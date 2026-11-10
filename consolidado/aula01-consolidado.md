# Aula 01 — Recuperação de Informação: do problema da busca ao nosso motor

## Identificação e progresso

- **Aula:** 01 — Recuperação de Informação
- **Ambiente de prática:** R no Google Colab
- **Motor utilizado:** `motor01 v1 2026-10-01`
- **Módulos concluídos:** 10 de 10
- **Avaliação final:** 10 acertos em 10 questões
- **Estado do R:** a ser anexado pelo Colab ao final, usando `anexar_estado()`.

## 1. O que aprendi

### Recuperação de Informação (RI)

Uma consulta tradicional a banco de dados recupera registros que atendem aos critérios definidos. Um sistema de Recuperação de Informação busca documentos potencialmente relevantes e pode ordená-los segundo uma estimativa de relevância.

Em um sistema com muitos documentos, podemos dividir o processamento em duas etapas:

- **Retrieve:** recupera rapidamente um conjunto menor de candidatos.
- **Rerank:** reavalia e ordena os candidatos usando um método mais sofisticado, evitando aplicá-lo a todos os documentos.

### Documentos e indexação no R

Os documentos foram organizados em um vetor nomeado `docs`, com identificadores de `d1` a `d8`.

```r
length(docs)       # 8 documentos
docs["d5"]        # retorna vetor com nome d5
docs[["d5"]]      # retorna o texto sem preservar o nome
```

Em R, os índices numéricos começam em 1. O operador `[` preserva o nome de um elemento de vetor nomeado; `[[` extrai seu conteúdo.

### Tokenização, vocabulário e frequências

A função `tokenizar()` transforma o texto em termos normalizados. Para o corpus da aula:

```r
tokens <- lapply(docs, tokenizar)
vocab <- sort(unique(unlist(tokens)))
freq <- table(unlist(tokens))

length(vocab)                    # 45 termos distintos
sum(lengths(tokens))            # 64 ocorrências no total
sort(freq, decreasing = TRUE)[1:6]
```

As seis palavras mais frequentes observadas foram:

| Termo | Frequência total |
|---|---:|
| de | 6 |
| a | 5 |
| documentos | 4 |
| e | 3 |
| busca | 2 |
| modelo | 2 |

**Distinção importante:** frequência total é o número de ocorrências; tamanho do vocabulário é o número de termos diferentes. Adicionar `"porto de santos"` ao corpus eleva o vocabulário de 45 para 47 termos, pois `porto` e `santos` são novos. Adicionar `"busca busca busca"` eleva a frequência de `busca` de 2 para 5, mas mantém o vocabulário com 45 termos.

### Matriz termo-documento (TDM)

Na matriz termo-documento, as **linhas** são termos, as **colunas** são documentos e cada célula registra quantas vezes o termo aparece no documento.

```r
tdm <- sapply(tokens, function(tk) {
  as.integer(table(factor(tk, levels = vocab)))
})
rownames(tdm) <- vocab

dim(tdm)               # 45 8
tdm["a", "d7"]         # 2
tdm["de", "d3"]        # 2
tdm["modelo", ]        # d2 e d3: 1; demais: 0
colSums(tdm)           # 7 9 9 6 9 8 9 7
```

`factor(tk, levels = vocab)` assegura que todos os documentos tenham 45 posições, inclusive zeros para termos ausentes. Sem comprimentos iguais, `sapply()` não conseguiria simplificar esses vetores em uma matriz regular.

### Busca booleana

A busca booleana retorna documentos que contêm um termo, sem ordenar os resultados por relevância.

```r
busca_booleana <- function(termo, tdm) {
  termo <- tolower(termo)
  if (!termo %in% rownames(tdm)) return(character(0))
  colnames(tdm)[tdm[termo, ] > 0]
}

busca_booleana("MODELO", tdm)   # d2, d3
busca_booleana("xyz", tdm)      # character(0)

# Operador lógico E (AND): documentos que contêm ambos os termos
intersect(
  busca_booleana("documentos", tdm),
  busca_booleana("busca", tdm)
)                               # d5
```

`tolower()` normaliza maiúsculas e minúsculas; `character(0)` representa um resultado vazio; `intersect()` mantém apenas os documentos presentes em ambos os resultados.

### TF, DF, IDF e TF-IDF

- **TF (Term Frequency):** quantidade de ocorrências de um termo em um documento específico.
- **DF (Document Frequency):** número de documentos diferentes que contêm o termo.
- **IDF (Inverse Document Frequency):** mede a raridade do termo no conjunto de documentos.
- **TF-IDF:** combina frequência no documento com raridade no corpus para atribuir um peso ao termo.

Fórmulas usadas na aula:

\[
IDF(t) = \log\left(\frac{N}{df_t}\right)
\]

