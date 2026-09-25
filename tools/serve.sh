#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
bundle check || bundle install
exec bundle exec jekyll serve --host 0.0.0.0 --livereload --force_polling "$@"
