test_that("bit_txt loads a tab-delimited file", {
  tmp <- tempfile(fileext = ".txt")
  on.exit(unlink(tmp), add = TRUE)
  write.table(data.frame(a = 1:2, b = c("p", "q")), tmp, sep = "\t", quote = FALSE, row.names = FALSE)

  e <- new.env(parent = emptyenv())
  result <- bit_txt(tmp, envir = e, quiet = TRUE)

  expect_equal(result$a, 1:2)
  expect_equal(result$b, c("p", "q"))
})

test_that("bit_read dispatches by extension", {
  csv <- tempfile(fileext = ".csv")
  txt <- tempfile(fileext = ".txt")
  on.exit(unlink(c(csv, txt)), add = TRUE)
  write.csv(data.frame(a = 1), csv, row.names = FALSE)
  write.table(data.frame(b = 2), txt, sep = "\t", quote = FALSE, row.names = FALSE)

  e <- new.env(parent = emptyenv())
  csv_out <- bit_read(csv, envir = e, quiet = TRUE)
  txt_out <- bit_read(txt, envir = e, quiet = TRUE)

  expect_equal(csv_out$a, 1)
  expect_equal(txt_out$b, 2)
})

test_that("bit_read rejects unknown extensions", {
  expect_error(bit_read("notes.md"), "Unsupported file extension")
})
