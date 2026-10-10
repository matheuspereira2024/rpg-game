# Brief de Sprites — Raça x Classe

Documento de referência visual pros 36 sprites de herói (6 raças x 6 classes). Serve como briefing pra um artista ou como base pra prompts em ferramentas de geração de imagem.

## Especificação técnica geral

- **Estilo**: pixel art chibi (cabeça grande, corpo curto — 2 a 3 "cabeças" de altura), baseado nas referências enviadas (MiniFolks, Tiny RPG Character Pack).
- **Resolução sugerida**: tile-base 32x32px por sprite (compatível com a maioria dos packs desse estilo; dá pra escalar pra 48x48 se quiser mais detalhe depois).
- **Escala no jogo**: 1 herói = 1 SQM = 1 tile do grid da arena (a proporção arena/herói de 1/40 a 1/80 que você mencionou fica pra quando formos desenhar as arenas).
- **Vista**: 3/4 top-down, como nas referências. Por ora só o sprite parado de frente — variações de direção/animação ficam pra depois.
- **Paleta**: poucas cores por sprite (4 a 8 tons), contorno escuro pra manter legibilidade em tamanho pequeno.
- **Fundo**: transparente.

## Silhueta base por classe (vale pra todas as raças)

| Classe | Pose | Equipamento base |
|---|---|---|
| Guerreiro | Ereta, defensiva | Armadura leve, escudo redondo pequeno (madeira+metal), espada de uma mão |
| Bárbaro | Inclinada pra frente, agressiva | Torso parcialmente nu, tira de couro cruzando o peito, machado de duas mãos apoiado no ombro, olhos vermelhos |
| Caçador | Alerta, semi-agachada | Roupa de couro ajustada, capuz/boné leve, arco na mão, aljava de flechas nas costas |
| Assassino | Furtiva, agachada | Roupa preta/couro ajustada, capuz cobrindo parte do rosto, uma adaga em cada mão |
| Clérigo | Serena, ereta | Vestimenta longa clara (branco/dourado), bastão de madeira, símbolo sagrado no peito |
| Mago | Contemplativa, mão livre erguida | Túnica azul longa, chapéu pontudo, cajado com gema na ponta |

Essas silhuetas são o ponto de partida; cada raça abaixo aplica ajustes de proporção, paleta e "sotaque visual" em cima delas — sem mudar o que identifica a classe (arma, pose, cor-base do equipamento).

**Nota sobre a pendência Orc x Bárbaro**: a descrição "pouca roupa, tira de couro, machado de duas mãos" é da silhueta da classe **Bárbaro**, e vale pra qualquer raça que rolar Bárbaro. O que diferencia um Bárbaro Orc de um Bárbaro Humano é só a raça por baixo (pele, proporção, traços), não o equipamento.

---

## Humano

