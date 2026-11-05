# Aula 06 — Parte D: Rocchio e pseudo-realimentação no motor do grupo

## Guia de estudo autônomo, com uma LLM como tutora — sessão prática, **de grupo**

*versão 1 — 2026-10-08 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o grupo: como usar

Este é o **segundo arquivo** da Aula 06. Vem depois de `GUIA_ESTUDO_aula06.md` (a teoria, Módulos 1–6 e o teste), que cada um fez sozinho. **Esta sessão é do grupo:** reúnam-se, uma LLM, **um Colab**, uma pessoa digitando (muda a cada módulo).

1. Abra a LLM. Cole **este arquivo inteiro** e, junto, **a ficha do projeto** (`consolidados/00_FICHA_PROJETO.md`). Se quiserem, o consolidado da teoria de um de vocês.
2. Escreva: *"Vamos para a prática."*
3. **Colab** → *Ambiente de execução → Alterar o tipo* → **R**, antes de enviar qualquer arquivo. Na **primeira célula**, troquem `<usuario>` e `<grupo>` pelo endereço do repositório (seção 1 da ficha); na **segunda**, os nomes dos arquivos `qrels_<juiz>_<data>.csv` (seção 4 da ficha). Rodem as duas.
4. Se ela despejar texto, entregar código sem comentário, escrever fórmula em texto puro, **escolher o $k$ por vocês**, **decidir se o motor usa a pseudo-realimentação** ou **julgar um documento**, digam **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é conosco"**.

**Primeira célula do Colab** (a mesma da Aula 5,5, com o `motor06`):

```r
REPO <- "https://raw.githubusercontent.com/<usuario>/projeto-<grupo>/main/"   # o endereco Raw do repositorio do grupo (secao 1 da ficha)
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor06.R")   # funcoes do curso, ate a Aula 5,5
download.file(paste0(REPO, "estrutura/codigo/config.R"), "config.R")         # traz o config.R (vai ser editado no Modulo 9)
source("config.R")                                                           # cfg: as decisoes do grupo
cp     <- read.csv(paste0(REPO, "estrutura/banco-de-dados/corpus.csv"),      # o corpus CONGELADO na Aula 05
                   stringsAsFactors = FALSE, fileEncoding = "UTF-8")         #   texto fica texto; acentos em UTF-8
docs   <- setNames(cp$texto, cp$id)                                          # vetor nomeado id -> texto
origem <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/origem.rds"))))   # de que artigo veio cada documento
ix     <- montar(docs, cfg)                                                  # tudo derivado: indice, TF-IDF, BM25
estado()                                                                     # a tutora compara com a secao 8 da ficha
```

**Segunda célula — o gabarito e as consultas** (como na Parte D da Aula 5,5):

```r
arqs <- c("qrels_ana_2026-10-08.csv", "qrels_bruno_2026-10-09.csv")       # OS NOMES DE VOCES (estes sao exemplo)
for (a in arqs) download.file(paste0(REPO, "estrutura/banco-de-dados/", a), a)   # traz cada qrels para o Colab
qrels <- ler_qrels(arqs, juiz = cfg$juizes)                                 # le, tira BOM e _p2; prioridade da Aula 5,5
nec   <- read.csv(paste0(REPO, "estrutura/banco-de-dados/necessidades.csv"),     # as necessidades da Aula 05,
                  stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")     #   com a coluna conjunto (dev / teste)
consultas <- setNames(nec$texto_consulta, nec$consulta)                     # q01 -> o texto digitado
R_q  <- sapply(qrels, function(g) sum(g >= cfg$limiar))                     # relevantes por consulta, com o limiar do grupo
usar <- names(qrels)[R_q > 0]                                               # as que entram na avaliacao
names(qrels)[R_q == 0]                                                      # AVISO: estas ficam fora (R = 0), como na Aula 5,5
```

