library(testthat)
library(bitUtils)

test_that("bit_csv loads a CSV file correctly", {
  # 임시 CSV 파일을 만듭니다
  tmp <- tempfile(fileext = ".csv")
  write.csv(data.frame(a = 1:3, b = 4:6), tmp, row.names = FALSE)

  # bit_csv 함수를 테스트합니다
  result <- bit_csv(tmp)

  # 객체를 확인하고 테스트합니다
  expect_true(exists("tmp"))
  expect_equal(result[["a"]], 1:3)
  expect_equal(result[["b"]], 4:6)

  # 임시 파일을 삭제합니다
  unlink(tmp)
})
