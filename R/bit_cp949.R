#' @title Convert Encoding of Dataframe from CP949 to UTF-8
#'
#' @description This function changes the encoding of the character columns in a dataframe from CP949 to UTF-8.
#' @details The function provides a GUI for the user to select a dataframe from the global environment. It then changes the encoding of character columns and column names of the chosen dataframe from CP949 to UTF-8.
#'
#' @usage bit_cp949()
#'
#' @return This function returns no value. It alters the chosen dataframe in the global environment in-place.
#'
#' @note This function requires the gWidgets2 and data.table packages.
#'
#' @seealso \code{\link[data.table]{data.table}}, \code{\link[gWidgets2]{gwindow}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  # Generate a sample dataframe
#'  df <- data.frame(a = c("가", "나"), b = c("다", "라"))
#'  Encoding(df$a) <- Encoding(df$b) <- "CP949"
#'  assign("df", df, envir = .GlobalEnv)
#'  # Run the function
#'  bit_cp949()
#' }
#' @import gWidgets2
bit_cp949 <- function() {
  # Check if the necessary packages are loaded
  if (!("gWidgets2" %in% .packages(all.available = TRUE))) {
    stop("gWidgets2 package is not loaded. Please install and load the package before running this function.")
  }
  if (!("data.table" %in% .packages(all.available = TRUE))) {
    stop("data.table package is not loaded. Please install and load the package before running this function.")
  }

  # 현재 환경에 있는 모든 객체를 가져오기
  all_objects <- ls(envir = .GlobalEnv)

  # 데이터 프레임만 추출
  data_frames <- all_objects[sapply(all_objects, function(x) is.data.frame(get(x)))]

  # 선택창 만들기
  win <- gWidgets2::gwindow("Choose a dataframe", width = 280)
  group <- gWidgets2::ggroup(cont = win, horizontal = FALSE)

  # 메시지 추가
  initial_msg <- gWidgets2::glabel("Click here to see the list of dataframes:", cont = group)

  listbox <- gWidgets2::gcombobox(data_frames, cont = group, editable = FALSE)

  # 선택한 데이터 프레임 이름 반환
  gWidgets2::addHandlerChanged(listbox, handler = function(h,...) {
    dataframe_name <- gWidgets2::svalue(h$obj)
    gWidgets2::gmessage(paste("You chose dataframe:", dataframe_name), parent = win)

    # 선택한 데이터 프레임 가져오기
    df <- get(dataframe_name)

    # Convert to data.table
    DT <- data.table::as.data.table(df)

    # Convert encoding of character columns
    for (col in names(DT)) {
      if (is.character(DT[[col]])) {
        data.table::set(DT, j = col, value = iconv(DT[[col]], from = "cp949", to = "utf-8"))
      }
    }

    # Convert column names
    data.table::setnames(DT, iconv(names(DT), from = "cp949", to = "utf-8"))

    # Convert back to data.frame
    df <- as.data.frame(DT)

    # Assign converted data frame back to global environment
    assign(dataframe_name, df, envir = .GlobalEnv)

    gWidgets2::gmessage(paste("The encoding of dataframe", dataframe_name, "has been converted to UTF-8."), parent = win)

    # Close the window
    gWidgets2::dispose(win)
  })

  gWidgets2::visible(win) <- TRUE
}
