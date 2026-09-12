# Entrega 2 — TF-IDF

## Objetivo

Nesta entrega foi realizada uma etapa inicial de **mineração de textos**, utilizando artigos da Wikipédia relacionados a três portos: **Porto de Santos, Porto de Xangai e Porto de Roterdão**.

O objetivo foi obter os textos, organizar os parágrafos, realizar uma tokenização simples, construir um vocabulário, analisar a frequência dos termos, criar uma matriz termo-documento e realizar buscas booleanas.

Nesta segunda entrega, essas etapas foram mantidas e complementadas com uma busca booleana capaz de considerar múltiplos termos simultaneamente, além do cálculo do **TF-IDF** e de uma **busca por similaridade** entre a consulta e os parágrafos, utilizando a similaridade de cosseno.

## Importação de bibliotecas e dados

Foram utilizadas as bibliotecas `tidytext`, `httr2`, `stringr` e `dplyr`.

- `httr2`: utilizada para realizar as requisições à API da Wikipédia.
- `stringr`: utilizada para manipulação e contagem de caracteres/palavras.
- `dplyr`: utilizada para organização e transformação dos dados.
- `tidytext`: incluída como biblioteca de apoio à mineração de texto.

```r
install.packages(c("tidytext", "stringr", "dplyr"))
```

```r
library(tidytext)    # Biblioteca para mineração de texto
library(httr2)       # Biblioteca para acesso de HTTP (scraping/APIs)
library(stringr)     # Biblioteca para manipulação de strings
library(dplyr)       # Biblioteca para manipulação de dados
```

A função `baixar_sites()` realiza uma requisição à API da Wikipédia e retorna somente o texto do artigo. Foram utilizados os seguintes títulos:

- `Porto_de_Santos`
- `Porto_de_Xangai`
- `Porto_de_Roterdão`

```r
baixar_sites <- function(titulo)
{
  request("https://pt.wikipedia.org/w/api.php") |> # API da wikipedia
  req_url_query(action = "query", prop = "extracts", explaintext = 1, format = "json", redirects = 1, titles = titulo) |> #Define os parâmetros de consulta
  req_perform() |> resp_body_json() |> # Extraindo para arquivo json
  (\(r) r$query$pages[[1]]$extract)() # Pega só o texto do artigo
}

titulos <- c("Porto_de_Santos", "Porto_de_Xangai", "Porto_de_Roterdão") # Lista de títulos
docs <- lapply(titulos, baixar_sites)
```

Os textos retornados foram armazenados em uma lista e posteriormente organizados em um corpus.

## Organização do corpus

Os textos foram separados em parágrafos utilizando a quebra de linha como separador. Em seguida, os parágrafos vazios ou formados apenas por espaços foram removidos.

Depois disso, os três conjuntos de textos foram unidos em uma única estrutura, e cada parágrafo recebeu um identificador no formato:

`paragrafo1`, `paragrafo2`, `paragrafo3`, ...

```r
corpus <- lapply(seq_along(docs), function(i) {

  paragrafos <- unlist(strsplit(docs[[i]], "\n")) # Separa o texto em parágrafos
  paragrafos <- paragrafos[nchar(trimws(paragrafos)) > 0] # Tira parágrafos vazios ou só com espaços
  data.frame( # Cria uma tabela com duas colunas:
    paragrafo = paragrafos # Cada parágrafo em uma linha
  )
})

corpus <- bind_rows(corpus) # Junta todas as tabelas em uma só
head(corpus)
```

Essa organização permitiu tratar cada parágrafo como um documento individual durante as etapas seguintes.

## Limpeza dos textos

Antes da tokenização, foi feita uma filtragem dos parágrafos com base na quantidade de palavras.

Foi criada temporariamente a variável `n_palavras`, que conta os elementos separados por espaços. Foram mantidos somente os parágrafos que possuem **10 palavras ou mais**.

Após a filtragem, a variável auxiliar foi removida.

```r
corpus <- corpus |>
  mutate(n_palavras = str_count(paragrafo, "\\S+")) |> # Conta quantas palavras tem em cada parágrafo
  filter(n_palavras >= 10) |>   # Mantém só parágrafos com 10 palavras ou mais
  select(-n_palavras) # Remove a coluna auxiliar que foi criada só para contar
```

Essa etapa reduz a presença de trechos muito curtos, que poderiam contribuir pouco para as análises de frequência e busca.

## Tokenização

A tokenização foi realizada por meio da função `tokenizar()`.

O processo possui duas etapas principais:

1. Transformação de todo o texto para letras minúsculas;
2. Separação do texto em tokens utilizando espaços em branco.

