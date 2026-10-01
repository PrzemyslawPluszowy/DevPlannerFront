#!/usr/bin/env bash
set -Eeuo pipefail

readonly project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly destination=codex-staging@135.125.200.141
readonly identity="${DEVPLANNER_STAGING_SSH_KEY:-$HOME/.ssh/id_ed25519_codex_devplanner_staging}"
readonly flutter_bin="${FLUTTER_BIN:-flutter}"
readonly revision="$(git -C "$project_dir" rev-parse HEAD)"
readonly remote_archive="devplanner-front-${revision}-web.tar.gz"
readonly ssh_options=(-o BatchMode=yes -o StrictHostKeyChecking=yes -o ConnectTimeout=10 -i "$identity")

if [[ $# -gt 1 || ( $# -eq 1 && "$1" != --no-build ) ]]; then
    echo 'Użycie: deploy_staging_wasm.sh [--no-build]' >&2
    exit 64
fi

ssh "${ssh_options[@]}" "$destination" 'test -w /srv/devplanner/frontend' || {
    echo 'Brak prawa publikacji Frontu. Administrator: sudo chown codex-staging:codex-staging /srv/devplanner/frontend' >&2
    exit 77
}

if [[ $# -eq 0 ]]; then
    (cd "$project_dir" && "$flutter_bin" build web --wasm --no-tree-shake-icons \
        --dart-define=DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl)
fi
test -s "$project_dir/build/web/main.dart.wasm"
test -s "$project_dir/build/web/index.html"
readonly staging_dir="$(mktemp -d)"
trap 'rm -rf "$staging_dir"' EXIT
mkdir "$staging_dir/web"
cp -R "$project_dir/build/web/." "$staging_dir/web/"
# Nginx stagingu rozpoznaje .js, lecz nie ma typu MIME dla .mjs.
# Moduł ES zachowuje treść; zmieniają się nazwa pliku i wskazanie loadera.
mv "$staging_dir/web/main.dart.mjs" "$staging_dir/web/main.dart.wasm.js"
sed 's/main\.dart\.mjs/main.dart.wasm.js/g' \
    "$staging_dir/web/flutter_bootstrap.js" > "$staging_dir/bootstrap.js"
mv "$staging_dir/bootstrap.js" "$staging_dir/web/flutter_bootstrap.js"
sed "s/flutter_bootstrap\.js/flutter_bootstrap.js?release=$revision/g" \
    "$staging_dir/web/index.html" > "$staging_dir/index.html"
mv "$staging_dir/index.html" "$staging_dir/web/index.html"
COPYFILE_DISABLE=1 tar -czf "$staging_dir/$remote_archive" -C "$staging_dir/web" .
readonly checksum="$(shasum -a 256 "$staging_dir/$remote_archive" | awk '{print $1}')"
scp "${ssh_options[@]}" "$staging_dir/$remote_archive" "$destination:$remote_archive"

ssh "${ssh_options[@]}" "$destination" bash -s -- "$revision" "$checksum" "$remote_archive" <<'REMOTE'
set -Eeuo pipefail
readonly revision="$1" checksum="$2" archive="$HOME/$3"
readonly root=/srv/devplanner/frontend
[[ "$revision" =~ ^[0-9a-f]{40}$ && "$checksum" =~ ^[0-9a-f]{64}$ ]]
printf '%s  %s\n' "$checksum" "$archive" | sha256sum --check --status
umask 022
mkdir -p "$root/releases"
readonly release="$root/releases/$revision"
if [[ -e "$release" ]]; then
    echo 'Wersja już istnieje; nie nadpisuję opublikowanego katalogu.' >&2
    exit 65
fi
mkdir "$release"
tar -xzf "$archive" -C "$release"
test -s "$release/main.dart.wasm"
test -s "$release/main.dart.wasm.js"
test -s "$release/index.html"
readonly previous="$(readlink "$root/current" || true)"
ln -s "releases/$revision" "$root/.current-$revision"
mv -Tf "$root/.current-$revision" "$root/current"
if ! curl --fail --silent --show-error --max-time 30 https://devnote.flutter-dev.pl/main.dart.wasm -o /dev/null; then
    if [[ -n "$previous" ]]; then
        ln -s "$previous" "$root/.rollback-$revision"
        mv -Tf "$root/.rollback-$revision" "$root/current"
    else
        rm "$root/current"
    fi
    echo 'Weryfikacja HTTP nie przeszła; przywrócono poprzedni symlink.' >&2
    exit 1
fi
rm "$archive"
echo "Front Wasm opublikowany: $revision"
REMOTE

curl --fail --silent --show-error --max-time 30 https://devnote.flutter-dev.pl/ -o /dev/null
curl --fail --silent --show-error --max-time 30 https://devnote.flutter-dev.pl/workspaces -o /dev/null
