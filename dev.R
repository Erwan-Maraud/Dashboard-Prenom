
# To do list -------------------------------------------------------------------

# Analyse :
# Liste de prénom dynamique
# Sidebar : option aléatoire

# Comparaison de 2 prénoms

# Fonctionalité 
# Regrouper prénoms similaires
# Ajouter signification du prénom 
# Ajouter option sur l'origine du prénom
# Carte France avec popularité du prénom 

# A faire :
# Page info -> insee
# data managment des accents -> kevin = kévin
# Readme
# origine (france, américaine, + évolution par origine)

# Logique filtrage partie serveur ----------------------------------------------
periode1 <- 1990
periode2 <- 2024
input_geo = "France entière"
input_sexe = "Masculin"
input_sexe = "Tous"

# Intialisation 
prenom_filtered <- prenom
# Filtres 
if (input_geo == "France entière") {
  prenom_filtered <- prenom_filtered %>% filter(geographie == "F")
}
if (input_sexe != "Tous") {
  prenom_filtered <- prenom_filtered %>% filter(sexe == input_sexe)
}
prenom_filtered <- prenom_filtered %>% 
  filter(periode >= periode1 & periode <= periode2)

# Paramètres des fonctions -----------------------------------------------------
data_filtered = prenom_filtered

prenom_selected <- data_filtered %>% 
  filter(prenom == "Erwan") %>% 
  mutate(rang = sample(1:200, n(), replace = TRUE))

# Développement ----------------------------------------------------------------

# Les filtres
prenom_selected_region <- prenom %>% 
  filter(prenom == "Erwan") %>% 
  filter(periode >= periode1 & periode <= periode2) %>% 
  filter(niveau_geographique == "REG") 

# Sélection des données 
naissance_region <- prenom %>% 
  filter(periode >= periode1 & periode <= periode2) %>% 
  filter(niveau_geographique == "REG") %>% 
  group_by(region) %>% 
  summarise(
    n_naiss_region = sum(valeur, na.rm = T),
  ) %>% 
  left_join(
    prenom_selected_region %>%
      group_by(region) %>% 
      summarise(n_prenom_region = sum(valeur, na.rm = T), .groups = "drop"),
    by = "region"
  ) %>% 
  mutate(
    n_prenom_region = replace_na(n_prenom_region, 0),
    part_region = 10000 * n_prenom_region / n_naiss_region
  ) %>% 
  arrange(desc(part_region))



