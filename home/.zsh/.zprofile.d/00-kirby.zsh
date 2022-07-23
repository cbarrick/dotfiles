if [[ "${HOST%%.*}" == "kirby" ]]
then
	export CPPFLAGS="-I/opt/cuda/include"
	export LDLIBS="-L/opt/cuda/lib64"

	path=(
		"/opt/cuda/bin"
		${path}
	)
fi
