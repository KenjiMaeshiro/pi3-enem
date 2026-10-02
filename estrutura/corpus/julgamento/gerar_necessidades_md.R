# ===============================================================
# gerar_necessidades_md.R
# Gera o Entregável 2 a partir de necessidades.csv + pool atual
# ===============================================================
#
# Execute DEPOIS de gerar a pool com os IDs estáveis doc-...
#
# Este script NÃO julga relevância.
# Os "indícios" são somente IDs de documentos recuperados para a consulta,
# usados para demonstrar que a consulta foi construída sobre conteúdo do corpus.

if (!exists("pool")) {
  stop("Objeto 'pool' não encontrado. Rode primeiro o montar_pool.R.")
}

if (!all(c("consulta", "documento") %in% names(pool))) {
  stop("A pool precisa ter as colunas consulta e documento.")
}

necessidades <- read.csv(
  "necessidades.csv",
  stringsAsFactors = FALSE,
  fileEncoding = "UTF-8"
)

obrigatorias <- c(
  "consulta",
  "texto_consulta",
  "necessidade",
  "escopo"
)

faltando <- setdiff(
  obrigatorias,
  names(necessidades)
)

if (length(faltando) > 0) {
  stop(
    "Faltam colunas em necessidades.csv: ",
    paste(faltando, collapse = ", ")
  )
}

linhas <- c(
  "# Necessidades de Informação",
  "",
  "As necessidades abaixo são usadas no experimento de avaliação do motor de busca.",
  "Os IDs indicados em **Indícios** são documentos recuperados pelo sistema e servem apenas para demonstrar que há conteúdo do corpus associado ao tema. **Eles não constituem julgamento de relevância.**",
  ""
)

for (i in seq_len(nrow(necessidades))) {

  qid <- necessidades$consulta[i]

  ids <- unique(
    pool$documento[
      pool$consulta == qid
    ]
  )

  # No máximo 3 indícios por consulta para manter o arquivo legível.
  ids <- head(ids, 3)

  texto_indicios <- if (length(ids) == 0) {
    "(nenhum documento recuperado — revisar consulta)"
  } else {
    paste(ids, collapse = ", ")
  }

  linhas <- c(
    linhas,
    paste0("## ", qid),
    "",
    paste0("**Necessidade:** ", necessidades$necessidade[i]),
    "",
    paste0("**Consulta:** `", necessidades$texto_consulta[i], "`"),
    "",
    paste0("**Escopo:** ", necessidades$escopo[i]),
    "",
    paste0("**Indícios:** ", texto_indicios, " *(não são julgamentos)*"),
    ""
  )
}

writeLines(
  linhas,
  "necessidades.md",
  useBytes = TRUE
)

cat("\n===== ENTREGÁVEL 2 =====\n")
cat("Necessidades:", nrow(necessidades), "\n")
cat("Consultas presentes na pool:", length(unique(pool$consulta)), "\n")
cat("Arquivo criado: necessidades.md\n")
