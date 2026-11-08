# Aula 07 — Parte D: LSA e busca híbrida no motor do grupo

## Guia de estudo autônomo, com uma LLM como tutora — sessão prática, **de grupo**

*versão 2 — 2026-10-22 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*
*Nota da v2: saíram os* embeddings *neurais e o notebook Python (decisão do professor); a sessão usa o LSA da teoria, tudo em R.*

---

## Para o grupo: como usar

Este é o **segundo arquivo** da Aula 07. Vem depois de `GUIA_ESTUDO_aula07.md` (a teoria, Módulos 1–6 e o teste), que cada um fez sozinho. **Esta sessão é do grupo:** reúnam-se, uma LLM, **um Colab**, uma pessoa digitando (muda a cada módulo).

1. Abra a LLM. Cole **este arquivo inteiro** e, junto, **a ficha do projeto** (`consolidados/00_FICHA_PROJETO.md`). Se quiserem, o consolidado da teoria de um de vocês.
2. Escreva: *"Vamos para a prática."*
3. **Colab** → *Ambiente de execução → Alterar o tipo* → **R**, antes de enviar qualquer arquivo. Na **primeira célula**, troquem `<usuario>` e `<grupo>` (seção 1 da ficha); na **segunda**, os nomes dos `qrels_<juiz>_<data>.csv` (seção 4). Rodem as duas.
4. Tenham à mão o arquivo da teoria: as funções `lsa`, `ranking_lsa` e `rrf` são **copiadas** de lá (Módulos 3, 4 e 6).
5. Se ela despejar texto, entregar código sem comentário, escrever fórmula em texto puro, **escolher o modelo ou o $k$ por vocês** ou **julgar um documento**, digam **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é conosco"**.

**Primeira célula do Colab** — a da Aula 06, com o `motor07`:

```r
REPO <- "https://raw.githubusercontent.com/<usuario>/projeto-<grupo>/main/"   # o endereco Raw do repositorio do grupo (secao 1 da ficha)
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor07.R")   # funcoes do curso, ate a Aula 06
download.file(paste0(REPO, "estrutura/codigo/config.R"), "config.R")         # traz o config.R (vai ser editado no Modulo 9)
source("config.R")                                                           # cfg: as decisoes do grupo
cp     <- read.csv(paste0(REPO, "estrutura/banco-de-dados/corpus.csv"),      # o corpus CONGELADO na Aula 05
                   stringsAsFactors = FALSE, fileEncoding = "UTF-8")         #   texto fica texto; acentos em UTF-8
docs   <- setNames(cp$texto, cp$id)                                          # vetor nomeado id -> texto
origem <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/origem.rds"))))   # de que artigo veio cada documento
ix     <- montar(docs, cfg)                                                  # tudo derivado: indice, TF-IDF, BM25
estado()                                                                     # a tutora compara com a secao 8 da ficha
```

**Segunda célula — o gabarito e as consultas** (a mesma da Aula 06):

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

**Tempo:** 60 a 90 minutos. **Depois:** Aula 08. **Atenção:** tudo some quando a sessão do Colab cair; o fechamento diz o que baixar e enviar.

**No fim vocês terão:** o LSA no corpus do grupo, comparado ao BM25 numa consulta, lendo os textos; BM25, LSA com alguns $k$ e o híbrido em todas as consultas julgadas, com modelo e $k$ escolhidos no **desenvolvimento** e relatados **uma vez** no **teste**; a decisão no `config.R` e na ficha.

---
---

# Instruções para a LLM

Valem **todas** as regras da Parte A do arquivo anterior — teto 360 (540 para uma ideia só), uma ideia por mensagem, código comentado, trechos de no máximo 8 linhas (as duas células iniciais e as funções copiadas da teoria são a exceção), previsão antes da saída, "só o que foi apresentado", exemplos antes do checkpoint, LaTeX, tom, o guia vence. Sem consolidado da teoria, calibre com: *"por que somar o escore do BM25 com o cosseno do LSA não é uma boa fusão?"*

**Primeiro, a ficha.** Leia-a inteira e diga de volta, em **três linhas**: (1) o grupo e o tema; (2) o corpus congelado (quantos documentos, `corpus.csv`), as consultas de trabalho, as necessidades e quais são de **teste**; (3) o que a Aula 06 deixou: `prf_k`, o resultado do Rocchio, pendências. **Sem ficha, a sessão não começa** — peça; se se perdeu, reconstruam pelos consolidados e marquem *"reconstruída na Aula 07"*. Você não altera a ficha durante a sessão; devolve inteira no fechamento.

