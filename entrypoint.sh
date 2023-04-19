#! /bin/bash

set -x


PREV_TARGET=

function set_output() {
  printf "%s=%s\n" "$1" "$2" >> "$GITHUB_OUTPUT"
}

function cleanup() {
    mv target deb-target
    test -n "$PREV_TARGET" && mv "$PREV_TARGET" target
    true
}

function process_variant() {
    local _args _outp
    _args="deb"
    [ "$1" != "default" ] && _args="$_args --variant $1"
    [ -n "$INPUT_DEBVERSION" ] && _args="$_args --deb-version $INPUT_DEBVERSION"
    echo "cargo $_args" >&2
    if test -z "$INPUT_SUBDIR"; then
    	_outp="$(cargo $_args | tail -1)"
    else
	_outp="$( (cd "$INPUT_SUBDIR" && cargo $_args | tail -1) )"
    fi

    if [ -n "$INPUT_PKGNAME" ] && [ -n "$INPUT_DEBVERSION" ]; then
      if [ "$1" = "default" ]; then
        set_output "deb" "deb-${_outp#$PWD/}"
      else
        set_output "deb_$1" "deb-${_outp#$PWD/}"
      fi
    fi
}

function main() {
    local _var
    cd "$GITHUB_WORKSPACE" || return 1
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
