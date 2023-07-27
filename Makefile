#!/usr/bin/make
SHELL := /bin/bash
.ONESHELL:

.PHONY: all
all: help
.DEFAULT_GOAL: all

.PHONY: help
help:
	@echo 'Makefile for the ansible-self-signed-certificates role'
	echo
	echo "usage: $(MAKE) [COMMAND]"
	echo '  help            - Print this message and exit.'
	echo '  deps            - Install dependencies.'
	echo '  test            - Run the test playbook.'
	echo

# DEPENDENCIES

.PHONY: deps
deps: requirements.txt
	@set -euo pipefail
	pip install -r requirements.txt

# RUN COMMANDS

.PHONY: test
test: tests/test.yml
	@set -euo pipefail

	echo "Running $<..."
	TIME="Time elapsed: %E" time ansible-playbook "$<"
