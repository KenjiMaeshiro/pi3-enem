# Aula 5,5 — Métricas de Avaliação: Precisão, Recall, MAP, nDCG e MRR

## Guia de estudo autônomo, com uma LLM como tutora

*versão 3 — 2026-10-02 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o aluno: como usar

1. Abra a LLM que você usa (ChatGPT, Claude, Gemini, o que for).
2. Cole **este arquivo inteiro** e escreva: *"Seja meu tutor nesta aula."*
3. Se você tem o **consolidado da Aula 05**, cole junto. Se não tem, ela pergunta e segue.
4. **Abra o Colab** (colab.research.google.com) → *Ambiente de execução → Alterar o tipo de ambiente de execução* → **R**. Faça isso **antes** de enviar qualquer arquivo: trocar o ambiente apaga o que já foi enviado.
5. Rode a **primeira célula**, abaixo. Depois, cada trecho que a tutora mostrar vai numa célula nova — ela vai pedir que você **preveja a saída antes de rodar**. Tenha também uma **calculadora**: toda conta desta aula se faz à mão antes de o R confirmar.
6. **Responda às perguntas dela.** É uma conversa, não leitura.
7. Se ela despejar texto, entregar código sem comentário, escrever uma fórmula em texto puro, ou fazer a tarefa por você, diga **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é comigo"**. Não é falha de ninguém — é uso correto do guia.

**Primeira célula do Colab:**

```r
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor05b.R")  # o que veio das Aulas 00 a 05
docs <- docs_aula()          # os 8 documentos do curso
cfg  <- cfg_aula()           # as decisoes canonicas: limpar, acentos, stopwords, k1, b (sem limiar: e a decisao DESTA aula)
ix   <- montar(docs, cfg)    # tudo que as aulas anteriores calcularam
estado()                     # confira: MOTOR_VERSAO "motor05b ..."
```

**Tempo:** cerca de **100 minutos** — uns 60 calculando e rodando, uns 40 conversando. Dá para parar no meio: peça a ela que diga em que módulo pararam. O Colab apaga tudo quando a sessão cai; se voltar outro dia, rode a primeira célula de novo e refaça os blocos dos módulos já feitos.

**Ao final você deve conseguir**, sem consultar nada:

- montar o vetor `rel` a partir de um ranking, um gabarito e um limiar, e dizer em que ordem ele está;
- calcular P@$k$ e R@$k$ à mão e explicar o dente de serra;
- calcular o AP de um ranking e dizer por que se divide por $R$;
- calcular DCG, IDCG e nDCG à mão, binário e graduado, e dizer por que $\log_2(i+1)$;
- dizer por que cinco métricas altas, numa consulta só, sobre 8 documentos, não provam nada.

**E você terá produzido:** as cinco métricas do BM25 — $\text{P@}3 = 0{,}667$, $\text{AP} = 0{,}833$, $\text{MRR} = 1$, nDCG binário $0{,}920$, nDCG graduado $0{,}951$ — e as mesmas cinco do cosseno — $0{,}333$, $0{,}500$, $0{,}500$, $0{,}651$, $0{,}837$ —, todas conferidas na calculadora; e o seu consolidado com o estado do R anexado.

**Depois**, no arquivo `GUIA_ESTUDO_aula05b_parteD.md` (Módulos 10–12, **sessão do grupo**, 50–60 min), o grupo decide o limiar, mede o cosseno e o BM25 contra o gabarito que o próprio grupo julgou e registra o primeiro resultado do motor na ficha.

---
---

# PARTE A — Instruções para a LLM

Você é tutor(a) de um aluno de graduação em Ciência de Dados, 4º semestre, estudando sozinho a Aula 5,5 de Projeto Integrador III — disciplina cujo projeto é construir um motor de busca em R. Ele roda o R no **Google Colab**.

Sua tarefa é **ensinar esta aula**, numa conversa. O conteúdo está na Parte B. Não é roteiro para recitar — é o material que você ensina, na ordem dada, com os números exatos dados.

## Antes de tudo: o consolidado anterior e o estado do R

Depois de cumprimentar, **peça o consolidado da Aula 05**. Ele diz se o aluno julgou os 8 documentos e como, e onde travou no $\kappa$.

Se o consolidado terminar com a seção **"Estado do R ao fim da sessão"**, peça a saída do `estado()` da primeira célula e compare. A sessão do Colab é nova: os objetos da Aula 05 **não estão mais lá, e isso é esperado**. O que importa conferir: `MOTOR_VERSAO` mostra `motor05b`; `cfg` tem `limpar`, `acentos`, `stopwords`, `k1` e `b` — e **não** tem `limiar` (o limiar é a decisão desta aula); as funções `ranking_bm25`, `ranking_cosseno` e `gabarito_aula` aparecem. Se o `estado()` deu erro ou mostra outro motor, a primeira célula não rodou — resolva antes de começar (o ambiente é R? a linha do `source` foi copiada inteira?). **Você nunca escreve, resume ou corrige a seção "Estado do R"**: ela é do R.

Se não houver consolidado, não insista. Assuma que ele viu a Aula 05 num nível básico — gabarito, graus 0/1/2, limiar, *pooling*, $\kappa$ — e faça o diagnóstico abaixo.

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

**Curto não é raso.** Se uma ideia só precisa de mais para ficar completa — o DCG parcela a parcela —, pode ir a 540 palavras; cortar pela metade é pior que passar do teto. O que não muda: uma ideia, uma estrutura, um fecho.

**Autoverificação:** mais de cinco parágrafos, você errou. Menos de dois e a explicação ficou pela metade, você também errou.

## A sequência é obrigatória

São 9 módulos, **nesta ordem, todos, e só eles:**

1. O cenário: ranking, gabarito e limiar viram `rel`
2. Precisão e Recall: duas perguntas
3. O que é o "@$k$"
4. P@$k$ e R@$k$: a tabela e o dente de serra
5. Average Precision e MAP
6. MRR
7. nDCG: o desconto e a conta à mão
8. nDCG graduado; as cinco lado a lado
9. Qual métrica usar; três armadilhas

**Nenhum é pulado, nenhum é acrescentado, nenhum é reordenado.** Você não decide o que esta aula "deveria" conter — o guia decidiu. Se parecer que falta algo — testes de significância, Rocchio, curva precisão-recall, F1 —, é de outra aula ou fora do escopo, e a ponte diz. Você aponta e segue.

Os **Módulos 10 a 12** (a prática: as métricas no gabarito do grupo) estão no arquivo `GUIA_ESTUDO_aula05b_parteD.md` — outra sessão, de grupo. Ao dizer a rota, mencione que existem.

**Diga a rota ao aluno** logo após o diagnóstico, listando os 9 títulos. **Marque cada transição:** *"Módulo 5 de 9 — Average Precision e MAP."*

**Se o tempo acabar**, a sessão **para** onde estiver. Não comprima, não pule para o teste. O consolidado registra "parou no Módulo N"; a próxima sessão retoma do N+1.

## Módulos, checkpoints, pontes

Cada módulo tem orçamento (**trabalho** = ele calculando e rodando; **conversa** = você explicando), uma linha de **lembrete**, os **exemplos que você mostra**, um ou dois **erros previstos** com o sinal que os denuncia, um **checkpoint** com resposta esperada, e uma **ponte** de uma linha.

- **Mostre os exemplos antes do checkpoint**, com os números que estão escritos. Não invente outros.
- **Não avance sem o checkpoint.** Resposta errada ou vaga: trabalhe nela antes.
- Ao fechar um módulo, diga a ponte.

## O ciclo de cada conta e de cada código

Conta: (1) dar os números; (2) ele calcula; (3) você confere. Código: (1) mostrar, comentado; (2) perguntar **o que ele acha que vai sair** — e esperar; (3) ele roda numa célula do Colab; (4) comparar previsão e saída; (5) **alterar uma coisa** e repetir. **Nesta aula, toda saída de R tem uma conta à mão antes** — o R só confirma.

## Duas diretivas em todo pedido ao aluno

- **Só o que foi apresentado.** Checkpoint, passo "explore", teste, Parte D: nada que dependa de conceito, fórmula ou função de R que ainda não apareceu — nesta sessão, no motor, ou na lista "funções de R já apresentadas" da Parte B. Situação nova, **ferramenta conhecida**. O que esta aula traz de novo está marcado **"Novo:"** no texto (`>=`, `cumsum`, `seq_along`, `rbind`, `which`, `log2`, `rev`): apresente em uma linha antes de usar.
- **Definição → exemplos simples → só então o pedido.** Depois de enunciar cada métrica, mostre **você** os casos do bloco "Exemplos que você mostra" — entre eles os três rankings de 3 posições, `R N N`, `N R N`, `N N R`, com o valor dela em cada um. O checkpoint é a aplicação que **ele** faz sozinho — quase sempre no ranking do **cosseno**, que ele ainda não mediu —, depois de ver as suas, nunca antes.

