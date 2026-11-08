# Consolidado — PI III — Aula 08 — 08/11/2026
*guia versão 2 · tutor: Claude (Claude Code) · sessão individual (teoria) · motor08*
**Aluno:** Pedro Santos Malaquias Rodrigues

## 1. O que foi passado
- M1 — dois estágios; $\text{R@}1 = 0{,}5$, $\text{R@}2 = 0{,}5$, $\text{R@}3 = 1$, $\text{R@}4 = 1$; com limiar 1, menor $k = 6$ e $\text{R@}3 = 0{,}75$
- M2 — pontuar cada lado separado (BM25) × ler o par; `d2` embaralhado, mesmo BM25 ($1{,}687$); custo em leituras ($50 \times 20 = 1\,000$ contra $50 \times 2\,000 = 100\,000$)
- M3 — proximidade ordenada: `d2` $1$, `d3` $0{,}5$ à mão; "modelo de texto" em `d3`: $0{,}5 + 0 + 1 = 1{,}5$
- M4 — `reordenar`: $k = 2$ não muda; $k = 3$ dá `d2 d3 d1`, AP $0{,}833 \to 1$; Checkpoint 4 com o empate certo (`d1 d6 d2`)
- M5 — limites ("documentos busca" dá 0 em todos; "ordena" × "ordenar"); *cross-encoders* como conceito
- M6 — latência × qualidade: AP fica em 1 a partir de $k = 3$; $k$ e janela escolhidos no desenvolvimento
- O aluno não fez a teoria da Aula 07 sozinho; o estágio 1 foi tratado como BM25. Ele fez a Parte D das Aulas 06, 07 e 08 com o grupo no mesmo dia.

## 2. Como foi o aprendizado — opinião do tutor
Percorremos os seis módulos. Pedro acertou bem quando a pergunta tinha uma escolha concreta: identificou a ordem das palavras como o que o BM25 não vê, resolveu o empate do Checkpoint 4 pela ordem do estágio 1 e escolheu a razão certa para o *cross-encoder* reconhecer "ordena" e "ordenar". As dificuldades ficaram nas contas e nas definições: o $\text{R@}k$ precisou ser explicado sem notação (a notação matemática não aparecia formatada para ele) e só saiu com a conta separada em duas partes, contar e depois dividir; as distâncias da proximidade também saíram passo a passo, uma subtração por vez. Duas previsões erraram de forma que vale anotar: que embaralhar o documento mudaria o BM25, e que o `d2` subiria mesmo fora da cabeça com $k = 2$; as duas foram corrigidas pela saída do R. No Checkpoint 6, a primeira objeção (custo) foi dele; a segunda (uma consulta só não escolhe $k$) foi entregue por mim. Durante a aula, mostrei as saídas do R copiadas do guia; no fim rodei todos os códigos e conferi que batem.

**Teste final, nesta sessão:** parcial em M1 (o relevante fica fora da cabeça, mas continua em 80º, não "fora dos resultados"); errou M2 (a entrada é o par, que muda com a consulta) e M3 ("modelo vetorial" dá $\frac{1}{3}$, a invertida dá 0); M4, M5 e M6 não respondidas aqui, a pedido do aluno.

**Teste final, respostas de outro agente de IA:** depois da sessão, o aluno colou as respostas das seis perguntas que deu numa sessão com outro agente de IA. O texto não foi produzido nesta sessão, e o tutor só o corrigiu:
- M1 parcial: o cutoff está certo, mas fica a dúvida "fora do ranking ou em 80º". No motor da aula, a cauda fica intacta e o documento continua em 80º.
- M2 certa: o cross-encoder lê o par, e a representação depende da consulta.
- M3 errada: a resposta foi "3 nas duas ordens". A proximidade é 1 dividido pela distância, $\frac{1}{3}$, e a ordem invertida dá 0.
- M4 errada: a resposta reordenou os cinco e cortou em 3 (D, B, C). Com $k = 3$, só A, B e C são lidos e reordenados, e D e E ficam como estavam: B, C, A, D, E. O empate pela ordem do estágio 1 estava certo.
- M5 parcial: a resposta deu distância 2, mas o brinquedo dá 0, porque "recuperacao" vem antes de "informacao" no d1. A parte do cross-encoder (escore alto pelo sentido) estava certa.
- M6 certa: $k = 10$, e o teste não entra no desempate.

## 3. Observações para a frente
- **Revisar antes da Aula 09:** o $\text{R@}k$ e o AP como frações (contar relevantes até a posição e dividir pelo total); a regra da proximidade (subtração de posições, só de 1 a 3, só a menor, na ordem da consulta); que o estágio 2 só lê a cabeça e a cauda fica intacta ($k$ é o tamanho da cabeça reordenada, não um corte do ranking); que $k$ se escolhe no desenvolvimento, com várias consultas.
- **Para a próxima tutora:** ritmo calmo; funciona bem com uma conta por mensagem e com perguntas de múltipla escolha; escrever a matemática também em texto simples, porque o LaTeX não aparece formatado para ele; pedir a previsão antes de rodar.
- **Perguntas guardadas:** nenhuma.
- **Produzido:** `proximidade`, `reordenar`; BM25 reordenado com $k = 3$: `d2 d3 d1 d4 d8 d6 d5 d7`.
- **Parte D (sessão de grupo):** feita em 08/11/2026 — top-3, janela 3, sobre o BM25 (ver `aula08_parteD_consolidado.md`).

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-08 15:12 · R version 4.6.1 (2026-06-24 ucrt) · motor08 v2 2026-10-22 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | manter |
| `cfg$stopwords` | character | 0 |  |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `cfg$modelo` | character | 1 | bm25 |
| `cfg$lsa_k` | numeric | 1 | 2 |
| `cfg$rrf_c` | numeric | 1 | 60 |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `docs2` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 vetores como documentos rep..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `g` | numeric, nomeado | 8 | d1 1, d2 2, d3 2, d4 0, d5 0, d6 1, ... |
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
| `ix2$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix2$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix2$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix2$N` | integer | 1 | 8 |
| `ix2$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix2$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix2$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix2$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix2$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, vetores, ... |
| `ix2$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix2$avgdl` | numeric | 1 | 8 |
| `ix2$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
| `pv` | numeric, nomeado | 8 | d1 0.3333, d2 0, d3 0, d4 0, d5 0, d6 0.3333, ... |
| `px` | numeric, nomeado | 8 | d1 0, d2 1, d3 0.5, d4 0, d5 0, d6 0, ... |
| `qt` | character | 3 | modelo, de, recuperacao |
| `r$rel` | integer | 8 | 1, 0, 1, 0, 0, 0, ... |
| `r$g` | numeric | 8 | 2, 1, 2, 0, 0, 1, ... |
| `r$R` | integer | 1 | 2 |
| `r1$rel` | integer | 8 | 1, 1, 1, 0, 0, 1, ... |
| `r1$g` | numeric | 8 | 2, 1, 2, 0, 0, 1, ... |
| `r1$R` | integer | 1 | 4 |
| `rb` | numeric, nomeado | 8 | d3 1.873, d1 1.869, d2 1.687, d4 1.427, d8 0.519, d6 0.4925, ... |
| `rv` | numeric, nomeado | 8 | d2 2.833, d1 1.25, d6 1.186, d5 0.6594, d3 0.6542, d8 0.519, ... |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `proximidade`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

