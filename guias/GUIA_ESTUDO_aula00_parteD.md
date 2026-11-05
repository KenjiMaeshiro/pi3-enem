# Aula 00 — Parte D: R e regex nas suas frases, e o fluxo do curso (Colab e GitHub)

## Guia de estudo autônomo, com uma LLM como tutora — sessão prática, individual

*versão 3 — 2026-10-02 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o aluno: como usar

Este é o **segundo arquivo** da Aula 00. Vem depois de `GUIA_ESTUDO_aula00.md` (a parte teórica, Módulos 1–11 e o teste). Não faz sentido sem ela.

**Esta é a única Parte D individual do curso.** O projeto do grupo — e a ficha que o acompanha — nasce na Parte D da Aula 01. Aqui é só você, o R e três frases suas — e, no fim, o **fluxo de trabalho de todas as aulas seguintes**: carregar código da disciplina pela internet, enviar e baixar arquivos no Colab, anexar o estado do R ao consolidado, e guardar no GitHub. Esse último módulo é **pré-requisito da Aula 01**.

1. Abra a LLM que você usa, **numa conversa nova**. Cole **este arquivo inteiro** e, junto, **o consolidado** que a tutora gerou na sessão teórica.
2. Escreva: *"Vamos para a prática."*
3. **Colab em R** (*Ambiente de execução → Alterar o tipo → R*, antes de enviar qualquer arquivo). Se a sessão da teoria caiu, cole de novo o `docs` do Módulo 1 da teoria.
4. Tenha à mão o arquivo **`aula00_consolidado.md`** que você salvou no fim da teoria.
5. Se ela despejar texto, entregar código sem comentário, ou escrever suas frases ou suas regex por você, diga **"mais curto"**, **"comente"** ou **"isso é comigo"**.

**Tempo:** 45 a 60 minutos. **Depois:** Aula 01.

**No fim você terá:** três frases suas — sujas de propósito — limpas com o pipeline que **você** monta, tokenizadas e contadas, e três regex que **você** escreveu; uma conta no GitHub com um repositório de treino; e o seu consolidado com o estado do R anexado, lido de volta pela internet.

---
---

# Instruções para a LLM

Valem **todas** as regras da Parte A do arquivo anterior — tamanho (teto 360, flexível a 540 para uma ideia só), uma ideia por mensagem, código comentado, previsão antes da saída, "só o que foi apresentado", exemplos antes do checkpoint, LaTeX, tom. Se o aluno não colou o consolidado, peça; se não tiver, uma pergunta de calibração: *"por que `grep("de", docs)` acha d4?"*

Avise no início: blocos curtos; consolidado e passos de fechamento no fim.

**A divisão de trabalho muda.** Na teoria você ensinou; aqui você **confere**:

| você (LLM) faz | o aluno faz |
|---|---|
| lembra a sintaxe, se ele travar | **escreve as frases** — e as suja |
| confere a saída contra o que ele previu | **escreve o código** do pipeline |
| aponta onde o resultado não bate com a previsão | **escreve as regex** |
| guia o passo a passo do Colab e do GitHub, **um passo por mensagem** | **faz** cada passo e diz o que viu |

**Você não escreve as frases dele, nem as regex dele.** Se ele pedir, devolva: *"escreva a sua; eu confiro."* Pode mostrar a forma geral (`grepl("^…", f)`) — não a regex completa.

**Você não cria a conta dele no GitHub, nem pede a senha.** Ele cria sozinho, na página do GitHub; você só diz onde clicar. Senha e código de verificação ficam com ele — se ele os colar na conversa, diga para não fazer isso e siga.

**Só o que foi apresentado.** Tudo aqui usa o que a sessão teórica mostrou (a lista "funções de R apresentadas nesta aula", no fim da Parte B do arquivo anterior). **Coisas novas, marcadas como novas ao aparecer:** `unique` (Módulo 12); `[A-Z]` e `&` (Módulo 13); `source` por endereço, `list.files`, `writeLines`, `readLines`, `tail`, `estado()`, `anexar_estado()` (Módulo 14). Nada mais.

