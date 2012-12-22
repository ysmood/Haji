########################################## Common ###########################################

# Common bash commands.
alias le='less -R'
alias ll='ls -laFh'
alias cls='clear'
alias ps='ps -ef'

# Disk usage
alias du='du -khs'

# Cradle folder
alias cradle='cd /home/saya/cradle'

######################################### Special ##########################################

# Shrink the VM disk.
alias haji-shrink='sudo vmware-toolbox-cmd disk shrinkonly'

# Show all available commands.
alias haji-cmds="echo $PATH | tr ':' '\n' | xargs -n 1 ls -1"

# Generate a random password.
alias haji-password='openssl rand -base64 32'

# Shutdown the vm.
alias haji-shutdown='sudo shutdown -P 0'

# Act as root.
alias haji-su='sudo su -'

# Reload .zshrc
alias haji-zsh='source .zshrc'

# Achive and Compress TAR
#tar -jcvf data.tar.bz2 directory_to_compress
alias haji-tz='tar -jcvf'
# tar -jxvf data.tar.bz2 -C /tmp/extract_here/
alias haji-tuz='tar -jxvf'
# tar -zxvf data.tar.gz -C /tmp/extract_here/
alias haji-tug='tar -zxvf'
