#' Create a scatter plot.
#'
#' @param df A dataframe.
#' @param prop A column in the 'df' dataframe. Must be of class 'numeric' and a proportion from 0-1.
#' @param cat A column in the 'df' dataframe. Must be of class factor or character.
#' @return A ggplot2 rendering of the proportions across categories.
#' @export
#' @examples
#' set.seed(123)
#' n <- 100
#' b0 <- 33
#' b1 <- 2
#' sigma <- 1
#' x <- round((rnorm(n, mean = 2, sd = .5)), 1)
#' y <- round((b0 + b1*x + rnorm(n, sigma)), 1)
#' cat <- c(rep("Group_A", 50), rep("Group_B", 50))
#' xlab <- "X-axis label"
#' ylab <- "Y-axis label"
#' legendLab <- "Legend Title"
#' mydata <- as.data.frame(cbind(as.numeric(x), as.numeric(y), cat))
#' scatter(mydata, x, y, cat, xlab, ylab, legendLab)
#' @importFrom ggplot2 aes

scatter <- function(df, x, y, cat, xlab, ylab, legendLab) {
  colors <- c("seagreen4", "darkslateblue", "tan3")
  ggplot2::ggplot(data = df, aes(x = x, y = y)) +
    ggplot2::geom_point(aes(color = cat, shape = cat), size= 3.4) +
    ggplot2::geom_smooth(aes(color = cat), method = "lm", size = 1.4, se = FALSE, fullrange = TRUE) +
    ggplot2::labs(x = xlab,
                  y = ylab,
                  color = legendLab,
                  shape = legendLab) +
    ggplot2::theme_classic() +
    ggplot2::theme(legend.title = ggplot2::element_text(size = 14.2),
          axis.text = ggplot2::element_text(size = 13.5),
          legend.text = ggplot2::element_text(size = 13),
          axis.title = ggplot2::element_text(size = 13.5)) +
    ggplot2::scale_shape_discrete(breaks = unique(cat)) +
    ggplot2::scale_color_manual(values = colors[1:length(unique(cat))], breaks = unique(cat))
}
