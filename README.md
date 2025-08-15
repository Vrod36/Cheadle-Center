# Abstract


 Bees are around us everyday, yet we don’t truly understand them beyond the famous Honey Bee or Bumble Bee. With climate becoming rapidly inconsistent, we are fighting to gain the knowledge of how this phenomenon interacts with a bee’s ability to tolerate temperature (CTmin/CTmax). We conducted thermal tolerance assays on 170 bees in Santa Barbara and the Sierra Nevadas from many different generas, with a focus on Elevation. Within our tests, other variables were also taken into account for accuracy, such as Wet Mass, Duration spent in Vials, and Body Size. Our linear regression models have portrayed that the most significant variable towards a bee’s critical thermal minimum (CTmin). With a p-value of 0.001, the model shows that as elevation increases the CTmin of a bee will decrease. This means that bees living in higher elevations are more resistant to cold temperatures. We have also found that the heat tolerance of bees is surprisingly consistent among all variables. Through this project, our hope is that further research is done towards understanding the complexities of a relationship between bees and temperature change. 

# Context
Thanks to working under the Fuerete program at UCSB, I was able to partner with the Cheadle Center for Biological and Ecological Restoration on this project.

# Description of Data

In [Data](https://github.com/Vrod36/Cheadle-Center/tree/deda8a58cb18d75d23d9762a1bc677be5c73f600/Data)
| FIle Name | Description |
| :------------ |:---------------|
| Data.csv | Data sheet of bees, that were collected in the Sierra Nevadas for thermal tolerance testing. |
| Regression.csv | Data Sheet of Sierra Nevada bees, but with variables narrowed down for linear regression models (Live Mass, Elevation, Duration, CTmin, and CTmax) |
| Thermal_Tolerance_Data 2025.csv | Data Sheet of all bees collected in Santa Barbara and the Sierra Nevadas, used for theremal tolerance testing. |

# Descrpition of Script 

In [Script](https://github.com/Vrod36/Thermal-Tolerance-of-Sierra-Nevada-Bees/tree/dba2e0a5fc67fdb7e36c71542bf61a1423932cb5/Script)
| FIle Name | Description |
| :------------ |:---------------|
| regression.R | Code is used to create multiple linear regression models and graphs for Sierra Nevada Bees. |
| Total.R | Early in project, Code that was used to create scatterplots for CTmax and CTmin, in realtion to body mass or elevation. |


## General workflow for running the analyses:

1. Download Regression.csv data from the data folder in this repository and read it in R.
2. Use janitor::clean_names() to standardize column names.
3. Standardize text entries (e.g., trimming spaces in scientific_name).
4. Convert duration from HH:MM:SS format into minutes (lubridate::hms() + lubridate::period_to_seconds()).
5. Filter the dataset for general CTmin analysis, remove unwanted species with few samples (less than 4 smampled), exclude data where duration exceeds your threshold (4 hours), remove missing values (NA) for the specific variable being plotted.
   a. Output *c_tmin_data* (not included in archive)
6. Subset for Bombus-only data, filter rows containing "Bombus" in scientific_name, apply the same cleaning rules as before.
   a. Output *bombus_data*
7. Plot CTmin for Bombus, adjust x-axis to start at 45 minutes and increment by 45 minutes, customize axis labels to display hours/minutes.
   a. Output *bombus_ctmin*
8. Plot CTmax for Bombus with statistical annotation
   a. Ouput *bombus_ctmax*

## Defintions of column names in *Thermal_Tolerance_Data 2025.csv*

| Column Name  | Defintion  | 
| :------------ |:---------------| 
|Catalog Number | Numbered Identification for an individual bee in the UCSB Cheadle Center Records. |
| Vial#         | The number vial that the bee was in during thermal tolerance testing.             |
| Scientfic Name| The Bee Species Name.                                                             |
| Mass Tube with Bee (g) | The weight of a vial with the bee in it.                                 |
| Mass Tube (g) | The weight of the vial.                                                           |
| Live Mass (g) | The weight of the bee on its own, before its been dried.                          | 
| ITD(mm) | The measurement from the base of one Bees to the base of the other wing.                |
| CTmin | The lowest temprature a Bee can handle before it seizes movement.                         |
| CTmax | The highest temperature a Bee can handle before it seizes movement.                       |
| Site | The catergorical location in which we sampled the bees from.                               |
| Elevation | The Elevation of the location where we sampled the bees from.                         |
| Acclimation (w)| When the 10 minute acclimation period begins for the heat tolerance testing.     |
| Acclimation (c)| When the 10 minute acclimation period begins for the cold tolerance testing.     |
| Assay Start | When the testing for heat or cold tolerance begins                                  |
| Assay End | When the testing for heat or cold tolerance ends                                      |
| Plant | The plant species that a bee was collected on                                             |
| Time Collected | The time that bees are collected and put in vials                                |






