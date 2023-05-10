# SPDX-License-Identifier: CC0-1.0
# SPDX-FileCopyrightText: 2023 The Foundation for Public Code <info@publiccode.net>

# Makefile variables used:
#
# $@ : target label
# $< : the first prerequisite after the colon
# $^ : all of the prerequisite files
# $* : wildcard matched part
#
# patsubst : $(patsubst pattern,replacement,text)
#	https://www.gnu.org/software/make/manual/html_node/Text-Functions.html

.PHONY: default
default: all

url-check/url-check.py:
	git submodule add https://github.com/publiccodenet/url-check.git

.PHONY: update-url-check
update-url-check: url-check/url-check.py
	git submodule update --init --recursive

.PHONY:
check: url-check-config.json url-check/url-check.py check-no-fails.sh
	./check-no-fails.sh
	@echo SUCCESS $@

all: url-check/url-check.py
