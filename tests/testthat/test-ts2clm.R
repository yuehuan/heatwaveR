context("Test ts2clm.R")

test_that("ts2clm() returns the correct output", {
  res <- ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"))
  expect_is(res, "data.frame")
  expect_equal(ncol(res), 6)
  expect_equal(nrow(res), 12053)
})

test_that("all starting error checks flag correctly", {
  expect_error(ts2clm(sst_WA)) # Specific error not supplied as R sees them as different some how...
  expect_error(ts2clm(sst_WA, climatologyPeriod = "1983-01-01"),
               "Bummer! Please provide BOTH start and end dates for the climatology period.")
  expect_error(ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"),
                      maxPadLength = "2"),
               "Please ensure that 'maxPadLength' is a numeric/integer value.")
  expect_error(ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"),
                      pctile = "90"),
               "Please ensure that 'pctile' is a numeric/integer value.")
  expect_error(ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"),
                      windowHalfWidth = "5"),
               "Please ensure that 'windowHalfWidth' is a numeric/integer value.")
  expect_error(ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"),
                      smoothPercentile = "FALSE"),
               "Please ensure that 'smoothPercentile' is either TRUE or FALSE.")
  expect_error(ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"),
                      smoothPercentileWidth = "31"),
               "Please ensure that 'smoothPercentileWidth' is a numeric/integer value.")
  expect_error(ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"),
                      clmOnly = "FALSE"),
               "Please ensure that 'clmOnly' is either TRUE or FALSE.")
})

test_that("the start/end dates must not be before/after the clim limits", {
  expect_error(ts2clm(sst_WA, climatologyPeriod = c("1973-01-01", "2012-12-31")),
               "The specified start date precedes the first day of series, which is 1982-01-01")
  expect_error(ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2023-12-31")),
               "The specified end date follows the last day of series, which is 2014-12-31")
})

test_that("smooth_percentile = FALSE prevents smoothing", {
  res_smooth <- ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"))
  res_chunky <- ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"),
                       smoothPercentile = FALSE)
  expect_lt(var(res_smooth$seas), var(res_chunky$seas))
})

test_that("clmOnly = TRUE returns only the clim data", {
  res <- ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"),
                clmOnly = TRUE)
  expect_is(res, "data.frame")
  expect_equal(ncol(res), 4)
  expect_equal(nrow(res), 366)
})

test_that("robust = TRUE switches to the slower function", {
  t_1 <- system.time(ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"), robust = TRUE))
  t_2 <- system.time(ts2clm(sst_WA, climatologyPeriod = c("1983-01-01", "2012-12-31"), robust = FALSE))
  expect_lt(t_2[1], t_1[1])
})
