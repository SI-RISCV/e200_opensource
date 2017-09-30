import targets

class U500(targets.Target):
    xlen = 64
    ram = 0x80000000
    ram_size = 16 * 1024
    instruction_hardware_breakpoint_count = 2
    openocd_config_path = "Freedom.cfg"
    link_script_path = "Freedom.lds"
