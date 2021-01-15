---
title: Stock Analyzer
linktitle: Stock Analyzer
toc: true
type: docs
date: "2019-05-05T00:00:00+01:00"
draft: false
menu:
  dat_sci_3:
    parent: III. Reporting
    weight: 17

# Prev/next pager order (if `docs_section_pager` enabled in `params.toml`)
weight: 16
---

The goal of this session is to teach you how to develop a shiny application. 

## <i class="fab fa-r-project" aria-hidden="true"></i> &nbsp; ProjectStock Analyzer Application

This is going to be your second Project: Stock Analyzer App - A fully functional stock analysis application built with shiny

An app that can pull in any of the stock that are listed in the SP500, DOW, NASDAQ or DAX and it will be able to select one and analyze them using a short and a long moving average. The user can change the moving averages to what they want

You're building this!

<< INSERT IMAGE or embedd APP >>

<a href="https://cran.r-project.org/web/packages/quantmod/index.html" target="_blank">
<img src="/img/icons/logo_quantmod.png" align="right" style="height:100px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

We’ll use the `quantmod` package to retrieve and manipulate stock information. There’s a lot of details behind `quantmod` and extensible timeseries (`xts`) objects, much of which is beyond the scope of this class. We’ll skim the surface to get you to a proficient level. 

First, load the quantmod package and use the `getSymbols()` function to retrieve stock prices. This function uses a financial symbol to collect data from financial APIs (e.g. yahoo finance). Optionally, you can use the `from` and `to` arguments to limit the range of prices. `auto.assign` indicates whether the results should be loaded to the environment (automatically generates a new objects if `TRUE`) or if `FALSE` be returned instead (what we are used to).

```r
library(quantmod)
library(lubridate)
getSymbols("AAPL", from = "2020-01-01", to = today(), auto.assign = F)
```

* The index is a column of dates. This is different from data frames, which generally do not have row names and indicies are a sequence from 1:nrow.
* The values are prices and volumes. We’ll be working primarily the `adjusted price` when graphing, since this removes the effect of stock splits. This value is the closing price adjusted for any stock splits or dividends that occured during the time range.

### Project Setup

Let's get started! Get ourselves setup with a new blank project. In RStudio click 

1. Click `File`
2. Click `New Project`
3. Select `New Directory` 
4. Name it `stock_analyzer_app`. 
5. Save it where you want 

KLÄRUNG `OLI`: Step 5, Integration mit GITHUB<br>
KLÄRUNG `OLI`: Headlines und Nummerierung

### 1. App Workflow

First we need to come up with an analysis. A Financial Analysis Code Workflow for our App. We have to think about how the user is going to interact with the app and integrate this analysis into it. We need to do accomplish the following steps:

1. Create a dropwdown list from that the user can select stock indices (DAX, S&P 500, DOW, NASDAQ100).
2. Pull in the stock list from the selected stock index.
3. The user will select 1 stock from the selected stock index.
4. The functionality is designed to pull the past 180 days of stock data.
5. Create an analysis button to start the analysis functions.
6. Plot the analysis itself with ggplotly (timeseries visualization).
7. We will implement 2 moving averages - short (fast) and long (slow)
8. Output an automated commentary, that indicates positive or negative trends based on the moving averages.
9. Add sliders to adjust the analysis.
10. Add a date range input field to adjust the default time frame.

Before you start an App, you should always have an analysis that you've completed. It should be functioning separately from the web app. Let's start with that.

You can use the following template for your analysis.

KLÄRUNG `OLI`: Detaillierung des tempaltes. Mehr input?

<!-- DOWNLOADBOX -->
<div id="header">Website</div>
<div id="container">
  <div id="first">{{% icon globe %}}</div>
  <div id="second"><a href="https://cloud.tuhh.de/index.php/s/WKXYkbKNP4Hs6y5" target="_blank"><b>stock_analysis_template.R</b></a></div>
  <div id="clear"></div>
