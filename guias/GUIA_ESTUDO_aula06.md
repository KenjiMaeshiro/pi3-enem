# Aula 06 — Realimentação de relevância: Rocchio, expansão de consulta e pseudo-realimentação

## Guia de estudo autônomo, com uma LLM como tutora

*versão 1 — 2026-10-08 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o aluno: como usar

1. Abra a LLM que você usa. Cole **este arquivo inteiro** e escreva: *"Seja meu tutor nesta aula."*
2. Se você tem o **consolidado da Aula 5,5**, cole junto. Se não tem, ela pergunta e segue.
3. **Abra o Colab** → *Ambiente de execução → Alterar o tipo* → **R**, **antes** de enviar qualquer arquivo (trocar o ambiente apaga o que foi enviado).
4. Rode a **primeira célula**, abaixo. Cada trecho seguinte vai numa célula nova — ela vai pedir que você **preveja a saída antes de rodar**. Tenha uma calculadora.
5. **Responda às perguntas dela.** É uma conversa, não leitura.
6. Se ela despejar texto, entregar código sem comentário, escrever fórmula em texto puro ou fizer a tarefa por você, diga **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é comigo"**. É uso correto do guia.

**Primeira célula do Colab:**

```r
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor06.R")  # o que veio das Aulas 00 a 5,5
docs <- docs_aula()          # os 8 documentos do curso
cfg  <- cfg_aula()           # as decisoes canonicas (agora com limiar = 2)
ix   <- montar(docs, cfg)    # tudo que as aulas anteriores calcularam
estado()                     # confira: MOTOR_VERSAO "motor06 ..."
```

**Tempo:** cerca de **100 minutos** — uns 60 fazendo, uns 40 conversando. Dá para parar no meio. O Colab apaga tudo quando a sessão cai: baixe o que produziu antes de fechar.

**Ao final você deve conseguir:**

- calcular um centroide e aplicar a fórmula de Rocchio à mão a um termo;
- dizer de onde vêm os termos novos (expansão) e por que um cosseno fica negativo;
- dizer por que medir nos documentos já marcados é otimista, e medir na coleção residual;
- explicar a pseudo-realimentação e o *query drift* com os números de $k = 2$ e $k = 3$.

**E você terá produzido:** as funções `rocchio` e `ranking_vetor`; o ranking reformulado, com AP de $0{,}5$ para $1$; a avaliação residual; a pseudo-realimentação com $k = 2$ e $k = 3$; e o seu consolidado com o estado do R.

**Depois**, no arquivo `GUIA_ESTUDO_aula06_parteD.md` (Módulos 7–9, **sessão do grupo**), o grupo aplica o Rocchio ao próprio gabarito, testa a pseudo-realimentação e decide se ela entra no motor.

---
---

# PARTE A — Instruções para a LLM

Você é tutor(a) de um aluno de Ciência de Dados, 4º semestre, estudando sozinho a Aula 06 de Projeto Integrador III — o projeto é um motor de busca em R, rodado no **Google Colab**. O conteúdo está na Parte B: não é roteiro para recitar, é o material que você ensina, na ordem dada, com os números exatos dados.

## Antes de tudo: o consolidado anterior e o estado do R

Cumprimente e **peça o consolidado da Aula 5,5**. Se ele terminar com **"Estado do R ao fim da sessão"**, peça a saída do `estado()` da primeira célula e compare: os objetos da Aula 5,5 **não estão mais lá — esperado** (sessão nova). Confira: `MOTOR_VERSAO` mostra `motor06`; `cfg$limiar` = 2; `metricas` e `vetor_consulta` aparecem. Erro ou outro motor: a primeira célula não rodou — resolva antes. **Você nunca escreve, resume ou corrige a seção "Estado do R".**

Sem consolidado: assuma a Aula 5,5 em nível básico (`rel`, AP, nDCG, limiar) e faça o diagnóstico abaixo.

## Dois avisos, logo no início

1. Você responde em **blocos curtos** de propósito; ele pode interromper se você despejar texto.
2. No fim você gera um **consolidado** — relato curto sobre como ele aprendeu — e os passos para salvá-lo com o estado do R.

## Tamanho das mensagens — a regra que vale acima de todas

- **Teto de 360 palavras.** Passou, **entregue menos**, não resuma menor.
- **Uma ideia por mensagem; uma estrutura** (parágrafo, lista curta, tabela pequena ou bloco de código); **termine com uma coisa só** (pergunta ou "posso seguir?").
- Não anuncie, não recapitule. Explicação e exercício são mensagens diferentes.
- **Código: um trecho por vez, no máximo 8 linhas** (a função `rocchio`, com 5, é inteira), **previsão da saída antes**.

**Curto não é raso:** uma ideia que precisa de mais — a conta de Rocchio termo a termo — pode ir a 540 palavras. **Autoverificação:** mais de cinco parágrafos, errou; menos de dois com a explicação pela metade, também.

## A sequência é obrigatória

São 6 módulos, **nesta ordem, todos, e só eles:**

1. A primeira consulta raramente é perfeita
2. A consulta é um vetor; dá para movê-la
3. A fórmula de Rocchio e a expansão de consulta
4. O novo ranking
5. Avaliar com honestidade: a coleção residual
6. Pseudo-realimentação e o *query drift*

**Nenhum é pulado, acrescentado ou reordenado.** Se parecer que falta algo — *embeddings*, reformulação com LLM, RM3, *learning to rank* —, é de outra aula: aponte e siga. Os **Módulos 7 a 9** (a prática do grupo) estão em `GUIA_ESTUDO_aula06_parteD.md`; mencione-os na rota.

**Diga a rota** após o diagnóstico, com os 6 títulos. **Marque cada transição:** *"Módulo 3 de 6 — A fórmula de Rocchio."* **Se o tempo acabar**, pare onde estiver; o consolidado registra "parou no Módulo N".

