# Internal helpers shared by the loaders. Not exported.

bit_make_name <- function(path) {
  name <- tools::file_path_sans_ext(basename(path))
  name <- gsub("[[:space:]]+", "_", name)
  make.names(name)
}

bit_is_interactive <- function() {
  interactive() && capabilities("tcltk")
}

bit_resolve_files <- function(file, filters, caption) {
  if (is.null(file)) {
    if (!bit_is_interactive()) {
      stop(
        "No file path was supplied, and a file dialog cannot be shown ",
        "in a non-interactive session.",
        call. = FALSE
      )
    }
    filenames <- tcltk::tk_choose.files(filters = filters, caption = caption)
    if (length(filenames) == 0L || (length(filenames) == 1L && !nzchar(filenames))) {
      stop(gettext("No file was selected."), call. = FALSE)
    }
    return(filenames)
  }

  file <- as.character(file)
  missing <- file[!file.exists(file)]
  if (length(missing) > 0L) {
    stop(gettextf("The file %s does not exist.", paste(missing, collapse = ", ")), call. = FALSE)
  }
  file
}

bit_resolve_dir <- function(dir) {
  if (is.null(dir)) {
    if (!bit_is_interactive()) {
      stop(
        "No directory was supplied, and a directory dialog cannot be shown ",
        "in a non-interactive session.",
        call. = FALSE
      )
    }
    directory <- tcltk::tk_choose.dir()
    if (!nzchar(directory) || is.na(directory)) {
      stop(gettext("No directory was selected."), call. = FALSE)
    }
    return(directory)
  }

  dir <- as.character(dir)[[1L]]
  if (!dir.exists(dir)) {
    stop(gettextf("The directory %s does not exist.", dir), call. = FALSE)
  }
  dir
}

bit_load_files <- function(files, envir, do_assign, quiet, fread_args) {
  out <- vector("list", length(files))
  obj_names <- vapply(files, bit_make_name, character(1L), USE.NAMES = FALSE)

  for (i in seq_along(files)) {
    path <- files[[i]]
    args <- c(list(input = path, data.table = FALSE), fread_args)
    data <- do.call(data.table::fread, args)
    out[[i]] <- data
    if (isTRUE(do_assign)) {
      assign(obj_names[[i]], data, envir = envir)
    }
    if (!isTRUE(quiet)) {
      path_disp <- normalizePath(path, winslash = "/", mustWork = FALSE)
      cat(sprintf("%s <- data.table::fread(\"%s\", data.table = FALSE)\n", obj_names[[i]], path_disp))
    }
  }

  names(out) <- obj_names
  if (length(out) == 1L) {
    invisible(out[[1L]])
  } else {
    invisible(out)
  }
}

bit_load_dir <- function(dir, pattern, envir, do_assign, quiet, notify, fread_args, label) {
  directory <- bit_resolve_dir(dir)
  files <- list.files(directory, pattern = pattern, full.names = TRUE, ignore.case = TRUE)
  if (length(files) == 0L) {
    warning(gettextf("No %s files found in the directory.", label), call. = FALSE)
    return(invisible(list()))
  }

  result <- bit_load_files(
    files = files,
    envir = envir,
    do_assign = do_assign,
    quiet = quiet,
    fread_args = fread_args
  )

  if (isTRUE(notify) && bit_is_interactive()) {
    tcltk::tk_messageBox(
      title = gettext("Success"),
      message = gettextf("Loaded %d file(s).", length(files))
    )
  } else if (!isTRUE(quiet)) {
    message(gettextf("Loaded %d file(s) from %s.", length(files), directory))
  }

  invisible(result)
}

bit_convert_encoding <- function(x, from = "cp949", to = "utf-8") {
  if (!is.data.frame(x)) {
    stop("`x` must be a data frame.", call. = FALSE)
  }

  DT <- data.table::as.data.table(x)
  for (col in names(DT)) {
    if (is.character(DT[[col]])) {
      data.table::set(DT, j = col, value = iconv(DT[[col]], from = from, to = to))
    }
  }

  converted_names <- iconv(names(DT), from = from, to = to)
  if (anyNA(converted_names)) {
    converted_names <- names(DT)
  }
  data.table::setnames(DT, converted_names)
  as.data.frame(DT)
}
