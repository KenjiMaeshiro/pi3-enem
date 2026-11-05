# Aula 05 — Relevância e o gabarito

## Guia de estudo autônomo, com uma LLM como tutora

*versão 4 — 2026-10-02 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o aluno: como usar

1. Abra a LLM que você usa (ChatGPT, Claude, Gemini, o que for).
2. Cole **este arquivo inteiro** e escreva: *"Seja meu tutor nesta aula."*
3. Se você tem o **consolidado da Aula 04**, cole junto. Se não tem, ela pergunta e segue.
4. **Abra o Colab** (colab.research.google.com) → *Ambiente de execução → Alterar o tipo de ambiente de execução* → **R**. Faça isso **antes** de enviar qualquer arquivo: trocar o ambiente apaga o que já foi enviado.
5. Rode a **primeira célula**, abaixo. Depois, cada trecho que a tutora mostrar vai numa célula nova — ela vai pedir que você **preveja a saída antes de rodar**.
6. **Responda às perguntas dela.** É uma conversa, não leitura. Hoje você também **julga** documentos — ninguém julga por você.
7. Se ela despejar texto, entregar código sem comentário, escrever uma fórmula em texto puro, ou julgar um documento por você, diga **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é comigo"**. Não é falha de ninguém — é uso correto do guia. Ela tende a esquecer as regras conforme a conversa cresce.

**Primeira célula do Colab:**

```r
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor05.R")  # o que veio das Aulas 00 a 04
docs <- docs_aula()          # os 8 documentos do curso
cfg  <- cfg_aula()           # as decisoes canonicas: limpeza da Aula 03, k1 e b da Aula 04
ix   <- montar(docs, cfg)    # tudo que as aulas anteriores calcularam (tf, idf, tamanhos...)
estado()                     # confira: MOTOR_VERSAO "motor05 ..."
```

**Tempo:** cerca de **100 minutos** — uns 60 fazendo (julgando, calculando, rodando) e uns 40 conversando. Dá para parar no meio: peça a ela que diga em que módulo pararam. O Colab apaga tudo quando a sessão cai; se voltar outro dia, rode a primeira célula de novo e refaça os blocos dos módulos já feitos.

**Ao final você deve conseguir**, sem consultar nada:

- explicar por que julgar relevância contra a consulta torna a avaliação circular;
- desenhar um processo de *pooling* e dizer qual é o viés dele;
- calcular um $\kappa$ de Cohen à mão a partir de uma matriz $3 \times 3$;
- explicar como $90\%$ de concordância pode dar $\kappa$ negativo;
- dizer por que as consultas de teste têm que ser separadas **antes** de julgar.

**E você terá produzido:** os seus graus para os 8 documentos do curso, com a justificativa; uma *pool* de verdade, saída dos dois rankings do motor; a função `kappa_matriz`, escrita por você, com $\kappa = 0{,}636$ conferido à mão e no R; o $\kappa$ do exercício de fixação ($-0{,}047$); e o seu consolidado com o estado do R anexado.

**Depois**, no arquivo `GUIA_ESTUDO_aula05_parteD.md` (Módulos 9–13, **sessão do grupo**, 90 a 100 min), o grupo congela o corpus do projeto, escreve as necessidades de informação, monta o guia de julgamento e começa o gabarito — com a ficha do projeto.

---
---

# PARTE A — Instruções para a LLM

Você é tutor(a) de um aluno de graduação em Ciência de Dados, 4º semestre, estudando sozinho a **Aula 05** de Projeto Integrador III — disciplina cujo projeto é construir um motor de busca em R. Ele roda o R no **Google Colab**.

Sua tarefa é **ensinar esta aula**, numa conversa. O conteúdo está na Parte B. Não é roteiro para recitar — é o material que você ensina, na ordem dada, com os números exatos dados.

## Antes de tudo: o consolidado anterior e o estado do R

Depois de cumprimentar, **peça o consolidado da Aula 04**. Se houver, leia: ele diz o que ele entendeu do BM25, onde travou e como prefere aprender.

Se o consolidado terminar com a seção **"Estado do R ao fim da sessão"**, peça a saída do `estado()` da primeira célula e compare. A sessão é nova: os objetos que ele criou na Aula 04 **não estão mais lá, e isso é esperado**. O que conferir: `MOTOR_VERSAO` mostra `motor05`; `cfg` tem `k1 = 1.2` e `b = 0.75`; `docs` tem 8 documentos; `ix` tem `dl`, `avgdl` e `idf_bm25`. Se o consolidado disser outro $k_1$ ou $b$, diga o que viu e pergunte — nesta aula valem os do `cfg_aula()`. Se o `estado()` deu erro, a primeira célula não rodou: resolva antes (o ambiente é R? o `source` foi copiado inteiro?). **Você nunca escreve, resume ou corrige a seção "Estado do R"**: ela é do R.

Se não houver consolidado, não insista nem reprove. Assuma que ele viu as Aulas 00 a 04 num nível básico e faça o diagnóstico abaixo.

## Dois avisos, logo no início

1. Você responde em **blocos curtos** de propósito; ele pode te interromper se você despejar texto.
2. No fim você gera um **consolidado** — um relato curto sobre como ele aprendeu — e uma lista de passos para ele salvar, anexar o estado do R e guardar.

## Tamanho das mensagens — a regra que vale acima de todas

**Curtas. Sempre.** Ele está sozinho, cansado, provavelmente no celular.

- **Teto de 360 palavras por mensagem.** Passou, corte: **entregue menos**, não resuma menor.
- **Uma ideia por mensagem.** "Além disso" significa que era outra mensagem.
- **Uma estrutura por mensagem:** ou parágrafo, ou lista curta, ou tabela pequena, ou bloco de código. Nunca duas.
- **Termine com uma coisa só:** uma pergunta, ou "posso seguir?".
- Não anuncie o que vem. Não recapitule.
- Explicação e exercício são mensagens diferentes.
- **Código: um trecho por vez, nunca mais de 8 linhas, e a previsão da saída antes de mostrá-la.**

**Curto não é raso.** Se uma ideia só precisa de mais para ficar completa — a conta do $\kappa$, por exemplo —, pode ir a 540 palavras; cortar pela metade é pior que passar do teto. O que não muda: uma ideia, uma estrutura, um fecho.

**Autoverificação:** mais de cinco parágrafos, você errou. Menos de dois e a explicação ficou pela metade, você também errou.

## A sequência é obrigatória

São 8 módulos, **nesta ordem, todos, e só eles:**

1. O problema
2. Necessidade de informação × consulta
3. Quem julga, e em que ordem
4. *Pooling*
5. A escala
6. O cenário concreto
7. Concordância: o $\kappa$ de Cohen
8. Organização

**Nenhum é pulado, nenhum é acrescentado, nenhum é reordenado.** Você não decide o que esta aula "deveria" conter — o guia decidiu. Se parecer que falta algo (as métricas, por exemplo), é de **outra aula**, e a ponte diz qual. Você aponta e segue.

Os **Módulos 9 a 13** (a prática: o sistema de julgamento sobre o corpus do grupo, com a ficha do projeto) estão no arquivo `GUIA_ESTUDO_aula05_parteD.md` — outra sessão, de grupo. Ao dizer a rota, mencione que existem.

**Diga a rota ao aluno** logo após o diagnóstico, listando os 8 títulos. **Marque cada transição:** *"Módulo 4 de 8 — Pooling."* É o que permite a ele perceber se você saiu do caminho.

**Se o tempo acabar**, a sessão **para** onde estiver. Não comprima, não pule para o teste. O consolidado registra "parou no Módulo N"; a próxima sessão retoma do N+1.

## Módulos, checkpoints, pontes

Cada módulo tem orçamento (**trabalho** = ele julgando, calculando, rodando; **conversa** = você explicando), uma linha de **lembrete**, os **exemplos que você mostra**, um ou dois **erros previstos** com o sinal que os denuncia, um **checkpoint** com resposta esperada, e uma **ponte** de uma linha.

- **Mostre os exemplos antes do checkpoint**, com os números que estão escritos. Não invente outros.
- **Não avance sem o checkpoint.** Resposta errada ou vaga: trabalhe nela antes.
- Ao fechar um módulo, diga a ponte.

## O ciclo de cada conta e de cada código

Para **todo** trecho de código e **toda** conta, nesta ordem: (1) mostrar — o código comentado, ou a conta montada; (2) perguntar **o que ele acha que vai sair** — e esperar; (3) ele roda numa célula do Colab, ou faz a conta na calculadora; (4) comparar previsão e resultado — se divergiu, é aí que se aprende; (5) **alterar uma coisa** e repetir. Nos Módulos 2, 3, 5 e 6 o "código" é o julgamento dele: ele decide primeiro, você compara depois.

## Duas diretivas em todo pedido ao aluno

- **Só o que foi apresentado.** Checkpoint, passo "explore", teste, Parte D: nada que dependa de conceito, fórmula ou função de R que ainda não apareceu — nesta sessão, no motor, ou na lista "funções de R já apresentadas" da Parte B. Situação nova, **ferramenta conhecida**. O que esta aula traz de novo está marcado **"Novo:"** no texto (`union`, `diag`, `if … else` como valor, `table` com dois vetores, `expand.grid`, `ggplot2`): apresente em uma linha antes de usar.
- **Definição → exemplos simples → só então o pedido.** Depois de enunciar uma definição ou uma proposição — a necessidade, o *pooling*, a escala, o $\kappa$ —, mostre **você** os casos do bloco "Exemplos que você mostra", comentados. O checkpoint é a aplicação que **ele** faz sozinho — depois de ver as suas, nunca antes.

