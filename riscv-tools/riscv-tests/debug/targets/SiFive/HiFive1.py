import targets

class HiFive1(targets.Target):
    xlen = 32
    ram = 0x80000000
    ram_size = 16 * 1024
    instruction_hardware_breakpoint_count = 2
    misa = 0x40001105
