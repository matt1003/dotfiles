# Add custom directories to PATH if they exist:
for dir in "$HOME/bin" "$HOME/.local/bin" "$HOME/work/bin"; do
  [[ -d $dir && ! ":$PATH:" =~ ":$dir:" ]] && PATH="$dir:$PATH"
done

# Set default editor to vim if in SSH session, otherwise use nvim:
export EDITOR="${EDITOR:-nvim}"
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
fi

# Set the history limit to 100,000 commands:
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE="$HOME/.zsh_history"
