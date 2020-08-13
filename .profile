# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

export ENV="development"

export PATH="$HOME/go/bin:$PATH"

export PATH="$HOME/.cargo/bin:/usr/lib/go-1.10/bin:$PATH"
export CSC_IDENTITY_AUTO_DISCOVERY=false

# for node-rdkafka
export CPPFLAGS=-I/usr/local/opt/openssl/include
export LDFLAGS=-L/usr/local/opt/openssl/lib

# for java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export PATH=${JAVA_HOME}/bin:$PATH

# for android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# for deno
export PATH=$PATH:$HOME/.deno/bin

# For python
export PATH="$PATH:$HOME/Library/Python/3.7/bin"

alias headers='curl -I -X GET'
alias bim='vim'
alias start_clipper='ssh -f -N dev-clipper; clipper'
alias dus='du -sch .[!.]* * |sort -h'

lklogs() {
  klogs "$@" | while read line; do
    date=$(echo $line | awk '{print $2}')
    tdate=$(TZ='America/Los_Angeles' date --date="$date")
    echo $line | awk -vt="$tdate" '{print $1 " " t " " substr($0, index($0,$3))}'
  done
}
httpstat() {
  docker run --rm -it dockerepo/httpstat "$@"
}
spoof_mac() {
  sudo ifconfig en0 ether $(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
}
say() {
  data="{\"message\": \"$1\"}"
  curl -X POST http://say.windsor.io --data $data
}
local-only-branches() {
  EXISTING=$(git branch -r | awk 'BEGIN { FS = "/" } ; { print $2 }')
  for b in $(git branch | grep -v '*'); do
    if [[ "$EXISTING" != *"$b"* ]]; then
      echo $b
    fi
  done
}
