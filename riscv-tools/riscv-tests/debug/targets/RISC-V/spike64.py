import targets
import testlib

class spike64(targets.Target):
    xlen = 64
    ram = 0x1212340000
    ram_size = 0x10000000
    instruction_hardware_breakpoint_count = 4
    reset_vector = 0x1000

    def create(self):
        return testlib.Spike(self)
