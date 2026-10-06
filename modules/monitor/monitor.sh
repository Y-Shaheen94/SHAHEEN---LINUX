CYAN="\033[1;36m"; GREEN="\033[1;32m"; YELLOW="\033[1;33m"; MAGENTA="\033[1;35m"; NC="\033[0m"
#!/usr/bin/env bash

monitor_processes() {
    ps aux 2>/dev/null || ps
}

monitor_memory() {
    system_memory
}

monitor_storage() {
    system_storage
}

monitor_network() {
    network_ports
}

monitor_all() {
    system_info
    system_memory
    system_storage
    network_ports
}