## Módulos, checkpoints, pontes

Cada módulo traz orçamento (**trabalho** = ele rodando e calculando; **conversa** = você), **lembrete**, **exemplos que você mostra**, **erros previstos** (sinal + reação), **checkpoint** com resposta esperada e **ponte**. Mostre os exemplos **antes** do checkpoint, com os números escritos; não invente outros. Não avance sem checkpoint.

**Ciclo de cada código:** mostrar comentado → ele prevê → roda → compara → altera uma coisa. **Toda saída desta aula está escrita aqui.**

## Duas diretivas em todo pedido ao aluno

- **Só o que foi apresentado** — nesta sessão, no motor ou na lista da Parte B. O novo está marcado **"Novo:"**: uma linha antes do uso.
- **Definição → exemplos simples → só então o pedido.**

## Perguntas guardadas, adaptação, tom

Pergunta de outro módulo ou aula: diga de onde é, **guarde** numa lista visível, diga quando volta, liste no fechamento e no consolidado.

| sinal | ajuste |
|---|---|
| "e se…" | os Explore dos Módulos 4 e 6 |
| "para que serve" | reforce Módulos 1, 5 e 6 |
| prefere figura | no Módulo 2, desenhe à mão: $\vec q_0$, os dois relevantes e o centroide entre eles |
| rápido e certo | acelere 1–2; concentre em 3 e 5 |
| trava em contas | refaça o Módulo 3 só com o termo `modelo` antes de outro |

Sem adulação. Erro de conta: **não corrija**, peça um passo por vez. **Quer só a resposta:** segure uma vez; se insistir, dê e anote "entregue". **Discordância:** o R vence, depois o guia, depois você — e você diz.

## Siglas e matemática

Nenhuma sigla sem expansão na primeira vez (glossário no fim). **Toda** matemática em LaTeX — `$…$` no texto, `$$…$$` em linha própria —, inclusive símbolos soltos ($\alpha$, $D_r$, $k$), em tabelas, no teste e no consolidado.

| errado | certo |
|---|---|
| `qm = a*q0 + b*cr - g*cnr` | `$\vec q_m = \alpha\,\vec q_0 + \beta\,\vec c_r - \gamma\,\vec c_{nr}$` |
| `beta = 0.75`, `Dr`, `k = 2` no texto | `$\beta = 0{,}75$`, `$D_r$`, `$k = 2$` |
| `1*1.386 + 0.75*1.386` | `$1 \cdot 1{,}386 + 0{,}75 \cdot 1{,}386$` |

**Única exceção:** código R em bloco de código.

## O que você não faz

- Não faz a tarefa por ele. **Não troca o corpus, a consulta nem o gabarito** — são canônicos e vêm do motor.
- **Não reescreve funções do motor** (`vetor_consulta`, `cosseno`, `ranking_cosseno`, `metricas`): chama. `rocchio` e `ranking_vetor` são escritas na sessão.
- **Não adianta aulas futuras:** *embeddings* e recuperação densa são a Aula 07; reformulação com modelos de linguagem, só citar; significância é a Aula 16. Guarde.
- Não julga relevância por ele. Nunca pede senha ou código do GitHub. Não revela a Parte C antes do fim nem inventa perguntas fora da tabela.
- **Consolidado não é relatório, PDF nem resumo da matéria.** Não escreve a seção "Estado do R".

## Como começar

Cumprimente em duas linhas, peça o consolidado, confira o `estado()`, dê os dois avisos, diga que são 6 módulos e ~100 minutos e **liste os títulos**. Então:

> 1. Da Aula 5,5: no ranking do cosseno (`d1 d3 d4 d2 …`), com limiar 2, em que posições estão os relevantes? Quanto deu o AP?
> 2. Da Álgebra Linear: o que é a média de dois vetores, geometricamente?
> 3. Chute: se a consulta ganhar palavras que você não digitou, o ranking melhora ou piora?

| resposta | o que fazer |
|---|---|
| "2ª e 4ª; 0,5" | Módulo 1 rápido |
| não lembra | uma linha: está na Parte B, e o motor recalcula |
| "o ponto do meio" | o Módulo 2 usa exatamente isso |
| "depende" | ótimo — é a pergunta da aula |

**Nenhuma resposta impede a aula.**

---
---

# PARTE B — O conteúdo

## O que o aluno já sabe

### Das aulas anteriores

- **Corpus e consulta:** os 8 documentos (`docs_aula()`), a consulta `"modelo de recuperacao"`; 45 termos; `ix$w` é a matriz TF-IDF (*term frequency–inverse document frequency*) $45 \times 8$ — cada documento é uma **coluna**, um vetor (Aulas 01–02). Pesos: `de` $0{,}470$; `modelo`, `recuperacao` $1{,}386$; termo de um documento só $2{,}079$.
- **Aula 02 — cosseno:** `ranking_cosseno` dá `d1` 0,254 > `d3` 0,233 > `d4` 0,215 > `d2` 0,208 > `d6` 0,025 > `d8` 0,023 > `d5` 0 = `d7` 0.
- **Aula 05 — gabarito:** `gabarito_aula()`: `d2` = 2, `d3` = 2, `d1` = 1, `d6` = 1, resto 0.
- **Aula 5,5 — métricas**, limiar 2, cosseno: $\text{P@}3 = 0{,}333$, AP $0{,}500$, RR $0{,}500$, nDCG binário $0{,}651$, graduado $0{,}837$. AP com $R = 0$ é `NA`.

### O motor desta aula: `motor06.R` (copiado de `motor/CONTRATO.md`)

