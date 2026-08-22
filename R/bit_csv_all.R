#' Load all CSV files in a directory
#'
#' Choose a directory interactively, or pass one directly, and load every
#' `.csv` file in that directory.
#'
#' @param dir Directory path. If `NULL` (the default), a directory dialog is
#'   shown.
#' @inheritParams bit_csv
#' @param notify Logical; if `TRUE` and a GUI is available, show a completion
#'   message box. Defaults to `FALSE` so scripts are not blocked.
#'
#' @return A named list of data frames, or a single data frame if the directory
#'   contains one matching file. Returned invisibly.
#'
#' @examples
#' \dontrun{
#' bit_csv_all()
#' bit_csv_all("C:/data")
#' }
#'
#' @export
bit_csv_all <- function(dir = NULL,
                        envir = .GlobalEnv,
                        assign = TRUE,
                        encoding = "unknown",
                        quiet = FALSE,
                        notify = FALSE,
                        ...) {
  bit_load_dir(
    dir = dir,
    pattern = "\\.csv$",
    envir = envir,
    do_assign = assign,
    quiet = quiet,
    notify = notify,
    fread_args = list(encoding = encoding, ...),
    label = ".csv"
  )
}
