# Aula 01 — Parte D | Consolidado

**Grupo:** Enem  
**Projeto:** Motor de busca para comparação dos portos de Santos, Xangai e Roterdão  
**Repositório:** https://github.com/KenjiMaeshiro/pi3-enem  
**Arquivo sugerido no repositório:** `consolidado/aula01_parteD_consolidado.md`

## 1. Objetivo

Registrar as decisões do grupo, a coleta e organização de textos e os primeiros procedimentos de recuperação de informação estudados na Aula 01 — Parte D. Este consolidado descreve os arquivos apresentados e os resultados verificados durante a revisão, sem substituir o corpus nem os códigos já existentes.

## 2. Módulo 11 — Definições do projeto

- **Tema:** comparação entre os portos de Santos, Xangai e Roterdão, considerando história, infraestrutura, movimentação de cargas e aspectos logísticos.
- **Relação com a Baixada Santista:** o Porto de Santos integra a comparação.
- **Público-alvo:** estudantes e pesquisadores interessados na comparação dos portos.
- **Necessidades de informação discutidas:** (1) qual dos três portos tem maior movimentação de cargas; (2) quando o Porto de Santos se originou; (3) como se compara a capacidade de cargas dos três portos.
- **Fonte escolhida:** Wikipédia em português, com atenção às condições de atribuição e compartilhamento da licença CC BY-SA.
- **Unidade documental:** parágrafo; no código da Aula 01, são mantidos parágrafos com pelo menos 10 palavras.
- **Repositório:** `KenjiMaeshiro/pi3-enem`, usado para preservar e compartilhar os arquivos do grupo.

**Observação:** movimentação efetiva de cargas e capacidade de movimentação são conceitos diferentes; uma busca ou análise comparativa deve distinguir essas medidas.

## 3. Módulo 12 — Coleta e organização do corpus

### 3.1 Arquivos analisados

- `config.R`: contém a lista `cfg` com parâmetros do projeto, incluindo `minimo = 10`, opções de limpeza e parâmetros de modelos de recuperação de informação de aulas posteriores.
- `aula01.R`: contém a coleta dos artigos, a separação e filtragem dos parágrafos e as rotinas iniciais de processamento e busca.

### 3.2 Fonte e coleta

A função `baixar_sites(titulo)` usa o pacote `httr2` para consultar a API da Wikipédia em português e recuperar o texto do artigo. Os títulos presentes no código são:

```r
titulos <- c("Porto_de_Santos", "Porto_de_Xangai", "Porto_de_Roterdão")
docs <- lapply(titulos, baixar_sites)
```

Na revisão prática, uma consulta ao artigo **Porto de Santos** retornou texto iniciado por `Porto de Santos é um porto estuarino...`, e `nchar(texto)` retornou **17127** caracteres naquela execução. Esse número corresponde ao texto consultado naquele momento, não ao tamanho de um documento-parágrafo.

### 3.3 Formação dos documentos

No `aula01.R`, os textos são divididos nas quebras de linha (`strsplit(..., "\n")`), os trechos vazios são removidos e os parágrafos são reunidos em uma tabela. O filtro utiliza:

```r
corpus <- corpus |>
  mutate(n_palavras = str_count(paragrafo, "\\S+")) |>
  filter(n_palavras >= 10) |>
  select(-n_palavras)
```

Os identificadores são criados com `paste0("paragrafo", 1:nrow(corpus))`. Como a identificação ocorre antes do filtro, a numeração pode apresentar saltos após a remoção de parágrafos.

O `config.R` também registra `cfg$minimo = 10`, mas o trecho do `aula01.R` usa o valor literal `10`; portanto, nessa versão do código, alterar apenas `cfg$minimo` **não altera automaticamente** o filtro.

### 3.4 Estrutura do arquivo RDS inspecionado

Na sessão de revisão, a leitura de `estrutura/banco-de-dados/docs.rds` apresentou:

```r
class(docs)
# [1] "character"

str(docs)
# Named chr [1:75] ...
# - attr(*, "names") = chr [1:75] "paragrafo1" "paragrafo2" ...
```

Assim, **o arquivo inspecionado contém um vetor nomeado de 75 textos**, não um `data.frame`. Nesse caso, `length(docs)` corresponde a **75 documentos**.

**Controle de versões:** a ficha do projeto também registra uma versão posterior do corpus com **60 documentos** (20 por porto), utilizada em etapas posteriores. Não se deve tratar os números 75 e 60 como resultados do mesmo corpus sem indicar a versão. Este consolidado não altera nem reconstrói esses arquivos.

