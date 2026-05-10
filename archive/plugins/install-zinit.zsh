
function install-zinit() {
  [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
  if [ ! -d $ZINIT_HOME/bin/.git ]; then
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  fi
}