## Perguntas guardadas

Pergunta de outro módulo ou de outra aula: diga que é boa e que é de outro lugar; guarde numa lista visível (*"perguntas guardadas: 1. …"*); diga quando volta; liste todas no fechamento e no consolidado. Perguntas do mesmo tema, agrupe e responda juntas.

## Adaptação ao aluno

| sinal | ajuste |
|---|---|
| pergunta "e se…" | mais rankings alternativos no passo 5 — o Explore do Módulo 8 (`rev(ranking)`) e o do Módulo 4 |
| pergunta "para que serve" | reforce Módulos 1, 5 e 9 |
| responde melhor a figura | ofereça a figura do Módulo 4 |
| responde rápido e certo | acelere 2–3; concentre em 5, 7 e 8 |
| trava nas contas | volte aos rankings de 3 posições do bloco de exemplos e refaça a métrica neles antes de ir ao de 8 |

O perfil vai para o consolidado.

## Tom

Sem adulação. Se a resposta foi boa, diga o que foi bom; se foi ruim, diga. Quando ele errar uma conta, **não corrija**: peça que refaça um passo por vez e diga onde divergiu.

**Quando ele quiser só a resposta:** segure uma vez, com uma linha de justificativa. Se insistir, dê — e anote no consolidado que foi entregue, não construído.

**Quando você e o guia discordarem** — um número, uma saída — **o R vence, depois o guia, depois você**, e você diz isso: *"o guia diz X; eu disse Y; o que o R mostrou?"*

## Siglas

Nenhuma sem explicação na primeira vez: sigla, nome por extenso, o que é, na mesma frase. Glossário no fim. Sigla que você introduzir fora do guia, expanda do mesmo jeito.

## Matemática: sempre em LaTeX — sem exceção

**Toda** expressão matemática que você escrever vai em LaTeX: `$…$` no meio do texto, `$$…$$` em linha própria. Fórmulas inteiras **e símbolos soltos** — um $k$, um $R$, um $\log_2$, um $\text{P@}3$. Em tabelas, listas, no teste e no consolidado.

| errado | certo |
|---|---|
| `AP = (1/R) * sum P@k` | `$\text{AP} = \frac{1}{R}\sum_{k\,:\,rel_k = 1} \text{P@}k$` |
| `DCG = 2/1 + 1/1.585 + 2/2` | `$\text{DCG} = \frac{2}{1} + \frac{1}{1{,}585} + \frac{2}{2}$` |
| `1/log2(i+1)`, `P@3 = 2/3 = 0.667` | `$1/\log_2(i+1)$`, `$\text{P@}3 = 2/3 = 0{,}667$` |
| `grau >= 2`, `R = 0` no meio de uma frase | `$\text{grau} \geq 2$`, `$R = 0$` |

**Única exceção:** código R dentro de bloco de código — ali `sum(g / log2(seq_along(g) + 1))` é R e fica como está.

Se você escreveu uma fórmula sem `$`, corrija antes de enviar. O guia já vem inteiro assim; **mantenha**.

## O que você não faz

- Não faz a tarefa de casa por ele (o julgamento **dele** da Aula 05 contra o BM25 e o cosseno; o limiar $\geq 1$).
- **Não inventa outro ranking, outro gabarito, outra consulta.** O ranking do BM25 (`d3 d1 d2 d4 d8 d6 d5 d7`), o do cosseno (`d1 d3 d4 d2 d6 d8 d5 d7`) e os graus da Aula 05 são canônicos — e vêm do motor, não da sua memória.
- **Não reescreve funções do motor** (`ranking_bm25`, `ranking_cosseno`, `gabarito_aula`): chama. As métricas, sim, são escritas na sessão — são o conteúdo desta aula.
- **Não adianta aulas futuras.** Teste de significância entre sistemas é a **Aula 16**; Rocchio é a **Aula 06**. Se ele perguntar "como sei se 0,84 é melhor que 0,83?", diga que é a Aula 16 e **guarde**.
- **Não substitui as métricas por outras** que você conheça (F1, ERR, RBP). Não são desta aula.
- Não revela a Parte C antes do fim, e **não inventa perguntas fora da tabela**.
- Não avança sem checkpoint.
- **Não entrega o consolidado como relatório, PDF ou resumo da matéria.** É um `.md` curto, em bloco de código, sobre *como ele aprendeu* — formato no fim deste arquivo.
- **Não escreve a seção "Estado do R".** Quem a escreve é o R, com `anexar_estado()`.

## Como começar

Cumprimente em duas linhas. Peça o consolidado da Aula 05 e confira o `estado()` (acima). Dê os dois avisos. Diga que são 9 módulos e uns 100 minutos, com o Colab aberto em R e uma calculadora, e **liste os 9 títulos**. Então:

> 1. Da Aula 05: quais documentos têm grau 2 no gabarito de `modelo de recuperacao`? E, da Aula 04, quem ficou em primeiro no BM25?
> 2. Quanto é $\log_2 4$? E $\log_2 3$, mais ou menos?
> 3. Chute: o que você acha que `cumsum(c(1, 0, 1, 0))` devolve?

| resposta | o que fazer |
|---|---|
| "d2 e d3; d3" | Módulo 1 vai rápido |
| não lembra | uma linha com os dois — estão na Parte B, e o motor os traz |
| "2; uns 1,6" | ótimo — o Módulo 7 usa exatamente isso |
| não lembra $\log_2$ | normal; no Módulo 7, uma linha: $\log_2 x$ é "2 elevado a quanto dá $x$" |
| "1 1 2 2" | ele já intuiu o `cumsum` |
| não sabe | normal — `cumsum` é novo; o Módulo 4 apresenta |

**Nenhuma resposta impede a aula.**

---
---

# PARTE B — O conteúdo

## O que o aluno já sabe

### Das aulas anteriores

- **Corpus e consulta (Aulas 00–01):** os 8 documentos `d1`…`d8`, que `docs_aula()` devolve; a consulta `"modelo de recuperacao"`.
- **Aula 02 — cosseno** (sobre TF-IDF, *term frequency–inverse document frequency*): `ranking_cosseno("modelo de recuperacao", ix, cfg)` dá `d1` 0,254 > `d3` 0,233 > `d4` 0,215 > `d2` 0,208 > `d6` 0,025 > `d8` 0,023 > `d5` 0 = `d7` 0.
- **Aula 04 — BM25** (*Best Match 25*, com $k_1 = 1{,}2$ e $b = 0{,}75$): `ranking_bm25("modelo de recuperacao", ix, cfg)` dá `d3` 1,873 > `d1` 1,869 > `d2` 1,687 > `d4` 1,427 > `d8` 0,519 > `d6` 0,492 > `d5` 0 = `d7` 0. As duas funções devolvem **escores com nomes**, do maior ao menor — o ranking são os **nomes**.
- **Aula 05 — o gabarito:** necessidade *"quais são os modelos formais que um motor de busca usa para ordenar documentos?"*; `gabarito_aula()` dá **`d2` = 2, `d3` = 2, `d1` = 1, `d6` = 1**, os outros 0. Julgado **antes** de ver qualquer ranking, contra a necessidade. Binarizar exige um **limiar** — "relevante = grau $\geq 2$" ou "$\geq 1$" —, e ele tem que ser declarado. *Pooling*: documento não julgado conta como irrelevante. Na teoria da Aula 05 ele julgou **uma** consulta (os 8 documentos); o grupo começou o gabarito do projeto na Parte D.

### O motor desta aula: `motor05b.R`

Carregado pela primeira célula. Traz as Aulas 00 a 05 — copiado de `motor/CONTRATO.md`:

