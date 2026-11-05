# Aula 01 — Parte D: o tema, o primeiro corpus, o repositório e a ficha do projeto

## Guia de estudo autônomo, com uma LLM como tutora — sessão prática, **de grupo**

*versão 4 — 2026-10-01 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o grupo: como usar

Este é o **segundo arquivo** da Aula 01. Vem depois de `GUIA_ESTUDO_aula01.md` (a teoria, Módulos 1–10 e o teste) — que cada um fez sozinho. **Esta sessão é do grupo:** reúnam-se, uma LLM, **um Colab**, uma pessoa digitando (muda a cada módulo).

**É a sessão que funda o projeto.** Aqui vocês escolhem o tema do motor de busca, coletam o primeiro corpus, criam o repositório do grupo e o `config.R`, e a tutora cria a **ficha do projeto** — a memória fixa que vai ser colada em toda sessão prática até o fim do curso.

1. Abra a LLM. Cole **este arquivo inteiro** e, junto, o arquivo **`FICHA_PROJETO_modelo.md`** (a tutora vai preenchê-lo).
2. Escreva: *"Vamos fundar o projeto."*
3. **Colab** → *Ambiente de execução → Alterar o tipo* → **R**, antes de enviar qualquer arquivo. Rode a **primeira célula**, abaixo. A instalação do `httr2` leva um ou dois minutos.
4. Alguém do grupo precisa ter conta no **GitHub** (Aula 00). O repositório é criado no fim, no passo 6 do fechamento.
5. Se ela despejar texto, entregar código sem comentário, **escolher o tema por vocês** ou responder as perguntas da tarefa por vocês, digam **"mais curto"**, **"comente"** ou **"isso é conosco"**.

**Primeira célula do Colab:**

```r
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor01.R")  # tokenizar e estado
install.packages(c("httr2", "jsonlite"))        # para baixar da Wikipédia; o Colab esquece a cada sessão
library(httr2)                                  # carrega o pacote
dir.create("estrutura/banco-de-dados", recursive = TRUE)   # as pastas do repositório, aqui no Colab
dir.create("estrutura/codigo",         recursive = TRUE)   # (recursive: cria a de dentro e a de fora)
dir.create("consolidados")                                  # a pasta dos consolidados e da ficha
list.files(recursive = TRUE, include.dirs = TRUE)           # confira: as três pastas aparecem
```

**Tempo:** 75 a 90 minutos. **Depois:** Aula 1,5 (teoria, individual).

**Atenção ao Colab:** tudo o que fizerem aqui some quando a sessão cair. O fechamento empacota tudo num arquivo só, que vocês baixam e enviam ao GitHub. Não fechem a aba antes disso.

**No fim vocês terão:** o tema do projeto, decidido e justificado; um corpus de 20 a 60 documentos reais sobre ele; o `config.R` com o critério de documento; a matriz termo-documento desse corpus; a **ficha do projeto** preenchida; e o **repositório público do grupo** no GitHub, com tudo isso dentro.

---
---

# Instruções para a LLM

Valem **todas** as regras da Parte A do arquivo anterior — tamanho (teto 360, flexível a 540), uma ideia por mensagem, código comentado, previsão antes da saída, "só o que foi apresentado", exemplos antes do checkpoint, LaTeX, tom. Se ninguém colou um consolidado da teoria, calibre com uma pergunta: *"o que `sapply` faz que `lapply` não faz?"*

**Você fala com um grupo**, não com um aluno: "vocês". Quem digita muda a cada módulo — peça isso na transição. Toda decisão de projeto é **do grupo**: antes de registrar qualquer coisa na ficha, pergunte *"o grupo concorda?"* e espere.

Avise no início: blocos curtos; no fim, a **ficha do projeto**, o consolidado do grupo e os **passos de fechamento**.

**Confira a primeira célula** antes do Módulo 11: peça a saída do `list.files(...)` — as três pastas têm que aparecer — e rode `estado()`: a linha `MOTOR_VERSAO` mostra `motor01`. Se a instalação do `httr2` falhou, resolva antes de seguir (o ambiente é R?).

