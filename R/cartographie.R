
# 1. Chargement des packages  ---------------------------------------------
library(ggplot2)
library(patchwork)
library(sf)
library(ggiraph)

# carte_part_prenom_region <- function(nombre_naissance_regions) {
#   
#   # Importation des données géographique
#   url <- "https://raw.githubusercontent.com/gregoiredavid/france-geojson/master/regions-avec-outre-mer.geojson"
#   carto_region <- st_read(url)
#   
#   # Préparation des données 
#   data_carte <- carto_region %>%
#     left_join(
#       nombre_naissance_regions,
#       by = c("nom" = "region")
#     ) %>% 
#     mutate(
#       classe = cut(
#         part_region,
#         breaks = unique(quantile(part_region, probs = seq(0, 1, length.out = 7), na.rm = T)),
#         include.lowest = TRUE
#       ),
#       nom_label = gsub("'", " ", nom),
#       tooltip_label = paste0(nom_label, "\n", 
#                              "Naissances : ", format_chiffre(n_prenom_region), "\n",
#                              "Part du prénom dans la région : ", 
#                              format_chiffre(part_region, digits = 1))
#     ) %>% 
#     st_transform(2154)
#   
#   # Echelle et labels variables en fonction des données
#   breaks <- unique(quantile(data_carte$part_region, probs = seq(0, 1, length.out = 7), na.rm = TRUE))
#   labels <- paste0(round(head(breaks, -1), 1), " – ", round(tail(breaks, -1), 1))
#   levels(data_carte$classe) <- labels
#   palette <- rev(scales::brewer_pal(palette = "RdYlBu")(length(labels)))
#   
#   carte_metropole <- data_carte %>% filter(!code %in% c("01", "02", "03", "04", "06"))
#   # carte_reunion <- data_carte %>% filter(code == "04")
#   # carte_mayotte <- data_carte %>% filter(code == "06")
#   # carte_martinique <- data_carte %>% filter(code == "02")
#   # carte_guyane <- data_carte %>% filter(code == "03")
#   
#   p1 <- ggplot(data = carte_metropole) + 
#     geom_sf_interactive(
#       aes(fill = classe, data_id = nom_label, tooltip = tooltip_label),
#       color = "black"
#     ) +
#     scale_fill_manual(values = palette, drop = FALSE, name = "") +
#     theme_void() +
#     labs(title = "Fréquence du prénom par région pour 10 000 naissances")
#   
#   girafe(ggobj = p1)
# }

# Fonction helpers pour la fonction carte_part_prenom_region
plot_carte_popularite_region <- function(data, legend.position = "none") {
  ggplot(data = data) + 
    geom_sf_interactive(
      aes(fill = classe, data_id = nom_label, tooltip = tooltip_label),
      color = "black"
    ) +
    scale_fill_manual(values = palette, drop = FALSE, name = " ") +
    theme_void() + 
    theme(legend.position = legend.position)
}

carte_part_prenom_region <- function(nombre_naissance_regions) {
  
  # Importation des données géographique
  url <- "https://raw.githubusercontent.com/gregoiredavid/france-geojson/master/regions-avec-outre-mer.geojson"
  carto_region <- st_read(url)
  
  # Préparation des données 
  data_carte <- carto_region %>%
    left_join(
      nombre_naissance_regions,
      by = c("nom" = "region")
    ) %>% 
    mutate(
      classe = cut(
        part_region,
        breaks = unique(quantile(part_region, probs = seq(0, 1, length.out = 7), na.rm = T)),
        include.lowest = TRUE
      ),
      nom_label = gsub("'", " ", nom),
      tooltip_label = paste0(nom_label, "\n", 
                             "Naissances : ", format_chiffre(n_prenom_region), "\n",
                             "Part du prénom dans la région : ", 
                             format_chiffre(part_region, digits = 1))
    ) %>% 
    st_transform(2154)
  
  # Echelle et labels variables en fonction des données
  breaks <- unique(quantile(data_carte$part_region, probs = seq(0, 1, length.out = 7), na.rm = TRUE))
  labels <- paste0(round(head(breaks, -1), 1), " – ", round(tail(breaks, -1), 1))
  levels(data_carte$classe) <- labels
  palette <- rev(scales::brewer_pal(palette = "RdYlBu")(length(labels)))
  
  # On construit chaque carte séparément à cause des distances géographiques
  metropole <- data_carte %>% filter(!code %in% c("01", "02", "03", "04", "06"))
  guadeloupe <- data_carte %>% filter(code == "01")
  martinique <- data_carte %>% filter(code == "02")
  guyane <- data_carte %>% filter(code == "03")
  reunion <- data_carte %>% filter(code == "04")
  mayotte <- data_carte %>% filter(code == "06")
  
  # Métropole
  p1 <- plot_carte_popularite_region(data = metropole, legend.position = "left") +
    theme(legend.key.size = unit(0.4, "cm"), legend.text = element_text(size = 8))
  
  # Outre mer 
  p2 <- plot_carte_popularite_region(data = guadeloupe)
  p3 <- plot_carte_popularite_region(data = martinique)
  p4 <- plot_carte_popularite_region(data = guyane)
  p5 <- plot_carte_popularite_region(data = reunion)
  p6 <- plot_carte_popularite_region(data = mayotte)
  
  # Assemblage
  carte_finale <- p1 + (p2 / p3 / p4 / p5 / p6)
  
  girafe(ggobj = carte_finale)
}
