# ==========================================================
# 🧠 PROJETO: Perfil dos Eleitores com Deficiência no Brasil
# 🚀 Versão Final — Pronta para GitHub e Power BI
# ==========================================================

# --- 1️⃣ Carregando e preparando os dados ---
getwd()
if(!dir.exists("output")) dir.create("output")

dados_acm <- read.csv("data/perfil_eleitor_red.csv", sep = ",", header = TRUE, stringsAsFactors = TRUE)
names(dados_acm) <- toupper(names(dados_acm))
dados_acm <- na.omit(dados_acm)

# --- Pacotes ---
pacotes <- c("tidyverse", "ggrepel", "ggplot2", "sjPlot", "FactoMineR", 
             "ade4", "scales", "ggfx", "dplyr", "readxl")
invisible(lapply(pacotes, function(p) if(!require(p, character.only = TRUE)) install.packages(p)))

# --- 2️⃣ Tabelas de Contingência (exploratórias, não publicadas no README) ---
tabelas_contingencia <- list(
  genero = sjt.xtab(dados_acm$DS_TIPO_DEFICIENCIA, dados_acm$DS_GENERO),
  faixa = sjt.xtab(dados_acm$DS_TIPO_DEFICIENCIA, dados_acm$DS_FAIXA_ETARIA),
  raca  = sjt.xtab(dados_acm$DS_TIPO_DEFICIENCIA, dados_acm$DS_RACA_COR),
  esc   = sjt.xtab(dados_acm$DS_TIPO_DEFICIENCIA, dados_acm$DS_GRAU_ESCOLARIDADE),
  eciv  = sjt.xtab(dados_acm$DS_TIPO_DEFICIENCIA, dados_acm$DS_ESTADO_CIVIL),
  uf    = sjt.xtab(dados_acm$DS_TIPO_DEFICIENCIA, dados_acm$SG_UF)
)
# Exporta como HTML (para referência interna)
for (n in names(tabelas_contingencia)) {
  html_file <- paste0("output/tabela_contingencia_", n, ".html")
  cat(as.character(tabelas_contingencia[[n]]$knitr), file = html_file)
}
print(tabelas_contingencia)

# --- 3️⃣ Análise de Correspondência Múltipla (ACM) ---
ACM <- dudi.acm(dados_acm, scannf = FALSE)
perc_variancia <- (ACM$eig / sum(ACM$eig)) * 100

# Coordenadas
quant_categorias <- apply(dados_acm, 2, function(x) nlevels(as.factor(x)))
df_ACM <- data.frame(ACM$c1, Variável = rep(names(quant_categorias), quant_categorias))

# Gráfico ACM
grafico_acm <- df_ACM %>%
  rownames_to_column() %>%
  rename(Categoria = 1) %>%
  ggplot(aes(x = CS1, y = CS2, label = Categoria, color = Variável)) +
  geom_point() +
  geom_label_repel(size = 2.5) +
  geom_vline(xintercept = 0, linetype = "longdash", color = "grey48") +
  geom_hline(yintercept = 0, linetype = "longdash", color = "grey48") +
  labs(
    title = "Mapa Perceptual - Análise de Correspondência Múltipla",
    x = paste("Dimensão 1:", round(perc_variancia[1], 2), "%"),
    y = paste("Dimensão 2:", round(perc_variancia[2], 2), "%")
  ) +
  theme_bw()
print(grafico_acm)

ggsave("output/mapa_acm_perfil.png", grafico_acm, width = 10, height = 8, dpi = 300)
write.csv(df_ACM, "output/coordenadas_acm.csv", row.names = FALSE)

cat("\n\n## 🎯 Mapa Perceptual (ACM)\n![Mapa ACM](output/mapa_acm_perfil.png)\n", file = "README.md", append = TRUE)

# --- 4️⃣ Método do Cotovelo + K-means ---
set.seed(123)
wss <- sapply(1:10, function(k) kmeans(df_ACM[, c("CS1", "CS2")], centers = k, nstart = 25)$tot.withinss)

