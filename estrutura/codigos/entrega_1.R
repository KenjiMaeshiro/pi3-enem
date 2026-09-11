# # Importação de bibliotecas e dados

install.packages(c("tidytext", "stringr", "dplyr"))

library(tidytext)    # Biblioteca para mineração de texto
library(httr2)       # Biblioteca para acesso de HTTP (scraping/APIs)
library(stringr)     # Biblioteca para manipulação de strings
library(dplyr)       # Biblioteca para manipulação de dados

baixar_sites <- function(titulo)
{
  request("https://pt.wikipedia.org/w/api.php") |> # API da wikipedia
  req_url_query(action = "query", prop = "extracts", explaintext = 1, format = "json", redirects = 1, titles = titulo) |> #Define os parâmetros de consulta
  req_perform() |> resp_body_json() |> # Extraindo para arquivo json
  (\(r) r$query$pages[[1]]$extract)() # Pega só o texto do artigo
}

titulos <- c("Porto_de_Santos", "Porto_de_Xangai", "Porto_de_Roterdão") # Lista de títulos
docs <- lapply(titulos, baixar_sites)
#head(docs)
#docs[[1]]

corpus <- lapply(seq_along(docs), function(i) {

  paragrafos <- unlist(strsplit(docs[[i]], "\n")) # Separa o texto em parágrafos
  paragrafos <- paragrafos[nchar(trimws(paragrafos)) > 0] # Tira parágrafos vazios ou só com espaços
  data.frame( # Cria uma tabela com duas colunas:
    texto = paste0("paragrafo-", seq_along(paragrafos)),
    paragrafo = paragrafos # Cada parágrafo em uma linha
  )
})

corpus <- bind_rows(corpus) # Junta todas as tabelas em uma só
head(corpus)

# # Limpeza dos textos

corpus <- corpus |>
  mutate(n_palavras = str_count(paragrafo, "\\S+")) |> # Conta quantas palavras tem em cada parágrafo
  filter(n_palavras >= 10) |>   # Mantém só parágrafos com 10 palavras ou mais
  select(-n_palavras) # Remove a coluna auxiliar que foi criada só para contar

# # Tokenizar

tokenizar <- function(texto)
{
  texto <- tolower(texto) # 1) Tudo minusculo
  unlist(strsplit(texto, "\\s+")) # Quebra o texto em palavras separadas
}

tokens <- lapply(corpus$paragrafo, tokenizar)
names(tokens) <- paste0("paragrafo-", 1:nrow(corpus)) #Renomeia o nome de cada parágrafo
head(tokens)

# # Criando vocabulário e a frequencia total

# Criação do vocabulário
vocab <- sort(unique(unlist(tokens))) # Junta todas as palavras, tira repetidas e ordena em ordem alfabética
length(vocab)


# Frequencia total de cada token
frequencia <- table(unlist(tokens)) # Conta quantas vezes cada palavra aparece no corpus
freq_sorted <- sort(frequencia, decreasing = TRUE) # Ordena da mais frequente para a menos frequente

top10 <- head(freq_sorted, 10)
print(top10)