**Tempo:** 60 a 90 minutos. **Depois:** Aula 07. **Atenção:** tudo some quando a sessão do Colab cair; o fechamento diz o que baixar e enviar. Não fechem a aba antes.

**No fim vocês terão:** o Rocchio aplicado ao gabarito do grupo, medido no ranking completo e na coleção residual; a pseudo-realimentação testada em todas as consultas julgadas, com $k$ escolhido no **desenvolvimento** e relatado **uma vez** no **teste**; a decisão de usá-la ou não no motor, no `config.R` e na ficha.

---
---

# Instruções para a LLM

Valem **todas** as regras da Parte A do arquivo anterior — teto 360 (540 para uma ideia só), uma ideia por mensagem, código comentado, trechos de no máximo 8 linhas (as duas células iniciais são a exceção: coladas uma vez), previsão antes da saída, "só o que foi apresentado", exemplos antes do checkpoint, LaTeX, tom, o guia vence. Sem consolidado da teoria, calibre com: *"por que medir o Rocchio nos documentos que o usuário marcou é otimista?"*

**Primeiro, a ficha.** Leia-a inteira e diga de volta, em **três linhas**: (1) o grupo e o tema; (2) o corpus congelado (quantos documentos, `corpus.csv`), as consultas de trabalho, as necessidades e quais são de **teste**; (3) o que a Aula 5,5 deixou: limiar, prioridade de juízes, consultas fora da avaliação, o resultado cosseno × BM25, pendências. **Sem ficha, a sessão não começa** — peça; se se perdeu, reconstruam pelos consolidados e marquem *"reconstruída na Aula 06"*. Você não altera a ficha durante a sessão; devolve inteira no fechamento.

**Depois, o estado do R.** Peça a saída do `estado()` e compare com a seção 8 da ficha: `MOTOR_VERSAO` mostra `motor06` (a ficha diz `motor05b`: esperado); `length(docs)` bate com a seção 4; `cfg` tem `limiar` e, se houver mais de um juiz, `juizes` — e **ainda não** tem `prf_k` nem `rocchio`. Confira também a segunda célula: `names(qrels)` são as consultas julgadas da ficha, e as que ficaram fora por $R = 0$ são as que a ficha registra. Divergência não é erro de ninguém: diga o que viu e pergunte qual é a verdade. **Você nunca escreve a seção 8.**

**Você fala com um grupo:** "vocês". Quem digita muda a cada módulo. Avise no início: blocos curtos; no fim, a **ficha**, o consolidado do grupo e os **passos de fechamento**.

| você (LLM) faz | o grupo faz |
|---|---|
| lembra as fórmulas e as funções da teoria | **reescreve** `rocchio` e `ranking_vetor` (ou copia da teoria) e **roda** tudo |
| confere saídas, aponta casos degenerados | **prevê** cada saída e **lê** os documentos que subiram ou caíram |
| escreve as linhas do `config.R` | **escolhe** $k$ olhando **só** o desenvolvimento; **decide** se o motor usa PRF |
| preenche a ficha | **diz** a decisão em uma frase, com o porquê |

**Você não escolhe $k$, não decide usar ou não a PRF, não julga relevância.** "Não usar" é uma decisão válida, com o porquê. Se perguntarem "qual $k$ é melhor?", devolva: *"olhem a tabela de desenvolvimento: qual tem o maior MAP, e em quantas consultas ele piora?"*

**Só o que foi apresentado.** Da teoria desta aula: `rocchio`, `ranking_vetor`, `rowMeans`, `drop = FALSE`, `!=`, `<`, `pmax`, coleção residual, PRF, *drift*. Das anteriores: `c`, `length`, `names`, `colnames`, `[ ]`, `[[ ]]`, `==`, `%in%`, `!`, `1:n`, `paste0`, `sapply`, `function`, `sum` (00); `list.files`, `estado`, `anexar_estado` (Parte D 00); `intersect`, `if`, `>`, `round` (01); `apply`, `$` (02); `for`, `head` (03); valor padrão de argumento (04); `if (…) x else y` (05); `>=`, `rbind` (5,5); `download.file`, `source`, `readRDS`, `is.null` (Parte D 01); `gzcon(url(…))` (Parte D 02); `read.csv`, `setNames` (Parte D 05); `rowMeans` (Parte D 5,5); do motor, `tokenizar`, `docs_aula`, `cfg_aula`, `montar`, `vetor_consulta`, `preparar`, `cosseno`, `ranking_cosseno`, `ler_qrels`, `metricas`. Nada mais.

