# bitUtils

Utility Functions for Data Loading

## Description

`bitUtils` is an R package that provides utility functions for loading and handling data. It currently includes some functions for interactive selection and loading of .csv and .txt files.

## Features

-   Interactive file selection using `tcltk`
-   Fast loading of data using `fread()` in `data.table`
-   Support for loading multiple files at once with `bit_csv_all()`, `bit_txt_all()`
-   Automatic removal of the Tk dialog box after file loading for a seamless workflow

## Installation

You can install the `bitUtils` package from GitHub using the `devtools` package:

``` r
devtools::install_github("sens5900r/bitUtils")
```

## Usage

The `bit_csv()` function allows you to interactively choose a .csv file and load it into a data frame in the global environment.

``` r
bit_csv() # Show file dialog to select one or more .csv files
bit_txt() # Show file dialog to select one or more .txt files
```

The `bit_csv_all()` function allows you to select a directory and load all the .csv files in that directory into separate data frames in the global environment.

``` r
bit_csv_all() # Show directory dialog to select a directory containing .csv files
bit_txt_all() # Show directory dialog to select a directory containing .txt files
```

## License

This package is licensed under the GPL-3 license.

## Contact

For any questions or feedback, please contact the package maintainer at [shin.jonghwa\@modernity.or.kr](mailto:shin.jonghwa@modernity.or.kr).
