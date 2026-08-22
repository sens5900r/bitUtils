test_that("bit_csv_all loads every CSV in a directory", {
  dir <- tempfile("bitutils-all-")
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)
  write.csv(data.frame(a = 1), file.path(dir, "one.csv"), row.names = FALSE)
  write.csv(data.frame(b = 2), file.path(dir, "two.csv"), row.names = FALSE)

  e <- new.env(parent = emptyenv())
  result <- bit_csv_all(dir, envir = e, quiet = TRUE)

  expect_true(is.list(result))
  expect_named(result, c("one", "two"), ignore.order = TRUE)
  expect_equal(e$one$a, 1)
  expect_equal(e$two$b, 2)
})

test_that("bit_txt_all loads every TXT in a directory", {
  dir <- tempfile("bitutils-txt-")
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)
  write.table(data.frame(a = 3), file.path(dir, "alpha.txt"), sep = "\t", quote = FALSE, row.names = FALSE)

  e <- new.env(parent = emptyenv())
  result <- bit_txt_all(dir, envir = e, quiet = TRUE)

  expect_equal(result$a, 3)
  expect_equal(e$alpha$a, 3)
})

test_that("bit_csv_all warns when the directory has no CSV files", {
  dir <- tempfile("bitutils-empty-")
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)
  expect_warning(bit_csv_all(dir, quiet = TRUE), "No .csv files")
})
