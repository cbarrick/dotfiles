if [[ "${HOST%%.*}" == "samus" ]]
then
	export POETRY_HOME="${HOME}/.poetry"

	export HOMEBREW_PREFIX="/opt/homebrew"
	export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
	export HOMEBREW_REPOSITORY="/opt/homebrew"
	export HOMEBREW_SHELLENV_PREFIX="/opt/homebrew"

	path=(
		"${HOME}/.local/bin"
		"${HOME}/.cargo/bin"
		"${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin"
		"${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin"
		"${HOMEBREW_PREFIX}/opt/ruby/bin"
		"${HOMEBREW_PREFIX}/bin"
		"${HOMEBREW_PREFIX}/sbin"
		${path}
	)

	fpath=(
		"${ZDOTDIR}/functions"
		"${HOMEBREW_PREFIX}/share/zsh-completions"
		"${HOMEBREW_PREFIX}/share/zsh/site-functions"
		"${HOMEBREW_PREFIX}/share/zsh/functions"
		${fpath}
	)

	manpath=(
		"${HOME}/.local/share/man"
		"${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman"
		"${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnuman"
		"${HOMEBREW_PREFIX}/opt/ruby/share/man"
		"${HOMEBREW_PREFIX}/share/man"
		${manpath}
		""  # Empty string means to use the default search path.
	)

	infopath=(
		"${HOME}/.local/share/info"
		"${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuinfo"
		"${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnuinfo"
		"${HOMEBREW_PREFIX}/share/info"
		${infopath}
		""  # Empty string means to use the default search path.
	)

	source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
	source "${HOME}/.poetry/env"
fi
