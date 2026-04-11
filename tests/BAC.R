
# Data : 
# Nombre de naissance par an

# Sidebar : 
# 1. Définir la période d'analyse
# 2. Sélectionner le regroupement géographique : France entière / Région / Département
# 3. Choix du sexe : Tous / Masculin / Féminin
# Option aléatoire : 

# Général :
# 1. Top 10 prénom
# 2. Nombre de naissance cette année / période


# Fonctionalité 
# Regrouper prénoms similaires
# Ajouter signification du prénom 
# Ajouter option sur l'origine du prénom
# Carte France avec popularité du prénom 

#-------------------------------------------------------------------------------

periode1 <- 1900
periode2 <- 1910
input_geo = "France entière"
input_sexe = "Masculin"

data_filtered <- prenom %>% 
  filter(periode >= periode1, periode <= periode2) %>% 
  filter(sexe == input_sexe) %>% 
  filter(niveau_geographique == "FRANCE")

data_top10 <- data_filtered %>% 
  group_by(prenom) %>% 
  summarise(valeur = sum(valeur, na.rm = T)) %>% 
  arrange(desc(valeur)) %>% 
  head(10) %>% 
  mutate(
    prenom = factor(prenom, levels = prenom),
    hover_label = paste0(prenom, "<br>",
                         "Nombre : ", format_chiffre(valeur))
  )

plot_ly(
  data = data_top10,
  x = ~prenom,
  y = ~valeur,
  type = "bar",
  customdata = ~hover_label,     
  hovertemplate = "%{customdata}<extra></extra>"  
) %>%
  layout(
    yaxis = list(title = "Nombre"),
    xaxis = list(title = "Prénom")
  )


rm(data_filtered, data_top10)
