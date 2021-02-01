#' Template data
#'
#' Dataframe containing sample data from a fictitious survey of birds and trees from three towns
#' In this dataset, three parks, all named affectionately after insect groups, in each town were surveyed for ten days.
#'
#' @format R data.frame
#' \describe{
#' \item{town}{name of town}
#' \item{park}{name of park within town}
#' \item{day}{day of sampling}
#' \item{num_trees}{number of trees sampled in the park}
#' \item{num_birds}{number of birds counted in the park on that day}

#' }
"town"


#' Curaçao arthropod data
#'
#' Dataframe containing arthropod data from Curaçao homeowner sampling.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{name of the focal property, to be used for report title generation (anonymized by letter here).}
#'   \item{sitetype}{land-use category for the focal property.}
#'   \item{SR}{species richness of arthropods found at the property.}
#'   \item{Spiders}{proportion of all arthropods found at the property that were spiders (Araneae)}
#'   \item{Beetles}{proportion of all arthropods that were beetles (Coleoptera)}
#'   \item{Flies}{proportion of all arthropods that were true flies (Diptera)}
#'   \item{True Bugs}{proportion of all arthropods that were true bugs (Hemiptera)}
#'   \item{Wasps and Ants}{proportion of all arthropods that were wasps and ants (Hymenoptera)}
#'   \item{Butterflies}{proportion of all arthropods that were butterflies (Lepidoptera)}
#'   \item{Lacewings}{proportion of all arthropods that were lacewings (Neuroptera)}
#'   \item{Crickets}{proportion of all arthropods that were crickets (Orthoptera)}


#' }
"curacao.arthropods"


#' Curaçao exotic birds summary data
#'
#' Dataframe summarizing the sites where exotic birds were observed at Curaçao homeowner sites.
#'
#' @format R data.frame
#' \describe{
#'   \item{species}{common name of exotic bird species observed on properties}
#'   \item{Site Type}{land-use category for the focal property}
#'   \item{Percentage of Sites}{The number of sites where each bird species was observed in each category}

#' }
"curacao.exo.birds.sum"


#' Curaçao exotic birds
#'
#' Dataframe containing exotic bird data from Curaçao homeowner sampling.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{name of the focal property (anonymized by letter here)}
#'   \item{sitetype}{land-use category for the focal property}
#'   \item{Exotic parrots}{abundance of exotic parrots at focal property}
#'   \item{Chestnut-fronted Macaw}{abundance of Chestnut-fronted Macaws at focal property}
#'   \item{Rock Pigeon}{abundance of Rock Pigeons at focal property}
#'   \item{House Sparrow}{abundance of House Sparrows at focal property}
#'   \item{Saffron Finch}{abundance of Saffron Finches at focal property}
#'   \item{ReportName}{name of report for references (not required)}
#'
#' }
"curacao.exo.birds"


#' Curaçao exotic herps data
#'
#' Dataframe containing exotic reptile and amphibian data from Curaçao homeowner sampling.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{name of the focal property (anonymized by letter here)}
#'   \item{sitetype}{land-use category for the focal property}
#'   \item{Mourning Gecko}{abundance of Mourning Gecko at focal property.}
#'   \item{Tropical House Gecko}{abundance of Tropical House Gecko at focal property.}
#'   \item{Johnstone's Whistling Frog}{abundance of Johnstone's Whistling Frog at focal property}
#'   \item{Cuban Tree Frog}{abundance of Cuban Tree Frog at focal property}
#'   \item{Colombian Four-eyed Frog}{abundance of Colombian Four-eyed Frog at focal property}
#'   \item{Asian House Gecko}{abundance of Asian House Gecko at focal property}
#'   \item{ReportName}{name of report for references (not required)}
#'
#' }
"curacao.exo.herps"


#' Curaçao exotic herps summary data
#'
#' Dataframe summarizing the sites where exotic reptiles and amphibians were observed at Curaçao homeowner sites.
#'
#' @format R data.frame
#' \describe{
#'   \item{species}{common name of exotic herp species observed on properties}
#'   \item{Site Type}{land-use category for the focal property}
#'   \item{Percentage of Sites}{the number of sites where each herp species was observed in each category}
#'
#' }
"curacao.exo.herps.sum"


#' List of Curaçao native birds
#'
#' Dataframe with binary presence/absence variable for each bird species found at a Curaçao homeowner site.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{name of the focal property (anonymized by letter here)}
#'   \item{sitetype}{land-use category for the focal property}
#'   \item{Scientific name}{number of sites where each herp species was observed in each category}
#'   \item{Present}{number of sites where each herp species was observed in each category}
#'   \item{Common Name}{common name of native bird species in Curaçao}
#'
#' }
"curacao.nat.birds.list"


