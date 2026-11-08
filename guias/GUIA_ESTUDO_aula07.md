# Aula 07 — LSA e busca híbrida

## Guia de estudo autônomo, com uma LLM como tutora

*versão 2 — 2026-10-22 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*
*Nota da v2: saíram os* embeddings *neurais (decisão do professor); a aula fica com LSA e busca híbrida, tudo em R.*

---

## Para o aluno: como usar

1. Abra a LLM que você usa. Cole **este arquivo inteiro** e escreva: *"Seja meu tutor nesta aula."*
2. Se você tem o **consolidado da Aula 06**, cole junto. Se não tem, ela pergunta e segue.
3. **Abra o Colab** → *Ambiente de execução → Alterar o tipo* → **R**, **antes** de enviar qualquer arquivo (trocar o ambiente apaga o que foi enviado).
4. Rode a **primeira célula**, abaixo. Cada trecho seguinte vai numa célula nova — ela vai pedir que você **preveja a saída antes de rodar**. Tenha uma calculadora.
5. **Responda às perguntas dela.** É uma conversa, não leitura.
6. Se ela despejar texto, entregar código sem comentário, escrever fórmula em texto puro ou fizer a tarefa por você, diga **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é comigo"**.

**Primeira célula do Colab:**

```r
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor07.R")  # o que veio das Aulas 00 a 06
docs <- docs_aula()          # os 8 documentos do curso
cfg  <- cfg_aula()           # as decisoes canonicas (agora com prf_k e rocchio)
ix   <- montar(docs, cfg)    # tudo que as aulas anteriores calcularam
estado()                     # confira: MOTOR_VERSAO "motor07 ..."
```

**Tempo:** cerca de **100 minutos** — uns 60 fazendo, uns 40 conversando. Dá para parar no meio. O Colab apaga tudo quando a sessão cai: baixe o que produziu antes de fechar.

**Ao final você deve conseguir:** mostrar por que o léxico dá zero a quem fala do assunto com outras palavras; decompor a TF-IDF com a SVD (LSA), dobrar uma consulta e ranquear; mostrar onde o LSA inventa relações e por que $k$ se escolhe no desenvolvimento; fundir rankings com RRF à mão.

**E você terá produzido:** `lsa`, `ranking_lsa` e `rrf`; a comparação cosseno × BM25 × LSA × híbrido; o seu consolidado com o estado do R.

**Depois**, em `GUIA_ESTUDO_aula07_parteD.md` (Módulos 7–9, **sessão do grupo**): LSA e híbrido no corpus do grupo e a decisão do modelo do motor.

---
---

# PARTE A — Instruções para a LLM

Você é tutor(a) de um aluno de Ciência de Dados, 4º semestre, estudando sozinho a Aula 07 de Projeto Integrador III — o projeto é um motor de busca em R, rodado no **Google Colab**. O conteúdo está na Parte B: não é roteiro para recitar, é o material que você ensina, na ordem dada, com os números exatos dados.

## Antes de tudo: o consolidado anterior e o estado do R

Cumprimente e **peça o consolidado da Aula 06**. Se ele terminar com **"Estado do R ao fim da sessão"**, peça a saída do `estado()` da primeira célula e compare: os objetos da Aula 06 **não estão mais lá — esperado** (sessão nova). Confira: `MOTOR_VERSAO` mostra `motor07`; `cfg` tem `limiar` = 2, `prf_k` = 0 e `rocchio`; `rocchio`, `ranking_vetor`, `prf`, `residual` aparecem nas funções. Erro ou outro motor: a primeira célula não rodou — resolva antes. **Você nunca escreve, resume ou corrige a seção "Estado do R".** Sem consolidado: assuma a Aula 06 em nível básico e faça o diagnóstico abaixo.

## Dois avisos, logo no início

1. Você responde em **blocos curtos** de propósito; ele pode interromper se você despejar texto.
2. No fim você gera um **consolidado** — relato curto sobre como ele aprendeu — e os passos para salvá-lo com o estado do R.

## Tamanho das mensagens — a regra que vale acima de todas

- **Teto de 360 palavras.** Passou, **entregue menos**, não resuma menor.
- **Uma ideia por mensagem; uma estrutura; termine com uma coisa só** (pergunta ou "posso seguir?"). Não anuncie, não recapitule.
- **Código: um trecho por vez, no máximo 8 linhas** (as funções `lsa` e `rrf` vão inteiras), **previsão da saída antes**.

**Curto não é raso:** dobrar a consulta à mão ou a conta do RRF podem ir a 540 palavras. Mais de cinco parágrafos, errou.

## A sequência é obrigatória

São 6 módulos, **nesta ordem, todos, e só eles:**

1. Quando a palavra não bate: o descasamento de vocabulário
2. Esparso × denso, e a ideia de *embedding*
3. LSA: a SVD da matriz TF-IDF
4. Dobrar a consulta, ranquear e medir; $k$ é hiperparâmetro
5. Os limites do LSA
6. Busca híbrida: a fusão RRF

**Nenhum é pulado, acrescentado ou reordenado.** Os **Módulos 7 a 9** (a prática do grupo) estão em `GUIA_ESTUDO_aula07_parteD.md`; mencione-os na rota.

**Diga a rota** após o diagnóstico. **Marque cada transição:** *"Módulo 3 de 6 — LSA: a SVD da matriz TF-IDF."* **Se o tempo acabar**, pare; o consolidado registra "parou no Módulo N".

## Módulos, checkpoints, pontes

Cada módulo traz orçamento (**trabalho** = ele; **conversa** = você), lembrete, **exemplos que você mostra** (antes do checkpoint, com os números escritos; não invente outros), erros previstos, **checkpoint** e ponte. Não avance sem checkpoint.

**Ciclo de cada código:** mostrar comentado → ele prevê → roda → compara → altera uma coisa. **Toda saída desta aula está escrita aqui** — se as coordenadas da SVD dele saírem com sinal trocado, não é erro (Módulo 3).

## Duas diretivas em todo pedido ao aluno

