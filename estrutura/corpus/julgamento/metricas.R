# ===============================================================
# metricas.R — Entregável 6
# ===============================================================
#
# Calcula:
# - P@k
# - R@k
# - AP por consulta
# - MAP
# - MRR
# - nDCG binário
# - nDCG graduado
#
# O gabarito deve vir de um qrels.csv com as colunas:
# consulta, documento, grau, juiz, timestamp, segundos
#
# Limiar padrão de relevância binária:
# grau >= 2
#
# Convenções:
# - Documentos fora do gabarito conhecido contam como não relevantes.
# - Consultas sem relevante conhecido retornam NA para Recall/AP/nDCG
#   quando a métrica fica indefinida.
# - Rankings menores que k mantêm denominador k em P@k.
# - A ordem em caso de empate deve ser resolvida antes de chamar estas funções.
# - A busca booleana não possui ranking natural; qualquer ordenação usada
#   para avaliá-la deve ser documentada no relatório.


# ---------------------------------------------------------------
# 1. MÉTRICAS DE UMA ÚNICA CONSULTA
# ---------------------------------------------------------------

# P@k
p_at_k <- function(ranking, relevantes, k) {
  topo <- ranking[seq_len(min(k, length(ranking)))]
  sum(topo %in% relevantes) / k
}


# R@k
r_at_k <- function(ranking, relevantes, k, total_relevantes) {
  if (total_relevantes == 0) return(NA_real_)

  topo <- ranking[seq_len(min(k, length(ranking)))]
  sum(topo %in% relevantes) / total_relevantes
}


# Average Precision (AP)
ap_query <- function(ranking, relevantes, total_relevantes) {
  if (total_relevantes == 0) return(NA_real_)

  acertos <- 0
  soma <- 0

  for (i in seq_along(ranking)) {
    if (ranking[i] %in% relevantes) {
      acertos <- acertos + 1
      soma <- soma + acertos / i
    }
  }

  soma / total_relevantes
}


# Reciprocal Rank
mrr_query <- function(ranking, relevantes) {
  pos <- which(ranking %in% relevantes)

  if (length(pos) == 0) return(0)

  1 / min(pos)
}


# DCG
dcg <- function(ranking, grau_vec, k = NULL) {
  n <- if (is.null(k)) {
    length(ranking)
  } else {
    min(k, length(ranking))
  }

  if (n == 0) return(0)

  ids <- ranking[seq_len(n)]

  rel <- ifelse(
    ids %in% names(grau_vec),
    grau_vec[ids],
    0
  )

  rel <- as.numeric(rel)

  sum(rel / log2(seq_len(n) + 1))
}


# nDCG
ndcg <- function(ranking, grau_vec, k = NULL) {
  d <- dcg(ranking, grau_vec, k)

  ideal_ordem <- names(
    sort(grau_vec, decreasing = TRUE)
  )

  id <- dcg(
    ideal_ordem,
    grau_vec,
    k
  )

  if (id == 0) return(NA_real_)

  d / id
}


# ---------------------------------------------------------------
# 2. CARREGAR E CONSOLIDAR O QRELS
# ---------------------------------------------------------------

carregar_gabarito <- function(caminho_qrels) {

  qrels <- read.csv(
    caminho_qrels,
    stringsAsFactors = FALSE
  )

  colunas_obrigatorias <- c(
    "consulta",
    "documento",
    "grau"
  )

  faltando <- setdiff(
    colunas_obrigatorias,
    names(qrels)
  )

  if (length(faltando) > 0) {
    stop(
      "Faltam colunas no qrels.csv: ",
      paste(faltando, collapse = ", ")
    )
  }

  # Se o mesmo par consulta-documento tiver mais de um julgamento,
  # usa a média arredondada como grau final para as métricas.
  agregado <- aggregate(
    grau ~ consulta + documento,
    data = qrels,
    FUN = function(x) round(mean(x))
  )

  split(
    setNames(
      agregado$grau,
      agregado$documento
    ),
    agregado$consulta
  )
}


# ---------------------------------------------------------------
# 3. MÉTRICAS DE UMA CONSULTA
# ---------------------------------------------------------------

