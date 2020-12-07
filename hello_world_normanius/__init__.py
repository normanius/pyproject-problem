try:
    from importlib.metadata import metadata as _meta
except ModuleNotFoundError:
    from importlib_metadata import metadata as _meta

__version__ = _meta("hello_world_normanius")["version"]
__author__ = _meta("hello_world_normanius")["author"]

def hello_world():
    print("Hello world!")