</div>

**App Workflow - Steps**

Tip: Break up your analysis into modular functions. This will help big time in the Shiny Apps. We will build the following functions:

1. Get stock lists
2. Extract symbol based on user input
3. Get Stock data
4. Plot stock data
5. Generate commentary
6. Save scripts (so that we can update our functions easily)


### 1.1 Get the stock list

We want to have a list of stocks, that the user can select from. We need a function that retrieves all the stocks in a given index. The following function is designed for the three major US indices and the biggest German index containing the 30 largest German blue-chip companies: 

* DAX30
* SP500
* DOW30
* NASDAQ100 

You can modify the list as you want. You can add any indices and ETFs to the following scheme. The function is currently built for retrieving the lists (names and symbols) from the corresponding wikipedia pages:

KLÄRUNG `OLI`: Komplette function oder sollen die Teile selbst bauen?

```r
get_stock_list <- function(stock_index = "SP500") {
    
    # Control for upper and lower case
    index_lower <- str_to_lower(stock_index)
    # Control if user input is valid
    index_valid <- c("dax", "sp500", "dow", "nasdaq")
    if (!index_lower %in% index_valid) {stop(paste0("x must be a character string in the form of a valid exchange.",
                                                    " The following are valid options:\n",
                                                    stringr::str_c(str_to_upper(index_valid), collapse = ", ")))
    }
    
    # Control for different currencies and different column namings in wiki
    vars <- switch(index_lower,
                   dax    = list(wiki     = "DAX", 
                                 columns  = c("Ticker symbol", "Company"),
                                 currency = "euro"),
                   sp500  = list(wiki     = "List_of_S%26P_500_companies", 
                                 columns  = c("Symbol", "Security"),
                                 currency = "dollar"),
                   dow    = list(wiki     = "Dow_Jones_Industrial_Average",
                                 columns  = c("Symbol", "Company"),
                                 currency = "dollar"),
                   nasdaq = list(wiki     = "NASDAQ-100",
                                 columns  = c("Ticker", "Company"),
                                 currency = "dollar")
    )
    
    # Extract stock list depending on user input
    stock_list_tbl <- read_html(glue("https://en.wikipedia.org/wiki/{vars$wiki}")) %>% 
                        
                        # Extract table from wiki
                        html_nodes(css = "#constituents") %>% 
                        html_table() %>% 
                        dplyr::first() %>% 
                        as_tibble(.name_repair = "minimal") %>% 
                        # Select desired columns (different for each article)
                        dplyr::select(vars$columns) %>% 
                        # Make naming identical
                        set_names(c("symbol", "company")) %>% 
                        
                        # Clean (just relevant for DOW)
                        mutate(symbol = str_remove(symbol, "NYSE\\:[[:space:]]")) %>% 
        
                        # Sort
                        arrange(symbol) %>%
                        # Create the label for the dropdown list (Symbol + company name)
                        mutate(label = str_c(symbol, company, sep = ", ")) %>%
                        dplyr::select(label)
    
    # Return currency and the stock list
    return(list(currency     = vars$currency,
                constituents = stock_list_tbl))
    
}
```

*Example function calls*

Let's test the function. Default is the German DAX. To retrieve other lists, just change the argument.

```r
stock_list_lst <- get_stock_list()
# get_stock_list("DOW")
# get_stock_list("SP500")

stock_list_lst
## $currency
## [1] "euro"
## 
## $constituents
## # A tibble: 30 x 1
##    label                 
##    <chr>                 
##  1 1COV.DE, Covestro     
##  2 ADS.DE, Adidas        
##  3 ALV.DE, Allianz       
##  4 BAS.DE, BASF          
##  5 BAYN.DE, Bayer        
##  6 BEI.DE, Beiersdorf    
##  7 BMW.DE, BMW           
##  8 CON.DE, Continental   
##  9 DAI.DE, Daimler       
## 10 DB1.DE, Deutsche Börse
## # … with 20 more rows
```

