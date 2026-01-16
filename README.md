# Pranay's dotfiles

Cross-platform dotfiles that work seamlessly on both **macOS** and **Linux** (Ubuntu/Debian).

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don't want or need. Don't blindly use my settings unless you know what that entails. Use at your own risk!

### Prerequisites

**macOS:**
- [Homebrew](https://brew.sh/) - Package manager for macOS
- Run `./brew.sh` to install required tools (includes `fnm`)

**Linux (Ubuntu/Debian):**
- `git`, `curl`, `sudo` access
- The `.linux` script will install all required tools automatically

**Both platforms:**
- The bootstrap script automatically installs [oh-my-zsh](https://ohmyz.sh/) with custom plugins

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/github/dotfiles`) The bootstrapper script will:
- Copy dotfiles to your home folder
- Install oh-my-zsh with custom plugins
- Run platform-specific setup (`.linux` on Linux, or use `brew.sh` on macOS)

```bash
git clone https://github.com/pranaygp/dotfiles.git && cd dotfiles && ./bootstrap.sh
```

The bootstrap script will prompt for confirmation. To skip the prompt, use the `--force` flag:

```bash
./bootstrap.sh --force
```

To update, `cd` into your local `dotfiles` repository and run:

```bash
./bootstrap.sh --force
```

### Git-free install

To install these dotfiles without Git:

```bash
cd; curl -#L https://github.com/pranaygp/dotfiles/tarball/main | tar -xzv --strip-components 1 --exclude={README.md,bootstrap.sh,LICENSE.txt}
```

To update later on, just run that command again.

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing takes place.

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Pranay Prakash"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="pranay.gp@gmail.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"

# Other private env vars
export GH_TOKEN="..."
export OTHER_SECRET="..."
```

You could also use `~/.extra` to override settings, functions and aliases from my dotfiles repository. It’s probably better to [fork this repository](https://github.com/pranaygp/dotfiles/fork) instead, though.

### Platform-Specific Setup

#### macOS

**Sensible macOS defaults:**

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
./.macos
```

**Install Homebrew formulae:**

When setting up a new Mac, install common [Homebrew](https://brew.sh/) formulae (after installing Homebrew, of course):

```bash
./brew.sh
```

This installs essential tools like `fnm`, `neovim`, `git`, `gh`, `lazygit`, `ripgrep`, `fzf`, `bat`, `starship`, and many more.

Some of the functionality of these dotfiles depends on formulae installed by `brew.sh`. If you don't plan to run `brew.sh`, you should look carefully through the script and manually install any particularly important ones.

#### Linux (Ubuntu/Debian)

**Automated Linux setup:**

The bootstrap script automatically runs the `.linux` setup script on Linux systems. You can also run it manually:

```bash
./.linux
```

This installs a comprehensive development environment including:

**Editors & Version Control:**
- Neovim 0.11.5+ (from GitHub releases, required for LazyVim)
- Git, GitHub CLI (`gh`), lazygit, git-delta, git-lfs

**Shell & Terminal:**
- Zsh, oh-my-zsh with custom plugins
- Starship prompt
- tmux, screen, htop

**Development Tools:**
- fnm (Fast Node Manager)
- ripgrep, fd, fzf, tree, zoxide
- bat, jq, httpie, ast-grep

**Media Processing:**
- ffmpeg, imagemagick, gifsicle, pngcrush

**Other Tools:**
- 1Password CLI, nmap, speedtest-cli, git-lfs, zstd

**Important notes:**
- Neovim is installed from GitHub releases (v0.11.5) instead of apt, because LazyVim requires v0.11.2+
- On Ubuntu, `fd` and `bat` are symlinked from `/usr/bin/fdfind` and `/usr/bin/batcat` to `~/.local/bin/`
- Make sure `~/.local/bin` is in your PATH (handled automatically by `.path`)

## Feedback

Suggestions/improvements
[welcome](https://github.com/pranaygp/dotfiles/issues)!

## Thanks to…

* [Mathias Bynens](https://github.com/mathiasbynens) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles) which inspired much of this repository