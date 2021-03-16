---
title: Intro to the tidyverse
linktitle: Intro to the tidyverse
toc: true
type: docs
date: "2019-05-05T00:00:00+01:00"
draft: false
menu:
  data_science:
    parent: I. Data Science Fundamentals
    weight: 4

# Prev/next pager order (if `docs_section_pager` enabled in `params.toml`)
weight: 3
---

{{< figure src="/img/courses/dat_sci/02/data_science_workflow.png" caption="Typical data sciecne workflow" >}}

The intent of this chapter is to get you familiarized with the process of going from data import to visualization. This section will walk you through the core concepts in the packages `dplyr` and `ggplot2`, which are parts of the `tidyverse`. The tidyverse is a collection of R packages developed by RStudio’s chief scientist Hadley Wickham. These packages work well together as part of larger data analysis pipeline. You will gain a tremendous level of experience and repetitions with these packages, which will solidify your knowledge. The later chapters will solidify your understanding of all concepts in this part.

<!-- HEADING (R theory) -->
## Theory Input <i class="fab fa-r-project" aria-hidden="true"></i> &nbsp;
### Packages

You know what functions are and how to write your own functions. You’re not the only person writing your own functions with R. Many people design tools that can help people analyze data. They provide those functions and objects for free in wrapped up packages. You only have to download and install them. Each R package is hosted at http://cran.r-project.org, the same website that hosts R (often interesting new R packages are only available on GitHub, because submitting to CRAN is a lot more work than just providing a version on github). However, you don’t need to visit the website (or github) to download an R package. You can download packages straight from R’s command line.

**Video instructions to install R packages**

<div style="padding:62.5% 0 3% 0;position:relative;"><iframe src="https://player.vimeo.com/video/203516241?color=428bca&title=0&byline=0&portrait=0" style="position:absolute;top:0;left:0;width:100%;height:100%;" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe></div><script src="https://player.vimeo.com/api/player.js"></script>

These are the basic commands you will need for installing and loading packages in your current R session:

<!-- CODE (show) -->
<pre><code class="r"># install package from CRAN
install.packages("packagename")

# load the package to use in the current R session
library("packagename")         

# use a particular function within a package without loading the package
packagename::function_name()</code></pre>
<!-- CODE (show) -->

<!-- INFOBOX -->
<div id="header">Infobox</div>
<div id="container">
  <div id="first">{{% icon info-solid %}}</div>
  <div id="second">Use tab complete to quickly complete function names as well as file pathes.</div>
  <div id="clear"></div>
</div>

Downlaod the following file and place in your getting_started folder. Try running the commands to install some of the packages we are going to use throughout this class.

<!-- DOWNLOADBOX -->
<div id="header">Download</div>
<div id="container">
  <div id="first">{{% icon download %}}</div>
  <div id="second"><a href="https://github.com/TUHHStartupEngineers/dat_sci_ss20/raw/master/02/install_pkgs.R" target="_blank"><b>install_pkgs.R</b></a></div>
  <div id="clear"></div>
</div>

**Windows Users:** You will get a warning if `Rtools` is not installed. See the last session for install instructions.

If you get a message saying "Do you want to install from source the packages which need compilation?", selecting "No" will revert to the latest compiled version which may not be the most recent on CRAN (the respository that people and organizations store open source packages on). Selecting "Yes" will download the latest, and use your machine to do the compiling. This may take longer.

If you get errors do the following:
1. Try installing one package at a time. Find which package has the error and isolate it. Then proceed to step 2.
2. Restart R by exiting RStudio and reopening. Retry installing the problem package. If this does not work, proceed to step 3.
3. Google "R" + "install.packages" + the error message. Chances are 99% likely that someone else has experienced an error like yours.

If otherwise unsuccessful, contact me and I will do my best to troubleshoot.

***

### Pipes

<a href="https://magrittr.tidyverse.org" target="_blank">
<img src="/img/icons/logo_pipe.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>
Pipes are a powerful tool for clearly expressing a sequence of multiple operations. You will be using the “pipe”-operator <code>%>%</code> throughout this class. The “pipe” is from the <code>magrittr</code> package (included in the tidyverse). The point of the pipe is to help you write code in a way that is easier to read and understand. It makes your code more readable by structuring sequences of data operations left-to-right (as opposed to from the inside and out). The pipe makes your code read more like a sentence, branching from left to right. You can read it as a series of imperative statements: group, then summarise, then filter. As suggested by this reading, a good way to pronounce <code>%>%</code> when reading code is “then”. Mathematically it can be expressed like the following:<br></br>

* `x %>% f` is equivalent to `f(x)`
* `x %>% f(y)` is equivalent to `f(x, y)`
* `x %>% f %>% g %>% h` is equivalent to `h(g(f(x)))`


Instead of writing this:

<!-- CODE (show) -->
<pre><code class="r">data <- iris
data <- head(data, n=3)</code></pre>
<!-- CODE (show) -->
you can write the code like this:
<!-- CODE (show) -->
<pre><code class="r"># The easiest way to get magrittr is to load the whole tidyverse:
library("tidyverse")
# Alternatively, load just magrittr:
library("magrittr")

iris %>% head(n=3)</code></pre>
<!-- CODE (show) -->

When coupling several function calls with the pipe-operator, the benefit will become more apparent. Consider this pseudo example:

<!-- CODE (show) -->
<pre><code class="r">the_data <-
  read.csv('/path/to/data/file.csv') %>%
  subset(variable_a > x) %>%
  transform(variable_c = variable_a/variable_b) %>%
  head(100)</code></pre>
<!-- CODE (show) -->

***

### Tibbles

<a href="https://tibble.tidyverse.org/" target="_blank">
<img src="/img/icons/logo_tibble.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>
Throughout this class we work with <code>tibbles</code> instead of R’s traditional <code>data.frame</code>. Tibbles are data frames, but they tweak some older behaviours to make life a little easier. R is an old language, and some things that were useful 10 or 20 years ago now get in your way. In most places, the term tibble and data frame will be used interchangeably.<br></br>

* tibble is one of the unifying features of tidyverse,
* it is a better data.frame realization,
* objects of the class data.frame can be coerced to tibble using `as_tibble()`

When you print a tibble, the output shows:
* all columns that fit the screen
* first 10 rows
* data type for each column

A tibble is being constucted like this:

<!-- CODE (show) -->
<pre><code class="r">tibble(
    x = 1:50,
    y = runif(50), 
    z = x + y^2,
    outcome = rnorm(50)
  )</code></pre>
<!-- CODE (show) -->

Check yourself how dataframes and tibbles print differently (you can use for an example the built in dataframe `cars`):

<!-- CODE (show) -->
<pre><code class="r">class(cars)
## "data.frame"

cars_tbl <- as_tibble(cars)
class(cars_tbl)
## "tbl_df"     "tbl"        "data.frame"
</code></pre>
<!-- CODE (show) -->

There are multiple ways of subsetting (retrieving just parts of the date) tibbles:

<!-- CODE (show) -->
<pre><code class="r"># This way applies to dataframes and tibbles
vehicles <- as_tibble(cars[1:5,])
vehicles[['speed']]
vehicles[[1]]
vehicles$speed

# Using placeholders with the pipe
vehicles %>% .$dist
vehicles %>% .[['dist']]
vehicles %>% .[[2]]</code></pre>
<!-- CODE (show) -->

***

### Import

Before you can manipulate data with R, you need to import the data into R’s memory, or build a connection to the data that R can use to access the data remotely.

How you import your data will depend on the format of the data. The most common way to store small data sets is as a plain text file. Data may also be stored in a proprietary format associated with a specific piece of software, such as SAS, SPSS, or Microsoft Excel. Data used on the internet is often stored as a JSON or XML file. Large data sets may be stored in a database or a distributed storage system.

When you import data into R, R stores the data in your computer’s RAM while you manipulate it. This creates a size limitation: truly big data sets should be stored outside of R in a database or distributed storage system. You can then create a connection to the system that R can use to access the data without bringing the data into your computer’s RAM.

The tidyverse offers the following packages for importing data:

* `readr` for reading flat files like .csv files
* `readxl` for .xls and .xlsx sheets.
* `haven` for SPSS, Stata, and SAS data.
* `googledrive` to interact with files on Google Drive from R.

<figure>
<div class="logo_row">
  <div class="logo_column">
    <a href="https://readr.tidyverse.org" target="_blank">
      <img src="/img/icons/logo_readr.svg" alt="CAPTION" style="width:100%">
    </a>
  </div>
  <div class="logo_column">
    <a href="https://readxl.tidyverse.org" target="_blank">
      <img src="/img/icons/logo_readxl.svg" alt="Snow" style="width:100%">
    </a>
  </div>
  <div class="logo_column">
    <a href="https://haven.tidyverse.org" target="_blank">
      <img src="/img/icons/logo_haven.svg" alt="Forest" style="width:100%">
    </a>
  </div>
  <div class="logo_column">
    <a href="https://googledrive.tidyverse.org" target="_blank">
      <img src="/img/icons/logo_googledrive.svg" alt="Mountains" style="width:100%">
    </a>
  </div>
</div>
<figcaption>Click on the images to get more information about the packages and their functions.</figcaption>
</figure>

There are a handful of other packages that are not in the tidyverse, but are tidyverse-adjacent. They are very useful for importing data from other sources (we will use them in the next session):