**Não adiante:** *embeddings* (Aula 07), reformulação com LLM (aula futura), significância (Aula 16). Guarde. **Nunca peça senha, *token* ou código do GitHub** — o envio é feito por eles, pela página.

**Rota:** Módulos 7, 8 e 9 de 9. Marque: *"Módulo 8 de 9 — Pseudo-realimentação em todas as consultas."*

---

## Módulo 7 — Rocchio com o gabarito do grupo
*trabalho 17 min · conversa 8 min · lembrete: toda linha comentada; previsão antes; a completa é otimista — medir a residual*

**Quem digita: a primeira pessoa.** Primeiro, as duas funções da teoria — o grupo reescreve de memória, ou copia do arquivo da teoria:

```r
rocchio <- function(q, Dr, Dnr = character(0), ix, a = 1, b = 0.75, g = 0.15) {  # q: vetor; Dr, Dnr: nomes
  cr  <- rowMeans(ix$w[, Dr, drop = FALSE])                                # centroide dos relevantes
  cnr <- if (length(Dnr)) rowMeans(ix$w[, Dnr, drop = FALSE]) else 0       # dos nao relevantes; sem nenhum, 0
  a * q + b * cr - g * cnr                                                 # a formula, termo a termo
}                                                                          # fim da funcao
ranking_vetor <- function(q, ix)                  # q: vetor de pesos no espaco de ix$vocab
  sort(apply(ix$w, 2, function(d) cosseno(q, d)), # um cosseno por coluna
       decreasing = TRUE)                         # do maior ao menor
```

**Teste antes do corpus de vocês** — no corpus do curso, tem que sair o ranking da teoria:

```r
ix_aula <- montar(docs_aula(), cfg_aula())                                  # o indice do curso: so para o teste
q_aula  <- vetor_consulta(tokenizar("modelo de recuperacao"), ix_aula$vocab, ix_aula$idf_tfidf)  # a consulta do curso
names(ranking_vetor(rocchio(q_aula, c("d2", "d3"), "d4", ix_aula), ix_aula))  # tem que dar d3 d2 d1 d6 d8 d5 d7 d4
```

Se não der, alguma linha foi digitada errado: não sigam.

**Uma consulta de trabalho.** $D_r$ = julgados com grau $\geq$ `cfg$limiar`; $D_{nr}$ = julgados com grau 0 **que aparecem no top-5** do ranking base (o que o usuário teria visto e recusado):

```r
q    <- usar[1]                                                    # uma consulta de trabalho julgada (troquem)
g    <- qrels[[q]]                                                 # os graus dela
q0   <- vetor_consulta(preparar(consultas[[q]], cfg), ix$vocab, ix$idf_tfidf)  # o vetor, com a limpeza do grupo
base <- ranking_vetor(q0, ix)                                      # o mesmo que ranking_cosseno(consultas[[q]], ix, cfg)
Dr   <- intersect(names(g)[g >= cfg$limiar], names(docs))          # os relevantes julgados que estao no corpus
Dnr  <- intersect(names(base)[1:5], names(g)[g == 0])              # grau 0 visto no top-5 base
Dr; Dnr                                                            # confiram antes de seguir
```

```r
novo <- ranking_vetor(rocchio(q0, Dr, Dnr, ix), ix)                # a consulta reformulada, buscada de novo
round(rbind(base    = metricas(base, g, cfg$limiar),               # antes...
            rocchio = metricas(novo, g, cfg$limiar)), 3)           # ...e depois, na colecao completa
```

