# Consolidado — PI III — Aula 08 — Tema 2 (frase exata) — 2026-11-26

*Guia versão 1 · tutora: GPT-6.2 · motor08 v2 (adaptação ao ambiente disponível)*

**Aluno:** Caio Kenji Maeshiro

## 1. O que foi passado

- **M1 — Índice posicional e frase exata:** aprendi a localizar termos pelas suas posições e a utilizar a interseção com deslocamentos para identificar sequências consecutivas. No corpus didático, nenhum documento contém a frase inteira “modelo de recuperacao”; apenas `d2` contém “modelo de”.
- **M2 — Trecho mais longo:** aprendi que, quando todos os escores de frase são zero, a reordenação preserva o ranking original. A função `trecho` divide o comprimento da maior sequência correspondente pelo número de termos da consulta. No exemplo didático, `d2` obteve $2/3$ e subiu para a primeira posição com $k=3$, elevando o AP de $0{,}833$ para $1$.
- **M3 — Rigidez:** observei que remover stopwords pode permitir correspondências entre frases originalmente diferentes, mas também eliminar informações úteis para distinguir documentos. Na consulta didática, a remoção do “de” provocou empates. A limpeza com acentos mantidos dividiu “recuperação” em “recupera” e “o”; a transliteração evita esse problema no exemplo. O plural também pode impedir correspondências exatas.
- **M4 — Corpus do grupo:** avaliei o corpus de 60 documentos, com 20 consultas, das quais 11 julgadas no conjunto de desenvolvimento. Nenhuma das 11 apresentou a frase inteira no top-10. O MAP original do BM25 foi $0{,}90719696969697$.

| k | MAP por frase | MAP por trecho |
|---:|---:|---:|
| 3 | 0,907 | 0,862 |
| 5 | 0,907 | 0,843 |
| 10 | 0,907 | 0,821 |

Escolhi manter o BM25 sem reordenação por frase ou trecho. Para $k=3$, nove consultas mantiveram o AP e duas pioraram: `q14` ($-0{,}083$) e `q15` ($-0{,}417$). Nenhuma melhorou. Na `q15`, sobre incêndio no Porto de Santos e impacto ambiental, um documento sem relevância registrada no gabarito subiu da terceira para a primeira posição, deslocando dois documentos relevantes. O AP caiu de $1$ para aproximadamente $0{,}583$.

## 2. Como foi o aprendizado — opinião da tutora

Ao longo da sessão, demonstrei compreender a relação entre posições e frases consecutivas, o efeito das stopwords e a necessidade de avaliar a reordenação com métricas. Inicialmente tive dificuldade com a interseção deslocada, o denominador do escore de trecho e a distinção entre escore de reordenação e MAP. Após as explicações, identifiquei corretamente que empates preservam a ordem original e que uma estratégia sem ganho não precisa ser incorporada ao motor.

**Teste final:** acertei integralmente M1, M3 e M4; acertei parcialmente M2. Preciso revisar o cálculo do maior trecho consecutivo: para “busca de documentos” em “busca em muitos documentos”, o escore é $1/3$, não $1/2$.

## 3. Observações para a frente