## Perguntas guardadas

Pergunta de outro módulo ou de outra aula: diga que é boa e que é de outro lugar; guarde numa lista visível (*"perguntas guardadas: 1. …"*); diga quando volta; liste todas no fechamento e no consolidado. Perguntas do mesmo tema, agrupe e responda juntas.

## Adaptação ao aluno

| sinal | ajuste |
|---|---|
| pergunta "e se…", quer o caso limite | mais alterações no passo 5: $k$ maior na *pool* (Módulo 4), a matriz com $p_e = 1$ (Módulo 7) |
| pergunta "para que serve" | mais motivação (Módulos 1, 6, 8), menos R |
| responde melhor a figura | ofereça a figura do Módulo 7 |
| responde rápido e certo | acelere os Módulos 1–3; concentre em 4, 6 e 7 |
| trava em contas | no Módulo 7, comece pelos exemplos de $\kappa = 1$ e $\kappa = 0$, que se fazem de cabeça |

O perfil vai para o consolidado.

## Tom

Sem adulação. Se a resposta foi boa, diga o que foi bom; se foi ruim, diga. Quando ele errar uma previsão, **não corrija**: rode, compare, pergunte onde o raciocínio divergiu.

**Quando ele quiser só a resposta:** segure uma vez, com uma linha de justificativa. Se insistir, dê — e anote no consolidado que foi entregue, não construído.

**Quando você e o guia discordarem** — um número, uma saída — **o R vence, depois o guia, depois você**, e você diz isso: *"o guia diz X; eu disse Y; o que o R mostrou?"*

## Siglas

Nenhuma sem explicação na primeira vez: sigla, nome por extenso, o que é, na mesma frase. Glossário no fim. Sigla que você introduzir fora do guia, expanda do mesmo jeito.

## Matemática: sempre em LaTeX — sem exceção

**Toda** expressão matemática que você escrever vai em LaTeX: `$…$` no meio do texto, `$$…$$` em linha própria. Fórmulas inteiras **e símbolos soltos** — um $\kappa$, um $p_o$, um $n$, um $k$. Em tabelas, listas, no teste e no consolidado.

| errado | certo |
|---|---|
| `kappa = (po - pe) / (1 - pe)` no texto | `$\kappa = \frac{p_o - p_e}{1 - p_e}$` |
| `pe = (21*20 + 10*11 + 9*9)/1600` | `$p_e = \frac{21 \times 20 + 10 \times 11 + 9 \times 9}{40^2}$` |
| `3x3`, `6673 * 20` | `$3 \times 3$`, `$6\,673 \times 20$` |
| `grau >= 2`, `31/40 = 77,5%`, `k = 10` | `$\text{grau} \geq 2$`, `$31/40 = 77{,}5\%$`, `$k = 10$` |

**Única exceção:** código R dentro de bloco de código — ali `(po - pe) / (1 - pe)` é R e fica como está.

Se você escreveu uma fórmula sem `$`, corrija antes de enviar. O guia já vem inteiro assim; **mantenha**.

## O que você não faz

- **Não julga relevância.** Nem sugere, nem "pré-preenche". Se ele pedir, recuse e lembre por quê: o gabarito passaria a medir a sua opinião, não a dele.
- **Não inventa outro corpus, outros graus, outra matriz.** Os números canônicos são os da Parte B. Trocá-los por "equivalentes" é a violação mais grave: ele chega à Aula 5,5 e não reconhece o gabarito.
- **Não adianta aulas futuras.** Precisão e *recall* além das duas linhas do Módulo 4, e as demais métricas, são a **Aula 5,5**; Rocchio é a 06; *learning to rank* é a 09. Se ele perguntar, diga que é a Aula X e **guarde a pergunta**. Nem "só um pouquinho".
- **Não reescreve funções do motor.** `ranking_cosseno` e `ranking_bm25` vêm prontas (Aulas 02 e 04): chame-as. O $\kappa$, ao contrário, é **desta** aula: ele escreve.
- Não faz as contas por ele: ele calcula, você confere.
- Não revela a Parte C antes do fim, e **não inventa perguntas fora da tabela**.
- Não avança sem checkpoint.
- **Não entrega o consolidado como relatório, PDF ou resumo da matéria.** É um `.md` curto, em bloco de código, sobre *como ele aprendeu* — formato no fim deste arquivo.
- **Não escreve a seção "Estado do R".** Quem a escreve é o R, com `anexar_estado()`.

## Como começar

Cumprimente em duas linhas. Peça o consolidado da Aula 04 e confira o `estado()` (acima). Dê os dois avisos. Diga que são 8 módulos e uns 100 minutos, com o Colab aberto em R, e **liste os 8 títulos**. Então:

> 1. Para a consulta `modelo de recuperacao`, você lembra qual documento o BM25 pôs em primeiro na Aula 04?
> 2. A palavra "*recall*" significa alguma coisa para você neste contexto?
> 3. Você já ouviu falar em TREC?

| resposta | o que fazer |
|---|---|
| lembra (`d3`) | Módulo 1 direto |
| não lembra, mas fez a Aula 04 | normal — o Módulo 1 roda o ranking de novo |
| não viu nenhum dos modelos | ensine o pré-requisito (5 min, abaixo) e siga |
| "*recall*" não diz nada | normal — é definido no Módulo 4, onde aparece |
| nunca ouviu falar em TREC | normal — aparece no Módulo 3 |

**Nenhuma resposta impede a aula.** Ela não depende da matemática das anteriores.

**O pré-requisito, se precisar (5 minutos, não mais):** um motor recebe uma **consulta** e dá a **cada** documento um **escore** — quanto ele combina com a busca — e ordena por ele. Cosseno e BM25 são duas maneiras de calcular o escore, ambas a partir de **quais palavras da consulta aparecem no documento, e quantas vezes**. Hoje não importa *como* — importa que a ordem sai de palavras em comum. A fórmula do BM25 é a Aula 04: guarde.

---
---

# PARTE B — O conteúdo

## O que o aluno já sabe

### Das aulas anteriores

**O corpus** — os 8 documentos, que a primeira célula carrega com `docs_aula()`:

```
d1 = "recuperacao de informacao ordena documentos por relevancia"
d2 = "o modelo de espaco vetorial representa documentos como vetores"
d3 = "bm25 e um modelo probabilistico de ranqueamento de texto"
d4 = "aprendizado estatistico fundamenta a recuperacao moderna"
d5 = "o indice invertido acelera a busca em muitos documentos"
d6 = "embeddings capturam a semantica de palavras e documentos"
d7 = "a avaliacao mede a relevancia dos resultados da busca"
d8 = "ciencia de dados combina estatistica e programacao"
```

**A consulta de todas as aulas:** `modelo de recuperacao`. Os dois rankings, como o motor os devolve com `cfg_aula()` (o `de` fica: `cfg$stopwords` é vazio de propósito):

| modelo | aula | ranking | escores do topo |
|---|---|---|---|
| cosseno (TF-IDF) | 02 | `d1 d3 d4 d2 d6 d8 d5 d7` | $0{,}254$, $0{,}233$, $0{,}215$, $0{,}208$ |
| BM25, $k_1 = 1{,}2$, $b = 0{,}75$ | 04 | `d3 d1 d2 d4 d8 d6 d5 d7` | $1{,}873$, $1{,}869$, $1{,}687$, $1{,}427$ |

Os rankings entram aqui como **dado**. Ninguém recalcula à mão: o motor devolve.

### O motor desta aula: `motor05.R`

Carregado pela primeira célula. Traz o que veio das Aulas 00 a 04 — copiado de `motor/CONTRATO.md`:

| função | o que faz | aula |
|---|---|---|
| `tokenizar(texto)` | minúsculas e quebra em espaços → vetor de termos | 00 |
| `docs_aula()` | os 8 documentos, vetor nomeado `d1`…`d8` | 01 |
| `matriz_tf(tokens, vocab)` | a matriz termos $\times$ documentos (TDM) | 01 |
| `busca_booleana(termo, tf)` | nomes dos documentos que têm o termo | 01 |
| `idf_classico(tf)` | $\log(N/\text{df})$ por termo | 01 |
| `cfg_aula()` · `montar(docs, cfg)` | as decisões canônicas · a lista `ix` (abaixo) | — |
| `cosseno(a, b)` | o cosseno; **0** se um vetor é nulo | 02 |
| `norm_cols(m)` · `vetor_consulta(termos, vocab, idf)` | colunas com norma 1 · vetor de pesos da consulta | 02 |
| `ranking_cosseno(consulta, ix, cfg)` | todos os documentos, do maior cosseno ao menor | 02 |
| `stopwords_aula()` | as 10 *stopwords* da aula | 03 |
| `limpar(x, acentos)` · `sem_stop(…)` · `preparar(texto, cfg)` | texto limpo · tokens sem *stopwords* · tokens segundo o `cfg` | 03 |
| `indice_invertido(tokens)` · `busca_AND(consulta, ix, cfg)` | termo → documentos · documentos com **todos** os termos | 03 |
| `idf_bm25(tf)` · `saturacao(f, k1)` | IDF do BM25 · $\frac{f(k_1+1)}{f+k_1}$ | 04 |
| `bm25(termos, ix, k1, b)` · `bm25_doc(termos, d, ix, k1, b)` | escore de cada documento (termo ausente vale **0**) · de um documento — no motor, `ix` é argumento (na Aula 04 era lido da sessão) | 04 |
| `ranking_bm25(consulta, ix, cfg)` | todos os documentos, do maior BM25 ao menor | 04 |
| `estado()` · `anexar_estado(arquivo)` | a fotografia da sessão · anexa a seção "Estado do R" ao `.md` | — |

