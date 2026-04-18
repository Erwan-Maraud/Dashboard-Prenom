
ui <- page_navbar(
  
  title = "Attribution des Prénoms",
  
  id = "nav",
  selected = "Analyse",
  
  # ------ THEME ---------------------------------------------------------------
  theme = bs_theme(
    version = 5,
    bootswatch = "lux"
  ),
  
  ## ---- CSS ----
  header = tags$style(HTML("
  
      .btn-random:active {
        transform: scale(0.95);
      }
  
    ")),

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
    
    conditionalPanel(
      condition = "input.nav == 'Analyse'",
      
      ### ---- Prénom ----
      selectizeInput(
        inputId = "prenom_analyse",
        label = "Prénom",
        choices = NULL,
        multiple = FALSE,
        options = list(
          placeholder = 'Taper un prénom...',
          highlight = TRUE
        )
      )
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
    ),
    
    conditionalPanel(
      condition = "input.nav == 'Analyse'",
      
      ### ---- Option prénom aléatoire ----
      actionButton(
        inputId = "random_prenom",
        label = "Prénom aléatoire",
        class = "btn-random"
      )
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
      nav_panel(
        title = "Évolution",
        layout_column_wrap(
          height="100px",
          value_box(
            title = "Prénom sélectionné",
            value = textOutput("prenom_affiche"),
          ),
          value_box(
            title = "Nombre total de naissance sur la période",
            value = textOutput("nb_naiss_prenom_analyse"),
            showcase = bsicons::bs_icon("graph-up-arrow")
          ),
          value_box(
            title = "Meilleur rang sur la période",
            value = textOutput("best_rang_prenom_analyse"),
            showcase = bsicons::bs_icon("trophy")
          )
        ),
        card(
          card_header("Évolution du nombre de naissance"),
          card_body(plotlyOutput("plot_evo_prenom")),
          full_screen = T
        )
      ),
      nav_panel(
        title = "Géographie",
        
      ),
      nav_panel("Signification"),
      nav_panel("Prénoms similaires"),
      nav_panel("Tableau de données")
    )
  )
  
)
