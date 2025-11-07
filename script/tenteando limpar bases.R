
getwd()
# Definir o diretório de trabalho
setwd("C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL")

#INICIANDO A LIMPEZA  E ORGANIZAÇAO DOS DADOS
#Instalando pacote para ler excel, dplyr e stringi para manipular e dados maiusculo/minusculo

install.packages("readxl")
install.packages("dplyr")
install.packages("stringi")
install.packages("stringr")
install.packages("readr")

library(readxl)
library(dplyr)
library(stringi)
library(stringr)
library(readr)

perfil_eleitor <- read.csv("perfil_eleitor_deficiencia_2024_BRASIL.csv", sep = ";", header = TRUE, stringsAsFactors = TRUE)

# Mostra as primeiras linhas do data frame
head(perfil_eleitor)  

# Mostra a estrutura do data frame
str(perfil_eleitor)   

# ----------- LIMPANDO E REDUZINDO A BASE DE ELEITORES

install.packages("dplyr")
library(dplyr)

print(perfil_eleitor)

# Nome das colunas que você deseja manter
colunas_desejadas <- c("SG_UF","DS_TIPO_DEFICIENCIA","DS_GENERO","DS_FAIXA_ETARIA","DS_GRAU_ESCOLARIDADE","DS_RACA_COR","DS_ESTADO_CIVIL","DS_IDENTIDADE_GENERO")

# Selecionar apenas as colunas desejadas
dados_reduzidos <- perfil_eleitor %>%
  select(all_of(colunas_desejadas))

print(dados_reduzidos)
str(dados_reduzidos)

# Remover acentos e colocar tudo em minúsculas
perfil_eleitor_clean <- dados_reduzidos %>%
  select(all_of(colunas_desejadas)) %>%
  mutate(across(everything(), ~ {
    # Converte para UTF-8
    .x <- iconv(., from = "WINDOWS-1252", to = "UTF-8")
    .x <- str_to_lower(.x)
    .x <- str_replace_all(.x, "[áàâãä]", "a")
    .x <- str_replace_all(.x, "[éèêë]", "e")
    .x <- str_replace_all(.x, "[íìîï]", "i")
    .x <- str_replace_all(.x, "[óòôõö]", "o")
    .x <- str_replace_all(.x, "[úùûü]", "u")
    .x <- str_replace_all(.x, "[ç]", "c")
    .x <- str_replace_all(.x, "[ñ]", "n")
    .x
  }))

print(perfil_eleitor_clean)
str(perfil_eleitor_clean)

# removendo não informado

perfil_eleitor_filtrado <- perfil_eleitor_clean[!apply(perfil_eleitor_clean, 1, function(x) any(x == "nao informado")), ]

perfil_eleitor_filtrado <- perfil_eleitor_clean[!apply(perfil_eleitor_clean, 1, function(x) any(x == "invalida")), ]


print(perfil_eleitor_filtrado)
str(perfil_eleitor_filtrado)

# tirando "prefere não informar

perfil_eleitor_final <- perfil_eleitor_filtrado[!apply(perfil_eleitor_filtrado, 1, function(x) any(x == "prefere nao informar")), ]

print(perfil_eleitor_final)
str(perfil_eleitor_final)

# Convertendo a coluna SG_UF para maiúsculas
perfil_eleitor_final$SG_UF <- toupper(perfil_eleitor_final$SG_UF)

print(perfil_eleitor_final)


# adicionando a região para os dados

# Crie um vetor com o mapeamento de estados e suas respectivas regiões
regioes <- c(
  "AC" = "Norte", "AL" = "Nordeste", "AP" = "Norte", "AM" = "Norte",
  "BA" = "Nordeste", "CE" = "Nordeste", "DF" = "Centro-Oeste", "ES" = "Sudeste",
  "GO" = "Centro-Oeste", "MA" = "Nordeste", "MT" = "Centro-Oeste", "MS" = "Centro-Oeste",
  "MG" = "Sudeste", "PA" = "Norte", "PB" = "Nordeste", "PR" = "Sul",
  "PE" = "Nordeste", "PI" = "Nordeste", "RJ" = "Sudeste", "RN" = "Nordeste",
  "RS" = "Sul", "RO" = "Norte", "RR" = "Norte", "SC" = "Sul",
  "SP" = "Sudeste", "SE" = "Nordeste", "TO" = "Norte"
)

# adicionar a coluna de regiões ao data.frame

library(dplyr)

dados_eleitor <- perfil_eleitor_final %>%
  mutate(REGIAO = regioes[SG_UF])

print(dados_eleitor)

# salvando a bd tratada 

write.csv(dados_eleitor, "C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/dados_eleitor.csv", row.names = FALSE)

# ------- inserindo cod de uf nas bases



library(readxl)
library(dplyr)
library(stringi)
library(stringr)
library(readr)

perfil_eleitor_1 <- read.csv("dados_eleitor.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)

print(perfil_eleitor_1)

# Criar um data.frame com os códigos das UFs do IBGE
uf_ibge <- data.frame(
  SG_UF = c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", 
            "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", 
            "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", 
            "SP", "SE", "TO"),
  COD_IBGE = c(12, 27, 13, 13, 29, 23, 53, 32, 
               52, 21, 15, 12, 31, 15, 33, 41, 
               26, 22, 33, 24, 43, 11, 14, 42, 
               35, 28, 17)
)

library(dplyr)

# Juntar os dados com os códigos IBGE
perfil_eleitor <- perfil_eleitor_1 %>%
  left_join(uf_ibge, by = "SG_UF")

print(perfil_eleitor)

write.csv(perfil_eleitor, "C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/perfil_eleitor_lim.csv", row.names = FALSE)


perfil_eleitor <- read.csv("perfil_eleitor_lim.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)
print(perfil_eleitor)

# tirando "prefere não informar


perfil_eleitor_limp <- perfil_eleitor[!apply(perfil_eleitor, 1, function(x) any(x == "invalida")), ]

print(perfil_eleitor_limp)
str(perfil_eleitor_limp)

# tirando a coluna de codigo dos municipios de novo para pode aplicar a acm

# Nome das colunas que você deseja manter
colunas_desejadas <- c("SG_UF","DS_TIPO_DEFICIENCIA","DS_GENERO","DS_FAIXA_ETARIA",
                       "DS_GRAU_ESCOLARIDADE","DS_RACA_COR","DS_ESTADO_CIVIL","DS_IDENTIDADE_GENERO","REGIAO")

# Selecionar apenas as colunas desejadas
dados<- perfil_eleitor_limp %>%
  select(all_of(colunas_desejadas))

print(dados)
str(dados)
write.csv(dados, "C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/perfil_eleitor_red.csv", row.names = FALSE)