```r
tokenizar <- function(texto)
{
  texto <- tolower(texto) # 1) Tudo minusculo
  unlist(strsplit(texto, "\\s+")) # Quebra o texto em palavras separadas
}

tokens <- lapply(corpus$paragrafo, tokenizar)
names(tokens) <- paste0("paragrafo-", 1:nrow(corpus)) #Renomeia o nome de cada parágrafo
head(tokens)
```

Assim, palavras que aparecem com letras maiúsculas e minúsculas passam a ser consideradas como o mesmo termo.

Como a separação foi feita apenas por espaços, alguns sinais de pontuação permaneceram associados aos tokens. Por exemplo, podem aparecer termos como `santos,` e `santos` como tokens diferentes.

## Criação do vocabulário e frequência dos termos

Após a tokenização, todos os tokens foram reunidos para formar o vocabulário.

O vocabulário foi criado removendo os termos repetidos e organizando os termos em ordem alfabética.

```r
# Criação do vocabulário
vocab <- sort(unique(unlist(tokens))) # Junta todas as palavras, tira repetidas e ordena em ordem alfabética
length(vocab)

# Frequencia total de cada token
frequencia <- table(unlist(tokens)) # Conta quantas vezes cada palavra aparece no corpus
freq_sorted <- sort(frequencia, decreasing = TRUE) # Ordena da mais frequente para a menos frequente

top10 <- head(freq_sorted, 10)
print(top10)
```

O resultado foi um vocabulário com:

**1.946 termos únicos.**

Também foi calculada a frequência total de cada token no corpus. Os 10 termos mais frequentes foram:

| Termo | Frequência |
|---|---:|
| `de` | 442 |
| `o` | 189 |
| `a` | 181 |
| `e` | 153 |
| `do` | 127 |
| `porto` | 92 |
| `da` | 88 |
| `em` | 86 |
| `para` | 55 |
| `um` | 53 |

É possível observar que os termos mais frequentes são, em sua maioria, palavras muito comuns da língua portuguesa, como preposições, artigos e conjunções. O termo relacionado diretamente ao tema, `porto`, também apresentou frequência elevada, aparecendo **92 vezes**.

## Matriz termo-documento

Foi criada uma **matriz termo-documento (TDM)** para representar a quantidade de vezes que cada termo aparece em cada parágrafo.

Na matriz:

- cada **linha** representa um termo do vocabulário;
- cada **coluna** representa um parágrafo;
- cada célula representa a quantidade de ocorrências daquele termo no respectivo parágrafo.

```r
# linha = termo, coluna = site
tdm <- sapply(tokens, function(t)
  as.integer(table(factor(t, levels = vocab)))  # Conta quantas vezes cada palavra do vocabulário aparece
)
rownames(tdm) <- vocab # Nomeia as linhas com as palavras do vocabulário

dim(tdm)
```

A dimensão obtida foi:

**1.946 × 75**

Portanto, a matriz possui **1.946 termos** e **75 documentos/parágrafos** após o tratamento realizado.

## Busca booleana

Foi criada a função `busca_booleana()`, responsável por verificar em quais documentos um determinado termo aparece.

A função recebe um termo e a matriz termo-documento. Caso o termo exista no vocabulário, são retornados os documentos em que sua frequência é maior que zero.

```r
busca_booleana <- function(termo, tdm) {
  if (!termo %in% rownames(tdm)) return(character(0)) # Se o termo não existe no vocabulário, retorna vazio
  colnames(tdm)[tdm[termo, ] > 0] # Retorna os nomes das colunas onde o termo aparece
}
busca_booleana("porto", tdm)
busca_booleana("cidade", tdm)
```

### Busca pelo termo `porto`

O termo `porto` foi encontrado em **53 dos 75 parágrafos** considerados na matriz.

Os documentos retornados foram:

`paragrafo-1`, `paragrafo-2`, `paragrafo-3`, `paragrafo-4`, `paragrafo-6`, `paragrafo-7`, `paragrafo-10`, `paragrafo-11`, `paragrafo-12`, `paragrafo-13`, `paragrafo-16`, `paragrafo-17`, `paragrafo-18`, `paragrafo-20`, `paragrafo-22`, `paragrafo-23`, `paragrafo-24`, `paragrafo-25`, `paragrafo-26`, `paragrafo-27`, `paragrafo-28`, `paragrafo-31`, `paragrafo-32`, `paragrafo-33`, `paragrafo-34`, `paragrafo-35`, `paragrafo-36`, `paragrafo-38`, `paragrafo-39`, `paragrafo-40`, `paragrafo-42`, `paragrafo-43`, `paragrafo-44`, `paragrafo-51`, `paragrafo-52`, `paragrafo-53`, `paragrafo-54`, `paragrafo-56`, `paragrafo-57`, `paragrafo-58`, `paragrafo-59`, `paragrafo-60`, `paragrafo-61`, `paragrafo-62`, `paragrafo-63`, `paragrafo-64`, `paragrafo-67`, `paragrafo-68`, `paragrafo-70`, `paragrafo-71`, `paragrafo-73`, `paragrafo-74`, `paragrafo-75`.

