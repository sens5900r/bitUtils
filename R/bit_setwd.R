#' Set the working directory
#'
#' Choose a directory interactively, or pass one directly, then set it as the
#' working directory.
#'
#' @param dir Directory path. If `NULL` (the default), a directory dialog is
#'   shown.
#'
#' @return The new working directory, invisibly.
#'
#' @examples
#' \dontrun{
#' bit_setwd()
#' bit_setwd("C:/data")
#' }
#'
#' @seealso [base::setwd()]
#'
#' @export
bit_setwd <- function(dir = NULL) {
  chosen_dir <- bit_resolve_dir(dir)
  setwd(chosen_dir)
  message("Working directory has been changed to: ", chosen_dir)
  message("You can also change the working directory manually using: setwd(\"",
          normalizePath(chosen_dir, winslash = "/", mustWork = FALSE), "\")")
  invisible(getwd())
}
