test_that("internal names become valid R object names", {
  expect_equal(bitUtils:::bit_make_name("C:/tmp/my data.csv"), "my_data")
  expect_equal(bitUtils:::bit_make_name("123.csv"), "X123")
})
