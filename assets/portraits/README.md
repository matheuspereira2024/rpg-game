# Portraits individuais dos heróis

Derivados da matriz oficial `Arte Promocional/Raca-Classe/Versao 2 - Matriz Unica/Matriz-36-combinacoes-FINAL-v1.png`.

- 36 PNGs RGB de 256×256, fundo preto, um personagem por arquivo.
- Estrutura: `<raça>/<classe>.png`.
- Todos foram centralizados pelo limite visual da silhueta completa, incluindo equipamento.
- A linha Halfling foi reduzida para 92% para reforçar levemente sua menor estatura; as demais preservam a escala original, salvo proteção automática caso uma silhueta exceda a margem de 8 px.
- `manifest.json` registra ordem, corte original, área detectada e escala aplicada.
- `_contato-36.png` serve para revisão visual conjunta.

Para regenerar: `node tools/split-hero-matrix.mjs`, executado a partir da raiz do projeto. O script preserva a matriz original.
