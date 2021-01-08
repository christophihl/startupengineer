---
title: "Serving your App"
linktitle: Serving your App
date: '2019-05-05T00:00:00+01:00'
output: pdf_document
toc: yes
draft: no
menu:
  dat_sci_3:
    parent: III. Reporting
    weight: 16
weight: 15
type: docs
---

## <i class="fab fa-r-project" aria-hidden="true"></i> &nbsp;Theory Input

<a href="https://rstudio.github.io/rsconnect/" target="_blank">
<img src="/img/icons/cloud_icon.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

We have created a very useful application now.
But what if we want to share our application with other people in the web?
In the following chapter we will show you one way to serve your application in the web using [shinyapps.io](https://www.shinyapps.io/).
There are also other sites you could use to serve you web application but because [shinyapps.io](https://www.shinyapps.io/) has a great and easy connection to RStudio and a very nice documentation, we use it here.
In its basic version it is for free and we do not require an own server.
Obviously, there are some limitations in the basic version like being allowed to serve only 5 applications and actively using the applications 25 hours per month.
For our use, the limits are sufficiently large.

**0. Open the application**

Let's create a new folder named e.g. `sales_dashboard_shiny` and copy the sales dashboard in it.
It is advisable to rename - if not already the case - the application to `sales_dashboard_shiny.Rmd`.
To make sure that everything runs successfully, click on `Run Document`.
If it does not run, please check in one of the previous chapters why that might be the case.

**1. Installing and loading `rsconnect`**

<a href="https://rstudio.github.io/rsconnect/" target="_blank">
<img src="/img/icons/rsconnect_logo.svg" align="right" style="width:200px; height:200px; padding:0px 0px 10px 10px; margin-top:0px; margin-bottom:0px;"/>
</a>

In order to run a web application on [shinyapps.io](https://www.shinyapps.io/) we have to load the `rsconnect` package.
It allows deploying RMarkown documents, Shiny applications and other files to publishing platforms.

We install the package and load the package by running the following commands in the console:

```
install.packages("rsconnect")
library(rsconnect)
```

**2. Register and connect your account** 

Now, we are required to register on [shinyapps.io](https://www.shinyapps.io/).

One particular advantage is that you can use your GitHub account to register.
To do so, go to [shinyapps.io - Sign Up](https://www.shinyapps.io/admin/#/signup) and click on `Sign Up with GitHub`.

{{< figure src="/img/courses/dat_sci/15/authorize_github_shinyapps.png" caption="...">}}

You will be asked to authorize shinyapps.io to use your GitHub profile information, which facilitates the registration. Of course you can also register without GitHub, if you prefer.

After authorizing or signing up without GitHub, you have to choose an account name. This name will be included in your URL for your web application, e.g. `https://my_account_name.shinyapps.io/my_web_application_name/`.

When you chose a name fulfilling the requirements, you will be redirected to your shinyapps.io dashboard. 
In order for RStudio to connect to your shinyapps.io account, you need your own personal token that can be found under `Account -> Tokens`.
You should see your token there and click on `Show`.
Then, a window containing with an incomplete R function `rsconnect::setAccountInfo()` with the argument `secret` missing.
Please never share your secret token with anyone!

{{< figure src="/img/courses/dat_sci/15/copy_token.png" caption="...">}}

To copy the complete command including all required arguments, either click on `Show secret` and copy the command or click on `Copy to clipboard` and take the command from there.

You can now paste the command in your R console which will establish the connection between RStudio and your shinyapps.io account.
Now you are ready to publish your app.

**3. Publish your application**

To send your application to shinyapps.io, you have to click on the publish icon highlighted by the arrow in the screenshot below.

{{< figure src="/img/courses/dat_sci/15/publish_icon.png" caption="...">}}

In the following prompt you should see your files you want to publish and your shinyapp.io account.

{{< figure src="/img/courses/dat_sci/15/publish_prompt.png" caption="...">}}

Confirming will cause the building of your app on shinyapps.io which especially when done for the first time will take some time.
That is because ...
After the first built publishing will become significantly faster.


**4. Dealing with error messages**

Although your code successfully runs when you use `Run Document`, that does not necessarily mean that it runs on your shinyapps.io as well.
Then, you won't see your web application but an error message stating: 

<span style="color:red">**Error:** *An error has occurred. Check your logs or contact the app author for clarification*.</span>

To get a better understanding of how to troubleshoot, you have to go on shinyapps.io and check the logs for the full error message.
Go to the application and you will see the tab `Logs` on the top, which will show you what you would usually see in your R console.

{{< figure src="/img/courses/dat_sci/15/error_log.png" caption="...">}}

Two common errors that often occur when attempting to publish the application for the first time are:

* Your data should be located in your app directory. Copy it in the same directory and change the code accordingly.
* Even if referenced by already loaded packages, all packages need to be installed. Note that you only want to load but do not want install packages in your code. Installing should be done in the console. 

In general, it is good practice to always have a look at the error logs if something has gone wrong.
In both cases, the logs would have given a useful hint to understand the error.

If you make changes in your application and want to publish them, you only have to click on the publish button.
You don't have to repeat the other steps.

You can have a look at the published website using the link below:

<div style="text-align:center">
<a href="https://owmork.shinyapps.io/sales_dashboard_shiny/" target="_blank"><b>Sales Dashboard - Web Application</b></a>
</div>

***

## <i class="fas fa-laptop-code"></i>&nbsp;Challenge

Your challenge is to follow the instructions and publish your application from the previous chapter!

Please provide use with the link to your application!
