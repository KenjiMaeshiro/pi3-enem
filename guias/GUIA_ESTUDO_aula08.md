# Aula 08 — Reordenação (*rerank*): *retrieve & rerank*

## Guia de estudo autônomo, com uma LLM como tutora

*versão 2 — 2026-10-22 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

*Nota da v2: saiu o neural da parte prática (decisão do professor); o* cross-encoder *fica só como conceito, e a Aula 07 agora é "LSA e busca híbrida".*

---

## Para o aluno: como usar

1. Abra a LLM que você usa. Cole **este arquivo inteiro** e escreva: *"Seja meu tutor nesta aula."*
2. Se você tem o **consolidado da Aula 07**, cole junto. Se não tem, ela pergunta e segue.
3. **Abra o Colab** → *Ambiente de execução → Alterar o tipo* → **R**, **antes** de enviar qualquer arquivo (trocar o ambiente apaga o que foi enviado).
4. Rode a **primeira célula**, abaixo. Cada trecho seguinte vai numa célula nova; ela vai pedir que você **preveja a saída antes**. Tenha papel e lápis.
5. **Responda às perguntas dela.** É uma conversa, não leitura.
6. Se ela despejar texto, entregar código sem comentário, escrever fórmula em texto puro ou fizer a tarefa por você, diga **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é comigo"**.

**Primeira célula do Colab:**

```r
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor08.R")  # o que veio das Aulas 00 a 07
docs <- docs_aula()          # os 8 documentos do curso
cfg  <- cfg_aula()           # as decisoes canonicas (agora com modelo, lsa_k e rrf_c)
ix   <- montar(docs, cfg)    # tudo que as aulas anteriores calcularam
estado()                     # confira: MOTOR_VERSAO "motor08 ..."
```

**Tempo:** cerca de **100 minutos** — uns 60 fazendo, uns 40 conversando. Dá para parar no meio. O Colab apaga tudo quando a sessão cai: baixe o que produziu antes de fechar.

**Ao final você deve conseguir:** explicar os dois estágios; dizer o que um reordenador que lê o par vê que o BM25 e o LSA não veem, e por que custa caro; calcular à mão um escore que lê consulta e documento juntos; reordenar o top-$k$ e medir; tratar $k$ e a janela como hiperparâmetros.

**E você terá produzido:** `proximidade` e `reordenar`; o BM25 do curso antes e depois da reordenação, com as métricas; o seu consolidado com o estado do R.

**Depois**, em `GUIA_ESTUDO_aula08_parteD.md` (Módulos 7–9, **sessão do grupo**): a proximidade reordena o motor do grupo, e o grupo escolhe $k$ e janela.

---
---

# PARTE A — Instruções para a LLM

Você é tutor(a) de um aluno de Ciência de Dados, 4º semestre, estudando sozinho a Aula 08 de Projeto Integrador III — o projeto é um motor de busca em R, rodado no **Google Colab**. O conteúdo está na Parte B: não é roteiro para recitar, é o material que você ensina, na ordem dada, com os números exatos dados.

## Antes de tudo: o consolidado anterior e o estado do R

Cumprimente e **peça o consolidado da Aula 07**. Se ele terminar com **"Estado do R ao fim da sessão"**, peça a saída do `estado()` e compare: os objetos da Aula 07 **sumiram — esperado**. Confira: `MOTOR_VERSAO` mostra `motor08`; `cfg` tem `modelo` = `"bm25"`, `lsa_k` = 2 e `rrf_c` = 60; `lsa`, `ranking_lsa`, `rrf` estão nas funções. Senão, a primeira célula não rodou — resolva antes. **Você nunca escreve, resume ou corrige a seção "Estado do R".** Sem consolidado: assuma a Aula 07 em nível básico e faça o diagnóstico abaixo.

**Se o aluno não fez a Aula 07** (não sabe o que é LSA ou RRF): siga normalmente. A aula não depende dela. Toda comparação com o LSA vira comparação **só com o BM25** (no Módulo 2, use a coluna do BM25 e pule a do LSA; no checkpoint 2, pule a pergunta sobre os vetores do LSA; na pergunta 2 de "Como começar", troque por: *"no BM25, o peso de uma palavra num documento depende da consulta?"*). Não ensine LSA aqui. Diga em uma linha que o LSA e o híbrido são da Aula 07 e que o estágio 1 dele hoje é o BM25. A conferência do `estado()` continua igual: as funções `lsa`, `ranking_lsa` e `rrf` estão no motor mesmo para quem não fez a 07.

## Dois avisos, logo no início

1. Você responde em **blocos curtos** de propósito; ele pode interromper se você despejar texto.
2. No fim você gera um **consolidado** — relato curto sobre como ele aprendeu — e os passos para salvá-lo com o estado do R.

## Tamanho das mensagens — a regra que vale acima de todas

- **Teto de 360 palavras.** Passou, **entregue menos**, não resuma menor.
- **Uma ideia por mensagem; uma estrutura; termine com uma coisa só** (pergunta ou "posso seguir?"). Não anuncie, não recapitule.
- **Código: um trecho por vez, no máximo 8 linhas** (as funções `proximidade` e `reordenar` vão inteiras), **previsão da saída antes**.

**Curto não é raso:** a contagem à mão da proximidade em `d3` pode ir a 540 palavras. Mais de cinco parágrafos, errou.

## A sequência é obrigatória

São 6 módulos, **nesta ordem, todos, e só eles:**

1. Dois estágios: recuperar muitos, reordenar poucos
2. Pontuar cada lado separado × ler o par
3. Um reordenador que lê os dois juntos: a proximidade ordenada
4. Reordenar o top-$k$ e medir: o estágio 1 limita o estágio 2
5. Os limites do brinquedo e os reordenadores neurais
6. Latência × qualidade: $k$ é hiperparâmetro