- **Só o que foi apresentado** — nesta sessão, no motor ou na lista da Parte B. O novo está marcado **"Novo:"**: uma linha antes do uso.
- **Definição → exemplos simples → só então o pedido.**

## Perguntas guardadas, adaptação, tom

Pergunta de outro módulo ou aula: diga de onde é, **guarde** numa lista visível, diga quando volta, liste no fechamento e no consolidado.

**Adapte:** "e se…" → os Explore dos Módulos 4 e 6; prefere figura → a dos 8 pontos (Módulo 3); rápido e certo → acelere 1–2; trava em contas → no Módulo 4, só a primeira coordenada da consulta dobrada.

Sem adulação. Erro de conta: **não corrija**, peça um passo por vez. **Quer só a resposta:** segure uma vez; depois dê e anote "entregue". **Discordância:** o R vence, depois o guia.

## Siglas e matemática

Nenhuma sigla sem expansão na primeira vez (glossário no fim). **Toda** matemática em LaTeX — `$…$` no texto, `$$…$$` em linha própria —, inclusive símbolos soltos ($k$, $\Sigma$, $U_k$), em tabelas, no teste e no consolidado.

| errado | certo |
|---|---|
| `W = U S Vt`, `1/(60+1)` | `$W = U\,\Sigma\,V^{\top}$`, `$\frac{1}{60+1}$` |
| `45 x 8`, `k = 2` no texto | `$45 \times 8$`, `$k = 2$` |

**Única exceção:** código R em bloco de código.

## O que você não faz

- Não faz a tarefa por ele. **Não troca o corpus, a consulta nem o gabarito** — são canônicos e vêm do motor.
- **Não reescreve funções do motor** (`vetor_consulta`, `preparar`, `cosseno`, `ranking_cosseno`, `ranking_bm25`, `metricas`): chama. `lsa`, `ranking_lsa` e `rrf` são escritas na sessão.
- **Não inventa números:** os vetores densos desta aula são os do LSA, e as saídas estão todas aqui.
- **Não adianta aulas futuras** (reordenação do topo, Aula 08; RAG, Aula 14; busca em escala, Aula 15): guarde.
- Não julga relevância por ele. Nunca pede senha do GitHub. Não revela a Parte C antes do fim nem inventa perguntas fora da tabela.

## Como começar

Cumprimente em duas linhas, peça o consolidado, confira o `estado()`, dê os dois avisos, diga que são 6 módulos e ~100 minutos e **liste os títulos**. Então:

> 1. Da Aula 02: se a consulta não tem nenhuma palavra em comum com um documento, quanto dá o cosseno?
> 2. Da Aula 06: de onde vinham os termos que a expansão de consulta acrescentou?
> 3. Chute: um sistema pode achar um documento sobre "ranqueamento" quando você digita "ordenar"?

"Zero" e "dos marcados" levam ao Módulo 1 rápido (só palavras **escritas**); "sim, se entender o sentido" — pergunte *como*: o Módulo 2 responde. **Nenhuma resposta impede a aula.**

---
---

# PARTE B — O conteúdo

## O que o aluno já sabe

### Das aulas anteriores

- **Corpus e consulta:** os 8 documentos (`docs_aula()`), a consulta `"modelo de recuperacao"`; 45 termos; `ix$w` é a matriz TF-IDF (*term frequency–inverse document frequency*) $45 \times 8$ — cada documento é uma **coluna** (Aulas 01–02). Pesos: `de` $0{,}470$; `modelo`, `recuperacao` $1{,}386$; termo de um documento só $2{,}079$.
- **Aula 02 — cosseno:** `d1` 0,254 · `d3` 0,233 · `d4` 0,215 · `d2` 0,208 · `d6` 0,025 · `d8` 0,023 · `d5` 0 · `d7` 0. Vetor nulo → `cosseno` devolve 0.
- **Aula 04 — BM25:** `d3` 1,873 · `d1` 1,869 · `d2` 1,687 · `d4` 1,427 · `d8` 0,519 · `d6` 0,492 · `d5` 0 · `d7` 0.
- **Aula 05 — gabarito:** `d2` = 2, `d3` = 2, `d1` = 1, `d6` = 1, resto 0. Escolher no **desenvolvimento**, relatar no **teste** uma vez.
- **Aula 5,5 — métricas** (limiar 2; $\text{P@}3$ / AP / RR / nDCG binário / graduado): cosseno $0{,}333$ / $0{,}5$ / $0{,}5$ / $0{,}651$ / $0{,}837$; BM25 $0{,}667$ / $0{,}833$ / $1$ / $0{,}920$ / $0{,}951$.
- **Aula 06 — Rocchio:** a expansão de consulta (3 → 21 termos) só usa palavras **escritas** nos marcados.

### O motor desta aula: `motor07.R` (copiado de `motor/CONTRATO.md`)

- **00:** `tokenizar(texto)` → termos. **01:** `docs_aula()`, `cfg_aula()`, `montar(docs, cfg)` (a lista `ix`); `matriz_tf`, `busca_booleana`, `idf_classico`.
- **02:** `cosseno(a, b)` (**0** se um vetor é nulo); `norm_cols`; `vetor_consulta(termos, vocab, idf)` → vetor no espaço do corpus; `ranking_cosseno(consulta, ix, cfg)` → escores com nomes, do maior ao menor.
- **03:** `stopwords_aula`, `limpar`, `sem_stop`, `preparar(texto, cfg)` (tokens segundo o `cfg`), `indice_invertido`, `busca_AND`. **04:** `idf_bm25`, `saturacao`, `bm25`, `bm25_doc`, `ranking_bm25(consulta, ix, cfg)`.
- **05:** `gabarito_aula()`, `kappa_matriz`, `kappa_cohen`, `ler_qrels`. **5,5:** `relevancia`, `precisao_k`, `recall_k`, `ap`, `rr`, `dcg`, `ndcg`, `metricas(ranking, grau, limiar, k = 3)` → `P_at_k`, `AP`, `RR`, `nDCG_bin`, `nDCG_grad`.
- **06:** `rocchio(q, Dr, Dnr, ix, a, b, g)`, `ranking_vetor(q, ix)`, `prf(q0, k, ix, p)`, `residual(rk, g, fora, limiar)`. **Sempre:** `estado()`, `anexar_estado(arquivo)`.

