#!/bin/bash

#python3 -m build --sdist .
#python3 -m build --wheel .
#ls dist
#twine upload dist/rosdep2-0.25.1.tar.gz dist/rosdep2-0.25.1-py3-none-any.whl
#vim ~/.pypirc
#twine upload dist/rosdep2-0.25.1.tar.gz dist/rosdep2-0.25.1-py3-none-any.whl
# https://github.com/astral-sh/uv/issues/7676

LAST_LINE="$(uv build 2>&1 | tail -2)"


echo "-------------"

BITS="$(echo $LAST_LINE | cut -d ' ' -f 3,6)"

#for LINE in $BITS; do
#  echo "xx $LINE"
#done;


echo "uv publish $(echo $BITS | cut -d ' ' -f 1) $(echo $BITS | cut -d ' ' -f 2) --token \$(awk -F '= ' '/password/ {print \$2}' ~/.pypirc)"
