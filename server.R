
server <- function(input, output, session) {
  
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
}

