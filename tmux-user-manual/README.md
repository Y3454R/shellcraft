# tmux User Manual

A practical guide to tmux — the terminal multiplexer that keeps your sessions alive.

---

## What is tmux?

tmux (terminal multiplexer) lets you run multiple terminal sessions inside a single window. Its killer feature: sessions persist even when you disconnect — so you can detach, close your laptop, and reattach later to find everything exactly as you left it.

---

## Installation

| OS | Command |
|----|---------|
| macOS | `brew install tmux` |
| Ubuntu / Debian | `sudo apt install tmux` |
| Fedora / RHEL | `sudo dnf install tmux` |
| Arch Linux | `sudo pacman -S tmux` |
| Windows | Use WSL, then run the Ubuntu command |

Verify installation:
```bash
tmux -V
# e.g. tmux 3.3a
```

---

## Core Concepts

```
Session
 └── Window 1
 │    ├── Pane A
 │    └── Pane B
 └── Window 2
      └── Pane C
```

- **Session** — a collection of windows. Survives disconnection.
- **Window** — like a tab. Each session can have multiple windows.
- **Pane** — a split within a window. Each pane is an independent terminal.

---

## The Prefix Key

Almost every tmux shortcut starts with the **prefix key**:

```
Ctrl + b
```

Press `Ctrl+b`, release, then press the next key.
For example, `Ctrl+b d` means: press Ctrl+b, let go, then press d.

---

## Sessions

| Action | Command |
|--------|---------|
| Start new session | `tmux` |
| Start named session | `tmux new -s mysession` |
| List sessions | `tmux ls` |
| Attach to last session | `tmux attach` |
| Attach to named session | `tmux attach -t mysession` |
| Detach from session | `Ctrl+b d` |
| Kill a session | `tmux kill-session -t mysession` |

---

## Windows

| Action | Shortcut |
|--------|----------|
| New window | `Ctrl+b c` |
| Next window | `Ctrl+b n` |
| Previous window | `Ctrl+b p` |
| Switch to window by number | `Ctrl+b 0` through `Ctrl+b 9` |
| Rename window | `Ctrl+b ,` |
| List windows | `Ctrl+b w` |
| Close window | `Ctrl+b &` |

---

## Panes

| Action | Shortcut |
|--------|----------|
| Split horizontally (top/bottom) | `Ctrl+b "` |
| Split vertically (left/right) | `Ctrl+b %` |
| Move between panes | `Ctrl+b` + arrow key |
| Close current pane | `Ctrl+b x` |
| Zoom pane (toggle fullscreen) | `Ctrl+b z` |
| Show pane numbers | `Ctrl+b q` |
| Resize pane | `Ctrl+b` + hold arrow key |

---

## Copy Mode (Scrolling)

By default, you can't scroll with your mouse. Enter copy mode to scroll and select text.

| Action | Shortcut |
|--------|----------|
| Enter copy mode | `Ctrl+b [` |
| Scroll up | Arrow keys or `PgUp` |
| Search | `/` (then type search term) |
| Exit copy mode | `q` or `Escape` |

---

## Common Workflows

### Keep a long-running process alive on a server

```bash
ssh user@server
tmux new -s work
# start your process
# close SSH — the process keeps running

# later, reconnect:
ssh user@server
tmux attach -t work
```

### Side-by-side terminal and logs

```bash
tmux new -s dev
# split into two panes
# Ctrl+b %
# run your app in the left pane, tail logs in the right pane
```

### Multiple projects

```bash
tmux new -s project-a
# do work, then detach with Ctrl+b d

tmux new -s project-b
# do work, then detach

tmux ls              # see both sessions
tmux attach -t project-a   # switch back
```

---

## Quick Reference Card

```
Session management
  tmux new -s name     New named session
  tmux ls              List sessions
  tmux attach -t name  Attach to session
  Ctrl+b d             Detach

Windows
  Ctrl+b c             New window
  Ctrl+b n / p         Next / previous window
  Ctrl+b ,             Rename window

Panes
  Ctrl+b "             Split top/bottom
  Ctrl+b %             Split left/right
  Ctrl+b arrow         Move between panes
  Ctrl+b z             Zoom / unzoom pane
  Ctrl+b x             Kill pane

Other
  Ctrl+b [             Enter scroll/copy mode
  Ctrl+b ?             Show all shortcuts
```

---

## Tips

- Use `Ctrl+b ?` anytime to see a full list of shortcuts inside tmux.
- Name your sessions and windows — it makes switching between them much easier.
- You can run `tmux` inside an existing tmux session, but it's rarely needed and can get confusing.
- Consider a config file at `~/.tmux.conf` to remap the prefix key or customize colors.

---

*tmux version this manual was written for: 3.x*
