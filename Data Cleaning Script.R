# Data Load 

pacman::p_load(readr, tidyverse, plotly, tidymodels, mice, kableExtra, stringr, DescTools, scales, doParallel)

Conmebol_raw <- read_csv("conmebol.csv") %>%
  select(-X1, -rating) 

# Data Cleaning

#Lets convert value into a number and clean the names of the players

Conmebol_num <- Conmebol_raw %>%
  mutate(value2 = str_sub(value,-1,-1),
         value = parse_number(value),
         value = case_when(value2 == "M" ~ value * 1000000,
                           value2 == "K" ~ value * 1000,
                           TRUE ~ 0),
         position = case_when(best_position %in% c("ST","RW","LW","CF") ~ "ATT",
                              best_position %in% c("RB","RWB","LWB","CB","LB") ~ "DEF",
                              best_position == "GK" ~ "GK",
                              TRUE ~ "MID"))

Conmebol <- Conmebol_num %>% 
  na_if(.,0) %>% 
  separate(height, c("Foot", "Inches")) %>%
  mutate(height = as.double(str_c(Foot, '.', Inches))) %>% 
  select(-Foot, -Inches, -value2)
