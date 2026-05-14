
ui <- page_navbar(
  
  title = "Attribution des Prénoms",
  
  id = "nav",
  selected = "Général",
  
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
    id = "sidebar",
    
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
            title = "Nombre de naissances H/F",
            value = textOutput("nb_naissance_tot"),
            showcase = bsicons::bs_icon("person-plus")
          ),
          value_box(
            title = "Nombre de naissances F",
            value = textOutput("nb_naissance_femme"),
            showcase = bsicons::bs_icon("gender-female")
          ),
          value_box(
            title = "Nombre de naissances H",
            value = textOutput("nb_naissance_homme"),
            showcase = bsicons::bs_icon("gender-male")
          )
        ),
        card(
          card_header("Évolution du nombre de naissances"),
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
      
      ## ---- Évolution ----
      nav_panel(
        title = "Évolution",
        layout_column_wrap(
          height="100px",
          value_box(
            title = "Prénom sélectionné",
            value = textOutput("prenom_affiche"),
          ),
          value_box(
            title = "Nombre total de naissances sur la période",
            value = textOutput("nb_naiss_prenom_analyse"),
            showcase = bsicons::bs_icon("graph-up-arrow")
          ),
          value_box(
            title = "Moyenne d'attribution par an",
            value = textOutput("moyenne_attribution"),
            showcase = bsicons::bs_icon("123")
          ),
          value_box(
            title = "Meilleur rang sur la période",
            value = textOutput("best_rang_prenom_analyse"),
            showcase = bsicons::bs_icon("trophy")
          )
        ),
        card(
          card_header("Évolution du nombre de naissances"),
          card_body(plotlyOutput("plot_evo_prenom")),
          full_screen = T
        )
      ),
      
      ## ---- Géographie ----
      nav_panel(
        title = "Géographie",
        card(
          card_header("Popularité du prénom par région : Fréquence du prénom 
                      par région pour 10 000 naissances"),
          card_body(girafeOutput("carte_prenom_region")),
          full_screen = T
        )
      ),
      
      # ## ---- Signification ----
      # nav_panel("Signification"),
      # 
      # ## ---- Prénoms similaires ----
      # nav_panel("Prénoms similaires"),
      # nav_panel("Tableau de données")
    )
  ),
  
  # ------ INFORMATIONS --------------------------------------------------------
  
  nav_panel(
    title = "Informations",
    
    layout_column_wrap(
      width = 1,
      heights_equal = "row",
      # INTRO
      card(
        card_header("À propos des données"),
        p(
          "Les données utilisées dans cette application proviennent de ",
          tags$b("l’Institut national de la statistique et des études économiques (Insee)"),
          ". Elles sont issues des bulletins d’état civil de naissance transmis par les communes ",
          "afin d’alimenter le répertoire national d’identification des personnes physiques (RNIPP)."
        ),
        p("Le périmètre couvre la France métropolitaine et les départements-régions d’outre-mer."),
        
        p("Source : ", 
          tags$a(
          "Insee – Fichier des prénoms",
          href = "https://www.insee.fr/fr/statistiques/8595130?sommaire=8595113#consulter",
          target = "_blank"
          )
        )
      ),
      
      # ACCORDION
      accordion(
        multiple = FALSE,
        # Couverture
        accordion_panel(
          "Couverture et qualité des données",
          p("Les données couvrent la période de 1900 à 2024."),
          tags$ul(
            tags$li("L’exhaustivité n’est pas garantie avant 1946"),
            tags$li("Des erreurs de saisie peuvent subsister"),
            tags$li("Les données peuvent être corrigées dans le temps"),
            tags$li("Les fréquences ne sont pas parfaitement exactes")
          )
        ),
        
        # Traitement
        accordion_panel(
          "Traitement des prénoms",
          tags$ul(
            tags$li("Seul le premier prénom est conservé"),
            tags$li("Suppression des anomalies (ex : 'ANONYME', espaces incorrects)"),
            tags$li("Conservation des accents et apostrophes dans la mesure du possible")
          ),
          p("Certains prénoms composés peuvent être reconstitués automatiquement."),
          p(tags$i("Exemple : 'N DEYE' peut être interprété comme un prénom composé."))
        ),
        
        # Statistiques
        accordion_panel(
          "Diffusion des statistiques",
          tags$ul(
            tags$li("Données disponibles au niveau national, régional et départemental"),
            tags$li("Nombre de naissances par année et par sexe"),
            tags$li("Valeurs arrondies au multiple de 5")
          ),
          p("Cet arrondi vise à limiter les fluctuations faibles et à respecter le secret statistique.")
        ),
        
        # Données manquantes
        accordion_panel(
          "Données non diffusées",
          p("Un prénom est diffusé uniquement s’il apparaît au moins 3 fois."),
          tags$ul(
            tags$li("par année (niveau national)"),
            tags$li("par année et zone (région ou département)")
          ),
          p(
            tags$b("Important : "),
            "l’absence d’un prénom ne signifie pas qu’il n’existe pas, mais qu’il est trop rare."
          )
        ),
        
        # Choix des prénoms
        accordion_panel(
          "Choix des prénoms",
          p("Les parents choisissent librement les prénoms depuis 1993."),
          p("L’officier d’état civil peut toutefois alerter le procureur si le prénom :"),
          tags$ul(
            tags$li("nuit à l’intérêt de l’enfant"),
            tags$li("porte atteinte à un tiers")
          )
        ),
        
        # Écriture
        accordion_panel(
          "Particularités d’écriture",
          p("Les prénoms sont adaptés à l’alphabet français.")
        )
      )
    )
  )
)
