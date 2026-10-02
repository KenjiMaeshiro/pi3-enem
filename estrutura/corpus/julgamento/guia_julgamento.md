# Guia de Julgamento de Relevância

## Regra de ouro

O documento deve ser julgado **contra a necessidade de informação em prosa**, e não apenas contra as palavras da consulta. A presença de termos como “porto”, “Santos”, “Xangai”, “Roterdã”, “terminal” ou “cargas” não torna um documento relevante por si só.

## Escala

| Grau | Significado operacional |
|---|---|
| **2 — Responde à necessidade** | O documento fornece informação que efetivamente ajuda a responder o que o usuário quer saber, mesmo que de forma breve. |
| **1 — Relacionado, mas insuficiente** | O documento fala do mesmo assunto ou menciona elementos importantes da necessidade, porém não entrega informação suficiente para respondê-la. |
| **0 — Não serve** | O documento não contribui para responder à necessidade, ainda que compartilhe palavras da consulta. |

## Casos de fronteira

1. **Documento correto, mas superficial → grau 1.**  
   Exemplo de regra: para uma necessidade sobre dragagem, profundidade ou calado, um parágrafo que apenas diga que o porto realiza dragagem, sem explicar profundidade, finalidade ou efeito operacional, é relacionado, mas insuficiente.

2. **Responde apenas a uma parte da necessidade → grau 1.**  
   Se a necessidade compara Santos, Xangai e Roterdã e o documento traz informação útil sobre apenas um dos portos, ele contribui para o tema, mas não responde sozinho à necessidade comparativa.

3. **Traz uma resposta direta, mesmo curta → grau 2.**  
   Um parágrafo curto pode receber grau 2 se trouxer exatamente a informação pedida, por exemplo capacidade de terminal, acesso ferroviário/rodoviário, tipo de carga, expansão portuária ou função econômica.

4. **Só repete palavras da consulta → grau 0.**  
   Um texto que menciona “porto”, “cargas” ou “terminais”, mas trata de outro aspecto sem relação com a necessidade específica, não deve ganhar relevância por coincidência de vocabulário.

5. **Cita um fato relacionado, mas não o explica → grau 1.**  
   Para uma necessidade sobre incêndios e impacto ambiental no Porto de Santos, um documento que apenas mencione a ocorrência de um incêndio sem explicar consequências ambientais, contaminação ou efeitos relacionados é apenas parcialmente útil.

6. **Informação histórica só é relevante quando a necessidade for histórica → grau 0 ou 1 conforme o caso.**  
   Um parágrafo sobre a fundação ou evolução histórica de um porto não deve receber grau 2 em uma necessidade sobre capacidade atual, acessos ou movimentação de cargas. Pode ser grau 1 somente se oferecer contexto útil para a necessidade.

7. **Documento excelente, mas com informação já conhecida pelo usuário → julgar pelo conteúdo, não pela novidade.**  
   Se o documento responde claramente à necessidade, ele continua sendo grau 2. Não reduzir a nota porque a informação parece óbvia ou conhecida.

8. **Trecho com informação acessória muito longa → julgar pela parte útil.**  
   Se o documento contém muito contexto, mas inclui uma resposta clara à necessidade, a presença de conteúdo adicional não reduz automaticamente o grau.

## Procedimento para os juízes

- Leia primeiro a **necessidade** e o **escopo**.
- Depois leia o documento inteiro.
- Ignore qual modelo recuperou o documento e qualquer posição de ranking.
- Atribua 0, 1 ou 2 sem consultar outro juiz.
- Em caso de dúvida entre 1 e 2, pergunte: **“Com este documento, eu consigo responder à necessidade ou apenas sei que ele fala do assunto?”**
- Em caso de dúvida entre 0 e 1, pergunte: **“Existe alguma informação concreta aqui que ajude parcialmente a responder?”**
- Se surgir um caso novo não previsto neste guia, registre a decisão para incluir depois em `consolidados/`.
