# limpando base de qtd de votos 

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


QTD_VOTOS <- read_csv2("perfil_eleitorado_2024.original.csv")
print(QTD_VOTOS)


# Mostra a estrutura do data frame
str(QTD_VOTOS)   

# ----------- LIMPANDO E REDUZINDO A BASE DE ELEITORES

install.packages("dplyr")
library(dplyr)

print(QTD_VOTOS)

# Nome das colunas que você deseja manter
colunas_desejadas <- c("SG_UF","QT_ELEITORES_PERFIL","QT_ELEITORES_DEFICIENCIA","DS_GENERO",
                       "DS_FAIXA_ETARIA","DS_GRAU_ESCOLARIDADE","DS_RACA_COR","DS_ESTADO_CIVIL",
                       "DS_IDENTIDADE_GENERO")

# Selecionar apenas as colunas desejadas
dados_reduzidos <- QTD_VOTOS %>%
  select(all_of(colunas_desejadas))

print(dados_reduzidos)
str(dados_reduzidos)

# Remover acentos e colocar tudo em minúsculas
qtd_votos_red <- dados_reduzidos %>%
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

print(qtd_votos_red)
str(qtd_votos_red)

# removendo não informado

qtd_votos_red_2 <- qtd_votos_red[!apply(qtd_votos_red, 1, function(x) any(x == "nao informado")), ]

print(qtd_votos_red_2)
str(qtd_votos_red_2)

# tirando "prefere não informar

qtd_votos_red <- qtd_votos_red_2[!apply(qtd_votos_red_2, 1, function(x) any(x == "prefere nao informar")), ]

print(qtd_votos_red )
str(qtd_votos_red )

# Convertendo a coluna SG_UF para maiúsculas
qtd_votos_red$SG_UF <- toupper(qtd_votos_red $SG_UF)

print(qtd_votos_red)


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

qtd_votos_final <- qtd_votos_red %>%
  mutate(REGIAO = regioes[SG_UF])

print(qtd_votos_final)

# salvando a bd tratada 

write.csv(qtd_votos_final, "C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/qtd_votos.csv", row.names = FALSE)

#-------------

# ------- inserindo cod de uf nas bases



library(readxl)
library(dplyr)
library(stringi)
library(stringr)
library(readr)

qtd_votos <- read.csv("qtd_votos.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)

print(qtd_votos)

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
qtd_votos_1 <- qtd_votos%>%
  left_join(uf_ibge, by = "SG_UF")

print(qtd_votos_1)

write.csv(qtd_votos_1, "C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/qtd_votos_lim.csv", row.names = FALSE)


