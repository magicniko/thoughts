#!/usr/bin/env bash
w=EJhR6aBuQgMzyKkLkx4GxJ5cKzuZJ6ZNinA4t87DxYJS
set -x
cd "$(dirname $0)"
f="$(mktemp)"; f1="$(mktemp)"; d="$(mktemp -d)"
trap "rm -rf $f $f1 $d" EXIT
curl -sqLf "https://api-mainnet.magiceden.dev/v2/wallets/${w}/tokens?offset=0&limit=500" > "${f}"
jq .[].image "${f}" -r | sort  -u > "${f1}"
cd "${d}"
<"${f1}" xargs -P8 -I{} wget --quiet --tries=10 --user-agent "gimmemyjpegs-v6.9420" --compression auto --max-redirect 2 {}
for i in *; do md5sum "$i" | awk '{print $1}' | while read MD5; do mv "$i" "$MD5"; done; done
file * | awk '{print $1, $2}' | while read F T; do mv ${F//:/} ${F//:/}.${T}; done
cd - ; cp --no-clobber ${d}/* ./static/images/