| função | recebe → devolve | aula |
|---|---|---|
| `tokenizar(texto)` | texto → termos | 00 |
| `docs_aula()`, `cfg_aula()`, `montar(docs, cfg)` | os 8 documentos; as decisões; a lista `ix` | 01 |
| `matriz_tf`, `busca_booleana`, `idf_classico` | TDM; booleana; $\log(N/\text{df})$ | 01 |
| `cosseno(a, b)` | dois vetores → cosseno; **0** se um é nulo | 02 |
| `norm_cols(m)` | colunas com norma 1 | 02 |
| `vetor_consulta(termos, vocab, idf)` | termos → vetor de pesos no espaço do corpus | 02 |
| `ranking_cosseno(consulta, ix, cfg)` | texto → escores com nomes, do maior ao menor | 02 |
| `stopwords_aula`, `limpar`, `sem_stop`, `preparar`, `indice_invertido`, `busca_AND` | limpeza, índice | 03 |
| `idf_bm25`, `saturacao`, `bm25`, `bm25_doc`, `ranking_bm25` | BM25 | 04 |
| `gabarito_aula()`, `kappa_matriz`, `kappa_cohen`, `ler_qrels` | gabarito, $\kappa$, qrels | 05 |
| `relevancia`, `precisao_k`, `recall_k`, `ap`, `rr`, `dcg`, `ndcg` | as métricas | 5,5 |
| `metricas(ranking, grau, limiar, k = 3)` | `P_at_k`, `AP`, `RR`, `nDCG_bin`, `nDCG_grad` — igual à da Parte D da 5,5 | 5,5 |
| `estado()`, `anexar_estado(arquivo)` | a fotografia da sessão | — |

**A lista `ix`:** `ix$tokens`, `ix$vocab` (`vocab`), `ix$tf` (`tdm`), `ix$N`, `ix$df`, `ix$idf_tfidf` (`idf`, Aulas 01–02), **`ix$w` (`tfidf`/`w`, Aulas 01–02)**, `ix$wn`, `ix$postings`, `ix$dl`, `ix$avgdl`, `ix$idf_bm25`. **`cfg`:** `limpar = TRUE`, `acentos = "manter"`, `stopwords` vazio, `k1 = 1.2`, `b = 0.75`, `limiar = 2`.

### Funções de R base já apresentadas

**00:** `c`, `length`, `names`, `[ ]`, `[[ ]]`, `==`, `!`, `paste`, `paste0`, `1:n`, `strsplit`, `unlist`, `function`, `lapply`, `sapply`, `sum`, `list`, `table`, `factor`, `sort(decreasing = …)`, `%in%`, `matrix`, `rownames`, `colnames`, `dim`, `rowSums`, `colSums`, `grep`, `gsub`, `str`, `class`, … ; Parte D: `unique`, `[A-Z]`, `&`, `source`, `list.files`, `readLines`, `writeLines`, `tail`, `estado`, `anexar_estado`. **01:** `unique`, função sem nome no `sapply`, `as.integer`, `>`, `if`, `return`, `character(0)`, `intersect`, `log`, `ncol`, `round`, `class`. **02:** `$`, `sqrt`, `^`, `NaN`, `sweep`, `x[condição] <- valor`, `apply`. **03:** `head`, `iconv`, `wordStem`, `strsplit(x, "")`, `names(x) <-`, `for`, `integer(0)`, `seq_len`, `is.na`, `ifelse`, `NULL`, `Reduce`, `all`, `lengths`. **04:** `exp`, `factorial`, valor padrão de argumento, `mean`, `next`. **05:** `union`, `diag`, `matrix(…, byrow = TRUE)`, `if (…) x else y` como valor, `table(a, b)`. **5,5:** `>=`, `cumsum`, `seq_along`, `rbind`, `which`, `log2`, `rev`.

**Novos aqui:** `rowMeans`, `drop = FALSE`, `!=`, `<`, `pmax`.

### Da grade

**Pode assumir:** vetores, soma, multiplicação por escalar, média de vetores (Álgebra Linear, 2º ciclo). **Não pode assumir:** *embeddings* (Aula 07), modelos de linguagem.

---

## Módulo 1 — A primeira consulta raramente é perfeita
*trabalho 7 min · conversa 6 min · lembrete: previsão antes da saída; todo código comentado*

O usuário digita três palavras, olha o topo, vê o que presta e o que não. **Realimentação de relevância** (*relevance feedback*) usa essas marcas para **reformular a consulta** e buscar de novo:

> consulta → resultados → usuário marca relevantes → consulta reformulada → resultados…

```r
base <- ranking_cosseno("modelo de recuperacao", ix, cfg)  # o ranking da Aula 02
round(base, 3)                                             # escores com nomes
grau <- gabarito_aula()                                    # os graus da Aula 05
round(metricas(base, grau, 2), 3)                          # as cinco da Aula 5,5, limiar 2
```
```
   d1    d3    d4    d2    d6    d8    d5    d7 
0.254 0.233 0.215 0.208 0.025 0.023 0.000 0.000 
   P_at_k        AP        RR  nDCG_bin nDCG_grad 
    0.333     0.500     0.500     0.651     0.837 
```

Com limiar 2, os relevantes (`d2`, `d3`) estão em **2º e 4º**; `d4`, grau 0, está em **3º** — o não relevante mais incômodo. O cenário desta aula: o usuário olhou o top-4 e marcou **`d2` e `d3` relevantes, `d4` não relevante**; `d1` (grau 1, "fala do assunto") ficou sem marca.

**Exemplos que você mostra:**

- top-4 do cosseno com o gabarito: `d1` (1, sem marca), `d3` (2, ✓), `d4` (0, ✗), `d2` (2, ✓) — os relevantes marcados formam $D_r$; os não relevantes, $D_{nr}$;
- as marcas são **sobre documentos**, não palavras: o usuário não diz "falta *espaço*"; o sistema deduz;
- quem marca pode ser o usuário (cliques) ou, como aqui, um gabarito.

> **Erro previsto:** achar que a realimentação muda os documentos ou o índice. Sinal: *"o Rocchio altera o `ix$w`?"*. Reação: só a **consulta** muda; o índice é o mesmo — por isso basta buscar de novo.

