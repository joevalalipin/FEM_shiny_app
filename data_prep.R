library(readr)
library(dplyr)

# clear environment

rm(list = ls())

# set validations to run

param_validations = "all"

# set output tables to saveout

param_saveout_emission_tables = c(
  "smry_livestock_annual",
  "smry_all_annual_by_emission_type",
  "smry_all_annual_by_gas"
)
param_saveout_mitign_delta_tables = c(
  "smry_livestock_annual_mitign_delta",
  "smry_all_annual_by_emission_type_mitign_delta",
  "smry_all_annual_by_gas_mitign_delta"
)
param_saveout_tables = c(param_saveout_emission_tables, param_saveout_mitign_delta_tables)

# load validation tables

allowable_StockClass_by_Sector <- read_csv("data_validation/allowed_values/Allowed_StockClass_by_Sector.csv")

allowable_StockClass <- allowable_StockClass_by_Sector %>% 
  pull(StockClass) %>% 
  unique()

allowable_Sector <- allowable_StockClass_by_Sector %>% 
  pull(Sector) %>% 
  unique()

allowable_Primary_Farm_Class_by_Territory <- read_csv("data_validation/allowed_values/Allowed_Primary_Farm_Class_by_Territory.csv")

allowable_Primary_Farm_Class <- allowable_Primary_Farm_Class_by_Territory %>% 
  pull(Primary_Farm_Class) %>% 
  unique() %>% 
  sort()

allowable_Territory <- allowable_Primary_Farm_Class_by_Territory %>% 
  pull(Territory) %>% 
  unique() %>% 
  sort()

allowable_Transaction_Type <- read_csv("data_validation/allowed_values/Allowed_Transaction_Type.csv") %>% 
  pull(Transaction_Type) %>% 
  unique()

allowable_Supplementary_Feed <- read_csv("data_validation/allowed_values/Allowed_Supplement.csv") %>% 
  pull(Supplement) %>% 
  unique()

allowable_Breed <- read_csv("data_validation/allowed_values/Allowed_Breed.csv") %>% 
  pull(Breed) %>% 
  unique()

# pre-define input tables with example

# example inputs

StockRec_OpeningBalance_df_ex <- read_csv("data_input_example/StockRec_OpeningBalance.csv") %>% 
  filter(Entity_ID == 10002) %>% 
  select(-Entity_ID, -Period_End)

StockRec_Movements_df_ex <- read_csv("data_input_example/StockRec_Movements.csv") %>% 
  filter(Entity_ID == 10002) %>% 
  select(-Entity_ID, -Period_End)

StockRec_BirthsDeaths_df_ex <- read_csv("data_input_example/StockRec_BirthsDeaths.csv") %>% 
  filter(Entity_ID == 10002) %>% 
  select(-Entity_ID, -Period_End)

SuppFeed_DryMatter_df_ex <- read_csv("data_input_example/SuppFeed_DryMatter.csv") %>% 
  filter(Entity_ID == 10002) %>% 
  select(-Entity_ID, -Period_End)

Dairy_Production_df_ex <- read_csv("data_input_example/Dairy_Production.csv") %>% 
  filter(Entity_ID == 10002) %>% 
  select(-Entity_ID, -Period_End)

Fertiliser_df_ex <- read_csv("data_input_example/Fertiliser.csv") %>% 
  filter(Entity_ID == 10002) %>% 
  select(-Entity_ID, -Period_End)

Effluent_Structure_Use_df_ex <- read_csv("data_input_example/Effluent_Structure_Use.csv") %>% 
  filter(Entity_ID == 10002) %>% 
  select(-Entity_ID, -Period_End)

Effluent_EcoPond_Treatments_df_ex <- read_csv("data_input_example/Effluent_EcoPond_Treatments.csv") %>% 
  filter(Entity_ID == 10002) %>% 
  select(-Entity_ID, -Period_End)

BreedingValues_df_ex <- read_csv("data_input_example/BreedingValues.csv") %>% 
  filter(Entity_ID == 10001) %>%  # the example farm is dairy, BVs only apply to sheep for now
  select(-Entity_ID, -Period_End)

Breed_Allocation_df_ex <- read_csv("data_input_example/Breed_Allocation.csv") %>% 
  filter(Entity_ID == 10002) %>% 
  select(-Entity_ID, -Period_End)


# empty tables

StockRec_OpeningBalance_df_default <- StockRec_OpeningBalance_df_ex %>% 
  mutate(StockClass = NA,
         Opening_Balance = 0) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))

StockRec_Movements_df_default <- StockRec_Movements_df_ex %>% 
  mutate(Transaction_Date = NA,
         StockClass = NA,
         Transaction_Type = NA,
         Stock_Count = 0) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))

SuppFeed_DryMatter_df_default <- SuppFeed_DryMatter_df_ex %>% 
  mutate(Supplement = NA,
         Dry_Matter_t = 0,
         Beef_Allocation = 0,
         Dairy_Allocation = 0,
         Deer_Allocation = 0,
         Sheep_Allocation = 0) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))

StockRec_BirthsDeaths_df_default <- StockRec_BirthsDeaths_df_ex %>% 
  mutate(Month = NA,
         StockClass = NA,
         Births = 0,
         Deaths = 0) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))

Dairy_Production_df_default <- Dairy_Production_df_ex %>% 
  mutate(Month = NA,
         Milk_Yield_Herd_L = 0,
         Milk_Fat_Herd_kg = 0,
         Milk_Protein_Herd_kg = 0) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))

Fertiliser_df_default <- Fertiliser_df_ex %>% 
  mutate(N_Urea_Coated_t = 0,
         N_Urea_Uncoated_t = 0,
         N_NonUrea_SyntheticFert_t = 0,
         N_OrganicFert_t = 0,
         Lime_t = 0,
         Dolomite_t = 0) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))

Effluent_Structure_Use_df_default <- Effluent_Structure_Use_df_ex %>% 
  mutate(Month = NA,
         Dairy_Shed_hrs_day = 0,
         Other_Structures_hrs_day = 0) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))

Effluent_EcoPond_Treatments_df_default <- Effluent_EcoPond_Treatments_df_ex %>% 
  mutate(Treatment_Date = NA) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))

BreedingValues_df_default <- BreedingValues_df_ex %>% 
  mutate(StockClass = NA,
         BV_aCH4 = 0) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))

Breed_Allocation_df_default <- Breed_Allocation_df_ex %>% 
  mutate(Sector = NA,
         Breed = NA,
         Breed_Allocation = 0) %>% 
  slice(1) %>% 
  slice(rep(1, each = 5))


# validate integer inputs

integer_validator <- "function(value, callback) {const isValid = Number.isInteger(Number(value)) && Number(value) >= 0; callback(isValid);}"

# save all objects

save.image(file = "data_prep.RData")
