[![Build Status](https://app.travis-ci.com/Marketos-Damigos/SML-Adv_R-LAB_05.svg?branch=main)](https://app.travis-ci.com/Marketos-Damigos/SML-Adv_R-LAB_05)

# 732A94 - Advanced R Programming  Lab 5 
## Overview
Downloading Swedish elections data for years 2010, 2014 and 2018, and preview with shiny dashboard using RC-class by Marketos Damigos (marda352) and Christoforos Spyretos (chrsp415).

## Contribution
Both students contributed equally for the development of the package.

## Installation

```
devtools::install_github("Marketos-Damigos/SML-Adv_R-LAB_05", subdir="Lab5package")
```

## Vignettes

```
browseVignettes("Lab5package")
```

## Initialization

```
x = elections("2014")
x
```

## How to get different election types

```
x$council
x$muni
x$parliament
```

## How to open shiny dashboard

```
x$shiny()
```