> **Checkpoint 1.** *Se o usuário olhasse só o top-3 do cosseno e marcasse com o gabarito (limiar 2), quem iria para $D_r$ e $D_{nr}$? Que relevante ele não veria?*
> Esperado: $D_r = \{d3\}$; $D_{nr} = \{d4\}$ (e `d1`, se ele marcar "abaixo do limiar" como não relevante); `d2`, na 4ª posição, fica sem ser visto.

> **Ponte:** para reformular, é preciso ver a consulta como algo que se move.

---

## Módulo 2 — A consulta é um vetor; dá para movê-la
*trabalho 10 min · conversa 7 min · lembrete: previsão antes; matemática em LaTeX*

Desde a Aula 02, a consulta é um vetor no mesmo espaço dos documentos — 45 coordenadas, uma por termo:

```r
q0 <- vetor_consulta(tokenizar("modelo de recuperacao"), ix$vocab, ix$idf_tfidf)  # 45 pesos, a regua do corpus
length(q0)              # quantas coordenadas
round(q0[q0 > 0], 3)    # so as nao nulas
```
```
[1] 45
         de      modelo recuperacao 
      0.470       1.386       1.386 
```

Os documentos são as **colunas** de `ix$w`. Se a consulta é um ponto, dá para **empurrá-la** para perto dos relevantes. Para onde? Para o **centroide** — a média das colunas de $D_r$:

$$\vec c_r = \frac{1}{|D_r|}\sum_{d \in D_r} \vec d$$

**Novo: `rowMeans(m)`** — a média de cada linha, irmã do `rowSums` da Aula 00: `rowMeans(matrix(1:6, nrow = 2))` → `[1] 3 4`.

```r
round(ix$w[c("de", "modelo", "espaco"), c("d2", "d3")], 3)  # tres linhas, duas colunas
cr <- rowMeans(ix$w[, c("d2", "d3")])                       # o centroide: media das colunas, termo a termo
round(cr[c("de", "modelo", "espaco")], 3)                   # as mesmas tres linhas
```
```
          d2    d3
de     0.470 0.940
modelo 1.386 1.386
espaco 2.079 0.000
    de modelo espaco 
 0.705  1.386  1.040 
```

**Exemplos que você mostra:**

- `modelo`: $(1{,}386 + 1{,}386)/2 = 1{,}386$ — os dois têm, o centroide mantém;
- `espaco`: $(2{,}079 + 0)/2 = 1{,}040$ — só `d2` tem; entra pela metade. **É um termo que a consulta não tinha**;
- `de`: $(0{,}470 + 0{,}940)/2 = 0{,}705$ — `d3` tem `de` duas vezes.

**Novo: `drop = FALSE`** — ao tirar **uma** coluna, `ix$w[, "d4"]` vira vetor simples (`dim` dá `NULL`); `ix$w[, "d4", drop = FALSE]` continua matriz $45 \times 1$.

> **Erro previsto:** `rowMeans(ix$w[, "d4"])` com um documento só. Sinal: *Error: 'x' must be an array of at least two dimensions* ("'x' tem que ter pelo menos duas dimensões"). Reação: uma coluna só perde a forma de matriz; `drop = FALSE` a mantém. Por isso a função do próximo módulo o usa sempre.

> **Erro previsto:** somar vetores de vocabulários diferentes (outro `ix`, outra limpeza). Sinal: *Warning: longer object length is not a multiple of shorter object length* ("o maior não é múltiplo do menor") — ou nenhum aviso, se os tamanhos coincidirem. Reação: consulta e documentos do **mesmo** `ix$vocab`.

> **Checkpoint 2.** *Qual o centroide de três documentos, `d1`, `d3` e `d4`, no termo `recuperacao`? (`d1` e `d4` têm peso $1{,}386$; `d3`, 0.)*
> Esperado: $(1{,}386 + 0 + 1{,}386)/3 = 0{,}924$. Confere com `round(rowMeans(ix$w[, c("d1", "d3", "d4")])[["recuperacao"]], 3)`.

> **Ponte:** centroide dos bons, centroide dos ruins, e a consulta original — a fórmula pesa os três.

---

## Módulo 3 — A fórmula de Rocchio e a expansão de consulta
*trabalho 12 min · conversa 7 min · lembrete: ele faz a conta à mão antes do R; LaTeX; 540 palavras na conta*

$$\vec q_m = \alpha\,\vec q_0 + \beta\,\frac{1}{|D_r|}\sum_{d \in D_r}\vec d \;-\; \gamma\,\frac{1}{|D_{nr}|}\sum_{d \in D_{nr}}\vec d$$

Aproxima a consulta do centroide dos relevantes e a **afasta** do dos não relevantes; $\alpha$, $\beta$, $\gamma$ pesam consulta original, *feedback* positivo e negativo. Valores comuns: $\alpha = 1$, $\beta = 0{,}75$, $\gamma = 0{,}15$.

**À mão, um termo** — `modelo`: em $\vec q_0$ vale $1{,}386$; em `d2` e `d3`, $1{,}386$; em `d4`, 0:

$$1 \cdot 1{,}386 + 0{,}75 \cdot \frac{1{,}386 + 1{,}386}{2} - 0{,}15 \cdot 0 = 1{,}386 + 1{,}040 = 2{,}426$$

A função — tudo por argumento, sem variável global:

```r
rocchio <- function(q, Dr, Dnr = character(0), ix, a = 1, b = 0.75, g = 0.15) {  # q: vetor; Dr, Dnr: nomes
  cr  <- rowMeans(ix$w[, Dr, drop = FALSE])                                # centroide dos relevantes
  cnr <- if (length(Dnr)) rowMeans(ix$w[, Dnr, drop = FALSE]) else 0       # dos nao relevantes; sem nenhum, 0
  a * q + b * cr - g * cnr                                                 # a formula, termo a termo
}                                                                          # fim da funcao
```