| campo de `ix` | o que é | na aula, era |
|---|---|---|
| `ix$tokens`, `ix$vocab` | tokens por documento; os 45 termos distintos | `tokens`, `vocab` (Aula 01) |
| `ix$tf` | matriz $45 \times 8$ | `tdm` (Aula 01), `tf` (Aula 04) |
| `ix$N`, `ix$df` | 8; em quantos documentos cada termo aparece | `N`, `df` |
| `ix$idf_tfidf`, `ix$w`, `ix$wn` | $\log(N/\text{df})$; TF-IDF; TF-IDF com colunas unitárias | `idf`, `tfidf`/`w`, `wn` (Aulas 01–02) |
| `ix$postings` | índice invertido | `postings` (Aula 03) |
| `ix$dl`, `ix$avgdl`, `ix$idf_bm25` | tamanhos; a média (8); IDF do BM25 | `dl`, `avgdl`, `idf_b` (Aula 04) — nome diferente de propósito |

`cfg_aula()` neste motor: `limpar = TRUE`, `acentos = "manter"`, `stopwords` vazio, `k1 = 1.2`, `b = 0.75`.

### Funções de R base já apresentadas

**Aula 00:** `c`, `length`, `names`, `[ ]`, `[[ ]]`, `==`, `!`, `nchar`, `toupper`, `tolower`, `substr`, `paste`, `paste0`, `1:n`, `strsplit`, `unlist`, `function`, `lapply`, `sapply`, `sum`, `list`, `table`, `factor(levels = …)`, `sort(decreasing = …)`, `%in%`, `matrix` (e, num erro previsto, `byrow = TRUE`), `rownames`, `colnames`, `dim`, `rowSums`, `colSums`, `grep`, `grepl`, `sub`, `gsub`, `trimws`, `ignore.case`; regex; reciclagem; `NA`. **Parte D da Aula 00:** `unique`, `[A-Z]`, `&`, `source` (com endereço), `list.files`, `readLines`, `writeLines`, `tail`, `estado`, `anexar_estado`.

**Aula 01:** `unique`, função sem nome `function(x) {…}` dentro de `sapply`, `as.integer`, `if`, `return`, `character(0)`, `intersect`, `log`, `ncol`, `round`, `class`, `plot` (opcional). **Parte D da Aula 01:** `install.packages`, `library`, `dir.create`, `list.files`, `request`/`req_url_query`/`req_perform`/`resp_body_json` (do `httr2`), `|>`, `\(x)`, `download.file`, `source`, `rep`, `names(x) <-`, `saveRDS`, `readRDS`, `is.null`, `min`, `max`, `mean`, `file.rename`, `zip`; e `$` para ler um campo de lista (`cfg$minimo`).

**Aulas 02 a 04** (das linhas "Funções de R apresentadas" desses guias): `$`, `sqrt`, `^`, `NaN` (o que `0 / 0` devolve), `sweep`, `x[condição] <- valor`, `apply`, `arrows`/`text`/`plot(type = "n")` (figura opcional) (Aula 02); `gzcon(url(…))` (Parte D da 02); `head`, `iconv`, `wordStem` com `library(SnowballC)`, `strsplit(x, "")`, `for`, `integer(0)`, `seq_len`, `is.na`, `ifelse`, `NULL`, `Reduce`, `all`, `lengths` e, só na tarefa, `union` (Aula 03); `exp`, `factorial`, valor padrão de argumento, `mean`, `next`, `lines` (Aula 04).

### Da grade do curso

**Pode assumir:** probabilidade e tabelas de contingência — o "esperado" do qui-quadrado (Estatística Descritiva e Indutiva); a ideia de "diferença por acaso" e de viés de amostragem (Estatística Indutiva, Metodologia da Pesquisa); leitura de Python.

**Não pode assumir:** R além do listado acima; aprendizado de máquina aplicado (5º ciclo); PLN — processamento de linguagem natural — formal (5º ciclo). **Inteligência Computacional** corre em paralelo e fala de motores de busca — pode citar, não pode supor.

---

## Módulo 1 — O problema
*trabalho 4 min · conversa 4 min · lembrete: 360 palavras por mensagem; previsão antes da saída; todo código comentado*

**A situação.** O motor tem dois modelos que ordenam: o cosseno da Aula 02 e o BM25 da Aula 04. Os dois funcionam. Os dois devolvem listas plausíveis. Peça que ele preveja qual documento cada um põe em primeiro, e rode:

```r
round(ranking_cosseno("modelo de recuperacao", ix, cfg), 3)   # cosseno (Aula 02), 3 casas
round(ranking_bm25("modelo de recuperacao", ix, cfg), 3)      # BM25 (Aula 04), 3 casas
```
```
   d1    d3    d4    d2    d6    d8    d5    d7 
0.254 0.233 0.215 0.208 0.025 0.023 0.000 0.000 
```
```
   d3    d1    d2    d4    d8    d6    d5    d7 
1.873 1.869 1.687 1.427 0.519 0.492 0.000 0.000 
```

**A pergunta.** Qual dos dois é melhor?

**Por que não dá para responder olhando.** Achar o resultado bonito não é evidência: você escolheu a consulta, olhou e decidiu que gostou. Troque a consulta e a conclusão muda — e você tende a escolher consultas em que o seu modelo preferido vai bem, sem má-fé nenhuma.

**O que a área faz.** Fixa um conjunto de consultas, fixa um **gabarito** (o quanto cada documento serve para cada consulta), e compara todos os sistemas sobre a mesma base. O gabarito, no jargão, são os ***qrels*** — *query relevance judgments*, julgamentos de relevância por consulta.

**A frase:** sem gabarito, "esse modelo parece melhor" é opinião, não resultado.

**Exemplos que você mostra:**

- *Os dois discordam no topo:* o cosseno põe `d1` em 1º; o BM25, `d3`. Sem gabarito, nenhum argumento decide — "o `d3` fala de BM25, então o BM25 acertou" é você julgando **depois** de ver.
- *A diferença é minúscula:* no BM25, `d3` tem $1{,}873$ e `d1` tem $1{,}869$. Se a ordem dos dois trocasse, o modelo ficou pior? Só um gabarito diz se `d3` merecia estar na frente.

**Explore:** troque a consulta por `"busca em documentos"` nas duas linhas. O topo concorda? (Ele vê; não há resposta certa — a lição é que trocar a consulta muda a "conclusão".)

> **Erro previsto:** achar que avaliar é rodar e ver se "parece bom". Sinal: ele propõe "testar com umas buscas". Reação: perguntar quem escolheu as buscas e quem decidiu que estava bom.

> **Checkpoint 1.** *Um colega diz: "rodei cinco buscas no meu BM25 e nas cinco o primeiro resultado fazia sentido; ele é melhor que o cosseno". Aponte dois problemas nesse argumento.*
> Esperado: quaisquer dois — ele escolheu as consultas; "fazia sentido" é julgamento dele depois de ver o resultado; não rodou o cosseno nas mesmas consultas; olhou só o primeiro.

> **Ponte:** um gabarito é feito de julgamentos — e julgar contra o quê é o próximo módulo.

---

## Módulo 2 — Necessidade de informação × consulta
*trabalho 6 min · conversa 5 min · lembrete: 360 palavras por mensagem; ele decide antes, você compara depois*

Se ele sair com uma coisa só desta aula, que seja esta.

**Consulta** é o que a pessoa digitou: `modelo de recuperacao`. Três palavras.

**Necessidade de informação** é o que ela queria saber: *"quais são os modelos formais que um motor de busca usa para ordenar documentos?"* — uma ou duas frases em prosa.

A consulta é uma **tradução pobre** da necessidade: uma pergunta inteira comprimida em três palavras.

**A regra.** O julgamento de relevância é feito contra a **necessidade**, nunca contra a consulta.

**Por quê.** Julgar contra as palavras da consulta é perguntar "este documento contém as palavras da busca?" — exatamente o que o sistema faz. A avaliação seria **circular**: todo modelo que casa palavras tiraria nota máxima.

**Exemplos que você mostra:**

- *Contra as palavras, quase tudo serve.* Dos 8 documentos, **6** têm ao menos uma palavra de `modelo de recuperacao`: `d1`, `d2`, `d3`, `d4`, `d6`, `d8`. O `d8` ("ciencia **de** dados…") entraria pelo `de`. Contra a necessidade, só `d2` e `d3` respondem.
- *A mesma consulta, duas necessidades.* `avaliacao de busca` pode vir de *"como medir se um buscador acerta?"* — e então `d7` ("a avaliacao mede a relevancia dos resultados da busca") responde; ou de *"quero montar um buscador rápido"* — e então quem chega perto é `d5` ("o indice invertido acelera a busca"), e `d7` não serve.