plot(1:10, wss, type = "b", pch = 19, frame = FALSE,
     xlab = "Número de Clusters (k)", ylab = "Soma dos Erros Quadrados (WSS)",
     main = "Método do Cotovelo para Definição de K", col = "#7B2CBF", lwd = 2)
png("output/metodo_cotovelo.png", width = 900, height = 600, res = 120)
plot(1:10, wss, type = "b", pch = 19, frame = FALSE,
     xlab = "Número de Clusters (k)", ylab = "Soma dos Erros Quadrados (WSS)",
     main = "Método do Cotovelo para Definição de K", col = "#7B2CBF", lwd = 2)
dev.off()

cat("\n\n## 🔹 Método do Cotovelo\n![Método do Cotovelo](output/metodo_cotovelo.png)\n", file = "README.md", append = TRUE)

ideal_clusters <- 3
kmeans_result <- kmeans(df_ACM[, c("CS1", "CS2")], centers = ideal_clusters, nstart = 25)
df_ACM$Cluster <- as.factor(kmeans_result$cluster)

# =====================================================
# 🔹 Mapa Constelação — ACM + Clusters (versão cinematográfica)
# =====================================================
# =====================================================
# 🌌 Mapa Constelação — ACM + Clusters (versão final)
# =====================================================

library(ggfx)
library(ggplot2)
library(dplyr)
library(ggrepel)

# 1️⃣ Cria df_obs com coordenadas das observações da ACM
df_obs_coords <- as.data.frame(ACM$li)
colnames(df_obs_coords)[1:2] <- c("Axis1", "Axis2")

# Remove duplicatas antigas de row_id, se houver
if ("row_id" %in% colnames(dados_acm)) {
  dados_acm <- dados_acm %>% dplyr::select(-row_id)
}
if ("row_id" %in% colnames(df_obs_coords)) {
  df_obs_coords <- df_obs_coords %>% dplyr::select(-row_id)
}

# Adiciona identificador único
df_obs_coords <- df_obs_coords %>% tibble::rownames_to_column(var = "row_id")
dados_acm <- dados_acm %>% tibble::rownames_to_column(var = "row_id")

# Junta coordenadas e base original
df_obs <- dplyr::left_join(df_obs_coords, dados_acm, by = "row_id")

# 2️⃣ Clusterização com K-means (mesmo número de clusters da ACM)
set.seed(123)
k <- 3
kmeans_obs <- kmeans(df_obs[, c("Axis1", "Axis2")], centers = k, nstart = 25)
df_obs$Cluster <- factor(kmeans_obs$cluster)

# 3️⃣ Resumo interpretativo (faixa etária, raça, tipo deficiência e UF)
variaveis_interesse <- c("DS_FAIXA_ETARIA", "DS_RACA_COR", "DS_TIPO_DEFICIENCIA", "SG_UF")

df_resumo <- df_obs %>%
  dplyr::select(all_of(variaveis_interesse), Cluster) %>%
  dplyr::group_by(Cluster) %>%
  dplyr::summarise(
    faixa = names(sort(table(DS_FAIXA_ETARIA), decreasing = TRUE))[1],
    raca  = names(sort(table(DS_RACA_COR), decreasing = TRUE))[1],
    def = {
      tab <- sort(table(DS_TIPO_DEFICIENCIA), decreasing = TRUE)
      nomes_validos <- names(tab)[!grepl("outros", tolower(names(tab)))]
      if (length(nomes_validos) > 0) nomes_validos[1] else names(tab)[1]
    },
    estados = paste(names(sort(table(SG_UF), decreasing = TRUE))[1:3], collapse = ", ")
  ) %>%
  dplyr::mutate(
    descricao = paste0(
      "Cluster ", Cluster, ": ",
      faixa, ", ", raca, ", ", tolower(def),
      " (", estados, ")"
    )
  )

# 4️⃣ Cores e centróides
cores_clusters <- c("#C77DFF", "#80ED99", "#3A86FF")

