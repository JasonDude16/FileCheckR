#' Intersect all vectors
#'
#' @param ... atomic numeric vectors
#'
#' @return atomic vector of intersection of vectors
#' @export
#'
#' @examples
#' intersect_all(1:5, 3:6, 2:8)
intersect_all <- function(...) {
  purrr::reduce(list(...), dplyr::intersect)
}
