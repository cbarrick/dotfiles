if [[ "$(hostname -s)" == "roronoa" ]]
then
	# Allow GNU core utilities to replace the defaults.
	path=(
		'/usr/local/opt/coreutils/libexec/gnubin'
		'/usr/local/opt/gnu-sed/libexec/gnubin'
		$path
	)
fi