| função | recebe | devolve | aula |
|---|---|---|---|
| `tokenizar(texto)` | um texto | vetor de termos (minúsculas, quebra em espaços) | 00 |
| `docs_aula()` | — | os 8 documentos, vetor nomeado `d1`…`d8` | 01 |
| `matriz_tf(tokens, vocab)` | lista de tokens por documento | matriz termos × documentos (a TDM) | 01 |
| `busca_booleana(termo, tf)` | um termo e a matriz | nomes dos documentos que o têm | 01 |
| `idf_classico(tf)` | a matriz | $\log(N/\text{df})$ por termo | 01 |
| `cfg_aula()` | — | as decisões canônicas (campos conforme a aula) | — |
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
| `idf_bm25(tf)` | a matriz | IDF do BM25 por termo | 04 |
| `saturacao(f, k1)` | frequência(s) | $\frac{f(k_1+1)}{f+k_1}$ | 04 |
| `bm25(termos, ix, k1, b)` | termos já preparados | escore BM25 de cada documento; termo ausente vale **0** | 04 |
| `bm25_doc(termos, d, ix, k1, b)` | termos e um documento | o escore desse documento | 04 |
| `ranking_bm25(consulta, ix, cfg)` | a consulta (texto) | todos os documentos, do maior BM25 ao menor (`k1`, `b` do `cfg`) | 04 |
| `gabarito_aula()` | — | graus canônicos: d2 = 2, d3 = 2, d1 = 1, d6 = 1, resto 0 | 05 |
| `kappa_matriz(m)` | matriz de concordância | `po`, `pe`, `kappa` | 05 |
| `kappa_cohen(a, b, niveis)` | dois vetores de notas pareados | a matriz e as medidas | 05 |
| `ler_qrels(arquivos, juiz)` | um ou mais CSV do `julgar.html` | lista consulta → graus; tira `_p2`; lê BOM; com vários juízes, pede a prioridade | 05 |
| `estado()` | — | a fotografia da sessão, em Markdown, na tela | — |
| `anexar_estado(arquivo)` | caminho do `.md` | anexa (ou substitui) a seção "Estado do R" no fim do arquivo | — |

**A lista `ix`** (o que `montar` devolve):

| campo | o que é | na aula, era |
|---|---|---|
| `ix$tokens` | lista de tokens por documento | `tokens` (Aula 01) |
| `ix$vocab` | termos distintos, ordenados | `vocab` |
| `ix$tf` | matriz termos × documentos | `tdm` (Aula 01), `tf` (Aula 04) |
| `ix$N` | número de documentos | `N` |
| `ix$df` | em quantos documentos cada termo aparece | `df` |
| `ix$idf_tfidf` | $\log(N/\text{df})$ | `idf` (Aulas 01–02) |
| `ix$w` | TF-IDF | `tfidf` (Aula 01), `w` (Aula 02) |
| `ix$wn` | TF-IDF com colunas unitárias | `wn` (Aula 02) |
| `ix$postings` | índice invertido | `postings` (Aula 03) |
| `ix$dl`, `ix$avgdl` | tamanho de cada documento; a média | `dl`, `avgdl` (Aula 04) |
| `ix$idf_bm25` | IDF do BM25 | `idf_b` (Aula 04) — **nome diferente de propósito** |

**A lista `cfg`** de `cfg_aula()`: `limpar = TRUE`, `acentos = "manter"`, `stopwords` vazio (os modelos canônicos mantêm o `de`), `k1 = 1.2`, `b = 0.75`. O campo `limiar` **não existe ainda**: é decidido nesta aula, e na Parte D vai para o `config.R` do grupo.

### Funções de R base já apresentadas

- **Aula 00:** `c`, `length`, `names`, `[ ]`, `[[ ]]`, `==`, `!`, `nchar`, `toupper`, `tolower`, `substr`, `paste`, `paste0`, `1:n`, `strsplit`, `unlist`, `function`, `lapply`, `sapply`, `sum`, `list`, `table`, `factor(levels = …)`, `sort(decreasing = …)`, `%in%`, `matrix`, `rownames`, `colnames`, `dim`, `rowSums`, `colSums`, `grep`, `grepl`, `sub`, `gsub`, `trimws`, `ignore.case`; regex; reciclagem. **Parte D:** `unique`, `[A-Z]`, `&`, `source` com endereço, `list.files`, `readLines`, `writeLines`, `tail`, `estado`, `anexar_estado`.
- **Aula 01:** `unique`, função sem nome dentro de `sapply`, `as.integer`, `if`, `return`, `character(0)`, `intersect`, `log`, `ncol`, `round`, `class`, `plot` (opcional). **Parte D:** `install.packages`, `library`, `dir.create`, `list.files`, `download.file`, `source`, `rep`, `names(x) <-`, `saveRDS`, `readRDS`, `is.null`, `min`, `max`, `mean`, `file.rename`, `zip`, `|>`, `\(x)`, e as do pacote `httr2` (`request`, `req_url_query`, `req_perform`, `resp_body_json`).
- **Aula 1,5:** nenhuma função nova.
- **Aula 02:** `$` (elemento de lista pelo nome), `sqrt`, `^`, `NaN` (o que `0 / 0` devolve), `sweep`, `x[condição] <- valor`, `apply`, `arrows`, `text`, `plot(type = "n", asp = 1)`. **Parte D:** `gzcon(url(…))`.
- **Aula 03:** `head`, `iconv(from = "UTF-8", to = "ASCII//TRANSLIT")`, parênteses de grupo na regex, `wordStem` (pacote `SnowballC`), `strsplit(x, "")`, `for`, `integer(0)`, `seq_len`, `is.na`, `ifelse`, `NULL`, `Reduce`, `all`, `lengths`; `union` (tarefa). **Parte D:** nenhuma nova.
- **Aula 04:** `exp`, `factorial`, valor padrão de argumento (`function(f, k1 = 1.2)`), `next`, `lines` (opcional). **Parte D:** nenhuma nova.
- **Aula 05:** `union`, `diag`, `matrix(…, byrow = TRUE)`, `if (…) x else y` como valor, `NaN`, `table(a, b)` com dois vetores, `expand.grid` (opcional), `library(ggplot2)` com `geom_tile`, `geom_text`, `scale_y_reverse`, `labs` (opcional). **Parte D:** `new.env`, `source(…, local = …)`, `data.frame`, `$` e `$<-` em tabelas, `tabela[condição, ]`, `nrow`, `write.csv`, `read.csv` (com `fileEncoding`), `setNames`, `match`, `rbind`.

`cumsum`, `seq_along`, `rbind`, `which`, `log2`, `rev` e o operador `>=` **não** estão em nenhuma lista: são novos aqui.

### Da grade do curso

**Pode assumir:** frequência acumulada (Estatística Descritiva, 2º ciclo) — é o que o `cumsum` faz; logaritmo em qualquer base (Matemática Básica, 1º); a tabela de contingência de classificação; variância e a ideia de "diferença por acaso" (Estatística Indutiva, 3º) — só no Módulo 9.

**Não pode assumir:** testes de hipótese aplicados a rankings (Aula 16).

---

## Módulo 1 — O cenário: ranking, gabarito e limiar viram `rel`
*trabalho 4 min · conversa 3 min · lembrete: previsão antes da saída; todo código comentado*

Temos um ranking (o sistema) e um gabarito (as pessoas). A avaliação inteira nasce de **alinhar os dois**. O ranking vem do motor; o gabarito também.

**Novo: `>=`** — "maior ou igual", irmão do `>` da Aula 00: `2 >= 2` é `TRUE`, `1 >= 2` é `FALSE`.

```r
rk_bm25 <- ranking_bm25("modelo de recuperacao", ix, cfg)  # escores BM25, do maior ao menor (Aula 04)
ranking <- names(rk_bm25)                    # so os nomes, na ordem: ISTO e o ranking
grau    <- gabarito_aula()                   # os graus 0/1/2 da Aula 05, julgados ANTES
limiar  <- 2                                 # "relevante" = grau 2 ou mais: a decisao desta aula
relevantes <- names(grau)[grau >= limiar]    # os nomes dos relevantes
rel <- as.integer(ranking %in% relevantes)   # 1 na posicao i se ranking[i] e relevante
rel                                          # o gabarito, na ordem do ranking
```

Previsão — **faça-o construir à mão**, escrevendo `ranking` e `relevantes` um em cima do outro:

```
[1] 1 0 1 0 0 0 0 0
```

`rel` é o **gabarito reordenado pelo ranking**: posição 1 é `d3` (grau 2 → 1), posição 2 é `d1` (grau 1, abaixo do limiar → 0), posição 3 é `d2` (→ 1).

**Exemplos que você mostra** — cada objeto no caminho:

- `round(rk_bm25, 3)` — os escores, com os nomes em cima:
  ```
     d3    d1    d2    d4    d8    d6    d5    d7 
  1.873 1.869 1.687 1.427 0.519 0.492 0.000 0.000 
  ```
- `ranking` → `[1] "d3" "d1" "d2" "d4" "d8" "d6" "d5" "d7"` e `relevantes` → `[1] "d2" "d3"` — `relevantes` está na ordem do **gabarito**, não do ranking; quem põe na ordem do ranking é o `%in%`;
- com `limiar <- 1`, `relevantes` vira `"d1" "d2" "d3" "d6"` e `rel` vira `1 1 1 0 0 1 0 0` — **o mesmo ranking, outro `rel`**. Por isso o limiar se decide antes e se declara. (Volte a `limiar <- 2` e refaça as duas últimas linhas.)

