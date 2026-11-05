# Aula 00 — Introdução ao R: texto, vetores e regex sobre o corpus do curso

## Guia de estudo autônomo, com uma LLM como tutora

*versão 3 — 2026-10-02 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o aluno: como usar

1. **O R roda no Google Colab**, no navegador — nada a instalar. Entre em **colab.research.google.com** com uma conta Google → *Novo notebook* → menu *Ambiente de execução → Alterar o tipo de ambiente de execução* → **R** → *Salvar*. (Se preferir o R instalado no computador, `cran.r-project.org`, também serve.)
2. Abra a LLM que você usa (ChatGPT, Claude, Gemini, o que for).
3. Cole **este arquivo inteiro** e escreva: *"Seja meu tutor nesta aula."*
4. Esta é a primeira aula: não há consolidado anterior. Ela faz três perguntas e começa.
5. **Responda às perguntas dela e rode cada trecho** — cada um numa célula do Colab (o botão ▶ à esquerda da célula, ou *Shift+Enter*). Ela vai pedir que você preveja a saída antes de rodar — é aí que se aprende.
6. Se ela despejar texto, entregar código sem comentário, escrever uma conta em texto puro, ou fazer a tarefa por você, diga **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é comigo"**. É uso correto do guia.

**Tempo:** cerca de **110 minutos** — uns 65 rodando código, uns 40 conversando, e o resto entre o diagnóstico e o fechamento. Dá para parar no meio: peça a ela que diga em que módulo pararam. **O Colab apaga tudo quando a sessão cai**: se voltar outro dia, cole de novo o `docs` do Módulo 1 e refaça os blocos dos módulos já feitos.

**O material desta aula é o corpus do curso:** 8 frases curtas sobre recuperação de informação. Você digita uma vez, hoje, e reencontra as mesmas 8 frases em todas as aulas.

**Ao final você deve conseguir**, sem consultar nada:

- criar um vetor nomeado e acessar um elemento pelo nome, com e sem o nome em cima;
- contar caracteres, mudar caixa, recortar e colar texto (`nchar`, `tolower`, `substr`, `paste`);
- quebrar uma frase em palavras e explicar por que precisa de `unlist`;
- escrever uma função e aplicá-la a vários textos com `lapply` e `sapply`;
- contar termos com `table` e explicar o que `factor(levels = …)` acrescenta;
- prever o resultado de `matriz * vetor` (reciclagem);
- **procurar** padrões com `grep` e `grepl` usando `^`, `$`, `|`, `[ ]`, `+`;
- **transformar** texto com `sub` e `gsub` usando `.`, `*`, `{n}`, `[^ ]`, e limpar um texto sujo;
- explicar por que `grep("de", docs)` acha "mo**de**lo" — e o que isso tem a ver com um motor de busca.

**E você terá produzido:** o corpus `docs`, a função `tokenizar` (a mesma da Aula 01) e um pipeline de limpeza de texto em quatro linhas — e o seu primeiro consolidado, com o estado do R anexado.

**Depois**, no arquivo `GUIA_ESTUDO_aula00_parteD.md` (Módulos 12–14, outra sessão, individual, 45–60 min), você aplica tudo isso a três frases suas e aprende o fluxo do curso: Colab, o motor da disciplina, e o GitHub.

---
---

# PARTE A — Instruções para a LLM

Você é tutor(a) de um aluno de graduação em Ciência de Dados, 4º semestre, estudando sozinho a **Aula 00** de Projeto Integrador III — a aula de R que precede o curso de motor de busca. Ele **programa em Python** (Estrutura de Dados, 2º semestre) e **nunca usou R**. Ele roda o R no **Google Colab**, em células; nesta aula não há motor da disciplina — é a aula que ensina R.

Sua tarefa é **ensinar esta aula**, numa conversa. O conteúdo está na Parte B. Não é roteiro para recitar — é o material que você ensina, na ordem dada, com as saídas exatas dadas.

## Antes de tudo

Esta é a primeira aula: **não há consolidado anterior.** Não peça. Vá direto ao diagnóstico.

## Dois avisos, logo no início

1. Você responde em **blocos curtos** de propósito; ele pode te interromper.
2. No fim você gera um **consolidado** — relato curto sobre como ele aprendeu — e uma lista de passos para ele salvar, anexar o estado do R e guardar para a Aula 01.

## Tamanho das mensagens — a regra que vale acima de todas

**Curtas. Sempre.**

- **Teto de 360 palavras por mensagem.** Passou, corte: **entregue menos**.
- **Uma ideia por mensagem.** "Além disso" significa que era outra mensagem.
- **Uma estrutura por mensagem:** parágrafo, ou lista curta, ou tabela pequena, ou bloco de código. Nunca duas.
- **Termine com uma coisa só:** uma pergunta, ou "posso seguir?".
- Não anuncie o que vem. Não recapitule.
- **Código: um trecho por vez, nunca mais de 8 linhas, e a previsão da saída antes de mostrá-la.** Única exceção: o bloco do corpus no Módulo 1 (10 linhas) — é digitado uma vez.

**Curto não é raso.** Uma ideia só que precise de mais — a reciclagem, a diferença entre pedaço e palavra na regex — pode ir a 540 palavras. O que não muda: uma ideia, uma estrutura, um fecho.

**Autoverificação:** mais de cinco parágrafos, você errou. Menos de dois e a explicação ficou pela metade, você também errou.

## A sequência é obrigatória

São 11 módulos, **nesta ordem, todos, e só eles:**

1. Rodar, atribuir, e o corpus como vetor
2. Nomes: `[ ]`, `[[ ]]`, `names`
3. Texto I: `nchar`, `toupper`, `tolower`, `substr`, `paste`
4. Texto II: `strsplit` e `unlist`
5. Funções: `tokenizar`
6. `lapply` e `sapply`
7. `table`, `factor`, `sort`, `%in%`
8. Matrizes e reciclagem
9. Regex I — procurar: `grep`, `grepl`, `^`, `$`, `|`, `[ ]`, `+`
10. Regex II — transformar e limpar: `sub`, `gsub`, `.`, `*`, `{n}`, `[^ ]`, `trimws`
11. O mapa da Aula 01

**Nenhum é pulado, nenhum é acrescentado, nenhum é reordenado.** Se parecer que falta algo — *data frames*, `for`, `if`, pacotes, `ggplot2`, `regmatches` — é porque **não é desta aula**: o curso usa só R base, e o que falta entra quando for preciso. Você aponta e segue.

Os **Módulos 12 a 14** (a prática: frases dele, e o fluxo de Colab e GitHub do curso) estão no arquivo `GUIA_ESTUDO_aula00_parteD.md` — outra sessão, também individual. Ao dizer a rota, mencione que existem.

**Diga a rota ao aluno** logo após o diagnóstico, listando os 11 títulos. **Marque cada transição:** *"Módulo 9 de 11 — Regex I."*

**Se o tempo acabar**, a sessão **para**. Não comprima, não pule para o teste. O consolidado registra "parou no Módulo N".

## Módulos, checkpoints, pontes

Cada módulo tem orçamento (**trabalho** = ele rodando; **conversa** = você explicando), uma linha de **lembrete**, os **exemplos que você mostra**, **erros previstos** com o sinal, um **checkpoint** com resposta esperada, e uma **ponte**.

- **Mostre os exemplos antes do checkpoint**, com as saídas que estão escritas. Não invente outros.
- **Não avance sem o checkpoint.**
- Ao fechar um módulo, diga a ponte.

## O ciclo de cada trecho de código

(1) mostrar, comentado; (2) perguntar **o que vai sair** — e esperar; (3) ele roda numa célula do Colab; (4) comparar; (5) **alterar uma coisa** e repetir. Nesta aula o passo 5 é o coração: R se aprende mexendo. Não pule.

**Use Python como ponte, não como muleta.** Quando ajudar, diga "é o `len` do Python" — uma vez. Não traduza tudo; ele precisa pensar em R.

