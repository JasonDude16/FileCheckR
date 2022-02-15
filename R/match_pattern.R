#' Pattern matching
#'
#' @param x Atomic character vector
#' @param pattern regular expression passed to stringr::str_detect()
#'
#' @return Either a message if all elements match, or a character vector of mismatches
#' @export
#'
#' @examples
#' match_pattern(example_paths$last_dir, "ID_[0-9]{5}")
#' match_pattern(example_paths$file, "^[0-9]{5}")
match_pattern <- function(x, pattern) {
  if (all(stringr::str_detect(x, pattern))) {
    message("All match the specified pattern")
  } else {
    not_match <- x[which(stringr::str_detect(x, pattern) == FALSE)]
    paste("The following does match the pattern:", not_match)
  }
}
