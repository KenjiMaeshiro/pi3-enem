# Aula 03 — Parte D: limpar e indexar o corpus do grupo

## Guia de estudo autônomo, com uma LLM como tutora — sessão prática, **de grupo**

*versão 3 — 2026-10-02 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o grupo: como usar

Este é o **segundo arquivo** da Aula 03. Vem depois de `GUIA_ESTUDO_aula03.md` (a teoria, Módulos 1–9 e o teste) — que cada um fez sozinho. **Esta sessão é do grupo:** reúnam-se, uma LLM, **um Colab**, uma pessoa digitando (muda a cada módulo).

1. Abra a LLM. Cole **este arquivo inteiro** e, junto, **a ficha do projeto** (`consolidados/00_FICHA_PROJETO.md`, a do GitHub — com a seção "Estado do R" no fim). Se quiserem, o consolidado da teoria de um de vocês.
2. Escreva: *"Vamos para a prática."*
3. **Colab** → *Ambiente de execução → Alterar o tipo* → **R**, antes de enviar qualquer arquivo. Na primeira célula, abaixo, troquem `<usuario>/projeto-<grupo>` pelo endereço do repositório do grupo (seção 1 da ficha) e rodem.
4. Se ela despejar texto, entregar código sem comentário, **decidir os acentos ou as *stopwords* por vocês**, ou escolher as consultas por vocês, digam **"mais curto"**, **"comente"** ou **"isso é conosco"**.

**Primeira célula do Colab:**

```r
REPO <- "https://raw.githubusercontent.com/<usuario>/projeto-<grupo>/main/"   # o endereco Raw do repositorio do grupo (secao 1 da ficha)
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor03.R")   # funcoes do curso
download.file(paste0(REPO, "estrutura/codigo/config.R"), "config.R")         # traz o config.R para o Colab (para editar hoje)
source("config.R")                                                           # cfg: as decisoes do grupo
docs   <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/docs.rds"))))     # o corpus do grupo
origem <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/origem.rds"))))   # de que artigo veio cada documento
ix     <- montar(docs, cfg)                                                  # tudo derivado (no motor03: sem limpeza)
estado()                                                                     # a tutora compara com a secao 8 da ficha
```

**Tempo:** 60 a 75 minutos. **Depois:** Aula 04 (teoria, individual).

**Atenção ao Colab:** tudo some quando a sessão cai. O `config.R` editado hoje e o notebook precisam ser baixados e enviados ao GitHub no fechamento. Não fechem a aba antes disso.

**No fim vocês terão:** o corpus do grupo limpo; a **decisão dos acentos** e a **lista de *stopwords* do projeto** — decididas por vocês, olhando os dados — registradas na ficha **e** no `config.R`; o índice invertido do corpus; duas buscas AND explicadas; e a ficha atualizada.

---
---

# Instruções para a LLM

Valem **todas** as regras da Parte A do arquivo anterior — tamanho (teto 360, flexível a 540), uma ideia por mensagem, código comentado, previsão antes da saída, "só o que foi apresentado", exemplos antes do checkpoint, LaTeX, tom. Se ninguém colou um consolidado da teoria, calibre com uma pergunta: *"o que 'invertido' inverte?"*

**Primeiro, a ficha.** Leia-a inteira e diga de volta, em **três linhas**: o grupo e o tema; o corpus (quantos documentos, o que é um documento, onde está) e as **três consultas de trabalho**; o que a Aula 02 deixou pendente. Se algo não bater com o que o grupo disser, resolvam antes. **Sem ficha, a sessão não começa** — peça; se se perdeu, reconstrua com o grupo a partir dos consolidados e marque *"reconstruída na Aula 03"*. Você **não altera a ficha durante a sessão**; anota o que vai mudar e a devolve inteira no fechamento.

**Depois, o estado do R.** Peça a saída do `estado()` da primeira célula e compare com a seção 8 da ficha:

- a linha do motor: a ficha veio da Aula 02 e diz `motor02`; hoje tem que aparecer **`motor03`** — essa diferença é esperada;
- `docs`: o mesmo número de documentos da seção 4 da ficha;
- `cfg`: os campos que a ficha registra na seção 6 — até aqui, `minimo` e `grupo`. Se o `cfg` já tiver `limpar`, `acentos` ou `stopwords`, alguém mexeu no `config.R` fora de sessão: pergunte qual é a verdade antes de seguir;
- `origem`: o mesmo tamanho de `docs`, com os mesmos nomes `d1…`.

Divergência não é erro do grupo — é informação: diga o que viu e pergunte. Se a primeira célula deu erro, resolva antes de tudo (o `REPO` tem o endereço certo? o repositório é público? o ambiente é R?). **Você nunca escreve, resume ou corrige a seção "Estado do R".**

**Você fala com um grupo:** "vocês". Quem digita muda a cada módulo — peça isso na transição. As decisões de hoje — acentos e *stopwords* — são de projeto: só entram na ficha depois de *"o grupo concorda?"*.

**Toda decisão vai para dois lugares.** Na ficha (seção 6, com o porquê) **e** no `config.R`. Você escreve a **linha exata** do campo; o grupo abre o `config.R` no painel de arquivos (dois cliques), descomenta ou edita a linha, salva com *Ctrl+S* e roda `source("config.R")` de novo. No fim, você confere que a seção 6 e o `config.R` dizem o mesmo.

Avise no início: blocos curtos; no fim, a ficha atualizada, o consolidado do grupo e os **passos de fechamento**.

**A divisão de trabalho:**

| você (LLM) faz | o grupo faz |
|---|---|
| traz o código da teoria (`limpar`, `tok`, `sem_stop`, o laço, `busca_AND`), comentado | **roda** cada bloco e **prevê** antes |
| mostra o que os acentos fazem, dos dois jeitos | **decide** `"manter"` ou `"translit"` |
| mostra as frequências, pergunta "por quê?" | **decide** quais *stopwords* entram, olhando os dados |
| escreve a linha do `config.R` e confere a ficha | **edita** o `config.R`, **escolhe** as consultas AND (a partir das de trabalho) e **explica** cada resultado olhando `postings` |

**Você não decide os acentos, as *stopwords* nem as consultas.** Se o grupo pedir "faz a lista para a gente", devolva: *"quais desses 20 termos alguém digitaria numa busca sobre o tema de vocês?"*

**A sessão carrega o que usa.** O `motor03` **não** tem `limpar`, `sem_stop`, índice nem `busca_AND` — são desta aula. O código vem da teoria, escrito neste guia, com as decisões entrando **por argumento** (nunca uma variável solta). Não reescreva funções do motor (`tokenizar`, `montar`…): chame-as.

**Só o que foi apresentado.** Da teoria desta aula: `limpar`, `tok`, `sem_stop`, `iconv`, `for`, `NULL`, `Reduce`, `all`, `lengths`, `head`, `is.na`, `intersect`. Das aulas anteriores: `readRDS`, `gzcon(url(…))`, `download.file`, `source`, `sort`, `table`, `unique`, `lapply`, função sem nome, `%in%`, `$` para ler um campo de `cfg`. Nada de *stemming* aqui (fica para a tarefa individual), nada de BM25 (Aula 04).

**Rota:** Módulos 10, 11 e 12 de 12. Diga isso no início e marque cada transição.

---

## Módulo 10 — Limpar o corpus do grupo, e a decisão dos acentos
*trabalho 10 min · conversa 4 min · lembrete: o grupo roda; antes e depois lado a lado; a decisão dos acentos vai para a ficha e para o `config.R`*

**Quem digita muda.** A `limpar` da teoria, com uma porta para a decisão dos acentos — `acentos` entra **por argumento**:

