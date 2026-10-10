# Mapa do RPG Game

Levantamento: **09/09/2026**. Guia de continuidade para localizar informações e retomar o desenvolvimento sem perder decisões anteriores.

Atualização da mesma data: plataforma inicial **navegador** aprovada; abas Inventário, Invocação e Aventura (mapa com arenas/masmorras de dificuldade crescente). Geração de personagens é o primeiro sistema em discussão. Referência de chances e cores preservada em `docs/referencias/raridades-qualidades-2026-09-09.png`.

## Atualização: primeira página implementada

O estado de “sem código” descrito no levantamento abaixo é histórico. Agora existe `invocacao-web/`: protótipo React/TypeScript/Vinext com tela de invocação, fundo e baú gerados, portraits da matriz FINAL, coleção simples e persistência D1. Leia `invocacao-web/README.md` para executar e localizar os sistemas. Não é uma implementação em Godot.

- `invocacao-web/app/page.tsx` e `app/globals.css`: interface e animação.
- `invocacao-web/lib/game.ts`: sorteios e atributos.
- `invocacao-web/app/api/game/route.ts`, `lib/queries.ts`, `db/schema.ts`, `drizzle/`: operações e banco.
- Invocar custa 10; reciclar devolve 5; **o ID de personagem só nasce no aceite**. Candidato pendente tem apenas token da operação, não ID de herói.
- Protótipo usa sessão de demonstração com 100 cristais, sem conta recuperável. Sorteios de raridade/qualidade independentes, raças/classes equiprováveis, nomes por raça e bônus de Clérigo para Cultista são parâmetros provisórios. IDs são únicos no banco central da implantação; bancos locais de desenvolvimento são separados.
- Arte nova e prompts em `invocacao-web/public/art/` e `invocacao-web/ARTES.md`. Inventário antigo não enumera dependências, builds ou arquivos novos desse projeto.
- A matriz FINAL também foi recortada deterministicamente em 36 portraits individuais em `assets/portraits/<raça>/<classe>.png`: todos 256×256, fundo preto, silhueta centralizada; Halflings a 92%. O índice técnico está em `assets/portraits/manifest.json`, a revisão conjunta em `_contato-36.png` e o gerador reproduzível em `tools/split-hero-matrix.mjs`. Esses recortes permanecem preservados como referência histórica; desde 15/09/2026, a revelação e a coleção usam os 36 sprites-base Idle V1 transparentes de `invocacao-web/public/art/arena/heroes/`.

### Experimento de arena

A rota `invocacao-web/app/arena/` contém a escala visual de arena aprovada em 10/09/2026: câmara de pedra com 30 colunas por 20 linhas, 36 px por SQM e área jogável de 1080×720 px. As paredes são uma moldura externa e não ocupam células. Um humanoide comum ocupa logicamente 1 SQM e tem cerca de 48 px de altura visual; armas e corpo podem ultrapassar a célula. Os personagens atuais dos packs são referências temporárias até a produção dos sprites próprios. Posicionamento interativo, obstáculos, entradas e regras de combate continuam sem implementação.

O primeiro sprite próprio de calibração é `assets/sprites/humano/guerreiro-idle-v1.png`, também copiado para `invocacao-web/public/art/arena/` e exibido na arena. Ele preserva a identidade do portrait, usa emblema solar e possui transparência real; ainda é um quadro parado experimental, sem animações.

Em 15/09/2026 foi padronizada a árvore de inimigos próprios em `assets/sprites/inimigos/<criatura>/`: cada criatura mantém na raiz sua referência Idle de 256×256 e uma pasta `animations/`; fontes maiores, quando existirem, ficam separadas em `source/`. O espelho público usa `invocacao-web/public/art/arena/enemies/<criatura>/`. A rota `/arena/inimigos`, ligada à galeria de heróis e à página principal da arena, reúne as criaturas disponíveis. O Esqueleto Guerreiro é o primeiro inimigo simples próprio, com perspectiva 3/4 e apenas uma espada.

