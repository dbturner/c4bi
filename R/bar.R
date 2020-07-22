#' Create a bar plot.
#'
#' @param df A dataframe.
#' @param x A column in the 'df' dataframe. Must be of class 'numeric' and a proportion from 0-1.
#' @param y A column in the 'df' dataframe. Must be of class factor or character.
#' @return A ggplot2 rendering of the proportions across categories.
#' @export
#' @examples
#' x <- c("a", "b", "c")
#' y <- c(2, 4, 4)
#' mydata <- as.data.frame(cbind(x, y))
#' ylab <- c("y-axis label")
#' fillLab <- x
#' bar(df = mydata,
#'     x = mydata$x,
#'     y = mydata$y,
#'     ylab = ylab,
#'     fillLab = fillLab)
#' @importFrom ggplot2 aes

bar <- function(df, x, y, ylab, fillLab) {
  ggplot2::ggplot(df, aes(x = x, y = y)) +
    ggplot2::geom_bar(stat = "identity", aes(fill = fillLab)) +
    ggplot2::labs(y = ylab,
         fill = fillLab) +
    ggplot2::theme_classic() +
    ggplot2::theme(axis.ticks.x = ggplot2::element_blank(),
          axis.text.x = ggplot2::element_blank(),
          axis.title.x = ggplot2::element_blank(),
          legend.title = ggplot2::element_blank(),
          text = ggplot2::element_text(size = 18))
}
