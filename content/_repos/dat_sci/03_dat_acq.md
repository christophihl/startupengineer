---
title: Data Acquisition
linktitle: Data Acquisition
toc: true
type: docs
date: "2019-05-05T00:00:00+01:00"
draft: false
menu:
  dat_sci:
    parent: I. Data Science Fundamentals
    weight: 5

# Prev/next pager order (if `docs_section_pager` enabled in `params.toml`)
weight: 4
---

Web scraping data in the net ...

Why web scrape

* The web is full of free & valuable data
* Many companies put their information out there
* Few companies have programs to actively retrieve & analyze competitor data
* Companies that implement programs have a Competitive Advantage


## <i class="fab fa-r-project" aria-hidden="true"></i> Theory Input


* Importing spreadsheet data files stored online
* Scraping HTML text
* Scraping HTML table data
* Leveraging APIs to scrape data

####rvest
<a href="https://rvest.tidyverse.org/" target="_blank">
<img src="/img/icons/logo_rvest.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>


####HTML

Step 1: Determine URL & Website structure

Components of a URL:

* URL Base path
* URL Page path
* URL query parameters (initialized by the question mark `?`)


<figure>
<div style="display:flex;">
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/URL_01_base.png" alt="CAPTION" style="width:100%">
  </div>
  <div style="flex: 50%; padding: 5px;">
      <img src="/img/courses/dat_sci/03/URL_02_product_main.png" alt="CAPTION" style="width:100%">
  </div>
</div>
<figcaption>HOME: URL Base path (left) and PRODUCT FAMILY MAIN: URL Page Path (right)</figcaption>
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
<figcaption>PRODUCT FAMILY SUB: URL Page Path (left) and PRODUCT: Query Parameters</figcaption>
<div id="clear"></div>
</figure>
</br></br></br></br></br>


https://www.canyon.com/en-de/
https://www.canyon.com/en-de/road-bikes/
https://www.canyon.com/en-de/road-bikes/endurance-bikes/endurace/
https://www.canyon.com/en-de/road-bikes/endurance-bikes/endurace/endurace-cf-slx-disc-9.0-etap/2399.html?dwvar_2399_pv_rahmenfarbe=BK&dwvar_2399_pv_rahmengroesse=M&quantity=1


<!-- HEADING with Business-Logo -->
## <i class="fas fa-user-tie"></i> Business case






<!-- HEADING (challenge) -->
## <i class="fas fa-laptop-code"></i> Challenge