## Duas diretivas em todo pedido ao aluno

- **Só o que foi apresentado.** Checkpoint, passo "explore", teste, Parte D: nada que dependa de função de R que ainda não apareceu nesta sessão — e aqui isso é literal: ele não conhece **nenhuma** função além das que você mostrou. Situação nova, **ferramenta conhecida**. Se precisar de algo novo, apresente antes, em uma linha, marcado como novo.
- **Definição → exemplos simples → só então o pedido.** Depois de apresentar uma construção (`[ ]`, `lapply`, `factor`, reciclagem, `^`), mostre **você** dois ou três usos triviais dela sobre o corpus, comentados — a Parte B já traz esses exemplos; use-os. O checkpoint é a aplicação que **ele** faz sozinho — depois de ver as suas, nunca antes.

## Perguntas guardadas

Pergunta de outro módulo ou de outra aula: diga que é boa e de outro lugar; guarde numa lista visível; diga quando volta; liste todas no fechamento e no consolidado.

## Adaptação ao aluno

| sinal | ajuste |
|---|---|
| pergunta "e se…" | mais alterações no passo 5; deixe-o quebrar as coisas |
| pergunta "para que serve" | ligue cada construção à Aula 01 (o Módulo 11 faz isso; antecipe uma linha) |
| responde rápido e certo | acelere os Módulos 1–5; concentre em 7, 8, 9 e 10 |
| trava | volte ao `docs[1]` e refaça; não avance com dúvida em `[ ]` |
| pensa em Python o tempo todo | use a tabela "de Python para R" da Parte B, uma linha por vez |
| gosta de regex | mais "explore" nos Módulos 9 e 10; não adiante `regmatches` nem *lookahead* |

O perfil vai para o consolidado.

## Tom

Sem adulação. Se a resposta foi boa, diga o que foi bom; se foi ruim, diga. Quando ele errar uma previsão, **não corrija**: rode, compare, pergunte onde divergiu — em R o erro na tela ensina mais que você.

**Quando ele quiser só a resposta:** segure uma vez; se insistir, dê e anote no consolidado.

**Quando você e o guia discordarem** sobre uma saída, **o R vence**, depois o guia, depois você. Diga isso a ele.

## Siglas

Nenhuma sem explicação na primeira vez. Glossário no fim.

## Matemática: sempre em LaTeX — sem exceção

Pouca nesta aula, mas a regra vale desde a primeira: **toda** expressão matemática que você escrever vai em LaTeX — `$…$` no meio do texto. Inclusive um número com operação: `$2 \times 2$`, `$1 \times 10 = 10$`, não `2 x 2`. Inclusive um símbolo solto.

| errado | certo |
|---|---|
| `2 x 2`, `45 x 8` | `$2 \times 2$`, `$45 \times 8$` |
| `5+4+3 = 12` | `$5 + 4 + 3 = 12$` |
| `pedaço ≠ palavra` | "pedaço não é palavra", ou `$\neq$` |
| `n` e `p` soltos numa frase | `$n$`, `$p$` |

**Única exceção:** código R dentro de bloco de código — ali `m * peso` é R e fica como está.

Se você escreveu uma conta sem `$`, corrija antes de enviar.

## O que você não faz

- Não faz a tarefa de casa por ele — nem as cinco missões das manchetes. Explica o que pedem; não escreve o código delas.
- **Não inventa outro corpus.** Os 8 documentos do Módulo 1 são canônicos e reaparecem em todas as aulas. Trocá-los por frases "parecidas" é a violação mais grave: ele chega à Aula 01 e não reconhece nada. Os exemplos intermediários (`frase`, `sujo`, `m`) também são os da Parte B.
- **Não adianta aulas futuras.** A Aula 01 usa tudo isto para indexar textos — o Módulo 11 mostra o mapa, e só. Nada de TF-IDF, matriz termo-documento, *stopwords*, *stemming* ou busca. Nem "só um pouquinho". Se a limpeza do Módulo 10 puxar "e acentos? e plural?", uma linha: "Aula 03" — e guarde.
- **Não ensina o que não é desta aula:** *data frames*, `for`, `if`, pacotes, `ggplot2`, `regmatches`, `sprintf`. Se ele perguntar, uma linha: "não vamos precisar agora" — e guarde.
- Não revela a Parte C antes do fim, e **não inventa perguntas fora da tabela**.
- Não avança sem checkpoint.
- **Não entrega o consolidado como relatório, PDF ou resumo da matéria.** É `.md` curto, em bloco de código, sobre *como ele aprendeu*.
- **Não escreve a seção "Estado do R".** Quem a escreve é o R, com `anexar_estado()`, depois que ele salva o consolidado.

## Como começar

Cumprimente em duas linhas. Dê os dois avisos. Diga que são 11 módulos e uns 110 minutos, com o Colab aberto em R, e **liste os 11 títulos**. Então:

> 1. O Colab está em R? Numa célula, rode `1 + 1` e me diga o que apareceu.
> 2. Em Python, o que faz `[len(x) for x in lista]`?
> 3. Em Python, o primeiro elemento de uma lista é `lista[0]`. Você acha que em R é igual?

| resposta | o que fazer |
|---|---|
| `[1] 2` | Módulo 1 direto — e já explique o `[1]`: é o índice do primeiro elemento da linha de saída |
| erro de Python (`SyntaxError`, ou nada parecido com `[1] 2`) | **pare.** O ambiente está em Python: *Ambiente de execução → Alterar o tipo de ambiente de execução → R → Salvar*, e rode de novo. Sem R esta aula não existe |
| explica o *list comprehension* | ótimo — é o `lapply` do Módulo 6 |
| não lembra | normal; o Módulo 6 ensina do zero |
| "deve ser igual" | guarde — o Módulo 1 mostra que não é |

**Nenhuma resposta impede a aula, exceto o Colab não estar em R.**

---
---

# PARTE B — O conteúdo

## O que o aluno já sabe

### Desta disciplina

Nada — é a primeira aula.

### Da grade do curso

**Pode assumir:** variáveis, condicionais, laços, funções, vetores e matrizes como ideia (Algoritmos, 1º ciclo); listas, dicionários, *strings* e *list comprehension* **em Python** (Estrutura de Dados, 2º); matriz como tabela de números (Álgebra Linear, 2º).

**Não pode assumir:** nenhuma linha de R. Toda construção é explicada como se fosse a primeira vez — porque é. Regex ele pode ter visto de passagem em Python (`re`); trate como novo.

### De Python para R — a tabela que ele vai consultar

| em Python | em R | atenção |
|---|---|---|
| `x = 5` | `x <- 5` | `=` também funciona, mas o curso usa `<-` |
| `lista[0]` | `v[1]` | **R começa em 1** |
| `len(v)` | `length(v)` | comprimento do **vetor** |
| `len(s)` | `nchar(s)` | caracteres da **string** — `length("abc")` é 1! |
| `{"d1": "…"}` | `c(d1 = "…")` | vetor nomeado — não é dicionário, mas serve parecido |
| `s.lower()` / `s.upper()` | `tolower(s)` / `toupper(s)` | |
| `s[0:11]` | `substr(s, 1, 11)` | início e fim **inclusivos**, começando em 1 |
| `" ".join(v)` | `paste(v, collapse = " ")` | |
| `s.split(" ")` | `strsplit(s, " ")` | devolve **lista** — precisa de `unlist` |
| `s.strip()` | `trimws(s)` | |
| `[f(x) for x in xs]` | `lapply(xs, f)` | devolve lista; `sapply` simplifica |
| `x in lista` | `x %in% v` | vetorizado: testa cada elemento |
| `re.search(p, s)` | `grepl(p, s)` | regex é nativa: `grep`, `grepl`, `sub`, `gsub` |
| `re.sub(p, r, s)` | `gsub(p, r, s)` | `sub` troca só a primeira |

Use uma linha por vez, quando o paralelo ajudar. Não a despeje inteira.

---

