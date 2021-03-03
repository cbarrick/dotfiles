if [[ "$(hostname -s)" == "kirby" ]]
then
	# Enable conda, but do not activate an environment.
    source /opt/conda/etc/profile.d/conda.sh
fi