metricas_consulta <- function(
  ranking,
  grau_vec,
  limiar = 2,
  ks = c(1, 3, 5, 10)
) {

  relevantes <- names(grau_vec)[
    grau_vec >= limiar
  ]

  total_relevantes <- length(relevantes)

  grau_bin <- as.numeric(
    grau_vec >= limiar
  )

  names(grau_bin) <- names(grau_vec)

  pk <- setNames(
    sapply(
      ks,
      function(k) {
        p_at_k(
          ranking,
          relevantes,
          k
        )
      }
    ),
    paste0("P@", ks)
  )

  rk <- setNames(
    sapply(
      ks,
      function(k) {
        r_at_k(
          ranking,
          relevantes,
          k,
          total_relevantes
        )
      }
    ),
    paste0("R@", ks)
  )

  c(
    pk,
    rk,

    AP = ap_query(
      ranking,
      relevantes,
      total_relevantes
    ),

    RR = mrr_query(
      ranking,
      relevantes
    ),

    nDCG_binario = ndcg(
      ranking,
      grau_bin
    ),

    nDCG_graduado = ndcg(
      ranking,
      grau_vec
    ),

    total_relevantes =
      total_relevantes
  )
}


# ---------------------------------------------------------------
# 4. MÉTRICAS DE TODAS AS CONSULTAS DE UM MODELO
# ---------------------------------------------------------------

metricas_todas <- function(
  rankings,
  gabarito,
  limiar = 2,
  ks = c(1, 3, 5, 10)
) {

  consultas <- names(rankings)

  linhas <- lapply(
    consultas,
    function(q) {

      grau_vec <- gabarito[[q]]

      if (is.null(grau_vec)) {
        grau_vec <- setNames(
          numeric(0),
          character(0)
        )
      }

      metricas_consulta(
        rankings[[q]],
        grau_vec,
        limiar,
        ks
      )
    }
  )

  tabela <- as.data.frame(
    do.call(rbind, linhas)
  )

  tabela <- cbind(
    consulta = consultas,
    tabela
  )

  list(
    por_consulta = tabela,

    aps_individuais =
      setNames(
        tabela$AP,
        tabela$consulta
      ),

    MAP =
      mean(
        tabela$AP,
        na.rm = TRUE
      ),

    MRR_medio =
      mean(
        tabela$RR,
        na.rm = TRUE
      ),

    nDCG_binario_medio =
      mean(
        tabela$nDCG_binario,
        na.rm = TRUE
      ),

    nDCG_graduado_medio =
      mean(
        tabela$nDCG_graduado,
        na.rm = TRUE
      )
  )
}


# ---------------------------------------------------------------
# 5. TESTE OBRIGATÓRIO
# ---------------------------------------------------------------

ranking <- c(
  "d3",
  "d1",
  "d2",
  "d4",
  "d8",
  "d6",
  "d5",
  "d7"
)

grau <- c(
  d1 = 1,
  d2 = 2,
  d3 = 2,
  d4 = 0,
  d5 = 0,
  d6 = 1,
  d7 = 0,
  d8 = 0
)

limiar_teste <- 2

relevantes_teste <- names(grau)[
  grau >= limiar_teste
]

total_relevantes_teste <-
  length(relevantes_teste)

cat(
  "=== Teste obrigatorio (Entregavel 6) ===\n"
)

cat(
  "relevantes (grau >=",
  limiar_teste,
  "):",
  relevantes_teste,
  "\n\n"
)

cat(
  "P@3            =",
  round(
    p_at_k(
      ranking,
      relevantes_teste,
      3
    ),
    3
  ),
  " | esperado 0.667\n"
)

cat(
  "AP             =",
  round(
    ap_query(
      ranking,
      relevantes_teste,
      total_relevantes_teste
    ),
    3
  ),
  " | esperado 0.833\n"
)

cat(
  "MRR            =",
  round(
    mrr_query(
      ranking,
      relevantes_teste
    ),
    3
  ),
  " | esperado 1.000\n"
)

grau_bin_teste <- as.numeric(
  grau >= limiar_teste
)

names(grau_bin_teste) <-
  names(grau)

cat(
  "nDCG binario   =",
  round(
    ndcg(
      ranking,
      grau_bin_teste
    ),
    3
  ),
  " | esperado 0.920\n"
)

cat(
  "nDCG graduado  =",
  round(
    ndcg(
      ranking,
      grau
    ),
    3
  ),
  " | esperado 0.951\n"
)
