#!/bin/bash

__BPP_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$__BPP_SOURCE_DIR/../cli/cli.sh" && __bpp_cli setup
