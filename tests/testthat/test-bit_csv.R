test_that("bit_csv loads a CSV file correctly", {
  # 임시 CSV 파일을 만듭니다
  tmp <- tempfile(fileext = ".csv")
  write.csv(data.frame(a = 1:3, b = 4:6), tmp, row.names = FALSE)

  # bit_csv 함수를 테스트합니다
  bit_csv(tmp)

  # 생성된 객체의 이름을 가져옵니다
  object_name <- tools::file_path_sans_ext(basename(tmp))

  # 객체를 확인하고 테스트합니다
  expect_true(exists(object_name))
  result <- get(object_name)
  expect_equal(result[["a"]], 1:3)
  expect_equal(result[["b"]], 4:6)

  # 임시 파일을 삭제합니다
  unlink(tmp)
})
