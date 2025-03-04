
<!-- README.md is generated from README.Rmd. Please edit that file -->

# climateTR

<!-- badges: start -->

![Build
Status](https://img.shields.io/github/workflow/status/FrancisMsangi/climateTR/CI)
![Test
Coverage](https://img.shields.io/codecov/c/github/FrancisMsangi/climateTR)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/github/v/release/FrancisMsangi/climateTR?logo=github)
![Downloads](https://img.shields.io/github/downloads/FrancisMsangi/climateTR/total)
<!-- badges: end -->

The goal of climateTR is to facilitate temporal aggregation and trend
analysis of raster time-series climate data. It allows users to
aggregate climate data at different temporal scales (daily, monthly,
annual, and seasonal) and perform trend analysis using both parametric
(linear regression) and non-parametric (Mann-Kendall) methods

## Installation

You can install the development version of climateTR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("FrancisMsangi/climateTR")
```

## Example Usage

### Temporal Aggregation

``` r
library(climateTR)
library(terra)
#> Warning: package 'terra' was built under R version 4.3.3
#> terra 1.8.29

# Generate example raster data
set.seed(123)
r_day <- rast(nrows = 10, ncols = 10, nlyrs = 365)
values(r_day) <- runif(ncell(r_day) * nlyr(r_day)) * 100

# Aggregate daily data to monthly
r_monthly <- aggr(r_day, agg_type = "monthly", temp = "day",
                  start = "2001-01-01", end = "2001-12-31", func = sum)

# Print summary
r_monthly
#> class       : SpatRaster 
#> dimensions  : 10, 10, 12  (nrow, ncol, nlyr)
#> resolution  : 36, 18  (x, y)
#> extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (CRS84) (OGC:CRS84) 
#> source(s)   : memory
#> names       :   X20011,   X20012,   X20013,   X20014,   X20015,   X20016, ... 
#> min values  : 1033.690, 1116.627, 1132.167, 1095.410, 1159.627, 1146.544, ... 
#> max values  : 1956.725, 1740.182, 1937.782, 1801.837, 1921.434, 1859.319, ...
```

### Trend Analysis

``` r
# Generate example raster data for trend analysis
r_year <- rast(nrows = 10, ncols = 10, nlyrs = 30)
values(r_year) <- runif(ncell(r_year) * nlyr(r_year)) * 200

# Apply linear regression trend analysis
trend_reg <- trend_rast(stacked = r_year, method = "regression")
#> Starting linear regression trend analysis...
#> [                                                  ] 1% completed[=                                                 ] 2% completed[==                                                ] 3% completed[==                                                ] 4% completed[==                                                ] 5% completed[===                                               ] 6% completed[====                                              ] 7% completed[====                                              ] 8% completed[====                                              ] 9% completed[=====                                             ] 10% completed[======                                            ] 11% completed[======                                            ] 12% completed[======                                            ] 13% completed[=======                                           ] 14% completed[========                                          ] 15% completed[========                                          ] 16% completed[========                                          ] 17% completed[=========                                         ] 18% completed[==========                                        ] 19% completed[==========                                        ] 20% completed[==========                                        ] 21% completed[===========                                       ] 22% completed[============                                      ] 23% completed[============                                      ] 24% completed[============                                      ] 25% completed[=============                                     ] 26% completed[==============                                    ] 27% completed[==============                                    ] 28% completed[==============                                    ] 29% completed[===============                                   ] 30% completed[================                                  ] 31% completed[================                                  ] 32% completed[================                                  ] 33% completed[=================                                 ] 34% completed[==================                                ] 35% completed[==================                                ] 36% completed[==================                                ] 37% completed[===================                               ] 38% completed[====================                              ] 39% completed[====================                              ] 40% completed[====================                              ] 41% completed[=====================                             ] 42% completed[======================                            ] 43% completed[======================                            ] 44% completed[======================                            ] 45% completed[=======================                           ] 46% completed[========================                          ] 47% completed[========================                          ] 48% completed[========================                          ] 49% completed[=========================                         ] 50% completed[==========================                        ] 51% completed[==========================                        ] 52% completed[==========================                        ] 53% completed[===========================                       ] 54% completed[============================                      ] 55% completed[============================                      ] 56% completed[============================                      ] 57% completed[=============================                     ] 58% completed[==============================                    ] 59% completed[==============================                    ] 60% completed[==============================                    ] 61% completed[===============================                   ] 62% completed[================================                  ] 63% completed[================================                  ] 64% completed[================================                  ] 65% completed[=================================                 ] 66% completed[==================================                ] 67% completed[==================================                ] 68% completed[==================================                ] 69% completed[===================================               ] 70% completed[====================================              ] 71% completed[====================================              ] 72% completed[====================================              ] 73% completed[=====================================             ] 74% completed[======================================            ] 75% completed[======================================            ] 76% completed[======================================            ] 77% completed[=======================================           ] 78% completed[========================================          ] 79% completed[========================================          ] 80% completed[========================================          ] 81% completed[=========================================         ] 82% completed[==========================================        ] 83% completed[==========================================        ] 84% completed[==========================================        ] 85% completed[===========================================       ] 86% completed[============================================      ] 87% completed[============================================      ] 88% completed[============================================      ] 89% completed[=============================================     ] 90% completed[==============================================    ] 91% completed[==============================================    ] 92% completed[==============================================    ] 93% completed[===============================================   ] 94% completed[================================================  ] 95% completed[================================================  ] 96% completed[================================================  ] 97% completed[================================================= ] 98% completed[==================================================] 99% completed[==================================================] 100% completed

# Apply Mann-Kendall trend analysis
trend_mann <- trend_rast(stacked = r_year, method = "Mann_Kendall")
#> Starting Mann-Kendall trend analysis...
#> [                                                  ] 1% completed[=                                                 ] 2% completed[==                                                ] 3% completed[==                                                ] 4% completed[==                                                ] 5% completed[===                                               ] 6% completed[====                                              ] 7% completed[====                                              ] 8% completed[====                                              ] 9% completed[=====                                             ] 10% completed[======                                            ] 11% completed[======                                            ] 12% completed[======                                            ] 13% completed[=======                                           ] 14% completed[========                                          ] 15% completed[========                                          ] 16% completed[========                                          ] 17% completed[=========                                         ] 18% completed[==========                                        ] 19% completed[==========                                        ] 20% completed[==========                                        ] 21% completed[===========                                       ] 22% completed[============                                      ] 23% completed[============                                      ] 24% completed[============                                      ] 25% completed[=============                                     ] 26% completed[==============                                    ] 27% completed[==============                                    ] 28% completed[==============                                    ] 29% completed[===============                                   ] 30% completed[================                                  ] 31% completed[================                                  ] 32% completed[================                                  ] 33% completed[=================                                 ] 34% completed[==================                                ] 35% completed[==================                                ] 36% completed[==================                                ] 37% completed[===================                               ] 38% completed[====================                              ] 39% completed[====================                              ] 40% completed[====================                              ] 41% completed[=====================                             ] 42% completed[======================                            ] 43% completed[======================                            ] 44% completed[======================                            ] 45% completed[=======================                           ] 46% completed[========================                          ] 47% completed[========================                          ] 48% completed[========================                          ] 49% completed[=========================                         ] 50% completed[==========================                        ] 51% completed[==========================                        ] 52% completed[==========================                        ] 53% completed[===========================                       ] 54% completed[============================                      ] 55% completed[============================                      ] 56% completed[============================                      ] 57% completed[=============================                     ] 58% completed[==============================                    ] 59% completed[==============================                    ] 60% completed[==============================                    ] 61% completed[===============================                   ] 62% completed[================================                  ] 63% completed[================================                  ] 64% completed[================================                  ] 65% completed[=================================                 ] 66% completed[==================================                ] 67% completed[==================================                ] 68% completed[==================================                ] 69% completed[===================================               ] 70% completed[====================================              ] 71% completed[====================================              ] 72% completed[====================================              ] 73% completed[=====================================             ] 74% completed[======================================            ] 75% completed[======================================            ] 76% completed[======================================            ] 77% completed[=======================================           ] 78% completed[========================================          ] 79% completed[========================================          ] 80% completed[========================================          ] 81% completed[=========================================         ] 82% completed[==========================================        ] 83% completed[==========================================        ] 84% completed[==========================================        ] 85% completed[===========================================       ] 86% completed[============================================      ] 87% completed[============================================      ] 88% completed[============================================      ] 89% completed[=============================================     ] 90% completed[==============================================    ] 91% completed[==============================================    ] 92% completed[==============================================    ] 93% completed[===============================================   ] 94% completed[================================================  ] 95% completed[================================================  ] 96% completed[================================================  ] 97% completed[================================================= ] 98% completed[==================================================] 99% completed[==================================================] 100% completed

# Print results
trend_reg
#> class       : SpatRaster 
#> dimensions  : 10, 10, 2  (nrow, ncol, nlyr)
#> resolution  : 36, 18  (x, y)
#> extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (CRS84) (OGC:CRS84) 
#> source(s)   : memory
#> names       :     slope,     pvalue 
#> min values  : -2.519434, 0.01239925 
#> max values  :  2.862960, 0.95590394
trend_mann
#> class       : SpatRaster 
#> dimensions  : 10, 10, 2  (nrow, ncol, nlyr)
#> resolution  : 36, 18  (x, y)
#> extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (CRS84) (OGC:CRS84) 
#> source(s)   : memory
#> names       : Sens_slope,     pvalue 
#> min values  :  -3.301863, 0.01382126 
#> max values  :   3.167313, 1.00000000
```

You can view the package vignette
[here](https://github.com/FrancisMsangi/climateTR/tree/master/vignettes/ClimateTR_package_for_temporal_aggregation_and_trend_analysis_of_climate_data.html)