**Agora a coleção residual** — sem os marcados, no ranking e no gabarito:

```r
residual <- function(rk, g, fora, limiar)                               # metricas so no que NAO foi marcado
  metricas(rk[!names(rk) %in% fora], g[!names(g) %in% fora], limiar)    # tira 'fora' do ranking e do gabarito
fora <- c(Dr, Dnr)                                                       # tudo que o usuario marcou
round(rbind(base    = residual(base, g, fora, cfg$limiar),               # base, sem os marcados
            rocchio = residual(novo, g, fora, cfg$limiar)), 3)           # Rocchio, sem os marcados
```

Com $D_r$ = **todos** os relevantes, a residual não tem relevante nenhum no limiar de vocês: $R = 0$, AP `NA` — o caso degenerado da teoria. Só o nDCG graduado ainda vê algo (os grau 1, se o limiar é 2). O realista: **o usuário só marca o que vê**.

```r
Dr_v   <- intersect(names(base)[1:5], Dr)                               # so os relevantes que estavam no top-5
novo_v <- ranking_vetor(rocchio(q0, Dr_v, Dnr, ix), ix)                 # Rocchio com o que foi visto
fora_v <- c(Dr_v, Dnr)                                                   # os marcados, agora
round(rbind(base    = residual(base,   g, fora_v, cfg$limiar),           # o resto, antes
            rocchio = residual(novo_v, g, fora_v, cfg$limiar)), 3)       # o resto, depois: achou algo NOVO?
```

Se sobrou relevante abaixo do top-5, esta tabela diz se o Rocchio o trouxe para cima. Se `Dr_v` sai vazio, ninguém relevante foi visto: o bloco para com *missing value where TRUE/FALSE needed* e não há realimentação possível nessa consulta.

**Exemplos que você mostra** — os números da teoria (corpus do curso):

- completa: AP $0{,}5 \to 1$ — os marcados `d2` e `d3` subiram; parece milagre;
- residual com os três marcados: limiar 2 dá `NA`; limiar 1, empate ($1$ e $1$) — nos documentos novos, nada mudou;
- marcando só `d3` e `d4`: residual AP $0{,}5 \to 1$ — `d2`, **não marcado**, subiu para 1º. Ganho honesto.

> **Erro previsto:** reportar a tabela completa como "o ganho do Rocchio". Sinal: *"AP subiu para 1"*. Reação: *"quem está no topo? quem os escolheu?"* — a residual é o número que vai para a ficha.

> **Erro previsto:** um id de $D_r$ que não está no corpus. Sinal: *Error in ix$w[, Dr, drop = FALSE]: subscript out of bounds* ("índice fora dos limites"). Reação: é para isso o `intersect(…, names(docs))` — e um sinal de que o gabarito foi feito sobre outra versão do corpus (Aula 5,5).

> **Checkpoint 7.** *Na consulta de vocês: quanto mudou o AP na completa, e quanto na residual com `Dr_v`? Em uma frase, com esses números, por que a completa é otimista?*
> Esperado: os dois pares de números lidos das tabelas; a frase liga a diferença aos marcados ("subiram os que já tínhamos visto"). Se a residual deu `NA`, dizem por quê (todos os relevantes estavam no top-5: nada novo a achar). *"O grupo concorda?"* — o resultado vai para a lista da ficha.

> **Ponte:** na prática, ninguém marca nada. E se o motor marcar sozinho?

---

## Módulo 8 — Pseudo-realimentação em todas as consultas
*trabalho 22 min · conversa 8 min · lembrete: $k$ se escolhe no dev; o teste roda UMA vez; o grupo decide*

**Quem digita muda.** A PRF da teoria, como função, e o AP de uma consulta com e sem ela:

