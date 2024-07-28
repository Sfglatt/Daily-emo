## Script purpose: Process daily diary data
## Project: Understanding Flexibility in Revising Social Interpretations and Implementing Emotion Regulation Strategies
## Author: Sglatt

# Packages ------

if (!require("readxl")) {install.packages("readxl"); require("readxl")}
if (!require("writexl")) {install.packages("writexl"); require("writexl")}
if (!require("tidyr")) {install.packages("tidyr"); require("tidyr")}
if (!require("dplyr")) {install.packages("dplyr"); require("dplyr")}
if (!require("tidyverse")) {install.packages("tidyverse"); require("tidyverse")}
if (!require("lubridate")) {install.packages("lubridate"); require("lubridate")}


# Import data  ------

EMA_dat <- read.csv("Data/DualFlex (EMA)_February 22, 2024_17.39.csv") 

EMA_dat <- EMA_dat[-1, ] # remove row 1 (var description from Qualtrics)
head(EMA_dat)


# Arrange data  ------

# Arrange dataframe in rows by email (proxy for ID) and then ascending date
EMA_dat_2 <- EMA_dat %>%
  mutate(StartDate = mdy_hm(StartDate)) %>%
  arrange(Email, StartDate) %>%
  select(Email, StartDate, everything()) 

# Filter
EMA_dat_3 <- EMA_dat_2 %>%
  filter(!is.na(Email) & Email != "") %>%  # Exclude rows with empty email column
  mutate(ID = paste0("PR", group_indices(., Email))) %>%
  select(ID, everything()) # give each participant (based on email) a participant ID ("PR1" etc.)

# Look at it
head(EMA_dat_3)


# Save data  ------

# save all new data in one file
write.csv(EMA_dat_3, "EMA_dat_organized_all_ID.csv") 

# save each participant in a csv
## make a folder for all files
dir.create("Participant_data", showWarnings = FALSE)

# loop for csv
for (id in unique_ids) {
  filtered_data <- EMA_dat_2 %>% filter(ID == id)
  filename <- fs::path("Participant_data", paste0("EMA_dat_", id, ".csv"))
  write.csv(filtered_data, file = filename, row.names = FALSE)
}

# Quick check data  ------

# pick one participant from the original and new organized frames to verify 
Check_or <- EMA_dat %>%
  filter(Email == "XXX@gmail.com") # choose email 

Check_or_2 <- Check_or %>%
  mutate(StartDate = mdy_hm(StartDate)) %>%
  arrange(Email, StartDate) %>%
  select(Email, StartDate, everything()) 

head(Check_or_2)