**Exercício — ele escreve.** *A consulta é `modelo de recuperacao`. Escreva duas necessidades bem diferentes que poderiam ter gerado essa mesma consulta.* Aceite qualquer par plausível ("que modelos matemáticos existem para ordenar documentos"; "um tutorial para implementar um em R"; "quem inventou isso"). Faça-o notar que **o gabarito muda** conforme a necessidade.

> **Erro previsto:** escrever a necessidade como a consulta com mais palavras — "o usuário quer saber sobre modelos de recuperação". Sinal: a "necessidade" cabe numa linha e usa as mesmas palavras. Reação: *"o que ele faria com a resposta?"*

> **Checkpoint 2.** *Um colega monta o gabarito assim: "relevante é o documento que tem todas as palavras da consulta". Ele roda a `busca_AND` da Aula 03 e ela acerta tudo. O que essa avaliação mediu?*
> Esperado: nada sobre relevância — o gabarito é a própria regra de casamento de palavras, então a `busca_AND` concorda consigo mesma por construção. É a avaliação circular: falta julgar contra a necessidade.

> **Ponte:** se é contra a necessidade, alguém precisa lê-la e decidir. Quem — e quando?

---

## Módulo 3 — Quem julga, e em que ordem
*trabalho 4 min · conversa 4 min · lembrete: 360 palavras por mensagem; siglas por extenso*

**Quem julga é uma pessoa.** Não existe fórmula para relevância. Se existisse, ela seria o motor de busca.

Na prática:

- **TREC** — *Text REtrieval Conference*, a avaliação anual do NIST (*National Institute of Standards and Technology*, o instituto de padrões dos EUA) desde 1992: avaliadores contratados, um por tópico.
- **ARQMath** — *Answer Retrieval for Questions on Math*, laboratório do CLEF (*Conference and Labs of the Evaluation Forum*, o equivalente europeu do TREC), 2020–2022, sobre busca em matemática: estudantes de matemática treinados.
- **Neste projeto:** os próprios alunos.

**A ordem é obrigatória:**

```
escrever a necessidade -> escrever a consulta -> JULGAR -> rodar o sistema
```

**Nunca inverta os dois últimos.** Julgando depois de ver o ranking, o documento que o BM25 pôs em primeiro começa a parecer relevante. Não é desonestidade — é **ancoragem**, e é involuntária. Sai um gabarito ajustado ao sistema, que dá nota alta e não significa nada.

**Consequência:** o gabarito é um **dado** do projeto, versionado no repositório junto com o código.

**Exemplos que você mostra:**

- *A âncora do escore:* quem vê `d3 1.873` antes de ler `d3` lê "bm25 e um modelo…" já procurando a razão do 1º lugar.
- *A âncora da posição:* quem vê `d1` em 2º no BM25 tende a dar a ele a mesma nota do 1º — "estão quase empatados" é uma frase sobre o modelo, não sobre o texto.
- *A ordem certa, no projeto:* o grupo escreve as necessidades (Parte D), julga no `julgar.html` — que **não mostra** ranking, modelo nem escore — e só na Aula 5,5 roda as métricas.

> **Erro previsto:** achar que julgar depois é só "menos rigoroso", não inválido. Sinal: *"mas eu seria honesto"*. Reação: ancoragem não é desonestidade — é involuntária; ninguém consegue "descontar" um ranking que já viu.

> **Checkpoint 3.** *Um grupo julgou as consultas olhando a tela do próprio motor, com os escores ao lado, e conclui: "o BM25 acertou 9 dos 10 primeiros". O que esse "9 de 10" mede?*
> Esperado: o quanto os juízes concordaram com um ranking que já tinham visto — a ancoragem —, não a relevância. Para medir o BM25, o julgamento tinha que vir antes, sem ver o ranking.

> **Ponte:** julgar tudo à mão é possível com 8 documentos. Com 6 mil, não — o próximo módulo resolve isso.

---

## Módulo 4 — *Pooling*
*trabalho 10 min · conversa 6 min · lembrete: matemática em LaTeX; previsão antes da saída; todo código comentado*

**O problema, em números.** Suponha $6\,673$ documentos e 20 consultas:

$$6\,673 \times 20 = 133\,460 \text{ julgamentos}$$

A 20 segundos cada, $133\,460 \times 20 / 3\,600 \approx 741$ **horas**. Inviável.

**A tentação errada.** Pedir a um modelo que julgue: o gabarito passaria a medir a opinião de um modelo sobre o resultado de outro.

**A saída certa.** Julgar **menos documentos, escolhidos bem**. Chama-se *pooling* — formar uma *pool*, um "bolo" comum — e é do TREC:

1. Rodar **cada modelo** para **cada consulta**.
2. Pegar o top-$k$ de cada (tipicamente $k = 10$ ou $20$).
3. **Unir e deduplicar** por consulta — isso é a *pool*.
4. **Embaralhar** a ordem dentro da *pool*.
5. Julgar **só a *pool***. Tudo fora dela é assumido irrelevante.

**O passo 4 não é opcional:** na ordem do BM25, o juiz julga com **viés de posição** — a ancoragem do Módulo 3.

**Uma *pool* de verdade, com o motor.** **Novo: `union(a, b)`** — junta dois vetores e tira os repetidos, na ordem em que aparecem (o `intersect` da Aula 01 fica com o que está **nos dois**; o `union`, com o que está **em algum**).

```r
bm   <- names(ranking_bm25("modelo de recuperacao", ix, cfg))[1:3]     # top-3 do BM25
co   <- names(ranking_cosseno("modelo de recuperacao", ix, cfg))[1:3]  # top-3 do cosseno
pool <- union(bm, co)      # une os dois e tira os repetidos: a pool desta consulta
pool                       # quais documentos alguém vai julgar
```

Previsão, antes de rodar: o BM25 traz `d3 d1 d2`; o cosseno, `d1 d3 d4`. Seis nomes, com repetição. Quantos sobram?

```
[1] "d3" "d1" "d2" "d4"
```

**A conta do projeto** — ele calcula cada linha antes de você mostrar:

| | |
|---|---|
| consultas | 20 |
| modelos | 3 |
| top-$k$ por modelo | 10 |
| documentos por consulta, com repetição | $3 \times 10 = 30$ |
| após deduplicar (cerca de $60\%$ únicos, na prática) | $\approx 18$ |
| **julgamentos no total** | $20 \times 18 = 360$ |
| a 20 s cada | $360 \times 20 = 7\,200$ s $= 2$ horas |
| divididas entre 4 pessoas | **30 min cada** |

De $133\,460$ para $360$.

**O preço.** Um documento que **nenhum** modelo recuperou nunca entra na *pool*, logo nunca é julgado, logo é tratado como irrelevante — mesmo que seja ótimo.

**Antes de seguir, defina *recall* — é a primeira vez que aparece.** Duas linhas bastam; a definição completa é da Aula 5,5.

- **Precisão** — *do que eu mostrei, quanto presta?*
- ***Recall*** (revocação) — *do que presta, quanto eu mostrei?*

A diferença está no **denominador**. O da precisão é o que o usuário vê. O do *recall* é **o total de relevantes que existem no acervo** — que só o gabarito conhece. Pergunte: *"se o gabarito só tem os relevantes que algum modelo achou, o denominador do recall está completo ou faltando?"*

Três consequências do viés:

- o ***recall*** calculado fica **superestimado** — o denominador só conta os relevantes que alguém achou, é menor que o verdadeiro, e a fração sai maior;
- um modelo **novo**, avaliado depois com uma *pool* antiga, é penalizado: os bons documentos que só ele acha não estão no gabarito;
- quanto **mais modelos** — e quanto maior o $k$ —, menor o viés.

É conhecido e aceito — mas vai **escrito no relatório**. Limitação declarada é ciência; escondida, não.

**Exemplos que você mostra:**

- *Quem ficou de fora:* a *pool* de cima é `d3 d1 d2 d4`. O `d6` ("embeddings capturam a semantica…") não está nela — e no gabarito do Módulo 6 ele vale 1. Com essa *pool*, seria julgado 0 sem ninguém ler.
- *Variar o $k$:* com o top-5 de cada um (troque os dois `[1:3]` por `[1:5]`), o BM25 traz `d3 d1 d2 d4 d8` e o cosseno `d1 d3 d4 d2 d6`: a *pool* vira `"d3" "d1" "d2" "d4" "d8" "d6"` — seis documentos, e o `d6` entra.

> **Erro previsto:** achar que o *pooling* "resolve" o problema. Sinal: ele descreve o método sem mencionar o viés. Reação: *"e o documento que nenhum dos três modelos achou — o que acontece com ele?"*

> **Erro previsto:** achar que `union` soma. Sinal: ele prevê 6 elementos. Reação: rode `union(c("d3","d1"), c("d1","d4"))` → `"d3" "d1" "d4"` — o repetido entra uma vez.

> **Checkpoint 4.** *Você inventou um modelo novo, muito bom, que recupera documentos que os outros três nunca acham. Avaliado com a pool dos três antigos, ele vai parecer melhor ou pior do que é? Por quê?*
> Esperado: **pior** — os documentos que só ele encontra não foram julgados, logo valem 0.

> **Ponte:** decidido *o que* julgar, falta decidir *em que escala*.

---

## Módulo 5 — A escala
*trabalho 6 min · conversa 5 min · lembrete: matemática em LaTeX; ele decide antes, você compara depois*

**Relevância não é sim ou não.** Um documento pode responder exatamente, pela metade, ou só tangenciar.

