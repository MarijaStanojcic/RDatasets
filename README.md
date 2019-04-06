# R Shiny App

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/MarijaStanojcic/RDatasets/master?urlpath=shiny/APP/)

Here is the link https://marija-stanojcic.shinyapps.io/R_datasets/ to my R Shiny app, where you can actually search through all of these data, see the preview and summary of the data that you are interested in. 

# RDatasets

### What is this?
Find r data from a list of data sets from http://vincentarelbundock.github.io/Rdatasets/datasets.html. (Last Updated: March 22, 2019)

### Motivation 
I wanted to find R dataset to work with for my class project. I found this website with a lot of r datasets http://vincentarelbundock.github.io/Rdatasets/datasets.html and rather than looking through each data independently I decided to make a program that would help me find my data.

### About the program
This program reads the list of data sets from the website into a new data. 
Checks for uninstalled packages and installs them. 
Checks for unloaded packages and loads them, and all of this make it possible to easily search for a particular R data (from the website) with some specifics, for example, number of rows, number of columns, etc.
Since I found some mistakes in columns has_numerical, has_logical, has_character variables I wrote a code to rewrite those columns and also to add column has_factor (it's true if data has at least one factor variable, otherwise it's false). 

You can also check a GitHub repository https://github.com/vincentarelbundock/Rdatasets where you can find more about this list of data.

Quote from @vincentarelbundock: "Rdatasets is a collection of over 1200 datasets that were originally distributed alongside the statistical software environment R and some of its add-on packages. The goal is to make these data more broadly accessible for teaching and statistical software development."

### License

I don't own the rights to any data from R packages that are used here. If you want to use it, it's on you. :) 



