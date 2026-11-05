# Aula 04 — BM25: o modelo probabilístico, construído do zero

## Guia de estudo autônomo, com uma LLM como tutora

*versão 3 — 2026-10-02 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o aluno: como usar

1. Abra a LLM que você usa (ChatGPT, Claude, Gemini, o que for).
2. Cole **este arquivo inteiro** e escreva: *"Seja meu tutor nesta aula."*
3. Se você tem o **consolidado da Aula 03**, cole junto. Se não tem, ela pergunta e segue.
4. **Abra o Colab** (colab.research.google.com) → *Ambiente de execução → Alterar o tipo de ambiente de execução* → **R**. Faça isso **antes** de enviar qualquer arquivo: trocar o ambiente apaga o que já foi enviado.
5. Rode a **primeira célula**, abaixo. Tenha também uma **calculadora**: esta aula tem mais conta à mão que as anteriores — é assim que a fórmula deixa de assustar.
6. **Responda às perguntas dela.** É uma conversa, não leitura.
7. Se ela despejar texto, entregar código sem comentário, escrever uma fórmula em texto puro, ou fazer a tarefa por você, diga **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é comigo"**. É uso correto do guia — ela tende a esquecer as regras conforme a conversa cresce.

**Primeira célula do Colab:**

```r
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor04.R")  # o que veio das Aulas 00 a 03
docs <- docs_aula()          # os 8 documentos do curso
cfg  <- cfg_aula()           # as decisões canônicas: limpar = TRUE, acentos = "manter", sem stopwords
ix   <- montar(docs, cfg)    # tudo que as aulas anteriores calcularam (TDM, df, TF-IDF, índice)
estado()                     # confira: MOTOR_VERSAO "motor04 ..."
```

**Tempo:** cerca de **100 minutos** — uns 60 calculando e rodando, uns 40 conversando. Dá para parar no meio. O Colab apaga tudo quando a sessão cai: se voltar outro dia, rode a primeira célula de novo e refaça os blocos dos módulos já feitos. Três cuidados com o Colab: troque o ambiente para R **antes** de enviar arquivos; o arquivo enviado tem que ficar solto em `/content`, com o nome exato (`list.files()` confere); baixe o que produziu **antes** de fechar.

**Ao final você deve conseguir**, sem consultar nada:

- dizer os dois defeitos do TF-IDF que o BM25 corrige;
- explicar o que é *burstiness* e por que uma Poisson só não descreve palavras;
- calcular o teto de saturação do modelo 2-Poisson — e saber por que dá 2,52 e não 1,79;
- dizer por que a fórmula exata não é usada, e o que a aproximação preserva (e o que não preserva);
- ler a fórmula do BM25 símbolo a símbolo, calcular $K$ e o IDF à mão, e escrever o BM25 em R — com a linha que impede o `NaN`.

**E você terá produzido:** o ranking BM25 de `modelo de recuperacao` — `d3` 1,873, `d1` 1,869, `d2` 1,687, `d4` 1,427, `d8` 0,519, `d6` 0,492, `d5` e `d7` zero —, o escore de `d2` conferido na calculadora, e o seu consolidado com o estado do R anexado.

**Depois**, no arquivo `GUIA_ESTUDO_aula04_parteD.md` (Módulos 10–12, **sessão do grupo**, cerca de 65 min), o grupo roda o BM25 no corpus do projeto, lado a lado com o cosseno nas três consultas de trabalho, mexe em $k_1$ e $b$, e decide os dois.

---
---

# PARTE A — Instruções para a LLM

Você é tutor(a) de um aluno de graduação em Ciência de Dados, 4º semestre, estudando sozinho a Aula 04 de Projeto Integrador III — disciplina cujo projeto é construir um motor de busca em R. Ele roda o R no **Google Colab**.

Sua tarefa é **ensinar esta aula**, numa conversa. O conteúdo está na Parte B. Não é roteiro para recitar — é o material que você ensina, na ordem dada, com os números exatos dados.

## Antes de tudo: o consolidado anterior e o estado do R

Depois de cumprimentar, **peça o consolidado da Aula 03**. Se houver, leia: ele diz o que ele domina e como prefere aprender.

Se o consolidado terminar com a seção **"Estado do R ao fim da sessão"**, peça a saída do `estado()` da primeira célula e compare. A sessão do Colab é nova: os objetos da Aula 03 (`postings`, `brutos`…) **não estão mais lá, e isso é esperado**. O que conferir: `MOTOR_VERSAO` mostra `motor04`; `cfg` tem `limpar`, `acentos` e `stopwords` (vazio); `ix` tem `tokens`, `vocab`, `tf`, `N`, `df`, `idf_tfidf`, `w`, `wn`, `postings`, e `ix$vocab` tem 45 termos. Se o `estado()` deu erro, a primeira célula não rodou — resolva antes de começar (o ambiente é R? a linha do `source` foi copiada inteira?). **Você nunca escreve, resume ou corrige a seção "Estado do R"**: ela é do R.

Se não houver consolidado, não insista. Assuma que ele viu as Aulas 00 a 03 — TF-IDF, cosseno, limpeza, índice invertido — e faça o diagnóstico abaixo.

## Dois avisos, logo no início

1. Você responde em **blocos curtos** de propósito; ele pode te interromper.
2. No fim você gera um **consolidado** — um relato curto sobre como ele aprendeu — e uma lista de passos para ele salvar, anexar o estado do R e guardar.

## Tamanho das mensagens — a regra que vale acima de todas

**Curtas. Sempre.**

- **Teto de 360 palavras por mensagem.** Passou, corte: **entregue menos**, não resuma menor.
- **Uma ideia por mensagem.** "Além disso" significa que era outra mensagem.
- **Uma estrutura por mensagem:** parágrafo, ou lista, ou tabela, ou código. Nunca duas.
- **Termine com uma coisa só:** uma pergunta, ou "posso seguir?".
- Não anuncie o que vem. Não recapitule. Explicação e exercício são mensagens diferentes.
- **Código: um trecho por vez, nunca mais de 8 linhas, e a previsão da saída antes de mostrá-la.** Única exceção: a função `bm25_doc` do Módulo 9 (11 linhas) — é a fórmula do Módulo 7, uma linha por símbolo; mostre-a inteira e leia linha a linha.

**Curto não é raso.** Esta aula tem deduções: uma ideia só pode ir a 540 palavras — o cálculo de $w(0)$, por exemplo. O que não muda: uma ideia, uma estrutura, um fecho.

**Autoverificação:** mais de cinco parágrafos, você errou. Menos de dois e a explicação ficou pela metade, você também errou.

## A sequência é obrigatória

São 9 módulos, **nesta ordem, todos, e só eles:**

1. Por que ir além do TF-IDF
2. Poisson: a distribuição e os números
3. *Burstiness*: quanto uma Poisson só erra
4. *Eliteness*: duas populações e o peso do termo
5. A saturação emerge — e a conta
6. Por que não usar a fórmula exata: a aproximação
7. A fórmula do BM25: $k_1$, $b$ e $K$
8. O IDF do BM25
9. Implementando em R

**Nenhum é pulado, nenhum é acrescentado, nenhum é reordenado.** A derivação (Módulos 2–6) vem **antes** da fórmula (7) de propósito: o aluno deve ver a saturação *cair* do modelo antes de vê-la escrita. Se ele pedir a fórmula antes, diga que ela vem no Módulo 7 e por quê.

Os **Módulos 10 a 12** (a prática: BM25 no corpus do grupo, com a ficha do projeto) estão no arquivo `GUIA_ESTUDO_aula04_parteD.md` — outra sessão, de grupo. Ao dizer a rota, mencione que existem.

**Diga a rota ao aluno** logo após o diagnóstico, listando os 9 títulos. **Marque cada transição:** *"Módulo 5 de 9 — A saturação emerge."*

**Se o tempo acabar**, a sessão **para** onde estiver. Não comprima, não pule para o teste. O consolidado registra "parou no Módulo N"; a próxima sessão retoma do N+1.

## Módulos, checkpoints, pontes

Cada módulo tem orçamento (**trabalho** = ele calculando e rodando; **conversa** = você explicando), uma linha de **lembrete**, os **exemplos que você mostra**, um ou dois **erros previstos** com o sinal que os denuncia, um **checkpoint** com resposta esperada, e uma **ponte**.

- **Mostre os exemplos antes do checkpoint**, com os números que estão escritos. Não invente outros.
- **Não avance sem o checkpoint.** Resposta errada ou vaga: trabalhe nela antes.

## O ciclo de cada conta e de cada código

Conta: (1) dar os números; (2) ele calcula; (3) você confere contra o guia. Código: (1) mostrar, comentado; (2) perguntar **o que ele acha que vai sair** — e esperar; (3) ele roda numa célula do Colab; (4) comparar previsão e saída; (5) **alterar uma coisa** e repetir.

## Duas diretivas em todo pedido ao aluno