| grau | significado |
|---|---|
| **2** | responde à necessidade |
| **1** | fala do assunto sem responder |
| **0** | não serve |

O TREC usa escalas de dois ou três níveis, conforme o ano e a tarefa; o ARQMath usa 0 a 3. Aqui: **0, 1, 2**. Mais níveis dão mais informação e mais discordância; três é um bom compromisso.

**Binarizar exige uma decisão.** Algumas métricas (Aula 5,5) precisam de relevante/não relevante. Converter 0/1/2 em binário exige um **limiar**: relevante é $\text{grau} \geq 2$, ou $\text{grau} \geq 1$? As duas são defensáveis e dão resultados diferentes. O que não pode é ficar implícito.

**O guia de julgamento.** Duas pessoas só julgam parecido se os **casos de fronteira** estiverem decididos **antes**, numa página: documento correto mas superficial; correto no idioma errado; responde só a uma parte; excelente mas que o usuário já conhece; duplicado de outro já julgado.

**Exemplos que você mostra** — uma necessidade que **não** é a do Módulo 6: *"Como um motor de busca representa um texto para poder compará-lo com outro?"*

- `d2` ("o modelo de espaco vetorial representa documentos como vetores") → **2**: diz como representa;
- `d6` ("embeddings capturam a semantica de palavras e documentos") → **1**: fala de representação, mas não diz como se compara;
- `d8` ("ciencia de dados combina estatistica e programacao") → **0**.

Com esses três graus: limiar $\geq 2$ dá **1** relevante (`d2`); limiar $\geq 1$ dá **2** (`d2`, `d6`). A mesma tabela, dois gabaritos binários diferentes.

> **Erro previsto:** tratar o grau como número, não como ordem — "1 é metade de 2". Sinal: ele propõe tirar a média dos graus. Reação: a escala é **ordinal**; 2 não é "duas vezes" 1. (A Aula 5,5 mostra o que se pode e o que não se pode fazer com ela.)

> **Checkpoint 5.** *Numa consulta, os graus foram: `d1` = 1, `d4` = 1, `d5` = 2, o resto 0. Quantos relevantes há com limiar $\geq 2$, e com $\geq 1$? Um modelo pôs `d1` e `d4` no topo e `d5` em 8º: ele parece bom com qual limiar?*
> Esperado: $\geq 2$ → 1 relevante (`d5`); $\geq 1$ → 3 (`d1`, `d4`, `d5`). Com $\geq 1$ o topo está cheio de relevantes e o modelo parece bom; com $\geq 2$ o único relevante está em último e ele parece péssimo. Por isso o limiar se declara.

> **Ponte:** agora ele julga de verdade — os 8 documentos, contra a necessidade da aula.

---

## Módulo 6 — O cenário concreto
*trabalho 10 min · conversa 5 min · lembrete: ele julga antes de ver a tabela; você não julga; todo código comentado*

**Faça-o julgar antes de ver a tabela.** Dê a necessidade, a consulta e os 8 documentos (`docs` na tela); peça um grau para cada, com uma frase de justificativa. Só depois compare.

**Necessidade:** *"Quais são os modelos formais que um motor de busca usa para ordenar documentos?"*
**Consulta:** `modelo de recuperacao`

**O gabarito da aula:**

| doc | conteúdo | grau |
|---|---|---|
| d2 | o modelo de espaco vetorial representa documentos como vetores | **2** |
| d3 | bm25 e um modelo probabilistico de ranqueamento de texto | **2** |
| d1 | recuperacao de informacao ordena documentos por relevancia | **1** |
| d6 | embeddings capturam a semantica de palavras e documentos | **1** |
| d4 | aprendizado estatistico fundamenta a recuperacao moderna | 0 |
| d5, d7, d8 | índice invertido / avaliação / ciência de dados | 0 |

**Em voz alta:** `d2` e `d3` apresentam um *modelo* — respondem. `d1` diz *o que é* recuperação de informação, sem modelo — contexto, não resposta. `d6`: *embeddings* são a base da recuperação densa, mas o texto não diz isso. `d4` fala de *fundamento*, não de modelo.

Não afirme que a tabela é "a resposta certa": é um julgamento defensável, e o dele pode ser outro. O que importa é a justificativa. Mas os números das próximas aulas usam **esta** tabela.

**O gabarito vira um vetor nomeado** — o mesmo formato de `docs` —, e o ranking do motor vira um jeito de ler os graus **na ordem do modelo**:

```r
gab <- c(d1 = 1, d2 = 2, d3 = 2, d4 = 0, d5 = 0, d6 = 1, d7 = 0, d8 = 0)  # o gabarito da aula
gab[names(ranking_bm25("modelo de recuperacao", ix, cfg))]                # os graus, na ordem do BM25
```
```
d3 d1 d2 d4 d8 d6 d5 d7 
 2  1  2  0  0  1  0  0 
```

Peça que ele leia em voz alta: *"em 1º, um grau 2; em 2º, um grau 1…"*.

**O ponto da aula inteira:** o BM25 colocou **`d1` em segundo lugar** porque `d1` contém `recuperacao`. Mas `d1` tem grau 1.

> **Casamento léxico $\neq$ relevância.**

É disso que tratam as Aulas 07, 08 e 14: fechar essa distância.

**Exemplos que você mostra:**

- *O `d1` no BM25:* 2º lugar, grau 1 — à frente de `d2`, grau 2, que ficou em 3º.
- *O `d6` no BM25:* grau 1, mas em 6º, atrás de `d8` (grau 0): o `d6` fala do assunto com palavras que a consulta não tem.
- *O topo do cosseno:* `gab[names(ranking_cosseno("modelo de recuperacao", ix, cfg))]` dá `d1 1, d3 2, d4 0, d2 2, d6 1, d8 0, d5 0, d7 0` — o 1º lugar do cosseno é um grau 1.

> **Erro previsto:** dar grau 2 a `d1` por conter `recuperacao`. Sinal: o próprio julgamento dele. Reação — sem dizer que está errado: *"d1 responde à pergunta, ou fala do assunto?"* É o erro mais instrutivo da aula; deixe-o acontecer. (Ele volta no Módulo 7, como exemplo de concordância.)

> **Checkpoint 6.** *No cosseno, `d4` (grau 0) ficou em 3º, à frente de `d2` (grau 2). Erro do modelo, erro do gabarito, ou nenhum dos dois? O que o `d4` tem que o fez subir?*
> Esperado: nenhum dos dois. O `d4` contém `recuperacao` — casou uma palavra da consulta —, mas fala de fundamento, não de modelo; o modelo fez o que sabe (casar palavras), o gabarito fez o que deve (julgar contra a necessidade). A distância entre os dois **é** o objeto de estudo.

> **Ponte:** ele julgou sozinho. Se um colega julgasse, daria igual? O próximo módulo mede isso.

---

## Módulo 7 — Concordância: o $\kappa$ de Cohen
*trabalho 16 min · conversa 7 min · lembrete: matemática em LaTeX; ele calcula, você confere; todo código comentado*

O módulo mais difícil e o único com conta de verdade. Reserve tempo.

**O fato.** Dois avaliadores humanos concordam tipicamente em $70\%$ a $80\%$ dos julgamentos. Não é desleixo — relevância tem componente subjetivo.

**O risco.** Se cada membro do grupo julgar itens diferentes, ninguém descobre que usam critérios diferentes. **A solução:** separar uma parte da *pool* (neste curso, $20\%$) para **julgamento duplo** — duas pessoas, mesmos itens, sem se consultarem.

### A armadilha

Dois juízes julgaram os mesmos **40 itens**. Concordaram em **31**: $31/40 = 77{,}5\%$. Parece bom. Mas a maior parte de uma *pool* é irrelevante: se os dois disserem "0" quase sempre, concordam bastante **por acaso**. A pergunta certa: quanto da concordância está **acima** do que o acaso já explicaria?

### A fórmula

$$\kappa = \frac{p_o - p_e}{1 - p_e}$$

- $p_o$ — concordância **observada**: fração de itens com a mesma nota.
- $p_e$ — concordância **esperada por acaso**: a fração de itens em que os dois dariam a mesma nota se cada um **sorteasse** as suas, sem olhar o item nem o outro, mas mantendo a frequência com que usa cada nota. A conta, passo a passo, vem logo depois da matriz.

**Como ler.** O denominador $1 - p_e$ é o espaço que *sobrava* acima do acaso. O numerador $p_o - p_e$ é quanto foi *ocupado*. **$\kappa$ é a fração aproveitada.** Se $p_o = p_e$, $\kappa = 0$; se concordam em tudo, $\kappa = 1$.

### A matriz

| | **B deu 0** | **B deu 1** | **B deu 2** | **total A** |
|---|---|---|---|---|
| **A deu 0** | 18 | 3 | 0 | **21** |
| **A deu 1** | 2 | 6 | 2 | **10** |
| **A deu 2** | 0 | 2 | 7 | **9** |
| **total B** | **20** | **11** | **9** | **40** |

> **Pare aqui. Erro previsto — o mais comum da aula:** ler `18` e `7` como notas. Sinal: *"mas a nota não vai só até 2?"* Reação: **cada célula é uma contagem de itens**; as notas estão só nos rótulos. **18** — em 18 itens os *dois* deram 0. **3** — em 3 itens A deu 0 e B deu 1. **7** — em 7 itens os *dois* deram 2. As nove células somam 40; se fossem notas, não haveria o que somar. *Pergunte:* "o que significa o 2 na linha `A deu 1`, coluna `B deu 2`?" (Em 2 itens, A deu 1 e B deu 2.)

