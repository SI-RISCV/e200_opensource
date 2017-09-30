import collections
import os.path
import random
import re
import shlex
import subprocess
import sys
import tempfile
import time
import traceback

import pexpect

# Note that gdb comes with its own testsuite. I was unable to figure out how to
# run that testsuite against the spike simulator.

def find_file(path):
    for directory in (os.getcwd(), os.path.dirname(__file__)):
        fullpath = os.path.join(directory, path)
        if os.path.exists(fullpath):
            return fullpath
    return None

def compile(args, xlen=32): # pylint: disable=redefined-builtin
    cc = os.path.expandvars("$RISCV/bin/riscv64-unknown-elf-gcc")
    cmd = [cc, "-g"]
    if xlen == 32:
        cmd.append("-march=rv32imac")
        cmd.append("-mabi=ilp32")
    else:
        cmd.append("-march=rv64imac")
        cmd.append("-mabi=lp64")
    for arg in args:
        found = find_file(arg)
        if found:
            cmd.append(found)
        else:
            cmd.append(arg)
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    if process.returncode:
        print
        header("Compile failed")
        print "+", " ".join(cmd)
        print stdout,
        print stderr,
        header("")
        raise Exception("Compile failed!")

def unused_port():
    # http://stackoverflow.com/questions/2838244/get-open-tcp-port-in-python/2838309#2838309
    import socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind(("", 0))
    port = s.getsockname()[1]
    s.close()
    return port

class Spike(object):
    logname = "spike-%d.log" % os.getpid()

    def __init__(self, target, halted=False, timeout=None, with_jtag_gdb=True):
        """Launch spike. Return tuple of its process and the port it's running
        on."""
        if target.sim_cmd:
            cmd = shlex.split(target.sim_cmd)
        else:
            spike = os.path.expandvars("$RISCV/bin/spike")
            cmd = [spike]
        if target.xlen == 32:
            cmd += ["--isa", "RV32G"]
        else:
            cmd += ["--isa", "RV64G"]
        cmd += ["-m0x%x:0x%x" % (target.ram, target.ram_size)]

        if timeout:
            cmd = ["timeout", str(timeout)] + cmd

        if halted:
            cmd.append('-H')
        if with_jtag_gdb:
            cmd += ['--rbb-port', '0']
            os.environ['REMOTE_BITBANG_HOST'] = 'localhost'
        self.infinite_loop = target.compile(
                "programs/checksum.c", "programs/tiny-malloc.c",
                "programs/infinite_loop.S", "-DDEFINE_MALLOC", "-DDEFINE_FREE")
        cmd.append(self.infinite_loop)
        logfile = open(self.logname, "w")
        logfile.write("+ %s\n" % " ".join(cmd))
        logfile.flush()
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE,
                stdout=logfile, stderr=logfile)

        if with_jtag_gdb:
            self.port = None
            for _ in range(30):
                m = re.search(r"Listening for remote bitbang connection on "
                        r"port (\d+).", open(self.logname).read())
                if m:
                    self.port = int(m.group(1))
                    os.environ['REMOTE_BITBANG_PORT'] = m.group(1)
                    break
                time.sleep(0.11)
            assert self.port, "Didn't get spike message about bitbang " \
                    "connection"

    def __del__(self):
        try:
            self.process.kill()
            self.process.wait()
        except OSError:
            pass

    def wait(self, *args, **kwargs):
        return self.process.wait(*args, **kwargs)

class VcsSim(object):
    def __init__(self, sim_cmd=None, debug=False):
        if sim_cmd:
            cmd = shlex.split(sim_cmd)
        else:
            cmd = ["simv"]
        cmd += ["+jtag_vpi_enable"]
        if debug:
            cmd[0] = cmd[0] + "-debug"
            cmd += ["+vcdplusfile=output/gdbserver.vpd"]
        logfile = open("simv.log", "w")
        logfile.write("+ %s\n" % " ".join(cmd))
        logfile.flush()
        listenfile = open("simv.log", "r")
        listenfile.seek(0, 2)
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE,
                stdout=logfile, stderr=logfile)
        done = False
        while not done:
            # Fail if VCS exits early
            exit_code = self.process.poll()
            if exit_code is not None:
                raise RuntimeError('VCS simulator exited early with status %d'
                                   % exit_code)

            line = listenfile.readline()
            if not line:
                time.sleep(1)
            match = re.match(r"^Listening on port (\d+)$", line)
            if match:
                done = True
                self.port = int(match.group(1))
                os.environ['JTAG_VPI_PORT'] = str(self.port)

    def __del__(self):
        try:
            self.process.kill()
            self.process.wait()
        except OSError:
            pass