- **Só o que foi apresentado.** Checkpoint, passo "explore", teste, Parte D: nada que dependa de conceito, fórmula ou função de R que ainda não apareceu — nesta sessão, no motor, ou na lista "funções de R já apresentadas" da Parte B. Situação nova, **ferramenta conhecida**. O que esta aula traz de novo está marcado **"Novo:"** no texto; se precisar de qualquer outra coisa nova, apresente antes, em uma linha, marcada como nova — ou mude o pedido.
- **Definição → exemplos simples → só então o pedido.** Depois de enunciar uma definição ou uma proposição — a Poisson, o peso $w(f)$, a fórmula do BM25, o IDF —, mostre **você** os casos do bloco "Exemplos que você mostra", comentados. O checkpoint é a aplicação que **ele** faz sozinho — depois de ver as suas, nunca antes.

## Perguntas guardadas

Pergunta de outro módulo ou de outra aula: diga que é boa e que é de outro lugar; guarde numa lista visível (*"perguntas guardadas: 1. …"*); diga quando volta; liste todas no fechamento e no consolidado. Perguntas do mesmo tema, agrupe.

## Adaptação ao aluno

| sinal | ajuste |
|---|---|
| pergunta "e se…" | mais variações de $k_1$ e $b$ no Explore do Módulo 9 |
| pergunta "para que serve" | reforce os Módulos 1, 3 e 6 — a motivação e a decisão de engenharia |
| responde melhor a figura | ofereça a figura do Módulo 7 |
| responde rápido e certo | acelere 1–3; concentre em 5, 6, 8 e 9 |
| trava nas contas | refaça o $w(0)$ com ele, número a número; não avance com dúvida em Poisson |

O perfil vai para o consolidado.

## Tom

Sem adulação. Se a resposta foi boa, diga o que foi bom; se foi ruim, diga. Quando ele errar uma conta, **não corrija**: peça que refaça um passo por vez e ache onde divergiu.

**Quando ele quiser só a resposta:** segure uma vez, com uma linha de justificativa. Se insistir, dê — e anote no consolidado que foi entregue, não construído.

**Quando você e o guia discordarem:** **o R vence, depois o guia, depois você**, e você diz isso: *"o guia diz X; eu disse Y; o que o R mostrou?"*

## Siglas

Nenhuma sem explicação na primeira vez: sigla, nome por extenso, o que é, na mesma frase. Glossário no fim. Sigla que você introduzir fora do guia, expanda do mesmo jeito.

## Matemática: sempre em LaTeX — sem exceção

Esta é a aula com mais matemática do curso, e a regra é absoluta: **toda** expressão que você escrever vai em LaTeX — `$…$` no meio do texto, `$$…$$` em linha própria. Fórmulas inteiras **e símbolos soltos** — um $\lambda$, um $k_1$, um $f$, um $p$. Em tabelas, listas, no teste e no consolidado.

| errado | certo |
|---|---|
| `P(X=f) = e^-lambda lambda^f / f!` | `$P(X = f) = \frac{e^{-\lambda}\lambda^{f}}{f!}$` |
| `w(inf) = log(p/q) = log 6 = 1.79` | `$w(\infty) = \log\frac{p}{q} = \log 6 = 1{,}79$` |
| `K = k1 * (1 - b + b * dl/avgdl)` no texto | `$K = k_1\left(1 - b + b\,\frac{\lvert d \rvert}{\text{avgdl}}\right)$` |
| `lambda = 3, mu = 0.2` | `$\lambda = 3$, $\mu = 0{,}2$` |

**Única exceção:** código R dentro de bloco de código — ali `k1 * (1 - b + b * dl[[d]] / avgdl)` é R e fica como está.

Se você escreveu uma fórmula sem `$`, corrija antes de enviar. O guia já vem inteiro assim; **mantenha**.

## O que você não faz

- Não faz a tarefa de casa por ele (o BM25 sobre 3 consultas, a variação de $k_1$ e $b$).
- **Não inventa outro corpus nem outros parâmetros.** $\lambda = 3$, $\mu = 0{,}2$, $p = 0{,}6$, $q = 0{,}1$ são os da aula; os 8 documentos também. Trocá-los é a violação mais grave.
- **Não adianta aulas futuras.** Como *avaliar* qual ranking é melhor — com métricas como a precisão — é a **Aula 05/5,5**; o gabarito de relevância também. Se ele perguntar "mas o BM25 é melhor mesmo?", diga que essa pergunta é a próxima aula inteira e **guarde**.
- **Não reescreve funções do motor** (`preparar`, `ranking_cosseno`…): use-as. E o motor desta aula **não tem** BM25 — o BM25 é o que esta aula escreve.
- Não revela a Parte C antes do fim, e **não inventa perguntas fora da tabela**.
- **Não entrega o consolidado como relatório, PDF ou resumo da matéria.** Não escreve a seção "Estado do R".

## Como começar

Cumprimente em duas linhas. Peça o consolidado e confira o `estado()` (acima). Dê os dois avisos. Diga que são 9 módulos, uns 100 minutos, Colab e calculadora, e **liste os 9 títulos**. Então:

> 1. De Estatística Descritiva: você viu a distribuição de Poisson? O que é o $\lambda$ dela?
> 2. Da Aula 02: no ranking do cosseno para `modelo de recuperacao`, quem ficou em primeiro? Confira: `round(ranking_cosseno("modelo de recuperacao", ix, cfg), 3)`.
> 3. Quanto é $e^{-3}$, mais ou menos? (**Novo: `exp(x)`** é $e^{x}$ no R: `exp(-3)` → `[1] 0.04978707`.)

A saída da pergunta 2, do motor:

```
   d1    d3    d4    d2    d6    d8    d5    d7 
0.254 0.233 0.215 0.208 0.025 0.023 0.000 0.000 
```

| resposta | o que fazer |
|---|---|
| sabe que $\lambda$ é a média | o Módulo 2 vai rápido |
| não lembra de Poisson | normal — o Módulo 2 ensina do zero, com números |
| "d1", antes de rodar | ótimo; o Módulo 9 compara com o BM25 |
| não lembrava; viu no R | basta: `d1` primeiro, `d3` segundo |
| "uns 0,05" | tem a intuição |

**Nenhuma resposta impede a aula.**

---
---

# PARTE B — O conteúdo

## O que o aluno já sabe

### Das aulas anteriores

- **Aula 01:** o corpus de 8 documentos; TF-IDF $= \text{tf} \times \log(N/\text{df})$; `modelo` ($\text{df} = 2$) pesa 1,386; `documentos` ($\text{df} = 4$) 0,693; `de` ($\text{df} = 5$) 0,470; `de` em `d3` (2 vezes) 0,940.
- **Aula 1,5:** o $\log$ do IDF é autoinformação — raro carrega mais informação.
- **Aula 02:** cosseno; ranking `d1` 0,254, `d3` 0,233, `d4` 0,215, `d2` 0,208 para `modelo de recuperacao`; o cosseno normaliza o tamanho pela direção (divide pela norma).
- **Aula 03:** limpeza, *stopwords*, índice invertido. O índice de 37 termos usava `stopwords_aula()`; **aqui o `cfg_aula()` não tem stopwords** — os números do BM25 desta aula usam o `de` e os 45 termos.

### O motor desta aula: `motor04.R`

Carregado pela primeira célula. Copiado de `motor/CONTRATO.md` (até o `motor04`):

| função | recebe | devolve | aula |
|---|---|---|---|
| `tokenizar(texto)` | um texto | vetor de termos (minúsculas, quebra em espaços) | 00 |
| `docs_aula()` | — | os 8 documentos, vetor nomeado `d1`…`d8` | 01 |
| `matriz_tf(tokens, vocab)` | lista de tokens por documento | matriz termos $\times$ documentos (a TDM) | 01 |
| `busca_booleana(termo, tf)` | um termo e a matriz | nomes dos documentos que o têm | 01 |
| `idf_classico(tf)` | a matriz | $\log(N/\text{df})$ por termo | 01 |
| `cfg_aula()` | — | as decisões canônicas | — |
| `montar(docs, cfg)` | corpus e decisões | a lista `ix` (abaixo) | — |
| `cosseno(a, b)` | dois vetores | o cosseno; **0** se um vetor é nulo | 02 |
| `norm_cols(m)` | uma matriz | colunas com norma 1 | 02 |
| `vetor_consulta(termos, vocab, idf)` | termos da consulta | vetor de pesos no espaço do corpus | 02 |
| `ranking_cosseno(consulta, ix, cfg)` | a consulta (texto) | todos os documentos, do maior cosseno ao menor | 02 |
| `stopwords_aula()` | — | as 10 stopwords da aula | 03 |
| `limpar(x, acentos)` | texto; `"manter"` ou `"translit"` | texto limpo | 03 |
| `sem_stop(texto, stopwords, acentos)` | texto | tokens limpos, sem stopwords | 03 |
| `preparar(texto, cfg)` | texto e decisões | tokens segundo o `cfg` (limpeza + stopwords) | 03 |
| `indice_invertido(tokens)` | lista de tokens | lista termo → documentos | 03 |
| `busca_AND(consulta, ix, cfg)` | a consulta | documentos com **todos** os termos | 03 |
| `estado()`, `anexar_estado(arquivo)` | — / caminho do `.md` | a fotografia da sessão; anexa-a ao arquivo | — |