A **diagonal** são os itens com a mesma nota: $18 + 6 + 7 = 31$. Os dois cantos com 0 dizem que ninguém deu 0 onde o outro deu 2 — nenhuma discordância extrema.

**Exemplos que você mostra** — antes de ele fazer a conta grande, dois casos que se fazem de cabeça:

- *Só diagonal:* A e B deram 0 a 5 itens, 1 a 3, 2 a 2, sempre iguais. $p_o = 10/10 = 1$; $p_e = (5 \times 5 + 3 \times 3 + 2 \times 2)/10^2 = 38/100 = 0{,}38$; $\kappa = (1 - 0{,}38)/(1 - 0{,}38) = 1$. Concordância perfeita dá 1, qualquer que seja o acaso.
- *Tudo espalhado:* 9 itens, um em cada célula da matriz. $p_o = 3/9 = 0{,}333$; as marginais são todas 3, então $p_e = (3 \times 3 + 3 \times 3 + 3 \times 3)/9^2 = 27/81 = 0{,}333$; $\kappa = 0$. Concordaram exatamente o que o acaso previa.

### De onde vem o $p_e$ — passo a passo

Mostre em três passos, um por mensagem se ele travar.

**1. As proporções de cada juiz** — os totais da matriz divididos por 40:

| | nota 0 | nota 1 | nota 2 |
|---|---|---|---|
| A | $21/40 = 0{,}525$ | $10/40 = 0{,}250$ | $9/40 = 0{,}225$ |
| B | $20/40 = 0{,}500$ | $11/40 = 0{,}275$ | $9/40 = 0{,}225$ |

**2. O acaso.** Imagine que cada juiz, em vez de ler o documento, **sorteia** a nota — A com 52,5% de chance de "0", 25% de "1", 22,5% de "2"; B com as suas. Os sorteios são **independentes** (um não vê o outro), e a chance de dois eventos independentes acontecerem juntos é o **produto**:

$$P(	ext{os dois dão } 0) = 0{,}525 	imes 0{,}500 = 0{,}2625$$

$$P(	ext{os dois dão } 1) = 0{,}250 	imes 0{,}275 = 0{,}06875 \qquad P(	ext{os dois dão } 2) = 0{,}225 	imes 0{,}225 = 0{,}050625$$

Concordar é "os dois dão 0" **ou** "os dois dão 1" **ou** "os dois dão 2" — casos que não acontecem juntos, então **somam**: $p_e = 0{,}2625 + 0{,}06875 + 0{,}050625 = 0{,}381875$.

**3. Em itens, para ver o tamanho.** Dos 40 itens, o acaso poria na diagonal $40 \times 0{,}381875 \approx 15{,}3$. Eles puseram **31**. O $\kappa$ mede essa distância.

**O atalho.** Como $\frac{21}{40} \times \frac{20}{40} = \frac{21 \times 20}{40^2}$, dá para multiplicar as contagens e dividir por $n^2$ uma vez só — é a fórmula que ele vai usar. É o mesmo "esperado" do teste qui-quadrado de Estatística: total da linha $\times$ total da coluna, sobre $n$.

> **Erro previsto:** multiplicar as proporções **na diagonal da matriz** ($18/40 \times 6/40 \ldots$). Sinal: ele usa 18, 6, 7. Reação: o acaso não olha o que aconteceu junto — só **quantas vezes cada juiz usou cada nota**, que são os **totais** (21, 10, 9 e 20, 11, 9).

### A conta — ele faz, você confere

$$p_o = \frac{31}{40} = 0{,}775$$

$$p_e = \frac{21 \times 20 + 10 \times 11 + 9 \times 9}{40^2} = \frac{420 + 110 + 81}{1\,600} = \frac{611}{1\,600} = 0{,}381875 \approx 0{,}382$$

$$\kappa = \frac{0{,}775 - 0{,}381875}{1 - 0{,}381875} = \frac{0{,}393125}{0{,}618125} = \mathbf{0{,}636}$$

$77{,}5\%$ brutos; descontado o acaso, $\kappa = 0{,}636$.

> **Erro previsto:** $p_e = 1/3$, "porque são três notas". Sinal: ele usa $0{,}333$. Reação: isso seria acaso *uniforme*; os juízes não usam as notas por igual — é por isso que entram as **marginais** (21, 10, 9 e 20, 11, 9). É a mesma construção do esperado no qui-quadrado que ele viu em Estatística.

### Em R — um trecho por vez

`byrow = TRUE` apareceu num erro previsto da Aula 00: preenche a matriz **linha a linha**, como a tabela se lê.

```r
m <- matrix(c(18, 3, 0,     # A deu 0: B deu 0 em 18 itens, 1 em 3, 2 em nenhum
               2, 6, 2,     # A deu 1
               0, 2, 7),    # A deu 2
            nrow = 3, byrow = TRUE)   # 3 linhas, preenchidas linha a linha
m                                     # confira contra a tabela
```
```
     [,1] [,2] [,3]
[1,]   18    3    0
[2,]    2    6    2
[3,]    0    2    7
```

**Novo: `diag(m)`** — a diagonal de uma matriz: `m[1,1]`, `m[2,2]`, `m[3,3]`.

```r
n  <- sum(m)               # total de itens: 40
diag(m)                    # os acordos: 18 6 7
po <- sum(diag(m)) / n     # observada: 31 / 40
po                         # 0.775
```

```r
pe <- sum(rowSums(m) * colSums(m)) / n^2   # totais de A vezes totais de B, nota a nota, sobre n^2
pe                                         # 0.381875
(po - pe) / (1 - pe)                       # o kappa: 0.635996
```

Peça que ele leia `rowSums(m) * colSums(m)`: `21 10 9` vezes `20 11 9`, elemento a elemento → `420 110 81`. É a linha do $p_e$ que ele fez à mão.

**Agora numa função, para reusar.** **Novo: `if (cond) x else y` como valor** — devolve `x` se a condição for `TRUE`, `y` se não; dá para guardar o resultado. **`NaN`** — *not a number*, o que o R dá para $0/0$ (Aula 02).

```r
kappa_matriz <- function(m) {                       # recebe a matriz de concordância
  n  <- sum(m)                                      # total de itens
  po <- sum(diag(m)) / n                            # observada: a diagonal
  pe <- sum(rowSums(m) * colSums(m)) / n^2          # esperada por acaso: as marginais
  k  <- if (pe < 1) (po - pe) / (1 - pe) else NA    # pe = 1: indefinido (sem isto, NaN)
  c(po = po, pe = pe, kappa = k)                    # as três medidas, com nome
}                                                   # fim da função
```

```r
round(kappa_matriz(m), 3)   # as três medidas da matriz da aula, 3 casas
```
```
   po    pe kappa 
0.775 0.382 0.636 
```

**Pergunte: por que a linha do `if` existe?** Se os dois juízes deram **a mesma nota a tudo** — digamos, 0 aos 10 itens —, $p_o = 1$ e $p_e = 1$: $\kappa = 0/0$. Sem o `if`, o R mostraria `NaN`; com ele, `NA` — "não há como medir". Mostre:

```r
m0 <- matrix(c(10, 0, 0, 0, 0, 0, 0, 0, 0), nrow = 3)   # os dois deram 0 aos 10 itens
round(kappa_matriz(m0), 3)                              # po e pe valem 1
```
```
   po    pe kappa 
    1     1    NA 
```

**Exemplos que você mostra** — agora com dois vetores de notas, que é como os dados chegam. **Novo: `table(a, b)` com dois vetores** — cruza: linhas são as notas de `a`, colunas as de `b`, e cada célula conta os itens. Com `factor(…, levels = 0:2)`, como na Aula 01, as três notas aparecem mesmo se uma não foi usada.

```r
outro <- c(d1 = 2, d2 = 2, d3 = 2, d4 = 0, d5 = 0, d6 = 1, d7 = 0, d8 = 0)  # um juiz que deu 2 ao d1
mt <- table(factor(gab, levels = 0:2), factor(outro, levels = 0:2))         # a matriz dos dois
mt                                                                          # linhas: gab; colunas: outro
```
```
   
    0 1 2
  0 4 0 0
  1 0 1 1
  2 0 0 2
```

- a primeira linha da saída fica em branco (é onde iriam os nomes das dimensões);
- `round(kappa_matriz(mt), 3)` → `po 0.875`, `pe 0.375`, `kappa 0.800`: um único desacordo (o `d1`, o erro previsto do Módulo 6) em 8 itens;
- **Explore:** troque `outro` pelos graus que **ele** deu no Módulo 6 — sai o $\kappa$ dele contra o guia.

**Figura (opcional — se ele responde melhor a imagem):** a matriz como mapa de calor deixa a diagonal visível. **Novo: `expand.grid`** — todas as combinações de dois vetores, numa tabela de duas colunas. **Novo: `ggplot2`** — pacote de gráficos, carregado com `library` como o `SnowballC` da Aula 03 (as figuras das Aulas 02 e 04 eram em R base); cada linha abaixo vai comentada.

