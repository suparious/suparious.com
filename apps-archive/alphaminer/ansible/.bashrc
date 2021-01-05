# Declare a list of cluster members, using the project repo name as our hook
FRIENDS=$(docker node ls | grep -vE '\*|HOSTNAME' | awk '{print $2}')

# Simple loop, limited to expressions within double-parentheses (" ")
# NB: many admins setup Jenkins or Ansible just to get this functionality
function friend {
  command=$1
  for friend in ${FRIENDS[@]}; do
    echo $friend | figlet | lolcat
    echo -e "\e[1mChatting with: $friend, about $command\e[0m"
    # quit waiting for a initial response after 5 seconds
    ssh -tq -o ConnectTimeout=5 $friend $command
    echo
  done
}

# Discover active swarm node type
MANAGER=$(docker info 2> /dev/null | grep "Is Manager" | grep true)

if [ -z "$MANAGER" ]
then
  export MANAGER=false
else
  export MANAGER=true
fi

## Depricated with bash '__git_ps1'
# check if we are in a branch
#git_branch() {
#  git branch 2>/dev/null | grep '^*' | colrm 1 2
#}

# Set a color based on git status
acolor() {
  [[ -n $(git status --porcelain=v2 2>/dev/null) ]] && echo 31 || echo 33
}

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Enable colorful Debian prompt
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  color_prompt=yes
else
  color_prompt=
fi

PROMPT_COMMAND=__prompt_command

__prompt_command() {
  local EXIT="$?"             # This needs to be first
  # thanks @hansfn - https://gist.github.com/justintv/168835#gistcomment-2711710
  PS1="\[\033[2;37m\]\T \[\033[0;32m\]\u\[\033[0;33m\]@\[\033[0;36m\]\h \[\033[1;33m\]\w\[\033[\$(acolor)m\]$(__git_ps1) "

  if [ $EXIT != 0 ]; then
    PS1+='\[\033[0;37m\][\[\033[1;33m\]$?\[\033[1;37m\]]'
  else
    PS1+='\[\033[0;37m\][\[\033[1;32m\]ok\[\033[1;37m\]]'
  fi

  PS1+='\n\[\033[0;32m\]└─\[\033[0;32m\] \$\[\033[0;32m\] ▶\[\033[0m\] '
}

# Display hostname banner
figlet $(hostname) | lolcat

if [ "$MANAGER" = true ]; then
  #echo -e "    Docker swarm \e[1mMANAGER" | lolcat
  echo -e "    Docker swarm MANAGER" | lolcat
else
  echo "    Docker swarm WORKER" | lolcat
fi

# Show some system stats
echo
echo "uptime is $( uptime )"
uname -a | lolcat
echo "date   is $( date   )"
echo
df -h | grep -E 'techfusion|sd|md|mmc' | awk -v OFS='\t' '{print $5, $2, $1}' | lolcat
echo

# Enable some shell aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias src='cd /media/source'
