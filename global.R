
# 1. Chargement des librairies --------------------------------------------
library(dplyr)
library(tidyr)
library(arrow)
library(stringr)
library(janitor)
library(plotly)
library(shiny)
library(bslib)
library(shinyWidgets)
library(bsicons)
library(DT)

# 2. Chargement des fonctions ---------------------------------------------
source("R/functions.R")

# 3. Chargement des données -----------------------------------------------
prenom <- readRDS("data/prenom_clean.rds")
code_geo <- readRDS("data/ref_geo.rds")


