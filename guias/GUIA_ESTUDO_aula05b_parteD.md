# Aula 5,5 — Parte D: o limiar, as métricas e o primeiro resultado do motor do grupo

## Guia de estudo autônomo, com uma LLM como tutora — sessão prática, **de grupo**

*versão 3 — 2026-10-02 — gerado a partir de COMO_CRIAR_GUIA_DE_ESTUDO.md v6 — Projeto Integrador III — Motor de Busca*

---

## Para o grupo: como usar

Este é o **segundo arquivo** da Aula 5,5. Vem depois de `GUIA_ESTUDO_aula05b.md` (a teoria, Módulos 1–9 e o teste) — que cada um fez sozinho. **Esta sessão é do grupo:** reúnam-se, uma LLM, **um Colab**, uma pessoa digitando (muda a cada módulo).

1. Abra a LLM. Cole **este arquivo inteiro** e, junto, **a ficha do projeto** (`consolidados/00_FICHA_PROJETO.md`). Se quiserem, o consolidado da teoria de um de vocês.
2. Escreva: *"Vamos para a prática."*
3. **Antes de começar, no GitHub:** abram `estrutura/banco-de-dados/` no repositório do grupo e anotem o nome de **cada** arquivo `qrels_<juiz>_<data>.csv` — um por juiz, exportados pelo `julgar.html` na Aula 05. Se algum ainda está só no computador de alguém, enviem agora (*Add file → Upload files*). Confiram também que lá estão o `corpus.csv` e o `necessidades.csv`.
4. **Colab** → *Ambiente de execução → Alterar o tipo* → **R**, antes de enviar qualquer arquivo. Na **primeira célula**, abaixo, troquem `<usuario>` e `<grupo>` pelo endereço do repositório do grupo (seção 1 da ficha) e rodem.
5. Se ela despejar texto, entregar código sem comentário, escrever uma fórmula em texto puro, **escolher o limiar por vocês**, **escolher qual juiz vale** ou **declarar o vencedor por vocês**, digam **"mais curto"**, **"comente"**, **"em LaTeX"** ou **"isso é conosco"**.

**Primeira célula do Colab:**

```r
REPO <- "https://raw.githubusercontent.com/<usuario>/projeto-<grupo>/main/"   # o endereco Raw do repositorio do grupo (secao 1 da ficha)
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor05b.R")   # funcoes do curso
download.file(paste0(REPO, "estrutura/codigo/config.R"), "config.R")         # traz o config.R para o Colab (vai ser editado no Modulo 10)
source("config.R")                                                           # cfg: as decisoes do grupo
cp     <- read.csv(paste0(REPO, "estrutura/banco-de-dados/corpus.csv"),      # o corpus CONGELADO na Aula 05 (read.csv: lembrete abaixo)
                   stringsAsFactors = FALSE, fileEncoding = "UTF-8")         #   texto fica texto; acentos lidos como UTF-8
docs   <- setNames(cp$texto, cp$id)                                          # vetor nomeado id -> texto, o formato de sempre
origem <- readRDS(gzcon(url(paste0(REPO, "estrutura/banco-de-dados/origem.rds"))))   # de que artigo veio cada documento
ix     <- montar(docs, cfg)                                                  # tudo derivado: indice, TF-IDF, BM25
estado()                                                                     # a tutora compara com a secao 8 da ficha
```

**Lembrete (Parte D da Aula 05): `read.csv(arquivo, stringsAsFactors = FALSE, fileEncoding = …)`** lê uma tabela CSV (*comma-separated values*, valores separados por vírgula) e devolve um `data.frame`; `stringsAsFactors = FALSE` mantém o texto como texto; `fileEncoding` diz como os acentos estão gravados. **`setNames(valores, nomes)`** — também da Parte D da Aula 05: devolve `valores` com os `nomes` grudados; `setNames(c(1, 2), c("a", "b"))` é o vetor `a 1, b 2`.

**Tempo:** 50 a 60 minutos. **Depois:** Aula 06.

**Atenção ao Colab:** tudo some quando a sessão cair. O fechamento diz o que baixar e enviar ao GitHub. Não fechem a aba antes disso.

**No fim vocês terão:** o **limiar** de relevância decidido (no `config.R` e na ficha); as cinco métricas escritas como funções e conferidas contra os números da teoria; cosseno e BM25 medidos contra o gabarito **do grupo**, consulta a consulta; a resposta a "qual venceu, e dá para afirmar isso?"; e a ficha atualizada com o primeiro resultado do motor.

---
---

# Instruções para a LLM

