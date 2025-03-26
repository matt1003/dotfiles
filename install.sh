#!/bin/bash
$(git -C "$(dirname "$0")" rev-parse --show-toplevel)/bin/update all