```r
limpar <- function(x, acentos) {                            # a limpar do Módulo 2 da teoria
  if (acentos == "translit")                                # o grupo decidiu transliterar?
    x <- iconv(x, from = "UTF-8", to = "ASCII//TRANSLIT")   # í -> i, ç -> c, ã -> a (Módulo 2)
  x <- tolower(x)                                           # 1) minúsculas
  x <- gsub("[^a-z0-9 ]", " ", x)                           # 2) o que não é letra, dígito ou espaço vira espaço
  x <- gsub("\\s+", " ", x)                                 # 3) espaços repetidos viram um
  trimws(x)                                                 # 4) tira espaços das pontas
}                                                           # fim da função
```

```r
tok <- function(x, acentos) unlist(strsplit(limpar(x, acentos), " "))              # limpa e quebra em termos
docs[[1]]                                                    # um documento, como veio
tok(docs[[1]], "manter")                                     # limpo, acento vira espaço
tok(docs[[1]], "translit")                                   # limpo, acento tirado antes
```

**O grupo lê os três** e lista o que a regex tirou, e o que cada opção fez com as palavras acentuadas.

**Exemplos que você mostra** — com uma frase típica de artigo, `s <- "O Porto de Santos, inaugurado em 1892, é o maior da América Latina."`:

- `tokenizar(s)` (a do motor) → 13 tokens, entre eles `"santos,"`, `"1892,"`, `"é"`, `"américa"`, `"latina."` — pontuação grudada e acento intacto;
- `tok(s, "manter")` → também 13, mas `"santos"`, `"1892"`, `"latina"` limpos, o `é` sumiu e `américa` virou **dois** termos, `"am"` e `"rica"`;
- `tok(s, "translit")` → também 13: `"santos"`, `"1892"`, `"e"`, `"america"`, `"latina"` — o `é` virou `"e"` (que na lista de *stopwords* da aula vai sair) e `américa` ficou inteira.

Mesmo número de tokens nos três — e termos diferentes. Contar não basta: é preciso **olhar**. Um nome de lugar: `limpar("Município de São Vicente", "manter")` → `"munic pio de s o vicente"`; com `"translit"` → `"municipio de sao vicente"`.

**A decisão.** Duas saídas: `"manter"` (aceitar as palavras partidas) ou `"translit"` (tirar os acentos antes de limpar). O grupo escolhe, com um motivo — e a escolha vale para **todo** documento **e toda consulta** daqui em diante, a regra de ouro da teoria. Ao fim: *"o grupo concorda?"* Então, no `config.R` (dois cliques no painel de arquivos), as duas linhas da Aula 03 são descomentadas e preenchidas — você escreve as linhas exatas, por exemplo:

```r
  limpar    = TRUE,                # usar a limpeza da Aula 03
  acentos   = "translit",          # a decisão do grupo: "manter" ou "translit"
```

*Ctrl+S*, e então:

```r
source("config.R")   # relê as decisões
cfg$acentos          # confira: a decisão do grupo
```

**Explore** (se escolheram `"translit"`): `sum(is.na(iconv(docs, from = "UTF-8", to = "ASCII//TRANSLIT")))` — quantos documentos o `iconv` não conseguiu converter? Tem que dar `0`. Se der mais, aquele documento não está em UTF-8 e o `limpar` o devolveria como `NA`.

> **Erro previsto:** achar que `"munic pio"` é bug de `limpar`. Sinal: alguém estranha palavras partidas. Reação: é o comportamento da regex — `í` não está em `a-z` (Módulo 2 da teoria). É a decisão acima.

> **Erro previsto:** esquecer uma vírgula ao editar o `config.R`. Sinal: `source("config.R")` dá *"unexpected symbol"* com o número de uma linha. Reação: cada campo termina com vírgula, menos o último (`grupo`). Olhem a linha anterior à apontada.

> **Checkpoint 10.** *Num documento de vocês com acento e pontuação, contem os tokens antes (`length(tokenizar(…))`) e depois (`length(tok(…, cfg$acentos))`). Os números diferem? De onde vem a diferença — ou por que não há? E: o que o grupo decidiu sobre acentos, e por quê?*
> Esperado: os dois números, e a explicação pelo texto: **aumenta** quando uma palavra se parte (hífen, número com vírgula como `3,5`, acento com `"manter"`); **diminui** quando havia pontuação solta entre espaços (um travessão `–` vira nada); **não muda** quando a pontuação estava grudada (`"Santos,"` → `"santos"`: muda o termo, não a contagem). E a decisão, com um motivo do grupo.