class Openocd(object):
    logfile = tempfile.NamedTemporaryFile(prefix='openocd', suffix='.log')
    logname = logfile.name

    def __init__(self, server_cmd=None, config=None, debug=False):
        if server_cmd:
            cmd = shlex.split(server_cmd)
        else:
            openocd = os.path.expandvars("$RISCV/bin/openocd")
            cmd = [openocd]
            if debug:
                cmd.append("-d")

        # This command needs to come before any config scripts on the command
        # line, since they are executed in order.
        cmd += [
            # Tell OpenOCD to bind gdb to an unused, ephemeral port.
            "--command",
            "gdb_port 0",
            # Disable tcl and telnet servers, since they are unused and because
            # the port numbers will conflict if multiple OpenOCD processes are
            # running on the same server.
            "--command",
            "tcl_port disabled",
            "--command",
            "telnet_port disabled",
        ]

        if config:
            f = find_file(config)
            if f is None:
                print "Unable to read file " + config
                exit(1)

            cmd += ["-f", f]
        if debug:
            cmd.append("-d")

        logfile = open(Openocd.logname, "w")
        logfile.write("+ %s\n" % " ".join(cmd))
        logfile.flush()
        self.process = subprocess.Popen(cmd, stdin=subprocess.PIPE,
                stdout=logfile, stderr=logfile)

        # Wait for OpenOCD to have made it through riscv_examine(). When using
        # OpenOCD to communicate with a simulator this may take a long time,
        # and gdb will time out when trying to connect if we attempt too early.
        start = time.time()
        messaged = False
        while True:
            log = open(Openocd.logname).read()
            if "Ready for Remote Connections" in log:
                break
            if not self.process.poll() is None:
                header("OpenOCD log")
                sys.stdout.write(log)
                raise Exception(
                        "OpenOCD exited before completing riscv_examine()")
            if not messaged and time.time() - start > 1:
                messaged = True
                print "Waiting for OpenOCD to examine RISCV core..."
            if time.time() - start > 60:
                raise Exception("ERROR: Timed out waiting for OpenOCD to "
                        "examine RISCV core")

        try:
            self.port = self._get_gdb_server_port()
        except:
            header("OpenOCD log")
            sys.stdout.write(log)
            raise

    def _get_gdb_server_port(self):
        """Get port that OpenOCD's gdb server is listening on."""
        MAX_ATTEMPTS = 50
        PORT_REGEX = re.compile(r'(?P<port>\d+) \(LISTEN\)')
        for _ in range(MAX_ATTEMPTS):
            with open(os.devnull, 'w') as devnull:
                try:
                    output = subprocess.check_output([
                        'lsof',
                        '-a',  # Take the AND of the following selectors
                        '-p{}'.format(self.process.pid),  # Filter on PID
                        '-iTCP',  # Filter only TCP sockets
                    ], stderr=devnull)
                except subprocess.CalledProcessError:
                    output = ""
            matches = list(PORT_REGEX.finditer(output))
            matches = [m for m in matches
                    if m.group('port') not in ('6666', '4444')]
            if len(matches) > 1:
                print output
                raise Exception(
                    "OpenOCD listening on multiple ports. Cannot uniquely "
                    "identify gdb server port.")
            elif matches:
                [match] = matches
                return int(match.group('port'))
            time.sleep(1)
        raise Exception("Timed out waiting for gdb server to obtain port.")

    def __del__(self):
        try:
            self.process.kill()
            self.process.wait()
        except (OSError, AttributeError):
            pass

