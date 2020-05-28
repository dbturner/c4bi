# Parent script for Curaçao reports
# Author: Daniel B Turner, Matthew R. Helmus
# last updated by D.T: 2 December 2018
# last updated by M.R.H: 20 December 2018

rm(list=ls())

# load packages ----------------------------------------------------------------------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(rmarkdown)
library(reshape2)
library(tidyr)
library(kableExtra)
library(knitr)
library(here)

# global parameters -----------------------------------------------------------------------------------------------------------------
puk <- 0 # number of digits to round

# set color palette
fun_colors3 <- c("palegreen2", "steelblue2", "lightgoldenrod2") # assign vector of three color names for plots
fun_colors4 <- c("palegreen2", "steelblue2", "lightgoldenrod2", "lightpink") # assign vector of four color names for plots
# forest = blue, garden = yellow, scrub = red,  your = green
fun_colors3 <- c("steelblue2", "lightgoldenrod2","lightpink") # assign vector of three color names for plots
fun_colors4 <- c("steelblue2", "lightgoldenrod2", "lightpink", "palegreen2") # assign vector of four color names for plots

# native herps ---------
# wrangle native herp data

# set working directory to downloaded folder

herps_nat <- read.csv("data/Curacao native herps.csv") # load native herp dataset


herps_nat_noNA <- na.omit(herps_nat) # create dataframe of sites without NAs to calculate means more easily

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

colnames(herps_nat)[3:7] <- c("Dutch Leaf-toed Gecko", "Antillean Dwarf Gecko", "Striped Anole", "Laurent's Whiptail", "Turnip-tailed Gecko")
colnames(herps_nat_means)[2:6] <- c("Dutch Leaf-toed Gecko", "Antillean Dwarf Gecko", "Striped Anole", "Laurent's Whiptail", "Turnip-tailed Gecko")

herps_natList <- split(herps_nat, f = herps_nat$Site) # create a list that separates the native herp observations by site so they can be listed in each site's unique report

for(i in 1:31){
  herps_natList[[i]]$Site <- c("Your garden")
} # Change site name so that reader sees "Your garden"

herps_nat_long <- vector("list", 31)

# exotic herps ------------
# wrangle exotic herp proportion data
herps_exo_prop <- read.csv("data/Curacao exotic herps summary stats.csv") # load data

colnames(herps_exo_prop) <- c("species", "Site Type", "Percentage of sites") # change column names

herps_exo_prop$`Percentage of sites` <- round(herps_exo_prop$`Percentage of sites`, puk)
herps_exo_prop$species <- factor(herps_exo_prop$species,c("Mourning Gecko",
                                                          "Asian House Gecko",
                                                          "Tropical House Gecko",
                                                          "Colombian Four-eyed Frog",
                                                          "Johnstone's Whistling Frog",
                                                          "Cuban Tree Frog"))

# create plot
herps_exo_prop_plot <- ggplot(data = herps_exo_prop, aes(x = `Site Type`, y = `Percentage of sites`, fill = `Site Type`)) +
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
herps_exo_sp <- read.csv("data/Curacao exotic herps.csv") # load data
colnames(herps_exo_sp) <- c("Site", "sitetype", "Mourning Gecko", "Tropical House Gecko", "Johnstone's Whistling Frog", "Cuban Treefrog", "Colombian Four-eyed Frog", "Asian House Gecko", "ReportName")

herps_exo_spMelt <- melt(herps_exo_sp, id = c("Site", "sitetype", "ReportName"))

herps_exo_spMelt$variable <- as.character(herps_exo_spMelt$variable)

herps_exo_spMelt <- herps_exo_spMelt[order(herps_exo_spMelt$ReportName, -herps_exo_spMelt$value),]

herps_exoList <- split(herps_exo_spMelt, f = herps_exo_spMelt$Site)

herps_exoList[[1]][1, 4] # check to see if the dataframes were separated correctly

# native birds ---------------
# load data for species list
birds_nat <- read.csv("data/Curacao native birds list.csv") # load data

