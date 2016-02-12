# setup

## zshell

### on-my-zsh configuration

#### installation(go to the home directory)
```
redhat linux:
  sudo yum install zsh
unbuntu linux:
  sudo apt-get install zsh
mac
  sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

#### configure after the installation
```
  change shell setting:
  chsh -s /bin/zsh
```

#### my profile configuration
```
add the following items into ~/.zshrc:

set -o vi
# personal hobby
export TBIRD_HOME=${HOME}/IdeaProjects/tbird
source ${TBIRD_HOME}/conf/unix/zshrc.local

# edit ~/.zshrc file to add more plugins for the plugins entry
# execute "ll ~/.oh-my-zsh/plugins" to get the full plugin list
```

#### reference
..* github: https://github.com/robbyrussell/oh-my-zsh


# hive

- met the error while launching the hive command from the cli, refer the [link](http://stackoverflow.com/questions/28997441/hive-startup-error-terminal-initialization-failed-falling-back-to-unsupporte) for details
```
it is fixed by configurating the following environment parameter.
export HADOOP_USER_CLASSPATH_FIRST=true
```

# profile

## zshell

- add softlink .zshrc.local under the home directory to point the zshrc.local file
- edit '.zshrc' to source the personal profile
```
source ~/.zshrc.local
source ~/.zshrc.secret
```

# notes

- .zshrc.secret has a copy in the evernote

# reference

- [tbird git repository](https://github.com/ranchunmao/tbird)
- [markdown reference](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [hive wiki page](https://cwiki.apache.org/confluence/display/Hive/GettingStarted)