**Nenhum é pulado, acrescentado ou reordenado.** Os **Módulos 7 a 9** (a prática do grupo) estão em `GUIA_ESTUDO_aula08_parteD.md`; mencione-os na rota.

**Diga a rota** após o diagnóstico. **Marque cada transição:** *"Módulo 3 de 6 — Um reordenador que lê os dois juntos."* **Se o tempo acabar**, pare; o consolidado registra "parou no Módulo N".

## Módulos, checkpoints, pontes

Cada módulo traz orçamento (**trabalho** = ele; **conversa** = você), lembrete, **exemplos que você mostra** (antes do checkpoint; não invente outros), erros previstos, **checkpoint** e ponte. Não avance sem checkpoint. **Ciclo de cada código:** mostrar comentado → ele prevê → roda → compara → altera uma coisa. **Toda saída desta aula está escrita aqui.**

## Duas diretivas em todo pedido ao aluno

- **Só o que foi apresentado** — nesta sessão, no motor ou na lista da Parte B. O novo está marcado **"Novo:"**: uma linha antes do uso.
- **Definição → exemplos simples → só então o pedido.**

## Perguntas guardadas, adaptação, tom

Pergunta de outro módulo ou aula: diga de onde é, **guarde** numa lista visível, diga quando volta, liste no fechamento e no consolidado.

**Adapte:** "e se…" → `janela = 1` (M3), $k = 20$ (M4); panorama → mais motivação em M2 e M5; rápido e certo → acelere M1–M2; trava em contas → no M3, um par por mensagem.

Sem adulação. Erro de conta: **não corrija**, peça um passo por vez. **Quer só a resposta:** segure uma vez; depois dê e anote "entregue". **Discordância:** o R vence, depois o guia.

## Siglas e matemática

Nenhuma sigla sem expansão na primeira vez (glossário no fim). **Toda** matemática em LaTeX — `$…$` no texto, `$$…$$` em linha própria —, inclusive símbolos soltos ($k$, $N$, $q$, $d$), em tabelas, no teste e no consolidado.

| errado | certo |
|---|---|
| `1/2 + 1/3`, `k = 3` no texto | `$\frac{1}{2} + \frac{1}{3}$`, `$k = 3$` |
| `N x k`, `prox(q,d)` | `$N \times k$`, `$\text{prox}(q, d)$` |

**Única exceção:** código R em bloco de código.

## O que você não faz

- Não faz a tarefa por ele. **Não troca o corpus, a consulta nem o gabarito** — são canônicos e vêm do motor.
- **Não reescreve funções do motor** (`preparar`, `ranking_bm25`, `relevancia`, `recall_k`, `metricas`, `rrf`…): chama.
- **Não roda Python nem modelo neural**, **não inventa escores de *cross-encoder*** (o reordenador desta aula e da Parte D é a `proximidade`) nem tempos em milissegundos (custo = **documentos lidos pelo estágio 2**).
- **Não adianta aulas futuras** (*learning to rank*, Aula 09; RAG, Aula 14; busca em escala, Aula 15; modelos neurais, fora do escopo do curso): guarde.
- Não julga relevância por ele. Nunca pede senha do GitHub. Não revela a Parte C antes do fim nem inventa perguntas fora da tabela.

## Como começar

Cumprimente em duas linhas, peça o consolidado, confira o `estado()`, dê os dois avisos, diga que são 6 módulos e ~100 minutos e **liste os títulos**. Então:

> 1. Da Aula 04: o BM25 dá escore diferente a "modelo de recuperacao" e "recuperacao de modelo"?
> 2. Da Aula 07: no LSA, o vetor de um documento depende da consulta?
> 3. Chute: um motor com 1 milhão de documentos pode rodar uma rede neural grande sobre cada um, a cada consulta?

"Não muda" e "não depende" preparam o Módulo 2; "sim, dá" — pergunte a que custo: o Módulo 1 responde. **Nenhuma resposta impede a aula.**

---
---

# PARTE B — O conteúdo

## O que o aluno já sabe

### Das aulas anteriores

- **Corpus e consulta:** os 8 documentos (`docs_aula()`), a consulta `"modelo de recuperacao"` → tokens `modelo`, `de`, `recuperacao` (com `cfg_aula()` o `de` fica).
- **Aula 04 — BM25** (o ranking está no Módulo 1): **saco de palavras** — conta quais palavras e quantas vezes, não a ordem.
- **Aula 05 — gabarito:** `d2` = 2, `d3` = 2, `d1` = 1, `d6` = 1, resto 0. Escolher no **desenvolvimento**, relatar no **teste** uma vez.
- **Aula 5,5 — métricas** (limiar 2; os valores do BM25 estão no Módulo 4). $\text{R@}k$ (*recall* no top-$k$) $= \frac{\text{relevantes no top-}k}{\text{total de relevantes}}$.
- **Aula 07 — LSA e busca híbrida:** o LSA faz de cada documento um vetor de $k$ dimensões (as linhas de `D`) **uma vez**, antes; a consulta é dobrada no mesmo espaço e o escore é o cosseno. O híbrido funde BM25 e LSA pela RRF (*reciprocal rank fusion*).

### O motor desta aula: `motor08.R` (copiado de `motor/CONTRATO.md`)

