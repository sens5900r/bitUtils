#' A simple Tcl/Tk script editor
#'
#' Open a small editor with load/save, Run, and basic R keyword highlighting.
#' Code is evaluated in the global environment, so objects created with
#' [bit_csv()] remain visible to scripts you run from the window.
#'
#' @return A `tktoplevel` widget. The function is called for its side effect.
#'
#' @examples
#' \dontrun{
#' bit_editor()
#' }
#'
#' @details
#' The File menu loads and saves the buffer. Run parses the buffer and
#' evaluates it in `.GlobalEnv`. Highlighting marks R reserved words; it does
#' not parse comments or string literals, so a keyword inside a comment may
#' still be coloured.
#'
#' Keyboard shortcuts: Ctrl+O load, Ctrl+S save, Ctrl+R run.
#'
#' @export
bit_editor <- function() {
  wfile <- ""
  tt <- tcltk::tktoplevel()
  tcltk::tkwm.title(tt, "bitUtils editor")
  txt <- tcltk::tktext(tt, height = 20, width = 100, wrap = "none", undo = TRUE)
  yscroll <- tcltk::tkscrollbar(tt, command = function(...) tcltk::tkyview(txt, ...))
  xscroll <- tcltk::tkscrollbar(tt, orient = "horizontal", command = function(...) tcltk::tkxview(txt, ...))

  tcltk::tkgrid(txt, yscroll, sticky = "nsew")
  tcltk::tkgrid(xscroll, sticky = "ew")
  tcltk::tkgrid.rowconfigure(tt, 0, weight = 1)
  tcltk::tkgrid.columnconfigure(tt, 0, weight = 1)
  tcltk::tkconfigure(
    txt,
    yscrollcommand = function(...) tcltk::tkset(yscroll, ...),
    xscrollcommand = function(...) tcltk::tkset(xscroll, ...)
  )
  tcltk::tktag.configure(txt, "keyword", foreground = "#0033aa")

  keywords <- c(
    "if", "else", "repeat", "while", "function", "for", "in", "next", "break",
    "TRUE", "FALSE", "NULL", "Inf", "NaN", "NA", "NA_integer_", "NA_real_",
    "NA_character_", "NA_complex_"
  )

  highlight <- function() {
    tcltk::tktag.remove(txt, "keyword", "1.0", "end")
    for (word in keywords) {
      start <- "1.0"
      pattern <- paste0("\\y", word, "\\y")
      repeat {
        pos <- tcltk::tclvalue(tcltk::tcl(txt, "search", "-regexp", "--", pattern, start, "end"))
        if (!nzchar(pos)) {
          break
        }
        end <- paste0(pos, "+", nchar(word), "c")
        tcltk::tktag.add(txt, "keyword", pos, end)
        start <- end
      }
    }
  }

  save <- function() {
    file <- tcltk::tclvalue(tcltk::tcl(
      "tk_getSaveFile",
      initialfile = tcltk::tcl("file", "tail", wfile),
      initialdir = tcltk::tcl("file", "dirname", wfile)
    ))
    if (!nzchar(file)) {
      return()
    }
    chn <- tcltk::tcl("open", file, "w")
    on.exit(tcltk::tcl("close", chn), add = TRUE)
    tcltk::tcl("puts", "-nonewline", chn, tcltk::tkget(txt, "1.0", "end-1c"))
    wfile <<- file
    tcltk::tcl("wm", "title", tt, file)
  }

  load <- function() {
    file <- tcltk::tclvalue(tcltk::tcl("tk_getOpenFile"))
    if (!nzchar(file)) {
      return()
    }
    chn <- tcltk::tcl("open", file, "r")
    on.exit(tcltk::tcl("close", chn), add = TRUE)
    tcltk::tkdelete(txt, "1.0", "end")
    tcltk::tkinsert(txt, "1.0", tcltk::tclvalue(tcltk::tcl("read", chn)))
    wfile <<- file
    tcltk::tcl("wm", "title", tt, file)
    highlight()
  }

  run <- function() {
    highlight()
    code <- tcltk::tclvalue(tcltk::tkget(txt, "1.0", "end-1c"))
    parsed <- try(parse(text = code), silent = TRUE)
    if (inherits(parsed, "try-error")) {
      tcltk::tkmessageBox(message = "Syntax error", icon = "error")
      return()
    }
    cat("Executing from script window:", "-----", code, "result:", sep = "\n")
    result <- try(eval(parsed, envir = .GlobalEnv), silent = TRUE)
    if (inherits(result, "try-error")) {
      tcltk::tkmessageBox(message = as.character(result), icon = "error")
      return()
    }
    if (!is.null(result)) {
      print(result)
    }
  }

  tcltk::tkbind(txt, "<KeyRelease-Return>", function() highlight())
  tcltk::tkbind(tt, "<Control-o>", function() load())
  tcltk::tkbind(tt, "<Control-s>", function() save())
  tcltk::tkbind(tt, "<Control-r>", function() run())

  topMenu <- tcltk::tkmenu(tt)
  tcltk::tkconfigure(tt, menu = topMenu)
  fileMenu <- tcltk::tkmenu(topMenu, tearoff = FALSE)
  tcltk::tkadd(fileMenu, "command", label = "Load", command = load, accelerator = "Ctrl+O")
  tcltk::tkadd(fileMenu, "command", label = "Save", command = save, accelerator = "Ctrl+S")
  tcltk::tkadd(topMenu, "cascade", label = "File", menu = fileMenu)
  tcltk::tkadd(topMenu, "command", label = "Run", command = run)
  invisible(tt)
}