### 1.2 Extract Symbol based on user input

As shown above, we need the stock symbols from the returned lists. 

This could be an example user input. 

```r
user_input <- "AAPL, Apple Inc."
```

Build a function that extracts `AAPL` from that input. You can use `stringr::str_split()` in combination with `purrr::pluck()` (helps us drill into lists).

*Test code*

```r
user_input %>% ... %>% ...
## [1] "AAPL"
```

*Modularize (function)*

```r
get_symbol_from_user_input <- function(user_input) {
    user_input %>% ... %>% ... 
}
```

*Example function calls*

```r
"ADS.DE, Adidas" %>% get_symbol_from_user_input()
## [1] "ADS.DE"
"AAPL, Apple Inc." %>% get_symbol_from_user_input()
## [1] "AAPL"
```


### 1.3 Get stock data

In this step we are retrieving the stock prices for a given symbol in a given time frame. Addtionally, we are adding two columns for the moving averages. In stock analysis, comparing moving averages can help determine if a stock is likely to continue going up or down. This is a simple form of a technical trading pattern:

* Short (Fast) Moving Average: Uses a shorter time window (e.g. 20-days). Indicates short term trend.
* Long (Slow) Moving Average: Uses a longer time window (e.g. 50-days). Indicates longterm trend.

* `rollmean()` calculates a rolling average (vectorized) from the `zoo` package (will be loaded with the `quantmod` package.)
  + Because there might be missing values in the retrieved data, we need to set the `fill` argument to `NA`
  + By default the rolling average is being centered (there will probably show up less NA values at the beginning than expected. Example: If we took an average of the first 5 values, there should be 4 NA values at the top). We provide the argument called `align` and pass the value `right`. 
* `timetk::tk_tbl` makes it easy to convert the `xts` object from the `getSymbols()` function to a `tibble` object. Similar to `as_tibble()`.

Pull in last 180 days of stock history (default), calculate a 5-day short movering average and a 50-day long moving average:

*Test code*

Set values for testing

```r
from   <- today() - days(180) 
to     <- today() # or something int this format "2021-01-07"
```

```r
# Retrieve market data
"AAPL" %>% quantmod::getSymbols(
              src         = "yahoo", 
              from        = ..., 
              to          = ..., 
              auto.assign = FALSE) %>% 
    
              # Convert to tibble
              timetk::tk_tbl(preserve_index = T, 
              silent         = T) %>% 
    
              # Modify tibble 
              set_names(c("date", "open", "high", "low", "close", "volume", "adjusted")) %>% 
              drop_na() %>%
                                
              # Convert the date column to a date object (I suggest a lubridate function)
              dplyr::... %>% 
              # Select the date and the adjusted column
              dplyr::... %>%
    
              # Add the moving averages
              # name the columns mavg_short and mavg_long
              dplyr::...(... = ...(..., ...,  fill = NA, align = "right")) %>% 
              dplyr::...(... = ...(..., ...,  fill = NA, align = "right"))
```

*Modularize (function)*

Basically, you just need to copy your code from above into the `function` function.

```r
get_stock_data <- function(stock_symbol, 
                           from = today() - days(180), 
                           to   = today(), 
                           mavg_short = 20, mavg_long = 50) {
    
    stock_symbol %>% quantmod::getSymbols( 
        ...
    
}
```

*Example function calls*