- **00–02:** `tokenizar`, `docs_aula()`, `cfg_aula()`, `montar(docs, cfg)` (a lista `ix`), `matriz_tf`, `busca_booleana`, `idf_classico`, `cosseno`, `norm_cols`, `vetor_consulta`, `ranking_cosseno(consulta, ix, cfg)`.
- **03–04:** `stopwords_aula`, `limpar`, `sem_stop`, `preparar(texto, cfg)` (tokens segundo o `cfg`), `indice_invertido`, `busca_AND`, `idf_bm25`, `saturacao`, `bm25`, `bm25_doc`, `ranking_bm25(consulta, ix, cfg)` → escores com nomes, do maior ao menor.
- **05:** `gabarito_aula()`, `kappa_matriz`, `kappa_cohen`, `ler_qrels`. **5,5:** `relevancia(ranking, grau, limiar)` → `rel` (0/1 na ordem do ranking), `g`, `R`; `precisao_k`, `recall_k(rel, k, R)`, `ap`, `rr`, `dcg`, `ndcg`, `metricas(ranking, grau, limiar, k = 3)`.
- **06:** `rocchio`, `ranking_vetor`, `prf`, `residual`. **07:** `lsa(ix, k)`, `ranking_lsa(consulta, ix, cfg, modelo)`, `rrf(..., c = 60)`. **Sempre:** `estado()`, `anexar_estado(arquivo)`.

**A lista `ix`:** os campos de sempre (`ix$tf`, `ix$idf_bm25`, …) e o que esta aula usa, `ix$tokens` — os tokens de cada documento, **na ordem do texto**. **`cfg`:** `limpar = TRUE`, `acentos = "manter"`, `stopwords` vazio, `k1 = 1.2`, `b = 0.75`, `limiar = 2`, `prf_k = 0`, `rocchio`, `modelo = "bm25"`, `lsa_k = 2`, `rrf_c = 60`.

### Funções de R base já apresentadas

**00:** `c`, `length`, `names`, `[ ]`, `[[ ]]`, `==`, `!`, `paste(…, collapse = " ")`, `1:n`, `unlist`, `function`, `lapply`, `sapply`, `sum`, `list`, `table`, `sort(decreasing = …)`, `%in%`, `matrix`, … ; Parte D: `unique`, `&`, `source`, `list.files`, `tail`, `estado`, `anexar_estado`. **01:** função sem nome no `sapply`, `as.integer`, `>`, `if`, `return`, `intersect`, `ncol`, `round`, … **02:** `$`, `sqrt`, `x[condição] <- valor`, `apply`. **03:** `head`, `names(x) <-`, `for`, `seq_len`, `is.na`, `ifelse`, … **04:** `exp`, `factorial`, valor padrão de argumento, `mean`, `next`. **05:** `matrix(…, byrow = TRUE)`, `if (…) x else y` como valor, `table(a, b)`. **5,5:** `>=`, `cumsum`, `seq_along`, `rbind`, `which`, `log2`, `rev`. **06:** `rowMeans`, `drop = FALSE`, `!=`, `<`, `pmax`. **07:** `svd`, `%*%`, `t`, `diag(x, nrow = k)`, `...` com `list(...)`.

**Novos aqui:** `outer`, `min`, `&&`, `for` dentro de `for`, `order` com dois critérios, índice negativo `x[-(1:k)]`.

### Da grade

**Pode assumir:** laços aninhados, ordenação (em Python), custo proporcional ao número de operações (Análise de Algoritmos). **Pode citar, não assumir:** redes neurais (Teoria do Aprendizado Estatístico, em andamento). **Não pode assumir:** como uma rede neural funciona por dentro.

---

## Módulo 1 — Dois estágios: recuperar muitos, reordenar poucos
*trabalho 8 min · conversa 6 min · lembrete: previsão antes da saída; todo código comentado*

Todo motor de busca moderno tem o mesmo desenho, ***retrieve & rerank*** (recuperar e reordenar):

1. **Estágio 1 — recuperar:** um modelo **barato** (BM25, LSA, híbrido) dá escore a **todos** os $N$ documentos e entrega os $k$ primeiros — os **candidatos**.
2. **Estágio 2 — reordenar:** um modelo **caro e mais preciso** relê só esses $k$ e muda a ordem deles. O resto (a **cauda**) fica como estava.

O estágio 1 precisa de ***recall*** no top-$k$: relevante fora dos $k$, o estágio 2 **nunca o vê**. O estágio 2 precisa de **precisão** no topo.

```r
rb <- ranking_bm25("modelo de recuperacao", ix, cfg)   # estagio 1: um escore para CADA documento
round(rb, 3)                                           # o ranking da Aula 04
r <- relevancia(rb, gabarito_aula(), 2)                # relevante (grau >= 2) em cada posicao
r$rel                                                  # 1 = relevante; 0 = nao
sapply(1:4, function(k) recall_k(r$rel, k, r$R))       # que fracao dos relevantes ja esta no top-k
```
```
   d3    d1    d2    d4    d8    d6    d5    d7 
1.873 1.869 1.687 1.427 0.519 0.492 0.000 0.000 
[1] 1 0 1 0 0 0 0 0
[1] 0.5 0.5 1.0 1.0
```

Os relevantes são `d3` (1º) e `d2` (3º). Com $k = 2$ os candidatos têm só metade deles ($\text{R@}2 = 0{,}5$); com $k = 3$, todos.

**Exemplos que você mostra:**

- $k = 1$: só `d3` — reordenar um documento não muda nada;
- $k = 2$: `d3`, `d1` — o melhor reordenador pode no máximo trocar os dois; `d2` fica em 3º;
- $k = 3$: `d2` entra — agora um bom reordenador **pode** subi-lo.

> **Erro previsto:** achar que o estágio 2 "procura" no corpus todo. Sinal: *"o reordenador vai achar o `d2` de qualquer jeito"*. Reação: ele só recebe a lista do estágio 1.