**A lista `ix`:** `ix$tokens`, `ix$vocab`, `ix$tf`, `ix$N`, `ix$df`, `ix$idf_tfidf`, **`ix$w`**, `ix$wn`, `ix$postings`, `ix$dl`, `ix$avgdl`, `ix$idf_bm25`. **`cfg`:** `limpar = TRUE`, `acentos = "manter"`, `stopwords` vazio, `k1 = 1.2`, `b = 0.75`, `limiar = 2`, `prf_k = 0`, `rocchio = c(a = 1, b = 0.75, g = 0.15)`.

### Funções de R base já apresentadas

**00:** `c`, `length`, `names`, `[ ]`, `[[ ]]`, `==`, `!`, `1:n`, `unlist`, `function`, `lapply`, `sapply`, `sum`, `list`, `sort(decreasing = …)`, `%in%`, `matrix`, `rownames`, `colnames`, `dim`, `rowSums`, `colSums`, … ; Parte D: `unique`, `source`, `list.files`, `estado`, `anexar_estado`, … **01:** função sem nome no `sapply`, `as.integer`, `>`, `if`, `return`, `character(0)`, `intersect`, `log`, `ncol`, `round`. **02:** `$`, `sqrt`, `^`, `NaN`, `sweep`, `x[condição] <- valor`, `apply`, `plot(type = "n", asp = 1)`, `text`. **03:** `head`, `iconv`, `names(x) <-`, `for`, `integer(0)`, `seq_len`, `is.na`, `ifelse`, `NULL`, `Reduce`, `all`, `lengths`. **04:** `exp`, `factorial`, valor padrão de argumento, `mean`, `next`. **05:** `union`, `diag`, `matrix(…, byrow = TRUE)`, `if (…) x else y` como valor, `table(a, b)`. **5,5:** `>=`, `cumsum`, `seq_along`, `rbind`, `which`, `log2`, `rev`. **06:** `rowMeans`, `drop = FALSE`, `!=`, `<`, `pmax`.

**Novos aqui:** `svd`, `%*%`, `t`, `diag(x, nrow = k)`, `...` com `list(...)`.

### Da grade

**Pode assumir:** vetores, produto escalar, produto de matrizes (Álgebra Linear). **Pode citar, não assumir:** componentes principais (Teoria do Aprendizado Estatístico, em andamento). **Não pode assumir:** a SVD (ferramenta, sem demonstração).

---

## Módulo 1 — Quando a palavra não bate: o descasamento de vocabulário
*trabalho 8 min · conversa 6 min · lembrete: previsão antes da saída; todo código comentado*

Booleano, cosseno, BM25, Rocchio: tudo compara **palavras escritas**. Se consulta e documento dizem a mesma coisa com palavras diferentes, o escore é **zero** — o **descasamento de vocabulário** (*vocabulary mismatch*).

```r
round(ranking_cosseno("busca", ix, cfg), 3)          # quem tem a palavra "busca"?
round(ranking_cosseno("ranqueamento", ix, cfg), 3)   # e "ranqueamento"?
```
```
   d5    d7    d1    d2    d3    d4    d6    d8 
0.270 0.265 0.000 0.000 0.000 0.000 0.000 0.000 
   d3    d1    d2    d4    d5    d6    d7    d8 
0.413 0.000 0.000 0.000 0.000 0.000 0.000 0.000 
```

`d1` — *"recuperacao de informacao ordena documentos por relevancia"* — é sobre buscar informação e **ordenar** documentos; fica com 0 nas duas. O BM25 não ajuda: `ranking_bm25("busca", ix, cfg)` dá `d5` 1,219 · `d7` 1,219 e zero para o resto.

**Exemplos que você mostra:**

- `ranking_cosseno("buscar", ix, cfg)`: **todos 0**, na ordem do corpus. `buscar` não está em `ix$vocab`: vetor nulo, e o `cosseno` devolve 0 por proteção (Aula 02). Uma letra a mais e o motor fica cego;
- "busca" e "ranqueamento": acertam quem tem a palavra, ignoram quem fala do assunto (`d1`).

> **Erro previsto:** achar que a limpeza ou o *stemming* da Aula 03 resolvem. Sinal: *"é só tirar o -r de buscar"*. Reação: resolve "buscar"/"busca"; não resolve "ordena"/"ranqueamento" — palavras **diferentes**, sentido próximo.

> **Checkpoint 1.** *Uma pessoa digita "ordenar documentos". Sem rodar: quais documentos ficam com cosseno maior que zero, e por quê? E `d3`, que é sobre ranqueamento?*
> Esperado: só os que têm `documentos` — `d1`, `d2`, `d5`, `d6` —, porque `ordenar` não está no vocabulário (`d1` tem `ordena`). `d3` fica com 0. Confere: `d1` 0,166 · `d6` 0,157 · `d2` 0,136 · `d5` 0,135 · resto 0.

> **Ponte:** para "busca" chegar perto de "recuperação", o vetor precisa de coordenadas que não sejam palavras.

---

## Módulo 2 — Esparso × denso, e a ideia de *embedding*
*trabalho 8 min · conversa 6 min · lembrete: previsão antes; matemática em LaTeX*

Na TF-IDF, cada coordenada é **uma palavra**, e quase todas são zero:

```r
sum(ix$w[, "d1"] != 0)                    # quantas coordenadas de d1 nao sao zero
sum(ix$w != 0) / length(ix$w)             # a fracao nao nula da matriz inteira
```
```
[1] 7
[1] 0.1722222
```

`d1` usa **7 de 45** coordenadas; a matriz, $17{,}2\%$: vetores **esparsos** (num corpus real, mais de $99\%$ de zeros). E `busca` e `recuperacao` são eixos **perpendiculares**: cosseno zero por construção.

