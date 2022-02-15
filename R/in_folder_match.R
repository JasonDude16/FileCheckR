#' Within-Folder pattern match
#'
#' @param path_tbl Tibble of paths created with make_path_tibble()
#' @param pattern Regular expression passed to stringr::str_extract()
#' @param ... Arguments passed to group_by()
#'
#' @return Tibble structure
#' @export
#'
#' @examples
#' in_folder_match(example_paths, "^[0-9]{5}", main_dir, last_dir)
in_folder_match <- function(path_tbl, pattern, ...) {
  requireNamespace("magrittr", quietly = TRUE)
  path_tbl %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(files = list(file)) %>%
    dplyr::mutate(x = purrr::map(files, ~ stringr::str_extract(.x, pattern))) %>%
    dplyr::mutate(match = purrr::map_chr(x, ~ ifelse(length(unique(.x) == 1), 1, 0)))
}
