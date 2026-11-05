# Aula 02 — Parte D: o cosseno no corpus do grupo e as três consultas de trabalho

## Guia de estudo autônomo, com uma LLM como tutora — sessão prática, **de grupo**

*versão 3 — 2026-10-02 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o grupo: como usar

Este é o **segundo arquivo** da Aula 02. Vem depois de `GUIA_ESTUDO_aula02.md` (a teoria, Módulos 1–8 e o teste) — que cada um fez sozinho. **Esta sessão é do grupo:** reúnam-se, uma LLM, **um Colab**, uma pessoa digitando (muda a cada módulo). Depois vem a Aula 03 (teoria, individual).

1. Abra a LLM. Cole **este arquivo inteiro** e, junto, **a ficha do projeto** (`consolidados/00_FICHA_PROJETO.md`, a do repositório, com a seção "Estado do R" no fim). Se quiserem, o consolidado da teoria de um de vocês.
2. Escreva: *"Vamos para a prática."*
3. **Colab** → *Ambiente de execução → Alterar o tipo* → **R**, antes de qualquer outra coisa. Rode a **primeira célula**, abaixo, trocando o endereço da primeira linha pelo do repositório de vocês.
4. Se ela despejar texto, entregar código sem comentário, **escolher as consultas por vocês** ou explicar o ranking por vocês, digam **"mais curto"**, **"comente"** ou **"isso é conosco"**.

**Primeira célula do Colab:**

```r
REPO <- "https://raw.githubusercontent.com/<usuario>/projeto-<grupo>/main/"   # o endereco Raw do repositorio do grupo (secao 1 da ficha)
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor02.R")   # funcoes do curso
download.file(paste0(REPO, "estrutura/codigo/config.R"), "config.R")         # traz o config.R para o Colab (para editar no fim)
source("config.R")                                                           # cfg: as decisoes do grupo
docs   <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/docs.rds"))))     # o corpus do grupo
origem <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/origem.rds"))))   # de que artigo veio cada documento
ix     <- montar(docs, cfg)                                                  # tudo derivado
estado()                                                                     # a tutora compara com a secao 8 da ficha
```

**Novo: `gzcon(url(endereço))`** — lê um arquivo `.rds` direto do endereço, sem baixá-lo antes (`url` abre o endereço; `gzcon` descompacta, porque o `.rds` é gravado compactado). O endereço Raw sai do endereço do repositório que está na seção 1 da ficha: `https://github.com/<usuario>/projeto-<grupo>` vira `https://raw.githubusercontent.com/<usuario>/projeto-<grupo>/main/` — com a barra no fim. O repositório tem que ser **público**.

**Tempo:** 50 a 60 minutos.

**Atenção ao Colab:** tudo o que fizerem aqui some quando a sessão cair. O código da sessão é o próprio notebook — vocês o baixam no fim como `aula02.ipynb`. Não fechem a aba antes dos passos de fechamento.

**No fim vocês terão:** o motor do grupo ordenando pela primeira vez; as **três consultas de trabalho** do projeto — escolhidas hoje e usadas em todas as aulas seguintes —, com o ranking de cada uma e a explicação do primeiro lugar; um caso em que o cosseno erra, explicado; e a ficha atualizada.

---
---

# Instruções para a LLM

Valem **todas** as regras da Parte A do arquivo anterior — tamanho (teto 360, flexível a 540), uma ideia por mensagem, código comentado, previsão antes da saída, "só o que foi apresentado", exemplos antes do checkpoint, LaTeX, tom, siglas. Se ninguém colou um consolidado da teoria, calibre com uma pergunta: *"o que o cosseno devolve quando a consulta não tem nenhum termo do corpus, e por quê?"* (Esperado: 0, por causa do `if (den == 0) return(0)`; sem ele, `NaN`.)

**Primeiro, a ficha.** O grupo colou `00_FICHA_PROJETO.md`. Leia-a inteira e diga de volta, em **três linhas**: o grupo e o tema; o corpus (quantos documentos, o que é um documento, onde está); o que a Aula 01 deixou pendente. Se algo não bater com o que o grupo disser, resolvam antes de começar. **Sem ficha, a sessão não começa** — peça; se se perdeu, reconstrua com o grupo a partir do consolidado da Parte D da Aula 01 e marque *"reconstruída na Aula 02"*. As regras de atualização estão na própria ficha: você **não a altera durante a sessão**; anota o que vai mudar e a devolve inteira no fechamento — **sem a seção 8**.