Um vetor **denso** tem **poucas** coordenadas (2, 20, 100), quase **nenhuma zero**, e nenhuma é uma palavra: são eixos aprendidos dos dados, e textos parecidos ficam **perto** mesmo sem palavras em comum. É o ***embedding*** (imersão: o texto "mergulhado" num espaço de poucas dimensões).

De onde vem a "parecença"? Da **hipótese distribucional**: *"conhecerás uma palavra pela companhia que ela mantém"* (J. R. Firth, 1957). Palavras nos **mesmos contextos** têm sentido próximo — "busca" e "recuperação" aparecem perto de "documentos", "relevância".

**Exemplos que você mostra:** `d1` esparso — 45 números, 7 não nulos, cada um com nome de palavra; `d1` no LSA com 2 dimensões (Módulo 3) — $(-0{,}862;\ -0{,}253)$, nenhum zero, nenhum nome.

> **Erro previsto:** achar que cada dimensão densa "é" um tema. Sinal: *"a dimensão 1 é sobre busca?"*. Reação: as dimensões não têm nome nem precisam ter; o que importa é a **distância** entre vetores.

> **Checkpoint 2.** *`d4` tem 6 palavras distintas, nenhuma presente em todos os documentos. Sem rodar: quantos zeros tem a coluna `d4` de `ix$w`? E num vetor denso de $k = 2$?*
> Esperado: $45 - 6 = 39$ (confere com `sum(ix$w[, "d4"] == 0)`); no denso, em geral nenhum.

> **Ponte:** falta o método que aprende os eixos de "quem aparece com quem". O mais antigo usa só álgebra linear e a matriz que você já tem.

---

## Módulo 3 — LSA: a SVD da matriz TF-IDF
*trabalho 13 min · conversa 8 min · lembrete: previsão antes; LaTeX; os sinais podem trocar*

A **LSA** (*latent semantic analysis*, análise semântica latente; Deerwester et al., 1990) decompõe a TF-IDF $W$ ($45 \times 8$) pela **SVD** (*singular value decomposition*, decomposição em valores singulares):

$$W = U\,\Sigma\,V^{\top}$$

$U$ ($45 \times 8$): uma linha por **termo**, colunas ortonormais; $\Sigma$: diagonal com os **valores singulares** $\sigma_1 \geq \sigma_2 \geq \dots \geq 0$; $V$ ($8 \times 8$): uma linha por **documento**. As $k$ primeiras direções dão a melhor aproximação de $W$ com $k$ dimensões; os documentos são as linhas de $V_k\Sigma_k$.

**Novo: `svd(m)`** — lista com `$d` (valores singulares), `$u` e `$v`. **Novo: `%*%`** — produto de matrizes (`*` é elemento a elemento). **Novo: `t(m)`** — a transposta. Com `A <- matrix(1:6, nrow = 2)`: `A %*% c(1, 1, 1)` dá `9 12`; `t(A)` é $3 \times 2$.

```r
s <- svd(ix$w)                                   # a decomposicao: lista com d, u (45 x 8), v (8 x 8)
round(s$d, 3)                                    # os valores singulares, do maior ao menor
round(s$d^2, 2); round(sum(s$d^2), 2)            # a "energia" de cada direcao, e o total
all(round(s$u %*% diag(s$d) %*% t(s$v) - ix$w, 10) == 0)  # U Sigma V' devolve W?
```
```
[1] 5.602 5.313 5.022 4.783 4.672 4.522 4.319 4.024
[1] 31.38 28.23 25.22 22.88 21.83 20.45 18.65 16.19
[1] 184.82
[1] TRUE
```

A **energia** de $k$ direções é $\sum_{i \leq k}\sigma_i^2 / \sum_i \sigma_i^2$. Os valores singulares são **parecidos** (de 5,6 a 4,0): 8 documentos curtos não têm estrutura forte — com $k = 2$ fica só um terço (lição, não defeito).

**Novo: `diag(x, nrow = k)`** — a `diag` da Aula 05 com o tamanho dito. Sem `nrow`, `diag(5.602)` daria uma identidade $5 \times 5$, não a matriz $1 \times 1$.

```r
lsa <- function(ix, k) {                                          # k: quantas dimensoes guardar
  s <- svd(ix$w)                                                  # W = U Sigma V'
  U <- s$u[, 1:k, drop = FALSE]; rownames(U) <- ix$vocab          # termos x k
  D <- s$v[, 1:k, drop = FALSE] %*% diag(s$d[1:k], nrow = k)      # documentos x k: V_k Sigma_k
  rownames(D) <- colnames(ix$w)                                   # d1 ... d8
  list(U = U, S = s$d[1:k], D = D)                                # o modelo
}
```

```r
m2 <- lsa(ix, 2)       # LSA com k = 2
round(m2$D, 3)         # os 8 documentos em duas coordenadas
```
```
     [,1]   [,2]
d1 -0.862 -0.253
d2 -2.417  2.910
d3 -1.340  3.089
d4 -0.583 -0.397
d5 -3.361 -0.685
d6 -0.945  0.428
d7 -3.207 -2.888
d8 -0.434  1.001
```

**Os sinais podem sair trocados** em outra máquina; os cossenos não mudam. **Figura (opcional):** `plot(m2$D, type = "n", asp = 1)` e `text(m2$D, labels = rownames(m2$D))` (Aula 02): `d2`, `d3` no alto; `d5`, `d7` à esquerda; `d1`, `d4`, `d6` perto da origem.

**Exemplos que você mostra:**

- energia com $k = 1$: $31{,}38 / 184{,}82 = 0{,}170$ — só $17\%$;
- com $k = 2$: $(31{,}38 + 28{,}23)/184{,}82 = 0{,}323$ — dois terços da matriz ficam de fora;
- `d2` $(-2{,}417;\ 2{,}910)$ e `d3` $(-1{,}340;\ 3{,}089)$ ficam perto — os dois falam de **modelo**, o termo de maior peso ($0{,}295$) na coluna 2 de $U$.

