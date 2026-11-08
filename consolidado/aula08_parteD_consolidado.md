# Consolidado — PI III — Aula 08 — Parte D — 08/11/2026
*guia versão 2 · tutor: Claude (Claude Code, com execução no R local e no Colab) · sessão de grupo · motor08*
**Grupo:** Enem · **presentes:** Pedro Santos (conduziu); demais: — · **digitou:** o tutor, a pedido do grupo, nos três módulos

## 1. O que foi feito
- M7 — `proximidade` e `reordenar` (testes da teoria: $0{,}5$ e `b a c`) sobre o estágio 1 do grupo (BM25). Em q01 nada se move; em q14 (top-10, janela 3) a reordenação subiu documentos com "porto de santos" colado, que não respondem à necessidade, e tirou do top-5 o relevante `be66af`, sobre o incêndio de 2015 (AP $0{,}312 \to 0{,}146$).
- M8 — grade $k \in \{3, 5, 10\}$ × janela $\in \{2, 3, 5\}$ nas 11 consultas avaliadas, todas `dev`; sem teste. MAP do estágio 1: $0{,}907$. Melhor combinação: $k = 3$, janela 2 ou 3, $0{,}847$; pior: $k = 10$, janela 5, $0{,}665$. Nenhuma combinação ganhou em alguma consulta; $k = 3$ perde em q14, q15 e q16.
- M9 — decisão: **reordenar o top-3 do BM25, janela 3**, porque a proximidade premia documentos com as palavras da consulta em ordem, o que deve ajudar em consultas mais longas, mesmo tendo perdido em q14, q15 e q16. `config.R`: `rerank_k = 3`, `janela = 3`.

