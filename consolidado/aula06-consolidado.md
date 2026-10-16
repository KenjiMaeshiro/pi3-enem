# Consolidado — PI III — Aula 06 — 2026-10-16
*guia versão 1 · tutora: Claude · sessão individual (teoria) · motor06*
**Aluno:** Lucas Murinelly Feliciano

## 1. O que foi passado
- M1 — o ciclo de realimentação; $D_r$ e $D_{nr}$ no ranking do cosseno
- M2 — a consulta como vetor; centroide; `rowMeans`, `drop = FALSE`
- M3 — a fórmula de Rocchio; `modelo` = 2,426 à mão; expansão: 3 → 21 termos
- M4 — o novo ranking; cosseno negativo; AP $0{,}5 \to 1$
- M5 — coleção residual: `NA` com limiar 2, empate com limiar 1
- M6 — pseudo-realimentação; $k = 2$ (AP $0{,}833$) × $k = 3$ (AP $0{,}750$): *drift*; $k = 1$ (AP $0{,}417$)

Os seis módulos foram percorridos.

## 2. Como foi o aprendizado — opinião da tutora
Percorremos os seis módulos. Você fez bem o que exigia raciocinar sobre o resultado: previu o `d4` no fim do ranking, entendeu que o cosseno negativo vem dos pesos negativos que o $\gamma$ cria (e não de um bug), concluiu sozinho que "o Rocchio só usou o gabarito" e identificou o `recuperacao` como a ponte do *drift* com $k = 1$. Refez o AP de $0{,}833$ e de $0{,}417$ à mão, de ponta a ponta.

As dificuldades ficaram nas contas e nas definições. Precisei repetir a fórmula do AP (precisão na posição de cada relevante, depois a média), o que é o limiar, o centroide e o nDCG. Seus palpites antes de rodar erraram várias vezes: AP $2/3$ no ranking do Rocchio, "empata" no cenário com só `d3` marcado (deu $0{,}5 \to 1$), "fica igual" na PRF com $k = 2$ (subiu para $0{,}833$). Quase sempre a conta passo a passo corrigiu o palpite. Ao montar a coleção residual, você incluiu `d3` e esqueceu `d8`. No $k = 3$, acertou a direção (o AP cai), mas atribuiu a queda a "ver mais arquivos", e o motivo é o `d4` entrar em $D_r$. O Colab reiniciou no meio e perdemos `ix`, `q0`, `qm` e as duas funções; reconstruímos tudo. Entreguei a conta de `modelo` com $\beta = 0{,}5$ ($2{,}079$) depois de segurar uma vez.

**Teste final:** acertou M4; a revisar M1, M2, M3, M5 e M6.
- M1: $D_r$ certo, mas pôs `d1` em $D_{nr}$ (grau 1 fica sem marca).
- M2: dividiu sem somar antes ($0{,}693$ em vez de $1{,}386$).
- M3: conta entregue por mim.
- M5: não chegou à objeção (medir nos marcados é otimista) nem à coleção residual.
- M6: previu AP baixo, mas sem o porquê ($k = 10$ com ~3 relevantes enche $D_r$ de irrelevantes).

## 3. Observações para a frente
- **Revisar antes da Aula 07:** as contas à mão (centroide: somar e depois dividir; AP: precisão na posição de cada relevante e a média), e por que medir nos documentos marcados é otimista e o que a coleção residual muda.
- **Para a próxima tutora:** ritmo calmo, funciona bem com a conta passo a passo e com a previsão antes de rodar. Costuma pedir de novo as definições (AP, nDCG, limiar, centroide); vale deixá-las à vista. Conforto com o R razoável, mas com vetores e contas ainda inseguro.
- **Perguntas guardadas:** nenhuma.
- **Produzido:** `rocchio`, `ranking_vetor`; ranking Rocchio `d3 d2 d1 d6 d8 d5 d7 d4`; residual: empate; PRF $k = 2$, $k = 3$ e $k = 1$.
- **Parte D (sessão de grupo):** a marcar — com a ficha do projeto.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-16 12:37 · R version 4.6.1 (2026-06-24) · motor06 v1 2026-10-01 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `b_res` | numeric, nomeado | 6 | d1 0.2539, d2 0.2078, d6 0.02485, d8 0.02295, d5 0, d7 0 |
| `base` | numeric, nomeado | 8 | d1 0.2539, d3 0.2327, d4 0.2148, d2 0.2078, d6 0.02485, d8 0.02295, ... |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | manter |
| `cfg$stopwords` | character | 0 |  |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `fora` | character | 2 | d3, d4 |
| `g_res` | numeric, nomeado | 6 | d1 1, d2 2, d5 0, d6 1, d7 0, d8 0 |
| `grau` | numeric, nomeado | 8 | d1 1, d2 2, d3 2, d4 0, d5 0, d6 1, ... |
| `ix$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$N` | integer | 1 | 8 |
| `ix$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, o, ... |
| `ix$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix$avgdl` | numeric | 1 | 8 |
| `ix$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `MOTOR_VERSAO` | character | 1 | motor06 v1 2026-10-01 |
| `n_res` | numeric, nomeado | 6 | d2 0.1641, d1 0.112, d6 0.05843, d8 0.05719, d5 -0.003006, d7 -0.005905 |
| `neg` | character | 5 | a, aprendizado, estatistico, fundamenta, moderna |
| `novo_a` | numeric, nomeado | 8 | d3 0.9107, d2 0.1641, d1 0.112, d6 0.05843, d8 0.05719, d5 -0.003006, ... |
| `q_a` | numeric, nomeado | 45 | a -0.104, acelera 0, aprendizado -0.3119, avaliacao 0, bm25 1.56, busca 0, ... |
| `q_prf` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0.7798, busca 0, ... |
| `q_prf1` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `q_prf3` | numeric, nomeado | 45 | a 0.1733, acelera 0, aprendizado 0.5199, avaliacao 0, bm25 0.5199, busca 0, ... |
| `q0` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `qm` | numeric, nomeado | 45 | a -0.104, acelera 0, aprendizado -0.3119, avaliacao 0, bm25 0.7798, busca 0, ... |
| `r_prf` | numeric, nomeado | 8 | d3 0.6484, d1 0.5751, d2 0.1745, d4 0.1614, d6 0.06213, d8 0.04714, ... |
| `r_prf1` | numeric, nomeado | 8 | d1 0.8821, d4 0.1831, d3 0.1292, d2 0.126, d7 0.06654, d6 0.04093, ... |
| `r_prf3` | numeric, nomeado | 8 | d3 0.5165, d1 0.5014, d4 0.4871, d2 0.1678, d6 0.05804, d7 0.04063, ... |
| `top` | character | 2 | d1, d3 |
| `top3` | character | 3 | d1, d3, d4 |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `ranking_bm25`, `ranking_cosseno`, `ranking_vetor`, `recall_k`, `relevancia`, `rocchio`, `rr`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

