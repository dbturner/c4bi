# RScript for Curaçao homeowner reports
# Authors: Daniel B. Turner, Jocelyn E. Behm, & Matthew R. Helmus
# Description - This script will complete the following tasks in sections:
#     1. Load data from farm biodiversity surveys.
#     2. Create objects or lists of some plots to be used in the reports.
#     3. Run a "for loop" that will cycle through the datasets to create individualized reports.

rm(list=ls())


# SECTION 1: Load data from homeowner biodiversity surveys.           --------------------------------------------------

# a. Load relevant R packages
library(dplyr)
library(ggplot2)
library(rmarkdown)
library(reshape2)
library(tidyr)
library(kableExtra)
library(knitr)
library(here)

# b. Load data files
load(here::here("data/curacao.nat.herps.rda"))
load(here::here("data/curacao.exo.herps.sum.rda"))
load(here::here("data/curacao.exo.herps.rda"))
load(here::here("data/curacao.nat.birds.list.rda"))
load(here::here("data/curacao.nat.birds.rda"))
load(here::here("data/curacao.exo.birds.sum.rda"))
load(here::here("data/curacao.exo.birds.rda"))
load(here::here("data/curacao.arthropods.rda"))

# c. Set up global parameters
puk <- 0 # number of digits to round

# set color palette
fun_colors3 <- c("palegreen2", "steelblue2", "lightgoldenrod2") # assign vector of three color names for plots
fun_colors4 <- c("palegreen2", "steelblue2", "lightgoldenrod2", "lightpink") # assign vector of four color names for plots
# forest = blue, garden = yellow, scrub = red,  your = green
fun_colors3 <- c("steelblue2", "lightgoldenrod2","lightpink") # assign vector of three color names for plots
fun_colors4 <- c("steelblue2", "lightgoldenrod2", "lightpink", "palegreen2") # assign vector of four color names for plots


# Section 2: Tidy data and populate objects for data visualizations --------------------------------------------------

# Native herps
herps_nat_noNA <- na.omit(curacao.nat.herps) # create dataframe of sites without NAs to calculate means more easily

herps_nat_means <- herps_nat_noNA %>%
  group_by(sitetype) %>%
  summarise(Dutch.Leaf.toed.Gecko = round(mean(Dutch.Leaf.toed.Gecko), puk),
            Antillean.Dwarf.Gecko = round(mean(Antillean.Dwarf.Gecko), puk),
            Striped.Anole = round(mean(Striped.Anole), puk),
            Laurent.s.Whiptail = round(mean(Laurent.s.Whiptail), puk),
            Turnip.tailed.Gecko = round(mean(Turnip.tailed.Gecko), puk)) # create summary dataframe for means across all species for all categories


meanNames <- as.factor(c("forestMeans", "gardenMeans", "scrubMeans")) # set factor names so combined dataframe is clearer
herps_nat_means$sitetype <- meanNames
herps_nat_means$Site <- NA # create these columns to combine dataframes later
herps_nat_means$ReportName <- NA # create these columns to combine dataframes later
herps_nat_means$Site<- c("Forest", "Garden", "Scrub")

colnames(curacao.nat.herps)[3:7] <- c("Dutch Leaf-toed Gecko", "Antillean Dwarf Gecko", "Striped Anole", "Laurent's Whiptail", "Turnip-tailed Gecko")
colnames(herps_nat_means)[2:6] <- c("Dutch Leaf-toed Gecko", "Antillean Dwarf Gecko", "Striped Anole", "Laurent's Whiptail", "Turnip-tailed Gecko")

herps_natList <- split(curacao.nat.herps, f = curacao.nat.herps$Site) # create a list that separates the native herp observations by site so they can be listed in each site's unique report

for(i in 1:31){
  herps_natList[[i]]$Site <- c("Your garden")
} # Change site name so that reader sees "Your garden"

herps_nat_long <- vector("list", 31)


# Exotic herps
# wrangle exotic herp proportion data
colnames(curacao.exo.herps.sum) <- c("species", "Site Type", "Percentage of sites") # change column names

curacao.exo.herps.sum$`Percentage of sites` <- round(curacao.exo.herps.sum$`Percentage of sites`, puk)
curacao.exo.herps.sum$species <- factor(curacao.exo.herps.sum$species,c("Mourning Gecko",
                                                                        "Asian House Gecko",
                                                                        "Tropical House Gecko",
                                                                        "Colombian Four-eyed Frog",
                                                                        "Johnstone's Whistling Frog",
                                                                        "Cuban Tree Frog"))

