# Entrega 3 — Limpeza de Texto e Remoção de Stopwords

## Objetivo

Nesta entrega foi realizada uma etapa inicial de **mineração de textos**, utilizando artigos da Wikipédia relacionados a três portos: **Porto de Santos, Porto de Xangai e Porto de Roterdão**.

O objetivo foi obter os textos, organizar os parágrafos, realizar uma tokenização simples, construir um vocabulário, analisar a frequência dos termos, criar uma matriz termo-documento e realizar buscas booleanas.

Nesta entrega, essas etapas foram mantidas e complementadas com uma etapa de **limpeza mais completa dos textos** (remoção de acentos e de pontuação) e com a **remoção de stopwords**, além do cálculo do **TF-IDF** e de uma **busca por similaridade** entre a consulta e os parágrafos, utilizando a similaridade de cosseno.

## Importação de bibliotecas e dados

Foram utilizadas as bibliotecas `tidytext`, `stopwords`, `httr2`, `stringr` e `dplyr`.

- `httr2`: utilizada para realizar as requisições à API da Wikipédia.
- `stringr`: utilizada para manipulação e contagem de caracteres/palavras.
- `dplyr`: utilizada para organização e transformação dos dados.
- `tidytext`: incluída como biblioteca de apoio à mineração de texto.
- `stopwords`: utilizada para obter uma lista de stopwords em português.

```r
install.packages(c("stopwords","tidytext", "stringr", "dplyr"))
```

```r
library(tidytext)    # Biblioteca para mineração de texto
library(stopwords)   # Biblioteca de listas de stopwords
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

Depois disso, os três conjuntos de textos foram unidos em uma única estrutura, com cada parágrafo armazenando também o nome do artigo de origem (`site`) e recebendo um identificador no formato:

`paragrafo1`, `paragrafo2`, `paragrafo3`, ...

```r
corpus <- lapply(seq_along(docs), function(i) {

  paragrafos <- unlist(strsplit(docs[[i]], "\n")) # Separa o texto em parágrafos
  paragrafos <- paragrafos[nchar(trimws(paragrafos)) > 0] # Tira parágrafos vazios ou só com espaços
  data.frame( # Cria uma tabela com duas colunas:
    site = titulos[i], # Nome do site/artigo
    paragrafo = paragrafos # Cada parágrafo em uma linha
  )
})

corpus <- bind_rows(corpus) # Junta todas as tabelas em uma só
head(corpus)
```

Essa organização permitiu tratar cada parágrafo como um documento individual durante as etapas seguintes, mantendo também o registro de qual artigo cada parágrafo pertence.

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

Nesta entrega, foi criada também a função `limpar()`, que realiza uma limpeza mais completa do texto de cada parágrafo antes da tokenização:

1. transforma todo o texto para letras minúsculas;
2. substitui letras acentuadas por suas versões sem acento (por exemplo, `á`, `à`, `ã` e `â` passam a ser tratadas como `a`);
3. substitui por espaço qualquer caractere que não seja letra, número ou espaço, removendo assim a pontuação;
4. colapsa sequências de dois ou mais espaços em um único espaço e remove espaços nas extremidades do texto.

```r
limpar <- function(texto) {
  texto <- tolower(texto) # 1) Tudo minusculo

  # 2) Tratamento de acentos
  texto <- gsub("[áàãâä]", "a", texto)
  texto <- gsub("[éèêë]", "e", texto)
  texto <- gsub("[íìîï]", "i", texto)
  texto <- gsub("[óòõôö]", "o", texto)
  texto <- gsub("[úùûü]", "u", texto)
  texto <- gsub("[ç]", "c", texto)

  texto <- gsub("[^a-z0-9 ]", " ", texto)  # 3) Troca por espaco tudo que não for letra, digito ou espaco

  texto <- gsub("\\s+", " ", texto) #3) Colapsa 2+ espacos em um só

  trimws(texto) # 4) Remove espaços das pontas
}
corpus$paragrafo <- limpar(corpus$paragrafo)
head(corpus)
```

Com essa limpeza, palavras que antes ficavam separadas apenas pela pontuação, como `santos,` e `santos`, passam a ser tratadas como o mesmo termo, o que melhora a qualidade do vocabulário construído nas etapas seguintes.

## Tokenização

A tokenização foi realizada por meio da função `tokenizar()`.

Como o texto já chega minúsculo e sem pontuação após a função `limpar()`, a tokenização passou a ter apenas uma etapa: separar o texto em tokens utilizando espaços em branco.

```r
tokenizar <- function(texto)
{
  unlist(strsplit(texto, "\\s+")) # Quebra o texto em palavras separadas
}

