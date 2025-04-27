# Load bashrc if it exists
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# Add user's bin directory to PATH
export PATH="$HOME/bin:$PATH"
