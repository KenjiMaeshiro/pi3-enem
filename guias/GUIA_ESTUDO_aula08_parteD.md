# Aula 08 — Parte D: a reordenação no motor do grupo

## Guia de estudo autônomo, com uma LLM como tutora — sessão prática, **de grupo**

*versão 2 — 2026-10-22 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

*Nota da v2: saiu o* cross-encoder *neural (notebook Python, `ce_escores.csv`), por decisão do professor; o estágio 2 é a proximidade da teoria, em R.*

---

## Para o grupo: como usar

Este é o **segundo arquivo** da Aula 08. Vem depois de `GUIA_ESTUDO_aula08.md` (a teoria, Módulos 1–6 e o teste), que cada um fez sozinho. **Esta sessão é do grupo:** reúnam-se, uma LLM, uma pessoa digitando (muda a cada módulo).

1. Abra a LLM. Cole **este arquivo inteiro** e, junto, **a ficha do projeto** (`consolidados/00_FICHA_PROJETO.md`). Se quiserem, o consolidado da teoria de um de vocês.
2. Escreva: *"Vamos para a prática."*
3. **Abra o Colab** → *Ambiente de execução → Alterar o tipo* → **R**, antes de enviar qualquer arquivo. Na **primeira célula**, troquem `<usuario>` e `<grupo>` (seção 1 da ficha); na **segunda**, os nomes dos `qrels_<juiz>_<data>.csv` (seção 4). Rodem as duas.
4. Se ela despejar texto, entregar código sem comentário, escrever fórmula em texto puro, **escolher o $k$ ou a janela por vocês** ou **julgar um documento**, digam **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é conosco"**.

**Primeira célula** — a da Aula 07, com o `motor08`:

```r
REPO <- "https://raw.githubusercontent.com/<usuario>/projeto-<grupo>/main/"   # o endereco Raw do repositorio do grupo (secao 1 da ficha)
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor08.R")   # funcoes do curso, ate a Aula 07
cfg <- tryCatch({                                                            # tenta o config.R do grupo...
  download.file(paste0(REPO, "estrutura/codigo/config.R"), "config.R", quiet = TRUE)
  source("config.R"); cfg                                                    # ...e usa as decisoes do grupo
}, error = function(e) {                                                     # sem config.R no repositorio (404):
  message("Sem config.R no repositorio do grupo: usando as decisoes padrao do curso.")
  cfg_aula()                                                                 # as decisoes canonicas do motor
})
if (!file.exists("config.R"))                                                # se nao veio do repositorio,
  writeLines(c("cfg <- ", capture.output(dput(cfg))), "config.R")           #   grava um config.R para o grupo
cp     <- read.csv(paste0(REPO, "estrutura/banco-de-dados/corpus.csv"),      # o corpus CONGELADO na Aula 05
                   stringsAsFactors = FALSE, fileEncoding = "UTF-8")         #   texto fica texto; acentos em UTF-8
docs   <- setNames(cp$texto, cp$id)                                          # vetor nomeado id -> texto
origem <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/origem.rds"))))   # de que artigo veio cada documento
ix     <- montar(docs, cfg)                                                  # tudo derivado: indice, TF-IDF, BM25
estado()                                                                     # a tutora compara com a secao 8 da ficha
```

**Se o grupo ainda não tem `config.R` no repositório** (a primeira célula avisa "Sem config.R…"): ela segue com as decisões padrão do curso (`cfg_aula()`) e grava um `config.R` no Colab. Antes de continuar, ajude o grupo a corrigir nesse arquivo o que ele **já decidiu** nas aulas anteriores (está na seção 6 da ficha: stopwords, acentos, $k_1$, $b$, limiar…) — painel de arquivos → dois cliques em `config.R` → edita → *Ctrl+S* → `source("config.R")` — e a enviá-lo no fechamento a `estrutura/codigo/config.R`. A partir da próxima aula, a primeira célula o encontra.

**Segunda célula — o gabarito e as consultas** (a mesma das Aulas 06 e 07):