```r
stock_data_tbl <- get_stock_data("AAPL", from = "2020-06-01", to = "2021-01-12", mavg_short = 5, mavg_long = 8)
## # A tibble: 156 x 4
##    date       adjusted mavg_short mavg_long
##    <date>        <dbl>      <dbl>     <dbl>
##  1 2020-06-01     80.2       NA        NA  
##  2 2020-06-02     80.6       NA        NA  
##  3 2020-06-03     81.0       NA        NA  
##  4 2020-06-04     80.3       NA        NA  
##  5 2020-06-05     82.6       80.9      NA  
##  6 2020-06-08     83.1       81.5      NA  
##  7 2020-06-09     85.7       82.5      NA  
##  8 2020-06-10     87.9       83.9      82.7
##  9 2020-06-11     83.7       84.6      83.1
## 10 2020-06-12     84.4       84.9      83.6
## # … with 146 more rows
```


### 1.4 Plot the stock data

Now that we are able to pull in the data, we can easily plot a time series diagram with `ggplot` and `ggplotly`. 

* Convert to long format (factors keep the order of our legend matching the order of our data columns)
* ggplot has to be grouped <<- see my stackoverflow answer
* You cann add themes or change the style as you want

*Test code*

```r
g <- stock_data_tbl %>% 
    
     # convert to long format
     pivot_longer(...    = ..., 
                  ...    = ..., 
                  ...    = ..., 
                  names_ptypes = list(legend = factor())) %>% 
    
     # ggplot
     ggplot(aes(..., ..., ... = ..., group = legend)) +
     geom_line(aes(linetype = legend)) +
     
     # Add theme possibly: theme_...
     # Add colors possibly: scale_color_..
     
     labs(y = "Adjusted Share Price", x = "")

ggplotly(g)
```

<iframe width="100%" height="600" name="iframe" frameBorder="0" src="/img/courses/dat_sci/14/stock_plot.html"></iframe>
<!--- {{< plotly json="/img/courses/dat_sci/14/test.json" height="500px" modebar="false">}} DOES NOT WORK --->

*Modularize (function)*

```r
plot_stock_data <- function(stock_data) {

     g <- stock_data %>%

     ...

     ggplotly(g)
}
```

*Example function calls*

```r
"ADS.DE" %>% 
    get_stock_data() %>%
    plot_stock_data()
```

* Control for different currencies. The y-axis needs to be in € for the German stocks and in $ for the US stocks.

KLÄRUNG `OLI`: sollen die das selber bauen?

```r
currency_format <- function(currency) {
    
    if (currency == "dollar") { x <- scales::dollar_format(largest_with_cents = 10) }
    if (currency == "euro")   { x <- scales::dollar_format(prefix = "", suffix = " €",
                                     big.mark = ".", decimal.mark = ",",
                                     largest_with_cents = 10)}
    
    return(x)
}

# Add this to your plot function
## scale_y_continuous(labels = currency_format(stock_list_lst %>% purrr::pluck("currency"))) +
```

*Example function calls*

We have to add another argument to the `plot_stock_data()` function:

```r
stock_list_lst <- get_stock_list()
"ADS.DE" %>% 
    get_stock_data() %>%
    plot_stock_data(stock_data = .,
                    index_data = stock_list_lst)

```

### 1.5 COMMENTARY 

Automatically generate an anaylist commentary based on a moving average logic:

**1.5.1 Implement commentary Logic** 

Compare both moving averages on the last day. The logic goes as this:

* If short < long, this is a bad sign
* If short > long, this is a 

Steps

1. Get last value
2. Compare long and short

KLÄRUNG `OLI`: sollen die das selber bauen?

```r
warning_signal <- stock_data_tbl %>%
    tail(1) %>% # Get last value
    mutate(mavg_warning_flag = mavg_short < mavg_long) %>%
    pull(mavg_warning_flag)
```

**1.5.2 Extract the moveing average days**

Calculate / Extract which ...-day moving average are generated (baesed on the number of NAs):

KLÄRUNG `OLI`: sollen die das selber bauen?

```r
n_short <- stock_data_tbl %>% pull(mavg_short) %>% is.na() %>% sum() + 1
n_long  <- stock_data_tbl %>% pull(mavg_long) %>% is.na() %>% sum() + 1
```

