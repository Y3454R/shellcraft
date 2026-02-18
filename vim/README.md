# Vim Tips: Replace & Undo

This document is a quick, practical reference for **replace** and **undo** operations in Vim. It’s written to be copy-paste friendly for a README or personal notes.

---

## Replace Text in Vim

### Replace in the Current Line

```vim
:s/old/new/
```

* Replaces the **first occurrence** of `old` with `new` in the current line.

```vim
:s/old/new/g
```

* Replaces **all occurrences** in the current line.

---

### Replace in the Entire File

```vim
:%s/old/new/
```

* Replaces the **first occurrence per line** across the whole file.

```vim
:%s/old/new/g
```

* Replaces **all occurrences everywhere**.

---

### Replace with Confirmation

```vim
:%s/old/new/gc
```

Vim will ask before each replacement:

* `y` → yes
* `n` → no
* `a` → replace all
* `q` → quit
* `l` → replace once and stop

---

### Replace in a Selected Range (Visual Mode)

1. Select text using `v`, `V`, or `Ctrl+v`
2. Run:

```vim
:s/old/new/g
```

Only the selected lines are affected.

---

### Case-Insensitive Replace

```vim
:%s/old/new/gi
```

* `i` → ignore case
* `I` → match case strictly

---

### Replace Whole Words Only

```vim
:%s/\<old\>/new/g
```

Prevents partial matches (e.g., `folder` won’t match `old`).

---

## Undo & Redo in Vim

### Undo Last Change

```vim
u
```

* Undoes the most recent change.
* Can be pressed multiple times.

---

### Undo Multiple Changes

```vim
5u
```

* Undo the last **5 changes**.

---

### Redo

```vim
Ctrl+r
```

* Re-applies the last undone change.

---

### Undo All Changes in a Line

```vim
U
```

* Reverts the current line to its original state.

---

### Jump Through Undo History

```vim
:undolist
```

Shows undo branches and sequence numbers.

```vim
:undo 3
```

Jumps directly to undo state `3`.

---

## Pro Tips

* Every **insert mode session** is one undo step
* Use `.` to **repeat the last change** (extremely powerful)
* Combine search + replace with macros for complex edits

---

Happy Vimming 🧙‍♂️