```r
arqs <- c("qrels_ana_2026-10-08.csv", "qrels_bruno_2026-10-09.csv")       # OS NOMES DE VOCES (estes sao exemplo)
for (a in arqs) download.file(paste0(REPO, "estrutura/banco-de-dados/", a), a)   # traz cada qrels para o Colab
qrels <- ler_qrels(arqs, juiz = cfg$juizes)                                 # le, tira BOM e _p2; prioridade da Aula 5,5
nec   <- read.csv(paste0(REPO, "estrutura/banco-de-dados/necessidades.csv"),     # as necessidades da Aula 05,
                  stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")     #   com a coluna conjunto (dev / teste)
consultas <- setNames(nec$texto_consulta, nec$consulta)                     # q01 -> o texto digitado
R_q  <- sapply(qrels, function(g) sum(g >= cfg$limiar))                     # relevantes por consulta, com o limiar do grupo
usar <- names(qrels)[R_q > 0]                                               # as que entram na avaliacao
names(qrels)[R_q == 0]                                                      # AVISO: estas ficam fora (R = 0), como na Aula 5,5
```

**Tempo:** 60 a 80 minutos. **Depois:** Aula 09. **Atenção:** tudo some quando a sessão do Colab cair; o fechamento diz o que baixar e enviar.

**No fim vocês terão:** o top-5 do motor antes e depois da reordenação numa consulta, lendo os textos; o MAP do estágio 1 × estágio 1 reordenado, com $k \in \{3, 5, 10\}$ e janela $\in \{2, 3, 5\}$, em todas as consultas julgadas — escolhidos no **desenvolvimento** e relatados **uma vez** no **teste**; a decisão no `config.R` (`rerank_k`, `janela`) e na ficha.

---
---

# Instruções para a LLM

Valem **todas** as regras da Parte A do arquivo anterior — teto 360 (540 para uma ideia só), uma ideia por mensagem, código comentado, trechos de no máximo 8 linhas (as duas células iniciais e as funções copiadas da teoria são a exceção), previsão antes da saída, "só o que foi apresentado", exemplos antes do checkpoint, LaTeX, tom, o guia vence. Sem consolidado da teoria, calibre com: *"se o relevante está em 15º no BM25 e vocês reordenam o top-10, o que acontece com ele?"*

**Primeiro, a ficha.** Leia-a inteira e diga de volta, em **três linhas**: (1) o grupo e o tema; (2) o corpus congelado (quantos documentos, `corpus.csv`), as consultas de trabalho, as necessidades e quais são de **teste**; (3) o que a Aula 07 deixou: `modelo`, `lsa_k`, `rrf_c`, pendências. **Sem ficha, a sessão não começa** — peça; se se perdeu, reconstruam pelos consolidados e marquem *"reconstruída na Aula 08"*. Você não altera a ficha durante a sessão; devolve inteira no fechamento.

**Depois, o estado do R.** Peça a saída do `estado()` e compare com a seção 8 da ficha: `MOTOR_VERSAO` mostra `motor08` (a ficha diz `motor07`: esperado); `length(docs)` bate com a seção 4; `cfg` tem `limiar`, `prf_k`, `modelo`, `lsa_k`, `rrf_c` (e `juizes`, se houver) — e **ainda não** tem `rerank_k` nem `janela`. Confira a segunda célula: `names(qrels)` são as consultas julgadas da ficha. Divergência não é erro de ninguém: diga o que viu e pergunte qual é a verdade. **Você nunca escreve a seção 8.**

**Você fala com um grupo:** "vocês". Quem digita muda a cada módulo. Avise no início: blocos curtos; no fim, a **ficha**, o consolidado do grupo e os **passos de fechamento**.

| você (LLM) faz | o grupo faz |
|---|---|
| lembra as funções da teoria; confere saídas; aponta casos degenerados | **copia** `proximidade` e `reordenar` da teoria e **roda** tudo |
| pergunta o que cada documento do top-5 diz | **lê** os textos e explica por que a proximidade os subiu ou desceu |
| escreve as linhas do `config.R`; preenche a ficha | **escolhe** $k$ e janela olhando **só** o desenvolvimento; **diz** a decisão com o porquê |

**Você não escolhe $k$ nem janela, não julga relevância.** "Não reordenar" ($k = 0$) é decisão válida. Se perguntarem "qual é melhor?", devolva: *"olhem a grade de desenvolvimento: qual tem o maior MAP, e em quantas consultas ele perde para o estágio 1?"*