A lista `ix`:

| campo | o que é | na aula, era |
|---|---|---|
| `ix$tokens` | lista de tokens por documento | `tokens` (Aula 01) |
| `ix$vocab` | termos distintos, ordenados (45) | `vocab` |
| `ix$tf` | matriz termos $\times$ documentos | `tdm` (Aula 01) |
| `ix$N` | número de documentos (8) | `N` |
| `ix$df` | em quantos documentos cada termo aparece | `df` |
| `ix$idf_tfidf` | $\log(N/\text{df})$ | `idf` (Aulas 01–02) |
| `ix$w` | TF-IDF | `tfidf` (Aula 01), `w` (Aula 02) |
| `ix$wn` | TF-IDF com colunas unitárias | `wn` (Aula 02) |
| `ix$postings` | índice invertido | `postings` (Aula 03) |

A lista `cfg` (de `cfg_aula()`): `limpar = TRUE`, `acentos = "manter"`, `stopwords = character(0)` — os modelos canônicos mantêm o `de`.

### Funções de R base já apresentadas

- **Aula 00:** `c`, `length`, `names`, `[ ]`, `[[ ]]`, `==`, `!`, `nchar`, `toupper`, `tolower`, `substr`, `paste`, `paste0`, `1:n`, `strsplit`, `unlist`, `function`, `lapply`, `sapply`, `sum`, `list`, `table`, `factor(levels = …)`, `sort(decreasing = …)`, `%in%`, `matrix`, `rownames`, `colnames`, `dim`, `rowSums`, `colSums`, `grep`, `grepl`, `sub`, `gsub`, `trimws`, `ignore.case`; regex `^ $ | [ ] [^ ] + . * {n} {n,} \\s`; reciclagem. Parte D: `unique`, `[A-Z]`, `&`, `source` (com endereço), `list.files`, `readLines`, `writeLines`, `tail`, `estado`, `anexar_estado`.
- **Aula 01:** `unique`, função sem nome dentro de `sapply`, `as.integer`, `if`, `return`, `character(0)`, `intersect`, `log`, `ncol`, `round`, `class`, `plot` (opcional). Parte D: `install.packages`, `library`, `dir.create`, `list.files`, as funções do `httr2`, `|>`, `\(x)`, `download.file`, `source`, `rep`, `names(x) <-`, `saveRDS`, `readRDS`, `is.null`, `min`, `max`, `mean`, `file.rename`, `zip`.
- **Aula 02:** `$` (elemento de lista pelo nome), `sqrt`, `^`, `NaN` (o que `0 / 0` devolve), `sweep`, `x[condição] <- valor`, `apply`; `arrows`, `text`, `plot(type = "n", asp = 1)` (figura opcional). Parte D: `gzcon(url(…))` — ler um `.rds` direto do endereço.
- **Aula 03:** `head`, `iconv(from = "UTF-8", to = "ASCII//TRANSLIT")`, parênteses de grupo na regex `( | )`, `wordStem` (do `SnowballC`), `strsplit(x, "")`, `for`, `integer(0)`, `seq_len`, `is.na`, `ifelse`, `NULL`, `Reduce`, `all`, `lengths`; só na tarefa, `union`. Parte D: nenhuma nova.

### Da grade do curso

**Pode assumir:** distribuições discretas e a **Poisson**; probabilidade condicional, **lei da probabilidade total** e Bayes (Estatística Descritiva, 2º ciclo); limites e concavidade (Cálculo, 3º); razão de verossimilhanças como ideia (Estatística Indutiva, 3º). **Teoria do Aprendizado Estatístico** corre em paralelo e usa verossimilhança — pode citar.

**Não pode assumir:** que ele lembre a fórmula da Poisson de cor — o Módulo 2 a dá.

---

## Módulo 1 — Por que ir além do TF-IDF
*trabalho 2 min · conversa 4 min · lembrete: 360 palavras; não mostre a fórmula do BM25 ainda*

O TF-IDF tem dois defeitos:

- **A frequência cresce linearmente.** A 10ª ocorrência vale tanto quanto a 2ª. Mas num texto sobre o porto, ver "porto" pela 10ª vez não convence mais do que a 2ª — a evidência **satura**.
- **Documentos longos acumulam.** Mais palavras, mais ocorrências, escores maiores. O cosseno da Aula 02 trata isso pela direção, mas não distingue *por que* o documento é longo.

Falta um tratamento **principiado** de frequência e tamanho. A família probabilística segue o **PRP** — *Probability Ranking Principle*, o princípio de ordenar os documentos pela **probabilidade de relevância** $P(R \mid d, q)$; o BM25 é a forma prática dela que venceu.

**Não vamos apresentar a fórmula pronta.** Vamos construí-la a partir de uma pergunta estatística: *quantas vezes esperamos que uma palavra apareça num documento, e o que a contagem observada diz sobre o documento ser sobre aquele assunto?*

**Exemplos que você mostra** — com os pesos da Aula 01:

- `de` em `d1` (1 vez): $1 \times 0{,}470 = 0{,}470$; em `d3` (2 vezes): $2 \times 0{,}470 = 0{,}940$ — o dobro, só por repetir;
- se `modelo` aparecesse 10 vezes num documento: $10 \times 1{,}386 = 13{,}86$ — dez vezes o peso de uma ocorrência, sem teto;
- se `d4` fosse colado duas vezes seguidas (12 palavras, o mesmo conteúdo): `recuperacao` iria de $1{,}386$ a $2{,}773$ — o documento não ficou mais "sobre" recuperação; só ficou mais longo.

> **Erro previsto:** "o cosseno já resolve o tamanho". Sinal: ele acha que a Aula 02 bastou. Reação: o cosseno divide pela norma — trata todo documento longo igual. O BM25 vai perguntar *por que* é longo (Módulo 7). E o cosseno não faz nada com a frequência linear.

> **Checkpoint 1.** *O documento A tem 50 palavras e cita `porto` 2 vezes. O documento B é o A colado 5 vezes seguidas (250 palavras, `porto` 10 vezes). No TF-IDF, quanto B pesa a mais que A em `porto`? Qual dos dois defeitos aparece aqui?*
> Esperado: 5 vezes mais ($10$ contra $2$ ocorrências, mesmo IDF). Os dois: a frequência linear (10 vale 5 vezes 2) e o tamanho (B é longo só por repetir o mesmo conteúdo).

> **Ponte:** para modelar "quantas vezes uma palavra aparece", a estatística tem uma distribuição pronta.

---

## Módulo 2 — Poisson: a distribuição e os números
*trabalho 5 min · conversa 4 min · lembrete: numérico antes do abstrato; LaTeX; código comentado*

A Poisson modela a **contagem de eventos raros** num intervalo fixo — eventos independentes, a uma taxa média constante:

$$P(X = f) = \frac{e^{-\lambda}\,\lambda^{f}}{f!}$$

$X$ é a variável (quantas vezes ocorreu); $f$ é um valor específico ($0, 1, 2, \ldots$); $\lambda$ é a **taxa média** — o único parâmetro. Chamadas por hora, defeitos por metro — e **ocorrências de uma palavra por documento**.

**Faça-o calcular** com "porto" aparecendo em média 2 vezes ($\lambda = 2$): $e^{-2} = 0{,}135$; $P(X = 1) = 0{,}135 \times 2 = 0{,}271$. Depois, o R confere: `exp` é o $e^{x}$ do diagnóstico, `^` é a potência da Aula 02, e **Novo: `factorial(n)`** é $n!$.

```r
f <- 0:5                                  # os valores de f que vamos testar
round(exp(-2) * 2^f / factorial(f), 3)    # P(X = f) com lambda = 2, para cada f de uma vez
```
```
[1] 0.135 0.271 0.271 0.180 0.090 0.036
```

| $f$ | 0 | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|---|
| $P(X = f)$ | 0,135 | 0,271 | 0,271 | 0,180 | 0,090 | 0,036 |

Pico perto da média; cai rápido nos extremos. Ver a palavra **5 vezes** teria só 3,6%. **Guarde essa linha: é onde o modelo vai falhar.**

**Exemplos que você mostra** — variando $\lambda$:

- $\lambda = 1$: $P(0) = e^{-1} = 0{,}368$, $P(1) = 0{,}368$, $P(2) = 0{,}184$ — com média 1, ver 0 ou 1 vez é igualmente provável;
- $\lambda = 0{,}5$: $P(0) = e^{-0{,}5} = 0{,}607$ — palavra rara: na maioria dos documentos, zero;
- de $\lambda = 2$ para $\lambda = 1$, o pico anda para a esquerda: $\lambda$ é onde a massa se concentra.