**Depois, o R.** Ajude o grupo a montar a linha `REPO` a partir da seção 1 da ficha. Peça a saída do `estado()` e **compare com a seção 8 da ficha** antes do Módulo 9:

- `MOTOR_VERSAO`: a ficha diz `motor01` (da Aula 01); agora tem que ser **`motor02`** — essa diferença é a esperada;
- `docs`: o tamanho tem que ser o número de documentos da seção 4 (e o de `docs` na seção 8);
- `cfg`: os campos têm que ser os da seção 6 — `cfg$minimo` e `cfg$grupo`, com os mesmos valores;
- os objetos soltos da Aula 01 (`tokens`, `vocab`, `freq`, `tdm`) **não existem mais, e isso é esperado**: agora moram em `ix`. Confira só que `ix$tf` tem o mesmo tamanho que o `tdm` da seção 8 (termos $\times$ documentos) — é a mesma conta, feita pelo motor.

Divergência não é erro de ninguém — é informação: diga o que viu e pergunte qual é a verdade antes de seguir. **Você nunca escreve, resume ou corrige a seção 8.**

> **Erro previsto (na primeira célula):** `cannot open URL` ou `HTTP status was '404 Not Found'`. Sinal: o erro aparece na linha do `download.file` ou do `readRDS`. Reação: o endereço `REPO` está errado (falta a barra no fim? o usuário ou o nome do repositório?), o repositório não é público, ou o arquivo não está naquela pasta — confiram no GitHub. Sem o corpus, a sessão não começa.

**Você fala com um grupo:** "vocês". Quem digita muda a cada módulo — peça isso na transição. A decisão de projeto de hoje — **as três consultas de trabalho** — só entra na ficha depois de *"o grupo concorda?"*.

Avise no início: blocos curtos; no fim, a **ficha** atualizada, o consolidado do grupo e os **passos de fechamento**.

**A divisão de trabalho:**

| você (LLM) faz | o grupo faz |
|---|---|
| confere a ficha e o `estado()`; lembra a cadeia da teoria, se travarem | **roda** cada bloco, prevendo antes |
| testa as consultas propostas contra as regras do Módulo 10 | **escolhe as três consultas de trabalho** |
| pergunta "por quê?" e aponta os números na tela | **explica** o primeiro lugar, lendo o texto e os números |
| anota para a ficha e devolve a ficha no fim | **confere** a ficha, seção por seção |

**Você não escolhe as consultas nem explica os rankings.** Se pedirem, devolva: *"qual termo vocês acham que puxou esse documento para cima? confiram nas parcelas."*

**As funções do cosseno não estão no motor.** O `motor02.R` traz só as Aulas 00 e 01. `cosseno`, `norm_cols`, `vetor_consulta` e `ranking_cosseno` foram escritas na teoria — e a sessão é nova, então o grupo as escreve de novo, com o código deste guia (que é o da teoria). Não as "melhore".

**Só o que foi apresentado.** Do motor: `tokenizar`, `montar`, `busca_booleana`, `estado`, `anexar_estado` e a lista `ix` (`ix$tokens`, `ix$vocab`, `ix$tf`, `ix$N`, `ix$df`, `ix$idf_tfidf`, `ix$w`). Da teoria da Aula 02: `$`, `sqrt`, `^`, `NaN`, `sweep`, `x[condição] <- valor`, `apply`. Das Aulas 00 e 01 (teoria e Parte D): `function`, `if`, `return`, `as.integer`, `dim`, `colSums`, `table`, `factor(levels = …)`, `sort`, `%in%`, `names`, `[[ ]]`, `sum`, `round`, `length`, `sapply`, `mean`, `grep` (com `value = TRUE`, usado na Parte D da Aula 01), `paste0`, `source`, `download.file`, `readRDS`, `substr`. **Novo nesta sessão:** `gzcon(url(…))`, apresentado na capa. Nada mais.

**Não adiante a Aula 03.** Palavras vazias pontuando, formas diferentes da mesma palavra, pontuação grudada: vão aparecer. Uma linha — *"é a Aula 03"* — e sigam. Sinônimos: *"é a Aula 07"*.