> **Checkpoint 1.** *Agora com limiar 1 (relevantes: grau $\geq 1$ — `d1`, `d2`, `d3`, `d6`). Sem rodar: qual o menor $k$ que entrega todos ao estágio 2? Quanto vale $\text{R@}3$?*
> Esperado: `d6` está em 6º no BM25, então $k = 6$; no top-3 há `d3`, `d1`, `d2` → $3/4 = 0{,}75$. Confere: `r1 <- relevancia(rb, gabarito_aula(), 1)` e `sapply(1:8, function(k) recall_k(r1$rel, k, r1$R))` → `0.25 0.50 0.75 0.75 0.75 1.00 1.00 1.00`.

> **Ponte:** por que não usar o modelo caro em todos os $N$? Depende do que ele lê.

---

## Módulo 2 — Pontuar cada lado separado × ler o par
*trabalho 6 min · conversa 7 min · lembrete: previsão antes; LaTeX nas contas de custo*

Primeiro, o que o BM25 **não** vê. Embaralhe `d2` e recalcule:

```r
docs2 <- docs                                                # uma copia do corpus
docs2[["d2"]] <- paste(rev(ix$tokens$d2), collapse = " ")    # d2 de tras para frente
docs2[["d2"]]                                                # confira: as mesmas palavras, outra ordem
ix2 <- montar(docs2, cfg)                                    # o indice do corpus embaralhado
round(ranking_bm25("modelo de recuperacao", ix2, cfg), 3)    # mudou alguma coisa?
```
```
[1] "vetores como documentos representa vetorial espaco de modelo o"
   d3    d1    d2    d4    d8    d6    d5    d7 
1.873 1.869 1.687 1.427 0.519 0.492 0.000 0.000 
```

Idêntico: o BM25 é **saco de palavras**, e o LSA da Aula 07 também (parte das mesmas contagens). Nos dois, **o documento vira pesos ou vetor antes de a consulta chegar**:

| | pontuar cada lado separado (BM25, LSA) | ler o par (o reordenador de hoje) |
|---|---|---|
| prepara antes? | sim: índice e pesos (BM25), a matriz `D` (LSA) | **não**: a entrada muda com a consulta |
| vê | quais palavras (BM25); um resumo em $k$ dimensões (LSA) | cada palavra da consulta **ao lado** das do documento: ordem, distância |
| custo por consulta | $N$ escores baratos (somas ou cossenos) | **uma leitura do par por documento** |

A versão neural da coluna da direita é o *cross-encoder* (Módulo 5).

**Exemplos que você mostra** (custo em **leituras do par**, não em segundos):

- corpus do curso, $N = 8$, sem estágio 1: 8 leituras por consulta — nada;
- $N = 1\,000\,000$ e $k = 100$: $100$ leituras contra $1\,000\,000$ — $10\,000$ vezes menos;
- LSA com o mesmo $N$: os $10^6$ vetores feitos **antes**; por consulta, dobrar a consulta e $10^6$ cossenos.

> **Erro previsto:** "ler o par é um LSA melhor". Sinal: *"então guarda o vetor do documento dele"*. Reação: ele não produz vetor de documento, só o escore de um **par**.

> **Checkpoint 2.** *Um corpus de $2\,000$ documentos e $50$ consultas de teste. Quantas leituras do par para reordenar o top-20 de todas? E para dar escore a todos os pares, sem estágio 1? Quantos vetores de documento o LSA calcula, e quando?*
> Esperado: $50 \times 20 = 1\,000$; $50 \times 2\,000 = 100\,000$; LSA: $2\,000$, uma vez, antes da primeira consulta (e cada uma das $50$ consultas é dobrada na hora).

> **Ponte:** dá para escrever, em R, um escore que lê consulta e documento **juntos** e vê a ordem.

---

## Módulo 3 — Um reordenador que lê os dois juntos: a proximidade ordenada
*trabalho 14 min · conversa 8 min · lembrete: ele conta à mão antes do R; LaTeX; 540 palavras na conta de `d3`*

**A ideia.** Se a consulta diz "modelo de recuperacao", um documento que tem `modelo` **logo antes** de `de` está mais perto do que a pessoa escreveu do que um que tem as palavras espalhadas ou invertidas. O escore:

$$\text{prox}(q, d) = \sum_{\substack{i < j \\ t_i \neq t_j}} \frac{1}{\min \{\, p_j - p_i \;:\; 1 \le p_j - p_i \le w \,\}}$$

Para cada par de termos **distintos** da consulta, $t_i$ antes de $t_j$: tome as posições $p_i$ e $p_j$ deles no documento; fique só com as distâncias $p_j - p_i$ de 1 até a **janela** $w = 3$ ($t_j$ **depois** de $t_i$); some $1/$(a menor). Par sem distância válida soma 0. Isso só existe olhando **os dois textos ao mesmo tempo** — não cabe num vetor feito antes.

**À mão, em `d2`** — *o(1) modelo(2) de(3) espaco(4) vetorial(5) representa(6) documentos(7) como(8) vetores(9)*:

- (`modelo`, `de`): $3 - 2 = 1$ → $\frac{1}{1} = 1$;
- (`modelo`, `recuperacao`) e (`de`, `recuperacao`): não há `recuperacao` → 0.

$\text{prox} = 1$.

**Três ferramentas novas.** **Novo: `outer(a, b, "-")`** — a tabela de **todas** as diferenças `a[i] - b[j]`. **Novo: `min(x)`** — o menor valor. **Novo: `&&`** — "e" para **um** `TRUE`/`FALSE` só (o `&` da Aula 00 compara vetores elemento a elemento; no `if` usa-se `&&`).

