#LIMPANDO A BASE NO DE LOCAIS PARA SABER QUANTOS TEM SEM DUPLICADA

library(dplyr)

local_vot <- read_csv2("eleitorado_local_votacao_2024.csv")

# Mostra as primeiras linhas do data frame
head(local_vot)  

# Mostra a estrutura do data frame
str(local_vot)   

#para tirar as duplicadas dos locais de votação pelo nome do local

dados_unicos <- local_vot %>%
  distinct(NM_LOCAL_VOTACAO_ORIGINAL,.keep_all = TRUE)

str(dados_unicos)

head(dados_unicos)

# Contar total de locais
total_locais <- nrow(dados_unicos)

#contar os que tem acessibilidade
total_acessivel <- sum(dados_unicos$CD_SITU_SECAO_ACESSIBILIDADE ==1, na.rm = TRUE)

#CONTAR OS SEM ACESSIBILIDADE

total_s_acessibilidade <- sum(dados_unicos$CD_SITU_SECAO_ACESSIBILIDADE ==0,na.rm = TRUE)

#MOSTRAR RESULTADOS

cat("total de locais:",total_locais, "\n")
cat("Total de locais acessiveis:", total_acessivel, "\n")
cat("Total Sem acessibilidade:", total_s_acessibilidade, "\n")


#AGORA PARA SABER POR ESTADO OU REGIÃO

library(dplyr)

Resumo_por_estado <- dados_unicos %>%
  group_by(SG_UF) %>%
  summarise(
  Total_Locais = n(),
  Locais_Acessiveis = sum(CD_SITU_SECAO_ACESSIBILIDADE == 1, na.rm = TRUE),
  Locais_Nao_Acessiveis = sum(CD_SITU_SECAO_ACESSIBILIDADE == 0, na.rm = TRUE),
  Percentual_Acessiveis = (Locais_Acessiveis / Total_Locais) * 100)
    
  # PARA VER O RESUMO
    
  print(Resumo_por_estado)
    
  
  # classificando
  
  library(dplyr)
  
  dados_por_estado <- dados_unicos %>%
    group_by(SG_UF) %>% #agrupar por estado
    summarise(
      Total_Locais = n (), 
      Locais_Acessiveis = sum(CD_SITU_SECAO_ACESSIBILIDADE == 1, na.rm = TRUE),
      Locais_Nao_Acessiveis = sum(CD_SITU_SECAO_ACESSIBILIDADE == 0, na.rm = TRUE),
      Percentual_Acessiveis = (Locais_Acessiveis / Total_Locais) * 100) %>%
    arrange(desc(Percentual_Acessiveis))  # Ordena do maior para o menor número de locais acessíveis

  print(dados_por_estado)
  install.packages("writexl")
  library(writexl)
  
  write_xlsx(dados_por_estado,"C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/locais_acessiveis.xls")
  
  
  
  write.csv(dados_por_estado, "locais_acessiveis_uf.csv",row.names = FALSE) #Row.names = FALSE 
                                      #Remove a coluna de índices para evitar uma numeração extra.   
    
#abrindo novamente a base
  
  library(dplyr)
  getwd()
  setwd("C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/")
  
  
  library(readr)
  locais_acessiveis_uf <- read_csv("locais_acessiveis_uf.csv")
  View(locais_acessiveis_uf)
  
  # Remover pontos que podem ser separadores de milhar e converter para numérico
  df$Percentual_Acessiveis <- as.numeric(gsub("\\.", "", df$Percentual_Acessiveis))
  

  
  