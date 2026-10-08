# Relatório de Avaliação — Projeto Integrador III

## 1. Corpus e usuário-alvo

O projeto avaliou um motor de busca sobre um corpus temático de portos, composto por documentos derivados de páginas da Wikipédia sobre o **Porto de Santos**, o **Porto de Xangai** e o **Porto de Roterdã**.

O corpus final possui **60 documentos**, distribuídos igualmente entre as três fontes:

| Fonte | Documentos |
|---|---:|
| Porto de Santos | 20 |
| Porto de Xangai | 20 |
| Porto de Roterdã | 20 |
| **Total** | **60** |

Os documentos receberam identificadores estáveis derivados do conteúdo, no formato `doc-...`, evitando a dependência da posição da linha no corpus.

A inspeção do corpus produziu os seguintes resultados:

```text
IDs únicos: 60
IDs duplicados: 0
IDs vazios: 0
Textos vazios: 0
Fontes vazias: 0
Textos duplicados: 0
Possíveis problemas de codificação: 0

Média de palavras: 57,83
Desvio-padrão: 45,94
Mínimo: 10
Q1: 28
Mediana: 38,5
Q3: 78
Máximo: 239
```

O usuário-alvo considerado é um **pesquisador ou estudante interessado em localizar e comparar informações sobre os três portos**, incluindo história, infraestrutura, movimentação de cargas, administração, integração logística, impactos econômicos e eventos específicos.

Os modelos avaliados foram:

- busca booleana;
- TF-IDF com similaridade de cosseno;
- BM25.

---

## 2. Necessidades de informação

Foram definidas **20 necessidades de informação**, identificadas de `q01` a `q20`. Cada necessidade possui uma consulta curta, uma descrição em prosa e um escopo que delimita o que deve ou não ser considerado resposta adequada.

| Consulta | Necessidade |
|---|---|
| q01 | O pesquisador quer entender por que a movimentacao de cargas nos portos estudados e economicamente relevante, para a regiao ou para o pais. |
| q02 | O pesquisador quer comparar o volume de conteineres movimentados, em TEU, entre o Porto de Santos e o Porto de Xangai. |
| q03 | O pesquisador quer uma visao historica de como cada um dos tres portos se desenvolveu ao longo do tempo. |
| q04 | O pesquisador quer saber como e quando novos terminais foram construidos ou expandidos. |
| q05 | O pesquisador quer comparar profundidade de calado e obras de dragagem entre os portos. |
| q06 | O pesquisador quer entender quais modais de transporte terrestre dao acesso a cada porto. |
| q07 | O pesquisador quer saber quais tipos de carga (granel solido, granel liquido, conteiner etc.) cada porto movimenta. |
| q08 | O pesquisador quer entender quem administra cada porto e como essa administracao mudou ao longo do tempo. |
| q09 | O pesquisador quer dados de capacidade (area, calado, numero de guindastes) dos terminais. |
| q10 | O pesquisador quer entender o papel do porto no desenvolvimento economico da regiao ao seu redor. |
| q11 | O pesquisador quer entender o papel dos portos no comercio exterior (exportacao e importacao). |
| q12 | O pesquisador quer entender a relacao entre o Porto de Santos e o polo industrial de Cubatao/SP. |
| q13 | O pesquisador quer a trajetoria administrativa especifica de CDS/CODESP/SPA no Porto de Santos. |
| q14 | O pesquisador quer levantar os incendios e acidentes ocorridos no Porto de Santos. |
| q15 | O pesquisador quer o impacto ambiental especifico dos incendios de Santos: contaminacao da agua, morte de peixes. |
| q16 | O pesquisador quer a trajetoria historica de crescimento do Porto de Xangai. |
| q17 | O pesquisador quer detalhes da construcao e expansao do terminal de aguas profundas de Yangshan. |
| q18 | O pesquisador quer comparar os diferentes terminais/portos internos que compoem o complexo de Xangai. |
| q19 | O pesquisador quer entender o papel do Porto de Roterda como ponto de transporte para o interior da Europa. |
| q20 | O pesquisador quer uma comparacao geral entre os tres portos em volume de carga e conteineres. |