class OpenocdCli(object):
    def __init__(self, port=4444):
        self.child = pexpect.spawn(
                "sh -c 'telnet localhost %d | tee openocd-cli.log'" % port)
        self.child.expect("> ")

    def command(self, cmd):
        self.child.sendline(cmd)
        self.child.expect(cmd)
        self.child.expect("\n")
        self.child.expect("> ")
        return self.child.before.strip("\t\r\n \0")

    def reg(self, reg=''):
        output = self.command("reg %s" % reg)
        matches = re.findall(r"(\w+) \(/\d+\): (0x[0-9A-F]+)", output)
        values = {r: int(v, 0) for r, v in matches}
        if reg:
            return values[reg]
        return values

    def load_image(self, image):
        output = self.command("load_image %s" % image)
        if 'invalid ELF file, only 32bits files are supported' in output:
            raise TestNotApplicable(output)

class CannotAccess(Exception):
    def __init__(self, address):
        Exception.__init__(self)
        self.address = address

Thread = collections.namedtuple('Thread', ('id', 'target_id', 'name',
    'frame'))

class Gdb(object):
    logfile = tempfile.NamedTemporaryFile(prefix="gdb", suffix=".log")
    logname = logfile.name

    def __init__(self,
            cmd=os.path.expandvars("$RISCV/bin/riscv64-unknown-elf-gdb")):
        self.child = pexpect.spawn(cmd)
        self.child.logfile = open(self.logname, "w")
        self.child.logfile.write("+ %s\n" % cmd)
        self.wait()
        self.command("set confirm off")
        self.command("set width 0")
        self.command("set height 0")
        # Force consistency.
        self.command("set print entry-values no")

    def wait(self):
        """Wait for prompt."""
        self.child.expect(r"\(gdb\)")

    def command(self, command, timeout=6000):
        self.child.sendline(command)
        self.child.expect("\n", timeout=timeout)
        self.child.expect(r"\(gdb\)", timeout=timeout)
        return self.child.before.strip()

    def c(self, wait=True, timeout=-1, async=False):
        if async:
            async = "&"
        else:
            async = ""
        if wait:
            output = self.command("c%s" % async, timeout=timeout)
            assert "Continuing" in output
            return output
        else:
            self.child.sendline("c%s" % async)
            self.child.expect("Continuing")

    def interrupt(self):
        self.child.send("\003")
        self.child.expect(r"\(gdb\)", timeout=6000)
        return self.child.before.strip()

    def x(self, address, size='w'):
        output = self.command("x/%s %s" % (size, address))
        value = int(output.split(':')[1].strip(), 0)
        return value

    def p_raw(self, obj):
        output = self.command("p %s" % obj)
        m = re.search("Cannot access memory at address (0x[0-9a-f]+)", output)
        if m:
            raise CannotAccess(int(m.group(1), 0))
        return output.split('=')[-1].strip()

    def p(self, obj):
        output = self.command("p/x %s" % obj)
        m = re.search("Cannot access memory at address (0x[0-9a-f]+)", output)
        if m:
            raise CannotAccess(int(m.group(1), 0))
        value = int(output.split('=')[-1].strip(), 0)
        return value

    def p_string(self, obj):
        output = self.command("p %s" % obj)
        value = shlex.split(output.split('=')[-1].strip())[1]
        return value

    def stepi(self):
        output = self.command("stepi")
        return output

    def load(self):
        output = self.command("load", timeout=6000)
        assert "failed" not in  output
        assert "Transfer rate" in output

    def b(self, location):
        output = self.command("b %s" % location)
        assert "not defined" not in output
        assert "Breakpoint" in output
        return output

    def hbreak(self, location):
        output = self.command("hbreak %s" % location)
        assert "not defined" not in output
        assert "Hardware assisted breakpoint" in output
        return output

    def threads(self):
        output = self.command("info threads")
        threads = []
        for line in output.splitlines():
            m = re.match(
                    r"[\s\*]*(\d+)\s*Thread (\d+)\s*\(Name: ([^\)]+)\s*(.*)",
                    line)
            if m:
                threads.append(Thread(*m.groups()))
        if not threads:
            threads.append(Thread('1', '1', 'Default', '???'))
        return threads

    def thread(self, thread):
        return self.command("thread %s" % thread.id)

