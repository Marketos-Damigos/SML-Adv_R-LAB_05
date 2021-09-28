context("elections")

test_that("class is correct.", {
  elections_check <- elections$new("2014")
  
  expect_true(class(elections_check)[1] == "elections")
})

test_that("Correct output.", {
  elections_check <- elections$new("2014")
  
  expect_true(length(elections_check$council) == 120)
})

test_that("Output is df.", {
  elections_check <- elections$new("2014")
  
  expect_true(is.data.frame(elections_check$council))
})

test_that("Case year is wrong.", {
  
  expect_error(elections_check <- elections$new("2013"))
})

test_that("Shiny function returns a shiny object.", {
  library(shiny)
  elections_check <- elections$new("2014")
  
  expect_true(is.shiny.appobj(elections_check$shiny()))
})