**Depois, o estado do R.** Peça a saída do `estado()` e compare com a seção 8 da ficha: `MOTOR_VERSAO` mostra `motor07` (a ficha diz `motor06`: esperado); `length(docs)` bate com a seção 4; `cfg` tem `limiar`, `prf_k`, `rocchio` (e `juizes`, se houver) — e **ainda não** tem `modelo`, `lsa_k` nem `rrf_c`. Confira a segunda célula: `names(qrels)` são as consultas julgadas da ficha. Divergência não é erro de ninguém: diga o que viu e pergunte qual é a verdade. **Você nunca escreve a seção 8.**

**Você fala com um grupo:** "vocês". Quem digita muda a cada módulo. Avise no início: blocos curtos; no fim, a **ficha**, o consolidado do grupo e os **passos de fechamento**.

| você (LLM) faz | o grupo faz |
|---|---|
| lembra as funções da teoria; confere saídas; aponta casos degenerados | **copia** `lsa`, `ranking_lsa` e `rrf` da teoria e **roda** tudo |
| pergunta o que cada documento do top-5 diz | **lê** os textos e explica por que o LSA os trouxe |
| escreve as linhas do `config.R`; preenche a ficha | **escolhe** modelo e $k$ olhando **só** o desenvolvimento; **diz** a decisão com o porquê |

**Você não escolhe o modelo nem o $k$, não julga relevância.** "Ficar com o BM25" é decisão válida. Se perguntarem "qual é melhor?", devolva: *"olhem a tabela de desenvolvimento: qual linha tem o maior MAP, e em quantas consultas ela perde para o BM25?"*

**Só o que foi apresentado.** Da teoria desta aula: `svd`, `%*%`, `t`, `diag(x, nrow = k)`, `...`; `lsa`, `ranking_lsa`, `rrf`; energia, dobrar a consulta, $k$ como hiperparâmetro, RRF. Das anteriores: `c`, `length`, `names`, `rownames`, `colnames`, `[ ]`, `[[ ]]`, `==`, `%in%`, `!`, `1:n`, `paste0`, `sapply`, `lapply`, `function`, `sum`, `list`, `unlist`, `sort(decreasing = …)`, `dim`, `matrix` (00); `unique`, `list.files`, `estado`, `anexar_estado` (Parte D 00); `intersect`, `if`, `return`, `>`, `round` (01); `apply`, `$`, `sqrt`, `^` (02); `head`, `for`, `NULL`, `names(x) <-` (03); valor padrão de argumento (04); `if (…) x else y` (05); `<`, `rowMeans`, `drop = FALSE` (06); `which`, `rbind` (5,5); `download.file`, `source`, `readRDS`, `min`, `max` (Parte D 01); `gzcon(url(…))` (Parte D 02); `read.csv`, `setNames`, `nrow` (Parte D 05); do motor, `preparar`, `vetor_consulta`, `cosseno`, `ranking_bm25`, `ler_qrels`, `metricas`. **Novo aqui, marcado:** `<=`. Nada mais.

**Não adiante:** reordenação do topo (Aula 08), RAG (Aula 14), escala (Aula 15). Guarde. **Nunca peça senha, *token* ou código do GitHub** — o envio é feito por eles, pela página.

**Rota:** Módulos 7, 8 e 9 de 9. Marque: *"Módulo 8 de 9 — BM25, LSA e híbrido em todas as consultas."*

---

## Módulo 7 — O LSA no corpus do grupo: uma consulta, lendo os textos
*trabalho 20 min · conversa 8 min · lembrete: toda linha comentada; previsão antes; o grupo lê os textos*

**Quem digita: a primeira pessoa.** Copiem da teoria, sem mudar nada, `lsa` (Módulo 3) e `ranking_lsa` (Módulo 4), e rodem. O `motor07` não as tem.

```r
dim(ix$w); min(dim(ix$w))                         # termos x documentos; o k maximo e o menor dos dois
m20 <- lsa(ix, 20)                                # LSA de trabalho, k = 20 (menos, se o k maximo for menor)
s <- svd(ix$w)                                    # a SVD inteira, so para a energia
round(sum(m20$S^2) / sum(s$d^2), 3)               # fracao da energia guardada com k = 20
```

