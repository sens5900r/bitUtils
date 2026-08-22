# Cloud Agent base image for the bitUtils R package.
#
# Provides R plus the system libraries needed to build/run the package and its
# dependencies (data.table, tcltk, gWidgets2/gWidgets2tcltk) and the standard
# R package dev tooling (devtools/roxygen2/testthat). GUI functions rely on
# Tcl/Tk + X11, so a headless X server (Xvfb) is included and DISPLAY is preset.
#
# Repository-dependent R packages are installed later by the `install` phase
# (see .cursor/install.sh) so they track DESCRIPTION rather than the image.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    DISPLAY=:99

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        # R engine + package build toolchain
        r-base r-base-dev build-essential gfortran \
        # Tcl/Tk for the tcltk / gWidgets2tcltk GUI backends
        tcl tk tcl-dev tk-dev \
        # Headless X server so Tk-based functions run without a physical display
        xvfb xauth x11-utils \
        # System libraries required to build common R package dependencies
        libcurl4-openssl-dev libssl-dev libxml2-dev libgit2-dev \
        libfontconfig1-dev libfreetype6-dev libharfbuzz-dev libfribidi-dev \
        libpng-dev libtiff5-dev libjpeg-dev zlib1g-dev \
        # General tooling
        git curl ca-certificates locales \
    && sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*

# Prefer Posit Public Package Manager binary builds for fast, reproducible
# installs of CRAN packages on Ubuntu 24.04 (noble).
RUN printf '%s\n' \
    'options(repos = c(P3M = "https://packagemanager.posit.co/cran/__linux__/noble/latest"))' \
    'options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))' \
    'options(Ncpus = max(1L, parallel::detectCores()))' \
    >> /usr/lib/R/etc/Rprofile.site

# Let the non-root agent user install R packages into the site library without sudo.
RUN chown -R ubuntu:ubuntu /usr/local/lib/R/site-library

USER ubuntu