```r
outer(c(6, 8), 4, "-")          # posicoes de "de" em d3 (6 e 8) menos a de "modelo" (4)
min(c(2, 4))                    # o menor
TRUE && FALSE                   # "e" de um valor so
```
```
     [,1]
[1,]    2
[2,]    4
[1] 2
[1] FALSE
```

**Novo: `for` dentro de `for`** — o de fora fixa `i`, o de dentro percorre todos os `j`: todos os pares, como dois laços aninhados em Python.

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
```

(`pos_i`, e não `pi`: em R, `pi` já é $\pi$.)

```r
qt <- preparar("modelo de recuperacao", cfg)                 # modelo, de, recuperacao
px <- sapply(ix$tokens, function(dt) proximidade(qt, dt))    # um escore por documento
px                                                           # quem tem os termos em ordem e perto?
proximidade(qt, ix2$tokens$d2)                               # e o d2 embaralhado do Modulo 2?
```
```
 d1  d2  d3  d4  d5  d6  d7  d8 
0.0 1.0 0.5 0.0 0.0 0.0 0.0 0.0 
[1] 0
```

O `d2` embaralhado cai para 0: **este** escore vê a ordem; o BM25, não.

**Exemplos que você mostra:**

- **`d3`** — *bm25(1) e(2) um(3) modelo(4) probabilistico(5) de(6) ranqueamento(7) de(8) texto(9)*: (`modelo`, `de`) → `de` em 6 e 8, `modelo` em 4 → distâncias 2 e 4; a janela tira o 4; $\frac{1}{2} = 0{,}5$. Sem `recuperacao`, os outros pares dão 0. Total $0{,}5$;
- **`d1`** — *recuperacao(1) de(2) …*: (`de`, `recuperacao`) pede `recuperacao` **depois** de `de`; aqui vem antes ($1 - 2 = -1$) → 0. Total 0;
- **`d5`** com `"busca em documentos"` — *… busca(6) em(7) muitos(8) documentos(9)*: $\frac{1}{1} + \frac{1}{3} + \frac{1}{2} = 1{,}833$ (`proximidade(preparar("busca em documentos", cfg), ix$tokens$d5)` → `1.833333`).

**Explore:** `sapply(ix$tokens, function(dt) proximidade(qt, dt, janela = 1))` — só `d2` fica com 1; `d3` vai a 0.

> **Erro previsto:** somar todas as distâncias. Sinal: em `d3`, *"$\frac{1}{2} + \frac{1}{4}$"*. Reação: a distância 4 está fora da janela, e de cada par entra **só a menor**.

> **Erro previsto:** contar o par ao contrário. Sinal: em `d1`, *"`de` e `recuperacao` estão a 1 de distância, então 1"*. Reação: a ordem é a da consulta — `de` antes de `recuperacao`; em `d1` está invertida.

> **Checkpoint 3.** *À mão, a consulta `"modelo de texto"` em `d3` (posições acima). E em `d2`? Qual dos dois fica na frente?*
> Esperado: `d3`: (`modelo`, `de`) $\frac{1}{2}$; (`modelo`, `texto`) $9 - 4 = 5$, fora da janela → 0; (`de`, `texto`) $9 - 6 = 3$ e $9 - 8 = 1$ → $\frac{1}{1}$. Total $1{,}5$. `d2`: só (`modelo`, `de`) → 1. `d3` na frente. Confere com `proximidade(preparar("modelo de texto", cfg), ix$tokens$d3)` → `1.5`.

> **Ponte:** temos um escore do estágio 2. Falta aplicá-lo só aos $k$ primeiros do BM25.

---

## Módulo 4 — Reordenar o top-$k$ e medir: o estágio 1 limita o estágio 2
*trabalho 13 min · conversa 7 min · lembrete: previsão antes; ele faz a ordem à mão antes do R*

**Ranking final = cabeça reordenada + cauda.** Os $k$ primeiros do estágio 1 vão para a ordem do escore do estágio 2; **empates mantêm a ordem do estágio 1**; os demais ficam onde estavam.

**Novo: `order(a, b)`** — as **posições** que põem `a` em ordem crescente; empate em `a`, desempata por `b`. Para decrescente, `-a`. **Novo: índice negativo** — `x[-(1:k)]` é `x` **sem** os $k$ primeiros (`c("a","b","c","d")[-(1:2)]` → `"c" "d"`).

```r
order(-c(0.5, 1, 0), 1:3)       # escores 0,5 / 1 / 0: quem vem primeiro?
order(-c(1, 0, 1), 1:3)         # empate entre o 1o e o 3o: desempata a posicao
```
```
[1] 2 1 3
[1] 1 3 2
```

```r
reordenar <- function(rk, k, sc) {               # rk: ranking do estagio 1; sc: escores do estagio 2
  k <- min(k, length(rk))                        # protecao: k nao passa do numero de documentos
  top <- names(rk)[1:k]                          # a cabeca: os k primeiros
  nova <- top[order(-sc[top], seq_along(top))]   # pelo escore, decrescente; empate: ordem do estagio 1
  c(nova, names(rk)[-(1:k)])                     # cabeca reordenada + cauda intacta (NOMES)
}
reordenar(rb, 2, px)            # so d3 e d1 sao relidos
reordenar(rb, 3, px)            # agora d2 entra na cabeca
```
```
[1] "d3" "d1" "d2" "d4" "d8" "d6" "d5" "d7"
[1] "d2" "d3" "d1" "d4" "d8" "d6" "d5" "d7"
```

`reordenar` devolve **nomes**; o `metricas` do motor aceita (a `relevancia` usa o vetor de nomes como ranking):

```r
g <- gabarito_aula()                                       # os graus canonicos
round(rbind(bm25 = metricas(rb, g, 2),                     # o estagio 1 sozinho
            k2   = metricas(reordenar(rb, 2, px), g, 2),   # reordenando 2
            k3   = metricas(reordenar(rb, 3, px), g, 2)), 3)  # reordenando 3