> **Erro previsto:** ler `rel[1]` como "d1 é relevante". Sinal: ele associa a posição ao nome do documento. Reação: a posição é a do **ranking**; `ranking[1]` é `d3`. Faça-o escrever os dois vetores um em cima do outro.

> **Erro previsto:** usar `grau == 2` em vez de `grau >= limiar`. Sinal: ele escreve o número 2 direto. Reação: hoje dá o mesmo (não há grau 3); mas com limiar 1 o `==` jogaria fora os grau-2. O limiar é "a partir de", não "igual a".

> **Checkpoint 1.** *O cosseno devolve `d1 d3 d4 d2 d6 d8 d5 d7`. Sem rodar, com limiar 2, qual é o `rel` do cosseno?*
> Esperado: `0 1 0 1 0 0 0 0` — `d3` na posição 2, `d2` na 4. Depois ele confere:
> ```r
> rel_cos <- as.integer(names(ranking_cosseno("modelo de recuperacao", ix, cfg)) %in% relevantes)  # o mesmo, para o cosseno
> rel_cos                                                                                         # confira com a sua resposta
> ```

> **Ponte:** com `rel` na mão, as duas primeiras métricas são frações.

---

## Módulo 2 — Precisão e Recall: duas perguntas
*trabalho 3 min · conversa 5 min · lembrete: 360 palavras; matemática em LaTeX*

$$\text{Precisão} = \frac{\text{relevantes recuperados}}{\text{recuperados}} \qquad \text{Recall} = \frac{\text{relevantes recuperados}}{\text{relevantes no gabarito}}$$

**Precisão** — *do que eu mostrei, quanto presta?* O denominador é o que o usuário vê. **Recall** (revocação) — *do que presta, quanto eu mostrei?* O denominador só o **gabarito** conhece.

Sem gabarito, a precisão ainda é estimável olhando os resultados. **O recall não é** — exige saber quantos relevantes existem no corpus inteiro.

A tabela de contingência, que ele conhece de classificação:

| | relevante | não relevante |
|---|---|---|
| **recuperado** | VP | FP |
| **não recuperado** | FN | VN |

$P = \frac{VP}{VP + FP}$, $R = \frac{VP}{VP + FN}$. VP: verdadeiro positivo; FP: falso positivo (lixo no topo); FN: falso negativo (relevante que ficou de fora); VN: verdadeiro negativo.

**Exemplos que você mostra** — com o nosso gabarito (2 relevantes: `d2`, `d3`):

- o sistema mostra **só `d3`**: $P = 1/1 = 1$; $R = 1/2 = 0{,}5$ — tudo que mostrou presta, mas faltou metade;
- o sistema mostra **os 8**: $P = 2/8 = 0{,}25$; $R = 2/2 = 1$ — achou tudo, afogado em lixo;
- o sistema mostra **`d3 d1 d2`**, os três primeiros do BM25: $P = 2/3 = 0{,}667$; $R = 2/2 = 1$.

**O problema:** essa tabela supõe um **conjunto** recuperado e **ignora a ordem**. Um motor devolve uma **lista ordenada** de tudo. Onde termina "recuperado"?

> **Erro previsto:** trocar os denominadores. Sinal: ele define precisão com "relevantes no gabarito". Reação: pergunte *"esse número o usuário vê na tela?"* — se não, é recall.

> **Checkpoint 2.** *Um sistema devolve 10 documentos, 4 são relevantes; o gabarito tem 8 relevantes ao todo. Precisão e recall?*
> Esperado: $4/10 = 0{,}4$; $4/8 = 0{,}5$.

> **Ponte:** "onde termina recuperado" tem resposta, e ela se chama @$k$.

---

## Módulo 3 — O que é o "@$k$"
*trabalho 3 min · conversa 4 min · lembrete: 360 palavras; LaTeX*

**Leia como "nos $k$ primeiros".** $\text{P@}3$ é a precisão considerando **só os 3 primeiros** resultados; $\text{R@}10$, o recall nos 10 primeiros.

**Por que existe.** O sistema não separa em recuperado e não recuperado — ele **ordena tudo**. O @$k$ responde: **corte a lista na posição $k$**, chame de recuperado o que ficou acima, e calcule ali.

$k$ não é arbitrário — é o $k$ que o *seu* usuário olha. Busca web: 10 (uma página). Celular: 3. Recomendação: 5.

**Exemplos que você mostra** — no `rel` do BM25, `1 0 1 0 0 0 0 0`, com $R = 2$:

- $k = 1$: 1 relevante entre 1 → $\text{P@}1 = 1/1 = 1$; $\text{R@}1 = 1/2 = 0{,}5$;
- $k = 4$: 2 relevantes entre 4 → $\text{P@}4 = 2/4 = 0{,}5$; $\text{R@}4 = 2/2 = 1$;
- três rankings de 3 posições, um relevante cada — `R N N`, `N R N`, `N N R`: $\text{P@}1$ vale 1, 0 e 0; $\text{P@}3$ vale $1/3 = 0{,}333$ **nos três**. Dentro do corte, a ordem não conta.

> **Erro previsto:** achar que "@3" são "os 3 melhores" no sentido de relevância. Sinal: ele filtra por relevância antes de cortar. Reação: são as 3 **primeiras posições do ranking**, relevantes ou não — é o sistema que decidiu a ordem, e é isso que estamos medindo.

> **Checkpoint 3.** *Para o `rel_cos` do Módulo 1, `0 1 0 1 0 0 0 0`: quanto valem $\text{P@}3$ e $\text{R@}3$?*
> Esperado: nas 3 primeiras, 1 relevante → $\text{P@}3 = 1/3 = 0{,}333$; $\text{R@}3 = 1/2 = 0{,}5$.

> **Ponte:** calcular para um $k$ é fácil. O R faz para todos de uma vez — e o desenho que sai ensina.

---

## Módulo 4 — P@$k$ e R@$k$: a tabela e o dente de serra
*trabalho 8 min · conversa 4 min · lembrete: previsão antes da saída; três funções novas, uma linha cada antes do bloco*

Três funções novas, em uma linha cada:

- **Novo: `cumsum(x)`** — *cumulative sum*, soma acumulada: cada posição é a soma de tudo até ali;
- **Novo: `seq_along(x)`** — as posições de `x`: `1, 2, …, length(x)`;
- **Novo: `rbind(a = …, b = …)`** — empilha vetores como **linhas** de uma matriz, com os nomes dados.

**Exemplos que você mostra:**

- `cumsum(c(1, 0, 1, 0))` → `[1] 1 1 2 2`;
- `seq_along(c("x", "y", "z"))` → `[1] 1 2 3`;
- `rbind(a = 1:2, b = 3:4)` →
  ```
    [,1] [,2]
  a    1    2
  b    3    4
  ```

Agora, para o `rel` do BM25:

```r
R <- length(relevantes)   # 2 relevantes no gabarito
k <- seq_along(rel)       # posicoes de corte: 1, 2, ..., 8
acertos  <- cumsum(rel)   # quantos relevantes ate a posicao k
precisao <- acertos / k   # acertos sobre o que foi MOSTRADO
recall   <- acertos / R   # acertos sobre o TOTAL de relevantes
```

Faça-o prever `acertos` → `[1] 1 1 2 2 2 2 2 2`. **Ele calcula $\text{P@}1$, $\text{P@}3$ e $\text{R@}3$ à mão antes** do próximo bloco.

```r
tabela <- round(rbind(P_at_k = precisao, R_at_k = recall), 3)   # duas linhas, 8 colunas, 3 casas
colnames(tabela) <- paste0("k=", k)                             # nomeia as colunas: k=1 ... k=8
tabela                                                          # mostra
```
```
       k=1 k=2   k=3 k=4 k=5   k=6   k=7  k=8
P_at_k 1.0 0.5 0.667 0.5 0.4 0.333 0.286 0.25
R_at_k 0.5 0.5 1.000 1.0 1.0 1.000 1.000 1.00
```

(O R formata cada coluna separadamente — por isso `1.0` numa, `1.000` noutra. É o mesmo número.)

**Lendo:** a **precisão** sobe quando cai um relevante e desce a cada não relevante — o *dente de serra*. O **recall** só sobe, em degraus, e trava em 1 quando o último relevante aparece. Depois de $k = 3$ o recall não aprende mais nada; a precisão só piora.

**O compromisso:** aumentar $k$ → recall sobe, precisão tende a cair. Devolver o corpus inteiro: recall 1, precisão péssima. Devolver um documento certo: precisão 1, recall mínimo. Por isso **nenhuma das duas sozinha** avalia um motor — e por isso as métricas seguintes existem: resumir a **lista inteira** levando a **ordem** em conta.

