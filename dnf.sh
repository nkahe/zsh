alias copr="sudo dnf5 copr"    \
      inf="dnf5 info"      \
      ins="sudo dnf5 install"  \
      list="dnf5 list --exclude '*i686'"  \
      lu="dnf5 check-update" \
      rem="sudo dnf5 remove"   \
      se="dnf5 search --exclude '*i686'"  \
      up="sudo dnf5 upgrade"


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
        return
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