A **energia** é a da teoria: $\sum_{i \leq k}\sigma_i^2 / \sum_i \sigma_i^2$. Com centenas de documentos, 20 dimensões guardam bem mais que o terço do corpus de 8 com $k = 2$ — mas ainda **jogam fora** parte da matriz, de propósito.

**Uma consulta de trabalho**, LSA ao lado do BM25:

```r
q  <- usar[1]                                              # uma consulta de trabalho julgada (troquem)
rl <- ranking_lsa(consultas[[q]], ix, cfg, m20)            # o LSA: a consulta e o TEXTO, dobrado em 20 coordenadas
rb <- ranking_bm25(consultas[[q]], ix, cfg)                # o lexico, com as decisoes do grupo
round(head(rl, 5), 3)                                      # os cossenos LSA do top-5
rbind(bm25 = names(rb)[1:5], lsa = names(rl)[1:5])         # os dois top-5 lado a lado
so_lsa <- names(rl)[1:5][!names(rl)[1:5] %in% names(rb)[1:5]]   # os que SO o LSA trouxe
docs[so_lsa]                                               # leiam
```

```r
sapply(so_lsa, function(d)                                 # para cada um que so o LSA trouxe...
  length(intersect(preparar(consultas[[q]], cfg), ix$tokens[[d]])))   # ...quantas palavras da consulta ele tem
qrels[[q]][so_lsa]                                         # e o grau que o grupo deu (NA = nao julgado)
```

**Leiam** os textos que só o LSA trouxe: falam do assunto com outras palavras (o `d1` de "busca") ou só "parecem" (o `d4`, o `d8`)? Um documento com **zero** palavras da consulta só pode ter vindo pelas direções da SVD. E o que o BM25 tinha e o LSA perdeu — um nome próprio, uma sigla, um número?

**Exemplos que você mostra** — da teoria (corpus de 8, $k = 2$):

- "busca": o léxico só via `d5` e `d7`; o LSA trouxe `d1` (0,967 — fala de recuperação: ganho) e pôs `d4` no topo (0,999 — não fala de busca: ruído);
- "ranqueamento": `d8` empatado com `d3`, com só `e` e `de` em comum — com pouco texto, o LSA inventa relações;
- num corpus simulado de 80 documentos (não é de nenhum grupo), $k = 20$ guardou $0{,}815$ da energia; os dois que só o LSA trouxe tinham 1 palavra da consulta cada, e grau 2: ganho.

> **Erro previsto:** não copiar as funções. Sinal: *Error in lsa(ix, 20) : could not find function "lsa"* ("não encontrou a função"). Reação: o `motor07` vai até a Aula 06; copiem `lsa` e `ranking_lsa` da teoria e rodem a célula.

> **Erro previsto:** $k$ maior que o possível. Sinal: `lsa(ix, 500)` dá *Error in s\$u[, 1:k, drop = FALSE] : subscript out of bounds*. Reação: o $k$ máximo é `min(dim(ix$w))` — em geral, o número de documentos.

> **Erro previsto:** esquecer o modelo. Sinal: `ranking_lsa(consultas[[q]], ix, cfg)` dá *Error in t(modelo\$U) : argument "modelo" is missing, with no default* ("argumento ausente, sem padrão"). Reação: o quarto argumento é o que `lsa` devolveu (`m20`).

> **Erro previsto:** passar o id em vez do texto. Sinal: `ranking_lsa(q, ix, cfg, m20)` sai todo `0`, na ordem do corpus — sem erro. Reação: `"q01"` não está no vocabulário: vetor nulo (o caso degenerado da teoria). O texto é `consultas[[q]]`.

> **Checkpoint 7.** *Na consulta de vocês: quantos documentos os dois top-5 têm em comum? Escolham um que só o LSA trouxe e um que só o BM25 trouxe e digam, lendo os textos, por que cada modelo os pôs ali.*
> Esperado: o número (do `rbind`); para o do LSA, uma frase ligando o texto à consulta por **sentido** (ou admitindo ruído, com a contagem de palavras em comum); para o do BM25, a palavra exata. *"O grupo concorda?"* — vai para a ficha.

> **Ponte:** uma consulta e um $k$ não decidem nada. Hora de medir em todas.

---