#' Curaçao native bird data
#'
#' Dataframe containing native bird data from Curaçao homeowner sampling.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{name of the focal property (anonymized by letter here)}
#'   \item{sitetype}{land-use category for the focal property}
#'   \item{SR}{species richness of native birds found at the focal property}
#'   \item{ReportName}{name of report for references (not necessary)}
#'
#' }
"curacao.nat.birds"


#' Curaçao native herp summary data
#'
#' Dataframe summarizing the sites where native reptiles and amphibians were observed at Curaçao homeowner sites.
#'
#' @format R data.frame
#' \describe{
#'   \item{sitetype}{land-use category for the focal property}
#'   \item{species}{common name of native herp species on properties}
#'   \item{mean}{mean abundance of each native herp species on each property within a land-use category}
#'
#' }
"curacao.nat.herps.sum"


#' Curaçao native herp data
#'
#' Dataframe containing native bird data from Curaçao homeowner sampling.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{name of the focal propety (anonymized by letter here)}
#'   \item{sitetype}{land-use category for the focal property}
#'   \item{Dutch Leaf-toed Gecko}{abundance of Dutch Leaf-toed Gecko at focal property}
#'   \item{Antillean Dwarf Gecko}{abundance of Antillean Dwarf Gecko at focal property}
#'   \item{Striped Anole}{abundance of Striped Anole at focal property}
#'   \item{Laurent's Whiptail}{abundance of Laurent's Whiptail at focal property}
#'   \item{Turnip-tailed Gecko}{abundance of Turnip-tailed Gecko at focal property}
#'   \item{ReportName}{name of report for references (not necessary)}
#'
#' }
"curacao.nat.herps"

#' Arthropod abundance and richness data
#'
#' Dataframe containing arthropod predator abundance and richness data from southeastern Pennsylvania farms.
#'
#' @format R data.frame
#' \describe{
#'   \item{farmName}{the general name of 6 individual farms of three "urbanization categories" (high, medium, low) and the names of the three categories to plot as comparisons to category means in abundance and richness plots}
#'   \item{meanAbun}{mean abundance of arthropod predators on each farm across all pitfall traps}
#'   \item{meanRich}{mean richness of arthropod predator families on each farm across all pitfall traps}
#'   \item{urbanCat}{the urbanization category of each individual farm to be print out in the .html file}
#'
#' }
"abun.rich.sepa"

#' Arthropod diversity data for pie chart
#'
#' Dataframe containing proportional abundacne of major orders of arthropod predators from total arthropod abundance on southeastern Pennsylvania farms; used to make pie charts.
#'
#' @format R data.frame
#' \describe{
#'   \item{farmName}{the general name of 6 individual farms of three "urbanization categories" (high, medium, low)}
#'   \item{family}{common name of arthropod predator family}
#'   \item{meanAbun}{mean abundance of arthropod predators in each family across all pitfall traps}
#'   \item{prop}{proportion of family abundance over the total number of arthropod predators across all pitfall traps at a farm}
#'
#' }
"arth.div.pie.sepa"

#' Plant community & arthropod richness data
#'
#' Dataframe containing arthropod richness and plant community data from southeastern Pennsylvania farms.
#'
#' @format R data.frame
#' \describe{
#'   \item{farmName}{the general name of 15 individual farms of three "urbanization categories" (low, medium, high urbanization		  intensity) and the names of the three categories to plot as comparisons to category means in abundance and richness plots.}
#'   \item{richness}{richness of arthropod predator families in each pitfall trap on a farm}
#'   \item{urbanCat}{the urbanization category of each individual farm to be print out in the .html file}
#'   \item{weedyCover}{the percent ground cover of non-crop plants in a 2-meter radius circle around the pitfall trap}
#'
#' }
"interact.rich.sepa"

#' Plastic mulch & arthropod richness data
#'
#' Dataframe containing arthropod abundance and richness data from traps based on presence/absence of plastic mulch.
#'
#' @format R data.frame
#' \describe{
#'   \item{category}{factor of pitfall traps placed under plastic mulch ("Plastic) or not under plastic mulch ("No plastic")}
#'   \item{meanAbun}{mean abundance of arthropod predators in each pitfall trap}
#'   \item{meanRich}{mean family richness of arthropod predators in each pitfall trap}
#'
#' }
"plastic.sepa"

#' Tick-borne disease presence/absence and tick nymph abundance data
#'
#' Dataframe containing nymph tick abundances and presence/absence of tick-borne diseases.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{site name}
#'   \item{total_nymphs_site}{tick nymphs tested for disease at that site}
#'   \item{Ownership}{property manager of that site}
#'   \item{Anaplasma}{presence/absence of Anaplasma in a tick nymph from that site}
#'   \item{Babesia}{presence/absence of Babesia in a tick nymph from that site}
#'   \item{Lyme disease}{presence/absence of Lyme disease in a tick nymph that site}
#'   \item{Not infected}{Uninfected tick nymph found at that site}
#'
#' }
"pathogens.table"


