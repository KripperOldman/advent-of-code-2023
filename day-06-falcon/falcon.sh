#!/usr/bin/env bash

falcon_dir=Falcon-0.9.6.8

export DYLD_FALLBACK_LIBRARY_PATH="$falcon_dir/lib"

"$falcon_dir/bin/falcon" ${1?}
