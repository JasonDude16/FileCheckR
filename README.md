
# FileCheckR

The goal of FileCheckR is to assist with file- and folder-checking
processes, specifically for research labs conducting human subject
research.

## Installation

You can install the development version of FileCheckR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("JasonDude16/FileCheckR")
```

## Motivating Example

Suppose you’re collecting experimental data from research subjects, and
each subject performs a battery of tasks. Each task has several datasets
associated with it (e.g., a behavioral dataset consisting of accuracy
and response time, and a physiological dataset, such as EEG). All of
these files are–hopefully–organized in some logical way. This
organizational structure may consist of separate folders for behavioral
and physiological folders, each of which has subfolders for each
subject, and each subject folder may have several files, for example
(whether a database is warranted here is a discussion for another day).

Among all of these files and folders, there is bound to be errors and
inconsistencies: subjects may have incorrectly formatted IDs (e.g., the
ID length should be 5 but it’s 6), a subject file is saved in another
subject’s folder, a subject may not have all the files they’re supposed
to, etc. Researchers often have protocols in place to find and correct
these errors using the help of RAs or similar, but this is tedious,
time-consuming, and, most importantly, error-prone. There must be a
better way.

``` r
library(FileCheckR)
```

Instead of manually checking and comparing files and folders, you can
create a tibble (similar to a data frame) of paths and other
information.

``` r
make_path_tibble(getwd(), recursive = FALSE)
#> # A tibble: 10 x 10
#>    main_dir  file      ext   dirs  last_dir dirs_list n_dirs mtime              
#>    <chr>     <chr>     <chr> <chr> <chr>    <list>     <dbl> <dttm>             
#>  1 FileChec… data      ""    /     ""       <chr [0]>      0 2022-02-13 22:45:02
#>  2 FileChec… DESCRIPT… ""    /     ""       <chr [0]>      0 2022-02-14 20:31:12
#>  3 FileChec… FileChec… "Rpr… /     ""       <chr [0]>      0 2022-02-14 20:36:55
#>  4 FileChec… LICENSE   ""    /     ""       <chr [0]>      0 2022-02-13 21:16:03
#>  5 FileChec… LICENSE.… "md"  /     ""       <chr [0]>      0 2022-02-13 21:16:03
#>  6 FileChec… man       ""    /     ""       <chr [0]>      0 2022-02-14 20:44:26
#>  7 FileChec… NAMESPACE ""    /     ""       <chr [0]>      0 2022-02-14 20:40:41
#>  8 FileChec… R         ""    /     ""       <chr [0]>      0 2022-02-14 20:40:14
#>  9 FileChec… README.md "md"  /     ""       <chr [0]>      0 2022-02-14 21:18:17
#> 10 FileChec… README.R… "Rmd" /     ""       <chr [0]>      0 2022-02-14 21:25:51
#> # … with 2 more variables: partial <chr>, full <chr>
```

If individual data files have a column of the subject ID, you can
extract this and add it as a column to the tibble.

``` r
# example setup
tmp <- tempdir()
file <- paste0(tmp, .Platform$file.sep, "tmp.csv")
write.csv(data.frame(id = 1), file = file)

