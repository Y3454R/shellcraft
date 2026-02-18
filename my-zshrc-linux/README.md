# Zsh + Oh My Zsh + Atuin Setup (Portable, SSH Server Safe)

This guide documents the full process of setting up:

* Zsh
* Oh My Zsh
* Autosuggestions
* Syntax Highlighting
* Atuin (smart history)

Designed for:

* Ubuntu 24.04+
* VPS / SSH servers
* Non-system-wide (portable) setup
* Zero impact on other users

---

## Overview

This setup:

* Installs Zsh as the default shell (for current user only)
* Installs Oh My Zsh in `~/.oh-my-zsh`
* Installs plugins in `~/.zsh/`
* Installs Atuin in `~/.atuin`
* Modifies only `~/.zshrc`
* Does NOT affect other Linux users

---

# 1. Install Zsh

```bash
sudo apt update
sudo apt install zsh -y
```

Verify installation:

```bash
zsh --version
```

---

# 2. Set Zsh as Default Shell (User Only)

```bash
chsh -s $(which zsh)
```

If you are on a server via SSH, logout and reconnect via SSH:

```bash
exit
```

After reconnecting, verify:

```bash
echo $SHELL
```

---

# 3. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

This creates:

* `~/.oh-my-zsh/`
* `~/.zshrc`

---

# 4. Install Plugins (Portable, No sudo)

Create directory:

```bash
mkdir -p ~/.zsh
cd ~/.zsh
```

Clone plugins:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting
```

---

# 5. Install Atuin

```bash
curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
```

Reconnect SSH after installation.

---

# 6. Final ~/.zshrc Configuration

Replace `~/.zshrc` with:

```zsh
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="clean"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Autosuggestions
if [ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Syntax Highlighting (must be last)
if [ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Atuin
if [ -f "$HOME/.atuin/bin/env" ]; then
  . "$HOME/.atuin/bin/env"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi
```

Reload:

```bash
source ~/.zshrc
```

---

# 7. Verify Setup

Check shell:

```bash
echo $0
```

Test autosuggestion:

* Type a previous command partially

Test syntax highlighting:

* Invalid command should show in red

Test Atuin:

```bash
atuin search docker
```

---

# Isolation Guarantee

This setup modifies only:

* `~/.zshrc`
* `~/.oh-my-zsh`
* `~/.zsh`
* `~/.atuin`

It does NOT modify:

* `/etc/zshrc`
* `/etc/profile`
* Other users’ home directories

Safe for multi-user servers.

---

# Optional: Remove Old SSH Sessions

Check active sessions:

```bash
who
```

Check current terminal:

```bash
tty
```

Kill another session:

```bash
pkill -t pts/X
```

---

# Maintenance

Update packages:

```bash
sudo apt update
sudo apt upgrade -y
```

Reboot if required:

```bash
sudo reboot
```

---
