if [[ "${HOST%%.*}" == "samus" ]]
then
	export HOMEBREW_PREFIX="/opt/homebrew"
	export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
	export HOMEBREW_REPOSITORY="/opt/homebrew"
	export HOMEBREW_SHELLENV_PREFIX="/opt/homebrew"

	export CC="${HOMEBREW_PREFIX}/opt/llvm/bin/clang"
	export CPP="${HOMEBREW_PREFIX}/opt/llvm/bin/clang-cpp"
	export CXX="${HOMEBREW_PREFIX}/opt/llvm/bin/clang++"
	export LD="${HOMEBREW_PREFIX}/opt/llvm/bin/lld"
	export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/llvm/lib -Wl,-rpath,${HOMEBREW_PREFIX}/opt/llvm/lib"
	export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/llvm/include"

	path=(
		"${HOME}/.local/bin"
		"${HOME}/.cargo/bin"
		"${HOMEBREW_PREFIX}/opt/llvm/bin"
		"${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin"
		"${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin"
		"${HOMEBREW_PREFIX}/opt/make/libexec/gnubin"
		"${HOMEBREW_PREFIX}/opt/ruby/bin"
		"${HOMEBREW_PREFIX}/bin"
		"${HOMEBREW_PREFIX}/sbin"
		"/Applications/iTerm.app/Contents/Resources/utilities"
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
		"${HOMEBREW_PREFIX}/opt/llvm/share/man"
		"${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman"
		"${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnuman"
		"${HOMEBREW_PREFIX}/opt/make/libexec/gnuman"
		"${HOMEBREW_PREFIX}/opt/ruby/share/man"
		"${HOMEBREW_PREFIX}/share/man"
		${manpath}
		""  # Empty string means to use the default search path.
	)

	infopath=(
		"${HOME}/.local/share/info"
		"${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuinfo"
		"${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnuinfo"
		"${HOMEBREW_PREFIX}/opt/make/libexec/gnuinfo"
		"${HOMEBREW_PREFIX}/share/info"
		${infopath}
		""  # Empty string means to use the default search path.
	)

	source "${HOMEBREW_PREFIX}/share/google-cloud-sdk/completion.zsh.inc"
	source "${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.zsh.inc"
fi
