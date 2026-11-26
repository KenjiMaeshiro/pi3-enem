# ==========================================================================
#  experimentos_frase_exata.R -- testes extras do Tema 2 da Aula 08
#  (busca por frase exata) no corpus do grupo, respondendo as perguntas
#  provaveis da apresentacao. Rode a partir da raiz do repositorio:
#     Rscript experimentos/aula08_frase_exata/experimentos_frase_exata.R
#  Usa o motor08 do curso e o config.R do grupo (motor puro, sem a camada
#  de correcao do Farol). Resultados: README.md desta pasta.
# ==========================================================================

source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor08.R",
       encoding = "UTF-8-BOM")                                    # o motor08 tem BOM no inicio
source("estrutura/codigos/config.R", encoding = "UTF-8")          # decisoes do grupo
B  <- "estrutura/banco-de-dados/"
cp <- read.csv(paste0(B, "corpus.csv"), stringsAsFactors = FALSE, fileEncoding = "UTF-8")
docs <- setNames(cp$texto, cp$id)
ix <- montar(docs, cfg)
qrels <- ler_qrels(paste0(B, "qrels_consenso.csv"), juiz = cfg$juizes)
nec <- read.csv(paste0(B, "necessidades.csv"), stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
orig <- setNames(nec$texto_consulta, nec$consulta)
R_q <- sapply(qrels, function(g) sum(g >= cfg$limiar))
dev <- intersect(names(qrels)[R_q > 0], nec$consulta[nec$conjunto == "dev"])   # as 11 consultas avaliadas

# ---------- funcoes do Tema 2 ----------
frase <- function(qt, dt) {                       # quantas vezes qt aparece colada e na ordem em dt
  if (!length(qt)) return(0)
  ini <- which(dt == qt[1])
  for (i in seq_along(qt)[-1]) ini <- intersect(ini, which(dt == qt[i]) - (i - 1))
  length(ini)
}
trecho <- function(qt, dt) {                      # maior pedaco colado / numero de termos
  n <- length(qt); m <- 0
  for (i in seq_len(n)) for (j in i:n) if (frase(qt[i:j], dt) > 0) m <- max(m, j - i + 1)
  m / n
}
maior <- function(qt, dt) {                       # o proprio maior pedaco, em texto
  n <- length(qt); best <- character(0)
  for (i in seq_len(n)) for (j in i:n)
    if (frase(qt[i:j], dt) > 0 && (j - i + 1) > length(best)) best <- qt[i:j]
  paste(best, collapse = " ")
}
reordenar <- function(rk, k, sc) {                # cabeca pelo escore; empate = ordem do estagio 1
  nm <- names(rk); k <- min(k, length(nm)); if (k == 0) return(nm)
  cab <- nm[seq_len(k)]; c(cab[order(-sc[cab])], nm[-seq_len(k)])
}
apq <- function(rk, g) unname(metricas(rk, g, cfg$limiar)["AP"])
mapa <- function(Q, est, f = NULL, k = 0) {       # MAP no dev, com ou sem reordenar
  sapply(dev, function(q) {
    rk <- est(Q[[q]]); qt <- preparar(Q[[q]], cfg)
    if (is.null(f) || k == 0) return(apq(rk, qrels[[q]]))
    sc <- sapply(ix$tokens[head(names(rk), k)], function(dt) f(qt, dt))
    apq(reordenar(rk, k, sc), qrels[[q]])
  })
}
m <- lsa(ix, cfg$lsa_k)
est <- list(bm25    = function(tx) ranking_bm25(tx, ix, cfg),
            lsa     = function(tx) ranking_lsa(tx, ix, cfg, m),
            hibrido = function(tx) rrf(ranking_bm25(tx, ix, cfg), ranking_lsa(tx, ix, cfg, m), c = cfg$rrf_c))

# ---------- 1. Frase e trecho relendo ate o corpus inteiro ----------
cat("\n== 1. Reordenar ate os 60 trechos (BM25) ==\n")
cat("BM25 sem reordenar:", round(mean(mapa(orig, est$bm25)), 3), "\n")
for (f in c("frase", "trecho")) for (k in c(3, 5, 10, 20, 40, 60))
  cat(sprintf("%-6s k=%2d MAP %.3f\n", f, k, mean(mapa(orig, est$bm25, get(f), k))))
inteira <- sapply(dev, function(q) sum(sapply(ix$tokens, function(dt) frase(preparar(orig[[q]], cfg), dt)) > 0))
cat("consultas com a frase inteira em algum dos 60 trechos:", sum(inteira > 0), "de", length(dev), "\n")

# ---------- 2. O pedaco colado mais comum ----------
cat("\n== 2. Maior pedaco colado (2+ termos) no top-10 do BM25 ==\n")
for (q in dev) {
  top <- head(names(ranking_bm25(orig[[q]], ix, cfg)), 10)
  p <- sapply(ix$tokens[top], function(dt) maior(preparar(orig[[q]], cfg), dt))
  p <- p[lengths(strsplit(p, " ")) >= 2]
  cat(q, ":", length(p), "de 10", if (length(p)) paste0("(", paste(names(table(p)), table(p), sep = " x", collapse = "; "), ")"), "\n")
}
for (fr in c("porto santos", "porto xangai", "porto roterdao"))
  cat(sprintf("'%s' colado em %d dos 60 trechos\n", fr, sum(sapply(ix$tokens, function(dt) frase(strsplit(fr, " ")[[1]], dt)) > 0)))

# ---------- 3. Consultas reescritas em forma de frase ----------
cat("\n== 3. Consultas em forma de frase (escritas so a partir da necessidade) ==\n")
nat <- c(q01 = "qual a importância econômica da movimentação de cargas nos portos",
         q04 = "como foi a construção e a expansão de novos terminais no porto",
         q06 = "como é o acesso ferroviário e rodoviário ao porto",
         q08 = "quem é a autoridade portuária que administra os portos de Santos e Xangai",
         q10 = "qual o papel do porto no desenvolvimento econômico da região",
         q11 = "qual o papel dos portos no comércio exterior, nas exportações e importações",
         q14 = "quais incêndios e acidentes aconteceram no porto de Santos",
         q15 = "qual o impacto ambiental dos incêndios no porto de Santos, com contaminação da água e morte de peixes",
         q16 = "qual é a história do crescimento do porto de Xangai",
         q17 = "como foi a construção do terminal de águas profundas de Yangshan",
         q18 = "quais são os terminais do porto de Xangai, como Wusongkou, Waigaoqiao e Yangshan")
cat("BM25 sem reordenar:", round(mean(mapa(nat, est$bm25)), 3), "\n")
for (f in c("frase", "trecho")) for (k in c(3, 10, 60))
  cat(sprintf("%-6s k=%2d MAP %.3f\n", f, k, mean(mapa(nat, est$bm25, get(f), k))))
inteira <- sapply(dev, function(q) sum(sapply(ix$tokens, function(dt) frase(preparar(nat[[q]], cfg), dt)) > 0))
cat("consultas com a frase inteira em algum dos 60 trechos:", sum(inteira > 0), "de", length(dev), "\n")

# ---------- 4. LSA e hibrido no estagio 1 ----------
cat("\n== 4. Frase e trecho com LSA e hibrido no estagio 1 ==\n")
for (mod in names(est)) {
  cat(sprintf("%-8s sozinho %.3f", mod, mean(mapa(orig, est[[mod]]))))
  for (k in c(3, 5, 10)) cat(sprintf(" | trecho k=%d %.3f", k, mean(mapa(orig, est[[mod]], trecho, k))))
  cat(sprintf(" | frase k=10 %.3f\n", mean(mapa(orig, est[[mod]], frase, 10))))
}

# ---------- 5. Busca com aspas medida no gabarito ----------
cat("\n== 5. Expressao entre aspas como filtro (BM25) ==\n")
expr <- c(q01 = "movimentacao de cargas", q06 = "acesso ferroviario", q08 = "autoridade portuaria",
          q10 = "desenvolvimento economico", q11 = "comercio exterior", q14 = "porto de santos",
          q15 = "impacto ambiental", q16 = "porto de xangai", q17 = "aguas profundas")
for (q in names(expr)) {
  g <- qrels[[q]]; rk <- ranking_bm25(orig[[q]], ix, cfg); comnota <- names(rk)[rk > 0]
  filt <- comnota[sapply(ix$tokens[comnota], function(dt) frase(preparar(expr[[q]], cfg), dt)) > 0]
  cat(sprintf("%s \"%s\": %d -> %d trechos | relevantes mantidos %d de %d | AP %.3f -> %.3f\n", q, expr[[q]],
      length(comnota), length(filt), sum((g[filt] >= cfg$limiar) %in% TRUE), sum(g >= cfg$limiar),
      apq(names(rk), g), if (length(filt)) apq(filt, g) else 0))
}

# ---------- 6. Simulacao: os nao julgados da q15 ----------
cat("\n== 6. q15 se 895fa2 e 3630de fossem relevantes (simulacao) ==\n")
g <- qrels$q15; g2 <- g
g2[grep("^doc-895fa2", names(docs), value = TRUE)] <- 2
g2[grep("^doc-3630de", names(docs), value = TRUE)] <- 2
rk <- ranking_bm25(orig[["q15"]], ix, cfg); qt <- preparar(orig[["q15"]], cfg)
for (k in c(0, 3, 5)) {
  ord <- if (k) reordenar(rk, k, sapply(ix$tokens[head(names(rk), k)], function(dt) trecho(qt, dt))) else names(rk)
  cat(sprintf("k=%d | AP com o gabarito atual %.3f | AP se os dois forem relevantes %.3f\n", k, apq(ord, g), apq(ord, g2)))
}

# ---------- 7. Rankings do R para comparar com o Farol ----------
cat("\n== 7. Exporta os 33 rankings (11 consultas x 3 modelos) para o teste R x Farol ==\n")
tab <- do.call(rbind, lapply(names(est), function(mod) do.call(rbind, lapply(dev, function(q) {
  rk <- est[[mod]](orig[[q]])
  data.frame(modelo = mod, q = q, pos = seq_along(rk), id = names(rk), score = unname(rk))
}))))
saida <- "experimentos/aula08_frase_exata/rankings_R.csv"
write.csv(tab, saida, row.names = FALSE)
cat("salvo em", saida, "\ncompare com: node experimentos/aula08_frase_exata/r_x_farol.js\n")
