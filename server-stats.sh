#!/bin/bash

# Total memory usage (Free vs Used including percentage)
mem_info() {
  local total available used
  total=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
  available=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
  used=$((total-available))
  
  local used_percentage available_percentage
  used_percentage=$(awk -v u="$used" -v t="$total" 'BEGIN {printf "%.1f", u/t*100}')
  available_percentage=$(awk -v a="$available" -v t="$total" 'BEGIN {printf "%.1f", a/t*100}')
  
  echo "----------------------------------------"
  echo "          MEMORY USAGE"
  echo "----------------------------------------"
  printf "  Total     : %-10s\n" "$total kB"
  printf "  Used      : %-10s  (%s%%)\n" "$used kB" "$used_percentage"
  printf "  Free/Avail: %-10s  (%s%%)\n" "$available kB" "$available_percentage"
  echo "----------------------------------------"
  echo

}


#Total disk usage (Free vs Used including percentage)
disk_info() {
  local total used available used_percentage
  
  local disk_space_total_line=$(df -h --total | tail -1)
  total=$(echo "$disk_space_total_line" | awk '{print $2}')
  used=$(echo "$disk_space_total_line" | awk '{print $3}')
  available=$(echo "$disk_space_total_line" | awk '{print $4}')
  used_percentage=$(echo "$disk_space_total_line" | awk '{print $5}')
  
  echo "----------------------------------------"
  echo "          DISK USAGE (all filesystems)"
  echo "----------------------------------------"
  printf "  Total     : %-10s\n" "$total"
  printf "  Used      : %-10s  (%s)\n" "$used" "$used_percentage"
  printf "  Free      : %-10s\n" "$available"
  echo "----------------------------------------"
  echo
}


#Total CPU usage
cpu_info() {
echo "----------------------------------------"
echo "          CPU USAGE                     "
echo "----------------------------------------"
local sleep_duration=0.5

local previousDate=$(date +%s%N | cut -b1-13)
local previousStats=$(cat /proc/stat)

sleep $sleep_duration

local currentDate=$(date +%s%N | cut -b1-13)
local currentStats=$(cat /proc/stat)    

local cpus=$(echo "$currentStats" | grep -P 'cpu' | awk -F " " '{print $1}')

for cpu in $cpus
do
    local currentLine=$(echo "$currentStats" | grep "$cpu ")
    local user=$(echo "$currentLine" | awk -F " " '{print $2}')
    local nice=$(echo "$currentLine" | awk -F " " '{print $3}')
    local system=$(echo "$currentLine" | awk -F " " '{print $4}')
    local idle=$(echo "$currentLine" | awk -F " " '{print $5}')
    local iowait=$(echo "$currentLine" | awk -F " " '{print $6}')
    local irq=$(echo "$currentLine" | awk -F " " '{print $7}')
    local softirq=$(echo "$currentLine" | awk -F " " '{print $8}')
    local steal=$(echo "$currentLine" | awk -F " " '{print $9}')
    local guest=$(echo "$currentLine" | awk -F " " '{print $10}')
    local guest_nice=$(echo "$currentLine" | awk -F " " '{print $11}')

    local previousLine=$(echo "$previousStats" | grep "$cpu ")
    local prevuser=$(echo "$previousLine" | awk -F " " '{print $2}')
    local prevnice=$(echo "$previousLine" | awk -F " " '{print $3}')
    local prevsystem=$(echo "$previousLine" | awk -F " " '{print $4}')
    local previdle=$(echo "$previousLine" | awk -F " " '{print $5}')
    local previowait=$(echo "$previousLine" | awk -F " " '{print $6}')
    local previrq=$(echo "$previousLine" | awk -F " " '{print $7}')
    local prevsoftirq=$(echo "$previousLine" | awk -F " " '{print $8}')
    local prevsteal=$(echo "$previousLine" | awk -F " " '{print $9}')
    local prevguest=$(echo "$previousLine" | awk -F " " '{print $10}')
    local prevguest_nice=$(echo "$previousLine" | awk -F " " '{print $11}')    

    local PrevIdle=$((previdle + previowait))
    local Idle=$((idle + iowait))

    local PrevNonIdle=$((prevuser + prevnice + prevsystem + previrq + prevsoftirq + prevsteal))
    local NonIdle=$((user + nice + system + irq + softirq + steal))

    local PrevTotal=$((PrevIdle + PrevNonIdle))
    local Total=$((Idle + NonIdle))

    local totald=$((Total - PrevTotal))
    local idled=$((Idle - PrevIdle))

    local CPU_Percentage=$(awk "BEGIN {print ($totald - $idled)/$totald*100}")

    if [[ "$cpu" == "cpu" ]]; then
        echo "total "$CPU_Percentage
    else
        echo $cpu" "$CPU_Percentage
    fi
done
echo "----------------------------------------"
}



#Top 5 processes by memory usage
top_mem() {
    echo "----------------------------------------"
    echo "     TOP 5 PROCESSES BY MEMORY USAGE"
    echo "----------------------------------------"
    printf "%-8s %-5s %-s\n" "PID" "MEM%" "COMMAND"
    ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "%-8s %-5s %-s\n", $2, $4, $11}'
    echo "----------------------------------------"
    echo
}



#Top 5 processes by CPU usage
top_cpu() {
    echo "----------------------------------------"
    echo "     TOP 5 PROCESSES BY CPU USAGE"
    echo "----------------------------------------"
    printf "%-8s %-5s %-s\n" "PID" "CPU%" "COMMAND"
    ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "%-8s %-5s %-s\n", $2, $3, $11}'
    echo "----------------------------------------"
    echo
}



main() {
    echo "====================  SERVER STATS  ===================="
    mem_info
    disk_info
    cpu_info
    top_cpu
    top_mem
    echo "========================================================="
}

main