**Esta sessão cria a ficha.** O grupo colou `FICHA_PROJETO_modelo.md` (versão 2); leia as regras dele. Você preenche o modelo com o que o grupo decidir nos Módulos 11–13 e o devolve inteiro no fechamento — **sem a seção 8, "Estado do R"**: ela é do R, e o grupo a gera com `anexar_estado()`. Se o grupo **não colou o modelo**, peça antes de começar — a sessão não termina sem a ficha.

**A divisão de trabalho:**

| você (LLM) faz | o grupo faz |
|---|---|
| provoca, testa e registra a decisão | **decide** o tema, a fonte, o que é um documento, o nome do repositório |
| ajuda a **obter** os textos (a chamada à API, o `strsplit`) | escolhe as páginas e **roda** a coleta |
| lembra a sintaxe da cadeia da aula | **roda** a cadeia dos Módulos 4–7 sobre o corpus |
| confere saídas, preenche a ficha e escreve a linha do `config.R` | **responde** às perguntas da tarefa e **confere** a ficha |

**Você não escolhe o tema, e não responde à tarefa.** Se o grupo pedir "sugere um tema", devolva três perguntas (Módulo 11), não um tema. Se pedir "os 10 termos mais frequentes são informativos?", é o grupo quem diz.

**Só o que foi apresentado.** A cadeia é a da teoria (`tokenizar` do motor; `unique`, `as.integer`, função sem nome, `if`, `return`, `intersect`, `log`, `round` da teoria); `nchar`, `substr`, `paste0`, `sum`, regex da Aula 00. **Coisas novas aqui, marcadas como novas ao aparecer:** `install.packages`, `library`, `dir.create`, o pacote `httr2`, o `|>`, a função `\(r)`, `$`, `"\n"`, `download.file`, `rep`, `names(x) <-`, `saveRDS`, `is.null`, `min`, `max`, `mean`, `file.rename`, `zip` (`source` e `list.files` vêm da Parte D da Aula 00). Nada mais.

**Não adiante a Aula 03.** Texto real vem com pontuação e acentos; `"Santos,"` vai virar um token. Diga em uma linha que é o problema da Aula 03 e siga. **Não adiante a Aula 02:** "como ordenar" é lá.

**Rota:** Módulos 11, 12 e 13 de 13. Diga isso no início e marque cada transição.

---

## Módulo 11 — O tema, a fonte, e o que é um documento
*trabalho 15 min · conversa 8 min · lembrete: você provoca; o grupo decide; nada vai para a ficha sem "o grupo concorda?"*

O motor de busca do grupo vai ser sobre **um tema identificado com a Baixada Santista**, escolhido por vocês. A decisão tem cinco partes, nesta ordem.

**1. O tema.** Uma frase. Três testes, que você aplica ao que o grupo propuser:

- *É da Baixada Santista?* — o lugar, a história, uma atividade, as pessoas. "Futebol" não é; "o Santos Futebol Clube e a Vila Belmiro" é.
- *Alguém buscaria isso?* — quem é o usuário, e o que ele quer descobrir. Sem usuário, não há necessidade de informação (Módulo 1 da teoria).
- *Há texto aberto suficiente?* — pelo menos três artigos da Wikipédia em português, ou uma fonte equivalente com licença clara.

Exemplos, **só para calibrar** (o tema é deles): o Porto de Santos e a sua história; as praias e o turismo de Guarujá; o café, a imigração e o centro histórico de Santos; o meio ambiente de Cubatão e a Serra do Mar; os nove municípios da região metropolitana.

**2. Quem usaria, e três perguntas.** O grupo escreve três perguntas que uma pessoa faria a esse motor. Teste: *alguém digitaria isso num buscador?*

**3. A fonte.** A Wikipédia em português é o padrão: aberta, licença **CC BY-SA** (pode usar, citando), e a API — *application programming interface*, o endereço de onde um programa pede dados — entrega texto puro. Outra fonte é bem-vinda se tiver licença ou permissão clara — o `PLANO_DADOS_REGIONAL.md` da disciplina lista algumas. O grupo lista **os títulos exatos** das páginas, como aparecem no alto do artigo na Wikipédia (com desambiguação quando houver: "Santos (São Paulo)", não "Santos").

