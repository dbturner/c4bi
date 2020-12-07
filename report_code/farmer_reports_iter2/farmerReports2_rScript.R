# Parent Script for Second Farm Biodiversity Reports
# Authors: Daniel B. Turner, Jocelyn E. Behm, & Matthew R. Helmus
# Description - This script will complete the following tasks in sections:
#     1. Load data from farm biodiversity surveys
#         a. Data needed (two .csv files):  farmReport2_interactRich.csv
#                                           farmReport2_plastic.csv
#     2. Create objects or lists of some plots to be used in the reports
#     3. Run a "for loop" that will cycle through the datasets to create individualized biodiversity reports

# SECTION 1: Load data from farm biodiversity surveys.                                  --------------------------------------------------

# a. Load relevant R packages
library(ggplot2)
library(rmarkdown)
library(here)

# b. Load data files (these data are provided on GitHub as .csv files).

interactRich <- read.csv("data/farmReport2_interactRich.csv")
print(interactRich) # Check to see if the data look complete.

plastic <- read.csv("data/farmReport2_plastic.csv")
print(plastic) # Check to see if the dataframe is complete.

# SECTION 2: Create objects or lists of some plots to be used in the reports.           --------------------------------------------------

# The 'urbanIntensity' vector will be called to tell the reader their specific "urbanization category."
urbanIntensity <- c("Low Intensity", "Low Intensity", "Low Intensity", "Low Intensity", "Low Intensity", "Medium Intensity", "Medium Intensity", "Medium Intensity", "Medium Intensity", "High intensity", "High intensity", "High intensity", "High intensity", "High intensity", "High intensity")

# The 'farmNames' vector will be called to name each unique .html file.
farmNames <- c("ruralFarm_1", "ruralFarm_2", "ruralFarm_3", "ruralFarm_4", "ruralFarm_5", "suburbanFarm_1", "suburbanFarm_2", "suburbanFarm_3", "suburbanFarm_4", "urbanFarm_1", "urbanFarm_2", "urbanFarm_3", "urbanFarm_4", "urbanFarm_5", "urbanFarm_6")

colors <- c("burlywood4", "darkslategray4") # color palette 1
moreColors <- c("seagreen4", "darkslateblue", "tan3") # color palette 2

weedy_interactions <- ggplot(data = interactRich, aes(x = weedyCover, y = richness)) +
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

abundance_plastic <- ggplot(data = plastic, aes(x = category, y = meanAbun)) +
  geom_bar(aes(fill = category), stat = "identity") +
  theme_classic() +
  scale_fill_manual(values = colors) +
  theme(axis.title.x = element_blank(),
        legend.position = "none",
        text = element_text(size = 13)) +
  labs(y = "Average abundance of beneficial\npredators per trap") # This object will be called to show the relationship between plastic mulch presence and predatory arthropod abundance.

richness_plastic <- ggplot(plastic, aes(x = category, y = meanRich)) +
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

  render("analysis/farmerReports2_rmd.Rmd", output_file = paste0('userReports_caseStudy2B/farmerReport2_example_', farmNames[i], ".html"), "html_document") # This line executes each farm's .html report by calling the "child" .rmd file.
  # NOTE: The .rmd should be located in the same workspace directory as this R script.
  # ANOTHER NOTE: The .html files will be located in the same workspace directory as this R script.
}
