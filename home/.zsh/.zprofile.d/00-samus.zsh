if [[ "$(hostname -s)" == "samus" ]]
then
	# Setup homebrew
	export HOMEBREW_PREFIX="/opt/homebrew";
	export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
	export HOMEBREW_REPOSITORY="/opt/homebrew";
	export HOMEBREW_SHELLENV_PREFIX="/opt/homebrew";
	export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
	export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
	export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
	
	# Allow GNU core utilities to replace the defaults.
	path=(
		'/opt/homebrew/opt/coreutils/libexec/gnubin'
		'/opt/homebrew/opt/gnu-sed/libexec/gnubin'
		$path
	)

	# Use homebrew's ruby.
	path=('/opt/homebrew/opt/ruby/bin' $path)
fi