def run_all_tests(module, target, parsed):
    if not os.path.exists(parsed.logs):
        os.makedirs(parsed.logs)

    overall_start = time.time()

    global gdb_cmd  # pylint: disable=global-statement
    gdb_cmd = parsed.gdb

    todo = []
    if parsed.misaval:
        target.misa = int(parsed.misaval, 16)
        print "Using $misa from command line: 0x%x" % target.misa
    elif target.misa:
        print "Using $misa from target definition: 0x%x" % target.misa
    else:
        todo.append(("ExamineTarget", ExamineTarget))

    for name in dir(module):
        definition = getattr(module, name)
        if type(definition) == type and hasattr(definition, 'test') and \
                (not parsed.test or any(test in name for test in parsed.test)):
            todo.append((name, definition))

    results, count = run_tests(parsed, target, todo)

    header("ran %d tests in %.0fs" % (count, time.time() - overall_start),
            dash=':')

    return print_results(results)

good_results = set(('pass', 'not_applicable'))
def run_tests(parsed, target, todo):
    results = {}
    count = 0

    for name, definition in todo:
        instance = definition(target)
        log_name = os.path.join(parsed.logs, "%s-%s-%s.log" %
                (time.strftime("%Y%m%d-%H%M%S"), type(target).__name__, name))
        log_fd = open(log_name, 'w')
        print "Running", name, "...",
        sys.stdout.flush()
        log_fd.write("Test: %s\n" % name)
        log_fd.write("Target: %s\n" % type(target).__name__)
        start = time.time()
        real_stdout = sys.stdout
        sys.stdout = log_fd
        try:
            result = instance.run()
            log_fd.write("Result: %s\n" % result)
        finally:
            sys.stdout = real_stdout
            log_fd.write("Time elapsed: %.2fs\n" % (time.time() - start))
        print "%s in %.2fs" % (result, time.time() - start)
        sys.stdout.flush()
        results.setdefault(result, []).append(name)
        count += 1
        if result not in good_results and parsed.fail_fast:
            break

    return results, count

def print_results(results):
    result = 0
    for key, value in results.iteritems():
        print "%d tests returned %s" % (len(value), key)
        if key not in good_results:
            result = 1
            for test in value:
                print "   ", test

    return result

def add_test_run_options(parser):

    parser.add_argument("--logs", default="logs",
            help="Store logs in the specified directory.")
    parser.add_argument("--fail-fast", "-f", action="store_true",
            help="Exit as soon as any test fails.")
    parser.add_argument("test", nargs='*',
            help="Run only tests that are named here.")
    parser.add_argument("--gdb",
            help="The command to use to start gdb.")
    parser.add_argument("--misaval",
            help="Don't run ExamineTarget, just assume the misa value which is "
            "specified.")

def header(title, dash='-', length=78):
    if title:
        dashes = dash * (length - 4 - len(title))
        before = dashes[:len(dashes)/2]
        after = dashes[len(dashes)/2:]
        print "%s[ %s ]%s" % (before, title, after)
    else:
        print dash * length

def print_log(path):
    header(path)
    lines = open(path, "r").readlines()
    for l in lines:
        sys.stdout.write(l)
    print