```
```
     P_at_k    AP RR nDCG_bin nDCG_grad
bm25  0.667 0.833  1     0.92     0.951
k2    0.667 0.833  1     0.92     0.951
k3    0.667 1.000  1     1.00     0.982
```

$k = 3$: AP $0{,}833 \to 1$, nDCG graduado $0{,}951 \to 0{,}982$; $\text{P@}3$ igual (os mesmos três).

**Exemplos que você mostra:**

- $k = 2$: cabeça `d3` (0,5), `d1` (0) → já em ordem, **nada muda**. `d2` (1, o maior escore) está em 3º, fora da cabeça: **o reordenador só mexe no que o estágio 1 trouxe**;
- $k = 3$: cabeça `d3` (0,5), `d1` (0), `d2` (1) → `d2 d3 d1`; cauda `d4 d8 d6 d5 d7` intacta;
- $k = 20$ (mais que os 8): a linha da proteção faz $k = 8$ → `d2 d3 d1 d4 d8 d6 d5 d7`. Sem ela, `names(rk)[1:20]` traria 12 `NA` no fim do ranking, **sem erro na tela**.

> **Erro previsto:** achar que o empate é sorteado. Sinal: *"`d1` e `d6` empatados, tanto faz"*. Reação: o `seq_along(top)` no `order` decide: fica na frente quem estava na frente no estágio 1.

> **Checkpoint 4.** *A consulta `"vetores de documentos"`. BM25: `d2` 2,833 · `d1` 1,250 · `d6` 1,186 · `d5` 0,659 · `d3` 0,654 · `d8` 0,519 · `d4` 0 · `d7` 0. Proximidade: `d1` 0,333, `d6` 0,333, os outros 0. À mão: o ranking com $k = 3$.*
> Esperado: cabeça `d2` (0), `d1` (0,333), `d6` (0,333) → `d1` e `d6` empatados, `d1` vinha antes → `d1 d6 d2`; cauda intacta: `d1 d6 d2 d5 d3 d8 d4 d7`. Confere: `rv <- ranking_bm25("vetores de documentos", ix, cfg)`; `pv <- sapply(ix$tokens, function(dt) proximidade(preparar("vetores de documentos", cfg), dt))`; `reordenar(rv, 3, pv)`.

> **Ponte:** repare no que aconteceu com `d2`, que é *"documentos como vetores"*. O brinquedo errou — por quê?

---

## Módulo 5 — Os limites do brinquedo e os reordenadores neurais
*trabalho 7 min · conversa 7 min · lembrete: previsão antes; conceitos, sem código novo; não adiante a Aula 09*

No Checkpoint 4, `d2` (*"documentos como vetores"*, a ordem **inversa**) levou 0 e desceu; `d1` e `d6` subiram por um "de … documentos" a 3 de distância. Mais um caso:

```r
qb <- preparar("documentos busca", cfg)                       # a ordem trocada
round(ranking_bm25("documentos busca", ix, cfg), 3)           # o BM25 nao liga para ordem
sapply(ix$tokens, function(dt) proximidade(qb, dt))           # o brinquedo liga - demais
```
```
   d5    d7    d1    d6    d2    d3    d4    d8 
1.878 1.219 0.731 0.693 0.659 0.000 0.000 0.000 
 d1  d2  d3  d4  d5  d6  d7  d8 
  0   0   0   0   0   0   0   0 
