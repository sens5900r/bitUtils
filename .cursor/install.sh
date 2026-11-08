#!/usr/bin/env bash
# Cloud Agent install phase for bitUtils.
#
# Idempotent: installs the R package dependencies and dev tooling, then installs
# bitUtils' own dependencies from DESCRIPTION. Safe to run repeatedly.
set -euo pipefail

cd "$(dirname "$0")/.."

echo "== Installing R package dependencies and dev tooling =="
Rscript .cursor/install-packages.R

echo "== Installing bitUtils dependencies from DESCRIPTION =="
Rscript -e 'remotes::install_deps(".", dependencies = TRUE, upgrade = "never")'

echo "== Install complete =="
