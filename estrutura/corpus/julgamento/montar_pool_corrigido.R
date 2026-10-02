# ===============================================================
# montar_pool.R — versão corrigida e autocontida
# ===============================================================

# ---------------------------------------------------------------
# 0. VERIFICAÇÕES INICIAIS
# ---------------------------------------------------------------

objetos <- c(
  "corpus", "tdm", "tf", "w",
  "dl", "avgdl", "idf_tfidf",
  "idf_bm25", "vocab", "stopwords"
)

faltando <- objetos[!vapply(objetos, exists, logical(1), inherits = TRUE)]

if (length(faltando) > 0) {
  stop(
    paste0(
      "Execute primeiro o motor de busca. Objetos ausentes: ",
      paste(faltando, collapse = ", ")
    )
  )
}

if (!"id" %in% names(corpus)) {
  stop("O objeto corpus precisa possuir a coluna 'id'.")
}

if (any(is.na(corpus$id)) || any(trimws(corpus$id) == "")) {
  stop("Existem IDs vazios no corpus.")
}

if (anyDuplicated(corpus$id) > 0) {
  stop("Existem IDs duplicados no corpus.")
}

# ---------------------------------------------------------------
# 1. CONSULTAS
# ---------------------------------------------------------------

consultas <- c(
  q01 = "movimentacao cargas importancia economica portos",
  q02 = "movimentacao conteineres santos xangai teus",
  q03 = "historia desenvolvimento porto santos xangai roterda",
  q04 = "expansao construcao terminais porto",
  q05 = "profundidade calado dragagem portos",
  q06 = "acesso ferroviario rodoviario transporte porto",
  q07 = "tipos cargas movimentadas portos",
  q08 = "administracao autoridade portuaria santos xangai",
  q09 = "terminais portuarios capacidade infraestrutura",
  q10 = "porto desenvolvimento economico regiao",
  q11 = "porto comercio exterior exportacoes importacoes",
  q12 = "porto santos industria cubatao sao paulo",
  q13 = "historia administracao companhia docas codesp santos",
  q14 = "incendios acidentes porto santos terminais",
  q15 = "incendio porto santos impacto ambiental contaminacao peixes",
  q16 = "historia desenvolvimento crescimento porto xangai",
  q17 = "yangshan expansao terminal aguas profundas xangai",
  q18 = "terminais wusongkou waigaoqiao yangshan xangai",
  q19 = "porto roterda transporte europa alemanha reno mosa",
  q20 = "santos xangai roterda cargas conteineres"
)

# ---------------------------------------------------------------
# 2. PRÉ-PROCESSAMENTO
# ---------------------------------------------------------------

processar_consulta_pool <- function(consulta) {
  termos <- unlist(strsplit(tolower(consulta), "\\s+"))
  termos <- termos[nzchar(termos)]
  termos <- termos[!termos %in% stopwords]

  if (requireNamespace("SnowballC", quietly = TRUE)) {
    termos <- SnowballC::wordStem(termos, language = "portuguese")
  }

  termos
}

# ---------------------------------------------------------------
# 3. BUSCA BOOLEANA
# ---------------------------------------------------------------

buscar_booleano_pool <- function(consulta, k = 1) {
  termos <- processar_consulta_pool(consulta)
  termos <- termos[termos %in% rownames(tdm)]

  if (length(termos) == 0) {
    return(character(0))
  }

  conjuntos <- lapply(
    termos,
    function(t) colnames(tdm)[tdm[t, ] > 0]
  )

  ids <- Reduce(intersect, conjuntos)
  ids <- unique(ids)
  ids <- ids[ids %in% corpus$id]

  head(ids, k)
}

# ---------------------------------------------------------------
# 4. COSSENO
# ---------------------------------------------------------------

cosseno_pool <- function(a, b) {
  den <- sqrt(sum(a^2)) * sqrt(sum(b^2))

  if (!is.finite(den) || den == 0) {
    return(0)
  }

  sum(a * b) / den
}

# ---------------------------------------------------------------
# 5. TF-IDF
# ---------------------------------------------------------------

buscar_tfidf_pool <- function(consulta, k = 1) {
  termos <- processar_consulta_pool(consulta)

  q <- as.integer(
    table(
      factor(termos, levels = vocab)
    )
  )

  qw <- q * idf_tfidf

  scores <- apply(
    w,
    2,
    function(dvec) cosseno_pool(qw, dvec)
  )

  scores[!is.finite(scores)] <- 0

  if (length(scores) == 0 || max(scores) <= 0) {
    return(character(0))
  }

  ordem <- order(scores, decreasing = TRUE)
  ordem <- ordem[scores[ordem] > 0]

  ids <- colnames(w)[ordem]
  ids <- ids[ids %in% corpus$id]

  head(ids, k)
}

# ---------------------------------------------------------------
# 6. BM25
# ---------------------------------------------------------------

