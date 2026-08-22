test_that("bit_csv loads a CSV file into a supplied environment", {
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  write.csv(data.frame(a = 1:3, b = 4:6), tmp, row.names = FALSE)

  e <- new.env(parent = emptyenv())
  result <- bit_csv(tmp, envir = e, quiet = TRUE)
  object_name <- make.names(tools::file_path_sans_ext(basename(tmp)))

  expect_true(exists(object_name, envir = e, inherits = FALSE))
  expect_equal(result[["a"]], 1:3)
  expect_equal(result[["b"]], 4:6)
  expect_equal(e[[object_name]][["a"]], 1:3)
})

test_that("bit_csv returns data without assigning when assign = FALSE", {
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  write.csv(data.frame(x = 9:10), tmp, row.names = FALSE)

  e <- new.env(parent = emptyenv())
  result <- bit_csv(tmp, envir = e, assign = FALSE, quiet = TRUE)

  expect_equal(result$x, 9:10)
  expect_equal(length(ls(envir = e)), 0L)
})

test_that("bit_csv errors when the file is missing", {
  expect_error(bit_csv("no-such-file.csv"), "does not exist")
})

test_that("bit_csv sanitizes file names that contain spaces", {
  dir <- tempfile("bitutils-")
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)
  path <- file.path(dir, "my data.csv")
  write.csv(data.frame(n = 1), path, row.names = FALSE)

  e <- new.env(parent = emptyenv())
  bit_csv(path, envir = e, quiet = TRUE)
  expect_true(exists("my_data", envir = e, inherits = FALSE))
})
