#!/bin/sh
set -eu

case "${CODE_SIGN_IDENTITY:-}" in
  ''|'-')
    echo 'error: Configure a stable signing identity in Runner/Configs/Signing.local.xcconfig. Unsigned/ad-hoc builds are not supported.' >&2
    exit 1
    ;;
esac
if [ "${CONFIGURATION:-}" = Release ]; then
  case "$CODE_SIGN_IDENTITY" in
    'Developer ID Application'*) ;;
    *)
      echo 'error: Release requires a separate Developer ID Application identity and notarization.' >&2
      exit 1
      ;;
  esac
fi
