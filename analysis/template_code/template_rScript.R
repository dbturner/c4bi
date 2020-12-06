# Template script for c4bi
# Authors' names
# Description of the script - This script will populate objects
# into the global environment that are called from the `template_rmd.Rmd`
# to produce individual reports for the sample dataset, `PlantGrowth` (built into R).


# SECTION 1: Load packages and data ----------

# Load packages
library(dplyr)
library(ggplot2)
library(rmarkdown)

# Load data
set.seed(123)

park_A <- cbind(rep("North Town", 10), rep("Beetle", 10), 1:10, rep(24, 10), rnbinom(10, 25, .75))
park_B <- cbind(rep("North Town", 10), rep("Butterfly", 10), 1:10, rep(10, 10), rnbinom(10, 5, .8))
park_C <- cbind(rep("East Town", 10), rep("Grasshopper", 10), 1:10, rep(18, 10), rnbinom(10, 12, .77))
park_D <- cbind(rep("East Town", 10), rep("Bee", 10), 1:10, rep(14, 10), rnbinom(10, 9, .79))
park_E <- cbind(rep("West Town", 10), rep("Wasp", 10), 1:10, rep(20, 10), rnbinom(10, 12, .77))
park_F <- cbind(rep("East Town", 10), rep("Ant", 10), 1:10, rep(7, 10), rnbinom(10, 4, .9))
park_G <- cbind(rep("West Town", 10), rep("Dragonfly", 10), 1:10, rep(26, 10), rnbinom(10, 20, .75))
park_H <- cbind(rep("North Town", 10), rep("Damselfly", 10), 1:10, rep(11, 10), rnbinom(10, 4, .82))
park_I <- cbind(rep("West Town", 10), rep("Mantis", 10), 1:10, rep(30, 10), rnbinom(10, 27, .8))

park <- as.data.frame(rbind(park_A,
                            park_B,
                            park_C,
                            park_D,
                            park_E,
                            park_F,
                            park_G,
                            park_H,
                            park_I))

names(park)[1] <- "town"
names(park)[2] <- "park"
names(park)[3] <- "day"
names(park)[4] <- "num_trees"
names(park)[5] <- "num_birds"
park$num_birds <- as.numeric(as.character(park$num_birds))
park$num_trees <- as.numeric(as.character(park$num_trees))
park$town <- as.character(park$town)

town <- park

ggplot(park, aes(x = num_trees, y = num_birds)) +
  geom_point(aes(color = town)) +
  geom_smooth(method = "lm")


# SECTION 2: Create objects or lists of some plots to be used in the reports. ----------
# Prep data.
town_sum <- park %>%
  group_by(town) %>%
  summarize(mean_birds = mean(num_birds),
            mean_trees = mean(num_trees))

mean_birds_all <- c("All towns", mean(park$num_birds), NA)
mean_trees_all <- c("All towns", NA, mean(park$num_trees))

bird_sum <- rbind(town_sum, mean_birds_all) %>%
  select(-mean_trees)
tree_sum <- rbind(town_sum, mean_trees_all) %>%
  select(-mean_birds)

# Try out some exploratory plots to see how they look.
# Here, we are calling the data from a subset - a single focal town and the average across all towns.
ggplot(bird_sum[c(1, length(bird_sum$town)),], aes(x = town, y = round(as.numeric(mean_birds), digits = 0))) +
  geom_bar(stat = "identity", aes(fill = town)) +
  labs(y = "Average number of birds") +
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        legend.title = element_blank()) +
  scale_fill_brewer(palette = "Dark2")

ggplot(data = tree_sum[c(1, length(tree_sum$town)),], aes(x = town, y = round(as.numeric(mean_trees), digits = 0))) +
  geom_bar(stat = "identity", aes(fill = town)) +
  labs(y = "Average number of trees") +
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        legend.title = element_blank()) +
  scale_fill_brewer(palette = "Dark2")

ggplot(data = park, aes(x = num_trees, y = num_birds)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue4") +
  labs(x = "Number of trees",
       y = "Number of birds") +
  theme_classic()

# Name objects to be called in RMarkdown.

report_name <- factor(c("East Town","North Town","West Town"))

# SECTION 3: Run a "for loop" that will cycle through the datasets to create individualized reports  ----------

i = 1
samp <- length(report_name)

for (i in 1:samp) { # The 'for loop' should be run as many times as there are farms.
  report <- report_name[i]

  bird_plot <- ggplot(bird_sum[c(i, length(bird_sum$town)),], aes(x = town, y = round(as.numeric(mean_birds), digits = 0))) +
    geom_bar(stat = "identity", aes(fill = town)) +
    labs(y = "Average number of birds") +
    theme_classic() +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          axis.title.x = element_blank(),
          legend.title = element_blank(),
          axis.text.y = element_text(color = "grey20", size = 12, angle = 0, hjust = .5, vjust = .5, face = "plain"),
          axis.title = element_text(size = 13.6),
          legend.text = element_text(size = 13)) +
    scale_fill_brewer(palette = "Dark2")

  tree_plot <- ggplot(tree_sum[c(i, length(tree_sum$town)),], aes(x = town, y = round(as.numeric(mean_trees), digits = 0))) +
    geom_bar(stat = "identity", aes(fill = town)) +
    labs(y = "Average number of trees") +
    theme_classic() +
    theme(axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          axis.title.x = element_blank(),
          legend.title = element_blank(),
          axis.text.y = element_text(color = "grey20", size = 12, angle = 0, hjust = .5, vjust = .5, face = "plain"),
          axis.title = element_text(size = 13.6),
          legend.text = element_text(size = 13)) +
    scale_fill_brewer(palette = "Dark2")

  birds_by_trees <- ggplot(data = park, aes(x = num_trees, y = num_birds)) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE, color = "blue4") +
    labs(x = "Number of trees",
         y = "Number of birds") +
    theme_classic() +
    theme(axis.text = element_text(size = 13.5),
          axis.title = element_text(size = 13.5))

  render("analysis/template_reports/template_rmd.Rmd", output_file = paste0('template_report_', report_name[i], ".html"), "html_document") # This line executes each farm's .html report by calling the "child" .rmd file.
  # NOTE: The .rmd should be located in the same workspace directory as this R script.
  # ANOTHER NOTE: The .html files will be located in the same workspace directory as this R script.
}
