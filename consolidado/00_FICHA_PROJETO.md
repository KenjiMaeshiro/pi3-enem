# Ficha do projeto — grupo Enem

*Reconstruída na Aula 06 (Parte D) em 07/11/2026: a ficha original se perdeu. Fontes: consolidados do repositório (`consolidado/aula00` a `aula07`), guias, `corpus.csv`, `necessidades.csv`, `qrels_consenso.csv`, `config.R`, o notebook `entrega-4.ipynb` e, em 08/11/2026, o relatório da Entrega 1 (`entregas/entrega-1.pdf`). O que nenhum registro confirma está como `—`; o grupo confere seção por seção.*
*Última atualização: Aula 08 Parte D, 08/11/2026, motor08.*

---

## 1. Grupo, repositório e ambiente

- **Grupo:** Enem
- **Integrantes (Entrega 1):** Ana Luiza Bispo Aguiar; Caio Kenji de Paula Maeshiro (GitHub `KenjiMaeshiro`); Lucas Murinelly Feliciano (`lucas-murinelly`); Pedro Santos Malaquias Rodrigues (`malaquiias`).
- **Instituição:** Fatec Baixada Santista – Rubens Lara · Tecnologia em Ciência de Dados · Projeto Integrador III — Motor de Busca · Prof. Dr. João Paulo Ferreira de Mello.
- **Repositório:** https://github.com/KenjiMaeshiro/pi3-enem (público, criado em 04/09/2026 por Caio Kenji)
- **Endereço Raw:** `https://raw.githubusercontent.com/KenjiMaeshiro/pi3-enem/main/`
- **Ambiente:** Google Colab com R (R 4.6.1). Notebook do grupo: `entrega-4.ipynb`, no Drive de Kenji, limpo em 07/11/2026; cópia do original em `entrega-4 (backup antes da limpeza 2026-11-07).ipynb`.
- **Pastas:** o repositório usa `consolidado/` e `estrutura/codigos/`; os guias esperam `consolidados/` e `estrutura/codigo/`. A diferença é conhecida; o código do notebook usa `estrutura/codigos/`.

## 2. Tema e usuário

- **Tema:** os portos de Santos, Xangai e Roterdã, comparados em história, infraestrutura, movimentação de cargas, administração, integração logística e impactos econômicos.
- **Ligação com a Baixada Santista:** o Porto de Santos.
- **Usuário:** um pesquisador ou estudante que quer localizar e comparar informações sobre os três portos (relatório da Aula 05).
- **Três perguntas da Aula 01:** — (não constam na Entrega 1; as necessidades q01 a q20 da Aula 05 fazem esse papel desde então)
- **Por que este tema e não outro:** a importância dos portos no transporte e no comércio, e o interesse em estudar e comparar os portos de Santos, Xangai e Roterdã (Entrega 1, 06/10/2026).

## 3. Fonte e documento

- **Fonte:** Wikipédia em português, pela API (`action=query`, `prop=extracts`, texto puro). Licença CC BY-SA.
- **Títulos:** `Porto_de_Santos`, `Porto_de_Xangai`, `Porto_de_Roterdão` (acessados em 14/08/2026).
- **Por que a Wikipédia:** informações textuais sobre os três portos e coleta programática pela API. Alternativa considerada: os portais institucionais das autoridades portuárias; descartada porque a Wikipédia é uma fonte comum aos três portos e dá um corpus mais uniforme (Entrega 1).
- **Por que o parágrafo:** permite recuperar trechos específicos, em vez de indicar só uma página inteira (Entrega 1).
- **O que é um documento:** o parágrafo com pelo menos 10 palavras; os 20 primeiros de cada artigo. Quando o artigo tem menos de 20 parágrafos válidos, o texto inteiro é dividido em 20 partes iguais.
- **Limitação conhecida (Roterdã):** o artigo `Porto_de_Roterdão` é curto: 555 palavras e só 6 parágrafos com 10 palavras ou mais (conferido em 07/11/2026). Por isso os 20 documentos de Roterdã são janelas de 22 a 29 palavras cortadas no meio do texto, não parágrafos. Efeitos: um documento de Roterdã pode começar ou terminar no meio de uma frase e responde menos sozinho a uma necessidade; os documentos de Roterdã são bem mais curtos que os de Santos e Xangai, o que pesa no BM25 (normalização por tamanho). O grupo decidiu **manter o corpus congelado** e registrar a limitação, porque mudar os documentos de Roterdã mudaria os ids e invalidaria os 11 julgamentos que os usam. O problema já aparecia na Entrega 1 (Roterdã com 6 de 75 parágrafos); a correção prevista ali, acrescentar páginas sobre Roterdã, não foi feita.
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
| LSA e busca híbrida | 07 | `entrega-4.ipynb` (seções da Aula 07) | testado, não usado (`modelo = "bm25"`) |
| reordenação (proximidade ordenada) | 08 | `entrega-4.ipynb` (seções da Aula 08) | ok (`rerank_k = 3`, `janela = 3`, sobre o BM25) |
| **decisões para o R** | — | `estrutura/codigos/config.R` | campos: `minimo`, `grupo`, `limpar`, `acentos`, `stopwords`, `k1`, `b`, `limiar`, `juizes`, `prf_k`, `rocchio`, `modelo`, `lsa_k`, `rrf_c`, `rerank_k`, `janela` |

