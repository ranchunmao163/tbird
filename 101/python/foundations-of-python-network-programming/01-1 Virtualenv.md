
# Virtualenv

https://pypi.org/project/virtualenv/

## Documentation

https://virtualenv.pypa.io/en/latest/

- what? virtualenv is a tool to create isolated Python environments.
- what's the difference between 'virtualenv' and 'venv module'?
- why do we need 'virtualenv'?
- how? virtualenv creates an environment that has its own installation directories, that doesn't share libraries with other virtualenv environments (and optionally doesn't access the globally installed libraries either.)

## Installation

[?] what's the difference between pipx and pip?


## User Guide

### Quick start


Create the environment (creates a folder in your current directory)
```
virtualenv env_name
```

In Linux or Mac, activate the new python environment
```
source env_name/bin/activate
```

Confirm that the env is successfully selected
```
which python3
```

### Introduction

```shell
virtualenv venv
```

- Basic command
  - works in two phases
    - phase 1: discovers a python interpreter to create a virtual environment from (by default this is the same python as the one "virtualenv" is running from, however we can change this via the "p" option).
    - phase 2: creates a virtual environment at the specified destination (dest), this can be broken down into four further sub-steps:
      - 2.1 create a python that matches the target python interpreter from phase 1
      - 2.2 install (bootstrap) seed packages (one or more of pip, setuptools, wheel) in the created environment
      - 2.3 install activation scripts into the binary directory of the virtual environment (these will allow end users to activate the virtual environment from various shells)
      - 2.4 create files that mark the virtual environment as to be ignored by version control systems (currently we support Git only, as Mercurial, Bazaar or SVN do not supprot ignore files in subdirectories). This step can be skipped with the "no-vcs-ignore" option.

### Python discovery

- The first thing we need to be able to create a virtual environment is a python interpreter.
  - This will describe to the tool what type of virtual environment you would like to create, think of it as: version, architecture, implementation.
- "virtualenv" being a python application has always at least one such available, the one "virtualenv" itself is using, and as such this is the default discovered element.
  - This means that if you install "virtualenv" under python 3.8, virtualenv will by default create virtual environments that are also version 3.8.
- Created python virtual environments are usually not self-contained.
  - A complete python packaging is usually made up of thousands of files, so it's not efficient to install the entire python again into a new folder.
  - Instead virtual environments are mere shells, that contain little within themselves, and borrow most from the system python (this is what you installed, when you installed python itself).
    - **This does mean that if you upgrade your system python your virtual environments might break, so watch out.**
      - The upside of this, referring to the system python, is that creating virtual environments can be fast.
      - Warning:
        - As detailed above, virtual environments usually just borrow things from the system Python, they don't actually contain all the data from the system Python.
          - The version of the python executable is hardcoded within the python exe itself.
          - **Therefore, if you upgrade your system Python, your virtual environment will still report the version before the upgrade, even though now other than the executable all additional content(standrd library, binary libs, etc) are of the new version** [?] what does it mean?
        - Barring any major incompatibilities (rarely the case) the virtual environment will continue working, but other than the content embedded within the python executable it will behave like the upgraded version.
          - **If such a virtual environent python is specified as the target python interpreter, we will create virtual environments that match the new system python version, not the version reported by the virtual environment.** [?] what does it mean?
- Here we'll describe the built-in mechanism (note this can be extended though by plugins).
  - The CLI flag "p" or "python" allows you to specify a python specifier for what type of virtual environment you would like, the format is either:
    - a relative/absolute path to a Python interpreter
    - a specifier identifying the Python implementation, version, architecture in the following format:
```
{python implementation name}{version}{architecture}

[?] what's the difference between python, cpython, and pypy?
```

### Creators

- "virtualenv" at the moment has two types of virtual environments:
  - "venv"
  - "builtin"
- CLI interface "creator": https://virtualenv.pypa.io/en/latest/cli_interface.html#creator

### Seeders

- There are two main mechanisms available:
  - pip
  - app-data
    - This method uses the **user application data** directory to create install images.
    - These images are needed to **be created only once**, and subsequent virtual environment can just link/copy those images into their pure python library path (**the "site-packages" folder**).
      - This allows all but the first virtual environment creation to be blazing fast (a "pip" mechanism takes usually 98% of the virtualenv creation time, so by creating this install image that we can just link into the virtual environments install directory we can achieve speedups of shaving the initial 1 mimute and 10 seconds down to just 8 seconds in case of a copy, or 0.8 seconds in case symlinks are available - this is on Windows, Linux/macOS with symlinks this can be as low as 100ms from 3+ seconds).
      - **To override the filesystem location of the seed cache, one can use the VIRTUALENV_OVERRIDE_APP_DATA environment variable.**