> **Erro previsto:** `lsa(ix, 9)`. Sinal: *Error in s\$u[, 1:k, drop = FALSE]: subscript out of bounds* ("índice fora dos limites"). Reação: a SVD só tem $\min(\text{termos}, \text{documentos}) = 8$ dimensões.

> **Checkpoint 3.** *Com os quadrados da saída, que fração da energia fica com $k = 3$? Quantas dimensões guardariam pelo menos $80\%$?*
> Esperado: $84{,}83/184{,}82 = 0{,}459$; só com $k = 6$ chega a $0{,}811$. Confere com `round(cumsum(s$d^2) / sum(s$d^2), 3)`: `0.170 0.323 0.459 0.583 0.701 0.811 0.912 1.000`.

> **Ponte:** os documentos estão em 2 dimensões; a consulta ainda está em 45.

---

## Módulo 4 — Dobrar a consulta, ranquear e medir; $k$ é hiperparâmetro
*trabalho 12 min · conversa 7 min · lembrete: ele faz a conta à mão antes do R; LaTeX; 540 palavras na conta*

Para pôr a consulta no espaço de $k$ dimensões, multiplica-se por $U_k^{\top}$ — **dobrar** a consulta (*folding-in*):

$$\vec q_k = U_k^{\top}\,\vec q_0$$

```r
q0 <- vetor_consulta(preparar("modelo de recuperacao", cfg), ix$vocab, ix$idf_tfidf)  # 45 pesos
qk <- t(m2$U) %*% q0                                       # (2 x 45) %*% (45): duas coordenadas
round(qk, 3)                                               # a consulta dobrada
round(m2$U[c("de", "modelo", "recuperacao"), ], 3)         # as linhas de U que importam
```
```
       [,1]
[1,] -0.370
[2,]  0.445
              [,1]   [,2]
de          -0.110  0.171
modelo      -0.166  0.295
recuperacao -0.064 -0.032
```

Só três termos de $\vec q_0$ são não nulos (`de` $0{,}470$; `modelo`, `recuperacao` $1{,}386$). O ranking: cosseno de $\vec q_k$ com cada linha de `m2$D`.

```r
ranking_lsa <- function(consulta, ix, cfg, modelo) {               # modelo: o que lsa() devolve
  q0 <- vetor_consulta(preparar(consulta, cfg), ix$vocab, ix$idf_tfidf)  # texto -> 45 pesos
  qk <- t(modelo$U) %*% q0                                         # dobra: k coordenadas
  s  <- apply(modelo$D, 1, function(d) cosseno(qk, d))             # um cosseno por LINHA (documento)
  sort(s, decreasing = TRUE)                                       # do maior ao menor
}
r2 <- ranking_lsa("modelo de recuperacao", ix, cfg, m2); round(r2, 3)    # o ranking LSA, k = 2
round(metricas(r2, gabarito_aula(), 2), 3)                               # as cinco, limiar 2
```
```
    d2     d3     d8     d6     d5     d1     d4     d7 
 1.000  0.960  0.960  0.900  0.474  0.397  0.096 -0.039 
   P_at_k        AP        RR  nDCG_bin nDCG_grad 
    0.667     1.000     1.000     1.000     0.966 
```

AP $1$ (cosseno $0{,}5$; BM25 $0{,}833$). Repare no `1` do `apply`: os documentos agora são **linhas**.

**Exemplos que você mostra:**

- a primeira coordenada à mão: $0{,}470 \cdot (-0{,}110) + 1{,}386 \cdot (-0{,}166) + 1{,}386 \cdot (-0{,}064) = -0{,}052 - 0{,}230 - 0{,}089 \approx -0{,}37$ (com todas as casas, o R dá $-0{,}370$);
- **dobrar é a operação dos documentos**: `round(t(m2$U) %*% ix$w[, "d2"], 3)` dá $(-2{,}417;\ 2{,}910)$, a linha de `d2` em `m2$D`;
- cosseno de `d2`: $\vec q_k \cdot \vec d_2 = 2{,}188$; $\lVert \vec q_k \rVert = 0{,}578$; $\lVert \vec d_2 \rVert = 3{,}783$; $2{,}188/(0{,}578 \cdot 3{,}783) = 1{,}000$.

**$k$ é hiperparâmetro — e oscila** (rode `ranking_lsa(…, lsa(ix, 3))` etc.):

| $k$ | top-4 | $\text{P@}3$ | AP | RR | nDCG bin. | nDCG grad. |
|---|---|---|---|---|---|---|
| 2 | `d2 d3 d8 d6` | 0,667 | 1 | 1 | 1 | 0,966 |
| 3 | `d3 d6 d8 d2` | 0,333 | 0,750 | 1 | 0,877 | 0,925 |
| 4 | `d3 d2 d1 d6` | 0,667 | 1 | 1 | 1 | 1 |
| 8 | `d1 d3 d4 d2` | 0,333 | 0,5 | 0,5 | 0,651 | 0,837 |

Com $k = 8$ não há compressão: volta **a ordem do cosseno da Aula 02**. **Explore:** com $k = 1$, **todos** os cossenos dão 1 — empate total, ordem do corpus.

> **Erro previsto:** esquecer o `t()`. Sinal: `m2$U %*% q0` dá *Error in m2\$U %\*% q0: non-conformable arguments* ("argumentos não conformáveis"). Reação: $U$ é $45 \times 2$; o produto que existe é $(2 \times 45)\cdot(45)$. O mesmo erro sai se $\vec q_0$ vier de **outro** vocabulário.

> **Erro previsto:** escolher $k$ por esta tabela. Sinal: *"então $k = 4$ é o melhor"*. Reação: é **uma** consulta — escolher aqui é ajustar no teste (Aula 05). $k$ se escolhe no **desenvolvimento**.

> **Checkpoint 4.** *À mão: o cosseno de `d7` $(-3{,}207;\ -2{,}888)$, com $\lVert \vec d_7 \rVert = 4{,}316$. Por que dá negativo, se os pesos TF-IDF são todos positivos?*
> Esperado: $1{,}187 - 1{,}285 = -0{,}098$; $-0{,}098/(0{,}578 \cdot 4{,}316) \approx -0{,}039$. As coordenadas do LSA não são pesos de palavras e podem ser negativas: o cosseno vai de $-1$ a $1$.