buscar_bm25_pool <- function(consulta, k = 1, k1 = 1.2, b = 0.75) {
  termos <- processar_consulta_pool(consulta)

  score_documento <- function(d) {
    s <- 0

    for (t in termos) {
      if (!(t %in% vocab)) {
        next
      }

      f <- tf[t, d]

      K <- k1 * (
        1 - b +
          b * dl[d] / avgdl
      )

      s <- s +
        unname(idf_bm25[t]) *
        ((f * (k1 + 1)) / (f + K))
    }

    unname(s)
  }

  scores <- vapply(
    colnames(tf),
    score_documento,
    numeric(1)
  )

  scores[!is.finite(scores)] <- 0

  if (length(scores) == 0 || max(scores) <= 0) {
    return(character(0))
  }

  ordem <- order(scores, decreasing = TRUE)
  ordem <- ordem[scores[ordem] > 0]

  ids <- colnames(tf)[ordem]
  ids <- ids[ids %in% corpus$id]

  head(ids, k)
}

# ---------------------------------------------------------------
# 7. GERAR CANDIDATOS
# ---------------------------------------------------------------

k_modelo <- 1

candidatos_por_consulta <- setNames(
  vector("list", length(consultas)),
  names(consultas)
)

for (qid in names(consultas)) {
  consulta_atual <- consultas[[qid]]

  r_bool <- buscar_booleano_pool(consulta_atual, k_modelo)
  r_tfidf <- buscar_tfidf_pool(consulta_atual, k_modelo)
  r_bm25 <- buscar_bm25_pool(consulta_atual, k_modelo)

  ids <- unique(c(r_bool, r_tfidf, r_bm25))
  ids <- ids[!is.na(ids) & nzchar(ids)]
  ids <- ids[ids %in% corpus$id]

  candidatos_por_consulta[[qid]] <- ids
}

# ---------------------------------------------------------------
# 8. MONTAR POOL
# ---------------------------------------------------------------

linhas_pool <- list()
contador <- 1

for (qid in names(candidatos_por_consulta)) {
  ids <- candidatos_por_consulta[[qid]]

  if (length(ids) == 0) {
    next
  }

  for (doc_id in ids) {
    linhas_pool[[contador]] <- data.frame(
      consulta = qid,
      documento = doc_id,
      stringsAsFactors = FALSE
    )
    contador <- contador + 1
  }
}

if (length(linhas_pool) == 0) {
  stop("Nenhum candidato foi recuperado. A pool não pôde ser criada.")
}

pool <- do.call(rbind, linhas_pool)
rownames(pool) <- NULL

# remover pares repetidos
chave <- paste(pool$consulta, pool$documento, sep = "||")
pool <- pool[!duplicated(chave), , drop = FALSE]
rownames(pool) <- NULL

# limitar a 50, se necessário
if (nrow(pool) > 50) {
  set.seed(42)
  pool <- pool[sample(seq_len(nrow(pool)), 50), , drop = FALSE]
  rownames(pool) <- NULL
}

# embaralhar a ordem final
set.seed(42)
pool <- pool[sample(seq_len(nrow(pool))), , drop = FALSE]
rownames(pool) <- NULL

# ---------------------------------------------------------------
# 9. JULGAMENTO DUPLO (20%)
# ---------------------------------------------------------------

n_duplo <- round(nrow(pool) * 0.20)

if (n_duplo > 0) {
  set.seed(2026)

  idx_duplo <- sample(
    seq_len(nrow(pool)),
    n_duplo
  )

  duplo <- pool[
    idx_duplo,
    c("consulta", "documento"),
    drop = FALSE
  ]
} else {
  duplo <- pool[
    FALSE,
    c("consulta", "documento"),
    drop = FALSE
  ]
}

# ---------------------------------------------------------------
# 10. SALVAR ARQUIVOS
# ---------------------------------------------------------------

write.csv(
  pool,
  "pool.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

write.csv(
  duplo,
  "duplo_julgamento.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

# ---------------------------------------------------------------
# 11. VERIFICAÇÃO
# ---------------------------------------------------------------

total_julgamentos <- nrow(pool) + nrow(duplo)

cat("\n===== ENTREGÁVEL 4 — VERIFICAÇÃO =====\n")
cat("Consultas previstas:", length(consultas), "\n")
cat(
  "Consultas presentes na pool:",
  length(unique(pool$consulta)),
  "\n"
)
cat("Pool principal:", nrow(pool), "julgamentos\n")
cat(
  "Julgamento duplo:",
  nrow(duplo),
  "julgamentos adicionais\n"
)
cat(
  "Total máximo de trabalho humano:",
  total_julgamentos,
  "julgamentos\n"
)
cat(
  "Tempo estimado a 20 s/julgamento:",
  round(total_julgamentos * 20 / 60, 1),
  "min\n"
)

chave_final <- paste(
  pool$consulta,
  pool$documento,
  sep = "||"
)

cat(
  "Pares consulta-documento duplicados:",
  sum(duplicated(chave_final)),
  "\n"
)

cat(
  "Documentos inexistentes no corpus:",
  sum(!pool$documento %in% corpus$id),
  "\n"
)

cat("\nItens por consulta:\n")
print(table(pool$consulta))

if (total_julgamentos > 60) {
  stop("O total de julgamentos ultrapassou 60.")
}

if (anyDuplicated(chave_final) > 0) {
  stop("Existem pares consulta-documento duplicados.")
}

if (any(!pool$documento %in% corpus$id)) {
  stop("Existem documentos da pool que não pertencem ao corpus.")
}

cat("\nOK: pool criada corretamente.\n")
cat("Arquivos gerados: pool.csv e duplo_julgamento.csv\n")
cat("Objeto pool criado em memória:", exists("pool"), "\n")