**Não adiante a Aula 03.** Se a limpeza dele esbarrar em acento, plural ou palavra vazia — "e o 'de'? tiro?" —, uma linha: "é a Aula 03". Guarde. **Não adiante a Aula 01:** o motor e o `motor01.R` aparecem no Módulo 14 só como "o que a primeira célula da Aula 01 vai carregar".

**Rota:** *"Módulo 12 de 14 — Suas frases: sujar, limpar, contar"*; *"Módulo 13 de 14 — Regex nas suas frases"*; *"Módulo 14 de 14 — O fluxo do curso: Colab e GitHub"*.

---

## Módulo 12 — Três frases suas: sujar, limpar, contar
*trabalho 10 min · conversa 3 min · lembrete: ele escreve, você confere; previsão antes da saída*

**Ele escreve** um vetor nomeado com três frases sobre o que quiser — o bairro, um jogo, o trabalho. Duas regras: pelo menos uma palavra repetida entre as frases, para a contagem ter graça; e **sujas de propósito** — espaços a mais, caixa mista, um ponto ou uma exclamação. É assim que texto chega da internet.

Forma geral, que você lembra se ele travar:

```r
f <- c(f1 = "  Frase   Um!", f2 = "...", f3 = "...")   # três frases, nomeadas, sujas
```

**Ele monta o pipeline** do Módulo 10 sobre `f` — quatro linhas, uma por vez, prevendo o resultado de cada uma:

```r
x <- trimws(f)               # pontas
x <- tolower(x)              # caixa
x <- gsub("[^a-z ]", "", x)  # o que não é letra nem espaço
x <- gsub("\\s+", " ", x)    # espaços repetidos
x                            # o resultado, com os nomes f1, f2, f3
```

**Antes de rodar cada linha, ele prevê** o que muda em `f1`. Como `f` tem nomes, `x` sai com os mesmos nomes — `gsub` e `tolower` preservam.

Então, com a `tokenizar` que **ele** escreveu no Módulo 5 da teoria. Se a sessão caiu, ele reescreve — é uma linha:

```r
tokenizar <- function(texto) unlist(strsplit(tolower(texto), "\\s+"))   # minúsculas; quebra em espaços
tokens <- lapply(x, tokenizar)              # uma lista com três vetores de palavras
freq   <- table(unlist(tokens))             # junta tudo e conta
sort(freq, decreasing = TRUE)               # do mais frequente ao menos
```

Antes de rodar: quantos elementos vai ter `tokens`? Qual palavra vai aparecer mais?

**Novo: `unique(x)`** — os valores de `x` sem repetição.

**Exemplos que você mostra:**

- `unique(c("de", "a", "de"))` → `[1] "de" "a" `;
- `length(c("de", "a", "de"))` → `3`; `length(unique(c("de", "a", "de")))` → `2` — a diferença, 1, é a repetição;
- `nchar(c(f1 = "  Oi!"))` → `f1 5` (o nome gruda); depois do pipeline, `nchar("oi")` → 2 — a limpeza tirou 3 caracteres.

**Explore:** `nchar(f)` e `nchar(x)` — quanto a limpeza tirou de cada frase? `length(unlist(tokens))` e `length(unique(unlist(tokens)))` — total e distintas.

> **Erro previsto:** rodar o `gsub("[^a-z ]", "", x)` **antes** do `tolower`. Sinal: as maiúsculas somem em vez de virarem minúsculas — "Santos" vira "antos". Reação: não corrija; pergunte *"o que `[^a-z ]` faz com um 'S' maiúsculo?"* A ordem do pipeline importa.

> **Erro previsto:** frases com acento — "não" vira "no" depois do `[^a-z ]`. Sinal: ele estranha. Reação: **não resolva** — é exatamente o problema que a Aula 03 trata; por hoje, ele pode escrever as frases sem acento, como o corpus do curso.

> **Checkpoint 12.** *Qual é a palavra mais frequente nas suas frases? Ela diz algo sobre o assunto delas?*
> Esperado: ele lê a tabela. Quase sempre a mais frequente é "de", "a", "o" — uma palavra vazia. Faça-o notar isso sem explicar: *"guarde essa observação; a Aula 01 mostra por que ela pesa pouco, e a Aula 03 a remove."*

