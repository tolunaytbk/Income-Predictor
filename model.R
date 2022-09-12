# Libraries
library(readr)
library(MASS)

# Get Data
data <- read.csv("GelirSira.csv")
data <- data[-1]

# Model
model <- polr(as.factor(GelirKategori) ~ Cinsiyet +
                    OkulTipi + 
                    Edebiyat + 
                    Matematik + 
                    FenBil +
                    Tarih,
                  data = data, 
                  Hess = TRUE,
                  method = c("logistic"))

# Save Model
saveRDS(model, "model.rds")