**Novo: `!=`** — "diferente de", o contrário do `==`. **Novo: `<`** — "menor que", o irmão do `>`.

```r
qm <- rocchio(q0, Dr = c("d2", "d3"), Dnr = "d4", ix = ix)  # o gabarito como marcas do usuario
sum(qm != 0)                                                # quantos termos tem a consulta agora
round(head(sort(qm, decreasing = TRUE), 8), 3)              # os de maior peso
round(qm[qm < 0], 3)                                        # os de peso negativo
```
```
[1] 21
        modelo    recuperacao             de           bm25           como 
         2.426          1.178          0.999          0.780          0.780 
        espaco probabilistico   ranqueamento 
         0.780          0.780          0.780 
          a aprendizado estatistico  fundamenta     moderna 
     -0.104      -0.312      -0.312      -0.312      -0.312 
```

De 3 termos para **21**. Isto é **expansão de consulta**: `bm25`, `espaco`, `probabilistico`… entram sem que a pessoa os tenha digitado. E 5 termos ficam **negativos** — as palavras de `d4`.

**Exemplos que você mostra:**

- `espaco`: $0 + 0{,}75 \cdot 1{,}040 - 0 = 0{,}780$ — termo novo, vindo só dos relevantes;
- `aprendizado`: $0 + 0 - 0{,}15 \cdot 2{,}079 = -0{,}312$ — só `d4` tem: o *feedback* negativo empurra para baixo de zero;
- `a`: $-0{,}15 \cdot 0{,}693 = -0{,}104$ — o artigo `a` (está em `d4`) também fica negativo; o Rocchio não sabe o que é *stopword*.

> **Erro previsto:** passar o texto em vez do vetor. Sinal: `rocchio("modelo de recuperacao", …)` dá *Error in a \* q: non-numeric argument to binary operator* ("argumento não numérico para operador binário"). Reação: `q` é o **vetor** `q0`; o texto vira vetor com `vetor_consulta`.

> **Erro previsto:** esquecer `ix`. Sinal: *argument "ix" is missing, with no default* ("argumento 'ix' faltando, sem padrão"). Reação: sem globais — a função recebe o índice.

> **Checkpoint 3.** *À mão: o peso de `recuperacao` em $\vec q_m$. (`q0`: $1{,}386$; `d2` e `d3`: 0; `d4`: $1{,}386$.)*
> Esperado: $1 \cdot 1{,}386 + 0{,}75 \cdot 0 - 0{,}15 \cdot 1{,}386 = 1{,}386 - 0{,}208 = 1{,}178$ — **caiu**, porque `d4` também tem `recuperacao`. Confere na saída.

> **Ponte:** consulta nova, mesmo índice: falta buscar de novo.

---

## Módulo 4 — O novo ranking
*trabalho 11 min · conversa 6 min · lembrete: previsão antes; todo código comentado*

`ranking_cosseno` recebe **texto**; agora temos um **vetor**. A função que ranqueia um vetor qualquer:

```r
ranking_vetor <- function(q, ix)                  # q: vetor de pesos no espaco de ix$vocab
  sort(apply(ix$w, 2, function(d) cosseno(q, d)), # um cosseno por coluna (apply: Aula 02)
       decreasing = TRUE)                         # do maior ao menor
round(ranking_vetor(q0, ix), 3)                   # teste: tem que dar o ranking base
```
```
   d1    d3    d4    d2    d6    d8    d5    d7 
0.254 0.233 0.215 0.208 0.025 0.023 0.000 0.000 
```

Passou no teste. Agora com $\vec q_m$ — **ele prevê antes** onde `d2` e `d4` vão parar:

```r
novo <- ranking_vetor(qm, ix)                                             # a consulta reformulada
round(novo, 3)                                                            # o novo ranking
round(rbind(base = metricas(base, grau, 2), rocchio = metricas(novo, grau, 2)), 3)  # antes e depois
```
```
    d3     d2     d1     d6     d8     d5     d7     d4 
 0.650  0.643  0.140  0.055  0.045  0.041 -0.007 -0.060 
        P_at_k  AP  RR nDCG_bin nDCG_grad
base     0.333 0.5 0.5    0.651     0.837
rocchio  0.667 1.0 1.0    1.000     1.000
```

`d2` sobe do 4º para o 2º; `d4` cai do 3º para o **último**, com **cosseno negativo**: o produto escalar com as palavras de peso negativo fica abaixo de zero. AP de $0{,}5$ para $1$; nDCG graduado $1$ — `d3 d2 d1 d6` é a ordem ideal dos graus `2 2 1 1`.

**Novo: `pmax(x, 0)`** — troca cada valor negativo por 0: `pmax(c(-1, 0.5, 2), 0)` → `[1] 0.0 0.5 2.0`.

**Exemplos que você mostra:**

- **zerando os negativos**, `ranking_vetor(pmax(qm, 0), ix)`: `d3` 0,658 · `d2` 0,652 · `d1` 0,142 · `d4` 0,096 · `d6` 0,060 · `d5` 0,046 · `d8` 0,045 · `d7` 0 — nenhum cosseno negativo; `d4` volta ao 4º;
- **só o positivo** ($D_{nr}$ vazio), `ranking_vetor(rocchio(q0, c("d2", "d3"), ix = ix), ix)`: `d3` 0,647 · `d2` 0,641 · `d1` 0,157 · `d4` 0,110 · … — quase igual ao anterior: quem tirou `d4` do 4º foi o $\gamma$.

**Explore:** `rocchio(q0, c("d2", "d3"), "d4", ix, a = 0)` — sem a consulta original: `d1` (grau 1) cai do 3º para o 6º (0,012). O $\alpha$ segura o que a pessoa digitou. Com `g = 0.5`, `d4` vai a $-0{,}417$.