> **Ponte:** o LSA pôs os relevantes no topo. Mas veja o que ele fez com "busca".

---

## Módulo 5 — Os limites do LSA
*trabalho 8 min · conversa 6 min · lembrete: previsão antes; ele lê os textos dos documentos*

O LSA acertou "modelo de recuperacao". Agora, as duas consultas do Módulo 1:

```r
round(ranking_lsa("busca", ix, cfg, m2), 3)          # no lexico, so d5 e d7
round(ranking_lsa("ranqueamento", ix, cfg, m2), 3)   # no lexico, so d3
```
```
    d4     d7     d1     d5     d6     d2     d3     d8 
 0.999  0.982  0.967  0.942  0.566  0.149 -0.134 -0.134 
    d8     d3     d2     d6     d5     d1     d4     d7 
 0.999  0.999  0.949  0.715  0.170  0.086 -0.224 -0.353 
```

**1. Documentos sem a palavra ganham escore.** Em "busca", `d1` (0,967) fala de recuperação: ganho de *recall*. Mas o **primeiro** é `d4` (*"aprendizado estatistico…"*), que não fala de busca, e `d5`, que tem a palavra, cai para 4º. Ganho e ruído vêm do **mesmo** mecanismo.

**2. Relações inventadas com corpus pequeno.** Em "ranqueamento", `d8` (*"ciencia de dados…"*) empata com `d3`. Por quê?

```r
intersect(ix$tokens$d3, ix$tokens$d8)            # o que d3 e d8 tem em comum
round(cosseno(ix$w[, "d3"], ix$w[, "d8"]), 3)    # na TF-IDF: 45 coordenadas
round(cosseno(m2$D["d3", ], m2$D["d8", ]), 3)    # no LSA: 2 coordenadas
```
```
[1] "e"  "de"
[1] 0.058
[1] 1
```

Só `e` e `de`, palavras sem assunto: cosseno $0{,}058$ na TF-IDF, $1$ em 2 dimensões. Com 8 frases, a SVD não tem dados para separar "fala de ranqueamento" de "usa `de`" (o mesmo com `d4` e `d7`: $0{,}991$, só o `a` em comum). Relações de verdade pedem **muito** texto.

**3. $k$ decide entre ganho e ruído.** Com `lsa(ix, 4)`: "busca" dá `d5 d7 d4 d1`, "ranqueamento" `d3 d6 d8`. Com `lsa(ix, 8)`, sem compressão, volta o léxico: "busca" só `d5` e `d7`, "ranqueamento" só `d3` — sem ruído e sem ganho. $k$ é hiperparâmetro: escolhe-se no **desenvolvimento**, com muitas consultas (Aula 05). Modelos neurais fazem o mesmo com vetores aprendidos em grandes coleções — fora do escopo do curso.

**Exemplos que você mostra:** "busca", $k = 2$: `d1` de 0 para 0,967 (ganho), `d4` 0,999 (ruído); `d3` × `d8`: $0{,}058 \to 1$; "busca", $k = 8$: `d5` 0,746 · `d7` 0,733, os outros $0{,}000$ — a ordem do léxico, com outros valores.

> **Erro previsto:** "denso é sempre melhor". Sinal: ele cita o AP $1$ do LSA. Reação: numa consulta; o mesmo LSA pôs `d8` no topo de "ranqueamento". Um termo raro e exato (nome, sigla) se dilui nas direções comuns; o léxico o acerta pela palavra. Mede-se.

> **Erro previsto:** "é só usar o maior $k$". Reação: $k = 8$ é o cosseno da Aula 02 (AP $0{,}5$ em "modelo de recuperacao"); o ganho está no meio, e só o desenvolvimento diz onde.

> **Checkpoint 5.** *Um colega diz: "o LSA achou `d4` para 'busca'; logo, ele entende o sentido". Sua objeção? E como decidir se o LSA serve num corpus?*
> Esperado: `d4` não fala de busca — com 8 frases e 2 dimensões o LSA inventa proximidades (`d3` × `d8` por `e` e `de`); uma consulta não prova nada: mede-se com gabarito em muitas consultas, com $k$ escolhido no desenvolvimento.

> **Ponte:** se o léxico acerta umas e o LSA outras, por que não usar os dois?

---

## Módulo 6 — Busca híbrida: a fusão RRF
*trabalho 12 min · conversa 6 min · lembrete: ele faz a conta à mão antes do R; LaTeX; todo código comentado*

Somar escores não funciona: BM25 vai a 1,873, o cosseno do LSA fica em $[-1, 1]$. A **RRF** (*reciprocal rank fusion*, fusão pelo inverso da posição; Cormack, Clarke & Büttcher, 2009) usa **só as posições**:

$$\text{RRF}(d) = \sum_{r \in \text{rankings}} \frac{1}{c + \text{pos}_r(d)}, \qquad c = 60$$

O $c$ amortece: entre 1º e 2º ($\frac{1}{61}$, $\frac{1}{62}$) a diferença é pequena; quem está bem nos **dois** rankings ganha de quem é 1º num e último no outro.

**Novo: `...`** — "quantos argumentos vierem"; `list(...)` os junta. `f <- function(...) length(list(...))`; `f(1, 2, 3)` dá `3`.

```r
rrf <- function(..., c = 60) {                         # ...: quantos rankings vierem
  rks <- list(...)                                     # os rankings, numa lista
  ids <- unique(unlist(lapply(rks, names)))            # todos os documentos que aparecem
  s <- sapply(ids, function(d)                         # para cada documento...
    sum(sapply(rks, function(r) {                      # ...soma sobre os rankings
      p <- which(names(r) == d)                        # a posicao dele neste ranking
      if (length(p)) 1 / (c + p) else 0 })))           # ausente: nao soma nada
  sort(s, decreasing = TRUE)                           # do maior ao menor
}
```