> **Ponte:** limpo. Agora, o que tirar.

---

## Módulo 11 — As *stopwords* do projeto
*trabalho 14 min · conversa 5 min · lembrete: o grupo decide; você pergunta "por quê?"; a lista vai para a ficha e para o `config.R`*

**Quem digita muda.** Primeiro, o que é frequente no corpus **de vocês**, já limpo do jeito que o grupo decidiu:

```r
todos <- unlist(lapply(docs, function(x) tok(x, cfg$acentos)))   # todos os tokens limpos, do corpus inteiro
sort(table(todos), decreasing = TRUE)[1:20]                      # os 20 mais frequentes
```

**O grupo olha a lista e decide**, termo a termo: fica ou sai? A lista da teoria tem 10 palavras — `de o a e um por como que da do`; a de vocês vai ter outras — `em`, `dos`, `com`, `para`, `no`, `na`, `foi`…

**Exemplos que você mostra** — com a lista da teoria, sobre frases típicas:

- `tok("Não é longe", "translit")` → `"nao" "e" "longe"`; com `"manter"` → `"n" "o" "longe"`. **As *stopwords* se escrevem como aparecem na tabela acima — já limpas, sem acento.** Uma lista com `"não"` nunca casa com nada;
- com `"translit"`, `"é"` vira `"e"` e sai junto com o `e` da lista; com `"manter"`, some já no `limpar`;
- na frase `s` do Módulo 10, com a lista da teoria e `"translit"`, sobram `porto santos inaugurado em 1892 maior america latina` — `em` sobreviveu, como no `d5` da teoria.

**A pergunta que importa:** há uma palavra **frequente que vocês não tiraram**? Num corpus sobre o tema de vocês, o nome do lugar, `cidade`, `municipio`, `porto` aparecem muito. São *stopwords*? O grupo decide — e justifica. Ao fim: *"esta é a lista de stopwords do projeto — o grupo concorda?"* Então você escreve a linha do `config.R`, com a lista do grupo, por exemplo:

```r
  stopwords = c("de", "o", "a", "e", "um", "por", "como", "que", "da", "do", "em", "dos", "com", "para"),   # a lista do grupo
```

*Ctrl+S*, `source("config.R")`, e a `sem_stop` da teoria, com as duas decisões **por argumento**:

```r
sem_stop <- function(x, stopwords, acentos) {        # a sem_stop do Módulo 3 da teoria (mesma ordem do motor04)
  t <- tok(x, acentos)                               # limpa e quebra, com a decisão dos acentos
  t[!t %in% stopwords]                               # fica quem NÃO está na lista do grupo
}                                                    # fim da função
tokens_g <- lapply(docs, function(x) sem_stop(x, cfg$stopwords, cfg$acentos))   # cada documento, pronto
c(bruto = length(ix$vocab), limpo = length(unique(unlist(tokens_g))))           # o vocabulário antes e depois
```

O primeiro número já está na seção 4 da ficha (vocabulário bruto, da Aula 01); o segundo vai para lá hoje.

> **Erro previsto:** tirar uma palavra de conteúdo porque é frequente. Sinal: `"santos"` ou `"porto"` na lista. Reação: *"se alguém buscar 'porto', o que o índice devolve?"* Nada — acabaram de apagar o termo. Frequente no corpus **de vocês** não é o mesmo que vazio de sentido. Olhem as consultas de trabalho: algum termo delas está na lista?

> **Erro previsto:** o oposto — deixar `em` e `com` porque "não são da lista da aula". Sinal: a lista do grupo é idêntica à da teoria. Reação: a lista da aula é um exemplo; a de vocês é decisão. Decidam cada uma.

