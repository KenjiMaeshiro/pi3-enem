# ===============================================================
# concordancia.R — Entregável 7
# ===============================================================
#
# Calcula o kappa de Cohen sobre os itens julgados por dois juízes.
#
# Entrada esperada:
# um data.frame ou CSV consolidado com as colunas:
# consulta, documento, grau, juiz, timestamp, segundos
#
# Saída:
# - número de itens julgados em duplicata
# - matriz de confusão 3x3
# - concordância observada (po)
# - concordância esperada ao acaso (pe)
# - kappa de Cohen
# - lista de discordâncias


# ---------------------------------------------------------------
# 1. KAPPA DE COHEN
# ---------------------------------------------------------------

kappa_cohen <- function(a, b, categorias = c(0, 1, 2)) {

  a <- factor(a, levels = categorias)
  b <- factor(b, levels = categorias)

  matriz <- table(
    juiz1 = a,
    juiz2 = b
  )

  n <- sum(matriz)

  if (n == 0) {
    stop("Não há itens suficientes para calcular o kappa.")
  }

  po <- sum(diag(matriz)) / n

  pa <- rowSums(matriz) / n
  pb <- colSums(matriz) / n

  pe <- sum(pa * pb)

  if (pe == 1) {
    kappa <- NA_real_
  } else {
    kappa <- (po - pe) / (1 - pe)
  }

  list(
    kappa = kappa,
    po = po,
    pe = pe,
    matriz_confusao = matriz,
    n = n
  )
}


# ---------------------------------------------------------------
# 2. MONTAR PARES JULGADOS POR DOIS JUÍZES
# ---------------------------------------------------------------

montar_pares_duplos <- function(qrels_todos) {

  colunas_obrigatorias <- c(
    "consulta",
    "documento",
    "grau",
    "juiz"
  )

  faltando <- setdiff(
    colunas_obrigatorias,
    names(qrels_todos)
  )

  if (length(faltando) > 0) {
    stop(
      "Faltam colunas no arquivo de julgamentos: ",
      paste(faltando, collapse = ", ")
    )
  }

  chave <- paste(
    qrels_todos$consulta,
    qrels_todos$documento,
    sep = "||"
  )

  por_item <- split(
    qrels_todos,
    chave
  )

  pares <- lapply(
    por_item,
    function(df) {

      juizes_unicos <- unique(df$juiz)

      if (length(juizes_unicos) < 2) {
        return(NULL)
      }

      if (length(juizes_unicos) > 2) {
        warning(
          "Item ",
          df$consulta[1],
          "/",
          df$documento[1],
          " tem mais de 2 juízes. Serão usados os 2 primeiros."
        )

        juizes_unicos <- juizes_unicos[1:2]
      }

      g1 <- df$grau[
        df$juiz == juizes_unicos[1]
      ][1]

      g2 <- df$grau[
        df$juiz == juizes_unicos[2]
      ][1]

      data.frame(
        consulta = df$consulta[1],
        documento = df$documento[1],
        juiz1 = juizes_unicos[1],
        grau1 = g1,
        juiz2 = juizes_unicos[2],
        grau2 = g2,
        stringsAsFactors = FALSE
      )
    }
  )

  pares <- pares[
    !vapply(
      pares,
      is.null,
      logical(1)
    )
  ]

  if (length(pares) == 0) {
    stop(
      "Nenhum item foi julgado por 2 juízes diferentes."
    )
  }

  do.call(
    rbind,
    pares
  )
}


# ---------------------------------------------------------------
# 3. RODAR A ANÁLISE COMPLETA
# ---------------------------------------------------------------

concordancia <- function(qrels_todos) {

  pares <- montar_pares_duplos(
    qrels_todos
  )

  resultado <- kappa_cohen(
    pares$grau1,
    pares$grau2
  )

  discordancias <- pares[
    pares$grau1 != pares$grau2,
    ,
    drop = FALSE
  ]

  list(
    n_itens_duplos =
      nrow(pares),

    matriz_confusao =
      resultado$matriz_confusao,

    po =
      resultado$po,

    pe =
      resultado$pe,

    kappa =
      resultado$kappa,

    discordancias =
      discordancias[
        order(discordancias$consulta),
        ,
        drop = FALSE
      ]
  )
}


# ---------------------------------------------------------------
# 4. INTERPRETAÇÃO DO KAPPA
# ---------------------------------------------------------------

interpretar_kappa <- function(k) {

  if (is.na(k)) {
    return(
      "Kappa indefinido. Verifique se houve variação nas categorias usadas pelos juízes."
    )
  }

  if (k < 0.4) {
    return(
      "kappa < 0.4: guia de julgamento ambíguo. Reescrever o guia e rejulgar antes de seguir."
    )
  }

  if (k < 0.6) {
    return(
      "0.4 <= kappa < 0.6: aceitável para trabalho de disciplina, mas registrar como limitação no relatório."
    )
  }

  "kappa >= 0.6: bom."
}


# ---------------------------------------------------------------
# 5. FUNÇÃO PARA LER UM CSV CONSOLIDADO
# ---------------------------------------------------------------

analisar_concordancia_csv <- function(caminho_csv) {

  qrels_todos <- read.csv(
    caminho_csv,
    stringsAsFactors = FALSE,
    fileEncoding = "UTF-8"
  )

  resultado <- concordancia(
    qrels_todos
  )

  cat("\n===== CONCORDÂNCIA ENTRE JUÍZES =====\n")
  cat(
    "Itens julgados por dois juízes:",
    resultado$n_itens_duplos,
    "\n\n"
  )

  cat("Matriz de confusão:\n")
  print(
    resultado$matriz_confusao
  )

  cat(
    "\npo =",
    round(resultado$po, 3),
    "\n"
  )

  cat(
    "pe =",
    round(resultado$pe, 3),
    "\n"
  )

  cat(
    "kappa =",
    round(resultado$kappa, 3),
    "\n"
  )

  cat(
    "\nInterpretação:",
    interpretar_kappa(resultado$kappa),
    "\n"
  )

  cat("\nDiscordâncias:\n")
  print(
    resultado$discordancias
  )

  invisible(resultado)
}


# ---------------------------------------------------------------
# 6. TESTE DA FÓRMULA
# ---------------------------------------------------------------

a_teste <- c(
  0, 0, 0, 0,
  1, 1, 1, 1,
  2, 2
)

b_teste <- c(
  0, 0, 0, 1,
  0, 1, 1, 2,
  1, 2
)

r_teste <- kappa_cohen(
  a_teste,
  b_teste
)

cat(
  "=== Teste da fórmula do kappa ===\n"
)

print(
  r_teste$matriz_confusao
)

cat(
  "po =",
  round(r_teste$po, 3),
  " pe =",
  round(r_teste$pe, 3),
  " kappa =",
  round(r_teste$kappa, 3),
  " (esperado 0.375)\n"
)