#### Wheels

- To install a seed package via either "pip" or "app-data" method virtualenv needs to acquire a wheel of the target package.
- These wheels may be acquired from multiple locations as follows:
  - embedded wheels. "virtualenv" ships out of box with a set of embed "wheels" for all three seed packages ("pip", "setuptools", "wheel").
  - upgraded embedded wheels.
  - extra search dir.

#### Embed wheels for distributions

### Activators

- These are activation scripts that will mangle with your shell's settings to ensure that commands from within the python virtual environment take priority over your system paths.
  - Note, though that all we do is to change priority; so, if your virtual environments "bin/Scripts" folder does not contain some executable, this will still resolve to the same executable it would have resolved before the activation.
- For a list of shells we provide activators see [activators](https://virtualenv.pypa.io/en/latest/cli_interface.html#activators)
- The activate script prepends the virtual environment's binary folder onto the "PATH" environment variable.
  - It's really just convenience for doing so, since you could do the same yourself.
  - Note that you don't have to activate a virtual environment to use it. You can instead use the full paths to its executables, rather than relying on your shell to resolve them to your virtual environment.
- Activator scripts also modify your shell prompt to indicate which environment is currently active, by prepending the environment name (or the name specified by "--prompt" when initially creating the environment) in brackets, like "(venv)"

```shell
source venv/bin/activate
```

---

[Exteneded reading: there is no magic - virtualenv edition](https://www.recurse.com/blog/14-there-is-no-magic-virtualenv-edition)


```shell
source bin/activate
```
- "source bin/activate"
  - "source" is a bash command that runs a file, the same way you'd use "import" to run your python module.
  - **"source" runs the file provided in your current shell, not in a subshell.**
    - Thus it keeps the variables it creates or modifies around after the file is done executing.
    - Since (almost) all that virtualenv does is to modify environmental variables, this matters.
  - Running a bash file directly (e.g., calling "activate" from "bin/" runs the script in a subshell), it will NOT be able to modify the current shell's environmental variables.


```shell
# unset irrelevant variables
deactivate nondestructive

VIRTUAL_ENV='/Users/chran/Documents/GitHub/tbird/101/python/foundations-of-python-network-programming/networks-programming'
if ([ "$OSTYPE" = "cygwin" ] || [ "$OSTYPE" = "msys" ]) && $(command -v cygpath &> /dev/null) ; then
    VIRTUAL_ENV=$(cygpath -u "$VIRTUAL_ENV")
fi
export VIRTUAL_ENV

_OLD_VIRTUAL_PATH="$PATH"
PATH="$VIRTUAL_ENV/bin:$PATH"
export PATH
```
- **It is the meat of the activate file.**
  - "deactivate" ensures that any existing virtual environment is deactivated before a new one is created. Virtual environments are separated from each other, they can't be nested.
  - "export" exports a variable into your current environment.
    - It also ensures that environmental variables in processes spawned from the current one get the same values.
    - **Since we're running the file via "source", the effect is to set variables and then keep them after the activate script finishes running.**
  - So the activate script does three primary things:
    - 1. Sets a VIRTUAL_ENV bash environmental variable containing the virtual environment directory.
    - 2. Prepends that directory to your PATH.
    - 3. Sets the new PATH.
      - What is PATH? The PATH is an environmental variable representing a list of directories. Your system will look for programs and scripts in the order that directories are listed. The list is separated by colons.

- Notice that "activate" also modifies the bash prompt (PS1). The important point is that the code stores the old PS1 and inserts the name of the virtualenv into the new one.
- "deactivate"
  - "deactivate" calls "export" to restore the old environmental variables, then calls "unset" to remove unneeded variables from the environment.
    - We can verify this from the terminal by using the command "env" to view all your environmental variables.
  - Finally, deactivate calls "unset -f deactivate" to remove the "deactivate" function itself (-f removes a function). The function is now gone from the environment.
- Fun scripts
  - "source" is the same as the dot operator.
  - 

---

### Programmatic API

- At the moment "virtualenv" offers only CLI level interface.
- If you want to trigger invocation of Python environments from within Python you should be using the "virtualenv.cli_run" method; this takes an "args" argument where you can pass the options the same way you would from the command line.
- The run will return a session object containing data about the created virtual environment.

```python
from virtualenv import cli_run

cli_run(["venv])
```

## CLI interface

### CLI flags

- All options have sensible defaults, and there's one required argument: the name/path of the virtual environment to create.
- The default values for the command line options can be overridden via the Configuration file or Environment Variables.
  - Environment variables takes priority over the configuration file values.
    - "--help" will show if a default comes from the environment variables as the help message will end in this case with environment variables or the configuration file.





[?] read useful links