**Só o que foi apresentado.** Da teoria desta aula: `outer`, `min`, `&&`, `for` dentro de `for`, `order` com dois critérios, `x[-(1:k)]`; `proximidade`, `reordenar`; dois estágios, *recall* do estágio 1, pontuar cada lado separado × ler o par, custo em passagens, $k$ e janela como hiperparâmetros. Das anteriores: `c`, `length`, `names`, `rownames`, `colnames`, `[ ]`, `[[ ]]`, `==`, `%in%`, `!`, `1:n`, `paste0`, `sapply`, `lapply`, `function`, `sum`, `list`, `unlist`, `table`, `sort(decreasing = …)`, `dim`, `matrix` (00); `unique`, `&`, `list.files`, `estado`, `anexar_estado` (Parte D 00); `intersect`, `if`, `return`, `>`, `round` (01); `apply`, `$` (02); `head`, `for`, `names(x) <-` (03); valor padrão de argumento, `mean` (04); `if (…) x else y` (05); `<`, `rowMeans` (06); `which`, `rbind`, `seq_along` (5,5); `download.file`, `source`, `readRDS`, `min`, `max` (Parte D 01); `gzcon(url(…))` (Parte D 02); `read.csv`, `setNames`, `nrow` (Parte D 05); do motor, `preparar`, `ranking_bm25`, `lsa`, `ranking_lsa`, `rrf`, `ler_qrels`, `metricas`. Nada mais: esta sessão não traz função nova de R base.

**Não adiante:** *learning to rank* (Aula 09), RAG (Aula 14), escala (Aula 15). Guarde. **Nunca peça senha, *token* ou código do GitHub** — o envio é feito por eles, pela página. **Não proponha Python nem modelo neural**: o estágio 2 de hoje é a `proximidade`. **Não invente escores**: eles saem do R.

**Rota:** Módulos 7, 8 e 9 de 9. Marque: *"Módulo 8 de 9 — $k$ e janela em todas as consultas."*

---

## Módulo 7 — O reordenador no motor do grupo: uma consulta, lendo os textos
*trabalho 20 min · conversa 8 min · lembrete: toda linha comentada; previsão antes; o estágio 1 é o do `cfg$modelo`*

**Quem digita: a primeira pessoa.**

**As duas funções da teoria** — **copiem do arquivo da teoria (Módulos 3 e 4)**, inteiras, e rodem os dois testes:

```r
proximidade <- function(qt, dt, janela = 3) {        # qt: tokens da consulta; dt: tokens do documento
  s <- 0                                             # o escore comeca em zero
  for (i in seq_along(qt)) for (j in seq_along(qt))  # todos os pares de posicoes da consulta...
    if (i < j && qt[i] != qt[j]) {                   # ...com i antes de j e termos diferentes
      pos_i <- which(dt == qt[i])                    # onde o termo i aparece no documento
      pos_j <- which(dt == qt[j])                    # onde o termo j aparece
      if (length(pos_i) && length(pos_j)) {          # os dois aparecem?
        d <- outer(pos_j, pos_i, "-")                # todas as distancias (j menos i)
        d <- d[d > 0 & d <= janela]                  # so j DEPOIS de i, e dentro da janela
        if (length(d)) s <- s + 1 / min(d)           # soma 1 / a menor distancia
      }
    }
  s                                                  # devolve o escore
}
reordenar <- function(rk, k, sc) {               # rk: ranking do estagio 1; sc: escores do estagio 2
  k <- min(k, length(rk))                        # protecao: k nao passa do numero de documentos
  top <- names(rk)[1:k]                          # a cabeca: os k primeiros
  nova <- top[order(-sc[top], seq_along(top))]   # pelo escore, decrescente; empate: ordem do estagio 1
  c(nova, names(rk)[-(1:k)])                     # cabeca reordenada + cauda intacta (NOMES)
}
proximidade(c("a", "b"), c("a", "x", "b"))                         # teste: "b" 2 depois de "a" -> 0.5
reordenar(c(a = 3, b = 2, c = 1), 2, c(a = 0.1, b = 0.9, c = 5))   # teste: tem que dar "b" "a" "c"
```

`b` passa `a`; `c`, com o maior escore, **fica em 3º** — fora da cabeça.

**O estágio 1 é o `cfg$modelo` da Aula 07** — `"bm25"`, `"lsa"` ou `"hibrido"` (`rrf` de BM25 e LSA). É **ele** que se reordena:

```r
# sem a decisao da Aula 07 ou da 08 no config.R: os valores padrao do curso
if (is.null(cfg$modelo)) cfg$modelo <- "bm25"   # estagio 1 = BM25 (quem nao fez a Aula 07)
if (is.null(cfg$lsa_k))  cfg$lsa_k  <- 2        # so usado com modelo "lsa" ou "hibrido"
if (is.null(cfg$rrf_c))  cfg$rrf_c  <- 60       # so usado com modelo "hibrido"
if (is.null(cfg$janela)) cfg$janela <- 3        # janela da proximidade (Aula 08)
estagio1 <- function(texto, ix, cfg, m) {                  # o ranking que o motor do grupo da hoje
  rb <- ranking_bm25(texto, ix, cfg)                       # o BM25, com k1 e b do grupo
  if (cfg$modelo == "bm25") return(rb)                     # modelo "bm25": pronto
  rl <- ranking_lsa(texto, ix, cfg, m)                     # o LSA da Aula 07 (m = lsa(ix, k))
  if (cfg$modelo == "lsa") rl else rrf(rb, rl, c = cfg$rrf_c)   # "lsa", ou o hibrido pela RRF
}                                                          # fim da funcao
m <- if (cfg$modelo == "bm25") NULL else lsa(ix, cfg$lsa_k)   # o LSA so e calculado se for usado
```

**O estágio 2 inteiro**: só os $k$ candidatos passam pela `proximidade` — o custo é $k$, não $N$:

```r
rerank_prox <- function(rk, qt, tokens, k, janela) {    # rk: estagio 1; qt: tokens da consulta
  if (k == 0) return(names(rk))                         # k = 0: nao reordena
  top <- head(names(rk), k)                             # os candidatos (head corta se k > N)
  sc  <- sapply(tokens[top], function(dt) proximidade(qt, dt, janela))   # so eles sao lidos
  reordenar(rk, k, sc)                                  # cabeca reordenada + cauda
}                                                       # fim da funcao
```

**Uma consulta de trabalho**, antes e depois:

```r
q  <- usar[1]                                               # uma consulta de trabalho julgada (troquem)
rk <- estagio1(consultas[[q]], ix, cfg, m)                  # estagio 1: o motor da Aula 07
qt <- preparar(consultas[[q]], cfg); qt                     # os tokens da consulta, COM as stopwords do grupo
round(sapply(ix$tokens[names(rk)[1:10]], function(dt) proximidade(qt, dt, 3)), 3)   # prox do top-10, na ordem do estagio 1
rn <- rerank_prox(rk, qt, ix$tokens, 10, 3)                 # reordena os 10 primeiros, janela 3
rbind(estagio1 = names(rk)[1:5], rerank = rn[1:5])          # os dois top-5 lado a lado
docs[rn[1:5][!rn[1:5] %in% names(rk)[1:5]]]                 # os que SUBIRAM para o top-5: leiam
```

(O nome é `rn`, de "reordenado" — **não** `rr`: `rr` é a função do *reciprocal rank* no motor, e o `metricas` precisa dela.)

**Leiam** os que subiram — e os que saíram (troquem `rn` e `names(rk)` na última linha); se nenhum entrou ou saiu, comparem as posições no `rbind`. Subiu o que **responde**, ou só o que tem as palavras em ordem? O que desceu respondia, com outra ordem?

**Exemplos que você mostra:**

- da teoria, `"modelo de recuperacao"` no BM25: $k = 2$ não muda nada (`d2` está em 3º); $k = 3$ dá `d2 d3 d1`, AP $0{,}833 \to 1$;
- da teoria, o **híbrido** (`lsa(ix, 2)`, $c = 60$): `d3 d2 d1 d8 d6 d4 d5 d7`. Os dois relevantes já estão no topo (AP $1$); com $k = 3$ vira `d2 d3 d1 …` — AP continua $1$. Estágio 1 bom deixa pouco para o estágio 2;
- **corpus simulado** (24 notícias, stopwords tiradas), `"fila de caminhoes no porto"` → `qt` = `fila caminhoes porto`. Estágio 1: `doc18 doc01 doc13 doc05 doc24`; proximidade $0{,}333$, $1$, $0{,}5$, $0{,}5$, $0$; reordenado: `doc01 doc13 doc05 doc18 doc24` — os mesmos cinco. `doc01` (*"… a fila de caminhoes cresce …"*) subiu: `fila caminhoes` colados, sem o `de` (stopword).

> **Erro previsto:** consulta sem a limpeza do grupo. Sinal: `tokenizar(…)` no lugar de `preparar(…, cfg)`; no simulado, com `"Fila de caminhões no porto"` (acento), `doc01` cai de $1$ para $0$ — `caminhões` não casa com o `caminhoes` dos documentos, sem erro na tela. Reação: os `ix$tokens` foram feitos com a limpeza e as stopwords do grupo; a consulta passa pelo **mesmo** `preparar(…, cfg)`. As posições também são as **depois** da limpeza.