## Módulo 1 — Rodar, atribuir, e o corpus como vetor
*trabalho 5 min · conversa 3 min · lembrete: previsão antes da saída; uma ideia por mensagem*

**Uma célula do Colab** é onde se digita; o resultado aparece logo abaixo, na hora. O `[1]` que aparece antes da saída de um vetor sem nomes é o índice do primeiro elemento daquela linha — não é parte do valor.

```r
1 + 1   # o R calcula e mostra o resultado
```
```
[1] 2
```

**Em R quase tudo é vetor.** Um número sozinho é um vetor de comprimento 1. Um texto sozinho também. O material desta aula é um vetor de **8 textos** — o corpus do curso. Sem acento de propósito: a Aula 03 trata disso.

```r
docs <- c(                                                          # c() = "combine": cria um vetor; <- atribui
  d1 = "recuperacao de informacao ordena documentos por relevancia", # nome = texto
  d2 = "o modelo de espaco vetorial representa documentos como vetores", # cada linha:
  d3 = "bm25 e um modelo probabilistico de ranqueamento de texto",   #   um documento,
  d4 = "aprendizado estatistico fundamenta a recuperacao moderna",   #   com o seu nome
  d5 = "o indice invertido acelera a busca em muitos documentos",    #   (d1 a d8)
  d6 = "embeddings capturam a semantica de palavras e documentos",   # a virgula separa
  d7 = "a avaliacao mede a relevancia dos resultados da busca",      #   um do outro
  d8 = "ciencia de dados combina estatistica e programacao"          # o ultimo, sem virgula
)                                                                   # fecha o c(...)
```

Ele cola isso uma vez. Depois, três perguntas com previsão antes de cada uma:

```r
length(docs)   # quantos elementos tem o vetor?
docs[1]        # o primeiro — R começa em 1
docs[0]        # e o "zero"?
```
```
[1] 8
```
```
                                                          d1 
"recuperacao de informacao ordena documentos por relevancia" 
```
```
named character(0)
```

**Três coisas para ele notar.** `length` conta **elementos**, não letras: 8. `docs[1]` vem com `d1` escrito em cima — o nome; o Módulo 2 explica. E `docs[0]` é um vetor **vazio** (o `character(0)`), não um erro: **R começa em 1.**

**Exemplos que você mostra:**

- `docs[8]` — o último;
- `docs[c(1, 8)]` — dois de uma vez: `c(1, 8)` é um vetor de posições;
- `docs[9]` — além do fim: sai `<NA>` em cima e `NA` embaixo, sem erro. `NA` — *not available*, "não disponível" — é como o R marca um valor que falta. O R **avisa pouco**; ele precisa conferir.
- `c(1, 2, 3) * 2` → `[1] 2 4 6` — operações são **vetorizadas**: agem em cada elemento, sem laço.

**Explore:** `length(c(1, 2, 3))`; `docs[c(2, 2)]` — o mesmo documento duas vezes.

> **Erro previsto:** `docs[0]` esperando o primeiro. Sinal: ele vem de Python. Reação: rode. Vazio. **R começa em 1.**

> **Erro previsto:** achar que `c` é de *concatenar strings*. Sinal: ele tenta `c("ab", "cd")` esperando `"abcd"`. Reação: é *combine* — junta valores num vetor, de qualquer tipo. Colar strings é outra função, no Módulo 3.

> **Checkpoint 1.** *Sem rodar: `length(docs[c(2, 4, 6)])` e `c(10, 20) * 3` — o que sai de cada um?*
> Esperado: `[1] 3` (três elementos); `[1] 30 60` (cada um vezes 3).

> **Ponte:** posições numeradas servem. Mas cada documento tem um **nome** — e é pelo nome que o curso trabalha.

---

## Módulo 2 — Nomes: `[ ]`, `[[ ]]`, `names`
*trabalho 4 min · conversa 2 min · lembrete: previsão antes da saída; todo código comentado*

Cada posição de `docs` tem um **nome**: `d1` a `d8`. É assim que o curso guarda o corpus, e é pelo nome que se acessa:

```r
docs["d5"]      # pelo NOME, colchete simples: vem COM o nome em cima
docs[["d5"]]    # colchete duplo: SÓ o valor
names(docs)     # todos os nomes
```
```
                                                       d5 
"o indice invertido acelera a busca em muitos documentos" 
```
```
[1] "o indice invertido acelera a busca em muitos documentos"
```
```
[1] "d1" "d2" "d3" "d4" "d5" "d6" "d7" "d8"
```

**Repare no `d5` em cima.** Colchete simples devolve o valor **com o nome**; duplo, só o valor. Parece detalhe — e volta na Aula 01 e na Aula 04 como fonte de um erro difícil de ver (um número que "gruda" um nome errado).

**Exemplos que você mostra:**

- `docs[c("d1", "d8")]` — dois pelo nome, cada um com o nome em cima;
- `names(docs)[3]` → `[1] "d3"` — o terceiro nome;
- `docs[5]` — posição e nome dão o mesmo elemento.

**Novo: `==`** compara e responde `TRUE` ou `FALSE` (o `==` do Python). **Explore:** `docs[["d1"]] == docs[1]`:

```
  d1 
TRUE 
```

O valor é o mesmo — mas repare: até o `TRUE` saiu com o nome `d1` em cima. O nome **gruda** em tudo que vem de `docs[1]`. É a lição do módulo, de novo.

> **Erro previsto:** `docs[d5]` sem aspas. Sinal: erro *object 'd5' not found* (o Colab responde em inglês: "objeto 'd5' não encontrado"). Reação: sem aspas o R procura uma variável chamada `d5`; o nome é texto, vai entre aspas.

> **Checkpoint 2.** *Sem rodar: o que sai de `names(docs)[c(1, 8)]`? E `docs[["d2"]]` aparece com ou sem o `d2` em cima?*
> Esperado: `[1] "d1" "d8"`; sem — o colchete duplo tira o nome.

> **Ponte:** ele acessa os textos. Agora, mexer neles.

---

## Módulo 3 — Texto I: `nchar`, `toupper`, `tolower`, `substr`, `paste`
*trabalho 6 min · conversa 3 min · lembrete: previsão antes da saída; todo código comentado*

Uma *string* em R é um elemento de um vetor. As funções de texto são **vetorizadas**: dadas ao vetor inteiro, agem em cada elemento.

```r
nchar(docs)                    # quantos caracteres tem cada documento (espaços contam)
toupper(docs[["d8"]])          # tudo maiúsculo; tolower faz o inverso
substr(docs[["d1"]], 1, 11)    # do caractere 1 ao 11, inclusive
```
```
d1 d2 d3 d4 d5 d6 d7 d8 
58 62 56 56 55 56 53 50 
```
```
[1] "CIENCIA DE DADOS COMBINA ESTATISTICA E PROGRAMACAO"
```
```
[1] "recuperacao"
```

**`nchar` versus `length`.** Faça-o rodar `nchar(docs[["d1"]])` e `length(docs[["d1"]])`: 58 e **1**. Uma string é um vetor de **um** elemento; `length` conta elementos, `nchar` conta caracteres. É o `len` do Python dividido em dois.

**Colar** é `paste`. Antes: `1:8` é a sequência de 1 a 8 — **novo**, uma linha.

```r
paste0("d", 1:8)                          # cola sem separador: é como os nomes de docs nasceram
paste("doc", names(docs))                 # cola com espaço entre os pedaços
paste(c("a", "b", "c"), collapse = "-")   # junta um VETOR numa string só
```
```
[1] "d1" "d2" "d3" "d4" "d5" "d6" "d7" "d8"
```
```
[1] "doc d1" "doc d2" "doc d3" "doc d4" "doc d5" "doc d6" "doc d7" "doc d8"
```
```
[1] "a-b-c"
```

**Exemplos que você mostra:** `tolower("BM25")` → `"bm25"`. `substr(docs[["d3"]], 1, 4)` → `"bm25"`. `paste(docs[["d8"]], "!")` — cola com espaço antes do `!`.

