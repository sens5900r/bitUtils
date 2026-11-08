#!/usr/bin/env Rscript
# Idempotently install the R packages needed to develop, document, test and run
# the bitUtils package. Runtime dependencies come from DESCRIPTION; the dev
# tooling (devtools/roxygen2/testthat) supports the standard R package workflow.
# gWidgets2tcltk is the concrete toolkit backend that lets gWidgets2 functions
# actually run against Tcl/Tk.

# Binary CRAN repo (Ubuntu 24.04 / noble); also configured in Rprofile.site.
options(repos = c(P3M = "https://packagemanager.posit.co/cran/__linux__/noble/latest"))
options(HTTPUserAgent = sprintf(
  "R/%s R (%s)", getRversion(),
  paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])
))
options(Ncpus = max(1L, parallel::detectCores()))

pkgs <- c(
  # Declared in DESCRIPTION Imports:
  "data.table", "gWidgets2",
  # Toolkit backend so gWidgets2 works with the tcltk GUI (tcltk ships with R).
  "gWidgets2tcltk",
  # Standard R package development tooling.
  "testthat", "roxygen2", "devtools", "remotes"
)

missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) {
  message("Installing: ", paste(missing, collapse = ", "))
  install.packages(missing)
} else {
  message("All required R packages already present; nothing to install.")
}

ok <- vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)
if (!all(ok)) {
  stop("Failed to install: ", paste(pkgs[!ok], collapse = ", "))
}
message("R package dependencies ready: ", paste(pkgs, collapse = ", "))