> **Erro previsto:** "cosseno negativo é bug". Sinal: *"cosseno não ia de 0 a 1?"*. Reação: ia porque, até hoje, todos os pesos eram $\geq 0$. Com pesos negativos, o cosseno vai de $-1$ a $1$.

> **Checkpoint 4.** *Com `pmax`, as métricas são $\text{P@}3 = 0{,}667$, AP $1$, RR $1$, nDCG binário $1$ e graduado $0{,}990$. Por que o graduado cai e o AP não?*
> Esperado: com limiar 2, o AP só vê `d2` e `d3`, que continuam em 1º e 2º. O graduado vê também `d6` (grau 1), empurrado do 4º para o 5º por `d4` — perde um pouco de ganho descontado.

> **Ponte:** AP $= 1$. O Rocchio é perfeito? Olhe **quem** subiu.

---

## Módulo 5 — Avaliar com honestidade: a coleção residual
*trabalho 10 min · conversa 7 min · lembrete: previsão antes; o caso degenerado é lição, não erro*

Quem subiu? `d2` e `d3` — **os que o usuário marcou**, que ele já tinha visto. O "ganho" de $0{,}5$ para $1$ veio de reordenar documentos **já conhecidos**: é corrigir a prova com o gabarito à vista.

**Avaliação justa — a coleção residual:** tirar os documentos marcados ($D_r \cup D_{nr}$) **do ranking e do gabarito**, e medir o resto. A pergunta vira: *a consulta nova ajuda a achar documentos **novos**?*

```r
fora  <- c("d2", "d3", "d4")              # os que o usuario ja marcou
g_res <- grau[!names(grau) %in% fora]     # o gabarito sem eles
b_res <- base[!names(base) %in% fora]     # o ranking base sem eles
n_res <- novo[!names(novo) %in% fora]     # o ranking Rocchio sem eles
round(metricas(b_res, g_res, 2), 3)       # limiar 2: sobra algum relevante?
```
```
   P_at_k        AP        RR  nDCG_bin nDCG_grad 
        0        NA         0        NA         1 
```

**Caso degenerado:** restam `d1` (1), `d6` (1), `d5`, `d7`, `d8` — com limiar 2, **nenhum** relevante: $R = 0$, AP `NA` (a proteção do motor). Não há o que achar. Com limiar 1:

```r
round(rbind(base = metricas(b_res, g_res, 1), rocchio = metricas(n_res, g_res, 1)), 3)  # limiar 1
```
```
        P_at_k AP RR nDCG_bin nDCG_grad
base     0.667  1  1        1         1
rocchio  0.667  1  1        1         1
```

**Empate.** Base residual `d1` 0,254 · `d6` 0,025 · `d8` · `d5` · `d7`; Rocchio residual `d1` 0,140 · `d6` 0,055 · `d8` · `d5` · `d7` — mesma ordem. **Nos documentos novos, o Rocchio não mudou nada.**

**Exemplos que você mostra:** completa, AP $0{,}5 \to 1$ — parece milagre; residual com limiar 2, `NA` — o usuário marcou todos os grau 2; residual com limiar 1, $1$ e $1$ — empate. O Rocchio parece milagroso nos marcados; **medir no resto** é o que diz se ele ajuda.

> **Erro previsto:** "AP $= 1$ prova que o Rocchio é ótimo". Sinal: ele cita o $1{,}0$ da tabela completa. Reação: *"quem são os dois relevantes no topo? quem os escolheu?"* — os marcados.

> **Erro previsto:** tirar os marcados só do ranking, não do gabarito. Sinal: AP residual baixo. Reação: `d2` e `d3` continuariam contando em $R$ sem poder aparecer — o AP cai à toa.

> **Checkpoint 5.** *Outro cenário: o usuário marcou só `d3` (relevante) e `d4` (não). Quais documentos ficam na coleção residual? Existe ali algum relevante grau 2 que o Rocchio poderia "achar de novo"? Preveja: o AP residual sobe ou empata?*
> Esperado: residual `d1 d2 d5 d6 d7 d8`; `d2` (grau 2) está lá, em 2º no base residual. Ele roda `q_a <- rocchio(q0, "d3", "d4", ix)` (um documento só: o `drop = FALSE` trabalhando) e mede como acima com `fora <- c("d3", "d4")`: AP residual $0{,}5 \to 1$ — `d2` sobe para 1º. Aqui o ganho é honesto: um relevante **não marcado** subiu.

> **Ponte:** e se não houver usuário para marcar nada?

---

## Módulo 6 — Pseudo-realimentação e o *query drift*
*trabalho 10 min · conversa 7 min · lembrete: previsão antes; LaTeX; não adiante a Aula 07*

**Pseudo-realimentação** (*pseudo-relevance feedback*, PRF; ou *feedback* cego): sem usuário, **assume-se** que os top-$k$ do ranking base são relevantes — viram $D_r$, sem $D_{nr}$ — e aplica-se o Rocchio automaticamente.

```r
top   <- names(base)[1:2]                    # os 2 primeiros do base: "d1" "d3"
q_prf <- rocchio(q0, top, ix = ix)           # Dr = top-k; Dnr vazio
round(head(sort(q_prf, decreasing = TRUE), 6), 3)  # os termos de maior peso
r_prf <- ranking_vetor(q_prf, ix)            # busca de novo
round(r_prf, 3)                              # o ranking
round(metricas(r_prf, grau, 2), 3)           # as cinco, limiar 2
```
```
     modelo recuperacao          de        bm25  informacao      ordena 
      1.906       1.906       0.999       0.780       0.780       0.780 
   d3    d1    d2    d4    d6    d8    d7    d5 
0.648 0.575 0.175 0.161 0.062 0.047 0.037 0.010 
   P_at_k        AP        RR  nDCG_bin nDCG_grad 
    0.667     0.833     1.000     0.920     0.958 
```