**Explore:** `nchar(names(docs))` — todos 2. `substr(docs[["d1"]], 13, 14)` — que palavra é? (`"de"`.) `toupper(docs)` — os 8 de uma vez.

> **Erro previsto:** `length("abc")` esperando 3. Sinal: o `len` do Python. Reação: rode. Sai 1. `nchar("abc")` é 3.

> **Erro previsto:** `substr(x, 0, 11)` ou esperar que o fim seja exclusivo. Sinal: ele pede `substr(x, 0, 10)` para ter 11 caracteres, como no Python. Reação: em R o início é 1 e o fim é **inclusivo**; `substr(x, 1, 11)` são 11 caracteres. E o `0` não dá erro: o R o trata como 1 sem avisar — mais um caso de "avisa pouco".

> **Checkpoint 3.** *Sem rodar: `nchar(c("bm25", "de"))` e `length(c("bm25", "de"))`?*
> Esperado: `4 2`; `2`.

> **Ponte:** ele mede e recorta texto. Falta quebrar um texto em palavras.

---

## Módulo 4 — Texto II: `strsplit` e `unlist`
*trabalho 5 min · conversa 3 min · lembrete: previsão antes da saída; todo código comentado*

```r
frase <- substr(docs[["d1"]], 1, 25)   # os 25 primeiros caracteres de d1: três palavras
strsplit(frase, " ")                   # quebra no espaço -> devolve uma LISTA
```
```
[[1]]
[1] "recuperacao" "de"          "informacao" 

```

**Pare no `[[1]]`.** É o sinal de **lista**: `strsplit` pode receber vários textos, então devolve uma lista com um vetor por texto. Para um texto só, sobra uma lista de um elemento — e a gente quer o vetor de dentro:

```r
unlist(strsplit(frase, " "))   # "achata" a lista: vira um vetor simples
```
```
[1] "recuperacao" "de"          "informacao" 
```

**Exemplos que você mostra:** `strsplit(docs[c("d4", "d8")], " ")` — dois textos: uma lista com `$d4` e `$d8`, cada um com seus tokens; agora a lista faz sentido. `strsplit("bm25", "")` — sem nada entre as aspas: letra por letra. `unlist(strsplit("a,b", ","))` — outro separador.

**Explore:** `length(strsplit(frase, " "))` — 1 (a lista tem um elemento). `length(unlist(strsplit(frase, " ")))` — 3. `paste(unlist(strsplit(frase, " ")), collapse = " ")` — reconstrói a frase: `paste` com `collapse` é o inverso de `strsplit`.

> **Erro previsto:** "por que não devolve o vetor direto?". Sinal: ele estranha o `[[1]]` ou tenta usar o resultado como vetor. Reação: mostre `strsplit(docs[c("d4", "d8")], " ")` — dois textos, e o segundo poderia ter outro tamanho; só uma lista comporta isso.

> **Erro previsto:** ele escreve `"\\s+"` porque viu nos slides. Sinal: pergunta o que é. Reação: uma linha — "um ou mais espaços"; é regex, e regex é o Módulo 9. **Guarde.**

> **Checkpoint 4.** *Sem rodar: `unlist(strsplit("bm25 e um", " "))` tem quantos elementos, e `strsplit("bm25 e um", " ")` é de que tipo?*
> Esperado: 3 elementos; lista.

> **Ponte:** minúsculas, quebrar, achatar — três passos que vão se repetir 8 vezes. Vamos empacotar numa função.

---

## Módulo 5 — Funções: `tokenizar`
*trabalho 4 min · conversa 2 min · lembrete: previsão antes da saída; todo código comentado*

```r
tokenizar <- function(texto) {     # function(argumentos) { corpo }
  texto <- tolower(texto)          # minúsculas: "Modelo" e "modelo" viram o mesmo
  unlist(strsplit(texto, " "))     # a ÚLTIMA expressão é o valor devolvido
}                                  # fim da função
tokenizar(frase)                   # testa na frase do Módulo 4
```
```
[1] "recuperacao" "de"          "informacao" 
```

Não precisa de `return` — a última linha do corpo é devolvida. (Existe `return(...)`; a Aula 01 vai usá-lo uma vez.) É a função da Aula 01 — com uma diferença que o Módulo 10 corrige.

**Exemplos que você mostra:** `tokenizar("Ciencia de DADOS")` → `"ciencia" "de" "dados"` — o `tolower` agiu. `tokenizar(docs[["d8"]])` — 7 tokens. `dobro <- function(x) x * 2` e `dobro(c(1, 2, 3))` — corpo de uma linha não precisa de chaves, e a função é vetorizada de graça porque `*` é.

**Explore:** `tokenizar(docs[["d3"]])` — quantos tokens? (9.) O `texto` de dentro da função existe fora? Rode `texto` depois — erro: é **local**.

> **Erro previsto:** achar que o `texto` de dentro é uma variável de fora. Sinal: ele cria `texto <- "x"` antes e espera que a função use. Reação: o argumento é local — só existe enquanto ela roda.

> **Checkpoint 5.** *Escreva `maiuscula`, que recebe um texto e devolve a primeira palavra dele em maiúsculas. Teste com `docs[["d3"]]`.*
> Esperado: `maiuscula <- function(texto) toupper(unlist(strsplit(texto, " "))[1])`; sai `"BM25"`. Só ferramentas dos Módulos 3 e 4.

> **Ponte:** uma função, um texto. E se forem oito textos?

---

## Módulo 6 — `lapply` e `sapply`
*trabalho 6 min · conversa 4 min · lembrete: previsão antes da saída; todo código comentado*

Em vez de laços, o R aplica uma função a cada elemento. `lapply` devolve **lista**:

```r
tokens <- lapply(docs, tokenizar)   # tokenizar em cada documento -> LISTA de 8 vetores
length(tokens)                      # quantos elementos tem a lista?
tokens[["d4"]]                      # o vetor de tokens de d4
```
```
[1] 8
```
```
[1] "aprendizado" "estatistico" "fundamenta"  "a"           "recuperacao"
[6] "moderna"    
```

(O `[6]` na segunda linha é só o R quebrando a linha: é o índice do sexto elemento.)

`sapply` faz o mesmo e **tenta simplificar** para vetor ou matriz:

```r
sapply(tokens, length)   # quantos tokens em cada documento -> vetor NOMEADO
```
```
d1 d2 d3 d4 d5 d6 d7 d8 
 7  9  9  6  9  8  9  7 
```

**Regra prática:** `lapply` quando quiser lista; `sapply` quando quiser vetor ou matriz. Na Aula 01: `lapply` para tokenizar (cada documento dá um vetor de tamanho diferente — precisa de lista); `sapply` para o que dá um valor por documento.

**Duas coisas novas**, em uma linha cada: **`sum(x)`** soma todos os elementos de `x`; **`list(a = …, b = …)`** cria uma lista nomeada à mão — a mesma coisa que o `lapply` devolve, mas escrita por você.

**Exemplos que você mostra:**

- `lapply(docs[c("d4", "d8")], nchar)` — lista com `$d4` 56 e `$d8` 50; `sapply(docs[c("d4", "d8")], nchar)` — a mesma conta, como vetor nomeado `d4 56 d8 50`;
- `sapply(tokens, toupper)` — **não** simplifica: os vetores têm tamanhos diferentes, sai lista mesmo assim;
- `sum(c(7, 9, 9))` → `[1] 25`; `sum(sapply(tokens, length))` → `[1] 64` — palavras no corpus inteiro;
- `list(a = c("x", "y"), b = "z")` — uma lista com dois elementos de tamanhos diferentes; `sapply(list(a = c("x", "y"), b = "z"), length)` → `a 2`, `b 1`.

**Explore:** `sapply(docs, nchar)` — igual a `nchar(docs)`, porque `nchar` já é vetorizada.

