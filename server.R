shinyServer(function(input, output, session) {

  # to check that date fall within reporting period
  date_validator <- reactive({
    paste0("function(value, callback) {
          const date = new Date(value);
          const minDate = new Date('", input$Period_Start, "');
          const maxDate = new Date('", input$Period_End, "');
          callback(date >= minDate && date <= maxDate);
        }")
  })
  
  # write input tables, including example farm inputs
  output$StockRec_OpeningBalance <- renderRHandsontable({
    
    data <- StockRec_OpeningBalance_df_default %>% 
      # pre-populate example
      bind_rows(StockRec_OpeningBalance_df_ex) %>% 
      arrange(StockClass)
    
    rhandsontable(data, rowHeaders = FALSE) %>%
      hot_col("StockClass", type = "dropdown", source = allowable_StockClass, allowInvalid = FALSE) %>% 
      hot_col("Opening_Balance", type = "numeric", validator = integer_validator, allowInvalid = FALSE)
    
  })
  
  output$StockRec_BirthsDeaths <- renderRHandsontable({
    
    data <- StockRec_BirthsDeaths_df_default %>% 
      # pre-populate example
      bind_rows(StockRec_BirthsDeaths_df_ex) %>% 
      arrange(Month)
    
    rhandsontable(data, rowHeaders = FALSE) %>%
      hot_col("Month", type = "dropdown", source = c(1:12), allowInvalid = FALSE) %>% 
      hot_col("StockClass", type = "dropdown", source = allowable_StockClass, allowInvalid = FALSE) %>% 
      hot_col(c("Births", "Deaths"), type = "numeric", validator = integer_validator, allowInvalid = FALSE)

  })
  
  output$StockRec_Movements <- renderRHandsontable({
    
    data <- StockRec_Movements_df_default %>% 
      # pre-populate example
      bind_rows(StockRec_Movements_df_ex) %>% 
      arrange(Transaction_Date)

    rhandsontable(data, rowHeaders = FALSE) %>%
      hot_col("Transaction_Date", type = "date", dateFormat = "YYYY-MM-DD", validator = date_validator(), allowInvalid = FALSE) %>% 
      hot_col("StockClass", type = "dropdown", source = allowable_StockClass, allowInvalid = FALSE) %>% 
      hot_col("Transaction_Type", type = "dropdown", source = allowable_Transaction_Type, allowInvalid = FALSE) %>% 
      hot_col("Stock_Count", type = "numeric", validator = integer_validator, allowInvalid = FALSE)

  })
  
  output$SuppFeed_DryMatter <- renderRHandsontable({
    
    data <- SuppFeed_DryMatter_df_default %>% 
      # pre-populate example
      bind_rows(SuppFeed_DryMatter_df_ex) %>% 
      arrange(SupplementName)
    
    rhandsontable(data, rowHeaders = FALSE) %>%
      hot_col("SupplementName", type = "dropdown", source = allowable_Supplementary_Feed, allowInvalid = FALSE) %>% 
      hot_validate_numeric("Dry_Matter_t", min = 0, allowInvalid = FALSE)
    
  })
  
  output$SuppFeed_SectoralAllocation <- renderRHandsontable({
    
    data <- SuppFeed_SectoralAllocation_df_default %>% 
      # pre-populate example
      bind_rows(SuppFeed_SectoralAllocation_df_ex) %>% 
      arrange(Sector)
    
    rhandsontable(data, rowHeaders = FALSE) %>%
      hot_col("Sector", type = "dropdown", source = allowable_Sector, allowInvalid = FALSE) %>% 
      hot_validate_numeric("SuppFeed_Allocation", min = 0, max = 1, allowInvalid = FALSE)
    
  })
  
  output$Dairy_Production <- renderRHandsontable({
    
    data <- Dairy_Production_df_default %>% 
      # pre-populate example
      bind_rows(Dairy_Production_df_ex) %>% 
      arrange(Month)
    
    rhandsontable(data, rowHeaders = FALSE) %>% 
      hot_col("Month", type = "dropdown", source = c(1:12), allowInvalid = FALSE) %>% 
      hot_validate_numeric(c("Milk_Yield_Herd_L", "Milk_Fat_Herd_kg", "Milk_Protein_Herd_kg"), min = 0, allowInvalid = FALSE)
    
  })
  
  output$Fertiliser <- renderRHandsontable({
    
    data <- Fertiliser_df_ex
    
    rhandsontable(data, rowHeaders = FALSE) %>% 
      hot_validate_numeric(c("N_Urea_Coated_t", "N_Urea_Uncoated_t", "N_NonUrea_SyntheticFert_t"), min = 0, allowInvalid = FALSE)
    
  })

  # reset the input tables
  
  observeEvent(input$ClearTables, {
    showModal(modalDialog(title = "Are you sure?",
                          tagList(actionButton("ConfirmClearTables", "Yes"),
                                  modalButton("No")),
                          footer = NULL))
  })
  
  observeEvent(input$ConfirmClearTables, {
    
    output$StockRec_OpeningBalance <- renderRHandsontable({
      data <- StockRec_OpeningBalance_df_default
      rhandsontable(data, rowHeaders = FALSE) %>%
        hot_col("StockClass", type = "dropdown", source = allowable_StockClass, allowInvalid = FALSE) %>% 
        hot_col("Opening_Balance", type = "numeric", validator = integer_validator, allowInvalid = FALSE)
    })
    
    output$StockRec_BirthsDeaths <- renderRHandsontable({
      data <- StockRec_BirthsDeaths_df_default
      rhandsontable(data, rowHeaders = FALSE) %>%
        hot_col("Month", type = "dropdown", source = c(1:12), allowInvalid = FALSE) %>% 
        hot_col("StockClass", type = "dropdown", source = allowable_StockClass, allowInvalid = FALSE) %>% 
        hot_col(c("Births", "Deaths"), type = "numeric", validator = integer_validator, allowInvalid = FALSE)
    })
    
    output$StockRec_Movements <- renderRHandsontable({
      data <- StockRec_Movements_df_default 
      rhandsontable(data, rowHeaders = FALSE) %>%
        hot_col("Transaction_Date", type = "date", dateFormat = "YYYY-MM-DD", allowInvalid = FALSE) %>% 
        hot_col("StockClass", type = "dropdown", source = allowable_StockClass, allowInvalid = FALSE) %>% 
        hot_col("Transaction_Type", type = "dropdown", source = allowable_Transaction_Type, allowInvalid = FALSE) %>% 
        hot_col("Stock_Count", type = "numeric", validator = integer_validator, allowInvalid = FALSE)
    })
    
    output$SuppFeed_DryMatter <- renderRHandsontable({
      data <- SuppFeed_DryMatter_df_default 
      rhandsontable(data, rowHeaders = FALSE) %>%
        hot_col("SupplementName", type = "dropdown", source = allowable_Supplementary_Feed, allowInvalid = FALSE) %>% 
        hot_validate_numeric("Dry_Matter_t", min = 0, allowInvalid = FALSE)
    })
    
    output$SuppFeed_SectoralAllocation <- renderRHandsontable({
      data <- SuppFeed_SectoralAllocation_df_default 
      rhandsontable(data, rowHeaders = FALSE) %>%
        hot_col("Sector", type = "dropdown", source = allowable_Sector, allowInvalid = FALSE) %>% 
        hot_validate_numeric("SuppFeed_Allocation", min = 0, max = 1, allowInvalid = FALSE)
    })
    
    output$Dairy_Production <- renderRHandsontable({
      data <- Dairy_Production_df_default 
      rhandsontable(data, rowHeaders = FALSE) %>% 
        hot_col("Month", type = "dropdown", source = c(1:12), allowInvalid = FALSE) %>% 
        hot_validate_numeric(c("Milk_Yield_Herd_L", "Milk_Fat_Herd_kg", "Milk_Protein_Herd_kg"), min = 0, allowInvalid = FALSE)
    })
    
    output$Fertiliser <- renderRHandsontable({
      data <- Fertiliser_df_default
      rhandsontable(data, rowHeaders = FALSE) %>% 
        hot_validate_numeric(c("N_Urea_Coated_t", "N_Urea_Uncoated_t", "N_NonUrea_SyntheticFert_t"), min = 0, allowInvalid = FALSE)
    })
    
    removeModal()
    
  })
  
  # calculate emissions
  observeEvent(input$CalcEmissions, {
    
    source("src/model_pipeline/1.1_load_static_inputs.R")
    
    
    FarmYear_df <- data.frame(Entity_ID = input$Entity_ID,
                              Period_Start = as.Date(input$Period_Start),
                              Period_End = as.Date(input$Period_End),
                              Territory = input$Territory,
                              Primary_Farm_Class = input$Primary_Farm_Class)
    # print(FarmYear_df)
    
    StockRec_BirthsDeaths_df <- hot_to_r(input$StockRec_BirthsDeaths) %>% 
      filter(!is.na(Month)) %>%
      mutate(StockClass = as.character(StockClass)) %>% 
      bind_cols(FarmYear_df %>% select(Entity_ID, Period_End))
    # print(StockRec_BirthsDeaths_df)
    
    StockRec_Movements_df <- hot_to_r(input$StockRec_Movements) %>% 
      mutate(Transaction_Date = as.Date(Transaction_Date),
             Transaction_Type = as.character(Transaction_Type),
             StockClass = as.character(StockClass)) %>% 
      filter(!is.na(Transaction_Date)) %>%
      bind_cols(FarmYear_df %>% select(Entity_ID, Period_End))
    # print(StockRec_Movements_df)
    
    StockRec_OpeningBalance_df <- hot_to_r(input$StockRec_OpeningBalance) %>% 
      filter(!is.na(StockClass)) %>%
      mutate(StockClass = as.character(StockClass)) %>% 
      bind_cols(FarmYear_df %>% select(Entity_ID, Period_End))
    # print(StockRec_OpeningBalance_df)
    
    SuppFeed_DryMatter_df <- hot_to_r(input$SuppFeed_DryMatter) %>% 
      filter(!is.na(SupplementName)) %>%
      mutate(SupplementName = as.character(SupplementName)) %>% 
      bind_cols(FarmYear_df %>% select(Entity_ID, Period_End))
    # print(SuppFeed_DryMatter_df)
    
    SuppFeed_SectoralAllocation_df <- hot_to_r(input$SuppFeed_SectoralAllocation) %>% 
      filter(!is.na(Sector)) %>%
      mutate(Sector = as.character(Sector)) %>% 
      bind_cols(FarmYear_df %>% select(Entity_ID, Period_End))
    # print(SuppFeed_SectoralAllocation_df)
    
    Dairy_Production_df <- hot_to_r(input$Dairy_Production) %>% 
      filter(!is.na(Month)) %>%
      bind_cols(FarmYear_df %>% select(Entity_ID, Period_End))
    # print(Dairy_Production_df)
    
    Fertiliser_df <- hot_to_r(input$Fertiliser) %>% 
      filter(N_Urea_Coated_t + N_Urea_Uncoated_t + N_NonUrea_SyntheticFert_t > 0) %>% 
      bind_cols(FarmYear_df %>% select(Entity_ID, Period_End))
    # print(Fertiliser_df)
 
    save(FarmYear_df,
         StockRec_BirthsDeaths_df,
         StockRec_Movements_df,
         StockRec_OpeningBalance_df,
         SuppFeed_DryMatter_df,
         SuppFeed_SectoralAllocation_df,
         Dairy_Production_df,
         Fertiliser_df,
         file = "user_inputs.RData")
  
    source("load_user_inputs.R")
    source("src/model_pipeline/2_preprocessing.R")
    source("src/model_pipeline/3.1_livestock.R")
    source("src/model_pipeline/3.2_fertiliser.R")
    source("src/model_pipeline/4_summary_outputs.R")
    
    # print(smry_all_annual_by_emission_type_df)
    # print(smry_all_annual_by_gas_df)
    
    output$Output_Smry_Type <- renderRHandsontable({
      rhandsontable(smry_all_annual_by_emission_type_df %>% select(-1,-2), rowHeaders = FALSE, readOnly = TRUE)
    })
    
    output$Output_Smry_Gas <- renderRHandsontable({
      rhandsontable(smry_all_annual_by_gas_df %>% select(-1,-2), rowHeaders = FALSE, readOnly = TRUE)
    })
    
    # build the workbook and download results and inputs
    output$DLData <- downloadHandler(
      filename = function() {paste0("fem_data_", Sys.time(), ".xlsx")},
      
      content = function(file) {
        
        wb <- createWorkbook()
        
        addWorksheet(wb, "FarmYear")
        writeData(wb, "FarmYear", FarmYear_df)
        
        addWorksheet(wb, "StockRec_BirthsDeaths")
        writeData(wb, "StockRec_BirthsDeaths", StockRec_BirthsDeaths_df)
        
        addWorksheet(wb, "StockRec_Movements")
        writeData(wb, "StockRec_Movements", StockRec_Movements_df)
        
        addWorksheet(wb, "StockRec_OpeningBalance")
        writeData(wb, "StockRec_OpeningBalance", StockRec_OpeningBalance_df)
        
        addWorksheet(wb, "SuppFeed_DryMatter")
        writeData(wb, "SuppFeed_DryMatter", SuppFeed_DryMatter_df)
        
        addWorksheet(wb, "SuppFeed_SectoralAllocation")
        writeData(wb, "SuppFeed_SectoralAllocation", SuppFeed_SectoralAllocation_df)
        
        addWorksheet(wb, "Dairy_Production")
        writeData(wb, "Dairy_Production", Dairy_Production_df)
        
        addWorksheet(wb, "Fertiliser")
        writeData(wb, "Fertiliser", Fertiliser_df)
        
        saveWorkbook(wb, file, overwrite = TRUE)
        }
      )
  })
})