### Busca pelo termo `cidade`

O termo `cidade` foi encontrado em **10 parágrafos**:

`paragrafo-8`, `paragrafo-20`, `paragrafo-24`, `paragrafo-32`, `paragrafo-36`, `paragrafo-37`, `paragrafo-39`, `paragrafo-41`, `paragrafo-51` e `paragrafo-70`.

## Cálculo do TF-IDF

Para diferenciar termos que aparecem em muitos parágrafos (e por isso são menos informativos) de termos mais raros e específicos, foi calculado o **TF-IDF** de cada termo em cada parágrafo.

- `tf` é a frequência do termo em cada parágrafo (a própria matriz termo-documento);
- `df` indica em quantos parágrafos cada termo aparece;
- `idf` é o peso da palavra, calculado como o logaritmo da razão entre o número total de parágrafos (`N`) e o `df` do termo — quanto mais raro o termo, maior o peso;
- `w` é o resultado do TF-IDF, obtido multiplicando `tf` pelo `idf`.

```r
tf  <- tdm # frequência do termo em cada parágrafo
N   <- ncol(tdm) # Número total de documentos
df  <- rowSums(tdm > 0) #  Em quantos documentos a palavra aparece
idf <- log(N / df) # Peso da palavra

w <- tf * idf  # Frequência × peso
round(w[c("porto", "terminais", "cidade"), ], 2)
```

Para os termos `porto`, `terminais` e `cidade`, os pesos TF-IDF nos primeiros parágrafos foram:

| Termo | paragrafo-1 | paragrafo-2 | paragrafo-3 | paragrafo-4 | paragrafo-5 |
|---|---:|---:|---:|---:|---:|
| `porto` | 1.04 | 0.69 | 0.35 | 0.35 | 0.00 |
| `terminais` | 1.54 | 0.00 | 0.00 | 0.00 | 0.00 |
| `cidade` | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |

Como o termo `porto` aparece em muitos parágrafos, seu peso IDF é baixo, mesmo quando sua frequência é alta. Já `terminais`, por ser mais raro no corpus, recebe um peso maior quando aparece. O termo `cidade`, por sua vez, chega a atingir um peso de 2,01 nos parágrafos em que aparece, refletindo sua raridade no corpus.

## Normalização dos vetores dos parágrafos

Para que os parágrafos pudessem ser comparados de forma justa entre si (independentemente do tamanho de cada um), os vetores de TF-IDF de cada parágrafo foram normalizados, de modo que cada parágrafo passasse a ter "tamanho" (norma) igual a 1:

```r
norm_cols <- function(m) sweep(m, 2, sqrt(colSums(m^2)), "/") # Divide cada coluna pela sua norma deixa cada documento com "tamanho 1"
wn <- norm_cols(w) # matriz TF-IDF
round(colSums(wn^2), 2)
```

Após a normalização, a soma dos quadrados dos pesos de cada parágrafo passou a ser igual a **1**, confirmando que todos os vetores de documento ficaram normalizados.

## Similaridade de cosseno e busca por ranking

Por fim, foi implementada uma busca por **similaridade**, em que uma consulta é comparada com todos os parágrafos do corpus, retornando os mais parecidos com ela — e não apenas os que contêm exatamente os termos buscados.

A similaridade entre dois vetores foi medida com o **cosseno do ângulo** entre eles:

```r
cosseno <- function(a, b) sum(a * b) / (sqrt(sum(a^2)) * sqrt(sum(b^2))) # Mede o quão parecidos dois vetores são
consulta <- "porto santos terminais"
q <- as.integer(table(factor(tokenizar(consulta), levels = vocab))) # Transforma a consulta num vetor de contagens, alinhado ao vocabulário
qw <- q * idf # Aplica o peso IDF nos termos da consulta
round(qw[qw > 0], 2) # Mostra só os termos que aparecem na consulta, com seus pesos
```

Para a consulta `"porto santos terminais"`, os pesos obtidos para cada termo foram:

| Termo | Peso |
|---|---:|
| `porto` | 0.35 |
| `santos` | 1.68 |
| `terminais` | 1.54 |

Em seguida, a similaridade de cosseno foi calculada entre a consulta e cada parágrafo do corpus, e os resultados foram ordenados do mais para o menos parecido:

```r
scores <- apply(w, 2, function(dvec) cosseno(qw, dvec)) # Calcula a similaridade da consulta com cada parágrafo
res <- sort(scores, decreasing = TRUE) # Ordena do mais parecido para o menos parecido
res_df <- data.frame( # Monta uma tabela com o resultado
  paragrafo = names(res),
  score = round(as.numeric(res), 4), # Valor da similaridade arredondado
  row.names = NULL
)
head(res_df, 10)
```

Os 10 parágrafos mais similares à consulta `"porto santos terminais"` foram:

| Parágrafo | Score |
|---|---:|
| paragrafo-22 | 0.1918 |
| paragrafo-20 | 0.1827 |
| paragrafo-6 | 0.1132 |
| paragrafo-1 | 0.1093 |
| paragrafo-13 | 0.0977 |
| paragrafo-50 | 0.0974 |
| paragrafo-8 | 0.0931 |
| paragrafo-44 | 0.0738 |
| paragrafo-26 | 0.0737 |
| paragrafo-46 | 0.0731 |

Diferente da busca booleana, que apenas indica se um termo está presente ou não em cada parágrafo, a busca por similaridade permite **ranquear** os parágrafos de acordo com o quão relacionados estão com a consulta como um todo, mesmo que não contenham exatamente todas as palavras pesquisadas — é o caso, por exemplo, de `paragrafo-6`, `paragrafo-8`, `paragrafo-44`, `paragrafo-26` e `paragrafo-46`, que aparecem entre os mais similares combinando os termos `porto`, `santos` e `terminais`, algo que a busca booleana, por comparar apenas um termo por vez, não é capaz de fazer diretamente.

## Considerações sobre os resultados

Os resultados mostram que o processamento conseguiu transformar os textos obtidos da Wikipédia em uma estrutura adequada para operações de mineração de textos que vão além da simples contagem e busca de termos.

O vocabulário apresentou **1.946 termos únicos**, enquanto a matriz termo-documento apresentou **75 parágrafos**. A análise de frequência bruta mostrou forte presença de palavras funcionais, principalmente `de`, `o`, `a`, `e` e `do`, o que é esperado em textos escritos em português, mas evidencia a limitação de usar apenas a contagem de ocorrências como medida de relevância.

O cálculo do **TF-IDF** trouxe justamente essa correção: termos muito frequentes em vários parágrafos, como `porto`, receberam pesos relativamente baixos, enquanto termos mais raros e específicos, como `terminais` e `cidade`, alcançaram pesos mais altos nos parágrafos em que aparecem, evidenciando maior relevância local. Após a normalização dos vetores de cada parágrafo, foi possível comparar os documentos de forma padronizada, independentemente do seu tamanho.

A busca booleana continua útil para verificar rapidamente se um termo específico aparece ou não em um parágrafo, como mostram os exemplos de `porto` (presente em 53 dos 75 parágrafos) e `cidade` (presente em 10 parágrafos). No entanto, ela é limitada a um termo por vez e a uma resposta binária. Já a busca por **similaridade de cosseno**, utilizando os pesos TF-IDF, permitiu comparar a consulta `"porto santos terminais"` — que combina três termos — com todos os parágrafos do corpus de uma só vez, trazendo ao topo do ranking parágrafos que não continham necessariamente todos os termos buscados, mas que ainda assim eram tematicamente relacionados.

Assim, essa abordagem se mostrou mais flexível e informativa do que a busca booleana pura, pois não se limita a uma resposta binária, mas indica um grau de relevância entre a consulta e cada parágrafo.

## Conclusão

Nesta entrega, o processo de mineração de textos foi ampliado em relação à etapa anterior. Além das etapas iniciais de obtenção dos dados, organização do corpus, limpeza, tokenização, criação do vocabulário, análise de frequência, construção da matriz termo-documento e busca booleana, foram incorporadas técnicas mais avançadas de recuperação de informação: o cálculo do TF-IDF, a normalização dos vetores de documento e a busca por similaridade de cosseno.

Essas adições permitiram passar de uma análise baseada apenas na frequência bruta e na presença ou ausência de termos para uma análise que pondera a relevância de cada termo em cada parágrafo e que ranqueia os documentos de acordo com sua semelhança com uma consulta. 