## Módulo 8 — BM25, LSA e híbrido em todas as consultas
*trabalho 25 min · conversa 8 min · lembrete: escolhe-se no dev; o teste roda UMA vez; o grupo decide*

**Quem digita muda.** Copiem a `rrf` da teoria (Módulo 6) e rodem. Depois, uma função que dá o ranking de cada modelo, e outra que dá o AP — tudo que usam entra pelos argumentos:

```r
ranking_modelo <- function(txt, modelo, ix, cfg, m, c = 60) {    # m: o que lsa() devolve
  rb <- ranking_bm25(txt, ix, cfg)                               # o lexico
  if (modelo == "bm25") return(rb)                               # so ele
  rl <- ranking_lsa(txt, ix, cfg, m)                             # o LSA
  if (modelo == "lsa") rl else rrf(rb, rl, c = c)                # so ele, ou a fusao RRF
}                                                                # fim da funcao
ap_modelo <- function(q, modelo, m, consultas, qrels, ix, cfg)   # o AP de um modelo numa consulta
  metricas(ranking_modelo(consultas[[q]], modelo, ix, cfg, m), qrels[[q]], cfg$limiar)[["AP"]]
```

**Alguns $k$**, limitados pelo corpus. **Novo: `<=`** — "menor ou igual": `3 <= 3` dá `TRUE`.

```r
ks <- c(10, 20, 50)                                                  # os k candidatos (troquem, se quiserem)
ks <- ks[ks <= min(dim(ix$w))]                                       # so os possiveis
ms <- setNames(lapply(ks, function(k) lsa(ix, k)), paste0("k", ks))  # um modelo LSA por k: k10, k20, k50
names(ms)                                                            # confiram quais ficaram
```

**Desenvolvimento e teste** — a lógica das Aulas 05 e 06: escolhe-se **no desenvolvimento**; o **teste** roda **uma vez**, no fim, e nada se ajusta depois de vê-lo.

```r
dev   <- intersect(usar, nec$consulta[nec$conjunto == "dev"])          # aqui se escolhe
teste <- intersect(usar, nec$consulta[nec$conjunto == "teste"])        # so no fim, uma vez
tab_dev <- sapply(dev, function(q) c(                                  # para cada consulta dev, o AP de...
  bm25 = ap_modelo(q, "bm25", NULL, consultas, qrels, ix, cfg),        # ...BM25 (nao usa LSA: m = NULL)
  lsa  = sapply(ms, function(m) ap_modelo(q, "lsa", m, consultas, qrels, ix, cfg)),       # ...LSA, cada k
  hib  = sapply(ms, function(m) ap_modelo(q, "hibrido", m, consultas, qrels, ix, cfg))))  # ...hibrido, cada k
round(tab_dev, 3); round(rowMeans(tab_dev), 3)                         # por consulta, e o MAP de cada linha
```

As linhas saem `bm25`, `lsa.k10`, `lsa.k20`, …, `hib.k10`, … O MAP (*mean average precision*) é a média dos AP, como na Aula 5,5.

**Procurem onde cada um perde** (troquem `k20` pela linha que estiverem olhando):

```r
colnames(tab_dev)[tab_dev["lsa.k20", ] < tab_dev["bm25", ]]   # consultas em que o LSA perdeu do BM25
colnames(tab_dev)[tab_dev["hib.k20", ] < tab_dev["bm25", ]]   # e em que o hibrido perdeu
```

Abram uma delas com o `rbind` dos top-5 do Módulo 7 (troquem `q` e o modelo) e leiam.

**O grupo escolhe** — `"bm25"`, `"lsa"` ou `"hibrido"`, e o $k$ — olhando **só** `tab_dev`, e diz por quê em uma frase. *"O grupo concorda?"* Só então:

```r
escolha <- "hibrido"; k_esc <- 20                                  # O QUE O GRUPO ESCOLHEU (exemplo)
m_esc <- lsa(ix, k_esc)                                            # o LSA do k escolhido
tab_teste <- sapply(teste, function(q) c(                          # para cada consulta de teste...
  bm25      = ap_modelo(q, "bm25", NULL, consultas, qrels, ix, cfg),     # ...a referencia
  escolhido = ap_modelo(q, escolha, m_esc, consultas, qrels, ix, cfg)))  # ...e a escolha
round(tab_teste, 3); round(rowMeans(tab_teste), 3)                 # relatar como saiu
```

**Exemplos que você mostra:**