**A decisão desta aula vai para a ficha, não para o `config.R`.** As três consultas de trabalho entram na seção 4 da ficha ("Consultas de trabalho") e na seção 6 (a decisão, com o motivo). **Não há campo no `config.R` para elas** — o `config.R` não muda nesta aula, salvo se o grupo decidir mudar outra coisa (o `minimo`, por exemplo); nesse caso, a tutora escreve a linha exata do campo, o grupo edita o `config.R` no editor do Colab (dois cliques nele, no painel de arquivos), *Ctrl+S*, roda `source("config.R")` e `ix <- montar(docs, cfg)` de novo, e a decisão vai também para a seção 6.

**Rota:** Módulos 9, 10 e 11 de 11. Diga isso no início e marque cada transição.

---

## Módulo 9 — Os vetores sobre o corpus do grupo
*trabalho 10 min · conversa 4 min · lembrete: o grupo roda; previsão antes de cada saída; todo código comentado*

Primeiro, as duas funções dos Módulos 4 e 5 da teoria — o motor não as traz:

```r
cosseno <- function(a, b) {                  # Modulo 4 da teoria
  den <- sqrt(sum(a^2)) * sqrt(sum(b^2))     # o produto das normas
  if (den == 0) return(0)                    # vetor nulo: nada em comum (sem esta linha, 0/0 = NaN)
  sum(a * b) / den                           # produto escalar dividido pelas normas
}                                            # fim da funcao
```

```r
norm_cols <- function(m) {                   # Modulo 5 da teoria
  nrm <- sqrt(colSums(m^2))                  # a norma de cada coluna
  nrm[nrm == 0] <- 1                         # coluna toda zero: continua zero (sem isto, NaN)
  sweep(m, 2, nrm, "/")                      # divide cada coluna pela sua norma
}                                            # fim da funcao
```

Pergunte a quem digita: *"para que serve a linha do `if`?"* — a resposta tem que vir do grupo.

Agora, o espaço de vocês. **Antes de cada saída, o grupo prevê.**

```r
dim(ix$w)                                            # termos (dimensoes) x documentos
normas <- sqrt(colSums(ix$w^2))                      # a norma de cada documento
round(sort(normas, decreasing = TRUE)[1:3], 2)       # os tres "mais longos"
maior <- names(sort(normas, decreasing = TRUE))[1]   # o nome do de maior norma
origem[[maior]]                                      # de que artigo ele veio
```

Por que ele é o maior — muitas palavras, ou muitas raras?

```r
length(ix$tokens[[maior]])                   # quantas palavras ele tem
round(mean(sapply(ix$tokens, length)))       # quantas tem um documento medio do corpus
sum(ix$df[ix$tokens[[maior]]] == 1)          # quantas das palavras dele so aparecem nele
wn <- norm_cols(ix$w)                        # as colunas com comprimento 1
table(round(colSums(wn^2), 2))               # todos 1? (o 1 em cima; quantos documentos, embaixo)
```

**Exemplos que você mostra** — os mesmos comandos no corpus da aula, para o grupo saber o que esperar:

- `round(sort(normas, decreasing = TRUE)[1:3], 2)` →
  ```
    d7   d5   d2 
  5.23 5.14 5.12 
  ```
- para `d7`: 9 palavras, contra uma média de 8; 5 delas só aparecem nele (`avaliacao`, `mede`, `dos`, `resultados`, `da`) — é longo **e** cheio de termos raros, cada um pesando $\log 8 = 2{,}08$;
- `table(round(colSums(wn^2), 2))` →
  ```
  
  1 
  8 
  ```
  — os 8 documentos com comprimento 1: a vantagem do "mais longo" sumiu.

> **Erro previsto:** `length(docs)` ou `dim(ix$w)` não batem com a ficha. Sinal: o número de documentos ou de termos é outro. Reação: pare. Ou a ficha está errada, ou o `docs.rds` do repositório não é o da Aula 01. O grupo decide qual é a verdade; a ficha registra.

> **Erro previsto:** o vocabulário tem `"santos,"` e `"município."`. Sinal: o grupo estranha termos com pontuação em `ix$vocab`. Reação: uma linha — *"é a Aula 03"* — e sigam. Já está na seção 4 da ficha.