Create a warning signal logic:

```r
if (warning_signal) {
    str_glue("In reviewing the stock prices of {user_input}, the {n_short}-day moving average is below the {n_long}-day moving average, indicating negative trends")
} else {
    str_glue("In reviewing the stock prices of {user_input}, the {n_short}-day moving average is above the {n_long}-day moving average, indicating positive trends")
}
```

*Modularize (function)*

```r
generate_commentary <- function(data, user_input) {
    warning_signal <- data %>%
        tail(1) %>%
        mutate(mavg_warning_flag = mavg_short < mavg_long) %>%
        pull(mavg_warning_flag)
    
    n_short <- data %>% pull(mavg_short) %>% is.na() %>% sum() + 1
    n_long  <- data %>% pull(mavg_long) %>% is.na() %>% sum() + 1
    
    if (warning_signal) {
        str_glue("In reviewing the stock prices of {user_input}, the {n_short}-day moving average is below the {n_long}-day moving average, indicating negative trends")
    } else {
        str_glue("In reviewing the stock prices of {user_input}, the {n_short}-day moving average is above the {n_long}-day moving average, indicating positive trends")
        
    }
}

generate_commentary(stock_data_tbl, user_input = user_input)
```

*Example function calls*

```r
# get_stock_list("DAX")
"ADS.DE, Adidas" %>% 
    get_symbol_from_user_input() %>%
    get_stock_data(from = "2020-01-01", to = "2020-12-30") %>%
    # plot_stock_data()
    generate_commentary(user_input = "ADS.DE, Adidas")
## In reviewing the stock prices of ADS.DE, Adidas, the 20-day moving average is above the 50-day moving average, indicating positive trends
```

#### 1.6 Save scripts

The following code allows you to override your functions everytime you add changes to them:

```r
fs::dir_create("00_scripts") #create folder

# write functions to an R file
dump(
    list = c("get_stock_list", "get_symbol_from_user_input", "get_stock_data", "plot_stock_data", "generate_commentary"),
    file = "00_scripts/stock_analysis_functions.R", 
    append = FALSE) # Override existing 
```

 
## 2 Stock Analyzer - Creating the Layout with Shiny

Now that we have all of our functions, we can start to build our app. Let's start with building the layout first. The layout refers to the User Interface (Design & Structure of our App)

* Download File template (01_stock_analyzer_layout.R)

<!-- DOWNLOADBOX -->
<div id="header">Website</div>
<div id="container">
  <div id="first">{{% icon globe %}}</div>
  <div id="second"><a href="https://cloud.tuhh.de/index.php/s/RxKHWAbBZm4m9gB" target="_blank"><b>01_stock_analyzer_layout_template.R</b></a></div>
  <div id="clear"></div>
</div>

RStudio IDE will alter it's functionality once it recognizes we are building a Shiny App (buttons top right of the window)

There are 3 components of a Shiny App

1. UI
  +  `ui`: A function that is built using nested HTML componets. More importantly, this function controls to look & appearance of our web application.
    + `fluidPage()` crates a Web Page that we can add elements to.
2. Server
  + `server`: A special function that is setup with an input, output & session. More important, this is where reactive code is run.
3. shinyApp()
  + `shinyApp()`: Connects the UI with the server functionality

Our script needs to have at least the following components:

```r
# UI ----
ui <- fluidPage(title = "Stock Analyzer")

# SERVER ----
server <- function(input, output, session) {

}

# RUN APP ----
shinyApp(ui = ui, server = server)
```

Run App Button --> Result in Viewer

{{< figure src="/img/courses/dat_sci/14/shiny_layout_empty.png">}}

You see the title

If you inspect the HTML file (right click ...) in the <head> node ... and pretty much an empty body (container-fluid). divisions.

see for yourself. this function just produces some HTML code with an empty division (div):

```r
fluidPage(title = "Stock Analyzer")
## <div class="container-fluid"></div>
```

