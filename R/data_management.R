
# 1. Chargement des librairies --------------------------------------------
library(dplyr)
library(arrow)
library(stringr)
library(janitor)
library(plotly)
library(shiny)
library(bslib)
library(shinyWidgets)
library(bsicons)
library(DT)

source("R/functions.R")

# 2. Chargement des données -----------------------------------------------
prenom <- arrow::read_parquet("data/prenoms-2024.parquet")

code_geo_region <- read.csv("data/regions-france.csv") %>% 
  janitor::clean_names() %>% 
  rename(
    geographie = code_region,
    region = nom_region
    ) %>% 
  mutate(
    geographie = as.character(sprintf("%02d", geographie)),
    niveau_geographique = "REG",
    departement = "Tous"
  )

code_geo_departement <- read.csv("data/departements-france.csv") %>% 
  janitor::clean_names() %>% 
  rename(
    geographie = numero_departement
  ) %>% 
  mutate(
    niveau_geographique = "DEP",
    geographie = ifelse(geographie %in% c("1", "2", "3", "4", "5", "6", "7", "8", "9"),
                        paste0("0", geographie), geographie)
  ) 

code_geo <- rbind(code_geo_departement, code_geo_region)

# 3. Management des données -----------------------------------------------
prenom <- prenom %>% 
  mutate(
    prenom = str_to_title(prenom),
    sexe = factor(sexe, levels = c("1", "2"), labels = c("Masculin", "Féminin")),
    periode = as.numeric(periode)
  ) 

# Ajout des variables département et région 
prenom <- prenom %>% 
  left_join(
    code_geo, 
    by = c("niveau_geographique", "geographie")
  ) %>% 
  mutate(
    departement = ifelse(geographie == "F", "Tous", departement),
    region = ifelse(geographie == "F", "Toutes", region)
  ) 

# # Calcul du rang du prénom par an, par région, département et par sexe
# prenom <- prenom %>%
#   group_by(prenom, periode, sexe, niveau_geographique, geographie, departement, region) %>%
#   summarise(valeur = sum(valeur, na.rm = TRUE), .groups = "drop") %>%
#   group_by(periode, sexe, niveau_geographique, geographie, departement, region) %>%
#   arrange(desc(valeur), .by_group = TRUE) %>%
#   mutate(rang = row_number()) %>%
#   ungroup()

# Calcul du nombre d'attribution de prénom par an, par région, par département et par sexe
prenom_group <- prenom %>% 
  group_by(periode, sexe, region, departement) %>% 
  summarise(
    valeur_tot = sum(valeur, na.rm = T),
    nombre_prenom_distinct = n_distinct(prenom),
    .groups = "drop"
    ) %>% 
  arrange(periode, region)

prenom <- prenom %>% 
  left_join(
    prenom_group, 
    by = c("periode", "sexe", "region", "departement")
  )

# Ménage 
rm(code_geo_departement, code_geo_region, prenom_group)
