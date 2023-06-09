#' @title Load a CSV file using a dialog
#'
#' @description This function allows the user to choose a CSV file from their file system and
#' then loads that file into a data frame in the global environment.
#'
#' @param file A character string specifying the path to the CSV file to load.
#'   If NULL (the default), a file dialog will be shown.
#'
#' @return NULL. This function is called for its side effect of loading a data frame into the global environment.
#'
#' @export
bit_csv <- function(file = NULL) {
  if (is.null(file)) {
    filenames <- tcltk::tk_choose.files(filters = matrix(c("CSV files", ".csv"), ncol = 2), caption = gettext("Choose .CSV files"))
    if (length(filenames) == 0) {
      stop(gettext("No file was selected."))
    }
  } else {
    if (!file.exists(file)) {
      stop(gettextf("The file %s does not exist.", file))
    }
    filenames <- file
  }
  for (file in filenames) {
    data <- data.table::fread(file, data.table = FALSE)
    name <- tools::file_path_sans_ext(basename(file))
    assign(name, data, envir = .GlobalEnv)

    # Print the object name and the file name
    cat(sprintf("%s <- data.table::fread('%s', data.table=FALSE)\n", name, file))
  }
}
