# Entrega 1 — Mineração de Textos

## Objetivo

Nesta entrega foi realizada uma etapa inicial de **mineração de textos**, utilizando artigos da Wikipédia relacionados a três portos: **Porto de Santos, Porto de Xangai e Porto de Roterdão**.

O objetivo foi obter os textos, organizar os parágrafos, realizar uma tokenização simples, construir um vocabulário, analisar a frequência dos termos, criar uma matriz termo-documento e realizar buscas booleanas.

## Importação de bibliotecas e dados

Foram utilizadas as bibliotecas `tidytext`, `httr2`, `stringr` e `dplyr`.

- `httr2`: utilizada para realizar as requisições à API da Wikipédia.
- `stringr`: utilizada para manipulação e contagem de caracteres/palavras.
- `dplyr`: utilizada para organização e transformação dos dados.
- `tidytext`: incluída como biblioteca de apoio à mineração de texto.

```r
install.packages(c("tidytext", "stringr", "dplyr"))

library(tidytext)
library(httr2)
library(stringr)
library(dplyr)
```

A função `baixar_sites()` realiza uma requisição à API da Wikipédia e retorna somente o texto do artigo. Foram utilizados os seguintes títulos:

- `Porto_de_Santos`
- `Porto_de_Xangai`
- `Porto_de_Roterdão`

```r
baixar_sites <- function(titulo)
{
  request("https://pt.wikipedia.org/w/api.php") |>
    req_url_query(
      action = "query",
      prop = "extracts",
      explaintext = 1,
      format = "json",
      redirects = 1,
      titles = titulo
    ) |>
    req_perform() |>
    resp_body_json() |>
    (\(r) r$query$pages[[1]]$extract)()
}

titulos <- c(
  "Porto_de_Santos",
  "Porto_de_Xangai",
  "Porto_de_Roterdão"
)

docs <- lapply(titulos, baixar_sites)
```

Os textos retornados foram armazenados em uma lista e posteriormente organizados em um corpus.

## Organização do corpus

Os textos foram separados em parágrafos utilizando a quebra de linha como separador. Em seguida, os parágrafos vazios ou formados apenas por espaços foram removidos.

```r
corpus <- lapply(seq_along(docs), function(i) {

  paragrafos <- unlist(
    strsplit(docs[[i]], "\n")
  )

  paragrafos <- paragrafos[
    nchar(trimws(paragrafos)) > 0
  ]

  data.frame(
    paragrafo = paragrafos
  )
})

corpus <- bind_rows(corpus)
```

Depois disso, os três conjuntos de textos foram unidos em uma única estrutura, e cada parágrafo recebeu um identificador no formato:

`paragrafo1`, `paragrafo2`, `paragrafo3`, ...

```r
corpus$texto <- paste0(
  "paragrafo",
  1:nrow(corpus)
)
```

Essa organização permitiu tratar cada parágrafo como um documento individual durante as etapas seguintes.

## Limpeza dos textos

Antes da tokenização, foi feita uma filtragem dos parágrafos com base na quantidade de palavras.

Foi criada temporariamente a variável `n_palavras`, que conta os elementos separados por espaços. Foram mantidos somente os parágrafos que possuem **10 palavras ou mais**.

Após a filtragem, a variável auxiliar foi removida.

```r
corpus <- corpus |>
  mutate(
    n_palavras = str_count(paragrafo, "\\S+")
  ) |>
  filter(n_palavras >= 10) |>
  select(-n_palavras)
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
  texto <- tolower(texto)

  unlist(
    strsplit(texto, "\\s+")
  )
}

tokens <- lapply(
  corpus$paragrafo,
  tokenizar
)

names(tokens) <- paste0(
  "paragrafo-",
  1:nrow(corpus)
)
```

Assim, palavras que aparecem com letras maiúsculas e minúsculas passam a ser consideradas como o mesmo termo.

Como a separação foi feita apenas por espaços, alguns sinais de pontuação permaneceram associados aos tokens. Por exemplo, podem aparecer termos como `santos,` e `santos` como tokens diferentes.

## Criação do vocabulário e frequência dos termos

Após a tokenização, todos os tokens foram reunidos para formar o vocabulário.

O vocabulário foi criado removendo os termos repetidos e organizando os termos em ordem alfabética.

```r
vocab <- sort(
  unique(unlist(tokens))
)

length(vocab)
```

O resultado foi um vocabulário com:

**1.946 termos únicos.**

Também foi calculada a frequência total de cada token no corpus. Os 10 termos mais frequentes foram:

```r
frequencia <- table(
  unlist(tokens)
)

freq_sorted <- sort(
  frequencia,
  decreasing = TRUE
)

top10 <- head(
  freq_sorted,
  10
)

print(top10)
```

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
tdm <- sapply(tokens, function(t)
  as.integer(
    table(
      factor(t, levels = vocab)
    )
  )
)

rownames(tdm) <- vocab

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

  if (!termo %in% rownames(tdm))
    return(character(0))

  colnames(tdm)[
    tdm[termo, ] > 0
  ]
}
```

### Busca pelo termo `porto`

```r
busca_booleana("porto", tdm)
```

O termo `porto` foi encontrado em **53 dos 75 parágrafos** considerados na matriz.

Os documentos retornados foram:

`paragrafo-1`, `paragrafo-2`, `paragrafo-3`, `paragrafo-4`, `paragrafo-6`, `paragrafo-7`, `paragrafo-10`, `paragrafo-11`, `paragrafo-12`, `paragrafo-13`, `paragrafo-16`, `paragrafo-17`, `paragrafo-18`, `paragrafo-20`, `paragrafo-22`, `paragrafo-23`, `paragrafo-24`, `paragrafo-25`, `paragrafo-26`, `paragrafo-27`, `paragrafo-28`, `paragrafo-31`, `paragrafo-32`, `paragrafo-33`, `paragrafo-34`, `paragrafo-35`, `paragrafo-36`, `paragrafo-38`, `paragrafo-39`, `paragrafo-40`, `paragrafo-42`, `paragrafo-43`, `paragrafo-44`, `paragrafo-51`, `paragrafo-52`, `paragrafo-53`, `paragrafo-54`, `paragrafo-56`, `paragrafo-57`, `paragrafo-58`, `paragrafo-59`, `paragrafo-60`, `paragrafo-61`, `paragrafo-62`, `paragrafo-63`, `paragrafo-64`, `paragrafo-67`, `paragrafo-68`, `paragrafo-70`, `paragrafo-71`, `paragrafo-73`, `paragrafo-74`, `paragrafo-75`.

### Busca pelo termo `cidade`

```r
busca_booleana("cidade", tdm)
```

O termo `cidade` foi encontrado em **10 parágrafos**:

`paragrafo-8`, `paragrafo-20`, `paragrafo-24`, `paragrafo-32`, `paragrafo-36`, `paragrafo-37`, `paragrafo-39`, `paragrafo-41`, `paragrafo-51` e `paragrafo-70`.

## Considerações sobre os resultados

Os resultados mostram que o processamento conseguiu transformar os textos obtidos da Wikipédia em uma estrutura adequada para operações básicas de mineração de textos.

O vocabulário apresentou **1.946 termos únicos**, enquanto a matriz termo-documento apresentou **75 parágrafos**. Isso demonstra uma quantidade considerável de termos diferentes mesmo após a filtragem dos parágrafos menores.

A análise de frequência mostrou forte presença de palavras funcionais, principalmente `de`, `o`, `a`, `e` e `do`. Isso é esperado em textos escritos em português, mas também indica que uma análise baseada somente na frequência bruta pode ser influenciada por palavras que possuem pouca relevância temática.

O termo `porto` apresentou frequência de **92 ocorrências** e apareceu em **53 dos 75 parágrafos**, mostrando uma distribuição ampla pelo corpus e uma forte relação com o assunto dos textos analisados. Já `cidade` apareceu em apenas 10 parágrafos, indicando uma distribuição mais restrita.

Também é importante considerar uma limitação da tokenização utilizada. Como os tokens foram separados apenas por espaços, sinais de pontuação permaneceram em alguns termos. Dessa forma, uma etapa posterior de normalização poderia melhorar a qualidade do vocabulário.

Outro ponto importante é que, na construção do corpus, os parágrafos dos três artigos foram unidos em uma única estrutura e identificados sequencialmente. Assim, a análise realizada nesta entrega trabalha principalmente com os parágrafos como documentos.

## Conclusão

Nesta entrega foram realizadas as principais etapas iniciais de um processo de mineração de textos: obtenção dos dados, organização do corpus, limpeza, tokenização, criação do vocabulário, análise de frequência, construção da matriz termo-documento e busca booleana.