> **Checkpoint 9.** *Qual documento de vocês tem a maior norma, de que artigo veio, e por quê — muitas palavras, muitas palavras raras, ou as duas? O que a normalização faz com essa vantagem?*
> Esperado: o grupo lê `maior`, `origem[[maior]]` e os três números do segundo bloco, e conclui com eles (por exemplo: "o dobro da média de palavras, mas poucas raras: é longo"). Depois de `norm_cols`, todos valem 1 — a vantagem some.

> **Ponte:** vetores prontos. Agora, o que o motor de vocês vai responder.

---

## Módulo 10 — As três consultas de trabalho
*trabalho 18 min · conversa 5 min · lembrete: o grupo escolhe; o grupo explica; você confere; "o grupo concorda?"*

Primeiro, as duas funções dos Módulos 6 e 7 da teoria:

```r
vetor_consulta <- function(termos, vocab, idf) {            # Modulo 6 da teoria
  q <- as.integer(table(factor(termos, levels = vocab)))    # contagens; termo fora do vocabulario some
  q * idf                                                   # a regua do corpus
}                                                           # fim da funcao
```

```r
ranking_cosseno <- function(consulta, ix) {                           # Modulo 7 da teoria
  qw <- vetor_consulta(tokenizar(consulta), ix$vocab, ix$idf_tfidf)   # a consulta no espaco do corpus
  s  <- apply(ix$w, 2, function(d) cosseno(qw, d))                    # um cosseno por documento
  sort(s, decreasing = TRUE)                                          # do mais parecido ao menos
}                                                                     # fim da funcao
```

**O grupo escreve três consultas** — e elas são uma **decisão de projeto**: vão para a ficha e serão as mesmas nas Aulas 03, 04, 05 e 5,5, para comparar modelos sobre a mesma pergunta. Regras, que você confere:

- pelo menos uma com duas palavras ou mais;
- pelo menos uma derivada das **três perguntas** da seção 2 da ficha (o que o usuário do motor quer saber);
- todo termo existe no corpus: `tokenizar(consulta) %in% ix$vocab` dá só `TRUE`.

Para cada uma — **antes de rodar, o grupo prevê** qual documento (ou de qual artigo) vai ficar em primeiro, e por quê:

```r
consulta <- "porto"                          # UMA consulta do grupo (troquem pela de voces)
tokenizar(consulta) %in% ix$vocab            # cada termo existe no corpus? FALSE = vai sumir
r <- ranking_cosseno(consulta, ix)           # o ranking inteiro
round(r[1:5], 3)                             # os 5 primeiros
melhor <- names(r)[1]                        # o primeiro lugar
origem[[melhor]]                             # de que artigo ele veio
docs[[melhor]]                               # o texto inteiro, para ler
```

Depois, **o grupo explica o primeiro lugar** — lendo o texto e estes números:

```r
qw <- vetor_consulta(tokenizar(consulta), ix$vocab, ix$idf_tfidf)   # o vetor da consulta, aqui fora
termos <- names(qw[qw > 0])                  # os termos da consulta que pesam alguma coisa
round(qw[termos], 2)                         # o peso de cada um na consulta
round(ix$w[termos, melhor], 2)               # o peso de cada um no primeiro lugar
round(qw[termos] * ix$w[termos, melhor], 2)  # a parcela de cada um no produto escalar
```

**Exemplos que você mostra** — no corpus da aula, consulta `modelo de recuperacao`, primeiro lugar `d1`:

- `round(qw[termos], 2)` → `de 0.47`, `modelo 1.39`, `recuperacao 1.39`;
- `round(ix$w[termos, "d1"], 2)` → `de 0.47`, `modelo 0.00`, `recuperacao 1.39`;
- as parcelas:
  ```
           de      modelo recuperacao 
         0.22        0.00        1.92 
  ```
  — quem puxou `d1` para cima foi `recuperacao`; `modelo` não está em `d1` e não contribuiu nada.

E o caso que não pode virar consulta de trabalho — **todos** os termos fora do vocabulário. No corpus da aula, `round(ranking_cosseno("turismo", ix)[1:5], 3)` →

```
d1 d2 d3 d4 d5 
 0  0  0  0  0 
```

Tudo zero, na ordem das colunas: o `melhor` seria só o primeiro documento do corpus, e **não significa nada**. É o `if` do `cosseno` trabalhando. **Sem ele**, os cossenos seriam todos $0/0$ = `NaN`; `sort` descarta `NaN`, o ranking ficaria vazio, e o `[1:5]` mostraria cinco `NA`:

```
<NA> <NA> <NA> <NA> <NA> 
  NA   NA   NA   NA   NA 
```

— e o `origem[[melhor]]` seguinte daria erro. Por isso o `%in%` vem antes de tudo.

**Ao fim das três:** *"estas são as consultas de trabalho do projeto — o grupo concorda?"* Anote para a ficha: seção 4 ("Consultas de trabalho: q1 "…" · q2 "…" · q3 "…"") e seção 6 (uma linha com o motivo de cada uma). Diga ao grupo, como informação: não há campo no `config.R` para elas.

> **Erro previsto:** termo da consulta fora do vocabulário — `"turismo"` não está em nenhum documento. Sinal: `%in%` dá `FALSE`; se todos derem `FALSE`, o ranking é todo zero. Reação: o termo some, como na teoria. Trocar a consulta — e é bom descobrir isso antes de ela virar consulta de trabalho.

> **Erro previsto:** explicar o primeiro lugar por "é o mais importante" ou "fala mais do assunto". Sinal: a explicação não cita termo nem número. Reação: *"o cosseno não sabe o que é importante. Que parcela puxou esse documento?"*

> **Checkpoint 10.** *Para uma das três consultas de vocês, digam qual termo contribuiu mais para o primeiro lugar — e mostrem os números na tela que provam isso.*
> Esperado: o termo com a maior parcela em `qw[termos] * ix$w[termos, melhor]`; o grupo aponta a parcela e diz de onde ela vem (peso alto na consulta, no documento, ou nos dois).

> **Ponte:** três rankings que fazem sentido. Agora, um que não faz — de propósito.

---

## Módulo 11 — Onde o cosseno erra, no corpus do grupo
*trabalho 8 min · conversa 4 min · lembrete: não resolva os limites; o grupo mostra o erro com números*

**O grupo monta uma consulta que devolve um ranking claramente errado**, e mostra por quê. Três caminhos, o grupo escolhe um:

- uma consulta com **sinônimo** que os textos não usam — *"litoral"* onde os textos dizem *"praia"*;
- uma consulta com a **mesma palavra em outra forma** — *"praias"* onde os textos dizem *"praia"*;
- uma consulta só de **palavras vazias** — *"de"*, *"do"*, *"da"*. Num corpus de dezenas de parágrafos, elas costumam estar em **todos**: $\text{idf} = \log(N/N) = 0$, o vetor da consulta é nulo, e o ranking é todo zero. Se não estão em todos, pontuam os documentos que as repetem — uma ordem que não diz nada sobre o assunto.

```r
consulta <- "praias"                         # a consulta que erra (troquem pela de voces)
tokenizar(consulta) %in% ix$vocab            # o termo existe no corpus?
round(ranking_cosseno(consulta, ix)[1:5], 3) # o ranking: o que veio?
grep("^prai", ix$vocab, value = TRUE)        # formas parecidas no corpus (troquem o comeco)
round(ix$idf_tfidf[c("de", "do", "da")], 2)  # palavras vazias: idf 0 = estao em todos os documentos
```

(`grep(…, value = TRUE)`, da Parte D da Aula 01, devolve os próprios termos em vez das posições. Um nome que não está no vocabulário, na última linha, sai como `NA`, sem erro.)

**Exemplos que você mostra** — os três caminhos no corpus da aula:

- *sinônimo:* `round(ranking_cosseno("ranqueamento", ix), 3)` → $d_3$ com $0{,}413$ e o resto zero — inclusive `d1`, *"ordena documentos por relevancia"*;
- *outra forma:* `ranking_cosseno("vetor", ix)` → tudo zero — `d2` diz *"vetorial"* e *"vetores"*;
- *palavra vazia:* `round(ranking_cosseno("de", ix), 3)` → $d_3\ 0{,}187 > d_1\ 0{,}112 > d_6\ 0{,}107 > d_8\ 0{,}098 > d_2\ 0{,}092$ — `d3` ganha só por ter `de` duas vezes. (No corpus da aula `de` não está nos 8 documentos; no de vocês, provavelmente está.)

Roda, mostra o ranking, e diz **o que o modelo não sabe** naquele caso. Isso vai para a seção 4 da ficha, em "peculiaridades que atrapalham".

