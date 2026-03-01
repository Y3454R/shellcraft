# VPS Specs & Storage Checking Guide

A comprehensive guide to checking your VPS specifications, storage, and resource limits - especially useful for shared servers with user-specific quotas.

---

## Table of Contents
- [System-Wide Specs](#system-wide-specs)
- [User Account Limits](#user-account-limits)
- [Storage & Disk Usage](#storage--disk-usage)
- [Current Resource Usage](#current-resource-usage)
- [Docker Resource Usage](#docker-resource-usage)
- [Finding Large Files & Directories](#finding-large-files--directories)
- [All-in-One Check Scripts](#all-in-one-check-scripts)

---

## System-Wide Specs

### CPU Information

```bash
# Number of CPU cores
nproc
```
**What it shows:** Total number of CPU cores available on the system.

```bash
# Detailed CPU information
lscpu
```
**What it shows:** Complete CPU architecture details including model, speed, cache, and virtualization info.

```bash
# CPU model name
cat /proc/cpuinfo | grep "model name" | head -1
```
**What it shows:** The brand and model of your CPU (e.g., "Intel Xeon E5-2680").

```bash
# Count total processors
cat /proc/cpuinfo | grep "processor" | wc -l
```
**What it shows:** Total number of logical processors (includes hyper-threading).

### Memory (RAM) Information

```bash
# Memory in human-readable format
free -h
```
**What it shows:** Total, used, free, shared, buff/cache, and available memory.
- **Total:** Total installed RAM
- **Used:** Currently in use
- **Available:** Actually available for new applications (more accurate than "free")

```bash
# Total memory from system info
cat /proc/meminfo | grep MemTotal
```
**What it shows:** Total RAM in kilobytes.

### Disk Space

```bash
# Disk usage for all mounted filesystems
df -h
```
**What it shows:** Size, used, available space, and mount points for all filesystems.
- **Size:** Total capacity
- **Used:** Currently occupied
- **Avail:** Free space remaining
- **Use%:** Percentage used

```bash
# Disk usage for root filesystem only
df -h /
```
**What it shows:** Just the root partition where most system files live.

```bash
# Disk usage for home directory
df -h ~
```
**What it shows:** The filesystem where your home directory is located.

---

## User Account Limits

These commands show YOUR specific resource limits on shared systems.

### Check All Your Limits

```bash
# Show all resource limits for your user
ulimit -a
```
**What it shows:**
- `-t`: Max CPU time per process
- `-f`: Max file size you can create
- `-d`: Max data segment size
- `-s`: Max stack size
- `-m`: Max resident set size (RAM)
- `-u`: Max number of processes
- `-n`: Max number of open file descriptors
- `-l`: Max locked memory
- `-v`: Max virtual memory

### Specific Limit Checks

```bash
# Maximum processes your user can run
ulimit -u
```
**Important for:** Running multiple Docker containers or build processes.

```bash
# Maximum open files
ulimit -n
```
**Important for:** Applications that open many files simultaneously (databases, web servers).

```bash
# Maximum memory (if set)
ulimit -m
```
**Important for:** Memory-intensive applications like Jenkins builds.

### Cgroups Limits (Modern Linux)

```bash
# Check which cgroup you're in
cat /proc/self/cgroup
```
**What it shows:** Your control group hierarchy (used for resource limiting).

```bash
# Check memory limit for your user
cat /sys/fs/cgroup/memory/user.slice/user-$(id -u).slice/memory.limit_in_bytes 2>/dev/null | numfmt --to=iec
```
**What it shows:** Hard memory limit for your user account (if set). Empty output means unlimited.

```bash
# Check CPU quota
cat /sys/fs/cgroup/cpu/user.slice/user-$(id -u).slice/cpu.cfs_quota_us 2>/dev/null
```
**What it shows:** CPU time quota. -1 means unlimited.

### Disk Quota

```bash
# Check your disk quota
quota -s
```
**What it shows:** Your disk usage limits and current usage.
- **blocks:** Disk space used
- **quota:** Soft limit
- **limit:** Hard limit
- **grace:** Time until soft limit becomes enforced

```bash
# Verbose quota information
quota -vs
```
**What it shows:** Detailed quota info for all filesystems.

---

## Storage & Disk Usage

### Your Home Directory

```bash
# Total size of your home directory
du -sh ~
```
**What it shows:** Total space used by your home directory.

```bash
# Size of each item in home directory
du -sh ~/* | sort -hr | head -10
```
**What it shows:** Top 10 largest directories/files in your home, sorted by size.
- `-s`: Summary only (don't recurse)
- `-h`: Human readable
- `sort -hr`: Sort human-readable sizes in reverse (largest first)

```bash
# Find directories larger than 1GB
du -h ~ | awk '$1 ~ /[0-9\.]+G/ {print $0}' | sort -hr
```
**What it shows:** All directories over 1GB in size.

### Current Directory

```bash
# Size of current directory
du -sh .
```
**What it shows:** Total size of current working directory.

```bash
# Size of each subdirectory
du -h --max-depth=1 | sort -hr
```
**What it shows:** Size of immediate subdirectories, sorted by size.

---

## Current Resource Usage

### What YOU Are Using Right Now

```bash
# Your current memory usage
ps -u $USER -o rss,comm | awk '{sum+=$1} END {print "Memory: " sum/1024 " MB"}'
```
**What it shows:** Total RAM used by all your processes in MB.

```bash
# Your current CPU usage
top -u $USER
```
**What it shows:** Real-time view of your processes with CPU and memory usage.
- Press `q` to quit
- Press `M` to sort by memory
- Press `P` to sort by CPU

```bash
# Number of processes you're running
ps -u $USER | wc -l
```
**What it shows:** Count of your active processes.

```bash
# List your top memory-consuming processes
ps -u $USER -o pid,rss,comm --sort=-rss | head -10
```
**What it shows:** Your top 10 processes by memory usage.

### System-Wide Usage

```bash
# System load and uptime
uptime
```
**What it shows:** How long system has been running and load averages (1, 5, 15 minutes).
- Load average < number of CPUs = good
- Load average > number of CPUs = system under stress

```bash
# Interactive process monitor
htop
```
**What it shows:** Colorful, interactive view of all system processes.
- Press `F6` to sort, `F9` to kill processes, `q` to quit
- Install with: `sudo apt install htop -y`

```bash
# Simple process monitor (built-in)
top
```
**What it shows:** Real-time process information (older version of htop).

---

## Docker Resource Usage

### Docker Storage

```bash
# Docker disk usage breakdown
docker system df
```
**What it shows:**
- **Images:** Space used by Docker images
- **Containers:** Space used by containers
- **Local Volumes:** Space used by volumes
- **Build Cache:** Space used by build cache

```bash
# Detailed Docker disk usage
docker system df -v
```
**What it shows:** Detailed breakdown of every image, container, and volume.

### Docker Container Stats

```bash
# Real-time stats for all containers
docker stats
```
**What it shows:** Live CPU, memory, network, and disk I/O for each container.

```bash
# Stats for specific container
docker stats jenkins --no-stream
```
**What it shows:** One-time snapshot of container resource usage.

```bash
# Stats in a loop
watch -n 5 docker stats --no-stream
```
**What it shows:** Updates every 5 seconds (useful for monitoring).

### List Docker Resources

```bash
# List all images
docker images
```
**What it shows:** All Docker images with their size.

```bash
# List all containers (running and stopped)
docker ps -a
```
**What it shows:** All containers with status and size.

```bash
# List all volumes
docker volume ls
```
**What it shows:** All Docker volumes (persistent data storage).

---

## Finding Large Files & Directories

### Find Large Directories

```bash
# Find directories over 1GB
find ~ -type d -exec du -sh {} + 2>/dev/null | awk '$1 ~ /[0-9\.]+G/' | sort -hr
```
**What it shows:** All directories in your home over 1GB.

```bash
# Top 20 largest directories
du -ah ~ 2>/dev/null | sort -rh | head -20
```
**What it shows:** 20 largest items (files and directories) in your home.

### Find Specific Large Items

```bash
# Find node_modules directories
find ~ -name "node_modules" -type d -prune -exec du -sh {} + 2>/dev/null | sort -hr
```
**What it shows:** All `node_modules` folders and their sizes.
**Why useful:** node_modules can be huge and safely deleted (reinstall with `npm install`).

```bash
# Find build artifacts
find ~ -name "dist" -o -name "build" -o -name ".next" -type d -prune -exec du -sh {} + 2>/dev/null | sort -hr
```
**What it shows:** Build output directories that can usually be regenerated.

```bash
# Find Python virtual environments
find ~ -name "venv" -o -name ".venv" -o -name "env" -type d -prune -exec du -sh {} + 2>/dev/null | sort -hr
```
**What it shows:** Python virtual environments (can be recreated).

```bash
# Find large files over 100MB
find ~ -type f -size +100M -exec ls -lh {} \; 2>/dev/null | awk '{print $9 ": " $5}'
```
**What it shows:** Individual files larger than 100MB.

### Clean Up Common Space Wasters

```bash
# Remove all node_modules (can reinstall)
find ~ -name "node_modules" -type d -prune -exec rm -rf {} + 2>/dev/null
```

```bash
# Remove build artifacts
find ~ -name "dist" -o -name "build" -o -name ".next" -type d -prune -exec rm -rf {} + 2>/dev/null
```

```bash
# Clean npm cache
npm cache clean --force
```

```bash
# Clean pip cache
pip cache purge
```

```bash
# Clean Docker (CAREFUL: removes unused images/containers)
docker system prune -a --volumes
```

---

## All-in-One Check Scripts

### Full System Check Script

```bash
cat << 'EOF' > check-system.sh
#!/bin/bash
echo "======================================"
echo "    VPS SYSTEM SPECIFICATIONS"
echo "======================================"
echo ""
echo "=== CPU ==="
echo "Cores: $(nproc)"
echo "Model: $(cat /proc/cpuinfo | grep "model name" | head -1 | cut -d':' -f2 | xargs)"
echo ""
echo "=== MEMORY ==="
free -h
echo ""
echo "=== DISK SPACE ==="
df -h /
echo ""
echo "=== SYSTEM LOAD ==="
uptime
echo ""
echo "=== DOCKER INFO ==="
if command -v docker &> /dev/null; then
    docker system df
else
    echo "Docker not installed"
fi
EOF

chmod +x check-system.sh
./check-system.sh
```

### User Account Limits Check Script

```bash
cat << 'EOF' > check-my-limits.sh
#!/bin/bash
echo "======================================"
echo "    YOUR ACCOUNT LIMITS"
echo "======================================"
echo ""
echo "Username: $USER"
echo "UID: $(id -u)"
echo ""
echo "=== PROCESS LIMITS ==="
echo "Max processes: $(ulimit -u)"
echo "Current processes: $(ps -u $USER | wc -l)"
echo "Max open files: $(ulimit -n)"
echo ""
echo "=== MEMORY INFO ==="
MY_MEM=$(ps -u $USER -o rss= | awk '{sum+=$1} END {print sum/1024}')
echo "Current memory usage: ${MY_MEM} MB"
echo ""
echo "=== DISK INFO ==="
echo "Home directory size:"
du -sh ~ 2>/dev/null
echo ""
echo "Disk quota:"
quota -s 2>/dev/null || echo "No quota set or command not available"
echo ""
echo "Available space on home filesystem:"
df -h ~ | tail -1
echo ""
echo "=== CGROUP INFO ==="
echo "Your cgroup: $(cat /proc/self/cgroup | head -1)"
echo ""
echo "=== ALL LIMITS (ulimit -a) ==="
ulimit -a
EOF

chmod +x check-my-limits.sh
./check-my-limits.sh
```

### Storage Analysis Script

```bash
cat << 'EOF' > analyze-storage.sh
#!/bin/bash
echo "======================================"
echo "    STORAGE ANALYSIS"
echo "======================================"
echo ""
echo "=== OVERALL DISK USAGE ==="
df -h /
echo ""
echo "=== YOUR HOME DIRECTORY ==="
echo "Total size:"
du -sh ~ 2>/dev/null
echo ""
echo "=== TOP 10 LARGEST DIRECTORIES ==="
du -sh ~/* 2>/dev/null | sort -hr | head -10
echo ""
echo "=== POTENTIAL SPACE SAVERS ==="
echo ""
echo "node_modules directories:"
find ~ -name "node_modules" -type d -prune 2>/dev/null | wc -l
echo ""
echo "Build artifacts (dist/build/.next):"
find ~ \( -name "dist" -o -name "build" -o -name ".next" \) -type d 2>/dev/null | wc -l
echo ""
echo "Python virtual environments:"
find ~ \( -name "venv" -o -name ".venv" -o -name "env" \) -type d 2>/dev/null | wc -l
echo ""
if command -v docker &> /dev/null; then
    echo "=== DOCKER USAGE ==="
    docker system df
fi
EOF

chmod +x analyze-storage.sh
./analyze-storage.sh
```

### Monitoring Script (Continuous)

```bash
cat << 'EOF' > monitor-resources.sh
#!/bin/bash
# Monitor system resources every 10 seconds
# Press Ctrl+C to stop

while true; do
    clear
    echo "======================================"
    echo "    RESOURCE MONITOR"
    echo "    $(date)"
    echo "======================================"
    echo ""
    echo "=== DISK SPACE ==="
    df -h / | grep -E "Filesystem|/"
    echo ""
    echo "=== MEMORY ==="
    free -h | grep -E "total|Mem:"
    echo ""
    echo "=== YOUR PROCESSES ==="
    echo "Count: $(ps -u $USER | wc -l)"
    MY_MEM=$(ps -u $USER -o rss= | awk '{sum+=$1} END {print sum/1024}')
    echo "Memory: ${MY_MEM} MB"
    echo ""
    if command -v docker &> /dev/null && docker ps -q | grep -q .; then
        echo "=== DOCKER CONTAINERS ==="
        docker stats --no-stream
    fi
    echo ""
    echo "Press Ctrl+C to stop monitoring..."
    sleep 10
done
EOF

chmod +x monitor-resources.sh
./monitor-resources.sh
```

---

## Quick Reference Commands

### Before Starting Jenkins

```bash
# Check available space
df -h /

# Check your current usage
du -sh ~

# Check Docker space
docker system df

# Check your process limits
ulimit -u
```

### After Starting Jenkins

```bash
# Monitor Jenkins container
docker stats jenkins

# Check space regularly
watch -n 30 'df -h / && echo "---" && docker system df'

# Check Jenkins logs if issues
docker logs jenkins --tail 100
```

### If Running Out of Space

```bash
# 1. Check what's using space
du -sh ~/* | sort -hr | head -10

# 2. Clean Docker
docker system prune -a --volumes

# 3. Remove node_modules
find ~ -name "node_modules" -type d -prune -exec rm -rf {} + 2>/dev/null

# 4. Remove build artifacts
find ~ -name "dist" -o -name "build" -type d -prune -exec rm -rf {} + 2>/dev/null
```

---

## Interpreting the Results

### CPU
- **1-2 cores:** Light Jenkins use only (1 build at a time)
- **2-4 cores:** Moderate use (2-3 concurrent builds)
- **4+ cores:** Heavy use (multiple concurrent builds)

### Memory
- **2GB minimum:** Basic Jenkins operation
- **4GB recommended:** Comfortable for most use cases
- **8GB+ ideal:** Multiple concurrent builds with Docker

### Disk Space
- **5GB minimum free:** Basic Jenkins installation
- **10GB recommended:** Comfortable for builds and artifacts
- **20GB+ ideal:** Multiple projects with Docker images

### Processes Limit
- **100+:** Should be sufficient for Jenkins
- **1000+:** More than enough for any reasonable workload

### File Descriptors
- **1024:** Usually sufficient for Jenkins
- **4096+:** Better for heavy use
- Can increase with: `ulimit -n 4096`

---

## Common Issues and Solutions

### "Cannot allocate memory"
**Check:** `free -h` and `ulimit -m`
**Solution:** Stop unnecessary processes or request more RAM

### "Too many open files"
**Check:** `ulimit -n`
**Solution:** Increase file descriptor limit: `ulimit -n 4096`

### "Disk quota exceeded"
**Check:** `quota -s` and `df -h ~`
**Solution:** Clean up space or request higher quota

### "Resource temporarily unavailable"
**Check:** `ulimit -u` and process count
**Solution:** Stop unnecessary processes

---

## Notes

- Commands with `2>/dev/null` suppress permission errors
- Commands with `sudo` require root/admin access
- Monitoring commands (top, htop, watch) run continuously - press `q` or Ctrl+C to exit
- Always check with your system administrator before making major changes on shared systems
- Storage limits and quotas vary by hosting provider and account type

---

## Created for Jenkins Setup

This guide was created to help assess VPS resources before installing Jenkins.
For Jenkins to run smoothly, ensure you have:
- ✅ At least 2GB RAM available
- ✅ At least 10GB disk space free
- ✅ Sufficient process limits (100+ recommended)
- ✅ Docker installed and accessible