## 2. Como o grupo trabalhou — opinião do tutor
O grupo leu os textos de q14 e respondeu sem hesitar que os documentos que subiram não respondem à necessidade e que o que desceu respondia. Na grade, apontou a linha de maior MAP entre as reordenações, mas a primeira leitura ("perde em todas") e a escolha de reordenar não batiam com a tabela: $k = 3$ fica abaixo de não reordenar ($0{,}847$ contra $0{,}907$) e perde em 3 de 11 consultas, sem ganhar em nenhuma. Mostrei isso com os números e perguntei de novo; o grupo manteve a decisão de reordenar com $k = 3$, janela 3, e escolheu como porquê a hipótese de que a proximidade ajuda em consultas mais longas. É uma decisão do grupo, registrada com a ressalva; os números atuais não a sustentam. Como nas Aulas 06 e 07, o código foi rodado por mim; o grupo leu as saídas e decidiu, mas não digitou.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 09):** o motor está com BM25 + reordenação do top-3 (janela 3). Vale testar a hipótese do grupo com consultas mais longas ou mais julgamentos, e lembrar que, no gabarito atual, `rerank_k = 0` dá MAP $0{,}907$. O guia da Aula 09 Parte D não está no repositório do grupo.
- **Tarefa do grupo (análise da reordenação):** feita. Onde perdeu, q14 (AP $0{,}312 \to 0{,}146$): a proximidade premiou "porto de santos" colado em documentos que não falam de acidentes e zerou o relevante `be66af`, que tem "incêndio" no singular e "terminais" fora da ordem da consulta. Onde não mudou, q01: o top-3 do BM25 já estava na ordem da proximidade. Texto completo na seção 6 da ficha.
- **Perguntas guardadas:** nenhuma.
- **Produzido:** ver a entrada "Aula 08 Parte D" na linha do tempo da ficha do projeto.
- **Ficha atualizada:** sim — seções alteradas: 5, 6, 7 e cabeçalho; seção 8 gerada por `anexar_estado()`.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-08 05:32 · R version 4.6.1 (2026-06-24) · motor08 v2 2026-10-22 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `ap0` | numeric, nomeado | 11 | q01 1, q04 1, q06 1, q08 0.6667, q10 1, q11 1, ... |
| `ap1` | numeric, nomeado | 11 | q01 1, q04 1, q06 1, q08 0.6667, q10 1, q11 1, ... |
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
| `f` | character | 1 | aula08_parteD_consolidado.md |
| `grade` | matrix | 3 × 3 | linhas: k3, k5, k10 \| colunas: janela2, janela3, janela5 |
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
| `ks` | numeric | 3 | 10, 20, 50 |
| `m` | NULL | 0 |  |
| `m20$U` | matrix | 1229 × 20 | linhas: 000, 03, 1, ... \| colunas: (sem nomes) |
| `m20$S` | numeric | 20 | 52.05, 41.72, 39.5, 36.92, 35.23, 33.24, ... |
| `m20$D` | matrix | 60 × 20 | linhas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, ... \| colunas: (sem nomes) |
| `map0` | numeric | 1 | 0.9072 |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
| `ms$k10` | list | 3 | elementos: U, S, D |
| `ms$k20` | list | 3 | elementos: U, S, D |
| `ms$k50` | list | 3 | elementos: U, S, D |
| `nec` | data.frame | 20 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `q` | character | 1 | q14 |
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
| `qt` | character | 5 | incendios, acidentes, porto, santos, terminais |
| `qts$q01` | character | 5 | movimentacao, cargas, importancia, economica, portos |
| `qts$q04` | character | 4 | expansao, construcao, terminais, porto |
| `qts$q06` | character | 5 | acesso, ferroviario, rodoviario, transporte, porto |
| `qts$q08` | character | 5 | administracao, autoridade, portuaria, santos, xangai |
| `qts$q10` | character | 4 | porto, desenvolvimento, economico, regiao |
| `qts$q11` | character | 5 | porto, comercio, exterior, exportacoes, importacoes |
| `qts$q14` | character | 5 | incendios, acidentes, porto, santos, terminais |
| `qts$q15` | character | 7 | incendio, porto, santos, impacto, ambiental, contaminacao, ... |
| `qts$q16` | character | 5 | historia, desenvolvimento, crescimento, porto, xangai |
| `qts$q17` | character | 6 | yangshan, expansao, terminal, aguas, profundas, xangai |
| `qts$q18` | character | 5 | terminais, wusongkou, waigaoqiao, yangshan, xangai |
| `r` | character | 1 | hib.k50 |
| `rb` | numeric, nomeado | 60 | doc-eb2430c7a98d9748 9.467, doc-77019194da3c538e 4.896, doc-65b06580ad1d7e3a 4.598, doc-54eb3169714cc9ef 3.741, doc-d5e0c45cb91c9866 3.741, doc-7840f74f5d343cdd 2.928, ... |
| `REPO` | character | 1 | https://raw.githubuserconte... |
| `rk` | numeric, nomeado | 60 | doc-0216e3f17d8941f2 4.719, doc-be66af09907c9837 4.68, doc-543790f4a0744d86 4.337, doc-ddecd989aeefe128 3.771, doc-91a6d0af42b298da 2.975, doc-c97f55cd190b8eda 2.69, ... |
| `rks$q01` | numeric, nomeado | 60 | doc-eb2430c7a98d9748 9.467, doc-77019194da3c538e 4.896, doc-65b06580ad1d7e3a 4.598, doc-54eb3169714cc9ef 3.741, doc-d5e0c45cb91c9866 3.741, doc-7840f74f5d343cdd 2.928, ... |
| `rks$q04` | numeric, nomeado | 60 | doc-c97f55cd190b8eda 3.402, doc-2ac1452fe6a0f227 3.328, doc-fec162740cbeb223 3.291, doc-4a66b7c1a6d42c6f 3.291, doc-91a6d0af42b298da 2.975, doc-0216e3f17d8941f2 2.693, ... |
| `rks$q06` | numeric, nomeado | 60 | doc-5c233ac3a9ebb8e4 4.73, doc-501972e9e1fb7e50 4.254, doc-f5d88d23b5724d1d 4.201, doc-37b06b360d428b99 4.189, doc-cfc6cc91aacf0b8d 3.69, doc-ddecd989aeefe128 3.49, ... |
| `rks$q08` | numeric, nomeado | 60 | doc-92129bb62291df53 8.232, doc-87a504ca426bc8ab 5.569, doc-7880e5e984c067aa 3.797, doc-ddecd989aeefe128 3.736, doc-c97f55cd190b8eda 3.657, doc-79bf3835d1d77ed8 3.34, ... |
| `rks$q10` | numeric, nomeado | 60 | doc-65b06580ad1d7e3a 7.093, doc-3920f91f96c67fe8 4.106, doc-db8517f307829d06 3.472, doc-28a6b0ff0368e381 3.009, doc-77019194da3c538e 2.791, doc-56713a5bb7e8f872 2.47, ... |
| `rks$q11` | numeric, nomeado | 60 | doc-3920f91f96c67fe8 4.819, doc-a3276b08b5b119d8 4.778, doc-56713a5bb7e8f872 4.07, doc-34e10bb2c8393e95 3.127, doc-87eae23e5a597432 2.414, doc-28a6b0ff0368e381 0.8489, ... |
| `rks$q14` | numeric, nomeado | 60 | doc-0216e3f17d8941f2 4.719, doc-be66af09907c9837 4.68, doc-543790f4a0744d86 4.337, doc-ddecd989aeefe128 3.771, doc-91a6d0af42b298da 2.975, doc-c97f55cd190b8eda 2.69, ... |
| `rks$q15` | numeric, nomeado | 60 | doc-9f69a04e49fbc49b 6.689, doc-be66af09907c9837 5.087, doc-895fa264b77fe72a 4.602, doc-3630de3baf43985a 3.396, doc-87eae23e5a597432 3.278, doc-c97f55cd190b8eda 2.69, ... |
| `rks$q16` | numeric, nomeado | 60 | doc-3920f91f96c67fe8 5.282, doc-28a6b0ff0368e381 4.952, doc-0279001a1a60b9ae 4.417, doc-65b06580ad1d7e3a 3.98, doc-db8517f307829d06 3.472, doc-e6e35237be5c264b 3.328, ... |
| `rks$q17` | numeric, nomeado | 60 | doc-28a6b0ff0368e381 16.3, doc-6a4c8a90c1269b98 7.504, doc-54eb3169714cc9ef 3.453, doc-057bf37bc31e0a02 3.072, doc-c97f55cd190b8eda 2.723, doc-9f69a04e49fbc49b 2.131, ... |
| `rks$q18` | numeric, nomeado | 60 | doc-28a6b0ff0368e381 6.404, doc-65b06580ad1d7e3a 6.051, doc-87eae23e5a597432 5.983, doc-9775d6ed4fab1088 4.619, doc-6a4c8a90c1269b98 3.463, doc-91a6d0af42b298da 2.303, ... |
| `rl` | numeric, nomeado | 60 | doc-54eb3169714cc9ef 0.8704, doc-eb2430c7a98d9748 0.8581, doc-7840f74f5d343cdd 0.8294, doc-d5e0c45cb91c9866 0.8102, doc-37b06b360d428b99 0.7807, doc-5c233ac3a9ebb8e4 0.7781, ... |
| `rn` | character | 60 | doc-0216e3f17d8941f2, doc-543790f4a0744d86, doc-ddecd989aeefe128, doc-c97f55cd190b8eda, doc-6a4c8a90c1269b98, doc-be66af09907c9837, ... |
| `s$d` | numeric | 60 | 52.05, 41.72, 39.5, 36.92, 35.23, 33.24, ... |
| `s$u` | matrix | 1229 × 60 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `s$v` | matrix | 60 × 60 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `so_lsa` | character | 2 | doc-7840f74f5d343cdd, doc-37b06b360d428b99 |
| `tab_dev` | matrix | 7 × 11 | linhas: bm25, lsa.k10, lsa.k20, ... \| colunas: q01, q04, q06, q08, ... |
| `teste` | character | 0 |  |
| `usar` | character | 11 | q01, q04, q06, q08, q10, q11, ... |

### Funções definidas

`anexar_estado`, `ap`, `ap_modelo`, `ap_rerank`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `estagio1`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `proximidade`, `ranking_bm25`, `ranking_cosseno`, `ranking_final`, `ranking_lsa`, `ranking_modelo`, `ranking_motor`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `rerank_prox`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

