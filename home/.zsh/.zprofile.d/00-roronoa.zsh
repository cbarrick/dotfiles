if [[ "$(hostname -s)" == "roronoa" ]]
then
	path=(
		"${HOME}/.local/bin"
		"${HOME}/.cargo/bin"
		'/usr/local/opt/coreutils/libexec/gnubin'
		'/usr/local/opt/gnu-sed/libexec/gnubin'
		'/usr/local/opt/ruby/bin'
		"/usr/local/bin"
		"/usr/local/sbin"
		$path
	)
fi