**4. O que é UM documento.** Um artigo inteiro é um documento **ruim** (Módulo 10 da teoria). O padrão é **o parágrafo**: a menor unidade que responde sozinha a uma pergunta. O grupo confirma ou propõe outra coisa — e justifica.

**5. O repositório.** Quem do grupo cria o repositório no GitHub, e com que nome — sugestão: `projeto-<nome-do-grupo>`, público. O endereço fica `https://github.com/<usuário>/projeto-<nome-do-grupo>` e vai para a seção 1 da ficha.

**Exemplos que você mostra:**

- *tema vago:* "a Baixada Santista" — estreite com "sobre o quê, para quem?": "a história do Porto de Santos, para um estudante do ensino médio que faz um trabalho";
- *tema estreito demais:* "a Bolsa Oficial de Café" — um artigo só; 20 parágrafos do mesmo texto não fazem um motor, porque toda pergunta tem a mesma resposta;
- *pergunta que não é busca × pergunta que é:* "qual é a melhor praia?" pede opinião; "praias de Guarujá com bandeira azul" pede documentos.

> **Erro previsto:** escolher o tema por ser "legal", sem usuário. Sinal: o grupo não consegue dizer quem buscaria. Reação: *"quem abre esse motor, e o que digita?"* Sem resposta, o tema não está pronto.

> **Erro previsto:** fonte sem licença — um site de notícias, um PDF de circulação restrita. Sinal: "a gente copia de lá". Reação: no projeto o corpus vai para um repositório público; sem licença, não. Wikipédia, ou uma fonte do `PLANO_DADOS_REGIONAL.md`.

> **Erro previsto:** querer o artigo inteiro como documento "porque tem mais conteúdo". Sinal: o grupo propõe um documento por artigo. Reação: *"a busca vai dizer que a resposta está 'no artigo de Santos' — em qual dos 300 parágrafos?"*

> **Checkpoint 11.** *O grupo diz, em uma mensagem: o tema em uma frase e a sua ligação com a Baixada; quem usaria; as três perguntas; por que este tema e não outro; a fonte, a licença e os títulos das páginas; o que é um documento e por quê; o nome do repositório e quem o cria. Depois: "o grupo concorda?"*
> Esperado: todos os itens, cada um com uma frase do grupo, e um "sim" de todos. Só então você anota — vai para as seções 1, 2 e 3 da ficha. O que o grupo não souber dizer fica `—`, não vira palpite seu.

> **Ponte:** decidido. Agora, os textos de verdade.

---

## Módulo 12 — Coletar e salvar o primeiro corpus
*trabalho 25 min · conversa 7 min · lembrete: código comentado; uma coisa nova por vez; tudo vai para as pastas do repositório*

**Novo: o pacote `httr2`**, carregado na primeira célula, conversa com APIs na web. **Novo: o `|>`** (*pipe*) passa o resultado da esquerda como primeiro argumento da direita: `x |> f()` é `f(x)`. **Novo: `\(r) …`** é uma função sem nome escrita em forma curta — `\(r) r + 1` é `function(r) r + 1`. **Novo: `x$nome`** pega o elemento `nome` de uma lista — o mesmo que `x[["nome"]]`.

```r
baixar_wiki <- function(titulo) {                         # recebe o título exato de um artigo
  request("https://pt.wikipedia.org/w/api.php") |>        # o endereço da API da Wikipédia
    req_url_query(action = "query", prop = "extracts",    # queremos o texto do artigo...
                  explaintext = 1, format = "json",       # ...em texto puro, resposta em JSON
                  redirects = 1, titles = titulo) |>      # segue redirecionamentos; qual artigo
    req_perform() |> resp_body_json() |>                  # faz a chamada; lê a resposta (JSON)
    (\(r) r$query$pages[[1]]$extract)()                   # entra na resposta e pega só o texto
}                                                         # fim da função
```

