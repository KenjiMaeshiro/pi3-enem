# Ficha do projeto — grupo Enem

*Reconstruída na Aula 06 (Parte D) em 07/11/2026: a ficha original se perdeu. Fontes: consolidados do repositório (`consolidado/aula00` a `aula07`), guias, `corpus.csv`, `necessidades.csv`, `qrels_consenso.csv`, `config.R` e o notebook `entrega-4.ipynb`. O que nenhum registro confirma está como `—`; o grupo confere seção por seção.*
*Última atualização: Aula 06 Parte D, 07/11/2026, motor06.*

---

## 1. Grupo, repositório e ambiente

- **Grupo:** Enem
- **Integrantes (pelos registros):** Pedro Santos (GitHub `malaquiias`), Lucas Murinelly Feliciano (`lucas-murinelly`), Kenji Maeshiro (`KenjiMaeshiro`). Outros integrantes: —
- **Repositório:** https://github.com/KenjiMaeshiro/pi3-enem (público, criado em 04/09/2026 por Kenji Maeshiro)
- **Endereço Raw:** `https://raw.githubusercontent.com/KenjiMaeshiro/pi3-enem/main/`
- **Ambiente:** Google Colab com R (R 4.6.1). Notebook do grupo: `entrega-4.ipynb`, no Drive de Kenji, limpo em 07/11/2026; cópia do original em `entrega-4 (backup antes da limpeza 2026-11-07).ipynb`.
- **Pastas:** o repositório usa `consolidado/` e `estrutura/codigos/`; os guias esperam `consolidados/` e `estrutura/codigo/`. A diferença é conhecida; o código do notebook usa `estrutura/codigos/`.

## 2. Tema e usuário

- **Tema:** os portos de Santos, Xangai e Roterdã, comparados em história, infraestrutura, movimentação de cargas, administração, integração logística e impactos econômicos.
- **Ligação com a Baixada Santista:** o Porto de Santos.
- **Usuário:** um pesquisador ou estudante que quer localizar e comparar informações sobre os três portos (relatório da Aula 05).
- **Três perguntas da Aula 01:** —
- **Por que este tema e não outro:** —

## 3. Fonte e documento

- **Fonte:** Wikipédia em português, pela API (`action=query`, `prop=extracts`, texto puro). Licença CC BY-SA.
- **Títulos:** `Porto_de_Santos`, `Porto_de_Xangai`, `Porto_de_Roterdão`.
- **O que é um documento:** o parágrafo com pelo menos 10 palavras; os 20 primeiros de cada artigo. Quando o artigo tem menos de 20 parágrafos válidos, o texto inteiro é dividido em 20 partes iguais.
- **Limitação conhecida (Roterdã):** o artigo `Porto_de_Roterdão` é curto: 555 palavras e só 6 parágrafos com 10 palavras ou mais (conferido em 07/11/2026). Por isso os 20 documentos de Roterdã são janelas de 22 a 29 palavras cortadas no meio do texto, não parágrafos. Efeitos: um documento de Roterdã pode começar ou terminar no meio de uma frase e responde menos sozinho a uma necessidade; os documentos de Roterdã são bem mais curtos que os de Santos e Xangai, o que pesa no BM25 (normalização por tamanho). O grupo decidiu **manter o corpus congelado** e registrar a limitação, porque mudar os documentos de Roterdã mudaria os ids e invalidaria os 11 julgamentos que os usam.
- **Corpus antigo × congelado:** as Entregas 1 a 4 usaram 75 parágrafos; o corpus congelado na Aula 05 tem 60 documentos (20 por porto).

## 4. Corpus