```r
rb <- ranking_bm25("modelo de recuperacao", ix, cfg)   # lexico: d3 d1 d2 d4 d8 d6 d5 d7
rh <- rrf(rb, r2)                                      # funde com o LSA k = 2 (d2 d3 d8 d6 d5 d1 d4 d7)
round(rh, 4)                                           # o hibrido
```
```
    d3     d2     d1     d8     d6     d4     d5     d7 
0.0325 0.0323 0.0313 0.0313 0.0308 0.0306 0.0303 0.0294 
```

```r
rc <- ranking_cosseno("modelo de recuperacao", ix, cfg); g <- gabarito_aula()  # o cosseno e os graus
round(rbind(cosseno = metricas(rc, g, 2), bm25 = metricas(rb, g, 2),           # lexicos...
            lsa2 = metricas(r2, g, 2), rrf = metricas(rh, g, 2)), 3)           # ...denso e hibrido
```
```
        P_at_k    AP  RR nDCG_bin nDCG_grad
cosseno  0.333 0.500 0.5    0.651     0.837
bm25     0.667 0.833 1.0    0.920     0.951
lsa2     0.667 1.000 1.0    1.000     0.966
rrf      0.667 1.000 1.0    1.000     0.990
```

O híbrido iguala o LSA no AP e **supera os dois** no nDCG graduado ($0{,}990$): pôs `d1` (grau 1) em 3º; o LSA o tinha em 6º.

**Exemplos que você mostra:**

- `d3`: 1º no BM25, 2º no LSA → $\frac{1}{61} + \frac{1}{62} = 0{,}01639 + 0{,}01613 = 0{,}0325$;
- `d1`: 2º e 6º → $\frac{1}{62} + \frac{1}{66} = 0{,}03128$; `d8`: 5º e 3º → $\frac{1}{65} + \frac{1}{63} = 0{,}03126$;
- ausente: `round(rrf(rb[1:3], r2[1:3]), 4)` dá `d3` 0,0325 · `d2` 0,0323 · `d1` 0,0161 · `d8` 0,0159 — quem está num só ranking soma uma parcela.

**Explore:** `rrf(rb, r2, c = 1)` — `d3` 0,8333 · `d2` 0,7500 · `d1` 0,4762 …: mais espaçados, **mesma ordem** aqui.

> **Erro previsto:** fundir um vetor fora de ordem. Sinal: ele passa escores sem `sort`. Reação: a função usa a **posição**; fora de ordem dá posições erradas, sem erro na tela. Os `ranking_*` já vêm ordenados.
> **Checkpoint 6.** *À mão: o escore RRF de `d6` (6º no BM25, 4º no LSA), com $c = 60$. Em que posição ele cai?*
> Esperado: $\frac{1}{66} + \frac{1}{64} = 0{,}01515 + 0{,}01563 = 0{,}0308$ → 5º, entre `d8` (0,0313) e `d4` (0,0306).

> **Ponte:** você sabe fazer busca com LSA e híbrida e medir. O teste confirma — e a Parte D leva os dois ao corpus do grupo, com $k$ escolhido no desenvolvimento.

---

**Funções de R apresentadas nesta aula** (o guia da Aula 08 copia esta linha): `svd`, `%*%`, `t`, `diag(x, nrow = k)`, `...` com `list(...)`. **Escritas na sessão** (irão para o `motor08`, com estes nomes): `lsa(ix, k)`, `ranking_lsa(consulta, ix, cfg, modelo)`, `rrf(..., c = 60)`.

**Casos degenerados desta aula:** consulta fora do vocabulário → vetor nulo, `cosseno` 0 para todos, ordem do corpus (também no LSA: $U_k^{\top}\vec 0 = \vec 0$); $k > \min(\text{termos}, \text{documentos})$ e `%*%` sem `t()` (os erros previstos dos Módulos 3 e 4); $k = 1$ → empate total; sinais da SVD trocados → cossenos iguais; empate no escore de origem (BM25 0) → posição na ordem do corpus; escores RRF iguais → ordem do primeiro ranking; ausente de um ranking → não soma parcela dele.

---
---

# PARTE C — Teste final: uma pergunta por módulo

**Só depois do Módulo 6, antes do consolidado.** Avise: *"um teste curto — uma por módulo."* **Só estas perguntas**, só dos módulos alcançados, **uma por vez**; diga se acertou e, em uma linha, o que faltou. Não reensine.

| módulo | pergunta | esperado |
|---|---|---|
| **1** | Alguém busca `"aprendizagem"`. O que o `ranking_cosseno` devolve, e por que é descasamento de vocabulário? | todos 0 (vetor nulo), na ordem do corpus; `d4` tem "aprendizado" — o mesmo assunto, outra palavra |
| **2** | Um documento tem 10 palavras distintas, nenhuma em todos os documentos, num vocabulário de 45. Quantos zeros no vetor TF-IDF? Quantas coordenadas no LSA com $k = 3$? | 35 zeros; 3 coordenadas, em geral nenhuma zero |
| **3** | Se os valores singulares fossem 6, 2, 1 e 1, que fração da energia ficaria com $k = 1$? O que isso diz, comparado ao corpus do curso? | $36/42 = 0{,}857$: uma direção domina; no curso, $k = 1$ guarda só $0{,}170$ |
| **4** | Com $\vec q_k = (-0{,}370;\ 0{,}445)$, quem tem cosseno maior: `d1` $(-0{,}862;\ -0{,}253)$ ou `d6` $(-0{,}945;\ 0{,}428)$? Por quê, sem a conta toda? | `d6`: as duas coordenadas têm o sinal das da consulta; em `d1` a segunda é oposta (0,900 contra 0,397) |
| **5** | Com $k = 2$, `d8` empata com `d3` em "ranqueamento", e os dois só têm `e` e `de` em comum. Por quê? E com $k = 8$? | 8 frases não bastam para separar assunto de palavra comum: cosseno $0{,}058$ na TF-IDF, $1$ em 2 dimensões; com $k = 8$ não há compressão e só `d3` pontua |
| **6** | Com $c = 60$: A é 1º num ranking e 10º no outro; B é 4º nos dois. Quem fica à frente? | B: $\frac{2}{64} = 0{,}0313$ contra A: $\frac{1}{61} + \frac{1}{70} = 0{,}0307$ |

