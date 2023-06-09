#!/bin/bash
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileCopyrightText: 2023 The Foundation for Public Code <info@publiccode.net>

if [ "_${VERBOSE}_" == "__" ]; then VERBOSE=0; fi
if [ $VERBOSE -gt 0 ]; then
	set -x
	URL_CHECK_VERBOSE=--verbose
fi

# $ help set | grep '\-e'
#      -e  Exit immediately if a command exits with a non-zero status.
set -e

if [ "_${URL_CHECK_JUST_RAN}_" == "__" ]; then
	url-check/url-check.py $URL_CHECK_VERBOSE
fi
if [ $(grep -c '"failing"' url-check-fails.json) -ne 0 ]; then
	echo
	echo "Fails: $(grep -c '"http' url-check-fails.json)"
	echo
	cat url-check-fails.json;
	exit 1
fi
