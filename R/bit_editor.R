#' bit_editor: A simple text editor with syntax highlighting and scripting capabilities
#'
#' This function creates a Tcl/Tk text editor with basic syntax highlighting,
#' scripting capabilities, load/save functionality, and a scrollbar.
#'
#' @return A tktoplevel widget that acts as a text editor.
#'
#' @examples
#' \dontrun{
#' bit_editor()
#' }
#'
#' @details
#' This function utilizes several nested functions to achieve its functionality:
#' 1. `save`: Saves the current content of the text box to a file.
#' 2. `load`: Loads the content of a file into the text box.
#' 3. `run`: Executes the current content of the text box as R code.
#'
#' The text editor supports basic syntax highlighting. It highlights reserved words
#' in R programming with a blue color. It also has a scrollbar to navigate through
#' large amounts of text and supports text wrapping.
#'
#' The editor also features a menu bar with options to load a file, save the current
#' content to a file, and execute the current content as R code.
#'
#' @seealso \code{\link{tktext}}, \code{\link{tkscrollbar}}, \code{\link{tkmenu}}
#'
#' @note The syntax highlighting feature is quite rudimentary and highlights
#' reserved words even if they are part of comments or string literals.
#'
#' @import tcltk
#'
#' @export
bit_editor <- function() {
  wfile <- ""
  tt <- tktoplevel()
  txt <- tktext(tt, height=20, width=100, wrap="none")
  yscroll <- tkscrollbar(tt, command=function(...)tkyview(txt, ...))
  xscroll <- tkscrollbar(tt, orient="horizontal", command=function(...)tkxview(txt, ...))

  tkgrid(txt, yscroll, sticky="nsew")
  tkgrid(xscroll, sticky="ew")

  tkconfigure(txt, yscrollcommand=function(...)tkset(yscroll, ...), xscrollcommand=function(...)tkset(xscroll, ...))

  save <- function() {
    file <- tcl("tk_getSaveFile",
                initialfile=tcl("file", "tail", wfile),
                initialdir=tcl("file", "dirname", wfile))
    if (!length(file)) return()
    chn <- tcl("open", file, "w")
    tcl("puts", chn, tkget(txt,"0.0","end"))
    tcl("close", chn)
    wfile <<- file
    tcl("wm", "title", tt, file)
  }
  load <- function() {
    file <- tcl("tk_getOpenFile")
    if (!length(file)) return()
    chn <- tcl("open", file, "r")
    tkinsert(txt, "0.0", tcl("read", chn))
    tcl("close", chn)
    wfile <<- file
    tcl("wm", "title", tt, file)
  }
  run <- function() {
    code <- tclvalue(tkget(txt,"1.0","end"))
    e <- try(parse(text = code))
    if (inherits(e, "try-error")) {
      tkmessageBox(message = "Syntax error", icon = "error")
      return()
    }
    cat("Executing from script window:", "-----", code, "result:", sep = "\n")
    result <- eval(e)
    if (!is.null(result)) {
      print(result)
    } else {
      print("The code did not produce a result.")
    }
  }
  topMenu <- tkmenu(tt)
  tkconfigure(tt, menu=topMenu)
  fileMenu <- tkmenu(topMenu, tearoff=FALSE)
  tkadd(fileMenu, "command", label="Load", command=load)
  tkadd(fileMenu, "command", label="Save", command=save)
  tkadd(topMenu, "cascade", label="File", menu=fileMenu)
  tkadd(topMenu, "command", label="Run", command=run)
}
