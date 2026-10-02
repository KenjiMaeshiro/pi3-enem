# Aula 5,5 --- Parte D: Métricas no próprio gabarito

**Aluno:** Pedro Santos\
**Data:** 25/09/2026\
**Tutora:** GPT-5.6 Sol

## Parte 1 --- Módulos 10--12

### Módulo 10 --- Do gabarito ao vetor de relevância

Foi adotado como critério de binarização:

\[ `\text{relevante}`{=tex} `\iff `{=tex}grau `\geq 2`{=tex} \]

A escolha foi feita para utilizar um critério mais rigoroso,
considerando como relevantes apenas os documentos julgados como
efetivamente relevantes.

Documentos não julgados são tratados como grau 0 de acordo com a regra
de *pooling* utilizada no experimento.

Na consulta `q01`, havia 1 documento relevante. TF-IDF e BM25
recuperaram esse documento já na primeira posição.

### Módulo 11 --- As métricas em uma consulta

Para `q01`, foram obtidos:

  Métrica           Booleano   TF-IDF    BM25
  --------------- ---------- -------- -------
  P@3                  0,000    0,333   0,333
  AP                   0,000    1,000   1,000
  MRR                  0,000    1,000   1,000
  nDCG binário         0,000    1,000   1,000
  nDCG graduado        0,000    1,000   1,000

TF-IDF e BM25 empataram nas cinco métricas da `q01`. O Booleano não
recuperou o documento relevante nessa consulta.

O P@3 de TF-IDF e BM25 foi:

\[ P@3 = `\frac{1}{3}`{=tex} = 0{,}333 \]

### Módulo 12 --- Avaliação das consultas

Os resultados médios obtidos foram:

  Modelo         MAP     MRR   nDCG binário   nDCG graduado
  ---------- ------- ------- -------------- ---------------
  Booleano     0,227   0,150          0,238           0,187
  TF-IDF       0,985   0,550          0,993           0,960
  BM25         0,894   0,488          0,920           0,913

As consultas sem documentos conhecidos com grau $\geq 2$ apresentam `NA`
nas métricas que dependem da existência de documentos relevantes. Esses
casos não foram interpretados como valor zero.

------------------------------------------------------------------------

## Parte 2 --- Decisões e interpretação

O limiar de relevância foi escolhido antes da interpretação final dos
resultados:

\[ grau `\geq 2`{=tex} \]

A justificativa foi tornar o critério de relevância mais rigoroso.

Os documentos não julgados foram tratados como grau 0, seguindo a regra
de *pooling* adotada.

Na comparação dos resultados, o TF-IDF apresentou os maiores valores
médios. Entretanto, isso não foi interpretado como prova de
superioridade geral sobre o BM25.

Foram observados diversos empates entre TF-IDF e BM25 nas consultas, e
as diferenças entre os dois modelos são relativamente pequenas em várias
métricas.

Portanto, os resultados devem ser interpretados dentro das condições
específicas deste experimento.

------------------------------------------------------------------------

## Parte 3 --- Produzido

**Limiar utilizado:** grau $\geq 2$.

**Motivo:** considerar como relevantes apenas os documentos julgados
como efetivamente relevantes, adotando um critério mais rigoroso de
binarização.

**Resultados agregados principais:**

-   Booleano: MAP = 0,227; MRR = 0,150; nDCG binário = 0,238; nDCG
    graduado = 0,187.
-   TF-IDF: MAP = 0,985; MRR = 0,550; nDCG binário = 0,993; nDCG
    graduado = 0,960.
-   BM25: MAP = 0,894; MRR = 0,488; nDCG binário = 0,920; nDCG graduado
    = 0,913.

**Conclusão do aluno:** no experimento realizado, o TF-IDF apresentou os
maiores resultados médios. Porém, isso não permite afirmar que seja
sempre superior ao BM25, pois existem diversos empates e diferenças
relativamente pequenas entre os modelos em várias métricas e consultas.
Os resultados dizem respeito ao corpus, às consultas e aos julgamentos
utilizados neste experimento.