```r
prf <- function(q0, k, ix, p = c(a = 1, b = 0.75, g = 0.15)) {   # pseudo-realimentacao: top-k viram Dr
  top <- names(ranking_vetor(q0, ix))[1:k]                        # os k primeiros do ranking base
  ranking_vetor(rocchio(q0, top, ix = ix,                         # Rocchio sem Dnr...
                        a = p[["a"]], b = p[["b"]], g = p[["g"]]), ix)  # ...com os pesos de p; busca de novo
}                                                                 # fim da funcao
```

```r
ap_q <- function(txt, grau, k, ix, cfg) {                                  # AP de uma consulta; k = 0: sem PRF
  q0 <- vetor_consulta(preparar(txt, cfg), ix$vocab, ix$idf_tfidf)         # o vetor da consulta
  rk <- if (k == 0) ranking_vetor(q0, ix) else prf(q0, k, ix)              # base ou PRF
  metricas(rk, grau, cfg$limiar)[["AP"]]                                   # so o AP, contra os graus dela
}                                                                          # fim da funcao
```

**Desenvolvimento e teste** — a lógica da Aula 05: escolhe-se **no desenvolvimento**; o **teste** se roda **uma vez**, no fim, e não se ajusta nada depois de vê-lo.

```r
dev   <- intersect(usar, nec$consulta[nec$conjunto == "dev"])      # aqui se escolhe k
teste <- intersect(usar, nec$consulta[nec$conjunto == "teste"])    # so no fim, uma vez
tab_dev <- sapply(dev, function(q) {                                # para cada consulta dev...
  a <- function(k) ap_q(consultas[[q]], qrels[[q]], k, ix, cfg)     # o AP desta consulta com um k
  c(base = a(0), k2 = a(2), k3 = a(3), k5 = a(5))                   # ...o AP em cada opcao
})                                                                  # fim do sapply
round(tab_dev, 3)                                                   # uma coluna por consulta
round(rowMeans(tab_dev), 3)                                         # o MAP de cada opcao
```

**Procurem o *drift*:** em que consulta a PRF **piorou**? E o que havia no top-$k$ dela?

```r
colnames(tab_dev)[tab_dev["k5", ] < tab_dev["base", ]]             # consultas em que k = 5 piorou (troquem o k)
qrels[["q02"]][names(ranking_cosseno(consultas[["q02"]], ix, cfg))[1:5]]  # troquem q02: graus do top-5 base (NA = nao julgado)
```

**O grupo escolhe $k$** — ou "sem PRF" — olhando **só** `tab_dev`, e diz por quê em uma frase. *"O grupo concorda?"* Só então:

```r
k_grupo <- 2                                                        # O VALOR QUE O GRUPO ESCOLHEU (exemplo)
tab_teste <- sapply(teste, function(q) {                            # para cada consulta de teste...
  a <- function(k) ap_q(consultas[[q]], qrels[[q]], k, ix, cfg)     # o mesmo atalho
  c(base = a(0), prf = a(k_grupo))                                  # ...base e PRF com o k escolhido
})                                                                  # fim do sapply
round(tab_teste, 3); round(rowMeans(tab_teste), 3)                  # por consulta e o MAP: relatar como saiu
```

**Exemplos que você mostra:**

- na teoria (corpus do curso, uma consulta): base AP $0{,}5$; $k = 1$ dá $0{,}417$; $k = 2$, $0{,}833$; $k = 3$, $0{,}750$ — o $k$ maior trouxe `d4` para $D_r$;
- **números de exemplo** (não de um corpus), três consultas dev: MAP base $0{,}52$, $k = 2$ $0{,}58$, $k = 3$ $0{,}55$, $k = 5$ $0{,}47$ — $k = 2$ vence, $k = 5$ fica abaixo do base;
- no mesmo exemplo, se o teste der base $0{,}61$ e PRF $0{,}57$: **relata-se assim**. Trocar $k$ agora seria ajustar no teste.

> **Erro previsto:** olhar o teste "só para ver" antes de escolher $k$. Sinal: alguém roda `tab_teste` com os três $k$. Reação: *"depois de ver, vocês conseguem escolher como se não tivessem visto?"* — o número de teste deixa de valer.

