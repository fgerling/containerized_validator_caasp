#! /bin/sh

. /app/config/validator_caasp.conf

eval $(ssh-agent)
ssh-add "$SSH_KEY"

# copy $SSH_KEY so sonobuoy can run more tests
if [ -f "$SSH_KEY"];
then
	mkdir -p ~/.ssh
	cp "$SSH_KEY" ~/.ssh/
fi

# run validator_caasp with all arguments passed to the container
./validator_caasp $@