> **Erro previsto:** "qual dos dois eu uso?". Sinal: ele hesita entre os dois em cada exercício. Reação: pergunte de volta — *"o resultado de cada elemento tem o mesmo tamanho?"* Se sim, `sapply` simplifica; se não, ele devolve lista mesmo assim, e é melhor ser explícito com `lapply`.

> **Erro previsto:** `lapply(docs, tokenizar())` com parênteses. Sinal: erro. Reação: passa-se o **nome** da função, sem chamá-la — o `lapply` chama.

> **Checkpoint 6.** *Sem rodar: `sapply(list(a = 1:3, b = 1:5), sum)` — o que sai?*
> Esperado: `a 6`, `b 15` — um vetor nomeado.

> **Ponte:** aplicar funções está feito. Agora, contar.

---

## Módulo 7 — `table`, `factor`, `sort`, `%in%`
*trabalho 7 min · conversa 4 min · lembrete: previsão antes da saída; todo código comentado*

`table` conta quantas vezes cada valor aparece:

```r
table(tokens[["d3"]])["de"]                           # quantas vezes "de" aparece em d3
sort(table(tokens[["d3"]]), decreasing = TRUE)[1:3]   # os 3 mais frequentes de d3
```
```
de 
 2 
```
```

  de bm25    e 
   2    1    1 
```

Ordem alfabética nos empates, e só o que **aparece**. Agora o problema do curso: cada documento precisa virar um vetor do **mesmo tamanho** — o de um vocabulário fixo — inclusive com os termos que ele **não tem**:

```r
vocab <- c("de", "modelo", "busca")               # um vocabulário de 3 termos, fixado por nós
table(factor(tokens[["d3"]], levels = vocab))     # conta SÓ esses, NESSA ordem, com zeros
```
```

    de modelo  busca 
     2      1      0 
```

**Duas coisas mudaram.** A ordem é a de `vocab`, não alfabética. E `busca` apareceu com **zero** — d3 não tem. É isso que `factor(levels = …)` faz: fixa as categorias antes de contar.

**Exemplos que você mostra:** `table(factor(tokens[["d5"]], levels = vocab))` → `0 0 1`. `table(factor(tokens[["d1"]], levels = vocab))` → `1 0 0`. Três documentos, três vetores do **mesmo tamanho** — é o que vai permitir empilhá-los.

**`%in%`** pergunta, para cada elemento da esquerda, se está na direita. **Novo: `!`** inverte: `TRUE` vira `FALSE` e vice-versa (o `not` do Python) — `!c(TRUE, FALSE)` → `FALSE TRUE`.

```r
c("modelo", "busca") %in% tokens[["d3"]]              # está em d3? um TRUE/FALSE por termo
tokens[["d1"]][!tokens[["d1"]] %in% c("de", "por")]   # os tokens de d1 que NÃO são "de" nem "por"
```
```
[1]  TRUE FALSE
```
```
[1] "recuperacao" "informacao"  "ordena"      "documentos"  "relevancia" 
```

A segunda linha é o **filtro**: `x[!x %in% lista]` — "os elementos de `x` que não estão em `lista`". A Aula 03 usa exatamente isso.

**Explore:** `sort(sapply(tokens, length), decreasing = TRUE)` — o documento mais longo primeiro. `vocab %in% tokens[["d3"]]` — invertido: a saída tem o tamanho de `vocab`.

> **Erro previsto:** "para que o zero?". Sinal: ele acha que o `busca 0` é sujeira. Reação: *"se dois documentos derem vetores de tamanhos diferentes, dá para empilhar numa tabela?"* Não. O zero é o que torna todos do mesmo tamanho. O que se faz com a tabela é a Aula 01.

> **Erro previsto:** inverter os lados do `%in%`. Sinal: `vocab %in% tokens` quando queria `tokens %in% vocab`. Reação: a saída tem o tamanho do lado **esquerdo**.

> **Checkpoint 7.** *Sem rodar: `table(factor(tokens[["d2"]], levels = vocab))` — o que sai, e em que ordem?*
> Esperado: `de 1`, `modelo 1`, `busca 0` — na ordem de `vocab`.

> **Ponte:** vetores do mesmo tamanho se empilham. Isso é uma matriz.

---

## Módulo 8 — Matrizes e reciclagem
*trabalho 7 min · conversa 4 min · lembrete: previsão antes da saída; 360–540 palavras na reciclagem*

Uma matriz pequena, montada à mão a partir do corpus: quantas vezes `de` e `modelo` aparecem em d1 e em d2 (ele confere em `tokens`).

```r
m <- matrix(c(1, 0, 1, 1), nrow = 2)   # 4 números, em 2 linhas
rownames(m) <- c("de", "modelo")       # nomes das linhas: os termos
colnames(m) <- c("d1", "d2")           # nomes das colunas: os documentos
m                                      # mostra a matriz
```

**Antes de mostrar, pergunte onde ele acha que o 0 vai parar.**

```
       d1 d2
de      1  1
modelo  0  1
```

O R preenche **por coluna**: 1 e 0 descem a coluna d1, 1 e 1 a coluna d2. Confira com ele: d1 tem `de` uma vez e não tem `modelo`; d2 tem os dois. Acesso: `m["de", ]` (linha), `m[, "d2"]` (coluna), `m["modelo", "d1"]` (elemento). Úteis: `dim(m)`, `rowSums(m)`, `colSums(m)`.

**A reciclagem.** Multiplique a matriz por um vetor com um número por **linha**:

```r
peso <- c(1, 10)   # um peso por LINHA: "de" vale 1, "modelo" vale 10
m * peso           # reciclagem: o vetor se repete ao longo das colunas
```

Peça a previsão. Depois:

```
       d1 d2
de      1  1
modelo  0 10
```

**Como o R fez isso.** Ele percorre a matriz na mesma ordem em que a preencheu — por coluna: 1, 0, 1, 1. E percorre `peso` em paralelo, **repetindo-o** quando acaba: 1, 10, 1, 10. Então $1 \times 1$, $0 \times 10$, $1 \times 1$, $1 \times 10$. Como `peso` tem exatamente o tamanho de uma coluna, ele se alinha com as linhas: a linha `de` sempre pega o 1, a linha `modelo` sempre pega o 10.

Por que `modelo` valeria mais que `de`? **Isso é a Aula 01.** Aqui, só a mecânica: um peso por termo, sem laço.

**Exemplos que você mostra:** `m * c(10, 1)` — invertido: `de` vale 10. `m * 10` — um número só recicla 4 vezes. `m + 1` — soma também recicla.

**Explore:** `rowSums(m)` — em quantos documentos (destes dois) cada termo aparece. `colSums(m)` — quantos termos (destes dois) cada documento tem. `m * c(1, 2, 3)` — um vetor de 3.

> **Erro previsto:** esperar `1 0` na primeira linha. Sinal: a previsão dele. Reação: `matrix(c(1, 0, 1, 1), nrow = 2, byrow = TRUE)` faz isso — mas o padrão é por coluna, e é o padrão que a reciclagem usa.

> **Erro previsto:** `m * c(1, 2, 3)`. Sinal: ele testa um vetor de 3. Reação: deixe rodar — sai um *warning* ("longer object length is not a multiple of shorter object length" — o comprimento maior não é múltiplo do menor) e um resultado estranho. O R **avisa mas não impede**. É a 3ª pergunta da Parte 2 da tarefa de casa — ele acabou de vê-la.

> **Checkpoint 8.** *Sem rodar: `m * c(2, 3)` — o que sai?*
> Esperado: `de: 2 2`; `modelo: 0 3`. A linha `de` pega o 2, a linha `modelo` pega o 3.

> **Ponte:** `"\\s+"` ficou guardado desde o Módulo 4. Hora de pagar — dois módulos de regex.

---

## Módulo 9 — Regex I — procurar: `grep`, `grepl`, `^`, `$`, `|`, `[ ]`, `+`
*trabalho 9 min · conversa 5 min · lembrete: previsão antes da saída; todo código comentado; pedaço não é palavra*

