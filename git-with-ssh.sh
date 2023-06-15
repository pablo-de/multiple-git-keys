#!/bin/bash

current_dir=$(pwd)

if [[ $current_dir == *"work"* ]]; then
  sed -i 's|IdentityFile ~/.ssh/id_rsa|IdentityFile ~/.ssh/work_rsa|' ~/.ssh/config
else
  sed -i 's|IdentityFile ~/.ssh/work_rsa|IdentityFile ~/.ssh/id_rsa|' ~/.ssh/config
fi

git "$@"
