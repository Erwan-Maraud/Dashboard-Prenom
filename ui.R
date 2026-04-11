
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
      step = 1,
      sep = ""
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
  
  # nav_panel(
  #   title = "Général",
  #   layout_column_wrap(
  #     height="1px",
  #     value_box(
  #       title = "Nombre de naissance",
  #       value = 100,
  #       showcase = bsicons::bs_icon("person-plus")
  #     ),
  #     value_box(
  #       title = "Nombre de prénoms différents attribués",
  #       value = 100,
  #       showcas = bsicons::bs_icon("tags")
  #     )
  #   ),
  #   card(
  #     card_header("Top 10 des prénoms attribués"),
  #     card_body(
  #       plotlyOutput("plot_top10_prenom")
  #     )
  #   )
  # ),
  
  nav_panel(
    title = "Général",
    navset_card_underline(
      nav_panel(
        title = "Top 10 des prénoms attribués",
        plotlyOutput("plot_top10_prenom")
      ),
      nav_panel(
        title = "Naissances",
          layout_column_wrap(
            height="10px",
            value_box(
              title = "Nombre de naissance H/F",
              value = 100,
              showcase = bsicons::bs_icon("person-plus")
            ),
            value_box(
              title = "Nombre de naissance F",
              value = 100,
              showcase = bsicons::bs_icon("tags")
            ),
            value_box(
              title = "Nombre de naissance H",
              value = 100,
              showcase = bsicons::bs_icon("tags")
            )
          ),
        card(
          card_header("Évolution du nombre de naissance"),
          card_body("ici graphique"),
          full_screen = T
        )
      ),
      nav_panel(
        title = "Nombre de prénoms différents"
      )
    )
  ),
  
  # ------ ANALYSE -------------------------------------------------------------
  nav_panel(
    title = "Analyse"
  )
  
)
