# Aula 00 — Consolidado da parte teórica

## 1. Conteúdos estudados

1. **Vetores e indexação:** criação com `c()`, acesso com `[]` e índices iniciados em 1.
2. **Vetores nomeados:** uso de `names()`, seleção por nome e diferença entre `[` e `[[`.
3. **Manipulação de texto:** `nchar()`, `length()`, `toupper()`, `tolower()`, `substr()`, `paste()` e `paste0()`.
4. **Separação de palavras:** `strsplit()` produz uma lista; `unlist()` transforma seus elementos em vetor.
5. **Funções próprias:** criação de funções com `function()`, incluindo uma função de tokenização.
6. **Aplicação de funções:** `lapply()` retorna lista; `sapply()` simplifica resultados; contagem de palavras por documento.
7. **Frequências:** `table()`, `sort()`, `factor()` e `%in%` para contar e consultar termos.
8. **Matrizes:** criação com `matrix()`, preenchimento por colunas e operações com vetores.
9. **Expressões regulares:** `grep()`, `grepl()`, `^`, `$`, `|`, classes de caracteres e padrões de espaços.
10. **Limpeza de texto:** `trimws()`, `tolower()`, `sub()` e `gsub()`; importância da ordem das operações.
11. **Recuperação simples:** combinação de `names(docs)` e `grepl()` para identificar documentos que contêm termos.

## 2. Aprendizagem e desempenho

- **Teste final:** 11 acertos em 11 questões, respondidas sem executar os exemplos antes da previsão.
- **Pontos consolidados:** indexação a partir de 1, seleção em vetores nomeados, distinção entre `nchar()` e `length()`, matrizes e seleção de documentos com regex.
- **Dúvidas superadas durante a aula:** `length()` de uma lista conta seus elementos, não todas as palavras dentro deles; `sub()` substitui a primeira ocorrência e `gsub()` substitui todas.
- **Estratégia de estudo:** prever a saída de cada comando, executar no R e comparar com o resultado observado.

## 3. Produzido e conexão com a próxima aula

- Corpus de estudo `docs`, com documentos nomeados de `d1` a `d8`.
- Função `tokenizar()` e aplicação de `lapply()` para separar textos em palavras.
- Contagens de palavras e frequências com `table()`.
- Expressões regulares para localizar padrões e documentos.
- **Próxima etapa:** reutilizar tokenização, frequências e matrizes para construir uma representação termo-documento na Aula 01.

> Este consolidado foi reconstruído a partir do histórico da tutoria. A seção **Estado do R** não foi inserida aqui: ela será acrescentada automaticamente pela função `anexar_estado()` no Colab.

---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-04 00:03 · R version 4.6.1 (2026-06-24) · sem motor · não edite à mão*

### Objetos

| objeto | tipo | tamanho | valor / amostra |
|---|---|---|---|
| `docs` | character, nomeado | 8 | d1 recuperacao de informacao o..., d2 o modelo de espaco vetorial..., d3 bm25 e um modelo probabilis..., d4 aprendizado estatistico fun..., d5 o indice invertido acelera ..., d6 embeddings capturam a seman..., ... |
| `f` | character, nomeado | 3 | f1   Gosto de jogar    basebal..., f2 o meu irmão tem 20 anos de ..., f3 Eu gosto de  estudar utiliz... |
| `freq` | table, nomeado | 17 | anos 1, baseball 1, caneta 1, de 3, e 2, estudar 1, ... |
| `m` | matrix | 2 × 2 | linhas: (sem nomes) \| colunas: (sem nomes) |
| `texto` | character | 2 | bm25, modelo |
| `tokens$f1` | character | 6 | gosto, de, jogar, baseball, e, futebol |
| `tokens$f2` | character | 7 | o, meu, irmo, tem, anos, de, ... |
| `tokens$f3` | character | 8 | eu, gosto, de, estudar, utilizando, papel, ... |
| `x` | character, nomeado | 3 | f1 gosto_de_jogar_baseball_e_f..., f2 o_meu_irmo_tem_anos_de_idade, f3 eu_gosto_de_estudar_utiliza... |

### Funções definidas

`anexar_estado`, `estado`, `tokenizar`
<!-- estado-R:fim -->

