#' @title Load all TXT files in a directory
#'
#' @description This function allows the user to choose a directory and loads all .txt files
#' in that directory into separate data frames in the global environment.
#'
#' @return NULL. This function is called for its side effect of loading data frames into the global environment.
#'
#' @export
bit_txt_all <- function() {
  directory <- tcltk::tk_choose.dir()
  if (nzchar(directory)) {
    files <- list.files(directory, pattern = "\\.txt$", full.names = TRUE)
    if (length(files) > 0) {
      for (i in seq_along(files)) {
        file <- files[i]
        data <- data.table::fread(file, sep="\t", quote="", data.table = FALSE)

        # 파일 이름에서 확장자 제거
        name <- tools::file_path_sans_ext(basename(file))
        # 공백을 _로 대체
        name <- gsub(" ", "_", name)

        assign(name, data, envir = .GlobalEnv)
      }
      # 메시지 박스를 표시합니다
      tcltk::tk_messageBox(title = gettext("Success"), message = gettext("Loading finished. The program will close soon."))
      # 1초 동안 실행을 중단합니다
      Sys.sleep(1)
    } else {
      print(gettext("No .txt files found in the directory."))
    }
  } else {
    print(gettext("No directory was selected."))
  }
}
