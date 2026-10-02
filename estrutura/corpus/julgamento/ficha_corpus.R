# ===============================================================
# ficha_corpus.R — Entregável 1
# Projeto Integrador III — Motor de Busca
# ===============================================================
#
# Objetivo:
# gerar uma ficha descritiva do corpus usado pelo motor de busca.
#
# O script usa apenas R base.
#
# Entrada esperada:
#   corpus.csv
#
# Colunas mínimas:
#   id
#   texto
#   fonte
#
# Observação:
# se o arquivo ainda usar a coluna "paragrafo" em vez de "texto",
# o script aceita automaticamente.


# ---------------------------------------------------------------
# 1. CARREGAR O CORPUS
# ---------------------------------------------------------------

caminho_corpus <- "corpus.csv"

if (!file.exists(caminho_corpus)) {
  stop(
    "Arquivo corpus.csv não encontrado. ",
    "Coloque ficha_corpus.R na mesma pasta do corpus.csv."
  )
}

corpus <- read.csv(
  caminho_corpus,
  stringsAsFactors = FALSE,
  fileEncoding = "UTF-8",
  check.names = FALSE
)


# ---------------------------------------------------------------
# 2. IDENTIFICAR A COLUNA DE TEXTO
# ---------------------------------------------------------------

if ("texto" %in% names(corpus)) {

  coluna_texto <- "texto"

} else if ("paragrafo" %in% names(corpus)) {

  coluna_texto <- "paragrafo"

} else {

  stop(
    "O corpus precisa possuir uma coluna chamada 'texto' ou 'paragrafo'."
  )
}


# ---------------------------------------------------------------
# 3. VERIFICAR COLUNAS ESSENCIAIS
# ---------------------------------------------------------------

colunas_obrigatorias <- c(
  "id",
  "fonte",
  coluna_texto
)

faltando <- setdiff(
  colunas_obrigatorias,
  names(corpus)
)

if (length(faltando) > 0) {
  stop(
    "Faltam colunas obrigatórias no corpus: ",
    paste(faltando, collapse = ", ")
  )
}


# ---------------------------------------------------------------
# 4. FUNÇÕES AUXILIARES
# ---------------------------------------------------------------

contar_palavras <- function(texto) {

  texto <- trimws(as.character(texto))

  if (
    is.na(texto) ||
    texto == ""
  ) {
    return(0)
  }

  palavras <- unlist(
    strsplit(
      texto,
      "\\s+"
    )
  )

  sum(
    nzchar(palavras)
  )
}


texto_tem_caractere_estranho <- function(texto) {

  if (
    is.na(texto) ||
    texto == ""
  ) {
    return(FALSE)
  }

  grepl(
    "�|Ã|Â",
    texto
  )
}


# ---------------------------------------------------------------
# 5. MEDIDAS BÁSICAS
# ---------------------------------------------------------------

texto <- corpus[[coluna_texto]]

n_documentos <- nrow(corpus)

n_ids_unicos <- length(
  unique(corpus$id)
)

ids_duplicados <- sum(
  duplicated(corpus$id)
)

textos_vazios <- sum(
  is.na(texto) |
    trimws(texto) == ""
)

fontes_vazias <- sum(
  is.na(corpus$fonte) |
    trimws(corpus$fonte) == ""
)

ids_vazios <- sum(
  is.na(corpus$id) |
    trimws(corpus$id) == ""
)


# ---------------------------------------------------------------
# 6. TAMANHO DOS DOCUMENTOS
# ---------------------------------------------------------------

n_palavras <- vapply(
  texto,
  contar_palavras,
  numeric(1)
)

n_caracteres <- nchar(
  as.character(texto)
)

resumo_palavras <- summary(
  n_palavras
)

media_palavras <- mean(
  n_palavras
)

desvio_palavras <- sd(
  n_palavras
)

q_palavras <- quantile(
  n_palavras,
  probs = c(
    0,
    0.25,
    0.50,
    0.75,
    1
  ),
  names = TRUE
)

