#!/usr/bin/env bash

echo "Installing InsightToolkit (ITK)"

command -v apt-get >/dev/null 2>&1 && \
sudo apt-get install libinsighttoolkit4.6 libinsighttoolkit4-dev

command -v brew >/dev/null 2>&1 && \
brew install insighttoolkit