Ainda em 15/09/2026, os pacotes AutoSprite V1 das seis classes humanas e do Esqueleto Guerreiro foram importados. Cada personagem possui `idle`, `walk` e `attack` nas oito direções, com 25 quadros por animação; as fontes são 256×256 e os quadros de runtime foram normalizados para 68×68 por vizinho mais próximo. No Caçador, Clérigo e Mago, `attack` corresponde respectivamente a Tiro Preciso, Projétil Sagrado e Projétil Arcano. Cast e o golpe físico de cajado do Mago foram excluídos. A rota `/arena` executa uma demonstração sem colisão ou dano: os seis humanos caminham para leste, o Esqueleto caminha para oeste, todos atacam e o ciclo reinicia.

Revisão visual de 15/09/2026: os ataques importados do Clérigo incorporaram o projétil no mesmo canvas e encostaram nas bordas em várias direções; o Caçador também variou a escala corporal durante o disparo. Para a próxima geração, o personagem deve manter escala, câmera e âncora dos pés fixas e executar somente o gesto de disparo. Flecha, Projétil Sagrado e Orbe Arcano passam a ser assets separados, movimentados pela lógica da arena.

Em 16/09/2026, o Orbe Arcano V1 do Mago tornou-se o primeiro projétil separado implementado. A fonte de produção está em `assets/projectiles/mago/orbe-arcano-v1.png`, com espelho público em `invocacao-web/public/art/arena/projectiles/`. Na demonstração `/arena`, a lógica lança o orbe durante o ataque East do Mago e o movimenta até o Esqueleto Guerreiro; colisão, dano e efeito de impacto continuam pendentes.

Ainda em 16/09/2026, o pacote V2 do Clérigo Humano substituiu seus quadros de Idle, Walk e ataque no runtime. O ataque `Projétil Sagrado` tem 16 quadros por direção, enquanto Idle e Walk mantêm 25; a arena respeita essa diferença. Um recorte determinístico do sol emitido originou `assets/projectiles/clerigo/projetil-sagrado-v1.png`, espelhado no diretório público e lançado durante o gesto do Clérigo. O pacote V1 e o Idle anterior foram preservados no diretório de produção.

Na revisão seguinte de 16/09/2026, o ponto inicial do Projétil Sagrado foi alinhado à ponta visível do cajado, o Caçador recebeu a flecha separada `assets/projectiles/cacador/flecha-v1.png` e todos os 4.272 quadros de runtime dos seis humanos e do Esqueleto Guerreiro foram padronizados. O contrato continua em canvas 68×68, agora com corpo Idle de referência próximo de 48 px e pés alinhados em Y=58; um fator fixo por personagem vale para todos os estados e direções. O processo reproduzível está em `tools/standardize-runtime-animation-scale.ps1`, e os ZIPs originais permanecem preservados.

Na revisão visual posterior, o sol do Projétil Sagrado V1 foi substituído no runtime por uma pequena esfera dourada de energia em `assets/projectiles/clerigo/projetil-sagrado-v2.png`; a fonte ImageGen foi preservada separadamente. O Walk do Caçador e do Assassino recebeu estabilização quadro a quadro pela mediana de cada direção, incluindo três correções de fechamento de loop. O Attack do Caçador foi reduzido em 8% e realinhado em Y=57 para não aumentar ao sair do Walk. O processo está em `tools/stabilize-ranged-animation-scale.ps1` e seus parâmetros em `assets/sprites/humano/ranged-animation-scale-v2.json`.

O Bárbaro recebeu uma correção complementar porque Walk e Attack do pacote-fonte eram menores que o Idle mesmo após a padronização geral. `tools/stabilize-barbarian-animation-scale.ps1` ajusta separadamente cada estado e direção dos 600 quadros para mediana visual de 49 px e pés em Y=58. Assim, o Bárbaro não fica menor que os demais humanos sem precisar regenerar a arte; os fatores estão em `assets/sprites/humano/barbaro/animations/scale-v2-metadata.json`.

