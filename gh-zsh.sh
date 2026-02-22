#!/usr/bin/env bash
set -e

OS="$(uname)"

#===========================================================
# Helpers
#===========================================================
msg() { echo -e "\n→ $1"; }
err() { echo "ERROR: $1" >&2; exit 1; }

# Use sudo only when not already root
if [[ "$(id -u)" -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
fi

backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        cp "$file" "${file}.backup-$(date +%F)" &> /dev/null
        msg "Backup created: ${file}.backup-$(date +%F)"
    fi
}

copy_to_root() {
    if [[ "$OS" == "Linux" ]]; then
        $SUDO cp -r ~/.zsh /root/
        $SUDO cp ~/.zshrc /root/ 2>/dev/null || true
        $SUDO cp ~/.p10k.zsh /root/ 2>/dev/null || true
        $SUDO cp -r ~/.tmux /root/ 2>/dev/null || true
        $SUDO ln -s -f /root/.tmux/.tmux.conf /root/.tmux.conf 2>/dev/null || true
        $SUDO cp ~/.tmux.conf.local /root/ 2>/dev/null || true
    fi
}

#===========================================================
# Ensure directories
#===========================================================
mkdir -p ~/.zsh
mkdir -p ~/.zsh/plugins

#===========================================================
# macOS – Command Line Tools
#===========================================================
install_clt_macos() {
    msg "Checking Xcode Command Line Tools…"
    if xcode-select -p &>/dev/null; then
        msg "Command Line Tools already installed"
        return
    fi

    msg "Installing macOS Command Line Tools…"
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

    PROD=$(
        softwareupdate -l \
        | grep -B 1 -E "Command Line Tools" \
        | awk -F"*" '/^ *\*/ {print $2}' \
        | sed 's/^ *Label: //' \
        | sort -V \
        | tail -n1
    )

    softwareupdate -i "$PROD" --verbose
    rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    xcode-select --switch /Library/Developer/CommandLineTools
}

#===========================================================
# OS-specific Install
#===========================================================
if [[ "$OS" == "Linux" ]]; then
    msg "Installing zsh, bat, git, curl"
    $SUDO apt update &> /dev/null
    $SUDO apt install -y zsh bat git curl tmux &> /dev/null
    export PATH="/usr/local/bin:$PATH"
    hash -r
fi

if [[ "$OS" == "Darwin" ]]; then
    install_clt_macos
fi

#===========================================================
# Change Shell
#===========================================================
msg "Setting ZSH as default shell"
if [[ "$OS" == "Darwin" ]]; then
    chsh -s /bin/zsh &> /dev/null
else
    $SUDO chsh -s /usr/bin/zsh "$(whoami)" &> /dev/null
    $SUDO chsh -s /usr/bin/zsh root &> /dev/null
fi

#===========================================================
# Backup old zshrc and download new
#===========================================================
backup_file ~/.zshrc
msg "Downloading new .zshrc"
curl -fsSL -o ~/.zshrc https://raw.githubusercontent.com/donny-son/instant-zsh/donny-son/.zshrc

#===========================================================
# Install Theme
#===========================================================
msg "Installing Powerlevel10k theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.zsh/powerlevel10k &> /dev/null

curl -fsSL -o ~/.p10k.zsh https://raw.githubusercontent.com/donny-son/instant-zsh/donny-son/.p10k.zsh

#===========================================================
# Install Plugins
#===========================================================
msg "Installing Plugins"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ~/.zsh/fast-syntax-highlighting &> /dev/null
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions &> /dev/null

curl -fsSL -o ~/.zsh/completion.zsh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/completion.zsh
curl -fsSL -o ~/.zsh/history.zsh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/history.zsh
curl -fsSL -o ~/.zsh/key-bindings.zsh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/key-bindings.zsh

#===========================================================
# Install oh-my-tmux
#===========================================================
msg "Installing oh-my-tmux"
git clone --single-branch https://github.com/gpakosz/.tmux.git ~/.tmux &> /dev/null
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf

backup_file ~/.tmux.conf.local
msg "Downloading .tmux.conf.local"
curl -fsSL -o ~/.tmux.conf.local https://raw.githubusercontent.com/donny-son/instant-zsh/donny-son/.tmux.conf.local

#===========================================================
# Copy to root (Linux only)
#===========================================================
copy_to_root

#===========================================================
# Finish
#===========================================================
msg "Installation Finished!"
msg "→ Reopen terminal if theme doesn't load automatically."

#===========================================================
# Replace current shell immediately with login ZSH
#===========================================================
exec zsh -l
