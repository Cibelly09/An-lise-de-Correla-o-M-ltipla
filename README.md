<p align="center">
  <img src="https://img.shields.io/badge/Status-Concluído-success?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Linguagem-R-blue?style=for-the-badge&logo=r"/>
  <img src="https://img.shields.io/badge/Método-ACM%20(FactoMineR)-purple?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Tipo%20de%20Projeto-Análise%20Exploratória-orange?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Ano-2025-lightgrey?style=for-the-badge"/>
</p>

---

<h1 align="center">🗳️ Análise de Correspondência Múltipla (ACM) — Perfil dos Eleitores com Deficiência no Brasil</h1>

<p align="center">
  <i>Projeto desenvolvido durante o MBA em Data Science e Analytics</i><br>
  <i>Explorando dados eleitorais para compreender padrões sociodemográficos e regionais</i>
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/cibellyviegas" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-Cibelly%20Viegas-blue?style=flat&logo=linkedin"/>
  </a>
  <a href="mailto:cibelly.viegas@gmail.com">
    <img src="https://img.shields.io/badge/Contato-Email-red?style=flat&logo=gmail"/>
  </a>
  <img src="https://img.shields.io/badge/Portfólio-Finalizado-success?style=flat"/>
</p>

---

<h1 align="center">🗳️ Análise de Correspondência Múltipla (ACM) — Perfil dos Eleitores com Deficiência no Brasil</h1>

<p align="center">
  <i>Projeto desenvolvido durante o MBA em Data Science e Analytics</i><br>
  <i>Explorando dados eleitorais para compreender padrões sociodemográficos</i>
</p>

---

## 🎯 Objetivo

Este projeto analisa o perfil dos **eleitores com deficiência no Brasil**, considerando variáveis como:

> 🧓 Faixa etária · 💍 Estado civil · 🧬 Raça · 🚻 Gênero · 🗺️ Estado · 🌎 Região  

A técnica de **Análise de Correspondência Múltipla (ACM)** foi utilizada para identificar **associações e agrupamentos entre variáveis categóricas**, possibilitando compreender como o perfil dos eleitores varia por região e estado.

---

## 🧠 Metodologia

A **ACM** é uma técnica **não supervisionada** voltada para dados **qualitativos**, ideal para revelar padrões de associação entre categorias.  

Etapas aplicadas:

1. 🧹 **Limpeza e preparação dos dados**  
2. 🔢 **Construção de tabelas de contingência**  
3. 🧮 **Teste Qui-Quadrado (χ²)** para detectar associações significativas  
4. 🎨 **Aplicação da ACM** (com `FactoMineR` e `factoextra`)  
5. 🗺️ **Visualização dos agrupamentos** e interpretação dos eixos fatoriais  

---

## 📊 Principais Resultados

✅ Identificação de **grupos de estados com perfis eleitorais semelhantes**  
✅ Fortes associações entre **região geográfica e características sociodemográficas**  
✅ Evidência de **diferenças entre Norte/Nordeste e Sul/Sudeste**  
✅ Visualização intuitiva dos perfis a partir de **mapas perceptuais**

---

## 🧰 Tecnologias e Ferramentas

| Categoria | Ferramentas |
|------------|--------------|
| **Linguagem** | R |
| **Principais pacotes** | `FactoMineR`, `factoextra`, `dplyr`, `ggplot2` |
| **Etapas** | Limpeza, Contingência, ACM, Visualização |
| **Ambiente** | RStudio |

---

## 📁 Estrutura do Projeto

| Pasta | Descrição |
|--------|------------|
| 📂 **data/** | Bases de dados tratadas e limpas utilizadas na análise |
| 📂 **script/** | Scripts em R com a lógica de limpeza, cruzamento e análise |
| 📂 **output/** | Mapas perceptuais, gráficos e resultados finais |
| ⚙️ **.gitignore** | Lista de arquivos ignorados no versionamento |
| 📜 **README.md** | Documentação do projeto |
| 🧠 **PROJECT_OFICIAL.Rproj** | Projeto RStudio principal |

---

## 🌐 Resultados Visuais

Exemplo de mapa perceptual gerado:  

![Mapa ACM](output/mapa_acm_perfil.png)

---

## 🔍 Insights Analíticos

A partir da Análise de Correspondência Múltipla (ACM), foi possível observar **padrões relevantes de associação** entre as variáveis sociodemográficas e a distribuição dos eleitores com deficiência no Brasil.  

### 🧩 Principais Descobertas

1. **Diferenças regionais marcantes**  
   - Estados do **Sul e Sudeste** apresentaram perfis semelhantes, com maior escolaridade e predominância de deficiência visual.  
   - Já no **Norte e Nordeste**, há maior proporção de eleitores com deficiência física ou de locomoção, com menor nível de escolaridade e maior concentração nas faixas etárias acima de 45 anos.  

2. **Associação entre tipo de deficiência e faixa etária**  
   - Deficiências auditivas se destacaram em faixas etárias mais elevadas.  
   - Deficiências intelectuais e múltiplas aparecem mais entre os grupos jovens.

3. **Influência do estado civil e gênero**  
   - Pessoas casadas e do sexo masculino concentraram maior incidência de deficiências de locomoção.  
   - Mulheres apresentaram maior presença entre as deficiências visuais e auditivas.  

4. **Relação com acessibilidade dos locais de votação**  
   - Estados com menor índice de acessibilidade nos locais de votação também apresentaram menor registro de eleitores com deficiência, indicando possíveis barreiras de acesso ao processo eleitoral.

---

## 📈 Conclusão

A Análise de Correspondência Múltipla mostrou-se uma ferramenta poderosa para **entender o comportamento e a distribuição dos eleitores com deficiência** no Brasil, revelando desigualdades regionais e sociais ainda existentes.  

Esses achados podem contribuir para políticas públicas voltadas à **acessibilidade eleitoral e inclusão social**, fornecendo um diagnóstico estatístico e visual do cenário brasileiro.  

---

⭐ *Projeto desenvolvido por **Cibelly Viegas**, durante o MBA em Data Science e Analytics — 2025.*

---

## ✨ Autoria

📍 **Cibelly Viegas**  
MBA em Data Science e Analytics  
📅 2025  

---

⭐ *Se gostou do projeto, não esqueça de deixar um star no repositório!*  
