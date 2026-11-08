test_that("bit_cp949 converts a data frame without a GUI", {
  df <- data.frame(a = "x", stringsAsFactors = FALSE)
  out <- bit_cp949(df, from = "UTF-8", to = "UTF-8")
  expect_equal(out$a, "x")
})

test_that("bit_cp949 converts an object by name", {
  e <- new.env(parent = emptyenv())
  e$sample_df <- data.frame(a = "x", stringsAsFactors = FALSE)
  out <- bit_cp949("sample_df", from = "UTF-8", to = "UTF-8", envir = e)
  expect_equal(out$a, "x")
  expect_equal(e$sample_df$a, "x")
})

test_that("bit_cp949 can round-trip Korean text through CP949", {
  skip_if(is.na(iconv("가", from = "UTF-8", to = "CP949")), "CP949 is not available")
  df <- data.frame(a = iconv("가", from = "UTF-8", to = "CP949"), stringsAsFactors = FALSE)
  out <- bit_cp949(df, from = "cp949", to = "utf-8")
  expect_equal(out$a, "가")
})

test_that("bit_setwd changes the working directory", {
  old <- getwd()
  on.exit(setwd(old), add = TRUE)
  dir <- tempfile("bitutils-wd-")
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)

  result <- suppressMessages(bit_setwd(dir))
  expect_equal(normalizePath(getwd()), normalizePath(dir))
  expect_equal(normalizePath(result), normalizePath(dir))
})