> **Erro previsto:** `teste` vazio. Sinal: `tab_teste` sai `named list()` e o `round(tab_teste, 3)` para com *non-numeric argument to mathematical function* ("argumento não numérico para função matemática"); sozinho, o `rowMeans` daria *'x' must be an array of at least two dimensions*. Reação: na Aula 05 o grupo deixou todas como dev (a regra da Aula 05) ou as de teste têm $R = 0$. Não há relato de teste hoje — e isso vai para a ficha.

> **Erro previsto:** `NA` no MAP. Sinal: `rowMeans` devolve `NA`. Reação: entrou consulta com $R = 0$; o `usar` da segunda célula as tira — confiram se foi usado.

> **Checkpoint 8.** *Qual $k$ vocês escolhem, olhando só o desenvolvimento, e por quê? Houve alguma consulta com drift? Qual documento irrelevante (ou não julgado) estava no top-$k$ dela?*
> Esperado: a escolha com o MAP dev e o número de consultas que pioraram; para o *drift*, a consulta e o documento lidos de `qrels[[q]][…]` — `docs[["d17"]]` para ver do que ele fala (troquem pelo id real). Se nenhuma piorou, dizem isso — e que com poucas consultas não dá para generalizar.

> **Ponte:** os números estão na mesa. Falta decidir — e registrar.

---

## Módulo 9 — A decisão do grupo e o registro
*trabalho 12 min · conversa 8 min · lembrete: "não usar" vale; ficha e `config.R` dizem o mesmo*

**Quem digita muda.** A pergunta: **o motor usa pseudo-realimentação?** Se sim, com que $k$ e que $\alpha$, $\beta$, $\gamma$? Pesem: o ganho no dev; o resultado no teste; o *drift* visto; o custo (uma segunda busca a cada consulta).

O grupo diz a decisão em uma frase. *"O grupo concorda?"* Você escreve as linhas; o grupo descomenta e ajusta as do bloco da Aula 06, se o `config.R` veio do modelo novo, ou as cola num bloco novo antes do `grupo = …` (painel de arquivos → dois cliques em `config.R` → edita → *Ctrl+S*):

```r
  # --- Aula 06: realimentacao ---------------------------------------------
  prf_k   = 0,                            # 0 = sem pseudo-realimentacao; k = usa os top-k
  rocchio = c(a = 1, b = 0.75, g = 0.15), # pesos do Rocchio
```

(Com o valor do grupo no lugar do `0`.) Depois:

```r
source("config.R")                                                         # recarrega com os campos novos
cfg$prf_k; cfg$rocchio                                                     # confiram com a decisao
ranking_motor <- function(txt, ix, cfg) {                                  # o ranking do motor, com a decisao
  q0 <- vetor_consulta(preparar(txt, cfg), ix$vocab, ix$idf_tfidf)         # o vetor da consulta
  if (cfg$prf_k == 0) ranking_vetor(q0, ix) else prf(q0, cfg$prf_k, ix, cfg$rocchio)  # sem ou com PRF
}                                                                          # fim da funcao
round(head(ranking_motor(consultas[[usar[1]]], ix, cfg), 5), 3)            # o top-5 que o motor daria
```

**Exemplos que você mostra** — frases de decisão (de exemplo):

- *"Não usar: no dev o MAP subiu de 0,52 para 0,58 com $k = 2$, mas no teste caiu de 0,61 para 0,57, e a consulta q03 derivou para 'praias'."* → `prf_k = 0`;
- *"Usar com $k = 2$: ganhou no dev e no teste e não piorou nenhuma consulta; ressalva: só 5 consultas."* → `prf_k = 2`;
- os pesos $\alpha = 1$, $\beta = 0{,}75$, $\gamma = 0{,}15$ ficam no `config.R` mesmo com `prf_k = 0`: registram o que foi testado.