> **Erro previsto:** o grupo não fez a Aula 07. Sinal: o `config.R` não tem `modelo`; o bloco acima usa `"bm25"` sem avisar. Reação: o estágio 1 é o BM25, e está certo assim; a ficha registra *"estágio 1 = BM25 (Aula 07 não feita)"*.

> **Erro previsto:** chamar o resultado de `rr`. Sinal: no Módulo 8, *Error in rr(r\$rel) : could not find function "rr"* ("não foi possível encontrar a função 'rr'"). Reação: `rr <- …` apagou a função do motor que o `metricas` usa. Rodem de novo o `source` do motor (primeira célula, linha 2) e usem `rn`.

> **Checkpoint 7.** *Na consulta de vocês: quantos documentos mudaram de posição no top-5? Escolham um que subiu e um que desceu e digam, lendo os textos, por que a proximidade os moveu — e se vocês concordam.*
> Esperado: o número (do `rbind`); para o que subiu, os termos da consulta em ordem e perto no texto, e se isso responde à **necessidade**; para o que desceu, o que faltava (ordem trocada, palavras longe). Consulta de um termo só: nada se move — dizer por quê. *"O grupo concorda?"* — vai para a ficha.

> **Ponte:** uma consulta não decide nada. Hora de medir em todas — e escolher $k$ e janela.

---

## Módulo 8 — $k$ e janela em todas as consultas
*trabalho 22 min · conversa 8 min · lembrete: escolhe-se no dev; o teste roda UMA vez; o grupo decide*

**Quem digita muda.** A função recebe **por argumento** tudo o que usa — o ranking do estágio 1 já calculado, os tokens da consulta, os graus, os tokens dos documentos, $k$, janela e limiar:

```r
ap_rerank <- function(rk, qt, grau, tokens, k, janela, limiar)               # AP de UMA consulta
  metricas(rerank_prox(rk, qt, tokens, k, janela), grau, limiar)[["AP"]]     # o AP da ordem final
dev   <- intersect(usar, nec$consulta[nec$conjunto == "dev"])                # aqui se escolhe
teste <- intersect(usar, nec$consulta[nec$conjunto == "teste"])              # so no fim, uma vez
rks <- lapply(consultas[usar], function(texto) estagio1(texto, ix, cfg, m))  # o estagio 1 de cada consulta, uma vez
qts <- lapply(consultas[usar], function(texto) preparar(texto, cfg))         # os tokens de cada consulta
sapply(qts, length)                                                          # quantos termos sobraram em cada uma
```

Consulta com **um termo** não tem par: a reordenação **não muda nada** nela.

**A grade, só no desenvolvimento** — a lógica das Aulas 05 a 07: escolhe-se **no dev**; o **teste** roda **uma vez**, no fim, e nada se ajusta depois de vê-lo.

```r
map0 <- mean(sapply(dev, function(q) ap_rerank(rks[[q]], qts[[q]], qrels[[q]], ix$tokens, 0, 3, cfg$limiar)))
round(map0, 3)                                                    # o MAP do estagio 1 sozinho (k = 0)
grade <- sapply(c(2, 3, 5), function(w)                           # cada janela vira uma coluna...
  sapply(c(3, 5, 10), function(k)                                 # ...cada k, uma linha
    mean(sapply(dev, function(q) ap_rerank(rks[[q]], qts[[q]], qrels[[q]], ix$tokens, k, w, cfg$limiar)))))
rownames(grade) <- c("k3", "k5", "k10"); colnames(grade) <- c("janela2", "janela3", "janela5")
round(grade, 3)                                                   # o MAP de cada combinacao
```

O MAP (*mean average precision*) é a média dos AP das consultas, como na Aula 5,5. **Procurem onde a reordenação perde** — para uma combinação candidata:

```r
ap0 <- sapply(dev, function(q) ap_rerank(rks[[q]], qts[[q]], qrels[[q]], ix$tokens, 0, 3, cfg$limiar))   # estagio 1
ap1 <- sapply(dev, function(q) ap_rerank(rks[[q]], qts[[q]], qrels[[q]], ix$tokens, 5, 3, cfg$limiar))   # k = 5, janela 3 (troquem)
round(rbind(estagio1 = ap0, rerank = ap1), 3)                     # consulta a consulta
dev[ap1 < ap0]                                                    # onde a reordenacao perdeu
```