A regra principal do julgamento foi avaliar cada documento contra a **necessidade em prosa**, e não apenas contra a presença literal das palavras da consulta.

---

## 3. Guia de julgamento

Foi utilizada uma escala de relevância com três graus:

| Grau | Regra operacional |
|---:|---|
| **2** | O documento responde à necessidade de informação de forma suficiente. |
| **1** | O documento trata do tema e fornece informação relacionada, mas não responde suficientemente à necessidade. |
| **0** | O documento não é útil para responder à necessidade. |

O guia também adotou como regra de ouro: **julgar a necessidade em prosa e não somente a consulta textual**.

Durante a avaliação de concordância surgiram divergências principalmente nas consultas `q11`, `q12` e `q19`. Os critérios dessas consultas foram explicitados com maior precisão antes da segunda rodada de julgamento duplo.

---

## 4. Estratégia de pooling e viés

A amostra de julgamento foi construída pelo método de *pooling*. Para cada uma das 20 consultas, os três modelos — Booleano, TF-IDF e BM25 — produziram documentos candidatos. Os resultados foram unidos e deduplicados por par `consulta-documento`.

A pool final utilizada no julgamento contém **29 pares consulta-documento**. Desses, **6 pares** foram separados para julgamento duplo, correspondendo aproximadamente a 20% da pool.

O arquivo entregue aos juízes não revelou qual modelo recuperou cada documento. A ordem de apresentação foi tratada separadamente da origem do resultado para reduzir viés de posição.

A principal limitação desse procedimento é o **viés de pooling**: um documento que não é recuperado por nenhum dos modelos não entra na pool, não é julgado e, portanto, não pode ser descoberto como relevante. Assim, o conjunto de relevantes conhecidos é limitado aos documentos efetivamente julgados.

Na execução prática, vários integrantes julgaram grande parte da pool. Esses julgamentos adicionais foram aproveitados para a consolidação do gabarito por unanimidade, maioria humana e, quando necessário, decisão coletiva nos casos de empate.

---

## 5. Concordância entre juízes

Os 6 itens reservados para julgamento duplo foram avaliados por **Murinelly e Lucas**, sem consulta às notas anteriores.

Na primeira avaliação, o resultado foi:

```text
Kappa de Cohen = 0,280
```

Como o valor ficou abaixo de `0,4`, o guia foi revisado e os seis itens foram julgados novamente.

Na segunda rodada válida, o resultado foi:

```text
Itens comparados: 6
Concordâncias: 4
Discordâncias: 2

po = 0,667
pe = 0,361
Kappa de Cohen = 0,478
```

Pelo critério adotado no projeto, o valor entre `0,4` e `0,6` foi tratado como **concordância aceitável, mas com limitação**. As discordâncias restantes foram preservadas como evidência da subjetividade presente na tarefa de julgamento.

Após essa etapa, os julgamentos humanos foram consolidados. Casos com maioria clara receberam o grau correspondente à maioria. Casos empatados foram discutidos pelo grupo e receberam uma decisão coletiva final.

O `qrels.csv` final possui:

```text
29 pares consulta-documento
11 pares com grau 0
4 pares com grau 1
14 pares com grau 2
0 pares pendentes
```

---

## 6. Métricas de recuperação

Foi considerado **relevante para as métricas binárias o documento com grau >= 2**.

Foram calculadas:

- Precisão em `k = 1, 3, 5, 10`;
- Recall em `k = 1, 3, 5, 10`;
- Average Precision (AP);
- Mean Average Precision (MAP);
- Mean Reciprocal Rank (MRR);
- nDCG binário;
- nDCG graduado.

O script de métricas também foi validado com o cenário de teste obrigatório, obtendo aproximadamente:

```text
P@3 = 0,667
AP = 0,833
MRR = 1,000
nDCG binário = 0,920
nDCG graduado = 0,951
```

### 6.1 Resultados agregados

