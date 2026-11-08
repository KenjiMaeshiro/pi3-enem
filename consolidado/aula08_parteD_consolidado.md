# Consolidado — PI III — Aula 08 — Parte D — 08/11/2026
*guia versão 2 · tutor: Claude (Claude Code, com execução no R local e no Colab) · sessão de grupo · motor08*
**Grupo:** Enem · **presentes:** Pedro Santos (conduziu); demais: — · **digitou:** o tutor, a pedido do grupo, nos três módulos

## 1. O que foi feito
- M7 — `proximidade` e `reordenar` (testes da teoria: $0{,}5$ e `b a c`) sobre o estágio 1 do grupo (BM25). Em q01 nada se move; em q14 (top-10, janela 3) a reordenação subiu documentos com "porto de santos" colado, que não respondem à necessidade, e tirou do top-5 o relevante `be66af`, sobre o incêndio de 2015 (AP $0{,}312 \to 0{,}146$).
- M8 — grade $k \in \{3, 5, 10\}$ × janela $\in \{2, 3, 5\}$ nas 11 consultas avaliadas, todas `dev`; sem teste. MAP do estágio 1: $0{,}907$. Melhor combinação: $k = 3$, janela 2 ou 3, $0{,}847$; pior: $k = 10$, janela 5, $0{,}665$. Nenhuma combinação ganhou em alguma consulta; $k = 3$ perde em q14, q15 e q16.
- M9 — decisão: **reordenar o top-3 do BM25, janela 3**, porque a proximidade premia documentos com as palavras da consulta em ordem, o que deve ajudar em consultas mais longas, mesmo tendo perdido em q14, q15 e q16. `config.R`: `rerank_k = 3`, `janela = 3`.

## 2. Como o grupo trabalhou — opinião do tutor
O grupo leu os textos de q14 e respondeu sem hesitar que os documentos que subiram não respondem à necessidade e que o que desceu respondia. Na grade, apontou a linha de maior MAP entre as reordenações, mas a primeira leitura ("perde em todas") e a escolha de reordenar não batiam com a tabela: $k = 3$ fica abaixo de não reordenar ($0{,}847$ contra $0{,}907$) e perde em 3 de 11 consultas, sem ganhar em nenhuma. Mostrei isso com os números e perguntei de novo; o grupo manteve a decisão de reordenar com $k = 3$, janela 3, e escolheu como porquê a hipótese de que a proximidade ajuda em consultas mais longas. É uma decisão do grupo, registrada com a ressalva; os números atuais não a sustentam. Como nas Aulas 06 e 07, o código foi rodado por mim; o grupo leu as saídas e decidiu, mas não digitou.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 09):** o motor está com BM25 + reordenação do top-3 (janela 3). Vale testar a hipótese do grupo com consultas mais longas ou mais julgamentos, e lembrar que, no gabarito atual, `rerank_k = 0` dá MAP $0{,}907$. O guia da Aula 09 Parte D não está no repositório do grupo.
- **Tarefa do grupo (análise da reordenação):** feita. Onde perdeu, q14 (AP $0{,}312 \to 0{,}146$): a proximidade premiou "porto de santos" colado em documentos que não falam de acidentes e zerou o relevante `be66af`, que tem "incêndio" no singular e "terminais" fora da ordem da consulta. Onde não mudou, q01: o top-3 do BM25 já estava na ordem da proximidade. Texto completo na seção 6 da ficha.
- **Perguntas guardadas:** nenhuma.
- **Produzido:** ver a entrada "Aula 08 Parte D" na linha do tempo da ficha do projeto.
- **Ficha atualizada:** sim — seções alteradas: 5, 6, 7 e cabeçalho; seção 8 gerada por `anexar_estado()`.
