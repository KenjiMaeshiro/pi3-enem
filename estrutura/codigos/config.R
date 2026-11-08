# ==========================================================================
#  config.R  --  as decisoes do grupo Enem, para o R
#  Base: motor/config_modelo.R (fractalarea/pi3-motor-de-busca).
#  Valores: consolidados do repositorio KenjiMaeshiro/pi3-enem (Aulas 01 a 05).
#  Itens com  ⚠  nao estao decididos nos consolidados: o grupo confirma.
# ==========================================================================

cfg <- list(
  # --- Aula 01: o que e um documento ------------------------------------
  minimo = 10,                  # PALAVRAS, nao caracteres: o corpus.csv usou paragrafos com >= 10 palavras (Aula 01; decidido em 07/11/2026). Nao e usado pelo motor06: o corpus esta congelado

  # --- Aula 03: limpeza e stopwords ---------------------------------------
  limpar    = TRUE,             # usar a limpeza da Aula 03
  acentos   = "translit",       # Aula 03 removeu acentos e pontuacao (i, c, a...)
  stopwords = c("de", "o", "a", "e", "um", "por", "como", "que", "da", "do"),  # lista curta da aula (07/11/2026): mantem o cosseno, BM25 MAP 0,840 -> 0,907

  # --- Aula 04: BM25 ------------------------------------------------------
  k1 = 1.2,                     # Aula 04: valor padrao da literatura
  b  = 0.75,                    # Aula 04: valor padrao da literatura

  # --- Aula 5,5: metricas -------------------------------------------------
  limiar = 2,                   # Aula 5,5: grau >= 2 conta como relevante
  juizes = "consenso",          # gabarito de consenso (qrels_consenso.csv)

  # --- Aula 06: realimentacao (decidido no Modulo 9, 07/11/2026) ---------
  prf_k   = 0,                            # 0 = sem pseudo-realimentacao: ganho pequeno no dev e drift em q08/q11
  rocchio = c(a = 1, b = 0.75, g = 0.15), # pesos do Rocchio (so valem se prf_k > 0)

  # --- Aula 07: LSA e busca hibrida (decidido no Modulo 9, 08/11/2026) --
  modelo = "bm25",                        # "bm25", "lsa" ou "hibrido": BM25, o mais confiavel (LSA so passa com k = 50)
  lsa_k  = 50,                            # dimensoes do LSA: o melhor k testado (nao usado com "bm25")
  rrf_c  = 60,                            # constante da fusao RRF (nao usada com "bm25")

  # --- Aula 08: reordenacao (decidido no Modulo 9, 08/11/2026) ---------
  rerank_k = 3,                           # reordena o top-3 do BM25 (MAP dev 0,907 -> 0,847; ver ficha, secao 6)
  janela   = 3,                           # distancia maxima da proximidade ordenada (2 e 3 empatam)

  # --- fim ----------------------------------------------------------------
  grupo = "Enem"                # ultimo campo, sem virgula depois
)
