# bitUtils

Utility functions for loading and handling tabular data in R.

Version 0.2.1 keeps the original Tcl/Tk dialogs, and the same functions also
accept file paths so they can be used in scripts and tests.

## Features

- Interactive file and directory selection with `tcltk`
- Fast loading with `data.table::fread()`
- Path-based loading for `bit_csv()`, `bit_txt()`, `bit_csv_all()`, `bit_txt_all()`
- `bit_read()` chooses CSV or TXT from the file extension
- Invisible return values in addition to assigning in an environment
- `bit_cp949()` for Korean Windows encodings, with or without a GUI
- `bit_setwd()` to choose or set the working directory
- `bit_editor()`, a small Tcl/Tk script window (Load / Save / Run)

## Installation

Install the development version from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("sens5900r/bitUtils")
```

## Usage

Interactive dialogs (unchanged from 0.1.x):

``` r
library(bitUtils)

bit_csv()      # choose one or more .csv files
bit_txt()      # choose one or more .txt files
bit_csv_all()  # choose a directory of .csv files
bit_txt_all()  # choose a directory of .txt files
bit_setwd()    # choose a working directory
```

The same functions accept paths. Tables are assigned by sanitized file name
and also returned, so either style works:

``` r
df <- bit_csv("data.csv")
bit_csv_all("C:/data")
bit_read("data.txt")

e <- new.env()
bit_csv("data.csv", envir = e, quiet = TRUE)
```

Repair Korean Windows encodings after loading:

``` r
bit_cp949(df)
bit_cp949("df")   # convert an object already in the global environment
# bit_cp949()     # interactive chooser (needs gWidgets2)
```

## License

GPL-3

## Contact

Maintainer: SHIN Jong-Hwa, [shin.jonghwa@modernity.or.kr](mailto:shin.jonghwa@modernity.or.kr)
