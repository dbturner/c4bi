# R Script for Tick Biodiversity Reports
# Authors: Daniel B. Turner, Jocelyn E. Behm, & Matthew R. Helmus
# Adapted by: Victoria A. Ramirez, Payton Phillips
# Description - This script will complete the following tasks in sections:
#     1. Load data from tick surveys.
#     2. Create objects or lists of some plots to be used in the reports.
#     3. Run a "for loop" that will cycle through the datasets for each plot
#        to create individualized tick biodiversity reports.

# SECTION 1: Load data from tick surveys.---------------------------------------------------

# a. Load relevant R packages
library(dplyr)
library(rmarkdown)
library(knitr)
library(ggplot2)
library(here)
library(RColorBrewer)
library(kableExtra)
library(ggsci)


# b. Load data files
## Note that these are already tidied in a another script,
## so minimal data manipulation will have to take place here
load(here::here("data/tick.sites.rda"))
load(here::here("data/ticks.caught.table.rda"))
load(here::here("data/ticks.caught.rda"))
load(here::here("data/ticks.caught.county.rda"))
load(here::here("data/pathogens.rda"))
load(here::here("data/pathogens.county.rda"))
load(here::here("data/pathogens.table.rda"))
load(here::here("data/mammals.species.richness.rda"))
load(here::here("data/mammals.species.richness.county.rda"))
load(here::here("data/mammals.photos.rda"))
load(here::here("data/mammals.each.site.rda"))


# SECTION 2: Create objects or lists of some plots to be used in the reports. ----------
## Here we need to define our owners/property managers, so R knows "who" to
## create each report for
## This "Owners" will be used in the for loop and its "i" (each entry in "Owners")
## will be used in the R markdown to call individualized values, in naming files, etc.

Owners <- factor(unique(tick.sites$Ownership))