## 6. Decisões

- Aula 01: tema — os portos de Santos, Xangai e Roterdã; fonte — Wikipédia (CC BY-SA) · sem campo
- Aula 01: documento — parágrafo com pelo menos 10 palavras, 20 por porto · `cfg$minimo = 10` (em **palavras**, não caracteres como no modelo da disciplina; corrigido em 07/11/2026 — o `config.R` dizia 200; o campo não é usado pelo motor, porque o corpus está congelado)
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
- Aula 06: análise do drift (tarefa do grupo) — consulta q11, escolhida porque o comércio exterior é um dos papéis centrais dos portos estudados. A consulta original ficou com três termos (comercio, exterior, porto), porque "exportacoes" e "importacoes" não aparecem no corpus. Com a PRF ($k = 3$) ela passou a ter 199 termos; os mais pesados (britanico, 1842, imperio, tratado, guerra, hong, kong, poder) vieram dos dois relevantes (`3920f9`, `a3276b`) e do documento de grau 1 (`56713a`), e tratam da evolução de Xangai (Guerra do Ópio, Tratado de 1842, ocupação japonesa), não de exportação ou importação. A consulta foi puxada da necessidade para a história de Xangai; o `56713a`, que trata quase só da guerra de 1937, é o que mais combina com os termos novos e passou à frente do relevante `a3276b` (AP 1,000 → 0,833). Isso confirma a decisão de não usar a PRF: quando os primeiros documentos falam de outro assunto, mesmo sendo relevantes, a PRF leva a consulta para esse assunto, e o motor não tem como perceber o desvio · resultado, sem campo
- Aula 06: stopwords do motor — **lista curta da aula** (de, o, a, e, um, por, como, que, da, do), porque mantém o cosseno e sobe o MAP do BM25 de 0,840 para 0,907; a `stopwords-iso` baixava o cosseno (0,908 → 0,870) e apagava termos do tema ("teus", "sao") · `cfg$stopwords = c("de", "o", "a", "e", "um", "por", "como", "que", "da", "do")`. Com ela, a tabela da PRF fica base 0,908 · k = 2 0,864 · k = 3 0,917 · k = 5 0,853, com as mesmas consultas piorando; a decisão de não usar a PRF se mantém.
- Aula 07: resultado — LSA × BM25 na consulta q01 ($k = 20$, 68,5% da energia): 3 documentos em comum nos top-5; só o LSA trouxe o `37b06b`, sem nenhuma palavra da consulta, que fala do transporte de mercadorias pelo porto (lido pelo grupo como ganho de sentido); só o BM25 trouxe o `770191`, pelas palavras exatas "movimentacao" e "cargas", mas ele só conta a história das operações · resultado, sem campo
- Aula 07: modelo do motor = **bm25**, porque é o mais confiável: o LSA só passa do BM25 com $k = 50$, que é quase a matriz inteira (60 documentos) e ganha em apenas 2 de 11 consultas (q08, q14); com $k = 10$ ou $20$ o LSA perde em 8 de 11 (MAP dev BM25 0,907; LSA $k = 10$/$20$/$50$ 0,430/0,518/0,944; híbrido 0,683/0,787/0,915; sem teste; ressalva: 11 consultas) · `cfg$modelo = "bm25"`, `cfg$lsa_k = 50`, `cfg$rrf_c = 60` (registram o que foi testado; não usados com "bm25")
- Aula 07: análise LSA × BM25 (tarefa do grupo) — **onde o LSA ganhou, q14** ($k = 50$, AP 0,312 → 0,556): o BM25 pôs em 1º o `0216e3`, que não fala de acidentes (grau 0), e o relevante `be66af` em 2º; o LSA inverteu, pondo em 1º o `be66af`, que narra o incêndio de 2015 nos tanques de combustíveis da Alemoa, porque olha o assunto do texto inteiro (incêndio, tanques, combustíveis) e não só quantas vezes as palavras da consulta aparecem. **Onde o LSA perdeu, q01** ($k = 20$, AP 1,000 → 0,500): o LSA pôs em 1º o `54eb31` (grau 0), um texto de 12 palavras sobre o terminal Baoshan, da SIPG, que só tem "cargas" em comum com a consulta e não explica por que as cargas são economicamente importantes, só afirma detalhes do terminal. Com poucas dimensões, o LSA aproxima textos curtos do mesmo assunto geral (cargas, terminais) e perde a especificidade da necessidade. Isso sustenta a decisão de ficar com o BM25 · resultado, sem campo
- Aula 08: resultado — reordenação por proximidade na consulta q14 (top-10, janela 3, estágio 1 = BM25): AP 0,312 → 0,146. Subiram documentos com "porto de santos" colado (`543790`, `ddecd9`), que têm as palavras em ordem mas não respondem à necessidade; o relevante `be66af` (incêndio de 2015 na Alemoa) ficou com proximidade 0 e saiu do top-5 · resultado, sem campo
- Aula 08: reordenação = **top-3, janela 3, sobre o estágio 1 BM25**, porque a proximidade premia documentos com as palavras da consulta em ordem, o que deve ajudar em consultas mais longas, mesmo que no gabarito atual tenha perdido em q14, q15 e q16 (MAP dev estágio 1 0,907; grade $k$ 3/5/10 × janela 2/3/5: melhor $k = 3$, janelas 2 e 3, 0,847; pior $k = 10$, janela 5, 0,665; sem teste). Ressalva: a reordenação não ganhou em nenhuma das 11 consultas e baixa o MAP em 0,06; o par mais comum nos textos, "porto de santos", não diz nada sobre a necessidade · `cfg$rerank_k = 3`, `cfg$janela = 3`
- Aula 08: análise da reordenação (tarefa do grupo) — **onde perdeu, q14** (AP 0,312 → 0,146): a proximidade deu 1 ponto aos documentos com "porto de santos" colado (`0216e3`, `543790`, `ddecd9`), que têm as palavras em ordem mas não respondem à necessidade (incêndios e acidentes); o relevante `be66af`, que narra o incêndio de 2015 na Alemoa, ficou com 0 pontos — tem "incêndio" (no singular) e "terminais", mas não perto e na ordem da consulta — e saiu do top-5. **Onde não mudou, q01** (AP 1,000 → 1,000): os três primeiros do BM25 já estavam na ordem da proximidade (1, 1 e 0 ponto). Em todo o desenvolvimento a reordenação não ganhou em nenhuma consulta · resultado, sem campo

