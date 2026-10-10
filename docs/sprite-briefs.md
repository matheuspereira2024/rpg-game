# Brief de Sprites — Raça x Classe

Documento de referência visual pros 36 sprites de herói (6 raças x 6 classes). Serve como briefing pra um artista ou como base pra prompts em ferramentas de geração de imagem.

## Especificação técnica geral

- **Estilo**: pixel art chibi (cabeça grande, corpo curto), confirmado pelos assets já comprados (ver seção "Inventário de assets" abaixo).
- **Resolução real dos assets adquiridos**: frames de 100x100px, fundo transparente (RGBA). Substitui a estimativa inicial de 32x32 — vamos padronizar tudo em 100x100 pra manter compatibilidade com o que já foi comprado.
- **Escala no jogo**: 1 herói = 1 SQM = 1 tile do grid da arena (a proporção arena/herói de 1/40 a 1/80 fica pra quando formos desenhar as arenas).
- **Vista**: 3/4 top-down.
- **Estados de animação já no padrão dos assets comprados**: Idle, Walk, Attack01, Attack02, Hurt, Death — cada um como uma tira horizontal de frames de 100x100. Personagens à distância também trazem um arquivo `_Effect` separado com o projétil (já é o que cobre a pendência de sprites de projétil pra esses casos).
- **Variante "with shadows"**: cada personagem tem uma versão com sombra própria embutida e outra sem — escolher uma e manter consistente no jogo todo.

## Inventário de assets já comprados (Tiny RPG Character Asset Pack 01 e 02)

Vasculhei a pasta "Tiny RPG Character Asset Pack" que você adicionou ao repositório. São dois pacotes:

- **Pack 01 — 22 personagens "heroicos/fantasia clássica"**: Archer, Armored Axeman, Armored Orc, Armored Skeleton, Bat, Elite Orc, Greatsword Skeleton, Knight, Knight Templar, Lancer, Necromancer, Orc, Orc rider, Priest, Skeleton, Skeleton Archer, Slime, Soldier, Swordsman, Werebear, Werewolf, Wizard. **Este é o pack relevante pra gente.**
- **Pack 02 — 20 personagens "demoníacos/monstro"**: Black Knight (A/B/C), Blood Monster, Demon (A-E), Demoness, Eyeball Monster, Flame Golem, Ghostfire, Hellbat, Hellhound, Lava Slime, Minotaur, Warlock. Estilo mais de monstro/chefe — melhor aproveitado depois como inimigo de fases avançadas do que como base racial dos heróis.

Abri visualmente alguns sprites do Pack 01 (Wizard, Priest, Orc, Skeleton, Necromancer, Archer, Knight) pra conferir o estilo — bate exatamente com o visual chibi/pixel pequeno que você quer.

### Mapeamento direto (reaproveitar como base, com ajuste de paleta se precisar)

| Nossa combinação | Personagem do pack | Observação |
|---|---|---|
| Humano Mago | Wizard | Já é robe azul + chapéu pontudo — quase idêntico ao brief que escrevi |
| Humano Clérigo | Priest | Robe clara, já vem com projétil de magia; paleta pode puxar mais pro branco/dourado |
| Humano Caçador | Archer | Já vem com projétil de flecha |
| Humano Guerreiro | Knight / Soldier / Swordsman | Três variações de guerreiro armado já existem — dá pra escolher a que mais bate ou usar as três como variação visual dentro da mesma classe |
| Morto-vivo (base racial) | Skeleton / Armored Skeleton / Greatsword Skeleton | Já são esqueletos — cobre boa parte da raça direto |
| **Morto-vivo Cultista Sombrio** | **Necromancer** | Encaixe quase perfeito — capuz escuro, robe sombrio, já é tematicamente "cultista". Resolve a classe especial que você pediu. |
| Orc (base racial) | Orc / Armored Orc / Elite Orc / Orc rider | Já são orcs verdes com variações de equipamento — dá pra escolher qual vira qual classe |