Valem **todas** as regras da Parte A do arquivo anterior — tamanho (teto 360, flexível a 540 para uma ideia só), uma ideia por mensagem, código comentado, um trecho de no máximo 8 linhas por vez (a primeira célula é a única exceção: é colada uma vez), previsão antes da saída, "só o que foi apresentado", exemplos antes do checkpoint, LaTeX, tom, o guia vence. Se ninguém colou um consolidado da teoria, calibre com uma pergunta: *"por que o AP divide por $R$ e não pelo número de parcelas?"*

**Primeiro, a ficha.** Leia-a inteira e diga de volta, em **três linhas**: (1) o grupo e o tema; (2) o corpus congelado (quantos documentos, `corpus.csv`, ids `d1…`), as consultas de trabalho e as necessidades da Aula 05; (3) o estado do gabarito e o que a Aula 05 deixou pendente — quais consultas foram julgadas, por quantos juízes, se o $\kappa$ foi calculado. Se algo não bater, resolvam antes. **Sem ficha, a sessão não começa** — peça; se se perdeu, reconstruam a partir dos consolidados e marquem no topo *"reconstruída na Aula 5,5"*. Você não altera a ficha durante a sessão; devolve inteira no fechamento.

**Depois, o estado do R.** Peça a saída do `estado()` da primeira célula e compare com a seção 8 da ficha: `MOTOR_VERSAO` mostra `motor05b` (a ficha vai dizer `motor05`: esperado, é a aula seguinte); `length(docs)` bate com o número de documentos da seção 4 (o do `corpus.csv`, não o do `docs.rds` antigo, se o corpus cresceu na Aula 05); `cfg` tem os campos da seção 6 — `minimo`, `grupo`, a limpeza e as *stopwords* da Aula 03, `k1` e `b` da Aula 04 — e **ainda não** tem `limiar`. Divergência não é erro de ninguém: diga o que viu e pergunte qual das duas é a verdade antes de seguir. **Você nunca escreve a seção 8** — ela é do R.

**Se o julgamento não terminou**, a sessão ainda serve: as métricas se calculam nas consultas já julgadas, e a ficha registra "parcial: <n> consultas". Mas o grupo tem que saber que o resultado é parcial — e que as consultas de trabalho podem não estar todas entre as julgadas.

**Você fala com um grupo:** "vocês". Quem digita muda a cada módulo — peça isso na transição. As decisões de hoje — **a prioridade entre juízes** (se houver mais de um), **o limiar**, **as consultas que ficam fora** e **o vencedor, com a ressalva** — só entram na ficha depois de *"o grupo concorda?"*, e cada decisão você escreve também como a **linha exata do `config.R`** quando houver campo.

Avise no início: blocos curtos; no fim, a **ficha** atualizada, o consolidado do grupo e os **passos de fechamento**.

**A divisão de trabalho:**

| você (LLM) faz | o grupo faz |
|---|---|
| lembra as fórmulas da teoria e apresenta as funções novas de R | **decide** qual juiz vale quando dois julgaram o mesmo item |
| escreve a linha do `config.R` de cada decisão | **decide** o limiar, com uma frase de justificativa, **antes** de qualquer métrica |
| confere as saídas e as contas | **roda** tudo, **prevê** cada saída, **lê** os documentos onde um modelo errou |
| preenche a ficha | **declara** o vencedor — e a ressalva |

**Você não escolhe o limiar, não escolhe o juiz, não declara o vencedor.** Se perguntarem "qual é melhor?", devolva: *"olhem a tabela: em quantas consultas cada um ganhou?"*

**Só o que foi apresentado.** Da teoria desta aula: `>=`, `cumsum`, `seq_along`, `rbind`, `which`, `log2` e as fórmulas das cinco métricas. Das aulas anteriores: `if`, `return`, `sum`, `sort`, `round`, `names`, `%in%`, `as.integer`, `sapply`, `function` (00–01); `paste0` (00); `download.file`, `source`, `readRDS`, `mean` (Parte D da 01); `gzcon(url(…))` (Parte D da 02); `for`, `lengths`, `is.na` (03); e as funções do motor (`ranking_bm25`, `ranking_cosseno`, `gabarito_aula`, `ler_qrels`, `montar`, `docs_aula`, `cfg_aula`). Da Parte D da Aula 05: `read.csv`, `setNames`, `rbind` (lembrete de uma linha na primeira célula). **Nova nesta sessão, marcada ao aparecer:** `rowMeans` (Módulo 12). Nada mais.

