#' Compare Folder/File IDs
#'
#' @param x atomic character vector containing ID
#' @param y atomic character vector containing ID
#' @param pattern_x regular expression used by str_match()
#' @param pattern_y regular expression used by str_match()
#'
#' @return Tibble structure
#' @export
#'
#' @examples
#' id_match(
#' example_paths$file,
#' example_paths$last_dir,
#' pattern_x = "[0-9]{4,5}",
#' pattern_y = "[0-9]{4,5}"
#' )
id_match <- function(x, y, pattern_x, pattern_y) {

  comp <- dplyr::intersect(which(!is.na(x)), which(!is.na(y)))
  x <- stringr::str_match(x[comp], pattern_x)
  y <- stringr::str_match(y[comp], pattern_y)

  if (all(x == y)) {
    message("All IDs match")
  } else {
    mismatch <- which(x != y)
    df <- data.frame(index = mismatch, x = x[mismatch], y = y[mismatch])
    message("The following do not match")
    return(df)
  }
}
