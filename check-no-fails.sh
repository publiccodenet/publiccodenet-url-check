#!/bin/bash
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileCopyrightText: 2023 The Foundation for Public Code <info@publiccode.net>

# $ help set | grep '\-e'
#      -e  Exit immediately if a command exits with a non-zero status.
set -e

url-check/url-check.py
LINES=`wc -l url-check-fails.json | cut -f1 -d' '`
if [ $LINES -gt 1 ]; then
	cat url-check-fails.json;
	exit 1
fi