> **Erro previsto:** "$\lambda = 2$ quer dizer que aparece sempre 2 vezes". Sinal: ele lê $\lambda$ como valor fixo. Reação: é a **média**; a tabela mostra a dispersão — 0 vezes tem 13,5%.

> **Checkpoint 2.** *Com $\lambda = 3$: calcule $P(X = 0)$, $P(X = 3)$ e $P(X = 6)$ (na calculadora ou com a linha de R acima, trocando o 2). Qual é o mais provável? E entre 0 e 6?*
> Esperado: $0{,}050$; $0{,}224$; $0{,}050$. O mais provável é perto da média (3); 0 e 6 ficam praticamente iguais ($0{,}0498$ e $0{,}0504$), longe do pico. (O $\lambda = 3$ volta no Módulo 5.)

> **Ponte:** se palavras fossem sorteadas independentemente, uma Poisson bastaria. Texto não é assim.

---

## Módulo 3 — *Burstiness*: quanto uma Poisson só erra
*trabalho 4 min · conversa 5 min · lembrete: 360 palavras; a tabela é o argumento*

**A observação:** palavras de **conteúdo** não se espalham uniformemente. Ou o documento **não fala** do assunto (zero ocorrências), ou fala — e então a palavra aparece **muitas vezes**. "porto" num artigo sobre praias: 0. Num artigo sobre o Porto de Santos: 8, 12, 20. O caso intermediário — exatamente 2 — é **raro**. A Poisson única prevê o oposto: muitos intermediários, quase nenhum extremo.

Isso se chama *burstiness* — as palavras vêm em rajadas.

**Quanto erra.** Compare uma **mistura** — 15% dos documentos com $\lambda = 4$, o resto com $\mu = 0{,}1$ — com uma Poisson única de **mesma média**, $0{,}15 \times 4 + 0{,}85 \times 0{,}1 = 0{,}685$:

| $f$ | mistura | Poisson única | razão |
|---|---|---|---|
| 0 | 0,772 | 0,504 | $1{,}5\times$ |
| 2 | 0,026 | 0,118 | $0{,}2\times$ |
| 4 | 0,029 | 0,005 | $6{,}3\times$ |
| 6 | 0,016 | 0,00007 | $\mathbf{216\times}$ |

Faça-o ler a última linha em voz alta: ver a palavra 6 vezes é **216 vezes mais provável** na realidade do que a Poisson única prevê. O modelo simples **não explica** os documentos que falam muito do assunto.

**Exemplos que você mostra** — lendo as outras linhas:

- $f = 0$: a mistura tem $1{,}5\times$ mais zeros — mais documentos que simplesmente não falam do assunto;
- $f = 2$: a mistura tem $0{,}2\times$ — o "meio-termo" é **cinco vezes mais raro** do que a Poisson única diz;
- $f = 4$: já $6{,}3\times$ — e a razão só cresce daí em diante. Os extremos ganham, o meio perde: é o desenho da rajada.

> **Erro previsto:** achar que a mistura são "dois documentos". Sinal: ele pergunta "quais dois?". Reação: são duas **populações** de documentos — 15% de um tipo, 85% de outro — e cada documento vem de uma delas.

> **Checkpoint 3.** *Num corpus de 1 000 documentos com essa palavra, quantos documentos com exatamente 6 ocorrências a Poisson única prevê, e quantos a mistura? Que documentos são esses?*
> Esperado: Poisson única: $1\,000 \times 0{,}00007 = 0{,}07$ — nenhum; mistura: $1\,000 \times 0{,}016 = 16$. São justamente os documentos que **falam muito** do assunto — os que um buscador mais quer achar.

> **Ponte:** se há duas populações, vamos dar nome a elas.

---

## Módulo 4 — *Eliteness*: duas populações e o peso do termo
*trabalho 4 min · conversa 6 min · lembrete: 360–540 palavras; elite ≠ relevante; LaTeX*

**A hipótese.** Para cada termo, os documentos se dividem em duas classes **ocultas**:

- **Elite** ($E$): o documento é genuinamente *sobre* aquele assunto.
- **Não-elite** ($\bar{E}$): o termo aparece de passagem.

Em cada classe a contagem é Poisson, com taxas diferentes:

$$f \mid E \sim \text{Poisson}(\lambda), \qquad f \mid \bar{E} \sim \text{Poisson}(\mu), \qquad \lambda > \mu$$

"Elite" **não é observável**: só vemos a contagem $f$.

**O peso do termo.** No modelo probabilístico, o peso é o log da razão entre ver $f$ em documentos relevantes e em irrelevantes:

$$w(f) = \log\frac{P(f \mid R)}{P(f \mid \bar{R})}$$

Supondo que a relevância afeta $f$ *apenas* através da eliteness, cada lado é uma **lei da probabilidade total** sobre as duas classes — $P(f \mid R) = P(E \mid R)\,P(f \mid E) + P(\bar{E} \mid R)\,P(f \mid \bar{E})$ — e o mesmo para $\bar{R}$:

$$w(f) = \log\frac{p\,e^{-\lambda}\lambda^{f} + (1-p)\,e^{-\mu}\mu^{f}}{q\,e^{-\lambda}\lambda^{f} + (1-q)\,e^{-\mu}\mu^{f}}$$

$p = P(E \mid R)$: chance de ser elite **dado que é relevante**. $q = P(E \mid \bar{R})$: dado que não é. Naturalmente $p > q$. Os $f!$ cancelam (estão em cima e embaixo).

**Exemplos que você mostra:**

- $p = q$: numerador e denominador são a mesma conta, $w(f) = \log 1 = 0$ para todo $f$ — se relevantes e irrelevantes são elite na mesma proporção, o termo não diz nada sobre relevância;
- $p = 1$, $q = 0$ (todo relevante é elite, nenhum irrelevante é): sobra $w(f) = \log\frac{e^{-\lambda}\lambda^{f}}{e^{-\mu}\mu^{f}}$ — a razão entre as duas Poissons: ser elite **é** ser relevante;
- os números da aula, $p = 0{,}6$ e $q = 0{,}1$: 60% dos relevantes são elite, contra 10% dos irrelevantes — o termo ajuda, mas não decide sozinho.

> **Erro previsto:** "elite = relevante". Sinal: ele usa os dois como sinônimos. Reação: **elite** é sobre o *termo* no documento ("este documento é sobre o porto"); **relevante** é sobre a *consulta* ("este documento responde ao que foi perguntado"). $p$ e $q$ são a ponte entre os dois — e o segundo exemplo é o único caso em que coincidem.

> **Checkpoint 4.** *E se $\lambda = \mu$ — documentos elite e não-elite usam a palavra na mesma taxa? O que acontece com $w(f)$, quaisquer que sejam $p$ e $q$?*
> Esperado: o numerador vira $e^{-\lambda}\lambda^{f}\,(p + 1 - p) = e^{-\lambda}\lambda^{f}$, e o denominador também; $w(f) = 0$. Se a contagem não separa elite de não-elite, ela não informa nada — nem sobre relevância.

> **Ponte:** essa fórmula tem uma propriedade que ninguém pôs nela. Vamos achá-la.

---

## Módulo 5 — A saturação emerge — e a conta
*trabalho 12 min · conversa 5 min · lembrete: ele calcula, você confere; 540 palavras para a conta; LaTeX*

**Os dois extremos.** Em $f = 0$, o peso é uma constante — normalizamos subtraindo-a, para que $w(0) = 0$. Quando $f \to \infty$, $\lambda^{f}$ domina os dois lados (pois $\lambda > \mu$) e tudo colapsa:

$$w(\infty) \to \log\frac{p}{q}$$

**A saturação não foi imposta — caiu do modelo.** Por mais que o termo se repita, a convicção de que "este documento é elite" tem **teto**.

**A conta, com ele.** $\lambda = 3$, $\mu = 0{,}2$, $p = 0{,}6$, $q = 0{,}1$. Constantes: $e^{-3} = 0{,}049787$, $e^{-0{,}2} = 0{,}818731$. Em $f = 0$ ($\lambda^0 = \mu^0 = 1$, sobram só os pesos):

$$\text{num} = 0{,}6 \times 0{,}049787 + 0{,}4 \times 0{,}818731 = 0{,}357365$$
$$\text{den} = 0{,}1 \times 0{,}049787 + 0{,}9 \times 0{,}818731 = 0{,}741837$$
$$w(0) = \log(0{,}357365 / 0{,}741837) = \log(0{,}481730) = \mathbf{-0{,}7304}$$

**Negativo.** É por isso que se normaliza.

**Exemplos que você mostra:**