Isso também resolve, parcialmente, a pendência de sprites de ataque/projétil: pra essas combinações, os frames de Attack01/Attack02 e os projéteis já existem prontos no pack.

### Lacunas (nada nos dois packs cobre isso — precisa de fonte nova ou geração)

- **Classe Bárbaro** (torso nu, machado grande, olhos vermelhos): não existe em nenhum dos dois packs. Elite Orc e Werebear chegam perto na "brutalidade" mas não têm a pose/arma certa.
- **Classe Assassino** (par de adagas, capuz furtivo): não existe nenhum personagem tipo ladino/rogue em nenhum dos dois packs.
- **Raças Halfling, Anão e Elfo**: nenhum dos dois packs tem corpo baixo-e-redondo (Halfling), baixo-e-robusto-com-barba (Anão) ou alto-e-esguio-com-orelhas-pontudas (Elfo). Todo mundo no Pack 01 tem proporção humana padrão ou é Orc/Esqueleto/monstro.

### Plano sugerido

1. **Fase 1**: usar o Pack 01 direto pra Humano, Orc e Morto-vivo nas classes já cobertas (Guerreiro, Caçador, Mago, Clérigo/Cultista Sombrio) — praticamente pronto pra importar e testar no jogo.
2. **Fase 2**: resolver as lacunas de classe (Bárbaro e Assassino) — como nenhum dos dois packs tem, esses dois precisam vir de outra fonte (outro pack comprado, ou geração via IA seguindo o brief de paleta/pose que já escrevi acima).
3. **Fase 3**: resolver as lacunas de raça (Halfling, Anão, Elfo) — mesma lógica, precisa de outra fonte específica pra esses corpos, já que nenhum personagem dos dois packs serve nem de base pra edição.

## Silhueta base por classe (vale pra todas as raças)

| Classe | Pose | Equipamento base |
|---|---|---|
| Guerreiro | Ereta, defensiva | Armadura leve, escudo redondo pequeno (madeira+metal), espada de uma mão |
| Bárbaro | Inclinada pra frente, agressiva | Torso parcialmente nu, tira de couro cruzando o peito, machado de duas mãos apoiado no ombro, olhos vermelhos |
| Caçador | Alerta, semi-agachada | Roupa de couro ajustada, capuz/boné leve, arco na mão, aljava de flechas nas costas |
| Assassino | Furtiva, agachada | Roupa preta/couro ajustada, capuz cobrindo parte do rosto, uma adaga em cada mão |
| Clérigo | Serena, ereta | Vestimenta longa clara (branco/dourado), cajado com emblema no topo, símbolo sagrado no peito |
| Mago | Contemplativa, mão livre erguida | Túnica azul longa, chapéu pontudo, cajado com gema na ponta |

Essas silhuetas são o ponto de partida; cada raça abaixo aplica ajustes de proporção, paleta e "sotaque visual" em cima delas — sem mudar o que identifica a classe (arma, pose, cor-base do equipamento).

