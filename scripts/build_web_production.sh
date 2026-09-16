#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
production_env="${script_dir}/.env.production"

if [[ ! -f "$production_env" ]]; then
  printf 'Brakuje %s. Skopiuj .env.production.example i uzupełnij konfigurację.\n' \
    "$production_env" >&2
  exit 1
fi

production_variables=(
  INVENTORY_API_BASE_URL
  BHP_API_BASE_URL
  CORE_API_BASE_URL
)

dart_defines=()

for variable_name in "${production_variables[@]}"; do
  variable_value="$(awk -F= -v key="$variable_name" '$1 == key {sub(/^[^=]*=/, ""); print; exit}' "$production_env")"
  if [[ "$variable_value" != https://* ]]; then
    printf '%s musi zawierać produkcyjny adres HTTPS.\n' "$variable_name" >&2
    exit 1
  fi
  dart_defines+=("--dart-define=${variable_name}=${variable_value}")
done

sentry_dsn="$(awk -F= '$1 == "SENTRY_DSN" {sub(/^[^=]*=/, ""); print; exit}' "$production_env")"
dart_defines+=("--dart-define=SENTRY_DSN=${sentry_dsn}")

cd "$script_dir"
flutter build web \
  --source-maps \
  --no-tree-shake-icons \
  "${dart_defines[@]}"

printf 'Gotowy build produkcyjny: %s\n' "${script_dir}/build/web"
