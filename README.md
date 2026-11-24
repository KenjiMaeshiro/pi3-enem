# Projeto Integrador 3
Membros: Ana Luiza, Caio Kenji, Lucas Murinelly e Pedro Santos

Motor de busca sobre os portos de Santos, Xangai e Roterdã (60 trechos da Wikipédia em português).

## Farol

O [Farol](farol/) é a interface do motor: você faz uma pergunta, escolhe o modelo (BM25, LSA ou híbrido) e recebe a resposta com os trechos citados. Como usar e o que ele precisa para funcionar estão em [`farol/README.md`](farol/README.md).

## Estrutura

| pasta | o que tem |
|---|---|
| [`farol/`](farol/) | a interface do motor (`farol.html`) e as instruções |
| [`estrutura/banco-de-dados/`](estrutura/banco-de-dados/) | corpus, necessidades e gabarito (qrels) |
| [`estrutura/codigos/`](estrutura/codigos/) | `config.R` com as decisões do grupo e os códigos das aulas |
| [`consolidado/`](consolidado/) | os consolidados de cada aula |
| [`guias/`](guias/) | os guias de estudo das aulas |
| [`entregas/`](entregas/) | as entregas do projeto |
