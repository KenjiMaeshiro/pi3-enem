# Aula 00 — Parte D: Consolidado

## 1. Conteúdos trabalhados

- **Módulo 12 — Suas frases: sujar, limpar, contar:** criação de três frases nomeadas, limpeza de texto, tokenização, frequências e palavras distintas.
- **Módulo 13 — Regex nas suas frases:** identificação de maiúsculas, números e pontuação; extração da primeira palavra; substituição de espaços; combinação de padrões.
- **Módulo 14 — O fluxo do curso: Colab e GitHub:** carregamento de código remoto, inspeção do estado do R, anexação ao consolidado, download, publicação e leitura pelo endereço Raw.

## 2. Avaliação da aprendizagem

O estudante criou suas três frases e escreveu suas próprias expressões regulares, com orientações pontuais da tutora. Acertou a ordem e o efeito das etapas do pipeline, após esclarecimentos sobre caracteres acentuados. Identificou que a palavra mais frequente, **de**, tem função principalmente gramatical, e não temática. Na construção das regex, precisou de pistas para diferenciar `+` de `*`, considerar espaços finais e combinar padrões, mas concluiu corretamente o desafio final. Realizou as etapas do Colab e do GitHub e confirmou a leitura remota do consolidado.

## 3. Produzido

- **Três frases:** gostos esportivos, idade de um familiar e hábitos de estudo; textos propositalmente com espaços extras, caixa mista, pontuação, número e acento.
- **Termo mais frequente:** `de` (3 ocorrências).
- **Regex construídas:** início com maiúscula ignorando espaços; presença de dígitos; caractere final não alfabético; remoção do restante após a primeira palavra; substituição de espaços por sublinhados; início com maiúscula e final em `a`.
- **Repositório de treino `pi3-treino` criado:** sim, segundo relato do estudante.
- **Consolidado da teoria enviado ao GitHub:** sim; endereço Raw compartilhado aponta para o repositório `pi3-enem`, na pasta `consolidado`.
- **Estado do R anexado:** sim.
- **Estado do R lido de volta pela internet:** sim.


---

<!-- estado-R:inicio -->
## Estado do R ao fim da sessão
*gerado por `anexar_estado()` em 2026-11-04 00:14 · R version 4.6.1 (2026-06-24) · sem motor · não edite à mão*

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
| `url` | character | 1 | https://raw.githubuserconte... |
| `x` | character, nomeado | 3 | f1 gosto_de_jogar_baseball_e_f..., f2 o_meu_irmo_tem_anos_de_idade, f3 eu_gosto_de_estudar_utiliza... |

### Funções definidas

`anexar_estado`, `estado`, `tokenizar`
<!-- estado-R:fim -->

