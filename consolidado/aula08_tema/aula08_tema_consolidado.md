# Consolidado — PI III — Aula 08 — Tema 2 (frase exata) — 25/11/2026

*guia versão 1 · tutora: ChatGPT (GPT-6) · sessão individual · motor08*

**Aluno:** Ana Luiza Bispo Aguiar

## 1. O que foi passado

- **M1 — índice posicional e frase exata:** compreendi que a busca por frase verifica se todas as palavras aparecem em sequência e na ordem correta. No exemplo do guia, ninguém possui a frase inteira `"modelo de recuperacao"`, mas `"modelo de"` aparece em `d2`. Também estudei como calcular as posições usando interseções.

- **M2 — frase e maior trecho:** observei que utilizar somente a frase exata não altera o ranking quando nenhum documento possui a expressão completa. O maior trecho permite considerar sequências menores da consulta. No exemplo do guia, `d2` apresenta um trecho de $\frac{2}{3}$, enquanto `d3` e `d1` apresentam $\frac{1}{3}$. O resultado pode melhorar com o trecho, dependendo da consulta e do valor de $k$.

- **M3 — rigidez da busca:** compreendi que stopwords, acentos e plurais podem alterar os resultados. Ao remover stopwords, expressões diferentes podem se tornar iguais. A configuração de acentos pode transformar `"recuperação"` em `"recupera o"` quando não utiliza transliteração. Além disso, palavras no singular e plural não são consideradas iguais automaticamente.

- **M4 — corpus do grupo:** trabalhamos com o corpus de 60 documentos e 11 consultas de desenvolvimento. O conjunto de teste estava vazio. No experimento anterior do grupo, o BM25 apresentou MAP de $0{,}907$, a busca por frase manteve $0{,}907$ e o método de trechos com $k=3$ apresentou $0{,}862$. Com $k=5$, o MAP foi $0{,}843$ e, com $k=10$, foi $0{,}821$. A decisão registrada foi não utilizar o reordenamento por frase ou por trechos.

**Execução no Colab em 25/11/2026:** carreguei o motor08, as configurações e os arquivos do grupo. Construí o índice dos 60 documentos e testei as funções `frase()`, `aspas()` e `busca_aspas()`. Na pesquisa por `"porto de roterdao"`, foram encontrados três documentos. Também comparei o resultado com a busca normal do BM25, que apresentou os dez primeiros documentos.

## 2. Como foi o aprendizado — opinião da tutora

Durante a atividade, percebi que o aluno compreendeu bem a lógica da frase exata e conseguiu identificar quando as palavras estavam ou não em posições consecutivas. Também respondeu corretamente às perguntas sobre desempate, comparação de tokens, funcionamento do BM25 e interpretação do MAP. Na parte prática, conseguiu executar os comandos no Google Colab, carregar os arquivos, preparar os documentos e construir o índice. Os testes mostraram que compreendeu a diferença entre uma busca normal e uma busca com aspas. O principal ponto reforçado foi que uma técnica adicional não significa necessariamente uma melhoria na recuperação de informação: é necessário comparar os resultados antes de adotá-la.

**Revisão final:** acertou as perguntas de revisão sobre frase exata, desempate, acentos e plurais, método de trechos e MAP. A execução prática das funções de frase e busca por aspas também foi concluída.

## 3. Observações para a frente

- **Revisar:** a diferença entre frase exata e maior trecho; o funcionamento do índice posicional; os efeitos das stopwords, dos acentos e dos plurais; a interpretação do MAP.
- **Perguntas guardadas:** nenhuma.
- **Para o grupo:** apresentar os resultados comparativos do BM25, da busca por frase e do método de trechos. Destacar que o BM25 inicial apresentou o melhor resultado geral e que o conjunto de teste estava vazio, portanto não houve validação independente.
- **Execução:** os testes práticos de frase exata foram realizados novamente no Google Colab em 25/11/2026, utilizando o motor08, pois o motor09 indicado originalmente no guia não estava disponível no repositório.