#' Create a pie plot.
#'
#' @param df A dataframe.
#' @param prop A column in the 'df' dataframe. Must be a proportion from 0-1.
#' @param cat A column in the 'df' dataframe. Must be be a factor.
#' @return A ggplot rendering of the proportion of values in each category.
#' @export
#' @examples
#' pie(mydat, mydat$prop, mydat$cat)
#' @importFrom ggplot2 aes

pie <- function(df, prop, cat) {
  ggplot2::ggplot(data = df, mapping = aes(x = "", y = {{ prop }}, fill = {{ cat }})) +
    ggplot2::geom_bar(width = 1, stat = "identity") +
    ggplot2::coord_polar("y", start = 0)
}
