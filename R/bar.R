#' Create a bar plot.
#'
#' @param df DESCRIPTION.
#' @param x DESCRIPTION.
#' @param y DESCRIPTION.
#' @param ylab DESCRIPTION.
#' @param fillLab DESCRIPTION.
#' @return DESCRIPTION
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
