# Farol: o motor de busca do grupo Enem

O Farol é uma página que responde perguntas sobre os portos de **Santos**, **Xangai** e **Roterdã**. Você escolhe o modelo de busca (BM25, LSA ou híbrido), escreve a pergunta, e:

1. o **motor do grupo** encontra os trechos mais relevantes entre os 60 parágrafos do corpus;
2. o **Claude** escreve a resposta usando só esses trechos e cita cada um ([1], [2]…);
3. abaixo da resposta ficam os trechos usados e o raciocínio do motor, com as contas.

É tudo um arquivo só: `farol.html`. Os dados e o motor estão dentro dele.

## Como usar

Há dois jeitos. A diferença é só a resposta escrita.

| | Pelo link do claude.ai | Abrindo o `farol.html` no computador |
|---|---|---|
| Onde | [Farol dos Portos](https://claude.ai/artifact/7M9FF5afH1bZ7zMs1jrfSn) | baixe o arquivo e abra no navegador |
| Busca, trechos e contas | sim | sim |
| Resposta escrita pelo Claude | sim | não (aparece um aviso) |
| O que precisa | conta no claude.ai e acesso ao link | só um navegador (Chrome, Edge, Firefox) |

### Pelo link (com resposta escrita)

- **Conta no claude.ai.** Quem abre precisa estar logado.
- **Acesso ao link.** A página é privada: o dono (Pedro) precisa compartilhar pelo botão **Compartilhar** da página com o e-mail da pessoa.
- **Permitir o uso do Claude.** Na primeira pergunta aparece o aviso "Este artefato usa conectores". É só clicar em **Permitir o uso do Claude**.
- **Cada resposta conta no limite de uso do Claude de quem pergunta**, como uma mensagem normal no chat.

### Pelo arquivo (sem resposta escrita)

- Baixe `farol.html` (botão **Download raw file** no GitHub) e dê dois cliques.
- Não precisa instalar nada nem de servidor. Com internet as fontes carregam; sem internet a página usa as fontes do sistema.
- Fora do claude.ai a página não tem acesso ao Claude: no lugar da resposta aparece um aviso, e o resto funciona igual.

## Como funciona

1. **Preparar a pergunta** — tira acentos (`translit`) e pontuação, passa para minúsculas e remove as 10 stopwords do grupo.
2. **Estágio 1 · o modelo escolhido**
   - **BM25** — k1 = 1,2 e b = 0,75.
   - **LSA** — SVD da matriz TF-IDF, com 50 dimensões (`lsa_k`).
   - **Híbrido** — fusão RRF do BM25 com o LSA (c = 60).
3. **Frase exata** — o que estiver entre aspas tem que aparecer colado e na ordem (`aula08_frase.R`). Ponha entre aspas só a expressão, não a pergunta inteira: `terminal "águas profundas" xangai`. Se nenhum trecho tiver a frase, o Farol avisa e busca sem as aspas.
4. **Estágio 2 · proximidade** (opcional) — relê os `rerank_k` primeiros e sobe quem tem os termos em ordem e perto.
5. **Resposta** — o Claude lê os 8 primeiros trechos (mais até 2 de cada porto, para perguntas que comparam) e responde citando cada um. Ele não usa nada de fora dos trechos; se eles não bastam, ele diz o que falta.

Os padrões são os do `config.R` do grupo (BM25 com releitura do top-3, janela 3). Tudo pode ser mudado no painel lateral, e o MAP no gabarito é recalculado na hora.

## Os números conferem com o R

O motor é uma tradução para JavaScript do `motor08.R` (curso), do `estrutura/codigos/config.R` e do `estrutura/codigos/aula08_frase.R`. Rodando as 11 consultas do gabarito de consenso (`qrels_consenso.csv`, limiar 2), o Farol dá o mesmo MAP do R:

| modelo | sem releitura | com releitura do top-3 |
|---|---|---|
| BM25 | 0,907 | 0,847 |
| LSA (50 dimensões) | 0,944 | 0,899 |
| Híbrido (RRF) | 0,915 | 0,854 |

Os rankings também batem consulta a consulta (mesmo top-5, mesmos cossenos do LSA até a 4ª casa).

## De onde vêm os dados

O JSON dentro do `farol.html` (bloco `<script id="dados">`) foi gerado a partir de `estrutura/banco-de-dados/`:

- `corpus.csv` — os 60 trechos da Wikipédia (CC BY-SA), congelados na Aula 05;
- `necessidades.csv` — as 20 consultas e necessidades;
- `qrels_consenso.csv` — o gabarito de consenso.

Se o corpus ou o gabarito mudarem, esse bloco precisa ser gerado de novo; o motor recalcula o resto (índice, BM25, SVD) quando a página abre.

## Limites

- O Claude não lembra a pergunta anterior: cada pergunta é respondida sozinha.
- O BM25 só acha palavras escritas igual (sem *stemming*): "incêndio" e "incêndios" são termos diferentes. O LSA ajuda nisso, porque busca pelo assunto.
- O conjunto de teste do gabarito está vazio; os MAPs acima são todos do dev.