A demonstração `/arena` agora exibe números de dano sobre o personagem atingido: o valor nasce acima do alvo, sobe e desaparece. Os eventos atuais são valores demonstrativos sincronizados aos golpes; ainda não reduzem a barra de Vida. A estrutura visual será alimentada pelos resultados do cálculo real quando o sistema de combate for implementado.

Em 16/09/2026, a demonstração `/arena` foi reduzida ao primeiro duelo funcional entre o Guerreiro Humano e o Esqueleto Guerreiro. Cada unidade seleciona o inimigo alcançável mais próximo, caminha a aproximadamente 1,35 SQM/s e para em uma célula adjacente sem ocupar a célula do adversário. Os golpes agora reduzem a barra de Vida; quando ela seria esgotada, volta imediatamente ao máximo para manter o duelo contínuo. Essa recuperação é exclusiva da demonstração, não uma regra de morte ou regeneração aprovada para o jogo final.

Ainda em 16/09/2026, a arena passou a exibir uma barra de Mana azul grudada abaixo da barra de Vida. A fórmula provisória é `Mana máxima = 20 + INT × 8`; a regeneração provisória é `0,5 + SAB × 0,15` por segundo. O duelo corpo a corpo atual não consome Mana, portanto as barras permanecem cheias até a definição de habilidades e custos.

Na revisão seguinte, o ataque corpo a corpo do duelo passou a durar 1 segundo. O dano é calculado no início da ação e aplicado visualmente aos 0,5 segundo. Vida Máxima usa `100 + CON × 10 + FOR × 2`. Cada golpe passou a variar com um dado de arma (`1d4`, `1d6`, `1d8` ou `1d12`) somado a Força e a uma parcela de Destreza; as duas espadas do duelo usam `1d8`. Sorte e uma parcela de Destreza determinam a chance de crítico, que lança duas vezes o dado. Armadura deriva de Constituição, parcelas de Força e Destreza e equipamento; sua redução segue uma curva de retornos decrescentes que tende ao limite de 75%. O painel sob a arena exibe Vida, Mana, regeneração, faixa normal de dano, crítico, Armadura e redução. No teste atual, o Guerreiro tem 210 de Vida e dano normal de 11–17; o Esqueleto tem 186 de Vida e dano normal de 8–13. Críticos podem superar essas faixas.

## 1. O que é o jogo

RPG gacha com combate automático em arenas. O jogador usa **Cristais de Invocação**, abre um baú que gera um herói aleatório, monta o time e posiciona os integrantes em slots predefinidos. Ao iniciar, os personagens se movimentam e atacam automaticamente. Os inimigos e suas posições são fixos por fase. A estratégia inicial está na composição e no posicionamento; habilidades e magias ficam para uma etapa posterior.

Mapa conceitual, baseado em `design-doc.md`:

```text
Cristais de Invocação → baú → herói aleatório
                              ├─ raça + classe
                              ├─ raridade + qualidade
                              ├─ seis atributos + bônus de classe
                              └─ identidade visual
                                  ├─ portrait: invocação / galeria / menus
                                  └─ sprite: combate na arena

Coleção de heróis → composição do time → slots da fase → combate automático
                                                        ├─ movimento no grid
                                                        ├─ alcance em SQM
                                                        └─ ataques básicos
```

O retorno do combate em recompensas, progressão e novos cristais ainda não está especificado nos documentos lidos. Não presumir uma economia já definida.

## 2. Estado real encontrado

Antes de adicionar este mapa: **872 arquivos**, sendo **782 PNG, 84 Aseprite, 4 Markdown e 2 ZIP**.

| Pasta principal | Arquivos | Papel |
|---|---:|---|
| `docs/` | 3 | Design, briefing visual atualizado e prompt de conceito racial |
| `Claude outputs/` | 1 | Brief histórico, com decisões antigas |
| `Arte Promocional/` | 15 | Conceitos, portraits e testes visuais |
| `Tiny RPG Character Asset Pack/` | 853 | Dois packs, fontes editáveis, animações, projéteis e referências isoladas |
| `assets/` | 0 | Estrutura preparada para os assets do jogo; ainda vazia |

