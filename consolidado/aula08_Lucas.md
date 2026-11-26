# Consolidado — PI III — Aula 08 — Tema 2 (frase exata) — 26/11/2026
*guia versão 1 · tutora: Claude (chat), em duas sessões · motor08 (o motor09 não foi disponibilizado; o `reordenar` usado foi uma versão provisória escrita na sessão)*
**Aluno:** Lucas Murinelly Feliciano

## 1. O que foi passado
- M1 — índice posicional e frase: $\text{frase}(q,d)=\left|\bigcap_{i=1}^{n}(P_i-(i-1))\right|$. Ninguém tem "modelo de recuperacao"; "modelo de" só em `d2`. Funções `posicoes` e `frase`.
- M2 — frase sozinha não muda nada (AP $0{,}833$). Trecho mais longo: `d2` $\frac{2}{3}$, AP $0{,}833 \to 1$. Função `trecho`. Empate no escore mantém a ordem do BM25.
- M3 — rigidez: sem stopwords `d2` perde o destaque (empata em $\frac{1}{2}$ e cai para a 4ª posição); acento vira "recupera o"; plural `modelos` não casa com `modelo`.
- M4 — corpus do grupo (60 documentos, estágio 1 = BM25, 11 consultas, todas de dev; nenhuma de teste).
  - A frase inteira aparece no top-10 de 0 das 11 consultas; coluna `frase` igual ao estágio 1 (MAP $0{,}907$).
  - Trecho piora o MAP: $0{,}862$, $0{,}843$ e $0{,}821$ para $k = 3, 5, 10$. Só duas consultas mudaram: `q14` ($-0{,}083$) e `q15` ($-0{,}417$). Nenhuma melhorou.
  - Em `q15`, um documento sem grau no gabarito subiu por ter trecho $\frac{2}{7}$ contra $\frac{1}{7}$; AP de $1$ para $\frac{7}{12}$.
  - "incendio porto" não aparece colado em nenhum dos 60 documentos (`incendio` em 4, `porto` em 36, 3 com ambos, separados por palavras como `historia`).
  - Pelos dados do dev, não reordenar (manter o BM25). A decisão é do grupo.

## 2. Como foi o aprendizado — opinião da tutora
Entendeu bem a ideia central: a frase exige tokens colados e idênticos, e o trecho premia pedaço colado, não relevância. Explicou com as próprias palavras por que o trecho piora e por que o empate preserva o BM25. A dificuldade foi sempre a mesma: a conta de interseção à mão, em especial quando o resultado é vazio (resposta certa $0$). Errou isso no Checkpoint 1 e de novo no teste final. Também errou duas previsões sobre `cfg` e `da`/`de`, quando as palavras têm que ser idênticas. Questionou com bom critério a falta de teste e a ausência de efeito da frase no corpus do grupo.

**Teste final:** acertou M2 e M4; a revisar M1 e M3 — interseção vazia dá $0$; `da` e `de` só casam se as stopwords forem removidas.

