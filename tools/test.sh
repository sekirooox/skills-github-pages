#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
baseurl="$(bundle exec ruby -ryaml -e 'puts YAML.load_file("_config.yml").fetch("baseurl")')"
JEKYLL_ENV=production bundle exec jekyll build --destination "_site${baseurl}"
bundle exec htmlproofer _site --disable-external
