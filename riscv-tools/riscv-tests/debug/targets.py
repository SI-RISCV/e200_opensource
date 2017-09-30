import importlib
import os.path
import sys
import tempfile

import testlib

class Target(object):
    # pylint: disable=too-many-instance-attributes

    # Name of the target. Defaults to the name of the class.
    name = None

    # XLEN of the target. May be overridden with --32 or --64 command line
    # options.
    xlen = 0

    # GDB remotetimeout setting.
    timeout_sec = 2

    # Path to OpenOCD configuration file relative to the .py file where the
    # target is defined. Defaults to <name>.cfg.
    openocd_config_path = None

    # Path to linker script relative to the .py file where the target is
    # defined. Defaults to <name>.lds.
    link_script_path = None

    # Will be autodetected (by running ExamineTarget) if left unset. Set to
    # save a little time.
    misa = None

    # List of commands that should be executed in gdb after connecting but
    # before starting the test.
    gdb_setup = []

    # Implements dmode in tdata1 as described in the spec. Targets that need
    # this value set to False are not compliant with the spec (but still usable
    # as long as running code doesn't try to mess with triggers set by an
    # external debugger).
    honors_tdata1_hmode = True

    # Internal variables:
    directory = None
    temporary_files = []
    temporary_binary = None

    def __init__(self, path, parsed):
        # Path to module.
        self.path = path
        self.directory = os.path.dirname(path)
        self.server_cmd = parsed.server_cmd
        self.sim_cmd = parsed.sim_cmd
        self.isolate = parsed.isolate
        if not self.name:
            self.name = type(self).__name__
        # Default OpenOCD config file to <name>.cfg
        if not self.openocd_config_path:
            self.openocd_config_path = "%s.cfg" % self.name
        self.openocd_config_path = os.path.join(self.directory,
                self.openocd_config_path)
        # Default link script to <name>.lds
        if not self.link_script_path:
            self.link_script_path = "%s.lds" % self.name
        self.link_script_path = os.path.join(self.directory,
                self.link_script_path)

    def create(self):
        """Create the target out of thin air, eg. start a simulator."""
        pass

    def server(self):
        """Start the debug server that gdb connects to, eg. OpenOCD."""
        return testlib.Openocd(server_cmd=self.server_cmd,
                config=self.openocd_config_path)

    def compile(self, *sources):
        binary_name = "%s_%s-%d" % (
                self.name,
                os.path.basename(os.path.splitext(sources[0])[0]),
                self.xlen)
        if self.isolate:
            self.temporary_binary = tempfile.NamedTemporaryFile(
                    prefix=binary_name + "_")
            binary_name = self.temporary_binary.name
            Target.temporary_files.append(self.temporary_binary)
        march = "rv%dima" % self.xlen
        for letter in "fdc":
            if self.extensionSupported(letter):
                march += letter
        testlib.compile(sources +
                ("programs/entry.S", "programs/init.c",
                    "-I", "../env",
                    "-march=%s" % march,
                    "-T", self.link_script_path,
                    "-nostartfiles",
                    "-mcmodel=medany",
                    "-DXLEN=%d" % self.xlen,
                    "-o", binary_name),
                xlen=self.xlen)
        return binary_name

    def extensionSupported(self, letter):
        # target.misa is set by testlib.ExamineTarget
        if self.misa:
            return self.misa & (1 << (ord(letter.upper()) - ord('A')))
        else:
            return False

def add_target_options(parser):
    parser.add_argument("target", help=".py file that contains definition for "
            "the target to test with.")
    parser.add_argument("--sim_cmd",
            help="The command to use to start the actual target (e.g. "
            "simulation)", default="spike")
    parser.add_argument("--server_cmd",
            help="The command to use to start the debug server (e.g. OpenOCD)")

    xlen_group = parser.add_mutually_exclusive_group()
    xlen_group.add_argument("--32", action="store_const", const=32, dest="xlen",
            help="Force the target to be 32-bit.")
    xlen_group.add_argument("--64", action="store_const", const=64, dest="xlen",
            help="Force the target to be 64-bit.")

    parser.add_argument("--isolate", action="store_true",
            help="Try to run in such a way that multiple instances can run at "
            "the same time. This may make it harder to debug a failure if it "
            "does occur.")

def target(parsed):
    directory = os.path.dirname(parsed.target)
    filename = os.path.basename(parsed.target)
    module_name = os.path.splitext(filename)[0]

    sys.path.append(directory)
    module = importlib.import_module(module_name)
    found = []
    for name in dir(module):
        definition = getattr(module, name)
        if type(definition) == type and issubclass(definition, Target):
            found.append(definition)
    assert len(found) == 1, "%s does not define exactly one subclass of " \
            "targets.Target" % parsed.target

    return found[0](parsed.target, parsed)
