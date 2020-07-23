#' Create a pie plot.
#'
#' @param df A DESCRIPTION.
#' @param prop A column in the 'df' dataframe. Must be of class 'numeric' and a proportion from 0-1.
#' @param cat A column in the 'df' dataframe. Must be of class factor or character.
#' @return A ggplot2 rendering of the proportions across categories.
#' @export
#' @examples
#' prop <- c(.2, .4, .4)
#' cat <- c("a", "b", "c")
#' mydata <- as.data.frame(cbind(prop, cat))
#' pie(mydata, mydata$prop, mydata$cat)
#' @importFrom ggplot2 aes

pie <- function(df, prop, cat) {
  ggplot2::ggplot(data = df, mapping = aes(x = "", y = {{ prop }}, fill = {{ cat }})) +
    ggplot2::geom_bar(width = 1, stat = "identity") +
    ggplot2::coord_polar("y", start = 0) +
    ggplot2::theme(axis.text = ggplot2::element_blank(),
          axis.ticks = ggplot2::element_blank(),
          panel.grid  = ggplot2::element_blank(),
          axis.title = ggplot2::element_blank(),
          panel.background = ggplot2::element_blank(),
          legend.title = ggplot2::element_blank(),
          text = ggplot2::element_text(size = 18))
}