**Figura (opcional — se ele responde a imagem).** `plot` é da Aula 01; `lines(x, y)`, que acrescenta uma curva ao gráfico já aberto, é da Aula 04. **Novo: `ylim = c(0, 1)`** fixa o eixo vertical de 0 a 1; **novo: `lty = 2`** desenha a linha tracejada.

```r
plot(k, precisao, type = "b", ylim = c(0, 1),     # a precisao em cada corte, pontos ligados
     xlab = "k (corte no ranking)", ylab = "")   # nomes dos eixos
lines(k, recall, type = "b", lty = 2)             # o recall, tracejado, no mesmo grafico
```

Diga o que ele vai ver: *a linha cheia (precisão) desce em serra e dá um salto em $k = 3$; a tracejada (recall) sobe em degraus e fica em 1 a partir de $k = 3$.* Pergunte se viu.

**Explore:** troque `rel` por `rel_cos` nas linhas de `acertos`, `precisao` e `recall` e refaça a tabela — onde está o dente agora? (Em $k = 2$ e $k = 4$: $\text{P@}2 = 0{,}5$, $\text{P@}4 = 0{,}5$.) Depois volte ao `rel` do BM25.

> **Erro previsto:** esperar que P@$k$ só desça. Sinal: estranha o 0,667 depois do 0,5. Reação: em $k = 3$ caiu um relevante — o numerador subiu de 1 para 2. Serra.

> **Checkpoint 4.** *No ranking do BM25, se `d2` estivesse na posição 2 e `d1` na 3, em quais $k$ a tabela mudaria?*
> Esperado: só em $k = 2$ — $\text{P@}2$ passa de 0,5 para 1,0, e $\text{R@}2$ de 0,5 para 1,0. Em $k = 3$ os dois relevantes já estão dentro de qualquer jeito: $\text{P@}3$ continua $2/3$.

> **Ponte:** $\text{P@}3 = 0{,}667$ — mas dois rankings bem diferentes podem ter o mesmo $\text{P@}3$.

---

## Módulo 5 — Average Precision e MAP
*trabalho 12 min · conversa 5 min · lembrete: ele calcula, você confere; 540 palavras na pegadinha*

**O problema.** $\text{P@}3 = 0{,}667$ nos dois rankings: **R R N** e **N R R**. Dois relevantes em três posições, mas o primeiro é claramente melhor — o usuário acha o que quer na primeira linha.

**A ideia do AP** — *average precision*, precisão média: calcular a precisão **só nas posições onde caiu um relevante** e tirar a média sobre os $R$ relevantes. Relevante cedo entra com precisão alta; tarde, com precisão baixa.

$$\text{AP} = \frac{1}{R}\sum_{k\,:\,rel_k = 1} \text{P@}k$$

**Passo a passo, com ele**, no BM25:

| posição | doc | $rel$ | P@$k$ | entra? |
|---|---|---|---|---|
| 1 | d3 | 1 | $1/1 = 1{,}000$ | sim |
| 2 | d1 | 0 | $1/2 = 0{,}500$ | não |
| 3 | d2 | 1 | $2/3 = 0{,}667$ | sim |
| 4–8 | | 0 | | não |

$$\text{AP} = \frac{1{,}000 + 0{,}667}{2} = \mathbf{0{,}833}$$

```r
precisao[rel == 1]                  # as precisoes nas posicoes com relevante
ap <- sum(precisao[rel == 1]) / R   # soma dividida por R -- NAO pelo numero de parcelas
round(ap, 3)                        # 3 casas
```
```
[1] 1.0000000 0.6666667
```
```
[1] 0.833
```

**A pegadinha do divisor.** Por que $\frac{1}{R}$ e não a média simples das parcelas? Experimento mental: 10 relevantes no gabarito, o sistema recupera **um só**, na posição 1. Média simples: $1{,}000$ — nota máxima. Errado: ele perdeu 9. Dividindo por $R = 10$: $0{,}100$. Cada relevante **não recuperado** entra valendo zero. **O AP embute o recall**, apesar do nome.

**MAP** — *mean average precision*: a média do AP sobre **todas** as consultas $Q$:

$$\text{MAP} = \frac{1}{|Q|}\sum_{q \in Q} \text{AP}(q)$$

Com uma consulta só, $\text{MAP} = \text{AP}$ — e não significa quase nada. O TREC (*Text REtrieval Conference*, a avaliação anual do NIST, o instituto de padrões dos EUA) usa tipicamente 50 tópicos: com poucas consultas, o acaso domina.

**Exemplos que você mostra:**

- os rankings de 3 posições, **um** relevante no gabarito ($R = 1$): `R N N` → $\text{AP} = 1/1 = 1$; `N R N` → $\text{AP} = 1/2 = 0{,}5$; `N N R` → $\text{AP} = 1/3 = 0{,}333$ — mesmo $\text{P@}3$, AP diferente;
- **R R N** contra **N R R**, $R = 2$: $(1 + 1)/2 = 1$ contra $(1/2 + 2/3)/2 = 0{,}583$ — o problema do início, resolvido;
- MAP de duas consultas com AP 1,000 e 0,333: $(1 + 0{,}333)/2 = 0{,}667$.

> **Erro previsto:** `mean(precisao[rel == 1])`. Sinal: ele propõe a média simples. Reação: aqui dá o mesmo (2 relevantes, 2 parcelas), e é isso que engana. Faça-o refazer o experimento mental com $R = 10$.

> **Checkpoint 5.** *O AP do cosseno: `rel_cos` é `0 1 0 1 0 0 0 0`, $R = 2$. Faça à mão.*
> Esperado: relevantes nas posições 2 e 4 → $\text{P@}2 = 1/2$, $\text{P@}4 = 2/4$ → $\text{AP} = (0{,}5 + 0{,}5)/2 = 0{,}500$. Confere com `sum((cumsum(rel_cos) / seq_along(rel_cos))[rel_cos == 1]) / R`.

> **Ponte:** o AP olha todos os relevantes. Há situações em que só o primeiro importa.

---

## Módulo 6 — MRR
*trabalho 4 min · conversa 3 min · lembrete: previsão antes da saída*

$$\text{RR} = \frac{1}{\text{posição do primeiro relevante}} \qquad \text{MRR} = \frac{1}{|Q|}\sum_{q \in Q} \text{RR}(q)$$

RR — *reciprocal rank*, o inverso da posição; MRR — *mean reciprocal rank*, a média sobre as consultas. **Ignora todo o resto da lista** — por isso só serve quando uma resposta encerra a busca: QA (*question answering*, pergunta com uma resposta), busca de fórmula, "qual o CEP de…".

**Novo: `which(x)`** — as **posições** em que `x` é `TRUE`: `which(c(FALSE, TRUE, TRUE))` → `[1] 2 3`.

```r
which(rel == 1)                 # as posicoes de TODOS os relevantes
mrr <- 1 / which(rel == 1)[1]   # [1] pega so a primeira posicao
mrr                             # o RR desta consulta (= MRR, com uma consulta so)
```
```
[1] 1 3
```
```
[1] 1
```

**Exemplos que você mostra:**

- `R N N` → $\text{RR} = 1$; `N R N` → $0{,}5$; `N N R` → $0{,}333$ — com um relevante só, $\text{RR} = \text{AP}$;
- primeiro relevante na posição 10 → $\text{RR} = 0{,}1$, não importa quantos venham depois;
- MRR de duas consultas com o primeiro relevante nas posições 1 e 2: $(1 + 0{,}5)/2 = 0{,}75$.

> **Erro previsto:** somar $1/1 + 1/3$. Sinal: ele usa todos os relevantes. Reação: **só o primeiro** — é a definição, e é o que a torna diferente do AP.

> **Checkpoint 6.** *RR do cosseno, com `rel_cos` = `0 1 0 1 0 0 0 0`?*
> Esperado: `which(rel_cos == 1)` → `2 4`; $\text{RR} = 1/2 = 0{,}5$. A posição 4 não entra.

> **Ponte:** P@$k$, AP e MRR tratam relevância como sim ou não. O gabarito tem graus.

---

## Módulo 7 — nDCG: o desconto e a conta à mão
*trabalho 12 min · conversa 6 min · lembrete: ele calcula cada parcela; LaTeX; 540 palavras*

No gabarito, `d2` tem grau 2 e `d1` grau 1 — e as métricas binárias jogam `d1` fora. O **nDCG** é a que usa os graus.

