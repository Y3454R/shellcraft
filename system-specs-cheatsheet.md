# 🖥️ System Specs Cheatsheet

## CPU

```bash
nproc                   # number of cores
lscpu                   # full CPU details (model, cores, threads, cache)
cat /proc/cpuinfo       # raw CPU info per core
```

---

## RAM

```bash
free -h                 # total, used, free, available
vmstat -s               # detailed memory stats
cat /proc/meminfo       # raw memory info
```

---

## Disk / Storage

```bash
df -h                   # disk usage per partition
lsblk                   # disk layout (partitions, mount points)
fdisk -l                # full disk info (requires sudo)
du -sh /*               # size of top-level directories
```

---

## GPU

### NVIDIA
```bash
nvidia-smi                          # GPU usage, memory, temp, driver version
nvidia-smi -q                       # full detailed info
nvidia-smi --query-gpu=name,memory.total,memory.free,temperature.gpu \
  --format=csv                      # custom query
watch -n 1 nvidia-smi              # live monitor (refresh every 1s)
```

### AMD
```bash
rocm-smi                            # AMD GPU stats (requires ROCm)
lspci | grep -i vga                 # detect GPU via PCI
lspci | grep -i amd
```

### Generic (any GPU)
```bash
lspci | grep -i vga                 # detect GPU
lspci | grep -i 3d
lshw -C display                     # detailed GPU info (sudo)
glxinfo | grep "OpenGL renderer"    # GPU being used for rendering
```

---

## OS & Kernel

```bash
uname -a                # kernel version + arch
cat /etc/os-release     # distro name and version
hostnamectl             # OS, kernel, hostname summary
lsb_release -a          # distro details
```

---

## Network

```bash
ip a                    # IP addresses
ip link                 # network interfaces
curl ifconfig.me        # public IP
```

---

## All-in-One Tools

```bash
# neofetch — pretty summary (install first)
sudo apt install neofetch && neofetch

# htop — live CPU/RAM monitor
sudo apt install htop && htop

# glances — all-in-one live monitor
sudo apt install glances && glances

# inxi — detailed hardware report
sudo apt install inxi
inxi -Fxz               # full system info
inxi -G                 # GPU only
```

---

## Quick One-liner (paste & run)

```bash
echo "=== CPU ===" && lscpu | grep -E "Model name|CPU\(s\)|Thread" \
&& echo "=== RAM ===" && free -h \
&& echo "=== DISK ===" && df -h \
&& echo "=== GPU ===" && lspci | grep -i vga \
&& (nvidia-smi --query-gpu=name,memory.total --format=csv,noheader 2>/dev/null || echo "No NVIDIA GPU / nvidia-smi not installed")
```
