if [[ -o login ]]
then
	# Google Cloud
	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
	source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi

if [[ -o interactive ]]
	# Conda
	source /usr/local/miniconda3/etc/profile.d/conda.sh
fi