Abram uma com o `rbind` do Módulo 7 (troquem `q`) e leiam: a proximidade subiu um texto que tem as palavras em ordem mas **não responde**? Ou o relevante estava **fora** do top-$k$?

**O grupo escolhe** $k$ e janela — ou $k = 0$ — olhando **só** `map0` e `grade`, e diz por quê em uma frase (pesem também o custo: $k$ documentos lidos por consulta). *"O grupo concorda?"* Só então:

```r
k_esc <- 5; j_esc <- 3                                            # O QUE O GRUPO ESCOLHEU (exemplo)
tab_teste <- sapply(teste, function(q)                            # para cada consulta de teste...
  sapply(c(estagio1 = 0, rerank = k_esc), function(k)             # ...a referencia (k = 0) e a escolha
    ap_rerank(rks[[q]], qts[[q]], qrels[[q]], ix$tokens, k, j_esc, cfg$limiar)))
round(tab_teste, 3); round(rowMeans(tab_teste), 3)                # relatar como saiu
```

**Exemplos que você mostra:**

- na teoria: AP $0{,}833$ ($k \le 2$) → $1$ ($k \ge 3$), com qualquer janela de 1 a 5;
- **corpus simulado** (BM25, 4 consultas dev): MAP do estágio 1 $0{,}480$; grade $k = 3$: $0{,}521$; $k = 5$: $0{,}535$; $k = 10$: $0{,}535$ — **iguais nas três janelas**. Com stopwords tiradas e consultas curtas, os pares que contam estão colados. Entre empatados, o menor $k$ ($5$); a janela fica a da teoria ($3$), e a ficha registra que não fez diferença;
- no mesmo corpus, o ganho veio de **uma** consulta (q01: $0{,}458 \to 0{,}681$); as outras três empataram. com o **híbrido** como estágio 1, $k = 5$ ganhou em q01 ($0{,}331 \to 0{,}554$) e **perdeu** em q02 ($0{,}625 \to 0{,}375$);
- teste do exemplo: $0{,}775$ → $0{,}775$ — **relata-se assim**. Trocar agora seria ajustar no teste.

> **Erro previsto:** olhar o teste antes de escolher. Sinal: alguém roda `tab_teste` com toda a grade. Reação: *"depois de ver, vocês conseguem escolher como se não tivessem visto?"*

> **Erro previsto:** `teste` vazio. Sinal: `tab_teste` sai `named list()` e o `round` para com *non-numeric argument to mathematical function* ("argumento não numérico para função matemática"). Reação: não há consulta de teste com $R > 0$; não há relato de teste hoje — vai para a ficha.

> **Erro previsto:** `NA` no MAP. Sinal: `mean` devolve `NA`. Reação: entrou consulta com $R = 0$; usem `usar`, da segunda célula.

> **Checkpoint 8.** *Quais $k$ e janela vocês escolhem, olhando só o desenvolvimento, e por quê? Em quantas consultas a escolha perde para o estágio 1, e o que havia no top-5 de uma delas?*
> Esperado: a escolha com `map0` e a grade (e o custo, se houver empate); o número de consultas em que perde; uma consulta lida — palavras em ordem que não respondem, ou relevante fora da cabeça. Com poucas consultas, a ressalva.

> **Ponte:** os números estão na mesa. Falta decidir — e registrar.

---

## Módulo 9 — A decisão do grupo e o registro
*trabalho 12 min · conversa 8 min · lembrete: "não reordenar" vale; ficha e `config.R` dizem o mesmo*

**Quem digita muda.** A pergunta: **o motor reordena, quantos, e com que janela?** Pesem: o MAP no dev; o teste; os erros vistos ao ler; o custo — $k$ documentos lidos **a cada consulta**, inclusive as que o aplicativo da Aula 12 vai receber.

O grupo diz a decisão em uma frase. *"O grupo concorda?"* Você escreve as linhas; o grupo descomenta e ajusta as do bloco da Aula 08 no `config.R` — ou, se o arquivo não tem esse bloco, cola as três linhas antes do `grupo = …` (painel de arquivos → dois cliques em `config.R` → edita → *Ctrl+S*):

```r
  # --- Aula 08: reordenacao (rerank) ------------------------------------
  rerank_k = 5,                           # quantos do topo o reordenador reordena (0 = nao)
  janela   = 3,                           # distancia maxima da proximidade ordenada
```

(Com os valores do grupo no lugar de `5` e `3`.) Depois:

```r
source("config.R")                                                         # recarrega com os campos novos
cfg$rerank_k; cfg$janela                                                   # confiram com a decisao
ranking_final <- function(texto, ix, cfg, m)                               # o motor inteiro, de um texto
  rerank_prox(estagio1(texto, ix, cfg, m), preparar(texto, cfg),           # estagio 1 do cfg$modelo...
              ix$tokens, cfg$rerank_k, cfg$janela)                         # ...e o estagio 2 do cfg
head(ranking_final(consultas[[usar[1]]], ix, cfg, m), 5)                   # o top-5 que o motor daria
```

**Exemplos que você mostra** — frases de decisão (de exemplo):

- *"Reordenar o top-5 do BM25 com janela 3: MAP dev 0,480 → 0,535; teste 0,775 → 0,775; o ganho veio de uma consulta; a janela não fez diferença. Ressalva: 4 consultas dev."* → `rerank_k = 5`, `janela = 3`;
- *"Não reordenar: no dev o ganho foi 0,01 e perdeu em 2 de 4 consultas, com as palavras em ordem num texto que não respondia."* → `rerank_k = 0` (a `janela` fica registrada, sem efeito);
- *"Reordenar o top-10 do híbrido (o `cfg$modelo` é `"hibrido"`)"* → `rerank_k = 10`, e a ficha diz **sobre qual estágio 1** foi escolhido.

> **Erro previsto:** a linha ficou comentada. Sinal: `cfg$rerank_k` dá `NULL` e o `ranking_final` para com *Error in if (k == 0) return(names(rk)) : argument is of length zero* ("argumento de comprimento zero"). Reação: tirem o `#` da linha, salvem (*Ctrl+S*) e rodem o `source("config.R")` de novo.

> **Erro previsto:** a ficha diz um $k$ e o `config.R` outro. Sinal: `cfg$rerank_k` ou `cfg$janela` não bate com a frase. Reação: corrijam antes do fechamento.

> **Checkpoint 9.** *A decisão de vocês em uma frase — reordenar ou não, quantos, com que janela, sobre qual estágio 1 — com os números que a sustentam e uma ressalva. E: `cfg$rerank_k` e `cfg$janela` dizem o mesmo?*
> Esperado: a frase, com o MAP dev e o de teste (ou "sem teste"), a ressalva (poucas consultas, erros vistos, janela sem efeito) e os dois campos iguais aos da frase.

> **Ponte:** o motor de vocês tem, agora, dois estágios — um que recupera e um que relê o par — e uma regra registrada para usá-los.

---

**Funções de R apresentadas nesta sessão** (o guia da Parte D da Aula 09 copia esta linha): nenhuma nova de R base. Da teoria: `proximidade`, `reordenar`. Escritas na sessão (recebem por argumento o que usam): `estagio1(texto, ix, cfg, m)`, `rerank_prox(rk, qt, tokens, k, janela)`, `ap_rerank(rk, qt, grau, tokens, k, janela, limiar)`, `ranking_final(texto, ix, cfg, m)`. Campos novos do `config.R`: `rerank_k`, `janela`.

**Casos degenerados desta sessão** (além dos erros previstos): $k > N$ → `head` e a proteção cortam; $k = 0$ → `rerank_prox` devolve o estágio 1; consulta de um termo, ou cabeça toda com proximidade 0 → ranking igual ao estágio 1, **sem aviso**; empate → ordem do estágio 1; documento da cauda com as palavras em ordem → não sobe (regra); stopword do grupo na consulta → some dos dois lados, e as distâncias são contadas sem ela; janela sem efeito → registrar, não forçar; documento não julgado → irrelevante (*pooling*); consulta com $R = 0$ → fora por `usar`.

---

## Fechamento

Ordem: **perguntas guardadas → tarefa → o que vem → ficha → consolidado → passos de fechamento.** (O teste foi na teoria, individual.)