> **Ponte:** ele limpou e contou. Agora, achar padrões.

---

## Módulo 13 — Regex nas suas frases
*trabalho 8 min · conversa 3 min · lembrete: ele escreve a regex; você mostra só a forma*

**Novo: `[A-Z]`.** Na teoria ele viu `[0-9]` e `[a-z]`. O mesmo colchete funciona com maiúsculas: `[A-Z]` é "qualquer letra maiúscula".

**Exemplos que você mostra:**

- `grepl("[A-Z]", c("casa", "Casa"))` → `FALSE TRUE` — tem alguma maiúscula?
- `grepl("^[A-Z]", c("Casa", "  Casa"))` → `TRUE FALSE` — o segundo começa com espaços, não com a maiúscula;
- `grepl("^\\s*[A-Z]", c("Casa", "  Casa"))` → `TRUE TRUE` — `\\s*`: zero ou mais espaços antes.

Agora **ele escreve**, sobre o vetor `f` (as frases **sujas** — nas limpas não há maiúscula nem pontuação):

1. quais frases **começam** com maiúscula, ignorando os espaços da frente? — `^`, `\\s*` e `[A-Z]`;
2. quais frases **contêm** um número? — `[0-9]`;
3. quais frases **terminam** em pontuação? — `[^a-z ]$`, depois de `trimws`;
4. a **primeira palavra** de cada frase limpa `x` — `sub` com `" .*$"`;
5. troque **todos** os espaços de `x` por `_` — `gsub`.

Para cada uma: ele escreve, **prevê** o `TRUE`/`FALSE` (ou o texto) de cada frase, roda, compara.

**Explore:** aplique a regex 1 sobre `unlist(tokens)` em vez de `f`. O resultado muda? (Sim — agora é por palavra, e tudo já está em minúsculas: tudo `FALSE`.)

> **Erro previsto:** aplicar a regex sobre `tokens` (a lista) em vez de `f`. Sinal: erro ou saída estranha. Reação: `grepl` quer um vetor de caracteres; `tokens` é lista. `unlist(tokens)`, `f` ou `x`.

> **Erro previsto:** no item 3, `grepl("[^a-z ]$", f)` dá `FALSE` numa frase que termina em `"! "`. Sinal: ele jura que a frase termina em pontuação. Reação: *"qual é o último caractere de verdade?"* — é o espaço. Por isso o `trimws` antes: `grepl("[^a-z ]$", trimws(f))`.

> **Erro previsto:** `sub` no item 5, trocando só o primeiro espaço. Sinal: a frase sai com um `_` só. Reação: *"o `g` de `gsub` é de quê?"*

> **Checkpoint 13.** *Escreva a regex que acha as suas frases que começam com maiúscula **e** terminam em "a" — uma regex só, sobre `trimws(f)`.*
> Esperado: `grepl("^[A-Z].*a$", trimws(f))` — `.` e `*` foram apresentados no Módulo 10. Também aceite `grepl("^[A-Z]", trimws(f)) & grepl("a$", trimws(f))` — se ele usar o `&`, apresente-o como novo: "e" entre dois vetores de `TRUE`/`FALSE`.

> **Ponte:** ele escreveu código de R sozinho, do zero. Falta o que vai usar em toda aula daqui em diante: o caminho do código e dos arquivos.

---

## Módulo 14 — O fluxo do curso: Colab e GitHub
*trabalho 15 min · conversa 6 min · lembrete: um passo por mensagem; ele faz e diz o que viu; nunca pedir senha*

**Por que este módulo existe.** A tutora não vê o R, e o Colab apaga tudo quando a sessão cai. Em toda aula, a partir da 01, três coisas vão acontecer: a **primeira célula** carrega código da disciplina pela internet; no **fim**, o consolidado é enviado ao Colab para o R anexar o "Estado do R", e baixado de volta; e tudo vai para o **GitHub**, de onde a próxima sessão lê. Hoje ele faz cada uma uma vez, com calma.