- na teoria (uma consulta): AP BM25 $0{,}833$, LSA $1$, RRF $1$; nDCG graduado $0{,}951$, $0{,}966$, $0{,}990$ — o híbrido somou o melhor dos dois;
- no corpus simulado (80 documentos, 5 consultas dev): MAP BM25 $0{,}943$; LSA $k = 10$ / $20$ / $50$: $0{,}909$ / $0{,}939$ / $0{,}953$; híbrido: $0{,}944$ / $0{,}953$ / $0{,}947$ — $k$ pequeno demais atrapalha; diferenças de centésimos com 5 consultas pedem ressalva;
- no mesmo exemplo, escolhido o híbrido com $k = 20$, o teste deu BM25 $0{,}985$ e híbrido $0{,}955$: **relata-se assim**. Trocar agora seria ajustar no teste.

> **Erro previsto:** olhar o teste antes de escolher. Sinal: alguém roda `tab_teste` com todas as linhas. Reação: *"depois de ver, vocês conseguem escolher como se não tivessem visto?"*

> **Erro previsto:** um $k$ que saiu da lista. Sinal: com menos de 50 documentos, `ms[["k50"]]` é `NULL` e `ap_modelo(q, "lsa", ms[["k50"]], …)` dá *Error in t.default(modelo\$U) : argument is not a matrix*. Reação: confiram `names(ms)`; usem só os que ficaram.

> **Erro previsto:** `teste` vazio. Sinal: `tab_teste` sai `named list()` e o `round` para com *non-numeric argument to mathematical function*. Reação: não há consulta de teste com $R > 0$; não há relato de teste hoje — e isso vai para a ficha.

> **Erro previsto:** `NA` no MAP. Sinal: `rowMeans` devolve `NA`. Reação: entrou consulta com $R = 0$; usem `usar`, da segunda célula.

> **Checkpoint 8.** *Qual modelo e qual $k$ vocês escolhem, olhando só o desenvolvimento, e por quê? Em quantas consultas o escolhido perde para o BM25, e o que havia no top-5 de uma delas?*
> Esperado: a escolha com os MAP de dev; o número de consultas em que perde (das linhas de `colnames`); uma consulta lida. Se o LSA perdeu em consultas com nomes próprios ou números, dizem isso. Com poucas consultas, a ressalva.

> **Ponte:** os números estão na mesa. Falta decidir — e registrar.

---

## Módulo 9 — A decisão do grupo e o registro
*trabalho 12 min · conversa 8 min · lembrete: "ficar com o BM25" vale; ficha e `config.R` dizem o mesmo*

**Quem digita muda.** A pergunta: **qual modelo o motor usa, e com que $k$?** Pesem: o MAP no dev; o resultado no teste; as consultas em que o LSA errou, lidas; o custo — o LSA refaz a SVD sempre que o corpus muda, e uma consulta nova não custa nada (é dobrada como na teoria).

O grupo diz a decisão em uma frase. *"O grupo concorda?"* Você escreve as linhas; o grupo descomenta e ajusta as do bloco da Aula 07, se o `config.R` veio do modelo novo, ou as cola num bloco novo antes do `grupo = …` (painel de arquivos → dois cliques em `config.R` → edita → *Ctrl+S*):

```r
  # --- Aula 07: LSA e busca hibrida --------------------------------------
  modelo = "bm25",                        # "bm25", "lsa" ou "hibrido" (RRF de bm25 e lsa)
  lsa_k  = 20,                            # dimensoes do LSA
  rrf_c  = 60,                            # constante da fusao RRF
```

(Com os valores do grupo.) Depois:

```r
source("config.R")                                                     # recarrega com os campos novos
cfg$modelo; cfg$lsa_k; cfg$rrf_c                                       # confiram com a decisao
ranking_motor <- function(txt, ix, cfg)                                # o ranking do motor, com a decisao
  ranking_modelo(txt, cfg$modelo, ix, cfg, lsa(ix, cfg$lsa_k), c = cfg$rrf_c)   # modelo, k e c do config.R
round(head(ranking_motor(consultas[[usar[1]]], ix, cfg), 5), 4)        # o top-5 que o motor daria
```

A `ranking_motor` refaz a SVD a cada consulta (com o corpus de vocês, frações de segundo); com `"bm25"`, o LSA nem chega a ser calculado.

