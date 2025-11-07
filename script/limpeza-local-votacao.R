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


local_vot <- read_csv2("eleitorado_local_votacao_2024.csv")
print(local_vot)


# Mostra a estrutura do data frame

str(local_vot)

# ----------- LIMPANDO E REDUZINDO A BASE DE ELEITORES

install.packages("dplyr")
library(dplyr)

print(local_vot)

# Nome das colunas que você deseja manter
colunas_desejadas <- c("SG_UF","DS_SITU_SECAO_ACESSIBILIDADE","NM_LOCAL_VOTACAO",
                       "NR_LATITUDE","NR_LONGITUDE","NM_MUNICIPIO")

# Selecionar apenas as colunas desejadas
dados_reduzidos <- local_vot %>%
  select(all_of(colunas_desejadas))

print(dados_reduzidos)
str(dados_reduzidos)

# Remover acentos e colocar tudo em minúsculas
local_votacao <- dados_reduzidos %>%
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

print(local_votacao)
str(local_votacao)

# removendo não informado

local_votacao<- local_votacao[!apply(local_votacao, 1, function(x) any(x == "nao informado")), ]

print(local_votacao)
str(local_votacao)

# tirando "prefere não informar

local_votacao_2 <- local_votacao[!apply(local_votacao, 1, function(x) any(x == "prefere nao informar")), ]

print(local_votacao_2)
str(local_votacao_2)

# Convertendo a coluna SG_UF para maiúsculas
local_votacao_2$SG_UF <- toupper(local_votacao_2$SG_UF)

print(local_votacao_2)


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

local_votacao_2 <- local_votacao_2 %>%
  mutate(REGIAO = regioes[SG_UF])

print(local_votacao_2)

# salvando a bd tratada 

write.csv(local_votacao_2, "C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/local_votacao.csv", row.names = FALSE)

## ------- inserindo cod de uf nas bases

library(readxl)
library(dplyr)
library(stringi)
library(stringr)
library(readr)

local_votacao <- read.csv("local_votacao.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)

print(local_votacao)

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
local_votacao <- local_votacao%>%
  left_join(uf_ibge, by = "SG_UF")

print(local_votacao)

write.csv(local_votacao, "C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/local_votacao_lim.csv", row.names = FALSE)