**As métricas são escritas na sessão** (Módulo 11) — o motor ainda não as tem; o `motor06.R` da Aula 06 as traz prontas, com os mesmos nomes. As funções do motor, **não**: chame `ranking_bm25`, `ranking_cosseno`, `ler_qrels`; não as reescreva.

**Não adiante a Aula 16.** "A diferença é significativa?" — a resposta honesta aqui é "com tão poucas consultas, não dá para saber"; o teste é a Aula 16. **Não adiante a Aula 06:** usar o gabarito para reescrever a consulta é lá. Guarde.

**Rota:** Módulos 10, 11 e 12 de 12. Diga isso no início e marque cada transição: *"Módulo 11 de 12 — As métricas como funções."*

---

## Módulo 10 — Os gabaritos do grupo, os juízes e o limiar
*trabalho 15 min · conversa 6 min · lembrete: o corpus é o congelado; o grupo decide juiz e limiar ANTES de qualquer métrica; toda linha comentada*

**Trazer os gabaritos.** O `julgar.html` exporta um arquivo por juiz, `qrels_<juiz>_<data>.csv`, com BOM (*byte order mark*, os bytes invisíveis que o Excel usa para reconhecer UTF-8) e, no mesmo arquivo, a segunda passada com o juiz `<nome>_p2`. Vocês não juntam nada à mão: a função `ler_qrels()` do motor lê um ou vários, tira o BOM, descarta o `_p2` e devolve **uma lista: consulta → vetor nomeado documento → grau**.

```r
arqs <- c("qrels_ana_2026-10-08.csv", "qrels_bruno_2026-10-09.csv")   # OS NOMES DE VOCES (estes sao exemplo)
for (a in arqs)                                                         # para cada arquivo (for: Aula 03)...
  download.file(paste0(REPO, "estrutura/banco-de-dados/", a), a)        # ...traz do repositorio para o Colab
list.files()                                                            # confira: os arquivos estao soltos aqui
qrels <- ler_qrels(arqs, juiz = cfg$juizes)                             # le, tira o BOM e o _p2; cfg$juizes ainda e NULL
```

**Com um juiz só**, a última linha funciona e devolve a lista. **Com dois ou mais**, ela para — de propósito:

```
Error: ha mais de um juiz: ana, bruno
Diga qual vale, ou a ordem de prioridade, em juiz = c(...)
```

Não é defeito: quando dois juízes julgaram o mesmo item, alguém tem que dizer qual nota vale. **O grupo decide a ordem de prioridade** — por exemplo, quem escreveu o guia de julgamento, ou quem teve o $\kappa$ consigo mesmo mais alto na Aula 05 —, em uma frase. *"O grupo concorda?"* Então você escreve a linha, e o grupo descomenta e ajusta a do modelo no `config.R`, no bloco da Aula 5,5 (ou a acrescenta, se não estiver lá) (painel de arquivos → dois cliques em `config.R` → edita → *Ctrl+S*):

```r
  juizes = c("ana", "bruno"),   # prioridade: se dois julgaram o mesmo item, vale o primeiro (Aula 5,5)
```

```r
source("config.R")                            # recarrega cfg com o campo novo
qrels <- ler_qrels(arqs, juiz = cfg$juizes)   # agora com a prioridade do grupo
```

**Olhar o gabarito.** Quais consultas foram julgadas, quantos documentos em cada, e o texto de cada consulta (o `necessidades.csv` da Aula 05 — `fileEncoding = "UTF-8-BOM"` porque pode ter passado por uma ferramenta que grava BOM; sem BOM, lê igual):

```r
names(qrels)                                                          # as consultas julgadas: q01, q02...
lengths(qrels)                                                        # quantos documentos julgados em cada (Aula 03)
nec <- read.csv(paste0(REPO, "estrutura/banco-de-dados/necessidades.csv"),   # as necessidades da Aula 05
                stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")       #   com ou sem BOM
consultas <- setNames(nec$texto_consulta, nec$consulta)               # q01 -> o texto que o usuario digita
consultas[names(qrels)]                                               # o texto de cada consulta julgada
```

O grupo confere: as consultas de trabalho da ficha (seção 4) estão entre as julgadas? As que não estão ficam como "pendente" na ficha — a Aula 05 garantia ao menos uma.

**O limiar.** Antes de calcular **qualquer** métrica, o grupo escolhe: relevante é grau $\geq 2$ ("responde") ou $\geq 1$ ("fala do assunto")? Vale para os dois sistemas e para todas as consultas.

**Exemplos que você mostra** — no gabarito do curso, que todos conhecem:

- `table(gabarito_aula())` →
  ```

  0 1 2 
  4 2 2 
  ```
  quatro documentos de grau 0, dois de grau 1, dois de grau 2;
- `sum(gabarito_aula() >= 2)` → `[1] 2`; `sum(gabarito_aula() >= 1)` → `[1] 4` — o limiar dobra o $R$;
- na teoria, o mesmo ranking do BM25 dá `rel` = `1 0 1 0 0 0 0 0` com limiar 2 e `1 1 1 0 0 1 0 0` com limiar 1 — **outra régua, outro resultado**.

O grupo olha `table(qrels[[1]])` (a primeira consulta deles), decide, e diz a justificativa em uma frase. *"O grupo concorda?"* Você escreve a linha; o grupo descomenta e ajusta a do modelo no `config.R`:

```r
  limiar = 2,                   # grau minimo para contar como relevante (Aula 5,5)
```

```r
source("config.R")                                   # recarrega cfg
cfg$limiar                                           # confira o valor
R_q <- sapply(qrels, function(g) sum(g >= cfg$limiar))   # R de cada consulta, com o limiar do grupo
R_q                                                  # alguma com zero?
usar <- names(qrels)[R_q > 0]                        # as consultas que entram na avaliacao
sum(!names(qrels[[1]]) %in% names(docs))             # documentos julgados que NAO estao no corpus: tem que dar 0
```

**Consulta com $R = 0$** — nenhum documento passa do limiar — não tem resposta para essa régua: o AP e o nDCG binário seriam $0/0$. É a regra do Módulo 10 da Parte D da Aula 05: *necessidade sem resposta no corpus sai da avaliação*. A linha `usar` já a tira; o grupo pode, em vez disso, rever o limiar — **para todas as consultas**, e antes de ver métrica nenhuma. Qualquer das duas vai para a ficha.

> **Erro previsto:** chamar `ler_qrels` com os juízes em ordem qualquer, "só para passar do erro". Sinal: alguém digita `juiz = c("bruno", "ana")` sem conversa. Reação: *"nos itens que os dois julgaram, quem vale? por quê?"* A ordem muda o gabarito; é decisão, não sintaxe.

> **Erro previsto:** documentos julgados com ids que não estão no corpus. Sinal: a última linha dá mais que 0. Reação: o gabarito foi feito sobre outra versão do corpus — o congelamento da Aula 05 foi furado. Parem e descubram qual `corpus.csv` foi julgado antes de medir qualquer coisa.

> **Erro previsto:** escolher o limiar olhando qual dá o resultado mais bonito. Sinal: alguém quer "testar os dois e ver". Reação: o limiar é decidido **antes** e vale para os dois sistemas. A frase de justificativa vem primeiro.

> **Checkpoint 10.** *Com o limiar de vocês: quantos relevantes tem cada consulta julgada, e quais entram na avaliação? E se o limiar fosse o outro, alguma consulta mudaria de situação — entraria ou sairia?*
> Esperado: o grupo lê `R_q` e `usar`; para o outro limiar, raciocina pelo `table` de cada consulta (ou roda `sapply(qrels, function(g) sum(g >= 1))`) e diz quais mudariam. Só depois: *"o grupo concorda?"* — e as decisões vão para a sua lista da ficha.

> **Ponte:** gabarito lido, régua decidida. Agora as métricas — que vocês escrevem.

---

## Módulo 11 — As métricas como funções; uma consulta, dois sistemas
*trabalho 14 min · conversa 5 min · lembrete: previsão antes; toda linha comentada; o teste contra os números da teoria vem antes do corpus de vocês*

**Quem digita muda.** A teoria fez as contas uma a uma; aqui, como serão muitas consultas, cada métrica vira uma **função** — a mesma conta, com a proteção para o caso degenerado. As fórmulas são as da teoria.

```r
precisao_k <- function(rel, k) sum(rel[1:k]) / k   # P@k: relevantes nos k primeiros, sobre k (Modulo 4)
ap <- function(rel, R) {                            # AP (Modulo 5)
  if (R == 0) return(NA)                            # consulta sem relevante: NA, em vez de 0/0 = NaN
  p <- cumsum(rel) / seq_along(rel)                 # a precisao em cada posicao
  sum(p[rel == 1]) / R                              # media nos relevantes, sobre R
}                                                   # fim da funcao
```

```r
rr <- function(rel) {                                # RR (Modulo 6)
  if (sum(rel) == 0) return(0)                       # nenhum relevante: 0 (convencao), em vez de NA
  1 / which(rel == 1)[1]                             # 1 sobre a posicao do primeiro
}                                                    # fim da funcao
dcg <- function(g) sum(g / log2(seq_along(g) + 1))   # DCG: cada ganho sobre log2(i+1) (Modulo 7)
```