Proporção de referência (baseline pra todas as outras raças). Pele em tons variados (claro a moreno), sem traço exagerado — é o "meio-termo" visual do grupo. Equipamento sem modificação especial.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | Corpo proporcional, expressão neutra/determinada | Aço cinza (#8A8F98), couro marrom (#6B4A2F), detalhe vermelho no brasão |
| Bárbaro | Musculatura visível, cabelo bagunçado | Pele bronzeada, couro cru (#8B5E3C), lâmina do machado cinza-aço |
| Caçador | Postura ágil, cabelo curto | Verde-floresta (#3F6B4A), marrom-couro, detalhe de flechas em madeira clara |
| Assassino | Rosto parcialmente coberto | Preto (#1C1C1E), roxo-escuro nos detalhes (#3B2A4A) |
| Clérigo | Expressão calma | Branco-marfim (#F2ECE4), dourado (#D4AF37) nos ornamentos |
| Mago | Barba ou cabelo comprido opcional | Azul-real (#2C4A8C), detalhes prateados, gema azul-clara no cajado |

## Orc

Pele verde (tons de #4E7A3C a #3D5C2E), compleição maior e mais larga que o humano, presas inferiores visíveis, sobrancelha cerrada. Equipamentos tendem a ficar mais crus/reforçados — cordas, ossos, metal batido — reforçando a brutalidade. Cicatrizes de batalha são um bom detalhe opcional.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | Escudo maior e mais entalhado, armadura remendada | Verde-pele, metal enferrujado (#6E6259), couro escuro |
| Bárbaro | Presas em destaque, machado maior que o do Humano | Verde-pele saturado, tira de couro vermelho-sangue, olhos vermelhos |
| Caçador | Arco mais rústico (madeira nodosa) | Verde-pele, marrom-terra, detalhes em osso (#DCD3C0) |
| Assassino | Capuz mais simples/improvisado | Verde-pele escuro, preto fosco, detalhes em couro cru |
| Clérigo | Símbolo sagrado mais tribal/xamânico | Verde-pele, branco-osso, acentos em vermelho-sangue |
| Mago | Cajado com adorno de osso/dente em vez de metal fino | Verde-pele, azul-acinzentado na túnica, gema esverdeada |

## Halfling

Baixo (aprox. 70% da altura do Humano), corpo mais redondo e atarracado, pés grandes (podem aparecer descalços), sem barba, expressão sempre leve/travessa. Equipamentos em versões reduzidas e proporções "fofas", cores mais alegres reforçando a leveza.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | Escudo proporcionalmente grande pro tamanho do corpo | Pele clara/corada, armadura de couro reforçado, azul nos detalhes |
| Bárbaro | Visual "valentão pequeno", ainda intimida pela pose | Pele corada, tira de couro marrom, olhos vermelhos |
| Caçador | Extremamente ágil, arco pequeno mas eficiente | Verde-oliva, marrom-claro, capuz bege |
| Assassino | Silhueta discreta, ótimo pra furtividade | Cinza-escuro, roxo-acinzentado |
| Clérigo | Expressão doce, vestimenta clara e simples | Bege-claro (#EFE3D0), dourado suave |
| Mago | Chapéu proporcionalmente grande, quase caindo | Azul-claro, roxo-lavanda nos detalhes |

## Anão

Baixo mas robusto (mais largo que o Halfling, ombros grandes), barba longa e trançada, pele avermelhada/curtida (associação com forjas), elmo ou capacete resistente. Equipamento em metal grosso, rebites visíveis, gravações — reforça a ideia de robustez e trabalho manual.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | Escudo com gravações rúnicas, armadura pesada | Metal escuro (#4A4A52), barba ruiva ou grisalha, couro marrom-escuro |
| Bárbaro | Barba trançada balançando, machado curto e largo | Pele avermelhada, tira de couro escuro, olhos vermelhos |
| Caçador | Besta em vez de arco longo é uma opção temática (ou arco curto reforçado) | Marrom-escuro, metal fosco |
| Assassino | Postura mais "encorpada" que o padrão de assassino | Preto-acinzentado, detalhes em metal escovado |
| Clérigo | Símbolo sagrado gravado em metal, não em pano | Branco-acinzentado, dourado-bronze |
| Mago | Cajado mais curto e grosso, gema encaixada em metal | Azul-petróleo, prata envelhecida |

## Morto-vivo

Pele pálida acinzentada ou levemente esverdeada, olhos brilhantes (verde ou azul-claro, únicos pontos de cor viva no rosto), roupas rasgadas e desbotadas, postura levemente encurvada. Equipamento em tecidos rasgados e metal enferrujado, tons esmaecidos — reforça a decadência.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | Armadura enferrujada e incompleta | Cinza-esverdeado na pele, metal oxidado (#5C5248), farrapos |
| Bárbaro | Ainda mais assustador — força "além da morte" | Pele acinzentada, tira de couro apodrecido, olhos verde-brilhante |
| Caçador | Arco rachado mas funcional, aljava puída | Cinza-pálido, marrom desbotado |
| Assassino | Encaixa muito bem tematicamente — quase invisível na penumbra | Preto desbotado, cinza-chumbo |
| Clérigo | Visual mais "cultista sombrio" que clérigo tradicional — vale definir se faz sentido na lore | Branco sujo/amarelado, dourado embaçado |
| Mago | Túnica puída, gema com brilho fantasmagórico | Azul-acinzentado, gema verde-fosforescente |

## Elfo

Alto e esguio (mais alto que o Humano), orelhas pontudas longas, feições finas, cabelo longo (solto ou preso), pele clara com leve luminosidade. Equipamento com acabamento elegante — bordados finos, madeira polida, prata — reforça a sofisticação.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | Armadura mais leve e ornamentada que a do Humano | Prata polida, verde-esmeralda nos detalhes |
| Bárbaro | Contraste interessante: elegância + fúria | Pele clara, tira de couro trançado, olhos vermelhos |
| Caçador | Arco longo e elegante — a classe mais "natural" pro Elfo | Verde-floresta, marrom-claro, detalhes em prata |
| Assassino | Movimento fluido, roupas ajustadas e leves | Roxo-escuro, preto-azulado |
| Clérigo | Vestimenta com bordados delicados | Branco-perolado, dourado-claro |
| Mago | A classe mais associada ao Elfo na maioria das referências de fantasia — cajado esguio e ornamentado | Azul-safira, prata, gema azul-clara |

---

## Como usar este documento

- **Como briefing pra artista**: cada linha da tabela já dá pose, equipamento e paleta — o suficiente pra um esboço inicial de cada combinação.
- **Como prompt pra ferramenta de geração de imagem** (Midjourney, Stable Diffusion, etc.), um template que você pode preencher usando as tabelas acima:

```
pixel art sprite of a [RAÇA] [CLASSE], chibi proportions, 32x32 tile, RPG game character,
[EQUIPAMENTO], [POSE], color palette of [PALETA PRINCIPAL], flat shading, dark outline,
transparent background, three-quarter top-down view, tiny RPG style, no background
```

Exemplo já preenchido (Elfo Mago):
```
pixel art sprite of an elf mage, chibi proportions, 32x32 tile, RPG game character,
long blue tunic, pointed hat, staff with a blue gem on top, contemplative pose with
one hand raised, color palette of sapphire blue, silver and light blue gem, flat shading,
dark outline, transparent background, three-quarter top-down view, tiny RPG style, no background
```

## Pendência levantada neste documento

- **Morto-vivo Clérigo**: a combinação de "clérigo" (classe ligada a cura/religião tradicional) com "morto-vivo" (raça) é meio contraditória tematicamente. Sugestão registrada na tabela é ir pra um visual mais "cultista sombrio", mas vale vocês decidirem se isso cabe na lore do jogo ou se preferem manter uma leitura mais literal (um morto-vivo que ainda serve a alguma entidade sagrada, por exemplo).
