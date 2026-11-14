# Consolidado — PI III — Aula 08 — Tema 2 (frase exata) — 14/11/2026
*guia versão 1 · tutora: Claude (Claude Code, com execução no R local) · motor08 (o motor09 ainda não está publicado: o endereço dá 404)*
**Aluno:** Pedro Santos Malaquias Rodrigues

## 1. O que foi passado
- M1 — índice posicional e frase: $\text{frase}(q, d) = \big|\bigcap_i (P_i - (i-1))\big|$; ninguém tem "modelo de recuperacao"; "modelo de" só em `d2`; Checkpoint 1: "a busca" só em `d5`
- M2 — frase sozinha não muda nada (empate geral, ordem do estágio 1, AP $0{,}833$); trecho mais longo: `d2` $\frac{2}{3}$, `d3` e `d1` $\frac{1}{3}$, novo top-3 `d2 d3 d1`, AP $0{,}833 \to 1$ com $k = 3$ (com $k = 1$ ou $2$, nada muda); "documentos busca": $\frac{1}{2}$ para os três, nada muda
- M3 — rigidez: sem stopwords, "modelo do espaco" casa com "modelo de espaco", e na consulta do gabarito tudo empata em $\frac{1}{2}$ (o BM25 cai a AP $0{,}5$); acento vira "recupera o" sem erro (o `translit` conserta); plural não casa; Checkpoint 3: $0$ com o `cfg`, $1$ sem stopwords
- M4 — no corpus do grupo (60 documentos, 11 consultas dev, teste vazio): a frase inteira não aparece no top-10 de nenhuma consulta; MAP do estágio 1 $0{,}907$; coluna frase $0{,}907$ em todos os $k$; trecho $0{,}862$ ($k = 3$), $0{,}843$ ($k = 5$), $0{,}821$ ($k = 10$); o trecho não ajudou em nenhuma consulta e atrapalhou em q14 e q15 (q15: $-0{,}417$ com $k = 3$). **Decisão:** não reordenar por frase nem por trecho. Sem relato de teste hoje.
- As funções `reordenar`, `frase` e `trecho` foram escritas pela tutora no R local, porque o `motor08` não traz `reordenar` nem `proximidade`.

## 2. Como foi o aprendizado — opinião da tutora
Percorremos os quatro módulos em múltipla escolha, com uma conta por mensagem, como pedia o consolidado da teoria. Pedro foi bem nas perguntas de leitura de sequência: acertou o `d7` de "a busca", o trecho $\frac{2}{3}$ do `d2`, o $\frac{1}{2}$ dos três em "documentos busca", o "modelo do espaco" sem stopwords, a queda do `d2` para $\frac{1}{2}$ e o Checkpoint 3. Os erros seguiram um padrão. Primeiro, ele achou que "algo em comum" não existia quando as duas listas tinham o mesmo número (o $\{5\}$ do `d5`). Segundo, achou que ordenar zeros daria erro no R. Terceiro, desempatou `d3` e `d1` fora da ordem do estágio 1. Por último, achou que o R lidaria sozinho com acento e plural. Todos esses erros foram corrigidos pela saída do R e, depois, não se repetiram. No Módulo 4, a primeira escolha foi o trecho com $k = 3$ ("o melhor do trecho"). Com a tabela lado a lado (MAP $0{,}862$ contra $0{,}907$, zero consultas ganhas), ele mudou sozinho para não reordenar. O código foi todo rodado por mim; ele leu as saídas e decidiu, mas não digitou.
**Teste final:** acertou M1, M2, M3 e M4; a revisar: nenhum módulo no teste, mas o desempate pela ordem do estágio 1 e a rigidez com acentos e plural erraram durante a sessão.

## 3. Observações para a frente
- **Revisar:** a regra do desempate (empate fica na ordem do estágio 1); que o R compara tokens letra por letra (acento e plural quebram a frase sem aviso); que $P_2 - 1$ em comum com $P_1$ significa a frase presente.
- **Perguntas guardadas:** nenhuma.
- **Para o grupo:** levar à apresentação que as consultas do grupo são listas de palavras-chave, então frase exata e trecho não ajudam neste corpus. O `config.R` continua com `rerank_k = 3` e `janela = 3` (proximidade, Parte D), que também fica abaixo de não reordenar ($0{,}847$ contra $0{,}907$): vale rediscutir. O conjunto `teste` está vazio, e nenhuma decisão da Aula 08 foi confirmada fora do dev.
- **Para a próxima tutora:** o `motor09.R` não existe no repositório do curso; o `motor08.R` tem BOM no começo (carregar com `encoding = "UTF-8-BOM"`).

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-14 20:29 · R version 4.6.1 (2026-06-24 ucrt) · motor08 v2 2026-10-22 · não edite à mão*

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
| `f_esc` | character | 1 | nenhuma |
| `grade` | matrix | 3 × 2 | linhas: k3, k5, k10 \| colunas: frase, trecho |
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
| `k_esc` | numeric | 1 | 0 |
| `m` | NULL | 0 |  |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
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