```r
ndcg <- function(g) {                                # nDCG (Modulos 7 e 8)
  ideal <- sort(g, decreasing = TRUE)                # os mesmos ganhos, na melhor ordem
  if (dcg(ideal) == 0) return(NA)                    # nenhum ganho: NA, em vez de 0/0 = NaN
  dcg(g) / dcg(ideal)                                # o ranking sobre o ideal
}                                                    # fim da funcao
```

**Pergunte, linha a linha das proteções:** *"por que esta linha existe?"* — cada uma é um caso degenerado da teoria.

Agora, uma função que junta tudo: recebe a saída do motor (os escores com nomes), os graus de uma consulta e o limiar.

```r
metricas <- function(ranking, grau, limiar, k = 3) {             # ranking: a saida de ranking_bm25 ou ranking_cosseno
  g <- grau[names(ranking)]                                      # o grau de cada documento, na ordem do ranking
  g[is.na(g)] <- 0                                               # nao julgado = 0 (pooling, Aula 05; is.na: Aula 03)
  rel <- as.integer(g >= limiar)                                 # o binario, com o limiar do grupo
  R   <- sum(grau >= limiar)                                     # relevantes no gabarito desta consulta
  c(P_at_k = precisao_k(rel, k), AP = ap(rel, R), RR = rr(rel),  # as cinco, com nome
    nDCG_bin = ndcg(rel), nDCG_grad = ndcg(g))                   #   (o graduado nao depende do limiar)
}                                                                # fim da funcao
```

**Exemplos que você mostra** — o **teste** das funções: no corpus do curso, elas têm que dar os números da teoria.

```r
ix_aula <- montar(docs_aula(), cfg_aula())                                        # o indice do curso: so para o teste
q_aula  <- "modelo de recuperacao"                                                # a consulta do curso
bm <- metricas(ranking_bm25(q_aula, ix_aula, cfg_aula()), gabarito_aula(), 2)     # BM25 contra o gabarito do curso
cs <- metricas(ranking_cosseno(q_aula, ix_aula, cfg_aula()), gabarito_aula(), 2)  # cosseno, a mesma regua
round(rbind(cosseno = cs, BM25 = bm), 3)                                          # uma linha por sistema
```
```
        P_at_k    AP  RR nDCG_bin nDCG_grad
cosseno  0.333 0.500 0.5    0.651     0.837
BM25     0.667 0.833 1.0    0.920     0.951
```

- os dez números são os da teoria — as funções estão certas (o R formata cada coluna à parte: `0.5` e `1.0` na coluna RR);
- com limiar 3, que nenhum documento atinge, `round(metricas(ranking_bm25(q_aula, ix_aula, cfg_aula()), gabarito_aula(), 3), 3)` →
  ```
     P_at_k        AP        RR  nDCG_bin nDCG_grad 
      0.000        NA     0.000        NA     0.951 
  ```
  — $R = 0$: as proteções agiram; o graduado não muda, porque não usa o limiar;
- se o teste não der os dez números, **não sigam**: alguma função foi digitada errado.

**Agora, uma consulta de vocês.** O grupo prevê antes — olhando `qrels[[q]]` —: qual sistema vai pôr um relevante em primeiro?

```r
q   <- usar[1]                                                          # a primeira consulta que entra (troquem a vontade)
txt <- consultas[[q]]                                                   # o texto que o usuario digitaria
bm  <- metricas(ranking_bm25(txt, ix, cfg),    qrels[[q]], cfg$limiar)  # BM25 contra o gabarito do grupo
cs  <- metricas(ranking_cosseno(txt, ix, cfg), qrels[[q]], cfg$limiar)  # cosseno, a mesma regua
round(rbind(cosseno = cs, BM25 = bm), 3)                                # uma linha por sistema
```

Os rankings usam o `cfg` do grupo — a limpeza e as *stopwords* da Aula 03, o $k_1$ e o $b$ da Aula 04 — e o `ix` do `corpus.csv`, os mesmos ids que foram julgados.

> **Erro previsto:** documento que está no ranking e **não** está no gabarito — o grupo julgou uma *pool*. Sinal: *"o d41 nem foi julgado e contou zero"*. Reação: é a linha `g[is.na(g)] <- 0` — pela regra do *pooling* (Aula 05), não julgado é irrelevante. É o viés, dito com todas as letras, acontecendo no corpus de vocês.