Não foram encontrados código-fonte do jogo, cenas, configuração de engine, dependências, scripts de processamento, testes ou instruções de execução. `git status` confirmou que esta raiz não é um repositório Git, apesar do diretório pai se chamar `GIT`. Isso descreve somente esta pasta; não demonstra que não exista implementação em outro local.

Cobertura: enumeração recursiva de todas as pastas e arquivos, leitura dos quatro documentos Markdown originais e inspeção visual da matriz FINAL e do conceito racial v3. Os demais arquivos de imagem e Aseprite foram inventariados; não foi feita revisão visual de cada frame. As medições históricas de cores/proporções nos documentos não foram recalculadas.

## 3. Onde ler por assunto

| Preciso entender ou alterar… | Começar aqui | Observação |
|---|---|---|
| Conceito e geração de heróis | `docs/design-doc.md`, Conceito geral e seções 1–2 | Regras de gacha e atributos |
| Raridade, qualidade e indicadores de UI | `docs/design-doc.md`, seções 1–3 | Estrela = qualidade; borda = raridade |
| Ficha persistida e ID único de personagem | `docs/design-doc.md`, **Ficha de dados e identificador do personagem** | ID de 32 bits global entre jogadores; futuras trocas/compra/venda; implementação adiada |
| Arena, movimento e posicionamento | `docs/design-doc.md`, seção 4 | Slots fixos; combate automático |
| Ataques e alcance | `docs/design-doc.md`, seção 5 | Valores iniciais de 1 e 5 SQM |
| Roupa, arma e cor de uma combinação | `docs/sprite-briefs.md`, **Brief consolidado…** | Usar esta tabela antes dos exemplos antigos |
| Altura e identidade racial | `docs/design-doc.md`, **Alturas relativas…**, e conceito v3 | Separar intenção aprovada dos desvios das imagens |
| Arte oficial dos heróis | Matriz `FINAL-v1` na pasta Versao 2 | Portrait; ainda há ressalva de proporção do Halfling |
| Conversão para sprite | `docs/design-doc.md`, **Decisão de arquitetura…** e **Matriz v2…** | Processo descrito; script não encontrado |
| Animação | `docs/design-doc.md`, **Estilo de arte…** e **Mudança de ordem…** | Teste lateral; perspectiva de arena pendente |
| Reaproveitamento dos packs | `docs/sprite-briefs.md`, **Inventário de assets…** | Mapeamento e lacunas, não implementação |
| Referências individuais dos packs | `Tiny RPG Character Asset Pack/Standard References/` | 42 PNG: 22 + 20 |
| Prompt inicial das raças sem classe | `docs/concept-art-prompt-racas.md` | Histórico: ainda diz Elfo mais alto que Humano |
| Arquivo ou subpasta exata | `docs/INVENTARIO-ARQUIVOS.md` | Inclui diretórios vazios e caminhos completos relativos à raiz |

## 4. Regras de jogo a preservar

- **Raças:** Humano, Orc, Halfling, Anão, Morto-vivo e Elfo.
- **Classes:** Guerreiro, Bárbaro, Caçador, Assassino, Clérigo e Mago. A matriz chama Assassino de Ladino. São 36 combinações visuais; Morto-vivo/Clérigo vira Cultista Sombrio, cuja mecânica ainda está em aberto.
- **Atributos:** Força, Destreza, Constituição, Inteligência, Sabedoria e Sorte.
- **Ficha e identidade:** cada personagem aceito tem ID de 32 bits único globalmente entre jogadores; candidatos antes do aceite não têm ID de personagem. Uma estrela ao lado do nome indica qualidade por cor; a borda da moldura indica raridade. O protótipo usa sequência central limitada a uint32; proprietário separado. Troca, compra e venda são futuras; conta definitiva, transferências e moeda continuam pendentes.
- **Geração:** iniciar cada atributo em 1 (6 pontos fixos); distribuir aleatoriamente, ponto a ponto, mais `36 + bônus de qualidade + bônus de raridade`, sem pesos. Depois aplicar o bônus fixo de classe. Com os +2 de classe documentados, total final de 44 a 54 pontos; nenhum atributo começa zerado.
- **Cadência provisória de combate:** todos os heróis e inimigos executam 1 ação por segundo. Por enquanto a cadência é fixa e não recebe modificadores; Destreza poderá influenciar a velocidade de ataque numa revisão futura.

