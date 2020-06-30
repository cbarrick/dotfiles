if [[ "$HOST" == "roronoa" ]]
then
	export CFLAGS="-mtune=cortex-a7 -mfpu=neon-vfpv4 -marm -mfloat-abi=hard"
	export CXXFLAGS=$CFLAGS
	export ASFLAGS=$CFLAGS
fi