> **Erro previsto:** a ficha diz "$k = 2$" e o `config.R` diz `prf_k = 0`. Sinal: `cfg$prf_k` não bate com a frase. Reação: as duas têm que dizer o mesmo — corrijam antes do fechamento.

> **Erro previsto:** decidir pela completa do Módulo 7. Sinal: *"o Rocchio deu AP 1, vamos usar"*. Reação: aquilo exigia um usuário marcando; o motor não tem. A decisão de hoje é sobre a **PRF**, e os números são os do Módulo 8.

> **Checkpoint 9.** *A decisão de vocês em uma frase — usar ou não, com que $k$ — com os números que a sustentam e uma ressalva. E: o `cfg$prf_k` que acabou de sair diz o mesmo?*
> Esperado: a frase, com o MAP dev e o de teste (ou "sem teste"), a ressalva (poucas consultas, *drift* visto) e o valor de `cfg$prf_k` igual ao da frase.

> **Ponte:** o motor de vocês tem, agora, uma etapa de reformulação de consulta — ligada ou desligada, por decisão registrada.

---

**Funções de R apresentadas nesta sessão** (o guia da Parte D da Aula 07 copia esta linha): nenhuma nova de R base — `rowMeans`, `drop = FALSE` e `intersect` reaparecem. Escritas na sessão: `rocchio` e `ranking_vetor` (da teoria), `residual`, `prf`, `ap_q`, `ranking_motor`. Campos novos do `config.R`: `prf_k`, `rocchio`.

**Casos degenerados desta sessão:** $D_r$ com todos os relevantes → residual com $R = 0$: `P_at_k` 0, `AP` `NA`, `RR` 0, `nDCG_bin` `NA` (o graduado ainda mede os grau 1); `Dr_v` vazio → o centroide de nada sai `NaN` e `ranking_vetor` para com *missing value where TRUE/FALSE needed* — não há realimentação nessa consulta; $D_{nr}$ vazio → `cnr` vale 0; id do gabarito fora do corpus → *subscript out of bounds* (evitado pelo `intersect`); consulta com $R = 0$ → fora por `usar`, com aviso na segunda célula; top-$k$ todo irrelevante → a PRF puxa a consulta para o assunto errado (*drift*) e o AP cai; `teste` vazio → `named list()` e erro no `round` (*non-numeric argument to mathematical function*); documento do top-$k$ não julgado → `NA` no `qrels[[q]][…]`, e conta como irrelevante nas métricas (*pooling*).

---

## Fechamento

Ordem: **perguntas guardadas → tarefa → o que vem → ficha → consolidado → passos de fechamento.** (O teste foi na teoria, individual.)