| Raridade | Bônus | Chance | Borda de referência |
|---|---:|---:|---|
| Comum | +0 | 70% | Cinza |
| Incomum | +1 | 22% | Verde |
| Raro | +3 | 6% | Azul |
| Épico | +5 | 1,90% | Roxo |
| Lendário | +7 | 0,10% | Laranja/ocre |

| Qualidade | Bônus | Chance | Estrela de referência |
|---|---:|---:|---|
| Normal | +0 | 65% | Cinza escuro |
| Bom | +1 | 20% | Bronze/avermelhada |
| Excelente | +2 | 10% | Prateada/cinza claro |
| Excepcional | +3 | 5% | Dourada/amarela |

Cada tabela soma 100%. Excepcional supera Excelente por decisão posterior à imagem de referência; todos os bônus de raridade e qualidade foram reduzidos em 1, mantendo chances e cores por nível. A imagem original foi preservada como histórico; estas tabelas são a regra atual. Independência dos dois sorteios ainda não definida; valores exatos de cores da UI também pendentes.

| Classe | Bônus fixo após geração | Alcance inicial documentado |
|---|---|---|
| Guerreiro | +1 Força, +1 Destreza | 1 SQM |
| Bárbaro | +1 Força, +1 Constituição | 1 SQM |
| Assassino | +1 Destreza, +1 Inteligência | 1 SQM |
| Caçador | +1 Destreza, +1 Sabedoria | 5 SQM |
| Clérigo | +1 Constituição, +1 Sabedoria | 5 SQM |
| Mago | +1 Inteligência, +1 Sabedoria | 5 SQM |

Não há regra própria confirmada de atributos/alcance para Cultista Sombrio. Não inferir que Clérigo já cura: o combate inicial documenta ataque básico à distância.

## 5. Mapa das pastas de produção e arte

```text
RPG Game/
├─ AGENTS.md                         entrada para futuras sessões
├─ docs/
│  ├─ design-doc.md                  jogo, decisões e histórico
│  ├─ sprite-briefs.md               visual e regras consolidadas
│  ├─ concept-art-prompt-racas.md    prompt racial antigo
│  ├─ MAPA-DO-PROJETO.md            este guia
│  └─ INVENTARIO-ARQUIVOS.md         fotografia completa do conteúdo
├─ Claude outputs/
│  └─ sprite-briefs.md               versão histórica
├─ assets/                          todas estas subpastas estão vazias
│  ├─ attacks/
│  ├─ projectiles/
│  ├─ ui/
│  └─ sprites/
│     ├─ anao/  ├─ elfo/  ├─ halfling/
│     └─ humano/  ├─ morto-vivo/  └─ orc/
├─ Arte Promocional/
│  ├─ Racas/                        conceitos v1, v2 e v3
│  ├─ Raca-Classe/
│  │  ├─ Versao 1 - Raca por Raca/  7 imagens: Humano v1/v2 + outras 5 raças
│  │  └─ Versao 2 - Matriz Unica/   2 matrizes + 2 testes de pixelização
│  └─ Testes de Animacao/           teste-walk-attack-v1-lateral.png
└─ Tiny RPG Character Asset Pack/
   ├─ Standard References/         Pack 01/ e Pack 02/, um PNG por personagem
   ├─ …Pack 01….zip                 pacote original
   ├─ …Pack 02….zip                 pacote original
   ├─ …Pack 01…/…Pack 01…/          conteúdo extraído (dois níveis)
   └─ …Pack 02…/…Pack 02…/          conteúdo extraído (dois níveis)
```