Now let's assemble every necessary part of our layout.

### 2.1 Making the Header of our web app

First we want to start playing around with this fluidPage. This is how shiny allows us to build applications by changing the underlying HTML code.

```
ui <- fluidPage(
    title = "Stock Analyzer",
    
    # 0.0 Test ----
    "Learning Shiny... I'm building my first App"
)
```

Add new components. Keep your app organized with comments. Use the outline to navigate your app.

* `div()` function: Creates an HTML division. It's used to create sections in your app (<div></div>).

* `h1()`: Creates an H1 Header (largest size of header) (<h1></h1>).
* `p()`: Creates an paragraph HTML tag (<p></p>)

```r
# 1.0 HEADER ----
div(
    h1("Stock Analzer")
    p("This is my second shiny project")
)
```

{{< figure src="/img/courses/dat_sci/14/shiny_layout_header.png">}}


### 2.2 Adding the Main Application UI Section

Essentially we are building a website. We want to have different sections. 

The actual dropdown and the plot in here 

column() generates a bootstrap grid column with width specified in units up to 12 units wide

```r
# 2.0 APPLICATION UI -----
div(
    column(width = 4, "UI"),
    column(width = 8, "Plot")
)
```

4 units on the left and 8 units on the right. If you drag it, it will adjust. (include bootstrap information here) We call that responsive layout. Responsive Layout: Depending on the width of your screen, bootstrap adjusts the columns. This helps apps look good on Mobile, Tablet & Desktop devices.

{{< figure src="/img/courses/dat_sci/14/shiny_layout_cols.png">}}

Shiny has HTML Helpers: These are bootstrap components that Shiny has turned into functions. We'll see a bunch of examples of these.

ADD wellPanel()

wellPanel(): Creates a Bootstrap Well. This is just a diviion that has a gray background. <div class="well"></div>
pickerInput(): A shinywidgets widget that creates a UI dropdown

runApp(): Use runApp() if the "Reload App" button gets hung up. Note that runApp() looks for a file called "app.R". If your app has a file name that is different, just put it in quotes inside of runApp()

e.g. runApp("01_stock_analyzer_layout.R")

```r
# 2.0 APPLICATION UI -----
div(
  column(
    width = 4,
    wellPanel(
    
    # Add content here pickerInput(inputId = "stock_selection", choices = 1:10)
    
    )
  ), 
  column(
    width = 8,
    div(
    
    # Add content here
    
    )
  )
)
```

### 2.3 Generating the S&P500 Stock List Dropdown


Some calc's only need to be performed once. I typically add these to the top of my application (or in a file that I source)

