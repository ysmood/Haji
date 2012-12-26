# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ys"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source .bashrc









######################################### ys kit ###########################################

# If Saya is sealed, run setup.
if [ -f /home/saya/.sealed ]; then
	haji setup	
fi

# Shrink the VM disk.
alias ys-shrink='sudo vmware-toolbox-cmd disk shrinkonly'

# Show all available commands.
alias ys-cmds="echo $PATH | tr ':' '\n' | xargs -n 1 ls -1"

# Generate a random password.
alias ys-password='openssl rand -base64 32'

# Shutdown the vm.
alias ys-shutdown='sudo shutdown -P 0'

# Act as root.
alias ys-su='sudo su -'

# Reload .zshrc
alias ys-zsh='source .zshrc'

# Achive and Compress TAR
#tar -jcvf data.tar.bz2 directory_to_compress
alias ys-tz='tar -jcvf'
# tar -jxvf data.tar.bz2 -C /tmp/extract_here/
alias ys-tuz='tar -jxvf'
# tar -zxvf data.tar.gz -C /tmp/extract_here/
alias ys-tug='tar -zxvf'











########################################## ALIAS ###########################################

# Common bash commands.
alias le='/usr/share/vim/vim73/macros/less.sh'
alias less='le'
alias ll='ls -laFh'
alias cls='clear'
alias ps='ps -ef'

# Disk usage
alias du='du -khs'

# Cradle folder
alias cradle='cd /home/saya/cradle'