tokens <- lapply(corpus$paragrafo, tokenizar)
names(tokens) <- paste0("paragrafo-", 1:nrow(corpus)) #Renomeia o nome de cada parágrafo
head(tokens)
```

## Removendo Stopwords

Após a tokenização, foi feita a remoção das **stopwords**: palavras muito comuns da língua portuguesa (como artigos, preposições e conjunções) que aparecem com alta frequência, mas contribuem pouco para o significado dos textos.

A lista de stopwords em português foi obtida por meio do pacote `stopwords`, utilizando a fonte `stopwords-iso`. Em seguida, essas palavras foram removidas dos tokens de cada parágrafo:

```r
# Armazenando stopwords do pacote "stopwords" em uma lista
stopwords <- stopwords("pt", source = "stopwords-iso")

# Retirando as stopwords
tokens <- lapply(tokens, function(tk) tk[!tk %in% stopwords])

head(tokens)
```

Com isso, termos como `de`, `o`, `a`, `e` e `do`, que na entrega anterior dominavam o topo da lista de frequência, deixaram de fazer parte do vocabulário.

## Criação do vocabulário e frequência dos termos

Após a tokenização e a remoção das stopwords, todos os tokens restantes foram reunidos para formar o vocabulário.

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

**1.428 termos únicos** — uma redução em relação aos 1.946 termos da entrega anterior, já que a limpeza e a remoção de stopwords eliminaram variações de pontuação e palavras muito comuns.

Também foi calculada a frequência total de cada token no corpus. Os 10 termos mais frequentes foram:

| Termo | Frequência |
|---|---:|
| `porto` | 102 |
| `xangai` | 40 |
| `santos` | 34 |
| `metros` | 24 |
| `sao` | 24 |
| `conteineres` | 22 |
| `milhoes` | 22 |
| `terminais` | 20 |
| `1` | 18 |
| `cidade` | 17 |

Diferente da entrega anterior, em que os termos mais frequentes eram palavras funcionais (`de`, `o`, `a`, `e`, `do`), agora o topo da lista é ocupado por termos diretamente relacionados ao tema dos textos, como `porto`, `xangai`, `santos`, `conteineres` e `terminais`.

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

**1.428 × 75**

Portanto, a matriz possui **1.428 termos** e **75 documentos/parágrafos** após o tratamento realizado.

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

O termo `porto` foi encontrado em **56 dos 75 parágrafos** considerados na matriz.

Os documentos retornados foram:

`paragrafo-1`, `paragrafo-2`, `paragrafo-3`, `paragrafo-4`, `paragrafo-6`, `paragrafo-7`, `paragrafo-8`, `paragrafo-10`, `paragrafo-11`, `paragrafo-12`, `paragrafo-13`, `paragrafo-16`, `paragrafo-17`, `paragrafo-18`, `paragrafo-20`, `paragrafo-22`, `paragrafo-23`, `paragrafo-24`, `paragrafo-25`, `paragrafo-26`, `paragrafo-27`, `paragrafo-28`, `paragrafo-31`, `paragrafo-32`, `paragrafo-33`, `paragrafo-34`, `paragrafo-35`, `paragrafo-36`, `paragrafo-38`, `paragrafo-39`, `paragrafo-40`, `paragrafo-42`, `paragrafo-43`, `paragrafo-44`, `paragrafo-46`, `paragrafo-51`, `paragrafo-52`, `paragrafo-53`, `paragrafo-54`, `paragrafo-55`, `paragrafo-56`, `paragrafo-57`, `paragrafo-58`, `paragrafo-59`, `paragrafo-60`, `paragrafo-61`, `paragrafo-62`, `paragrafo-63`, `paragrafo-64`, `paragrafo-67`, `paragrafo-68`, `paragrafo-70`, `paragrafo-71`, `paragrafo-73`, `paragrafo-74`, `paragrafo-75`.

### Busca pelo termo `cidade`

O termo `cidade` foi encontrado em **12 parágrafos**:

`paragrafo-8`, `paragrafo-20`, `paragrafo-24`, `paragrafo-32`, `paragrafo-36`, `paragrafo-37`, `paragrafo-39`, `paragrafo-41`, `paragrafo-51`, `paragrafo-70`, `paragrafo-71` e `paragrafo-74`.

Tanto `porto` quanto `cidade` passaram a aparecer em mais parágrafos do que na entrega anterior (53 e 10, respectivamente), já que a remoção de acentos e pontuação unificou variações do mesmo termo que antes eram contadas separadamente.

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
| `porto` | 0.88 | 0.58 | 0.29 | 0.29 | 0.00 |
| `terminais` | 1.48 | 0.00 | 0.00 | 0.00 | 0.00 |
| `cidade` | 0.00 | 0.00 | 0.00 | 0.00 | 0.00 |

Como o termo `porto` aparece em muitos parágrafos, seu peso IDF é baixo, mesmo quando sua frequência é alta. Já `terminais`, por ser mais raro no corpus, recebe um peso maior quando aparece. O termo `cidade`, por sua vez, chega a atingir um peso de 3,67 no parágrafo em que aparece, refletindo sua raridade no corpus.

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
| `porto` | 0.29 |
| `santos` | 1.18 |
| `terminais` | 1.48 |

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
| paragrafo-22 | 0.2566 |
| paragrafo-53 | 0.2048 |
| paragrafo-20 | 0.2036 |
| paragrafo-1 | 0.1506 |
| paragrafo-50 | 0.1260 |
| paragrafo-6 | 0.0995 |
| paragrafo-46 | 0.0994 |
| paragrafo-44 | 0.0978 |
| paragrafo-13 | 0.0880 |
| paragrafo-15 | 0.0870 |

Diferente da busca booleana, que apenas indica se um termo está presente ou não em cada parágrafo, a busca por similaridade permite **ranquear** os parágrafos de acordo com o quão relacionados estão com a consulta como um todo, mesmo que não contenham exatamente todas as palavras pesquisadas.

## Considerações sobre os resultados

A limpeza mais completa dos textos e a remoção de stopwords alteraram de forma visível os resultados desta entrega em relação à anterior. O vocabulário caiu de 1.946 para **1.428 termos únicos**, e a lista dos 10 termos mais frequentes deixou de ser dominada por palavras funcionais como `de`, `o`, `a`, `e` e `do`, passando a ser ocupada por termos diretamente ligados ao assunto dos textos, como `porto`, `xangai`, `santos`, `conteineres` e `terminais`.

A remoção de acentos e pontuação também teve efeito direto sobre a busca booleana: o termo `porto` passou a ser encontrado em 56 dos 75 parágrafos (antes, 53), e `cidade` passou a aparecer em 12 parágrafos (antes, 10), já que variações do mesmo termo que antes eram tratadas como palavras diferentes agora são contabilizadas juntas.

O cálculo do TF-IDF, aplicado sobre esse vocabulário já limpo, manteve pesos baixos para termos amplamente distribuídos, como `porto`, e pesos mais altos para termos mais raros, como `terminais` e `cidade`. A busca por similaridade de cosseno, utilizando esses pesos, voltou a colocar `paragrafo-22` e `paragrafo-20` entre os mais relevantes para a consulta `"porto santos terminais"`, agora com escores mais altos do que na entrega anterior, refletindo o vocabulário mais limpo e concentrado em termos relevantes ao tema.

## Conclusão

Nesta entrega, o processo de mineração de textos foi refinado com a introdução de uma limpeza mais completa dos textos (remoção de acentos e pontuação) e da remoção de stopwords, além da manutenção das etapas de tokenização, criação do vocabulário, análise de frequência, construção da matriz termo-documento, busca booleana, cálculo do TF-IDF e busca por similaridade de cosseno.

Como resultado, o vocabulário ficou mais enxuto e mais representativo do conteúdo dos textos, a busca booleana passou a identificar corretamente mais ocorrências dos termos pesquisados, e a busca por similaridade de cosseno produziu um ranking mais consistente com o tema da consulta.
