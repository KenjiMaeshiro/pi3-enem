# Consolidado — PI III — Aula 06 — Parte D — 07/11/2026
*guia versão 1 · tutor: Claude (duas sessões no mesmo dia; a segunda, no Claude Code, com execução no R local e no Colab) · sessão de grupo · motor06*
**Grupo:** Enem · **presentes:** Pedro Santos; Lucas Murinelly Feliciano (julgamentos de q08, q10, q18 e q11) · **digitou:** M7 e M8 (primeira sessão): o grupo, no Colab; M8 (rodada final), registro do gabarito, M9 no `config.R` e `anexar_estado()`: o tutor, a pedido de Pedro, no Colab e no R local

## 1. O que foi feito
- M7 — Rocchio no gabarito do grupo, na consulta q16 ($D_r$ = 2 relevantes, $D_{nr}$ vazio, porque não há grau 0 no top-5 da base): AP completo $0{,}583 \to 1{,}000$; residual `NA` nos dois, com $R = 0$, porque os dois relevantes estavam no top-5. O ganho da completa vem dos próprios documentos marcados.
- M8 — pseudo-realimentação nas 11 consultas avaliadas, todas `dev`; sem conjunto de teste. O *drift* foi lido documento a documento: em q08, q11 e q18, um documento de grau 1 ou sem grau entrava em $D_r$ e subia acima do relevante. O grupo julgou esses documentos (q08, q10, q18, q11) e depois os 16 documentos sem grau do top-3 da base, numa planilha embaralhada. O gabarito foi de 29 para 49 pares. MAP dev: base $0{,}908$; $k = 2$: $0{,}859$; $k = 3$: $0{,}915$; $k = 5$: $0{,}853$.
- M9 — decisão: **não usar a PRF** (`prf_k = 0`), porque o ganho de MAP é pequeno ou negativo e ela piora consultas que a base acerta (q08 e q11). A decisão está no `config.R` e na seção 6 da ficha. A ficha original se perdeu e foi reconstruída a partir dos consolidados e dos guias.

