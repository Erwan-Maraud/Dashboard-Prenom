
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
            height="100px",
            value_box(
              title = "Nombre de naissance H/F",
              value = textOutput("nb_naissance_tot"),
              showcase = bsicons::bs_icon("person-plus")
            ),
            value_box(
              title = "Nombre de naissance F",
              value = textOutput("nb_naissance_femme"),
              showcase = bsicons::bs_icon("gender-female")
            ),
            value_box(
              title = "Nombre de naissance H",
              value = textOutput("nb_naissance_homme"),
              showcase = bsicons::bs_icon("gender-male")
            )
          ),
        card(
          card_header("Évolution du nombre de naissance"),
          card_body(plotlyOutput("plot_evo_naissance")),
          full_screen = T
        )
      ),
      nav_panel(
        title = "Nombre de prénoms différents"
      ),
      nav_panel(
        title = "Tableau de données",
        card("ici un tableau des prénoms avec un colonne rang, prénom masculin et féminin")
      )
    )
  ),
  
  # ------ ANALYSE -------------------------------------------------------------
  nav_panel(
    title = "Analyse"
  )
  
)
