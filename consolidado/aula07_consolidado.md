# Consolidado — PI III — Aula 07 — 2026-10-25
*guia versão 2 · tutora: Claude · sessão individual (teoria) · motor07 · duas sessões (23/10 e 25/10)*
**Aluno:** Lucas Murinelly Feliciano

## 1. O que foi passado
- M1 — descasamento de vocabulário: "busca" ($d5$ $0{,}270$, $d7$ $0{,}265$), "ranqueamento" ($d3$ $0{,}413$); $d1$ fica com $0$ nas duas; "ordenar documentos": $d1$ $0{,}166$, $d6$ $0{,}157$, $d2$ $0{,}136$, $d5$ $0{,}135$, $d3$ $0$
- M2 — esparso × denso: $d1$ com $7$ de $45$ coordenadas não nulas, matriz com $17{,}2\%$; denso com $k = 2$: $d1 = (-0{,}862;\ -0{,}253)$; hipótese distribucional; $d4$ com $45 - 6 = 39$ zeros
- M3 — LSA: $W = U\,\Sigma\,V^{\top}$; valores singulares parecidos ($5{,}602$ a $4{,}024$); energia $0{,}170$ com $k = 1$, $0{,}323$ com $k = 2$, $0{,}811$ com $k = 6$; `lsa(ix, k)` escrita
- M4 — consulta dobrada $\vec q_k = U_k^{\top}\vec q_0 = (-0{,}370;\ 0{,}445)$; `ranking_lsa` escrita; ranking $k = 2$: $d2\ d3\ d8\ d6\ d5\ d1\ d4\ d7$, AP $1$ (BM25 $0{,}833$); $k = 3$ cai para $0{,}750$; cosseno negativo é geometria
- M5 — limites do LSA: "busca" com $k = 2$: $d4$ em 1º ($0{,}999$, ruído), $d1$ em 3º ($0{,}967$, ganho); $d3$ × $d8$: $0{,}058$ na TF-IDF e $1$ no LSA; com $k = 8$: só $d5$ ($0{,}746$) e $d7$ ($0{,}733$), a ordem do léxico com outros valores (a consulta dobrada fica mais curta, e todos os escores sobem pelo mesmo fator, cerca de $2{,}8$)
- M6 — RRF: `rrf` escrita e rodada; híbrido $d3\ d2\ d1\ d8\ d6\ d4\ d5\ d7$ ($d3 = 0{,}0325$, $d2 = 0{,}0323$); $d6$ em 5º ($0{,}0308$); AP $1$ igual ao LSA e nDCG graduado $0{,}990$ (LSA $0{,}966$)

## 2. Como foi o aprendizado — opinião da tutora
Você acerta bem o que pede raciocínio sobre o resultado, e quase sempre antes de rodar: previu o zero do $d1$ em "busca" com $k = 8$, que o $d3$ ficaria à frente no híbrido, e acertou no teste os módulos de contagem de zeros e de sinais da consulta dobrada ($d6$ à frente de $d1$ pelos sinais). Pediu para ver como checar o $d6$ no R, e essa pergunta foi boa: o resultado do $d6$ já estava dentro do ranking inteiro.

As dificuldades aparecem quando a conta muda de forma ou pede interpretação. Na energia com valores $6$, $2$, $1$ e $1$, você precisou de um passo por vez ($42$, depois $36$, depois $0{,}857$) e não soube dizer o que isso significa comparado ao corpus do curso. No M5, explicou o $d4$ por "aproxima" e depois por "perda de informação", e faltou o motivo: coocorrência de palavras, não sinônimo. Na RRF, previu "o LSA" quando a pergunta era sobre dois documentos, e só acertou ao comparar cada documento ranking a ranking. Previu que o híbrido seria melhor em todas as métricas, mas em quatro colunas o LSA já estava no máximo possível; só o nDCG graduado tinha folga.

Você pediu para **não fazer contas à mão**, e eu respeitei: o R fez as contas, e você previu e leu. Ritmo calmo, funciona bem com um passo por vez, número real antes da pergunta. Às vezes responde sem colar a saída do R; vale pedir.

**Teste final:** acertou M2, M4 e M6; a revisar M1, M3 e M5.
- M1 — errou: faltou ver que "aprendizagem" não está no vocabulário, vetor nulo, todos $0$ na ordem do corpus ($d4$ tem "aprendizado")
- M3 — conta certa ($\frac{36}{42} = 0{,}857$), mas não soube interpretar: uma direção domina, enquanto no curso $k = 1$ guarda só $0{,}170$
- M5 — parcial: viu que $k = 2$ perde informação, faltou dizer que a SVD não tem dados para separar assunto de palavra comum, e que com $k = 8$ não há compressão

**Registro do aluno:** o intervalo entre o dia em que a aula começou e o limite de tokens da conversa fez parte do conteúdo ser esquecido, e isso aparece no teste final.

