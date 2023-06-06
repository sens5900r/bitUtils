#' @title Set Working Directory Interactively
#'
#' @description This function provides a GUI for selecting a working directory.
#'
#' @details The function uses tcltk::tkchooseDirectory() to let the user choose a directory from their file system. After a directory is chosen, the function changes the working directory to the chosen directory and prints a message with the new directory and the corresponding setwd() code.
#'
#' @usage bit_setwd()
#'
#' @return This function returns no value. It changes the working directory to the user-selected directory in-place.
#'
#' @note This function requires the tcltk package.
#'
#' @seealso \code{\link[base]{setwd}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  # Run the function
#'  bit_setwd()
#' }
#' @import tcltk
bit_setwd <- function() {
  if (!("tcltk" %in% .packages(all.available = TRUE))) {
    stop("tcltk package is not loaded. Please install and load the package before running this function.")
  }

  chosen_dir <- tcltk::tkchooseDirectory()
  chosen_dir <- tcltk::tclvalue(chosen_dir)

  if (chosen_dir != "") {
    setwd(chosen_dir)
    message(paste("Working directory has been changed to:", chosen_dir))
    message(paste("You can also change the working directory manually using: setwd('", chosen_dir, "')", sep=""))
  } else {
    message("No directory selected. Working directory has not been changed.")
  }
}
