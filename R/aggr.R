#' Temporal aggregation of raster times series climate data
#'
#' @param x A SpatRaster of climate time series data
#' @param agg_type A character value indicating the type of temporal aggregation to perform can either be "days","monthly","annual" or "season"
#' @param agg_days A numeric value indicating the number of days to conduct "days" aggregation.Default value is NULL.
#' @param agg_month A vector of numeric values to indicate months of the "season" type aggregation.Example c(10,11,12) will indicate aggregation of season OND(October November December),for overlapping season example a vector c(11,12,1) will mean an aggregation from November current year to January next year(NDJ).Default value is NULL.
#' @param temp A character value indicating current temporal resolution for 'x'.Can either be "day" for daily data or "month" for monthly data.
#' @param start A character value to indicate the start date of the raster time series data x in format y-m-d.
#' @param end A character value to indicate the end date of the raster time series data x in format y-m-d.
#' @param func The function to be applied. Can be "sum","mean","max","min","sd","median","modal".
#'
#' @return A SpatRaster according to the required temporal aggregation
#' @export
#'
#' @examples
#' library (terra)
#' set.seed(123)
#'
#' # Daily to monthly aggregation for year 2001
#' r_day <- rast(nrows=10, ncols=10, nlyrs=365)
#' values(r_day) <- runif(ncell(r_day)*nlyr(r_day))*100
#' r_monthly<- aggr(r_day,agg_type="monthly",temp="day",start="2001-01-01",end="2001-12-31",func=sum)
#' r_monthly
#'
#' #Aggregating to annual from monthly from 2001 to 2010
#' r_month<-rast(nrows=10,ncols=10,nlyrs=120)
#' values(r_month) <- runif(ncell(r_month)*nlyr(r_month))*100
#'
#' r_annual<- aggr(r_month,agg_type="annual",temp="month",start="2001-01-01",end="2010-12-31",func=sum)
#' r_annual
#'
#'
#'
aggr <- function(x, agg_type, agg_days = NULL, agg_month = NULL, temp, start, end, func) {
  # Assigns time information to the raster stack based on the provided start, end, and time step (temp)
  dt <- seq.Date(as.Date(start), as.Date(end), by = temp)
  terra::time(x) <- dt

  # Aggregation based on the specified type
  ## Daily aggregation for a fixed number of days (only for daily data)
  if (agg_type == "days" & temp == "day" & !is.null(agg_days)) {
    # Create an index for grouping layers into specified day intervals
    ind = c(rep(1:floor(terra::nlyr(x) / agg_days), each = agg_days),
            rep(ceiling(terra::nlyr(x) / agg_days), times = terra::nlyr(x) - floor(terra::nlyr(x) / agg_days) * agg_days))

    return(terra::tapp(x, index = ind, fun = func))
  }

  ## Monthly aggregation (only for daily data)
  else if (agg_type == "monthly" & temp == "day") {
    # Group layers by year and month
    ind = paste0(lubridate::year(terra::time(x)), lubridate::month(terra::time(x)))

    return(terra::tapp(x, index = ind, fun = func))
  }

  ## Annual aggregation (only for monthly data)
  else if (agg_type == "annual" & temp == "month") {
    # Group layers into full years
    ind = rep(1:length(unique(lubridate::year(terra::time(x)))), each = 12)

    return(terra::tapp(x, index = ind, fun = func))
  }

  else {
    ## Seasonal aggregation (only for monthly data)
    if (agg_type == "season" & !is.null(agg_month) & temp == "month") {

      # Non-overlapping seasonal aggregation (season falls within the same year)
      if (identical(sort(agg_month), agg_month)) {
        # Select only the months in the specified season
        x = x[[which(lubridate::month(terra::time(x)) %in% agg_month)]]
        # Group layers by year
        ind = rep(1:length(unique(lubridate::year(terra::time(x)))), each = length(agg_month))

        return(terra::tapp(x, index = ind, fun = func))
      }

      else {
        # Overlapping seasonal aggregation (season spans two years)
        x = x[[which(lubridate::month(terra::time(x)) %in% agg_month)]]

        # Remove excess months at the start of the time series
        x = x[[-(1:(agg_month[1] - 1 - (12 - length(agg_month))))]]
        # Remove excess months at the end of the time series
        x = x[[1:(terra::nlyr(x) - (12 - agg_month[length(agg_month)] - (12 - length(agg_month))))]]

        # Group layers by overlapping seasons
        ind = rep(1:(length(unique(lubridate::year(terra::time(x)))) - 1), each = length(agg_month))

        return(terra::tapp(x, index = ind, fun = func))
      }
    }
  }
}
