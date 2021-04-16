---
title: Data Acquisition
linktitle: Data Acquisition
toc: true
type: docs
date: "2019-05-05T00:00:00+01:00"
draft: false
menu:
  dat_sci_1:
    parent: I. Data Science Fundamentals
    weight: 5

# Prev/next pager order (if `docs_section_pager` enabled in `params.toml`)
weight: 4
---
<!-- Style for the legend: API URL -->
<style>
/* basic positioning */
.legend { list-style: none; font-size: small;}
.legend li { float: left; margin-right: 10px;}
.legend span { border: 1px solid #ccc; float: left; width: 12px; height: 12px; margin: 2px; margin-top: 4px;}
/* your colors */
.legend .first { background-color: white; margin-right: 5px;}
.legend .second { background-color: blue; margin-right: 5px; }
.legend .third { background-color: green; margin-right: 5px;}
.legend .fourth { background-color: red; margin-right: 5px;}
.legend .fifth { background-color: yellow; margin-right: 5px;}
.legend .sixth { background-color: grey; margin-right: 5px;}
</style>

Before you can start to work with your data within your R session, you need to get the data into your R workspace. Data acquisition is the process you use to import data into your R session so that it can be viewed, stored, and analyzed. We have discussed already how to import spreadsheet-like tables saved as csv or Excel files using `read_csv` and `read_excel`. Data and information on the web is growing exponentially. In today’s world, all the data that you need for your own personal projects is already available on the internet – the only thing limiting you from using it is the ability to access it. This session will cover how to connect to databases and how to acquire data from the web.

Why web scrape in the context of Business Analytics?

* The web is full of free & valuable data
* Many companies put their information out there
* Few companies have programs to actively retrieve & analyze competitor data
* Companies that implement programs have a Competitive Advantage

## Theory Input <i class="fab fa-r-project" aria-hidden="true"></i> &nbsp;

### Databases

Connecting to databases is kind of an advanced topic, but it is something which is really important for you to do, because as a business analyst you are going to need to get data out of an Enterprise Resource Planning (ERP) system or customer relationship management (CRM) database quite frequently. Everything you will need is well documented here:

<!-- DOWNLOADBOX -->
<div id="header">Website</div>
<div id="container">
  <div id="first">{{% icon globe %}}</div>
  <div id="second"><a href="https://db.rstudio.com/" target="_blank"><b>db.rstudio.com</b></a></div>
  <div id="clear"></div>
</div>

There are many different kinds of databases out there: MySQL, PostgreSQL, Redshift, etc. In the documentation you will find instructions for each of those. I will only demonstrate an example for SQLite with the *Chinook* database. The Chinook data model represents a digital media store, including tables for artists, albums, media tracks, invoices and customers. The database should be already present in your project folder.

{{< figure src="/img/courses/dat_sci/03/chinook_scheme.png" caption="Chinook database model" >}}

<!-- DOWNLOADBOX -->
<div id="header">Download</div>
<div id="container">
  <div id="first">{{% icon download %}}</div>
  <div id="second"><a href="https://github.com/TUHHStartupEngineers/dat_sci_ss20/raw/master/03/Chinook_Sqlite.sqlite" target="_blank"><b>Chinook_Sqlite.sqlite</b></a></div>
  <div id="clear"></div>
</div>

<a href="https://github.com/r-dbi/RSQLite" target="_blank">
<img src="/img/icons/logo_rsqlite.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

To open up a connection you need the `RSQLite` package and the function `dbConnect()`. This function is used to create a connection object, which is a set of instructions for connecting to a database. It takes a couple of different arguments. The first is `drv` for the driver. In this case we pass the `SQLite()` function, which is a database driver that comes with the package. The second `dbname` is just the path, which points to the database.

<!-- CODE (show) -->
<pre><code class="r">library(RSQLite)
con <- RSQLite::dbConnect(drv    = SQLite(), 
                          dbname = "00_data/02_chinook/Chinook_Sqlite.sqlite")</code></pre>

Once we have that connection, we can use the function `dbListTables()` (from the `DBI` package) to return the names of the tables that are available in the database that you are connected to:

<!-- CODE (show) -->
<pre><code class="r">dbListTables(con)
##  [1] "Album"         "Artist"        "Customer"      "Employee"     
##  [5] "Genre"         "Invoice"       "InvoiceLine"   "MediaType"    
##  [9] "Playlist"      "PlaylistTrack" "Track"</code></pre>

To examine a table from a database, use `tbl()` from the `dplyr` package. Just pass the connection object and the name of the table.

<!-- CODE (show) -->
<pre><code class="r">tbl(con, "Album")
## # Source:   table<Album> [?? x 3]
## # Database: sqlite 3.30.1 [~/Chinook_Sqlite.sqlite]
##    AlbumId Title                                 ArtistId
##      &lt;int&gt; &lt;chr&gt;                                    &lt;int&gt;
##  1       1 For Those About To Rock We Salute You        1
##  2       2 Balls to the Wall                            2
##  3       3 Restless and Wild                            2
##  4       4 Let There Be Rock                            1
##  5       5 Big Ones                                     3
##  6       6 Jagged Little Pill                           4
##  7       7 Facelift                                     5
##  8       8 Warner 25 Anos                               6
##  9       9 Plays Metallica By Four Cellos               7
## 10      10 Audioslave                                   8
## # … with more rows</code></pre>

This is just a connection so far. If we want to pull the data into local memory we have to chain another function called `collect()`:

<pre><code class="r">album_tbl <- tbl(con, "Album") %>% collect()</code></pre>

If you are familiar with SQL, you can send queries like this: `x <- dbGetQuery(con, 'SELECT * FROM Artist')`. 

Once you are done with the data acquisition, disconnect from the database:

<pre><code class="r">dbDisconnect(con)
con
## &lt;SQLiteConnection&gt;
##   DISCONNECTED</code></pre> 

That is pretty much the gist of how you would connect to a database. Now every database is different and you need to have different drivers. But usually the IT department will take care of it.

### API

#### Requests
Up until now all files were stored locally in your system or in your working directory. But there may be a scenario where those files are stored at some remote server. Also the data is no longer present in expected file formats like `txt`, `csv`, `.xslx`. In such cases, the most common format in which data is stored on the Web can be `json`, `xml` or `html`. This is where accessing the web with R comes in picture.

We refer such data as web data and the exposed file path, which is nothing but the url to access the Web data, is referred to as an API (application programming interface). When we want to access and work on web data in R studio we invoke/consume the corresponding API using HTTP clients in R.

Hypertext Transfer Protocol (HTTP) is designed to enable communications between clients and servers. There are many possible HTTP methods used to consume an API. These types of requests correspond to different actions that you want the server to make. Below are the both most commonly used:

* `GET`: is used to request data from a specified resource.
* `POST`: is used to send data to a server to create/update a resource.

APIs offer data scientists a polished way to request clean and curated data from a website. When a website like Facebook sets up an API, they are essentially setting up a computer that waits for data requests. Once this computer receives a data request, it will do its own processing of the data and send it to the computer that requested it.

`swapi`, the Star Wars API, is connecto to a database that contains information about all the ships, planets, and inhabitants of the Star Wars Universe. This is the base URL (API) of `swapi`:

`https://swapi.dev/api/`

***

A GET request is built like this (you can open that url in your browser to see what the API returns):
<p><span style="color:white">GET </span><span style="color:blue">https</span><span style="color:white">://</span><span style="color:green">swapi.dev/</span><span style="color:red">api/</span><span style="color:yellow">people/</span><span style="color:grey">?page=2</span></p>

<ul class="legend">
    <li><span class="first"></span>  operation</li>
    <li><span class="second"></span>  scheme</li>
    <li><span class="third"></span>  host</li>
    <li><span class="fourth"></span>  basePath</li>
    <li><span class="fifth"></span>  path / endpoint</li>
    <li><span class="sixth"></span>  query parameter</li>
</ul></br>

<hr></hr>

From our perspective as the requester, we will need to write code in R that creates the request and tells the computer running the API what we need. That computer will then read our code, process the request, and return nicely-formatted data that can be easily parsed by existing R libraries. We can send data as query parameters to the API based on two types of Urls (depending on the API):

**1. Directory-based url** (separated by `/`). The path looks very similar to our local system file path:

`https://swapi.dev/api/people/1/`

Where `people` is the key of the query parameter and 1 is the value of that key. This API will fetch all data from the people with the id 1 (Luke Skywalker in this case).

**2. Parameter-based url**. The url contains key value pairs saprated by an ampersand `&` (this example has only one key-value pair) and starts with a `?`:

`https://swapi.dev/api/people/?page=3`

Where page is the key and 3 the value. How to query an API will be documented in the corresponding documentation. In response to this request, the API will return an HTTP response that includes a headers and a body. Almost all APIs use JSON (JavaScript Object Notation) for sending and receiving text and numbers in the body. JSON is a standard file format used for storing and transmitting data consisting of attribute–value pairs and array data types. The directory-based get request above will return the following JSON data:

<pre><code class="jsond">{
    "name": "Luke Skywalker", 
    "height": "172", 
    "mass": "77", 
    "hair_color": "blond", 
    "skin_color": "fair", 
    "eye_color": "blue", 
    "birth_year": "19BBY", 
    "gender": "male", 
    "homeworld": "http://swapi.dev/api/planets/1/", 
    "films": [
        "http://swapi.dev/api/films/1/", 
        "http://swapi.dev/api/films/2/", 
        "http://swapi.dev/api/films/3/", 
        "http://swapi.dev/api/films/6/"
    ], 
    "species": [], 
    "vehicles": [
        "http://swapi.dev/api/vehicles/14/", 
        "http://swapi.dev/api/vehicles/30/"
    ], 
    "starships": [
        "http://swapi.dev/api/starships/12/", 
        "http://swapi.dev/api/starships/22/"
    ], 
    "created": "2014-12-09T13:50:51.644000Z", 
    "edited": "2014-12-20T21:17:56.891000Z", 
    "url": "http://swapi.dev/api/people/1/"
}</code></pre>

<a href="https://httr.r-lib.org" target="_blank">
<img src="/img/icons/logo_httr.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

To make a request, first load the package `httr`, then call the `GET()` function with a url. Any API will return an HTTP response that consists of headers and a body. In the header you will find a HTTP status code, that indicates whether a specific HTTP request has been successfully completed. There are many different status codes. The most important ones are:

* `200`: The request has succeeded.
* `403`: The client does not have access rights to the content.
* `404`: Not found. The server can not find the requested resource.

***

<a href="https://glue.tidyverse.org/index.html" target="_blank">
<img src="/img/icons/logo_glue.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

The `glue` package is fantastic for string interpolation. With glue you can concatenate strings and and other R objects. Glue does this by embedding R expressions in curly braces which are then evaluated and inserted into the argument string. Compared to equivalents like `paste()` and `sprintf()` it is easier to write and less time consuming to maintain. 

```r
library(glue)
name <- "Fred"
glue('My name is {name}.')
## My name is Fred.
```

***

<!-- CODE (show) -->
<pre><code class="r">library(httr)
resp <- GET("https://swapi.dev/api/people/1/")

# Wrapped into a function
sw_api <- function(path) {
  url <- modify_url(url = "https://swapi.dev", path = glue("/api{path}"))
  resp <- GET(url)
  stop_for_status(resp) # automatically throws an error if a request did not succeed
}

resp <- sw_api("/people/1")
resp
## Response [https://swapi.dev/api/people/1/]
##   Date: 2020-06-22 11:54
##   Status: 200
##   Content-Type: application/json
##   Size: 637 B</code></pre>

Since the status code is 200, you can take the response returned by the API and turn it into a useful object. Most APIs will return most or all useful information in the response body, which is stored as raw Unicode (exactly the sequence of bytes that the web server sent) in `resp$content`. So in its current state, the data is not usable and needs to be converted. This particular response says that the data takes on a json format (`application/json`). To convert the raw Unicode into a character vector that resembles the JSON format, we can use `rawToChar()`:

<!-- CODE (show) -->
<pre><code class="r">rawToChar(resp$content)
## "{\"name\":\"Luke Skywalker\",\"height\":\"172\",\"mass\":\"77\",
## \"hair_color\":\"blond\",\"skin_color\":\"fair\",\"eye_color\":
## \"blue\",\"birth_year\":\"19BBY\",\"gender\":\"male\",\"homeworld\":
## \"http://swapi.dev/api/planets/1/\",\"films\":
## [\"http://swapi.dev/api/films/1/\",\"http://swapi.dev/api/films/2/\",
## \"http://swapi.dev/api/films/3/\",\"http://swapi.dev/api/films/6/\"],
## \"species\":[],\"vehicles\":[\"http://swapi.dev/api/vehicles/14/\",
## \"http://swapi.dev/api/vehicles/30/\"],\"starships\":
## [\"http://swapi.dev/api/starships/12/\",\"http://swapi.dev/api/
## starships/22/\"],\"created\":\"2014-12-09T13:50:
## 51.644000Z\",\"edited\":\"2014-12-20T21:17:56.891000Z\",\"url\":
## \"http://swapi.dev/api/people/1/\"}"</code></pre>

<a href="https://cran.r-project.org/web/packages/jsonlite/vignettes/json-aaquickstart.html" target="_blank">
<img src="/img/icons/logo_jsonlite.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

While the resulting string looks messy, it’s truly the JSON structure in character format (the quotation marks inside the string are escaped by a `\` to be recognized as those). From a character vector, we can convert it into list data structure using the `fromJSON()` function from the `jsonlite` library. We can use `toJSON()` to convert something back to the original JSON structure.

***

**R Lists**

Lists are R objects which contain elements of different types like numbers, strings, vectors and another list inside it. A List is created using the `list()` function. The list elements can be given names (optional).

<pre><code class="r">data_list <- list(strings= c("string1", "string2"), 
                  numbers = c(1,2,3), 
                  TRUE, 
                  100.23, 
                  tibble(
                      A = c(1,2), 
                      B = c("x", "y")
                    )
                  )</code></pre>

Lists can be accessed in similar fashion to vectors. Integer, logical or character vectors (in case of named lists) can be used for indexing. Indexing with `[` will give us a sublist not the content inside the component. To retrieve the content, we need to use `[[` or `$`.

***

<pre><code class="r">library(jsonlite)
resp %>% 
    .$content %>% 
    rawToChar() %>% 
    fromJSON()
## $name
## "Luke Skywalker"
## 
## $height
## "172"
## ...</code></pre>

Alternatively, the content of a API response can be accessed using the `content()` function from the `httr` package. If you want to accesses the body as a character vector, set the as argument `as` to "text". If you want it to be parsed into a list, set it to "parsed". If you leave it empty, it will automatically try to detect the type and parse it into a list:<br>
`content(resp, as = "text")`<br>
`content(resp, as = "parsed")`<br>
`content(resp)`<br>

The automatical parsing is convenient for interactive usage, but if you’re writing an API wrapper, it’s best to parse the text or raw content yourself and check it is as you expect.

Let's try to query the API from aplhavantage to get the current quote for the stock of Wirecard (Ticker WDI.DE). To do so, take a look at the <a href="https://www.alphavantage.co/documentation/" target="_blank">documentation</a> and go to the section Quote Endpoint and take a look at the Examples. The examples demonstrate how to query information for IBM (symbol=IBM). In order to get the quote for another company, we just have to replace the symbol with another stock ticker (WDI.DE in our case):

<section class="hide">
<pre><code class="r">resp <- GET('https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=WDI.DE')
resp
## Response [https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=WDI.de]
##   Date: 2020-06-22 14:31
##   Status: 200
##   Content-Type: application/json
##   Size: 214 B
## {
##     "Error Message": "the parameter apikey is invalid or missing.</code></pre> 
</section>

***

Many APIs can be called without any authentication (just as if you called them in a web browser). However, others require authentication to perform particular requests or to avoid rate limits and other limitations.They require you to sign up for an API key in order to use the API. The API key is a long string or a combination of username and password that you usually include in the request URL. The documentation will tell you how to include it.

</section class="hide">
<pre><code class="r">token    <- "my_individual_token"
response <- GET(glue("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=WDI.DE&apikey={token}"))
response
## Response [https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=WDI.DE&apikey="my_individual_token"]
##   Date: 2020-06-23 09:04
##   Status: 200
##   Content-Type: application/json
##   Size: 382 B
## {
##     "Global Quote": {
##         "01. symbol": "WDI.DE",
##         "02. open": "14.2500",
##         "03. high": "17.6000",
##         "04. low": "14.2180",
##         "05. price": "16.7080",
##         "06. volume": "7040228",
##         "07. latest trading day": "2020-06-23",
##         "08. previous close": "14.4400",
## ...</code></pre> 
</section>

***

There are several R packages, that are simply wrappers around popular web APIs and free to use: `spotifyr`, `rtweet`, `quandlr`, `Rfacebook`, `googleflights`, `ìnstaR`, `Rlinkedin`, `RedditExtractoR`, and many many more ...

#### Securing Credentials

It is important to avoid publishing code with your credentials in plain text. There are several options to protect your credentials in R: 

* Option 1: Environment variables using the .Renviron file
* Option 2: Encrypt credentials with the keyring package
* Option 3: Prompt for credentials using the RStudio IDE.

**Option 1:** *.Renviron file*

The .Renviron file can be used to store the credentials, which can then be retrieved with `Sys.getenv()`. Here are the steps:

* Create a new file defining the credentials:

<pre><code class="r">userid = "username"
   pwd = "password"</code></pre>
   
* Save it in your home directory with the file name `.Renviron`. If you are asked whether you want to save a file whose name begins with a dot, say YES.
* Note that by default, dot files are usually hidden. However, within RStudio, the file browser will make .Renviron visible and therefore easy to edit in the future.
* Restart R. `.Renviron` is processed only at the start of an R session.
* Retrieve the credentials using Sys.getenv("userid") / Sys.getenv("pwd")

<pre><code class="r">alphavantage_api_url <- "https://www.alphavantage.co/query"
ticker               <- "WDI.DE"
# You can pass all query parameters as a list to the query argument of GET()
GET(alphavantage_api_url, query = list('function' = "GLOBAL_QUOTE",
                                       symbol     = ticker,
                                       apikey     = Sys.getenv('TOKEN'))
    )</code></pre>

**Option 2:** *keyring package*

You can then store a value in the keyring from R with the `key_set()` function. You’ll be asked to enter a “password,” which is actually how you enter the value you want to securely store. By using the password dialog box, you can set the value once interactively and never have to type the value in clear text. You can access the value with the `key_get()` function.

<pre><code class="r">install.packages("keyring")
library(keyring)
keyring::key_set("token")
GET(alphavantage_api_url, query = list('function' = "GLOBAL_QUOTE",
                                       symbol     = ticker,
                                       apikey     = key_get("token"))
    )</code></pre>

**Option 3:** *prompt credentials*

The RStudio IDE’s API can be used to prompt the user to enter the credentials in a popup box that masks what is typed:

<pre><code class="r">install.packages("rstudioapi")
library("rstudioapi")
GET(alphavantage_api_url, query = list('function' = "GLOBAL_QUOTE",
                                       symbol     = ticker,
                                       apikey     = askForPassword("token"))
    )</code></pre>


### Web scraping

Unfortunately, not all websites provide APIs to retrieve their data  in a neat format. Hence, web scraping can come to your rescue. Web scraping is a technique for converting the data present in unstructured format over the web to the structured format which can easily be accessed and used. Any webpage you visit has a particular, expected general structure; there are technologies like `HTML`, `XML` and `JSON` to distribute the content. So, in order to get the data you need, you must effectively navigate through these different technologies. R can help you with that. Before we can start learning how to scrape a web page, we need to understand how a web page itself is structured.

From a user perspective, a web page has text, images and links all organized in a way that is aesthetically pleasing and easy to read. But the web page itself is written in specific coding languages that are then interpreted by our web browsers. When we're web scraping, we’ll need to deal with the actual contents of the web page itself: the code before it’s interpreted by the browser.
The main languages used to build web pages are called Hypertext Markup Language (HTML), Cascasing Style Sheets (CSS) and Javascript. HTML gives a web page its actual structure and content. CSS gives a web page its style and look, including details like fonts and colors. Javascript gives a webpage functionality.

#### HTML

Unlike R, HTML is not a programming language. Instead, it’s called a markup language — it describes the content and structure of a web page. HTML is organized using `tags`, which are surrounded by `<>` symbols. Different tags perform different functions. Together, many tags will form and contain the content of a web page.
The simplest HTML document looks like this:

<pre><code class="html">&lt;html&gt;
  &lt;head&gt;&lt;/head&gt;
&lt;/html&gt;</code></pre>

Although the above is a legitimate HTML document, it has no text or other content. If we were to save that as a `.html` file and open it using a web browser, we would see a blank page.
Notice that the word html is surrounded by `<>` brackets, which indicates that it is a tag. To add some more structure and text to this HTML document, we could add the following:

<pre><code class="html">&lt;html&gt;
&lt;head&gt;
&lt;/head&gt;
&lt;body&gt
  &lt;p&gt;Here's a paragraph of text!&lt;/p&gt;
  &lt;p&gt;Here's a second paragraph of text!&lt;/p&gt;
&lt;/body&gt;
&lt;/html&gt;</code></pre>

Here we’ve added `<head>` and `<body>` tags, which add more structure to the document. The `<p>` tags are what we use in HTML to designate paragraph text. There are many, many tags in HTML, but we won’t be able to cover all of them in this course. If interested, you can check out <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Element" target="_blank">this site</a>. The important takeaway is to know that tags have particular names (html, body, p, etc.) to make them identifiable in an HTML document. Notice that each of the tags are "paired" in a sense that each one is accompanied by another with a similar name. That is to say, the opening `<html>` tag is paired with another tag `</html>` that indicates the beginning and end of the HTML document. The same applies to `<body>` and `<p>`.
This is important to recognize, because it allows tags to be nested within each other. The `<body>` and `<head>` tags are nested within `<html>`, and `<p>` is nested within `<body>`. This nesting gives HTML a “tree-like” structure called Document Object Model (DOM). If a tag has other tags nested within it, we would refer to the containing tag as the parent and each of the tags within it as the “children”. If there is more than one child in a parent, the child tags are collectively referred to as “siblings”. These notions of parent, child and siblings give us an idea of the hierarchy of the tags. Each branch of this tree ends in a node and each node contains objects containing information. This structure allows programmatic access to the tree to change the structure, style or content of a document. We can use this DOM parsing to extract content of a website.

{{< figure src="/img/courses/dat_sci/03/dom.png" width="300" caption="Example of DOM hierarchy in an HTML document" >}}

#### CSS

Whereas HTML provides the content and structure of a web page, CSS provides information about how a web page should be styled. Without CSS, a web page is dreadfully plain. When we say styling, we are referring to a wide, wide range of things. Styling can refer to the color of particular HTML elements or their positioning. Like HTML, the scope of CSS material is so large that we can’t cover every possible concept in the language. If you’re interested, you can learn more here:

<!-- DOWNLOADBOX -->
<div id="header">Website</div>
<div id="container">
  <div id="first">{{% icon globe %}}</div>
  <div id="second"><a href="https://www.w3.org/Style/CSS/Overview.en.html" target="_blank">https://www.w3.org/Style/CSS/Overview.en.html</a></div>
  <div id="clear"></div>
</div>

If you want to practice the use of CSS selectors, this is a good site do do it:

<!-- DOWNLOADBOX -->
<div id="header">Website</div>
<div id="container">
  <div id="first">{{% icon globe %}}</div>
  <div id="second"><a href="http://flukeout.github.io" target="_blank">learn CSS</a></div>
  <div id="clear"></div>
</div>

Two concepts we do need to learn before we delve into the R web scraping code are `classes` and `ids`.

*Classes*

First, let's talk about classes. If we were making a website, there would often be times when we'd want similar elements of a website to look and positioned the same. 

<figure>
<div style="display:flex;">
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/bikes_css_01.png" alt="CAPTION" style="width:100%">
  </div>
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/bikes_css_02.png" alt="CAPTION" style="width:100%">
  </div>
</div>
<figcaption>No classes select (left) and classes for the pictures (right)</figcaption>
<div id="clear"></div>
</figure>
<figure>
<div style="display:flex;">
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/bikes_css_03.png" alt="CAPTION" style="width:100%">
  </div>
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/bikes_css_04.png" alt="CAPTION" style="width:100%">
  </div>
</div>
<figcaption>classes for the product title (left) and classes for the product price (right)</figcaption>
<div id="clear"></div>
</figure>

For example, we might want a number of items in a list to all appear in the same color, red. We could accomplish that by directly inserting some CSS that contains the color information into each line of text's HTML tag, like so:

<pre><code class="html">&lt;p style=”color:red” &gt;Text 1&lt;/p&gt;
&lt;p style=”color:red” &gt;Text 2&lt;/p&gt;
&lt;p style=”color:red” &gt;Text 3&lt;/p&gt;</code></pre>

The style text indicates that we are trying to apply CSS to the `<p>` tags. Inside the quotes, we see a key-value pair `color:red`. `color` refers to the color of the text in the `<p>` tags, while red describes what the color should be. But as we can see above, we’ve repeated this key-value pair multiple times. That's not ideal — if we wanted to change the color of that text, we'd have to change each line one by one. Instead of repeating this style text in all of these `<p>` tags, we can replace it with a class selector:

<pre><code class="html">&lt;p class=”red-text” &gt;Text 1&lt;/p&gt;
&lt;p class=”red-text” &gt;Text 2&lt;/p&gt;
&lt;p class=”red-text” &gt;Text 3&lt;/p&gt;</code></pre>

With the class selector, we can better indicate that these <code>&lt;p&gt;</code> tags are related in some way. In a separate CSS file, we can creat the red-text class and define how it looks by writing:

<pre><code class="css">.red-text {
    color: red;
}</code></pre>

Combining these two elements into a single web page will produce the same effect as the first set of red `<p>` tags, but it allows us to make quick changes more easily. 
In this session, of course, we're interested in web scraping, not building a web page (even though you can use that information to style your github page as well). But when we're web scraping, we'll often need to select a specific class of HTML tags, so we need understand the basics of how CSS classes work. Notice, that nodes can have multiple classes (separated by spaces).

*Ids*

Similarly, we may often want to scrape specific data that's identified using an id. CSS ids are used to give a single element an identifiable name, much like how a class helps define a class of elements.

<pre><code class="html">&lt;p id=”special” &gt;This is a special tag.&lt;/p&gt;</code></pre>

Don’t worry if you don’t quite understand classes and ids yet, it’ll become more clear when we start manipulating the code. You just need to know the following CSS Selector patterns used to select the styled elements.

Besides CSS selectors, you can also use Xpath (a XML path language) for selecting the nodes. Locating elements with XPath works very well with a little bit of more flexibility than CSS selectors.
But most expressions can be directly translated from one to the other and vice versa.

| Goal | CSS | XPath |
| --- | --- | --- |
| All Elements | * | //* |
| All P Elements | p | //p |
| All Child Elements | p > * | //p/* |
| Element By ID | #foo | //*[@id='foo'] |
| Element By Class | .foo | //*[contains(@class,'foo')] |
| Element With Attribute | *[title] | //*[@title] |
| First Child of All P | p > *first-child | //p/*[0] |
| All P with an A child | not possible | //p[a] |
| Next Element | p + * | //p/following-sibling::*[0] |
| Previous Element | not possible | //p/preceding-sibling::*[0] |

#### Selector gadget

A helpful tool to get the CSS Selector / xpath paths is the selectorgadget. It is a script that you can run on every website. You just have to click on the elements you want to select and it tells you the CSS / xpath code you need. Just add the following code to your bookmark bar, then go to any page and launch it.

<pre><code class="js">javascript:(function()%7Bvar%20s=document.createElement('div');s.innerHTML='Loading...';s.style.color='black';s.style.padding='20px';s.style.position='fixed';s.style.zIndex='9999';s.style.fontSize='3.0em';s.style.border='2px%20solid%20black';s.style.right='40px';s.style.top='40px';s.setAttribute('class','selector_gadget_loading');s.style.background='white';document.body.appendChild(s);s=document.createElement('script');s.setAttribute('type','text/javascript');s.setAttribute('src','https://dv0akt2986vzh.cloudfront.net/unstable/lib/selectorgadget.js');document.body.appendChild(s);%7D)();</code></pre>

But keep in mind, that there are infinite ways to select an element and having knowledge about the underlying html code of a website makes it way easier to scrape a website in the long run. To find the CSS class for an element, we need to right-click on that area and select “Inspect” or “Inspect Element” (depending on the browser you are using). The hardest part of scraping is figuring out the xpath or css to indicate which html nodes to select. 

<a href="https://rvest.tidyverse.org/" target="_blank">
<img src="/img/icons/logo_rvest.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

There are several R libraries designed to take HTML and the CSS selectors of the webpage for finding the relevant fields which contain the desired information. The library we’ll use in this tutorial is `rvest`. This package contains the basic web scraping functions, which are quite effective. Using the following functions, we will try to extract the data from web sites:

* `read_html(url)`: scrape entire HTML content from a given URL
* `html_nodes(css = ".class"")`: calls node based on CSS class
* `html_nodes(css = "#id"")`: calls node based on id
* `html_nodes(xpath = "xpath")`: calls node based on the given xpath
* `html_attrs()`: identifies attributes
* `html_text()`: strips the HTML tags and extracts only the text
* `html_table()`: turns HTML tables into data frames

<a href="https://stringr.tidyverse.org/" target="_blank">
<img src="/img/icons/logo_stringr.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

The package `stringr` comes into play when you think of tasks related to data cleaning and preparation. stringr functions are useful because they enable you to work around the individual characters within the strings in character vectors.

* `str_detect(x, pattern)` tells you if there’s any match to the pattern.
* `str_count(x, pattern)` counts the number of patterns.
* `str_subset(x, pattern)` extracts the matching components.
* `str_locate(x, pattern)` gives the position of the match.
* `str_extract(x, pattern)` extracts the text of the match.
* `str_match(x, pattern)` extracts parts of the match defined by parentheses.
* `str_replace(x, pattern, replacement)` / `str_replace_all(x, pattern, replacement)` replaces the matches with new text.#
* `str_split(x, pattern)` splits up a string into multiple pieces.

These pattern matching functions recognize four parts of pattern description. Regular expressions (RegEx) are the standard:

#### RegEx

| Category | <div style="width:120px">RegEx</div> | Explanation | Online example |
| --- | ------------ | -- | --- |
| Anchors | ^The | matches any string that `starts with The` | <a href="https://regex101.com/r/An9bz5/1" target="_blank">Try it!</a> |
| Anchors | end$ | matches any string that `ends with end` | <a href="https://regex101.com/r/tthX5B/1/" target="_blank">Try it!</a> |
| Anchors | ^The end$ | `exact` string match (starts and ends with The end) | --- |
| Quantifiers | abc* | matches a string that has ab followed by `zero or more` c | --- |
| Quantifiers | abc+ | matches a string that has ab followed by `one or more` c | --- |
| Quantifiers | abc? | matches a string that has ab followed by `zero or one` c | --- |
| Quantifiers | abc{n} | matches a string that has ab followed by `exact n` c | --- |
| Quantifiers | abc{n,} | matches a string that has ab followed by `n or more` c | --- |
| Quantifiers | abc{n,m} | matches a string that has ab followed by `n up to m` c | --- |
| Quantifiers | a(bc)* | matches a string that has a followed by `zero or more copies of the sequence` bc | --- |
| Quantifiers | a(bc){n,m} | matches a string that has a followed by `n up to m copies of the sequence` bc | --- |
| OR Operator | a(b\|c) | matches a string that has a followed by `b or c` (and `captures` b or c) | --- |
| OR Operator | a[bc] | same as previous, but `without capturing` b or c | --- |
| Character classes | \d (negated \D) | matches a single character that is a `digit` | --- |
| Character classes | \w (negated \W) or [:space:] | matches a `word` character (alphanumeric character plus underscore) | --- |
| Character classes | \s (negated \S) | matches a `whitespace` character | --- |
| Character classes | . | matches `any character` | --- |
| Bracket expressions | [abc] or [a-c] | matches a string that has either an a or a b or a c | --- |
| Bracket expressions | [a-fA-F0-9] or [:xdigit:] | a string that represents a single hexadecimal digit, case insensitively | --- |
| Bracket expressions | [0-9] or [:digit:] | a string that has a character from 0 to 9 | --- |
| Bracket expressions | [:alpha:] | Alphabetic characters: [:lower:] and [:upper:] | --- |
| Bracket expressions | [:alnum:] | AAlphanumeric characters: [:alpha:] and [:digit:] | --- |
| Bracket expressions | [^a-zA-Z] | a string that has not a letter from a to z or from A to Z. In this case the ^ is used as `negation` of the expression | --- |

In order to be taken literally, you must escape the characters `^.[$()|*+?{\` with a backslash `\` as they have special meaning. Notice that you can match also non-printable characters like tabs `\t`, new-lines `\n`, carriage returns `\r`.

*Greedy and Lazy match*

By default repetition of the quantifiers  (`*`,`+` and `{}`) is greedy, so the maximal possible number of repeats is used. For example, `<.+>` matches `<div>simple div</div>` in `This is a <div> simple div</div> test`. 

In order to catch only the opening div tag we can append a `?` to the quantifier to make it lazy: `<.+?>` will match `<div>` in this example.

*Look-ahead and Look-behind — (?=) and (?<=)*

| Category | <div style="width:120px">RegEx</div> | Explanation | Online example |
| --- | ------------ | -- | --- |
| Look-ahead | d(?=r) | matches a `d` only if is `followed by r, but r will not be part` of the overall regex | <a href="https://regex101.com/r/nv8xSd/1/" target="_blank">Try it!</a> |
| Look-behind | (?<=r)d | matches a `d` only if is `preceded by an r, but r will not be part` of the overall regex match | <a href="https://regex101.com/r/An9bz5/1" target="_blank">Try it!</a> |
| Look-ahead | d(?!r) | matches a d only if is `not followed` by r, but r will not be part of the overall regex match | <a href="https://regex101.com/r/NP6Lou/1/" target="_blank">Try it!</a> |
| Look-behind | (?<!r)d | matches a d only if is `not preceded` by an r, but r will not be part of the overall regex match | <a href="https://regex101.com/r/2VgA2Y/1/" target="_blank">Try it!</a> |

A combination of look-ahead and look-behind is a good way to extract something between two patterns.

***

#### Examples

1st example: Get all companies from the S&P 500 (wikipedia)

* assign the wikipedia URL to a variable
* read in the html from the URL
* Select the correct html nodes and extract the html table

In order to start parsing through a web page, we first need to request that data from the computer server that contains it. In rvest, the function that serves this purpose is the `read_html()` function. It takes in a web URL as an argument and returns a list object that contains the tree-like structure we discussed earlier. 

{{< figure src="/img/courses/dat_sci/03/html_wiki.png" caption="HTML from the wikipedia HTML" >}}

In order to capture the text, we need to use the `html_nodes()` and `html_text()` / `html_table()` functions respectively to search for this `#constituents` id and retrieve the text. Since we’re working with the tidyverse, we can just pipe the steps into the different functions. The code below does this:

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r"># get the URL for the wikipedia page with all S&P 500 symbols
url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
# use that URL to scrape the S&P 500 table using rvest
library(rvest)
sp_500 <- url %>%
          # read the HTML from the webpage
          read_html() %>%
          # Get the nodes with the id
          html_nodes(css = "#constituents") %>%
          # html_nodes(xpath = "//*[@id='constituents']"") %>% 
          # Extract the table and turn the list into a tibble
          html_table() %>% 
          .[[1]] %>% 
          as_tibble()</code></pre>
</section>

***
          
These functions together form the bulk of many common web scraping tasks. In general, web scraping in R (or in any other language) boils down to the following three steps:   

* Get the HTML for the web page that you want to scrape
* Decide what part of the page you want to read and find out what HTML/CSS you need to select it
* Select the HTML and analyze it in the way you need

***

2nd example: Get the 250 top rated movies from IMDB

<pre><code class="r">url  <- "https://www.imdb.com/chart/top/?ref_=nv_mv_250"
html <- url %>% 
          read_html()</code></pre>
          
{{< figure src="/img/courses/dat_sci/03/html_imdb_01.png" caption="class for title, rank, title, year and persons" >}}          

Get the ranks:

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">rank <-  html %>% 
            html_nodes(css = ".titleColumn") %>% 
            html_text() %>% 
            # Extrag all digits between " " and ".\n" The "\" have to be escaped
            # You can use Look ahead "<=" and Look behind "?=" for this
            stringr::str_extract("(?<= )[0-9]*(?=\\.\\n)")%>% 
            # Make all values numeric
            as.numeric()</code></pre>
</section>

***

Get the title: The title is in the child node with an a tag:

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">title <- html %>% 
            html_nodes(".titleColumn > a") %>% 
            html_text()</code></pre>
</section>

***

Get the year: The year has the classes .titleColumn AND .secondaryInfo. Separate those by a space.

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">year <- html %>% 
          html_nodes(".titleColumn .secondaryInfo") %>%
          html_text() %>% 
          # Extract numbers
          stringr::str_extract(pattern = "[0-9]+") %>% 
          as.numeric()</code></pre>
</section>

***

Get the people: The people are in the attribute `title`

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">people <- html %>% 
            html_nodes(".titleColumn > a") %>% 
            html_attr("title")</code></pre>
</section>
            
{{< figure src="/img/courses/dat_sci/03/html_imdb_02.png" caption="class for the ratings" >}}            

Get the ratings:

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">rating <- html %>% 
            html_nodes(css = ".imdbRating > strong") %>% 
            html_text() %>% 
            as.numeric()</code></pre>
</section>

***

... and the number of ratings:

<!-- CODE (hide) -->
<section class="hide">
<pre><code class="r">num_ratings <- html %>% 
              html_nodes(css = ".imdbRating > strong") %>% 
              html_attr('title') %>% 
              # Extract the numbers and remove the comma to make it numeric values
              stringr::str_extract("(?<=based on ).*(?=\ user ratings)" ) %>% 
              stringr::str_replace_all(pattern = ",", replacement = "") %>% 
              as.numeric()</code></pre>
</section>

***

Merge everything into a tibble:

<pre><code class="r">imdb_tbl <- tibble(rank, title, year, people, rating, num_ratings)</code></pre>

As a side note, if you run the code from a country where English is not the main language, it’s very likely that you’ll get some of the movie names translated into the main language of that country.
Most likely, this happens because the server infers your location from your IP address. 
If you run into this issue, retrieve the html content with the `GET()` function from the `httr` package and pass the following values to the headers parameter:

<pre><code class="r">resp <- GET(url = "https://www.imdb.com/chart/top/?ref_=nv_mv_250",  
            add_headers('Accept-Language' = "en-US, en;q=0.5")) 
html <- content(resp)</code></pre>

This will communicate the server something like “I want the linguistic content in American English (en-US). If en-US is not available, then other types of English (en) would be fine too (but not as much as en-US)”. The q parameter indicates the degree to which we prefer a certain language (in this case we will accept other English languages if its translation quality is > 50 %). If not specified, then the values is set to 1 by default, like in the case of en-US. You can read more about this <a href="https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4" target="_blank">here</a>.


#### Functional programming

If we scrape more than one page, we usually have to iterate over the content. Iterating refers to programmatically repeating a step or sets of steps, a set number of times or until a condition is met.
Typically, when we iterate in any programming language, we use a loop, typically a `for loop`:

<pre><code class="r">for (variable in vector) {
    
}
# Example: For Loop
numbers <- c(1:5)
for (i in numbers) {
   print(i)
}
## 1
## 2
## 3
## 4
## 5</code></pre>


<a href="https://purrr.tidyverse.org" target="_blank">
<img src="/img/icons/logo_purrr.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

Almost every iteration can be done with a for loop, but using the `purrr` package is a better idea. Loops in R are slow and hard to read. The purrr package provides a suite of functions for iteration and functional programming that integrate well with the rest of the tidyverse. The core function in purrr is `map()`, that serves to apply a function to all elements of an object. The base R function of `map()` is `lapply()` (and its variants `sapply()`, `vapply()`, ...), which does almost the same. But if we work in the tidyverse, `map()` is rather useful.

The above `for loop` would be written like this:

<pre><code class="r"># purr functional programming approach
numbers_list <- map(numbers, print)
## 1
## 2
## 3
## 4
## 5</code></pre>

A few things to note:

* both the for loop and map function do an operation for each element in the vector
* the map function returns a nested list where each entry is the result of the function called inside of it for one of the entries in the object that being iterated over. Assign this to a variable to avoid it from printing.
* Using purrr’s map function is only one line and less code
* Using purrr’s map function is easier to read

Another useful function from the `purrr` package is `pluck()`. It makes it easy to extract certain elements from lists, which is particularly helpful, if we want to extract data from json files.

Let's take a look at the following json file (you will see in the business case where it comes from). Download it to your computer and read it into R with the `jsonlite` package.

<!-- DOWNLOADBOX -->
<div id="header">Download</div>
<div id="container">
  <div id="first">{{% icon download %}}</div>
  <div id="second"><a href="https://raw.githubusercontent.com/TUHHStartupEngineers/dat_sci_ss20/master/03/bike_data.json" target="_blank"><b>bike_data.json</b></a></div>
  <div id="clear"></div>
</div>


<pre><code class="r">bike_data_lst <- fromJSON("bike_data.json")
# Open the data by clicking on it in the environment or by running View()
View(bike_data_lst)</code></pre>

There we can navigate through the list by clicking on the blue arrows. This json contains data about bikes listed on a website. Let's try to find the different color variations of the bike.
This is the path:

<section class="hide">
<pre><code class="r">productDetail --> variationAttributes --> values --> [[1]] --> displayValue</code></pre>
</section>

If we go to the right side of the viewer, a button appears. Clicking it will send the code to the console, that extract exactly those values.

<pre><code class="r">bike_data_lst[["productDetail"]][["variationAttributes"]][["values"]][[1]][["displayValue"]]
## "Stealth"     "aero silver"</code></pre>

`pluck()` does exactly the same, but looks rather neat. You just have to separate the path by commas:

<pre><code class="r">bike_data_lst %>%
  purrr::pluck("productDetail", "variationAttributes", "values", 1, "displayValue")
## "Stealth"     "aero silver"</code></pre>

<!-- HEADING with Business-Logo -->
## Business Case <i class="fas fa-user-tie"></i> &nbsp;
### Goal

There are many use cases: Contact Scraping, Monitoring/Comparing Prices, Scraping Reviews/Ratings etc.

In this case you learn how to web-scrape all bike models from the bike manufacturer Canyon to put into a strategic database with competitor product data. The individual product pages have a ton of valuable information. Hence, we have to find a way to get all individual product URLs to scrape the content for our strategic database.

The following steps describe how you get the bike data, which you have already used in the last session.

The starting point is the analysis of the URL, website and product structure of your competitor. The URL consists of a base path and several page paths:

* URL Base path / Landing page / Home
  + https://www.canyon.com/en-de/

<figure>
<div style="display:flex;">
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/URL_01_base.png" alt="CAPTION" style="width:100%">
  </div>
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/URL_02_product_main.png" alt="CAPTION" style="width:100%">
  </div>
</div>
<figcaption>Home (left) and product family (right)</figcaption>
<div id="clear"></div>
</figure>

<figure>
<div style="display:flex;">
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/URL_03_product_sub.png" alt="CAPTION" style="width:100%">
  </div>
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/URL_04_query_params.png" alt="CAPTION" style="width:100%">
  </div>
</div>
<figcaption>Product category (left) and product including query parameters for color and size</figcaption>
<div id="clear"></div>
</figure>

The products are divided into families and categories:

* URL Page path for the product families:
  + https://www.canyon.com/en-de/road-bikes/

* URL Page path for the product categories (the ride styles, endurance-bikes in this example, don't matter to us):
  + https://www.canyon.com/en-de/road-bikes/endurance-bikes/endurace/
  
Each bike can come in different color variations (indicated by `?dwvar_2399_pv_rahmenfarbe=BK` in this example)

* URL query parameters (initialized by the question mark `?`)
  + https://www.canyon.com/en-de/road-bikes/endurance-bikes/endurace/endurace-cf-slx-disc-9.0-etap/2399.html?dwvar_2399_pv_rahmenfarbe=BK&dwvar_2399_pv_rahmengroesse=M&quantity=1
  
Our goal is to get data for every bike in every available color scheme. We can do that, if we are able to construct the product URLs for each individual bike / color combination.

***

### Analysis with R

First, we have to load the relevant libraries.

<section class="hide">
<pre><code class="r"># WEBSCRAPING ----</br>
# 1.0 LIBRARIES ----</br>
library(tidyverse) # Main Package - Loads dplyr, purrr, etc.
library(rvest)     # HTML Hacking & Web Scraping
library(xopen)     # Quickly opening URLs
library(jsonlite)  # converts JSON files to R objects
library(glue)      # concatenate strings
library(stringi)   # character string/text processing</code></pre>
</section></br>

***

#### Page analysis

Analyze the page to make a plan for our web scraping approach (there is no unique way. Possibly there are hundreds of ways to get that data.)

* Where are the individual bikes listed, so that we can scrape their URLs? --> On the product category sites:

{{< figure src="/img/courses/dat_sci/03/canyon_category.png" caption="Product category site" >}}

* Where can we find all product category sites? --> If we hover over a product family, always in the second column of the menu bar:

{{< figure src="/img/courses/dat_sci/03/html_canyon_01.png" caption="Classes for the product categories" >}}

* Where do we find all available product families? --> In the first column:

{{< figure src="/img/courses/dat_sci/03/html_canyon_00.png" caption="Ids for the product families" >}}

#### Scraping

Get the available color IDs for each individual bike.

***
**Step 1:** Get URLs for each of the product categories

* 1.1: Get the bike product family IDs (doing that manually would have been faster. This is just for the purpuse of demonstration). 

<section class="hide">
<pre><code class="r"># 1.1 COLLECT PRODUCT FAMILIES ----</br>
url_home          <- "https://www.canyon.com/en-de"
xopen(url_home) # Open links directly from RStudio to inspect them</br>
# Read in the HTML for the entire webpage
html_home         <- read_html(url_home)</br>
# Web scrape the ids for the families
bike_family_tbl <- html_home %>%</br>
                 # Get the nodes for the families ...
                 html_nodes(css = ".js-navigationDrawer__list--secondary") %>%
                 # ...and extract the information of the id attribute
                 html_attr('id') %>%</br>
                 # Remove the product families Gear and Outlet and Woman 
                 # (because the female bikes are also listed with the others)
                 discard(.p = ~stringr::str_detect(.x,"WMN|WOMEN|GEAR|OUTLET")) %>%</br>
                 # Convert vector to tibble
                 enframe(name = "position", value = "family_class") %>%</br>
                 # Add a hashtag so we can get nodes of the categories by id (#)
                 mutate(
                     family_id = str_glue("#{family_class}")
                 )</br>
bike_family_tbl
## # A tibble: 5 x 3
##   position family_class                  family_id                     
##      <int> <chr>                         <glue>                        
##         1 js-navigationList-ROAD        #js-navigationList-ROAD       
##         2 js-navigationList-MOUNTAIN    #js-navigationList-MOUNTAIN   
##         3 js-navigationList-EBIKES      #js-navigationList-EBIKES     
##         4 js-navigationList-HYBRID-CITY #js-navigationList-HYBRID-CITY
##         5 js-navigationList-YOUNGHEROES #js-navigationList-YOUNGHEROES<br>
# The updated page has now also ids for CFR and GRAVEL. You can either include or remove them.</code></pre>
</section>

</br>

* Step 1.2: Get bike product category urls

<section class="hide">
<pre><code class="r"># 1.2 COLLECT PRODUCT CATEGORIES ----</br>
# Combine all Ids to one string so that we will get all nodes at once
# (seperated by the OR operator ",")
family_id_css <- bike_family_tbl %>%
                    pull(family_id) %>%
                    stringr::str_c(collapse = ", ")
family_id_css
## "#js-navigationList-ROAD, #js-navigationList-MOUNTAIN, #js-navigationList-EBIKES, #js-navigationList-HYBRID-CITY, #js-navigationList-YOUNGHEROES"</br>
# Extract the urls from the href attribute
bike_category_tbl <- html_home %>%</br>
           # Select nodes by the ids
           html_nodes(css = family_id_css) %>%</br>
           # Going further down the tree and select nodes by class
           # Selecting two classes makes it specific enough
           html_nodes(css = ".navigationListSecondary__listItem .js-ridestyles") %>%
           html_attr('href') %>%</br>
           # Convert vector to tibble
           enframe(name = "position", value = "subdirectory") %>%</br>
           # Add the domain, because we will get only the subdirectories
           mutate(
              url = glue("https://www.canyon.com{subdirectory}")
           ) %>%</br>
           # Some categories are listed multiple times.
           # We only need unique values
           distinct(url)</br>
bike_category_tbl
## # A tibble: 25 x 1
##    url                                                                    
##    <glue>                                                                 
##  1 https://www.canyon.com/en-de/road-bikes/race-bikes/aeroad/             
##  2 https://www.canyon.com/en-de/road-bikes/endurance-bikes/endurace/      
##  3 https://www.canyon.com/en-de/e-bikes/e-road-bikes/endurace-on/         
##  4 https://www.canyon.com/en-de/road-bikes/gravel-bikes/grail/            
##  5 https://www.canyon.com/en-de/road-bikes/cyclocross-bikes/inflite/      
##  6 https://www.canyon.com/en-de/road-bikes/triathlon-bikes/speedmax/      
##  7 https://www.canyon.com/en-de/road-bikes/race-bikes/ultimate/           
##  8 https://www.canyon.com/en-de/mountain-bikes/fat-bikes/dude/            
##  9 https://www.canyon.com/en-de/mountain-bikes/cross-country-bikes/exceed/
## 10 https://www.canyon.com/en-de/mountain-bikes/trail-bikes/grand-canyon/  
## # … with 15 more rows</code></pre>
</section>

***

**Step 2:** Get URL for each individual bike of each product category. You might have to scroll down a bit (depending on the category).

{{< figure src="/img/courses/dat_sci/03/html_canyon_02.png" caption="classes for the individual bike urls" >}}

* Step 2.1.1: Do it for a single bike

<section class="hide">
<pre><code class="r"># 2.0 COLLECT BIKE DATA ----</br>
# 2.1 Get URL for each bike of the Product categories</br>
# select first bike category url
bike_category_url <- bike_category_tbl$url[1]</br>
# Alternatives for selecting values
# bike_category_url <- bike_category_tbl %$% url %>% .[1]
# bike_category_url <- bike_category_tbl %>% pull(url) %>% .[1]
# bike_category_url <- deframe(bike_category_tbl[1,])
# bike_category_url <- bike_category_tbl %>% first %>% first</br>
xopen(bike_category_url)</br>
# Get the URLs for the bikes of the first category
html_bike_category  <- read_html(bike_category_url)
bike_url_tbl        <- html_bike_category %>%</br>
                # Get the 'a' nodes, which are hierarchally underneath 
                # the class productTile__contentWrapper
                html_nodes(css = ".productTile__contentWrapper > a") %>%
                html_attr("href") %>%</br>
                # Remove the query parameters of the URL (everything after the '?')
                str_remove(pattern = "\\?.*") %>%</br>
                # Convert vector to tibble
                enframe(name = "position", value = "url")</br>
# 2.1.2 Extract the descriptions (since we have retrieved the data already)
bike_desc_tbl <- html_bike_category %>%</br>
   # Get the nodes in the meta tag where the attribute itemprop equals description
   html_nodes('.productTile__productSummaryLeft > meta[itemprop="description"]') %>%</br>
   # Extract the content of the attribute content
   html_attr("content") %>%</br>
   # Convert vector to tibble
   enframe(name = "position", value = "description")</code></pre>
</section>

</br>

There is often data in JSON format listed with a lot of interesting data. Let's scrape that too.

{{< figure src="/img/courses/dat_sci/03/html_canyon_03.png" caption="JSON data of the bikes" >}}

<section class="hide">
<pre><code class="r"># 2.1.3 Get even more data from JSON files
bike_json_tbl  <- html_bike_category %>%</br>
           html_nodes(css = '.productGrid__listItem.xlt-producttile > div') %>%
           html_attr("data-gtm-impression") %>%</br>
           # Convert the JSON format to dataframe
           # map runs that function on each element of the list
           map(fromJSON) %>% # need JSON ### need lists</br>
           # Extract relevant information of the nested list
           map(purrr::pluck, 2, "impressions") %>% # Need purrr and expl above</br>
           # Set "not defined" and emtpy fields to NA (will be easier to work with)
           map(na_if, "not defined") %>%
           map(na_if, "") %>%</br>
           # The class of dimension56 and price varies between numeric and char.
           # This converts this column in each list to numeric
           # across allows to perform the same operation on multiple columns
           map(~mutate(., across(c("dimension56","price"), as.numeric))) %>%</br>
           # Stack all lists together
           bind_rows() %>%
           # Convert to tibble so that we have the same data format
           as_tibble() %>%</br>
           # Add consecutive numbers so that we can bind all data together
           # You could have also just use bind_cols()
           rowid_to_column(var='position') %>%
           left_join(bike_desc_tbl) %>%
           left_join(bike_url_tbl)</code></pre>
</section>

</br>

* Step 2.2: Make a function to get the bike data for every bike of each category (just wrap the above code into the `function()` function)

<section class="hide">
<pre><code class="r"># 2.2 Wrap it into a function ----
get_bike_data <- function(url) {</br>
  html_bike_category <- read_html(url)</br>
  # Get the URLs
  bike_url_tbl  <- html_bike_category %>%
    html_nodes(css = ".productTile__contentWrapper > a") %>%
    html_attr("href") %>%
    str_remove(pattern = "\\?.*") %>%
    enframe(name = "position", value = "url")</br>
  # Get the descriptions
  bike_desc_tbl <- html_bike_category %>%
    html_nodes(css = '.productTile__productSummaryLeft > 
                      meta[itemprop="description"]') %>%
    html_attr("content") %>%
    enframe(name = "position", value = "description")</br>
  # Get JSON data
  bike_json_tbl <- html_bike_category %>%
             html_nodes(css = '.productGrid__listItem.xlt-producttile > div') %>%
             html_attr("data-gtm-impression") %>%
             map(fromJSON) %>% # need JSON ### need lists
             map(purrr::pluck, 2, "impressions") %>% 
             map(na_if, "not defined") %>%
             map(na_if, "") %>%
             map(~mutate(., across(c("dimension56","price"), as.numeric))) %>%
             bind_rows() %>%
             as_tibble() %>%
             rowid_to_column(var='position') %>%
             left_join(bike_desc_tbl) %>%
             left_join(bike_url_tbl)
}</br>
# Run the function with the first url to check if it is working
bike_category_url <- bike_category_tbl$url[1]
bike_data_tbl     <- get_bike_data(url = bike_category_url)</br>
bike_data_tbl
## # A tibble: 24 x 21
##    position name  id    brand category variant dimension50 dimension51
##       <int> <chr> <chr> <chr> <chr>    <chr>   <chr>       <chr>      
##  1        1 Aero… 2881  Cany… Road/Ra… 500119… 2020        Team Repli…
##  2        2 Aero… 2873  Cany… Road/Ra… 500111… 2020        Stealth    
##  3        3 Aero… 2874  Cany… Road/Ra… 500111… 2020        Stealth    
##  4        4 Aero… 2876  Cany… Road/Ra… 500119… 2020        aero silver
##  5        5 Aero… 2875  Cany… Road/Ra… 500118… 2020        Stealth    
##  6        6 Aero… 2877  Cany… Road/Ra… 500119… 2020        Stealth    
##  7        7 Aero… 2878  Cany… Road/Ra… 500119… 2020        Stealth    
##  8        8 Aero… 2225  Cany… Road/Ra… 500042… 2019        Stealth    
##  9        9 Aero… 2096  Cany… Road/Ra… 500008… 2019        Stealth    
## 10       10 Aero… 2091  Cany… Road/Ra… 500007… 2019        Stealth    
## # … with 14 more rows, and 13 more variables: dimension52 <chr>,
## #   dimension53 <chr>, dimension54 <chr>, dimension55 <chr>, dimension63 <chr>,
## #   feedProductId <chr>, quantity <int>, price <dbl>, metric4 <chr>,
## #   dimension56 <dbl>, metric5 <chr>, description <chr>, url <chr></code></pre>
</section>

</br>

* Step 2.3a (`map()`): If we run this function for all bike category urls, we get the data for every bike

<section class="hide">
<pre><code class="r"># 2.3.1a Map the function against all urls</br>
# Extract the urls as a character vector
bike_category_url_vec <- bike_category_tbl %>% 
                            pull(url)</br>
# Run the function with every url as an argument
bike_data_lst <- map(bike_category_url_vec, get_bike_data)</br>
# Merge the list into a tibble
bike_data_tbl <- bind_rows(bike_data_lst)
saveRDS(bike_data_tbl, "bike_data_tbl.rds")</code></pre>
</section>

</br>

* Step 2.3b (`for loop`): The same could be achieved with a foor loop:

<section class="hide">
<pre><code class="r"># 2.3.1b Alternative with a for loop</br>
# Create an empty tibble, that we can populate
bike_data_tbl <- tibble()</br>
# Loop through all urls
for (i in seq_along(bike_category_tbl$url)) {</br>
  bike_category_url <- bike_category_tbl$url[i]
  bike_data_tbl     <- bind_rows(bike_data_tbl, get_bike_data(bike_category_url))</br>
  # Wait between each request to reduce the load on the server 
  # Otherwise we could get blocked
  Sys.sleep(5)</br>
  # print the progress
  print(i)</br>
}</code></pre>
</section>

</br>

* Step 2.4: CLEANING</br>
We didn't get only the canyon bikes, but also other products listed below some bike categories. They have a different id length. Let's remove observations, where the length of the id is not 4. And we got some duplicates. They have to be removed as well:

<pre><code class="r"># Check for duplicates
bike_data_tbl %>%
    group_by(id) %>%
    filter(n()>1) %>%
    arrange(id) %>% 
    View()</code></pre>
    
In this step we can also split the categories (seperator = Slash, when it is not preceded or followd by a whitespace. Negative look ahead and negative look behind.), rename some columns, fix some missing values, add the frame material and reorder the data.

<section class="hide">
<pre><code class="r"># Filter non Canyon bikes (based on id length) and add an empty column for the colors
bike_data_cleaned_tbl <- bike_data_tbl %>%</br>
    # Filter for bikes. Only unique ones
    filter(nchar(.$id) == 4) %>%
    filter(!(name %>% str_detect("Frameset"))) %>%
    distinct(id, .keep_all = T) %>%</br>
    # Split categories (Speedmax had to be treated individually)
    mutate(category = replace(category, 
           name == "Speedmax CF SLX 8.0 SL", "Road/Triathlon Bike/Speedmax")) %>%
    separate(col = category, into = c("category_1",
                                      "category_2",
                                      "category_3"),
             sep = "(?&lt;!\\s)/(?!\\s)") %>%</br>
    # Renaming
    rename("year"       = "dimension50") %>%
    rename("model"      = "name") %>%
    rename("gender"     = "dimension63") %>%
    rename("price_euro" = "metric4") %>%</br>
    # Fix years manually (have checked the website)
    mutate(year = replace_na(year, 2021)) %>%</br>
    # Add frame material
    mutate(frame_material = case_when(
                          model %>% str_detect(" CF ") ~ "carbon",
                          model %>% str_detect(" CFR ") ~ "carbon",
                          TRUE ~ "aluminium"
                                      )
          ) %>%</br>
    # Select and order columns
    select(-c(position, brand, variant, starts_with("dim"), 
              quantity, feedProductId, price, metric5)) %>%
    select(id, model, year, frame_material, price_euro, everything())</br>
saveRDS(bike_data_cleaned_tbl, "bike_data_cleaned_tbl.rds")</code></pre>
</section>

</br>

Now you have the updated bike data from last session. In this case we don't only want the bike models, but also all the different available color variations for each bike.

***

**Step 3:** Get all color variations for each bike
* Step 3.1a: Get the color IDs for each bike

The only place where I found all color variations for each bike was the script window.deptsfra (found it by searching for known color ids from example URLs), which is not loaded in the html body but in the html head. The content in this script is just a big JSON file (the one that was mentioned earlier), which we must extract. To look at it in a nicer representation, you can copy it and paste it to https://jsonlint.com for example.  

{{< figure src="/img/courses/dat_sci/03/canyon_script.png" caption="JSON data inside a script" >}}

<section class="hide">
<pre><code class="r"># 3.1a Get all color variations for each bike</br>
# Extract all bike urls
bike_url_vec <- bike_data_cleaned_tbl %>% 
                      pull(url)</br>
# Create function to get the variations
get_colors <- function(url) {</br>
    url %>%</br>
        read_html() %>%</br>
        # Get all 'script nodes' and convert to char
        html_nodes(css = "script") %>%
        as.character() %>%</br>
        # Select the node, that contains 'window.deptsfra'
        str_subset(pattern = "window.deptsfra") %>%</br>
        # remove the chars that do not belong to the json
        # 1. replace at the beginning everything until the first "{" with ""
        str_replace("^[^\\{]+", "") %>%
        # 2. replace at the end everything after the last "}" with ""
        str_replace("[^\\}]+$", "") %>%</br>
        # Convert from json to an r object and pick the relevant values
        fromJSON() %>%
        purrr::pluck("productDetail", "variationAttributes", "values", 1, "value")
}</br>
# Run the function over all urls and add result to bike_data_cleaned_tbl
# This will take a long time (~ 20-30 minutes) because we have to iterate over many bikes
bike_data_colors_tbl <- bike_data_cleaned_tbl %>% 
    mutate(colors = map(bike_url_vec, get_colors))</br>
saveRDS(bike_data_colors_tbl, "bike_data_colors_tbl.rds")</code></pre>
</section>

***

<a href="https://davisvaughan.github.io/furrr/" target="_blank">
<img src="/img/icons/logo_furrr.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

Processing large amounts of data with complex models can be time consuming. Historically, R has only utilized only one core, which makes it single-threaded. Which is a shame, because most computers are much more powerful than that. A computer with one processor may still have 4 cores (quad-core), allowing 4 computations to be executed at the same time. Much R code runs fast and fine on a single core or processor. But at times, it is good to utilize more than one core for the same calculation. This is called parallel processing instead of sequential computing. There are many libraries, that makes it pretty easy to use the power of multiple cores. With the package `furrr` the only step you have to do is adding the line `plan("multiprocess")` and replacing `map()` with `future_map()`.

***

* Step 3.1b: Get the color IDs for each bike in a faster way (parallel)
<section class="hide">
<pre><code class="r">library(furrr)     # Parallel Processing using purrr (iteration)
plan("multiprocess")
bike_data_colors_tbl <- bike_data_cleaned_tbl %>% 
    mutate(colors = future_map(bike_url_vec, get_colors))</code></pre>
</section>

</br>

* Step 3.2: Now we have the color Ids, but we still have to build the URLs for each variant by adding the Ids as query parameters.

<section class="hide">
<pre><code class="r"># 3.2 Create the urls for each variation</br>
bike_data_colors_tbl <- bike_data_colors_tbl %>%</br>
  # Create entry for each color variation
  unnest(colors) %>%</br>
  # Merge url and query parameters for the colors
  mutate(url_color = glue("{url}?dwvar_{id}_pv_rahmenfarbe={colors}")) %>%
  select(-url) %>%</br>
  # Use stringi to replace the last dash with the HTLM format of a dash (%2F)
  # Only if there is a dash in the color column
  mutate(url_color = ifelse(str_detect(colors, pattern = "/"),</br>
                        # if TRUE --> replace      
                        stringi::stri_replace_last_fixed(url_color, "/", "%2F"),</br>
                        # ELSE --> take the original url
                        url_color))</br>
bike_data_colors_tbl %>% glimpse()
## Rows: 416
## Columns: 12
## $ id               &lt;chr&gt; "2493", "2453", "2452", "2452", "2451", "2451",…
## $ model            &lt;chr&gt; "Aeroad CFR Disc EPS", "Aeroad CFR Disc AXS",…
## $ year             &lt;chr&gt; "2020", "2020", "2020", "2020", "2020", …
## $ frame_material   &lt;chr&gt; "carbon", "carbon", "carbon", "carbon", …
## $ price_euro       &lt;chr&gt; "8999.00", "7999.00", "7499.00", "7499.00",…
## $ category_1       &lt;chr&gt; "Road", "Road", "Road", "Road", "Road", …
## $ category_2       &lt;chr&gt; "Race", "Race", "Race", "Race", "Race", …
## $ category_3       &lt;chr&gt; "Aeroad", "Aeroad", "Aeroad", "Aeroad", …
## $ gender           &lt;chr&gt; "unisex", "unisex", "unisex", "unisex", …
## $ description      &lt;chr&gt; "Canyon - An aero road bike that combines …
## $ colors           &lt;chr&gt; "BK/BK", "BK/BK", "BK/BK", "BK/MC", "BK/BK",…
## $ url_color        &lt;chr&gt; "https://www.canyon.com/en-de/road-bikes/…</code></pre>
</section>

</br>

Now we have the URL for each individual bike and can get the stock availability for each size and color variation. It is the same process: Get the json data, save that data in a tibble/ list for each observation in the tibble itself and then using `unnest()` to create the wide data format. 

<section class="hide">
<pre><code class="r"># Create function
get_sizes <- function(url) {</br>
  json <- url %>%</br>
    read_html() %>%</br>
    # Get all 'script nodes' and convert to char
    html_nodes(css = "script") %>%
    as.character() %>%</br>
    # Select the node, that contains 'window.deptsfra'
    str_subset(pattern = "window.deptsfra") %>%</br>
    # remove the chars that do not belong to the json
    # 1. replace at the beginning everything until the first "{" with ""
    str_replace("^[^\\{]+", "") %>%
    # 2. replace at the end everything after the last "}" with ""
    str_replace("[^\\}]+$", "") %>%</br>
    # Convert from json to an r object and pick the relevant values
    fromJSON(flatten = T) %>%
    purrr::pluck("productDetail", "variationAttributes", "values", 2) %>%</br>
    # select(id, value, available, availability)# %>%
    select(id, value, availability.onlyXLeftNumber) %>%</br>
    # Rename
    rename(id_size = id) %>%
    rename(size = value) %>%
    rename(stock_availability = availability.onlyXLeftNumber) %>%</br>
    # Conver to tibble
    as_tibble()</br>
}</br>
# Pull url vector
bike_url_color_vec <- bike_data_colors_tbl %>% 
                        pull(url_color)</br>
# Map
bike_data_sizes_tbl <- bike_data_colors_tbl %>% 
  mutate(size = future_map(bike_url_color_vec, get_sizes))</br>
# Unnest
bike_data_sizes_tbl <- bike_data_sizes_tbl %>% 
                         unnest(size)</br>
saveRDS(bike_data_sizes_tbl, "bike_data_sizes_tbl.rds")</code></pre>
</section>

</br>

The database has now already over 2000 observations. From here we could start monitoring prices and availablilty etc. But I leave that up to you how to proceed.

### Further details

This was an introduction to web scraping static sites by using the library `rvest`. However, many web pages are dynamic and use JavaScript to load their content. These websites often require a different approach to gather the data. If you take a look at the following screenshot, you see, that also the website of Canyon uses JavaScript libraries like JQuery or ReactJs or Angular to dynamically create the HTML data. It will only be downloaded if we click the 'View More Items' button. So we can not simply use rvest to scrap the data if we want zo analyze the entire content (in this case only a few bikes/frames are not loaded).

{{< figure src="/img/courses/dat_sci/03/canyon_view_more.png" caption="Dynamic web page" >}}         

To solve the problem, there is another solution. We can use the Selenium web scraping framework. Selenium automates browsers. Originally, it is developed to programmatically test websites. But using it we can also scrap data from websites. Selenium doesn’t have it’s own web browser. We need to integrate it into other web browsers in order to run. But we will use a web browser, which will be running in the background and controlled by our selenium library. And this type of browser is called, headless browser. A headless browser loads website into memory, executes JavaScript code on the page and everything happens in the background. Many web browsers like firefox and chrome support headless features. 

Because I only want to mention this option and installing Selenium might be a little complicated, I am not going to explain the necessary steps in detail and provide you just the code how to click the button and get the entire html content.

<pre><code class="r">library(RSelenium)
# Start the headless browser
driver <- rsDriver(browser = "firefox")
remDr  <- driver$client</br>
# Open the url
url    <- "https://www.canyon.com/en-de/road-bikes/race-bikes/aeroad/"
remDr$navigate(url)</br>
# Locate and click the button
button <- remDr$findElement(using = "css", ".productGrid__viewMore")
button$clickElement()</br>
# Get the html
html <- remDr$getPageSource() %>% 
              unlist() %>% 
              read_html()</code></pre>

Things to keep in mind…

* Static & Well Structured: Web scraping is best suited for static & well structured web pages. 
* Code Changes: The underling HTML code of a web page can change anytime due to changes in design or for updating details. In such case, your script will stop working. It is important to identify changes to the web page and modify the web scraping script accordingly.
* API Availability: In many cases, an API is made available by the service provider or organization. It is always advisable to use the API and avoid web scraping.
* IP Blocking: Do not flood websites with requests as you run the risk of getting blocked. Have some time gap between request so that your IP address is not blocked from accessing the website. Of course, you can also learn to work your way around the anti scraping methods. However, you do need to understand the legality of scraping data and whatever you are doing with the scraped data: http://www.prowebscraper.com/blog/six-compelling-facts-about-legality-of-web-scraping/
 
***
**Datacamp**
<div id="header">Recommended Datacamp courses</div>
<div id="container">
  <div id="first">{{% icon datacamp %}}</div>
  <div id="second">
    <a href="https://learn.datacamp.com/courses/working-with-web-data-in-r" target="_blank"><b>Working with Web Data in R</b></a><br></div>  
  <div id="clear"></div>
</div>

***

<!-- HEADING (challenge) -->
## Challenge <i class="fas fa-laptop-code"></i>

In this chapter, there are two challenges for you:

1. Get some data via an API. There are millions of providers, that offer API access for free and have good documentation about how to query their service. You just have to google them. You can use whatever service you want. For example, you can get data about your listening history (spotify), get data about flights (skyscanner) or just check the weather forecast. Print the data in a readable format, e.g. a table if you want, you could also plot it. 

2. Scrape one of the competitor websites of canyon (either https://www.rosebikes.de/ or https://www.radon-bikes.de) and create a small database. The database should contain the model names and prices for at least one category. Use the `selectorgadget` to get a good understanding of the website structure, it is really helpful. After scraping your data, convert it to a readable format. Prices should be in a numeric format without any other letters or symbols. Also check if the prices are reasonable.  

Upload your codes to your github page. Print the first 10 rows of your tibbles. Keep in mind that you should not publish your credentials.