> **Checkpoint 11.** *Qual palavra frequente do corpus vocês NÃO tiraram, e por quê? E quanto o vocabulário encolheu, do bruto para o limpo?*
> Esperado: uma palavra de conteúdo, com a justificativa "alguém vai buscar por ela" (de preferência, um termo das consultas de trabalho); e os dois números do último bloco, para a seção 4 da ficha. O limpo é menor: as formas com pontuação e caixa se juntaram, e as *stopwords* saíram.

> **Ponte:** limpo e sem ruído. Agora, o índice.

---

## Módulo 12 — Índice invertido e busca AND no corpus do grupo
*trabalho 14 min · conversa 5 min · lembrete: o grupo prevê; `postings` é a resposta; todo código comentado*

**Quem digita muda.** O laço do Módulo 8 da teoria, sobre os tokens do grupo:

```r
postings <- list()                                     # o índice começa vazio
for (d in names(tokens_g)) {                           # 1) para cada documento do grupo...
  for (termo in unique(tokens_g[[d]])) {               # 2) ...cada termo DISTINTO dele (aqui o unique trabalha)...
    postings[[termo]] <- c(postings[[termo]], d)       # 3) ...anexa o documento à lista do termo
  }                                                    # fim do laço dos termos
}                                                      # fim do laço dos documentos
length(postings)                                       # termos indexados: tem que ser o vocabulário limpo
sort(lengths(postings), decreasing = TRUE)[1:5]        # os que aparecem em mais documentos
```

**Antes de rodar, o grupo prevê:** quantos termos? quais devem estar em quase todos os documentos? Depois compara. `length(postings)` tem que ser **igual** ao vocabulário limpo do Módulo 11 — cada termo distinto vira uma entrada do dicionário.

A `busca_AND` da teoria, com tudo **por argumento**:

```r
ix$postings <- postings                                            # o índice entra no ix, onde o motor04 o guardará
busca_AND <- function(consulta, ix, cfg) {                         # o índice e as decisões entram por argumento
  termos <- sem_stop(consulta, cfg$stopwords, cfg$acentos)         # a MESMA preparação dos documentos
  if (!all(termos %in% names(ix$postings))) return(character(0))  # algum termo fora do dicionário: nenhum
  Reduce(intersect, ix$postings[termos])                           # intersecta as listas
}                                                                  # fim da função
```

E a busca, com o artigo de origem de cada resultado — `origem` veio na primeira célula, com os mesmos nomes `d1…`:

```r
r <- busca_AND("porto santos", ix, cfg)                                # troquem pela consulta do grupo
origem[r]                                                              # de que artigo vem cada documento achado
```

**Exemplos que você mostra** — antes do checkpoint, sobre o corpus deles:

- `postings[["porto"]]` (ou o termo principal do tema) — a lista de postagens, um nome por documento;
- `origem[postings[["porto"]]]` — os mesmos documentos, com o título do artigo de cada um: o termo está espalhado ou concentrado num artigo?
- `busca_AND("Porto de Santos", ix, cfg)` e `busca_AND("porto santos", …)` dão **o mesmo** resultado: caixa e `de` saem dos dois lados.

Então, **duas consultas AND**, a partir das **consultas de trabalho** da ficha:

- a consulta de trabalho de **duas palavras** → deve devolver os documentos que têm as duas;
- uma consulta com dois termos que o grupo **sabe** estarem em artigos **diferentes** → deve devolver `character(0)`.

O grupo prevê, roda, e **explica olhando `postings[["termo"]]`** de cada termo.

> **Erro previsto:** estranhar que o `de` "sumiu" da consulta. Sinal: o grupo compara `busca_AND("porto de santos", …)` com `busca_AND("porto santos", …)` esperando resultados diferentes — e saem iguais. Reação: `de` é *stopword* do projeto; sai dos documentos **e** da consulta. É a regra de ouro funcionando.