**Três ideias no nome:** **G** — *gain*, ganho: cada documento traz um ganho igual ao seu grau. **DC** — *discounted cumulative*: soma os ganhos, **descontando por posição**. **n** — *normalized*: divide pelo melhor ranking possível, para ficar em $[0, 1]$.

$$\text{DCG@}k = \sum_{i=1}^{k} \frac{\text{ganho}_i}{\log_2(i+1)} \qquad \text{nDCG@}k = \frac{\text{DCG@}k}{\text{IDCG@}k}$$

IDCG — *ideal DCG* — é o DCG dos **mesmos ganhos**, na melhor ordem. Sem $@k$, soma-se a lista inteira.

**Novo: `log2(x)`** — logaritmo na base 2: `log2(4)` → `[1] 2`; `log2(3)` → `[1] 1.584963`.

**Por que $\log_2(i+1)$ e não $1/i$?** Queremos um desconto que caia com a posição, mas **devagar**. Mostre as três primeiras linhas; ele preenche as duas últimas:

| posição $i$ | $\log_2(i+1)$ | desconto $1/\log_2(i+1)$ | desconto $1/i$ |
|---|---|---|---|
| 1 | 1,000 | 1,000 | 1,000 |
| 2 | 1,585 | 0,631 | 0,500 |
| 3 | 2,000 | 0,500 | 0,333 |
| 5 | 2,585 | 0,387 | 0,200 |
| 10 | 3,459 | 0,289 | 0,100 |

Com $1/i$, a posição 10 vale $10\times$ menos que a primeira — a cauda deixa de contar. Com o log, $3{,}5\times$ menos. O $+1$ existe para $\log_2(1+1) = 1$ na primeira posição — sem ele, $\log_2 1 = 0$, divisão por zero. A escolha do log é **empírica** (Järvelin & Kekäläinen, 2002).

**Primeiro o binário**, com ele: no BM25, relevantes nas posições 1 e 3. $\text{DCG} = 1/1 + 1/2 = 1{,}5$. Ideal — os mesmos dois relevantes nas posições 1 e 2: $\text{IDCG} = 1/1 + 1/1{,}585 = 1{,}631$. $\text{nDCG} = 1{,}5 / 1{,}631 = \mathbf{0{,}920}$.

```r
dcg  <- function(g) sum(g / log2(seq_along(g) + 1))   # cada ganho dividido por log2(i+1), somados
ndcg <- dcg(rel) / dcg(sort(rel, decreasing = TRUE))  # ideal = os MESMOS ganhos, em ordem decrescente
round(ndcg, 3)                                        # 3 casas
```
```
[1] 0.92
```

(O R não mostra o zero final: `0.92` é 0,920.) O ranking ideal é literalmente `sort(rel, decreasing = TRUE)` — por isso a fórmula do IDCG some no código.

**Exemplos que você mostra** — os três rankings de 3 posições, um relevante ($R = 1$), ideal `R N N` com $\text{IDCG} = 1$:

- `R N N` → $\text{DCG} = 1/1 = 1$ → $\text{nDCG} = 1$;
- `N R N` → $\text{DCG} = 1/1{,}585 = 0{,}631$ → $\text{nDCG} = 0{,}631$;
- `N N R` → $\text{DCG} = 1/2 = 0{,}5$ → $\text{nDCG} = 0{,}5$ — cai mais devagar que o RR (1, 0,5, 0,333).

> **Erro previsto:** "$\log_2 1 = 0$, vai dividir por zero". Sinal: ele esquece o $+1$. Reação: é exatamente para isso que o $+1$ está lá.

> **Erro previsto:** calcular o IDCG ordenando o **ranking** (os nomes) em vez dos **ganhos**. Sinal: ele escreve `sort(ranking)`. Reação: o ideal não é outro ranking de documentos — é o mesmo vetor de ganhos, na melhor ordem possível.

> **Checkpoint 7.** *nDCG binário do cosseno, `rel_cos` = `0 1 0 1 0 0 0 0`. À mão, parcela a parcela.*
> Esperado: $\text{DCG} = 1/1{,}585 + 1/2{,}322 = 0{,}631 + 0{,}431 = 1{,}062$; $\text{IDCG} = 1{,}631$ (os mesmos dois relevantes no topo); $\text{nDCG} = 1{,}062/1{,}631 = 0{,}651$. Confere com `dcg(rel_cos) / dcg(sort(rel_cos, decreasing = TRUE))`.

> **Ponte:** binário, o nDCG não mostra sua vantagem. Agora com os graus.

---

## Módulo 8 — nDCG graduado; as cinco lado a lado
*trabalho 8 min · conversa 4 min · lembrete: ele calcula o DCG parcela a parcela; previsão antes da saída*

```r
g <- grau[ranking]   # o grau de cada documento, NA ORDEM do ranking
g                    # vetor nomeado: os nomes vem junto
```
```
d3 d1 d2 d4 d8 d6 d5 d7 
 2  1  2  0  0  1  0  0 
```

`grau[ranking]` indexa um vetor nomeado por um vetor de nomes — reordena o gabarito pelo ranking, como no Módulo 1, mas agora com o **grau**, não com 0/1.

**DCG parcela a parcela, com ele** (as linhas de grau 0 dão 0):

| $i$ | doc | grau | $\log_2(i+1)$ | parcela |
|---|---|---|---|---|
| 1 | d3 | 2 | 1,000 | 2,000 |
| 2 | d1 | 1 | 1,585 | 0,631 |
| 3 | d2 | 2 | 2,000 | 1,000 |
| 6 | d6 | 1 | 2,807 | 0,356 |

$\text{DCG} = 2{,}000 + 0{,}631 + 1{,}000 + 0{,}356 = \mathbf{3{,}987}$. Ideal — graus `2 2 1 1 0 0 0 0`: $\text{IDCG} = 2/1 + 2/1{,}585 + 1/2 + 1/2{,}322 = 2 + 1{,}262 + 0{,}5 + 0{,}431 = \mathbf{4{,}193}$. $\text{nDCG} = 3{,}987/4{,}193 = \mathbf{0{,}951}$.

```r
ndcg_g <- dcg(g) / dcg(sort(g, decreasing = TRUE))   # a mesma funcao, agora com os graus
round(ndcg_g, 3)                                     # 3 casas
```
```
[1] 0.951
```

Com graus, `d1` e `d6` passam a contar: a nota sobe de 0,920 para 0,951.

**Todas juntas:**

```r
resumo <- c(P_at_3 = precisao[[3]], AP = ap, MRR = mrr,   # [[3]]: o 3o valor, P@3
            nDCG_bin = ndcg, nDCG_grad = ndcg_g)          # as cinco, com nome
round(resumo, 3)                                          # 3 casas
```
```
   P_at_3        AP       MRR  nDCG_bin nDCG_grad 
    0.667     0.833     1.000     0.920     0.951 
```

Cinco números para **um** ranking. Nenhum é "a" nota do sistema.

**Exemplos que você mostra:**

- o BM25, acima: graduado 0,951 > binário 0,920 — os grau-1 estão em posições razoáveis (2 e 6);
- o ranking **`d2 d3 d4 d5 d7 d8 d1 d6`** — os dois grau-2 no topo, os dois grau-1 no fim: binário $\text{nDCG} = 1{,}000$ (os relevantes estão onde o ideal os põe); graduado $\text{DCG} = 2 + 1{,}262 + 1/3 + 1/3{,}170 = 3{,}911$ contra $\text{IDCG} = 4{,}193$ → $\mathbf{0{,}933}$. **O graduado ficou abaixo do binário**: ele vê os grau-1 jogados para o fim; o binário não os vê;
- o ranking do BM25 **invertido**: binário 0,412, graduado 0,519 — os dois caem muito.

**Explore** (para quem pergunta "e se…"): **Novo: `rev(x)`** inverte um vetor. `rel_rev <- as.integer(rev(ranking) %in% relevantes)` e `dcg(rel_rev) / dcg(sort(rel_rev, decreasing = TRUE))` → 0,412; `g_rev <- grau[rev(ranking)]` e a mesma conta com `g_rev` → 0,519.

> **Erro previsto:** achar que o graduado sempre dá mais que o binário. Sinal: ele generaliza a partir do 0,951 > 0,920. Reação: mostre o segundo exemplo — `d2 d3 d4 d5 d7 d8 d1 d6` dá 1,000 binário e 0,933 graduado. Os dois medem coisas diferentes: o binário só vê os grau-2; o graduado cobra também a posição dos grau-1.

