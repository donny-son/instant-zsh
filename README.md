# gh-zsh

A simple script to set an awesome shell environment for Ubuntu and MacOS, with:

* powerlevel10k theme (https://github.com/romkatv/powerlevel10k)
* oh-my-tmux (https://github.com/gpakosz/.tmux) with Powerline status bar
* zsh-completions (https://github.com/zsh-users/zsh-completions)
* zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
* fast-syntax-highlighting (https://github.com/zdharma-continuum/fast-syntax-highlighting/)
* completion (https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/completion.zsh)
* history (https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/history.zsh)
* key-bindings (https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/key-bindings.zsh)

Tmux features:
* Automatic tmux session management (auto-start/attach on terminal open)
* Window auto-rename to current directory
* Powerline-style status bar with battery, uptime, and hostname

Sets the following useful aliases:
* ..='cd ..'
* ...='cd ../..'
* ....='cd ../../..'
* grep='grep --color=auto'

For Linux
* bat='batcat --theme base16 -p'
* ls='ls -h --color=auto'
* la='ls -la --color=auto'

## Installation

``` bash
curl -fsSL https://raw.githubusercontent.com/donny-son/instant-zsh/donny-son/gh-zsh.sh | bash
```

## Testing in Docker

To test in a fresh Ubuntu container:

``` bash
docker run -it ubuntu:24.04 bash -c "apt update && apt install -y curl && curl -fsSL https://raw.githubusercontent.com/donny-son/instant-zsh/donny-son/gh-zsh.sh | bash"
```

To test local changes before pushing, mount the repo and copy files manually:

``` bash
docker run -it -v ~/tools/instant-zsh:/tmp/instant-zsh ubuntu:24.04 bash
```

Then inside the container:

``` bash
apt update && apt install -y curl git
cp /tmp/instant-zsh/.zshrc ~/.zshrc
cp /tmp/instant-zsh/.p10k.zsh ~/.p10k.zsh
cp /tmp/instant-zsh/.tmux.conf.local ~/.tmux.conf.local
bash /tmp/instant-zsh/gh-zsh.sh
```

## Notes
* If you already use zsh, your zsh config will be backed up to .zshrc-backup-date.
* If you already have a .tmux.conf.local, it will be backed up before overwriting.
* If the text/icons look broken, ensure your terminal uses one of the Nerd fonts.
* Tested on:
  * Ubuntu 20.04, 22.04, 24
  * MacOS 26.3
