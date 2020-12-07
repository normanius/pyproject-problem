#!/usr/bin/env bash

echo "###########################################################"
echo "# TEST 1: FAILURE"
echo "###########################################################"
_VERSION="0.1.0"

echo ">>> Building source distribution package..."
rm -rf build
rm -rf dist
rm -rf hello_world_normanius.egg-info
echo -en "$_VERSION\n" > VERSION
python setup.py sdist

echo
echo ">>> deploying package to TestPyPI (requires an account)"
twine upload --repository testpypi dist/*

echo
echo ">>> Sleeping a 20s..."
sleep 20s

echo
echo ">>> Install v${_VERSION} via TestPyPI (failure)"
rm -rf hello_world_normanius.egg-info
pip uninstall -y hello_world_normanius
pip install --index-url https://test.pypi.org/simple/ \
            --no-deps hello_world_normanius==$_VERSION


echo "###########################################################"
echo "# TEST 2: FIX BY REMOVING pyproject.toml"
echo "###########################################################"
_VERSION="0.2.0"

mkdir tmp
mv pyproject.toml tmp

echo ">>> Building source distribution package..."
rm -rf build
rm -rf dist
rm -rf hello_world_normanius.egg-info
echo -en "$_VERSION\n" > VERSION
python setup.py sdist

echo
echo ">>> deploying package to TestPyPI (requires an account)"
twine upload --repository testpypi dist/*

echo
echo ">>> Sleeping a 20s..."
sleep 20s

echo
echo ">>> Install v$_VERSION via TestPyPI (now it works)"
rm -rf hello_world_normanius.egg-info
pip uninstall -y hello_world_normanius
pip install --index-url https://test.pypi.org/simple/ \
            --no-deps hello_world_normanius==$_VERSION


echo "###########################################################"
echo "# TEST 3: FIX BY LOCAL INSTALLATION"
echo "###########################################################"
_VERSION="0.3.0"
mv tmp/pyproject.toml .

echo ">>> Building source distribution package..."
rm -rf build
rm -rf dist
rm -rf hello_world_normanius.egg-info
echo -en "$_VERSION\n" > VERSION
python setup.py sdist

echo
echo ">>> Install v$_VERSION local build (also works)"
rm -rf hello_world_normanius.egg-info
pip uninstall -y hello_world_normanius
pip install --no-deps "dist/hello_world_normanius-$_VERSION.tar.gz"
