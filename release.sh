python3 -m build --sdist .
python3 -m build --wheel .
#ls dist
#twine upload dist/rosdep2-0.25.1.tar.gz dist/rosdep2-0.25.1-py3-none-any.whl
#vim ~/.pypirc
#twine upload dist/rosdep2-0.25.1.tar.gz dist/rosdep2-0.25.1-py3-none-any.whl