- **Revisar:** interseção de posições deslocadas, comprimento do maior trecho consecutivo e diferença entre escore, AP e MAP.
- **Perguntas guardadas:** nenhuma pendente registrada ao final da sessão.
- **Para o grupo:** apresentar a comparação experimental e a análise da `q15`. A correspondência lexical consecutiva não garante relevância. A decisão de manter o BM25 refere-se às estratégias avaliadas nesta atividade; não alterei automaticamente o arquivo de configuração do grupo.
- **Limitações experimentais:** não havia consultas no conjunto de teste independente; os resultados se restringem ao desenvolvimento. Não houve caso de melhoria na análise por consulta com $k=3$. O conteúdo dos documentos da `q15` não foi examinado diretamente nesta análise.
- **Adaptações técnicas:** o carregamento do motor09 falhou; utilizei o motor08 v2 e recuperei a implementação de `reordenar` do guia teórico quando necessário. Na avaliação do grupo, utilizei diretamente o BM25, pois era o modelo configurado, e tratei explicitamente $k=0$ para preservar o ranking original. Um erro de objetos ausentes foi resolvido ao retornar ao notebook correto.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-26 22:17 · R version 4.6.1 (2026-06-24) · motor07 v1 2026-10-15 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `ap0` | numeric, nomeado | 11 | q01 1, q04 1, q06 1, q08 0.6667, q10 1, q11 1, ... |
| `cfg$minimo` | numeric | 1 | 10 |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | translit |
| `cfg$stopwords` | character | 10 | de, o, a, e, um, por, ... |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `cfg$juizes` | character | 1 | consenso |
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `cfg$modelo` | character | 1 | bm25 |
| `cfg$lsa_k` | numeric | 1 | 50 |
| `cfg$rrf_c` | numeric | 1 | 60 |
| `cfg$rerank_k` | numeric | 1 | 3 |
| `cfg$janela` | numeric | 1 | 3 |
| `cfg$grupo` | character | 1 | Enem |
| `consultas` | character, nomeado | 20 | q01 movimentacao cargas importa..., q02 movimentacao conteineres sa..., q03 historia desenvolvimento po..., q04 expansao construcao termina..., q05 profundidade calado dragage..., q06 acesso ferroviario rodoviar..., ... |
| `cp` | data.frame | 60 × 3 | colunas: texto, fonte, id |
| `dev` | character | 11 | q01, q04, q06, q08, q10, q11, ... |
| `docs` | character, nomeado | 60 | doc-fecae25906e7b91c o porto de roterdao portugu..., doc-1dca3350bc9b993d paises baixos de 1962 ate 2..., doc-01f9b4f10d310241 roterda foi o setimo maior ..., doc-09c80f2d1ecbbb22 roterda agora estende se po..., doc-95b16c205f58c0a3 portos em torno de nieuw ma..., doc-e6e35237be5c264b e valorizado a area de maas..., ... |
| `E$rks` | list | 11 | elementos: q01, q04, q06, q08, q10, q11, q14, q15, ... |
| `E$qts` | list | 11 | elementos: q01, q04, q06, q08, q10, q11, q14, q15, ... |
| `E$qrels` | list | 20 | elementos: q01, q02, q03, q04, q05, q06, q07, q08, ... |
| `E$tokens` | list | 60 | elementos: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, doc-95b16c205f58c0a3, doc-e6e35237be5c264b, doc-11237fcb5e042bfd, doc-fec162740cbeb223, ... |
| `E$limiar` | numeric | 1 | 2 |
| `grade` | matrix | 3 × 2 | linhas: (sem nomes) \| colunas: frase, trecho |
| `ix$tokens` | list | 60 | elementos: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, doc-95b16c205f58c0a3, doc-e6e35237be5c264b, doc-11237fcb5e042bfd, doc-fec162740cbeb223, ... |
| `ix$vocab` | character | 1229 | 000, 03, 1, 10, 100, 105, ... |
| `ix$tf` | matrix | 1229 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `ix$N` | integer | 1 | 60 |
| `ix$df` | numeric, nomeado | 1229 | 000 1, 03 1, 1 1, 10 2, 100 1, 105 1, ... |
| `ix$idf_tfidf` | numeric, nomeado | 1229 | 000 4.094, 03 4.094, 1 4.094, 10 3.401, 100 4.094, 105 4.094, ... |
| `ix$w` | matrix | 1229 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `ix$wn` | matrix | 1229 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `ix$postings` | list | 1229 | elementos: porto, roterdao, portugues, europeu, ou, roterda, brasileiro, maior, ... |
| `ix$dl` | numeric, nomeado | 60 | doc-fecae25906e7b91c 21, doc-1dca3350bc9b993d 20, doc-01f9b4f10d310241 22, doc-09c80f2d1ecbbb22 22, doc-95b16c205f58c0a3 25, doc-e6e35237be5c264b 20, ... |
| `ix$avgdl` | numeric | 1 | 42.52 |
| `ix$idf_bm25` | numeric, nomeado | 1229 | 000 3.705, 03 3.705, 1 3.705, 10 3.195, 100 3.705, 105 3.705, ... |
| `m` | NULL | 0 |  |
| `MOTOR_VERSAO` | character | 1 | motor07 v1 2026-10-15 |
| `nec` | data.frame | 20 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `qrels$q01` | numeric, nomeado | 3 | doc-eb2430c7a98d9748 2, doc-54eb3169714cc9ef 0, doc-d5e0c45cb91c9866 0 |
| `qrels$q02` | numeric, nomeado | 1 | doc-543790f4a0744d86 0 |
| `qrels$q03` | numeric, nomeado | 2 | doc-09c80f2d1ecbbb22 0, doc-fecae25906e7b91c 0 |
| `qrels$q04` | numeric, nomeado | 4 | doc-c97f55cd190b8eda 2, doc-2ac1452fe6a0f227 1, doc-9775d6ed4fab1088 0, doc-4a66b7c1a6d42c6f 1 |
| `qrels$q05` | numeric, nomeado | 1 | doc-21b74f8cdba51a41 1 |
| `qrels$q06` | numeric, nomeado | 3 | doc-5c233ac3a9ebb8e4 2, doc-37b06b360d428b99 0, doc-f5d88d23b5724d1d 0 |
| `qrels$q07` | numeric, nomeado | 1 | doc-7840f74f5d343cdd 0 |
| `qrels$q08` | numeric, nomeado | 3 | doc-92129bb62291df53 2, doc-87a504ca426bc8ab 1, doc-79bf3835d1d77ed8 2 |
| `qrels$q09` | numeric, nomeado | 2 | doc-543790f4a0744d86 0, doc-a3276b08b5b119d8 1 |
| `qrels$q10` | numeric, nomeado | 3 | doc-65b06580ad1d7e3a 2, doc-3920f91f96c67fe8 2, doc-db8517f307829d06 2 |
| `qrels$q11` | numeric, nomeado | 3 | doc-3920f91f96c67fe8 2, doc-a3276b08b5b119d8 2, doc-56713a5bb7e8f872 1 |
| `qrels$q12` | numeric, nomeado | 2 | doc-543790f4a0744d86 1, doc-4a66b7c1a6d42c6f 0 |
| `qrels$q13` | numeric, nomeado | 1 | doc-79bf3835d1d77ed8 0 |
| `qrels$q14` | numeric, nomeado | 4 | doc-895fa264b77fe72a 2, doc-be66af09907c9837 2, doc-0216e3f17d8941f2 0, doc-543790f4a0744d86 0 |
| `qrels$q15` | numeric, nomeado | 3 | doc-be66af09907c9837 2, doc-9f69a04e49fbc49b 2, doc-87eae23e5a597432 1 |
| `qrels$q16` | numeric, nomeado | 4 | doc-d0ed531787149512 0, doc-28a6b0ff0368e381 2, doc-3920f91f96c67fe8 2, doc-e6e35237be5c264b 1 |
| `qrels$q17` | numeric, nomeado | 3 | doc-28a6b0ff0368e381 2, doc-6a4c8a90c1269b98 1, doc-54eb3169714cc9ef 0 |
| `qrels$q18` | numeric, nomeado | 3 | doc-28a6b0ff0368e381 2, doc-87eae23e5a597432 2, doc-65b06580ad1d7e3a 2 |
| `qrels$q19` | numeric, nomeado | 1 | doc-fecae25906e7b91c 0 |
| `qrels$q20` | numeric, nomeado | 2 | doc-543790f4a0744d86 0, doc-fecae25906e7b91c 0 |
| `R_q` | integer, nomeado | 20 | q01 1, q02 0, q03 0, q04 1, q05 0, q06 1, ... |
| `teste` | character | 0 |  |
| `usar` | character | 11 | q01, q04, q06, q08, q10, q11, ... |

### Funções definidas

`anexar_estado`, `ap`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `estagio1`, `frase`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `med`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `trecho`, `vetor_consulta`
<!-- estado-R:fim -->
