#!/usr/bin/env Rscript

#Author: Phoenix Logan
#Usage: Search antibase for mass matches found with LC MS data and return a .csv
#file with matches 
usr_path <- readline(prompt="enter the full path to the .cdf files")

#read in the cdf files and extract information 
library(xcms)
path <- "C:/Users/Tim Bugni Lab/Desktop/PL_XCMS/"
c <- xcmsSet(files = path)
m <- group(c)
n <- fillPeaks(m)
values <- groupval(n,value = "into")
head(values)

#put values into a dataframe format
df_values <- as.data.frame(values)
#extract the row names of retention times and masses
mass_retention <- row.names(df_values)

#function will parse out all of the masses and seperate them from the
#retention times
extract_masses <- function(x) {
  x_split <- unlist(strsplit(x, "/"))
  masses <- x_split[seq(1,length(x_split),2)]
  return(masses)
}

#calling the extract_masses function and setting type = numeric
mass_lst <- sapply(mass_retention, extract_masses)
mass_lst <- as.numeric(mass_lst)

#Read in the antibase file
AB_lst <- read.csv("C:/Users/Tim Bugni Lab/Desktop/antibase_newScripts/Antibase_tableOut.csv")
AB_mass <- AB_lst$Mass

#This function will strip off the g_mol string at the end of each entry to 
#make parsing easier when comparing both masses
only_masses <- function(x) {
  for (i in 1:length(x)) {
    mass_extract <- vector(mode="character", length= length(x))
    split_x <- strsplit(as.character(x[i]), " ")
    split_mass <- split_x[[1]][1]
    mass_extract[i] <- split_mass
  }
  return(mass_extract)
}

#execute the function of all antibase masses
AB_massLst_stripped <- sapply(AB_mass, only_masses)

#replace all NA values with 0 and set it as a numeric vector
AB_massLst_stripped[is.na(AB_massLst_stripped)] <- 0 
AB_massLst_numeric <- as.numeric(AB_massLst_stripped)

#Function will compare masses with the antibase list and the user
#input file
match_df <- AB_lst[c(),]
lower_matches <- data.frame(stringsAsFactors = FALSE)
positions <- c()
compare_masses <- function(mass_lst){
  for (i in seq_along(mass_lst)) {
    positions <- c(positions, which(abs(AB_massLst_numeric - mass_lst[i]) < 0.01))
  }
  return(AB_lst[positions,])
}

#function will search for matches in Antibase where
#the mass = mass - mass(element)
subtract_element_mass <- function(mass, elem_mass) {
  mass <- as.numeric(mass) - elem_mass
  return(mass)
}

masses_minus_Na <- sapply(mass_lst, subtract_element_mass, elem_mass = 22.989769)
masses_minus_H <- sapply(mass_lst, subtract_element_mass, elem_mass = 1.00794)

#comparing new masses against antibase
as_is_masses <- compare_masses(mass_lst)
Na_masses <- compare_masses(masses_minus_Na)
H_masses <- compare_masses(masses_minus_H)

#write the test to an output
write.csv(as_is_masses, file="mass_matches.csv")
write.csv(Na_masses, file="minus_Na_matches.csv")
write.csv(H_masses, file="minus_H_matches.csv")