**Decisão sobre o símbolo do Clérigo**: nada de cruz ou iconografia cristã — o RPG não deve remeter a religiões reais. O símbolo sagrado do Clérigo (no peito e no topo do cajado) é um **emblema solar/roda de luz dourada** (círculo com raios, tipo um sol estilizado), validado na v2 do Humano. Usar essa mesma ideia de símbolo pras outras raças (adaptando cor/material conforme o "sotaque visual" de cada uma).

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
| Guerreiro | Escudo maior e mais entalhado, armadura remendada, lenço vermelho (em vez do azul do Humano) | Verde-pele, metal enferrujado (#6E6259), couro escuro, lenço vermelho |
| Bárbaro | Presas em destaque, machado maior que o do Humano | Verde-pele saturado, tira de couro vermelho-sangue, olhos vermelhos |
| Caçador | Arco mais rústico (madeira nodosa) | Verde-pele, marrom-terra, detalhes em osso (#DCD3C0) |
| Assassino | Capuz mais simples/improvisado | Verde-pele escuro, preto fosco, detalhes em couro cru |
| Clérigo | Símbolo sagrado mais tribal/xamânico (mesmo emblema solar dourado do Humano) | Verde-pele, branco-osso, acentos em vermelho-sangue |
| Mago | **Atualizado (aprovado):** capuz vermelho no lugar do chapéu pontudo, cajado com pedra/chama vermelha na ponta (tema de fogo, substitui a ideia original de osso/dente) | Verde-pele, túnica vermelha, pedra vermelha no cajado |

## Halfling

Baixo (aprox. 70% da altura do Humano), corpo mais redondo e atarracado, pés grandes (podem aparecer descalços), sem barba, expressão sempre leve/travessa. Equipamentos em versões reduzidas e proporções "fofas", cores mais alegres reforçando a leveza.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | Escudo redondo compacto pro tamanho do corpo, lenço vermelho (mesmo padrão usado em outras raças) | Pele clara/corada, armadura de couro e metal, lenço vermelho |
| Bárbaro | Visual "valentão pequeno" — armadura de peles e ossos, machado de duas lâminas | Pele corada, peles/ossos, lâmina prateada |
| Caçador | **Atualizado (aprovado):** usa besta (crossbow) em vez de arco longo, virotes na aljava — mantém capuz verde | Verde-floresta (capuz/manto), marrom-couro |
| Assassino | Capuz escuro cobrindo o rosto, par de adagas, silhueta discreta | Roxo-acinzentado escuro, detalhes em couro |
| Clérigo | Vestimenta clara com dourado, mesmo emblema solar das outras raças | Branco, dourado |
| Mago | **Atualizado (aprovado):** chapéu marrom (era azul-claro) e túnica verde (era azul/lavanda), gema verde no cajado | Marrom (chapéu), verde (túnica), gema verde |

## Anão

Baixo mas robusto (mais largo que o Halfling, ombros grandes), barba longa e trançada, pele avermelhada/curtida (associação com forjas), elmo ou capacete resistente. Equipamento em metal grosso, rebites visíveis, gravações — reforça a ideia de robustez e trabalho manual.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | **Atualizado (aprovado):** machado de uma mão no lugar da espada (mantém o escudo), lenço vermelho, barba ruiva | Metal escuro/prateado, couro marrom-escuro, lenço vermelho |
| Bárbaro | Barba trançada balançando, tatuagens nos braços, torso nu | Pele clara/corada, tira de couro, machado de duas mãos |
| Caçador | Capa/manto verde, arco e aljava | Verde-floresta, marrom-couro |
| Assassino | Capuz escuro cobrindo a cabeça, postura mais "encorpada" que o padrão de assassino | Preto-acinzentado, detalhes em metal escovado |
| Clérigo | Símbolo sagrado (mesmo emblema solar dourado das outras raças) | Branco-acinzentado, dourado-bronze |
| Mago | **Atualizado (aprovado):** capuz verde no lugar de qualquer chapéu, cajado longo e retorcido com gema verde na ponta (substitui a ideia original de cajado curto/azul-petróleo) | Verde-floresta, dourado nos detalhes, gema verde |

## Morto-vivo

Pele pálida acinzentada ou levemente esverdeada, olhos brilhantes (verde ou azul-claro, únicos pontos de cor viva no rosto), roupas rasgadas e desbotadas, postura levemente encurvada. Equipamento em tecidos rasgados e metal enferrujado, tons esmaecidos — reforça a decadência.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | **Entregue (v1):** armadura completa e ornamentada (elmo, ombreiras espinhadas, escudo, capa vermelha) — diverge do brief original ("enferrujada e incompleta"), ficou mais "cavaleiro morto" que "morto-vivo decadente" | Metal prateado, capa vermelha, crânio à mostra |
| Bárbaro | **Entregue (v1):** armadura de peles e ossos, machado de duas lâminas, colar de ossos — bate bem com "força além da morte" | Pele acinzentada, ossos, lâmina prateada |
| Caçador | **Entregue (v1):** capuz verde, besta (crossbow) em vez de arco — mesma troca aplicada no Halfling, mantém consistência entre raças pra essa classe | Verde, marrom-couro |
| Assassino | **Entregue (v1):** capuz escuro, par de adagas, cinto com caveira | Roxo-escuro/preto |
| ~~Clérigo~~ → **Cultista Sombrio** *(classe substituta, possivelmente exclusiva do Morto-vivo — mecânica exata a definir)* | **Entregue (v1):** capuz claro (bege/creme), cajado dourado com caveira encimada por raios (visual "solar"), símbolo de estrela no peito — **diverge do brief original**, que pedia paleta escura/profana (preto-arroxeado, roxo-sombrio, verde-fosforescente); saiu com a mesma linguagem dourada/clara do Clérigo das outras raças, o que quebra um pouco o contraste "luz sagrada vs. culto sombrio" que era a ideia original. Vale revisar na rodada de nivelamento. | Bege/creme, dourado, estrela |
| Mago | **Entregue (v1):** túnica e chapéu roxos bem preservados (não "puída" como no brief), cajado longo com gema verde brilhante e fumaça mágica | Roxo, dourado nos detalhes, gema verde |

**Nota sobre esta entrega (v1)**: o nível de detalhe (gravações em metal, pelagem, efeitos de magia, acabamentos) ficou o mais rico de todas as 6 raças até agora — reforça o padrão de "enriquecimento progressivo" já registrado no `design-doc.md`. Combinado com o desvio de paleta do Cultista Sombrio, esta é a raça que mais precisa de ajuste na rodada de nivelamento futura.

## Elfo

Esguio, **mesma altura do Humano** (decisão fechada depois do teste de proporção — texto antigo dizia "mais alto", corrigido aqui), orelhas pontudas longas, feições finas, cabelo longo (solto ou preso), pele clara com leve luminosidade. Equipamento com acabamento elegante — bordados finos, madeira polida, prata — reforça a sofisticação.

| Classe | Traço racial aplicado | Paleta principal |
|---|---|---|
| Guerreiro | Armadura mais leve e ornamentada que a do Humano, escudo com emblema de árvore dourado | Prata polida, verde-esmeralda nos detalhes |
| Bárbaro | Contraste interessante: elegância + fúria, tatuagens nos braços | Pele clara, tira de couro trançado |
| Caçador | Arco longo e elegante — a classe mais "natural" pro Elfo | Verde-floresta, marrom-claro, detalhes em prata |
| Assassino | Movimento fluido, roupas ajustadas e leves, capuz | Preto-azulado, dourado nos detalhes |
| Clérigo | Vestimenta com bordados delicados, mesmo emblema solar dourado das outras raças | Branco-perolado, verde, dourado-claro |
| Mago | **Atualizado (aprovado):** túnica e gema mágica na cor roxa (pedido específico, substitui a ideia original azul-safira) | Roxo, dourado nos detalhes, gema roxa |

---

## Pasta de referências padrão pra treino de modelo

Extraí um frame único (100x100px) de cada um dos 42 personagens dos dois packs comprados (pose Idle; pra Bat, Blood Monster_B, Ghostfire e Hellbat — criaturas voadoras sem pose parada — usei o frame de Flying no lugar). Ficaram organizados em:

`Tiny RPG Character Asset Pack/Standard References/Pack 01/<nome>.png` (22 arquivos)
`Tiny RPG Character Asset Pack/Standard References/Pack 02/<nome>.png` (20 arquivos)

Essa pasta é a fonte pra subir em ferramentas de treino de modelo de geração de personagem (uma imagem limpa por personagem, sem múltiplos frames).

## Como pedir pixel art "de verdade" (paleta travada, pronta pra animação)

A análise técnica no `design-doc.md` mostrou que tanto as renders raça x classe quanto a arte de conceito v3-simplificado são, tecnicamente, pintura digital com milhares de cores — não pixel art de paleta travada como os sprites reais do Tiny RPG Pack (26-32 cores). Pra pedir pro gerador produzir algo mais próximo do "leve de verdade" (mais fácil de manter consistente entre Idle/Walk/Attack), mude o prompt assim:

**Evitar**: "HD pixel art", "detailed", "ornate", "highly detailed", "intricate" — esses termos empurram o modelo pra sombreamento suave em gradiente.

**Pedir explicitamente**:
- "limited color palette (16-24 colors)"
- "flat shading with hard color bands, no gradients"
- "no anti-aliasing, no soft shadows"
- "uniform dark outline, single pixel width"
- Referenciar um estilo real de baixo-bit em vez de "pixel art" genérico: "in the style of 16-bit era SNES/GBA RPG sprites", "like Stardew Valley or RPG Maker character sprites"
- Resolução pequena e explícita: "32x32 pixel sprite" ou "48x48 pixel sprite" (canvas pequeno ajuda — a v3-simplificado, menor, já saiu mais "limpa" mesmo sem reduzir cores de verdade)

**Prompt revisado** (substitui o template antigo mais abaixo neste documento):
```
pixel art sprite of a [RAÇA] [CLASSE], 32x32 pixel grid, limited color palette
(16-24 colors max), flat shading with hard color bands, no gradients, no
anti-aliasing, uniform single-pixel dark outline, in the style of 16-bit era
SNES/GBA RPG character sprites (like Stardew Valley or RPG Maker sprite
sheets), chibi proportions, [EQUIPAMENTO], [POSE], transparent background,
three-quarter top-down view
```

**Ressalva**: ferramentas de geração de imagem genéricas (as que geraram as artes raça x classe) tendem a resistir e ainda devolver sombreamento suave, mesmo com esse prompt — foram treinadas majoritariamente em arte digital pintada. Ferramentas especializadas em pixel art (PixelLab.ai, que já estamos testando) têm mais chance de acertar de primeira, por serem otimizadas pra esse tipo de saída. Por isso o pipeline real de Idle/Walk/Attack deve passar por elas (ou pelo Tiny RPG Pack já comprado), não pela ferramenta usada nas artes de conceito.

**Se mesmo assim vier com muitas cores**: dá pra forçar depois com quantização de cor por código (reduzir a imagem gerada pra uma paleta fixa de N cores) — consigo fazer isso aqui assim que tivermos uma imagem de teste nesse estilo novo.

## Prompt final pra pedir o resultado igual à imagem de referência (v3-simplificado)

Isto é o texto pronto pra colar na ferramenta, **anexando junto a imagem `racas-do-mundo-concept-v3-simplificado.png`** como referência de escala/estilo (essa é a imagem que você aprovou de proporção e detalhe — não deixe a ferramenta "melhorar" ou enriquecer em cima dela).

```
Use a imagem em anexo como referência EXATA de escala, proporção e nível de
detalhe — não aumente o nível de detalhe nem adicione mais camadas de sombra
do que a referência tem.

Gere pixel art no seguinte padrão:
- Canvas com proporção 3:1 (largura x altura), igual à referência anexada.
- Personagens na mesma escala/tamanho da referência.
- Fundo preto puro — sem gradiente, sem brilho, sem vinheta atrás do personagem.
- Paleta de cores limitada (16 a 24 cores por personagem), sombreamento em
  blocos de cor chapada (sem gradiente suave, sem anti-aliasing), contorno
  escuro único e uniforme.
- Todos os personagens na mesma linha de base (pés alinhados) e mesma escala
  de equipamento entre si.
- Ordem fixa da esquerda pra direita: Caçador, Ladino, Mago, Clérigo,
  Guerreiro, Bárbaro.
- Altura relativa entre raças igual à referência: Humano e Elfo na mesma
  altura; Halfling o mais baixo do grupo (~70% da altura do Humano); Anão
  baixo e largo; Orc um pouco maior que o Humano; Morto-vivo na altura de
  referência (igual ao Humano).

Personagem: [RAÇA] [CLASSE].
Equipamento e pose: [conforme a tabela "Brief consolidado" abaixo, célula
da raça x classe correspondente].
Paleta desta combinação: [conforme a mesma tabela].
```

Exemplo já preenchido (Anão Guerreiro, puxando da tabela abaixo):
```
Personagem: anão guerreiro.
Equipamento e pose: machado de uma mão (NÃO espada) + escudo, pose ereta e
defensiva.
Paleta desta combinação: metal escuro/prateado, couro marrom-escuro, lenço
vermelho, barba ruiva.
```

## Brief consolidado pra gerar a matriz de 36 numa passada só (regras finais aprovadas)

Quando a geração é feita raça por raça, cada raça mantinha as decisões da rodada anterior. No formato de matriz única (6 raças x 6 classes numa imagem só), a ferramenta perdeu vários detalhes já aprovados — todo mundo saiu com besta em vez da arma certa por classe/raça, as cores de túnica não bateram com a raça, e o Guerreiro Anão voltou a segurar espada em vez do machado. Esta tabela reúne **a regra final de cada célula** (arma/equipamento obrigatório + paleta obrigatória) pra colar direto no prompt da matriz e evitar essa perda de detalhe. **Itens em maiúscula/negrito são os que mais escaparam da última tentativa — reforçar com mais peso no prompt.**

### Humano
| Classe | Arma/equipamento obrigatório | Paleta obrigatória |
|---|---|---|
| Guerreiro | Espada de uma mão + escudo redondo | Aço cinza, couro marrom, detalhe vermelho no brasão |
| Bárbaro | Machado de duas mãos | Pele bronzeada, couro cru, lâmina cinza-aço |
| Caçador | **ARCO** (não besta) + aljava de flechas | Verde-floresta, marrom-couro |
| Ladino/Assassino | Duas adagas | Preto, roxo-escuro |
| Clérigo | Cajado com emblema solar dourado no topo | Branco-marfim, dourado |
| Mago | Chapéu pontudo + cajado com gema | Azul-real, prateado, **gema AZUL-CLARA** |

### Orc
| Classe | Arma/equipamento obrigatório | Paleta obrigatória |
|---|---|---|
| Guerreiro | Espada + escudo maior entalhado | Verde-pele, metal enferrujado, couro escuro, **lenço VERMELHO** |
| Bárbaro | Machado de duas mãos (maior que o do Humano) | Verde-pele saturado, couro vermelho-sangue, olhos vermelhos |
| Caçador | **ARCO** rústico (madeira nodosa) + aljava | Verde-pele, marrom-terra, detalhes em osso |
| Ladino/Assassino | Duas adagas, capuz simples/improvisado | Verde-pele escuro, preto fosco |
| Clérigo | Cajado com emblema solar dourado (mesmo símbolo, sotaque tribal) | Verde-pele, branco-osso, acentos vermelho-sangue |
| Mago | **CAPUZ VERMELHO** (não chapéu) + cajado com pedra/chama | Verde-pele, túnica vermelha, **gema/pedra VERMELHA** |

### Halfling
| Classe | Arma/equipamento obrigatório | Paleta obrigatória |
|---|---|---|
| Guerreiro | Espada + escudo redondo compacto | Pele clara/corada, couro+metal, **lenço VERMELHO** |
| Bárbaro | Machado de duas lâminas, armadura de peles e ossos | Pele corada, peles/ossos |
| Caçador | **BESTA (crossbow)** + virotes, capuz VERDE | Verde-floresta, marrom-couro |
| Ladino/Assassino | Duas adagas, capuz escuro | Roxo-acinzentado escuro |
| Clérigo | Cajado com emblema solar dourado | Branco, dourado |
| Mago | **CHAPÉU MARROM** (não azul) + **TÚNICA VERDE** (não azul/lavanda) | Marrom, verde, **gema VERDE** |

### Anão
| Classe | Arma/equipamento obrigatório | Paleta obrigatória |
|---|---|---|
| Guerreiro | **MACHADO de uma mão** (não espada!) + escudo | Metal escuro/prateado, couro marrom-escuro, **lenço vermelho, barba ruiva** |
| Bárbaro | Machado de duas mãos, torso nu, tatuagens nos braços | Pele clara/corada, couro, **barba trançada** |
| Caçador | **ARCO** (não besta) + aljava, capa/manto verde | Verde-floresta, marrom-couro |
| Ladino/Assassino | Duas adagas, capuz escuro | Preto-acinzentado, metal escovado |
| Clérigo | Cajado com emblema solar dourado | Branco-acinzentado, dourado-bronze |
| Mago | **CAPUZ VERDE** (não chapéu) + cajado longo retorcido | Verde-floresta, dourado, **gema VERDE** |

### Elfo
| Classe | Arma/equipamento obrigatório | Paleta obrigatória |
|---|---|---|
| Guerreiro | Espada + escudo com emblema de árvore dourado, armadura leve ornamentada | Prata polida, verde-esmeralda |
| Bárbaro | Machado de duas mãos, tatuagens nos braços | Pele clara, couro trançado |
| Caçador | **ARCO** longo elegante + aljava | Verde-floresta, marrom-claro, prata |
| Ladino/Assassino | Duas adagas, capuz, movimento fluido | Preto-azulado, dourado |
| Clérigo | Cajado com emblema solar dourado, bordados delicados | Branco-perolado, verde, dourado-claro |
| Mago | Chapéu/capuz + cajado com gema | Roxo, dourado, **gema ROXA** (não azul-safira) |

### Morto-vivo
| Classe | Arma/equipamento obrigatório | Paleta obrigatória |
|---|---|---|
| Guerreiro | Espada + escudo, capa vermelha — **armadura enferrujada/incompleta, evitar armadura impecável** | Cinza-esverdeado na pele, metal oxidado, farrapos |
| Bárbaro | Machado de duas lâminas, armadura de peles e ossos | Pele acinzentada, ossos, olhos verde-brilhante |
| Caçador | **BESTA (crossbow)** + virotes, capuz verde | Cinza-pálido/esverdeado, marrom desbotado |
| Ladino/Assassino | Duas adagas, capuz escuro | Preto desbotado, cinza-chumbo |
| **Cultista Sombrio** (não Clérigo) | Cajado com **símbolo PROFANO** (não o emblema solar dourado das outras raças!) | **Preto-arroxeado, roxo-sombrio** — **NÃO usar bege/dourado/claro**, acentos verde-fosforescente |
| Mago | Cajado com gema fantasmagórica | Azul-acinzentado, **gema verde-fosforescente** |

### Traços raciais a manter em todas as classes (não muda por classe)
- **Humano**: proporção de referência, pele variada, sem exagero.
- **Orc**: pele verde, presas inferiores, compleição maior/mais larga.
- **Halfling**: baixo (~70% da altura do Humano — reforçar isso explicitamente, foi o maior desvio encontrado até agora), corpo redondo, sem barba.
- **Anão**: baixo e robusto (mais largo que o Halfling), barba longa trançada.
- **Elfo**: mesma altura do Humano, orelhas pontudas longas, feições finas.
- **Morto-vivo**: pele pálida/acinzentada ou rosto de caveira, olhos verde-brilhante, roupas rasgadas.

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

## Decisão registrada

- **Morto-vivo não usa a classe Clérigo padrão.** No lugar, recebe a classe **Cultista Sombrio** — visual e tematicamente mais alinhado à raça. Ainda em aberto: se isso é uma classe especial exclusiva do Morto-vivo (7ª classe, só disponível pra essa raça) ou uma reskin que substitui o Clérigo apenas nessa combinação. Restrições de raça x classe em geral ficam pra uma etapa futura de definição.
