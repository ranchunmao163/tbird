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
