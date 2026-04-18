
# To do list -------------------------------------------------------------------
# Data : 
# Nombre de naissance par an

# # Analyse :
# Sidebar pour la page analyse :
# Sidebar général + choix du prénom + option aléatoire
 
# Comparaison de 2 prénoms

# Fonctionalité 
# Regrouper prénoms similaires
# Ajouter signification du prénom 
# Ajouter option sur l'origine du prénom
# Carte France avec popularité du prénom 

# Logique filtrage partie serveur ----------------------------------------------
periode1 <- 1900
periode2 <- 1910
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

# Développement ----------------------------------------------------------------


