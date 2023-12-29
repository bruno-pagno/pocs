import argparse
import psutil
import platform

def show_memory_information():
    virtual_memory = psutil.virtual_memory()
    total_memory = round(virtual_memory.total / (1024 * 1024 * 1000), 2)
    available_memory = round(virtual_memory.available / (1024 * 1024 * 1000), 2)
    used_memory = round(virtual_memory.used / (1024 * 1024 * 1000), 2)
    memory_percent = virtual_memory.percent
    print('-- MEMORY --')
    print("Total Memory:", total_memory, "GB")
    print("Available Memory:", available_memory, "GB")
    print("Used Memory:", used_memory, "GB")
    print("Memory Usage Percentage:", str(memory_percent) + "%")

def show_os_information():
    print('-- OPERATING SYSTEM --')
    print('Operating System Type:', platform.system())
    print('Release:', platform.release())
    print('Version:', platform.version())

def show_cpu_information():
    print('-- CPU --')
    physical_cores = psutil.cpu_count(logical=False)
    total_cores = psutil.cpu_count(logical=True)
    print('Number of physical cores:', physical_cores)
    print('Total cores:', total_cores)

def show_available_targets():
    print('Invalid target. Available Targets:')
    print('\tmem - show memory information')
    print('\tos - show operating system information')
    print('\tcpu - show CPU information')

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('target', help='target to show information about (memory, cpu, os or all)')
    args = parser.parse_args()
    target = args.target

    if target == 'all':
        show_memory_information()
        print('')
        show_os_information()
        print('')
        show_cpu_information()
    elif target == 'mem' or target == 'memory':
        show_memory_information()
    elif target == 'os':
        show_os_information()
    elif target == 'cpu':
        show_cpu_information()
    else:
        show_available_targets()