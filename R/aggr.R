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
