# Consolidado — PI III — Aula 07 — Parte D — 08/11/2026
*guia versão 2 · tutor: Claude (Claude Code, com execução no R local e no Colab) · sessão de grupo · motor07*
**Grupo:** Enem · **presentes:** Pedro Santos (conduziu); demais: — · **digitou:** o tutor, a pedido do grupo, nos três módulos

## 1. O que foi feito
- M7 — LSA no corpus do grupo ($k = 20$, 68,5% da energia); LSA × BM25 na consulta q01, lendo os textos: 3 documentos em comum nos top-5; só o LSA trouxe o `37b06b`, sem nenhuma palavra da consulta, sobre o transporte de mercadorias pelo porto (lido como ganho de sentido); só o BM25 trouxe o `770191`, pelas palavras "movimentacao" e "cargas", que só conta a história das operações.
- M8 — BM25, LSA e híbrido (RRF, $c = 60$) com $k = 10, 20, 50$ nas 11 consultas avaliadas, todas `dev`; sem teste. MAP dev: BM25 $0{,}907$; LSA $0{,}430$ / $0{,}518$ / $0{,}944$; híbrido $0{,}683$ / $0{,}787$ / $0{,}915$. Com $k = 10$ ou $20$, o LSA perde do BM25 em 8 de 11 consultas; com $k = 50$, não perde em nenhuma e ganha em 2 (q08, q14).
- M9 — decisão: **ficar com o BM25**, o mais confiável, porque o LSA só passa dele com $k = 50$, quase a matriz inteira (60 documentos), e ganha em apenas 2 de 11 consultas. `config.R`: `modelo = "bm25"`, `lsa_k = 50`, `rrf_c = 60`.

## 2. Como o grupo trabalhou — opinião do tutor
O grupo leu os textos do top-5 antes de olhar os números e respondeu bem quando as perguntas vinham com os trechos na frente: viu que o `37b06b` fala do assunto sem as palavras da consulta e que o `770191` tem as palavras mas só conta história. Na tabela de desenvolvimento, identificou sozinho a linha de maior MAP (LSA $k = 50$) e que ela não perde em nenhuma consulta, e mesmo assim escolheu o BM25 por confiança; o porquê com números foi montado por mim a partir dessa intuição e aprovado pelo grupo. Não havia teste para olhar, então não houve a tentação de ajustar no teste. Como na Aula 06, todo o código foi rodado por mim; o grupo leu as saídas e decidiu, mas não digitou. No começo, o grupo achou que a Aula 07 já estava feita: o consolidado no repositório era a teoria do Lucas, não a Parte D.

## 3. Observações para a frente
- **Para a próxima sessão prática (Aula 08):** o motor está com `modelo = "bm25"`, `prf_k = 0`, stopwords curtas; o reordenador da Aula 08 vai reler o topo do BM25. Não há PRF × LSA a decidir. O guia da Aula 08 Parte D não está no repositório do grupo (há uma cópia em `danilopradooficial/projetointegrador3`, `materiais-tutora/`).
- **Tarefa do grupo (análise LSA × BM25):** feita. Onde o LSA ganhou, q14 ($k = 50$, AP $0{,}312 \to 0{,}556$): o LSA pôs em 1º o relevante `be66af`, sobre o incêndio de 2015 na Alemoa, porque olha o assunto do texto inteiro e não só a contagem das palavras. Onde perdeu, q01 ($k = 20$, AP $1{,}000 \to 0{,}500$): pôs em 1º o `54eb31` (grau 0), 12 palavras sobre o terminal Baoshan, que só afirma detalhes do terminal. Texto completo na seção 6 da ficha.
- **Perguntas guardadas:** nenhuma.
- **Produzido:** ver a entrada "Aula 07 Parte D" na linha do tempo da ficha do projeto.
- **Ficha atualizada:** sim — seções alteradas: 5, 6, 7 e cabeçalho; seção 8 gerada por `anexar_estado()`.