> **Erro previsto:** achar que é bug do código. Sinal: alguém revisa a função `cosseno`. Reação: o código está certo; o **modelo** trata termos como dimensões independentes (Módulo 8 da teoria). Se perguntarem quem resolve: formas e palavras vazias, Aula 03; sinônimos, Aula 07 — uma linha, e sigam.

> **Erro previsto:** `ix$tf["praias", melhor]` dá erro. Sinal: `subscript out of bounds`. Reação: o termo não é linha da matriz — não está no vocabulário. É o `%in%` que diz isso sem quebrar.

> **Checkpoint 11.** *Com o caminho que escolheram: mostrem, com um número ou um `FALSE` da tela, por que o documento que vocês esperavam no topo não veio — e escrevam, em uma frase para a ficha, o que o modelo não sabe ali.*
> Esperado: um sinônimo ou outra forma → `FALSE` no `%in%` (e, para a forma, o `grep` mostra a palavra "certa" no vocabulário); palavra vazia → `idf` 0, ou o ranking puxado pelas repetições. A frase diz o que falta ao modelo — *"não sabe que 'praias' e 'praia' são a mesma palavra"* —, sem precisar dizer como se resolve.

> **Ponte:** vocês viram o motor acertar e viram onde erra — no corpus de vocês, não no de brinquedo.

---

**Funções de R apresentadas nesta sessão** (o guia da Parte D da Aula 03 copia esta linha): `gzcon(url(…))` — ler um `.rds` direto do endereço. Escritas de novo, da teoria: `cosseno`, `norm_cols`, `vetor_consulta`, `ranking_cosseno`.

**Casos degenerados desta sessão:** consulta com **todos** os termos fora do vocabulário, ou só com termos de $\text{idf} = 0$ (palavras em todos os documentos) → vetor da consulta nulo → `ranking_cosseno` devolve tudo zero, na ordem das colunas, e `names(r)[1]` é só o primeiro documento — sem o `if` do `cosseno`, seriam `NaN`, que `sort` descarta, e `r[1:5]` mostraria cinco `NA`; termo fora do vocabulário numa consulta mista → some, sem aviso (o `%in%` mostra); `ix$tf[termo, …]` com termo fora do vocabulário → `subscript out of bounds`; documento com todos os termos em todos os documentos → coluna de `ix$w` toda zero, que `norm_cols` mantém zero (sem a proteção, `NaN`); endereço `REPO` errado ou repositório privado → `cannot open URL`.

---

## Glossário

| sigla / termo | por extenso | o que é |
|---|---|---|
| TF-IDF | *term frequency – inverse document frequency* | o peso de um termo num documento (Aula 01); aqui, `ix$w` |
| `NaN` | *not a number* | o que o R devolve para $0/0$; `sort` o descarta |
| `NA` | *not available* | valor ausente; aparece quando se pede uma posição que não existe |
| Raw | — | o endereço do GitHub que entrega o arquivo puro, para o R ler |
| `.rds` | — | arquivo em que o R guarda um objeto (`saveRDS`, Aula 01) |
| consultas de trabalho | — | as três consultas do projeto, as mesmas em todas as aulas |

---

## Fechamento

Ordem: **perguntas guardadas → tarefa → o que vem → ficha → consolidado → passos de fechamento.** (O teste já foi na sessão teórica, individual.)

1. **Perguntas guardadas:** responda as curtas; encaminhe as outras — palavras vazias, formas e pontuação são a Aula 03; sinônimos, a 07.
2. **A tarefa:** a tarefa da Aula 02 é **individual**, sobre o corpus de 8 (está no guia da teoria). O que esta sessão produz não é tarefa — é o projeto: vai para a ficha e para o notebook. Não escreva nada por eles.
3. **O que vem:** *"Vocês viram palavras vazias pontuando e `praias` não achar `praia`. A Aula 03 limpa o texto antes de indexar — tira a pontuação e as stopwords, reduz as palavras ao radical — e monta o índice invertido, que é o que faz a busca ser rápida quando o corpus tem milhares de documentos. Na Parte D, vocês decidem a limpeza e a lista de stopwords do projeto — e rodam de novo estas três consultas, para ver o que mudou."*
4. **A ficha do projeto** — avise que está gerando. Devolva-a **inteira, sem a seção 8**, em bloco de código Markdown, com só o permitido: **seção 4** — "Consultas de trabalho" com as três, e as peculiaridades vistas no Módulo 11; **seção 5** — a linha "TF-IDF + cosseno" em `ok`, com o arquivo `estrutura/codigo/aula02.ipynb`; **seção 6** — uma linha: *"Aula 02: consultas de trabalho q1 "…", q2 "…", q3 "…" — porque … · sem campo no `config.R`"* (e, se o grupo mudou outra coisa, a linha dela com o campo); **seção 7** — a entrada da Aula 02 (presentes, quem digitou em cada módulo, feito, produzido — os três primeiros lugares —, pendente); **cabeçalho** — *última atualização: Aula 02 Parte D, <data>, motor02*. Seções 1–3 intocadas.
5. **O consolidado** — avise que está gerando. Formato de **grupo**, abaixo. (`.md` em bloco de código, nunca PDF, sem código, sem reexplicação, LaTeX, sem a seção "Estado do R".)
6. **Logo abaixo do consolidado, na mesma mensagem, os passos de fechamento** — os oito abaixo, por extenso.

