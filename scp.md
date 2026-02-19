# SCP Quick Manual

`scp` (Secure Copy Protocol) lets you transfer files between local and remote machines over SSH.

---

## Basic Syntax

```
scp [options] source destination
```

The golden rule: **source comes first, destination comes second.**

---

## Common Use Cases

### Upload (local → remote)
```bash
scp file.zip user@host:/remote/path/
```

### Download (remote → local)
```bash
scp user@host:/remote/path/file.zip ./local-destination/
```

### Copy a directory
```bash
scp -r my-folder/ user@host:/remote/path/
```

### Custom port
```bash
scp -P 11111 file.zip user@host:/remote/path/
```

### Combine flags
```bash
scp -r -P 11111 my-folder/ user@host:/remote/path/
```

---

## Common Options

| Option | Description |
|--------|-------------|
| `-P`   | Specify port (note: uppercase P) |
| `-r`   | Recursively copy directories |
| `-i`   | Use a specific identity/key file |
| `-v`   | Verbose mode (useful for debugging) |
| `-C`   | Enable compression |

---

## Tips

- Always end a **remote directory** destination with `/` to avoid ambiguity.
- `-P` must come **before** the source and destination arguments.
- If copying a directory and you get `not a regular file`, you're missing `-r`.
- SCP uses your SSH config, so aliases in `~/.ssh/config` work here too.

---

## Quick Reference

```
# Upload
scp -P <port> <local-file> <user>@<host>:<remote-path>

# Download
scp -P <port> <user>@<host>:<remote-file> <local-path>

# Upload directory
scp -r -P <port> <local-dir> <user>@<host>:<remote-path>
```