\[
TF\text{-}IDF(t,d) = TF(t,d) \times IDF(t)
\]

Com oito documentos, um termo presente em todos tem IDF igual a zero. Um termo presente em apenas um documento tem IDF aproximadamente 2,08.

```r
N <- ncol(tdm)
df <- rowSums(tdm > 0)
idf <- log(N / df)
tfidf <- tdm * idf

round(idf["modelo"], 2)                 # 1.39
round(tfidf["modelo", "d3"], 2)         # 1.39
round(max(idf), 2)                     # 2.08
round(idf[c("de", "documentos", "recuperacao", "bm25")], 2)
# de: 0.47; documentos: 0.69; recuperacao: 1.39; bm25: 2.08
```

`tdm` guarda frequências; `tfidf` guarda pesos calculados a partir das frequências e da raridade dos termos. Um termo com TF = 2 e DF = 1 em um corpus de oito documentos recebe aproximadamente `2 × log(8) = 4,16`.

### Busca por padrão (`grep`) versus busca booleana

```r
grep("recupera", docs)              # posições 1 e 4
busca_booleana("recupera", tdm)     # character(0)

grep("busca", docs)                # posições 5 e 7
busca_booleana("busc", tdm)        # character(0)
```

`grep()` encontra sequências de caracteres dentro dos textos, inclusive como parte de palavras maiores. A busca booleana implementada consulta termos completos do vocabulário. `grep()` retorna posições dos documentos; `busca_booleana()` retorna seus identificadores.

## 2. Minha reflexão sobre a aula

### Conceito mais importante

> Acho que foi TF-IDF, porque ele é um cálculo bastante importante no motor de busca.

O TF-IDF permite calcular pesos dos termos a partir da frequência no documento e da raridade no conjunto de documentos, sendo útil para a recuperação de informações.

### Dificuldade superada

No início, confundi TF com DF. Depois compreendi que:

> TF é o cálculo da frequência com que um termo aparece em um só documento, e DF é a quantidade de documentos em que aquele termo aparece.

### Aplicação no projeto do ENEM

> O TF-IDF ajudaria a destacar documentos relevantes sobre determinado tópico do ENEM. Por exemplo, ao pesquisar sobre a redação do ENEM, daria mais destaque a documentos que abordam esse assunto, facilitando a pesquisa.

Essa é uma aplicação possível de pesos TF-IDF, lembrando que o método depende das palavras usadas e não compreende sozinho o significado completo dos textos.

## 3. Avaliação final

**Resultado: 10/10 questões corretas.**

| Questão | Tema | Resultado |
|---|---|---|
| 1 | Banco de dados versus Recuperação de Informação | Correta |
| 2 | Retrieve e Rerank | Correta |
| 3 | Indexação com `[` e `[[` | Correta |
| 4 | Tokenização e `unique()` | Correta |
| 5 | Vocabulário e frequência total | Correta |
| 6 | Consultas à TDM e `colSums()` | Correta |
| 7 | Busca booleana com `intersect()` | Correta |
| 8 | Cálculo de TF-IDF | Correta |
| 9 | Diferença entre TDM e TF-IDF | Correta |
| 10 | Busca com `grep()` e busca booleana | Correta |

## 4. Próximo passo: anexar o estado do R

Este arquivo registra o conteúdo e os resultados da aula. O bloco de estado do R deve ser gerado **no próprio ambiente Colab**, sem inventar objetos ou funções.

1. Salvar este texto como `aula01_consolidado.md` e disponibilizá-lo no ambiente de arquivos do Colab.
2. Confirmar que o motor foi carregado e que o arquivo está no diretório de trabalho.
3. Executar:

```r
anexar_estado("aula01_consolidado.md")
```

4. Conferir se o arquivo atualizado contém o bloco delimitado por `<!-- estado-R:inicio -->` e `<!-- estado-R:fim -->`.
5. Baixar o arquivo consolidado atualizado e guardá-lo para a continuidade do projeto.

> **Importante:** não adicionar manualmente um estado fictício do R; ele será produzido pela função `anexar_estado()`.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-10 15:09 · R version 4.6.1 (2026-06-24) · motor01 v1 2026-10-01 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `docs9` | character, nomeado | 9 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `freq` | table, nomeado | 45 | a 5, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `idf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `MOTOR_VERSAO` | character | 1 | motor01 v1 2026-10-01 |
| `N` | integer | 1 | 8 |
| `tdm` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `texto` | character | 1 | Modelo modelo MODELO |
| `tfidf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `tokens` | character | 3 | modelo, modelo, modelo |
| `vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |

### Funções definidas

`anexar_estado`, `busca_booleana`, `estado`, `tokenizar`
<!-- estado-R:fim -->

