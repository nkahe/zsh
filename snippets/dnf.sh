if ! command -v dnf &>/dev/null; then
  return
fi

# shortcut "~repos"
if [ "$ZSH_NAME" ]; then
  if [[ -d /etc/yum.repos.d ]]; then
    hash -d repos=/etc/yum.repos.d
  fi
fi

alias copr="sudo dnf copr"    \
      cu="dnf check-upgrade"  \
      inf="dnf info"          \
      ins="sudo dnf install"  \
      list="dnf list --exclude '*i686'"  \
      lu="dnf check-update"   \
      rem="sudo dnf remove"   \
      se="dnf search --exclude '*i686'"  \
      up="sudo dnf upgrade"   \
      upgrade="sudo dnf upgrade"

whyfile() {
  package=$(rpm -qf $1 --qf "%{NAME}")
  ret=$?
  echo -e "Installed by package: $package\n"
  (( $ret == 0 )) || return
  dnf info $package
  #whypkg $package
}

whycmd() {
  file=$(which $1)
  (($? == 0)) || return
  whyfile $file
}

whypkg() {
  if dnf repoquery --unneeded | grep -w "$1" > /dev/null; then
    echo "Package $1 is orphaned"
  fi

  # Check what depends on the package
  echo "These depend on that:"
  dnf repoquery --whatdepends $1 || \

  # Check what provides the package
  echo "Providers by:"
  dnf repoquery --whatprovides $1
}

pkgchg() {
  rpm -q --changelog $1 | less
}