tmp_tbl <- make_path_tibble(tmp)
x <- get_df_ids(tmp_tbl, ext = "csv", id_col = "id", read_fun = read.csv)
x[, c("main_dir", "file", "ext", "df_id")]
#> # A tibble: 1 x 4
#>   main_dir   file    ext   df_id
#>   <chr>      <chr>   <chr> <int>
#> 1 RtmpJqDONO tmp.csv csv       1
```

To show better examples of the functionality of this package, I’ll use
the `example_paths` tibble created using `make_path_tibble`. This tibble
was created from the following organizational structure:
`Task/Subject Folder/Subject Files`.

``` r
head(example_paths)
#> # A tibble: 6 x 11
#>   main_dir   file      ext   dirs  last_dir dirs_list n_dirs mtime              
#>   <chr>      <chr>     <chr> <chr> <chr>    <list>     <dbl> <dttm>             
#> 1 GNG_Anger… 9999_GNG… csv   /ID_… ID_30111 <chr [1]>      1 2021-09-29 18:43:03
#> 2 GNG_Anger… 30111_GN… dat   /ID_… ID_30111 <chr [1]>      1 2021-09-29 18:43:03
#> 3 GNG_Anger… 30111_GN… psyd… /ID_… ID_30111 <chr [1]>      1 2021-09-29 18:43:03
#> 4 GNG_Anger… 30121_GN… csv   /ID_… ID_30121 <chr [1]>      1 2021-11-13 11:43:45
#> 5 GNG_Anger… 30121_GN… log   /ID_… ID_30121 <chr [1]>      1 2021-11-13 11:43:45
#> 6 GNG_Anger… 30121_GN… psyd… /ID_… ID_30121 <chr [1]>      1 2021-11-13 11:43:45
#> # … with 3 more variables: partial <chr>, full <chr>, df_id <chr>
```

You can ensure files, folders, and columns match a specified pattern,
such as checking if all IDs have a length of 5 (you could do more
specific things, too, such as checking if each value of an ID is within
a specifc numeric range).

``` r
match_pattern(example_paths$last_dir, pattern = "^ID_[0-9]{5}$")
#> All match the specified pattern
match_pattern(example_paths$file, pattern = "^[0-9]{5}_")
#> [1] "The following does match the pattern: 9999_GNG_Anger_2021_Sep_29_1833.csv"
```

You can compare subject folder names with file names.

``` r
id_match(example_paths$df_id, example_paths$file, "[0-9]{5}", "[0-9]{5}")
#> The following do not match
#>   index     x     y
#> 1     2 88888 30111
id_match(example_paths$last_dir, example_paths$file, "[0-9]{5}", "[0-9]{4,5}")
#> The following do not match
#>   index     x    y
#> 1     1 30111 9999
```

If subject folders have multiple files, you can check if the files have
the same ID.

``` r
in_folder_match(example_paths, "^[0-9]{5}", main_dir, last_dir)
#> # A tibble: 70 x 5
#> # Groups:   main_dir [3]
#>    main_dir           last_dir files     x         match   
#>    <chr>              <chr>    <list>    <list>    <chr>   
#>  1 GNG_Anger_PsychoPy ID_30111 <chr [3]> <chr [3]> 1.000000
#>  2 GNG_Anger_PsychoPy ID_30121 <chr [3]> <chr [3]> 1.000000
#>  3 GNG_Anger_PsychoPy ID_30151 <chr [3]> <chr [3]> 1.000000
#>  4 GNG_Anger_PsychoPy ID_30171 <chr [3]> <chr [3]> 1.000000
#>  5 GNG_Anger_PsychoPy ID_30181 <chr [3]> <chr [3]> 1.000000
#>  6 GNG_Anger_PsychoPy ID_30201 <chr [3]> <chr [3]> 1.000000
#>  7 GNG_Anger_PsychoPy ID_30261 <chr [3]> <chr [3]> 1.000000
#>  8 GNG_Anger_PsychoPy ID_30271 <chr [3]> <chr [3]> 1.000000
#>  9 GNG_Anger_PsychoPy ID_30291 <chr [3]> <chr [3]> 1.000000
#> 10 GNG_Anger_PsychoPy ID_30301 <chr [3]> <chr [3]> 1.000000
#> # … with 60 more rows
```

You can count the number of files within each subject folder.

``` r
in_folder_file_count(example_paths, main_dir, last_dir)
#> # A tibble: 70 x 5
#> # Groups:   main_dir [3]
#>    main_dir           last_dir count group_min group_max
#>    <chr>              <chr>    <int>     <int>     <int>
#>  1 GNG_Anger_PsychoPy ID_30111     3         3         3
#>  2 GNG_Anger_PsychoPy ID_30121     3         3         3
#>  3 GNG_Anger_PsychoPy ID_30151     3         3         3
#>  4 GNG_Anger_PsychoPy ID_30171     3         3         3
#>  5 GNG_Anger_PsychoPy ID_30181     3         3         3
#>  6 GNG_Anger_PsychoPy ID_30201     3         3         3
#>  7 GNG_Anger_PsychoPy ID_30261     3         3         3
#>  8 GNG_Anger_PsychoPy ID_30271     3         3         3
#>  9 GNG_Anger_PsychoPy ID_30291     3         3         3
#> 10 GNG_Anger_PsychoPy ID_30301     3         3         3
#> # … with 60 more rows
```

If files have different extensions, you can check for their existence.

``` r
ext_match(example_paths, exts = c("csv", "psydat", "log"), main_dir, last_dir)
#> # A tibble: 70 x 4
#> # Groups:   main_dir [3]
#>    main_dir           last_dir ext       ext_diff
#>    <chr>              <chr>    <list>    <chr>   
#>  1 GNG_Anger_PsychoPy ID_30111 <chr [3]> "dat"   
#>  2 GNG_Anger_PsychoPy ID_30121 <chr [3]> ""      
#>  3 GNG_Anger_PsychoPy ID_30151 <chr [3]> ""      
#>  4 GNG_Anger_PsychoPy ID_30171 <chr [3]> ""      
#>  5 GNG_Anger_PsychoPy ID_30181 <chr [3]> ""      
#>  6 GNG_Anger_PsychoPy ID_30201 <chr [3]> ""      
#>  7 GNG_Anger_PsychoPy ID_30261 <chr [3]> ""      
#>  8 GNG_Anger_PsychoPy ID_30271 <chr [3]> ""      
#>  9 GNG_Anger_PsychoPy ID_30291 <chr [3]> ""      
#> 10 GNG_Anger_PsychoPy ID_30301 <chr [3]> ""      
#> # … with 60 more rows
```

These are some of the convenience functions, but the tibble structure
allows for considerable flexibility in how folders and files are grouped
and checked.

Happy file- and folder-checking!
