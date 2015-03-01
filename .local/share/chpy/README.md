# chpy

Minimal chruby clone for Python. Source the scripts and use them to install Pythons and change current versions.

Example:

```shell
chpy_install 2.6.9
chpy 2.6.9
```

Changes are made by manipulating PATH for the current session, changes
are not written to disk.

Currently, there is no argument validation, so if you try to install a
non-existent version of python, curl will barf on you, and if you try
to ```chpy``` to a version of Python not installed, the script will
happily prepend a non-existent path to your PATH.
