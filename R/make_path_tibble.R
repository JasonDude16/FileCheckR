.make_path_tibble_base <- function(path, pattern = NULL, ...) {
  stopifnot(is.character(path), dir.exists(path))

  full <- list.files(path, full.names = T, pattern = pattern, ...)
  partial <- stringr::str_remove(full, paste0("^", path))

  dirs <- dirname(partial)
  dirs_list <- purrr::map(strsplit(dirs, .Platform$file.sep), ~ .x[.x != ""])

  path_tbl <- tibble::tibble(
    main_dir = basename(path),
    partial = partial,
    file = basename(partial),
    ext = tools::file_ext(file),
    dirs = dirs,
    last_dir = basename(dirs),
    dirs_list = dirs_list,
    n_dirs = purrr::map_dbl(dirs_list, length),
    full = full,
    mtime = file.info(full)$mtime,
  )

  # moving full and partial to end to improve printing
  last <- which(colnames(path_tbl) %in% c("full", "partial"))
  not_last <- which(colnames(path_tbl) %in% c("full", "partial") == F)
  path_tbl <- path_tbl[c(not_last, last)]

  return(path_tbl)
}

#' Tibble of file information
#'
#' @param paths Character vector (atomic or list) of top-level file paths for which you'd like to create a tibble structure.
#' @param patterns Character vector (atomic or list) of file patterns passed to list.files(). Length must either be one or equal to length of paths.
#' @param ... Arguments passed to list.files()
#'
#' @return Tibble structure of file and folder information
#' @export
#'
#' @examples
#' make_path_tibble(getwd(), recursive = FALSE)
make_path_tibble <- function(paths, patterns = NULL, ...) {
  if (is.null(patterns)) {
    purrr::map_dfr(paths, function(.x, ...)
      .make_path_tibble_base(.x, ...), ...)
  } else {
    purrr::map2_dfr(paths, patterns, function(.x, .y, ...)
      .make_path_tibble_base(.x, .y, ...), ...)
  }
}