* [jsonlite](https://github.com/jeroen/jsonlite#jsonlite) for JSON.
* [xml2](https://github.com/r-lib/xml2) for XML.
* [httr](https://github.com/r-lib/httr) for web APIs.
* [rvest](https://github.com/hadley/rvest) for web scraping.
* [DBI](https://github.com/rstats-db/DBI) for relational databases. To connect to a specific database, you’ll need to pair DBI with a specific backend like RSQLite, RPostgres, or odbc. Learn more at [https://db.rstudio.com](https://db.rstudio.com).

**Example**

<!-- CODE (show) -->
<pre><code class="r"># Loading data (can also be achieved by clicking on "Import Dataset > From Text (readr)" in the upper right corner)
library(readr)
dataset_tbl <- read_csv("data.csv")
# In case of possible parsing errors, analyze them with problems()
readr::problems(dataset_tbl)

# Writing data
write_csv(dataset_tbl, "data.csv")

# Saving in csv (or tsv) does mean you loose information about the type of data in particular columns. You can avoid this by using  write_rds() and read_rds() to read/write objects in R binary rds format.
write_rds(dataset_tbl, "data.rds")</code></pre>
<!-- CODE (show) -->

***

### Tidy
<a href="https://tidyr.tidyverse.org/" target="_blank">
<img src="/img/icons/logo_tidyr.png" align="right" style="width:200px; height:231px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

Reshaping your data with tidyr

The Concept of Tidy Data

* each and every observation is represented as exactly one row,
* each and every variable is represented by exactly one column,
* thus each data table cell contains only one value.

{{< figure src="/img/courses/dat_sci/02/tidy_data_w.png" caption="The concept of tidy data" >}}


Usually data are untidy in only one way. However, if you are unlucky, they are really untidy and thus a pain to work with...

***

**Exercise**

Which of these data are tidy?

<!-- TABLES -->
<table style="position:relative; float:left; width:66%;" align="left">
<caption style="color: #fff;">table 1</caption>
<thead>
<tr>
<th>Sepal.Length</th>
<th>Sepal.Width</th>
<th>Petal.Length</th>
<th>Petal.Width</th>
<th>Species</th>
</tr>
</thead>
<tbody>
<tr>
<td>5.1</td>
<td>3.5</td>
<td>1.4</td>
<td>0.2</td>
<td>setosa</td>
</tr>
<tr>
<td>4.9</td>
<td>3.0</td>
<td>1.4</td>
<td>0.2</td>
<td>setosa</td>
</tr>
<tr>
<td>4.7</td>
<td>3.2</td>
<td>1.3</td>
<td>0.2</td>
<td>setosa</td>
</tr>
</tbody>
</table>
<table style="position:relative; float:right; width:31%;" align="right">
<caption style="color: #fff;">table 2</caption>
<thead>
<tr>
<th>Species</th>
<th>variable</th>
<th>value</th>
</tr>
</thead>
<tbody>
<tr>
<td>setosa</td>
<td>Sepal.Length</td>
<td>5.1</td>
</tr>
<tr>
<td>setosa</td>
<td>Sepal.Length</td>
<td>4.9</td>
</tr>
<tr>
<td>setosa</td>
<td>Sepal.Length</td>
<td>4.7</td>
</tr>
</tbody>
</table>


<table style="position:relative; float:left; width:52%;">
<caption style="color: #fff;">table 3</caption>
<thead>
<tr>
<th>Sepal.Length</th>
<th>5.1</th>
<th>4.9</th>
<th>4.7</th>
<th>4.6</th>
</tr>
</thead>
<tbody>
<tr>
<td>Sepal.Width</td>
<td>3.5</td>
<td>3.0</td>
<td>3.2</td>
<td>3.1</td>
</tr>
<tr>
<td>Petal.Length</td>
<td>1.4</td>
<td>1.4</td>
<td>1.3</td>
<td>1.5</td>
</tr>
<tr>
<td>Petal.Width</td>
<td>0.2</td>
<td>0.2</td>
<td>0.2</td>
<td>0.2</td>
</tr>
<tr>
<td>Species</td>
<td>setosa</td>
<td>setosa</td>
<td>setosa</td>
<td>setosa</td>
</tr>
</tbody>
</table>
<table style="position:relative; float:left; width:45%;">
<caption style="color: #fff;">table 4</caption>
<thead>
<tr>
<th>Sepal.L.W</th>
<th>Petal.L.W</th>
<th>Species</th>
</tr>
</thead>
<tbody>
<tr>
<td>5.1/3.5</td>
<td>1.4/0.2</td>
<td>setosa</td>
</tr>
<tr>
<td>4.9/3</td>
<td>1.4/0.2</td>
<td>setosa</td>
</tr>
<tr>
<td>4.7/3.2</td>
<td>1.3/0.2</td>
<td>setosa</td>
</tr>
<tr>
<td style="opacity:0;">---</td>
<td style="opacity:0;">---</td>
<td style="opacity:0;">---</td>
</tr>
</tbody>
</table>
<div style="clear: both;">
<!-- TABLES -->
 
**Solution**
 
<section class="hide">
table 1
</section>
 
***
 
To illustrate how we can make data tidy easily, we are using modified variants of the diamonds dataset from the ggplot2 package. Try to make the data tidy by looking at the corresponding help pages of each provided function.


1. Tidying data with `pivot_longer()`: Use, if some of your column names are actually values of a variable. Alternatively you can use `gather()`, but it is recommended to use `pivot_longer()`, because the other function is no longer being maintained.

<div id="header">Download</div>
<div id="container">
  <div id="first">{{% icon download %}}</div>
  <div id="second"><a href="https://github.com/TUHHStartupEngineers/dat_sci_ss20/raw/master/02/diamonds2.rds" target="_blank"><b>diamonds2.rds</b></a></div>
  <div id="clear"></div>
</div>

<!-- CODE (show) -->
<pre><code class="r">library(tidyverse)
diamonds2 <- readRDS("diamonds2.rds")

diamonds2 %>% head(n = 5)
## # A tibble: 5 x 3
##   cut     `2008` `2009`
##   &lt;chr&gt;    &lt;dbl&gt;  &lt;dbl&gt;
## 1 Ideal      326    332
## 2 Premium    326    332
## 3 Good       237    333
## 4 Premium    334    340
## 5 Good       335    341</code></pre>
<!-- CODE (show) -->

**Solution**

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">diamonds2 %>% 
  pivot_longer(cols      = c("2008", "2009"), 
               names_to  = 'year', 
               values_to = 'price') %>% 
  head(n = 5)</br>
#&#x2060;#&#x2060; # A tibble: 5 x 3
#&#x2060;#&#x2060;   cut     year  price
#&#x2060;#&#x2060;   &lt;chr&gt;   &lt;chr&gt; &lt;dbl&gt;
#&#x2060;#&#x2060; 1 Ideal   2008    326
#&#x2060;#&#x2060; 2 Ideal   2009    332
#&#x2060;#&#x2060; 3 Premium 2008    326
#&#x2060;#&#x2060; 4 Premium 2009    332
#&#x2060;#&#x2060; 5 Good    2008    237</code></pre>

The wide (original) format might be good for business reports, but it is not good for doing analyses. If we wanted to predict the price based on the other data (with a simple linear regression), we need the long format:

<pre><code class="r">model <- lm(price ~ ., data = diamonds2_long)
model
#&#x2060;#&#x2060; Call:
#&#x2060;#&#x2060; lm(formula = price ~ ., data = diamonds2_long)</br>
#&#x2060;#&#x2060; Coefficients:
#&#x2060;#&#x2060; (Intercept)     cutIdeal   cutPremium     year2009  
#&#x2060;#&#x2060;        237           89           89            6</code></pre>  

</section>
<!-- CODE (hide) -->

***

2. Tidying data with `pivot_wider()`: Use, if some of your observations are scattered across many rows. Alternatively you can use `spread()`, but it is recommended to use `pivot_wider()`, because the other function is no longer being maintained.

<!-- DOWNLOADBOX -->
<div id="header">Download</div>
<div id="container">
  <div id="first">{{% icon download %}}</div>
  <div id="second"><a href="https://github.com/jwarz/dat_sci_ss20/blob/master/02/diamonds3.rds?raw=true" target="_blank"><b>diamonds3.rds</b></a></div>
  <div id="clear"></div>
</div>

<!-- CODE (show) -->
<pre><code class="r">diamonds3 <- readRDS("diamonds3.rds")

diamonds3 %>% head(n = 5)
## # A tibble: 5 x 5
##   cut     price clarity dimension measurement
##   &lt;ord&gt;   &lt;dbl&gt; &lt;ord&gt;   &lt;chr&gt;           &lt;dbl&gt;
## 1 Ideal     326 SI2     x                3.95
## 2 Premium   326 SI1     x                3.89
## 3 Good      327 VS1     x                4.05
## 4 Ideal     326 SI2     y                3.98
## 5 Premium   326 SI1     y                3.84</pre></code>
<!-- CODE (show) -->

**Solution**

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">diamonds3 %>% 
  pivot_wider(names_from  = "dimension",
              values_from = "measurement") %>% 
  head(n = 5)</br>
#&#x2060;#&#x2060; # A tibble: 3 x 6
#&#x2060;#&#x2060;    cut     price clarity     x     y     z
#&#x2060;#&#x2060;   &lt;ord&gt;    &lt;dbl&gt; &lt;ord&gt;   &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;
#&#x2060;#&#x2060; 1 Ideal     326 SI2      3.95  3.98  2.43
#&#x2060;#&#x2060; 2 Premium   326 SI1      3.89  3.84  2.31
#&#x2060;#&#x2060; 3 Good      327 VS1      4.05  4.07  2.31</code></pre>
</section>
<!-- CODE (hide) -->

***

3. Tidying data with `separate()`: If some of your columns contain more than one value, use separate:

<!-- DOWNLOADBOX -->
<div id="header">Download</div>
<div id="container">
  <div id="first">{{% icon download %}}</div>
  <div id="second"><a href="https://github.com/jwarz/dat_sci_ss20/blob/master/02/diamonds4.rds?raw=true" target="_blank"><b>diamonds4.rds</b></a></div>
  <div id="clear"></div>
</div>

<!-- CODE (show) -->
<pre><code class="r">diamonds4 <- readRDS("diamonds4.rds")

diamonds4
## # A tibble: 5 x 4
##   cut     price clarity dim           
##   &lt;ord&gt;   &lt;dbl&gt; &lt;ord&gt;   &lt;chr&gt;         
## 1 Ideal     326 SI2     3.95/3.98/2.43
## 2 Premium   326 SI1     3.89/3.84/2.31
## 3 Good      327 VS1     4.05/4.07/2.31
## 4 Premium   334 VS2     4.2/4.23/2.63 
## 5 Good      335 SI2     4.34/4.35/2.75</pre></code>
<!-- CODE (show) -->

**Solution**

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">diamonds4 %>% 
  separate(col = dim,
           into = c("x", "y", "z"),
           sep = "/",
           convert = T)</br>
#&#x2060;#&#x2060; # A tibble: 5 x 6
#&#x2060;#&#x2060;   cut     price clarity     x     y     z
#&#x2060;#&#x2060;   &lt;ord&gt;   &lt;dbl&gt; &lt;ord&gt;   &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;
#&#x2060;#&#x2060; 1 Ideal     326 SI2      3.95  3.98  2.43
#&#x2060;#&#x2060; 2 Premium   326 SI1      3.89  3.84  2.31
#&#x2060;#&#x2060; 3 Good      327 VS1      4.05  4.07  2.31
#&#x2060;#&#x2060; 4 Premium   334 VS2      4.2   4.23  2.63
#&#x2060;#&#x2060; 5 Good      335 SI2      4.34  4.35  2.75</code></pre>
</section>
<!-- CODE (hide) -->

***

4. Tidying data with `unite()`: use to paste together multiple columns into one:

<!-- DOWNLOADBOX -->
<div id="header">Download</div>
<div id="container">
  <div id="first">{{% icon download %}}</div>
  <div id="second"><a href="https://github.com/jwarz/dat_sci_ss20/blob/master/02/diamonds5.rds?raw=true" target="_blank"><b>diamonds5.rds</b></a></div>
  <div id="clear"></div>
</div>

<!-- CODE (show) -->
<pre><code class="r">diamonds5 <- readRDS("diamonds5.rds")

diamonds5
## # A tibble: 5 x 7
##   cut     price clarity_prefix clarity_suffix     x     y     z
##   &lt;ord&gt;   &lt;dbl&gt; &lt;chr&gt;          &lt;chr&gt;          &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;
## 1 Ideal     326 SI             2               3.95  3.98  2.43
## 2 Premium   326 SI             1               3.89  3.84  2.31
## 3 Good      327 VS             1               4.05  4.07  2.31
## 4 Premium   334 VS             2               4.2   4.23  2.63
## 5 Good      335 SI             2               4.34  4.35  2.75</pre></code>
<!-- CODE (show) -->

**Solution**

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">diamonds5 %>% 
  unite(clarity, clarity_prefix, clarity_suffix, sep = '')</br>
#&#x2060;#&#x2060; # A tibble: 5 x 6
#&#x2060;#&#x2060;   cut     price clarity     x     y     z
#&#x2060;#&#x2060;   &lt;ord&gt;   &lt;dbl&gt; &lt;ord&gt;   &lt;dbl&gt; &lt;dbl&gt; &lt;dbl&gt;
#&#x2060;#&#x2060; 1 Ideal     326 SI2      3.95  3.98  2.43
#&#x2060;#&#x2060; 2 Premium   326 SI1      3.89  3.84  2.31
#&#x2060;#&#x2060; 3 Good      327 VS1      4.05  4.07  2.31
#&#x2060;#&#x2060; 4 Premium   334 VS2      4.2   4.23  2.63
#&#x2060;#&#x2060; 5 Good      335 SI2      4.34  4.35  2.75</code></pre>
</section>
<!-- CODE (hide) -->

***

### Transform
<a href="https://dplyr.tidyverse.org/" target="_blank">
<img src="/img/icons/logo_dplyr.png" align="right" style="width:200px; height:231px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

Often you’ll need to create some new variables or summaries, or maybe you just want to rename the variables or reorder the observations in order to make the data a little easier to work with. `dplyr` is a grammar of data manipulation, providing a consistent set of verbs that help you solve the most common data manipulation challenges. The following five key dplyr functions allow you to solve the vast majority of your data manipulation challenges:

* **`filter()`** picks cases based on their values (formula based filtering). Use **`slice()`** for filtering with row numbers. So both can be used for selecting the relevant rows.

<!-- CODE (show) -->
<pre><code class="r">library(ggplot2) # To load the diamonds dataset
library(dplyr)
diamonds %>% 
    filter(cut == 'Ideal' | cut == 'Premium', carat >= 0.23) %>% 
    head(5)

## # A tibble: 5 x 10
##   carat cut     color clarity depth table price     x     y     z
##   <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1 0.23  Ideal   E     SI2      61.5    55   326  3.95  3.98  2.43
## 2 0.290 Premium I     VS2      62.4    58   334  4.2   4.23  2.63
## 3 0.23  Ideal   J     VS1      62.8    56   340  3.93  3.9   2.46
## 4 0.31  Ideal   J     SI2      62.2    54   344  4.35  4.37  2.71
## 5 0.32  Premium E     I1       60.9    58   345  4.38  4.42  2.68

diamonds %>% 
   filter(cut == 'Ideal' | cut == 'Premium', carat >= 0.23) %>% 
   slice(3:4)
   
## # A tibble: 2 x 10
##   carat cut   color clarity depth table price     x     y     z
##   <dbl> <ord> <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1  0.23 Ideal J     VS1      62.8    56   340  3.93  3.9   2.46
## 2  0.31 Ideal J     SI2      62.2    54   344  4.35  4.37  2.71</pre></code>

<!-- INFOBOX -->
<div id="header">Infobox</div>
<div id="container">
  <div id="first">{{% icon info-solid %}}</div>
  <div id="second">
  An operator is a symbol that tells the compiler to perform specific mathematical or logical manipulations. You have used already mathematical operators. The following table shows some relational and logical operators supported by the R language.</br></br>
<table>
<thead>
<tr>
<th>Operator</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>&lt;</td>
<td>less than</td>
</tr>
<tr>
<td>&lt;=</td>
<td>less than or equal to</td>
</tr>
<tr>
<td>&gt;</td>
<td>greater than</td>
</tr>
<tr>
<td>&gt;=</td>
<td>greater than or equal to</td>
</tr>
<tr>
<td>==</td>
<td>exactly equal to</td>
</tr>
<tr>
<td>!=</td>
<td>not equal to</td>
</tr>
<tr>
<td>!x</td>
<td>Not x. Gives the opposite logical value.</td>
</tr>
<tr>
<td>x | y</td>
<td>x OR y</td>
</tr>
<tr>
<td>x &amp; y</td>
<td>x AND y</td>
</tr>
</tbody>
</table>
  </div>
  <div id="clear"></div>
</div>

***

* **`arrange()`** changes the ordering of the rows

<!-- CODE (show) -->
<pre><code class="r">diamonds %>% 
  arrange(cut, carat, desc(price))

# A tibble: 53,940 x 10
   carat cut   color clarity depth table price     x     y     z
   <dbl> <ord> <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
 1 0.22  Fair  E     VS2      65.1    61   337  3.87  3.78  2.49
 2 0.23  Fair  G     VVS2     61.4    66   369  3.87  3.91  2.39
 3 0.25  Fair  F     SI2      54.4    64  1013  4.3   4.23  2.32
 4 0.25  Fair  D     VS1      61.2    55   563  4.09  4.11  2.51
 5 0.25  Fair  E     VS1      55.2    64   361  4.21  4.23  2.33
 6 0.27  Fair  E     VS1      66.4    58   371  3.99  4.02  2.66
 7 0.290 Fair  F     SI1      55.8    60  1776  4.48  4.41  2.48
 8 0.290 Fair  D     VS2      64.7    62   592  4.14  4.11  2.67
 9 0.3   Fair  D     IF       60.5    57  1208  4.47  4.35  2.67
10 0.3   Fair  E     VVS2     51      67   945  4.67  4.62  2.37
# … with 53,930 more rows</code></pre>
<!-- CODE (show) -->

The NAs always end up at the end of the rearranged tibble.

---

* **`select()`** picks (or removes) variables based on their names

<!-- CODE (show) -->
<pre><code class="r">diamonds %>% 
  select(color, clarity, x:z) %>% 
  head(n = 5)

## # A tibble: 5 x 5
##   color clarity     x     y     z
##   <ord> <ord>   <dbl> <dbl> <dbl>
## 1 E     SI2      3.95  3.98  2.43
## 2 E     SI1      3.89  3.84  2.31
## 3 E     VS1      4.05  4.07  2.31
## 4 I     VS2      4.2   4.23  2.63
## 5 J     SI2      4.34  4.35  2.75</code></pre>
<!-- CODE (show) -->

Exclusive select:

<!-- CODE (show) -->
<pre><code class="r">diamonds %>% 
  select(-(x:z)) %>% 
  head(n = 5)
  
## # A tibble: 5 x 7
##   carat cut     color clarity depth table price
##   <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <int>
## 1 0.23  Ideal   E     SI2      61.5    55   326
## 2 0.21  Premium E     SI1      59.8    61   326
## 3 0.23  Good    E     VS1      56.9    65   327
## 4 0.290 Premium I     VS2      62.4    58   334
## 5 0.31  Good    J     SI2      63.3    58   335</code></pre>
<!-- CODE (show) -->

Select helpers

* `starts_with()` / `ends_with()`: helper that selects every column tht starts with a prefix or ends with a suffix
* `contains()`: A select helper that selects any column containing a string of text.
* `everything()`: a select() helper that selects every column that has not already been selected. Good for reordering.

<!-- CODE (show) -->
<pre><code class="r">diamonds %>% 
  select(x:z, everything()) %>% 
  head(n = 5)
  
## # A tibble: 5 x 10
##       x     y     z carat cut     color clarity depth table price
##   <dbl> <dbl> <dbl> <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <int>
## 1  3.95  3.98  2.43 0.23  Ideal   E     SI2      61.5    55   326
## 2  3.89  3.84  2.31 0.21  Premium E     SI1      59.8    61   326
## 3  4.05  4.07  2.31 0.23  Good    E     VS1      56.9    65   327
## 4  4.2   4.23  2.63 0.290 Premium I     VS2      62.4    58   334
## 5  4.34  4.35  2.75 0.31  Good    J     SI2      63.3    58   335</code></pre>

* **`rename()`** changes the name of a column.


<!-- CODE (show) -->
<pre><code class="r">diamonds %>% 
  rename(var_x = x) %>% 
  head(n = 5)

## # A tibble: 5 x 10
##   carat cut     color clarity depth table price var_x     y     z
##   <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <int> <dbl> <dbl> <dbl>
## 1 0.23  Ideal   E     SI2      61.5    55   326  3.95  3.98  2.43
## 2 0.21  Premium E     SI1      59.8    61   326  3.89  3.84  2.31
## 3 0.23  Good    E     VS1      56.9    65   327  4.05  4.07  2.31
## 4 0.290 Premium I     VS2      62.4    58   334  4.2   4.23  2.63
## 5 0.31  Good    J     SI2      63.3    58   335  4.34  4.35  2.75</code></pre>
<!-- CODE (show) -->


* **`mutate()`** adds new variables that are functions of existing variables and preserves existing ones.
* **`transmute()`** adds new variables and drops existing ones.

<!-- CODE (show) -->
<pre><code class="r">diamonds %>% 
  mutate(p = x + z, q = p + y) %>% 
  select(-(depth:price)) %>% 
  head(n = 5)

## # A tibble: 5 x 9
##   carat cut     color clarity     x     y     z     p     q
##   <dbl> <ord>   <ord> <ord>   <dbl> <dbl> <dbl> <dbl> <dbl>
## 1 0.23  Ideal   E     SI2      3.95  3.98  2.43  6.38  10.4
## 2 0.21  Premium E     SI1      3.89  3.84  2.31  6.2   10.0
## 3 0.23  Good    E     VS1      4.05  4.07  2.31  6.36  10.4
## 4 0.290 Premium I     VS2      4.2   4.23  2.63  6.83  11.1
## 5 0.31  Good    J     SI2      4.34  4.35  2.75  7.09  11.4</code></pre>
<!-- CODE (show) -->

<!-- CODE (show) -->
<pre><code class="r">diamonds %>% 
  transmute(carat, cut, sum = x + y + z) %>% 
  head(n = 5)

## # A tibble: 5 x 3
##   carat cut       sum
##   <dbl> <ord>   <dbl>
## 1 0.23  Ideal    10.4
## 2 0.21  Premium  10.0
## 3 0.23  Good     10.4
## 4 0.290 Premium  11.1
## 5 0.31  Good     11.4</code></pre>

* **`bind_cols()`** and **`bind_rows()`**: binds two tibbles column-wise or row-wise.

* **`group_by()`** and **`summarize()`** reduces multiple values down to a single summary

<!-- CODE (show) -->
<pre><code class="r">diamonds %>% 
  group_by(cut) %>% 
  summarize(max_price  = max(price),
            mean_price = mean(price),
            min_price  = min(price))

## # A tibble: 5 x 4
##   cut       max_price mean_price min_price
##   <ord>         <int>      <dbl>     <int>
## 1 Fair          18574      4359.       337
## 2 Good          18788      3929.       327
## 3 Very Good     18818      3982.       336
## 4 Premium       18823      4584.       326
## 5 Ideal         18806      3458.       326</code></pre>



* **`glimpse()`** can be used to see the columns of the dataset and display some portion of the data with respect to each attribute that can fit on a single line. You can apply this function to get a glimpse of your dataset. It is similar to the base function `str()`. 

<!-- CODE (show) -->
<pre><code class="r">glimpse(diamonds)
## Rows: 53,940
## Columns: 10
## $ carat   &lt;dbl&gt; 0.23, 0.21, 0.23, 0.29, 0.31, 0.24, 0.24, 0.26, 0.22, 0.23, …
## $ cut     &lt;ord&gt; Ideal, Premium, Good, Premium, Good, Very Good, Very Good, …
## $ color   &lt;ord&gt; E, E, E, I, J, J, I, H, E, H, J, J, F, J, E, E, I, J, J, J, …
## $ clarity &lt;ord&gt; SI2, SI1, VS1, VS2, SI2, VVS2, VVS1, SI1, VS2, VS1, SI1, VS1, …
## $ depth   &lt;dbl&gt; 61.5, 59.8, 56.9, 62.4, 63.3, 62.8, 62.3, 61.9, 65.1, 59.4, …
## $ table   &lt;dbl&gt; 55, 61, 65, 58, 58, 57, 57, 55, 61, 61, 55, 56, 61, 54, 62, …
## $ price   &lt;int&gt; 326, 326, 327, 334, 335, 336, 336, 337, 337, 338, 339, 340, 3…
## $ x       &lt;dbl&gt; 3.95, 3.89, 4.05, 4.20, 4.34, 3.94, 3.95, 4.07, 3.87, 4.00, …
## $ y       &lt;dbl&gt; 3.98, 3.84, 4.07, 4.23, 4.35, 3.96, 3.98, 4.11, 3.78, 4.05, …
## $ z       &lt;dbl&gt; 2.43, 2.31, 2.31, 2.63, 2.75, 2.48, 2.47, 2.53, 2.49, 2.39, …</code></pre>

**Data types and data structures**

Everything in R is an object. R has 6 basic data types. U can use `typeof()` to asses the data type or mode of an object.

| data type | example | 
| --- | --- |
| character | <pre style="margin:0px"><code class="r">"a", "dice"</code></pre> |
| numeric | <pre style="margin:0px"><code class="r">1, 10.23</code></pre> |
| integer | <pre style="margin:0px"><code class="r">1L, 10L</code></pre> |
| logical | <pre style="margin:0px"><code class="r">TRUE, FALSE</code></pre> |
| complex | will not be discussed in this class |
| raw | will not be discussed in this class |

<!-- INFOBOX -->
<div id="header">Infobox</div>
<div id="container">
  <div id="first">{{% icon info-solid %}}</div>
  <div id="second">Double quotes <code>"</code> and single quotes <code>'</code> can be used interchangeably (most of time) to define a character string, but double quotes are preferred.</div>
  <div id="clear"></div>
</div>

Most datasets we work with consist of batches of values such as a table of temperature values or a list of survey results. These batches are stored in R in one of several data structures. R has many data structures. These include

* atomic vector
* list
* matrix
* data frame
* factors

We will discuss those as soon as we will be working with them.

<!-- image -->
{{< figure src="/img/courses/dat_sci/02/data_structures.png" caption="Data structures" >}}

At the end of this session we will be dealing with dates. Date values are stored as numbers. But to be properly interpreted as a date object in R, their attribute must be explicitly defined as a date. Attributes are part of the object. These include:

* names
* dimnames
* dim
* class
* attributes (contain metadata)

**Lubridate**
<a href="https://lubridate.tidyverse.org/" target="_blank">
<img src="/img/icons/logo_lubridate.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

R provides many facilities to convert and manipulate dates and times, but a package called lubridate makes working with dates/times much easier.

* Easy and fast parsing of date-times: `ymd()`, `ymd_hms()`, `dmy()`, `dmy_hms`, `mdy()`, …

<pre><code class="r">library(lubridate)
ymd(20101215)
## "2010-12-15"
mdy("4/1/17")
## "2017-04-01"</code></pre>

* Simple functions to get and set components of a date-time, such as `year()`, `month()`, `mday()`, `hour()`, `minute()` and `second()`:

<pre><code class="r">bday <- dmy("14/10/1979")
month(bday)
## 10

year(bday)
## 1979</code></pre>

***

<!-- HEADING with Business-Logo -->
## Business case <i class="fas fa-user-tie"></i> &nbsp;

### Goal & Data

**Goal**</br>
You are a data scientist now. Your job is to study the products, look for opportunities to sell new products, better serve the customer and better market the products. All of that is supposed to be justified by data.

In this session you are about to get your hands into R with a real world situation. The goal is to analyze the sales of bikes sold through bike stores in germany. The bike models correspond to the models of the manufacturer Canyon (in the next session you will see how to gather this data), but the sales and store data are made up.

* Sales by year
* Sales by year and product family

We are going to do that by importing, wrangling and visualizing of the provided data.

**Data**</br>
The bike sales data is divided in multiple datasets for better understanding and organization. When working with transactional data, Entity-relationship diagrams (ERD) are used for describing and defining the data models (see example below). It illustrates the logical structure of the databases (see [ER-diagram-symbols-and-meaning](https://www.lucidchart.com/pages/ER-diagram-symbols-and-meaning) for further information). Please refer to the following data schema when working with the sales data. It shows with which key column we can combine the single databases. Example: To see which items are included in an order, you have to combine `Order Lines` with `Bikes` via the columns `product.id` and `bike.id`.

<!-- ADJUST THIS PART -->
{{< figure src="/img/courses/dat_sci/02/ERD.svg" caption="Data scheme" >}}

The dataset has information of ~15k orders from 2015 to 2019 made from multiple bike stores in germany. Its features allows viewing an order from multiple dimensions: from price to customer location, product attributes and many more. 

The three tables contain the following information (excerpt):

***

**1: Table `bikes`:**

| bike.id | model | model.year | frame.material | weight | price | category | gender | url |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2875 | Aeroad CF SL Disc 8.0 Di2 | 2020 | carbon | 7.60 | 4579 | Road - Race - Aeroad | unisex | https://www.canyon.com/en-de/road-bikes/race-bikes/aeroad/aeroad-cf-sl-disc-8.0-di2/2875.html |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

* `bike.id`: Unique product identifier
* `model`: Product name
* `model.year`: Release date of the bike model
* `frame.material`: Aluminium or carbon
* `weight`: Product weight measured in kilograms.
* `price`: Item price
* `category`: Bike family, bike category and bike ride style (separated by "-")
* `gender`: Unisex or female
* `url`: Link to the product in the online store of Canyon.

***

**2: Table `bikeshops`:**

| bikeshop.id | name | location | lat | lng |
| --- | --- | --- | --- | --- | --- | --- |
| 6 | fahrschneller | Stuttgart, Baden-Württemberg | 48.8 | 9.18 |
| ... | ... | ... | ... | ... | 

* `bikeshop.id`: Seller unique identifier
* `name`: Name of the bikeshop
* `location`: City name and state of the bikeshop (separated by ",")
* `lat`: Latitude
* `lng`: Longitude

***

**3: Table `Order Lines`:**

| ___ | order.id | order.line | order.date | customer.id | product.id | quantity |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 2015-01-07 | 2 | 2681 | 1 |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

* `___`: Rownumber
* `order.id`: Unique identifier of the order.
* `order.line`: Sequential number identifying number of different items included in the same order.
* `order.date`: Shows the purchase timestamp.
* `customer.id`: Key to the bikeshop dataset.
* `product.id`: Key to the bikes dataset
* `quantity`: Quantity of the ordered bikes per order line. 

***

### Analysis with R

#### First steps

You have downloaded the data already in the last session. Let's start by creating a script file. You can download the following template and add it to your folder `01_getting_started`:

<!-- DOWNLOADBOX -->
<div id="header">Download</div>
<div id="container">
  <div id="first">{{% icon download %}}</div>
  <div id="second"><a href="https://github.com/TUHHStartupEngineers/dat_sci_ss20/raw/master/02/sales_analysis.R" target="_blank"><b>sales_analysis.R</b></a></div>
  <div id="clear"></div>
</div>

<!-- INFOBOX -->
<div id="header">Infobox</div>
<div id="container">
  <div id="first">{{% icon info-solid %}}</div>
  <div id="second">You can click the table icon <img src="/img/courses/dat_sci/02/icon_table.png" width=3% style="display:inline-block; margin:0px"> in the upper right corner of the script window to open the outline. You can insert an entry by adding <code>----</code> (four dashes) at the end of a comment.</div>
  <div id="clear"></div>
</div>

As you can see the template has seven sections. In the following we are going to populate them step by step in order to conduct our analysis. 

<!-- INFOBOX -->
<div id="header">Infobox</div>
<div id="container">
  <div id="first">{{% icon info-solid %}}</div>
  <div id="second">Restart your R session any time you begin a new analysis. This starts you with a fresh slate. Go to <code>Session</code> and then click <code>Restart R</code></div>
  <div id="clear"></div>
</div>

##### 1. Libraries
You can just load the `tidyverse` library since it attaches all the packages we will need for this analysis. For the purpose of learning, the single packages, that we need, are listed as well.
<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r"># 1.0 Load libraries ----</br>
library(tidyverse)
#  library(tibble)    --> is a modern re-imagining of the data frame
#  library(readr)     --> provides a fast and friendly way to read rectangular data like csv
#  library(dplyr)     --> provides a grammar of data manipulation
#  library(magrittr)  --> offers a set of operators which make your code more readable (pipe operator)
#  library(tidyr)     --> provides a set of functions that help you get to tidy data
#  library(stringr)   --> provides a cohesive set of functions designed to make working with strings as easy as possible
#  library(ggplot2)   --> graphics</br>
## ── Attaching packages ──────────────────────────────── tidyverse 1.3.0 ──
## ✓ ggplot2 3.3.0     ✓ purrr   0.3.4
## ✓ tibble  3.0.1     ✓ dplyr   0.8.5
## ✓ tidyr   1.0.2     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.5.0
## ── Conflicts ───────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()</br>
# Excel Files
library(readxl)</code></pre>
</section></br>

##### 2. Import
The files are located at `/00_data/01_bike_sales/01_raw_data/`. To read tha data into R we are going to use the `read_excel()` function from the `readxl` package. Take a look at the help site to figure out how to use it. Also think about which data we need for our analysis. You can ignore the default arguments (the arguments which equal already a value) for now. Don't forget to store the data into a named variable.

<!-- CODE (show) -->
<pre><code class="r">?read_excel</code></pre>
<!-- CODE (show) -->

<!-- INFOBOX -->
<div id="header">Infobox</div>
<div id="container">
  <div id="first">{{% icon info-solid %}}</div>
  <div id="second">When working with paths to files, hit the Tab inside quotes " " to auto complete. This helps build the file path</div>
  <div id="clear"></div>
</div>

<!-- CODE (hide) -->
<section class="hide">

We need: 

* orderlines (for years)
* bikes (for price and for the product families)

<pre><code class="r"># 2.0 Importing Files ----
# A good convention is to use the file name and suffix it with tbl for the data structure tibble
bikes_tbl      <- read_excel(path = "00_data/01_bike_sales/01_raw_data/bikes.xlsx")
orderlines_tbl <- read_excel("00_data/01_bike_sales/01_raw_data/orderlines.xlsx")

# Not necessary for this analysis, but for the sake of completeness
bikeshops_tbl  <- read_excel("00_data/01_bike_sales/01_raw_data/bikeshops.xlsx")
</code></pre>

In your environment you should see now 3 loaded tables. You can click on them to take a look at the data.

</section></br>
<!-- CODE (hide) -->

##### 3. Examine
Use different methods to take a look and get a feel for the data.

<!-- CODE (hide) -->
<section class="hide"><pre><code class="r"># 3.0 Examining Data ----
# Method 1: Print it to the console
orderlines_tbl
# A tibble: 15,644 x 7
##    ...1  order.id order.line order.date          customer.id product.id quantity
##    &lt;chr&gt;    &lt;dbl&gt;      &lt;dbl&gt; &lt;dttm&gt;                    &lt;dbl&gt;      &lt;dbl&gt;    &lt;dbl&gt;
##  1 1            1          1 2015-01-07 00:00:00           2       2681        1
##  2 2            1          2 2015-01-07 00:00:00           2       2411        1
##  3 3            2          1 2015-01-10 00:00:00          10       2629        1
##  4 4            2          2 2015-01-10 00:00:00          10       2137        1
##  5 5            3          1 2015-01-10 00:00:00           6       2367        1
##  6 6            3          2 2015-01-10 00:00:00           6       1973        1
##  7 7            3          3 2015-01-10 00:00:00           6       2422        1
##  8 8            3          4 2015-01-10 00:00:00           6       2655        1
##  9 9            3          5 2015-01-10 00:00:00           6       2247        1
## 10 10           4          1 2015-01-11 00:00:00          22       2408        1
## # … with 15,634 more rows</br>
# Method 2: Clicking on the file in the environment tab (or run View(orderlines_tbl)) There you can play around with the filter.</br>
# Method 3: glimpse() function. Especially helpful for wide data (data with many columns)
glimpse(orderlines_tbl)
## Rows: 15,644
## Columns: 7
## $ ...1        &lt;chr&gt; "1", "2", "3", "4", "5", "6", "7", "8", "…
## $ order.id    &lt;dbl&gt; 1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 5, 5, 5, 5,…
## $ order.line  &lt;dbl&gt; 1, 2, 1, 2, 1, 2, 3, 4, 5, 1, 1, 2, 3, 4,…
## $ order.date  &lt;dttm&gt; 2015-01-07, 2015-01-07, 2015-01-10, 2015…
## $ customer.id &lt;dbl&gt; 2, 2, 10, 10, 6, 6, 6, 6, 6, 22, 8, 8, 8,…
## $ product.id  &lt;dbl&gt; 2681, 2411, 2629, 2137, 2367, 1973, 2422,…
## $ quantity    &lt;dbl&gt; 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1,…</code></pre>
</section></br>

***

#### Data manipulation

##### 4. Joining data
Take a look at `?left_join()`. Start by merging order_items and products and then chain all joins together.

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r"># by automatically detecting a common column, if any ...
left_join(orderlines_tbl, bikes_tbl)
## Error: `by` must be supplied when `x` and `y` have no common variables.</br>
# If the data has no common column name, you can provide each column name in the "by" argument. For example, by = c("a" = "b") will match x.a to y.b. The order of the columns has to match the order of the tibbles).
left_join(orderlines_tbl, bikes_tbl, by = c("product.id" = "bike.id"))
## # A tibble: 15,644 x 15
##    ...1  order.id order.line order.date          customer.id
##    &lt;chr&gt;    &lt;dbl&gt;      &lt;dbl&gt; &lt;dttm&gt;                    &lt;dbl&gt;
##  1 1            1          1 2015-01-07 00:00:00           2
##  2 2            1          2 2015-01-07 00:00:00           2
##  3 3            2          1 2015-01-10 00:00:00          10
##  4 4            2          2 2015-01-10 00:00:00          10
##  5 5            3          1 2015-01-10 00:00:00           6
##  6 6            3          2 2015-01-10 00:00:00           6
##  7 7            3          3 2015-01-10 00:00:00           6
##  8 8            3          4 2015-01-10 00:00:00           6
##  9 9            3          5 2015-01-10 00:00:00           6
## 10 10           4          1 2015-01-11 00:00:00          22
## # … with 15,634 more rows, and 10 more variables:
## #   product.id &lt;dbl&gt;, quantity &lt;dbl&gt;, model &lt;chr&gt;,
## #   model.year &lt;dbl&gt;, frame.material &lt;chr&gt;, weight &lt;dbl&gt;,
## #   price &lt;dbl&gt;, category &lt;chr&gt;, gender &lt;chr&gt;, url &lt;chr&gt;</br>
# Chaining commands with the pipe and assigning it to order_items_joined_tbl
bike_orderlines_joined_tbl <- orderlines_tbl %>%
        left_join(bikes_tbl, by = c("product.id" = "bike.id")) %>%
        left_join(bikeshops_tbl, by = c("customer.id" = "bikeshop.id"))</br>
# Examine the results with glimpse()
bike_orderlines_joined_tbl %>% glimpse()
## Rows: 15,644
## Columns: 19
## $ ...1           &lt;chr&gt; "1", "2", "3", "4", "5", "6", "7", …
## $ order.id       &lt;dbl&gt; 1, 1, 2, 2, 3, 3, 3, 3, 3, 4, 5, 5,…
## $ order.line     &lt;dbl&gt; 1, 2, 1, 2, 1, 2, 3, 4, 5, 1, 1, 2,…
## $ order.date     &lt;dttm&gt; 2015-01-07, 2015-01-07, 2015-01-10…
## $ customer.id    &lt;dbl&gt; 2, 2, 10, 10, 6, 6, 6, 6, 6, 22, 8,…
## $ product.id     &lt;dbl&gt; 2681, 2411, 2629, 2137, 2367, 1973,…
## $ quantity       &lt;dbl&gt; 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2,…
## $ model          &lt;chr&gt; "Spectral CF 7 WMN", "Ultimate CF S…
## $ model.year     &lt;dbl&gt; 2021, 2020, 2021, 2019, 2020, 2020,…
## $ frame.material &lt;chr&gt; "carbon", "carbon", "carbon", "carb…
## $ weight         &lt;dbl&gt; 13.80, 7.44, 14.06, 8.80, 11.50, 8.…
## $ price          &lt;dbl&gt; 3119, 5359, 2729, 1749, 1219, 1359,…
## $ category       &lt;chr&gt; "Mountain - Trail - Spectral", "Roa…
## $ gender         &lt;chr&gt; "female", "unisex", "unisex", "unis…
## $ url            &lt;chr&gt; "https://www.canyon.com/en-de/mount…
## $ name           &lt;chr&gt; "AlexandeRad", "AlexandeRad", "WITT…
## $ location       &lt;chr&gt; "Hamburg, Hamburg", "Hamburg, Hambu…
## $ lat            &lt;dbl&gt; 53.57532, 53.57532, 53.07379, 53.07…
## $ lng            &lt;dbl&gt; 10.015340, 10.015340, 8.826754, 8.8…</code></pre>

You should have a new variable called `bike_orderlines_joined_tbl` stored in your Global Environment.
</section></br>

##### 5. Wrangling data
Data manipulation & Cleaning. Usually a data scientist will spend most of his/her time at this section. These are the issues we are facing for our analysis:

* Take a look at the column `category` (e.g. by running `bike_orderlines_joined_tbl$category`). Those entries seem to have three categories separated by a `-`. For example there are Mountain - Trail - Spectral and Mountain - Trail - Neuron. You can print all unique entries, that start with `Mountain` with the following code chunk:

<pre><code class="r">bike_orderlines_joined_tbl %>% 
  select(category) %>%
  filter(str_detect(category, "^Mountain")) %>% 
  unique()
## # A tibble: 10 x 1
##    category                         
##    &lt;chr&gt;                            
##  1 Mountain - Trail - Spectral      
##  2 Mountain - Trail - Neuron        
##  3 Mountain - Dirt Jump - Stitched  
##  4 Mountain - Enduro - Torque       
##  5 Mountain - Trail - Grand Canyon  
##  6 Mountain - Cross-Country - Lux   
##  7 Mountain - Enduro - Strive       
##  8 Mountain - Downhill - Sender     
##  9 Mountain - Fat Bikes - Dude      
## 10 Mountain - Cross-Country - Exceed</code></pre>

We want to analyze the total sales by product family (= 1st category). To do it, we have to separate the column category in category.1, category.2 and category.3 and add the total price (sales price * quantity) to the data.

To fix those issues we are going to do a series of `dplyr` operations on the object `bike_orderlines_joined_tbl`:

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r"># 5.0 Wrangling Data ----
# All actions are chained with the pipe already. You can perform each step separately and use glimpse() or View() to validate your code. Store the result in a variable at the end of the steps.
bike_orderlines_wrangled_tbl <- bike_orderlines_joined_tbl %>%
  # 5.1 Separate category name
  separate(col    = category,
           into   = c("category.1", "category.2", "category.3"),
           sep    = " - ") %>%</br>
  # 5.2 Add the total price (price * quantity) 
  # Add a column to a tibble that uses a formula-style calculation of other columns
  mutate(total.price = price * quantity) %>%</br>
  # 5.3 Optional: Reorganize. Using select to grab or remove unnecessary columns
  # 5.3.1 by exact column name
  select(-...1, -gender) %>%</br>
  # 5.3.2 by a pattern
  # You can use the select_helpers to define patterns. 
  # Type ?ends_with and click on Select helpers in the documentation
  select(-ends_with(".id")) %>%</br>
  # 5.3.3 Actually we need the column "order.id". Let's bind it back to the data
  bind_cols(bike_orderlines_joined_tbl %>% select(order.id)) %>% </br>
  # 5.3.4 You can reorder the data by selecting the columns in your desired order.
  # You can use select_helpers like contains() or everything()
  select(order.id, contains("order"), contains("model"), contains("category"),
         price, quantity, total.price,
         everything()) %>%</br>
  # 5.4 Rename columns because we actually wanted underscores instead of the dots
  # (one at the time vs. multiple at once)
  rename(bikeshop = name) %>%
  set_names(names(.) %>% str_replace_all("\\.", "_"))</pre></code class="r">

Explanation of the last step:</br>
<ul>
<li><code>names()</code> returns all of the column names of a tibble as a character vector.</li> 
<li>The dot <code>.</code> is used in dplyr pipes <code>%>%</code> to supply the incoming data in another part of the function. The dot enables passing the incoming tibble to multiple spots in the function.</li>
<li><code>str_replace_all()</code> takes a "pattern" argument to find a pattern using Regular Expressions (RegEx) and a "replacement" argument to replace the pattern. Regex is used in programming to match strings. The period <code>.</code> is a special character.  It needs to be "escaped" using <code>"\\."</code>. We will use RegEx again in the next session.</li>
</ul>
</section>
<!-- CODE (hide) -->

***

#### Insights & Saving

##### 6. Business Insights

Now that we got the data in a good format, we can start to create business insights for that. We are going to do two analyses. The first is Sales by year and the second is sales by category. This will be a 2 step process for each analysis: Step 1: Manipulate / prepare the data and Step 2: Visualize it (this is one of the most important skills a data scientist needs to know).

**Sales by year: Step 1**

In the first step we need to do the following:

* Select the columns we need
* Extract the years from the date (we will use the lubridate library)
* Group the data by years and summarize the sales

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r"># 6.0 Business Insights ----
# 6.1 Sales by Year ----</br>
library(lubridate)
# Step 1 - Manipulate
sales_by_year_tbl <- bike_orderlines_wrangled_tbl %>%</br> 
  # Select columns
  select(order_date, total_price) %>%</br>
  # Add year column
  mutate(year = year(order_date)) %>%</br> 
  # Grouping by year and summarizing sales
  group_by(year) %>% 
  summarize(sales = sum(total_price)) %>%</br> 
  # Optional: Add a column that turns the numbers into a currency format 
  # (makes it in the plot optically more appealing)
  # mutate(sales_text = scales::dollar(sales)) <- Works for dollar values
  mutate(sales_text = scales::dollar(sales, big.mark = ".", 
                                     decimal.mark = ",", 
                                     prefix = "", 
                                     suffix = " €"))</br>
sales_by_year_tbl
## # A tibble: 5 x 3
##    year    sales sales_text  
##   &lt;dbl&gt;    &lt;dbl&gt; &lt;chr&gt;       
## 1  2015  9930282 9.930.282 € 
## 2  2016 10730507 10.730.507 €
## 3  2017 14510291 14.510.291 €
## 4  2018 12241853 12.241.853 €
## 5  2019 15017875 15.017.875 €</pre></code>
</section>

**Sales by year: Step 2**

Now that we got the data in a good format, we can visualize it with `ggplot2`. A bar plot is well suited for this case. This section will give you just some exposure to visualization. Session 5 will be completely dedicated to this topic.

* Create a canvas
* Select plotting style (bar plot in this case)
* Format the plot

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r"># 6.1 Sales by Year ----</br>
  # Step 2 - Visualize
  sales_by_year_tbl %>%</br>  
  # Setup canvas with the columns year (x-axis) and sales (y-axis)
  ggplot(aes(x = year, y = sales)) +</br>  
  # Geometries
  geom_col(fill = "#2DC6D6") + # Use geom_col for a bar plot
  geom_label(aes(label = sales_text)) + # Adding labels to the bars
  geom_smooth(method = "lm", se = FALSE) + # Adding a trendline</br>
  # Formatting
  # scale_y_continuous(labels = scales::dollar) + # Change the y-axis. 
  # Again, we have to adjust it for euro values
  scale_y_continuous(labels = scales::dollar_format(big.mark = ".", 
                                                    decimal.mark = ",", 
                                                    prefix = "", 
                                                    suffix = " €")) +
  labs(
    title    = "Revenue by year",
    subtitle = "Upward Trend",
    x = "", # Override defaults for x and y
    y = "Revenue"
  )</pre></code>
<!-- CODE (hide) -->
  
{{< figure src="/img/courses/dat_sci/02/revenue_by_year.png" caption="Revenue by year" >}}
  
</section>


Revenue by years was a first great vizualisation. But often times, what we want to do is dive into subsets of data. Showing Revenue by year and by category is a good way to extract more details from the existing data.

**Sales by category: Step 1**

* Select columns
* Group by year and category simultaneously

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r"># 6.2 Sales by Year and Category ----
# Step 1 - Manipulate
sales_by_year_cat_1_tbl <- bike_orderlines_wrangled_tbl %>%</br> 
  # Select columns and add a year
  select(order_date, total_price, category_1) %>%
  mutate(year = year(order_date)) %>%</br>
  # Group by and summarize year and main catgegory
  group_by(year, category_1) %>%
  summarise(sales = sum(total_price)) %>%
  ungroup() %>%</br>
  # Format $ Text
  mutate(sales_text = scales::dollar(sales, big.mark = ".", 
                                     decimal.mark = ",", 
                                     prefix = "", 
                                     suffix = " €"))</br>
sales_by_year_cat_1_tbl  
## # A tibble: 25 x 4
##     year category_1      sales sales_text 
##    &lt;dbl&gt; &lt;chr&gt;           &lt;dbl&gt; &lt;chr&gt;      
##  1  2015 E-Bikes       1599048 1.599.048 €
##  2  2015 Gravel         663025 663.025 €  
##  3  2015 Hybrid / City  502512 502.512 €  
##  4  2015 Mountain      3254289 3.254.289 €
##  5  2015 Road          3911408 3.911.408 €
##  6  2016 E-Bikes       1916469 1.916.469 €
##  7  2016 Gravel         768794 768.794 €  
##  8  2016 Hybrid / City  512346 512.346 €  
##  9  2016 Mountain      3288733 3.288.733 €
## 10  2016 Road          4244165 4.244.165 €
## # … with 15 more rows</code></pre>
</section>  


**Sales by category: Step 2**

* Create a canvas
* Select plotting style (combination of a facet wrap and bar plots in this case)

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r"># Step 2 - Visualize
sales_by_year_cat_1_tbl %>%</br>
  # Set up x, y, fill
  ggplot(aes(x = year, y = sales, fill = category_1)) +</br>
  # Geometries
  geom_col() + # Run up to here to get a stacked bar plot</br>
  # Facet
  facet_wrap(~ category_1) +</br>
  # Formatting
  scale_y_continuous(labels = scales::dollar_format(big.mark = ".", 
                                                    decimal.mark = ",", 
                                                    prefix = "", 
                                                    suffix = " €")) +
  labs(
    title = "Revenue by year and main category",
    subtitle = "Each product category has an upward trend",
    fill = "Main category" # Changes the legend name
  )</code></pre>
  
{{< figure src="/img/courses/dat_sci/02/facet_wrap.png" caption="Revenue by year and category" >}}
  
</section>

**Checks at this Point**

* Make sure that you have two plots, one for aggregated sales by year and one for sales by year and category_1
* Save your work

##### 7. Writing files

Excel is great when others may want access to your data that are Excel users. For example, many Busienss Intelligence Analysts use Excel not R. CSV is a good option when others may use different languages such as Python, Java or C++. RDS is a format used exclusively by R to save any R object in it's native format

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r"># 7.0 Writing Files ----</br>
  # 7.1 Excel ----
  install.packages("writexl")
  library("writexl")
  bike_orderlines_wrangled_tbl %>%
    write_xlsx("00_data/01_bike_sales/02_wrangled_data/bike_orderlines.xlsx")</br>
  # 7.2 CSV ----
  bike_orderlines_wrangled_tbl %>% 
    write_csv("00_data/01_bike_sales/02_wrangled_data/bike_orderlines.csv")</br>
  # 7.3 RDS ----
  bike_orderlines_wrangled_tbl %>% 
    write_rds("00_data/01_bike_sales/02_wrangled_data/bike_orderlines.rds")</code></pre>
</section>

<!-- INFOBOX -->
<div id="header">Infobox</div>
<div id="container">
  <div id="first">{{% icon info-solid %}}</div>
  <div id="second">Use RDS when you want to save any object. Not just tabular data. Save models, plots, anything. It's fast and preserves the object structure exactly (unlike Excel & CSV).</div>
  <div id="clear"></div>
</div>

***

### Datacamp
<div id="header">Recommended Datacamp courses</div>
<div id="container">
  <div id="first">{{% icon datacamp %}}</div>
  <div id="second">
    <a href="https://learn.datacamp.com/courses/introduction-to-the-tidyverse" target="_blank"><b>Introduction to the tidyverse</b></a><br></div>  
  <div id="clear"></div>
</div>

***

<!-- HEADING (challenge) -->
## Challenge <i class="fas fa-laptop-code"></i> &nbsp;

Your challenges are pretty similar like the analyses we just did:

1. Analyze the sales by location (state) with a bar plot. Since `state` and `city` are multiple features (variables), they should be split. Which state has the highes revenue? Replace your `bike_orderlines_wrangled_tbl` object with the newly wrangled object (with the columns `state` and `city`).

Hint: Add `+ theme(axis.text.x = element_text(angle = 45, hjust = 1))` to your plotting code to rotate your x-axis labels. Probably you have to resize the viewer pane to show the entire plot. For your website, try different values for `fig.width` and `fig.height` in your markdown document:

````r
```{r plot, fig.width=10, fig.height=7}

sales_by_loc_tbl %>%
  
  ggplot( ... ) +
  ...

```
`````

2. Analyze the sales by location and year (facet_wrap). Because there are 12 states with bike stores, you should get 12 plots.

Insert your scripts and results into your website. It might be easier to move your entire project folder into your website folder.

