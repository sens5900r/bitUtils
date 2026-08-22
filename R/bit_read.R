#' Load a tabular file by extension
#'
#' Dispatch to [bit_csv()] or [bit_txt()] from the file extension. If `file` is
#' `NULL`, a file dialog is shown for common tabular types.
#'
#' @inheritParams bit_csv
#'
#' @return A data frame, or a named list of data frames, returned invisibly.
#'
#' @examples
#' \dontrun{
#' bit_read()
#' bit_read("data.csv")
#' bit_read("data.txt")
#' }
#'
#' @export
bit_read <- function(file = NULL,
                     envir = .GlobalEnv,
                     assign = TRUE,
                     encoding = "unknown",
                     quiet = FALSE,
                     ...) {
  if (is.null(file)) {
    file <- bit_resolve_files(
      file = NULL,
      filters = matrix(
        c("Tabular files", ".csv .txt .tsv", "CSV files", ".csv", "TXT files", ".txt", "All files", "*"),
        ncol = 2,
        byrow = TRUE
      ),
      caption = gettext("Choose a tabular file")
    )
  }

  ext <- tolower(tools::file_ext(file))
  unknown <- ext[!ext %in% c("csv", "txt", "tsv")]
  if (length(unknown) > 0L) {
    stop(
      "Unsupported file extension: ",
      paste(unique(unknown), collapse = ", "),
      ". Use bit_csv() or bit_txt() directly.",
      call. = FALSE
    )
  }

  csv_files <- file[ext == "csv"]
  txt_files <- file[ext %in% c("txt", "tsv")]

  results <- list()
  if (length(csv_files) > 0L) {
    results <- c(
      results,
      wrap_loaded(bit_csv(
        file = csv_files,
        envir = envir,
        assign = assign,
        encoding = encoding,
        quiet = quiet,
        ...
      ), csv_files)
    )
  }
  if (length(txt_files) > 0L) {
    results <- c(
      results,
      wrap_loaded(bit_txt(
        file = txt_files,
        envir = envir,
        assign = assign,
        encoding = encoding,
        quiet = quiet,
        ...
      ), txt_files)
    )
  }

  if (length(results) == 1L) {
    invisible(results[[1L]])
  } else {
    invisible(results)
  }
}

wrap_loaded <- function(result, files) {
  if (is.data.frame(result) && length(files) == 1L) {
    out <- list(result)
    names(out) <- bit_make_name(files)
    out
  } else {
    as.list(result)
  }
}