coord_rede <- df_ACM %>%
  rename(Axis1 = CS1, Axis2 = CS2, Cluster = Cluster)

coord_centroides <- coord_rede %>%
  dplyr::group_by(Cluster) %>%
  dplyr::summarise(Axis1 = mean(Axis1), Axis2 = mean(Axis2))

set.seed(123)
coord_amostra <- coord_rede %>% dplyr::slice_sample(n = min(8000, nrow(coord_rede)))

# 5️⃣ Gráfico principal (versão refinada — centróides destacadas + legenda discreta)
expand_x <- diff(range(coord_amostra$Axis1)) * 0.6
expand_y <- diff(range(coord_amostra$Axis2)) * 0.25

g_constelacao <- ggplot() +
  # Camada difusa (brilho sutil)
  with_blur(
    geom_point(data = coord_amostra,
               aes(x = Axis1, y = Axis2, color = Cluster),
               alpha = 0.25, size = 2.4),
    sigma = 6
  ) +
  # Pontos principais
  geom_point(data = coord_amostra,
             aes(x = Axis1, y = Axis2, color = Cluster),
             alpha = 0.65, size = 1.3) +
  # ✨ Centróides com destaque (camadas sobrepostas)
  # camada de brilho mais amplo
  geom_point(data = coord_centroides,
             aes(x = Axis1, y = Axis2, color = Cluster),
             size = 28, shape = 8, stroke = 1.8, alpha = 0.12) +
  # camada intermediária
  geom_point(data = coord_centroides,
             aes(x = Axis1, y = Axis2, color = Cluster),
             size = 18, shape = 8, stroke = 1.6, alpha = 0.3) +
  # camada de contorno mais intensa
  geom_point(data = coord_centroides,
             aes(x = Axis1, y = Axis2, color = Cluster),
             size = 10, shape = 8, stroke = 1.4, alpha = 0.85) +
  # núcleo central brilhante
  geom_point(data = coord_centroides,
             aes(x = Axis1, y = Axis2, color = Cluster),
             size = 6, shape = 8, stroke = 1, alpha = 1) +
  # texto da centroid
  geom_text(data = coord_centroides,
            aes(x = Axis1, y = Axis2, label = Cluster),
            color = "white", vjust = -1.2, size = 6, fontface = "bold") +
  # Tema e layout
  theme_void() +
  theme(
    plot.background = element_rect(fill = "black", color = NA),
    panel.background = element_rect(fill = "black"),
    legend.position = "none",
    plot.margin = margin(t = 1, r = 3, b = 2, l = 3, unit = "cm"),
    plot.title = element_text(color = "white", size = 20, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(color = "gray80", size = 13, hjust = 0.5, margin = margin(b = 20))
  ) +
  ggtitle("🌌 Mapa Constelação — Clusters dos Eleitores com Deficiência") +
  labs(subtitle = "Distribuição e perfis predominantes identificados via ACM + K-Means") +
  scale_color_manual(values = cores_clusters) +
  coord_cartesian(
    xlim = c(min(coord_amostra$Axis1) - expand_x, max(coord_amostra$Axis1) + expand_x),
    ylim = c(min(coord_amostra$Axis2) - expand_y, max(coord_amostra$Axis2) + expand_y),
    clip = "off"
  )


# 💬 Legenda compacta no canto inferior esquerdo
df_resumo <- df_resumo %>% filter(!is.na(descricao) & descricao != "")

x_leg <- min(coord_amostra$Axis1) - diff(range(coord_amostra$Axis1)) * 0.7
y_min <- min(coord_amostra$Axis2) - diff(range(coord_amostra$Axis2)) * 0.45
y_gap <- diff(range(coord_amostra$Axis2)) / 14  # espaçamento menor entre legendas

legendas <- data.frame(
  x = rep(x_leg, nrow(df_resumo)),
  y = y_min + (seq_len(nrow(df_resumo)) * y_gap),
  label = df_resumo$descricao,
  fill = cores_clusters[1:nrow(df_resumo)]
)

g_constelacao <- g_constelacao +
  geom_label(
    data = legendas,
    aes(x = x, y = y, label = label, fill = fill),
    color = "white",
    size = 3.1,
    fontface = "bold",
    hjust = 0,
    alpha = 0.9,
    family = "mono",
    label.padding = unit(0.15, "lines"),
    label.r = unit(0.25, "lines"),
    show.legend = FALSE
  ) +
  scale_fill_identity()

# 7️⃣ Exibe e salva
print(g_constelacao)

if(!dir.exists("output")) dir.create("output")

ggsave("output/mapa_constelacao_clusters_final.png",
       plot = g_constelacao, width = 16, height = 9, dpi = 400, bg = "black")


cat("\n\n## 🌌 Mapa Constelação — Clusters dos Eleitores com Deficiência\n",
    "![Mapa Constelação](output/mapa_constelacao_clusters_final.png)\n",
    file = "README.md", append = TRUE)


# --- 6️⃣ Composição dos Clusters ---
df_obs <- df_obs %>%
  dplyr::mutate(
    REGIAO = dplyr::case_when(
      SG_UF %in% c("AC","AM","AP","PA","RO","RR","TO") ~ "Norte",
      SG_UF %in% c("AL","BA","CE","MA","PB","PE","PI","RN","SE") ~ "Nordeste",
      SG_UF %in% c("DF","GO","MT","MS") ~ "Centro-Oeste",
      SG_UF %in% c("ES","MG","RJ","SP") ~ "Sudeste",
      SG_UF %in% c("PR","RS","SC") ~ "Sul",
      TRUE ~ "Outros"
    )
  )

tabela_clusters_regiao <- df_obs %>%
  dplyr::count(REGIAO, Cluster) %>%
  dplyr::arrange(REGIAO, Cluster)

print(tabela_clusters_regiao)


# Gráficos
# 1. Tipo de deficiência
df_tipo <- df_obs %>% group_by(Cluster, DS_TIPO_DEFICIENCIA) %>%
  summarise(Qtd = n(), .groups = "drop") %>%
  mutate(Percent = Qtd / sum(Qtd))

g_tipo <- ggplot(df_tipo, aes(x = Cluster, y = Percent, fill = DS_TIPO_DEFICIENCIA)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_y_continuous(labels = percent_format()) +
  labs(title = "Composição dos Clusters por Tipo de Deficiência", x = "Cluster", y = "Proporção", fill = "Deficiência") +
  theme_minimal(base_size = 13)
print(g_tipo)

ggsave("output/cluster_por_tipo.png", g_tipo, width = 9, height = 5, dpi = 300)
cat("\n\n## ♿ Clusters por Tipo de Deficiência\n![Cluster Tipo](output/cluster_por_tipo.png)\n", file = "README.md", append = TRUE)

# 2. Região
df_regiao <- df_obs %>% group_by(Cluster, REGIAO) %>%
  summarise(Qtd = n(), .groups = "drop") %>%
  mutate(Percent = Qtd / sum(Qtd))

g_regiao <- ggplot(df_regiao, aes(x = Cluster, y = Percent, fill = REGIAO)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_y_continuous(labels = percent_format()) +
  labs(title = "Composição dos Clusters por Região", x = "Cluster", y = "Proporção", fill = "Região") +
  theme_minimal(base_size = 13)
print(g_regiao)

ggsave("output/cluster_por_regiao.png", g_regiao, width = 9, height = 5, dpi = 300)
cat("\n\n## 🗺️ Clusters por Região\n![Cluster Região](output/cluster_por_regiao.png)\n", file = "README.md", append = TRUE)

# --- 7️⃣ Exportações finais ---
write.csv(df_obs, "output/base_completa_clusterizada.csv", row.names = FALSE)
cat("\n\n✅ Todos os gráficos e resultados foram salvos na pasta `output/` e adicionados ao README com sucesso.\n")