JSON — *JavaScript Object Notation* — é o formato em que a API responde: uma lista dentro de lista. A última linha entra nela pelos nomes. (A alternativa é o `coletar_corpus.R` da disciplina, fonte **B** — ele já devolve um CSV; vocês vão usá-lo na Aula 05.)

**Exemplos que você mostra** — um artigo, para conferir antes de baixar todos:

```r
texto <- baixar_wiki("Porto de Santos")   # UM título do grupo (troquem pelo de vocês)
substr(texto, 1, 80)                      # os primeiros 80 caracteres: veio o artigo certo?
nchar(texto)                              # quantos caracteres tem o artigo inteiro
```

E um título errado, de propósito: `baixar_wiki("Porto de Santoss")` → `NULL`, sem mensagem de erro. É por isso que se testa um por um: o `NULL` só vira erro na linha seguinte, longe da causa.

**O critério de documento vai para o `config.R`.** **Novo: `download.file(endereço, arquivo)`** baixa um arquivo da web. `source(arquivo)` (Parte D da Aula 00) roda um arquivo `.R` inteiro — é o que a primeira célula faz com o motor; aqui, com um arquivo da pasta.

```r
download.file("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/config_modelo.R",
              "estrutura/codigo/config.R")      # o modelo da disciplina, na pasta do grupo
```

Agora, no painel de arquivos à esquerda, **dois cliques** em `estrutura/codigo/config.R` abrem um editor. Troquem `minimo = 200` pelo número que o grupo decidiu (ou deixem 200) e `"<nome do grupo>"` pelo nome; *Ctrl+S* salva. Então:

```r
source("estrutura/codigo/config.R")   # cria cfg com as decisões do grupo
cfg$minimo                            # confira: o critério de documento
```

**Todos os artigos, em parágrafos.** **Novo: `"\n"`** é a quebra de linha dentro de um texto; `"\n+"` é a regex "uma ou mais quebras de linha". **Novo: `names(x) <- nomes`** dá (ou troca) os nomes de um vetor ou de uma lista.

```r
titulos <- c("Porto de Santos", "Santos (São Paulo)", "Cubatão")        # OS TÍTULOS DO GRUPO
textos  <- lapply(titulos, baixar_wiki)                                  # um texto por artigo -> lista
names(textos) <- titulos                                                 # nomeia a lista pelos títulos
pars <- lapply(textos, function(t) unlist(strsplit(t, "\n+")))           # cada artigo -> vetor de parágrafos
pars <- lapply(pars, function(p) p[nchar(p) > cfg$minimo])               # o critério de documento do grupo
sapply(pars, length)                                                     # quantos parágrafos sobraram por artigo
```

**O corpus, num vetor nomeado — o mesmo formato do `docs` da aula.** **Novo: `rep(x, vezes)`** repete cada elemento de `x` tantas vezes. O `names(x) <-` de antes nomeia agora os documentos — e a `origem`, com os mesmos nomes.

```r
docs   <- unlist(pars)                                  # todos os parágrafos num vetor só
origem <- rep(names(pars), sapply(pars, length))        # de que artigo veio cada parágrafo
names(docs)   <- paste0("d", 1:length(docs))            # d1, d2, ... como na aula
names(origem) <- names(docs)                            # origem com os MESMOS nomes: origem[["d7"]] funciona
length(docs)                                            # quantos documentos
table(origem)                                           # quantos de cada artigo
```

**Salvar.** **Novo: `saveRDS(objeto, arquivo)`** guarda um objeto do R num arquivo; `readRDS(arquivo)` o traz de volta, em qualquer sessão futura.

```r
saveRDS(docs,   "estrutura/banco-de-dados/docs.rds")    # o corpus
saveRDS(origem, "estrutura/banco-de-dados/origem.rds")  # de que artigo veio cada documento
```

**Meta:** 20 a 60 documentos. Menos de 20, acrescentem páginas; mais de 60, está bom — o corpus cresce na Aula 05.