- **Documentos:** 60 — Santos 20, Xangai 20, Roterdã 20.
- **Onde está e em que forma:** `estrutura/banco-de-dados/corpus.csv` (colunas `texto`, `fonte`, `id`), **congelado na Aula 05**; ids estáveis `doc-<16 primeiros caracteres do md5 de fonte||texto>`. Também `docs.rds` e `origens.rds`.
- **Necessidades:** `estrutura/banco-de-dados/necessidades.csv` — 20 (q01 a q20), com consulta, necessidade em prosa, escopo e `conjunto`. Todas `dev`.
- **Gabarito:** `estrutura/banco-de-dados/qrels_consenso.csv` — 49 pares (19 de grau 0, 10 de grau 1, 20 de grau 2), `juiz = consenso`. Era 29 pares até a Aula 06; os 20 novos estão em `registro_julgamentos_aula06D.csv` e `registro_julgamentos_aula06D_top3.csv`.
- **Tamanho em palavras (corpus congelado):** média 57,83 · desvio 45,94 · mínimo 10 · mediana 38,5 · máximo 239. Por fonte: Santos 34 a 239 (mediana 73,5); Xangai 10 a 152 (mediana 40,5); Roterdã 22 a 29 (mediana 28).
- **Vocabulário:** 1.946 termos brutos (Entregas 1 e 2, 75 parágrafos) · 1.428 depois da limpeza e das stopwords (Entrega 3) · 1.239 no `motor06` sobre o corpus congelado (limpeza com `translit`, sem stopwords) · 1.229 com a lista curta de stopwords da aula (decisão de 07/11/2026).
- **Idioma, acentos, caixa, pontuação:** português; acentos removidos; tudo em minúsculas; pontuação vira espaço.
- **Consultas de trabalho:** "porto santos terminais" (Entregas 2 a 4). Desde a Aula 05, as 20 consultas de `necessidades.csv`.

## 5. Componentes do motor

| componente | aula | arquivo | estado |
|---|---|---|---|
| corpus, `config.R`, tokenização + TDM | 01 | `estrutura/codigos/aula01.R`; `entrega-4.ipynb` | ok |
| TF-IDF + cosseno | 02 | `estrutura/codigos/aula02.R`; `entrega-4.ipynb` | ok |
| limpeza + stopwords do grupo; índice invertido + busca AND | 03 | `estrutura/codigos/aula03.R`; `entrega-4.ipynb` | ok (pipeline próprio com `stopwords-iso` + stemming; fora do `config.R`) |
| BM25 | 04 | `estrutura/codigos/aula04.R`; `entrega-4.ipynb` | ok |
| `corpus.csv`, necessidades, guia de julgamento, `qrels` | 05 | `estrutura/banco-de-dados/` | ok; qrels 29 pares de consenso; κ = 0,478 entre dois juízes em 6 itens (2ª rodada) |
| métricas (P@k, MAP, MRR, nDCG) dos modelos | 5,5 | — (`metricas.R` e `rodar_metricas_corrigido.R` não estão no repositório) | ok |
| realimentação (Rocchio, pseudo-realimentação) | 06 | `entrega-4.ipynb` (seções da Aula 06) | testado, desligado (`prf_k = 0`) |
| **decisões para o R** | — | `estrutura/codigos/config.R` | campos: `minimo`, `grupo`, `limpar`, `acentos`, `stopwords`, `k1`, `b`, `limiar`, `juizes`, `prf_k`, `rocchio` |

## 6. Decisões

