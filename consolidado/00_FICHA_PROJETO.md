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
- **Vocabulário:** 1.946 termos brutos (Entregas 1 e 2, 75 parágrafos) · 1.428 depois da limpeza e das stopwords (Entrega 3) · 1.239 no `motor06` sobre o corpus congelado (limpeza com `translit`, sem stopwords).
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
| **decisões para o R** | — | `estrutura/codigos/config.R` | campos: `minimo`, `grupo`, `limpar`, `acentos`, `k1`, `b`, `limiar`, `juizes`, `prf_k`, `rocchio`; pendente: `stopwords` |

## 6. Decisões

- Aula 01: tema — os portos de Santos, Xangai e Roterdã; fonte — Wikipédia (CC BY-SA) · sem campo
- Aula 01: documento — parágrafo com pelo menos 10 palavras, 20 por porto · `cfg$minimo = 200` ⚠ o `config.R` diz 200, mas o grupo filtrou por 10 **palavras**: conferir
- Aula 02: consulta de trabalho "porto santos terminais" · sem campo
- Aula 03: acentos e pontuação removidos, caixa baixa · `cfg$limpar = TRUE`, `cfg$acentos = "translit"`
- Aula 03: stopwords — lista `stopwords-iso` em português, com stemming (`SnowballC`) no pipeline próprio · `cfg$stopwords` ⚠ não definido no `config.R`: pendente
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
- **Aula 06 Parte D** (07/11/2026) — presentes: Pedro Santos; Lucas Murinelly julgou q08, q10, q18 e q11; Pedro julgou os 16 pares do top-3. Feito: Módulo 7 (Rocchio em q16), Módulo 8 (PRF nas 11 consultas dev) e Módulo 9 (decisão: sem PRF); gabarito ampliado; notebook limpo; ficha reconstruída. Produzido: `qrels_consenso.csv` com 49 pares e os registros de julgamento (PR KenjiMaeshiro/pi3-enem#1); `config.R` com `prf_k = 0` e `rocchio`. Pendente: `cfg$stopwords`; conferir `cfg$minimo`; consolidado da Parte D.

## 8. Estado do R

*Gerada por `anexar_estado("00_FICHA_PROJETO.md")` no Colab. Não escrever à mão.*