**A pseudo-realimentação da Aula 06** foi medida sobre o cosseno; o `prf_k` continua no `config.R` como estava. Combiná-la com o LSA não é decisão de hoje — se a ficha diz `prf_k > 0`, anotem como pendência.

**Exemplos que você mostra** — frases de decisão (de exemplo):

- *"Híbrido com $k = 20$, $c = 60$: MAP dev 0,943 → 0,953; teste 0,985 → 0,955 — perdeu no teste, relatado. Ressalva: 5 consultas dev."* → `modelo = "hibrido"`, `lsa_k = 20`;
- *"Ficar com o BM25: o LSA perdeu em 3 de 4 consultas dev, todas com nomes de bairros."* → `modelo = "bm25"`;
- `lsa_k` e `rrf_c` ficam no `config.R` mesmo com `modelo = "bm25"`: registram o que foi testado.

> **Erro previsto:** a ficha diz "híbrido" e o `config.R` diz `"bm25"`. Sinal: `cfg$modelo` não bate com a frase. Reação: corrijam antes do fechamento.

> **Erro previsto:** escrever `"BM25"` ou `"LSA"`. Sinal: o top-5 do `ranking_motor` sai com escores de RRF ($0{,}03\ldots$) — sem aviso. Reação: `ranking_modelo` compara o texto exato; o que não for `"bm25"` nem `"lsa"` cai no híbrido. Os três valores são `"bm25"`, `"lsa"`, `"hibrido"`, sem acento, em minúsculas.

> **Erro previsto:** `lsa_k` maior que o possível. Sinal: com `"lsa"` ou `"hibrido"`, o `ranking_motor` para com *subscript out of bounds*. Reação: `lsa_k` $\leq$ `min(dim(ix$w))`.

> **Checkpoint 9.** *A decisão de vocês em uma frase — modelo e $k$ — com os números que a sustentam e uma ressalva. E: o `cfg$modelo` e o `cfg$lsa_k` que acabaram de sair dizem o mesmo?*
> Esperado: a frase, com o MAP dev e o de teste (ou "sem teste"), a ressalva (poucas consultas, erros do LSA vistos) e `cfg$modelo`, `cfg$lsa_k` iguais aos da frase.

> **Ponte:** o motor de vocês tem, agora, dois olhares — o léxico e o LSA — e uma regra registrada para usá-los.

---

**Funções de R apresentadas nesta sessão** (o guia da Parte D da Aula 08 copia esta linha): `<=`. Da teoria: `lsa`, `ranking_lsa`, `rrf`. Escritas na sessão: `ranking_modelo`, `ap_modelo`, `ranking_motor`. Campos novos do `config.R`: `modelo`, `lsa_k`, `rrf_c`.

**Casos degenerados desta sessão:** $k$ maior que `min(dim(ix$w))` → *subscript out of bounds* (em `lsa` e no `ranking_motor`); $k$ que saiu de `ks` → `NULL` e *argument is not a matrix*; id no lugar do texto, ou consulta só com palavras fora do vocabulário → vetor nulo, cosseno 0 para todos, ordem do corpus; modelo LSA feito com outro `ix` (o `cfg` mudou e o `ix` foi refeito) → *non-conformable arguments*: refaçam o `lsa`; empate no RRF → fica na ordem do BM25 (o primeiro ranking); documentos com BM25 0 → ainda recebem posição e parcela no RRF; `teste` vazio → `named list()` e erro no `round`; consulta com $R = 0$ → fora por `usar`; documento do top-5 não julgado → irrelevante (*pooling*); `cfg$modelo` fora dos três → cai no híbrido sem aviso.

---

## Fechamento

Ordem: **perguntas guardadas → tarefa → o que vem → ficha → consolidado → passos de fechamento.** (O teste foi na teoria, individual.)

