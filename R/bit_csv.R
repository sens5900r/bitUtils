#' Load CSV files
#'
#' Choose one or more CSV files interactively, or pass paths directly, and load
#' them with [data.table::fread()]. By default each table is assigned in
#' `envir` using a sanitized file name, and the data is also returned invisibly
#' so the same call works in scripts.
#'
#' @param file Character vector of file paths. If `NULL` (the default), a file
#'   dialog is shown.
#' @param envir Environment in which to assign the loaded data. Defaults to
#'   the global environment, matching earlier versions of bitUtils.
#' @param assign Logical; assign each table in `envir`? Defaults to `TRUE`.
#' @param encoding Encoding passed to [data.table::fread()]. Use `"UTF-8"` or
#'   `"unknown"` (the default). Korean Windows files that still look wrong after
#'   loading can be repaired with [bit_cp949()].
#' @param quiet Logical; if `TRUE`, do not echo a copy-pasteable `fread()` line.
#' @param ... Additional arguments forwarded to [data.table::fread()].
#'
#' @return A data frame if one file is loaded, otherwise a named list of data
#'   frames. Returned invisibly.
#'
#' @examples
#' \dontrun{
#' bit_csv()
#' df <- bit_csv("data.csv")
#' }
#'
#' @export
bit_csv <- function(file = NULL,
                    envir = .GlobalEnv,
                    assign = TRUE,
                    encoding = "unknown",
                    quiet = FALSE,
                    ...) {
  files <- bit_resolve_files(
    file = file,
    filters = matrix(c("CSV files", ".csv", "All files", "*"), ncol = 2),
    caption = gettext("Choose .CSV files")
  )
  bit_load_files(
    files = files,
    envir = envir,
    do_assign = assign,
    quiet = quiet,
    fread_args = list(encoding = encoding, ...)
  )
}