e.g. get_stock_list() on top (above the ### UI)

pickerInput: Check out the shinyWidgets documentation for more information on available widgets and options
--> change the choices to stocklist$label
multiple = F
selected = filter to aAAPLE (This will fail if AAPL is not present. What if AAPL gets removed from the SP500? Or what if the user selects an index like the DAX that AAPL is not part of?) How can you make this code more resistant to failure?

?pickerOptions
set options: 
* actionsBox
* liveSearch 
* size

{{< figure src="/img/courses/dat_sci/14/shiny_layout_dropdown.png">}}

### 2.4 Adding the Analyze button

actionButton(): A button that generates a click event
icon() let's us use Font Awesome icons ("download" icon)

{{< figure src="/img/courses/dat_sci/14/shiny_layout_button.png">}}

Nothing will happen, because we don't have set up any server logics

### 2.5 Inserting the Interactive Time Series Plot into our UI

Add two divisions for the title and for the plot 

* div(h4())
* div(get_stock_data(), plot_stock_data())

you could store the data at the top of the script (like the idnex list)

now we should have the plot in there

{{< figure src="/img/courses/dat_sci/14/shiny_layout_plot.png">}}

### 2.6  Adding the Analyst Commentary

width = 12
generate_commentary(user_input = "Placeholder")

{{< figure src="/img/courses/dat_sci/14/shiny_layout_commentary.png">}}

## 3. Adding Server Functionality

Let's start filling the server function.

* Cheat Sheet: Part Sever Opeartions (Reactivity)

### 3.1 Reactive Symbol Extraction

you can comment out / remove the stock_data_tbl at the top, because that is going to be updated depending on the user input

everything is needed in our source file. we just need to figure out how to use these

* Delay Reactions (Great for gernerating reactive values from Button clicks)
* eventReactive(): generates a reactive value only when an event happens. Good for creating reactive values following button clicks

start with plotting out the symbol that the user selects

 Analyze 
input`$` and output`$`

1. Get the symbol that the user is selecting (--> inputId = "analyze")

    # Stock Symbol ----
    stock_symbol <- eventReactive(input$analyze, {
        input$stock_selection
    })

    output$selected_symbol <- renderText(stock_symbol())
    
Use `renderText()` and `textOutput()` together. These are used to generate HTML text for inside H-tags (headers) and p-tags (paragraphs)

{{< figure src="/img/courses/dat_sci/14/shiny_server_textoutput1.png">}}


### 3.2 Reactively Generate the Plot Header - On Button Click

event

output$plot_header <- renderText(stock_symbol())

should include ignoreNULL = FALSE: to allow App to run on load.

{{< figure src="/img/courses/dat_sci/14/shiny_server_textoutput2.png">}}


### 3.3 Reactively Import Stock Data - On Symbol Extraction

server

When `stock_symbol()` changes it will react (reactive()) stock_data_tbl()


Use renderPrint() + verbatimTextOutput() when developing your app. It helps to see how the app is processing your code

verbatimTextOutput(outputId = "stock_data")
renderPrint(stock_data_tbl())


```r
# Get Stock Data ----
stock_data_tbl <- reactive({

  stock_symbol() %>% 
        get_stock_data(from = today() - days(180), 
                       to   = today(),
                       mavg_short = 20,
                       mavg_long  = 50)

})

output$stock_data <- renderPrint(stock_data(), {



})

```

{{< figure src="/img/courses/dat_sci/14/shiny_server_stock_data.png">}}


### 3.4 Reactively Render the Interactive Time Series Plot - On Stock Data Update


Instead of rendering the plot data, we want to render the plot. when `stock_data_tbl` changes

`renderPlotly()` will render the interactive plot

`renderPlotly()` and `plotlyOutput()` got together. 

* ... renders the plot on the server
* ... positions the plot in the UI

can use the ID "plotly_plot"


### 3.5 Reactively Render the Analyst Commentary - On Stock Data Update + Action Button Event

self explaining

### 3.6 Add moving average sliders to your Stock Analyzer

you can use hr()

APPLICATION DESCRIPTION ----
- Add Moving Average Functionality
- UI Placement:
  - Add a horizontal rule between the Analyze button and the new UI.
  - Place the Sliders below the button and horizontal rule
- Short MAVG Requirements: Starting value of 20, min of 5, max of 40
- Long MAVG Requirements: Starting value of 50, min of 50, max of 120
- Server requirements: Update immediately on change

{{< figure src="/img/courses/dat_sci/14/shiny_server_mavg.png">}}

### 3.7 Add Index selection

{{< figure src="/img/courses/dat_sci/14/shiny_server_index_selection.png">}}

### 3.8 Add Date Range input

Final

{{< figure src="/img/courses/dat_sci/14/shiny_server_final.png">}}

### 3.9 App Cleanup

Don't forget to remove everything. Commented out stuff, the textOutputs() etc ...

Order the server functions as consistent as possible with your anaylsis workflow. This makes it easier to debug your app and mak updates to your app as your analyiss cahgnes over time

It does not has a lot of theme to it, it just looks like a basic website ... You could make it look really cool though with bootstrap.
