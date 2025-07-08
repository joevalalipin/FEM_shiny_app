shinyUI(
  fluidPage(
    titlePanel(
      "FEM Shiny App"
      ),
    sidebarPanel(
      width = 3,
      textInput("Entity_ID", "Entity_ID", value = "10002"),
      dateInput("Period_Start", "Period_Start", value = "2022-06-01"),
      dateInput("Period_End", "Period_End", value = "2023-05-31"),
      selectInput("Territory", "Territory", choices = allowable_Territory, selected = "Southland District"),
      selectInput("Primary_Farm_Class", "Primary_Farm_Class", choices = allowable_Primary_Farm_Class, selected = "Dairy")
      ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Inputs",
          br(),
          br(),
          fluidRow(
            column(4, "StockRec_OpeningBalance", rHandsontableOutput("StockRec_OpeningBalance")),
            column(4, "StockRec_BirthsDeaths", rHandsontableOutput("StockRec_BirthsDeaths"))
            ),
          br(),
          br(),
          fluidRow(
            column(8, "StockRec_Movements", rHandsontableOutput("StockRec_Movements")),
            ),
          br(),
          br(),
          fluidRow(
            column(4, "SuppFeed_DryMatter", rHandsontableOutput("SuppFeed_DryMatter")),
            column(4, "SuppFeed_SectoralAllocation", rHandsontableOutput("SuppFeed_SectoralAllocation"))
            ),
          br(),
          br(),
          fluidRow(
            column(8, "Dairy_Production", rHandsontableOutput("Dairy_Production"))
            ),
          br(),
          br(),
          fluidRow(
            column(8, "Fertiliser", rHandsontableOutput("Fertiliser"))
            ),
          br(),
          br(),
          actionButton("ClearTables", "Clear Tables"),
          br(),
          br(),
          h5("End")
          ),
        
        tabPanel(
          "Outputs",
          br(),
          actionButton("CalcEmissions", "Calculate Emissions"),
          br(),
          br(),
          br(),
          "Emissions_Summary_by_Type", br(), br(), rHandsontableOutput("Output_Smry_Type"), br(), plotlyOutput("plot_Output_Smry_Type"),
          br(),
          br(),
          "Emissions_Summary_by_Gas", br(), br(), rHandsontableOutput("Output_Smry_Gas"), br(), plotlyOutput("plot_Output_Smry_Gas"),
          br(),
          br(),
          downloadButton("DLData", "Download Data"),
          br(),
          br(),
          h5("End")
          ),
        
        tabPanel(
          "Info",
          HTML("<br>This app is an R Shiny implementation of the <a href='https://github.com/Ministry-for-Primary-Industries/FarmEmissionsModel'>Farm Emissions R Model.</a><br>
                      User provides farm data on the input tab, and the output tab shows the summary emissions results.<br>
                      Please follow these steps.<br>
                      1. Fill out the farm details on the left hand side. The fields are pre-populated with an example farm data.<br>
                      2. Provide the required data by filling out the tables on the input tab. *<br>
                      3. If more rows are required, right click on any cell and click 'Insert row'.<br>
                      4. On the output tab, click 'Calculate Emissions'. A table will be generated with emissions results.<br>
                      5. Click 'Download Data' to download results and input data. <br>
                      <br><br><br<br><br>
                      * <i>Tables are pre-populated with example data; you can remove all table contents by clicking 'Clear Tables' button at the bottom of the tab.<br>
                      &nbsp;&nbsp;&nbsp;Columns have restrictions on what values you can enter:<br>
                      &nbsp;&nbsp;&nbsp;a. Stock count columns should be whole numbers.<br>
                      &nbsp;&nbsp;&nbsp;b. Sectoral allocation of supplementary feed column should be between 1 and 0.<br>
                      &nbsp;&nbsp;&nbsp;c. All numeric columns should be greater than or equal to 0.<br>
                      &nbsp;&nbsp;&nbsp;d. Date inputs should follow the format 'YYYY-MM-DD'.<br>
                      &nbsp;&nbsp;&nbsp;e. Date column should be within the reporting period, inclusive.</i><br>")
          )
        )
      )
    )
  )