docs_muito_curtos <- which(
  n_palavras < 10
)

docs_muito_longos <- which(
  n_palavras > 200
)


# ---------------------------------------------------------------
# 7. DISTRIBUIÇÃO POR FONTE
# ---------------------------------------------------------------

distribuicao_fontes <- sort(
  table(corpus$fonte),
  decreasing = TRUE
)


# ---------------------------------------------------------------
# 8. DUPLICAÇÃO DE TEXTO
# ---------------------------------------------------------------

texto_normalizado <- tolower(
  trimws(
    gsub(
      "\\s+",
      " ",
      as.character(texto)
    )
  )
)

duplicados_texto <- duplicated(
  texto_normalizado
)

n_textos_duplicados <- sum(
  duplicados_texto &
    texto_normalizado != ""
)


# ---------------------------------------------------------------
# 9. POSSÍVEIS PROBLEMAS DE CODIFICAÇÃO
# ---------------------------------------------------------------

codificacao_suspeita <- vapply(
  texto,
  texto_tem_caractere_estranho,
  logical(1)
)

n_codificacao_suspeita <- sum(
  codificacao_suspeita
)


# ---------------------------------------------------------------
# 10. DOCUMENTOS MAIS CURTOS E MAIS LONGOS
# ---------------------------------------------------------------

ordem_curto <- order(
  n_palavras,
  decreasing = FALSE
)

ordem_longo <- order(
  n_palavras,
  decreasing = TRUE
)

n_amostra <- min(
  5,
  n_documentos
)

mais_curtos <- corpus[
  ordem_curto[
    seq_len(n_amostra)
  ],
  c(
    "id",
    "fonte",
    coluna_texto
  ),
  drop = FALSE
]

mais_curtos$n_palavras <- n_palavras[
  ordem_curto[
    seq_len(n_amostra)
  ]
]

mais_longos <- corpus[
  ordem_longo[
    seq_len(n_amostra)
  ],
  c(
    "id",
    "fonte",
    coluna_texto
  ),
  drop = FALSE
]

mais_longos$n_palavras <- n_palavras[
  ordem_longo[
    seq_len(n_amostra)
  ]
]


# ---------------------------------------------------------------
# 11. AMOSTRA REPRODUTÍVEL
# ---------------------------------------------------------------

set.seed(42)

n_amostra_aleatoria <- min(
  10,
  n_documentos
)

idx_amostra <- sample(
  seq_len(n_documentos),
  n_amostra_aleatoria
)

amostra <- corpus[
  idx_amostra,
  c(
    "id",
    "fonte",
    coluna_texto
  ),
  drop = FALSE
]

amostra$n_palavras <- n_palavras[
  idx_amostra
]


# ---------------------------------------------------------------
# 12. IMPRIMIR A FICHA
# ---------------------------------------------------------------

cat(
  "\n==================================================\n"
)

cat(
  "FICHA DO CORPUS\n"
)

cat(
  "==================================================\n\n"
)

cat(
  "Arquivo:",
  caminho_corpus,
  "\n"
)

cat(
  "Total de documentos:",
  n_documentos,
  "\n"
)

cat(
  "IDs únicos:",
  n_ids_unicos,
  "\n"
)

cat(
  "IDs duplicados:",
  ids_duplicados,
  "\n"
)

cat(
  "IDs vazios:",
  ids_vazios,
  "\n"
)

cat(
  "Textos vazios:",
  textos_vazios,
  "\n"
)

cat(
  "Fontes vazias:",
  fontes_vazias,
  "\n\n"
)


cat(
  "---------------- TAMANHO DOS TEXTOS ----------------\n"
)

cat(
  "Média de palavras:",
  round(
    media_palavras,
    2
  ),
  "\n"
)

cat(
  "Desvio-padrão:",
  round(
    desvio_palavras,
    2
  ),
  "\n"
)

cat(
  "Mínimo:",
  q_palavras[1],
  "\n"
)

