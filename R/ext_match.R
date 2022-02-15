#' Within-folder extension match
#'
#' @param path_tbl Tibble of paths created with make_path_tibble()
#' @param exts Atomic character vector of file extensions (excluding period, e.g., "csv") that a folder should contain
#' @param ... Arguments passed to dplyr::group_by()
#'
#' @return Tibble structure
#' @export
#'
#' @examples
#' ext_match(example_paths, ext = c("csv", "log", "psydat"), main_dir, last_dir)
ext_match <- function(path_tbl, exts, ...) {
  requireNamespace("magrittr", quietly = TRUE)
  path_tbl %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(ext = list(ext)) %>%
    dplyr::mutate(ext_diff = purrr::map_chr(ext, function(.x) {
      diff <- setdiff(.x, exts)
      if (length(diff) == 0) {
        return("")
      } else {
        return(diff)
      }
    }))
}
