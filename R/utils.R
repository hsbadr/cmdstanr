# misc --------------------------------------------------------------------

#' Check for Windows
#' @return `TRUE` if OS is Windows, `FALSE` if not.
#' @noRd
os_is_windows <- function() {
  isTRUE(.Platform$OS.type == "windows")
}

#' Famous helper for switching on `NULL`
#' @param x,y Any \R objects.
#' @return `x` if not `NULL`, otherwise `y` regardless of whether `y` is `NULL`.
#' @noRd
`%||%` <- function(x, y) {
  if (!is.null(x)) x else y
}


# paths and extensions ----------------------------------------------------

#' Get extension for executable depending on OS
#' @noRd
#' @param path If not `NULL` then a path to add the extension to.
#' @return If `path` is `NULL` then `".exe"` on Windows and `""` otherwise. If
#'   `path` is not `NULL` then `.exe` is added as the extension on Windows.
cmdstan_ext <- function(path = NULL) {
  ext <- if (os_is_windows()) ".exe" else ""
  if (is.null(path)) {
    return(ext)
  }
  paste0(path, ext)
}

# Strip extension from a file path
strip_ext <- function(file) {
  tools::file_path_sans_ext(file)
}

# Change extension from a file path
change_ext <- function(file, ext) {
  out <- strip_ext(file)
  paste0(out, ext)
}

# Check for .stan file extension
has_stan_ext <- function(stan_file) {
  stopifnot(is.character(stan_file))
  isTRUE(tools::file_ext(stan_file) == "stan")
}

# Prepend cmdstan_path() to a relative path
add_cmdstan_path <- function(relative_path) {
  if (!nzchar(cmdstan_path())) {
    stop("Please set the path to CmdStan. See ?set_cmdstan_path.",
         call. = FALSE)
  }
  file.path(cmdstan_path(), relative_path)
}

# Strip the cmdstan_path() from a full path
strip_cmdstan_path <- function(full_path) {
  if (!nzchar(cmdstan_path())) {
    stop("Please set the path to CmdStan. See ?set_cmdstan_path.",
         call. = FALSE)
  }
  sub(cmdstan_path(), "", full_path)
}




# read csv output ---------------------------------------------------------

# FIXME: also parse the csv header
read_optim_csv <- function(csv_file) {
  full_csv <- readLines(csv_file)
  mark <- grep("#   refresh", full_csv)
  col_names <- strsplit(full_csv[mark + 1], split = ",")[[1]]

  header <- full_csv[1:mark]
  x <- scan(csv_file, skip = mark + 1, sep = ",")
  list(mle = setNames(x, col_names))
}



# write data  -------------------------------------------------------------

#' Dump data to temporary file in format readable by CmdStan
#'
#' Currently calls `rstan::stan_rdump()` to create the `.data.R` file.
#' FIXME:
#'
#' @param data A named list of \R objects.
#' @return Path to temporary file containing the data.
#' @noRd
write_rdump <- function(data) {
  checkmate::assert_names(names(data), type = "unique")
  temp_file <- tempfile(pattern = "standata-", fileext = ".data.R")
  rstan::stan_rdump(
    list = names(data),
    file = temp_file,
    envir = as.environment(data)
  )
  temp_file
}
