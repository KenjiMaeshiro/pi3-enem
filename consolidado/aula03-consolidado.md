# Aula 03 — Consolidado
## Pré-processamento, Tokenização e Índice Invertido

### 1. O que aprendi

Nesta aula, aprendi como o pré-processamento ajuda um motor de busca a organizar e recuperar informações.

Entendi que a limpeza dos textos é importante para evitar que pontuações, letras maiúsculas e espaços desnecessários prejudiquem a identificação das palavras.

Também aprendi a remover *stopwords*, que são palavras muito comuns, e a utilizar *stemming* para aproximar palavras que possuem radicais semelhantes.

Estudei três tipos de tokenização: por palavras, por caracteres e por subpalavras. No algoritmo BPE, compreendi que os pares de símbolos mais frequentes são unidos progressivamente.

### 2. Índice invertido

Aprendi que um índice invertido associa cada termo aos documentos em que ele aparece.

Isso permite que o motor de busca encontre documentos sem precisar examinar todo o conjunto de textos a cada pesquisa.

Na prática, construí um índice invertido em R utilizando listas e estruturas de repetição.

Também compreendi a importância da função `unique()`, que evita adicionar o mesmo documento várias vezes à lista de um termo.

### 3. Busca AND

Aprendi a utilizar a função `intersect()` para encontrar documentos presentes em duas listas.

Depois, utilizei `Reduce(intersect, ...)` para realizar buscas AND com vários termos.

Compreendi que a busca AND retorna apenas os documentos que contêm todos os termos pesquisados.

### 4. Dificuldades e descobertas

Uma descoberta importante foi perceber que o stemming não compreende o significado das palavras, mas aplica regras para reduzir suas formas.

Também entendi a diferença entre contar quantas vezes uma palavra aparece e contar quantos documentos contêm essa palavra.

### 5. Conclusão

Ao final da aula, consegui compreender como a limpeza, a tokenização e a construção de índices invertidos contribuem para um motor de busca mais eficiente.