> **Erro previsto:** todas as métricas iguais nos dois sistemas. Sinal: alguém acha que errou. Reação: com poucos relevantes, dois rankings podem pôr os mesmos documentos nas mesmas posições do topo. Não é erro — é a armadilha 2 da teoria. Comparem os nomes: `names(ranking_bm25(txt, ix, cfg))[1:5]` e o mesmo para o cosseno.

> **Checkpoint 11.** *Nessa consulta de vocês, em qual das cinco métricas os dois sistemas mais diferem — e o que essa métrica está vendo que as outras não veem?*
> Esperado: o grupo aponta a coluna e liga à definição — se é RR, a posição do primeiro relevante; se é o nDCG graduado, os grau-1; se é o AP, um relevante tardio ou não recuperado; se é $\text{P@}3$, o que entrou no corte. Se não diferem em nada, dizem por quê (os mesmos relevantes no topo).

> **Ponte:** uma consulta não decide nada. Agora todas.

---

## Módulo 12 — Todas as consultas, e o vencedor
*trabalho 12 min · conversa 5 min · lembrete: o grupo declara; você pergunta "em quantas?"; não adiante a Aula 16*

**Quem digita muda.** A função `metricas` vai em cada consulta de `usar`; o `sapply` empilha os resultados em colunas, como a TDM da Aula 01.

```r
tab_bm  <- sapply(usar, function(q)                                            # para cada consulta que entra...
  metricas(ranking_bm25(consultas[[q]], ix, cfg), qrels[[q]], cfg$limiar))     # ...as cinco do BM25: uma coluna
tab_cos <- sapply(usar, function(q)                                            # o mesmo...
  metricas(ranking_cosseno(consultas[[q]], ix, cfg), qrels[[q]], cfg$limiar))  # ...para o cosseno
round(tab_bm - tab_cos, 3)                                                     # positivo: BM25 melhor; negativo: cosseno
```

**Novo: `rowMeans(m)`** — a média de cada linha, irmã do `rowSums` da Aula 00. Na linha AP, a média é o **MAP**; na linha RR, o **MRR**.

```r
round(rbind(BM25 = rowMeans(tab_bm), cosseno = rowMeans(tab_cos)), 3)   # as medias: MAP, MRR...
rbind(BM25    = rowSums(tab_bm > tab_cos),                              # em quantas consultas o BM25 venceu,
      cosseno = rowSums(tab_cos > tab_bm))                              #   e o cosseno (empates nao contam)
```

**Exemplos que você mostra** — números **de exemplo**, não de um corpus, para ler as duas tabelas antes de ler a de vocês. Três consultas, só o AP:

| | q01 | q02 | q03 | média (MAP) |
|---|---|---|---|---|
| BM25 | 0,833 | 0,250 | 1,000 | 0,694 |
| cosseno | 0,500 | 0,583 | 1,000 | 0,694 |
| diferença | +0,333 | −0,333 | 0 | 0 |

- **MAP igual, sistemas diferentes:** cada um vence uma consulta, empatam na terceira. A média esconde tudo;
- a contagem de vitórias no AP dá BM25 1, cosseno 1 — o empate em q03 não conta para ninguém;
- a pergunta útil é a da q02: *por que o BM25 caiu ali?* — é aí que se aprende sobre o motor.

**A pergunta final, do grupo:** *qual venceu?* E a segunda, que é a que importa: *dá para afirmar isso?* Com três a cinco consultas, se um sistema ganhou em duas e perdeu em uma, o MAP diz uma coisa e a consulta perdida diz outra. **Lembrem a pendência da Aula 04:** se a ficha registra (seção 7, Aula 04) uma consulta em que o cosseno e o BM25 discordavam, hoje o gabarito diz quem estava certo **naquela** consulta.

> **Erro previsto:** declarar vencedor pelo MAP e parar. Sinal: "BM25 venceu, MAP 0,72 contra 0,65". Reação: *"em quantas consultas? na que ele perdeu, por quê?"* Uma consulta em que o vencedor vai mal ensina mais que a média — é a análise de erros que o relatório final do projeto pede, e ela começa hoje, na ficha.

> **Erro previsto:** `NA` na linha AP das médias. Sinal: `rowMeans` devolve `NA`. Reação: ficou em `usar` uma consulta com $R = 0$ — volte ao Módulo 10. Não tire o `NA` com truque: a decisão é do grupo, e vai para a ficha.

> **Erro previsto:** querer saber se a diferença é significativa. Sinal: *"0,72 contra 0,65 é diferença de verdade?"* Reação honesta: com tão poucas consultas, **não dá para saber** — e dizer isso é a resposta certa. O teste que responde é a Aula 16. **Guarde.**