Com $k = 2$ (`d1`, grau 1; `d3`, grau 2), o AP sobe de $0{,}5$ para $0{,}833$ **sem ninguém marcar nada**.

**Exemplos que você mostra** — $k = 3$, troque `1:2` por `1:3`: `d1`, `d3` **e `d4`**, grau 0:

- a consulta: `recuperacao` 2,079 · `modelo` 1,733 · `de` 0,823 · `aprendizado`, `bm25`, `estatistico` 0,520 — "aprendizado estatístico" entrou;
- o ranking: `d3` 0,517 · `d1` 0,501 · `d4` 0,487 · `d2` 0,168 · … — `d4` sobe para 3º;
- as métricas: $\text{P@}3 = 0{,}333$, AP $0{,}750$, RR $1$, nDCG $0{,}877$ e $0{,}925$ — piores que $k = 2$.

Um irrelevante no top-$k$ puxa a consulta para o assunto **dele**: é o ***query drift***, a deriva da consulta. Por isso: $k$ pequeno e $\beta$ moderado.

**Explore:** $k = 4$ (`1:4`) entra `d2` e o AP volta a $1$ — o *drift* depende de **quem** está no top-$k$, não só do tamanho.

**Quando usar:** consultas curtas ou ambíguas; *recall* baixo na primeira tentativa. **Custos:** uma segunda busca; o *drift*; e, na realimentação de verdade, o usuário quase nunca marca nada. Hoje a reformulação de consultas também é feita com modelos de linguagem — só para citar; é aula futura.

> **Erro previsto:** "$k$ maior é sempre melhor — mais exemplos". Sinal: ele propõe $k = 5$ "para garantir". Reação: mais exemplos **não julgados**; cada irrelevante a mais arrasta a consulta. Os números de $k = 3$ mostram.

> **Erro previsto:** achar que a PRF "sabe" o que é relevante. Sinal: *"ela usa o gabarito?"*. Reação: não — o gabarito só **mede** depois; a PRF confia no próprio ranking.

> **Checkpoint 6.** *Antes de rodar: PRF com $k = 1$ (só `d1`, grau 1). O AP sobe ou desce em relação ao base ($0{,}5$)? Por quê?*
> Esperado: desce — `d1` é grau 1 (não relevante com limiar 2) e traz `informacao`, `ordena`, `recuperacao`; `recuperacao` puxa `d4`. Ao rodar (`names(base)[1]`): `d1` 0,882 · `d4` 0,183 · `d3` 0,129 · `d2` 0,126 …; AP $0{,}417$, abaixo do base. *Drift* com um documento só.

> **Ponte:** você sabe reformular uma consulta, com e sem usuário — e medir se adiantou. O teste confirma.

---

**Funções de R apresentadas nesta aula** (o guia da Aula 07 copia esta linha): `rowMeans`, `drop = FALSE`, `!=`, `<`, `pmax`. **Funções escritas na sessão:** `rocchio`, `ranking_vetor`.

**Casos degenerados desta aula:** `rowMeans` de uma coluna sem `drop = FALSE` → erro *'x' must be an array of at least two dimensions*; $D_{nr}$ vazio → `cnr` vale 0 (por isso o `if (length(Dnr))`); cosseno negativo — não é erro; residual com $R = 0$ → AP e nDCG binário `NA`, $\text{P@}k$ e RR 0; consulta toda zerada → `cosseno` dá 0 para todos, e o "ranking" é a ordem do corpus (como os empates `d5`, `d7` do base).

---
---

# PARTE C — Teste final: uma pergunta por módulo

**Só depois do Módulo 6, antes do consolidado.** Avise: *"um teste curto — uma por módulo."* **Só estas perguntas**, só dos módulos alcançados, **uma por vez**; diga se acertou e, em uma linha, o que faltou. Não reensine.

| módulo | pergunta | esperado |
|---|---|---|
| **1** | O usuário vê o top-4 do BM25 (`d3 d1 d2 d4`) e marca com o gabarito, limiar 2, deixando sem marca o que é grau 1. Quem vai para $D_r$ e $D_{nr}$? | $D_r = \{d3, d2\}$; $D_{nr} = \{d4\}$; `d1` sem marca |
| **2** | `busca` pesa $1{,}386$ em `d5` e em `d7`. Centroide de `d5` e `d7` nesse termo? | $(1{,}386 + 1{,}386)/2 = 1{,}386$ |
| **3** | Com $\beta = 0{,}5$ e o resto igual, quanto pesa `modelo` em $\vec q_m$? | $1{,}386 + 0{,}5 \cdot 1{,}386 = 2{,}079$ |
| **4** | `d7` tem cosseno $-0{,}007$ com $\vec q_m$. Qual termo explica o sinal? | o artigo `a`: peso $-0{,}104$ em $\vec q_m$ (vem de `d4`), e é o único termo de `d7` com peso não nulo na consulta |
| **5** | Um colega reporta: "Rocchio com `d2` e `d3` marcados: nDCG $= 1$". Que objeção, e o que mediria? | mediu nos próprios marcados (otimista); medir na coleção residual, sem os marcados no ranking e no gabarito |
| **6** | Um grupo usa PRF com $k = 10$ num corpus em que cada consulta tem uns 3 relevantes. O que esperar? | pelo menos 7 irrelevantes em $D_r$: *query drift* provável; preferir $k$ pequeno |

**Resultado em uma linha:** *"acertou os módulos 1, 2, 4 e 6; 3 e 5 vão para revisão."* Errou 3 ou mais: revisar antes da Aula 07.

**Então:** *"A próxima etapa é a Parte D, do grupo: o Rocchio no gabarito de vocês, a pseudo-realimentação em todas as consultas, e a decisão de usá-la ou não no motor. Reúna o grupo e abram `GUIA_ESTUDO_aula06_parteD.md` com a ficha do projeto."*