Esses conhecimentos serão importantes para desenvolver o sistema de recuperação de informações do projeto PI3-ENEM.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-13 01:01 · R version 4.6.1 (2026-06-24) · motor03 v1 2026-10-01 · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `bruto_tf` | matrix | 48 × 8 | linhas: (como, a, acelera, ... \| colunas: d1, d2, d3, d4, ... |
| `brutos` | character, nomeado | 8 | d1 Recuperacao de Informacao: ..., d2 O modelo de espaco-vetorial..., d3 BM25 e um modelo probabilis..., d4 Aprendizado estatistico fun..., d5 O indice invertido acelera ..., d6 Embeddings capturam a seman..., ... |
| `cfg` | list | 0 | elementos: (sem nomes) |
| `d` | character | 1 | d8 |
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `freq` | numeric, nomeado | 4 | praias 5, ilhas 4, ruas 3, praia 2 |
| `ix$tokens` | list | 8 | elementos: d1, d2, d3, d4, d5, d6, d7, d8 |
| `ix$vocab` | character | 45 | a, acelera, aprendizado, avaliacao, bm25, busca, ... |
| `ix$tf` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$N` | integer | 1 | 8 |
| `ix$df` | numeric, nomeado | 45 | a 4, acelera 1, aprendizado 1, avaliacao 1, bm25 1, busca 2, ... |
| `ix$idf_tfidf` | numeric, nomeado | 45 | a 0.6931, acelera 2.079, aprendizado 2.079, avaliacao 2.079, bm25 2.079, busca 1.386, ... |
| `ix$w` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `ix$wn` | matrix | 45 × 8 | linhas: a, acelera, aprendizado, ... \| colunas: d1, d2, d3, d4, ... |
| `limpos` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `MOTOR_VERSAO` | character | 1 | motor03 v1 2026-10-01 |
| `p_sem$recuperacao` | character | 2 | d1, d4 |
| `p_sem$de` | character | 6 | d1, d2, d3, d3, d6, d8 |
| `p_sem$informacao` | character | 1 | d1 |
| `p_sem$ordena` | character | 1 | d1 |
| `p_sem$documentos` | character | 4 | d1, d2, d5, d6 |
| `p_sem$por` | character | 1 | d1 |
| `p_sem$relevancia` | character | 2 | d1, d7 |
| `p_sem$o` | character | 2 | d2, d5 |
| `p_sem$modelo` | character | 2 | d2, d3 |
| `p_sem$espaco` | character | 1 | d2 |
| `p_sem$vetorial` | character | 1 | d2 |
| `p_sem$representa` | character | 1 | d2 |
| `p_sem$como` | character | 1 | d2 |
| `p_sem$vetores` | character | 1 | d2 |
| `p_sem$bm25` | character | 1 | d3 |
| `p_sem$e` | character | 3 | d3, d6, d8 |
| `p_sem$um` | character | 1 | d3 |
| `p_sem$probabilistico` | character | 1 | d3 |
| `p_sem$ranqueamento` | character | 1 | d3 |
| `p_sem$texto` | character | 1 | d3 |
| `p_sem$aprendizado` | character | 1 | d4 |
| `p_sem$estatistico` | character | 1 | d4 |
| `p_sem$fundamenta` | character | 1 | d4 |
| `p_sem$a` | character | 5 | d4, d5, d6, d7, d7 |
| `p_sem$moderna` | character | 1 | d4 |
| `p_sem$indice` | character | 1 | d5 |
| `p_sem$invertido` | character | 1 | d5 |
| `p_sem$acelera` | character | 1 | d5 |
| `p_sem$busca` | character | 2 | d5, d7 |
| `p_sem$em` | character | 1 | d5 |
| `p_sem$muitos` | character | 1 | d5 |
| `p_sem$embeddings` | character | 1 | d6 |
| `p_sem$capturam` | character | 1 | d6 |
| `p_sem$semantica` | character | 1 | d6 |
| `p_sem$palavras` | character | 1 | d6 |
| `p_sem$avaliacao` | character | 1 | d7 |
| `p_sem$mede` | character | 1 | d7 |
| `p_sem$dos` | character | 1 | d7 |
| `p_sem$resultados` | character | 1 | d7 |
| `p_sem$da` | character | 1 | d7 |
| `p_sem$ciencia` | character | 1 | d8 |
| `p_sem$dados` | character | 1 | d8 |
| `p_sem$combina` | character | 1 | d8 |
| `p_sem$estatistica` | character | 1 | d8 |
| `p_sem$programacao` | character | 1 | d8 |
| `palavras` | character, nomeado | 4 | praias p r a i as, ilhas i l h as, ruas r u as, praia p r a i a |
| `postings$recuperacao` | character | 2 | d1, d4 |
| `postings$informacao` | character | 1 | d1 |
| `postings$ordena` | character | 1 | d1 |
| `postings$documentos` | character | 4 | d1, d2, d5, d6 |
| `postings$relevancia` | character | 2 | d1, d7 |
| `postings$modelo` | character | 2 | d2, d3 |
| `postings$espaco` | character | 1 | d2 |
| `postings$vetorial` | character | 1 | d2 |
| `postings$representa` | character | 1 | d2 |
| `postings$vetores` | character | 1 | d2 |
| `postings$bm25` | character | 1 | d3 |
| `postings$probabilistico` | character | 1 | d3 |
| `postings$ranqueamento` | character | 1 | d3 |
| `postings$texto` | character | 1 | d3 |
| `postings$aprendizado` | character | 1 | d4 |
| `postings$estatistico` | character | 1 | d4 |
| `postings$fundamenta` | character | 1 | d4 |
| `postings$moderna` | character | 1 | d4 |
| `postings$indice` | character | 1 | d5 |
| `postings$invertido` | character | 1 | d5 |
| `postings$acelera` | character | 1 | d5 |
| `postings$busca` | character | 2 | d5, d7 |
| `postings$em` | character | 1 | d5 |
| `postings$muitos` | character | 1 | d5 |
| `postings$embeddings` | character | 1 | d6 |
| `postings$capturam` | character | 1 | d6 |
| `postings$semantica` | character | 1 | d6 |
| `postings$palavras` | character | 1 | d6 |
| `postings$avaliacao` | character | 1 | d7 |
| `postings$mede` | character | 1 | d7 |
| `postings$dos` | character | 1 | d7 |
| `postings$resultados` | character | 1 | d7 |
| `postings$ciencia` | character | 1 | d8 |
| `postings$dados` | character | 1 | d8 |
| `postings$combina` | character | 1 | d8 |
| `postings$estatistica` | character | 1 | d8 |
| `postings$programacao` | character | 1 | d8 |
| `simbolos$praias` | character | 6 | p, r, a, i, a, s |
| `simbolos$ilhas` | character | 5 | i, l, h, a, s |
| `simbolos$ruas` | character | 4 | r, u, a, s |
| `simbolos$praia` | character | 5 | p, r, a, i, a |
| `stopwords` | character | 10 | de, o, a, e, um, por, ... |
| `termo` | character | 1 | programacao |
| `texto` | character | 1 | Olá, Cubatão |
| `texto_sem_acentos` | character | 1 | Ola, Cubatao |

### Funções definidas

`anexar_estado`, `busca_AND`, `busca_booleana`, `cfg_aula`, `cosseno`, `docs_aula`, `estado`, `idf_classico`, `limpar`, `matriz_tf`, `montar`, `norm_cols`, `prep`, `ranking_cosseno`, `sem_stop`, `stem`, `tok`, `tokenizar`, `vetor_consulta`
<!-- estado-R:fim -->

