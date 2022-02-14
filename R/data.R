#' Tibble of paths from research study.
#'
#' A tibble dataset containing file and folder information from data collected in a research lab.
#'
#' @format A tibble with 210 rows and 11 variables:
#' \describe{
#'   \item{main_dir}{top-level directory}
#'   \item{file}{name of file}
#'   \item{ext}{file's extension}
#'   \item{dirs}{partial file path, excluding top-level directory and file}
#'   \item{last_dir}{last directory}
#'   \item{dirs_list}{dirs column in list format}
#'   \item{n_dirs}{number of directories, excluding main_dir}
#' }
"example_paths"
