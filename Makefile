# SPDX-License-Identifier: CC0-1.0
# SPDX-FileCopyrightText: 2023 The Foundation for Public Code <info@publiccode.net>

# Makefile variables used:
#
# $@ : target label
# $< : the first prerequisite after the colon
# $^ : all of the prerequisite files
# $* : wildcard matched part
#
# see https://www.gnu.org/software/make/manual/html_node/Flavors.html#Flavors
# for differences in ":=" vs "?=" variable assignments
#
# patsubst : $(patsubst pattern,replacement,text)
#	https://www.gnu.org/software/make/manual/html_node/Text-Functions.html

.PHONY: default
default: all

url-check/url-check.py:
	# git submodule add https://github.com/publiccodenet/url-check.git
	git submodule update --init --recursive

.PHONY: update-url-check
update-url-check: url-check/url-check.py
	git submodule update --init --recursive

.PHONY: check
check: url-check-config.json url-check/url-check.py check-no-fails.sh
	./check-no-fails.sh
	@echo SUCCESS $@

.PHONY: all
all: url-check/url-check.py

vendor/bundle:
	bundle install

url-check-fails.json \
standard.publiccode.net-url-check-fails.json \
bumperscripter-url-check-fails.json \
community-implementation-guide-standard-url-check-fails.json \
standard.publiccode.net-develop-url-check-fails.json \
	&: url-check/url-check.py url-check-config.json
	url-check/url-check.py --verbose

_site/url-check-fails.json _site/index.html &: index.md url-check-fails.json \
		badges/standard.publiccode.net.svg \
		badges/standard.publiccode.net-develop.svg \
		badges/community-implementation-guide-standard.svg \
		badges/bumperscripter.svg \
		vendor/bundle
	PAGES_REPO_NWO=publiccodenet/publiccodenet-url-check \
		bundle exec jekyll build

./node_modules/.bin/badge:
	npm install badge-maker

./url-check/make-badge: ./node_modules/.bin/badge

LICENSE_ID ?= CC0-1.0
COPYRIGHT_TEXT ?= 2023 The Foundation for Public Code <info@publiccode.net>
MAKE_BADGE=\
 LICENSE_ID='$(LICENSE_ID)' \
 COPYRIGHT_TEXT='$(COPYRIGHT_TEXT)' \
 ./url-check/make-badge


badges/standard.publiccode.net.svg: \
		./node_modules/.bin/badge \
		./url-check/make-badge \
		standard.publiccode.net-url-check-fails.json
	$(MAKE_BADGE) "standard.publiccode.net" "main"

badges/standard.publiccode.net-develop.svg: \
		./node_modules/.bin/badge \
		./url-check/make-badge \
		standard.publiccode.net-develop-url-check-fails.json
	$(MAKE_BADGE) "standard.publiccode.net-develop" "develop"

badges/community-implementation-guide-standard.svg: \
		./node_modules/.bin/badge \
		./url-check/make-badge \
		community-implementation-guide-standard-url-check-fails.json
	$(MAKE_BADGE) "community-implementation-guide-standard" "main"


badges/bumperscripter.svg: \
		./node_modules/.bin/badge \
		./url-check/make-badge \
		bumperscripter-url-check-fails.json
	$(MAKE_BADGE) "bumperscripter" "main"

.PHONY: build
build: _site/index.html

.PHONY: serve
serve: _site/url-check-fails.json vendor/bundle
	PAGES_REPO_NWO=publiccodenet/publiccodenet-url-check \
		bundle exec jekyll serve

.PHONY: clean
clean:
	rm -rf _site badges
