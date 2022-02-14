.get_df_id <- function(path, id_col, read_fun, ...) {
  stopifnot(is.character(id_col), length(id_col) == 1)

  FUN <- match.fun(read_fun)

  x <- FUN(path, ...)[id_col]

  if (length(unique(x)) == 1) {
    return(x[1, 1])
  } else {
    message("Not all IDs match in the dataframe; did someone modify the data?")
  }

}

#' Get ID from file
#'
#' @param path_tbl Tibble of paths created by make_path_tibble()
#' @param ext Atomic character vector of length one identifying file extension to filter by
#' @param id_col Atomic character vector of length one identiying ID column in file
#' @param read_fun Unquoted function name for reading in files (e.g., read.csv)
#' @param ... Arguments passed to read function
#'
#' @return A tibble equal in length to the tibble passed in, with a column of IDs added (df_id). If an ID was not found/extracted for the associated file, NA is returned.
#' @export
#'
#' @examples
#' tmp <- tempdir()
#' file <- paste0(tmp, .Platform$file.sep, "tmp.csv")
#' write.csv(data.frame(id = 1), file = file)
#' tmp_tbl <- make_path_tibble(tmp)
#' get_df_ids(tmp_tbl, ext = "csv", id_col = "id", read_fun = read.csv)
get_df_ids <- function(path_tbl, ext, id_col, read_fun, ...) {

  if (!any(colnames(path_tbl) %in% "full")) {
    stop("The `full` column was not found in the dataset")
  }

  IDs <- purrr::map_if(path_tbl$full, .p = endsWith(path_tbl$full, ext), function(.x) {
    .get_df_id(.x, id_col, read_fun, ...)
  })

  path_tbl$df_id <- ifelse(path_tbl$ext == ext, unlist(IDs), NA)

  return(path_tbl)

}
