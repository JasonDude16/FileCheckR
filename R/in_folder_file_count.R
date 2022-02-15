#' Count files in folder
#'
#' @param path_tbl tibble of paths created with make_path_tibble()
#' @param ... Arguments passed to group_by()
#'
#' @return Tibble structure
#' @export
#'
#' @examples
#' in_folder_file_count(example_paths, main_dir, last_dir)
in_folder_file_count <- function(path_tbl, ...) {
  requireNamespace("magrittr", quietly = TRUE)
  path_tbl %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(
      count = dplyr::n(),
      group_min = min(count),
      group_max = max(count)
    )
}