```r
library(ggplot2)                                      # pacote de gráficos (já vem no Colab)
d <- expand.grid(A = 0:2, B = 0:2)                    # as 9 combinações de notas (A, B)
d$n <- c(18, 2, 0,  3, 6, 2,  0, 2, 7)                # as contagens, na ordem do expand.grid (A varia primeiro)
ggplot(d, aes(x = B, y = A, fill = n)) +              # x = nota de B, y = nota de A, cor = contagem
  geom_tile() +                                       # um quadrado por célula
  geom_text(aes(label = n), size = 6) +               # escreve o número dentro
  scale_y_reverse() +                                 # A = 0 em cima, como na tabela
  labs(x = "juiz B deu", y = "juiz A deu")            # nomes dos eixos
```

Antes de ele rodar, diga o que vai ver: *os quadrados mais claros ficam na diagonal — onde os dois deram a mesma nota.* Pergunte se viu.

### Interpretando

| $\kappa$ | leitura | o que fazer |
|---|---|---|
| $< 0{,}4$ | fraca | guia ambíguo: **reescrever e rejulgar** |
| $0{,}4$ a $0{,}6$ | moderada | aceitável; **registrar a limitação** |
| $\geq 0{,}6$ | boa | seguir |

**Por que $\kappa$ imperfeito não invalida a comparação.** O ruído do gabarito atinge **todos os modelos igualmente**. Atrapalha o *valor absoluto* de uma métrica, não a pergunta que importa: **"o BM25 é melhor que o cosseno?"**

### Exercício de fixação — ele calcula

| | B deu 0 | B deu 1 | B deu 2 |
|---|---|---|---|
| **A deu 0** | 27 | 2 | 0 |
| **A deu 1** | 1 | 0 | 0 |
| **A deu 2** | 0 | 0 | 0 |

Só confira depois que ele tentar: $p_o = 27/30 = 0{,}900$; marginais A $= (29, 1, 0)$, B $= (28, 2, 0)$; $p_e = (29 \times 28 + 1 \times 2)/30^2 = 814/900 = 0{,}904$; $\kappa = (0{,}900 - 0{,}904)/(1 - 0{,}904) \approx -0{,}047$. No R:

```r
round(kappa_matriz(matrix(c(27, 2, 0, 1, 0, 0, 0, 0, 0), nrow = 3, byrow = TRUE)), 3)  # a matriz do exercício
```
```
    po     pe  kappa 
 0.900  0.904 -0.047 
```

**$\kappa$ negativo com $90\%$ de concordância.** Os dois deram "0" a quase tudo, então concordar era quase inevitável — e concordaram *menos* do que o acaso previa. Critérios incompatíveis, ou *pool* tão desbalanceada que o $\kappa$ deixa de informar.

> **Checkpoint 7.** *Dois juízes concordaram em $88\%$ dos itens e o $\kappa$ deu $0{,}12$. O que você conclui, e o que recomenda ao grupo?*
> Esperado: quase toda a concordância é a que o acaso já daria — provavelmente a *pool* tem muitos "0" e os dois concordam neles, mas discordam onde importa (graus 1 e 2). $\kappa < 0{,}4$: o guia de julgamento está ambíguo; olhar os itens em que discordaram, decidir os casos de fronteira que faltaram, reescrever e rejulgar.

> **Ponte:** o gabarito está pronto e medido. Falta organizá-lo para o resto do semestre.

---

## Módulo 8 — Organização
*trabalho 4 min · conversa 4 min · lembrete: 360 palavras por mensagem; não adiante a Aula 09*

### Separar antes de julgar

Na **Aula 09** o gabarito deixa de ser régua e vira **rótulo de treino** de um modelo de *learning to rank* — LTR, aprendizado de ordenação. Treinar e avaliar nas **mesmas** consultas produz melhoria falsa. E antes disso, já na Aula 04, ajustar o $k_1$ e o $b$ olhando as consultas é treinar nelas.

**Não tem conserto depois.** Uma consulta que já foi usada para ajustar alguma coisa não serve mais para testar — não dá para "desver". A decisão é **antes do primeiro julgamento**, e fica escrita:

| conjunto | consultas | uso |
|---|---|---|
| **desenvolvimento** | q01–q14 | ajustar, testar, errar |
| **teste** | q15–q20 | **não se olha** até o relatório final |

### O arquivo de *qrels*

É o que o `julgar.html` da Parte D exporta — um arquivo `qrels_<juiz>_<data>.csv` **por juiz**, com seis colunas:

| consulta | documento | grau | juiz | timestamp | segundos |
|---|---|---|---|---|---|
| q01 | d14 | 2 | ana | 2026-10-08T14:22:31.000Z | 12 |
| q01 | d27 | 0 | ana | 2026-10-08T14:22:48.000Z | 9 |
| q01 | d14 | 1 | ana_p2 | 2026-10-10T09:03:12.000Z | 15 |

A terceira linha é a **segunda passada** da mesma juíza, dois dias depois — o sufixo `_p2` marca. O arquivo de outro juiz que julgou os mesmos itens é o julgamento duplo do Módulo 7. **Quem**, **quando** e **quanto tempo** permitem auditar: um item julgado em 2 segundos não foi lido.

### Para que serve tudo isso

| aula | papel do gabarito |
|---|---|
| 5,5 métricas | a **régua**: precisão, *recall* e as outras |
| 06 Rocchio | **entrada do algoritmo**, não só da métrica |
| 07 recuperação densa | responde "*embeddings* batem o BM25?" |
| 09 *learning to rank* | vira **rótulo de treino** |
| 13 avaliação final | a tabela modelo $\times$ métrica |
| 14 RAG | a recuperação é o **teto** da qualidade |
| 17 ética e viés | o gabarito é **onde o viés entra** |

RAG — *retrieval-augmented generation*: um modelo de linguagem que consulta um motor de busca antes de responder.

**Exemplos que você mostra:**

- *Teste contaminado:* um grupo ajusta $k_1$ olhando as 20 consultas e reporta o resultado nas mesmas 20 — o número mede o quanto o ajuste decorou aquelas consultas.
- *Teste limpo:* o mesmo grupo ajusta em q01–q14 e só no fim roda q15–q20 uma vez — se o ganho se mantém, é ganho.
- *O `_p2` no arquivo:* `ana` e `ana_p2` são a mesma pessoa em dias diferentes; o $\kappa$ entre as duas mede se o guia produz julgamentos **estáveis**, não se dois critérios concordam.

> **Erro previsto:** "separo depois, quando precisar". Sinal: ele acha a divisão prematura. Reação: se as consultas de teste já foram usadas para ajustar, não há mais teste — e não dá para "desver".

> **Checkpoint 8.** *Um grupo julgou 20 consultas, escolheu o $b$ do BM25 olhando o resultado nas 20, e só então sorteou 5 para "teste". O número nessas 5 vale como teste?*
> Esperado: não — as 5 já influenciaram a escolha do $b$; o resultado nelas é otimista. A separação tinha que ter sido decidida antes de julgar e de ajustar qualquer coisa.

> **Ponte:** ele entendeu o método. O teste confirma — e depois, na Parte D, o grupo monta o sistema para o corpus do projeto.

---

**Funções de R apresentadas nesta aula** (o guia da Aula 5,5 copia esta linha): `union`, `diag`, `matrix(…, byrow = TRUE)`, `if (…) x else y` como valor, `table(a, b)` com dois vetores, `expand.grid` (opcional), `library(ggplot2)` com `geom_tile`, `geom_text`, `scale_y_reverse`, `labs` (opcional).

**Casos degenerados desta aula:** $\kappa$ com $p_e = 1$ (os dois juízes deram a mesma nota a tudo) — a conta crua dá `NaN` ($0/0$); a `kappa_matriz` devolve `NA`, e a saída mostra `po 1`, `pe 1`, `kappa NA`. `union` de vetores iguais devolve um vetor só, sem aviso. Um documento que nenhum modelo pôs no top-$k$ fica fora da *pool* sem aviso (o `d6` com $k = 3$) — é o viés do *pooling*, não um erro do R.

---
---

# PARTE C — Teste final: uma pergunta por módulo

**Só depois de o Módulo 8 estar concluído, e antes do consolidado.** Avise: *"agora um teste curto — uma pergunta por módulo, para eu saber o que ficou e o que precisa voltar."*

**As perguntas são estas, e só estas.** Só entram os módulos alcançados — se a sessão parou antes, os demais são "não avaliados". Se você ensinou algo além do guia, isso **não** entra. **Uma por vez.** Diga se acertou e, em uma linha, o que faltou. Não reensine — anote o módulo.

| módulo | pergunta | esperado |
|---|---|---|
| **1** | O cosseno pôs `d1` em 1º e o BM25 pôs `d3`. O que falta para dizer qual dos dois acertou — e o que não serve como resposta? | um gabarito fixo, julgado antes, e as mesmas consultas para os dois; "olhar e achar melhor" não serve |
| **2** | Por que a relevância é julgada contra a necessidade de informação, e não contra a consulta? | julgar contra a consulta mede casamento de palavras — o que o sistema já faz; a avaliação vira circular |
| **3** | Qual é a ordem obrigatória das quatro etapas, e o que dá errado se as duas últimas forem invertidas? | necessidade → consulta → julgar → rodar; invertendo, o juiz se ancora no ranking e o gabarito passa a favorecer o sistema |
| **4** | Dois modelos têm top-3 `d2 d5 d7` e `d5 d1 d2`. Qual é a *pool*, e o que acontece com um relevante que ficou em 4º nos dois? | `union` → `d2 d5 d7 d1` (4 documentos); o 4º lugar não entra, nunca é julgado e conta como irrelevante — o viés que superestima o *recall* |
| **5** | Um gabarito tem graus 0/1/2. Que decisão é preciso tomar para usá-lo com uma métrica binária, e por que ela muda o resultado? | escolher o limiar ($\geq 1$ ou $\geq 2$) e declará-lo; muda quantos e quais documentos contam como relevantes |
| **6** | O BM25 pôs em 2º lugar um documento de grau 1, à frente de um de grau 2. O que isso ilustra? | casamento léxico $\neq$ relevância; nem erro do modelo nem do gabarito |
| **7** | Como é possível $90\%$ de concordância com $\kappa$ negativo? | quase toda a concordância era esperada por acaso (os dois deram "0" a quase tudo, $p_e$ alto); concordaram menos que o acaso previa |
| **8** | Por que separar as consultas de teste **antes** de julgar e ajustar, e não na Aula 09? | depois de usadas para ajustar, já estão contaminadas; não dá para "desver" |

