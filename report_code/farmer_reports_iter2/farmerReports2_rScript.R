# RScript for Second Round of southeatern PA Farm Reports
# Authors: Daniel B. Turner, Jocelyn E. Behm, & Matthew R. Helmus
# Description - This script will complete the following tasks in sections:
#     1. Load data from farm biodiversity surveys.
#     2. Create objects or lists of some plots to be used in the reports.
#     3. Run a "for loop" that will cycle through the datasets to create individualized reports.

# SECTION 1: Load data from farm biodiversity surveys.                                  --------------------------------------------------

# a. Load relevant R packages
library(ggplot2)
library(rmarkdown)
library(here)

# b. Load data files (these data are provided on GitHub as .csv files).

load(here::here("data/interact.rich.sepa.rda"))
print(interact.rich.sepa) # Check to see if the data look complete.

load(here::here("data/plastic.sepa.rda"))
print(plastic.sepa) # Check to see if the dataframe is complete.

# SECTION 2: Create objects or lists of some plots to be used in the reports.           --------------------------------------------------

### The 'urbanIntensity' vector will be called to tell the reader their specific "urbanization category."
urbanIntensity <- c("Low Intensity", "Low Intensity", "Low Intensity", "Low Intensity", "Low Intensity", "Medium Intensity", "Medium Intensity", "Medium Intensity", "Medium Intensity", "High intensity", "High intensity", "High intensity", "High intensity", "High intensity", "High intensity")

### The 'farmNames' vector will be called to name each unique .html file.
farmNames <- c("lowUrbanFarm_1", "lowUrbanFarm_2", "lowUrbanFarm_3", "lowUrbanFarm_4", "lowUrbanFarm_5", "mediumUrbanFarm_1", "mediumUrbanFarm_2", "mediumUrbanFarm_3", "mediumUrbanFarm_4", "highUrbanFarm_1", "highUrbanFarm_2", "highUrbanFarm_3", "highUrbanFarm_4", "highUrbanFarm_5", "highUrbanFarm_6")

colors <- c("burlywood4", "darkslategray4") # color palette 1
moreColors <- c("seagreen4", "darkslateblue", "tan3") # color palette 2

weedy_interactions <- ggplot(data = interact.rich.sepa, aes(x = weedyCover, y = richness)) +
  geom_point(aes(color = urbanCat, shape = urbanCat), size= 3.4) +
  geom_smooth(aes(color = urbanCat), method = "lm", size = 1.4, se = FALSE, fullrange = TRUE) +
  labs(x = "% weed cover", y = "Average beneficial predator\nrichness per trap", color = "Urban Intensity", shape = "Urban Intensity") +
  theme_classic() +
  theme(legend.title = element_text(size = 14.2),
        axis.text = element_text(size = 13.5),
        legend.text = element_text(size = 13),
        axis.title = element_text(size = 13.5)) +
  scale_shape_discrete(breaks = c("High", "Medium", "Low")) +
  scale_color_manual(values = moreColors, breaks = c("High", "Medium", "Low")) # This object will be called to show the interaction between urbanization category and local plant community diversity.

abundance_plastic <- ggplot(data = plastic.sepa, aes(x = category, y = meanAbun)) +
  geom_bar(aes(fill = category), stat = "identity") +
  theme_classic() +
  scale_fill_manual(values = colors) +
  theme(axis.title.x = element_blank(),
        legend.position = "none",
        text = element_text(size = 13)) +
  labs(y = "Average abundance of beneficial\npredators per trap") # This object will be called to show the relationship between plastic mulch presence and predatory arthropod abundance.

richness_plastic <- ggplot(plastic.sepa, aes(x = category, y = meanRich)) +
  geom_bar(aes(fill = category), stat = "identity") +
  theme_classic() +
  scale_fill_manual(values = colors) +
  theme(axis.title.x = element_blank(),
        legend.position = "none",
        text = element_text(size = 13)) +
  labs(y = "Average beneficial predator\nrichness per trap") # This object will be called to show the relationship between plastic mulch presence and predatory arthropod richness.

# SECTION 3: Run a "for loop" that will cycle through the datasets to create individualized biodiversity reports
i = 1
samp <- c(1, 6, 10)

for (i in samp) { # The 'for loop' should be run as many times as there are farms.
  urbanInt_loop <- urbanIntensity[i] # create object to print each unique urbanization category

  render("report_code/farmer_reports_iter2/farmerReports2_rmd.Rmd", output_file = paste0('report_output/farmerReport2_example_', farmNames[i], ".html"), "html_document") # This line executes each farm's .html report by calling the .rmd file.
  # NOTE: The .rmd should be located in the same workspace directory as this R script.
  # ANOTHER NOTE: The .html files will be located in the same workspace directory as this R script.
}