- Aula 01: tema — os portos de Santos, Xangai e Roterdã; fonte — Wikipédia (CC BY-SA) · sem campo
- Aula 01: documento — parágrafo com pelo menos 10 palavras, 20 por porto · `cfg$minimo = 200` ⚠ o `config.R` diz 200, mas o grupo filtrou por 10 **palavras**: conferir
- Aula 02: consulta de trabalho "porto santos terminais" · sem campo
- Aula 03: acentos e pontuação removidos, caixa baixa · `cfg$limpar = TRUE`, `cfg$acentos = "translit"`
- Aula 03: stopwords — lista `stopwords-iso` em português, com stemming (`SnowballC`), no pipeline próprio das Entregas 3 e 4 · sem campo (substituída na Aula 06, ver abaixo)
- Aula 04: BM25 com $k_1 = 1{,}2$ e $b = 0{,}75$, valores padrão da literatura · `cfg$k1 = 1.2`, `cfg$b = 0.75`
- Aula 05: corpus congelado com 60 documentos, 20 por porto · `corpus.csv`
- Aula 06: Roterdã em janelas de ~28 palavras, não parágrafos (artigo curto) — mantido como limitação conhecida, para não invalidar os 11 julgamentos com documentos de Roterdã · sem campo
- Aula 05: 20 necessidades, q01 a q20; teste: nenhum, todas `dev` · `necessidades.csv` (coluna `conjunto`)
- Aula 05: guia de julgamento — graus 0, 1 e 2; julgar pela necessidade em prosa, não pelas palavras da consulta; critérios de q11, q12 e q19 explicitados antes da 2ª rodada · `guia_julgamento.md`
- Aula 05: pooling — top-1 de booleano, TF-IDF e BM25 por consulta, 29 pares; 6 (20%) em julgamento duplo; κ 0,280 na 1ª rodada, guia revisado, 0,478 na 2ª; empates resolvidos pelo grupo · semente 42
- Aula 5,5: limiar de relevância grau ≥ 2, critério mais rigoroso, escolhido antes de interpretar os resultados · `cfg$limiar = 2`
- Aula 5,5: gabarito de consenso · `cfg$juizes = "consenso"`
- Aula 5,5: consultas fora da avaliação: q02, q03, q05, q07, q09, q12, q13, q19, q20 (R = 0) · `usar`
- Aula 5,5: resultado — TF-IDF MAP 0,985, BM25 0,894, booleano 0,227 (29 pares); ressalva: muitos empates entre TF-IDF e BM25 e diferenças pequenas · resultado, sem campo
- Aula 06: gabarito ampliado de 29 para 49 pares — q08, q10, q18, q11 e os 16 pares do top-3 da base sem grau; ressalvas: q10 e q18 julgados depois de ver o efeito da PRF; 5 pares do top-3 não totalmente às cegas · `qrels_consenso.csv`, `registro_julgamentos_aula06D*.csv`
- Aula 06: sem conjunto de teste; k escolhido e relatado só no desenvolvimento · `necessidades.csv` (todas `dev`)
- Aula 06: resultado — Rocchio na consulta q16 ($D_r$ = 2 relevantes, $D_{nr}$ vazio): AP completo 0,583 → 1,000; residual AP NA → NA (todos os relevantes estavam no top-5) · resultado, sem campo
- Aula 06: pseudo-realimentação — **não usar**, porque o ganho de MAP é pequeno ou negativo e a PRF piora consultas que a base acerta (drift em q08 e q11) (MAP dev base 0,908 → k = 2 0,859 · k = 3 0,915 · k = 5 0,853, em 11 consultas; sem teste) · `cfg$prf_k = 0`, `cfg$rocchio = c(a = 1, b = 0.75, g = 0.15)`
- Aula 06: stopwords do motor — **lista curta da aula** (de, o, a, e, um, por, como, que, da, do), porque mantém o cosseno e sobe o MAP do BM25 de 0,840 para 0,907; a `stopwords-iso` baixava o cosseno (0,908 → 0,870) e apagava termos do tema ("teus", "sao") · `cfg$stopwords = c("de", "o", "a", "e", "um", "por", "como", "que", "da", "do")`. Com ela, a tabela da PRF fica base 0,908 · k = 2 0,864 · k = 3 0,917 · k = 5 0,853, com as mesmas consultas piorando; a decisão de não usar a PRF se mantém.

## 7. Registro por aula