## 2. Como o grupo trabalhou — opinião do tutor
As funções `rocchio`, `prf` e `ap_q` foram escritas na primeira sessão, no Colab; na segunda, eu as reconstruí a partir do guia e conferi que reproduziam a tabela anterior exatamente antes de usar qualquer número novo. O grupo chegou a entender por que a completa é otimista (Checkpoint 7, com uma correção: a residual fica `NA` porque não sobra relevante, não porque "zerou"). O ponto mais forte foi o *drift*: o grupo olhou o top-$k$ de cada consulta que piorou e foi julgar os documentos que estavam causando a queda. O ponto mais fraco foi o mesmo gesto feito tarde: q10 e q18 foram julgados depois de ver o efeito na PRF, e em 5 pares do top-3 quem julgou já tinha visto o ranking. Isso está registrado no gabarito, e parte do ganho de $k = 3$ vem desses graus. O $k$ foi olhado só no desenvolvimento, porque não há teste. A decisão saiu do grupo: Pedro pediu a minha sugestão, eu devolvi as perguntas do guia, e o grupo escolheu "não usar" com o porquê. Na segunda sessão, muito do que foi rodado foi digitado por mim, a pedido de Pedro; o grupo acompanhou os resultados e tomou as decisões, mas não digitou o código dessa parte.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 07):** decidir `cfg$stopwords` (o pipeline próprio usava `stopwords-iso` + stemming; o motor não faz stemming); conferir `cfg$minimo` (o `config.R` diz 200, o grupo usou 10 palavras); preencher os campos `—` da ficha (as três perguntas da Aula 01, presentes por aula); escrever a tarefa do grupo (análise em prosa da consulta com *drift*: quais termos entraram e por quê); cada integrante enviar o seu consolidado da teoria; o `motor07.R` deu 404 numa sessão da teoria, conferir antes da aula.
- **Limitação registrada:** os 20 documentos de Roterdã são janelas de ~28 palavras, não parágrafos (o artigo tem só 6 parágrafos válidos). O grupo decidiu manter o corpus congelado.
- **Perguntas guardadas:** nenhuma.
- **Produzido:** ver a entrada "Aula 06 Parte D" na linha do tempo da ficha do projeto.
- **Ficha atualizada:** sim — reconstruída inteira; seções alteradas nesta aula: 3, 5, 6, 7 e cabeçalho; seção 8 gerada por `anexar_estado()`.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-08 00:46 · R version 4.6.1 (2026-06-24) · motor06 v2 2026-10-08 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `amostra` | data.frame | 10 × 4 | colunas: id, fonte, texto, n_palavras |
| `avgdl` | numeric | 1 | 30.52 |
| `b` | numeric | 1 | 0.75 |
| `base` | numeric, nomeado | 60 | doc-e6e35237be5c264b 0.1374, doc-3920f91f96c67fe8 0.1296, doc-28a6b0ff0368e381 0.1246, doc-0279001a1a60b9ae 0.1122, doc-db8517f307829d06 0.1014, doc-65b06580ad1d7e3a 0.09977, ... |
| `caminho_corpus` | character | 1 | corpus.csv |
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
| `cc` | data.frame | 60 × 3 | colunas: texto, fonte, id |
| `cfg$minimo` | numeric | 1 | 200 |
| `cfg$limpar` | logical | 1 | TRUE |
| `cfg$acentos` | character | 1 | translit |
| `cfg$k1` | numeric | 1 | 1.2 |
| `cfg$b` | numeric | 1 | 0.75 |
| `cfg$limiar` | numeric | 1 | 2 |
| `cfg$juizes` | character | 1 | consenso |
| `cfg$prf_k` | numeric | 1 | 0 |
| `cfg$rocchio` | numeric, nomeado | 3 | a 1, b 0.75, g 0.15 |
| `cfg$grupo` | character | 1 | Enem |
| `chave_final` | character | 29 | q12\|\|doc-543790f4a0744d86, q04\|\|doc-c97f55cd190b8eda, q01\|\|doc-eb2430c7a98d9748, q17\|\|doc-28a6b0ff0368e381, q08\|\|doc-92129bb62291df53, q03\|\|doc-09c80f2d1ecbbb22, ... |
| `codificacao_suspeita` | logical, nomeado | 60 | o porto de roterdao portugues europeu ou roterda portugues brasileiro e o maior porto maritimo da europa esta localizado na cidade de roterda na holanda do sul nos FALSE, paises baixos de 1962 ate 2002 foi o porto mais ativo do mundo atualmente foi ultrapassado por portos asiaticos como os de singapura e de xangai em 2006 FALSE, roterda foi o setimo maior do mundo em termos de contentores manipulados no porto em unidades equivalentes a 20 pes teu abrangendo 105 quilometros quadrados o porto de FALSE, roterda agora estende se por uma distancia de quarenta quilometros 25 milhas consiste na area do centro historico da cidade incluindo delfshaven o maashaven rijnhaven e feijenoord os FALSE, portos em torno de nieuw mathenesse waalhaven vondelingenplaat eemhaven botlek europoort situados ao longo da calandkanaal nieuwe waterweg e scheur este ultimo sendo os dois continuados de nieuwe maas FALSE, e valorizado a area de maasvlakte historia na primeira metade do seculo xx as atividades portuarias deslocaram se do centro oeste para o mar do norte o nieuwe FALSE, ... |
| `coluna_texto` | character | 1 | texto |
| `colunas_obrigatorias` | character | 3 | id, fonte, texto |
| `consulta` | character | 1 | porto santos terminais |
| `consulta_atual` | character | 1 | santos xangai roterda carga... |
| `consultas` | character, nomeado | 20 | q01 movimentacao cargas importa..., q02 movimentacao conteineres sa..., q03 historia desenvolvimento po..., q04 expansao construcao termina..., q05 profundidade calado dragage..., q06 acesso ferroviario rodoviar..., ... |
| `contador` | numeric | 1 | 30 |
| `conteudo_para_id` | character | 60 | Porto_de_Roterdão\|\|o porto ..., Porto_de_Roterdão\|\|paises b..., Porto_de_Roterdão\|\|roterda ..., Porto_de_Roterdão\|\|roterda ..., Porto_de_Roterdão\|\|portos e..., Porto_de_Roterdão\|\|e valori..., ... |
| `corpus` | data.frame | 60 × 3 | colunas: texto, fonte, id |
| `corpus_export` | data.frame | 60 × 3 | colunas: texto, fonte, id |
| `cp` | data.frame | 60 × 3 | colunas: texto, fonte, id |
| `desvio_palavras` | numeric | 1 | 45.94 |
| `dev` | character | 11 | q01, q04, q06, q08, q10, q11, ... |
| `df` | numeric, nomeado | 914 | 000 1, 03 1, 1 1, 10 2, 100 1, 105 1, ... |
| `distribuicao_fontes` | table, nomeado | 3 | Porto_de_Roterdão 20, Porto_de_Santos 20, Porto_de_Xangai 20 |
| `dl` | numeric, nomeado | 60 | doc-fecae25906e7b91c 15, doc-1dca3350bc9b993d 15, doc-01f9b4f10d310241 16, doc-09c80f2d1ecbbb22 17, doc-95b16c205f58c0a3 19, doc-e6e35237be5c264b 15, ... |
| `Dnr` | character | 0 |  |
| `doc_id` | character | 1 | doc-543790f4a0744d86 |
| `docs` | character, nomeado | 60 | doc-fecae25906e7b91c o porto de roterdao portugu..., doc-1dca3350bc9b993d paises baixos de 1962 ate 2..., doc-01f9b4f10d310241 roterda foi o setimo maior ..., doc-09c80f2d1ecbbb22 roterda agora estende se po..., doc-95b16c205f58c0a3 portos em torno de nieuw ma..., doc-e6e35237be5c264b e valorizado a area de maas..., ... |
| `docs_muito_curtos` | integer, nomeado | 0 |  |
| `docs_muito_longos` | integer, nomeado | 1 | a area de paqueta outeirinhos na margem direita santos entre os atuais armazens 12 e 23 que era originalmente um golfo foi aterrada para criar uma estrutura linear de cais que permitisse a atracacao de navios de maior profundidade bem como uma retroarea de armazenamento para este aterramento foi criada uma linha ferrea especial para transportar as pedras da pedreira do bairro jabaquara em uma das pontas das areas aterradas foram construidos predios para a administracao portuaria que hoje compoem a sede oficial da administracao do porto a construcao da usina hidreletrica de itatinga concluida em 1910 as margens da serra do mar foi outra obra de destaque a epoca itatinga era uma das mais importantes hidreletricas do pais em uma epoca em que poucos tinham acesso a rede eletrica eletricidade gerada por ela foi utilizada inclusive na construcao da usina hidreletrica de henry borden em cubatao por conta da localizacao da usina isolada no meio da mata atlantica a 7 km de bertioga foi construida uma vila de apoio para a residencia de funcionarios que trabalham em sua manutencao e operacao na qual chegaram a residir 70 familias simultaneamente mesmo sendo o efetivo de pessoal atual muito menor ainda hoje a usina fornece eletricidade para a operacao do porto e para suas instalacoes administrativas embora modernizada parte de sua estrutura como as turbinas por exemplo sao parte do equipamento original em continua operacao ha mais de cem anos 30 |
| `Dr` | character | 2 | doc-28a6b0ff0368e381, doc-3920f91f96c67fe8 |
| `Dr_v` | character | 2 | doc-3920f91f96c67fe8, doc-28a6b0ff0368e381 |
| `duplicados_texto` | logical | 60 | FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, ... |
| `duplo` | data.frame | 6 × 2 | colunas: consulta, documento |
| `f` | character | 1 | registro_julgamentos_aula06... |
| `faltando` | character | 0 |  |
| `fontes_vazias` | integer | 1 | 0 |
| `fora` | character | 2 | doc-28a6b0ff0368e381, doc-3920f91f96c67fe8 |
| `fora_v` | character | 2 | doc-3920f91f96c67fe8, doc-28a6b0ff0368e381 |
| `freq_sorted` | table, nomeado | 914 | port 81, sant 26, xanga 26, are 18, sao 18, cidad 16, ... |
| `frequencia` | table, nomeado | 914 | 000 1, 03 1, 1 1, 10 2, 100 1, 105 1, ... |
| `g` | numeric, nomeado | 4 | doc-d0ed531787149512 0, doc-28a6b0ff0368e381 2, doc-3920f91f96c67fe8 2, doc-e6e35237be5c264b 1 |
| `idf` | numeric, nomeado | 914 | 000 3.705, 03 3.705, 1 3.705, 10 3.195, 100 3.705, 105 3.705, ... |
| `idf_tfidf` | numeric, nomeado | 914 | 000 4.094, 03 4.094, 1 4.094, 10 3.401, 100 4.094, 105 4.094, ... |
| `ids` | character | 2 | doc-fecae25906e7b91c, doc-543790f4a0744d86 |
| `ids_duplicados` | integer | 1 | 0 |
| `ids_vazios` | integer | 1 | 0 |
| `idx_amostra` | integer | 10 | 49, 37, 1, 25, 10, 36, ... |
| `idx_duplo` | integer | 6 | 29, 25, 1, 6, 13, 15 |
| `ix$tokens` | list | 60 | elementos: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, doc-95b16c205f58c0a3, doc-e6e35237be5c264b, doc-11237fcb5e042bfd, doc-fec162740cbeb223, ... |
| `ix$vocab` | character | 1239 | 000, 03, 1, 10, 100, 105, ... |
| `ix$tf` | matrix | 1239 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `ix$N` | integer | 1 | 60 |
| `ix$df` | numeric, nomeado | 1239 | 000 1, 03 1, 1 1, 10 2, 100 1, 105 1, ... |
| `ix$idf_tfidf` | numeric, nomeado | 1239 | 000 4.094, 03 4.094, 1 4.094, 10 3.401, 100 4.094, 105 4.094, ... |
| `ix$w` | matrix | 1239 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `ix$wn` | matrix | 1239 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `ix$postings` | list | 1239 | elementos: o, porto, de, roterdao, portugues, europeu, ou, roterda, ... |
| `ix$dl` | numeric, nomeado | 60 | doc-fecae25906e7b91c 28, doc-1dca3350bc9b993d 28, doc-01f9b4f10d310241 28, doc-09c80f2d1ecbbb22 28, doc-95b16c205f58c0a3 29, doc-e6e35237be5c264b 28, ... |
| `ix$avgdl` | numeric | 1 | 57.83 |
| `ix$idf_bm25` | numeric, nomeado | 1239 | 000 3.705, 03 3.705, 1 3.705, 10 3.195, 100 3.705, 105 3.705, ... |
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
| `k` | character | 1 | k5 |
| `k_grupo` | logical | 1 | NA |
| `k_modelo` | numeric | 1 | 1 |
| `k1` | numeric | 1 | 1.2 |
| `linhas_pool` | list | 29 | elementos: (sem nomes) |
| `mais_curtos` | data.frame | 5 × 4 | colunas: id, fonte, texto, n_palavras |
| `mais_longos` | data.frame | 5 × 4 | colunas: id, fonte, texto, n_palavras |
| `media_palavras` | numeric | 1 | 57.83 |
| `MOTOR_VERSAO` | character | 1 | motor06 v2 2026-10-08 |
| `N` | integer | 1 | 60 |
| `n_amostra` | numeric | 1 | 5 |
| `n_amostra_aleatoria` | numeric | 1 | 10 |
| `n_caracteres` | integer | 60 | 163, 152, 167, 182, 200, 158, ... |
| `n_codificacao_suspeita` | integer | 1 | 0 |
| `n_documentos` | integer | 1 | 60 |
| `n_duplo` | numeric | 1 | 6 |
| `n_ids_unicos` | integer | 1 | 60 |
| `n_palavras` | numeric, nomeado | 60 | o porto de roterdao portugues europeu ou roterda portugues brasileiro e o maior porto maritimo da europa esta localizado na cidade de roterda na holanda do sul nos 28, paises baixos de 1962 ate 2002 foi o porto mais ativo do mundo atualmente foi ultrapassado por portos asiaticos como os de singapura e de xangai em 2006 28, roterda foi o setimo maior do mundo em termos de contentores manipulados no porto em unidades equivalentes a 20 pes teu abrangendo 105 quilometros quadrados o porto de 28, roterda agora estende se por uma distancia de quarenta quilometros 25 milhas consiste na area do centro historico da cidade incluindo delfshaven o maashaven rijnhaven e feijenoord os 28, portos em torno de nieuw mathenesse waalhaven vondelingenplaat eemhaven botlek europoort situados ao longo da calandkanaal nieuwe waterweg e scheur este ultimo sendo os dois continuados de nieuwe maas 29, e valorizado a area de maasvlakte historia na primeira metade do seculo xx as atividades portuarias deslocaram se do centro oeste para o mar do norte o nieuwe 28, ... |
| `n_qrels` | integer | 1 | 49 |
| `n_textos_duplicados` | integer | 1 | 0 |
| `nec` | data.frame | 20 × 5 | colunas: consulta, texto_consulta, necessidade, escopo, conjunto |
| `novo` | numeric, nomeado | 60 | doc-3920f91f96c67fe8 0.7834, doc-28a6b0ff0368e381 0.6199, doc-6a4c8a90c1269b98 0.1605, doc-87eae23e5a597432 0.118, doc-0279001a1a60b9ae 0.1174, doc-65b06580ad1d7e3a 0.1122, ... |
| `novo_v` | numeric, nomeado | 60 | doc-3920f91f96c67fe8 0.7834, doc-28a6b0ff0368e381 0.6199, doc-6a4c8a90c1269b98 0.1605, doc-87eae23e5a597432 0.118, doc-0279001a1a60b9ae 0.1174, doc-65b06580ad1d7e3a 0.1122, ... |
| `novos` | data.frame | 4 × 4 | colunas: consulta, documento, grau, juiz |
| `nv` | data.frame | 4 × 4 | colunas: consulta, documento, grau, juiz |
| `objetos` | character | 10 | corpus, tdm, tf, w, dl, avgdl, ... |
| `ordem_curto` | integer | 60 | 59, 56, 58, 57, 54, 42, ... |
| `ordem_longo` | integer | 60 | 30, 32, 47, 28, 39, 60, ... |
| `pares` | character, nomeado | 3 | q08 doc-87a504ca426bc8ab, q10 doc-3920f91f96c67fe8, q18 doc-87eae23e5a597432 |
| `pool` | data.frame | 29 × 2 | colunas: consulta, documento |
| `q` | character | 1 | q16 |
| `q_aula` | numeric, nomeado | 45 | a 0, acelera 0, aprendizado 0, avaliacao 0, bm25 0, busca 0, ... |
| `q_palavras` | numeric, nomeado | 5 | 0% 10, 25% 28, 50% 38.5, 75% 78, 100% 239 |
| `q0` | numeric, nomeado | 1239 | 000 0, 03 0, 1 0, 10 0, 100 0, 105 0, ... |
| `qc` | data.frame | 49 × 4 | colunas: consulta, documento, grau, juiz |
| `qid` | character | 1 | q20 |
| `qrels$q01` | numeric, nomeado | 3 | doc-eb2430c7a98d9748 2, doc-54eb3169714cc9ef 0, doc-d5e0c45cb91c9866 0 |
| `qrels$q02` | numeric, nomeado | 1 | doc-543790f4a0744d86 0 |
| `qrels$q03` | numeric, nomeado | 2 | doc-09c80f2d1ecbbb22 0, doc-fecae25906e7b91c 0 |
| `qrels$q04` | numeric, nomeado | 4 | doc-c97f55cd190b8eda 2, doc-2ac1452fe6a0f227 1, doc-9775d6ed4fab1088 0, doc-4a66b7c1a6d42c6f 1 |
| `qrels$q05` | numeric, nomeado | 1 | doc-21b74f8cdba51a41 1 |
| `qrels$q06` | numeric, nomeado | 3 | doc-5c233ac3a9ebb8e4 2, doc-37b06b360d428b99 0, doc-f5d88d23b5724d1d 0 |
| `qrels$q07` | numeric, nomeado | 1 | doc-7840f74f5d343cdd 0 |
| `qrels$q08` | numeric, nomeado | 3 | doc-92129bb62291df53 2, doc-79bf3835d1d77ed8 2, doc-87a504ca426bc8ab 1 |
| `qrels$q09` | numeric, nomeado | 2 | doc-543790f4a0744d86 0, doc-a3276b08b5b119d8 1 |
| `qrels$q10` | numeric, nomeado | 3 | doc-65b06580ad1d7e3a 2, doc-db8517f307829d06 2, doc-3920f91f96c67fe8 2 |
| `qrels$q11` | numeric, nomeado | 3 | doc-3920f91f96c67fe8 2, doc-a3276b08b5b119d8 2, doc-56713a5bb7e8f872 1 |
| `qrels$q12` | numeric, nomeado | 2 | doc-543790f4a0744d86 1, doc-4a66b7c1a6d42c6f 0 |
| `qrels$q13` | numeric, nomeado | 1 | doc-79bf3835d1d77ed8 0 |
| `qrels$q14` | numeric, nomeado | 4 | doc-895fa264b77fe72a 2, doc-be66af09907c9837 2, doc-0216e3f17d8941f2 0, doc-543790f4a0744d86 0 |
| `qrels$q15` | numeric, nomeado | 3 | doc-be66af09907c9837 2, doc-9f69a04e49fbc49b 2, doc-87eae23e5a597432 1 |
| `qrels$q16` | numeric, nomeado | 4 | doc-d0ed531787149512 0, doc-28a6b0ff0368e381 2, doc-3920f91f96c67fe8 2, doc-e6e35237be5c264b 1 |
| `qrels$q17` | numeric, nomeado | 3 | doc-28a6b0ff0368e381 2, doc-6a4c8a90c1269b98 1, doc-54eb3169714cc9ef 0 |
| `qrels$q18` | numeric, nomeado | 3 | doc-28a6b0ff0368e381 2, doc-65b06580ad1d7e3a 2, doc-87eae23e5a597432 2 |
| `qrels$q19` | numeric, nomeado | 1 | doc-fecae25906e7b91c 0 |
| `qrels$q20` | numeric, nomeado | 2 | doc-543790f4a0744d86 0, doc-fecae25906e7b91c 0 |
| `qw` | numeric, nomeado | 914 | 000 0, 03 0, 1 0, 10 0, 100 0, 105 0, ... |
| `r` | data.frame | 4 × 7 | colunas: consulta, documento, grau, julgou, data, criterio, obs |
| `r_bm25` | character | 1 | doc-543790f4a0744d86 |
| `r_bool` | character | 0 |  |
| `R_q` | integer, nomeado | 20 | q01 1, q02 0, q03 0, q04 1, q05 0, q06 1, ... |
| `r_tfidf` | character | 1 | doc-fecae25906e7b91c |
| `reg` | data.frame | 4 × 7 | colunas: consulta, documento, grau, julgou, data, criterio, obs |
| `regs` | character | 1 | registro_julgamentos_aula06... |
| `REPO` | character | 1 | https://raw.githubuserconte... |
| `res` | numeric, nomeado | 60 | doc-0216e3f17d8941f2.port 4.798, doc-543790f4a0744d86.port 4.129, doc-ddecd989aeefe128.port 3.56, doc-91a6d0af42b298da.port 2.851, doc-65b06580ad1d7e3a.port 2.707, doc-c97f55cd190b8eda.port 2.572, ... |
| `res_df` | data.frame | 60 × 2 | colunas: paragrafo, score |
| `resumo_palavras` | summaryDefault, nomeado | 6 | Min. 10, 1st Qu. 28, Median 38.5, Mean 57.83, 3rd Qu. 78, Max. 239 |
| `saida_resumo` | character | 23 | FICHA DO CORPUS, , Total de documentos: 60 , IDs únicos: 60 , IDs duplicados: 0 , IDs vazios: 0 , ... |
| `scores` | numeric, nomeado | 60 | doc-fecae25906e7b91c.port 0.7384, doc-1dca3350bc9b993d.port 0.7384, doc-01f9b4f10d310241.port 0.7305, doc-09c80f2d1ecbbb22.port 0, doc-95b16c205f58c0a3.port 0.5442, doc-e6e35237be5c264b.port 0, ... |
| `stopwords` | character | 560 | a, acerca, adeus, agora, ainda, alem, ... |
| `tab_dev` | matrix | 4 × 11 | linhas: base, k2, k3, ... \| colunas: q01, q04, q06, q08, ... |
| `tdm` | matrix | 914 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `termos_consulta` | character | 3 | port, sant, termin |
| `termos_teste` | character | 3 | sant, port, cidad |
| `teste` | character | 0 |  |
| `texto` | character | 60 | o porto de roterdao portugu..., paises baixos de 1962 ate 2..., roterda foi o setimo maior ..., roterda agora estende se po..., portos em torno de nieuw ma..., e valorizado a area de maas..., ... |
| `texto_normalizado` | character | 60 | o porto de roterdao portugu..., paises baixos de 1962 ate 2..., roterda foi o setimo maior ..., roterda agora estende se po..., portos em torno de nieuw ma..., e valorizado a area de maas..., ... |
| `textos_vazios` | integer | 1 | 0 |
| `tf` | matrix | 914 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `titulos` | character | 3 | Porto_de_Santos, Porto_de_Xangai, Porto_de_Roterdão |
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
| `usar` | character | 11 | q01, q04, q06, q08, q10, q11, ... |
| `vocab` | character | 914 | 000, 03, 1, 10, 100, 105, ... |
| `w` | matrix | 914 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |
| `wn` | matrix | 914 × 60 | linhas: 000, 03, 1, ... \| colunas: doc-fecae25906e7b91c, doc-1dca3350bc9b993d, doc-01f9b4f10d310241, doc-09c80f2d1ecbbb22, ... |

### Funções definidas

`anexar_estado`, `ap`, `ap_q`, `baixar_sites`, `bm25`, `bm25_doc`, `busca_AND`, `busca_booleana`, `buscar_bm25`, `buscar_bm25_pool`, `buscar_booleano`, `buscar_booleano_pool`, `buscar_tfidf`, `buscar_tfidf_pool`, `cfg_aula`, `chave`, `contar_palavras`, `cosseno`, `cosseno_pool`, `criar_20_documentos`, `dcg`, `docs_aula`, `estado`, `gabarito_aula`, `graus_top5`, `idf_bm25`, `idf_classico`, `indice_invertido`, `kappa_cohen`, `kappa_matriz`, `ler_qrels`, `limpar`, `matriz_tf`, `md5_texto`, `metricas`, `montar`, `ndcg`, `norm_cols`, `pool_booleano`, `precisao_k`, `preparar`, `prf`, `processar_consulta`, `processar_consulta_pool`, `ranking_bm25`, `ranking_cosseno`, `ranking_motor`, `ranking_vetor`, `recall_k`, `relevancia`, `residual`, `rocchio`, `rr`, `saturacao`, `sem_stop`, `stopwords_aula`, `texto_tem_caractere_estranho`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

