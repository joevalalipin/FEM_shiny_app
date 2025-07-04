library(readr)
library(dplyr)

# clear environment

rm(list = ls())

# set parameters

param_summarise_mode <- "highLevel-only"

# load validation tables

allowable_StockClass_by_Sector <- read_csv("input_validation/allowable_StockClass_by_Sector.csv")

allowable_StockClass <- allowable_StockClass_by_Sector %>% 
  pull(StockClass) %>% 
  unique()

allowable_Sector <- allowable_StockClass_by_Sector %>% 
  pull(Sector) %>% 
  unique()

allowable_Primary_Farm_Class_by_Territory <- read_csv("input_validation/allowable_Primary_Farm_Class_by_Territory.csv")

allowable_Primary_Farm_Class <- allowable_Primary_Farm_Class_by_Territory %>% 
  pull(Primary_Farm_Class) %>% 
  unique() %>% 
  sort()

allowable_Territory <- allowable_Primary_Farm_Class_by_Territory %>% 
  pull(Territory) %>% 
  unique() %>% 
  sort()

allowable_Transaction_Type <- read_csv("input_validation/allowable_Transaction_Type.csv") %>% 
  pull(Transaction_Type) %>% 
  unique()

allowable_Supplementary_Feed <- read_csv("input_validation/allowable_Supplementary_Feed.csv") %>% 
  pull(Supplementary_Feed) %>% 
  unique()

# pre-define input tables with example

# empty tables

StockRec_OpeningBalance_df_default <- data.frame(StockClass = rep(NA, 5),
                                                 Opening_Balance = as.integer(rep(0, 5)))

StockRec_BirthsDeaths_df_default <- data.frame(Month = rep(NA, 5),
                                               StockClass = rep(NA, 5),
                                               Births = rep(0, 5),
                                               Deaths = rep(0, 5))

StockRec_Movements_df_default <- data.frame(Transaction_Date = rep(NA, 5),
                                            StockClass = rep(NA, 5),
                                            Transaction_Type = rep(NA, 5),
                                            Stock_Count = rep(0, 5))

SuppFeed_DryMatter_df_default <- data.frame(SupplementName = rep(NA, 5),
                                            Dry_Matter_t = rep(0, 5))

SuppFeed_SectoralAllocation_df_default <- data.frame(Sector = rep(NA, 5),
                                                     SuppFeed_Allocation = rep(0, 5))

Dairy_Production_df_default <- data.frame(Month = rep(NA, 5),
                                          Milk_Yield_Herd_L = rep(0, 5),
                                          Milk_Fat_Herd_kg = rep(0, 5),
                                          Milk_Protein_Herd_kg = rep(0, 5))

Fertiliser_df_default <- data.frame(N_Urea_Coated_t = 0,
                                    N_Urea_Uncoated_t = 0,
                                    N_NonUrea_SyntheticFert_t = 0)

# example inputs

StockRec_OpeningBalance_df_ex <- data.frame(StockClass = c("Milking Cows Mature", "Dairy Heifers R2"),
                                            Opening_Balance = c(450, 140))

StockRec_BirthsDeaths_df_ex <- data.frame(Month = 8,
                                          StockClass = "Dairy Heifers R1",
                                          Births = 150,
                                          Deaths = 0)

StockRec_Movements_df_ex <- data.frame(Transaction_Date = "2023-04-25",
                                       StockClass = "Milking Cows Mature",
                                       Transaction_Type = "Sale",
                                       Stock_Count = 145)

SuppFeed_DryMatter_df_ex <- data.frame(SupplementName = c("Palm Kernel Extract (PKE)", "Swede, Forage (Whole Crop)"),
                                       Dry_Matter_t = c(10, 15))

SuppFeed_SectoralAllocation_df_ex <- data.frame(Sector = "Dairy",
                                                SuppFeed_Allocation = 1)

Dairy_Production_df_ex <- data.frame(Month = c(8, 9, 10, 11, 12, 1, 2, 3, 4, 5),
                                     Milk_Yield_Herd_L = c(116740.8911, 245081.654, 303713.2341, 280937.825, 252709.8793, 215892.3125, 175218.8682, 165686.0296, 127342.8347, 65141.06327),
                                     Milk_Fat_Herd_kg = c(4646.091865, 9753.839196, 12087.27785, 11180.85472, 10057.42978, 8526.177629, 6919.872117, 6543.394263, 5029.116671, 2572.598671),
                                     Milk_Protein_Herd_kg = c(5916.331744, 12420.5354, 15391.93535, 14237.69647, 12807.12754, 10881.40643, 8831.383093, 8350.908873, 6418.334788, 3283.240503))

Fertiliser_df_ex <- data.frame(N_Urea_Coated_t = 0,
                               N_Urea_Uncoated_t = 10,
                               N_NonUrea_SyntheticFert_t = 4)

# validate integer inputs

integer_validator <- "function(value, callback) {const isValid = Number.isInteger(Number(value)) && Number(value) >= 0; callback(isValid);}"

# save all objects

save.image(file = "data_prep.RData")
