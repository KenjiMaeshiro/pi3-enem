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

# # Criando matriz termo-documento

# linha = termo, coluna = site
tdm <- sapply(tokens, function(t)
  as.integer(table(factor(t, levels = vocab)))  # Conta quantas vezes cada palavra do vocabulário aparece
)
rownames(tdm) <- vocab # Nomeia as linhas com as palavras do vocabulário

dim(tdm)

# # Cálculo do TF-IDF

tf  <- tdm # frequência do termo em cada parágrafo
N   <- ncol(tdm) # Número total de documentos
df  <- rowSums(tdm > 0) #  Em quantos documentos a palavra aparece
idf <- log(N / df) # Peso da palavra

w <- tf * idf  # Frequência × peso
round(w[c("porto", "terminais", "cidade"), ], 2)

norm_cols <- function(m) sweep(m, 2, sqrt(colSums(m^2)), "/") # Divide cada coluna pela sua norma deixa cada documento com "tamanho 1"
wn <- norm_cols(w) # matriz TF-IDF
round(colSums(wn^2), 2)

cosseno <- function(a, b) sum(a * b) / (sqrt(sum(a^2)) * sqrt(sum(b^2))) # Mede o quão parecidos dois vetores são
consulta <- "porto santos terminais"
q <- as.integer(table(factor(tokenizar(consulta), levels = vocab))) # Transforma a consulta num vetor de contagens, alinhado ao vocabulário
qw <- q * idf # Aplica o peso IDF nos termos da consulta
round(qw[qw > 0], 2) # Mostra só os termos que aparecem na consulta, com seus pesos

scores <- apply(w, 2, function(dvec) cosseno(qw, dvec)) # Calcula a similaridade da consulta com cada parágrafo
res <- sort(scores, decreasing = TRUE) # Ordena do mais parecido para o menos parecido
res_df <- data.frame( # Monta uma tabela com o resultado
  paragrafo = names(res),
  score = round(as.numeric(res), 4), # Valor da similaridade arredondado
  row.names = NULL
)
head(res_df, 10)
