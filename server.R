
server <- function(input, output, session) {
  
  # Choix dynamique du département en fonction de la région sélectionné
  observeEvent(input$region, {
    
    if (input$region == "France entière") {
      updateSelectInput(
        session,
        "departement",
        choices = "Tous",
        selected = "Tous"
      )
    } else {
      
      departements <- code_geo %>%
        filter(region == input$region) %>%
        pull(departement) %>%
        unique() %>%
        sort()
      
      updateSelectInput(
        session,
        "departement",
        choices = c("Tous", departements),
        selected = "Tous"
      )
    }
  })
  
  # Choix de la sélection du prénom dynamique
  observeEvent(
    liste_prenom_pop(), 
    {
      updateSelectizeInput(
        session,
        "prenom_analyse",
        choices = liste_prenom_pop(),
        selected = character(0),
        server = TRUE
      )
    }
  )
  
  # ------ FILTRES -------------------------------------------------------------
  
  prenom_filtered <- reactive({
    df <- prenom 
    
    ## ---- Période ----
    df <- df %>% filter(periode >= input$periode[1] & periode <= input$periode[2])
    
    ## ---- Sexe ----
    if (input$sexe != "Tous") {
      df <- df %>% filter(sexe == input$sexe)
    }
    ## ---- Région ----
    if (input$region == "France entière") {
      df <- df %>% filter(geographie == "F")
    } else if (input$region != "France entière" && input$departement == "Tous") {
      df <- df %>% filter(region == input$region & departement == "Tous")
    } else if (input$region != "France entière" && input$departement != "Tous" 
               && !is.null(input$departement)) {
      df <- df %>% filter(region == input$region & departement == input$departement)
    }
    
    return(df)
  })
  
  # ------ GENERAL -------------------------------------------------------------
  
  ## ---- Top 10 ----
  output$plot_top10_prenom <- renderPlotly({
    plot_top10_prenom(prenom_filtered())
  })
  
  ## ---- Naissance ----
  output$nb_naissance_tot <- renderText({
    format_chiffre(get_nombre_naissance(prenom_filtered())$n_naiss_total)
  })
  
  output$nb_naissance_femme <- renderText({
    res <- get_nombre_naissance(prenom_filtered())
    part <- 100 * res$n_feminin / res$n_naiss_total
    
    paste0(
      format_chiffre(res$n_feminin), 
      " (", format_chiffre(part, digits = 1), " %)"
    )
  })
  
  output$nb_naissance_homme <- renderText({
    res <- get_nombre_naissance(prenom_filtered())
    part <- 100 * res$n_masculin / res$n_naiss_total
    
    paste0(
      format_chiffre(res$n_masculin), 
      " (", format_chiffre(part, digits = 1), " %)"
    )
  })
  
  output$plot_evo_naissance <- renderPlotly({
    plot_nombre_naissance_sexe(data_filtered = prenom_filtered())
  })
  
  ## ---- Prénoms différents ----
  output$nb_prenom_diff_tot <- renderText({
    format_chiffre(get_nombre_prenom_diff(prenom_filtered())$n_total)
  })
  
  output$nb_prenom_diff_femme <- renderText({
    res <- get_nombre_prenom_diff(prenom_filtered())
    part <- 100 * res$n_feminin / res$n_total
    
    paste0(
      format_chiffre(res$n_feminin), 
      " (", format_chiffre(part, digits = 1), " %)"
    )
  })
  
  output$nb_prenom_diff_homme <- renderText({
    res <- get_nombre_prenom_diff(prenom_filtered())
    part <- 100 * res$n_masculin / res$n_total
    
    paste0(
      format_chiffre(res$n_masculin), 
      " (", format_chiffre(part, digits = 1), " %)"
    )
  })
  
  output$plot_evo_nb_prenom_diff <- renderPlotly({
    plot_nombre_prenom_diff_sexe(data_filtered = prenom_filtered())
  })
  
  ## ---- Tableaux de données ----
  output$table_prenoms <- DT::renderDT({
    build_tableau_prenom(data_filtered = prenom_filtered())
  })
  
  # ------ ANALYSE -------------------------------------------------------------
  
  # Liste des prénoms dynamique
  liste_prenom_pop <- reactive({
    
    req(prenom_filtered())
    
    prenom_filtered() %>% group_by(prenom) %>% 
      summarise(valeur = sum(valeur, na.rm = T), .groups = "drop") %>% 
      arrange(desc(valeur)) %>% pull(prenom)
    
  })
  
  # Liste des prénoms aléatoire - parmi les 500 plus données
  liste_prenom_aleatoire <- reactive({
    
    req(prenom_filtered())
    
    prenom_filtered() %>% group_by(prenom) %>% 
      summarise(valeur = sum(valeur, na.rm = T), .groups = "drop") %>% 
      arrange(desc(valeur)) %>% slice_head(n = 500) %>% pull(prenom)
    
  })
  
  # Sélection d'un prénom aléatoire
  observeEvent(input$random_prenom, {
    
    prenoms <- liste_prenom_aleatoire()
    req(length(prenoms) > 0)
    choix <- sample(prenoms, 1)
    
    updateSelectizeInput(
      session,
      "prenom_analyse",
      choices = prenoms,
      selected = choix,
      server = TRUE
    )
  })
  
  # ---- Filtres du prénom ----
  
  prenom_selected <- reactive({
    req(input$prenom_analyse)
    prenom_filtered() %>% filter(prenom == input$prenom_analyse)
  })
  
  ## ---- Évolution ----
  
  output$plot_evo_prenom <- renderPlotly({
    req(input$prenom_analyse)
    plot_nombre_naissance_sexe(data_filtered = prenom_selected(), affiche_rang = T)
  })
  
  output$prenom_affiche <- renderText({
    
    if (is.null(input$prenom_analyse) || input$prenom_analyse == "") {
      "Veuillez sélectionner un prénom"
    } else {
      input$prenom_analyse
    }
    
  })
  
  output$nb_naiss_prenom_analyse <- renderText({
    req(input$prenom_analyse)
    format_chiffre(get_nombre_naissance(prenom_selected())$n_naiss_total)
  })
  
  output$best_rang_prenom_analyse <- renderText({
    req(input$prenom_analyse)
    res <- get_best_rang(data_prenom_selected = prenom_selected())
    
    paste0(format_chiffre(res$best_rang), " (", res$best_annee, ")")
  })
  
  output$moyenne_attribution <- renderText({
    req(input$prenom_analyse, input$periode)
    
    n_prenom <- get_nombre_naissance(prenom_selected())$n_naiss_total
    duree <- input$periode[2] - input$periode[1]
    
    format_chiffre(n_prenom / duree, 1)
    
  })
  
  ## ---- Géographie ----
  
  # Sélection des données par régions
  nombre_naissance_regions <- reactive({
    
    # Nombre de naissance pour le prénom sélectionné
    prenom_selected_region <- prenom %>% 
      filter(periode >= input$periode[1] & periode <= input$periode[2]) %>% 
      filter(niveau_geographique == "REG") %>% 
      filter(prenom == input$prenom_analyse)
    
    if (input$sexe != "Tous") {
      prenom_selected_region <- prenom_selected_region %>% filter(sexe == input$sexe)
    }
    
    prenom_selected_region <- prenom_selected_region %>% 
      group_by(region) %>% 
      summarise(n_prenom_region = sum(valeur, na.rm = T), .groups = "drop")
    
    # Nombre de naissance par région
    naissance_region <- prenom %>% 
      filter(periode >= input$periode[1] & periode <= input$periode[2]) %>% 
      filter(niveau_geographique == "REG") %>% 
      group_by(region) %>% 
      summarise(
        n_naiss_region = sum(valeur, na.rm = T),
      )
    
    nombre_naissance_regions <- naissance_region %>% 
      left_join(
        prenom_selected_region, by = "region"
      ) %>% 
      mutate(
        #n_prenom_region = replace_na(n_prenom_region, 0),
        part_region = 10000 * n_prenom_region / n_naiss_region,
        part_prenom = 100 * n_prenom_region / sum(n_prenom_region, na.rm = T)
      ) %>% 
      arrange(desc(part_region))
    
    return(nombre_naissance_regions)
  })
  
  # Carte 
  output$carte_prenom_region <- renderGirafe({
    carte_part_prenom_region(nombre_naissance_regions = nombre_naissance_regions())
  })
  
  
  # ------ TESTS ---------------------------------------------------------------
  

}