As funções de `assets/attacks`, `projectiles`, `sprites` e `ui` são inferidas pelos nomes; ainda não existe código que defina seu contrato de uso.

### Referências visuais principais

- **Portrait oficial:** `Arte Promocional/Raca-Classe/Versao 2 - Matriz Unica/Matriz-36-combinacoes-FINAL-v1.png`.
- **Matriz anterior:** mesma pasta, `Matriz-36-combinacoes-v1.png`; não confundir com FINAL.
- **Proporções aprovadas:** `Arte Promocional/Racas/racas-do-mundo-concept-v3-simplificado.png`.
- **Testes de conversão:** mesma pasta da matriz FINAL, `teste-pixelizacao-anao-guerreiro.png` e `teste-pixelizacao-morto-vivo-cultista.png`.
- **Animação experimental:** `Arte Promocional/Testes de Animacao/teste-walk-attack-v1-lateral.png`; a avaliação positiva é um registro do design, não validação de animação em engine.

Na matriz FINAL inspecionada, as linhas correspondem visualmente a **Humano, Orc, Halfling, Anão, Elfo e Morto-vivo**, de cima para baixo. As colunas são **Caçador, Assassino/Ladino, Mago, Clérigo/Cultista, Guerreiro e Bárbaro**. Essa leitura da matriz final não resolve automaticamente a dúvida histórica sobre rótulos na matriz anterior. Antes de automatizar cortes, verificar os limites reais de cada célula e a linha de base.

### Regras visuais resumidas

| Raça | Caçador | Mago | Particularidade |
|---|---|---|---|
| Humano | Arco | Azul; gema azul-clara | Referência de altura |
| Orc | Arco | Capuz/túnica vermelhos; pedra vermelha | Verde, largo, presas; lenço vermelho do Guerreiro |
| Halfling | Besta | Chapéu marrom, túnica/gema verdes | Cerca de 70% da altura humana; menor que o Anão |
| Anão | Arco | Capuz verde, cajado retorcido/gema verde | Baixo e largo; Guerreiro com machado de uma mão + escudo |
| Elfo | Arco | Roxo; gema roxa | Mesma altura do Humano; orelhas pontudas |
| Morto-vivo | Besta | Azul-acinzentado; gema verde-fosforescente | Altura humana; Cultista escuro/profano no lugar do Clérigo |

Clérigos usam **emblema solar dourado**, sem cruz. Cultista usa símbolo profano, roxo/preto e verde-fosforescente. Consulte o brief consolidado para todas as 36 células; esta tabela é só um atalho.

## 6. Como encontrar os assets dos packs

Raízes exatas do conteúdo extraído:

```text
Tiny RPG Character Asset Pack/Tiny RPG Character Asset Pack 01 v2.0 -Full 22 Characters/Tiny RPG Character Asset Pack 01 v2.0 -Full 22 Characters/
Tiny RPG Character Asset Pack/Tiny RPG Character Asset Pack 02 v1.01-Full 20 Characters/Tiny RPG Character Asset Pack 02 -Full 20 Characters/
```

Dentro de cada raiz:

- `Characters(100x100 split)/<Personagem>/`: arquivo Aseprite e subpastas com PNG por animação, com e sem sombra; alguns personagens têm subpasta de efeito/projétil.
- `Aseprite file/`: fontes editáveis também agrupadas separadamente. Não assumir identidade binária entre cópias sem comparar.
- Pack 01: `Arrow(Projectile)/` e `Magic(Projectile)/`.
- Pack 02: `Projectile/`.

Exemplo de busca: `rg --files "Tiny RPG Character Asset Pack" | Select-String 'Wizard|Necromancer|Attack01'`. Para navegação visual simples, começar por `Standard References/Pack 01/Wizard.png` em vez de uma tira de animação.