- o teto cru: $w(\infty) = \log(0{,}6/0{,}1) = \log 6 = \mathbf{1{,}7918}$;
- o teto **normalizado**: $1{,}7918 - (-0{,}7304) = \mathbf{2{,}5221}$;
- $w(1)$: num $= 0{,}6 \times 0{,}049787 \times 3 + 0{,}4 \times 0{,}818731 \times 0{,}2 = 0{,}155115$; den $= 0{,}162308$; $\log(0{,}9557) = -0{,}0453$; normalizado $-0{,}0453 + 0{,}7304 = 0{,}685$.

A curva inteira, no R. **Novo: valor padrão de argumento** — `p = 0.6` na definição da função quer dizer "se não disserem `p`, vale 0,6".

```r
w2p <- function(f, p = 0.6, q = 0.1, lam = 3, mu = 0.2) {    # o peso 2-Poisson do Módulo 4
  num <- p * exp(-lam) * lam^f + (1 - p) * exp(-mu) * mu^f   # mistura, dado relevante
  den <- q * exp(-lam) * lam^f + (1 - q) * exp(-mu) * mu^f   # mistura, dado irrelevante
  log(num / den)                                             # o log da razão
}                                                            # fim da função
round(w2p(c(0, 1, 2, 3, 5, 8)) - w2p(0), 3)                  # a curva, já normalizada
```
```
[1] 0.000 0.685 2.064 2.482 2.522 2.522
```

| $f$ | 0 | 1 | 2 | 3 | 5 | 8 |
|---|---|---|---|---|---|---|
| $w(f) - w(0)$ | 0,000 | 0,685 | 2,064 | 2,482 | 2,522 | **2,522** |

Da 3ª ocorrência em diante, praticamente não acrescenta. **Congelou** no teto.

> **Erro previsto — o mais comum desta aula:** obter 1,79 como teto e parar. Sinal: *"meu teto deu 1,79"*. Reação: a conta está certa; **faltou subtrair $w(0)$**. A normalização existe para que a *ausência* do termo contribua com zero, não com $-0{,}73$.

> **Checkpoint 5.** *Mesmo modelo, mas com $q = 0{,}2$. Qual é o teto cru, qual é $w(0)$, e qual é o teto normalizado? (Confira no R com `log(3) - w2p(0, q = 0.2)`.)*
> Esperado: teto cru $\log(0{,}6/0{,}2) = \log 3 = 1{,}0986$; den $= 0{,}2 \times 0{,}049787 + 0{,}8 \times 0{,}818731 = 0{,}664942$; $w(0) = \log(0{,}357365/0{,}664942) = -0{,}6209$; normalizado $1{,}0986 + 0{,}6209 \approx 1{,}720$ (o R mostra `[1] 1.719556`). Com $q$ maior, o termo distingue menos — o teto cai.

> **Ponte:** temos a fórmula exata. Por que o BM25 não a usa?

---

## Módulo 6 — Por que não usar a fórmula exata: a aproximação
*trabalho 3 min · conversa 6 min · lembrete: 360 palavras; é uma decisão de engenharia, diga isso*

**A pergunta certa:** temos $w(f)$ exata — por que aproximar? Veja o que seria preciso saber, **para cada palavra do vocabulário**:

| parâmetro | o que é | como estimar? |
|---|---|---|
| $\lambda$ | taxa nos docs **elite** | preciso saber *quais são* elite |
| $\mu$ | taxa nos **não-elite** | idem |
| $p$ | $P(E \mid R)$ | preciso de julgamentos de **relevância** |
| $q$ | $P(E \mid \bar{R})$ | idem |

**O impasse:** eliteness é oculta — para estimar $\lambda$ eu precisaria saber quem é elite, que é o que estou tentando inferir. E $p$, $q$ exigem julgamentos que, numa busca nova, **não existem**. Mesmo que fosse possível: vocabulário da Wikipédia $\sim 2$ milhões de termos, 4 parâmetros cada — **8 milhões** de parâmetros, cada um com poucos dados. Variância enorme; o modelo decoraria ruído.

**A saída de Robertson:** para *ranquear*, não é preciso reproduzir os valores — é preciso preservar o **comportamento**:

| propriedade | por quê |
|---|---|
| $w(0) = 0$ | termo ausente não contribui |
| crescente | mais ocorrências, mais evidência |
| côncava | cada ocorrência nova vale menos |
| satura em valor finito | a convicção tem teto |

Qualquer função com essas quatro **preserva o comportamento qualitativo** — ausência vale zero, mais é melhor, cada nova vale menos, há teto. **A ordem exata dos documentos depende da forma** da função — e é isso que $k_1$ ajusta (no Módulo 9 você vê `d1` e `d3` trocarem de lugar só mudando $k_1$). A mais simples, com **um** parâmetro em vez de quatro ocultos:

$$w(f) \approx w_\infty \cdot \frac{f}{f + k_1}$$

E $w_\infty$, a importância máxima do termo, estimada sem julgamentos? Pelo **IDF**. Normalizando para $w(1) = \text{IDF}$:

$$\boxed{\;w(f) \approx \text{IDF}(t) \cdot \frac{f\,(k_1 + 1)}{f + k_1}\;}$$

**É o núcleo do BM25.** Uma honestidade: a curva 2-Poisson tem um joelho abrupto (0,685 → 2,064 entre $f = 1$ e $f = 2$); a hipérbole é suave. O erro **não é pequeno**. Vale porque é **robusta**, não porque é precisa — trocar fidelidade teórica por estabilidade prática. (*Best Match* **25**: o 25 é o número da variante numa série — BM1, BM11, BM15… — testada no sistema **Okapi**, nos anos 1990.)

**Exemplos que você mostra** — as quatro propriedades, conferidas:

- $\frac{f}{f + 1{,}2}$ em $f = 0, 1, 2, 3$: $0$; $0{,}455$; $0{,}625$; $0{,}714$ — começa em zero, cresce, os incrementos caem ($0{,}455$, $0{,}170$, $0{,}089$: côncava), e tende a 1: **passa nas quatro**;
- o TF linear, $f$: zero em zero e crescente, mas os incrementos são sempre 1 (não é côncava) e não tem teto — **falha em duas**;
- $\log(1 + f)$: $0$; $0{,}693$; $1{,}099$; $1{,}386$… côncava, mas $\log(1 + 1000) = 6{,}9$ — cresce sem teto: **falha na saturação**.

> **Erro previsto:** achar que a hipérbole foi *derivada* da 2-Poisson. Sinal: "então é a mesma fórmula simplificada". Reação: não — foi **escolhida** por ter o mesmo formato. É engenharia, não álgebra.

> **Checkpoint 6.** *Duas candidatas: $1 - 0{,}5^{f}$ e $\sqrt{f}$. Calcule em $f = 0, 1, 2, 3$ e diga qual passa nas quatro propriedades.*
> Esperado: $1 - 0{,}5^{f}$: $0$; $0{,}5$; $0{,}75$; $0{,}875$ — incrementos $0{,}5$, $0{,}25$, $0{,}125$, tende a 1: passa nas quatro. $\sqrt{f}$: $0$; $1$; $1{,}414$; $1{,}732$ — côncava, mas $\sqrt{100} = 10$: sem teto, falha na saturação.

> **Ponte:** falta corrigir pelo tamanho do documento. Aí a fórmula fica completa.

---

## Módulo 7 — A fórmula do BM25: $k_1$, $b$ e $K$
*trabalho 8 min · conversa 4 min · lembrete: ele calcula $K$; LaTeX; figura opcional*

$$\text{BM25}(q, d) = \sum_{t \in q} \text{IDF}(t) \cdot \frac{f_{t,d}\,(k_1 + 1)}{f_{t,d} + k_1\!\left(1 - b + b\,\frac{\lvert d \rvert}{\text{avgdl}}\right)}$$

**Em português:** para cada termo da consulta, multiplique o quanto ele é **raro** pelo quanto **aparece neste documento** — corrigindo pela saturação e pelo tamanho. Some tudo.

| símbolo | o que é |
|---|---|
| $q$, $d$, $t$ | consulta, documento, termo ($t \in q$) |
| $f_{t,d}$ | quantas vezes $t$ aparece em $d$ |
| $\text{df}_t$, $N$ | em quantos docs $t$ aparece; total de docs |
| $\lvert d \rvert$, $\text{avgdl}$ | tamanho de $d$ em tokens; tamanho **médio** (*average document length*) |
| $k_1$ | **parâmetro**: saturação (típico 1,2) |
| $b$ | **parâmetro**: peso do tamanho (típico 0,75) |

Só $k_1$ e $b$ são escolhidos; o resto vem do corpus.

**$k_1$.** Com $b = 0$ sobra $\frac{f(k_1+1)}{f+k_1}$. Faça-o calcular $f = 1, 2, 3$ com $k_1 = 1{,}2$: **1,000; 1,375; 1,571**. Teto $k_1 + 1 = 2{,}2$.

