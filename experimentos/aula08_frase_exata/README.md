# Testes extras da frase exata (Aula 08, Tema 2)

Nenhum dos testes muda a decisão do Tema 2: **não reordenar por frase nem por trecho; manter o estágio 1 sem reordenar.** Eles respondem às perguntas prováveis da apresentação com números do nosso corpus.

Como rodar (da raiz do repositório):

```
Rscript experimentos/aula08_frase_exata/experimentos_frase_exata.R
node experimentos/aula08_frase_exata/r_x_farol.js
```

O script do R imprime as seções 1 a 6 e salva os rankings em `rankings_R.csv` (gerado, não vai para o repositório); o `r_x_farol.js` usa esse arquivo para a seção 7.

Motor puro do grupo (`motor08.R` + `estrutura/codigos/config.R`), 11 consultas avaliadas do dev, gabarito de consenso, limiar 2. Sem a camada de correção do Farol.

## 1. Reordenar até o corpus inteiro

| reordenação | k = 3 | k = 5 | k = 10 | k = 20 | k = 40 | k = 60 |
|---|---|---|---|---|---|---|
| frase | 0,907 | 0,907 | 0,907 | 0,907 | 0,907 | 0,907 |
| trecho | 0,862 | 0,843 | 0,821 | 0,823 | 0,823 | 0,823 |

BM25 sem reordenar: 0,907. A frase inteira não aparece em nenhum dos 60 trechos para nenhuma das 11 consultas, então reordenar por ela não muda nada, nem relendo o corpus inteiro. O trecho fica abaixo do BM25 em todos os k.

## 2. O pedaço colado mais comum

Nos 10 primeiros do BM25 de cada consulta (110 documentos), 27 têm um pedaço de 2 ou mais termos da consulta colado. O mais comum é o nome do porto: "porto santos" em 10 documentos e "porto xangai" em 7, concentrados nas consultas sobre um porto específico (q14: 4 de 10; q15: 6 de 10; q16: 7 de 10).

No corpus inteiro, "porto santos" aparece colado em 7 dos 60 trechos, "porto xangai" em 8 e "porto roterdao" em 3. Ou seja: não está em quase todo documento, mas domina o topo justamente das consultas sobre aquele porto, e o nome do porto não diz nada sobre o assunto da pergunta (incêndios, impacto ambiental, história).

## 3. Consultas em forma de frase

As 11 consultas foram reescritas como perguntas naturais, só a partir da necessidade (sem olhar o texto do corpus). Ex.: q14 "quais incêndios e acidentes aconteceram no porto de Santos". O gabarito vale igual, porque o julgamento é do documento para a necessidade.

| | palavras-chave (originais) | em forma de frase |
|---|---|---|
| BM25 sem reordenar | 0,907 | 0,733 |
| frase (qualquer k) | 0,907 | 0,733 |
| trecho k = 3 | 0,862 | 0,702 |
| trecho k = 10 | 0,821 | 0,587 |
| trecho k = 60 | 0,823 | 0,535 |
| consultas com a frase inteira em algum trecho | 0 de 11 | 0 de 11 |

Uma pergunta inteira quase nunca está colada num parágrafo da Wikipédia. E o BM25 piora com as perguntas porque palavras como "qual", "quais", "foi", "nos", "dos", "os" e "ao" não estão nas 10 stopwords do grupo e viram ruído.

## 4. LSA e híbrido no estágio 1

| estágio 1 | sozinho | trecho k = 3 | trecho k = 5 | trecho k = 10 | frase k = 10 |
|---|---|---|---|---|---|
| BM25 | 0,907 | 0,862 | 0,843 | 0,821 | 0,907 |
| LSA (k = 50) | 0,944 | 0,914 | 0,857 | 0,838 | 0,944 |
| Híbrido (RRF) | 0,915 | 0,869 | 0,848 | 0,831 | 0,915 |

Com qualquer estágio 1, a frase não muda nada e o trecho piora. O LSA sozinho é o melhor nas 11 consultas (ganha na q08 e na q14), mas também foi medido só no dev.

## 5. Busca com aspas medida no gabarito

Uma expressão natural de cada consulta foi posta entre aspas, como filtro sobre o BM25:

| consulta | expressão | trechos | relevantes mantidos | AP |
|---|---|---|---|---|
| q11 | "comercio exterior" | 37 → 3 | 2 de 2 | 1,000 → 1,000 |
| q16 | "porto de xangai" | 40 → 8 | 2 de 2 | 1,000 → 1,000 |
| q17 | "aguas profundas" | 21 → 2 | 1 de 1 | 1,000 → 1,000 |
| q08 | "autoridade portuaria" | 32 → 2 | 1 de 2 | 0,667 → 0,500 |
| q10 | "desenvolvimento economico" | 38 → 1 | 1 de 3 | 1,000 → 0,333 |
| q14 | "porto de santos" | 42 → 7 | 1 de 2 | 0,312 → 0,083 |
| q01 | "movimentacao de cargas" | 20 → 1 | 0 de 1 | 1,000 → 0,000 |
| q06 | "acesso ferroviario" | 38 → 0 | 0 de 1 | 1,000 → 0,000 |
| q15 | "impacto ambiental" | 40 → 0 | 0 de 2 | 1,000 → 0,000 |

As aspas cortam muito o ruído (ex.: 21 → 2 trechos), mas só mantêm todos os relevantes quando o texto usa exatamente a expressão (3 de 9). São uma ferramenta de precisão para quem sabe a expressão exata, não uma melhora geral do ranking. (No Farol, com a correção ligada, q06 e q15 não acham nada e voltam para a busca sem aspas, mantendo o AP 1.)

## 6. Simulação: os não julgados da q15

Hipótese (só simulação; o julgamento real é do grupo): 895fa2 e 3630de, que falam de incêndios em Santos, seriam relevantes para a q15.

| reordenação | AP com o gabarito atual | AP se os dois forem relevantes |
|---|---|---|
| sem reordenar | 1,000 | 1,000 |
| trecho k = 3 | 0,583 | 1,000 |
| trecho k = 5 | 0,417 | 1,000 |

Toda a queda da q15 vem desses dois documentos. Mesmo assim, o MAP do trecho continua abaixo do BM25 (cerca de 0,900 com k = 3 e 0,896 com k = 5, contra 0,907), por causa da q14. Vale julgar os dois para a q15 no gabarito.

## 7. R × Farol

Os 33 rankings (11 consultas × BM25, LSA e híbrido) saem com os 60 documentos na mesma ordem no R e no Farol; a maior diferença de nota é da ordem de 10⁻¹⁴ (arredondamento). O `r_x_farol.js` carrega o motor e os dados direto do `farol/farol.html`, então o teste vale para o arquivo que está no repositório.

O mesmo script refaz a busca com aspas do jeito do Farol (correção de digitação ligada, frase flexível e volta para a busca sem aspas quando nada é achado): q06 e q15 voltam sem aspas e mantêm o AP 1, e a q14 sobe de 0,313 para 0,500 porque a correção troca `acidentes` por `acidente`.