cat(
  "1º quartil:",
  q_palavras[2],
  "\n"
)

cat(
  "Mediana:",
  q_palavras[3],
  "\n"
)

cat(
  "3º quartil:",
  q_palavras[4],
  "\n"
)

cat(
  "Máximo:",
  q_palavras[5],
  "\n"
)

cat(
  "Documentos com menos de 10 palavras:",
  length(docs_muito_curtos),
  "\n"
)

cat(
  "Documentos com mais de 200 palavras:",
  length(docs_muito_longos),
  "\n\n"
)


cat(
  "---------------- DOCUMENTOS POR FONTE ----------------\n"
)

print(
  distribuicao_fontes
)

cat(
  "\n"
)


cat(
  "---------------- QUALIDADE DOS DADOS ----------------\n"
)

cat(
  "Textos duplicados:",
  n_textos_duplicados,
  "\n"
)

cat(
  "Textos com possível problema de codificação:",
  n_codificacao_suspeita,
  "\n\n"
)


cat(
  "---------------- 5 DOCUMENTOS MAIS CURTOS ----------------\n"
)

print(
  mais_curtos[
    ,
    c(
      "id",
      "fonte",
      "n_palavras"
    )
  ]
)

cat(
  "\n"
)


cat(
  "---------------- 5 DOCUMENTOS MAIS LONGOS ----------------\n"
)

print(
  mais_longos[
    ,
    c(
      "id",
      "fonte",
      "n_palavras"
    )
  ]
)

cat(
  "\n"
)


# ---------------------------------------------------------------
# 13. SALVAR AMOSTRA PARA INSPEÇÃO MANUAL
# ---------------------------------------------------------------

write.csv(
  amostra,
  "amostra_corpus.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)


# ---------------------------------------------------------------
# 14. SALVAR RESUMO EM TXT
# ---------------------------------------------------------------

saida_resumo <- capture.output({

  cat(
    "FICHA DO CORPUS\n\n"
  )

  cat(
    "Total de documentos:",
    n_documentos,
    "\n"
  )

  cat(
    "IDs únicos:",
    n_ids_unicos,
    "\n"
  )

  cat(
    "IDs duplicados:",
    ids_duplicados,
    "\n"
  )

  cat(
    "IDs vazios:",
    ids_vazios,
    "\n"
  )

  cat(
    "Textos vazios:",
    textos_vazios,
    "\n"
  )

  cat(
    "Fontes vazias:",
    fontes_vazias,
    "\n\n"
  )

  cat(
    "Média de palavras:",
    round(
      media_palavras,
      2
    ),
    "\n"
  )

  cat(
    "Mediana de palavras:",
    q_palavras[3],
    "\n"
  )

  cat(
    "Mínimo de palavras:",
    q_palavras[1],
    "\n"
  )

  cat(
    "Máximo de palavras:",
    q_palavras[5],
    "\n"
  )

  cat(
    "Documentos com menos de 10 palavras:",
    length(docs_muito_curtos),
    "\n"
  )

  cat(
    "Documentos com mais de 200 palavras:",
    length(docs_muito_longos),
    "\n\n"
  )

  cat(
    "Documentos por fonte:\n"
  )

  print(
    distribuicao_fontes
  )

  cat(
    "\nTextos duplicados:",
    n_textos_duplicados,
    "\n"
  )

  cat(
    "Possíveis problemas de codificação:",
    n_codificacao_suspeita,
    "\n"
  )
})

writeLines(
  saida_resumo,
  "ficha_corpus_resumo.txt",
  useBytes = TRUE
)


# ---------------------------------------------------------------
# 15. VERIFICAÇÃO FINAL
# ---------------------------------------------------------------

cat(
  "Arquivos gerados:\n"
)

cat(
  "- amostra_corpus.csv\n"
)

cat(
  "- ficha_corpus_resumo.txt\n"
)

cat(
  "\nFicha do corpus concluída.\n"
)