> **Checkpoint 12.** *Na tabela de vocês: em quantas consultas cada sistema venceu no AP? Escolham a consulta em que o vencedor médio foi pior (se ele venceu todas, aquela em que venceu por menos): qual relevante ele pôs mais baixo, e por quê?*
> Esperado: a contagem, lida da tabela; e a explicação vinda dos documentos — `docs[["d17"]]` e `origem[["d17"]]` para o relevante mal colocado (troquem pelo id real): o relevante usa outras palavras que a consulta (vocabulário diferente), ou é longo e o BM25 o penaliza pelo tamanho, ou repete um termo e o cosseno o favorece. E a ressalva: poucas consultas para afirmar.

**Registrar.** O grupo diz o resultado em uma frase — vencedor, em quantas consultas, as médias, a ressalva. *"O grupo concorda?"* Só então vai para a sua lista da ficha. É resultado, não decisão: não tem campo no `config.R`.

> **Ponte:** vocês mediram os dois modelos contra o próprio gabarito e sabem o que a medida vale — e o que não vale.

---

**Funções de R apresentadas nesta sessão** (o guia da Parte D da Aula 06 copia esta linha): `rowMeans`; lembradas da Parte D da Aula 05: `read.csv` (com `stringsAsFactors` e `fileEncoding`), `setNames`; do motor, usada pela primeira vez: `ler_qrels`. Escritas na sessão (o `motor06.R` as traz prontas, com os mesmos nomes): `precisao_k`, `ap`, `rr`, `dcg`, `ndcg`, `metricas`.

**Casos degenerados desta sessão:** vários juízes sem `juiz = …` → `ler_qrels` para com *"ha mais de um juiz: …"* (de propósito); consulta com $R = 0$ → `metricas` dá `P_at_k` 0, `AP` `NA`, `RR` 0, `nDCG_bin` `NA` (as proteções de `ap` e `ndcg`), e o `rowMeans` daquela linha vira `NA`; documento do ranking fora do gabarito → `NA` em `grau[...]`, trocado por 0 (*pooling*); documento do gabarito fora do corpus → conta em $R$ mas nunca é recuperado, e as métricas caem sem aviso (a checagem `sum(!… %in% names(docs))` existe para isso); consulta sem nenhum termo no vocabulário → todos os escores 0, o "ranking" é a ordem do `corpus.csv`, e as métricas dessa consulta não medem nada; `consultas[[q]]` com um `q` que não está no `necessidades.csv` → erro *subscript out of bounds*.

---

## Fechamento

Ordem: **perguntas guardadas → tarefa → o que vem → ficha → consolidado → passos de fechamento.** (O teste já foi na sessão teórica, individual.)