## 3. Observações para a frente
- **Revisar:** interseção vazia $\Rightarrow$ $0$; contar o tamanho do conjunto $|\cdot|$, não ler a posição; tokens idênticos (sem stopwords, `da` $\neq$ `de`).
- **Perguntas guardadas:** por que as 9 consultas de `nec` (`q02`, `q03`, `q05`, `q07`, `q09`, `q12`, `q13`, `q19`, `q20`), todas com $0$ relevantes, ficaram fora do `usar` — Aula 08. Checar o tamanho das consultas do dev (`sapply(E$qts[dev], length)`), que não foi rodado.
- **Para o grupo:** (1) as 20 consultas estão marcadas como dev e não há teste: sem teste não há medição final; (2) frase inteira com $0$ de 11, e o texto do corpus tem palavras no meio; (3) trecho não ajudou no dev; (4) decidir $k$ e a versão, ou manter o BM25.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-26 23:53 · R version 4.6.1 (2026-06-24) · motor08 v2 2026-10-22 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `ambos` | character | 3 | doc-9f69a04e49fbc49b, doc-3630de3baf43985a, doc-895fa264b77fe72a |
| `ap0` | numeric, nomeado | 11 | q01 1, q04 1, q06 1, q08 0.6667, q10 1, q11 1, ... |
| `ap1` | numeric, nomeado | 11 | q01 1, q04 1, q06 1, q08 0.6667, q10 1, q11 1, ... |
| `avgdl` | numeric | 1 | 30.52 |
| `b` | numeric | 1 | 0.75 |
| `base` | numeric, nomeado | 60 | doc-e6e35237be5c264b 0.1383, doc-3920f91f96c67fe8 0.1325, doc-28a6b0ff0368e381 0.1252, doc-0279001a1a60b9ae 0.1129, doc-db8517f307829d06 0.1024, doc-65b06580ad1d7e3a 0.1023, ... |
| `candidatos_por_consulta$q01` | character | 1 | doc-eb2430c7a98d9748 |
| `candidatos_por_consulta$q02` | character | 1 | doc-543790f4a0744d86 |
| `candidatos_por_consulta$q03` | character | 2 | doc-fecae25906e7b91c, doc-09c80f2d1ecbbb22 |
| `candidatos_por_consulta$q04` | character | 2 | doc-c97f55cd190b8eda, doc-2ac1452fe6a0f227 |
| `candidatos_por_consulta$q05` | character | 1 | doc-21b74f8cdba51a41 |
| `candidatos_por_consulta$q06` | character | 1 | doc-5c233ac3a9ebb8e4 |
| `candidatos_por_consulta$q07` | character | 1 | doc-7840f74f5d343cdd |
| `candidatos_por_consulta$q08` | character | 1 | doc-92129bb62291df53 |
| `candidatos_por_consulta$q09` | character | 2 | doc-a3276b08b5b119d8, doc-543790f4a0744d86 |
| `candidatos_por_consulta$q10` | character | 1 | doc-65b06580ad1d7e3a |
| `candidatos_por_consulta$q11` | character | 2 | doc-a3276b08b5b119d8, doc-3920f91f96c67fe8 |
| `candidatos_por_consulta$q12` | character | 2 | doc-4a66b7c1a6d42c6f, doc-543790f4a0744d86 |
| `candidatos_por_consulta$q13` | character | 1 | doc-79bf3835d1d77ed8 |
| `candidatos_por_consulta$q14` | character | 1 | doc-895fa264b77fe72a |
| `candidatos_por_consulta$q15` | character | 2 | doc-be66af09907c9837, doc-9f69a04e49fbc49b |
| `candidatos_por_consulta$q16` | character | 3 | doc-3920f91f96c67fe8, doc-28a6b0ff0368e381, doc-d0ed531787149512 |
| `candidatos_por_consulta$q17` | character | 1 | doc-28a6b0ff0368e381 |
| `candidatos_por_consulta$q18` | character | 1 | doc-28a6b0ff0368e381 |
| `candidatos_por_consulta$q19` | character | 1 | doc-fecae25906e7b91c |
| `candidatos_por_consulta$q20` | character | 2 | doc-fecae25906e7b91c, doc-543790f4a0744d86 |
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
| `cfs$limpar` | logical | 1 | TRUE |
| `cfs$acentos` | character | 1 | manter |
| `cfs$stopwords` | character | 10 | de, o, a, e, um, por, ... |
| `cfs$k1` | numeric | 1 | 1.2 |
| `cfs$b` | numeric | 1 | 0.75 |
| `cfs$limiar` | numeric | 1 | 2 |
| `cfs$prf_k` | numeric | 1 | 0 |
| `cfs$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `cfs$modelo` | character | 1 | bm25 |
| `cfs$lsa_k` | numeric | 1 | 2 |
| `cfs$rrf_c` | numeric | 1 | 60 |
| `chave` | character | 29 | q01\|\|doc-eb2430c7a98d9748, q02\|\|doc-543790f4a0744d86, q03\|\|doc-fecae25906e7b91c, q03\|\|doc-09c80f2d1ecbbb22, q04\|\|doc-c97f55cd190b8eda, q04\|\|doc-2ac1452fe6a0f227, ... |
| `chave_final` | character | 29 | q12\|\|doc-543790f4a0744d86, q04\|\|doc-c97f55cd190b8eda, q01\|\|doc-eb2430c7a98d9748, q17\|\|doc-28a6b0ff0368e381, q08\|\|doc-92129bb62291df53, q03\|\|doc-09c80f2d1ecbbb22, ... |
| `consulta` | character | 1 | porto santos terminais |
| `consulta_atual` | character | 1 | santos xangai roterda carga... |
| `consultas` | character, nomeado | 20 | q01 movimentacao cargas importa..., q02 movimentacao conteineres sa..., q03 historia desenvolvimento po..., q04 expansao construcao termina..., q05 profundidade calado dragage..., q06 acesso ferroviario rodoviar..., ... |
| `contador` | numeric | 1 | 30 |
| `conteudo_para_id` | character | 60 | Porto_de_Roterdão\|\|o porto ..., Porto_de_Roterdão\|\|paises b..., Porto_de_Roterdão\|\|roterda ..., Porto_de_Roterdão\|\|roterda ..., Porto_de_Roterdão\|\|portos e..., Porto_de_Roterdão\|\|e valori..., ... |
| `corpus` | data.frame | 60 × 3 | colunas: paragrafo, fonte, id |
| `corpus_export` | data.frame | 60 × 3 | colunas: texto, fonte, id |
| `cp` | data.frame | 60 × 3 | colunas: texto, fonte, id |
| `dev` | character | 11 | q01, q04, q06, q08, q10, q11, ... |
| `df` | numeric, nomeado | 914 | 000 1, 03 1, 1 1, 10 2, 100 1, 105 1, ... |
| `dif` | numeric, nomeado | 11 | q01 0, q04 0, q06 0, q08 0, q10 0, q11 0, ... |
| `dl` | numeric, nomeado | 60 | doc-fecae25906e7b91c 15, doc-1dca3350bc9b993d 15, doc-01f9b4f10d310241 16, doc-09c80f2d1ecbbb22 17, doc-95b16c205f58c0a3 19, doc-e6e35237be5c264b 15, ... |
| `Dnr` | character | 0 |  |
| `doc_id` | character | 1 | doc-543790f4a0744d86 |
| `docs` | character, nomeado | 60 | doc-fecae25906e7b91c o porto de roterdao portugu..., doc-1dca3350bc9b993d paises baixos de 1962 ate 2..., doc-01f9b4f10d310241 roterda foi o setimo maior ..., doc-09c80f2d1ecbbb22 roterda agora estende se po..., doc-95b16c205f58c0a3 portos em torno de nieuw ma..., doc-e6e35237be5c264b e valorizado a area de maas..., ... |
| `Dr` | character | 2 | doc-28a6b0ff0368e381, doc-3920f91f96c67fe8 |
| `Dr_v` | character | 2 | doc-3920f91f96c67fe8, doc-28a6b0ff0368e381 |
| `duplo` | data.frame | 6 × 2 | colunas: consulta, documento |
| `E$rks` | list | 11 | elementos: q01, q04, q06, q08, q10, q11, q14, q15, ... |
| `E$qts` | list | 11 | elementos: q01, q04, q06, q08, q10, q11, q14, q15, ... |
| `E$qrels` | list | 20 | elementos: q01, q02, q03, q04, q05, q06, q07, q08, ... |
| `E$tokens` | list | 60 | elementos: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, doc-95b16c205f58c0a3, doc-e6e35237be5c264b, doc-11237fcb5e042bfd, doc-fec162740cbeb223, ... |
| `E$limiar` | numeric | 1 | 2 |
| `f` | NULL | 0 |  |
| `faltando` | character | 0 |  |
| `fi` | integer, nomeado | 60 | doc-fecae25906e7b91c 0, doc-1dca3350bc9b993d 0, doc-01f9b4f10d310241 0, doc-09c80f2d1ecbbb22 0, doc-95b16c205f58c0a3 0, doc-e6e35237be5c264b 0, ... |
| `fora` | character | 9 | q02, q03, q05, q07, q09, q12, ... |
| `fora_v` | character | 2 | doc-3920f91f96c67fe8, doc-28a6b0ff0368e381 |
| `fr` | integer, nomeado | 8 | d1 0, d2 0, d3 0, d4 0, d5 0, d6 0, ... |
| `freq_sorted` | table, nomeado | 914 | port 81, sant 26, xanga 26, are 18, sao 18, cidad 16, ... |
| `frequencia` | table, nomeado | 914 | 000 1, 03 1, 1 1, 10 2, 100 1, 105 1, ... |
| `g` | numeric, nomeado | 8 | d1 1, d2 2, d3 2, d4 0, d5 0, d6 1, ... |
| `grade` | matrix | 3 × 2 | linhas: (sem nomes) \| colunas: frase, trecho |
| `idf` | numeric, nomeado | 914 | 000 3.705, 03 3.705, 1 3.705, 10 3.195, 100 3.705, 105 3.705, ... |
| `idf_tfidf` | numeric, nomeado | 914 | 000 4.094, 03 4.094, 1 4.094, 10 3.401, 100 4.094, 105 4.094, ... |
| `ids` | character | 2 | doc-fecae25906e7b91c, doc-543790f4a0744d86 |
| `idx_duplo` | integer | 6 | 29, 25, 1, 6, 13, 15 |
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
| `ix_aula$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix_aula$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix_aula$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix_aula$N` | integer | 1 | 8 |
| `ix_aula$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix_aula$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix_aula$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix_aula$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix_aula$postings` | list | 45 | elementos: recuperacao, de, informacao, ordena, documentos, por, relevancia, o, ... |
| `ix_aula$dl` | numeric, nomeado | 8 | d1 7, d2 9, d3 9, d4 6, d5 9, d6 8, ... |
| `ix_aula$avgdl` | numeric | 1 | 8 |
| `ix_aula$idf_bm25` | numeric, nomeado | 45 | a 0.6931, acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, ... |
| `ixs$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ixs$vocab` | character | 37 | acelera, aprendizado, avaliacao, bm25, busca, capturam, ... |
| `ixs$tf` | matrix | 37 × 8 | linhas: acelera, aprendizado, avaliacao, ... \| colunas: d1, d2, d3, d4, ... |
| `ixs$N` | integer | 1 | 8 |
| `ixs$df` | numeric, nomeado | 37 | acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, capturam 1, ... |
| `ixs$idf_tfidf` | numeric, nomeado | 37 | acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, capturam 2.079, ... |
| `ixs$w` | matrix | 37 × 8 | linhas: acelera, aprendizado, avaliacao, ... \| colunas: d1, d2, d3, d4, ... |
| `ixs$wn` | matrix | 37 × 8 | linhas: acelera, aprendizado, avaliacao, ... \| colunas: d1, d2, d3, d4, ... |
| `ixs$postings` | list | 37 | elementos: recuperacao, informacao, ordena, documentos, relevancia, modelo, espaco, vetorial, ... |
| `ixs$dl` | numeric, nomeado | 8 | d1 5, d2 6, d3 5, d4 5, d5 7, d6 5, ... |
| `ixs$avgdl` | numeric | 1 | 5.5 |
| `ixs$idf_bm25` | numeric, nomeado | 37 | acelera 1.792, aprendizado 1.792, avaliacao 1.792, bm25 1.792, busca 1.281, capturam 1.792, ... |
| `k` | character | 1 | k5 |
| `k_esc` | numeric | 1 | 3 |
| `k_grupo` | logical | 1 | NA |
| `k_modelo` | numeric | 1 | 1 |
| `k1` | numeric | 1 | 1.2 |
| `ks` | numeric | 3 | 10, 20, 50 |
| `linhas_pool` | list | 29 | elementos: (sem nomes) |
| `m` | NULL | 0 |  |
| `m20$U` | matrix | 1229 × 20 | linhas: 000, 03, 1, ... \| colunas: (sem nomes) |
| `m20$S` | numeric | 20 | 52.05, 41.72, 39.5, 36.92, 35.23, 33.24, ... |
| `m20$D` | matrix | 60 × 20 | linhas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, ... \| colunas: (sem nomes) |
| `map0` | numeric | 1 | 0.9072 |
| `MOTOR_VERSAO` | character | 1 | motor08 v2 2026-10-22 |
| `ms$k10` | list | 3 | elementos: U, S, D |
| `ms$k20` | list | 3 | elementos: U, S, D |
| `ms$k50` | list | 3 | elementos: U, S, D |
| `N` | integer | 1 | 60 |
| `n_duplo` | numeric | 1 | 6 |
| `n_qrels` | integer | 1 | 49 |
| `nec` | data.frame | 20 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `novo` | numeric, nomeado | 60 | doc-3920f91f96c67fe8 0.7764, doc-28a6b0ff0368e381 0.6211, doc-6a4c8a90c1269b98 0.1459, doc-0279001a1a60b9ae 0.1072, doc-db8517f307829d06 0.1045, doc-e6e35237be5c264b 0.1005, ... |
| `novo_v` | numeric, nomeado | 60 | doc-3920f91f96c67fe8 0.7764, doc-28a6b0ff0368e381 0.6211, doc-6a4c8a90c1269b98 0.1459, doc-0279001a1a60b9ae 0.1072, doc-db8517f307829d06 0.1045, doc-e6e35237be5c264b 0.1005, ... |
| `nv` | character | 60 | doc-895fa264b77fe72a, doc-9f69a04e49fbc49b, doc-be66af09907c9837, doc-3630de3baf43985a, doc-87eae23e5a597432, doc-c97f55cd190b8eda, ... |
| `objetos` | character | 10 | corpus, tdm, tf, w, dl, avgdl, ... |
| `p` | integer | 1 | 7 |
| `pool` | data.frame | 29 × 2 | colunas: consulta, documento |
| `pp$d1` | integer | 1 | 2 |
| `pp$d2` | integer | 1 | 3 |
| `pp$d3` | integer | 2 | 6, 8 |
| `pp$d4` | integer | 0 |  |
| `pp$d5` | integer | 0 |  |
| `pp$d6` | integer | 1 | 5 |
| `pp$d7` | integer | 0 |  |
| `pp$d8` | integer | 1 | 2 |
| `q` | character | 1 | q15 |
| `q_aula` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `q0` | numeric, nomeado | 1229 | 000 0, 03 0, 1 0, 10 0, 100 0, 105 0, ... |
| `qa` | character | 2 | a, busca |
| `qc` | data.frame | 49 × 4 | colunas: consulta, documento, grau, juiz |
| `qd` | character | 2 | documentos, busca |
| `qi` | character | 2 | incendio, porto |
| `qid` | character | 1 | q20 |
| `qm` | character | 3 | modelos, de, recuperacao |
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
| `qs` | character | 2 | modelo, recuperacao |
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
| `qw` | numeric, nomeado | 914 | 000 0, 03 0, 1 0, 10 0, 100 0, 105 0, ... |
| `r` | character | 1 | hib.k50 |
| `r_bm25` | character | 1 | doc-543790f4a0744d86 |
| `r_bool` | character | 0 |  |
| `R_q` | integer, nomeado | 20 | q01 1, q02 0, q03 0, q04 1, q05 0, q06 1, ... |
| `r_tfidf` | character | 1 | doc-fecae25906e7b91c |
| `rb` | numeric, nomeado | 8 | d3 1.873, d1 1.869, d2 1.687, d4 1.427, d8 0.519, d6 0.4925, ... |
| `rbs` | numeric, nomeado | 8 | d1 1.33, d3 1.33, d4 1.33, d2 1.235, d5 0, d6 0, ... |
| `rd` | numeric, nomeado | 8 | d5 1.878, d7 1.219, d1 0.7305, d6 0.6931, d2 0.6594, d3 0, ... |
| `regs` | character | 0 |  |
| `REPO` | character | 1 | https://raw.githubuserconte... |
| `res` | numeric, nomeado | 60 | doc-0216e3f17d8941f2.port 4.798, doc-543790f4a0744d86.port 4.129, doc-ddecd989aeefe128.port 3.56, doc-91a6d0af42b298da.port 2.851, doc-65b06580ad1d7e3a.port 2.707, doc-c97f55cd190b8eda.port 2.572, ... |
| `res_df` | data.frame | 60 × 2 | colunas: paragrafo, score |
| `ri` | numeric, nomeado | 60 | doc-9f69a04e49fbc49b 3.286, doc-895fa264b77fe72a 3.198, doc-be66af09907c9837 3.103, doc-3630de3baf43985a 2.36, doc-28a6b0ff0368e381 0.8489, doc-6a4c8a90c1269b98 0.8468, ... |
| `rk` | numeric, nomeado | 60 | doc-9f69a04e49fbc49b 6.689, doc-be66af09907c9837 5.087, doc-895fa264b77fe72a 4.602, doc-3630de3baf43985a 3.396, doc-87eae23e5a597432 3.278, doc-c97f55cd190b8eda 2.69, ... |
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
| `sc` | numeric, nomeado | 3 | doc-9f69a04e49fbc49b 0.1429, doc-be66af09907c9837 0.1429, doc-895fa264b77fe72a 0.2857 |
| `scores` | numeric, nomeado | 60 | doc-fecae25906e7b91c.port 0.7384, doc-1dca3350bc9b993d.port 0.7384, doc-01f9b4f10d310241.port 0.7305, doc-09c80f2d1ecbbb22.port 0, doc-95b16c205f58c0a3.port 0.5442, doc-e6e35237be5c264b.port 0, ... |
| `so_lsa` | character | 2 | doc-7840f74f5d343cdd, doc-37b06b360d428b99 |
| `stopwords` | character | 560 | a, acerca, adeus, agora, ainda, alem, ... |
| `tab_dev` | matrix | 7 × 11 | linhas: bm25, lsa.k10, lsa.k20, ... \| colunas: q01, q04, q06, q08, ... |
| `tdm` | matrix | 914 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `termos_consulta` | character | 3 | port, sant, termin |
| `termos_teste` | character | 3 | sant, port, cidad |
| `teste` | character | 0 |  |
| `tf` | matrix | 914 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `titulos` | character | 3 | Porto_de_Santos, Porto_de_Xangai, Porto_de_Roterdão |
| `tk` | character | 78 | em, 18, outubro, 2013, ocorreu, pior, ... |
| `tokens$doc-fecae25906e7b91c` | character | 15 | port, roterda, portugu, europ, roterd, portugu, ... |
| `tokens$doc-1dca3350bc9b993d` | character | 15 | pais, baix, 1962, ate, 2002, port, ... |
| `tokens$doc-01f9b4f10d310241` | character | 16 | roterd, setim, mund, term, contentor, manipul, ... |
| `tokens$doc-09c80f2d1ecbbb22` | character | 17 | roterd, estend, distanc, quarent, quilometr, 25, ... |
| `tokens$doc-95b16c205f58c0a3` | character | 19 | port, torn, nieuw, mathen, waalhaven, vondelingenplaat, ... |
| `tokens$doc-e6e35237be5c264b` | character | 15 | valoriz, are, maasvlakt, histor, metad, secul, ... |
| `tokens$doc-11237fcb5e042bfd` | character | 13 | waterweg, cav, roterda, mar, nort, canal, ... |
| `tokens$doc-fec162740cbeb223` | character | 13 | 1872, activ, industrial, form, margens, canal, ... |
| `tokens$doc-97a34c4835289df7` | character | 15 | europ, complex, long, foz, nieuw, waterweg, ... |
| `tokens$doc-1413d5de838236d0` | character | 13 | inicial, aprovaca, polit, 2004, interromp, raad, ... |
| `tokens$doc-7c2d2602559e107b` | character | 13 | governaca, 2005, plan, suficient, cont, questo, ... |
| `tokens$doc-4a66b7c1a6d42c6f` | character | 12 | construca, 2008, destin, navi, ancor, 2013, ... |
| `tokens$doc-37b06b360d428b99` | character | 10 | carg, port, funcion, import, transit, transport, ... |
| `tokens$doc-5c233ac3a9ebb8e4` | character | 16 | part, mund, roterda, mercador, sao, transport, ... |
| `tokens$doc-310c1524e3f8d2ad` | character | 13 | ligaca, roterd, alemanh, construca, ferrovi, neerlandes, ... |
| `tokens$doc-f5d88d23b5724d1d` | character | 16 | cidad, rios, ren, mos, proporcion, excelent, ... |
| `tokens$doc-057bf37bc31e0a02` | character | 12 | junt, terminal, pont, madeir, maranha, brasil, ... |
| `tokens$doc-21b74f8cdba51a41` | character | 14 | mineri, ferr, mund, berg, stahl, carec, ... |
| `tokens$doc-06bfb8527a70fe46` | character | 14 | quilh, navi, fund, canal, profund, 24, ... |
| `tokens$doc-501972e9e1fb7e50` | character | 15 | manobr, atrac, navi, europoort, port, transport, ... |
| `tokens$doc-543790f4a0744d86` | character | 36 | port, sant, port, estuarin, localiz, municipi, ... |
| `tokens$doc-34e10bb2c8393e95` | character | 38 | are, influenc, econom, port, concentr, aproxim, ... |
| `tokens$doc-eb2430c7a98d9748` | character | 32 | complex, portuari, sant, respond, histor, 25, ... |
| `tokens$doc-7840f74f5d343cdd` | character | 18 | 2016, consider, 39, port, mund, movimentaca, ... |
| `tokens$doc-77019194da3c538e` | character | 28 | operaco, carg, regia, sant, sao, vicent, ... |
| `tokens$doc-c97f55cd190b8eda` | character | 61 | 1870, coro, pass, busc, altern, expansa, ... |
| `tokens$doc-a3276b08b5b119d8` | character | 56 | port, explor, desenvolv, ampli, cds, gesta, ... |
| `tokens$doc-e192ab7f1371819c` | character | 73 | secul, xix, sant, princip, port, brasileir, ... |
| `tokens$doc-2ac1452fe6a0f227` | character | 40 | pass, estrutur, ampli, desenvolv, acord, invest, ... |
| `tokens$doc-7880e5e984c067aa` | character | 113 | are, paquet, outeirinh, marg, sant, atu, ... |
| `tokens$doc-79bf3835d1d77ed8` | character | 30 | venciment, concessa, outubr, 1980, administraca, port, ... |
| `tokens$doc-87a504ca426bc8ab` | character | 90 | codesp, oper, port, regim, monopoli, ate, ... |
| `tokens$doc-ddecd989aeefe128` | character | 35 | 15, 12, 2010, port, sant, receb, ... |
| `tokens$doc-cd70e786cc51ac19` | character | 37 | semestr, 2018, govern, federal, realiz, compr, ... |
| `tokens$doc-92129bb62291df53` | character | 23 | outubr, 2019, codesp, inic, process, remodelag, ... |
| `tokens$doc-9f69a04e49fbc49b` | character | 59 | 18, outubr, 2013, ocorr, pior, incendi, ... |
| `tokens$doc-3630de3baf43985a` | character | 47 | seguint, 03, agost, 2014, incendi, proporco, ... |
| `tokens$doc-895fa264b77fe72a` | character | 24 | cerc, 20, outubr, 2014, incendi, destru, ... |
| `tokens$doc-be66af09907c9837` | character | 76 | 2, abril, 2015, principi, incendi, termin, ... |
| `tokens$doc-0216e3f17d8941f2` | character | 41 | estuari, port, sant, brac, d, agu, ... |
| `tokens$doc-6a4c8a90c1269b98` | character | 36 | port, xanga, port, termin, maritim, agu, ... |
| `tokens$doc-d0ed531787149512` | character | 9 | 2016, port, xanga, estabelec, record, histor, ... |
| `tokens$doc-5485d2abaff10c59` | character | 21 | port, xanga, banh, mar, chin, oriental, ... |
| `tokens$doc-d1794bb991a87091` | character | 24 | port, administr, oper, shangha, international, port, ... |
| `tokens$doc-0279001a1a60b9ae` | character | 50 | histor, port, xanga, paralel, cidad, evidenc, ... |
| `tokens$doc-a10adea04287090a` | character | 32 | dinast, ming, 1368, 1644, oferec, avanc, ... |
| `tokens$doc-3920f91f96c67fe8` | character | 78 | dinast, qing, 1644, 1912, responsavel, elev, ... |
| `tokens$doc-f0dc2e2894423c43` | character | 21 | rebelia, taiping, 1850, 1864, reconhec, confront, ... |
| `tokens$doc-db8517f307829d06` | character | 23 | 1860, 1895, chin, pass, process, modernizaca, ... |
| `tokens$doc-56713a5bb7e8f872` | character | 49 | batalh, xanga, 1937, japa, assum, control, ... |
| `tokens$doc-28a6b0ff0368e381` | character | 46 | 1991, govern, central, permit, xanga, inic, ... |
| `tokens$doc-ef7f4ea1250cd201` | character | 21 | port, xanga, administr, shangha, international, port, ... |
| `tokens$doc-65b06580ad1d7e3a` | character | 49 | port, xanga, possu, numer, signific, are, ... |
| `tokens$doc-cfc6cc91aacf0b8d` | character | 11 | sipg, carva, responsavel, transport, 30, milho, ... |
| `tokens$doc-91a6d0af42b298da` | character | 14 | sipg, zhanghuabang, company, usad, transport, aco, ... |
| `tokens$doc-7e5ba3b3ebe57c3e` | character | 10 | sipg, jungong, road, branch, aco, ferr, ... |
| `tokens$doc-54eb3169714cc9ef` | character | 9 | sipg, baoshan, terminal, branch, transport, armazen, ... |
| `tokens$doc-d5e0c45cb91c9866` | character | 10 | sipg, longwu, branch, empres, subsidi, sipg, ... |
| `tokens$doc-9775d6ed4fab1088` | character | 9 | termin, xanga, luojing, ore, co, ltd, ... |
| `tokens$doc-87eae23e5a597432` | character | 66 | wusongk, port, antig, xanga, localiz, foz, ... |
| `top10` | table, nomeado | 10 | port 81, sant 26, xanga 26, are 18, sao 18, cidad 16, ... |
| `total_julgamentos` | integer | 1 | 35 |
| `tr` | numeric, nomeado | 8 | d1 0.3333, d2 0.6667, d3 0.3333, d4 0.3333, d5 0, d6 0.3333, ... |
| `trd` | numeric, nomeado | 8 | d1 0.5, d2 0.5, d3 0, d4 0, d5 0.5, d6 0.5, ... |
| `trs` | numeric, nomeado | 8 | d1 0.5, d2 0.5, d3 0.5, d4 0.5, d5 0, d6 0, ... |
| `usar` | character | 11 | q01, q04, q06, q08, q10, q11, ... |
| `vocab` | character | 914 | 000, 03, 1, 10, 100, 105, ... |
| `w` | matrix | 914 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `wn` | matrix | 914 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |

### Funções definidas

`anexar_estado`, `ap`, `ap_modelo`, `ap_q`, `ap_rerank`, `baixar_sites`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `buscar_bm25_pool`, `buscar_booleano_pool`, `buscar_tfidf_pool`, `cfg_aula`, `cosseno`, `cosseno_pool`, `criar_20_documentos`, `dcg`, `docs_aula`, `estado`, `estagio1`, `f_esc`, `frase`, `gabarito_aula`, `graus_top5`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `lsa`, `matriz_tf`, `md5_texto`, `med`, `metricas`, `montar`, `ndcg`, `norm_cols`, `pool_booleano`, `posicoes`, `precisao_k`, `preparar`, `prf`, `processar_consulta`, `processar_consulta_pool`, `proximidade`, `ranking_bm25`, `ranking_cosseno`, `ranking_final`, `ranking_lsa`, `ranking_modelo`, `ranking_motor`, `ranking_vetor`, `recall_k`, `relevancia`, `reordenar`, `rerank_prox`, `residual`, `rocchio`, `rr`, `rrf`, `saturacao`, `sem_stop`, `stopwords_aula`, `tem`, `tokenizar`, `trecho`, `vetor_consulta`
<!-- estado-R:fim -->

