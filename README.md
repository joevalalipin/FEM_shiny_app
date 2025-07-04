# FEM Shiny App

This app is an R Shiny implementation of the Farm Emissions R Model.
User provides farm data on the input tab, and the output tab shows the summary emissions results.


Please follow these steps.
1. Fill out the farm details on the left hand side. The fields are pre-populated with an example farm data.
2. Provide the required data by filling out the tables on the input tab. *
3. If more rows are required, right click on any cell and click 'Insert row'.
4. On the output tab, click 'Calculate Emissions'. A table will be generated with emissions results.
5. Click 'Download Data' to download results and input data.


* Tables are pre-populated with example data; you can remove all table contents by clicking 'Clear Tables' button at the bottom of the tab.
   Columns have restrictions on what values you can enter:
   a. Stock count columns should be whole numbers.
   b. Sectoral allocation of supplementary feed column should be between 1 and 0.
   c. All numeric columns should be greater than or equal to 0.
   d. Date inputs should follow the format 'YYYY-MM-DD'.
   e. Date column should be within the reporting period, inclusive.