# Aula 02 — Consolidado individual

## 1. Conteúdos estudados

1. **Limitação da soma TF-IDF:** repetir o texto aumenta TF e pode aumentar a soma dos pesos, mesmo sem acrescentar informação.
2. **Espaço vetorial:** cada termo do vocabulário corresponde a uma dimensão; os documentos são vetores de frequências ou pesos.
3. **Estrutura do índice `ix`:** `ix$tf` contém frequências, `ix$w` contém pesos TF-IDF e `ix$idf_tfidf` contém os pesos IDF.
4. **Similaridade do cosseno:** comparação da direção dos vetores por meio do produto escalar dividido pelo produto de suas normas.
5. **Normalização:** divisão de cada vetor por sua norma, produzindo vetores não nulos de comprimento 1.
6. **Vetor da consulta:** contagem dos termos da consulta nas posições do vocabulário e multiplicação pelo IDF.
7. **Ranking:** cálculo da similaridade entre a consulta e cada documento, seguido de ordenação decrescente.
8. **Limitações semânticas:** o modelo não reconhece automaticamente sinônimos, como `carro` e `automovel`.

## 2. Códigos R trabalhados

```r
# Motor e índice usados na aula
source("https://raw.githubusercontent.com/fractalarea/pi3-motor-de-busca/main/motor/motor02.R")
docs <- docs_aula()
cfg <- cfg_aula()
ix <- montar(docs, cfg)

# Similaridade do cosseno
cosseno <- function(a, b) {
  den <- sqrt(sum(a^2)) * sqrt(sum(b^2))
  if (den == 0) return(0)
  sum(a * b) / den
}

# Normalização das colunas
norm_cols <- function(m) {
  nrm <- sqrt(colSums(m^2))
  nrm[nrm == 0] <- 1
  sweep(m, 2, nrm, "/")
}
wn <- norm_cols(ix$w)

# Vetor TF-IDF da consulta
vetor_consulta <- function(termos, vocab, idf) {
  q <- as.integer(table(factor(termos, levels = vocab)))
  q * idf
}

# Ranking por similaridade do cosseno
ranking_cosseno <- function(consulta, ix) {
  qw <- vetor_consulta(tokenizar(consulta), ix$vocab, ix$idf_tfidf)
  s <- apply(ix$w, 2, function(d) cosseno(qw, d))
  sort(s, decreasing = TRUE)
}
```

## 3. Experimentos e resultados

- `dim(ix$tf)` retornou **45 × 8**: 45 termos e 8 documentos.
- `ix$w["e", "d6"]` retornou **0.980829253011726**; o cálculo previsto foi aproximadamente 0,98.
- `cosseno(c(1, 1), c(4, 2))` retornou **0.948683298050514**. Duplicar as coordenadas não altera a direção nem o cosseno.
- Após normalizar `ix$w`, as normas das oito colunas de `wn` ficaram iguais a 1 (dentro da precisão numérica).
- A similaridade entre `d2` e `d3` foi **0.0917067257924901** com vetores normalizados e **0.09170672579249** com a função `cosseno` aplicada aos vetores originais.
- Na consulta `busca busca abc`, somente `busca` recebeu peso positivo; `abc` não estava no vocabulário.

### Ranking da consulta `modelo de recuperacao`

| Posição | Documento | Similaridade |
|---:|---|---:|
| 1 | d1 | 0.253937581059294 |
| 2 | d3 | 0.232680271617961 |
| 3 | d4 | 0.214777354976216 |
| 4 | d2 | 0.207776325646027 |
| 5 | d6 | 0.0248512163451214 |
| 6 | d8 | 0.0229455459106457 |
| 7 | d5 | 0 |
| 8 | d7 | 0 |

### Ranking da consulta `modelo recuperacao`

| Posição | Documento | Similaridade |
|---:|---|---:|
| 1 | d1 | 0.234211365954964 |
| 2 | d4 | 0.220863052149693 |
| 3 | d3 | 0.194548373917446 |
| 4 | d2 | 0.191635979360206 |
| 5 | d5 | 0 |
| 6 | d6 | 0 |
| 7 | d7 | 0 |
| 8 | d8 | 0 |

**Interpretação:** remover `de` zerou as pontuações de `d6` e `d8` e fez `d4` ultrapassar `d3`.

## 4. Aprendizagem e desempenho

- **Avaliação final:** 8 acertos em 8 questões.
- **Pontos consolidados:** diferença entre TF e IDF; interpretação das coordenadas de vetores; produto escalar e normas; normalização; criação de vetores de consulta; ordenação por similaridade.
- **Dúvidas trabalhadas:** cálculo da raiz quadrada na norma, quadrado de coordenadas e interpretação do efeito de repetir termos.
- **Estratégia de estudo:** prever os resultados, executar os comandos no R e comparar a saída com a previsão.

## 5. Escopo e observações

Este documento registra **somente a parte individual da Aula 02**. A Parte D (atividade em grupo) será consolidada separadamente. O mesmo ambiente do Google Colab foi utilizado para a Aula 01 — Parte D; por isso, o estado do R pode incluir objetos e funções de outras atividades.

## 6. Estado do R

A seção abaixo deve ser inserida ou atualizada **automaticamente no Colab** por `anexar_estado()`, para refletir o ambiente no momento de salvar o consolidado. Não é uma transcrição manual do estado.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-12 00:56 · R version 4.6.1 (2026-06-24) · motor02 v1 2026-10-01 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `cfg` | list | 0 | elementos: (sem nomes) |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `ix$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$N` | integer | 1 | 8 |
| `ix$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `MOTOR_VERSAO` | character | 1 | motor02 v1 2026-10-01 |
| `texto` | character | 1 | Porto de Santos é um porto ... |
| `wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |

### Funções definidas

`anexar_estado`, `baixar_wiki`, `busca_booleana`, `cfg_aula`, `cosseno`, `docs_aula`, `estado`, `idf_classico`, `matriz_tf`, `montar`, `norm_cols`, `ranking_cosseno`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