1. **Perguntas guardadas:** responda as curtas; encaminhe — *embeddings* e "achar documentos com outras palavras" são a Aula 07; "o ganho é significativo?", a Aula 16; "PRF com BM25?", fora do escopo desta aula.
2. **A tarefa do grupo:** escrever, em prosa, para a ficha e o relatório, a análise da consulta com *drift* (ou da que mais ganhou na residual): quais termos entraram na consulta e por quê.
3. **O que vem:** *"Hoje a consulta ganhou palavras dos documentos relevantes — só as que estão escritas neles. Na Aula 07, com* embeddings *e recuperação densa, documentos que dizem a mesma coisa com outras palavras passam a ficar perto da consulta; e vocês vão medir isso com as mesmas `metricas`."*
4. **A ficha do projeto** — avise que está gerando. Devolva-a **inteira, sem a seção 8**, em bloco de código Markdown, só com o permitido: **seção 5** — a linha da Aula 06 (já está no modelo; acrescentem-na se faltar) *"realimentação (Rocchio, pseudo-realimentação) | 06 | `estrutura/codigo/aula06.ipynb` | <ok / testado, desligado>"*, e `prf_k`, `rocchio` acrescentados aos campos da linha "decisões para o R"; **seção 6** — *"Aula 06: pseudo-realimentação <usar com $k$ = … / não usar>, porque … (MAP dev <x> → <y>; teste <z> → <w>, ou sem teste) · `cfg$prf_k = <k>`, `cfg$rocchio = c(a = 1, b = 0.75, g = 0.15)`"* e *"Aula 06: resultado — Rocchio na consulta <q>: AP completo <x> → <y>; residual <x'> → <y'> · resultado, sem campo"*; **seção 7** — a entrada da Aula 06 (presentes, quem digitou, feito, produzido, pendente); **cabeçalho** — *última atualização: Aula 06 Parte D, <data>, motor06*. Seções 1–4 intocadas.
5. **O consolidado** — avise. Formato de **grupo** (`.md` em bloco de código, nunca PDF, sem código, sem reexplicação, LaTeX, sem a seção "Estado do R"):
   ```markdown
   # Consolidado — PI III — Aula 06 — Parte D — <data>
   *guia versão 1 · tutora: <qual LLM> · sessão de grupo · motor06*
   **Grupo:** <nome> · **presentes:** <nomes> · **digitou:** <nome(s), por módulo>

   ## 1. O que foi feito
   - M7 — Rocchio no gabarito do grupo; completa × residual
   - M8 — pseudo-realimentação em todas as consultas; $k$ escolhido no dev; teste relatado
   - M9 — a decisão; `config.R` e ficha

   ## 2. Como o grupo trabalhou — opinião da tutora
   <um parágrafo, em primeira pessoa: as funções foram reescritas ou copiadas? o grupo
   entendeu por que a completa é otimista? escolheu k só no dev, ou quis ver o teste?
   leu os documentos do drift? a decisão saiu do grupo ou foi puxada? quem digitou
   entendeu o que rodou?>

   ## 3. Observações para a frente
   - **Para a próxima sessão prática (Aula 07):** <o que precisa estar pronto; quem ficou de quê>
   - **Perguntas guardadas:** <pergunta> — <para qual aula>
   - **Produzido:** ver a entrada "Aula 06" na linha do tempo da ficha do projeto
   - **Ficha atualizada:** sim — seções alteradas: <5, 6, 7, cabeçalho>
   ```
6. **Logo abaixo do consolidado, na mesma mensagem, os passos de fechamento** — os oito, por extenso.

## Passos de fechamento (copie logo abaixo do consolidado)

1. Salvem a ficha como **`00_FICHA_PROJETO.md`** e o consolidado como **`aula06_parteD_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, enviem os dois (pasta à esquerda → upload). `list.files()` tem que mostrá-los soltos, com esses nomes exatos.
3. Rodem, numa célula:
   ```r
   anexar_estado("00_FICHA_PROJETO.md")            # o estado do R vai para a ficha
   anexar_estado("aula06_parteD_consolidado.md")   # e para o consolidado do grupo
   ```
4. Baixem (três pontinhos → *Fazer download*): os dois `.md`; o **`config.R`** (mudou: `prf_k` e `rocchio`); e o **notebook** (*Arquivo → Fazer download → Baixar o .ipynb*), salvo como **`aula06.ipynb`**.
5. No GitHub, enviem (*Add file → Upload files*; mesmo nome substitui): `consolidados/` ← `00_FICHA_PROJETO.md` e `aula06_parteD_consolidado.md`; `estrutura/codigo/` ← `config.R` e `aula06.ipynb`.
6. Confiram no GitHub que a ficha termina com a seção "Estado do R" e que o `config.R` tem `prf_k` e `rocchio`.
7. Confiram que a seção 6 da ficha e o `config.R` dizem o mesmo: o mesmo `prf_k`, os mesmos pesos.
8. Cada integrante envia o **seu** consolidado da teoria (`aula06_consolidado.md`) para `consolidados/<seu nome>/`.

Se o grupo disser que já fez, pergunte só: *"a ficha no GitHub termina com a seção 'Estado do R'?"*
