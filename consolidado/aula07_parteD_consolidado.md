# Consolidado — PI III — Aula 07 — Parte D — 08/11/2026
*guia versão 2 · tutor: Claude (Claude Code, com execução no R local e no Colab) · sessão de grupo · motor07*
**Grupo:** Enem · **presentes:** Pedro Santos (conduziu); demais: — · **digitou:** o tutor, a pedido do grupo, nos três módulos

## 1. O que foi feito
- M7 — LSA no corpus do grupo ($k = 20$, 68,5% da energia); LSA × BM25 na consulta q01, lendo os textos: 3 documentos em comum nos top-5; só o LSA trouxe o `37b06b`, sem nenhuma palavra da consulta, sobre o transporte de mercadorias pelo porto (lido como ganho de sentido); só o BM25 trouxe o `770191`, pelas palavras "movimentacao" e "cargas", que só conta a história das operações.
- M8 — BM25, LSA e híbrido (RRF, $c = 60$) com $k = 10, 20, 50$ nas 11 consultas avaliadas, todas `dev`; sem teste. MAP dev: BM25 $0{,}907$; LSA $0{,}430$ / $0{,}518$ / $0{,}944$; híbrido $0{,}683$ / $0{,}787$ / $0{,}915$. Com $k = 10$ ou $20$, o LSA perde do BM25 em 8 de 11 consultas; com $k = 50$, não perde em nenhuma e ganha em 2 (q08, q14).
- M9 — decisão: **ficar com o BM25**, o mais confiável, porque o LSA só passa dele com $k = 50$, quase a matriz inteira (60 documentos), e ganha em apenas 2 de 11 consultas. `config.R`: `modelo = "bm25"`, `lsa_k = 50`, `rrf_c = 60`.

## 2. Como o grupo trabalhou — opinião do tutor
O grupo leu os textos do top-5 antes de olhar os números e respondeu bem quando as perguntas vinham com os trechos na frente: viu que o `37b06b` fala do assunto sem as palavras da consulta e que o `770191` tem as palavras mas só conta história. Na tabela de desenvolvimento, identificou sozinho a linha de maior MAP (LSA $k = 50$) e que ela não perde em nenhuma consulta, e mesmo assim escolheu o BM25 por confiança; o porquê com números foi montado por mim a partir dessa intuição e aprovado pelo grupo. Não havia teste para olhar, então não houve a tentação de ajustar no teste. Como na Aula 06, todo o código foi rodado por mim; o grupo leu as saídas e decidiu, mas não digitou. No começo, o grupo achou que a Aula 07 já estava feita: o consolidado no repositório era a teoria do Lucas, não a Parte D.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 08):** o motor está com `modelo = "bm25"`, `prf_k = 0`, stopwords curtas; o reordenador da Aula 08 vai reler o topo do BM25. Não há PRF × LSA a decidir. O guia da Aula 08 Parte D não está no repositório do grupo (há uma cópia em `danilopradooficial/projetointegrador3`, `materiais-tutora/`).
- **Tarefa do grupo (análise LSA × BM25):** feita. Onde o LSA ganhou, q14 ($k = 50$, AP $0{,}312 \to 0{,}556$): o LSA pôs em 1º o relevante `be66af`, sobre o incêndio de 2015 na Alemoa, porque olha o assunto do texto inteiro e não só a contagem das palavras. Onde perdeu, q01 ($k = 20$, AP $1{,}000 \to 0{,}500$): pôs em 1º o `54eb31` (grau 0), 12 palavras sobre o terminal Baoshan, que só afirma detalhes do terminal. Texto completo na seção 6 da ficha.
- **Perguntas guardadas:** nenhuma.
- **Produzido:** ver a entrada "Aula 07 Parte D" na linha do tempo da ficha do projeto.
- **Ficha atualizada:** sim — seções alteradas: 5, 6, 7 e cabeçalho; seção 8 gerada por `anexar_estado()`.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-08 05:15 · R version 4.6.1 (2026-06-24) · motor07 v1 2026-10-15 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
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
| `cfg$grupo` | character | 1 | Enem |
| `consultas` | character, nomeado | 20 | q01 movimentacao cargas importa..., q02 movimentacao conteineres sa..., q03 historia desenvolvimento po..., q04 expansao construcao termina..., q05 profundidade calado dragage..., q06 acesso ferroviario rodoviar..., ... |
| `cp` | data.frame | 60 × 3 | colunas: texto, fonte, id |
| `dev` | character | 11 | q01, q04, q06, q08, q10, q11, ... |
| `docs` | character, nomeado | 60 | doc-fecae25906e7b91c o porto de roterdao portugu..., doc-1dca3350bc9b993d paises baixos de 1962 ate 2..., doc-01f9b4f10d310241 roterda foi o setimo maior ..., doc-09c80f2d1ecbbb22 roterda agora estende se po..., doc-95b16c205f58c0a3 portos em torno de nieuw ma..., doc-e6e35237be5c264b e valorizado a area de maas..., ... |
| `f` | character | 1 | aula07_parteD_consolidado.md |
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
| `m20$U` | matrix | 1229 × 20 | linhas: 000, 03, 1, ... \| colunas: (sem nomes) |
| `m20$S` | numeric | 20 | 52.05, 41.72, 39.5, 36.92, 35.23, 33.24, ... |
| `m20$D` | matrix | 60 × 20 | linhas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, ... \| colunas: (sem nomes) |
| `MOTOR_VERSAO` | character | 1 | motor07 v1 2026-10-15 |
| `ms$k10` | list | 3 | elementos: U, S, D |
| `ms$k20` | list | 3 | elementos: U, S, D |
| `ms$k50` | list | 3 | elementos: U, S, D |
| `nec` | data.frame | 20 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `q` | character | 1 | q01 |
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
| `r` | character | 1 | hib.k50 |
| `rb` | numeric, nomeado | 60 | doc-eb2430c7a98d9748 9.467, doc-77019194da3c538e 4.896, doc-65b06580ad1d7e3a 4.598, doc-54eb3169714cc9ef 3.741, doc-d5e0c45cb91c9866 3.741, doc-7840f74f5d343cdd 2.928, ... |
| `REPO` | character | 1 | https://raw.githubuserconte... |
| `rl` | numeric, nomeado | 60 | doc-54eb3169714cc9ef 0.8704, doc-eb2430c7a98d9748 0.8581, doc-7840f74f5d343cdd 0.8294, doc-d5e0c45cb91c9866 0.8102, doc-37b06b360d428b99 0.7807, doc-5c233ac3a9ebb8e4 0.7781, ... |
| `s$d` | numeric | 60 | 52.05, 41.72, 39.5, 36.92, 35.23, 33.24, ... |
| `s$u` | matrix | 1229 × 60 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `s$v` | matrix | 60 × 60 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `so_lsa` | character | 2 | doc-7840f74f5d343cdd, doc-37b06b360d428b99 |
| `tab_dev` | matrix | 7 × 11 | linhas: bm25, lsa.k10, lsa.k20, ... \| colunas: q01, q04, q06, q08, ... |
| `teste` | character | 0 |  |
| `usar` | character | 11 | q01, q04, q06, q08, q10, q11, ... |

### Funções definidas

`anexar_estado`, `ap`, `ap_modelo`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `metricas`, `montar`, `ndcg`, `norm_cols`, `precisao_k`, `preparar`, `prf`, `ranking_bm25`, `ranking_cosseno`, `ranking_lsa`, `ranking_modelo`, `ranking_motor`, `ranking_vetor`, `recall_k`, `relevancia`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

