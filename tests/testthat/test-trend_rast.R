r_year<-terra::rast(nrows=10,ncols=10,nlyrs=30)
terra::values(r_year) <- runif(terra::ncell(r_year)*terra::nlyr(r_year))*200

trend_reg<- trend_rast(stacked=r_year,method="regression")
trend_reg

test_that("Trend analysis works", {
  expect_equal(terra::nlyr(trend_reg), 2)
})
