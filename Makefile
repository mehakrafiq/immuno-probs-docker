##
##	ImmunoProbs Docker
##		ImmunoProbs and its dependencies bundled together in a single Docker
##    image. Copyright (C) 2019 Wout van Helvoirt
##

VERSION = $(shell pip search immuno-probs | cut -d ')' -f 1 | cut -d '(' -f 2)

default: help

##	COMMANDS
##

##		make help
##			Display the help information for this file.
##
help:
	@grep '^##.*' ./Makefile

##		make build
##			Build a docker image of all executables and tag the images.
##
build:
	docker build --build-arg immuno_probs_version=$(VERSION) -t docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:$(VERSION) .
	&& docker tag docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:$(VERSION) docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:latest

##		make deploy
##			Deploy the ImmunoProbs docker images (<version> and 'latest').
##
deploy:
	docker push docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:$(VERSION)
	&& docker push docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:latest