| Modelo | P@1 | P@3 | P@5 | P@10 | R@1 | R@3 | R@5 | R@10 | MAP | MRR | nDCG binário | nDCG graduado |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Booleano | 0,150 | 0,067 | 0,040 | 0,020 | 0,182 | 0,227 | 0,227 | 0,227 | 0,227 | 0,150 | 0,238 | 0,187 |
| TF-IDF | 0,550 | 0,233 | 0,140 | 0,070 | 0,864 | 1,000 | 1,000 | 1,000 | 0,985 | 0,550 | 0,993 | 0,960 |
| BM25 | 0,450 | 0,217 | 0,140 | 0,070 | 0,727 | 0,909 | 1,000 | 1,000 | 0,894 | 0,487 | 0,920 | 0,913 |

Os resultados mostram que o **TF-IDF apresentou os maiores valores agregados na maior parte das métricas**, especialmente em P@1, P@3, R@1, R@3, MAP, MRR e nos dois nDCGs.

O BM25 apresentou desempenho próximo ao TF-IDF e atingiu os mesmos valores agregados de TF-IDF em P@5, P@10, R@5 e R@10. A diferença entre os dois aparece principalmente nas primeiras posições do ranking e em consultas específicas.

A busca booleana obteve resultados agregados menores. No projeto, ela exige a presença conjunta dos termos válidos da consulta e não possui um ranqueamento natural de relevância; por isso, sua ordenação é apenas uma convenção determinística para viabilizar a avaliação.

---

## 7. Análise por consulta

A tabela a seguir resume o número de documentos considerados relevantes (`grau 2`) em cada consulta e o comportamento observado nos APs dos três modelos.

| Consulta | Relevantes conhecidos | Observação |
|---|---:|---|
| q01 | 1 | TF-IDF e BM25 obtiveram AP=1,000; o terceiro modelo ficou abaixo. |
| q02 | 0 | Nenhum documento da pool recebeu grau 2; AP e recall ficam indefinidos para esta consulta. |
| q03 | 0 | Nenhum documento da pool recebeu grau 2; AP e recall ficam indefinidos para esta consulta. |
| q04 | 1 | TF-IDF obteve o maior AP nesta consulta (1,000). |
| q05 | 0 | Nenhum documento da pool recebeu grau 2; AP e recall ficam indefinidos para esta consulta. |
| q06 | 1 | TF-IDF e BM25 obtiveram AP=1,000; o terceiro modelo ficou abaixo. |
| q07 | 0 | Nenhum documento da pool recebeu grau 2; AP e recall ficam indefinidos para esta consulta. |
| q08 | 1 | TF-IDF e BM25 obtiveram AP=1,000; o terceiro modelo ficou abaixo. |
| q09 | 0 | Nenhum documento da pool recebeu grau 2; AP e recall ficam indefinidos para esta consulta. |
| q10 | 1 | Os três modelos obtiveram AP=1,000. |
| q11 | 2 | Os três modelos obtiveram AP=1,000. |
| q12 | 0 | Nenhum documento da pool recebeu grau 2; AP e recall ficam indefinidos para esta consulta. |
| q13 | 0 | Nenhum documento da pool recebeu grau 2; AP e recall ficam indefinidos para esta consulta. |
| q14 | 1 | TF-IDF e BM25 obtiveram AP=1,000; o terceiro modelo ficou abaixo. |
| q15 | 2 | TF-IDF e BM25 obtiveram AP=1,000; o terceiro modelo ficou abaixo. |
| q16 | 2 | TF-IDF obteve o maior AP nesta consulta (0,833). Valores: Booleano=0,500, TF-IDF=0,833, BM25=0,583. |
| q17 | 1 | TF-IDF e BM25 obtiveram AP=1,000; o terceiro modelo ficou abaixo. |
| q18 | 1 | TF-IDF e BM25 obtiveram AP=1,000; o terceiro modelo ficou abaixo. |
| q19 | 0 | Nenhum documento da pool recebeu grau 2; AP e recall ficam indefinidos para esta consulta. |
| q20 | 0 | Nenhum documento da pool recebeu grau 2; AP e recall ficam indefinidos para esta consulta. |

Alguns casos merecem destaque:

