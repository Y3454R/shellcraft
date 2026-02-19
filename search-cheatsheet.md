# Linux Search Tools Cheatsheet

A quick reference for searching files and content in Linux.

---

## `grep` — Search File Contents

Search for patterns inside files.

### Basic Usage

```bash
grep "pattern" file.txt          # Find lines containing "pattern"
grep -i "pattern" file.txt       # Case-insensitive
grep -r "pattern" ./folder       # Recursive (search all files in folder)
grep -n "pattern" file.txt       # Show line numbers
grep -v "pattern" file.txt       # Invert — show lines that DON'T match
grep -l "pattern" *.txt          # List only filenames with matches
grep -c "pattern" file.txt       # Count matching lines
grep -w "pattern" file.txt       # Match whole words only
```

### Context Around Matches

```bash
grep -A 3 "pattern" file.txt     # 3 lines After match
grep -B 3 "pattern" file.txt     # 3 lines Before match
grep -C 3 "pattern" file.txt     # 3 lines Before AND After
```

### Regex Patterns

```bash
grep "^hello" file.txt           # Lines starting with "hello"
grep "hello$" file.txt           # Lines ending with "hello"
grep "h.llo" file.txt            # . matches any single character
grep -E "cat|dog" file.txt       # Match "cat" or "dog" (extended regex)
```

### Piping

```bash
cat file.txt | grep "pattern"
ps aux | grep "python"
history | grep "git"
```

---

## `find` — Search for Files by Name/Properties

### Basic Usage

```bash
find . -name "file.txt"          # Find by exact name
find . -name "*.log"             # Wildcard search
find . -iname "*.LOG"            # Case-insensitive name
find /home -name "*.py"          # Search in specific directory
```

### Filter by Type

```bash
find . -type f -name "*.txt"     # Files only (not directories)
find . -type d -name "logs"      # Directories only
```

### Filter by Size and Time

```bash
find . -size +10M                # Files larger than 10MB
find . -size -1k                 # Files smaller than 1KB
find . -mtime -7                 # Modified in the last 7 days
find . -mtime +30                # Modified more than 30 days ago
```

### Actions on Results

```bash
find . -name "*.log" -delete                      # Find and delete
find . -name "*.py" -exec grep -l "TODO" {} \;   # Run grep on each result
```

---

## `locate` — Fast Filename Search

Uses a pre-built database for near-instant results.

```bash
locate file.txt          # Search by name
locate -i file.txt       # Case-insensitive
sudo updatedb            # Refresh the database (if results seem outdated)
```

> **Tip:** `locate` is faster than `find` but may show stale results if the database is old. Use `find` when you need real-time accuracy.

---

## `which` / `whereis` — Find Executables

```bash
which python             # Shows the path of a command
whereis python           # Finds binary, source, and man pages
```

---

## Quick Reference

| Goal | Command |
|------|---------|
| Search text inside files | `grep -r "pattern" .` |
| Find a file by name | `find . -name "file.txt"` |
| Find files by extension | `find . -name "*.log"` |
| Fast file name search | `locate filename` |
| Find large files | `find . -size +10M` |
| Find recently modified files | `find . -mtime -7` |
| Find where a command lives | `which command` |
| Search command history | `history \| grep "command"` |
| Find TODOs in source code | `grep -rn "TODO" ./src` |
| Skip comment lines | `grep -v "^#" config.txt` |
