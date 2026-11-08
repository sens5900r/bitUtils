#' Load tab-delimited TXT files
#'
#' Choose one or more TXT files interactively, or pass paths directly, and load
#' them with [data.table::fread()] using tab separators by default.
#'
#' @inheritParams bit_csv
#' @param sep Field separator passed to [data.table::fread()]. Defaults to tab.
#' @param quote Quoting characters. Defaults to `""` so embedded quotes are
#'   left as-is, which is typical for Korean TSV exports.
#'
#' @return A data frame if one file is loaded, otherwise a named list of data
#'   frames. Returned invisibly.
#'
#' @examples
#' \dontrun{
#' bit_txt()
#' df <- bit_txt("data.txt")
#' }
#'
#' @export
bit_txt <- function(file = NULL,
                    envir = .GlobalEnv,
                    assign = TRUE,
                    encoding = "unknown",
                    quiet = FALSE,
                    sep = "\t",
                    quote = "",
                    ...) {
  files <- bit_resolve_files(
    file = file,
    filters = matrix(c("TXT files", ".txt", "All files", "*"), ncol = 2),
    caption = gettext("Choose .TXT files")
  )
  bit_load_files(
    files = files,
    envir = envir,
    do_assign = assign,
    quiet = quiet,
    fread_args = list(sep = sep, quote = quote, encoding = encoding, ...)
  )
}
