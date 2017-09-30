import targets
import testlib

class spike32(targets.Target):
    xlen = 32
    ram = 0x10000000
    ram_size = 0x10000000
    instruction_hardware_breakpoint_count = 4
    reset_vector = 0x1000

    def create(self):
        return testlib.Spike(self)
