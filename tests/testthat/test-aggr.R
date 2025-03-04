r_month<-terra::rast(nrows=10,ncols=10,nlyrs=120)
terra::values(r_month) <- runif(terra::ncell(r_month)*terra::nlyr(r_month))*100

r_annual<-aggr(r_month,agg_type="annual",agg_days=NULL,agg_month=NULL,temp="month",start="2001-01-01",end="2010-12-31",func=sum)

test_that("Temporal aggregation works", {
  expect_equal(terra::nlyr(r_annual), 10)
})
