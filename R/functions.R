
# Affichage nombre aux normes françaises ---------------------------------------

# n : nombre à standardiser
# digit : le nombre de décimal à prendre en compte dans l'arrondie

format_chiffre <- function(x, digits = 0) {
  format(round(x, digits), big.mark = " ", decimal.mark = ",", scientific = FALSE, trim = TRUE)
}

# Top 10 des prénoms attribués -------------------------------------------------

plot_top10_prenom <- function(data_filtered) {
  
  # Description :
  # Cette fonction groupe par sexe et par prénom pour afficher le top 10 
  # des prénoms attribué par sexe.
  
  # Paramètres :
  # data_filtered : dataset des prénoms filtré par sexe, région et période
  
  # Sélection des données 
  data_top10 <- data_filtered %>% 
    group_by(sexe, prenom) %>% 
    summarise(
      valeur = sum(valeur, na.rm = T),
      valeur_tot = sum(valeur_tot, na.rm = T),
      .groups = "drop"
    ) %>% 
    group_by(sexe) %>% 
    arrange(desc(valeur), .by_group = T) %>% 
    slice_head(n = 10) %>% 
    mutate(
      rang = row_number(),
      prenom_rang = paste0(rang, ". ", prenom)
    ) %>% 
    ungroup()
  
  # Ajout des labels pour l'affichage
  data_top10 <- data_top10 %>% 
    mutate(
      part = round(100 *valeur / valeur_tot, 1),
      prenom_rang = factor(prenom_rang, levels = prenom_rang),
      hover_label = paste0(prenom, "<br>",
                           "Nombre : ", format_chiffre(valeur), "<br>",
                           "Part : ", format_chiffre(part, digits = 1), " %")
    )
  
  # On réordonne les rang si on affiche les deux sexes
  if (length(unique(data_top10$sexe)) > 1) {
    data_top10 <- data_top10 %>% 
      arrange(sexe, desc(valeur)) %>% 
      group_by(sexe) %>% 
      mutate(prenom_rang = reorder(prenom_rang, valeur)) %>% 
      ungroup()
  }
  
  # Définition des couleurs par modalités
  couleur_sexe <- c("Masculin" = "#1F77B4", "Féminin" ="lightpink")
  
  # Graphique
  plot_ly(
    data = data_top10,
    x = ~prenom_rang,
    y = ~valeur,
    color = ~sexe,
    colors = couleur_sexe,
    type = "bar",
    customdata = ~hover_label,
    hovertemplate = "%{customdata}<extra></extra>"
  ) %>%
    layout(
      barmode = "group",
      yaxis = list(title = "Nombre"),
      xaxis = list(title = "Prénom")
    )
}

# Nombre de naissance ----------------------------------------------------------

get_nombre_naissance <- function(data_filtered) {
  
  # Description : Cette fonction renvoie une liste avec le nombre de naissances
  # total du dataset en paramètre pour les prénoms de sexe masculin, féminin et 
  # les deux réunis
  
  sums <- data_filtered %>% 
    group_by(sexe) %>% 
    summarise(n = sum(valeur, na.rm = TRUE), .groups = "drop")
  
  list(
    n_masculin = sums$n[sums$sexe == "Masculin"] %>% {if(length(.) == 0) 0 else .},
    n_feminin = sums$n[sums$sexe == "Féminin"]  %>% {if(length(.) == 0) 0 else .},
    n_naiss_total = sum(sums$n)
  )
}

plot_nombre_naissance_sexe <- function(data_filtered) {
  
  # Description : Cette fonction calcul le nombre de naissance par année et par 
  # sexe et représente la courbe d'évolution pour le dataset en paramètre
  
  # Couleurs 
  couleur_sexe <- c("Masculin" = "#1F77B4", "Féminin" ="lightpink")
  # Sélection des données
  data_graph <- data_filtered %>% 
    group_by(periode, sexe) %>% 
    summarise(n_naiss = sum(valeur, na.rm = T), .groups = "drop") %>% 
    mutate(
      hover_label = paste0("Sexe : ", sexe, "<br>",
                           "Année : ", periode, "<br>",
                           "Nombre de naissance : ", format_chiffre(n_naiss))
    ) %>% 
    arrange(periode, sexe)
  # Graphique
  plot_ly(
    data = data_graph, 
    x = ~periode,
    y = ~n_naiss,
    color = ~sexe,
    colors = couleur_sexe,
    type = 'scatter',
    mode = 'lines+markers',
    customdata = ~hover_label,
    hovertemplate = "%{customdata}<extra></extra>"
  ) %>% 
    layout(
      xaxis = list(title = "Année"),
      yaxis = list(title = "Nombre de naissances", 
                   range = c(0, max(data_graph$n_naiss) * 1.1)
      )
    )
}