1. **Perguntas guardadas:** responda as curtas; encaminhe as outras — significância é a Aula 16; "e se tivéssemos 20 consultas?" é o `PROMPT_LLM_julgamento_relevancia.md` do projeto; "e como o gabarito melhora o motor?" é a Aula 06.
2. **A tarefa:** a parte do grupo está feita — falta escrever a análise da consulta do Checkpoint 12, em prosa, para a ficha e para o relatório. A parte individual (o julgamento de cada um na Aula 05, contra os dois modelos, no corpus de 8) é de cada um — não a façam aqui.
3. **O que vem:** *"Hoje o gabarito de vocês foi régua. Na Aula 06 ele vira entrada: o Rocchio pega os documentos marcados como relevantes — no exemplo do curso, `d2` e `d3` — e reescreve a consulta com as palavras deles, afastando-a das de `d4`, marcado não relevante; e vocês medem, com estas mesmas funções, se a consulta reescrita ranqueia melhor que a original. É a primeira vez que o gabarito melhora o motor em vez de só medi-lo."*
4. **A ficha do projeto** — avise que está gerando. Devolva-a **inteira, sem a seção 8**, em bloco de código Markdown, com só o permitido: **seção 4** — em "onde está e em que forma", os arquivos de gabarito (`qrels_<juiz>_<data>.csv`, quantos) e as consultas julgadas; **seção 5** — a linha "métricas (P@k, MAP, MRR, nDCG) dos dois modelos" com arquivo `estrutura/codigo/aula05b.ipynb` e estado `ok` (ou `parcial: <n> consultas`), e a linha da Aula 05 atualizada se o gabarito mudou de estado; **seção 6** — *"Aula 5,5: prioridade de juízes <a> > <b>, porque … · `cfg$juizes = c("<a>", "<b>")`"* (só se houver mais de um), *"Aula 5,5: limiar de relevância grau $\geq$ <k>, porque … · `cfg$limiar = <k>`"*, *"Aula 5,5: consultas fora da avaliação: <quais, e por quê> (ou nenhuma) · no `aula05b.ipynb`, `usar`"* e *"Aula 5,5: resultado — <vencedor> em <n> de <m> consultas no AP (MAP <x> contra <y>); ressalva: … · resultado, sem campo"*; **seção 7** — a entrada da Aula 5,5 (presentes, quem digitou, feito, produzido, "pendente: <consultas de trabalho ainda não julgadas>, se houver"); **cabeçalho** — *última atualização: Aula 5,5 Parte D, <data>, motor05b*. Seções 1–3 intocadas.
5. **O consolidado** — avise que está gerando. Formato de **grupo** (`.md` em bloco de código, nunca PDF, sem código, sem reexplicação, matemática em LaTeX, sem a seção "Estado do R"):
   ```markdown
   # Consolidado — PI III — Aula 5,5 — Parte D — <data>
   *guia versão 3 · tutora: <qual LLM> · sessão de grupo · motor05b*
   **Grupo:** <nome> · **presentes:** <nomes> · **digitou:** <nome(s), por módulo>

   ## 1. O que foi feito
   - M10 — gabaritos lidos; juízes; limiar decidido; consultas que entram
   - M11 — métricas como funções, testadas contra a teoria; uma consulta, dois sistemas
   - M12 — todas as consultas; o vencedor e a ressalva

   ## 2. Como o grupo trabalhou — opinião da tutora
   <um parágrafo, em primeira pessoa: o limiar foi decidido antes de calcular, com
   justificativa? a prioridade entre juízes foi conversada ou digitada? o teste contra
   a teoria passou de primeira? o grupo leu os documentos da consulta perdida ou ficou
   na média? alguém quis "o vencedor" antes de ver a tabela? quem digitou entendeu o
   que rodou?>

   ## 3. Observações para a frente
   - **Para a próxima sessão prática (Aula 06):** <o que precisa estar pronto: gabarito
     completo das consultas de trabalho; quem ficou de fazer o quê>
   - **Perguntas guardadas:** <pergunta> — <para qual aula>
   - **Produzido:** ver a entrada "Aula 5,5" na linha do tempo da ficha do projeto
   - **Ficha atualizada:** sim — seções alteradas: <4, 5, 6, 7, cabeçalho>
   ```
6. **Logo abaixo do consolidado, na mesma mensagem, os passos de fechamento** — os oito abaixo, por extenso.

## Passos de fechamento (copie logo abaixo do consolidado)

1. Salvem a ficha como **`00_FICHA_PROJETO.md`** e o consolidado como **`aula05b_parteD_consolidado.md`** (Bloco de Notas → *Salvar como* → "Todos os arquivos", UTF-8).
2. No Colab, **sem fechar a sessão**, enviem os dois (pasta à esquerda → upload). `list.files()` tem que mostrá-los soltos, com esses nomes exatos.
3. Rodem, numa célula:
   ```r
   anexar_estado("00_FICHA_PROJETO.md")             # o estado do R vai para a ficha
   anexar_estado("aula05b_parteD_consolidado.md")   # e para o consolidado do grupo
   ```
4. Baixem (três pontinhos → *Fazer download*): os dois `.md`; o **`config.R`** (mudou: tem `limiar`, e `juizes` se houver mais de um juiz); e o **notebook** (*Arquivo → Fazer download → Baixar o .ipynb*), salvando-o como **`aula05b.ipynb`**. Arquivos de dados novos: nenhum nesta aula — os `qrels` já estão no repositório.
5. No GitHub, abram cada pasta e enviem (*Add file → Upload files*; mesmo nome substitui): `consolidados/` ← `00_FICHA_PROJETO.md` e `aula05b_parteD_consolidado.md`; `estrutura/codigo/` ← `config.R` e `aula05b.ipynb`.
6. Confiram no GitHub que a ficha termina com a seção "Estado do R" e que o `config.R` tem o campo `limiar` (e `juizes`, se for o caso).
7. Confiram que a seção 6 da ficha e o `config.R` dizem a mesma coisa: o mesmo limiar, a mesma ordem de juízes.
8. Cada integrante envia o **seu** consolidado individual da teoria (`aula05b_consolidado.md`) para `consolidados/<seu nome>/`.

Se o grupo disser que já fez, pergunte só: *"a ficha no GitHub termina com a seção 'Estado do R'?"*
