#!/usr/bin/env bash
_CODE=
_CODE="${_CODE}import hello_world_normanius as hello;"
_CODE="${_CODE}print('>>> Current version:', hello.__version__)"

echo
echo
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
echo ">>> Sleeping for 20s..."
sleep 30s

echo
echo ">>> Install v${_VERSION} via TestPyPI (failure)"
rm -rf hello_world_normanius.egg-info
pip uninstall -y hello_world_normanius
# Check twice, the first time the upload usually isn't available yet.
pip install --index-url https://test.pypi.org/simple/ \
            --no-deps hello_world_normanius==$_VERSION
pip install --index-url https://test.pypi.org/simple/ \
            --no-deps hello_world_normanius==$_VERSION
# python -c "$_CODE"


echo
echo
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
echo ">>> Sleeping for 20s..."
sleep 30s

echo
echo ">>> Install v$_VERSION via TestPyPI (now it works)"
rm -rf hello_world_normanius.egg-info
pip uninstall -y hello_world_normanius
# Check twice, the first time the upload usually isn't available yet.
pip install --index-url https://test.pypi.org/simple/ \
            --no-deps hello_world_normanius==$_VERSION
pip install --index-url https://test.pypi.org/simple/ \
            --no-deps hello_world_normanius==$_VERSION
python -c "$_CODE"

echo
echo
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
python -c "$_CODE"