**$b$.** Chame de $K$ o que fica no denominador ao lado de $f$: $K = k_1\left(1 - b + b\,\frac{\lvert d \rvert}{\text{avgdl}}\right)$. **Por que $b$ interpola:** um documento é longo por duas razões opostas — **verbosidade** (mesmo conteúdo, mais palavras: deve normalizar) ou **escopo** (cobre mais assuntos: não deve). Olhando só o tamanho, não dá para saber. $0{,}75$ é o meio-termo que funciona na prática.

**$K$ em números** ($k_1 = 1{,}2$, $b = 0{,}75$, $\text{avgdl} = 8$, $f = 1$) — faça-o calcular `d4` e `d3`:

| doc | $\lvert d \rvert$ | $\lvert d \rvert / \text{avgdl}$ | $K$ | contribuição $\frac{2{,}2}{1 + K}$ |
|---|---|---|---|---|
| d4 | 6 | 0,750 | 0,975 | **1,114** |
| d1 | 7 | 0,875 | 1,087 | 1,054 |
| d6 | 8 | 1,000 | 1,200 | 1,000 |
| d3 | 9 | 1,125 | 1,312 | **0,951** |

Mesmo termo, uma vez, nos quatro. Em `d4` (curto) vale 1,114; em `d3` (longo) 0,951. Documento longo tem mais chance de conter o termo **por acaso**.

**Exemplos que você mostra:**

- `d6` tem exatamente o tamanho médio: $K = k_1 = 1{,}2$ e a contribuição é $2{,}2/2{,}2 = 1$ — o tamanho médio é a régua;
- $k_1 = 0$: $K = 0$ e $\frac{f \cdot 1}{f + 0} = 1$ para todo $f \geq 1$ — a frequência é ignorada: vira "tem ou não tem" (e $f = 0$ dá $0/0$ — guarde isso para o Módulo 9);
- $b = 0$: $K = k_1$ em **todo** documento — o tamanho deixa de contar; $b = 1$: $K = k_1\,\lvert d \rvert/\text{avgdl}$ — normalização total.

**Figura (se ele responde a imagem).** **Novo: `lines(x, y)`** acrescenta uma curva ao gráfico que o `plot` (Aula 01) já abriu.

```r
f <- 0:8                                                   # ocorrências do termo
plot(f, f, type = "b",                                     # o TF linear: uma reta
     xlab = "ocorrências (f)", ylab = "contribuição")      # nomes dos eixos
lines(f, f * 2.2 / (f + 1.2), type = "b")                  # o BM25 com k1 = 1,2: dobra e para
```

O que ele vai ver: *o TF é uma reta; a curva do BM25 dobra cedo e fica abaixo de 2,2.* Pergunte se viu.

> **Erro previsto:** "de onde saiu o $K$?". Sinal: ele acha que é variável nova do modelo. Reação: é **apelido** do parêntese do denominador vezes $k_1$. Aparece no código com esse nome.

> **Checkpoint 7.** *$\lvert d \rvert = 16$, $\text{avgdl} = 8$, $k_1 = 1{,}2$, $b = 0{,}75$: calcule $K$ e a contribuição com $f = 1$.*
> Esperado: $K = 1{,}2 \times (0{,}25 + 0{,}75 \times 2) = 1{,}2 \times 1{,}75 = 2{,}1$; contribuição $= 2{,}2 / 3{,}1 = 0{,}710$. Documento com o dobro do tamanho médio: o termo vale 71% do que valeria num médio.

> **Ponte:** falta a outra peça — o IDF do BM25 é um pouco diferente do da Aula 01.

---

## Módulo 8 — O IDF do BM25
*trabalho 8 min · conversa 3 min · lembrete: ele calcula; LaTeX*

$$\text{IDF}(t) = \log\!\left(\frac{N - \text{df}_t + 0{,}5}{\text{df}_t + 0{,}5} + 1\right)$$

$N - \text{df}_t$: em quantos documentos o termo **não** aparece. A razão é "quem não tem" sobre "quem tem" — uma **razão de chances**. Raro pesa mais, como sempre.

**Faça-o calcular** `modelo` ($\text{df} = 2$, $N = 8$): numerador $6{,}5$; denominador $2{,}5$; razão $2{,}6$; $+1 = 3{,}6$; $\ln 3{,}6 = \mathbf{1{,}281}$.

| termo | $\text{df}$ | $N - \text{df} + 0{,}5$ | $\text{df} + 0{,}5$ | razão | IDF |
|---|---|---|---|---|---|
| modelo | 2 | 6,5 | 2,5 | 2,600 | **1,281** |
| recuperacao | 2 | 6,5 | 2,5 | 2,600 | 1,281 |
| documentos | 4 | 4,5 | 4,5 | 1,000 | 0,693 |
| de | 5 | 3,5 | 5,5 | 0,636 | **0,492** |

**De onde vêm as peças.** Tire os $+0{,}5$: $\frac{N - \text{df}}{\text{df}} + 1 = \frac{N}{\text{df}}$ — o IDF vira **exatamente** o $\log(N/\text{df})$ da Aula 01. Os $+0{,}5$ vêm do peso **RSJ** (Robertson–Spärck Jones), de que o BM25 herda o IDF: são uma **suavização** — meio documento somado a cada contagem, para nenhuma estimativa se apoiar numa contagem zero. Efeito: puxam os extremos para o meio. **O $+1$:** sem ele, termo em **mais da metade** do corpus tem razão $< 1$, logo log **negativo** — `de` ficaria com $\mathbf{-0{,}452}$, e o documento seria *punido* por conter o termo buscado.

**Exemplos que você mostra** — contra a Aula 01 (`modelo` foi de $1{,}386$ a $1{,}281$: o raro desce um pouco):

- `documentos` ($\text{df} = 4 = N/2$): $\ln(4{,}5/4{,}5 + 1) = \ln 2 = 0{,}693$ — **igual** à Aula 01: na metade do corpus as duas fórmulas coincidem;
- `de` ($\text{df} = 5$): $0{,}492$ contra $0{,}470$ — o comum sobe um pouco;
- termo em **todos** os 8: $\ln(0{,}5/8{,}5 + 1) = 0{,}057$ — nem zero (Aula 01), nem negativo (sem o $+1$: $-2{,}833$).

> **Erro previsto:** calcular sem o $+1$ e achar que $-0{,}452$ é bug. Sinal: ele chega ao negativo. Reação: é exatamente o que o $+1$ existe para impedir — ele acabou de ver o motivo.

> **Checkpoint 8.** *Um termo aparece em 7 dos 8 documentos. IDF do BM25? Sem o $+1$? E sem os $+0{,}5$ (mas com o $+1$)?*
> Esperado: $1{,}5/7{,}5 = 0{,}2$; $+1 = 1{,}2$; $\ln 1{,}2 = 0{,}182$. Sem o $+1$: $\ln 0{,}2 = -1{,}609$ — negativo. Sem os $+0{,}5$: $\ln(1/7 + 1) = \ln(8/7) = 0{,}134$ — o IDF da Aula 01.

> **Ponte:** tudo entendido. Agora o código — que é a fórmula, linha a linha.

---

## Módulo 9 — Implementando em R
*trabalho 14 min · conversa 3 min · lembrete: previsão antes da saída; todo código comentado; `[[ ]]`*

O motor já tem a TDM: `ix$tf` é a matriz da Aula 01, com a limpeza do `cfg`. As linhas da consulta:

```r
ix$tf[c("modelo", "de", "recuperacao"), ]   # as linhas dos três termos da consulta
```
```
            d1 d2 d3 d4 d5 d6 d7 d8
modelo       0  1  1  0  0  0  0  0
de           1  1  2  0  0  1  0  1
recuperacao  1  0  0  1  0  0  0  0
```

O BM25 precisa de três coisas que o motor04 **não** tem. (**Novo: `mean(x)`** — a média dos valores de `x`.)

```r
dl    <- colSums(ix$tf)                                     # |d|: quantas palavras tem cada documento
avgdl <- mean(dl)                                           # avgdl: o tamanho MÉDIO
idf_b <- log((ix$N - ix$df + 0.5) / (ix$df + 0.5) + 1)      # o IDF do Módulo 8, um por termo
dl                                                          # mostra os 8 tamanhos
```
```
d1 d2 d3 d4 d5 d6 d7 d8 
 7  9  9  6  9  8  9  7 
```

`avgdl` mostra `[1] 8`. E `round(idf_b[c("modelo", "de", "recuperacao", "documentos")], 3)`:

```
     modelo          de recuperacao  documentos 
      1.281       0.492       1.281       0.693 
```

Bate com a tabela que ele calculou. **Por que `idf_b` e não `idf`:** o motor já tem um IDF, `ix$idf_tfidf` — o $\log(N/\text{df})$ do cosseno. Dois modelos, dois IDFs, **dois nomes**. Numa versão anterior deste curso os dois se chamavam `idf`, e o código do cosseno sobrescreveu o do BM25 sem ninguém perceber.

**Novo: `next`** — dentro de um `for`, pula para o próximo elemento sem rodar o resto do bloco (o `continue` do Python). Agora a fórmula do Módulo 7:

```r
bm25_doc <- function(termos, d, k1 = 1.2, b = 0.75) {   # escore BM25 de UM documento d
  s <- 0                                                 # acumulador do somatório
  for (t in termos) {                                    # a SOMA sobre os termos da consulta
    if (!t %in% ix$vocab) next                           # termo fora do vocabulário: pula
    f <- ix$tf[t, d]                                     # f: frequência do termo NESTE documento
    if (f == 0) next                                     # termo ausente: contribui 0 (por quê?)
    K <- k1 * (1 - b + b * dl[[d]] / avgdl)              # o K do Módulo 7
    s <- s + idf_b[[t]] * (f * (k1 + 1)) / (f + K)       # a contribuição do termo
  }                                                      # fim do for
  s                                                      # devolve a soma
}                                                        # fim da função
```

**Linha a linha:** `for` é o $\sum_{t \in q}$; o primeiro `next` evita *subscript out of bounds* com termo que não existe; `f` é $f_{t,d}$; `K` é o parêntese. A função lê `ix`, `dl`, `avgdl` e `idf_b` da sessão — esses nomes não podem ser reaproveitados para outra coisa.

**Pare no `if (f == 0) next`.** Pergunte: *"com $k_1 = 1{,}2$, o que muda se a tirarmos?"* Nada: $0 \times 2{,}2 / (0 + K) = 0$. Ela existe para $k_1 = 0$: aí $K = 0$ e a conta vira $0/0$ = `NaN` (*Not a Number*). É a propriedade $w(0) = 0$ do Módulo 6 em código: termo ausente vale zero **por definição**, não pela conta.

**Pare no `[[ ]]`.** `idf_b` e `dl` são **nomeados**: com colchete simples o valor volta com o nome, `s` o herda, e o `sapply` a seguir o junta ao do documento — sai `d3.modelo`, `d1.de`. A armadilha da Aula 00.

```r
consulta <- preparar("modelo de recuperacao", cfg)                     # a MESMA limpeza do índice (motor)
scores <- sapply(colnames(ix$tf), function(d) bm25_doc(consulta, d))   # um escore por documento
round(sort(scores, decreasing = TRUE), 3)                              # do maior ao menor
```

**Exemplos que você mostra** — antes do ranking:

- `bm25_doc(consulta, "d4")` → `[1] 1.426863` — só `recuperacao`, uma vez: $1{,}281 \times 1{,}114$, a linha `d4` da tabela de $K$;
- `bm25_doc(consulta, "d5")` → `[1] 0` — nenhum termo da consulta: a linha `if (f == 0) next` agiu três vezes;
- `bm25_doc("porto", "d1")` → `[1] 0` — termo fora do vocabulário: o primeiro `next`.

**Prever a ordem antes.** Depois:

```
   d3    d1    d2    d4    d8    d6    d5    d7 
1.873 1.869 1.687 1.427 0.519 0.492 0.000 0.000 
```

`d3` e `d1` no topo, quase empatados — o cosseno liderava com `d1`. E a saturação sozinha (`sat` repete o núcleo do Módulo 6; ela é vetorizada, recebe vários $f$ de uma vez):

```r
sat <- function(f, k1 = 1.2) (f * (k1 + 1)) / (f + k1)   # a saturação, sem o tamanho
round(sat(1:5), 3)                                       # f = 1 a 5
```
```
[1] 1.000 1.375 1.571 1.692 1.774
```

**Explore** — um parâmetro por vez, pelo argumento:

```r
s2 <- sapply(colnames(ix$tf), function(d) bm25_doc(consulta, d, k1 = 0.5))   # troque k1 ou b aqui
round(sort(s2, decreasing = TRUE), 3)                                        # a ordem mudou?
```

| variação | saída (os 6 primeiros; `d5` e `d7` seguem em 0) |
|---|---|
| `k1 = 0.5` | `d1` 1,831, `d3` 1,822, `d2` 1,720, `d4` 1,366, `d8` 0,508, `d6` 0,492 — **`d1` passa `d3`**: a forma muda a ordem |
| `b = 0` | `d3` 1,958, `d1` 1,773, `d2` 1,773, `d4` 1,281, `d6` 0,492, `d8` 0,492 — sem tamanho, `d6` e `d8` empatam |
| `k1 = 0` | `d1`, `d2`, `d3` empatados em 1,773; `d4` 1,281; `d6`, `d8` 0,492 — "tem ou não tem", com peso |
| `k1 = 0`, com `#` na frente de `if (f == 0) next` (redefina a função) | `named numeric(0)` |

A última linha é a lição: todo documento tem **algum** termo da consulta ausente, que dá $0/0$ = `NaN`; `NaN` somado a qualquer coisa é `NaN` (`scores` mostra oito `NaN`); e o `sort` **descarta** `NaN`. Não sobra ninguém. Recoloque a linha.

> **Erro previsto:** a saída `d3.modelo d1.de …`. Sinal: os nomes com sufixo. Reação: ele usou `idf_b[t]` ou `dl[d]` com colchete simples. `[[ ]]`.

> **Erro previsto:** `named numeric(0)`, ou um ranking com menos documentos que o esperado. Sinal: ele rodou com $k_1 = 0$ e acha que "o R quebrou". Reação: `scores` sem o `sort` mostra os `NaN`. Volte à linha `if (f == 0) next`.

> **Checkpoint 9.** *Calcule à mão o BM25 de `d2` para `modelo de recuperacao`. `d2` tem `modelo` e `de`, uma vez cada; $\lvert d \rvert = 9$.*
> Esperado: $K = 1{,}2 \times (0{,}25 + 0{,}75 \times 1{,}125) = 1{,}3125$; cada termo contribui IDF $\times\, 2{,}2/2{,}3125 = $ IDF $\times\, 0{,}951$; $(1{,}281 + 0{,}492) \times 0{,}951 = 1{,}773 \times 0{,}951 = \mathbf{1{,}687}$. Bate com o R.

> **Ponte:** BM25 pronto e conferido. O teste confirma.

---

**Funções de R apresentadas nesta aula** (o guia da Aula 05 copia esta linha): `exp`, `factorial`, valor padrão de argumento (`function(f, k1 = 1.2)`), `mean`, `next`, `lines` (opcional). Do motor, usadas pela primeira vez: `preparar`, `ranking_cosseno`, os campos `ix$tf`, `ix$N`, `ix$df`, `ix$vocab`.

**Casos degenerados desta aula:** com $k_1 = 0$ e termo ausente, $\frac{0 \cdot 1}{0 + 0}$ = `NaN`; sem a linha `if (f == 0) next`, `scores` mostra oito `NaN` e `round(sort(scores, decreasing = TRUE), 3)` mostra `named numeric(0)` (o `sort` descarta `NaN`); com a linha, $k_1 = 0$ dá **empate** `d1` = `d2` = `d3` = 1,773. Documento sem nenhum termo da consulta (`d5`, `d7`): 0, e empates em zero ficam na ordem das colunas. Consulta inteiramente fora do vocabulário: oito zeros — não é ranking, é a ordem das colunas. `ix$tf["porto", "d1"]` sem o primeiro `next`: erro *subscript out of bounds*. Termo em todos os documentos: IDF 0,057 — nem zero, nem negativo.

---
---

# PARTE C — Teste final: uma pergunta por módulo

**Só depois de o Módulo 9 estar concluído, e antes do consolidado.** Avise: *"agora um teste curto — uma pergunta por módulo."*

**As perguntas são estas, e só estas.** Só os módulos alcançados. Se você ensinou algo além do guia, isso **não** entra. **Uma por vez.** Diga se acertou e, em uma linha, o que faltou. Não reensine — anote o módulo.

| módulo | pergunta | esperado |
|---|---|---|
| **1** | Os dois defeitos do TF-IDF que o BM25 corrige? | frequência linear (sem saturação); tamanho tratado sem princípio |
| **2** | Com $\lambda = 1$, qual é mais provável: ver a palavra 1 vez ou 3 vezes? | 1 vez: $P(1) = e^{-1} = 0{,}368$; $P(3) = 0{,}368/6 = 0{,}061$ |
| **3** | O que é *burstiness*, em uma frase, e o que a Poisson única erra por causa dela? | ou a palavra não aparece, ou aparece muitas vezes; a Poisson única quase proíbe os documentos que falam muito do assunto |
| **4** | Qual é a diferença entre "elite" e "relevante"? | elite: o documento é sobre o *termo*; relevante: responde à *consulta*; $p$ e $q$ ligam os dois |
| **5** | Por que se subtrai $w(0)$ — e o que dá se não subtrair? | para a ausência do termo contribuir zero; sem isso, o teto sai 1,79 em vez de 2,52 |
| **6** | Por que a fórmula 2-Poisson exata não é usada — e a hipérbole dá a mesma ordem que ela? | 4 parâmetros ocultos por termo, inestimáveis sem saber quem é elite nem julgamentos; não: preserva o comportamento, a ordem exata depende da forma ($k_1$) |
| **7** | O que acontece com $b = 0$, $b = 1$, e por que 0,75? | ignora o tamanho; normaliza totalmente; interpola entre verbosidade e escopo |
| **8** | Um termo está em 6 dos 8 documentos. IDF do BM25, e sem o $+1$? | $\ln(2{,}5/6{,}5 + 1) = \ln 1{,}385 = 0{,}325$; sem o $+1$: $\ln 0{,}385 = -0{,}956$ — o documento seria punido por conter o termo |
| **9** | Com $k_1 = 0$ e sem a linha `if (f == 0) next`, o que o R mostra para o ranking, e por quê? | `named numeric(0)`: termo ausente dá $0/0$ = `NaN`, o `NaN` contamina a soma de todo documento, e o `sort` descarta `NaN` |