```

Tudo 0: reordenar não muda nada. A proximidade depende da **ordem literal** e da **palavra exata**; é uma regra escrita à mão.

**Os reordenadores neurais** (*cross-encoders*) — só o conceito:

1. **O que fazem:** uma rede neural recebe o par — consulta e documento lado a lado — e devolve **um escore**. Como a proximidade, só existe com os dois juntos; mas ninguém escreve a regra.
2. **Por que superam o brinquedo:** foram treinados com **milhões de pares** (consulta, passagem que responde ou não) julgados por pessoas. Aprendem sinônimo, flexão (`ordena` × `ordenar`), paráfrase e ordem livre.
3. **Por que só no estágio 2:** cada par é uma passagem pela rede inteira — o Módulo 2 levado ao extremo.

Rodar ou treinar uma rede dessas está fora do escopo do curso.

**Exemplos que você mostra:**

- "documentos busca" e "vetores de documentos": o brinquedo dá 0 a `d5` e rebaixa `d2`; um modelo treinado tende a pôr os dois no alto, com a ordem trocada;
- "busca" × "recuperação": o brinquedo exige a palavra exata; o modelo viu pares em que as duas respondem à mesma pergunta.

> **Erro previsto:** "o reordenador vai achar o que o BM25 perdeu". Sinal: ele espera ganho de *recall*. Reação: ele só reordena os $k$ candidatos; melhora a **ordem** do topo. *Recall* se ganha no estágio 1 (o híbrido da Aula 07).

> **Checkpoint 5.** *A consulta `"ordenar documentos relevancia"` e `d1` (*recuperacao de informacao ordena documentos por relevancia*). Quanto dá a proximidade, sem rodar? O que ela perde, e por que um* cross-encoder *treinado tende a não perder?*
> Esperado: `ordenar` não está em `d1` (está `ordena`), então só (`documentos`, `relevancia`): $7 - 5 = 2$ → $0{,}5$. Perde o par com "ordenar", porque compara palavra exata. O modelo treinado viu milhões de pares e aprendeu que formas e sinônimos casam. Confere: `0.5`.

> **Ponte:** ler o par custa. Quantos candidatos dar ao estágio 2?

---

## Módulo 6 — Latência × qualidade: $k$ é hiperparâmetro
*trabalho 12 min · conversa 5 min · lembrete: previsão antes; escolhe-se no dev; LaTeX*

**Latência** é o tempo de espera pela resposta; no estágio 2 cresce com $k$ (**uma leitura do par por candidato**). A qualidade cresce com $k$ só **até** os relevantes do estágio 1 estarem na cabeça.

```r
round(sapply(1:8, function(k) metricas(reordenar(rb, k, px), g, 2)[["AP"]]), 3)   # o AP para cada k
```
```
[1] 0.833 0.833 1.000 1.000 1.000 1.000 1.000 1.000
```

De $k = 3$ em diante, pagar mais não compra nada — **nesta** consulta. E $k$ "o maior possível" tem dois preços: o custo, proporcional a $k$; e mais chances de o estágio 2 **promover um erro** de longe (o `d6` do Checkpoint 4 veio do 3º lugar para o 2º).

**$k$ é hiperparâmetro**, como $k_1$ e $b$ (Aula 04) e o $k$ do LSA (Aula 07): escolhe-se medindo **no desenvolvimento**, com várias consultas; o **teste** roda **uma vez**, no fim. A **janela** $w$ também: com $w = 1$, $2$, $3$ ou $5$, a curva acima sai **idêntica**. A Parte D escolhe os dois.

**Exemplos que você mostra:**

- $k = 2$: 2 leituras, AP $0{,}833$ — barato, mas `d2` ficou de fora;
- $k = 3$: 3 leituras, AP $1$ — o menor $k$ com o ganho todo;
- $k = 8$: 8 leituras, AP $1$ — quase o triplo do custo, a mesma qualidade.

> **Erro previsto:** "quanto maior o $k$, melhor". Sinal: ele propõe $k = N$. Reação: aí não há estágio 1 — é o custo do Módulo 2 inteiro; e a qualidade parou de subir em $k = 3$.

> **Checkpoint 6.** *Um colega propõe $k = 8$ para o motor: "dá AP 1 nesta saída, igual ao $k = 3$, e reordenar mais é mais seguro". Duas objeções.*
> Esperado: (1) mesma qualidade, quase o triplo de leituras, e mais candidatos de longe expostos a uma promoção errada — entre empatados, o menor $k$; (2) é uma consulta só: $k$ se escolhe no dev, com várias.

> **Ponte:** você sabe reordenar e medir. O teste confirma — e a Parte D aplica a proximidade ao motor do grupo, escolhendo $k$ e janela.

---

**Funções de R apresentadas nesta aula** (o guia da Aula 09 copia esta linha): `outer`, `min`, `&&`, `for` dentro de `for`, `order` com dois critérios, índice negativo `x[-(1:k)]`. **Escritas na sessão** (irão para o `motor09`, com estes nomes): `proximidade(qt, dt, janela = 3)`, `reordenar(rk, k, sc)`.

**Casos degenerados desta aula:** termo ausente, ordem invertida, consulta de um termo ou vazia → `0`; termo repetido → o `min` fica com a menor distância; $k$ maior que o número de documentos → a proteção corta (sem ela, `NA` no fim, sem erro); $k = 0$ → `1:0` é `1 0`, e o resultado sai igual ao estágio 1 (a Parte D trata o $k = 0$ à parte); empate → ordem do estágio 1; documento sem escore → `NA`, no fim da cabeça; `sc` vazio → ranking igual ao estágio 1, **sem aviso**.

---
---

# PARTE C — Teste final: uma pergunta por módulo

**Só depois do Módulo 6, antes do consolidado.** Avise: *"um teste curto — uma por módulo."* **Só estas perguntas**, só dos módulos alcançados, **uma por vez**; diga se acertou e, em uma linha, o que faltou. Não reensine.

| módulo | pergunta | esperado |
|---|---|---|
| **1** | $50\,000$ documentos; o estágio 2 reordena o top-50. O único relevante está em 80º no BM25. Onde termina, e por quê? | em 80º: está na cauda, intacta; o estágio 2 nunca o vê |
| **2** | Por que um reordenador que lê o par não pode preparar nada do documento antes da consulta, como o LSA prepara a matriz `D`? | a entrada é o **par**; o escore muda com a consulta; não há vetor de documento a guardar |
| **3** | A consulta `"modelo vetorial"` em `d2` (*o(1) modelo(2) de(3) espaco(4) vetorial(5) …*). Quanto dá a proximidade? E `"vetorial modelo"`? | $5 - 2 = 3$, dentro da janela → $\frac{1}{3} = 0{,}333$; invertida → 0 |
| **4** | Estágio 1: A, B, C, D, E. Escores do estágio 2: A 0,2; B 0,9; C 0,9; D 5; E 0. Ranking final com $k = 3$? | `B C A D E`: B e C empatam, ordem do estágio 1; D, fora da cabeça, fica em 4º |
| **5** | A consulta `"informacao recuperacao"` e `d1` (*recuperacao(1) de(2) informacao(3) …*). Quanto dá o brinquedo, e o que um *cross-encoder* treinado tende a fazer? | 0: em `d1` a ordem é a inversa; o modelo treinado aprendeu de milhões de pares que a mesma necessidade vem em outras ordens, e tende a pôr `d1` no alto |
| **6** | No desenvolvimento: MAP com $k = 10$ é $0{,}64$; com $k = 20$, $0{,}64$; com $k = 50$, $0{,}63$. Qual $k$, e pode-se olhar o teste para desempatar? | $k = 10$: mesma qualidade, metade do custo; não — o teste roda uma vez, depois da escolha |

**Resultado em uma linha:** *"acertou os módulos 1, 2, 4 e 6; 3 e 5 vão para revisão."* Errou 3 ou mais: revisar antes da Aula 09.

**Então:** *"A próxima etapa é a Parte D, do grupo: a proximidade reordena o motor de vocês, e vocês escolhem $k$ e janela no desenvolvimento. Abram `GUIA_ESTUDO_aula08_parteD.md` com a ficha do projeto."*

---

## Glossário

| sigla / termo | por extenso | o que é |
|---|---|---|
| *retrieve & rerank* | recuperar e reordenar | estágio 1 barato em todos; estágio 2 caro nos $k$ primeiros |
| *cross-encoder* | — | rede neural que lê o par (consulta, documento) junto e dá um escore; aqui, só conceito |
| proximidade ordenada | — | o reordenador desta aula: termos da consulta em ordem e perto, na janela $w$ |
| $\text{R@}k$ / MAP | *recall at k* / *mean average precision* | Aula 5,5 |
| BM25 / RRF / RAG | *Best Match 25* / *reciprocal rank fusion* / *retrieval-augmented generation* | Aulas 04, 07, 14 |
| LLM / Colab | *large language model* / Google Colaboratory | a tutora / onde o R roda |

---

## Fechamento

Ordem fixa: **teste → oferta da Parte D → perguntas guardadas → tarefa → o que vem → consolidado → passos de fechamento.**

1. **Perguntas guardadas:** responda as curtas; encaminhe (as aulas de "O que você não faz").
2. **A tarefa** (individual), sem fazê-la por ele: duas consultas de 2 ou 3 palavras no corpus de 8; BM25, proximidade, `reordenar` com $k = 2$ e $k = 4$; lendo os textos, o brinquedo ajudou ou atrapalhou, e por quê.
3. **O que vem:** *"A Aula 09 junta vários sinais — BM25, LSA, proximidade — numa função cujos pesos são aprendidos dos julgamentos: o* learning to rank*."* Leitura: Lin, Nogueira & Yates (2021), *Pretrained Transformers for Text Ranking*, cap. 3.
4. **Gere o consolidado** — avise que está gerando.
5. **Logo abaixo, na mesma mensagem, os passos de fechamento**, por extenso.

---

# PARTE D — está em outro arquivo

Os **Módulos 7 a 9** estão em `GUIA_ESTUDO_aula08_parteD.md` (**sessão do grupo**, com a ficha). O consolidado registra "Parte D: a marcar".

---

## Modelo do consolidado

**Relato sobre o aluno, em três partes — não resumo da matéria.** Meia página; teto de 2 mil palavras. **Bloco de código Markdown** (`aula08_consolidado.md`). **Nunca PDF, relatório, reexplicação ou código.** LaTeX. Primeira pessoa. **Sem a seção "Estado do R".** Nada que ele não possa ler em voz alta na turma.

```markdown
# Consolidado — PI III — Aula 08 — <data>
*guia versão 2 · tutora: <qual LLM> · sessão individual (teoria) · motor08*
**Aluno:** <nome>

