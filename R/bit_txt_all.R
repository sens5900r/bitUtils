#' Load all TXT files in a directory
#'
#' Choose a directory interactively, or pass one directly, and load every
#' `.txt` file in that directory as tab-delimited data.
#'
#' @inheritParams bit_csv_all
#' @param sep Field separator passed to [data.table::fread()]. Defaults to tab.
#' @param quote Quoting characters. Defaults to `""`.
#'
#' @return A named list of data frames, or a single data frame if the directory
#'   contains one matching file. Returned invisibly.
#'
#' @examples
#' \dontrun{
#' bit_txt_all()
#' bit_txt_all("C:/data")
#' }
#'
#' @export
bit_txt_all <- function(dir = NULL,
                        envir = .GlobalEnv,
                        assign = TRUE,
                        encoding = "unknown",
                        quiet = FALSE,
                        notify = FALSE,
                        sep = "\t",
                        quote = "",
                        ...) {
  bit_load_dir(
    dir = dir,
    pattern = "\\.txt$",
    envir = envir,
    do_assign = assign,
    quiet = quiet,
    notify = notify,
    fread_args = list(sep = sep, quote = quote, encoding = encoding, ...),
    label = ".txt"
  )
}
