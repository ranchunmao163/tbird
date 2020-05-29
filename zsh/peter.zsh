set -o vi

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_231.jdk/Contents/Home"
export PATH="${JAVA_HOME}:${PATH}"

export MAVEN_HOME="/Users/chran/bin/maven/latest"
export PATH="${MAVEN_HOME}/bin:${PATH}"

# fix makeinfo version issue
export PATH="/usr/local/opt/texinfo/bin:$PATH"

# fix autopoint and gettext command can't be found issue
export PATH="/usr/local/opt/gettext/bin:$PATH"

# Go
export GOPATH="${HOME}/go"
export PATH="${PATH}:${GOPATH}/bin"

# Ant
export ANT_HOME="${HOME}/bin/ant/latest"
export PATH="${PATH}:${ANT_HOME}/bin"

# https://computingforgeeks.com/how-to-configure-zsh-syntax-highlighting-on-linux-macos/
# mkdir ~/.scripts
# cd ~/.scripts
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
source ~/.scripts/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

