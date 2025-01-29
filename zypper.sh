#!/bin/bash
# set -eu

alias zyp='zyp.sh'
# List biggest rpm-packages on system.

# for openSUSE:
# tumbleweed-cli: Command line interface for interacting with Tumbleweed snapshots.
# https://github.com/boombatower/tumbleweed-cli
# alias tw='tumbleweed'

zypper='sudo zypper'
packets='rust cargo rust-gdb rust-std-static rustfmt'
alias alrust="$zypper addlock $packets" \
      rlrust="$zypper removelock $packets"

packets="'libavdevice*' 'libavfilter*' 'libavformat*'  'libavresample*' 'libavutil*'"
alias alpackman="$zypper addlock $packets" \
      rlpackman="$zypper removelock $packets"

packets="chromium 'kernel*' 'libreoffice*' 'libvirt*' pandoc oxygen5-icon-theme 'qemu*' 'virt*'"
alias zypper='$zypper' \
      addlocks="zypper addlock $packets" \
      rmlocks="$zypper removelock $packets" \
      addlock='$zypper addlock' \
      rmlock='$zypper removelock' \
      al="$zypper addlock" \
      rl="$zypper removelock" \
      locks='zypper locks' \
      cleanlocks='zypper cleanlocks'
alias ref='zypper refresh'
alias lu='$zypper list-updates'
  # If using KDE, refresh the pkcon Update Status icon after update.
# if [[ $XDG_SESSION_DESKTOP == KDE ]]; then
#   up() {
#     $zypper update "$@" --auto-agree-with-licenses --no-recommends && pkcon refresh
#   }
#   dup() {
#     $zypper dist-upgrade "$@" --auto-agree-with-licenses --no-recommends && pkcon refresh
#   }
# else
  function up() {
    $zypper update "$@" --auto-agree-with-licenses --no-recommends
  }
  function dup() {
    $zypper dist-upgrade "$@" --auto-agree-with-licenses --no-recommends
  }
# fi
alias pac="$zypper packages" \
      se="zypper search"    \
      inf="zypper info"     \
      ins="$zypper install"  \
      rem="$zypper remove --clean-deps" \
      clean="$zypper clean"
# Repot
alias lr='zypper repos --sort-by-priority' \
      ar="$zypper addrepo" \
      mr="$zypper modifyrepo" \
      nr="$zypper renamerepo" \
      rr="$zypper removerepo" \
      inr="$zypper install-new-recommends"
alias zyplog="$zypper-log"
# elif [[ -x `which aptitude` ]]; then
#   alias ins='sudo aptitude install'
#   alias se='aptitude search'
#   alias inf='aptitude show'
#   alias up='sudo apt-get upgrade'
#   alias ref='sudo apt-get update'

whypkg() {
    if zypper packages --orphaned | grep "| $1 " > /dev/null; then
        echo "Package $1 is orphaned"
        return
    fi
    zargs="zypper se -x -v"
    $zargs --requires --recommends --suggests $1 || \
    $zargs --requires-pkg $1 || \
    $zargs --recommends-pkg $1 || \
    $zargs --suggests-pkg $1
}