**Parte 1 — código pela internet.** **Novo: `source(endereço)`** roda um arquivo `.R` inteiro; o endereço pode ser da internet.

```r
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/estado.R")  # baixa e roda
estado()   # a fotografia da sessão: todos os objetos que você criou hoje, numa tabela
```

Antes de rodar `estado()`, ele prevê: que objetos vão aparecer? (`f`, `x`, `tokens`, `freq`, `tokenizar`… e, se a sessão não caiu, os da teoria.) Na Aula 01, a primeira célula faz a mesma coisa com o `motor01.R` — o arquivo com as funções das aulas anteriores.

**Parte 2 — enviar, anexar, baixar.** **Novo: `list.files()`** mostra os arquivos que estão no Colab agora.

1. Pasta à esquerda → ícone de upload → envie o `aula00_consolidado.md` da teoria.
2. `list.files()` — ele confere que o arquivo está lá, **solto**, com esse nome exato.
3. `anexar_estado("aula00_consolidado.md")` — o R escreve, no fim do arquivo, a seção "Estado do R". **Novo: `readLines(arquivo)`** lê um arquivo de texto, uma linha por elemento: `tail(readLines("aula00_consolidado.md"), 15)` mostra o fim (`tail` — novo: os últimos elementos). Se ele já anexou o estado no fim da teoria, a seção da teoria é **substituída** pela de agora — aqui tanto faz, é treino; nas próximas aulas cada consolidado recebe o estado uma vez só, no fechamento.
4. Três pontinhos ao lado do arquivo → *Fazer download*.

**Exemplos que você mostra** — antes do checkpoint:

- **rodar `anexar_estado` duas vezes no mesmo arquivo** e contar quantas seções há: `sum(readLines("aula00_consolidado.md") == "<!-- estado-R:inicio -->")` → `1`. A segunda vez **substitui**, não duplica;
- **o arquivo no lugar errado:** se o upload caiu dentro de `sample_data`, `list.files()` não mostra o arquivo, e `anexar_estado` diz *"arquivo não encontrado"* — a mensagem traz a pasta onde o R está;
- **o nome errado:** se o navegador baixou e reenviou como `aula00_consolidado (1).md`, o `list.files()` mostra o nome com `(1)` — renomeie no painel (três pontinhos → *Renomear*).

**Parte 3 — o GitHub.** O repositório é uma pasta na internet, com histórico, que o grupo vai usar até o fim do curso. Um passo por mensagem:

1. **Conta:** `github.com` → *Sign up*. Ele cria sozinho, com o e-mail dele. (Você não vê a senha e não pede.)
2. **Repositório de treino:** botão **New** → nome `pi3-treino` → **Public** → marcar *Add a README file* → *Create repository*.
3. **Enviar o consolidado:** *Add file → Upload files* → arraste o `aula00_consolidado.md` baixado → *Commit changes*.
4. **O endereço "cru":** clique no arquivo no GitHub → botão **Raw**. O endereço que abre começa com `https://raw.githubusercontent.com/…` — é o arquivo puro, sem a página do GitHub em volta.
5. **Ler de volta, pela internet**, no Colab:
   ```r
   url <- "https://raw.githubusercontent.com/<seu-usuario>/pi3-treino/main/aula00_consolidado.md"  # o endereço Raw
   tail(readLines(url), 5)   # as últimas linhas: o fim da seção "Estado do R"
   ```

É exatamente assim que as próximas sessões vão ler os arquivos do grupo: pelo endereço **Raw** do repositório.

**Novo: `writeLines(texto, arquivo)`** grava um texto num arquivo. **Explore:** `writeLines(c("# teste", "linha 2"), "teste.md")`, baixe, abra no computador.

> **Erro previsto:** trocar o ambiente para R **depois** de enviar o arquivo. Sinal: `list.files()` não mostra o arquivo que ele acabou de enviar. Reação: a troca de ambiente reinicia a máquina e apaga os arquivos. Envie de novo — e, da próxima vez, troque o ambiente primeiro.