# create plot
herps_exo_prop_plot <- ggplot(data = curacao.exo.herps.sum, aes(x = `Site Type`, y = `Percentage of sites`, fill = `Site Type`)) +
  geom_bar(stat="identity") +
  geom_text(aes(label = `Percentage of sites`), position = position_dodge(width = 0.9), vjust = .5, size = 3.9) +
  scale_fill_manual(values = fun_colors3) +
  facet_wrap(~ species) +
  labs(title="Percentage of sites \nwith exotic reptile or amphibian species") +
  ylab("Percentage of sites") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(color = "grey20", size=12.1, angle=30, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(color = "grey20", size=10, angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.title.x=element_blank(),
        axis.title.y = element_text(size = 12.8),
        legend.position = "none",
        strip.text.x = element_text(size = 11.7),
        plot.title = element_text(size=16)) # This object will be called to compare exotic reptile abundance across the focal site and site categories.

# wrangle exotic herp species list

colnames(curacao.exo.herps) <- c("Site", "sitetype", "Mourning Gecko", "Tropical House Gecko", "Johnstone's Whistling Frog", "Cuban Treefrog", "Colombian Four-eyed Frog", "Asian House Gecko", "ReportName")

herps_exo_spMelt <- melt(curacao.exo.herps, id = c("Site", "sitetype", "ReportName"))

herps_exo_spMelt$variable <- as.character(herps_exo_spMelt$variable)

herps_exo_spMelt <- herps_exo_spMelt[order(herps_exo_spMelt$ReportName, -herps_exo_spMelt$value),]

herps_exoList <- split(herps_exo_spMelt, f = herps_exo_spMelt$Site)

herps_exoList[[1]][1, 4] # check to see if the dataframes were separated correctly


# Native birds
# tidy data for species list
curacao.nat.birds.list$Scientific.name <- paste0("(", curacao.nat.birds.list$Scientific.name, ")")
curacao.nat.birds.list$Common.Name <- as.character(curacao.nat.birds.list$Common.Name)
curacao.nat.birds.list$bird.Name <- paste(curacao.nat.birds.list$Common.Name, curacao.nat.birds.list$Scientific.name)

# wrangle data for Rmd file for species list
curacao.nat.birds.list <- curacao.nat.birds.list[order(curacao.nat.birds.list$Site, -curacao.nat.birds.list$Present),]

birds_natList <- split(curacao.nat.birds.list, f = curacao.nat.birds$Site)

birds_natList[[1]]

# wrangle native bird species richness data
birdsNat_sr_sum <- curacao.nat.birds %>%
  group_by(sitetype) %>%
  summarise(SR = round(mean(SR), puk))

birdsNat_sr_sum$Site <- NA
birdsNat_sr_sum$ReportName <- NA

birdsNat_srTotal <- rbind(curacao.nat.birds, birdsNat_sr_sum)

birdsNat_srTotal[,1] <- c("Your garden") # assign all sites the name "Your garden" for plotting and visualization purposes
birdsNat_srTotal[32:34, 1] <- c("Forest", "Garden", "Scrub") # change summary means to more aesthetically pleasing names (this step could have been done in factorization line several rows above)
birdsNat_srTotal$ord <- 1:34


# make a sample plot
ggplot(birdsNat_srTotal[c(26, 32:34),], aes(x = reorder(Site, ord), y = SR)) +
  geom_bar(stat = "identity", aes(fill = Site)) +
  geom_text(aes(label=SR), position = position_dodge(width = 0.9), vjust = 0.5, size = 4.7) +
  scale_fill_manual(values = fun_colors4) +
  labs(y = "Average number of bird species",
       title = "Number of native bird species") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(color = "grey20", size=12, angle=30, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(color = "grey20", size=12, angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.title.x=element_blank(),
        legend.position = "none",
        axis.title=element_text(size=13.6),
        plot.title = element_text(size=18))


# Exotic birds
# wrangle exotic birds data
colnames(curacao.exo.birds.sum) <- c("species", "Site Type", "Percentage of sites")

curacao.exo.birds.sum$`Percentage of sites` <- round(curacao.exo.birds.sum$`Percentage of sites`, puk)
curacao.exo.birds.sum$species <- factor(curacao.exo.birds.sum$species,c("Exotic Parrots",
                                                                        "Chestnut-fronted Macaw",
                                                                        "Rock Pigeon",
                                                                        "Saffron Finch",
                                                                        "House Sparrow"))


# plot exotic bird proportions
birds_exo_prop_plot <- ggplot(data = curacao.exo.birds.sum, aes(x=`Site Type`, y = `Percentage of sites`, fill = `Site Type`)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = `Percentage of sites`), position = position_dodge(width = 0.9), vjust = .5, size = 3.9) +
  facet_wrap(~ species) +
  scale_fill_manual(values = fun_colors3) +
  labs(title = "Percentage of sites with exotic bird species") +
  ylab("Percentage of sites") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(color = "grey20", size=12.1, angle=30, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(color = "grey20", size=12, angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.title.x=element_blank(),
        legend.position = "none",
        strip.text.x = element_text(size = 12),
        axis.title=element_text(size=13.6),
        plot.title = element_text(size=18)) # This object will be called to compare exotic bird observations across sites.

# exotic birds list

# exotic birds list
birdsExo_List <- curacao.exo.birds # load data

colnames(birdsExo_List) <- c("Site", "sitetype", "Exotic Parrots", "Cheshnut-fronted Macaw", "Rock Pigeon", "House Sparrow", "Saffron Finch", "ReportName")

birdsExo_List <- melt(birdsExo_List, id = c("Site", "sitetype", "ReportName"))

birdsExo_List <- birdsExo_List[order(birdsExo_List$Site, -birdsExo_List$value),]

birdsExo_List <- split(birdsExo_List, f = birdsExo_List$Site)

# Arthropods -----------

# wrangle arthropod data
arthDiv <- curacao.arthropods %>%
  select(Site:AB, ReportName)

arthSum <- curacao.arthropods %>%
  group_by(sitetype) %>%
  summarise(SR = round(mean(SR), puk), AB = round(mean(AB), puk))

arthSum$ReportName <- NA
arthSum$Site <- NA

arthTot <- rbind(arthDiv, arthSum)

arthTot[,1] <- c("Your garden") # assign all sites the name "Your garden" for plotting and visualization purposes
arthTot[32:34, 1] <- c("Forest", "Garden", "Scrub") # change summary means to more aesthetically pleasing names (this step could have been done in factorization line several rows above)
arthTot$ord <- 1:34


# sample arthropod species richness plot
ggplot(arthTot[c(4, 32:34),], aes(x = reorder(Site, ord), y = SR)) +
  geom_bar(stat = "identity", aes(fill = Site)) +
  scale_fill_manual(values = fun_colors4) +
  labs(y = "Arthropod species richness",
       title = "Arthropod species richness") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(color = "grey20", size=10, angle=30, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(color = "grey20", size=10, angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.title.x=element_blank(),
        legend.position = "none")

# sample arthropod abundance plot
ggplot(arthTot[c(4, 32:34),], aes(x = reorder(Site, ord), y = AB)) +
  geom_bar(stat = "identity", aes(fill = Site)) +
  scale_fill_manual(values = fun_colors4) +
  labs(y = "Arthropod species richness",
       title = "Arthropod species richness") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(color = "grey20", size=10, angle=30, hjust=.5, vjust=.5, face="plain"),
        axis.text.y = element_text(color = "grey20", size=10, angle=0, hjust=.5, vjust=.5, face="plain"),
        axis.title.x=element_blank(),
        legend.position = "none")

# prep plot for an individual garden
compmeans <- aggregate(curacao.arthropods[,5:12], list(curacao.arthropods$sitetype), mean)
colnames(compmeans) <- c("Group 1", "Spiders", "Beetles", "Flies", "True Bugs", "Wasps and Ants", "Butterflies", "Lacewings", "Crickets")
compmeans1 <- melt(compmeans, id = "Group 1")
colnames(compmeans1) <- c("Site Type", "Order", "Proportion")
compmeans1$Order <- factor(compmeans1$Order,c("Beetles", "True Bugs","Butterflies","Crickets","Lacewings", "Flies",  "Wasps and Ants","Spiders"))


colnames(curacao.arthropods) <- c("Site", "sitetype", "SR", "AB", "Spiders", "Beetles", "Flies", "True Bugs", "Wasps and Ants", "Butterflies", "Lacewings", "Crickets", "ReportName")
arthMelt <- curacao.arthropods %>%
  select(Site, Spiders:Crickets)

arthMelt <- melt(arthMelt, id = "Site")
colnames(arthMelt) <- c("Site", "Order", "Proportion")
arthMelt$Order <- factor(arthMelt$Order,c("Beetles", "True Bugs","Butterflies","Crickets","Lacewings", "Flies",  "Wasps and Ants","Spiders"))
arthList <- split(arthMelt, f = arthMelt$Site)

# sample individual garden arthropod pie plot
ggplot(data = arthList[[6]], aes(x = "", y = Proportion, fill = Order)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  scale_fill_brewer(palette = "Set1") +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid  = element_blank(),
        axis.title = element_blank(),
        plot.title = element_text(size=22),
        panel.background = element_blank(),
        legend.text = element_text(size=14),
        legend.title = element_text(size = 16)) +
  labs(fill = "Arthropod order",
       title = "Your garden's arthropod composition")


# plot for the three categories
arthType_pie <- ggplot(data = compmeans1, aes(x = "", y = Proportion, fill = Order)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  scale_fill_brewer(palette = "Set1") +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid  = element_blank(),
        axis.title = element_blank(),
        plot.title = element_text(size=18),
        panel.background = element_blank(),
        legend.text = element_text(size=14),
        legend.title = element_text(size = 16),
        strip.text.x = element_text(size = 12.5)) +
  labs(fill = "Arthropod order",
       title = "Average composition of arthropods across all sites") +
  facet_wrap(~`Site Type`)


# Section 3: Run a "for loop" that will cycle through the datasets to create individualized biodiversity reports --------------
report_names <- curacao.arthropods$ReportName # create vector that will determine report names and customizable text in the report
i=1 # start loop at the first site

for (i in 1:3) { # <>< edits to have all reports spit out at once
  # for the sake of demonstration, we will only produce the first five sites' reports
  # vector of garden report names
  report_name <- report_names[i]

  # Native herp plots
  herps_NA <- curacao.nat.herps[i, 3] # create a vector for the if else statement in Rmd to evaluate gardens without nighttime surveys differently


  # Native bird species richness plot
  birdsNat_SR_plot <- ggplot(birdsNat_srTotal[c(i, 32:34),], aes(x = reorder(Site, ord), y = SR)) +
    geom_bar(stat = "identity", aes(fill = Site)) +
    geom_text(aes(label=SR), position = position_dodge(width = 0.9), vjust = 0.5, size = 4.7) +
    scale_fill_manual(values = fun_colors4) +
    labs(y = "Average number of bird species",
         title = "Number of native bird species") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          axis.text.x = element_text(color = "grey20", size=12.2, angle=0, hjust=.5, vjust=.5,
                                     face=c("bold","plain","plain","plain")),
          axis.text.y = element_text(color = "grey20", size=12, angle=0, hjust=.5, vjust=.5, face="plain"),
          axis.title.x=element_blank(),
          legend.position = "none",
          axis.title=element_text(size=13.6),
          plot.title = element_text(size=18))  # This object will be called to compare native bird observations across focal site and site categories.

  # arthropod species richness plot
  arthSR_plot <- ggplot(arthTot[c(i, 32:34),], aes(x = reorder(Site, ord), y = SR)) +
    geom_bar(stat = "identity", aes(fill = Site)) +
    geom_text(aes(label = SR), position = position_dodge(width = 0.9), vjust = .5, size = 4) +
    scale_fill_manual(values = fun_colors4) +
    labs(y = "Number of arthropod species",
         title = "Number of arthropod species ") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          axis.text.x = element_text(color = "grey20", size=12, angle=0, hjust=.5, vjust=.5,
                                     face=c("bold","plain","plain","plain")),
          axis.text.y = element_text(color = "grey20", size=12, angle=0, hjust=.5, vjust=.5, face="plain"),
          axis.title.x=element_blank(),
          legend.position = "none",
          axis.title=element_text(size=13.6),
          plot.title = element_text(size=18)) # This object will be called to compare arthropod species richness across focal site and site categories.

  # arthropod abundance plot
  arthAB_plot <- ggplot(arthTot[c(i, 32:34),], aes(x = reorder(Site, ord), y = AB)) +
    geom_bar(stat = "identity", aes(fill = Site)) +
    geom_text(aes(label = AB), position = position_dodge(width = 0.9), vjust = .5, size = 4) +
    scale_fill_manual(values = fun_colors4) +
    labs(y = "Average number of arthropods",
         title = "Abundance of arthropods") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          axis.text.x = element_text(color = "grey20", size=12, angle=0, hjust=.5, vjust=.5,
                                     face=c("bold","plain","plain","plain")),
          axis.text.y = element_text(color = "grey20", size=12, angle=0, hjust=.5, vjust=.5, face="plain"),
          axis.title.x=element_blank(),
          legend.position = "none",
          axis.title=element_text(size=13.6),
          plot.title = element_text(size=18)) # This object will be called to compare arthropod abundances across focal site and site categories.

  # arthropod composition pie plot for each site
  arthSite_pie <- ggplot(data = arthList[[i]], aes(x = "", y = Proportion, fill = Order)) +
    geom_bar(width = 1, stat = "identity") +
    coord_polar("y", start = 0) +
    scale_fill_brewer(palette = "Set1") +
    theme(axis.text = element_blank(),
          axis.ticks = element_blank(),
          panel.grid  = element_blank(),
          axis.title = element_blank(),
          plot.title = element_text(size=20),
          panel.background = element_blank(),
          legend.text = element_text(size=15),
          legend.title = element_text(size = 17)) +
    labs(fill = "Arthropod order",
         title = "Your garden's arthropod composition") # This object will be called to compare arthropod composition across focal site and site categories.

  # render Rmarkdown files
  knitr::knit_meta(class=NULL, clean = TRUE) # this fixes the error: cannot allocate vector of size
  rmarkdown::render(here::here("report_code/homeowner_reports/homeownerReports_rmd.Rmd"), output_file = paste0('report_output/homeownerReport_example_', report_name, '.html')) # This line executes each site's .html report by calling the .rmd file.
}
