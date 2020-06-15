---
title: Marketing for Startups
linktitle: Marketing for Startups
toc: true
type: docs
date: "2020-06-11T00:00:00Z"
draft: false
menu:
  tech_ent:
    weight: 8

# Prev/next pager order (if `docs_section_pager` enabled in `params.toml`)
weight: 7
---

## Objectives

This section on marketing for startups provides resources and materials to support the following learning objectives:
1. Understand the strategic levers of growth.
2. Manage (startup) marketing as conversion funnel.
3. Design appropriate marketing methods for specific conversion problems.
4. Interprete measures and metrics of marketing effectiveness and return on investment.
5. Calculate Customer Lifetime Value.

<br/>

## When and How to Grow

* YCombinator on Growth
{{< youtube 6lY9CYIY4pQ >}}

* Key take aways:
	* Invest in growth only if you have reached product market, measured by retention!
	* Try things that don't scale.
	* Growth means (1) attracting attention through external channels and (2) inceasing conversion on your site.
	* Optimize the use of only one or two external marketing channels.
	* Growth requires a culture of is experimentation.

<br/>

* [Get, Keep & Grow Customer Relationship Cycle](https://medium.com/@youngstapreneur/how-to-maximise-your-customer-relationship-cycle-478dd1d004e1)

* Three Engines of Growth
{{< youtube YNhi9PKcTso >}}


<br/>

## Marketing as Conversion Funnel

* [Intro](https://medium.com/@DaveParkerSEA/startup-marketing-funnel-breakdown-508b423d3747)
* [Funnel Economics](https://blog.ladder.io/marketing-funnel/#analysis)



<br/>

## Customer Acquisition Channels

* [Paid, Owned and Earned Channels](https://referralrock.com/blog/paid-owned-earned-media/)
* Challenges and Choices

{{< slideshare id="29639175" >}}




<br/>

## Customer Lifetime Value (CLV)

Customer Lifetime Value (CLV) is the total gross profit (contribution) a single user generates over the course of his or her use of a firm's service to cover R&D, G&A and other overhead. It is an important metric to determine marketing effectiveness and efficiency. CLV depends on:

* $CAC$ : Customer Acquisition Cost is the upfront investment in terms of marketing cost to acquire one customer.

* $P$ : Annual (or monthly) profits one customer generates for the firm. Often measured in terms of 
	- Average gross margin per user (AGMPU)
	- Contribution margin: $P =$ Revenue – Variable Cost
	- Gross Profit: $P =$ Revenue – Cost of Goods Sold
	- Revenue can include one-time and recurrent streams. For one-time revenue you need the lifetime of the product and its replacement probability, i.e. the likelihood that the customer purchases a new product version.

<br/>

* $L$ : Lifetime of one customer, i.e. number of years (or months) he or she is purchasing from the firm. Then the basic formula becomes:

$$CLV = P * L - CAC$$

Useful metrics to measure lifetime are:

* $CR$ : Churn rate is percentage of customers leaving in a given year (or month).

* $RR$ : Retention rate is percentage of customers staying in a given year (or month).

$$RR = 1 - CR$$

* $s_{t}$ : Survival probability is the chance that a customer is still around in year (or month) $t$.

Assuming that $s_{1} = 1$ and $RR_{t} = RR_{t+1}$ implies:

$$\begin{aligned}
s_{1} &= 1 \\\\
s_{2} &= s_{1} * RR \\\\
s_{3} &= s_{2} * RR \\\\
&... \\\\
s_{t} &= RR^{t-1}
\end{aligned}$$

The expected purchasing life $L$ is then given by:

$$\begin{aligned}
L &= \sum_{t=1}^\infty\ s_{t}  \\\\
&= \sum_{t=1}^\infty\ RR^{t-1} \\\\
&= \frac{1}{1 - RR} \\\\
&= \frac{1}{CR}
\end{aligned}$$


The $CLV$ formula can then be expressed in terms of survival, retention, and churn, respectively:

$$\begin{aligned}
CLV &= P * L - CAC \\\\
&= \sum_{t=1}^\infty\ (P * s_{t}) - CAC \\\\
&= \sum_{t=1}^\infty\ (P * RR^{t-1}) - CAC \\\\
&= \frac{P}{1 - RR} - CAC \\\\
&= \frac{P}{CR} - CAC
\end{aligned}$$

The time value of money can be incorporated:

$$CLV = \sum_{t=1}^\infty\ \frac{P * RR^{t-1}}{{(1 + i)}^{t - 1}} - CAC$$

which can be simplified with a geometric series to:

$$CLV = P * \Bigl(\frac{1 + i}{1 + i - RR}\Bigr) - CAC$$

Investors often also want to know the following ratio:

$$\frac{CAC}{P}$$

which is the payback period, i.e. how many years (or months) it takes to recover the $CAC$. Instead of the difference between $P * L$ and $CAC$, investors also want this ratio to be larger than 3 as a sign of a sustainable growth model:

$$\frac{P * L}{CAC} > 3$$

The $CLV$ for an entire customer segment is simply the average customer $CLV$ multiplied by the number of customers in a segment:

$$CLV_{segment} = CLV_{average\\_customer} * Customers_{segment}$$