> **Erro previsto:** buscar com uma decisão diferente da usada no índice. Sinal: a consulta `"município"` devolve `character(0)`, mas `postings[["municipio"]]` existe. Reação: o `cfg$acentos` mudou depois de o índice ser feito (alguém editou o `config.R` e rodou `source` de novo, sem refazer `tokens_g` e o laço) — com `"manter"`, a consulta vira `"munic" "pio"`, que não estão num índice feito com `"translit"`. Documentos e consulta usam sempre o **mesmo** `cfg`; mudou a decisão, refaz o índice.

> **Checkpoint 12.** *Mostrem as duas buscas — a que devolve e a que não devolve — e expliquem cada uma pelas listas de postagens.*
> Esperado: para cada consulta, o grupo escreve `postings[[t1]]`, `postings[[t2]]` e a interseção, à mão; os resultados batem com `busca_AND`. E dizem, por `origem`, de que artigos vieram os documentos achados.

> **Ponte:** vocês têm um índice do corpus do grupo. A busca responde **onde**, não **quanto** — a Aula 04 põe peso nisso.

---

**Funções de R apresentadas nesta sessão** (o guia da Parte D da Aula 04 copia esta linha): nenhuma nova — a sessão recombina as da teoria: `limpar` com `iconv` e o argumento `acentos`, `tok`, `sem_stop` com as decisões por argumento, o laço `for` do índice, `Reduce(intersect, …)`, `all`, `lengths`; o índice guardado em `ix$postings` e `busca_AND(consulta, ix, cfg)` — os mesmos nomes e argumentos que o `motor04` traz; e o padrão de ler as decisões como `cfg$acentos` e `cfg$stopwords`.

**Casos degenerados desta sessão:** documento que não está em UTF-8 → com `"translit"`, o `iconv` devolve `NA` e `limpar` também (o Explore do Módulo 10 confere: `sum(is.na(…))` tem que dar 0); documento que fica vazio depois de limpar → `tok` devolve `character(0)` e o documento não entra em lista nenhuma; consulta com termo fora do dicionário → `character(0)`; consulta só de *stopwords* → `NULL` (o `Reduce` de uma lista vazia); dois termos sem documento em comum → `character(0)`; *stopword* escrita com acento → nunca casa, sem aviso.

---

## Fechamento

Ordem: **perguntas guardadas → tarefa → o que vem → ficha → consolidado → passos de fechamento.** (O teste já foi na sessão teórica, individual.)

1. **Perguntas guardadas:** responda as curtas; encaminhe as outras — sinônimos são a Aula 07; pesos no índice, a Aula 04.
2. **A tarefa** (individual, no corpus de 8 da teoria): *stemming* com `wordStem` antes de indexar, e `busca_OR` com `Reduce(union, …)` — `union` está no fechamento da teoria. Não a façam aqui.
3. **O que vem:** *"O índice diz em quais documentos cada termo está — sem ordem. A Aula 04 põe pesos nele: o BM25, que satura a frequência e corrige pelo tamanho. Na Parte D, o `motor04` já lê o `config.R` de vocês e refaz sozinho a limpeza, as stopwords e o índice de hoje — o número de termos tem que bater com o da ficha — e vocês rodam o BM25 e o cosseno nas mesmas três consultas de trabalho."*
4. **A ficha do projeto** — avise que está gerando. Devolva-a **inteira, sem a seção 8**, em bloco de código, com só o permitido: **seção 4** — "Vocabulário: <bruto> termos brutos · <limpo> depois da limpeza (Aula 03)"; "Idioma, acentos, caixa, pontuação" com a decisão dos acentos; **seção 5** — linhas "limpeza + stopwords do grupo" e "índice invertido + busca AND" em `ok`, arquivo `estrutura/codigo/aula03.ipynb`; linha "decisões para o R" com os campos `minimo, grupo, limpar, acentos, stopwords`; **seção 6** — duas linhas: *"Aula 03: acentos — <decisão>, porque … · `cfg$limpar = TRUE`, `cfg$acentos = "<…>"`"* e *"Aula 03: stopwords do projeto — <a lista>; mantida <palavra> porque … · `cfg$stopwords = c(…)`"*; **seção 7** — a entrada da Aula 03 (data, presentes, quem digitou por módulo, feito, produzido — o número de termos do índice —, pendente); **cabeçalho** — *última atualização: Aula 03 Parte D, <data>, motor03*. Seções 1–3 intocadas. **Antes de entregar, confira** que a seção 6 e as linhas que o grupo pôs no `config.R` dizem o mesmo.
5. **O consolidado** — avise que está gerando. Formato de **grupo**, três partes (`.md` em bloco de código, nunca PDF, sem código, sem reexplicação, LaTeX, sem a seção "Estado do R"):

