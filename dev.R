
# To do list -------------------------------------------------------------------

# Analyse :
# Liste de prénom dynamique
# Sidebar : option aléatoire

# Comparaison de 2 prénoms

# Fonctionalité 
# Regrouper prénoms similaires
# Ajouter signification du prénom 
# Ajouter option sur l'origine du prénom

# A faire :
# Readme
# origine (france, américaine, + évolution par origine)

# Indicateur de popularité : basé sur les quantiles du nombre d'attribution du prénom

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

length(unique(prenom$prenom))