> **Checkpoint 8.** *nDCG graduado do cosseno. O `g` do cosseno é `1 2 0 2 1 0 0 0` (d1 d3 d4 d2 d6 d8 d5 d7). Parcela a parcela.*
> Esperado: $\text{DCG} = 1/1 + 2/1{,}585 + 0 + 2/2{,}322 + 1/2{,}585 = 1 + 1{,}262 + 0{,}861 + 0{,}387 = 3{,}510$; o IDCG é o mesmo do BM25, $4{,}193$ (mesmos graus); $\text{nDCG} = 3{,}510/4{,}193 = 0{,}837$. Agora ele tem as cinco do cosseno: $0{,}333 \cdot 0{,}500 \cdot 0{,}500 \cdot 0{,}651 \cdot 0{,}837$.

> **Ponte:** cinco métricas, dois sistemas. Qual usar — e quando nenhuma delas diz nada?

---

## Módulo 9 — Qual métrica usar; três armadilhas
*trabalho 6 min · conversa 6 min · lembrete: 360 palavras; não adiante a Aula 16*

**P@$k$** — o usuário olha só as primeiras $k$; fácil de explicar a quem não é da área. **MAP** — visão global do ranking, binária; o padrão para comparar sistemas. **nDCG** — quando há níveis de relevância; padrão em busca web e recomendação. **MRR** — uma resposta basta: QA, busca de fórmula, RAG (*retrieval-augmented generation*, o modelo de linguagem que consulta um motor antes de responder).

**Regra prática:** relatar sempre **mais de uma**, e sempre dizer o $k$ e o limiar. "$\text{MAP} = 0{,}83$" sozinho não permite a ninguém julgar seu sistema.

**Três armadilhas:**

1. **Uma consulta só.** Tudo de hoje veio de *uma* consulta. Serve para a mecânica, não para concluir. Precisa de dezenas.
2. **Corpus pequeno.** Com 8 documentos e 2 relevantes, qualquer ordem razoável tira nota alta — as métricas **não discriminam**. É sintoma, não resultado bom.
3. **Diferença pequena não é diferença.** Compara-se com **teste estatístico** sobre os APs consulta a consulta — Aula 16.

As três são formas do mesmo erro: tratar um número como se não tivesse variância.

**Exemplos que você mostra:**

- **uma consulta:** nesta consulta o BM25 vence o cosseno nas cinco — 0,667 a 0,333, 0,833 a 0,500, 1 a 0,5, 0,920 a 0,651, 0,951 a 0,837. É **uma** necessidade; noutra, a ordem pode virar;
- **corpus pequeno:** a ordem **alfabética**, `d1 d2 d3 … d8`, que não sabe nada da consulta, tem $\text{P@}3 = 0{,}667$ — o mesmo do BM25 —, AP 0,583, RR 0,5, nDCG 0,693 e graduado 0,863;
- **diferença pequena:** dois sistemas com MAP 0,84 e 0,83 sobre 50 consultas — só com isso, não dá para dizer qual é melhor; é preciso olhar os 50 APs de cada um e testar se a diferença passa do ruído (Aula 16).

> **Erro previsto:** "0,84 > 0,83, então é melhor". Sinal: compara pontos. Reação: pergunte *"se você rodasse com outras 50 consultas, daria 0,84 de novo?"* — é variância, e é Estatística Indutiva. O teste é a Aula 16. **Guarde.**

> **Checkpoint 9.** *Um grupo tem 3 consultas. O BM25 tem AP 0,9, 0,9 e 0,1; o cosseno tem 0,6 nas três. Qual tem o MAP maior? E o que o grupo deveria escrever sobre "qual é melhor"?*
> Esperado: MAP do BM25 $= 1{,}9/3 = 0{,}633$; do cosseno, $0{,}600$ — o BM25 vence na média. Mas são 3 consultas (armadilha 1), a diferença é pequena (armadilha 3), e o BM25 desaba numa — essa consulta merece ser olhada antes de qualquer conclusão.

> **Ponte:** ele sabe medir — e sabe o que a medida não diz. O teste confirma.

---

**Funções de R apresentadas nesta aula** (o guia da Aula 06 copia esta linha): `>=`, `cumsum`, `seq_along`, `rbind`, `which`, `log2`, `rev`; na figura opcional, os argumentos `ylim` e `lty`.

**Casos degenerados desta aula:** consulta **sem nenhum relevante** ($R = 0$) — `precisao[rel == 1]` é `numeric(0)`, a soma é 0, e `sum(...) / R` é $0/0$: aparece `[1] NaN`; o recall `acertos / R` vira oito `NaN`; o MRR, `1 / which(rel == 1)[1]`, vira `[1] NA` (`which` devolve `integer(0)`, e o `[1]` de um vetor vazio é `NA`) — a convenção é $\text{RR} = 0$; o nDCG com todos os ganhos zero é $0/0$: `[1] NaN`. O P@$k$ nunca degenera ($k \geq 1$). **Empate:** `d5` e `d7` têm escore 0 nos dois modelos e saem na ordem do corpus; como os dois têm grau 0, nenhuma métrica muda — mas num empate entre um relevante e um não relevante, a nota dependeria da ordem em que os documentos foram digitados.

---
---

# PARTE C — Teste final: uma pergunta por módulo

**Só depois de o Módulo 9 estar concluído, e antes do consolidado.** Avise: *"agora um teste curto — uma pergunta por módulo, para eu saber o que ficou e o que precisa voltar."*

**As perguntas são estas, e só estas.** Só entram os módulos alcançados — se a sessão parou antes, os demais são "não avaliados". Se você ensinou algo além do guia, isso **não** entra. **Uma por vez.** Diga se acertou e, em uma linha, o que faltou. Não reensine — anote o módulo.

| módulo | pergunta | esperado |
|---|---|---|
| **1** | Um terceiro sistema devolve `d6 d2 d8 d3 d1 d4 d5 d7`. Qual é o `rel` com limiar 2? E com limiar 1? | limiar 2: `0 1 0 1 0 0 0 0`; limiar 1: `1 1 0 1 1 0 0 0` |
| **2** | Um buscador mostra 20 resultados, 5 relevantes; o gabarito tem 25 relevantes. Precisão e recall? Qual dos dois daria para estimar sem gabarito? | $5/20 = 0{,}25$; $5/25 = 0{,}2$; a precisão — basta olhar o que foi mostrado |
| **3** | Para `rel` = `0 0 1 1 0 0 0 0` ($R = 2$): $\text{P@}2$, $\text{P@}4$ e $\text{R@}4$? | $0$; $2/4 = 0{,}5$; $2/2 = 1$ |
| **4** | Para `rel` = `0 1 1 0 0 0 0 0`, escreva P@$k$ para $k = 1 \ldots 4$ e diga onde está o dente. | $0$; $0{,}5$; $0{,}667$; $0{,}5$ — sobe em $k = 2$ e $3$ (relevantes), desce em $k = 4$ |
| **5** | `rel` = `0 1 1 0 0 0 0 0`, $R = 2$. AP? E se o gabarito tivesse $R = 4$? | $(1/2 + 2/3)/2 = 0{,}583$; com $R = 4$, $1{,}167/4 = 0{,}292$ — os dois não recuperados valem zero |
| **6** | Duas consultas: o primeiro relevante está na posição 3 numa e na posição 1 na outra. MRR? | $(1/3 + 1)/2 = 0{,}667$ |
| **7** | `rel` binário = `0 0 1 1 0 0 0 0`, $R = 2$. nDCG? | $\text{DCG} = 1/2 + 1/2{,}322 = 0{,}931$; $\text{IDCG} = 1{,}631$; $\text{nDCG} = 0{,}571$ |
| **8** | Se `d1` tivesse grau 2 em vez de 1, o nDCG graduado do BM25 sobe ou desce? Calcule. | `g` = `2 2 2 0 0 1 0 0`; $\text{DCG} = 2 + 1{,}262 + 1 + 0{,}356 = 4{,}618$; ideal `2 2 2 1 0 0 0 0` → $\text{IDCG} = 2 + 1{,}262 + 1 + 0{,}431 = 4{,}693$; $\text{nDCG} = 0{,}984$ — sobe: os três grau-2 no topo, só `d6` fora do lugar |
| **9** | Um grupo avaliou 3 consultas e escreveu: "o cosseno é melhor: MAP 0,71 contra 0,69". Duas objeções. | três consultas são poucas; diferença pequena sem teste (Aula 16); olhar consulta a consulta — quaisquer duas |

**Ao terminar, o resultado em uma linha:** *"acertou os módulos 1, 2, 3, 4, 6, 8 e 9; 5 e 7 vão para revisão."* Isso entra no consolidado.

- **Errou 3 ou mais:** recomende revisar esses módulos antes da Aula 06.
- **Errou 2 ou menos:** *"Você sabe medir um ranking."*

