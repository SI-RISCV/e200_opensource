#!/usr/bin/env python

"""Test that OpenOCD can talk to a RISC-V target."""

import argparse
import sys

import targets
import testlib
from testlib import assertIn, assertEqual

class OpenOcdTest(testlib.BaseTest):
    def __init__(self, target):
        testlib.BaseTest.__init__(self, target)
        self.gdb = None

    def early_applicable(self):
        return self.target.openocd_config

    def setup(self):
        # pylint: disable=attribute-defined-outside-init
        self.cli = testlib.OpenocdCli()
        self.cli.command("halt")

    def write_nops(self, count):
        for address in range(self.target.ram, self.target.ram + 4 * count, 4):
            # 0x13 is nop
            self.cli.command("mww 0x%x 0x13" % address)

class RegTest(OpenOcdTest):
    def test(self):
        self.write_nops(4)

        regs = self.cli.reg()
        assertIn("x18", regs)

        self.cli.command("reg x18 0x11782")
        self.cli.command("step 0x%x" % self.target.ram)

        assertEqual(self.cli.reg("x18"), 0x11782)

class StepTest(OpenOcdTest):
    def test(self):
        self.write_nops(4)

        self.cli.command("step 0x%x" % self.target.ram)
        for i in range(4):
            pc = self.cli.reg("pc")
            assertEqual(pc, self.target.ram + 4 * (i+1))
            self.cli.command("step")

class ResumeTest(OpenOcdTest):
    def test(self):
        self.write_nops(16)

        self.cli.command("bp 0x%x 4" % (self.target.ram + 12))
        self.cli.command("bp 0x%x 4" % (self.target.ram + 24))

        self.cli.command("resume 0x%x" % self.target.ram)
        assertEqual(self.cli.reg("pc"), self.target.ram + 12)

        self.cli.command("resume")
        assertEqual(self.cli.reg("pc"), self.target.ram + 24)

        self.cli.command("resume 0x%x" % self.target.ram)
        assertEqual(self.cli.reg("pc"), self.target.ram + 12)

def main():
    parser = argparse.ArgumentParser(
            description="Test that OpenOCD can talk to a RISC-V target.")
    targets.add_target_options(parser)
    testlib.add_test_run_options(parser)

    parsed = parser.parse_args()

    target = parsed.target(parsed.server_cmd, parsed.sim_cmd, parsed.isolate)
    if parsed.xlen:
        target.xlen = parsed.xlen

    module = sys.modules[__name__]

    return testlib.run_all_tests(module, target, parsed)

if __name__ == '__main__':
    sys.exit(main())
