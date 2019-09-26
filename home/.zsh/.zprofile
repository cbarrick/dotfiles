#!/usr/bin/env zsh

# Global profile
#--------------------
# The global profile may make changes to the PATH,
# so we source it before setting our own PATHs.

if [[ -o login ]]
then
	emulate sh -c '. /etc/profile'
fi


# Host-specific config
#--------------------

if [[ -e ${ZDOTDIR}/.zprofile.d/${HOST} ]]
then
	source ${ZDOTDIR}/.zprofile.d/${HOST}
fi
