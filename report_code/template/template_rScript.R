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
library(here)

# Set working directory if .Rproj file not opened

# Load data
load(here::here("data/town.rda"))

# SECTION 2: Create objects or lists of some plots to be used in the reports. ----------
# Prep data.
town_sum <- town %>%
  group_by(town) %>%
  summarize(mean_birds = mean(num_birds),
            mean_trees = mean(num_trees))

mean_birds_all <- c("All towns", mean(town$num_birds), NA)
mean_trees_all <- c("All towns", NA, mean(town$num_trees))

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

ggplot(data = town, aes(x = num_trees, y = num_birds)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue4") +
  labs(x = "Number of trees",
       y = "Number of birds") +
  theme_classic()

# Name objects to be called in RMarkdown.

report_name <- factor(c("East Town","North Town","West Town"))
file_name <- factor(c("East_Town","North_Town","West_Town"))

# SECTION 3: Run a "for loop" that will cycle through the datasets to create individualized reports  ----------

i = 1
samp <- length(report_name)

for (i in 1:samp) { # The 'for loop' should be run as many times as there are farms.
  report <- report_name[i]

  render(here("report_code/template/template_rmd.Rmd"), output_file = paste0('report_output/template_report_', file_name[i], ".html"), "html_document") # This line executes each farm's .html report by calling the "child" .rmd file.
  # NOTE: The .rmd should be located in the same workspace directory as this R script.
  # ANOTHER NOTE: The .html files will be located in the same workspace directory as this R script.
}
