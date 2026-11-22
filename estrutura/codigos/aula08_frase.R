# ==========================================================================
#  aula08_frase.R  --  busca por frase exata com aspas (grupo Enem)
#  Origem: Aula 08, Tema 2 (frase exata). Usa o motor08 e o config.R do grupo.
#  O que esta entre aspas na consulta tem que aparecer colado, nessa ordem.
#  NAO altera o config.R: e uma funcionalidade extra, ainda sem avaliacao.
# ==========================================================================

frase <- function(qt, dt) {                              # quantas vezes qt aparece, em sequencia, em dt
  if (length(qt) == 0) return(0)                         # consulta vazia: 0
  ini <- which(dt == qt[1])                              # inicios possiveis
  for (i in seq_along(qt)[-1])                           # para cada termo seguinte...
    ini <- intersect(ini, which(dt == qt[i]) - (i - 1))  # ...ficam os que batem
  length(ini)                                            # quantos sobraram
}

aspas <- function(consulta) {                            # os trechos entre aspas da consulta
  m <- regmatches(consulta, gregexpr('"[^"]+"', consulta))[[1]]  # cada "..." da consulta
  gsub('"', "", m)                                       # sem as aspas
}

busca_aspas <- function(consulta, ix, cfg, estagio1 = ranking_bm25) {  # o ranking com as aspas como filtro
  rk  <- estagio1(gsub('"', " ", consulta), ix, cfg)     # o estagio 1 com a consulta inteira, sem aspas
  fr  <- lapply(aspas(consulta), preparar, cfg = cfg)    # cada frase entre aspas, com a limpeza do grupo
  fr  <- fr[lengths(fr) > 0]                             # ignora frase que so tinha stopwords
  if (length(fr) == 0) return(rk)                        # sem aspas (ou vazias): o estagio 1 normal
  tem <- sapply(ix$tokens[names(rk)], function(dt)       # o documento tem TODAS as frases?
    all(sapply(fr, function(qt) frase(qt, dt) > 0)))
  rk[tem]                                                # so os que tem, na ordem do estagio 1
}

# --- exemplo ---------------------------------------------------------------
# source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor08.R",
#        encoding = "UTF-8-BOM")
# source("estrutura/codigos/config.R")
# ix <- montar(docs, cfg)
# head(busca_aspas('terminal "aguas profundas" xangai', ix, cfg))