## 7. Registro por aula

- **Aula 00** — teoria e Parte D individuais; repositório de treino `pi3-treino`; consolidado em `consolidado/`.
- **Aula 01** (Entrega 1, relatório de 06/10/2026, os quatro integrantes como autores) — presentes: —; feito: coleta dos três artigos pela API, parágrafos com ≥ 10 palavras, tokenização, TDM, busca booleana; produzido: 75 documentos (Xangai 38, Santos 31, Roterdã 6), 10 a 237 tokens (média 70,7), 1.946 termos distintos em 5.304 tokens; Xangai com 51% dos documentos; os dez termos mais frequentes são gramaticais, exceto "porto"; pendente: limpeza e stopwords (Aula 03), equilibrar Roterdã com novas páginas, revisar trechos que não são prosa.
- **Aula 02** (Entrega 2) — presentes: —; feito: TF-IDF, normalização, cosseno; produzido: ranking de "porto santos terminais" (`paragrafo-22`, `paragrafo-20` no topo).
- **Aula 03** (Entrega 3) — presentes: —; feito: limpeza de acentos e pontuação, `stopwords-iso`; produzido: 1.428 termos; `porto` em 56 de 75 parágrafos.
- **Aula 04** (Entrega 4) — presentes: —; feito: BM25 (IDF probabilístico, `bm25_doc`); produzido: BM25 num subcorpus de 8 parágrafos de Santos; pendente: o ranking exibido reaproveitou o do cosseno.
- **Aula 05** — presentes: —; feito: corpus congelado (60), 20 necessidades, guia, pooling (29 pares), julgamento duplo, κ; produzido: `corpus.csv`, `necessidades.csv`, `qrels_consenso.csv`, relatório de avaliação.
- **Aula 5,5** (25/09/2026) — Pedro Santos; feito: métricas nos três modelos; produzido: MAP TF-IDF 0,985, BM25 0,894, booleano 0,227.
- **Aula 06 teoria** (16/10/2026) — Lucas Murinelly Feliciano; Rocchio, residual, PRF no corpus do curso.
- **Aula 07 teoria** (23 e 25/10/2026) — Lucas Murinelly Feliciano; LSA, RRF; aviso: `motor07.R` deu 404 no começo.
- **Aula 06 Parte D** (07/11/2026) — presentes: Pedro Santos; Lucas Murinelly julgou q08, q10, q18 e q11; Pedro julgou os 16 pares do top-3. Feito: Módulo 7 (Rocchio em q16), Módulo 8 (PRF nas 11 consultas dev) e Módulo 9 (decisão: sem PRF); gabarito ampliado; notebook limpo; ficha reconstruída. Produzido: `qrels_consenso.csv` com 49 pares e os registros de julgamento (PR KenjiMaeshiro/pi3-enem#1); `config.R` com `prf_k = 0` e `rocchio`. Decidido depois: `cfg$stopwords` = lista curta da aula; `cfg$minimo = 10` (palavras). Tarefa do grupo (análise do drift em q11) feita em 08/11/2026, na seção 6. Pendente: campos `—` desta ficha.
- **Aula 07 Parte D** (08/11/2026) — presentes: Pedro Santos (conduziu); demais: —; digitou: o tutor, a pedido do grupo (R local e Colab). Feito: Módulo 7 (LSA $k = 20$ × BM25 em q01, lendo os textos), Módulo 8 (BM25, LSA e híbrido com $k$ = 10, 20, 50 nas 11 consultas dev; sem teste) e Módulo 9 (decisão: BM25); tarefa do grupo (q14 ganhou, q01 perdeu), na seção 6. Produzido: `config.R` com `modelo = "bm25"`, `lsa_k = 50`, `rrf_c = 60`; seções da Aula 07 no `entrega-4.ipynb`. Pendente: nenhum para a Aula 08 além dos campos `—` desta ficha; `prf_k = 0`, então não há PRF × LSA a decidir.
- **Aula 08 Parte D** (08/11/2026) — presentes: Pedro Santos (conduziu); demais: —; digitou: o tutor, a pedido do grupo (R local e Colab). Feito: Módulo 7 (proximidade e reordenação sobre o BM25 em q14, lendo os textos; q01 não muda), Módulo 8 (grade $k$ 3/5/10 × janela 2/3/5 nas 11 consultas dev; sem teste) e Módulo 9 (decisão: top-3, janela 3); tarefa do grupo (q14 perdeu, q01 não mudou), na seção 6. Produzido: `config.R` com `rerank_k = 3`, `janela = 3`; seções da Aula 08 no `entrega-4.ipynb`. Pendente: rever a reordenação com mais consultas e julgamentos (hipótese do grupo: ajuda em consultas mais longas).

## 8. Estado do R

*Gerada por `anexar_estado("00_FICHA_PROJETO.md")` no Colab. Não escrever à mão.*

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
| `f` | character | 1 | 00_FICHA_PROJETO.md |
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