# SECTION 3: Run a "for loop" that will cycle through the datasets to create individualized reports.           --------------------------------------------------
for (i in Owners){ ## ends at line 403


 #Section 1---------------------------------------------------------------------

  ## 1a. First is the tick species table, identifying which species were present
  ## and which were absent at each site-----------------------------------------

  ## We can make a function to define how to make the kable and modify it for each
  ## kable hereafter
  make_table_2 <- function(df) { ## ends at line 74

    kable(df, format = "html", align = "llllll", ## align all columns to the left
            escape = FALSE) %>% ## this argument allows our formatting to work (i.e. italic species names)
        kable_paper('striped', ## in HTML format (NOT PDF) "striped" creates alternating gray and white rows
                    full_width = F) %>%
        column_spec(1, width = "15em", bold = T, border_right = T) %>%
        column_spec(2, width = "15em", border_right = T) %>%
        column_spec(3, width = "15em", border_right = T)%>%
        column_spec(4, width = "15em", border_right = T) %>%
        column_spec(5, width = "12em", border_right = T) %>%
        column_spec(6, width = "15em", border_right = T)

  } ## starts at line 61

  ## now specifically define the table here, assigning it to an object so it can
  ## be called in the R markdown
  tick_table <- ticks.caught.table %>%
    ## filter by i so it only shows the sites within the called Owner
    filter(Ownership == i) %>%
    ungroup() %>%
    select(-c(Ownership, County)) %>% ## we do not need these columns in the table
    ## now do conditional table formatting to make the "Yes" cells stand out in bold and green
    mutate(
      `American Dog Tick` = cell_spec(`American Dog Tick`,
                                      bold = ifelse(
                                        `American Dog Tick` == "Yes", T, F),
                                      color = ifelse(
                                        `American Dog Tick` == "Yes", "green", "black")),
      `Black Legged Tick` = cell_spec(`Black Legged Tick`,
                                      bold = ifelse(
                                        `Black Legged Tick` == "Yes", T, F),
                                      color = ifelse(
                                        `Black Legged Tick` == "Yes", "green", "black")),
      `Brown Dog Tick` = cell_spec(`Brown Dog Tick`,
                                   bold = ifelse(
                                     `Brown Dog Tick` == "Yes", T, F),
                                   color = ifelse(
                                     `Brown Dog Tick` == "Yes", "green", "black")),
      `Lone Star Tick` = cell_spec(`Lone Star Tick`,
                                   bold = ifelse(
                                     `Lone Star Tick` == "Yes", T, F),
                                   color = ifelse(
                                     `Lone Star Tick` == "Yes", "green", "black")),
      `Longhorned Tick` = cell_spec(`Longhorned Tick`,
                                    bold = ifelse(
                                      `Longhorned Tick` == "Yes", T, F),
                                    color = ifelse(
                                      `Longhorned Tick` == "Yes", "green", "black"))
    ) %>%
    ## now pass everything through the function that calls kable and makes a table!
    make_table_2()

  ## 1b. Now make the bar charts showing tick abundance by species at each site
  ## compared to the county averages-------------------------------------------

  ## The first thing is to define our sites and levels (sites AND counties)
  ## so we can do conditional formatting within the ggplot()
  Sites <- unique(subset(ticks.caught, Ownership == i)$Site)
  levels <- c('Chester','Delaware','Philadelphia',
              unique(subset(ticks.caught,
                            Ownership == i)$Site))

  ## Now assign the ggplot object to a name that can be called in the Rmd
  tick_abundance_plot <- ggplot(data = subset(ticks.caught, Ownership == i),
  ## subsetting the data by Ownership = i is what allows us to only show the sites
  ## relevant to each owner/property manager
                           aes(x = Site, y = ticks_site, fill = County)) +
    geom_bar(stat = "identity") +
  ## now plot the county level bars separately
    geom_bar(data = ticks.caught.county,
             ## ceiling rounds everything up to the nearest whole number
             aes(x = County, y = ceiling(ticks_county), fill = County),
             stat = "identity", alpha = 0.5) +
             ## alpha = 0.5 so there is a visual difference between the counties and sites
    geom_text(data = subset(ticks.caught, Ownership == i),
              aes(label = ifelse(ticks_site > 0, ## ifelse() so we do not label zeroes
                                 ticks_site,
                                 NA)),
              position = position_dodge(0.5),
              vjust= 0.35,
              hjust="inward",
              size = 3, fontface = "bold") + ## bold the site labels so they stand out
    geom_text(data = ticks.caught.county,
              aes(x = County,
                  y = ceiling(ticks_county),
                  group = County,
                  label = ifelse(ticks_county > 0, ## ifelse() so we do not label zeroes
                                 ceiling(ticks_county),
                                 NA)),
              position = position_dodge(0.5),
              vjust= 0.35,
              hjust="inward",
              size = 3, fontface = "plain") +
    theme_bw() + ## instead of theme_classic() do theme_bw() so the facets look neater
    facet_grid(~Species) +
    ## scale the x axis so we can define our own order instead of it being alphabetical
    ## in this case we always want the sites and counties to be separated
    ## do the counties first since we have a coord_flip() later on
    scale_x_discrete(limits = c('Chester','Delaware','Philadelphia', "Chester", #COME BACK TO THIS
                                unique(subset(ticks.caught,
                                              Ownership == i)$Site)),
                     breaks = c('Chester','Delaware','Philadelphia', "Chester",
                                unique(subset(ticks.caught,
                                              Ownership == i)$Site)),
                     drop = T) +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(color = "grey20",
                                     size=12.2,
                                     angle=0,
                                     vjust=0.3,
                        ## this is why we defined sites and levels above,
                        ## now we can bold just the site names on the axis labels
                                     face = ifelse(levels %in% Sites,
                                                   "bold", "plain")),
          legend.position = "right",
          ## change the size of the font in the facet labels so it is visible
          strip.text.x = element_text(size = 10),
          ## get rid of the grids so the bars are easier to see
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    scale_fill_brewer(palette = "Set2") +
    guides(fill = guide_legend(nrow = 3)) +
    coord_flip() +
    labs(x = "", ## leave the sites/county axis name blank since it is intuitive
         y = "Number of Ticks Caught")


  #Section 2--------------------------------------------------------------------
  ## 2a. Make a simple table identifying which diseases were present and absent
  ## at all sites for each Owner ----------------------------------------------

  ## Just as above, make the modified kable function fit to this dataset
  make_table_3 <- function(df) { ## ends at 204
    kable(df, format = "html", align = "lllll",
            escape = F) %>%
        kable_paper('striped',
                    full_width = F) %>%
        column_spec(1, width = "15em", bold = T, border_right = T) %>%
        column_spec(2, width = "10em", border_right = T) %>%
        column_spec(3, width = "15em", border_right = T)%>%
        column_spec(4, width = "15em", border_right = T) %>%
        column_spec(5, width = "12em", border_right = T)
    } ## starts at line 194

  ## Again define the assign the table output to an object
  pathogens.table.kable <- pathogens.table %>%
    filter(Ownership == i) %>%
    ungroup() %>%
    rename("Number of nymphs tested" = total_nymphs_site) %>%
    select(-c(Ownership, `Not infected`)) %>% ## do not want these columns..
    ## but we do want these columns
    select(Site, `Number of nymphs tested`, `Lyme disease`, Anaplasma, Babesia) %>%
    ## again conditionally assign bold and green text to "Yes" cells
    mutate(
      `Lyme disease` = cell_spec(`Lyme disease`,
                                 bold = ifelse(
                                   `Lyme disease` == "Yes", T, F),
                                 color = ifelse(
                                   `Lyme disease` == "Yes", "green", "black")),
      Anaplasma = cell_spec(Anaplasma,
                            bold = ifelse(
                              Anaplasma == "Yes", T, F),
                            color = ifelse(
                              Anaplasma == "Yes", "green", "black")),
      Babesia = cell_spec(Babesia,
                          bold = ifelse(
                            Babesia == "Yes", T, F),
                          color = ifelse(
                            Babesia == "Yes", "green", "black"))
    ) %>%
    make_table_3()


   ##2b. County level disease prevalence pie charts------------------------------

  county_pathogens <-  ggplot(data = pathogens.county,
                            aes(x = "", y = prop_inf_county, fill = Disease)) +
    geom_bar(stat="identity", width=1) +
    ## use a facet_wrap so each county gets its own pie chart
    facet_wrap(~County) +
    ## this is how a bar chart gets turned into a pie chart using ggplot()
    coord_polar("y", start=0, clip = "off") +
    theme_void() + ## gets rid of background clutter we do not want
    ## below each pie chart add a label for number of nymphs tested
    geom_text(aes(label = paste(nymphs_county, "Nymphs tested", sep = " ")),
              x = 1.7,
              y = 3.5, ## this x,y position puts each label center & below each chart
              size = 3,
              fontface='italic',
              stat = 'identity',
              inherit.aes = FALSE) +
    scale_fill_brewer(palette = "Set3") +
    theme(legend.position = "right",
          ## define margins in title otherwise it is very close to each facet label
          plot.title = element_text(size = 18, margin=margin(0,0,20,0)),
          strip.text.x = element_text(size = 15))

      ## note that there is a lot of white space created with these pie charts,
      ## to address this change the fig size in the Rmd chunks


  #Section 3---------------------------------------------------------------------

  ## 3a. Species richness plot
  ## Again define our sites and levels (sites AND counties)
  ## so we can do conditional formatting within the ggplot()
  Sites <- unique(subset(mammals.species.richness, Ownership == i)$Site)
  levels <- c('Chester','Delaware','Philadelphia',
              unique(subset(mammals.species.richness,
                            Ownership == i)$Site))

    wild_species_richness <- ggplot(data = subset(mammals.species.richness, Ownership == i),
                             aes(x = Site, y = species_richness, fill = County)) +
      geom_bar(stat = "identity") +
      ## using stat_summary gives the same desired output at geom_bar but without the issues
      stat_summary(data = mammals.species.richness,
                   aes(x = County, y = county_avg_rich),
                   alpha = 0.5, stat = "identity", fun = "mean", geom = "bar") +
      geom_text(data = subset(mammals.species.richness, Ownership == i),
                aes(label=species_richness),
                position = position_dodge(width = 0.5),
                vjust = 0.5, hjust = 1,
                size = 5, fontface = "bold") +
      geom_text(data = mammals.species.richness.county,
                aes(x = County,
                    y = county_avg_rich,
                    label= ceiling(county_avg_rich)),
                position = position_dodge(width = 0.5),
                vjust = 0.5, hjust = 1,
                size = 5, fontface = "plain") +
      theme_classic() +
      scale_x_discrete(limits = c('Chester','Delaware','Philadelphia', "Chester",
                                  unique(subset(mammals.species.richness,
                                                Ownership == i)$Site)),
                       breaks = c('Chester','Delaware','Philadelphia', "Chester",
                                  unique(subset(mammals.species.richness,
                                                Ownership == i)$Site)),
                       drop = T) +
      theme(axis.text.x = element_text(size = 12),
            axis.text.y = element_text(color = "grey20",
                                       size=12.2,
                                       angle=0,
                                       vjust=0.3,
                                       face = ifelse(levels %in% Sites, "bold", "plain")),
            legend.position = "right") +
      scale_fill_brewer(palette = "Set2") +
      guides(fill = guide_legend(nrow = 5)) +
      coord_flip() +
      labs(x = "",
           y = "Number of Species")


    ##3b. Stacked bar chart- number of photos per species

    Sites <- unique(subset(mammals.photos, Ownership == i)$Site)
    levels <- c('Chester','Delaware','Philadelphia',
                unique(subset(mammals.photos,
                              Ownership == i)$Site))


    wild_photo_abundance <- ggplot(data = subset(mammals.photos, Ownership == i),
                             aes(x = Site, y = species_photos, fill = Species)) +
      geom_bar(stat = "identity", position = "stack") +
      ## using stat_summary gives the same desired output at geom_bar but without the issues
      stat_summary(data = mammals.photos,
                   aes(x = County, y = county_avg_photo, fill = Species),
                   stat = "identity", position = "stack", geom = "bar", fun = "mean") +
      theme_classic() +
      scale_x_discrete(limits = c('Chester','Delaware','Philadelphia', "Chester",
                                  unique(subset(mammals.photos,
                                                Ownership == i)$Site)),
                       breaks = c('Chester','Delaware','Philadelphia', "Chester",
                                  unique(subset(mammals.photos,
                                                Ownership == i)$Site)),
                       drop = T) +
      theme(axis.text.x = element_text(size = 12),
            axis.text.y = element_text(color = "grey20",
                                       size=12.2,
                                       angle=0,
                                       vjust=0.3,
                                       face = ifelse(levels %in% Sites, "bold", "plain")),
            legend.position = "right") +
      scale_fill_simpsons("springfield") +
      guides(fill = guide_legend(ncol = 2,
                                 title.position = "top")) +
      coord_flip() +
      labs(x = "",
        y = "Number of Photos")


    ##3c. List of wildlife "species" present vs absent at sites
    ## This function is a bit different from the others, as we have to do
    ## an ifelse() since one ownership (Swarthmore) does not have wildlife
    ## data, otherwise it will force the whole code to quit since it does
    ## not have the columns we are formatting
    make_table <- function(df) { ## ends at line 369
      # If there is no data, don't add the column_spec
      if(nrow(df)==0) { ## ends at line 361
        kable(df, format = "html") %>%
          kable_paper('striped',
                      full_width = F)
      } else { # Otherwise do add the styling // ## ends at line 368
        kable(df, format = "html") %>%
          kable_paper('striped',
                      full_width = F) %>%
          column_spec(1, bold = T, border_right = T) %>%
          column_spec(2, width = "30em", border_right = T) %>%
          column_spec(3, width = "30em", border_right = T)
      } ## starts at line 361
    } ## starts at line 355

    wildlife_table <- mammals.each.site %>%
      filter(Ownership == i) %>%
      ungroup() %>%
      select(-c(site_code, Ownership, County)) %>%
      make_table()

    # Misc.---------------------------------------------------------------------
    ## The information here is used throughout the report text

    ## number of sites surveyed throughout ticks, wildlife, etc.
    numSites <- length(unique(subset(tick.sites, Ownership == i)$Site))
    ## number of sites surveyed specifically for ticks
    numTickSites <- length(unique(subset(ticks.caught, Ownership == i)$Site))
    ## number of sites where camera trapping was done
    numCamSites <- length(unique(subset(mammals.photos, Ownership == i)$Site))

    ## list of sites surveyed throughout
    listSites <- unique(subset(tick.sites, Ownership == i)$Site)
    ## list of sites surveyed for ticks
    listTickSites <- unique(subset(ticks.caught, Ownership == i)$Site)
    ## list of sites where cameras were used
    listCamSites <- unique(subset(mammals.photos, Ownership == i)$Site)
    ## for sites where cameras weren't used we could say "none of your properties"
    ## instead of an NA output, but we will use an alternative with Rmd chunks
    #listCamSites <- ifelse(length(listCamSites) == 0, "none of your properties", listCamSites)


    render(here("report_code/tick_reports/tickReports_rmd.Rmd"), output_file = paste0('report_output/tick_report_', i, ".html"), "html_document") # This line executes each owner's .html report by calling the "child" .rmd file.
    ## now this line above renders everything in whatever spot you choose within the Rmd!
    # NOTE: The .rmd should be located in the same workspace directory as this R script.
    # ANOTHER NOTE: The .html files will be located in the same workspace directory as this R script.

} ## starts at line 51