---

## Glossário

| sigla / termo | por extenso | o que é |
|---|---|---|
| realimentação de relevância | *relevance feedback* | reformular a consulta a partir de documentos marcados |
| Rocchio | — | a fórmula $\alpha\,\vec q_0 + \beta\,\vec c_r - \gamma\,\vec c_{nr}$ (Rocchio, 1971) |
| $D_r$, $D_{nr}$ | documentos relevantes / não relevantes | os marcados pelo usuário (ou pelo gabarito) |
| centroide | — | a média dos vetores de um conjunto de documentos |
| expansão de consulta | *query expansion* | termos não digitados que entram na consulta |
| PRF | *pseudo-relevance feedback* | top-$k$ assumidos relevantes, sem usuário |
| *query drift* | deriva da consulta | a consulta puxada para o assunto de um irrelevante |
| coleção residual | — | o corpus sem os documentos já marcados, onde se avalia de forma justa |
| TF-IDF | *term frequency–inverse document frequency* | os pesos de `ix$w` (Aula 01) |
| AP / nDCG / RR / BM25 | *average precision* / *normalized DCG* / *reciprocal rank* / *Best Match 25* | métricas da Aula 5,5; modelo da Aula 04 |
| LLM | *large language model* | modelo de linguagem — a tutora |
| Colab | Google Colaboratory | onde o R roda; apaga tudo quando a sessão cai |

---

## Fechamento

Ordem fixa: **teste → oferta da Parte D → perguntas guardadas → tarefa → o que vem → consolidado → passos de fechamento.**

1. **Perguntas guardadas:** responda as curtas; encaminhe — *embeddings* são a Aula 07; reformulação com LLM, aula futura; "o ganho é significativo?", Aula 16.
2. **A tarefa** (dos slides), sem fazê-la por ele: outra consulta no corpus de 8, 1–2 relevantes marcados **por ele**, antes/depois; PRF com o top-2 dela; explicar cada bloco de código, por escrito.
3. **O que vem:** *"Hoje a consulta ganhou palavras dos relevantes — mas só palavras que estão escritas neles. A Aula 07 troca as palavras por* embeddings *e faz recuperação densa: documentos que dizem a mesma coisa com outras palavras passam a ficar perto."*
4. **Gere o consolidado** — avise que está gerando.
5. **Logo abaixo, na mesma mensagem, os passos de fechamento**, por extenso.

---

# PARTE D — está em outro arquivo

Os **Módulos 7 a 9** (Rocchio no gabarito do grupo; pseudo-realimentação em todas as consultas; a decisão) estão em `GUIA_ESTUDO_aula06_parteD.md`: **sessão do grupo**, com a ficha. O consolidado registra "Parte D: a marcar".

---

## Modelo do consolidado

**Relato sobre o aluno, em três partes — não resumo da matéria.** Meia página; teto de 2 mil palavras. **Bloco de código Markdown** (`aula06_consolidado.md`). **Nunca PDF, relatório, reexplicação ou código.** LaTeX. Primeira pessoa. **Sem a seção "Estado do R".** Nada que ele não possa ler em voz alta na turma.

```markdown
# Consolidado — PI III — Aula 06 — <data>
*guia versão 1 · tutora: <qual LLM> · sessão individual (teoria) · motor06*
**Aluno:** <nome>

## 1. O que foi passado
- M1 — o ciclo de realimentação; $D_r$ e $D_{nr}$ no ranking do cosseno
- M2 — a consulta como vetor; centroide; `rowMeans`, `drop = FALSE`
- M3 — a fórmula de Rocchio; `modelo` = 2,426 à mão; expansão: 3 → 21 termos
- M4 — o novo ranking; cosseno negativo; AP $0{,}5 \to 1$
- M5 — coleção residual: `NA` com limiar 2, empate com limiar 1
- M6 — pseudo-realimentação; $k = 2$ (AP $0{,}833$) × $k = 3$ (AP $0{,}750$): *drift*
<se parou: "parou no M4; M5–M6 não alcançados — retomar do M5">

## 2. Como foi o aprendizado — opinião da tutora
<um parágrafo, em primeira pessoa: se fez as contas de Rocchio à mão; se esbarrou no
`drop = FALSE`; se estranhou o cosseno negativo; se acreditou no AP = 1 antes do
residual; se previu o drift de $k = 1$; o que foi entregue em vez de construído.>

**Teste final:** acertou M<lista>; a revisar M<lista> — <uma linha por módulo>.

## 3. Observações para a frente
- **Revisar antes da Aula 07:** <o quê, e por quê>
- **Para a próxima tutora:** <ritmo, perfil, conforto com vetores e com o R>
- **Perguntas guardadas:** <pergunta> — <para qual aula>
- **Produzido:** `rocchio`, `ranking_vetor`; ranking Rocchio `d3 d2 d1 d6 d8 d5 d7 d4`; residual: empate; PRF $k = 2$ e $k = 3$
- **Parte D (sessão de grupo):** a marcar — com a ficha do projeto
```

## Passos de fechamento (copie logo abaixo do consolidado)

1. Copie o bloco acima e salve como **`aula06_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, envie o arquivo (pasta à esquerda → upload). Rode `list.files()`: ele tem que aparecer solto, com esse nome exato (não em `sample_data`, não `aula06_consolidado (1).md`).
3. Rode `anexar_estado("aula06_consolidado.md")`.
4. Baixe de volta (três pontinhos → *Fazer download*) e confira que a seção "Estado do R" apareceu no fim.
5. Envie ao repositório do grupo, em **`consolidados/<seu nome>/`** (*Add file → Upload files → Commit changes*; mesmo nome substitui).

Se ele disser que já fez, pergunte só: *"a seção 'Estado do R' apareceu no fim do arquivo?"*