> **Erro previsto:** título errado no meio da lista. Sinal: o `lapply(textos, function(t) …strsplit…)` dá erro *"non-character argument"* — e o erro aponta para o `strsplit`, não para o título. Reação: um dos textos veio `NULL`. `sapply(textos, is.null)` mostra qual (`is.null` — novo: "é vazio?"); corrijam o título com `substr(baixar_wiki("…"), 1, 80)` antes de rodar a lista de novo.

> **Erro previsto:** parágrafos que são listas, tabelas ou referências — "Ver também", "Referências". Sinal: `substr(docs, 1, 60)` mostra itens que não são prosa. Reação: o grupo decide: subir o `minimo` no `config.R` (e rodar de novo), ou aceitar e registrar. Decisão registrada na ficha.

> **Erro previsto:** um artigo domina — 40 parágrafos de um, 5 do outro. Sinal: `table(origem)` desequilibrada. Reação: não é erro, é a cara do corpus; vai para a ficha. Se o grupo quiser equilibrar, acrescenta páginas, não corta.

> **Checkpoint 12.** *`length(docs)`, `table(origem)`, e `substr(docs[["d1"]], 1, 80)` — o primeiro documento responde sozinho a alguma pergunta? E `origem[["d1"]]` diz de que artigo ele veio?*
> Esperado: entre 20 e 60; a distribuição por artigo; o grupo lê o parágrafo e diz sim ou não (se não, o critério está errado — volte ao `config.R`); `origem[["d1"]]` mostra o título do primeiro artigo.

> **Ponte:** corpus real, salvo nas pastas do repositório. Agora a cadeia inteira da aula, sobre ele.

---

## Módulo 13 — A cadeia da aula sobre o corpus, e a ficha nasce
*trabalho 20 min · conversa 8 min · lembrete: o grupo roda; previsão antes de cada saída; a ficha é conferida campo a campo*

**Quem digita muda.** A cadeia dos Módulos 4–7 da teoria, sobre o `docs` do grupo — a sessão é nova, então o código da teoria vem de novo (a `tokenizar` vem do motor):

```r
tokens <- lapply(docs, tokenizar)                         # Módulo 4: termos de cada documento
vocab  <- sort(unique(unlist(tokens)))                    # Módulo 5: o vocabulário
freq   <- table(unlist(tokens))                           # Módulo 5: frequência no corpus todo
tdm <- sapply(tokens, function(tk)                        # Módulo 6: para cada documento...
  as.integer(table(factor(tk, levels = vocab))))          #   ...conta cada termo do vocab
rownames(tdm) <- vocab                                    # linhas com o nome do termo
```

```r
busca_booleana <- function(termo, tdm) {                  # Módulo 7: a busca booleana
  termo <- tolower(termo)                                 # mesma normalização
  if (!termo %in% rownames(tdm)) return(character(0))     # termo inexistente: vazio
  colnames(tdm)[tdm[termo, ] > 0]                         # documentos com o termo
}                                                         # fim da função
```

Para cada saída, **o grupo prevê antes**: quantos termos distintos vão sair? qual vai ser o mais frequente?

As perguntas da tarefa, que **o grupo** responde:

1. quantos termos distintos surgiram (`length(vocab)`)? — comparar com os **45** do corpus da aula;
2. `sort(freq, decreasing = TRUE)[1:10]` — os 10 mais frequentes são *informativos*? O que isso sugere sobre a próxima aula?
3. `dim(tdm)` — quantas linhas, quantas colunas?

E a busca: **o grupo escolhe** três termos — um que aposta estar em um documento só, um que está em muitos, um que não está em nenhum. Prevê, roda `busca_booleana`, compara; `origem[busca_booleana("…", tdm)]` diz de que artigos vieram.

**Os números da ficha.** **Novo: `min`, `max`, `mean`** — menor, maior, média.

```r
tam <- sapply(tokens, length)               # tokens por documento
c(min(tam), max(tam), round(mean(tam)))     # menor, maior, média — vão para a seção 4
length(vocab)                               # o vocabulário bruto — vai para a seção 4
```

