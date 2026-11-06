# ==========================================================================
#  config.R  --  as decisoes do grupo Enem, para o R
#  Base: motor/config_modelo.R (fractalarea/pi3-motor-de-busca).
#  Valores: consolidados do repositorio KenjiMaeshiro/pi3-enem (Aulas 01 a 05).
#  Itens com  ⚠  nao estao decididos nos consolidados: o grupo confirma.
# ==========================================================================

cfg <- list(
  # --- Aula 01: o que e um documento ------------------------------------
  minimo = 200,                 # ⚠ o grupo filtrou por 10 PALAVRAS (Aula 01), nao por caracteres: confirmar

  # --- Aula 03: limpeza e stopwords ---------------------------------------
  limpar    = TRUE,             # usar a limpeza da Aula 03
  acentos   = "translit",       # Aula 03 removeu acentos e pontuacao (i, c, a...)
  # stopwords = c(...),         # ⚠ lista stopwords-iso pt (Aula 03), pacote stopwords; colar do R:
                                #   stopwords("pt", source = "stopwords-iso")

  # --- Aula 04: BM25 ------------------------------------------------------
  k1 = 1.2,                     # Aula 04: valor padrao da literatura
  b  = 0.75,                    # Aula 04: valor padrao da literatura

  # --- Aula 5,5: metricas -------------------------------------------------
  limiar = 2,                   # Aula 5,5: grau >= 2 conta como relevante
  juizes = "consenso",          # gabarito de consenso (qrels_consenso.csv)

  # --- Aula 06: realimentacao (DECISAO DO GRUPO, Modulo 9) ----------------
  # prf_k   = 0,                            # 0 = sem pseudo-realimentacao; k = usa os top-k
  # rocchio = c(a = 1, b = 0.75, g = 0.15), # pesos do Rocchio

  # --- Aula 07: LSA e busca hibrida (nao decidido) -----------------------
  # modelo = "bm25",                        # "bm25", "lsa" ou "hibrido"
  # lsa_k  = 20,                            # dimensoes do LSA
  # rrf_c  = 60,                            # constante da fusao RRF

  # --- Aula 08: reordenacao (nao decidido) -------------------------------
  # rerank_k = 0,                           # quantos do topo o reordenador reordena (0 = nao)
  # janela   = 3,                           # distancia maxima da proximidade ordenada

  # --- fim ----------------------------------------------------------------
  grupo = "Enem"                # ultimo campo, sem virgula depois
)
