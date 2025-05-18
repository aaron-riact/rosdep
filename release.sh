#!/bin/bash

#python3 -m build --sdist .
#python3 -m build --wheel .
#ls dist
#twine upload dist/rosdep2-0.25.1.tar.gz dist/rosdep2-0.25.1-py3-none-any.whl
#vim ~/.pypirc
#twine upload dist/rosdep2-0.25.1.tar.gz dist/rosdep2-0.25.1-py3-none-any.whl

LAST_LINE="$(python3 -m build --sdist --wheel | tail -1)"

echo $LAST_LINE


echo "-------------"

BITS="$(echo $LAST_LINE | cut -d ' ' -f 3,5)"

echo "twine dist/$(echo $BITS | cut -d ' ' -f 1) dist/$(echo $BITS | cut -d ' ' -f 2)"
