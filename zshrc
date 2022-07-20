source ~/.zsh/prompt
source ~/.zsh/env
source ~/.zsh/aliases
source ~/.zsh/functions

# Start SSH agent if it is not alreay running
if [ -z "$SSH_AUTH_SOCK" ] ; then
    # Start the ssk-agent
    eval `ssh-agent -s` > /dev/null

    # Add keys to ssh agent
    # List public keys, strip off `.pub` from file name, add private key to ssh-agent
    for x in $(ls ~/.ssh/*.pub); do ssh-add -q $(echo $x | sed 's/\.pub$//') ; done; 
fi