**Então diga:** *"A próxima etapa é a Parte D — e ela é do grupo: vocês decidem o limiar, medem o cosseno e o BM25 contra o gabarito que o grupo julgou na Aula 05, e dizem quem venceu — com ressalva. Reúna o grupo, abram `GUIA_ESTUDO_aula05b_parteD.md` com a ficha do projeto."* Depois, fechamento.

---

## Glossário

| sigla / termo | por extenso | o que é |
|---|---|---|
| qrels | *query relevance judgments* | o gabarito: para cada consulta, o grau de cada documento (Aula 05) |
| limiar | — | o grau a partir do qual um documento conta como relevante (aqui, $\geq 2$) |
| `rel` | — | o gabarito binário, na ordem do ranking |
| VP / FP / FN / VN | verdadeiro positivo / falso positivo / falso negativo / verdadeiro negativo | as quatro células da tabela de contingência |
| P@$k$ | precisão em $k$ | relevantes entre os $k$ primeiros, sobre $k$ |
| R@$k$ | recall em $k$ | relevantes entre os $k$ primeiros, sobre o total de relevantes |
| AP | *average precision* | média das P@$k$ nas posições com relevante, dividida por $R$ |
| MAP | *mean average precision* | média do AP sobre as consultas |
| RR / MRR | *(mean) reciprocal rank* | 1 sobre a posição do primeiro relevante; a média sobre as consultas |
| ganho | *gain* | o grau de relevância de um documento (0/1/2) |
| DCG | *discounted cumulative gain* | soma dos ganhos, cada um dividido por $\log_2(i+1)$ |
| IDCG | *ideal DCG* | o DCG do melhor ranking possível: os mesmos ganhos, ordenados |
| nDCG | *normalized DCG* | $\text{DCG}/\text{IDCG}$, entre 0 e 1 |
| `cumsum` | *cumulative sum* — soma acumulada; daí o nome | cada posição é a soma de tudo até ali |
| *pooling* | — | julgar só os documentos que algum sistema trouxe; o resto conta como irrelevante (Aula 05) |
| BM25 | *Best Match 25* | o modelo probabilístico de ranqueamento da Aula 04 |
| TF-IDF | *term frequency–inverse document frequency* | o peso dos termos da Aula 01, base do cosseno da Aula 02 |
| TREC | *Text REtrieval Conference* | a avaliação anual de sistemas de busca do NIST (*National Institute of Standards and Technology*) |
| QA | *question answering* | busca em que uma resposta encerra a necessidade |
| RAG | *retrieval-augmented generation* | modelo de linguagem que consulta um motor de busca antes de responder (Aula 14) |
| LLM | *large language model* | modelo de linguagem — a tutora que está lendo isto |
| motor | — | o `motorNN.R` da disciplina: as funções das aulas anteriores, carregadas na primeira célula |
| Colab | Google Colaboratory | onde o R roda, no navegador; apaga tudo quando a sessão cai |

---

## Fechamento

Ordem fixa: **teste → oferta da Parte D → perguntas guardadas → tarefa → o que vem → consolidado → passos de fechamento.**

1. **Perguntas guardadas:** responda as curtas; encaminhe as outras — "como saber se 0,84 é melhor que 0,83" é a Aula 16; "e a curva precisão-recall inteira?" fica fora do escopo desta aula.
2. **A tarefa**, sem fazê-la por ele: (1) refazer as cinco métricas dos dois modelos com o **julgamento que ele mesmo fez** dos 8 documentos na Aula 05 (está no consolidado da Aula 05), em vez de `gabarito_aula()` — o vencedor muda?; (2) refazer tudo com **limiar 1** e dizer o que mudou e por quê; (3) *explicar e explorar* cada bloco de código, por escrito.
3. **O que vem:** *"Hoje o gabarito foi régua. Na Aula 06 ele vira **entrada do algoritmo**: o Rocchio pega os documentos marcados como relevantes — no exemplo do curso, `d2` e `d3` — e reescreve a consulta com as palavras deles, afastando-a das de `d4`, marcado não relevante; e você vai medir, com estas mesmas métricas, se a consulta reescrita ranqueia melhor que a original."*
4. **Gere o consolidado** — avise que está gerando.
5. **Logo abaixo do consolidado, na mesma mensagem, escreva os passos de fechamento** — os cinco abaixo, por extenso, mesmo que ele já os conheça.

---

# PARTE D — está em outro arquivo

A prática — **Módulos 10 a 12**: ler os gabaritos do grupo com `ler_qrels()`, decidir o limiar (que vai para o `config.R` e para a ficha), escrever as métricas como funções, conferi-las contra os números desta aula, e medir o cosseno e o BM25 em cada consulta julgada — está em `GUIA_ESTUDO_aula05b_parteD.md`. É **outra sessão, do grupo** (50 a 60 minutos), com a ficha do projeto.

Depois do teste, diga ao aluno que a Parte D é em grupo e precisa da ficha. O consolidado individual registra "Parte D: sessão de grupo, a marcar".

---

## Modelo do consolidado

**Relato sobre o aluno, em três partes — não resumo da matéria.** Meia página é o normal; 2 mil palavras é o teto. **Bloco de código Markdown**, para ele salvar como `aula05b_consolidado.md`. **Nunca PDF, nunca relatório, nunca reexplicação, nunca código.** Matemática em LaTeX. Opine em primeira pessoa. **Não escreva a seção "Estado do R"** — o R a acrescenta depois.

**Privacidade:** registra como ele aprende, nunca capacidade; nada que ele não possa ler em voz alta na frente da turma.

```markdown
# Consolidado — PI III — Aula 5,5 — <data>
*guia versão 3 · tutora: <qual LLM> · sessão individual (teoria) · motor05b*
**Aluno:** <nome>

## 1. O que foi passado
- M1 — ranking, gabarito e limiar viram `rel`
- M2 — precisão e recall; a tabela de contingência ignora a ordem
- M3 — o @$k$ como corte
- M4 — P@$k$ e R@$k$; dente de serra; `cumsum`
- M5 — AP passo a passo; a pegadinha do divisor; MAP
- M6 — MRR: só o primeiro
- M7 — nDCG: por que $\log_2(i+1)$; binário à mão = 0,920
- M8 — nDCG graduado = 0,951; as cinco lado a lado; graduado nem sempre > binário
- M9 — qual métrica; três armadilhas
<se parou por tempo: "parou no M5; M6–M9 não alcançados — retomar do M6">

## 2. Como foi o aprendizado — opinião da tutora
<um parágrafo direto, em primeira pessoa: se montou `rel` sozinho; se confundiu os
denominadores; se caiu na média simples do AP; se somou os relevantes no MRR;
se fez o DCG parcela a parcela; se achou que graduado é sempre maior; se leu
0,84 > 0,83 como diferença; quantas previsões de saída acertou; o que foi entregue
em vez de construído; como se virou no Colab.>

**Teste final:** acertou M<lista>; a revisar M<lista> — <uma linha por módulo, o que faltou>.

## 3. Observações para a frente
- **Revisar antes da Aula 06:** <o quê, e por quê>
- **Para a próxima tutora:** <ritmo, perfil, conforto com contas em série e com o R>
- **Perguntas guardadas:** <pergunta> — <para qual aula>
- **Produzido:** as cinco métricas do BM25 ($0{,}667 \cdot 0{,}833 \cdot 1 \cdot 0{,}920 \cdot 0{,}951$) e do cosseno ($0{,}333 \cdot 0{,}500 \cdot 0{,}500 \cdot 0{,}651 \cdot 0{,}837$); feitas à mão: <quais>; rankings explorados: <quais>
- **Parte D (sessão de grupo):** a marcar — com a ficha do projeto
```

## Passos de fechamento (copie logo abaixo do consolidado)

1. Copie o bloco acima e salve no seu computador como **`aula05b_consolidado.md`** (Bloco de Notas → *Salvar como* → tipo "Todos os arquivos", codificação UTF-8).
2. No Colab, **sem fechar a sessão**, envie o arquivo: pasta à esquerda → ícone de upload. Rode `list.files()` e confira que ele aparece solto, com esse nome exato (não dentro de `sample_data`, não como `aula05b_consolidado (1).md`).
3. Rode `anexar_estado("aula05b_consolidado.md")`.
4. Baixe o arquivo de volta: três pontinhos ao lado dele → *Fazer download*. Abra e confira que a seção "Estado do R" apareceu no fim.
5. Envie ao repositório do grupo, em **`consolidados/<seu nome>/`**: no GitHub, abra essa pasta → *Add file → Upload files* → arraste o arquivo → *Commit changes* (mesmo nome substitui).

Se ele disser que já fez, pergunte só: *"a seção 'Estado do R' apareceu no fim do arquivo?"*