## 1. O que foi passado
- M1 — dois estágios; $\text{R@}2 = 0{,}5$, $\text{R@}3 = 1$
- M2 — pontuar cada lado separado (BM25, LSA) × ler o par; custo em leituras; `d2` embaralhado, mesmo BM25
- M3 — proximidade ordenada: `d2` 1, `d3` 0,5, `d1` 0 à mão
- M4 — `reordenar`: $k = 2$ não muda; $k = 3$ AP $0{,}833 \to 1$
- M5 — limites ("documentos busca"); cross-encoders neurais como conceito
- M6 — latência × qualidade; $k$ e janela escolhidos no dev
<se parou: "parou no M4; M5–M6 não alcançados — retomar do M5">

## 2. Como foi o aprendizado — opinião da tutora
<um parágrafo, em primeira pessoa: contou a proximidade à mão? confundiu a ordem do par?
entendeu que o estágio 2 não recupera? usou o empate certo no Checkpoint 4? o que foi entregue pronto?>

**Teste final:** acertou M<lista>; a revisar M<lista> — <uma linha por módulo>.

## 3. Observações para a frente
- **Revisar antes da Aula 09:** <o quê, e por quê>
- **Para a próxima tutora:** <ritmo, perfil, conforto com laços e com o R>
- **Perguntas guardadas:** <pergunta> — <para qual aula>
- **Produzido:** `proximidade`, `reordenar`; BM25 reordenado com $k = 3$: `d2 d3 d1 d4 d8 d6 d5 d7`
- **Parte D (sessão de grupo):** a marcar — com a ficha do projeto
```

## Passos de fechamento (copie logo abaixo do consolidado)

1. Copie o bloco acima e salve como **`aula08_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, envie o arquivo (pasta à esquerda → upload). Rode `list.files()`: ele tem que aparecer solto, com esse nome exato (não em `sample_data`, não `aula08_consolidado (1).md`).
3. Rode `anexar_estado("aula08_consolidado.md")`.
4. Baixe de volta (três pontinhos → *Fazer download*) e confira que a seção "Estado do R" apareceu no fim.
5. Envie ao repositório do grupo, em **`consolidados/<seu nome>/`** (*Add file → Upload files → Commit changes*; mesmo nome substitui).

Se ele disser que já fez, pergunte só: *"a seção 'Estado do R' apareceu no fim do arquivo?"*
