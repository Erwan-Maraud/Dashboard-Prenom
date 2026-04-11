

# Affichage nombre aux normes françaises ---------------------------------------

# n : nombre à standardiser
# digit : le nombre de décimal à prendre en compte dans l'arrondie

format_chiffre <- function(x, digits = 0) {
  format(round(x, digits), big.mark = " ", decimal.mark = ",", scientific = FALSE, trim = TRUE)
}



