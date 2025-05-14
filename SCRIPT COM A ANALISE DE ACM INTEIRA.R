#Carregamento de base perfil eleitor reduzida

dados_acm<- read.csv("perfil_eleitor_red.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)

# Mostrar as primeiras linhas do data frame
head(dados_acm)  

# Mostrar a estrutura do data frame
str(dados_acm)   

# Instalar e carregar pacotes utilizados
pacotes <- c("plotly", 
             "tidyverse", 
             "ggrepel",
             "knitr", "kableExtra", 
             "sjPlot", 
             "FactoMineR", 
             "amap", 
             "ade4",
             "readxl")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

#Fatoração do DF necessária para a ACM
dados_acm <- as.data.frame(unclass(dados_acm), stringsAsFactors=TRUE)

# Tabelas de contingência (todos as categorias devem possuir ao menos uma associação)
#Tipo de deficiência e gênero
sjt.xtab(var.row = dados_acm $DS_TIPO_DEFICIENCIA,
         var.col = dados_acm $DS_GENERO,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")

#Tipo de deficiência e Faixa Etária
sjt.xtab(var.row = dados_acm $DS_TIPO_DEFICIENCIA,
         var.col = dados_acm $DS_FAIXA_ETARIA,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")

#Tipo de deficiência e raça
sjt.xtab(var.row = dados_acm $DS_TIPO_DEFICIENCIA,
         var.col = dados_acm $DS_RACA_COR,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")

#Tipo de deficiência e grau de escolaridade
sjt.xtab(var.row = dados_acm $DS_TIPO_DEFICIENCIA,
         var.col = dados_acm $DS_GRAU_ESCOLARIDADE,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")


#Tipo de deficiência e estado civil
sjt.xtab(var.row = dados_acm $DS_TIPO_DEFICIENCIA,
         var.col = dados_acm $DS_ESTADO_CIVIL,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")

#Tipo de deficiência e Estado
sjt.xtab(var.row = dados_acm $DS_TIPO_DEFICIENCIA,
         var.col = dados_acm $SG_UF,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")

#Tipo de deficiência e Região
sjt.xtab(var.row = dados_acm $DS_TIPO_DEFICIENCIA,
         var.col = dados_acm $REGIAO,
         show.exp = TRUE,
         show.row.prc = TRUE,
         show.col.prc = TRUE, 
         encoding = "UTF-8")

# Como todos as categorias analisadas possuem associação, podemos aplicar a ACM
ACM <- dudi.acm(dados_acm, scannf = FALSE)

# Analisando as variâncias de cada dimensão (tirando os autovalores)
perc_variancia <- (ACM$eig / sum(ACM$eig)) * 100
paste0(round(perc_variancia,2),"%")

# Quantidade de categorias por variável
quant_categorias <- apply(dados_acm,
                          MARGIN =  2,
                          FUN = function(x) nlevels(as.factor(x)))

# Consolidando as coordenadas-padrão obtidas por meio da matriz binária (matriz de contingência
#contendo as relações entre todas as variáveis qualitativas analisadas).
#(puxando as coordenadas das 2 primeiras dimensões)

df_ACM <- data.frame(ACM$c1, Variável = rep(names(quant_categorias),
                                            quant_categorias))

# Plotando o mapa perceptual (mapa no qual a proximidade dos pontos indica a similaridade entre as categorias
# e a distância entre elas reflete a associação)
df_ACM %>%
  rownames_to_column() %>%
  rename(Categoria = 1) %>%
  ggplot(aes(x = CS1, y = CS2, label = Categoria, color = Variável)) +
  geom_point() +
  geom_label_repel() +
  geom_vline(aes(xintercept = 0), linetype = "longdash", color = "grey48") +
  geom_hline(aes(yintercept = 0), linetype = "longdash", color = "grey48") +
  labs(x = paste("Dimensão 1:", paste0(round(perc_variancia[1], 2), "%")),
       y = paste("Dimensão 2:", paste0(round(perc_variancia[2], 2), "%"))) +
  theme_bw()


str(df_ACM)

print(df_ACM)

# GERANDO UM MAPA 3D PARA VERIFICAR A PROFUNDIDADE DOS DADOS 
                          
# Criando a ACM
ACM <- dudi.acm(dados_acm, scannf = FALSE, nf = 3)

## Foram extraídas as coordenadas para 3 dimensões: nf = 3
## O intuito é plotar um gráfico tridimensional

# Analisando as variâncias de cada dimensão
perc_variancia <- (ACM$eig / sum(ACM$eig)) * 100
paste0(round(perc_variancia,2),"%")

# Quantidade de categorias por variável
quant_categorias <- apply(dados_acm,
                          MARGIN =  2,
                          FUN = function(x) nlevels(as.factor(x)))

# Consolidando as coordenadas obtidas por meio da matriz binária
df_ACM <- data.frame(ACM$c1, Variável = rep(names(quant_categorias),
                                            quant_categorias))

# Mapa perceptual em 3D (3 primeiras dimensões)
ACM_3D <- plot_ly()

# Adicionando as coordenadas
ACM_3D <- add_trace(p = ACM_3D,
                    x = df_ACM$CS1,
                    y = df_ACM$CS2,
                    z = df_ACM$CS3,
                    mode = "text",
                    text = rownames(df_ACM),
                    textfont = list(color = "blue"),
                    marker = list(color = "red"),
                    showlegend = FALSE)

ACM_3D
# ------------------------------------------
                          
# Poderíamos fazer o mapa com as coordenadas obtidas por meio da matriz de Burt

# Consolidando as coordenadas-padrão obtidas por meio da matriz de Burt
df_ACM_burt <- data.frame(ACM$co, Variável = rep(names(quant_categorias),
                                              quant_categorias))
#Salvando os DF com todas as coordenadas

write.csv(df_ACM_burt, "ACM_COORDENADAS.csv", row.names = FALSE) 

# Plotando o mapa perceptual
df_ACM_burt %>%
  rownames_to_column() %>%
  rename(Categoria = 1) %>%
  ggplot(aes(x = Comp1, y = Comp2, label = Categoria, color = Variável)) +
  geom_point() +
  geom_label_repel() +
  geom_vline(aes(xintercept = 0), linetype = "longdash", color = "grey48") +
  geom_hline(aes(yintercept = 0), linetype = "longdash", color = "grey48") +
  labs(x = paste("Dimensão 1:", paste0(round(perc_variancia[1], 2), "%")),
       y = paste("Dimensão 2:", paste0(round(perc_variancia[2], 2), "%"))) +
  theme_bw()

# É possível obter as coordenadas das observações
df_coord_obs <- ACM$li

# -- salvando os df
write.csv(df_coord_obs, "df_acm_burt.csv", row.names = FALSE) 

# Plotando o mapa perceptual para gênero
df_coord_obs %>%
  ggplot(aes(x = Axis1, y = Axis2, color = df_ACM_burt$DS_GENERO)) +
  geom_point() +
  geom_vline(aes(xintercept = 0), linetype = "longdash", color = "grey48") +
  geom_hline(aes(yintercept = 0), linetype = "longdash", color = "grey48") +
  labs(x = paste("Dimensão 1:", paste0(round(perc_variancia[1], 2), "%")),
       y = paste("Dimensão 2:", paste0(round(perc_variancia[2], 2), "%")),
       color = "Gênero") +
  theme_bw()

# plotando para faixa etária 
df_coord_obs %>%
  ggplot(aes(x = Axis1, y = Axis2, color = df_ACM_burt$DS_TIPO_DEFICIENCIA)) +
  geom_point() +
  geom_vline(aes(xintercept = 0), linetype = "longdash", color = "grey48") +
  geom_hline(aes(yintercept = 0), linetype = "longdash", color = "grey48") +
  labs(x = paste("Dimensão 1:", paste0(round(perc_variancia[1], 2), "%")),
       y = paste("Dimensão 2:", paste0(round(perc_variancia[2], 2), "%")),
       color = "DS_FAIXA_ETARIA") +
  theme_bw()

# Plotando o mapa perceptual para grau de escolaridade

df_coord_obs %>%
  ggplot(aes(x = Axis1, y = Axis2, color = dados_fat$DS_GRAU_ESCOLARIDADE)) +
  geom_point() +
  geom_vline(aes(xintercept = 0), linetype = "longdash", color = "grey48") +
  geom_hline(aes(yintercept = 0), linetype = "longdash", color = "grey48") +
  labs(x = paste("Dimensão 1:", paste0(round(perc_variancia[1], 2), "%")),
       y = paste("Dimensão 2:", paste0(round(perc_variancia[2], 2), "%")),
       color = "DS_GRAU_ESCOLARIDADE") +
  theme_bw()

# Plotando o mapa perceptual para estado civil

df_coord_obs %>%
  ggplot(aes(x = Axis1, y = Axis2, color = dados_fat$DS_ESTADO_CIVIL)) +
  geom_point() +
  geom_vline(aes(xintercept = 0), linetype = "longdash", color = "grey48") +
  geom_hline(aes(yintercept = 0), linetype = "longdash", color = "grey48") +
  labs(x = paste("Dimensão 1:", paste0(round(perc_variancia[1], 2), "%")),
       y = paste("Dimensão 2:", paste0(round(perc_variancia[2], 2), "%")),
       color = "DS_ESTADO_CIVIL") +
  theme_bw()


# Plotando o mapa perceptual para raça

df_coord_obs %>%
  ggplot(aes(x = Axis1, y = Axis2, color = dados_fat$DS_RACA_COR)) +
  geom_point() +
  geom_vline(aes(xintercept = 0), linetype = "longdash", color = "grey48") +
  geom_hline(aes(yintercept = 0), linetype = "longdash", color = "grey48") +
  labs(x = paste("Dimensão 1:", paste0(round(perc_variancia[1], 2), "%")),
       y = paste("Dimensão 2:", paste0(round(perc_variancia[2], 2), "%")),
       color = "DS_RACA_COR") +
  theme_bw()

#Salvando os DF
write.csv(acm_red_filtered, "nova_base.csv", row.names = FALSE)