## Modelo do consolidado de grupo

```markdown
# Consolidado — PI III — Aula 02 — Parte D — <data>
*guia versão 3 · tutora: <qual LLM> · sessão de grupo · motor02*
**Grupo:** <nome> · **presentes:** <nomes> · **digitou:** <M9: nome · M10: nome · M11: nome>

## 1. O que foi feito
- M9 — os vetores do corpus do grupo; o documento de maior norma e por quê
- M10 — as três consultas de trabalho, com os rankings e o primeiro lugar explicado
- M11 — uma consulta que erra, mostrada com números

## 2. Como o grupo trabalhou — opinião da tutora
<um parágrafo, em primeira pessoa: o grupo previu as ordens antes de rodar, e acertou
quantas? explicou os primeiros lugares com números ou com opinião? as consultas saíram
do grupo ou de um só? quem digitou entendeu o que rodou — inclusive a linha do `if`?
qual caminho escolheu no Módulo 11, e conseguiu mostrar o erro com números? o que foi
construído e o que foi entregue pronto?>

## 3. Observações para a frente
- **Para a próxima sessão prática:** <o que precisa estar pronto para a Parte D da Aula 03; quem ficou de fazer o quê>
- **Perguntas guardadas:** <pergunta> — <para qual aula>
- **Produzido:** ver a entrada "Aula 02" na linha do tempo da ficha do projeto
- **Ficha atualizada:** <sim — seções alteradas: 4, 5, 6, 7, cabeçalho>
```

## Passos de fechamento (copie logo abaixo do consolidado)

1. Salvem a ficha como **`00_FICHA_PROJETO.md`** e o consolidado como **`aula02_parteD_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. Enviem os dois ao Colab, **sem fechar a sessão** (pasta à esquerda → upload). `list.files()` tem que mostrá-los soltos, com esses nomes exatos.
3. Rodem, numa célula:
   ```r
   anexar_estado("00_FICHA_PROJETO.md")             # o estado do R vai para a ficha
   anexar_estado("aula02_parteD_consolidado.md")    # e para o consolidado do grupo
   ```
4. Baixem (três pontinhos → *Fazer download*): os dois `.md`; o `config.R` **só se mudou** (nesta aula, normalmente não muda); e o notebook (*Arquivo → Fazer download → Baixar o .ipynb*), salvando-o como **`aula02.ipynb`**. Nesta aula não há arquivo de dados novo.
5. No GitHub, abram cada pasta e enviem (*Add file → Upload files*; mesmo nome substitui → *Commit changes*): `consolidados/` ← a ficha e o consolidado; `estrutura/codigo/` ← `aula02.ipynb` (e o `config.R`, se mudou).
6. Confiram no GitHub que a ficha termina com a seção "Estado do R". (O `config.R` não ganha campo novo nesta aula; se o grupo mudou algum, confiram que a mudança está lá.)
7. Confiram que a seção 6 da ficha e o `config.R` dizem a mesma coisa: a linha da Aula 02 diz "sem campo no `config.R`", e os campos antigos (`minimo`, `grupo`) continuam com os valores da ficha.
8. Cada integrante envia o **seu** consolidado individual da teoria (`aula02_consolidado.md`) para `consolidados/<seu nome>/`.

Se o grupo disser que já fez, pergunte só: *"a ficha no GitHub termina com a seção 'Estado do R'?"*