- **q01**: TF-IDF e BM25 recuperaram o relevante com AP igual a `1,000`, enquanto o Booleano não o recuperou de forma útil no ranking avaliado.
- **q04**: TF-IDF obteve AP `1,000`; BM25 obteve AP `0,250`; Booleano ficou em `0,000`.
- **q10** e **q11**: os três modelos alcançaram AP `1,000`.
- **q15**: TF-IDF e BM25 alcançaram AP `1,000`, enquanto o Booleano ficou em `0,000`.
- **q16**: houve uma diferença mais clara entre os modelos: TF-IDF `0,833`, BM25 `0,583` e Booleano `0,500`.
- **q17** e **q18**: TF-IDF e BM25 alcançaram AP `1,000`, enquanto o Booleano ficou em `0,000`.

As consultas `q02`, `q03`, `q05`, `q07`, `q09`, `q12`, `q13`, `q19` e `q20` ficaram com `total_relevantes = 0` no gabarito conhecido. Nesses casos, AP e recall são indefinidos e aparecem como `NA`.

Isso **não significa que não existam documentos relevantes no corpus inteiro**. Significa somente que nenhum documento presente na pool e julgado recebeu grau 2 para essas necessidades.

---

## 8. Limitações

A avaliação possui algumas limitações que devem ser consideradas na interpretação dos números.

### 8.1 Pool reduzida

A pool final possui 29 pares consulta-documento para um corpus de 60 documentos e 20 consultas. Como nem todos os pares possíveis foram julgados, o gabarito representa apenas o subconjunto observado.

### 8.2 Viés de pooling

Documentos que nenhum dos três modelos recuperou não foram avaliados. Consequentemente, documentos potencialmente relevantes podem ter permanecido fora da pool.

### 8.3 Consultas sem relevante conhecido

Nove consultas não possuem grau 2 na pool. Para elas, AP e recall não podem ser calculados de forma informativa. Isso reduz a quantidade de consultas efetivamente utilizadas nas médias dessas métricas.

### 8.4 Concordância moderada

O Kappa final foi `0,478`. O valor permitiu prosseguir segundo o critério do projeto, mas mostra que ainda existe subjetividade na aplicação da escala de relevância.

### 8.5 Busca booleana

A busca booleana não possui ranking natural. A ordem usada para permitir P@k, AP, MRR e nDCG é uma convenção operacional e deve ser interpretada com cautela ao comparar o modelo com métodos naturalmente ranqueados.

### 8.6 Corpus pequeno e específico

O corpus é pequeno, temático e composto por apenas três fontes principais. Assim, os resultados descrevem o comportamento dos modelos **neste experimento** e não devem ser generalizados automaticamente para coleções maiores ou domínios diferentes.

---

## 9. Conclusão

O experimento permitiu construir um processo completo de avaliação de recuperação de informação: preparação de corpus, definição de necessidades, construção de pool, julgamento humano, medição de concordância, consolidação de `qrels` e cálculo das métricas.

Dentro do gabarito conhecido, o TF-IDF apresentou os maiores valores agregados na maior parte das métricas, enquanto o BM25 apresentou resultados próximos e, em vários cortes, equivalentes. A busca booleana teve desempenho mais limitado no conjunto avaliado.

O resultado deve ser interpretado juntamente com as limitações metodológicas. A pool reduzida e a existência de nove consultas sem documentos grau 2 conhecidos mostram que a avaliação não cobre todo o espaço de relevância do corpus. Além disso, o Kappa de `0,478` indica que o julgamento humano apresentou divergências que precisaram ser tratadas pelo grupo.

Como continuidade, uma avaliação futura poderia ampliar a profundidade do pooling, aumentar o número de documentos julgados por consulta e revisar novamente os casos de fronteira do guia de relevância. Isso permitiria um gabarito mais abrangente e uma comparação mais robusta entre os modelos.

---

## Arquivos principais produzidos

```text
corpus.csv
ficha_corpus.R
analise_corpus.md

necessidades.csv
necessidades.md
gerar_necessidades_md.R

guia_julgamento.md

montar_pool_corrigido.R
pool.csv
duplo_julgamento.csv

julgar.html

qrels.csv
qrels_consolidado_final.csv

concordancia.R
concordancia_murinelly_lucas.csv
concordancia_murinelly_lucas_p2.csv

metricas.R
rodar_metricas_corrigido.R
metricas_booleano.csv
metricas_tfidf.csv
metricas_bm25.csv
resumo_metricas.csv
analise_metricas.md

relatorio_avaliacao.md
```
