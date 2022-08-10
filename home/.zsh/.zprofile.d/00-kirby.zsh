if [[ "${HOST%%.*}" == "kirby" ]]
then
	# CUDA Setup
	# Nvidia ships several binaries that conflict with the system
	# toolchain, e.g. gcc. Therefore, CUDA must be added to the
	# *end* of the path.
	export CUDA_PATH="/opt/cuda"
	export CPPFLAGS="-I/opt/cuda/include"
	export LDLIBS="-L/opt/cuda/lib64"
	path=(${path} "/opt/cuda/bin")
fi
