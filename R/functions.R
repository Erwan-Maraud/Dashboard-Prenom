
# Affichage nombre aux normes françaises ---------------------------------------

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

plot_nombre_naissance_sexe <- function(data_filtered, affiche_rang = F) {
  
  # Description : Cette fonction calcul le nombre de naissance par année et par
  # sexe et représente la courbe d'évolution pour le dataset en paramètre
  
  # Couleurs
  couleur_sexe <- c("Masculin" = "#1F77B4", "Féminin" ="lightpink")
  
  # Sélection des données
  data_graph <- data_filtered %>%
    group_by(periode, sexe) %>%
    summarise(
      n_naiss = sum(valeur, na.rm = T),
      rang = min(rang, na.rm = T), .groups = "drop"
    ) %>%
    group_by(sexe) %>% 
    complete(
      periode = full_seq(periode, 1),
      fill = list(n_naiss = 0) 
    ) %>%
    ungroup() %>% 
    arrange(periode, sexe)
  
  # Label en fonction du paramètre
  if (affiche_rang) {
    data_graph <- data_graph %>%
      mutate(
        hover_label = paste0("Rang : ", rang, "<br>",
                             "Année : ", periode, "<br>",
                             "Nombre de naissances : ", format_chiffre(n_naiss))
      )} else {
        data_graph <- data_graph %>%
          mutate(
            hover_label = paste0("Sexe : ", sexe, "<br>",
                                 "Année : ", periode, "<br>",
                                 "Nombre de naissances : ", format_chiffre(n_naiss))
          )
      }
  
  
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

# Nombre de prénoms différents -------------------------------------------------

get_nombre_prenom_diff <- function(data_filtered) {
  
  # Description : Cette fonction renvoie une liste avec le nombre de prénoms différents
  # total du dataset en paramètre pour les prénoms de sexe masculin, féminin et 
  # les deux réunis
  
  sums <- data_filtered %>% 
    group_by(sexe) %>% 
    summarise(n = n_distinct(prenom), .groups = "drop")
  
  list(
    n_masculin = sums$n[sums$sexe == "Masculin"] %>% {if(length(.) == 0) 0 else .},
    n_feminin = sums$n[sums$sexe == "Féminin"]  %>% {if(length(.) == 0) 0 else .},
    n_total = sum(sums$n)
  ) 
}

plot_nombre_prenom_diff_sexe <- function(data_filtered) {
  
  # Description : Cette fonction calcul le nombre de prénoms différents attribué
  # par sexe et par année et trace l'évolution sur la période disponible dans 
  # le dataset filtré en paramètre
  
  # Couleurs 
  couleur_sexe <- c("Masculin" = "#1F77B4", "Féminin" ="lightpink")
  # Sélection des données
  data_graph <- data_filtered %>% 
    group_by(periode, sexe) %>% 
    summarise(n_prenom_diff = n_distinct(prenom), .groups = "drop") %>% 
    mutate(
      hover_label = paste0("Sexe : ", sexe, "<br>",
                           "Année : ", periode, "<br>",
                           "Nombre de prénoms différents : ", format_chiffre(n_prenom_diff))
    ) %>% 
    arrange(periode, sexe)
  
  # Graphique
  plot_ly(
    data = data_graph, 
    x = ~periode,
    y = ~n_prenom_diff,
    color = ~sexe,
    colors = couleur_sexe,
    type = 'scatter',
    mode = 'lines+markers',
    customdata = ~hover_label,
    hovertemplate = "%{customdata}<extra></extra>"
  ) %>% 
    layout(
      xaxis = list(title = "Année"),
      yaxis = list(title = "Nombre de prénoms différents", 
                   range = c(0, max(data_graph$n_prenom_diff) * 1.1)
      )
    )
}

# Tableau des prénoms ----------------------------------------------------------

build_tableau_prenom <- function(data_filtered) {
  
  # Description : Cette fonction permet la construction d'un tableau de prénoms 
  # avec le rang, les effectifs des prénoms attribués sur la période du dataset
  # en paramètres et gère automatiquement les colonnes en fonction du sexe 
  # sélectionné dans les filtres
  
  # Tableau prénoms masculins
  tab_homme <- data_filtered %>% 
    filter(sexe == "Masculin") %>% 
    group_by(sexe, prenom) %>%
    summarise(nombre = sum(valeur, na.rm = TRUE), .groups = "drop") %>%
    arrange(desc(nombre), .by_group = TRUE) %>%
    mutate(
      prenom_masculin = prenom,
      rang = row_number(),
      part = round(100 * nombre / sum(nombre, na.rm = T), 1),
      nombre_masculin_label = paste0(format_chiffre(nombre), " (",
                                     format_chiffre(part, digits = 1), " %)"),
    ) %>% 
    select(rang, prenom_masculin, nombre_masculin_label)
  
  # Tableau prénoms féminins
  tab_femme <- data_filtered %>% 
    filter(sexe == "Féminin") %>% 
    group_by(sexe, prenom) %>%
    summarise(nombre = sum(valeur, na.rm = TRUE), .groups = "drop") %>%
    arrange(desc(nombre), .by_group = TRUE) %>%
    mutate(
      prenom_feminin = prenom,
      rang = row_number(),
      part = round(100 * nombre / sum(nombre, na.rm = T), 1),
      nombre_feminin_label = paste0(format_chiffre(nombre), " (",
                                    format_chiffre(part, digits = 1), " %)"),
    ) %>% 
    select(rang, prenom_feminin, nombre_feminin_label)
  
  # Si les deux sexes sont sélectionnés alors on les fusionnes
  if (length(unique(data_filtered$sexe)) == 2) {
    tab <- full_join(tab_homme, tab_femme, by = "rang") %>% arrange(rang)
    noms_colonnes_tab <- c("Rang", "Masculin", "Effectifs", "Féminin", "Effectifs")
  } else if (unique(data_filtered$sexe) == "Masculin") {
    tab <- tab_homme %>% arrange(rang)
    noms_colonnes_tab <- c("Rang", "Masculin", "Effectifs")
  } else {
    tab <- tab_femme %>% arrange(rang)
    noms_colonnes_tab <- c("Rang", "Féminin", "Effectifs")
  }
  
  dt <- datatable(
    tab,
    rownames = FALSE,
    options = list(
      pageLength = 50,
      ordering = FALSE
    ),
    colnames = noms_colonnes_tab
  ) %>% 
    formatStyle(
      "rang",
      borderRight = "2px solid #ddd"
    )
  
  if (length(unique(data_filtered$sexe)) == 2) {
    dt <- dt %>% 
      formatStyle(
        "nombre_masculin_label",
        borderRight = "2px solid #ddd"
      )
  }
  
  return(dt)
}

# Meilleur rang  ----------------------------------------------------------

get_best_rang <- function(data_prenom_selected) {
  
  df_rang <- data_prenom_selected %>% 
    select(prenom, periode, rang) %>% 
    arrange(rang) %>% 
    slice_head(n = 1) 
  
  list(
    best_annee = df_rang %>% pull(periode),
    best_rang = df_rang %>% pull(rang)
  )
}