## 3. Observações para a frente
- **Revisar antes da Aula 08:** (1) o que acontece com consulta fora do vocabulário (vetor nulo, todos $0$); (2) por que uma direção dominante dá energia alta com $k = 1$, e o curso não; (3) o LSA não conhece sinônimos, só **coocorrência**, e por isso ganho e ruído vêm do mesmo mecanismo; (4) o $k$ se escolhe no desenvolvimento, com muitas consultas
- **Para a próxima tutora:** deixar as definições à vista (energia, $k$, coocorrência); mostrar a conta com os **números reais da aula** antes de pedir qualquer coisa; não pedir contas à mão; pedir que cole a saída do R
- **Perguntas guardadas:** nenhuma
- **Produzido:** `lsa`, `ranking_lsa`, `rrf`; LSA $k = 2$ `d2 d3 d8 d6 d5 d1 d4 d7`; híbrido `d3 d2 d1 d8 d6 d4 d5 d7`
- **Aviso sobre o motor:** o link `.../motor/motor07.R` deu 404 no começo da primeira sessão; avisar o professor ou o grupo
- **Parte D (sessão de grupo):** a marcar, com a ficha do projeto

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-10-26 02:49 · R version 4.6.1 (2026-06-24) · motor07 v1 2026-10-15 · não edite à mão*

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
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `fora` | character | 2 | d3, d4 |
| `g` | numeric, nomeado | 8 | d1 1, d2 2, d3 2, d4 0, d5 0, d6 1, ... |
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
| `m2$U` | matrix | 45 × 2 | linhas: a, acelera, aprendizado, ... \| colunas: (sem nomes) |
| `m2$S` | numeric | 2 | 5.602, 5.313 |
| `m2$D` | matrix | 8 × 2 | linhas: d1, d2, d3, ... \| colunas: (sem nomes) |
| `m3$U` | matrix | 45 × 3 | linhas: a, acelera, aprendizado, ... \| colunas: (sem nomes) |
| `m3$S` | numeric | 3 | 5.602, 5.313, 5.022 |
| `m3$D` | matrix | 8 × 3 | linhas: d1, d2, d3, ... \| colunas: (sem nomes) |
| `m8$U` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: (sem nomes) |
| `m8$S` | numeric | 8 | 5.602, 5.313, 5.022, 4.783, 4.672, 4.522, ... |
| `m8$D` | matrix | 8 × 8 | linhas: d1, d2, d3, ... \| colunas: (sem nomes) |
| `MOTOR_VERSAO` | character | 1 | motor07 v1 2026-10-15 |
| `n_res` | numeric, nomeado | 6 | d2 0.1641, d1 0.112, d6 0.05843, d8 0.05719, d5 -0.003006, d7 -0.005905 |
| `neg` | character | 5 | a, aprendizado, estatistico, fundamenta, moderna |
| `novo_a` | numeric, nomeado | 8 | d3 0.9107, d2 0.1641, d1 0.112, d6 0.05843, d8 0.05719, d5 -0.003006, ... |
| `q_a` | numeric, nomeado | 45 | a -0.104, acelera 0, aprendizado -0.3119, avaliacao 0, bm25 1.56, busca 0, ... |
| `q_prf` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0.7798, busca 0, ... |
| `q_prf1` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `q_prf3` | numeric, nomeado | 45 | a 0.1733, acelera 0, aprendizado 0.5199, avaliacao 0, bm25 0.5199, busca 0, ... |
| `q0` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `qk` | matrix | 2 × 1 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `qm` | numeric, nomeado | 45 | a -0.104, acelera 0, aprendizado -0.3119, avaliacao 0, bm25 0.7798, busca 0, ... |
| `r_prf` | numeric, nomeado | 8 | d3 0.6484, d1 0.5751, d2 0.1745, d4 0.1614, d6 0.06213, d8 0.04714, ... |
| `r_prf1` | numeric, nomeado | 8 | d1 0.8821, d4 0.1831, d3 0.1292, d2 0.126, d7 0.06654, d6 0.04093, ... |
| `r_prf3` | numeric, nomeado | 8 | d3 0.5165, d1 0.5014, d4 0.4871, d2 0.1678, d6 0.05804, d7 0.04063, ... |
| `r2` | numeric, nomeado | 8 | d2 1, d3 0.9596, d8 0.9596, d6 0.8999, d5 0.4736, d1 0.3971, ... |
| `r3` | numeric, nomeado | 8 | d3 0.9132, d6 0.863, d8 0.7407, d2 0.7096, d1 0.4889, d4 0.2449, ... |
| `rb` | numeric, nomeado | 8 | d3 1.873, d1 1.869, d2 1.687, d4 1.427, d8 0.519, d6 0.4925, ... |
| `rc` | numeric, nomeado | 8 | d1 0.2539, d3 0.2327, d4 0.2148, d2 0.2078, d6 0.02485, d8 0.02295, ... |
| `rh` | numeric, nomeado | 8 | d3 0.03252, d2 0.03227, d1 0.03128, d8 0.03126, d6 0.03078, d4 0.03055, ... |
| `s$d` | numeric | 8 | 5.602, 5.313, 5.022, 4.783, 4.672, 4.522, ... |
| `s$u` | matrix | 45 × 8 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `s$v` | matrix | 8 × 8 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `top` | character | 2 | d1, d3 |
| `top3` | character | 3 | d1, d3, d4 |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