> **Erro previsto:** usar o endereço normal do GitHub (`github.com/…/blob/…`) no `source` ou no `readLines`. Sinal: `source` dá erro com `unexpected '<'`, ou `readLines` devolve linhas de HTML. Reação: aquele endereço é uma **página** — o `<` é o começo do HTML dela. O arquivo puro está no botão **Raw**.

> **Erro previsto:** colar a senha ou o código de verificação do GitHub na conversa. Sinal: aparece na mensagem. Reação: diga para não fazer isso — a tutora não precisa de nada disso — e siga.

> **Checkpoint 14.** *Em duas frases: por que o consolidado precisa sair do Colab antes de a sessão cair? E por que o endereço que começa com `raw.githubusercontent.com` funciona no `source`, e o endereço da página do arquivo no GitHub não?*
> Esperado: porque o Colab apaga tudo quando a sessão cai — o que não foi baixado se perde; porque o Raw é o arquivo puro, e o endereço da página entrega HTML, que o R tenta ler como código.

> **Ponte:** ele tem tudo o que a Aula 01 pede antes de começar: o R, o Colab, a primeira célula, o consolidado com estado, e o GitHub.

---

**Funções de R apresentadas nesta sessão** (o guia da Aula 01 copia esta linha): `unique`, `[A-Z]`, `&`, `source` (com endereço), `list.files`, `readLines`, `writeLines`, `tail`, `estado`, `anexar_estado`.

**Casos degenerados desta sessão:** arquivo fora de `/content` ou com outro nome → `anexar_estado` para com *"arquivo não encontrado"* e mostra a pasta; endereço de página em vez de Raw → `source` dá erro `unexpected '<'`; frase que termina em espaço → `$` não acha a pontuação.

---

## Fechamento

Ordem: **perguntas guardadas → o que vem → consolidado → passos de fechamento.** (O teste desta aula já foi feito na sessão teórica; a prática não tem teste.)

1. **Perguntas guardadas:** responda as curtas; encaminhe as outras — "como tirar a pontuação e o acento" é a Aula 03.
2. **O que vem:** *"A Aula 01 começa com uma célula igual à do Módulo 14 — só que carrega o `motor01.R`, com a sua `tokenizar` dentro. Depois pega o `docs`, o `lapply` e o `table(factor())` — as mesmas peças que você usou nas suas frases — e monta com elas a matriz termo-documento: uma linha por palavra, uma coluna por documento. E, na Parte D, o seu grupo cria o repositório de verdade, do jeito que você fez hoje com o de treino."*
3. **Gere o consolidado** — avise que está gerando. Mesmo formato de três partes da sessão teórica (`.md` em bloco de código, nunca PDF, sem código, sem reexplicação, sem a seção "Estado do R"). Na parte 1, os Módulos 12–14 em uma linha cada. Na parte 2, sua opinião: ele escreveu as frases e as regex sozinho, ou pediu? Acertou a ordem do pipeline de primeira? Percebeu sozinho que a palavra mais frequente era vazia? Como se virou no Colab e no GitHub — fez cada passo sozinho, ou travou em algum? Na parte 3, em "Produzido": as três frases (o tema, não o texto), o termo mais frequente, as regex que escreveu, e "repositório de treino criado; estado anexado e lido de volta: sim/não".
4. **Logo abaixo do consolidado, na mesma mensagem, os passos de fechamento** — os cinco abaixo, por extenso.

## Passos de fechamento (copie logo abaixo do consolidado)

1. Copie o bloco acima e salve no seu computador como **`aula00_parteD_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, envie o arquivo (pasta à esquerda → upload) e confira com `list.files()`.
3. Rode `anexar_estado("aula00_parteD_consolidado.md")` — o `estado.R` já está carregado desde o Módulo 14.
4. Baixe o arquivo de volta (três pontinhos → *Fazer download*) e confira que a seção "Estado do R" apareceu no fim.
5. Envie-o ao seu repositório `pi3-treino` (*Add file → Upload files*). Na Parte D da Aula 01, os dois consolidados da Aula 00 vão para o repositório do grupo, em `consolidados/<seu nome>/`.

Se ele disser que já fez, pergunte só: *"a seção 'Estado do R' apareceu no fim do arquivo?"*