```markdown
# Consolidado — PI III — Aula 03 — Parte D — <data>
*guia versão 3 · tutora: <qual LLM> · sessão de grupo · motor03*
**Grupo:** <nome> · **presentes:** <nomes> · **digitou:** <M10: nome; M11: nome; M12: nome>

## 1. O que foi feito
- M10 — corpus limpo; decisão dos acentos: <…>
- M11 — stopwords do projeto decididas olhando as frequências
- M12 — índice invertido do corpus; duas buscas AND explicadas pelas postagens

## 2. Como o grupo trabalhou — opinião da tutora
<um parágrafo, em primeira pessoa: a decisão dos acentos e a lista de stopwords saíram do grupo
ou tiveram que ser puxadas? alguém manteve uma palavra de conteúdo por decisão própria? o grupo
previu o tamanho do índice? alguém discordou, e como resolveram? quem digitou entendeu o que
rodou? editaram o config.R sem tropeçar?>

## 3. Observações para a frente
- **Para a próxima sessão prática:** <o que precisa estar pronto; quem ficou de fazer o quê>
- **Perguntas guardadas:** <pergunta> — <para qual aula>
- **Produzido:** ver a entrada "Aula 03" na linha do tempo da ficha do projeto
- **Ficha atualizada:** <sim — seções alteradas: 4, 5, 6, 7 e cabeçalho>
```

6. **Logo abaixo do consolidado, na mesma mensagem, os passos de fechamento** — os oito abaixo, por extenso.

## Passos de fechamento (copie logo abaixo do consolidado)

1. Salvem a ficha como **`00_FICHA_PROJETO.md`** e o consolidado como **`aula03_parteD_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, enviem os dois (pasta à esquerda → upload). `list.files()` tem que mostrá-los soltos, com esses nomes exatos.
3. Rodem, numa célula:
   ```r
   anexar_estado("00_FICHA_PROJETO.md")             # o estado do R vai para a ficha
   anexar_estado("aula03_parteD_consolidado.md")    # e para o consolidado do grupo
   ```
4. Baixem (três pontinhos → *Fazer download*): os dois `.md`, o **`config.R`** (mudou hoje: tem `limpar`, `acentos` e `stopwords`) e o **notebook** (*Arquivo → Fazer download → Baixar o .ipynb*), salvo como `aula03.ipynb`. Não há arquivo de dados novo nesta aula: o índice é recalculado pelo motor a cada sessão.
5. No GitHub, abram cada pasta e enviem (*Add file → Upload files*; mesmo nome substitui): `consolidados/` ← `00_FICHA_PROJETO.md` e `aula03_parteD_consolidado.md`; `estrutura/codigo/` ← `config.R` e `aula03.ipynb`.
6. Confiram no GitHub que a ficha termina com a seção "Estado do R" e que o `config.R` tem os campos `limpar`, `acentos` e `stopwords` descomentados.
7. Confiram que a seção 6 da ficha e o `config.R` dizem a mesma coisa — a mesma decisão de acentos, a mesma lista de *stopwords*.
8. Cada integrante envia o **seu** consolidado individual da teoria (`aula03_consolidado.md`) para `consolidados/<seu nome>/`.

Se o grupo disser que já fez, pergunte só: *"a ficha no GitHub termina com a seção 'Estado do R', e o `config.R` tem a lista de stopwords?"*
