# Server-Performance-Stats

A simple script to display core server metrics.

## Prerequisites

- Any modern Linux distribution
- Bash (>= 4.0)
- Standard utilities: `awk`, `ps`, `df`, `grep` (usually pre-installed)
- Read access to `/proc/stat`, `/proc/meminfo

Superuser privileges are **not required**.

## Installation and Usage

Download the script using any convenient method.

### Option 1: using curl

```bash
curl -O https://raw.githubusercontent.com/YoungZerg/Server-Performance-Stats/main/server-stats.sh
chmod +x server-stats.sh
./server-stats.sh
```

### Option 2: using wget

```bash
wget https://raw.githubusercontent.com/YoungZerg/Server-Performance-Stats/main/server-stats.sh
chmod +x server-stats.sh
./server-stats.sh
```

### Option 3: clone the repository

```bash
git clone https://github.com/YoungZerg/Server-Performance-Stats.git
cd Server-Performance-Stats
chmod +x server-stats.sh
./server-stats.sh
```
