if [[ "$HOST" == "roronoa" ]]
then
	# Allow GNU core utilities to replace the defaults.
	path=(
		'/usr/local/opt/coreutils/libexec/gnubin'
		'/usr/local/opt/gnu-sed/libexec/gnubin'
		$path
	)

	# Enable Google Cloud SDK.
	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi
