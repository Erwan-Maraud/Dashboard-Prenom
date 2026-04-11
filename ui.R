
ui <- page_navbar(
  
  title = "Attribution des Prénoms",
  
  # ------ THEME ---------------------------------------------------------------
  theme = bs_theme(
    version = 5,
    bootswatch = "lux"
    ),
  
  # ------ SIDEBAR -------------------------------------------------------------
  sidebar = sidebar(
    title = "Filtres",
    
    ## ---- Période ----
    sliderInput(
      inputId = "periode",
      label = "Période",
      min = 1900,
      max = 2024,
      value = c(2000, 2024),   
      step = 1
    ),
    
    ## ---- Région ----
    selectInput(
      inputId = "region",
      label = "Région",
      choices = c("France entière", sort(unique(code_geo$region))),
      selected = "France entière",
      multiple = F
    ),
    
    ## ---- Département ----
    selectInput(
      inputId = "departement",
      label = "Département",
      choices = "Tous"
    ),
    
    ## ---- Sexe ----
    selectInput(
      inputId = "sexe",
      label = "Sexe",
      choices = c("Tous", "Féminin", "Masculin"),
      selected = "Tous"
    )
    
  ),

  # ------ GENERAL -------------------------------------------------------------

  nav_panel(
    title = "Général",
    
    card(
      card_header("test département"),
      card_body(
        tableOutput("test")
      )
    )
  ),
  
  # ------ ANALYSE -------------------------------------------------------------
  nav_panel(
    title = "Analyse"
  )
  
)
