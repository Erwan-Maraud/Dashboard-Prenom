
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
  
  nav_panel(
    title = "Général",
    navset_card_underline(
      ## ---- Top 10 prénoms ----
      nav_panel(
        title = "Top 10 des prénoms attribués",
        plotlyOutput("plot_top10_prenom")
      ),
      ## ---- Naissances ----
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
      ## ---- Prénoms différents ----
      nav_panel(
        title = "Nombre de prénoms différents",
        layout_column_wrap(
          height="100px",
          value_box(
            title = "Nombre de prénoms différents H/F",
            value = textOutput("nb_prenom_diff_tot"),
            showcase = bsicons::bs_icon("person-plus")
          ),
          value_box(
            title = "Nombre de prénoms féminins différents",
            value = textOutput("nb_prenom_diff_femme"),
            showcase = bsicons::bs_icon("gender-female")
          ),
          value_box(
            title = "Nombre de prénoms masculins différents",
            value = textOutput("nb_prenom_diff_homme"),
            showcase = bsicons::bs_icon("gender-male")
          )
        ),
        card(
          card_header("Évolution du nombre de prénoms différents attribués"),
          card_body(plotlyOutput("plot_evo_nb_prenom_diff")),
          full_screen = T
        )
      ),
      ## ---- Tableau de données ----
      nav_panel(
        title = "Tableau de données",
        card(
          DT::DTOutput("table_prenoms")
        )
      )
    )
  ),
  
  # ------ ANALYSE -------------------------------------------------------------
  nav_panel(
    title = "Analyse",
    navset_card_underline(
      nav_panel("Évolution"),
      nav_panel("Signification"),
      nav_panel("Prénoms similaires"),
      nav_panel("Tableau de données")
    )
  )
  
)