**Exemplos que você mostra** — antes do checkpoint, sobre o corpus deles:

- um termo de conteúdo que aparece com pontuação grudada: procure com `grep(",$", vocab, value = TRUE)[1:5]` — termos terminados em vírgula, como `"santos,"`;
- o mesmo termo sem a vírgula, se existir: `"santos" %in% vocab`;
- `busca_booleana("santos", tdm)` e `busca_booleana("santos,", tdm)` — dois resultados diferentes para a mesma palavra.

**A ficha.** Com tudo decidido e medido, você preenche o `FICHA_PROJETO_modelo.md`: seção 1 com o que o grupo disser (repositório e ambiente); 2 e 3 com o Checkpoint 11; 4 com os números acima e o que o grupo observou (acentos, pontuação, números, listas); 5 com as linhas da Aula 01 em "ok" — corpus, `config.R` (campos: `minimo`, `grupo`), tokenização + TDM — e as demais em "—"; 6 com a decisão do tema, da fonte e do critério de documento, **com o campo do `config.R`** (`cfg$minimo = …`); 7 com a entrada da Aula 01. **Leia a ficha de volta, seção por seção**, e pergunte a cada uma: *"está certo? o grupo concorda?"* Campo que o grupo não decidiu fica como `—`, não como palpite seu.

> **Erro previsto:** tokens com pontuação — `"Santos,"`, `"município."` — e acentos. Sinal: o grupo estranha `"santos,"` e `"santos"` como termos distintos. Reação: uma linha — *"texto real é sujo; limpar é a Aula 03"* — e siga. Não limpe agora. Anote na seção 4 da ficha: "pontuação grudada, acentos".

> **Erro previsto:** o grupo aceita a ficha sem ler. Sinal: "tá bom" em cinco segundos. Reação: leia em voz alta uma linha errada de propósito — o número de documentos, por exemplo — e veja se alguém corrige. A ficha vai ser a verdade por 15 semanas; hoje é o dia de conferir.

> **Checkpoint 13.** *Dos 10 termos mais frequentes do corpus de vocês, quantos dizem algo sobre o tema? E escolham uma das três perguntas da ficha: a `busca_booleana` com a palavra principal dela acha os documentos que vocês esperavam? Se não, por quê?*
> Esperado: o grupo conta — quase sempre 2 ou 3; o resto é `de`, `a`, `o`, `e`, `do`. E a busca: costuma achar documentos demais (sem ordem) ou de menos (a palavra está com vírgula, maiúscula ou acento diferente) — os dois problemas que as Aulas 02 e 03 resolvem.

> **Ponte:** vocês têm um corpus real, indexado, com busca, e um projeto com nome. Sujo — mas real, e de vocês.

---

**Funções de R apresentadas nesta sessão** (o guia da Parte D da Aula 02 copia esta linha): `install.packages`, `library`, `dir.create`, `list.files`, `request`/`req_url_query`/`req_perform`/`resp_body_json` (do `httr2`), `|>`, `\(x)`, `$`, `download.file`, `source`, `rep`, `names(x) <-`, `saveRDS`, `readRDS`, `is.null`, `min`, `max`, `mean`, `file.rename`, `zip`.

**Casos degenerados desta sessão:** título errado → `baixar_wiki` devolve `NULL` sem erro, e o erro só aparece no `strsplit` seguinte; artigo sem nenhum parágrafo acima do `minimo` → aquele título some de `docs` e de `origem` sem aviso (`sapply(pars, length)` mostra 0); termo fora do vocabulário → `busca_booleana` devolve `character(0)`.

---

## Fechamento

Ordem: **perguntas guardadas → tarefa → o que vem → ficha → consolidado → passos de fechamento.** (O teste já foi na sessão teórica, individual.)