**Ao terminar, o resultado em uma linha:** *"acertou os módulos 1, 2, 3, 4, 7, 8 e 9; 5 e 6 vão para revisão."* Isso entra no consolidado.

- **Errou 3 ou mais:** recomende revisar antes da Aula 05.
- **Errou 2 ou menos:** *"Você construiu o BM25."*

**Então diga:** *"A próxima etapa é a Parte D — do grupo: rodar o BM25 no corpus do projeto, compará-lo com o cosseno nas consultas de trabalho, e decidir $k_1$ e $b$. Reúna o grupo, abram `GUIA_ESTUDO_aula04_parteD.md` com a ficha do projeto."* Depois, fechamento.

---

## Glossário

| sigla / termo | por extenso | o que é |
|---|---|---|
| BM25 | *Best Match 25* | modelo probabilístico de ranqueamento; o 25 é o número da variante |
| Okapi | — | o sistema de busca experimental em que o BM25 foi criado (Robertson e colegas, anos 1990) |
| PRP | *Probability Ranking Principle* | ordenar os documentos por $P(R \mid d, q)$; a família de que o BM25 vem |
| TF-IDF | *term frequency – inverse document frequency* | $\text{tf} \times \log(N/\text{df})$: o peso das Aulas 01–02 |
| IDF (BM25) | — | $\log\!\left(\frac{N - \text{df} + 0{,}5}{\text{df} + 0{,}5} + 1\right)$; razão de chances suavizada |
| RSJ | Robertson–Spärck Jones | peso probabilístico de termo de onde vêm os $+0{,}5$ do IDF do BM25 |
| *burstiness* | — | palavras de conteúdo vêm em rajadas: ou zero, ou muitas |
| *eliteness* | — | classe oculta: o documento é genuinamente sobre o termo |
| 2-Poisson | — | duas Poissons, uma por classe ($\lambda$ elite, $\mu$ não-elite) |
| avgdl | *average document length* | tamanho médio dos documentos do corpus |
| NaN | *Not a Number* | o resultado de $0/0$ no R; contamina toda soma; o `sort` o descarta |
| MAP | *mean average precision* | uma métrica de avaliação de rankings (Aula 5,5) |
| nDCG | *normalized discounted cumulative gain* | outra métrica de avaliação, com graus de relevância (Aula 5,5) |
| LLM | *large language model* | modelo de linguagem — a tutora que está lendo isto |
| Colab | Google Colaboratory | onde o R roda, no navegador; apaga tudo quando a sessão cai |

---

## Fechamento

Ordem fixa: **teste → oferta da Parte D → perguntas guardadas → tarefa → o que vem → consolidado → passos de fechamento.**

1. **Perguntas guardadas:** responda as curtas; encaminhe as outras — "qual ranking é melhor, o do cosseno ou o do BM25?" é a Aula 05/5,5 inteira.
2. **A tarefa**, sem fazê-la por ele: BM25 sobre o corpus de 8 para **3 consultas**; comparar com `ranking_cosseno` do motor; variar $k_1$ e $b$ e observar a ordem.
3. **O que vem:** *"Você tem dois rankings para a mesma consulta — o cosseno põe `d1` primeiro, o BM25 põe `d3`. Qual está certo? Não dá para responder olhando. A Aula 05 constrói o **gabarito**: julgar quais documentos são relevantes, antes de ver qualquer ranking — e a Aula 5,5 mede os dois contra ele, com precisão, MAP (*mean average precision*) e nDCG (*normalized discounted cumulative gain*)."*
4. **Gere o consolidado** — avise que está gerando.
5. **Logo abaixo do consolidado, na mesma mensagem, escreva os passos de fechamento** — os cinco abaixo, por extenso, mesmo que ele já os conheça.

---

# PARTE D — está em outro arquivo

A prática — **Módulos 10 a 12**: o BM25 no corpus do grupo, lado a lado com o cosseno nas três consultas de trabalho, a variação de $k_1$ e $b$, e a decisão dos dois no `config.R` — está em `GUIA_ESTUDO_aula04_parteD.md`. É **outra sessão, do grupo** (cerca de 65 minutos), com a ficha do projeto.

Depois do teste, diga ao aluno que a Parte D é em grupo e precisa da ficha. O consolidado individual registra "Parte D: sessão de grupo, a marcar".

---

## Modelo do consolidado

**Relato sobre o aluno, em três partes — não resumo da matéria.** Meia página é o normal; 2 mil palavras é o teto. **Bloco de código Markdown**, para ele salvar como `aula04_consolidado.md`. **Nunca PDF, nunca relatório, nunca reexplicação, nunca código.** Matemática em LaTeX. Opine em primeira pessoa. **Não escreva a seção "Estado do R"** — o R a acrescenta depois.

**Privacidade:** registra como ele aprende, nunca capacidade; nada que ele não possa ler em voz alta na frente da turma.

```markdown
# Consolidado — PI III — Aula 04 — <data>
*guia versão 3 · tutora: <qual LLM> · sessão individual (teoria) · motor04*
**Aluno:** <nome>

## 1. O que foi passado
- M1 — os dois defeitos do TF-IDF
- M2 — Poisson; tabela com $\lambda = 2$
- M3 — burstiness; a mistura erra $216\times$ em $f = 6$
- M4 — eliteness; $w(f)$ como razão de verossimilhanças; $p > q$
- M5 — saturação emerge; $w(0) = -0{,}7304$, teto $2{,}5221$
- M6 — 4 parâmetros ocultos; as quatro propriedades; a hipérbole; o núcleo do BM25
- M7 — a fórmula; $k_1$, $b$, $K$; $K$ em números
- M8 — IDF do BM25; $+0{,}5$ (RSJ) e $+1$; `de` = 0,492
- M9 — `bm25_doc`; `[[ ]]`; `if (f == 0) next`; ranking `d3`, `d1`, `d2`, `d4`
<se parou por tempo: "parou no M5; M6–M9 não alcançados — retomar do M6">

## 2. Como foi o aprendizado — opinião da tutora
<um parágrafo direto, em primeira pessoa: quanto de Poisson ele trouxe; se fez a conta
de $w(0)$ sozinho; se caiu no 1,79; se distinguiu elite de relevante; se aceitou a
aproximação como engenharia ou insistiu em "derivar"; se calculou $K$ e o IDF sozinho;
se entendeu o NaN com $k_1 = 0$; se o `[[ ]]` foi reconhecido da Aula 00; o que foi
entregue em vez de construído.>

**Teste final:** acertou M<lista>; a revisar M<lista> — <uma linha por módulo, o que faltou>.

## 3. Observações para a frente
- **Revisar antes da Aula 05:** <o quê, e por quê>
- **Para a próxima tutora:** <ritmo, perfil, conforto com probabilidade e com contas longas, com o Colab>
- **Perguntas guardadas:** <pergunta> — <para qual aula>
- **Produzido:** ranking BM25 <valores>; `d2` conferido à mão: <valor>; variações de $k_1$/$b$ exploradas: <quais>
- **Parte D (sessão de grupo):** a marcar — com a ficha do projeto
```

## Passos de fechamento (copie logo abaixo do consolidado)

1. Copie o bloco acima e salve no seu computador como **`aula04_consolidado.md`** (Bloco de Notas → *Salvar como* → tipo "Todos os arquivos", codificação UTF-8).
2. No Colab, **sem fechar a sessão**, envie o arquivo: pasta à esquerda → ícone de upload. Rode `list.files()` e confira que ele aparece solto, com esse nome exato (não dentro de `sample_data`, não como `aula04_consolidado (1).md`).
3. Rode `anexar_estado("aula04_consolidado.md")`.
4. Baixe o arquivo de volta: três pontinhos ao lado dele → *Fazer download*. Abra e confira que a seção "Estado do R" apareceu no fim.
5. Envie ao repositório do grupo, em **`consolidados/<seu nome>/`** (no GitHub: abra a pasta → *Add file → Upload files* → *Commit changes*).

Se ele disser que já fez, pergunte só: *"a seção 'Estado do R' apareceu no fim do arquivo?"*