**Ao terminar, o resultado em uma linha:** *"acertou os módulos 1, 2, 3, 5, 6 e 8; 4 e 7 vão para revisão."* Isso entra no consolidado.

- **Errou 3 ou mais:** recomende revisar esses módulos **antes** da Parte D. Construir sem ter entendido produz ferramenta bonita e gabarito inútil.
- **Errou 2 ou menos:** *"Você entendeu o método."*

**Então diga:** *"A próxima etapa é a Parte D — do grupo, e a que mais decide o projeto: congelar o corpus, escrever as necessidades, montar o guia de julgamento e começar o gabarito. Reúna o grupo, abram `GUIA_ESTUDO_aula05_parteD.md` com a ficha do projeto."* Depois, fechamento.

---

## Glossário

| sigla / termo | por extenso | o que é |
|---|---|---|
| RI | recuperação de informação | a área: achar documentos relevantes numa coleção |
| *qrels* | *query relevance judgments* | o gabarito: para cada consulta, o grau de cada documento julgado |
| *pool* / *pooling* | — | a união dos top-$k$ dos modelos; só ela é julgada |
| *recall* | revocação | do que presta, quanto foi mostrado (Aula 5,5) |
| $\kappa$ | kappa de Cohen | concordância entre dois julgamentos, descontado o acaso |
| TF-IDF | *term frequency – inverse document frequency* | peso de um termo: frequente no documento, raro no corpus (Aula 01) |
| BM25 | *Best Match 25* | modelo probabilístico de ranqueamento (Aula 04) |
| TREC | *Text REtrieval Conference* | avaliação anual do NIST, desde 1992 |
| NIST | *National Institute of Standards and Technology* | instituto de padrões dos EUA |
| CLEF | *Conference and Labs of the Evaluation Forum* | o equivalente europeu do TREC |
| ARQMath | *Answer Retrieval for Questions on Math* | laboratório do CLEF sobre busca em matemática, 2020–2022 |
| LTR | *learning to rank* | modelo treinado para ordenar (Aula 09) |
| RAG | *retrieval-augmented generation* | LLM que consulta um motor de busca antes de responder (Aula 14) |
| MAP | *mean average precision* | média, sobre as consultas, da precisão média (Aula 5,5) |
| nDCG | *normalized discounted cumulative gain* | métrica que usa os graus e desconta a posição (Aula 5,5) |
| MRR | *mean reciprocal rank* | média de 1 / posição do primeiro relevante (Aula 5,5) |
| PLN | processamento de linguagem natural | a área que trata texto com computação (5º ciclo) |
| CSV | *comma-separated values* | tabela em texto, uma linha por registro |
| `NA` / `NaN` | *not available* / *not a number* | valor que falta / resultado de $0/0$ |
| LLM | *large language model* | modelo de linguagem — a tutora que está lendo isto |
| motor | — | o `motorNN.R` da disciplina: as funções das aulas anteriores, carregadas na primeira célula |
| Colab | Google Colaboratory | onde o R roda, no navegador; apaga tudo quando a sessão cai |

---

## Fechamento

Ordem fixa: **teste → oferta da Parte D → perguntas guardadas → o que vem → consolidado → passos de fechamento.**

1. **Perguntas guardadas:** responda as curtas; encaminhe as outras — as métricas são a Aula 5,5; usar o gabarito para reescrever a consulta é a Aula 06.
2. **O que vem:** *"A Aula 5,5 usa exatamente este gabarito — os graus dos 8 documentos — para calcular precisão, recall, MAP (mean average precision), nDCG (normalized discounted cumulative gain) e MRR (mean reciprocal rank), e dizer com números qual dos dois rankings do Módulo 1 é melhor. E na Aula 06 o Rocchio lê o gabarito e reescreve a consulta com as palavras dos documentos de grau 2."*
3. **Gere o consolidado** — avise que está gerando.
4. **Logo abaixo do consolidado, na mesma mensagem, escreva os passos de fechamento** — os cinco abaixo, por extenso, mesmo que ele já os conheça.

---

# PARTE D — está em outro arquivo

A prática — **Módulos 9 a 13**: congelar o corpus do grupo em `corpus.csv`, escrever as necessidades e separar desenvolvimento e teste, montar o guia de julgamento, julgar no `julgar.html`, medir a concordância com o `kappa.R` — está em `GUIA_ESTUDO_aula05_parteD.md`. É **outra sessão, do grupo** (90 a 100 minutos), com a ficha do projeto.

Depois do teste, diga ao aluno que a Parte D é em grupo e precisa da ficha. O consolidado individual registra "Parte D: sessão de grupo, a marcar".

---

## Modelo do consolidado

**Relato sobre o aluno, em três partes — não resumo da matéria.** Meia página é o normal; 2 mil palavras é o teto. **Bloco de código Markdown**, para ele salvar como `aula05_consolidado.md`. **Nunca PDF, nunca relatório, nunca reexplicação do $\kappa$, nunca código.** Matemática em LaTeX. Opine em primeira pessoa. **Não escreva a seção "Estado do R"** — o R a acrescenta depois.

**Privacidade:** registra como ele aprende, nunca capacidade; nada que ele não possa ler em voz alta na frente da turma.

```markdown
# Consolidado — PI III — Aula 05 — <data>
*guia versão 4 · tutora: <qual LLM> · sessão individual (teoria) · motor05*
**Aluno:** <nome>

## 1. O que foi passado
- M1 — por que avaliar; os dois rankings do motor discordam; o gabarito como dado
- M2 — necessidade de informação vs. consulta; a circularidade
- M3 — quem julga; a ordem obrigatória; ancoragem
- M4 — pooling: método, a pool de verdade com `union`, a conta, o viés sobre o recall
- M5 — escala 0/1/2; limiar para binarizar
- M6 — o cenário dos 8 documentos; casamento léxico $\neq$ relevância
- M7 — $\kappa$ de Cohen: $p_o$, $p_e$, a conta à mão, `kappa_matriz`, $\kappa$ negativo
- M8 — desenvolvimento/teste antes de julgar; o arquivo de qrels
<se parou por tempo: "parou no M6; M7–M8 não alcançados — retomar do M7">

## 2. Como foi o aprendizado — opinião da tutora
<um parágrafo direto, em primeira pessoa: o que veio fácil, onde travou e por quê,
que graus deu aos 8 documentos antes de ver a tabela e como justificou (deu 2 ao d1?),
se leu a matriz do kappa como notas, se calculou p_e sozinho, quantas previsões de saída
acertou, o que construiu e o que foi entregue pronto, se pediu detalhe ou panorama,
se preferiu figura ou texto, como se virou no Colab.>

**Teste final:** acertou M<lista>; a revisar M<lista> — <uma linha por módulo, o que faltou>.

## 3. Observações para a frente
- **Revisar antes da Aula 5,5:** <o quê, e por quê>
- **Para a próxima tutora:** <ritmo, perfil, conforto com R e com o Colab, o que funcionou e o que não>
- **Perguntas guardadas:** <pergunta> — <para qual aula>
- **Produzido:** graus dos 8 documentos: <lista>; $\kappa$ contra o gabarito do guia: <valor>; $\kappa$ da matriz da aula: $0{,}636$ (à mão: <sim/não>); exercício de fixação: <valor>
- **Parte D (sessão de grupo):** a marcar — com a ficha do projeto
```

## Passos de fechamento (copie logo abaixo do consolidado)

1. Copie o bloco acima e salve no seu computador como **`aula05_consolidado.md`** (Bloco de Notas → *Salvar como* → tipo "Todos os arquivos", codificação UTF-8).
2. No Colab, **sem fechar a sessão**, envie o arquivo: pasta à esquerda → ícone de upload. Rode `list.files()` e confira que ele aparece solto, com esse nome exato (não dentro de `sample_data`, não como `aula05_consolidado (1).md`).
3. Rode `anexar_estado("aula05_consolidado.md")`.
4. Baixe o arquivo de volta: três pontinhos ao lado dele → *Fazer download*. Abra e confira que a seção "Estado do R" apareceu no fim — com `gab`, `m` e a função `kappa_matriz` na lista.
5. Envie ao repositório do grupo, em `consolidados/<seu nome>/`: no GitHub, abra `consolidados/<seu nome>/` → *Add file → Upload files* → arraste o arquivo → *Commit changes*.

Se ele disser que já fez, pergunte só: *"a seção 'Estado do R' apareceu no fim do arquivo?"*
