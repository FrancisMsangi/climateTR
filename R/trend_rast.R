trend_rast <- function(stacked, method) {

  # Function to display a progress bar (similar to terra's style)
  progress_bar <- function(i, total) {
    width <- 50  # Width of the progress bar
    progress <- round((i / total) * width)
    cat("\r[", paste(rep("=", progress), collapse = ""),
        paste(rep(" ", width - progress), collapse = ""), "]",
        sprintf(" %d%% completed", round((i / total) * 100)), sep = "")
    utils::flush.console()  # Ensures the progress bar updates in real-time
  }

  # Linear regression-based trend analysis
  if (method == "regression") {
    cat("Starting linear regression trend analysis...\n")

    cellnumber <- terra::ncell(stacked)  # Total number of cells in the raster
    slope <- pvalues <- rep(0, cellnumber)  # Pre-allocate memory for slope and p-values

    # Loop through each raster cell
    for (i in seq_len(cellnumber)) {
      temp <- stacked[i]  # Extract pixel time series

      if (sum(!is.na(temp)) < 4) {  # Ensure enough valid data points for regression
        slope[i] <- NA
        pvalues[i] <- NA
      } else {
        # Fit a linear model (trend over time)
        this_result <- summary(stats::lm(as.vector(as.matrix(temp)) ~ as.vector(1:terra::nlyr(stacked))))
        slope[i] <- this_result$coefficients[2, 1]  # Extract slope
        pvalues[i] <- this_result$coefficients[2, 4]  # Extract p-value
      }
      progress_bar(i, cellnumber)  # Update progress bar
    }
    cat("\n")

    # Create raster outputs for slope and p-values
    ts <- pval <- terra::rast(nrow = terra::nrow(stacked), ncol = terra::ncol(stacked), crs = terra::crs(stacked))
    terra::ext(ts) <- terra::ext(pval) <- terra::ext(stacked)  # Set spatial extent

    ts[] <- slope
    pval[] <- pvalues

    lr <- c(ts, pval)  # Combine outputs into a single raster stack
    names(lr) <- c("slope", "pvalue")  # Assign meaningful names

    return(lr)  # Return the raster stack containing trend results
  }

  # Mann-Kendall test for trend detection
  else if (method == "Mann_Kendall") {
    cat("Starting Mann-Kendall trend analysis...\n")

    cellnumber <- terra::ncell(stacked)  # Total number of cells in the raster
    estimates <- pvalues <- rep(0, cellnumber)  # Pre-allocate memory for trend estimates and p-values

    # Loop through each raster cell
    for (i in seq_len(cellnumber)) {
      temp <- stacked[i]  # Extract pixel time series

      if (sum(!is.na(temp)) < 4) {  # Ensure enough valid data points
        estimates[i] <- NA
        pvalues[i] <- NA
      } else {
        # Apply the modified Mann-Kendall test (accounts for autocorrelation)
        suppressWarnings(this_result <- modifiedmk::mmkh3lag(as.vector(as.matrix(temp))))
        estimates[i] <- this_result[[7]]  # Extract Sens's slope estimate
        pvalues[i] <- this_result[[2]]  # Extract p-value
      }
      progress_bar(i, cellnumber)  # Update progress bar
    }
    cat("\n")

    # Create raster outputs for Sens's slope and p-values
    ts <- pval <- terra::rast(nrow = terra::nrow(stacked), ncol = terra::ncol(stacked), crs = terra::crs(stacked))
    terra::ext(ts) <- terra::ext(pval) <- terra::ext(stacked)  # Set spatial extent

    ts[] <- estimates
    pval[] <- pvalues

    theil <- c(ts, pval)  # Combine outputs into a single raster stack
    names(theil) <- c("Sens_slope", "pvalue")  # Assign meaningful names

    return(theil)  # Return the raster stack containing trend results
  }
}