1. **Perguntas guardadas:** responda as curtas; encaminhe — combinar BM25, LSA e proximidade com pesos aprendidos, Aula 09; RAG, Aula 14; escala e latência real, Aula 15; reordenadores neurais (*cross-encoders*), fora do escopo do curso.
2. **A tarefa do grupo:** escrever, em prosa, para a ficha e o relatório, a análise de uma consulta em que a reordenação ganhou e uma em que perdeu (ou não mudou): o que os textos dizem e por quê.
3. **O que vem:** *"Hoje o motor ganhou um segundo estágio. Na Aula 09, os sinais que vocês já têm — BM25, LSA, proximidade — viram* features *de uma função cujos pesos são aprendidos dos julgamentos de vocês: o* learning to rank*."*
4. **A ficha do projeto** — avise que está gerando. Devolva-a **inteira, sem a seção 8**, em bloco de código Markdown, só com o permitido: **seção 5** — a linha *"reordenação (proximidade ordenada) | 08 | `estrutura/codigo/aula08.ipynb` | <ok / testado, não usado>"* preenchida, e `rerank_k`, `janela` acrescentados aos campos da linha "decisões para o R"; **seção 6** — *"Aula 08: reordenação = top-<k> (0 = não), janela <w>, sobre o estágio 1 <bm25 / lsa / hibrido>, porque … (MAP dev estágio 1 <x>; grade k3/k5/k10 × janela 2/3/5: <melhores>; teste <y> → <z>, ou sem teste) · `cfg$rerank_k = <k>`, `cfg$janela = <w>`"*; **seção 7** — a entrada da Aula 08 (presentes, quem digitou, feito, produzido, pendente); **cabeçalho** — *última atualização: Aula 08 Parte D, <data>, motor08*. Seções 1–4 intocadas.
5. **O consolidado** — avise. Formato de **grupo** (`.md` em bloco de código, nunca PDF, sem código, sem reexplicação, LaTeX, sem a seção "Estado do R"):
   ```markdown
   # Consolidado — PI III — Aula 08 — Parte D — <data>
   *guia versão 2 · tutora: <qual LLM> · sessão de grupo · motor08*
   **Grupo:** <nome> · **presentes:** <nomes> · **digitou:** <nome(s), por módulo>

   ## 1. O que foi feito
   - M7 — proximidade e reordenar no estágio 1 do grupo (<modelo>); top-5 antes × depois numa consulta, lendo os textos
   - M8 — grade $k \in \{3, 5, 10\}$ × janela $\in \{2, 3, 5\}$ em todas as consultas; escolha no dev; teste relatado
   - M9 — a decisão; `config.R` e ficha

   ## 2. Como o grupo trabalhou — opinião da tutora
   <um parágrafo, em primeira pessoa: copiaram as funções e rodaram os testes? leram os textos
   ou só os números? escolheram no dev, ou quiseram ver o teste? a decisão saiu do grupo ou
   foi puxada? quem digitou entendeu?>

   ## 3. Observações para a frente
   - **Para a próxima sessão prática (Aula 09):** <o que precisa estar pronto; quem ficou de quê>
   - **Perguntas guardadas:** <pergunta> — <para qual aula>
   - **Produzido:** ver a entrada "Aula 08" na linha do tempo da ficha do projeto
   - **Ficha atualizada:** sim — seções alteradas: <5, 6, 7, cabeçalho>
   ```
6. **Logo abaixo do consolidado, na mesma mensagem, os passos de fechamento** — os oito, por extenso.

## Passos de fechamento (copie logo abaixo do consolidado)

1. Salvem a ficha como **`00_FICHA_PROJETO.md`** e o consolidado como **`aula08_parteD_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, enviem os dois (pasta à esquerda → upload). `list.files()` tem que mostrá-los soltos, com esses nomes exatos.
3. Rodem, numa célula:
   ```r
   anexar_estado("00_FICHA_PROJETO.md")            # o estado do R vai para a ficha
   anexar_estado("aula08_parteD_consolidado.md")   # e para o consolidado do grupo
   ```
4. Baixem (três pontinhos → *Fazer download*): os dois `.md`; o **`config.R`** (mudou: `rerank_k`, `janela`); e o **notebook R** (*Arquivo → Fazer download → Baixar o .ipynb*), salvo como **`aula08.ipynb`**.
5. No GitHub, enviem (*Add file → Upload files*; mesmo nome substitui): `consolidados/` ← `00_FICHA_PROJETO.md` e `aula08_parteD_consolidado.md`; `estrutura/codigo/` ← `config.R` e `aula08.ipynb`.
6. Confiram no GitHub que a ficha termina com a seção "Estado do R" e que o `config.R` tem `rerank_k` e `janela` **sem** `#` na frente.
7. Confiram que a seção 6 da ficha e o `config.R` dizem o mesmo: o mesmo `rerank_k` e a mesma `janela`, sobre o mesmo estágio 1 (`modelo`).
8. Cada integrante envia o **seu** consolidado da teoria (`aula08_consolidado.md`) para `consolidados/<seu nome>/`.

Se o grupo disser que já fez, pergunte só: *"a ficha no GitHub termina com a seção 'Estado do R'?"*