1. **Perguntas guardadas:** responda as curtas; encaminhe — reordenação, Aula 08; RAG, Aula 14; escala, Aula 15.
2. **A tarefa do grupo:** escrever, em prosa, para a ficha e o relatório, a análise de uma consulta em que o LSA (ou o híbrido) ganhou do BM25 e uma em que perdeu: o que os textos dizem e por quê.
3. **O que vem:** *"Hoje o motor ganhou um olhar denso e uma fusão. Na Aula 08, um reordenador relê o topo do ranking de vocês — onde as palavras da consulta aparecem, e em que ordem — e o reordena, medido com as mesmas `metricas`."*
4. **A ficha do projeto** — avise que está gerando. Devolva-a **inteira, sem a seção 8**, em bloco de código Markdown, só com o permitido: **seção 5** — a linha *"LSA e busca híbrida | 07 | `estrutura/codigo/aula07.ipynb` | <ok / testado, não usado>"*, e `modelo`, `lsa_k`, `rrf_c` acrescentados aos campos da linha "decisões para o R"; **seção 6** — *"Aula 07: modelo do motor = <bm25 / lsa / hibrido>, $k$ = <…>, porque … (MAP dev BM25 <x>, LSA <y>, híbrido <z>; teste <a> → <b>, ou sem teste) · `cfg$modelo = "<…>"`, `cfg$lsa_k = <…>`, `cfg$rrf_c = 60`"*; **seção 7** — a entrada da Aula 07 (presentes, quem digitou, feito, produzido, pendente — inclusive PRF × LSA, se `prf_k > 0`); **cabeçalho** — *última atualização: Aula 07 Parte D, <data>, motor07*. Seções 1–4 intocadas.
5. **O consolidado** — avise. Formato de **grupo** (`.md` em bloco de código, nunca PDF, sem código, sem reexplicação, LaTeX, sem a seção "Estado do R"):
   ```markdown
   # Consolidado — PI III — Aula 07 — Parte D — <data>
   *guia versão 2 · tutora: <qual LLM> · sessão de grupo · motor07*
   **Grupo:** <nome> · **presentes:** <nomes> · **digitou:** <nome(s), por módulo>

   ## 1. O que foi feito
   - M7 — LSA no corpus do grupo; LSA × BM25 numa consulta, lendo os textos
   - M8 — BM25, LSA (vários $k$) e híbrido em todas as consultas; escolha no dev; teste relatado
   - M9 — a decisão; `config.R` e ficha

   ## 2. Como o grupo trabalhou — opinião da tutora
   <um parágrafo, em primeira pessoa: leram os textos do top-5 ou só os números?
   escolheram no dev, ou quiseram ver o teste? a decisão saiu do grupo ou foi puxada?
   quem digitou entendeu?>

   ## 3. Observações para a frente
   - **Para a próxima sessão prática (Aula 08):** <o que precisa estar pronto; quem ficou de quê>
   - **Perguntas guardadas:** <pergunta> — <para qual aula>
   - **Produzido:** ver a entrada "Aula 07" na linha do tempo da ficha do projeto
   - **Ficha atualizada:** sim — seções alteradas: <5, 6, 7, cabeçalho>
   ```
6. **Logo abaixo do consolidado, na mesma mensagem, os passos de fechamento** — os oito, por extenso.

## Passos de fechamento (copie logo abaixo do consolidado)

1. Salvem a ficha como **`00_FICHA_PROJETO.md`** e o consolidado como **`aula07_parteD_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, enviem os dois (pasta à esquerda → upload). `list.files()` tem que mostrá-los soltos, com esses nomes exatos.
3. Rodem, numa célula:
   ```r
   anexar_estado("00_FICHA_PROJETO.md")            # o estado do R vai para a ficha
   anexar_estado("aula07_parteD_consolidado.md")   # e para o consolidado do grupo
   ```
4. Baixem (três pontinhos → *Fazer download*): os dois `.md`; o **`config.R`** (mudou: `modelo`, `lsa_k`, `rrf_c`); e o **notebook** (*Arquivo → Fazer download → Baixar o .ipynb*), salvo como **`aula07.ipynb`**.
5. No GitHub, enviem (*Add file → Upload files*; mesmo nome substitui): `consolidados/` ← `00_FICHA_PROJETO.md` e `aula07_parteD_consolidado.md`; `estrutura/codigo/` ← `config.R` e `aula07.ipynb`.
6. Confiram no GitHub que a ficha termina com a seção "Estado do R" e que o `config.R` tem `modelo`, `lsa_k` e `rrf_c`.
7. Confiram que a seção 6 da ficha e o `config.R` dizem o mesmo: o mesmo `modelo`, o mesmo `lsa_k`, o mesmo `rrf_c`.
8. Cada integrante envia o **seu** consolidado da teoria (`aula07_consolidado.md`) para `consolidados/<seu nome>/`.

Se o grupo disser que já fez, pergunte só: *"a ficha no GitHub termina com a seção 'Estado do R'?"*