### 3.5 Persistência

Arquivos `.rds` podem ser salvos com `saveRDS()` e lidos com `readRDS()`. Como o ambiente de execução do Colab pode ser temporário, é importante manter cópias persistentes no repositório ou em outro armazenamento apropriado. Durante esta revisão, os arquivos existentes foram apenas inspecionados.

## 4. Módulo 13 — Processamento e recuperação

### 4.1 Tokenização

O código apresentado define:

```r
tokenizar <- function(texto) {
  texto <- tolower(texto)
  unlist(strsplit(texto, "\\s+"))
}
```

Essa função converte o texto para minúsculas e o divide por espaços em branco. **Ela não remove automaticamente pontuação nem acentos.** A configuração de limpeza de aulas posteriores no `config.R` não significa que essa função específica já execute toda aquela limpeza.

### 4.2 Vocabulário

```r
vocab <- sort(unique(unlist(tokens)))
```

`unlist()` reúne os tokens; `unique()` elimina repetições; `sort()` organiza os termos distintos em ordem alfabética.

### 4.3 Frequência total

```r
frequencia <- table(unlist(tokens))
freq_sorted <- sort(frequencia, decreasing = TRUE)
top10 <- head(freq_sorted, 10)
```

`table()` contabiliza as ocorrências dos termos em todo o corpus. O código permite examinar os dez mais frequentes; os valores reais desse `top10` não foram fornecidos na revisão e, portanto, não são reproduzidos aqui.

### 4.4 Matriz termo-documento

```r
tdm <- sapply(tokens, function(t)
  as.integer(table(factor(t, levels = vocab)))
)
rownames(tdm) <- vocab
```

A matriz possui **termos nas linhas** e **documentos nas colunas**. Cada célula informa quantas vezes o termo aparece no documento. Na revisão, foi utilizado um exemplo didático em que o documento `d3` continha `porto`, `porto`, `santos`; nesse caso, as frequências eram `porto = 2`, `santos = 1`, `de = 0` e `xangai = 0`.

### 4.5 Busca booleana por um termo

```r
busca_booleana <- function(termo, tdm) {
  if (!termo %in% rownames(tdm)) return(character(0))
  colnames(tdm)[tdm[termo, ] > 0]
}
```

A função retorna os identificadores dos documentos nos quais o termo ocorre pelo menos uma vez. Quando o termo não está no vocabulário, retorna `character(0)`. Trata-se, nesta implementação, de **busca por um termo**, não de uma implementação completa de operadores booleanos `AND`, `OR` e `NOT`.

No exemplo didático trabalhado na revisão, `busca_booleana("porto", tdm)` retornaria `d1`, `d2` e `d3`, enquanto um termo inexistente como `aeroporto` retornaria um vetor vazio. Esses são **exemplos de aprendizagem**, não resultados medidos no corpus real.

## 5. Resultados da revisão

- Foi compreendido o papel da API da Wikipédia na obtenção de texto.
- Foi confirmada a diferença entre artigo completo, parágrafo-documento e corpus.
- Foi inspecionada a estrutura do `docs.rds` disponível na sessão: vetor nomeado de 75 textos.
- Foram revisadas tokenização, vocabulário, frequência total, matriz termo-documento e busca por um termo.
- Foi identificada a necessidade de distinguir o corpus inicial de 75 documentos da versão posterior de 60 documentos.
- Nenhum arquivo existente do projeto foi sobrescrito durante a elaboração deste consolidado.

## 6. Observações e próximos cuidados

1. Conferir, ao executar o projeto, se o arquivo RDS carregado corresponde à versão do corpus desejada.
2. Preservar a origem dos documentos e a atribuição exigida pela fonte.
3. Se o grupo decidir integrar o `config.R` ao filtro da Aula 01, avaliar conscientemente a substituição de `10` por `cfg$minimo`; isso **não foi feito** nesta revisão.
4. Verificar os resultados reais de `top10`, `dim(tdm)` e das consultas no ambiente do projeto antes de registrá-los como medições.
5. Revisar este consolidado com o grupo antes de adicioná-lo à pasta `consolidado/` no GitHub.

## 7. Arquivos relacionados

- `config.R`
- `aula01.R`
- `estrutura/banco-de-dados/docs.rds` (arquivo inspecionado na revisão)
- Ficha do projeto do grupo Enem
- `consolidado/aula01_consolidado.md` (consolidado da Aula 01 principal, mantido separadamente)

---

**Status:** rascunho do consolidado da Aula 01 — Parte D, preparado para revisão do grupo antes do envio ao repositório.
