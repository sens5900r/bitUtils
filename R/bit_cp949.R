#' Convert CP949 (or another encoding) to UTF-8
#'
#' Convert character columns and column names of a data frame. Pass a data
#' frame or the name of an object; if `x` is omitted, a GUI lists data frames
#' in the global environment.
#'
#' @param x A data frame, the name of a data frame in `envir`, or `NULL` to
#'   choose interactively.
#' @param from Source encoding. Defaults to `"cp949"` for Korean Windows files.
#' @param to Target encoding. Defaults to `"utf-8"`.
#' @param envir Environment used when `x` is a name, and when the GUI rewrites
#'   the chosen object. Defaults to the global environment.
#'
#' @return The converted data frame, invisibly. When `x` is a name or chosen in
#'   the GUI, the object in `envir` is replaced as well.
#'
#' @examples
#' df <- data.frame(a = "x", stringsAsFactors = FALSE)
#' identical(bit_cp949(df, from = "UTF-8", to = "UTF-8")$a, "x")
#'
#' \dontrun{
#' bit_cp949()
#' bit_cp949("df")
#' }
#'
#' @export
bit_cp949 <- function(x = NULL, from = "cp949", to = "utf-8", envir = .GlobalEnv) {
  if (is.null(x)) {
    return(bit_cp949_gui(from = from, to = to, envir = envir))
  }

  if (is.character(x) && length(x) == 1L) {
    if (!exists(x, envir = envir, inherits = FALSE)) {
      stop(gettextf("Object '%s' was not found.", x), call. = FALSE)
    }
    df <- get(x, envir = envir, inherits = FALSE)
    converted <- bit_convert_encoding(df, from = from, to = to)
    assign(x, converted, envir = envir)
    return(invisible(converted))
  }

  if (is.data.frame(x)) {
    return(invisible(bit_convert_encoding(x, from = from, to = to)))
  }

  stop("`x` must be a data frame, a length-1 character name, or NULL.", call. = FALSE)
}

bit_cp949_gui <- function(from, to, envir) {
  if (!requireNamespace("gWidgets2", quietly = TRUE)) {
    stop("The gWidgets2 package is required for the interactive chooser. Pass a data frame instead.", call. = FALSE)
  }
  if (!bit_is_interactive()) {
    stop("bit_cp949() needs a data frame (or name) in a non-interactive session.", call. = FALSE)
  }

  all_objects <- ls(envir = envir)
  data_frames <- all_objects[vapply(all_objects, function(nm) is.data.frame(get(nm, envir = envir, inherits = FALSE)), logical(1L))]
  if (length(data_frames) == 0L) {
    stop("No data frames were found in the target environment.", call. = FALSE)
  }

  win <- gWidgets2::gwindow("Choose a dataframe", width = 280)
  group <- gWidgets2::ggroup(cont = win, horizontal = FALSE)
  gWidgets2::glabel("Click here to see the list of dataframes:", cont = group)
  listbox <- gWidgets2::gcombobox(data_frames, cont = group, editable = FALSE)

  gWidgets2::addHandlerChanged(listbox, handler = function(h, ...) {
    dataframe_name <- gWidgets2::svalue(h$obj)
    df <- get(dataframe_name, envir = envir, inherits = FALSE)
    converted <- bit_convert_encoding(df, from = from, to = to)
    assign(dataframe_name, converted, envir = envir)
    gWidgets2::gmessage(
      paste("The encoding of dataframe", dataframe_name, "has been converted to", to, "."),
      parent = win
    )
    gWidgets2::dispose(win)
  })

  gWidgets2::visible(win) <- TRUE
  invisible(NULL)
}