**Pack 01 — 22 nomes reais de pasta:** Archer, Armored Axeman, Armored Orc, Armored Skeleton, Bat, Elite Orc, Greatsword Skeleton, Knight, Knight Templar, Lancer, Necromancer, Orc, Orc rider, Priest, Skeleton, Skeleton Archer, Slime, Soldier, Swordsman, Werebear, Werewolf, Wizard.

**Pack 02 — 20 nomes reais de pasta:** Black Knight_A, Black Knight_B, Black Knight_C, Blood Monster_A, Blood Monster_B, Demon_A, Demon_B, Demon_C, Demon_D, Demon_E, Demoness_A, Demoness_B, Eyeball Monster, Flame Golem, Ghostfire, Hellbat, Hellhound, Lava Slime, Minotaur, Warlock.

Mapeamento sugerido nos documentos: Wizard → Humano Mago; Priest → Humano Clérigo; Archer → Humano Caçador; Knight/Soldier/Swordsman → Humano Guerreiro; Necromancer → Cultista Sombrio; Skeleton e variações → base Morto-vivo; Orc e variações → base Orc. Isso não significa cobertura de todas as classes dessas raças. O Pack 02 é candidato a monstros/chefes.

Frames de 100×100 são o padrão descrito para os personagens dos packs; as tiras contêm vários frames, e há projéteis explicitamente nomeados 32×32. Estados variam: Idle, Walk ou Flying, Attack01/02/03, Block, Hurt, Death, efeitos e outros. Não supor que todos têm o mesmo conjunto, grafia ou quantidade de frames; há, por exemplo, `Swordsman_Attack3.png`.

## 7. Pipeline de arte decidido e o que falta executar

1. Usar a identidade visual consolidada da matriz como fonte.
2. Separar portrait para menus e sprite para arena.
3. Processo experimental histórico: recorte → redução BOX → quantização → ampliação NEAREST. Em 10/09/2026 ele foi substituído para heróis de arena pela geração direta em pixel art, usando o Guerreiro Humano como régua de câmera, ancoragem e detalhe.
4. Para animação, usar uma paleta fixa compartilhada entre frames; a aplicação dessa regra ainda não foi testada nos arquivos do jogo.
5. Ordem de produção registrada: identidade estática das 36 combinações, depois Idle/Walk/Attack 1 de cada uma; perspectiva fica para a etapa de animação.

Em 12/09/2026, os sprites de produção foram reorganizados no contrato `assets/sprites/<raça>/<classe>/`, com uma subpasta `animations/` para cada uma das 36 combinações. O Morto-vivo usa `cultista-sombrio/` no lugar de `clerigo/`. A árvore pública espelha o mesmo formato em `invocacao-web/public/art/arena/heroes/`.

Todos os 36 sprites-base ativos usam agora o caminho `assets/sprites/<raça>/<classe>/<classe>-idle-v1-256.png` e medem exatamente 256×256. Os seis humanos são as novas artes recebidas nessa resolução; os 30 sprites das outras raças foram reduzidos deterministicamente dos originais de 1254×1254 com vizinho mais próximo, preservando pixel art e transparência. Os originais de 1254×1254 foram excluídos das árvores de produção e pública.

Em 15/09/2026, o Bárbaro Anão Idle V1 foi reenquadrado no mesmo canvas transparente de 256×256: a figura foi reduzida deterministicamente para 82% com vizinho mais próximo, centralizada e mantida na linha-base dos pés. Assim ele permanece apenas levemente mais robusto, sem ficar mais alto que os demais anões. A versão grande anterior foi preservada em `assets/sprites/anao/barbaro/source/`.

