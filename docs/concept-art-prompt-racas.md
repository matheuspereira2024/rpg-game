# Prompt de geração — Conceito visual das 6 raças

Prompt pronto pra usar na mesma ferramenta que gerou a arte "Raças do Mundo" (ou outra parecida), baseado nas decisões já fechadas no `design-doc.md` / `sprite-briefs.md`. Por enquanto só define a **raça** (corpo, pele, traços físicos) — sem nenhum equipamento de classe — pra servir de base visual quando formos desenhar as classes em cima depois.

## O que ajustei em relação à imagem que você já gerou

A arte que você mandou ficou ótima como peça de divulgação (fundo escuro, moldura, texto) — vou manter a mesma qualidade de traço, mas tirando o "layout de cartaz" (título, molduras, texto descritivo) e deixando cada raça isolada, num fundo neutro. Isso facilita reaproveitar essa mesma imagem depois como referência quando formos gerar cada classe em cima da raça (um guerreiro anão, uma maga elfa, etc.) — sem ter que recortar texto/moldura toda vez.

## Prompt (copiar e colar)

```
Crie uma prancha de referência de personagens em pixel art de alta qualidade,
estilo "HD pixel art" com sombreamento em múltiplas camadas, contornos limpos,
iluminação suave e consistente, sem serrilhado excessivo. Fundo neutro escuro
liso, sem moldura, sem texto, sem título — só os personagens.

Mostre 6 raças de fantasia lado a lado, cada uma com uma versão masculina e uma
feminina, em pé, de corpo inteiro, vista de frente, na mesma escala entre si
(proporção chibi leve, cabeça um pouco maior que o corpo, entre 4 e 5 cabeças
de altura). Todos vestindo roupas neutras de viajante/aventureiro (túnica e
calça simples, sem armadura, sem arma, sem qualquer equipamento que identifique
uma classe) — o foco aqui é só a identidade racial.

1. HUMANO: proporção de referência (o "meio-termo" visual do grupo), tom de
pele variado (claro a moreno), sem traço físico exagerado, cabelo de
comprimento e cor comuns.

2. ORC: pele verde (tons de musgo a verde-escuro), porte maior e mais largo
que o humano, presas inferiores visíveis, sobrancelha cerrada e expressão
firme, físico robusto.

3. HALFLING: baixo (cerca de 70% da altura do humano), corpo mais redondo e
atarracado, pés grandes (pode aparecer descalço), sem barba, expressão leve
e travessa, cabelo cacheado ou bagunçado.

4. ANÃO: baixo mas robusto (mais largo de ombro que o Halfling), barba longa
e trançada (mesmo na versão feminina, se fizer sentido, ou substituída por
tranças de cabelo elaboradas), pele com tom mais avermelhado/curtido, físico
denso.

5. ELFO: alto e esguio (mais alto que o humano), orelhas pontudas longas,
feições finas e delicadas, cabelo longo (solto ou preso), pele clara com leve
luminosidade.

6. MORTO-VIVO: aparência óssea/esquelética ou pele pálida acinzentada com
sinais de decomposição, olhos com brilho sobrenatural (verde ou azul-claro),
roupas remanescentes rasgadas e desbotadas, postura levemente curvada.

Mantenha o mesmo estilo de traço, iluminação e nível de detalhe em todas as
6 raças, para que pareçam parte do mesmo jogo. Nenhuma delas deve carregar
arma, escudo, cajado ou qualquer item que sugira uma classe específica.
```

## Como usar daqui pra frente

1. Gera esse prompt primeiro pra fechar a identidade visual de cada raça (corpo, pele, rosto, proporção) sem viés de classe.
2. Quando for gerar uma combinação raça+classe específica (ex: Anão Guerreiro), usa a imagem da raça correspondente gerada aqui como referência visual (upload de imagem, se a ferramenta aceitar) e pede pra "adicionar" o equipamento da classe (usando as fichas por classe do `sprite-briefs.md`) — em vez de descrever a raça inteira de novo do zero. Isso ajuda a manter o mesmo rosto/corpo/tom de pele em todas as 6 classes de uma raça.
3. Lembrando (como já conversamos): essa linha de arte em alta qualidade é ótima pra material promocional, telas de seleção de raça e codex/lore — mas os sprites que realmente vão pra dentro da arena de batalha continuam vindo do pipeline Tiny RPG Character Pack + PixelLab, que já tem o rig, animações e escala certos pro jogo.