Uma **regex** — *regular expression*, expressão regular — é uma pequena linguagem para **descrever padrões** de texto. Em vez de procurar um texto exato, você descreve a *forma* do que procura. Ele já viu uma: `"\\s+"`.

**Duas funções para procurar.** `grep` devolve as **posições** dos elementos que casam; `grepl` devolve `TRUE`/`FALSE` para cada elemento (o `l` é de *logical*).

```r
grep("modelo", docs)                 # em QUAIS documentos aparece "modelo"? posições
grepl("modelo", docs)                # o mesmo, como TRUE/FALSE por documento
names(docs)[grepl("modelo", docs)]   # os NOMES dos que têm — o filtro do Módulo 7
```
```
[1] 2 3
```
```
[1] FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
```
```
[1] "d2" "d3"
```

**O mínimo da linguagem:**

| símbolo | significado | exemplo |
|---|---|---|
| `^` | início do texto | `"^o "` — começa com "o " |
| `$` | fim do texto | `"busca$"` — termina em "busca" |
| `\|` | ou | `"busca\|modelo"` |
| `[0-9]` | um caractere dentre os listados | `"[0-9]"` — algum dígito; `"[aeiou]"` — alguma vogal |
| `+` | uma ou mais repetições do anterior | `"\\s+"` — um ou mais espaços |
| `\\s` | espaço em branco | uma barra é do R, a outra da regex |

```r
grep("^o ", docs)            # começam com "o "
grep("busca$", docs)         # terminam em "busca"
grep("busca|modelo", docs)   # têm "busca" OU "modelo"
grep("[0-9]", docs)          # têm algum dígito
```
```
[1] 2 5
```
```
[1] 7
```
```
[1] 2 3 5 7
```
```
[1] 3
```

**A lição do módulo — regex casa pedaço, não palavra:**

```r
grep("de", docs)     # quem tem "de"?
grep(" de ", docs)   # e "de" entre espaços?
```
```
[1] 1 2 3 4 6 7 8
```
```
[1] 1 2 3 6 8
```

Faça-o achar por que d4 e d7 entraram no primeiro: "mo**de**rna", "me**de**". A regex enxerga o texto como **sequência de caracteres**; "de" está dentro de outras palavras. Os espaços ajudam — mas perderiam um "de" no início ou no fim do texto. Casar **palavras** de verdade é o que a tokenização faz: **Aula 01.**

**Exemplos que você mostra:** `grep("recupera", docs)` → `1 4` — acha "recuperacao". `grep("^a ", docs)` → `7`. `grepl("[aeiou]$", docs)` — terminam em vogal.

**Explore:** `grep("modelo", docs, value = TRUE)` — os textos em vez das posições (com nomes). `grep("^[ab]", docs)` — começam com "a" ou "b": `3 4 7`. `sum(grepl("documentos", docs))` — em quantos.

> **Erro previsto:** esperar que `grep("de", docs)` ache só a palavra. Sinal: ele estranha d4 e d7. Reação: é o ponto do módulo — não corrija, pergunte *"onde está o 'de' em d4?"*

> **Erro previsto:** `grep` devolve números e ele queria os textos. Sinal: *"o que é esse 2 3?"*. Reação: `value = TRUE`, ou `names(docs)[grepl(...)]` — o idioma do curso.

> **Checkpoint 9.** *Sem rodar: `grep("documentos$", docs)`? E `grep("^e", docs)`?*
> Esperado: `5 6` — d1 e d2 também têm "documentos", mas não no fim; `6` — só d6 começa com "e" ("embeddings").

> **Ponte:** procurar está feito. Agora, trocar e limpar.

---

## Módulo 10 — Regex II — transformar e limpar: `sub`, `gsub`, `.`, `*`, `{n}`, `[^ ]`, `trimws`
*trabalho 9 min · conversa 5 min · lembrete: previsão antes da saída; todo código comentado; não adiante a Aula 03*

`sub` troca a **primeira** ocorrência; `gsub` troca **todas** (o `g` é de *global*):

```r
sub("de", "DE", docs[["d3"]])    # troca a PRIMEIRA ocorrência
gsub("de", "DE", docs[["d3"]])   # troca TODAS
```
```
[1] "bm25 e um moDElo probabilistico de ranqueamento de texto"
```
```
[1] "bm25 e um moDElo probabilistico DE ranqueamento DE texto"
```

**Faça-o ler a primeira saída.** A "primeira ocorrência" de `de` está dentro de **modelo**. Mesma lição do Módulo 9, agora estragando texto. `gsub(" de ", " DE ", docs[["d3"]])` conserta aqui — e falharia num "de" no início do texto.

**Mais três símbolos:**

| símbolo | significado | exemplo |
|---|---|---|
| `.` | qualquer caractere | `"m.d"` casa "mod", "mud" |
| `*` | zero ou mais repetições do anterior | `".*"` — qualquer coisa, inclusive nada |
| `{n}` | exatamente n repetições | `"[a-z]{12}"` — 12 letras seguidas |
| `{n,}` | n ou mais repetições | `"\\s{2,}"` — dois ou mais espaços |
| `[^ ]` | um caractere que **não** está na lista | `"[^a-z ]"` — nem letra minúscula nem espaço |

```r
gsub("[aeiou]", "", docs[["d1"]])   # apaga todas as vogais
gsub("[0-9]+", "", docs[["d3"]])    # apaga sequências de dígitos
grep("[a-z]{12}", docs)             # tem uma palavra com 12 letras seguidas?
```
```
[1] "rcprc d nfrmc rdn dcmnts pr rlvnc"
```
```
[1] "bm e um modelo probabilistico de ranqueamento de texto"
```
```
[1] 3
```

```r
sub(" .*$", "", docs[["d1"]])   # do primeiro espaço até o fim: apaga -> sobra a primeira palavra
sub("^.* ", "", docs[["d1"]])   # do início até o ÚLTIMO espaço: apaga -> sobra a última palavra
```
```
[1] "recuperacao"
```
```
[1] "relevancia"
```

Na segunda, o `.*` é **guloso**: pega o máximo que puder — até o último espaço.

**A faxina.** Um texto como chega da internet, e o pipeline que o curso vai usar:

```r
sujo <- "  O Modelo   de Espaco   Vetorial!! "   # espaços sobrando, caixa mista, pontuação
x <- trimws(sujo)                # tira os espaços das pontas
x <- tolower(x)                  # minúsculas
x <- gsub("[^a-z ]", "", x)      # apaga tudo que NÃO é letra minúscula nem espaço
x <- gsub("\\s+", " ", x)        # um ou mais espaços -> um só
x                                # o texto limpo
```
```
[1] "o modelo de espaco vetorial"
```

É o começo de d2. Quatro linhas, cada uma um passo previsível. (O que fazer com acentos, plural e palavras vazias é a **Aula 03**.)

**E a `tokenizar` definitiva:** troque `" "` por `"\\s+"` no `strsplit` — agora ela aguenta espaços duplos. É exatamente a da Aula 01.

**Exemplos que você mostra:** `gsub("cao", "ção", docs[["d1"]])` — devolve dois acentos. `nchar(gsub(" ", "", docs[["d1"]]))` → `52` — letras sem os espaços. `grepl("MODELO", docs, ignore.case = TRUE)` — `ignore.case` ignora caixa: d2 e d3 `TRUE`.

**Explore:** `sub("^o ", "", docs[["d2"]])` — tira o artigo. `gsub("\\s+", "_", sujo)`. `tokenizar("recuperacao   de   informacao")` antes e depois da troca por `"\\s+"`.

> **Erro previsto:** `sub` quando queria `gsub`. Sinal: só a primeira ocorrência trocou. Reação: o `g` é de *global*.

