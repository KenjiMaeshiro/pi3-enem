// r_x_farol.js -- confere se o motor em JavaScript do Farol da os mesmos rankings do R.
// Rode a partir da raiz do repositorio, depois do experimentos_frase_exata.R (que gera o rankings_R.csv):
//    node experimentos/aula08_frase_exata/r_x_farol.js
// Opcional: node r_x_farol.js <caminho do farol.html> <caminho do rankings_R.csv>
const fs = require('fs');
const htmlPath = process.argv[2] || 'farol/farol.html';
const csvPath = process.argv[3] || 'experimentos/aula08_frase_exata/rankings_R.csv';

// carrega os dados e o motor que estao dentro do farol.html
const html = fs.readFileSync(htmlPath, 'utf8');
const dados = JSON.parse(html.match(/<script[^>]*id="dados"[^>]*>([\s\S]*?)<\/script>/)[1]);
const motorSrc = html.match(/<script>\s*(\/\* =+\s*\n\s*motor\.js[\s\S]*?)<\/script>/)[1];
const m = { exports: {} }; new Function('module', motorSrc)(m); const M = m.exports;
const ix = M.montar(dados.corpus, M.CFG); ix.lsa = M.lsa(ix);
const consulta = Object.fromEntries(dados.necessidades.map(n => [n.q, n.consulta]));

// 1) os 33 rankings do R contra os do Farol (sem releitura e sem a correcao de digitacao)
const linhas = fs.readFileSync(csvPath, 'utf8').trim().split(/\r?\n/).slice(1).map(l => {
  const p = l.split(',').map(x => x.replace(/"/g, ''));
  return { mod: p[0], q: p[1], pos: +p[2], id: p[3], sc: +p[4] };
});
const R = {};
for (const l of linhas) (R[l.mod + '|' + l.q] = R[l.mod + '|' + l.q] || []).push(l);
let iguais = 0, total = 0, maxDif = 0;
for (const k in R) {
  const [mod, q] = k.split('|');
  const r = M.buscar(consulta[q], ix, Object.assign({}, M.CFG, { modelo: mod, rerank_k: 0, compreender: false }));
  const rl = R[k].sort((a, b) => a.pos - b.pos);
  total++;
  if (rl.every((l, i) => l.id === r.rk1[i])) iguais++;
  for (const l of rl) maxDif = Math.max(maxDif, Math.abs(l.sc - r.sc1[l.id]));
}
console.log(`R x Farol: ${iguais} de ${total} rankings com os 60 trechos na mesma ordem; maior diferenca de nota ${maxDif.toExponential(1)}`);

// 2) busca com aspas do jeito do Farol (correcao ligada, frase flexivel e volta sem aspas se nada for achado)
const expr = { q01: 'movimentacao de cargas', q06: 'acesso ferroviario', q08: 'autoridade portuaria',
  q10: 'desenvolvimento economico', q11: 'comercio exterior', q14: 'porto de santos',
  q15: 'impacto ambiental', q16: 'porto de xangai', q17: 'aguas profundas' };
console.log('\nBusca com aspas no Farol (resto da consulta + expressao entre aspas):');
for (const q in expr) {
  const g = dados.qrels[q]; const nRel = Object.values(g).filter(x => x >= 2).length;
  const tx = consulta[q].replace(new RegExp(expr[q].split(' ').filter(w => w !== 'de').join('|'), 'g'), '').trim() + ' "' + expr[q] + '"';
  const c = Object.assign({}, M.CFG, { rerank_k: 0, compreender: true });
  let rk = M.buscar(tx, ix, c).rkFiltro, nota = '';
  if (!rk.length) { rk = M.buscar(tx.replace(/"/g, ' '), ix, c).rkCompleto; nota = ' (nada com aspas: voltou sem aspas)'; }
  const base = M.buscar(consulta[q], ix, Object.assign({}, c, { compreender: false })).rkCompleto;
  const mant = rk.filter(id => (g[id] || 0) >= 2).length;
  console.log(`${q} "${expr[q]}": ${rk.length} trechos, relevantes ${mant} de ${nRel}, AP ${M.ap(base, g, 2).toFixed(3)} -> ${M.ap(rk, g, 2).toFixed(3)}${nota}`);
}
