
# Data : 
# Nombre de naissance par an

# Sidebar pour la page analyse :
# Sidebar général + choix du prénom + option aléatoire
 

# Général :
# 2. Nombre de naissance cette année / période
# 3. Nombre de prénom distinct 
# 4. Tableau des 50 prénoms les plus données / les plus rare + valeur

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

#-------------------------------------------------------------------------------

get_nombre_naissance <- function(data_filtered) {
  
  n <- data_filtered %>% 
    group_by(geographie) %>% 
    summarise(n_naissance = sum(valeur, na.rm = T)) %>% 
    pull(n_naissance)
  
  return(n)
}