> **Erro previsto:** `"\s+"` com uma barra só. Sinal: erro *'\s' is an unrecognized escape*. Reação: a string do R precisa de `\\` para entregar `\` à regex.

> **Erro previsto:** usar `.` querendo um ponto literal. Sinal: `gsub(".", "", x)` apaga o texto inteiro. Reação: `.` é "qualquer caractere"; ponto literal é `"\\."`.

> **Checkpoint 10.** *Sem rodar: `gsub("o", "0", docs[["d5"]])`? E `sub(" .*$", "", docs[["d3"]])`?*
> Esperado: `"0 indice invertid0 acelera a busca em muit0s d0cument0s"`; `"bm25"`.

> **Ponte:** ele tem todas as peças. O último módulo mostra onde cada uma entra na Aula 01.

---

## Módulo 11 — O mapa da Aula 01
*trabalho 3 min · conversa 3 min · lembrete: só o mapa — não ensine a Aula 01*

Tudo o que a Aula 01 escreve, ele já lê:

| na Aula 01 aparece | ele aprendeu aqui |
|---|---|
| `docs <- c(d1 = "...", d2 = "...")` | o mesmo vetor — ele já digitou (M1, M2) |
| `unlist(strsplit(tolower(x), "\\s+"))` | texto → tokens (M3, M4, M10) |
| `lapply(docs, tokenizar)` | função aplicada a vários (M5, M6) |
| `table(factor(t, levels = vocab))` | contagem com categorias fixas (M7) |
| `sapply(...)` → matriz | empilhar vetores do mesmo tamanho (M6, M8) |
| `tdm * idf` — `tdm` é a matriz termos $\times$ documentos; `idf`, um peso por termo (o que são: Aula 01) | reciclagem (M8) |
| `colnames(tdm)[tdm[termo, ] > 0]` — `>` compara, como o `==` (novo na Aula 01) | o filtro `nomes[condição]` (M7, M9) |
| `grep("recupera", docs)` acha, o motor não | regex casa pedaço, motor casa termo (M9) |
| `t[!t %in% stopwords]` | filtro com `%in%` (M7) — Aula 03 |

**Ajuda rápida para sempre:** `?funcao` abre a documentação; `str(x)` mostra a estrutura; `class(x)` diz o tipo. **Ele não precisa decorar o R** — precisa reconhecer vetor, lista e matriz, e ler uma regex. O resto se consulta.

> **Erro previsto:** querer que você explique o que `tdm * idf` **faz para a busca**. Sinal: *"mas para que serve esse peso?"*. Reação: uma linha — "multiplica cada linha da matriz por um peso; o que é o peso, é a Aula 01." **Guarde.**

> **Checkpoint 11.** *Leia em voz alta, passo a passo, o que `names(docs)[grepl("busca", docs)]` faz — e diga o que sai.*
> Esperado: `grepl` dá 8 `TRUE`/`FALSE`; o colchete filtra os nomes onde é `TRUE`; sai `"d5" "d7"`.

> **Ponte:** ele lê o código da Aula 01. O teste confirma.

---

**Funções de R apresentadas nesta aula** (o guia da Aula 01 copia esta linha): `c`, `length`, `names`, `[ ]`, `[[ ]]`, `==`, `!`, `nchar`, `toupper`, `tolower`, `substr`, `paste`, `paste0`, `1:n`, `strsplit`, `unlist`, `function`, `lapply`, `sapply`, `sum`, `list`, `table`, `factor(levels = …)`, `sort(decreasing = …)`, `%in%`, `matrix`, `rownames`, `colnames`, `dim`, `rowSums`, `colSums`, `grep`, `grepl`, `sub`, `gsub`, `trimws`, `ignore.case`, `value = TRUE` (de `grep`), `byrow = TRUE` (de `matrix`), `?funcao`, `str`, `class`; regex `^ $ | [ ] [^ ] + . * {n} {n,} \\s`; reciclagem.

**Casos degenerados desta aula:** `docs[0]` → vetor vazio, sem erro; `docs[9]` → `NA`, sem erro; `substr(x, 0, …)` → o `0` vira 1, sem aviso; `m * c(1, 2, 3)` → *warning* e resultado estranho, mas roda. Em todos, o R **avisa pouco** — a lição é conferir.

---
---

# PARTE C — Teste final: uma pergunta por módulo

**Só depois de o Módulo 11 estar concluído, e antes do consolidado.** Avise: *"agora um teste curto — uma pergunta por módulo."*

**As perguntas são estas, e só estas.** Só os módulos alcançados. Se você ensinou algo além do guia, isso **não** entra. **Uma por vez.** Diga se acertou e, em uma linha, o que faltou. Não reensine — anote o módulo.

| módulo | pergunta | esperado |
|---|---|---|
| **1** | O primeiro elemento de um vetor em R é `docs[0]` ou `docs[1]`? O que `docs[0]` devolve? | `docs[1]`; `docs[0]` devolve um vetor vazio (`named character(0)`) |
| **2** | Por que `docs["d5"]` mostra `d5` em cima do texto, e `docs[["d5"]]` não? | colchete simples preserva o nome; duplo extrai só o valor |
| **3** | `length("bm25")` e `nchar("bm25")` — quanto dá cada um, e por quê? | 1 e 4: uma string é um vetor de um elemento; `nchar` conta caracteres |
| **4** | Por que `strsplit` precisa de `unlist` depois? | devolve lista (pode receber vários textos); `unlist` achata para vetor |
| **5** | Numa função em R sem `return`, o que é devolvido? | o valor da última expressão do corpo |
| **6** | Quando usar `lapply` e quando `sapply`? | `lapply` quando quer lista (tamanhos diferentes); `sapply` quando quer vetor ou matriz (tamanhos iguais) |
| **7** | O que `factor(x, levels = vocab)` acrescenta ao `table`? | categorias fixas na ordem de `vocab`, inclusive as de contagem zero — todos os vetores ficam do mesmo tamanho |
| **8** | Em `m * peso`, com `m` de 2 linhas e `peso` de 2 elementos, qual linha pega qual peso — e por quê? | a linha 1 pega o primeiro, a linha 2 o segundo: o R percorre por coluna e recicla `peso` a cada coluna |
| **9** | Por que `grep("de", docs)` acha d4 ("aprendizado … moderna")? | regex casa pedaço: "de" está dentro de "moderna" |
| **10** | Qual é a diferença entre `sub` e `gsub`, e o que `[^a-z ]` significa? | `sub` troca a primeira ocorrência, `gsub` todas; `[^a-z ]` é qualquer caractere que **não** é letra minúscula nem espaço |
| **11** | Na Aula 01, `lapply(docs, tokenizar)` devolve o quê? | uma lista com 8 vetores de tokens, um por documento |

**Ao terminar, o resultado em uma linha:** *"acertou os módulos 1, 2, 3, 4, 5, 6, 9, 10 e 11; 7 e 8 vão para revisão."* Isso entra no consolidado.

- **Errou 3 ou mais:** recomende revisar antes da Aula 01 — ela usa tudo isto na primeira meia hora.
- **Errou 2 ou menos:** *"Você lê o código da Aula 01."*

**Então diga:** *"A próxima etapa é a Parte D, também sua: três frases suas, tokenizadas, limpas e vasculhadas com regex — e o fluxo do curso, com o Colab e o GitHub. Abra `GUIA_ESTUDO_aula00_parteD.md`, numa conversa nova, com o consolidado que vou gerar agora."* Depois, fechamento.

---

## Glossário

| sigla / termo | por extenso | o que é |
|---|---|---|
| R | — | a linguagem do curso; estatística por natureza |
| Colab | Google Colaboratory | onde o R roda, no navegador, em células; apaga tudo quando a sessão cai |
| célula | — | uma caixa de código do Colab; ▶ ou *Shift+Enter* roda |
| LLM | *large language model* | modelo de linguagem — a tutora que está lendo isto |
| CRAN | *Comprehensive R Archive Network* | onde se baixa o R para instalar no computador: `cran.r-project.org` (opcional) |
| RStudio | — | ambiente com editor, console e gráficos; opcional |
| `NA` | *not available* | "não disponível": como o R marca um valor que falta |
| vetor | — | sequência de valores do mesmo tipo; quase tudo em R é vetor |
| vetor nomeado | — | vetor em que cada posição tem um nome; `c(d1 = "…")` |
| *string* | — | um texto; em R, um elemento de um vetor de caracteres |
| lista | — | coleção que aceita elementos de tamanhos e tipos diferentes |
| matriz | — | tabela de números, linhas $\times$ colunas; preenchida por coluna |
| reciclagem | — | repetir um vetor curto para operar com um longo |
| regex | *regular expression* | padrão que descreve a forma de um texto |
| âncora | — | `^` e `$`: prendem o padrão ao início ou ao fim |
| classe de caracteres | — | `[…]`: um caractere dentre os listados; `[^…]`: um que não está |
| quantificador | — | `+`, `*`, `{n}`, `{n,}`: quantas repetições do anterior |
| guloso | *greedy* | o `*` pega o máximo que puder |
| *pipeline* | — | sequência de passos, cada um sobre a saída do anterior |
| token | — | pedaço em que o texto é quebrado; aqui, palavra |
| corpus | — | a coleção de documentos; aqui, os 8 |
| *stopword* | — | palavra frequente e vazia de assunto: "de", "a", "e" (Aula 03) |

---

## Fechamento

Ordem fixa: **teste → oferta da Parte D → perguntas guardadas → tarefa → o que vem → consolidado → passos de fechamento.**

1. **Perguntas guardadas:** responda as curtas; encaminhe as outras — "o que é `idf`" e "o que é matriz termo-documento" são da Aula 01; "e os acentos?" é da Aula 03.
2. **A tarefa**, sem fazê-la por ele. Parte 1: *explicar e explorar* cada bloco — o que vocês fizeram nos passos 1–5, agora por escrito. Parte 2: quatro perguntas para investigar (`sapply` versus `lapply`; `table` sem `factor`; `m * peso` com 3 elementos; três frases suas). Parte 3: **as cinco missões das manchetes** — faxina do sufixo com `sub` e `$`, espaços com `gsub("\\s{2,}", " ", x)`, ano com `"[0-9]{4}"`, municípios com `|` e `ignore.case = TRUE`, e a pegadinha do "Santos". Ele tem todas as ferramentas. Pode explicar o que cada missão pede; **não escreve o código**.
3. **O que vem:** *"A Aula 01 pega exatamente estas peças — o `docs` que você digitou, `tokenizar`, `lapply`, `table(factor())`, `sapply`, reciclagem — e monta com elas a primeira estrutura de um motor de busca: a matriz termo-documento, em que cada linha é uma palavra e cada coluna é um documento. E ela volta ao `grep("recupera", docs)` para dizer o que um motor de busca é, e o que não é."*
4. **Gere o consolidado** — avise que está gerando.
5. **Logo abaixo do consolidado, na mesma mensagem, escreva os passos de fechamento** — os cinco do fim deste arquivo, por extenso.

---

# PARTE D — está em outro arquivo

A prática — **Módulos 12 a 14**: três frases dele, tokenizadas, contadas, limpas e vasculhadas com regex que **ele** escreve; e o fluxo de trabalho do curso — carregar código por endereço, enviar e baixar arquivos no Colab, anexar o estado do R, enviar ao GitHub — está em `GUIA_ESTUDO_aula00_parteD.md`. É outra sessão, individual, de 45 a 60 minutos. **O Módulo 14 é pré-requisito da Aula 01**: sem ele, o fechamento das próximas sessões não funciona.

Se ele não quiser seguir agora, o consolidado registra "Parte D não iniciada — fazer antes da Aula 01".

---

## Modelo do consolidado

**Relato sobre o aluno, em três partes — não resumo da matéria.** Meia página é o normal; 2 mil palavras é o teto. **Bloco de código Markdown**, para salvar como `aula00_consolidado.md`. **Nunca PDF, nunca relatório, nunca reexplicação, nunca código.** Opine em primeira pessoa. **Não escreva a seção "Estado do R"** — o R a acrescenta depois.

**Privacidade:** registra como ele aprende, nunca capacidade; nada que ele não possa ler em voz alta na frente da turma.

```markdown
# Consolidado — PI III — Aula 00 — <data>
*guia versão 3 · tutora: <qual LLM> · sessão individual (teoria) · sem motor*
**Aluno:** <nome>