- **Aula 00** — teoria e Parte D individuais; repositório de treino `pi3-treino`; consolidado em `consolidado/`.
- **Aula 01** (Entrega 1) — presentes: —; feito: coleta dos três artigos, parágrafos com ≥ 10 palavras, tokenização, TDM, busca booleana; produzido: 75 parágrafos, 1.946 termos; pendente: limpeza (Aula 03).
- **Aula 02** (Entrega 2) — presentes: —; feito: TF-IDF, normalização, cosseno; produzido: ranking de "porto santos terminais" (`paragrafo-22`, `paragrafo-20` no topo).
- **Aula 03** (Entrega 3) — presentes: —; feito: limpeza de acentos e pontuação, `stopwords-iso`; produzido: 1.428 termos; `porto` em 56 de 75 parágrafos.
- **Aula 04** (Entrega 4) — presentes: —; feito: BM25 (IDF probabilístico, `bm25_doc`); produzido: BM25 num subcorpus de 8 parágrafos de Santos; pendente: o ranking exibido reaproveitou o do cosseno.
- **Aula 05** — presentes: —; feito: corpus congelado (60), 20 necessidades, guia, pooling (29 pares), julgamento duplo, κ; produzido: `corpus.csv`, `necessidades.csv`, `qrels_consenso.csv`, relatório de avaliação.
- **Aula 5,5** (25/09/2026) — Pedro Santos; feito: métricas nos três modelos; produzido: MAP TF-IDF 0,985, BM25 0,894, booleano 0,227.
- **Aula 06 teoria** (16/10/2026) — Lucas Murinelly Feliciano; Rocchio, residual, PRF no corpus do curso.
- **Aula 07 teoria** (23 e 25/10/2026) — Lucas Murinelly Feliciano; LSA, RRF; aviso: `motor07.R` deu 404 no começo.
- **Aula 06 Parte D** (07/11/2026) — presentes: Pedro Santos; Lucas Murinelly julgou q08, q10, q18 e q11; Pedro julgou os 16 pares do top-3. Feito: Módulo 7 (Rocchio em q16), Módulo 8 (PRF nas 11 consultas dev) e Módulo 9 (decisão: sem PRF); gabarito ampliado; notebook limpo; ficha reconstruída. Produzido: `qrels_consenso.csv` com 49 pares e os registros de julgamento (PR KenjiMaeshiro/pi3-enem#1); `config.R` com `prf_k = 0` e `rocchio`. Decidido depois: `cfg$stopwords` = lista curta da aula. Pendente: conferir `cfg$minimo`; campos `—` desta ficha.

## 8. Estado do R

*Gerada por `anexar_estado("00_FICHA_PROJETO.md")` no Colab. Não escrever à mão.*

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-08 00:52 · R version 4.6.1 (2026-06-24) · motor06 v2 2026-10-08 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `amostra` | data.frame | 10 × 4 | colunas: id, fonte, texto, n_palavras |
| `avgdl` | numeric | 1 | 30.52 |
| `b` | numeric | 1 | 0.75 |
| `base` | numeric, nomeado | 60 | doc-e6e35237be5c264b 0.1383, doc-3920f91f96c67fe8 0.1325, doc-28a6b0ff0368e381 0.1252, doc-0279001a1a60b9ae 0.1129, doc-db8517f307829d06 0.1024, doc-65b06580ad1d7e3a 0.1023, ... |
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
| `cfg$stopwords` | character | 10 | de, o, a, e, um, por, ... |
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
| `novo` | numeric, nomeado | 60 | doc-3920f91f96c67fe8 0.7764, doc-28a6b0ff0368e381 0.6211, doc-6a4c8a90c1269b98 0.1459, doc-0279001a1a60b9ae 0.1072, doc-db8517f307829d06 0.1045, doc-e6e35237be5c264b 0.1005, ... |
| `novo_v` | numeric, nomeado | 60 | doc-3920f91f96c67fe8 0.7764, doc-28a6b0ff0368e381 0.6211, doc-6a4c8a90c1269b98 0.1459, doc-0279001a1a60b9ae 0.1072, doc-db8517f307829d06 0.1045, doc-e6e35237be5c264b 0.1005, ... |
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
| `q0` | numeric, nomeado | 1229 | 000 0, 03 0, 1 0, 10 0, 100 0, 105 0, ... |
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