# tidy data for species list
birds_nat$Scientific.name <- paste0("(", birds_nat$Scientific.name, ")")
birds_nat$Common.Name <- as.character(birds_nat$Common.Name)
birds_nat$bird.Name <- paste(birds_nat$Common.Name, birds_nat$Scientific.name)

# wrangle data for Rmd file for species list
birds_nat <- birds_nat[order(birds_nat$Site, -birds_nat$Present),]

birds_natList <- split(birds_nat, f = birds_nat$Site)

birds_natList[[1]]

# load data for species richness
birdsNat_sr <- read.csv("data/Curacao native birds.csv")

# wrangle native bird species richness data
birdsNat_sr_sum <- birdsNat_sr %>%
  group_by(sitetype) %>%
  summarise(SR = round(mean(SR), puk))

birdsNat_sr_sum$Site <- NA
birdsNat_sr_sum$ReportName <- NA

birdsNat_srTotal <- rbind(birdsNat_sr, birdsNat_sr_sum)

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

# exotic birds ------------
# load exotic birds data
birds_exo <- read.csv("data/Curacao exotic birds summary stats.csv")

# wrangle exotic birds data
colnames(birds_exo) <- c("species", "Site Type", "Percentage of sites")

birds_exo$`Percentage of sites` <- round(birds_exo$`Percentage of sites`, puk)
birds_exo$species <- factor(birds_exo$species,c("Exotic Parrots",
                                                "Chestnut-fronted Macaw",
                                                "Rock Pigeon",
                                                "Saffron Finch",
                                                "House Sparrow"))

# plot exotic bird proportions
birds_exo_prop_plot <- ggplot(data = birds_exo, aes(x=`Site Type`, y = `Percentage of sites`, fill = `Site Type`)) +
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
birdsExo_List <- read.csv("data/Curacao exotic birds.csv") # load data

colnames(birdsExo_List) <- c("Site", "sitetype", "Exotic Parrots", "Cheshnut-fronted Macaw", "Rock Pigeon", "House Sparrow", "Saffron Finch", "ReportName")

birdsExo_List <- melt(birdsExo_List, id = c("Site", "sitetype", "ReportName"))

birdsExo_List <- birdsExo_List[order(birdsExo_List$Site, -birdsExo_List$value),]

birdsExo_List <- split(birdsExo_List, f = birdsExo_List$Site)




# arthropods -----------
arth <- read.csv("data/Curacao arthropods.csv") # load data

# wrangle arthropod data
arthDiv <- arth %>%
  select(Site:AB, ReportName)

arthSum <- arth %>%
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
compmeans <- aggregate(arth[,5:12], list(arth$sitetype), mean)
colnames(compmeans) <- c("Group 1", "Spiders", "Beetles", "Flies", "True Bugs", "Wasps and Ants", "Butterflies", "Lacewings", "Crickets")
compmeans1 <- melt(compmeans, id = "Group 1")
colnames(compmeans1) <- c("Site Type", "Order", "Proportion")
compmeans1$Order <- factor(compmeans1$Order,c("Beetles", "True Bugs","Butterflies","Crickets","Lacewings", "Flies",  "Wasps and Ants","Spiders"))


colnames(arth) <- c("Site", "sitetype", "SR", "AB", "Spiders", "Beetles", "Flies", "True Bugs", "Wasps and Ants", "Butterflies", "Lacewings", "Crickets", "ReportName")
arthMelt <- arth %>%
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






##########################################################################################################
# loop through all of dataframes to create individual reports for each garden ------------
##########################################################################################################
report_names <- arth$ReportName # create vector that will determine report names and customizable text in the report
i=1 # start loop at the first site

for (i in 1:5) { # <>< edits to have all reports spit out at once
                 # for the sake of demonstration, we will only produce the first five sites' reports
  # vector of garden report names
  report_name <- report_names[i]

  # Native herp plots
  herps_NA <- herps_nat[i, 3] # create a vector for the if else statement in Rmd to evaluate gardens without nighttime surveys differently


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
  rmarkdown::render("analysis/homeownerReports_rmd.Rmd", output_file = paste0('userReports_caseStudy1/homeownerReport_example_', report_name, '.html')) # This line executes each site's .html report by calling the "child" .rmd file.
}