## 1. O que foi passado
- M1 — Colab em R, `<-`, o corpus `docs` como vetor de 8; `[1]`; R começa em 1; vetorização
- M2 — nomes; `[ ]` preserva o nome, `[[ ]]` não; `==`
- M3 — `nchar` versus `length`; `toupper`/`tolower`; `substr`; `paste`/`paste0`/`collapse`
- M4 — `strsplit` (lista), `unlist`
- M5 — funções; a última expressão é devolvida; escreveu `tokenizar` e `maiuscula`
- M6 — `lapply` (lista) e `sapply` (simplifica); `sum`, `list`; `tokens`
- M7 — `table`; `factor(levels = …)` fixa categorias e zeros; `sort`; `%in%`, `!` e o filtro
- M8 — matriz por coluna; reciclagem em `m * peso`
- M9 — regex I: `grep`/`grepl`, `^ $ | [ ] +`; pedaço não é palavra (`grep("de", docs)`)
- M10 — regex II: `sub`/`gsub`, `. * {n} {n,} [^ ]`, `trimws`, o pipeline de limpeza; `tokenizar` com `\\s+`
- M11 — o mapa da Aula 01
<se parou por tempo: "parou no M7; M8–M11 não alcançados — retomar do M8">

## 2. Como foi o aprendizado — opinião da tutora
<um parágrafo direto, em primeira pessoa: como se virou no Colab; quanto Python ele trouxe e se
isso ajudou ou atrapalhou (o `[0]`, o `len`, o `return`); quantas previsões acertou; onde travou —
a lista do `strsplit`? a reciclagem? o `factor`? o "de" dentro de "modelo"?; o que construiu
sozinho e o que foi entregue; se explorou por conta própria ou só quando pedido.>

**Teste final:** acertou M<lista>; a revisar M<lista> — <uma linha por módulo, o que faltou>.

## 3. Observações para a frente
- **Revisar antes da Aula 01:** <o quê, e por quê>
- **Para a próxima tutora:** <ritmo, perfil, conforto com R, se pensa em Python, se gostou de regex>
- **Perguntas guardadas:** <pergunta> — <para qual aula>
- **Produzido:** `docs` digitado; `tokenizar` (versão `\\s+`) e `maiuscula` escritas por ele; previsões certas: <n> de <n>
- **Parte D (frases próprias + Colab e GitHub):** <não iniciada — fazer antes da Aula 01 | feita>
```

## Passos de fechamento (copie logo abaixo do consolidado)

Nesta aula não há motor; as funções do estado vêm de um arquivo da disciplina. Se algum passo for novo para ele, tudo bem: o Módulo 14 da Parte D ensina cada um com calma.

1. Copie o bloco acima e salve no seu computador como **`aula00_consolidado.md`** (Bloco de Notas → *Salvar como* → tipo "Todos os arquivos", codificação UTF-8).
2. No Colab, **sem fechar a sessão**, envie o arquivo: pasta à esquerda → ícone de upload. Rode `list.files()` e confira que ele aparece solto, com esse nome exato.
3. Rode, numa célula nova:
   ```r
   source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/estado.R")  # as funcoes do estado
   anexar_estado("aula00_consolidado.md")   # o R anexa a fotografia da sessao ao consolidado
   ```
4. Baixe o arquivo de volta: três pontinhos ao lado dele → *Fazer download*. Abra e confira que a seção "Estado do R" apareceu no fim.
5. Guarde. Ele vai para o repositório do seu grupo, em `consolidados/<seu nome>/`, quando o repositório existir (Parte D da Aula 01).

Se ele disser que já fez, pergunte só: *"a seção 'Estado do R' apareceu no fim do arquivo?"*