class BaseTest(object):
    compiled = {}

    def __init__(self, target):
        self.target = target
        self.server = None
        self.target_process = None
        self.binary = None
        self.start = 0
        self.logs = []

    def early_applicable(self):
        """Return a false value if the test has determined it cannot run
        without ever needing to talk to the target or server."""
        # pylint: disable=no-self-use
        return True

    def setup(self):
        pass

    def compile(self):
        compile_args = getattr(self, 'compile_args', None)
        if compile_args:
            if compile_args not in BaseTest.compiled:
                # pylint: disable=star-args
                BaseTest.compiled[compile_args] = \
                        self.target.compile(*compile_args)
        self.binary = BaseTest.compiled.get(compile_args)

    def classSetup(self):
        self.compile()
        self.target_process = self.target.create()
        if self.target_process:
            self.logs.append(self.target_process.logname)
        try:
            self.server = self.target.server()
            self.logs.append(self.server.logname)
        except Exception:
            for log in self.logs:
                print_log(log)
            raise

    def classTeardown(self):
        del self.server
        del self.target_process

    def run(self):
        """
        If compile_args is set, compile a program and set self.binary.

        Call setup().

        Then call test() and return the result, displaying relevant information
        if an exception is raised.
        """

        sys.stdout.flush()

        if not self.early_applicable():
            return "not_applicable"

        self.start = time.time()

        try:
            self.classSetup()
            self.setup()
            result = self.test()    # pylint: disable=no-member
        except TestNotApplicable:
            result = "not_applicable"
        except Exception as e: # pylint: disable=broad-except
            if isinstance(e, TestFailed):
                result = "fail"
            else:
                result = "exception"
            if isinstance(e, TestFailed):
                header("Message")
                print e.message
            header("Traceback")
            traceback.print_exc(file=sys.stdout)
            return result

        finally:
            for log in self.logs:
                print_log(log)
            header("End of logs")
            self.classTeardown()

        if not result:
            result = 'pass'
        return result

gdb_cmd = None
class GdbTest(BaseTest):
    def __init__(self, target):
        BaseTest.__init__(self, target)
        self.gdb = None

    def classSetup(self):
        BaseTest.classSetup(self)

        if gdb_cmd:
            self.gdb = Gdb(gdb_cmd)
        else:
            self.gdb = Gdb()

        self.logs.append(self.gdb.logname)

        if self.binary:
            self.gdb.command("file %s" % self.binary)
        if self.target:
            self.gdb.command("set arch riscv:rv%d" % self.target.xlen)
            self.gdb.command("set remotetimeout %d" % self.target.timeout_sec)
        if self.server.port:
            self.gdb.command(
                    "target extended-remote localhost:%d" % self.server.port)
            # Select a random thread.
            # TODO: Allow a command line option to force a specific thread.
            thread = random.choice(self.gdb.threads())
            self.gdb.thread(thread)

        for cmd in self.target.gdb_setup:
            self.gdb.command(cmd)

        # FIXME: OpenOCD doesn't handle PRIV now
        #self.gdb.p("$priv=3")

    def classTeardown(self):
        del self.gdb
        BaseTest.classTeardown(self)

class ExamineTarget(GdbTest):
    def test(self):
        self.target.misa = self.gdb.p("$misa")

        txt = "RV"
        if (self.target.misa >> 30) == 1:
            txt += "32"
        elif (self.target.misa >> 62) == 2:
            txt += "64"
        elif (self.target.misa >> 126) == 3:
            txt += "128"
        else:
            raise TestFailed("Couldn't determine XLEN from $misa (0x%x)" %
                    self.target.misa)

        for i in range(26):
            if self.target.misa & (1<<i):
                txt += chr(i + ord('A'))
        print txt,

class TestFailed(Exception):
    def __init__(self, message):
        Exception.__init__(self)
        self.message = message

class TestNotApplicable(Exception):
    def __init__(self, message):
        Exception.__init__(self)
        self.message = message

def assertEqual(a, b):
    if a != b:
        raise TestFailed("%r != %r" % (a, b))

def assertNotEqual(a, b):
    if a == b:
        raise TestFailed("%r == %r" % (a, b))

def assertIn(a, b):
    if a not in b:
        raise TestFailed("%r not in %r" % (a, b))

def assertNotIn(a, b):
    if a in b:
        raise TestFailed("%r in %r" % (a, b))

def assertGreater(a, b):
    if not a > b:
        raise TestFailed("%r not greater than %r" % (a, b))

def assertLess(a, b):
    if not a < b:
        raise TestFailed("%r not less than %r" % (a, b))

def assertTrue(a):
    if not a:
        raise TestFailed("%r is not True" % a)

def assertRegexpMatches(text, regexp):
    if not re.search(regexp, text):
        raise TestFailed("can't find %r in %r" % (regexp, text))
