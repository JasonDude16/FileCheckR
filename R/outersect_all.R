#' Outersect of all vectors
#'
#' @param x A list, either named or unnamed, of numeric vectors
#' @param names Optional character vector of names for x
#'
#' @return List of numeric vectors containing the outersect
#' @export
#'
#' @examples
#' outersect_all(list(1:5, 3:6, 2:8), names = c("a", "b", "c"))
outersect_all <- function(x, names = NULL) {
  ll <- vector(mode = "list")

  for (i in 1:length(x)) {
    comb <- purrr::reduce(x[-i], c)
    ll[[i]] <- setdiff(x[[i]], comb)
  }

  if (!is.null(names(x))) {
    names(ll) <- names(x)
  }

  # overwrite names if names arg not null
  if (!is.null(names)) {
    names(ll) <- names
  }

  return(ll)
}
