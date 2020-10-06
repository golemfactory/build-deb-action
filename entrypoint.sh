#! /bin/bash

set -x


PREV_TARGET=

function set_output() {
  printf "::set-output name=%s::%s\n" "$1" "$2"
}

function cleanup() {
    mv target deb-target
    test -n "$PREV_TARGET" && mv "$PREV_TARGET" target
    true
}

function process_variant() {
    local _args
    _args="deb"
    [ "$1" != "default" ] && _args="$_args --variant $1"
    [ -n "$INPUT_DEBVERSION" ] && _args="$_args --deb-version $INPUT_DEBVERSION"
    echo "cargo $_args" >&2
    cargo $_args
    if [ -n "$INPUT_PKGNAME" ] && [ -n "$INPUT_DEBVERSION" ]; then
      if [ "$1" = "default" ]; then
        set_output "deb" "deb-target/debian/${INPUT_PKGNAME}_${INPUT_DEBVERSION}_amd64.deb"
      else
        set_output "deb.$1" "deb-target/debian/${INPUT_PKGNAME}-$1_${INPUT_DEBVERSION}_amd64.deb"
      fi
    fi
}

function main() {
    local _var
    cd "$GITHUB_WORKSPACE"
    rustup default stable

    if test -d ./target; then
      mv target prev-target
      PREV_TARGET=prev-target
    fi
    test -d deb-target && mv deb-target target

    for _var in $INPUT_VARIANTS; do
      process_variant "$_var" || {
        local _rv
        _rv=$?
        cleanup
        return $_rv
      }

    done

    cleanup
}

main || exit $?