#' Tick abundances by site data
#'
#' Dataframe containing tick abundances aggregated across life stages by site.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{site name}
#'   \item{Species}{tick species common name}
#'   \item{County}{site county}
#'   \item{Ownership}{property manager of that site}
#'   \item{ticks_site}{number of ticks found at that site}
#'
#' }
"ticks.caught"


#' Tick abundances by county data
#'
#' Dataframe containing ticks aggregated across all life stages by county.
#'
#' @format R data.frame
#' \describe{
#'   \item{County}{site county}
#'   \item{Species}{tick species' common name}
#'   \item{ticks county}{mean tick abundance}
#'   \item{sd_ticks_county}{standard deviation of tick abundance}
#'
#' }
"ticks.caught.county"


#' Tick presence/absence data
#'
#' Dataframe containing the presence/absence data of tick species for each site.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{site name}
#'   \item{County}{site county}
#'   \item{Ownership}{property manager of that site}
#'   \item{American Dog Tick}{presence/absence of American Dog Tick at that site}
#'   \item{Black Legged Tick}{presence/absence of Black Legged Tick at that site}
#'   \item{Brown Dog Tick}{presence/absence of Brown Dog Tick at that site}
#'   \item{Lone Star Tick}{presence/absence of Lone Star Tick at that site}
#'   \item{Longhorned Tick}{presence/absence of Longhorned Tick at that site}
#'
#' }
"ticks.caught.table"


#' Mammals and birds presence/absence
#'
#' Dataframe containing names of animals found at each site.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{site name}
#'   \item{site_code}{site code (two-three letter unique identifier when not anonymized)}
#'   \item{Ownership}{property manager of that site}
#'   \item{County}{site county}
#'   \item{Present at your site}{character string of animals present}
#'
#' }
"mammals.each.site"

#' Mammals and birds observation count data
#'
#' Dataframe containing the number of photo observations of animals species at each site.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{site name}
#'   \item{site_code}{site code (two-three letter unique identifier when not anonymized)}
#'   \item{Ownership}{property manager of that site}
#'   \item{County}{site county}
#'   \item{species}{animal species}
#'   \item{species_photos}{number of species' photographed observations}
#'
#' }
"mammals.photos"

#' Mammals and birds richness by site data
#'
#' Dataframe containing mammal and bird species richness by site.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{site name}
#'   \item{site_code}{site code (two-three letter unique identifier when not anonymized)}
#'   \item{Ownership}{property manager of that site}
#'   \item{County}{site county}
#'   \item{species_richness}{species richness at each site}
#'   \item{county_avg_rich}{average species richness in site's county}
#'
#' }
"mammals.species.richness"

#' Mammals and birds richness by county data
#'
#' Dataframe containing mammal and bird species richness by county.
#'
#' @format R data.frame
#' \describe{
#'   \item{County}{county name}
#'   \item{county_avg_rich}{average species richness in each county}
#'
#' }
"mammals.species.richness.county"


#' Tick-borne disease prevalence by county data
#'
#' Dataframe containing tick-borne disease prevalence in tick nymphs.
#'
#' @format R data.frame
#' \describe{
#'   \item{County}{county name}
#'   \item{Disease county}{tick-borne disease combination indicator ('new' does _not_ mean new to that county)}
#'   \item{nymphs_county}{total tick nymphs tested for disease in that county}
#'   \item{prop_inf_county}{proportion of county's nymphs found with that combination of tick-borne disease}
#'   \item{Disease}{disease name to present in figure}
#' }
"pathogens.county"

#' Tick-borne disease prevalence by site data
#'
#' Dataframe containing arthropod abundance and richness data from traps based on presence/absence of plastic mulch.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{site name}
#'   \item{total_nymphs_site}{tick nymphs tested for disease at that site}
#'   \item{Disease}{disease name to present in figure}
#'   \item{Ownership}{property manager of that site}
#'   \item{prop_inf}{proportion of the site's nymphs found with that combination of tick-borne disease}
#'
#' }
"pathogens"

#' Tick and camera data availability by site
#'
#' Dataframe containing arthropod abundance and richness data from traps based on presence/absence of plastic mulch.
#'
#' @format R data.frame
#' \describe{
#'   \item{Site}{site name}
#'   \item{site_code}{site code (two-three letter unique identifier when not anonymized)}
#'   \item{Ownership}{property manager of that site}
#'   \item{Ticks}{presenece/absence of tick data that site}
#'   \item{Cameras}{presence/absence of camera trap pictures}
#'   \item{County}{county name}
#' }
"tick.sites"


