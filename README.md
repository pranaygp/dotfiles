# Pranays’s dotfiles

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/github/dotfiles`) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/pranaygp/dotfiles.git && cd dotfiles && ./bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
./bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; ./bootstrap.sh
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

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults:

```bash
./.macos
```

### Install Homebrew formulae

When setting up a new Mac, you may want to install some common [Homebrew](https://brew.sh/) formulae (after installing Homebrew, of course):

```bash
./brew.sh
```

Some of the functionality of these dotfiles depends on formulae installed by `brew.sh`. If you don’t plan to run `brew.sh`, you should look carefully through the script and manually install any particularly important ones. A good example is Bash/Git completion: the dotfiles use a special version from Homebrew.

## Feedback

Suggestions/improvements
[welcome](https://github.com/pranaygp/dotfiles/issues)!

## Thanks to…

* [Mathias Bynens](https://github.com/mathiasbynens) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles) which inspired much of this repository