Em 12/09/2026, seis pacotes direcionais humanos foram importados para `assets/sprites/humano/<classe>/animations/<estado>/<direção>/frame_NNN.png`: 955 PNGs ao todo. Os frames animados usam canvas 68×68; o Clérigo tem Idle estático de 48×48 por direção. Idle e Walk cobrem oito direções; o Bárbaro também preserva `idle-axe-back`/`walk-axe-back`, enquanto os estados ativos `idle`/`walk` mantêm o machado nas mãos. Cada ZIP original e seu `source-metadata.json` ficam na pasta `animations/` da respectiva classe; a árvore pública recebe somente os frames.

A rota `/arena` testa simultaneamente as seis classes humanas atravessando a sala para leste, usando Walk de 9 quadros a 8 FPS. A escolha de qual pose substituirá futuramente a imagem representativa exibida na invocação foi explicitamente adiada; os sprites-base atuais não foram trocados nessa importação.

## 8. Divergências e pendências para não perder contexto

| Encontrado | Como tratar na retomada |
|---|---|
| `Claude outputs/sprite-briefs.md` usa Elfo mais alto, cores antigas e Clérigo Morto-vivo ainda em discussão visual | Histórico; priorizar brief consolidado em `docs/` |
| `concept-art-prompt-racas.md` ainda pede Elfo mais alto | Adaptar à decisão de altura igual antes de reutilizar |
| Exemplo de Elfo Mago no fim de `sprite-briefs.md` ainda pede azul | A tabela final aprovada pede roxo |
| Tabela individual de Morto-vivo descreve a entrega antiga clara/dourada do Cultista | É relato de divergência, não a regra final; consultar tabela consolidada |
| Caminhos antigos em `design-doc.md` omitem as subpastas Versao 1/Versao 2 | Usar caminhos reais deste mapa/inventário |
| Documento diz matriz final aprovada, mas também conserva pedidos de aprovação/regeneração anteriores | Preservar o marco FINAL e a ressalva do Halfling; não reabrir automaticamente a aprovação geral |
| 32×32 inicial, frames de pack 100×100 e pixelização com altura ~64 px coexistem | São referências de etapas diferentes; canvas, tamanho do corpo, pivô e escala final de arena precisam ser harmonizados |
| 16–24 cores de prompt versus ~27–28 no teste | Alvo de geração e resultado experimental; não declarar um único limite definitivo |
| Vista 3/4 top-down desejada; teste de animação lateral | Perspectiva e consistência de animação na arena ainda precisam ser validadas |
| Halfling fora da proporção esperada, inclusive ressalva na FINAL | Corrigir/verificar altura em portrait e sprite; não confundir aprovação de identidade com escala validada |
| Desvios medidos de Elfo/Anão/Morto-vivo nas imagens v1 | Medições são históricas dessas imagens; não transferir números à matriz FINAL |
| Godot/web/mobile/blockchain citados como alternativas históricas | Navegador aprovado em 09/09/2026; Godot com GDScript é recomendação registrada, ainda sem implementação |

Outras definições ainda necessárias para implementar: tamanho do time/grid, seleção de alvo e movimento para múltiplos combatentes, balanceamento definitivo das fórmulas provisórias de dano/Vida/defesa, velocidade de movimento, futura progressão da cadência de ataques, condições de vitória/derrota, recompensas, probabilidades de raça/classe e relação entre sorteios, persistência e progressão. A cadência-base provisória está definida em 1 ação por segundo; chances de raridade e qualidade já foram fornecidas em 09/09/2026. A árvore de habilidades e a mecânica do Cultista continuam pendentes.

## 9. Rotina de retomada

1. Ler este mapa e conferir mudanças no disco.
2. Abrir a seção original correspondente ao assunto; usar o mapa como índice, não como substituto integral do design.
3. Consultar o inventário para localizar os arquivos; validar os caminhos antes de editar/importar.
4. Distinguir histórico, aprovado, experimental e implementado ao planejar o trabalho.
5. Registrar novas decisões na fonte relevante e atualizar este mapa quando a estrutura mudar.

Este levantamento criou somente documentação de orientação. Os documentos e assets originais foram preservados.

