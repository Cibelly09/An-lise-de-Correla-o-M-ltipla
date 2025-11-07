library(dplyr)
library(readr)
local_vot <- read_csv2("perfil_eleitorado_2024 - qtd.csv")

# Mostra as primeiras linhas do data frame
head(local_vot)  

# Mostra a estrutura do data frame
str(local_vot)  

summary(local_vot)

library(dplyr)
#SELECIONAR APENAS AS COLUNAS QUE PRECISO

local_vot_selecionado <- local_vot %>% select(4, 24, 26)
str(local_vot_selecionado) 
# CONTAR QUANTOS TEM EM TUDO

resumo <- local_vot_selecionado %>% #SUMmarise para colocar várias funções
  summarise(
    total_estados = n_distinct(SG_UF), # n_distinct conta o n° de estados distintos
    total_eleitores = sum(QT_ELEITORES_PERFIL, na.rm = TRUE), # sum conta os eleitores ignorando NA
    total_eleitores_deficientes = sum(QT_ELEITORES_DEFICIENCIA, na.rm = TRUE)

  )
print(resumo)

#entendendo o percentual por estado

percentual_por_estado <- local_vot_selecionado %>%
  group_by(SG_UF) %>%
  summarise(
    total_eleitores = sum(QT_ELEITORES_PERFIL, na.rm = TRUE),
    total_eleitores_deficientes = sum(QT_ELEITORES_DEFICIENCIA, na.rm = TRUE),
    percentual_deficientes = (total_eleitores_deficientes / total_eleitores) * 100
  )

print(percentual_por_estado)

library(writexl)

write_xlsx(percentual_por_estado,"C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/qtd_def_estados.xls")
