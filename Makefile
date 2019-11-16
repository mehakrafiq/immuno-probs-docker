##
##	ImmunoProbs Docker
##		ImmunoProbs and its dependencies bundled together in a single Docker
##    image. Copyright (C) 2019 Wout van Helvoirt
##

default: help

##	COMMANDS
##

##		make help
##			Display the help information for this file.
##
help:
	@grep '^##.*' ./Makefile

##		make build v=<*.*.*>
##			Build a docker image of all executables and tag the images.
##
build:
	if [ -z "$v" ]; then echo "Argument missing or empty: 'v=*.*.*'"; else docker build --build-arg VERSION=$(v) -t docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:$(v) . && docker tag docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:$(v) docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:latest; fi

##		make deploy v=<*.*.*>
##			Deploy the ImmunoProbs docker images (<version> and 'latest').
##
deploy:
	if [ -z "$v" ]; then echo "Argument missing or empty: 'v=*.*.*'"; else docker push docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:$(v) && docker push docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:latest; fi
