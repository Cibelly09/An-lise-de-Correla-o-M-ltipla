# dia 25/09 -  Distribuição dos Tipos de Deficiência por Região

# Supondo que o seu dataframe se chama `dados`
# E que você tem uma coluna com o estado (SG_UF) e outra com o tipo de deficiência (tipo_deficiencia)

# CARREGANDO BASES 

dados<- read.csv("perfil_eleitor_red.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)

# Mostra as primeiras linhas do data frame
head(dados)  

# Mostra a estrutura do data frame
str(dados)   


tabela_contingencia <- table(dados$SG_UF, dados$DS_TIPO_DEFICIENCIA)
print(tabela_contingencia)

tabela_contingencia2<- table(dados$REGIAO, dados$DS_TIPO_DEFICIENCIA)
print(tabela_contingencia2)

# GERANDO UM GRÁFICO DE BARRAS 

library(ggplot2)

# Criando o gráfico de barras empilhadas
ggplot(dados, aes(x = SG_UF, fill = DS_TIPO_DEFICIENCIA)) +
  geom_bar(position = "fill") +  # fill para barras empilhadas
  labs(title = "Distribuição dos Tipos de Deficiência por Estado",
       x = "Estado", y = "Proporção") +
  theme_minimal()

# Comparando com Acessibilidade

# vamos unir a tabela de acessibilidade para realizar a analise

# Carregando os dados de acessibilidade
dados_acessibilidade <- read.csv("local_votacao_lim.csv", sep = ",", stringsAsFactors = TRUE)

dados_perfil<- read.csv("perfil_eleitor_red.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)

# identificando as colunas de união

# Supondo que 'COD_MUN_IBGE' e 'NR_ZONA' estejam em ambas as tabelas como chave comum:
head(dados_perfil)
head(dados_acessibilidade)


#Passo 1: Agrupar por estado e tipo de deficiência

library(dplyr)

# Agrupar dados de perfil por estado (SG_UF) e tipo de deficiência
dados_perfil_uf <- dados_perfil %>%
  group_by(SG_UF, DS_TIPO_DEFICIENCIA) %>%
  summarise(TOTAL_DEFICIENCIA = n())


#Passo 2: Agrupar acessibilidade por estado

# Substituir valores categóricos por numéricos
dados_acessibilidade$DS_SITU_SECAO_ACESSIBILIDADE <- ifelse(dados_acessibilidade$DS_SITU_SECAO_ACESSIBILIDADE == "com acessibilidade", 1,
                                                            ifelse(dados_acessibilidade$DS_SITU_SECAO_ACESSIBILIDADE == "sem acessibilidade", 0, NA))

# Agrupar dados de acessibilidade por estado (SG_UF)
dados_acessibilidade_uf <- dados_acessibilidade %>%
  group_by(SG_UF) %>%
  summarise(TOTAL_ACESSIBILIDADE = sum(DS_SITU_SECAO_ACESSIBILIDADE == 1, na.rm = TRUE))


#4. Fazer a junção com a base de perfil

# Fazer o merge dos dados de perfil e acessibilidade por estado (SG_UF)
dados_combinados_uf <- merge(dados_perfil_uf, dados_acessibilidade_uf, by = "SG_UF", all.x = TRUE)


# Verificar as primeiras linhas dos dados combinados
head(dados_combinados_uf)


# salvando a bd tratada 

write.csv(dados_combinados_uf, "C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/base_def_acess_uf.csv", row.names = FALSE)


# AGORA JUNTANDO POR REGIAO

# Agrupar dados de perfil por região e tipo de deficiência
dados_perfil_regiao <- dados_perfil %>%
  group_by(REGIAO, DS_TIPO_DEFICIENCIA) %>%
  summarise(TOTAL_DEFICIENCIA = n())

# Agrupar dados de acessibilidade por região
dados_acessibilidade_regiao <- dados_acessibilidade %>%
  group_by(REGIAO) %>%
  summarise(TOTAL_ACESSIBILIDADE = sum(DS_SITU_SECAO_ACESSIBILIDADE == 1, na.rm = TRUE))

# Unir os dados por região
dados_combinados_regiao <- merge(dados_perfil_regiao, dados_acessibilidade_regiao, by = "REGIAO")

# salvando a bd tratada 

write.csv(dados_combinados_regiao, "C:/Users/Cibelly Viegas/Desktop/TCC 24/TCC/PROJECT OFICIAL/base_def_acess_regiao.csv", row.names = FALSE)

#gráficos para comparar

# CARREGANDO BASES 

dados_combinados_regiao<- read.csv("base_def_acess_regiao.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)

# Mostra as primeiras linhas do data frame
head(dados_combinados_regiao)  

# Mostra a estrutura do data frame
str(dados_combinados_regiao)

install.packages("ggplot2")
install.packages("dplyr")

library(ggplot2)
library(dplyr)

# Criar um dataframe resumido para acessibilidade por tipo de deficiência e região
dados_resumidos <- dados_combinados_regiao %>%
  group_by(REGIAO, DS_TIPO_DEFICIENCIA) %>%
  summarise(TOTAL_ACESSIBILIDADE = sum(TOTAL_ACESSIBILIDADE, na.rm = TRUE)) %>%
  ungroup()

# Criar o gráfico
# Definindo cores para 5 regiões
cores <- c("black", "darkblue", "purple", "lightgray", "skyblue")  # Adicione mais cores conforme necessário

ggplot(dados_resumidos, aes(x = DS_TIPO_DEFICIENCIA, y = TOTAL_ACESSIBILIDADE, fill = REGIAO)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_fill_manual(values = cores) +  # Use as cores definidas
  theme_minimal() +  # Tema minimalista
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.title = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  ) +
  labs(
    title = "Comparação de Acessibilidade por Tipo de Deficiência e Região",
    x = "Tipo de Deficiência",
    y = "Total de Acessibilidade"
  )


# agr por estado

# CARREGANDO BASES 

dados_combinados_uf<- read.csv("base_def_acess_uf.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)

# Mostra as primeiras linhas do data frame
head(dados_combinados_uf)  

# Mostra a estrutura do data frame
str(dados_combinados_uf)

# Criar um dataframe resumido para acessibilidade por tipo de deficiência e estado
dados_resumidos_uf <- dados_combinados_uf %>%
  group_by(SG_UF, DS_TIPO_DEFICIENCIA) %>%
  summarise(TOTAL_ACESSIBILIDADE = sum(TOTAL_ACESSIBILIDADE, na.rm = TRUE)) %>%
  ungroup()

# Criar o gráfico para acessibilidade por tipo de deficiência e estado
# Carregar o pacote RColorBrewer
install.packages("RColorBrewer")  # Descomente se não tiver o pacote instalado
library(RColorBrewer)

# Gerar uma paleta de cores com 26 cores
cores_estados <- colorRampPalette(brewer.pal(n = 12, name = "Set3"))(26)  # Ajuste para gerar 26 cores

str(dados_resumidos_uf)  # Para verificar a estrutura do data frame

# Verifique se os pacotes estão carregados
library(ggplot2)
library(RColorBrewer)

# Gerar uma paleta de cores com 26 cores
cores_estados <- colorRampPalette(brewer.pal(n = 12, name = "Set3"))(26)  # Para 26 estados

# Criar o gráfico para acessibilidade por tipo de deficiência e estado
# Definindo a paleta de cores em tons de preto, lilás e azul marinho
cores_estados <- c("#2E2E2E",  # Preto
                   "#6A5ACD",  # Lilás
                   "#1E1E78",  # Azul marinho
                   "#4B0082",  # Lilás escuro
                   "#8A2BE2",  # Azul violeta
                   "#483D8B",  # Azul escuro
                   "#5B5B5B",  # Cinza escuro
                   "#7B68EE",  # Azul médio
                   "#9370DB",  # Azul lavanda
                   "#D8BFD8",  # Lilás claro
                   "#6A5ACD",  # Lilás
                   "#7B68EE",  # Azul médio
                   "#4B0082",  # Lilás escuro
                   "#1E1E78",  # Azul marinho
                   "#8A2BE2",  # Azul violeta
                   "#483D8B",  # Azul escuro
                   "#5B5B5B",  # Cinza escuro
                   "#D8BFD8",  # Lilás claro
                   "#2E2E2E",  # Preto
                   "#6A5ACD",  # Lilás
                   "#4B0082",  # Lilás escuro
                   "#1E1E78",  # Azul marinho
                   "#8A2BE2",  # Azul violeta
                   "#483D8B",  # Azul escuro
                   "#5B5B5B",  # Cinza escuro
                   "#9370DB",  # Azul lavanda
                   "#7B68EE",  # Azul médio
                   "#D8BFD8",  # Lilás claro
                   "#6A5ACD")  # Lilás

# Criar o gráfico para acessibilidade por tipo de deficiência e estado
ggplot(dados_resumidos_uf, aes(x = DS_TIPO_DEFICIENCIA, y = TOTAL_ACESSIBILIDADE, fill = SG_UF)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_fill_manual(values = cores_estados) +  # Use as cores definidas
  theme_minimal() +  # Tema minimalista
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.title = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  labs(
    title = "Comparação de Acessibilidade por Tipo de Deficiência e Estado",
    x = "Tipo de Deficiência",
    y = "Total de Acessibilidade"
  )