**Resultado em uma linha:** *"acertou os módulos 1, 2, 4 e 6; 3 e 5 vão para revisão."* Errou 3 ou mais: revisar antes da Aula 08.

**Então:** *"A próxima etapa é a Parte D, do grupo: LSA no corpus de vocês, BM25 × LSA × híbrido e a decisão do modelo. Abram `GUIA_ESTUDO_aula07_parteD.md` com a ficha do projeto."*

---

## Glossário

| sigla / termo | por extenso | o que é |
|---|---|---|
| *embedding* | imersão | vetor denso que representa um texto; perto = parecido |
| LSA | *latent semantic analysis* | SVD da matriz termo-documento, truncada em $k$ dimensões |
| SVD | *singular value decomposition* | $W = U\,\Sigma\,V^{\top}$ |
| dobrar (*folding-in*) | — | $\vec q_k = U_k^{\top}\vec q_0$: a consulta no espaço do LSA |
| RRF | *reciprocal rank fusion* | $\sum 1/(c + \text{pos})$ sobre os rankings |
| RAG | *retrieval-augmented generation* | geração com recuperação (Aula 14) |
| TF-IDF / BM25 / AP | *term frequency–inverse document frequency* / *Best Match 25* / *average precision* | Aulas 01, 04, 5,5 |
| LLM / Colab | *large language model* / Google Colaboratory | a tutora / onde o R roda |

---

## Fechamento

Ordem fixa: **teste → oferta da Parte D → perguntas guardadas → tarefa → o que vem → consolidado → passos de fechamento.**

1. **Perguntas guardadas:** responda as curtas; encaminhe (Aulas 08, 14, 15).
2. **A tarefa** (individual; a dos slides é a Parte D), sem fazê-la por ele: uma consulta de uma palavra no corpus de 8; cosseno, LSA com $k = 2$ e $k = 4$, RRF; um ganho e um ruído do LSA, por escrito; explicar cada bloco de código.
3. **O que vem:** *"A Aula 08 pega o topo desse ranking e o reordena olhando onde as palavras da consulta aparecem no documento, e em que ordem: a reordenação."* Leitura: Manning, Raghavan & Schütze, *Introduction to Information Retrieval*, cap. 18; Deerwester et al. (1990), *Indexing by Latent Semantic Analysis*; Cormack, Clarke & Büttcher (2009), sobre a RRF.
4. **Gere o consolidado** — avise que está gerando.
5. **Logo abaixo, na mesma mensagem, os passos de fechamento**, por extenso.

---

# PARTE D — está em outro arquivo

Os **Módulos 7 a 9** estão em `GUIA_ESTUDO_aula07_parteD.md` (**sessão do grupo**, com a ficha). O consolidado registra "Parte D: a marcar".

---

## Modelo do consolidado

**Relato sobre o aluno, em três partes — não resumo da matéria.** Meia página; teto de 2 mil palavras. **Bloco de código Markdown** (`aula07_consolidado.md`). **Nunca PDF, relatório, reexplicação ou código.** LaTeX. Primeira pessoa. **Sem a seção "Estado do R".** Nada que ele não possa ler em voz alta na turma.

```markdown
# Consolidado — PI III — Aula 07 — <data>
*guia versão 2 · tutora: <qual LLM> · sessão individual (teoria) · motor07*
**Aluno:** <nome>

## 1. O que foi passado
- M1 — descasamento de vocabulário: "busca", "ranqueamento", "buscar"
- M2 — esparso × denso; `d1` com 7 de 45; hipótese distribucional
- M3 — LSA: $W = U\,\Sigma\,V^{\top}$; energia $0{,}323$ com $k = 2$
- M4 — consulta dobrada $(-0{,}370;\ 0{,}445)$; AP $1$; $k$ como hiperparâmetro
- M5 — limites do LSA: `d4` em "busca"; `d3` × `d8` ($0{,}058 \to 1$); $k$ entre ganho e ruído
- M6 — RRF; `d3` = $0{,}0325$ à mão; híbrido nDCG graduado $0{,}990$
<se parou: "parou no M4; M5–M6 não alcançados — retomar do M5">

## 2. Como foi o aprendizado — opinião da tutora
<um parágrafo, em primeira pessoa: dobrou a consulta à mão? esbarrou no `non-conformable`?
achou que denso é sempre melhor? fez a RRF sozinho? o que foi entregue pronto?>

**Teste final:** acertou M<lista>; a revisar M<lista> — <uma linha por módulo>.

## 3. Observações para a frente
- **Revisar antes da Aula 08:** <o quê, e por quê>
- **Para a próxima tutora:** <ritmo, perfil, conforto com matrizes e com o R>
- **Perguntas guardadas:** <pergunta> — <para qual aula>
- **Produzido:** `lsa`, `ranking_lsa`, `rrf`; LSA $k = 2$ `d2 d3 d8 d6 d5 d1 d4 d7`; híbrido `d3 d2 d1 d8 d6 d4 d5 d7`
- **Parte D (sessão de grupo):** a marcar — com a ficha do projeto
```

## Passos de fechamento (copie logo abaixo do consolidado)

1. Copie o bloco acima e salve como **`aula07_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, envie o arquivo (pasta à esquerda → upload). Rode `list.files()`: ele tem que aparecer solto, com esse nome exato (não em `sample_data`, não `aula07_consolidado (1).md`).
3. Rode `anexar_estado("aula07_consolidado.md")`.
4. Baixe de volta (três pontinhos → *Fazer download*) e confira que a seção "Estado do R" apareceu no fim.
5. Envie ao repositório do grupo, em **`consolidados/<seu nome>/`** (*Add file → Upload files → Commit changes*; mesmo nome substitui).

Se ele disser que já fez, pergunte só: *"a seção 'Estado do R' apareceu no fim do arquivo?"*
