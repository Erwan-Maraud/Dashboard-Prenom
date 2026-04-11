
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

  output$test <- renderTable({
    data.frame(Département = unique(prenom_filtered()$departement))
  })
}