1. **Perguntas guardadas:** responda as curtas; encaminhe as outras — limpeza e *stemming* são a Aula 03; "como ordenar" é a Aula 02.
2. **A tarefa:** a parte 2 está feita — falta escrever as respostas. Faltam a parte 1 (explicar e explorar cada bloco, por escrito) e a parte 3 (pesquisa sobre RAG e pacotes de R). Não as faça.
3. **O que vem:** *"Vocês têm um corpus real. Os 10 termos mais frequentes dele são quase todos vazios — `de`, `a`, `do`. A Aula 1,5 explica, pela teoria da informação, por que uma palavra que aparece em todo lugar não informa nada; e na Parte D da Aula 02 vocês escolhem três consultas e o motor ordena este corpus pela primeira vez."*
4. **A ficha do projeto** — avise que está gerando. Devolva-a **inteira, sem a seção 8**, em bloco de código Markdown. Cabeçalho: *criada na Aula 01 (Parte D) em <data> · última atualização: Aula 01 Parte D, <data>, motor01*.
5. **O consolidado** — avise que está gerando. Formato de **grupo**, três partes (`.md` em bloco de código, nunca PDF, sem código, sem reexplicação, sem a seção "Estado do R"). Parte 1: Módulos 11–13 em uma linha cada. Parte 2: o tema saiu do grupo ou teve que ser puxado? Todos participaram da decisão, ou um decidiu? Quem digitou entendeu o que rodou? O grupo previu os termos distintos? Reconheceu os termos vazios sem você dizer? Conferiu a ficha de verdade? Como se virou no Colab? Parte 3: o que precisa estar pronto para a Parte D da Aula 02 (o repositório com `docs.rds`, `origem.rds` e `config.R`; três consultas pensadas); "Produzido": ver a entrada "Aula 01" da ficha.
6. **Logo abaixo do consolidado, na mesma mensagem, os passos de fechamento** — os oito abaixo, por extenso.

## Passos de fechamento (copie logo abaixo do consolidado)

1. Salvem a ficha como **`00_FICHA_PROJETO.md`** e o consolidado como **`aula01_parteD_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, enviem os dois (pasta à esquerda → upload). `list.files()` tem que mostrá-los soltos, com esses nomes exatos.
3. Rodem, numa célula:
   ```r
   anexar_estado("00_FICHA_PROJETO.md")             # o estado do R vai para a ficha
   anexar_estado("aula01_parteD_consolidado.md")    # e para o consolidado do grupo
   file.rename(c("00_FICHA_PROJETO.md", "aula01_parteD_consolidado.md"),          # file.rename -- novo:
               c("consolidados/00_FICHA_PROJETO.md",                              #   move os arquivos
                 "consolidados/aula01_parteD_consolidado.md"))                    #   para a pasta certa
   zip("projeto.zip", c("estrutura", "consolidados"))  # zip -- novo: tudo num arquivo só
   ```
4. Baixem o **`projeto.zip`** (três pontinhos → *Fazer download*) e o **notebook** (*Arquivo → Fazer download → Baixar o .ipynb*), salvando-o como `aula01.ipynb`.
5. No computador: descompactem o `projeto.zip` e ponham o `aula01.ipynb` dentro de `estrutura/codigo/`.
6. Quem ficou responsável **cria o repositório** no GitHub: botão **New** → nome `projeto-<nome-do-grupo>` → **Public** → marcar *Add a README file* → *Create repository*. Depois *Add file → Upload files* e arrastem as pastas **`estrutura`** e **`consolidados`** → *Commit changes*.
7. Confiram no GitHub: `estrutura/banco-de-dados/docs.rds`, `origem.rds`, `estrutura/codigo/config.R`, `aula01.ipynb`, `consolidados/00_FICHA_PROJETO.md` (com a seção "Estado do R" no fim) e o consolidado. Mandem o endereço do repositório a todos os integrantes.
8. Cada integrante envia o **seu** consolidado individual da teoria (`aula01_consolidado.md`): no computador, crie uma pasta com o seu nome e ponha o arquivo dentro; no GitHub, abra a pasta `consolidados` → *Add file → Upload files* → arraste a **pasta** → *Commit changes*. Fica `consolidados/<seu nome>/aula01_consolidado.md`.

Se o grupo disser que já fez, pergunte só: *"a ficha no GitHub termina com a seção 'Estado do R'?"*
