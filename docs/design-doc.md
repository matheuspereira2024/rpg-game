# RPG Game — Documento de Design (em construção)

## Conceito geral
RPG gacha com batalhas automáticas (auto-battler). O jogador invoca heróis aleatórios com cristais de invocação, monta um time e posiciona os heróis em arenas pré-definidas; o combate acontece de forma totalmente automática, sem controle direto durante a luta.

### Plataforma e navegação (decisão de 09/09/2026)
- Plataforma inicial aprovada: **navegador**. Versão instalada pode ser considerada posteriormente. Godot com GDScript é a recomendação técnica discutida; a implementação ainda não foi iniciada.
- **Inventário:** coleção de heróis do jogador.
- **Invocação:** geração de heróis mediante uso de Cristais de Invocação.
- **Aventura:** mapa de arenas/masmorras conquistáveis, com dificuldade crescente conforme o jogador avança.
- Primeiro sistema a detalhar: geração de personagens.

## 1. Geração de heróis (gacha)
- Moeda: Cristais de Invocação (cristalzinhos azuis).
- Baú: cada invocação custa **10 cristais** e revela 1 candidato aleatório, ainda sem ID de personagem.
- Sem limite de invocações, exceto pela quantidade de cristais disponíveis.

### Página de invocação e confirmação (09/09/2026)
- Fundo de fantasia, baú de tesouro dourado/roxo ao centro e saldo de cristais no canto superior direito.
- **Invocar personagem:** desconta 10 cristais, anima a abertura do baú e revela o candidato com seus atributos, qualidade e raridade.
- Após a revelação, oferecer **Aceitar** ou **Reciclar**. Resolver o candidato atual antes de permitir outra invocação.
- **Aceitar:** valida o candidato, gera/atribui seu ID único e o adiciona à coleção, sem nova cobrança.
- **Reciclar:** devolve **5 cristais (50% do custo)** e descarta o candidato, sem gerar ID de personagem.
- O candidato é provisório; eventual chave técnica de operação para evitar duplicidade não é o ID do personagem.
- Saldo insuficiente impede invocação. Cliques repetidos, recarga e repetição de requisições não devem duplicar cobrança, reembolso ou aceite.
- Para a primeira demonstração, saldo inicial e probabilidades de raça/classe ainda são parâmetros de teste, não regras de economia aprovadas. Independência entre qualidade e raridade segue pendente de decisão definitiva.

### Raças (6)
Humano, Orc, Halfling, Anão, Morto-vivo, Elfo.

### Classes (6)
Guerreiro, Bárbaro, Caçador, Assassino, Clérigo, Mago.

Qualquer combinação Raça x Classe é possível (36 combinações no total), com exceção listada abaixo.

### Raridade (5 níveis — referência aprovada em 09/09/2026)
| Raridade | Bônus de atributos | Chance | Cor de referência |
|---|---:|---:|---|
| Comum | +0 | 70% | Cinza |
| Incomum | +1 | 22% | Verde |
| Raro | +3 | 6% | Azul |
| Épico | +5 | 1,90% | Roxo |
| Lendário | +7 | 0,10% | Laranja/ocre |

As chances somam 100%. Esta tabela substitui os quatro níveis e bônus anteriores.

### Qualidade (4 níveis)
| Qualidade | Bônus de atributos | Chance | Cor de referência |
|---|---:|---:|---|
| Normal | +0 | 65% | Cinza escuro |
| Bom | +1 | 20% | Bronze/avermelhado |
| Excelente | +2 | 10% | Prateado/cinza claro |
| Excepcional | +3 | 5% | Dourado/amarelo |

As chances somam 100%. **Excepcional é superior a Excelente**, por decisão posterior à imagem de 09/09/2026. Todos os bônus de raridade e qualidade foram reduzidos em 1; chances e cores por nível foram mantidas. Referência visual histórica das duas tabelas (os bônus e os nomes dos dois níveis superiores foram atualizados neste documento): `referencias/raridades-qualidades-2026-09-09.png`. Os nomes de cores são descritivos; os valores exatos de interface ainda não foram definidos. A independência entre os sorteios de raridade e qualidade ainda precisa ser definida; não deduzir chances conjuntas só destas tabelas.

## 2. Atributos e pontuação
6 atributos: Força, Destreza, Constituição, Inteligência, Sabedoria e Sorte.

- Cada personagem começa com **1 em cada um dos seis atributos**: 6 pontos fixos, fora do sorteio.
- Reserva variável padrão: **36 pontos adicionais**, mais bônus de qualidade e raridade.
- Total distribuído aleatoriamente = `36 + bônus de qualidade + bônus de raridade`.
- Total antes do bônus de classe = `6 + 36 + bônus de qualidade + bônus de raridade`.
- Distribuição: aleatória, ponto a ponto, sem pesos — cada ponto variável pode cair em qualquer atributo. Pode gerar heróis desbalanceados, mas nenhum atributo começa zerado.
- Mantido o bônus de classe já documentado abaixo (+2 no total), o total final é `44 + bônus de qualidade + bônus de raridade`: de **44** (Comum Normal) a **54** (Lendário Excepcional). Para Cultista Sombrio, o bônus de classe próprio permanece indefinido.

### Bônus fixo de classe (aplicado após a geração)
- Guerreiro: +1 Força, +1 Destreza
- Bárbaro: +1 Força, +1 Constituição
- Assassino: +1 Destreza, +1 Inteligência
- Caçador: +1 Destreza, +1 Sabedoria
- Clérigo: +1 Constituição, +1 Sabedoria
- Mago: +1 Inteligência, +1 Sabedoria

### Ficha de dados e identificador do personagem (09/09/2026)
- Cada herói **aceito** deve ter uma ficha de dados persistida, com **ID único de 32 bits**, nome, raça, classe, raridade, qualidade, os seis atributos e referências de arte. O candidato revelado antes do aceite ainda não possui ID de personagem. Nome e referências de arte são campos previstos; suas regras de geração/seleção ainda serão detalhadas.
- Raridade e qualidade são campos próprios da ficha. A interface lê esses campos para escolher a cor da borda e da estrela; não deduz os dados a partir das cores ou da imagem.
- O ID identifica a **instância** do personagem: dois heróis aceitos com a mesma raça, classe, nome, arte ou atributos continuam sendo personagens diferentes e recebem IDs diferentes. O ID é atribuído uma vez **ao clicar em Aceitar**, nunca no sorteio/revelação, e preservado ao salvar/carregar e ao usar o herói nas diferentes abas.
- Convenção técnica proposta: inteiro **sem sinal de 32 bits (`uint32`)**, intervalo de 0 a 4.294.967.295 (2³² valores). Não confundir 32 bits com 32 caracteres.
- A unicidade exige alocação controlada: um número aleatório isolado não garante ausência de colisões. Ao gerar um candidato, conferir e reservar o ID de forma atômica no registro responsável, com restrição de unicidade e nova tentativa em caso de colisão. Outra opção é um contador persistente, sem reutilização e sem retornar a zero ao esgotar o intervalo. O algoritmo definitivo ainda será escolhido.
- **Escopo aprovado: global entre todos os jogadores.** Não podem existir dois personagens com o mesmo ID no jogo. A atribuição definitiva deverá ser coordenada por um registro central/servidor; navegadores independentes não conseguem garantir unicidade global apenas verificando seus próprios dados. A capacidade do espaço de 32 bits deve ser respeitada, sem reutilizar silenciosamente um ID ocupado.
- **Objetivo futuro:** permitir troca, compra e venda de personagens entre jogadores. O ID pertence ao personagem e permanece o mesmo quando muda de dono; a identificação do proprietário deve ser um campo separado. As regras de transferência, moeda e mercado ainda não foram definidas — não presumir dinheiro real, blockchain ou uma forma de pagamento.
- **Escopo atual:** registrar esse requisito; implementar a atribuição global, a propriedade e as transferências em uma etapa posterior. Um eventual protótipo local não deve ser apresentado como garantia de unicidade global nem como mercado implementado.
- Implementação inicial em `invocacao-web/`: candidato persistido sem ID, aceite com sequência central limitada a uint32 e transações D1. Sessões de demonstração ainda não são contas definitivas; propriedade transferível e mercado seguem para depois.

## 3. Identidade visual do herói
- **Qualidade:** uma única estrela ao lado do nome na ficha visual; o nível é indicado pela cor, não pela quantidade de estrelas.
- **Raridade:** cor da borda da moldura do quadro em que o personagem é mostrado.
- Estrela ao lado do nome = qualidade: Normal = cinza escuro, Bom = bronze/avermelhado, Excelente = prateado/cinza claro, Excepcional = dourado/amarelo, conforme a ordem atual aprovada.
- Moldura/quadro do retrato do herói, cor da borda = raridade: Comum = cinza, Incomum = verde, Raro = azul, Épico = roxo, Lendário = laranja/ocre. A referência de 09/09/2026 substitui a antiga ausência de cor para Comum.
- Estilo de arte: pequeno, cartunístico, pouco detalhado, pixel art chibi (32x32px base). 1 herói = 1 SQM = 1 tile do grid da arena.

### Aparência por classe (ideias iniciais)
- Caçador: roupa de couro, arco na mão, flechas nas costas.
- Assassino: roupa preta/couro, par de adagas (uma em cada mão).
- Mago: túnica azul, chapéu de mago, cajado com uma pedra sagrada na ponta (onde a magia é imbuída).
- Clérigo: vestimenta clara/branca, cajado com emblema no topo. Símbolo sagrado (peito e cajado) = emblema solar/roda de luz dourada — sem cruz ou iconografia cristã (decisão fechada, ver `sprite-briefs.md`).
- Guerreiro: armadura simples, escudo de madeira com metal, espada de uma mão.
- Bárbaro: pouca roupa, tira de couro cruzando o peito, machado de duas mãos, olhos vermelhos (indicando fúria).
- Orc: descrito com a mesma ideia visual do bárbaro (pouca roupa, tira de couro, machado de duas mãos) — **resolvido**: esse visual é da classe Bárbaro (vale pra qualquer raça); o Orc como raça tem seus próprios traços (pele verde, presas, compleição maior), independente da classe sorteada.

### Exceção de classe por raça
- **Morto-vivo não recebe a classe Clérigo padrão.** No lugar, tem a classe **Cultista Sombrio** (capuz escuro, símbolo profano, paleta roxo-sombria/verde-fosforescente). Em aberto: se é uma 7ª classe exclusiva do Morto-vivo ou uma reskin que substitui o Clérigo só nessa combinação. Restrições gerais de raça x classe ficam pra uma etapa futura de definição.

Brief visual completo dos 36 sprites (paleta, pose, equipamento por raça x classe) está no doc `sprite-briefs.md`.

### Alturas relativas entre raças (validado em arte de conceito — decisão final)
Testamos duas versões (`racas-do-mundo-concept-v2-limpo.png`, mais detalhada, e `racas-do-mundo-concept-v3-simplificado.png`, com nível de detalhe mais próximo do que dá pra sustentar em animação). Decisão fechada: Humano e Elfo ficam na **mesma altura** (na v2 o Elfo saiu mais alto, mas o resultado da v3 — Elfo do tamanho do Humano — agradou e foi aprovado). Morto-vivo também na altura de referência (build humana, aparência óssea/decadente). Orc é robusto e largo, altura próxima à do Humano. Anão é baixo e bem largo/robusto. Halfling é o mais baixo do grupo, com build mais esguia que o Anão (não confundir os dois — Anão = baixo+largo, Halfling = baixo+esguio). Essa hierarquia de altura deve se manter quando produzirmos os sprites reais de jogo.

### Análise técnica: renders raça x classe vs. sprite real de jogo (comparação de bits/paleta)

Você pediu uma comparação técnica entre a geração do Halfling e a dos Morto-vivos (a mais recente). Medi objetivamente (contagem de cores únicas e "flat run ratio" — % de pixels vizinhos horizontais com a cor exatamente idêntica, que é o indicador de shading em blocos chapados típico de pixel art de verdade) em personagens recortados das duas imagens, e comparei com 3 sprites reais do Tiny RPG Character Pack já comprado (Necromancer, Skeleton, Knight — 100x100px, os que realmente vão pro jogo):

| Personagem | Cores únicas | Flat run ratio | Categoria |
|---|---|---|---|
| Halfling Caçador (AI) | 35.411 | 1,3% | arte "HD pixel art" (pintura digital) |
| Morto-vivo Caçador (AI) | 33.391 | 1,5% | arte "HD pixel art" (pintura digital) |
| Morto-vivo Cultista Sombrio (AI, com efeito mágico) | 52.227 | 0,6% | arte "HD pixel art" (pintura digital) |
| Necromancer (asset real do pack) | 27 | 28,9% | pixel art de verdade (paleta travada) |
| Skeleton (asset real do pack) | 26 | 31,8% | pixel art de verdade (paleta travada) |
| Knight (asset real do pack) | 32 | 32,1% | pixel art de verdade (paleta travada) |

**Conclusão técnica**: comparando classe a classe (Caçador vs. Caçador), o Morto-vivo não é tecnicamente mais "pesado" que o Halfling — os dois têm a mesma ordem de grandeza (~33-35 mil cores únicas, ~1-1,5% de blocos chapados). O que mais pesa no conjunto do Morto-vivo é especificamente o Cultista Sombrio, que tem efeito de brilho/partícula mágica e sozinho quase dobra a contagem de cores (52 mil). Ou seja, a sensação de "esse ficou mais detalhado" vem mais de 1 personagem com efeito de magia do que de um salto geral de estilo.

**O ponto mais importante, porém, é outro**: tanto Halfling quanto Morto-vivo (e as outras 4 raças já geradas) pertencem à mesma categoria técnica — pintura digital com milhares de cores e sombreamento em gradiente contínuo (quase nenhum pixel repete a cor do vizinho). Isso é fundamentalmente diferente de "pixel art de verdade", que usa uma paleta travada de dezenas de cores e grandes blocos chapados (por isso o Necromancer real tem só 27 cores contra as 33-52 mil das nossas gerações — 1.000x a 2.000x menos cores). Reduzir "um pouco o detalhe" no prompt não muda essa categoria — ainda vai sair uma pintura suave com milhares de cores, só que com menos ornamento desenhado em cima. Pra chegar num padrão de bits realmente leve (que é o que você quer pro jogo), o caminho técnico é outro: ou (a) usar essas imagens só como arte de conceito/portrait de invocação e manter os sprites de batalha de verdade vindo do pipeline Tiny RPG Pack + PixelLab (que já produz nesse padrão de paleta travada), ou (b) rodar as imagens raça x classe por um processo de quantização de cor (reduzir pra uma paleta fixa de ~16-32 cores) antes de virarem sprite, o que muda bastante o visual final.

**Complemento (comparação com a v3-simplificado)**: você reenviou a imagem pra perguntar a diferença técnica em relação ao que geramos agora — confirmei por hash de arquivo que é exatamente o mesmo arquivo já salvo como `Arte Promocional/Racas/racas-do-mundo-concept-v3-simplificado.png` (a arte de conceito das 6 raças, sem classe, que vocês já tinham aprovado de proporção). Medi ela com o mesmo método:

| Personagem | Cores únicas | Colors/100px | Flat run ratio |
|---|---|---|---|
| Humano (M), v3-simplificado | 13.921 | 81,7 | 1,4% |
| Orc (M), v3-simplificado | 14.844 | 73,1 | 3,1% |
| Halfling (M), v3-simplificado | 10.703 | 85,1 | 1,2% |
| *(comparar com Halfling Caçador, raça x classe)* | 35.411 | 62,3 | 1,3% |

**O que isso mostra**: a v3-simplificado tem sim menos cores em números absolutos (10-15 mil contra 33-52 mil) porque o personagem é bem menor (sem roupa de classe, sem arma, traje de viajante simples) — menos área e menos elementos pra desenhar. Mas, proporcionalmente (cores por 100px de área) e no flat run ratio (1-3%, quase igual ao 0,6-1,5% das renders raça x classe), ela é **tecnicamente da mesma categoria**: pintura digital com sombreamento em gradiente, não pixel art de paleta travada de verdade. Ou seja, o motivo dela "parecer mais simples" não é um bit-depth menor de verdade — é ter menos ornamento desenhado em cima (sem armadura, sem cajado, sem efeito mágico) e ser menor em tela. Isso é uma pista útil: **dá pra chegar num visual "mais limpo" cortando ornamento e reduzindo escala**, sem que isso resolva sozinho a questão de paleta/bits pro sprite real de jogo (que continua precisando do pipeline Tiny RPG Pack + PixelLab, ou quantização de cor, pra ficar de verdade leve).

**Bônus — proporção**: essa mesma imagem, medida por altura de figura, bate bem com a régua de altura combinada: Humano ~201-206px, Elfo ~195-201px (praticamente igual, como decidido), Halfling ~163-168px (o mais baixo do grupo), Anão ~163-174px mas visivelmente mais largo, Orc ~217-219px (o maior). É uma referência melhor de proporção entre raças do que algumas das gerações raça x classe já feitas (Elfo e Halfling, por exemplo, saíram da régua nessas últimas) — vale usar essa imagem como âncora de proporção quando entrarmos na correção/nivelamento.

**Recomendação**: manter a linha "raça x classe" (Humano, Orc, Anão, Elfo, Halfling, Morto-vivo) como material de conceito/portrait — telas de invocação, galeria de heróis, banners promocionais, onde o nível de detalhe rico é uma vantagem — e não como base direta dos sprites que entram na arena. Os sprites de batalha continuam pelo pipeline já validado (Tiny RPG Pack + PixelLab), adaptando paleta/equipamento por raça x classe usando os briefs que já temos. Isso resolveria a dúvida do "nivelamento" de um jeito diferente do que tínhamos cogitado: em vez de nivelar as 36 combinações pra um detalhe médio único, cada linha de arte já nasce no padrão de bits certo pro seu uso (rico pra portrait, leve/travado pra sprite de jogo).

### Estilo de arte — status da decisão (em andamento)
Testamos 3 níveis de detalhe pra arte de conceito das raças (todos salvos em `Arte Promocional/Racas/`):
1. `racas-do-mundo-concept-v1.png` — versão inicial, com moldura/título/texto (estilo cartaz).
2. `racas-do-mundo-concept-v2-limpo.png` — mesmo nível de detalhe alto, mas isolado (sem moldura/texto).
3. `racas-do-mundo-concept-v3-simplificado.png` — nível de detalhe reduzido, bem mais próximo da complexidade sustentável em animação (mais perto do Tiny RPG Character Pack, mas ainda um pouco mais rico). **Proporções desta versão foram aprovadas.**

Ainda em aberto: se o nível de detalhe da v3 aguenta ficar consistente entre frames de animação (parado vs. ataque vs. andando) — esse é o teste real de viabilidade pra produção, e não foi feito ainda. Se passar nesse teste, a v3 vira candidata a estilo oficial de sprite de jogo (podendo substituir ou complementar o pipeline do Tiny RPG Pack); se não passar, essa linha de arte fica só como referência de proporção/paleta, e a produção real continua pelo pipeline já validado (Tiny RPG Pack + PixelLab).

**Teste de consistência de animação — resultado (`Arte Promocional/Testes de Animacao/teste-walk-attack-v1-lateral.png`)**: gerado um ciclo de caminhada (8 frames) e uma sequência de ataque com espada (6 frames, incluindo efeito de rastro/slash na arma) no mesmo personagem. Resultado: **consistência ótima** — cabelo, cachecol, armadura e cores idênticos em todos os 14 frames, poses de caminhada e ataque bem construídas (a sequência de ataque tem arco de preparação, golpe e recuperação). Isso confirma que esse nível de detalhe consegue sim manter consistência entre frames, o que era a principal dúvida.

**Porém**: esse teste saiu em **visão lateral/perfil** (estilo sidescroller, personagem de lado), não na visão top-down/3-quarto que o jogo usa (arena vista de cima, grid de SQM, como o Tiny RPG Character Pack). Antes de considerar essa linha de arte pronta pra produção, falta repetir o mesmo teste (walk + attack) pedindo explicitamente o ângulo top-down/elevado — essa perspectiva costuma ser mais difícil pro modelo manter consistente do que a lateral, então esse é o próximo teste real de viabilidade.

**Próximo passo (retomar depois):** repetir o teste de walk+attack pedindo ângulo top-down (não lateral), pra confirmar se a consistência se mantém na perspectiva que o jogo realmente usa.

### Mudança de ordem de produção (decisão)
Decidido: a questão do ângulo top-down fica pausada por ora. Nova ordem de trabalho:
1. Primeiro gerar todas as 36 combinações raça x classe na pose parada/frontal (referência estática), pra fechar a identidade visual de cada uma.
2. Só depois, ir uma a uma produzindo o conjunto básico de animação de cada combinação: Idle, Walk e Attack 1 (ataque básico).
3. A questão do ângulo de câmera (lateral vs. top-down) é resolvida quando chegarmos na etapa de animação.

**Orc — 6 classes: concluído e aprovado (v1).** Salvo em `Arte Promocional/Raca-Classe/Orc-6-classes-v1.png`. Mudanças pedidas em relação ao primeiro rascunho: Mago trocou chapéu+túnica azul por capuz+túnica vermelha com pedra de fogo no cajado (tema de fogo, diferente do Humano); Guerreiro trocou o lenço azul por vermelho. Caçador, Assassino, Clérigo e Bárbaro mantidos como no primeiro rascunho. Clérigo do Orc já usa o mesmo emblema solar dourado (sem cruz) definido pro Humano — consistência mantida entre raças nessa classe.

Medi a proporção do Orc contra o Humano v2 (mesmo canvas 2172x724 nas duas imagens): corpo do Orc ocupa em média ~411px de altura contra ~378px do Humano — Orc cerca de 9% "maior" no quadro, o que bate com a régua que definimos ("Orc robusto, altura próxima ou levemente acima do Humano"). Proporção validada.

**Anão — 6 classes: concluído e aprovado (v1).** Salvo em `Arte Promocional/Raca-Classe/Anao-6-classes-v1.png`. Mudanças pedidas: Guerreiro trocou espada por machado de uma mão (mantendo o escudo); Mago mudou de cajado curto azul-petróleo pra capuz verde + cajado longo retorcido com gema verde. Clérigo já usa o emblema solar dourado padrão. Demais classes mantidas na linha do brief original.

Medi a proporção do Anão contra Humano e Orc (mesmo canvas 2172x724): corpo do Anão tem altura média ~362px (contra ~378px do Humano e ~411px do Orc) — só uns 4-6% mais baixo que o Humano, bem menos do que a impressão de "baixote" que normalmente se espera de um anão. Em compensação, a largura média ficou uns 16% maior que a do Humano (~320px vs ~277px) — bate com "robusto/largo". **Observação pra próxima rodada**: se quiser o Anão lendo como visivelmente mais baixo (não só mais largo), vale pedir explicitamente uma redução de altura mais forte no prompt (o brief não tinha uma % definida pro Anão como definimos pro Halfling em 70%) — por ora não é um erro, só uma nuance de proporção que ficou mais sutil do que o estereótipo clássico de anão.

**Elfo — 6 classes: concluído e aprovado (v1).** Salvo em `Arte Promocional/Raca-Classe/Elfo-6-classes-v1.png`. Mudança pedida: Mago com túnica e gema roxas (era azul-safira no brief original). Clérigo já usa o emblema solar dourado padrão, Guerreiro ganhou um emblema de árvore no escudo (detalhe bonito, não pedido mas bem-vindo).

**Achado importante na medição de proporção**: corpo do Elfo saiu com altura média ~442-456px, contra ~378px do Humano — cerca de **17% mais alto**, quando a decisão fechada (depois do teste de altura relativa) foi "Elfo e Humano na mesma altura". Investigando, achei a causa: o `sprite-briefs.md` ainda tinha o texto antigo "Elfo: alto e esguio, mais alto que o Humano" (versão anterior à decisão final) — ou seja, o documento nunca foi corrigido depois que vocês bateram o martelo na altura igual, e isso provavelmente vazou pro prompt usado nessa geração. Já corrigi o texto no documento agora. Fica a critério de vocês se vale regenerar esse Elfo mais baixo pra bater com a decisão, ou deixar como está e ajustar só na rodada de nivelamento final.

**Nivelamento futuro — status: pronto pra começar.** Plano original: gerar as 6 raças primeiro do jeito que sair, e só depois fazer uma rodada de nivelamento pra escolher um padrão de riqueza de detalhe e refazer as 36 combinações nesse mesmo padrão. As 6 raças estão entregues (v1) agora, e com o Morto-vivo você já confirmou o mesmo problema que vinha se acumulando (detalhe rico demais) — ou seja, esse é o momento natural de decidir como conduzir essa rodada. Dois problemas a resolver juntos nela: (1) nível de riqueza de detalhe (Humano é o mais simples, Elfo/Morto-vivo os mais ornamentados) e (2) escala/altura relativa entre raças (ver tabela acima — só Humano e Orc bateram com a régua combinada). Ainda em aberto: qual raça/nível vira o padrão de referência pro nivelamento, e se o Halfling precisa de um reforço mais explícito da regra dos 70% de altura no prompt pra realmente sair baixo.

**Halfling — 6 classes: concluído e aprovado (v1).** Salvo em `Arte Promocional/Raca-Classe/Halfling-6-classes-v1.png`. Mudanças pedidas: Caçador trocou arco por besta (crossbow) com virotes; Mago mudou de azul-claro/lavanda pra chapéu marrom + túnica verde.

**Achado importante na medição de proporção (Halfling)**: corpo do Halfling saiu com altura média ~390-407px (figuras sem cajado esticado: 390-391px), contra ~377-379px do Humano — ou seja, o Halfling saiu **do mesmo tamanho ou até um pouco maior** que o Humano. Isso contradiz diretamente a regra fechada no brief ("Halfling = baixo, aprox. 70% da altura do Humano" — daria uns 265px). Diferente do caso do Elfo (onde achei um texto desatualizado como causa), aqui o texto do `sprite-briefs.md` já estava correto ("baixo, aprox. 70% da altura do Humano") — então a causa provável é o prompt de geração não ter reforçado esse percentual com força suficiente, ou o gerador ter compensado a altura pra manter a legibilidade dos detalhes (chapéu, armadura). Esse é o desvio de proporção mais grave encontrado até agora entre as raças já geradas, porque o Halfling **é definido pela baixa estatura** — sem isso, ele perde a identidade visual em relação ao Humano.

**Morto-vivo — 6 classes: entregue (v1), com ressalvas.** Salvo em `Arte Promocional/Raca-Classe/Morto-vivo-6-classes-v1.png`. Você mesmo notou que "ficaram excelentes, mas muito ricos em detalhes" — concordo, e a medição confirma mais um sintoma do mesmo problema:

- **Proporção**: corpo do Morto-vivo (figuras de base, sem cajado/machado esticado: Caçador, Assassino, Guerreiro) saiu com altura média ~404px, contra ~377px do Humano — cerca de **7% mais alto**, quando a regra é "Morto-vivo na altura de referência" (igual ao Humano). Mais leve que o desvio do Elfo (17%) mas na mesma direção.
- **Riqueza de detalhe**: esta é visualmente a raça mais ornamentada das 6 até agora (gravações em metal, pelagem, efeitos de fumaça mágica, acabamentos) — confirma o padrão de enriquecimento progressivo que você já tinha percebido no Elfo.
- **Desvio de paleta no Cultista Sombrio**: o brief pedia paleta escura/profana (preto-arroxeado, roxo-sombrio, verde-fosforescente) pra contrastar com o Clérigo dourado das outras raças. O resultado saiu com capuz claro (bege/creme) e cajado dourado com estrela — visualmente muito próximo da linguagem "sagrada/solar" do Clérigo comum, o que dilui o contraste "luz vs. culto sombrio" que era a ideia. Vale revisar isso especificamente na rodada de nivelamento, além da questão de detalhe/altura.

**Marco: as 6 raças estão com uma primeira versão gerada.** Com Halfling e Morto-vivo entregues, fecha-se o ciclo "1 raça, 6 classes" que vocês definiram como ordem de produção. Tabela-resumo das medições de altura corporal (mesma metodologia, canvas 2172x724, figuras sem arma/cajado esticado pra cima):

| Raça | Altura média (px) | vs. Humano | Regra esperada | Status |
|---|---|---|---|---|
| Humano | ~378 | baseline | referência | ✅ referência |
| Orc | ~411 | +9% | robusto, próximo/levemente acima | ✅ dentro do esperado |
| Anão | ~362 (só altura; +16% de largura) | -4% a -6% | baixo e robusto | ⚠️ mais largo que baixo — nuance, não erro |
| Elfo | ~442-456 | +17% | igual ao Humano | ❌ mais alto que o combinado (texto do brief já corrigido) |
| Halfling | ~390-407 | 0% a +8% | ~70% do Humano (bem mais baixo) | ❌ maior desvio — devia ser o mais baixo do grupo e saiu igual/maior |
| Morto-vivo | ~404 | +7% | igual ao Humano | ❌ acima do esperado, mesma direção do Elfo |

Ou seja: das 6 raças, só Humano (referência) e Orc bateram com a régua de altura combinada. Isso, somado à sua observação sobre riqueza de detalhe crescente, é o argumento mais forte pra encarar a rodada de nivelamento não só como "escolher um nível de detalhe", mas também como uma correção de escala relativa entre raças — os dois problemas parecem andar juntos (quanto mais detalhe/ornamento o gerador adiciona, mais ele parece "inflar" o corpo pra caber tudo).

**Humano — 6 classes: concluído e aprovado (v2, canônica).** v1 salva em `Arte Promocional/Raca-Classe/Humano-6-classes-v1.png`; v2 (atual) em `Humano-6-classes-v2.png`. As 6 classes (Caçador, Assassino, Mago, Clérigo, Guerreiro, Bárbaro) bateram muito bem com o brief do `sprite-briefs.md` — mesmo rosto/cabelo mantido consistente nas 6, só mudando equipamento e paleta por classe, exatamente o efeito desejado ("mesma pessoa, profissão diferente"). Na v2, o símbolo do Clérigo (peito e cajado) foi trocado de uma cruz pra um emblema solar/roda de luz dourada, pra evitar remeter a religião real (cristianismo) — essa é a versão oficial daqui pra frente. Serve de modelo de qualidade pras próximas 5 raças.

## 4. Loop de jogo / combate
- Sem controle direto do herói durante a batalha (auto-battler).
- Jogo dividido em fases; cada fase é uma arena (mapa quadrado/retangular — dungeon, sala temática, ex: "sala de sacrifício").
- Inimigos: quantidade e posições fixas por fase, definidas no design do mapa (sempre as mesmas a cada tentativa). Ex: 3 esqueletos guerreiros, 2 esqueletos arqueiros, 1 esqueleto mago.
- Interação do jogador: apenas posicionar os heróis dentro de slots pré-definidos do lado dele da arena (não é posicionamento livre).
- Ao iniciar (start): heróis e inimigos se movem automaticamente um em direção ao outro e atacam ao entrar em alcance.
- **Cadência provisória:** todos os heróis e inimigos executam no máximo **1 ação por segundo**. Nesta primeira versão, nenhum atributo altera essa cadência. Uma revisão futura poderá fazer a Destreza influenciar a velocidade de ataque, depois que o combate-base estiver equilibrado.
- **Aquisição de alvo — primeiro protótipo:** cada combatente procura o inimigo alcançável mais próximo e mantém esse alvo enquanto ele continuar válido. Guerreiro Humano e Esqueleto Guerreiro ocupam 1 SQM cada, não podem entrar na célula um do outro e param em células adjacentes para o ataque corpo a corpo. Empates devem ser resolvidos de modo determinístico. Na demonstração contínua da rota `/arena`, a Vida que seria esgotada volta imediatamente ao máximo; isso é apenas uma conveniência visual do protótipo, não uma regra de combate definitiva.
- **Mana — fórmula provisória:** a Mana máxima depende principalmente de Inteligência: `20 + INT × 8`. A regeneração de Mana depende de Sabedoria: `0,5 + SAB × 0,15` por segundo. A interface coloca a barra de Mana imediatamente abaixo da barra de Vida. Custos de habilidades e regras que interrompem ou modificam a regeneração ainda não foram definidos.
- **Momento do dano corpo a corpo:** o resultado do golpe é calculado quando a ação de ataque começa, mas Vida, número flutuante e demais efeitos de impacto só são atualizados na metade da animação. No protótipo atual, a ação dura 1 segundo e o impacto ocorre em 0,5 segundo.
- **Fórmulas provisórias do combate corpo a corpo:** Vida Máxima = `100 + Constituição × 10 + Força × 2`. O dano bruto de cada golpe é `dado da arma + Força + piso(Destreza ÷ 4)`; as armas podem usar `1d4`, `1d6`, `1d8` ou `1d12`, e as duas espadas do duelo atual usam `1d8`. Chance de crítico = `5% + Sorte × 0,75% + Destreza × 0,25%`, limitada provisoriamente a 50%. O crítico lança duas vezes o dado da arma, sem duplicar os bônus fixos. Armadura = `Constituição + piso(Força ÷ 2) + piso(Destreza ÷ 3) + armadura do equipamento`; o escudo do Guerreiro fornece 3 pontos no teste. Redução = `75% × Armadura ÷ (Armadura + 50)`, aproximando-se de 75% sem alcançá-lo. Dano final = `máximo de 1 e arredondamento(Dano bruto × (1 − Redução))`. O Guerreiro possui 210 de Vida, 19 de Armadura, 20,7% de redução, 12,25% de crítico e causa normalmente de 11 a 17 após a Armadura do Esqueleto. O Esqueleto possui 186 de Vida, 13 de Armadura, 15,5% de redução, 9% de crítico e causa normalmente de 8 a 13 após a Armadura do Guerreiro. Fórmulas e números continuam sujeitos a balanceamento.
- Magias/habilidades: adiadas para depois (dependem de uma árvore de habilidades, ligada a raça + classe) — por ora, só ataques básicos.

### Escala visual da primeira arena (aprovada em 10/09/2026)

- Arena-base: 30 colunas por 20 linhas, mantendo proporção 3:2 e total de 600 SQM.
- Cada SQM corresponde a uma célula quadrada de 36×36 px na escala de referência; área jogável total de 1080×720 px.
- Um herói ou inimigo humanoide comum ocupa logicamente 1 SQM pelo ponto dos pés. O corpo humanoide tem cerca de 48 px de altura visual e pode ultrapassar a célula, assim como armas, capas e efeitos.
- Inimigos grandes podem ter arte e ocupação maiores; o Minotauro do estudo visual lê aproximadamente como uma criatura de 2×2 SQM.
- Esta proporção foi aprovada visualmente na rota `/arena` com três heróis, três esqueletos e um Minotauro. Ela passa a ser a referência para produzir os sprites próprios das 36 combinações.

## 5. Ataques básicos por classe
- Corpo a corpo (alcance 1 SQM): Guerreiro (espada e escudo), Bárbaro (machado de duas mãos), Assassino (par de adagas).
- À distância (alcance 5 SQM, valor inicial): Mago (projétil mágico azul/roxo), Clérigo (projétil branco/amarelo, estética sagrada), Caçador (flecha).
- SQM = unidade de distância em quadrados do grid do mapa. O alcance é um atributo do próprio personagem, podendo futuramente ser alterado por itens.
- **Atualização**: o pack de assets já comprado (Tiny RPG Character Asset Pack 01) já traz sprite de ataque (Attack01/Attack02) e projétil pronto pra Wizard (Mago), Priest (Clérigo) e Archer (Caçador) — resolve boa parte dessa pendência pras raças/classes cobertas por esse pack. Ver `sprite-briefs.md` para o inventário completo.

### Organização de pastas: Versão 1 (raça por raça) vs. Versão 2 (matriz única)
A pasta `Arte Promocional/Raca-Classe/` agora tem duas subpastas: `Versao 1 - Raca por Raca/` (as 6 imagens antigas, uma por raça, geradas separadamente — Humano v1/v2, Orc, Anão, Elfo, Halfling, Morto-vivo) e `Versao 2 - Matriz Unica/` (a nova abordagem, todas as 36 combinações numa imagem só). A v1 fica guardada como histórico/referência; o trabalho de agora em diante é regenerar a matriz única (v2) até ela bater com todas as decisões já aprovadas.

**Problema encontrado na primeira tentativa da v2**: ao gerar tudo numa passada só, a ferramenta perdeu detalhes já fechados — todo Caçador saiu com besta (deveria variar por raça: besta só pra Halfling e Morto-vivo, arco pras outras 4), as cores de túnica/gema não bateram com a raça (Mago devia variar: azul-Humano, vermelho-Orc, verde-Halfling, verde-Anão, roxo-Elfo), e o Guerreiro Anão voltou a segurar espada em vez do machado de uma mão (decisão aprovada na v1). Criei uma tabela consolidada no `sprite-briefs.md` ("Brief consolidado pra gerar a matriz de 36 numa passada só") com a regra final de arma+paleta de cada uma das 36 células, destacando em negrito/maiúscula os itens que mais escaparam — é isso que deve ser reforçado no próximo prompt da matriz.

### Marco: matriz das 36 combinações aprovada como versão final (v1)
Salvo em `Arte Promocional/Raca-Classe/Versao 2 - Matriz Unica/Matriz-36-combinacoes-FINAL-v1.png`. Esta é a arte **oficial e final da primeira versão do jogo** para as 36 combinações raça x classe — todas as decisões acumuladas nesta conversa aplicadas de uma vez: arma certa por raça x classe (besta só Halfling/Morto-vivo, arco nas outras 4), cor certa por raça (Mago azul-Humano/vermelho-Orc/verde-Halfling/verde-Anão/roxo-Elfo/verde-fosforescente-Morto-vivo), Guerreiro Anão com machado (não espada), Cultista Sombrio com paleta escura/profana correta, emblema solar dourado do Clérigo padronizado (sem cruz) em todas as raças, fundo preto puro, ordem fixa de classe (Caçador, Ladino, Mago, Clérigo, Guerreiro, Bárbaro).

Por decisão desta conversa (ver seção "Decisão de arquitetura" abaixo), **esta é a versão de portrait** — a arte mostrada ao usuário na tela de invocação/galeria. Ainda não é o sprite de arena (isso passa pelo pipeline de pixelização, testado e documentado na seção "Matriz v2" abaixo). Pendência que continua de pé: a proporção do Halfling ainda precisa de correção (saiu do tamanho do Humano, deveria ser ~70%) — vale revisitar antes de considerar essa matriz 100% fechada, ou tratar como ajuste pontual numa v2 só do Halfling.

### Decisão de arquitetura: duas versões de arte por herói (portrait renderizado + sprite pixelado de arena)
Fechado: cada combinação raça x classe vai ter **duas versões de arte**, geradas a partir da mesma fonte:
- **Portrait (tela de invocação, galeria de heróis, qualquer lugar de UI/menu)**: a versão renderizada "HD pixel art" — a que sai direto da matriz consolidada (v2), sem pós-processamento. Aqui o nível de detalhe rico é uma vantagem, não um problema — resolve de vez a preocupação com "nivelamento de detalhe" que vínhamos discutindo, porque essa versão nunca precisou ser tecnicamente leve.
- **Sprite de arena (o que entra no jogo, em combate)**: a mesma arte passada pelo pipeline de pixelização (downscale + quantização de cor) já testado e validado (ver seção acima — bateu na faixa de cores/flat-run dos sprites reais do Tiny RPG Pack).

Isso também resolve, de quebra, a lacuna que o Tiny RPG Pack tinha (sem Bárbaro, sem Assassino, sem corpo de Halfling/Anão/Elfo) — em vez de depender só do pack comprado pra essas lacunas, dá pra gerar+pixelizar as combinações que faltam usando esse pipeline próprio.

**Ressalva técnica importante pra quando formos pra animação (Idle/Walk/Attack)**: o pipeline de quantização de cor que testamos (MAXCOVERAGE) escolhe a paleta de forma adaptativa a partir de cada imagem — se cada frame de animação for pixelizado separadamente, cada um pode escolher uma paleta ligeiramente diferente, causando "flicker" de cor entre frames (o personagem mudando de tom sutilmente a cada frame trocado). Pra evitar isso: extrair a paleta **uma vez só** (do frame de Idle, por exemplo) e forçar todos os outros frames (Walk, Attack) a usar exatamente essa mesma paleta fixa, em vez de re-quantizar cada frame independente. Isso ainda não foi testado — fica registrado como próximo cuidado técnico quando chegarmos na etapa de animação.

**Pendência que continua de pé independente dessa decisão**: o problema de proporção do Halfling (saiu do mesmo tamanho ou maior que o Humano, quando devia ser ~70% da altura) é uma questão de escala/proporção, não de estilo de renderização — precisa ser corrigido nas duas versões (portrait e sprite), então continua na lista antes de finalizar.

**Próximo passo prático**: assim que você aprovar uma versão final da matriz de 36 (com o brief consolidado aplicado), eu crio um script que recorta as 36 células automaticamente e gera as duas versões de cada uma (portrait direto + sprite pixelado), em vez de processar um personagem de cada vez manualmente.

### Matriz v2: brief consolidado aplicado com sucesso, mas ainda "renderizado" — pipeline de pixelização testado e funcionando
A matriz v2 (`Arte Promocional/Raca-Classe/Versao 2 - Matriz Unica/`) aplicou corretamente quase tudo do brief consolidado: besta só no Halfling e Morto-vivo (as outras 4 raças com arco), Mago com a cor certa por raça (azul-Humano, vermelho-Orc, verde-Halfling, verde-Anão, roxo-Elfo, verde-fosforescente-Morto-vivo), Guerreiro Anão de volta com machado (não espada), e o Cultista Sombrio finalmente saiu com a paleta escura/profana certa (roxo-sombrio, verde-fosforescente) em vez do visual dourado/claro que tinha saído errado antes. Ou seja, o brief consolidado funcionou.

Você notou, olhando pra ela, que ainda parece "renderizada" — e mediu certo no olho: **flat run ratio caiu pra 0,4%-0,7%**, o nível mais baixo (mais "pintura digital", menos "pixel art de verdade") de tudo que já medimos até agora, incluindo as tentativas anteriores.

**Testei o pós-processamento que você sugeriu (filtro pra virar pixel de verdade) e funcionou.** Pipeline testado em 2 personagens (Anão Guerreiro, Morto-vivo Cultista Sombrio):
1. Recortar o personagem da célula da matriz.
2. Reduzir a escala pra ~64px de altura usando filtro BOX (faz uma média limpa de blocos de pixel, em vez de amostrar 1 pixel só — evita ruído).
3. Quantizar a paleta pra ~27-28 cores usando o método MAXCOVERAGE do Pillow (preserva melhor tons distintos como o cinza do metal, que métodos mais simples tendem a "engolir").
4. (Opcional, só pra visualizar/usar em telas maiores) Reescalar de volta com filtro NEAREST (sem suavizar) — mantém os blocos de pixel nítidos em vez de borrar.

**Resultado medido** (na resolução nativa de 64px, antes de reescalar pra exibição):

| Personagem | Cores únicas antes | Cores únicas depois | Flat run antes | Flat run depois |
|---|---|---|---|---|
| Anão Guerreiro | 16.381 | 27 | 0,5% | 26,2% |
| *(referência: sprites reais do pack)* | 26-32 | — | — | 28,9%-32,1% |

Bateu quase exatamente na faixa dos sprites reais do Tiny RPG Pack (28,9%-32,1%). Visualmente o resultado manteve a identidade do personagem (barba, escudo, machado, cores) mesmo com a paleta bem mais enxuta — ficou pixel art de verdade, não só "parecendo". Imagens de comparação antes/depois salvas e enviadas no chat.

**Recomendação**: adotar esse pipeline (downscale + quantização) como etapa final depois de qualquer geração, em vez de tentar fazer o gerador de imagem entregar isso de primeira só no prompt (que, pelos testes até agora, não consegue sozinho). Fica então: (1) gerar a matriz seguindo o brief consolidado pra acertar arma/cor/pose, (2) rodar esse pós-processamento em cada personagem pra virar pixel art de paleta travada de verdade. Consigo automatizar isso pra recortar e processar os 36 personagens de uma vez, assim que você tiver uma matriz que queira converter.

### Diagnóstico de outra ferramenta de IA (confirmando nossa análise) + padrão técnico consolidado
Você perguntou pra ferramenta de geração que está usando como ela está gerando essas imagens, e a resposta dela bate exatamente com o que já tínhamos medido aqui: ela confirmou que não segue uma grade técnica real de sprite (não é "8-bit/16-bit/32-bit" de verdade, é imitação visual de pixel art renderizada em alta resolução, sem grade de pixel real por trás) — é a mesma conclusão a que chegamos comparando cores únicas e flat run ratio contra os sprites reais do Tiny RPG Pack. Bom sinal: duas fontes independentes confirmando o mesmo diagnóstico.

Ela também notou que a imagem de referência (a v3-simplificado, que reenviei — confirmei que é o mesmo arquivo de novo, 2172x724 aqui contra os "2048x682" que a ferramenta reportou; a proporção ~3:1 bate, a diferença de pixels é só reamostragem da própria ferramenta ao processar o upload) tem proporção 3:1, enquanto as gerações recentes saíram em ~16:9 — ou seja, nem a composição do canvas estava padronizada, além do nível de detalhe.

**Checklist proposto pela ferramenta** (composição/consistência): canvas 3:1, 6 personagens por imagem igualmente espaçados, altura visual idêntica entre raças equivalentes (variando só a proporção racial), aparência equivalente a sprite base de ~64x64px, mesmo número de níveis de sombra/highlight/outline/saturação em todas as raças, fundo preto puro, mesma posição vertical e escala de equipamento, ordem fixa (Caçador, Ladino, Mago, Clérigo, Guerreiro, Bárbaro).

**O que esse checklist resolve bem**: exatamente os problemas de composição/proporção que vínhamos flagrando (altura inconsistente entre raças, canvas mudando de forma, ordem de classe variando).

**O que esse checklist ainda não resolve**: ele não menciona paleta de cor nem tipo de sombreamento — ou seja, seguindo só essas regras, o resultado ainda deve sair como pintura digital em gradiente (a mesma categoria técnica que medimos em todas as gerações até agora, incluindo a própria v3-simplificado que você quer usar de modelo). Pra virar pixel art de paleta travada de verdade, isso precisa ser somado às regras que já tínhamos definido (paleta de 16-24 cores, sombreamento em blocos chapados, sem gradiente/anti-aliasing, contorno uniforme).

**Padrão técnico consolidado (juntando as duas listas) — usar daqui pra frente**:
1. Canvas 3:1, usando `racas-do-mundo-concept-v3-simplificado.png` (2172x724) como referência mestra de proporção/escala — subir ela como imagem de referência a cada geração.
2. 6 personagens por imagem, igualmente espaçados, ordem fixa: Caçador, Ladino, Mago, Clérigo, Guerreiro, Bárbaro.
3. Altura visual idêntica entre raças equivalentes (Humano = Elfo = Morto-vivo; Orc um pouco maior; Anão baixo e largo; Halfling o mais baixo, ~70% do Humano) — variando só a proporção racial, não a escala geral do desenho.
4. Fundo preto puro (nada de vinheta/brilho decorativo atrás do personagem — isso atrapalha inclusive nossa medição de proporção depois).
5. Mesma posição vertical e escala de equipamento entre raças.
6. **Paleta limitada (16-24 cores), sombreamento em blocos chapados, sem gradiente, sem anti-aliasing, contorno único uniforme** — sem isso, o resultado continua sendo pintura digital "parecida com pixel art", não pixel art de verdade (ver análise técnica acima).
7. Aplicar o brief consolidado (arma + paleta por raça x classe) já registrado na seção "Brief consolidado" do `sprite-briefs.md`.

### Novo formato testado: matriz única com as 36 combinações (v1)
Salvo em `Arte Promocional/Raca-Classe/Matriz-36-combinacoes-v1.png`. Diferente do fluxo anterior (1 raça por vez, 6 classes cada, em 6 imagens separadas), esta veio como uma única imagem com **as 6 raças (linhas) x 6 classes (colunas)** de uma vez, com cabeçalho de coluna (Caçador, Ladino, Mago, Clérigo, Guerreiro, Bárbaro — "Ladino" é sinônimo de Assassino, só trocar o nome na hora de padronizar). Fundo é um vinheta escura com brilho colorido atrás de cada personagem (efeito de apresentação, não é fundo transparente de sprite).

**Por que isso é relevante**: gerar tudo numa passada só, em vez de raça por raça, é exatamente o tipo de abordagem que reduz o "enriquecimento progressivo" que vínhamos vendo (Humano simples → Elfo/Morto-vivo cada vez mais ornamentados) — aqui a mesma paleta de pose/equipamento por classe se repete de forma consistente entre as raças (Mago sempre chapéu + cajado com gema, Clérigo sempre robe branco + cajado dourado, Guerreiro sempre espada+escudo, Bárbaro sempre machado+peles), com só a raça por baixo mudando. Se isso realmente segurar consistência de proporção entre raças (falta medir — a mistura com o fundo de brilho atrapalha a régua de altura de pixel que usamos antes), pode resolver o problema do nivelamento de um jeito mais simples do que refazer raça por raça.

**Medição técnica (aproximada)**: o fundo em degradê atrapalha a mesma metodologia limpa de antes (cores únicas / flat run ratio), mas mesmo com essa contaminação, amostrando 7 células da grade o **flat run ratio ficou entre 3,5% e 9% (média ~6%)** — bem acima dos 0,6%-1,5% medidos nas gerações raça x classe anteriores. Como o fundo em degradê tende a *reduzir* essa métrica (gradiente também não repete cor entre vizinhos), esse resultado mais alto é provavelmente uma medição por baixo do valor real do personagem sozinho — ou seja, sinal real de que esta geração usa mais blocos de cor chapada que as anteriores. Ainda longe dos ~30% dos sprites reais do Tiny RPG Pack, mas é a geração mais próxima do objetivo até agora.

**Pendências antes de adotar esse formato como padrão**:
- Confirmar a ordem das 6 raças nas linhas (os rótulos da esquerda saíram cortados no print que você mandou — só dá pra confirmar Morto-vivo, Anão e Orc pela aparência; as outras 3 linhas preciso que você confirme qual é Humano, Elfo e Halfling).
- Medir altura relativa entre raças nesse novo formato (pendente até isolar melhor o personagem do fundo).
- Decidir se o fundo com brilho é aceitável (bom pra arte de portrait/invocação, mas precisa virar fundo transparente puro se for base pra sprite de jogo).

### Próximo teste: prompt revisado pra pixel art de paleta travada
Decisão (nesta conversa): em vez de só "pedir menos detalhe", vamos testar um prompt que pede explicitamente paleta limitada (16-24 cores), sombreamento em blocos chapados (sem gradiente), sem anti-aliasing, contorno uniforme, e referência a estilos reais de baixo-bit (SNES/GBA, Stardew Valley, RPG Maker) em vez de "pixel art" genérico. Prompt completo e a lógica por trás dele estão em `sprite-briefs.md`, seção "Como pedir pixel art de verdade". Próximo passo prático: rodar esse prompt num personagem de teste e medir (mesma metodologia de cores únicas/flat run ratio) se ele realmente chega mais perto do padrão dos assets reais do Tiny RPG Pack (26-32 cores, ~30% flat run) — se a ferramenta atual resistir, o plano B é quantização de cor por código em cima da imagem gerada.

### Marco: recorte individual dos 36 portraits concluído e integrado à página de invocação (10/09/2026)
A pedido explícito ("precisamos recortar todos os personagens de forma correta e usar esse recorte na imagem de invocação"), a `Matriz-36-combinacoes-FINAL-v1.png` foi recortada em 36 arquivos individuais (um PNG por raça x classe, com fundo transparente) e a tela de invocação (`invocacao-web/`) passou a usar esses recortes em vez do CSS de spritesheet 6×6 que fatiava a matriz inteira por `background-position`.

**Como o recorte foi feito**: a matriz final tem 1240×1268px — não é um grid perfeitamente uniforme, cada célula tem tamanho ligeiramente diferente. O script localizou a grade automaticamente detectando linhas/colunas de fundo quase-preto que atravessam a imagem inteira (corredores entre células); o espaço entre corredores consecutivos define a banda de cada linha/coluna. Dentro de cada célula, o bounding-box do personagem foi calculado a partir dos pixels que não são fundo, com pequena margem — preservando a proporção original de cada raça/classe (nada foi esticado ou normalizado pra um tamanho único).

**Transparência sem furar roupa escura**: em vez de um threshold de cor simples, foi usado flood-fill a partir das bordas de cada recorte — só pixels quase-pretos **conectados à borda externa** viram transparentes. Isso preservou corretamente roupas escuras legítimas (capuz do Assassino, manto do Cultista Sombrio) que não fazem parte do fundo.

**Arquivos**: `invocacao-web/public/art/portraits/{raca}-{classe}.png` (slug sem acento, ex.: `anao-guerreiro.png`, `morto-vivo-cultista-sombrio.png`). A função `getPortraitSlug(row, column)`, adicionada a `lib/game.ts`, é a fonte única desse mapeamento. `page.tsx` e `globals.css` foram atualizados: `.portrait-art` agora usa `background-size:contain;background-position:center bottom`, alinhando todos os personagens pela base em vez de forçar o mesmo tamanho — o que deixa a diferença de altura entre raças visível na própria interface.

**Achado colateral relevante pra pendência do Halfling**: medindo a altura de cada recorte (bounding-box real, sem a distorção do canvas 2172x724 usado nas medições anteriores), a média do Halfling ficou em ~166px contra ~198px do Humano — **Halfling a ~84% da altura do Humano**. É uma melhora real em relação ao achado anterior (0% a +8%, ou seja, do mesmo tamanho ou maior que o Humano), mas ainda acima da meta de ~70% definida no brief. Como o recorte só extrai o que já está desenhado na matriz, ele não corrige proporção na origem — a diferença veio da própria arte final ser ligeiramente diferente da versão medida antes (ou de imprecisão de medição anterior pelo método do canvas fixo). De qualquer forma, a pendência **continua aberta**: se quiserem o Halfling batendo o 70% à risca, é preciso regenerar essa raça (ou aplicar um ajuste de escala controlado nos 6 recortes do Halfling) — recorte não resolve isso sozinho.

**O que ainda não foi feito**: a versão pixelizada (sprite de arena) dos 36 personagens. O recorte de hoje cobre só o portrait (tela de invocação/coleção); a pixelização usando o pipeline já validado (downscale BOX + quantização MAXCOVERAGE) ainda precisa ser aplicada aos 36 recortes quando entrarmos na etapa de sprite de arena.

### Sprites próprios Idle v1 — geração direta aprovada (10/09/2026)

**Estado atual dos arquivos (12/09/2026):** a estrutura de produção passou a ser `assets/sprites/<raça>/<classe>/animations/`, com o sprite-base na pasta da classe. Os 36 sprites-base ativos são `*-idle-v1-256.png`, todos com 256×256 e alfa; os 30 Idles não humanos foram reduzidos dos originais de 1254×1254 com vizinho mais próximo. Todos os originais grandes e as folhas experimentais antigas foram removidos das árvores ativas. Os parágrafos abaixo registram decisões e protótipos históricos e não descrevem mais os arquivos ativos.

**Animações direcionais humanas importadas (12/09/2026):** as seis classes humanas possuem Walk em oito direções sob `animations/<estado>/<direção>/frame_NNN.png`. A arena testa os ciclos East de 9 quadros a 8 FPS. O Bárbaro usa como estados ativos a pose e a caminhada com o machado nas mãos, preservando as variantes com o machado nas costas em estados separados. A seleção futura de uma pose desses pacotes para substituir a imagem representativa mostrada ao gerar um personagem continua pendente e não foi aplicada.

O Guerreiro Humano gerado diretamente em pixel art foi aprovado como nova referência visual dos personagens na arena. Essa decisão substitui, para os heróis novos, o plano anterior de transformar o portrait renderizado por downscale e quantização. Os registros desse pipeline permanecem acima como histórico técnico.

As 36 combinações foram refeitas individualmente. Cada geração usa o portrait recortado para identidade, cores e equipamento, e o Guerreiro Humano para câmera 3/4 top-down, contorno, densidade de pixel, enquadramento e ponto de apoio. Todos os arquivos Idle v1 usam canvas 1254×1254 e transparência alfa real validada. As proporções dirigidas são: Humano 100%, Orc 108% e mais largo, Halfling 70%, Anão 82% e largo, Elfo 100% e esguio, Morto-vivo 100%.

Fontes: `assets/sprites/<raça>/<classe>-idle-v1.png`. Cópias da aplicação: `invocacao-web/public/art/arena/heroes/`. A rota `/arena/herois` apresenta a matriz visual completa. Estes PNGs ainda não são spritesheets animadas; Walk, Attack, Hurt e Death deverão derivar do Idle aprovado de cada combinação.

#### Protótipo de movimento do Guerreiro Humano (em validação)

O primeiro teste animado foi consolidado no padrão de Idle semirrelaxado com 6 quadros a 3 FPS, caminhada para a direita com 7 quadros a 6 FPS e ataque com 6 quadros a 8 FPS. No Idle, espada e escudo ficam baixos e o movimento se limita à respiração. No Walk, as pernas alternam e o equipamento permanece firme, sem pose de ataque. Os três arquivos ativos do Guerreiro usam o sufixo `-spaced-v1.png` e são as únicas folhas mantidas em `assets/sprites/humano/animations/`. A reprodução pode ser vista em `/arena/animacoes`, inclusive na escala de aproximadamente 48 px do corpo humano.

O primeiro roteiro aplicado à arena testou aproximadamente 2,5 SQM/s. Após revisão da passada, o deslocamento ativo foi reduzido para cerca de 1,35 SQM/s, sincronizado ao Walk de 6 FPS. O teste ativo usa aproximação de combate, preparação curta, ataque básico e reinício contra dummies estáticos.

**Ataque básico do Guerreiro Humano — protótipo:** sequência de 6 quadros para a direita, com antecipação curta, levantamento da espada, corte horizontal, pequeno arco dourado no contato e retorno ao Idle. A reprodução usa 8 FPS, portanto o golpe completo dura 0,75 segundo. O arquivo ativo é `assets/sprites/humano/animations/guerreiro-ataque-basico-direita-v3-spaced-v1.png`, com o centro dos pés e a linha de chão fixos. Na arena, Idle e Walk permanecem ancorados pelo centro do canvas; o Attack troca para um pivô independente na base dos pés.

## Pendências / próximos passos
- Árvore de habilidades e magias por classe (ligada também à raça).
- Mecânica exata do Cultista Sombrio (classe exclusiva vs. reskin do Clérigo) — **assets visuais já resolvidos** via Necromancer do pack comprado.
- Sprites de ataque e de projétil: cobertos para Humano/Orc/Morto-vivo nas classes Guerreiro, Caçador, Mago e Cultista Sombrio via o pack comprado. Ainda faltam: classe Bárbaro, classe Assassino (nenhum dos dois packs tem), e as raças Halfling, Anão, Elfo (nenhuma base disponível nos packs).
- Plataforma inicial: navegador (aprovada em 09/09/2026). Recomendação de stack: Godot com GDScript; configuração e implementação pendentes.
- Fonte de assets pra completar as lacunas acima (outro pack ou geração via IA).
- Proporção do Halfling: mesmo após o recorte individual, segue ~14 pontos percentuais acima da meta de 70% da altura do Humano — precisa de regeneração ou ajuste de escala dedicado.
- Pixelização (sprite de arena) dos 36 recortes de portrait — pipeline validado, ainda não aplicado em lote às 36 combinações.

### Arena de validação do Guerreiro Humano (10/09/2026)

A tentativa de colocar as seis classes humanas simultaneamente foi descartada. As correções automáticas deformaram a anatomia de Bárbaro e Assassino, cortaram armas e bordas no Caçador e removeram a barba do Mago ao confundi-la com o fundo. Todos esses arquivos animados e seus scripts experimentais foram apagados.

O teste atual usa somente o Guerreiro Humano contra um dummy. Os Idle estáticos de todas as classes continuam aprovados e intactos; cada nova animação deverá partir diretamente do Idle correspondente, manter identidade, barba, armas, bordas e anatomia, e ser validada individualmente antes de entrar na arena.

**Bárbaro Humano — novo Idle em validação (11/09/2026):** o candidato `assets/sprites/humano/animations/barbaro-idle-semirrelaxado-v1-spaced-v1.png` usa diretamente a arte estática aprovada, sem redesenho ou limpeza automática. A animação tem 6 quadros a 3 FPS e simula apenas uma respiração vertical mínima com a base dos pés fixa. O machado completo, a barba, as peles e a anatomia permanecem iguais em todos os quadros. O candidato foi colocado parado na rota `/arena` para avaliação antes de produzir o Walk.

**Bárbaro Humano — Walk em validação (11/09/2026):** `assets/sprites/humano/animations/barbaro-walk-direita-v1-spaced-v1.png` contém 7 quadros a 6 FPS. As pernas passam uma pela outra e assumem contatos opostos no ciclo; tronco e cintura continuam voltados à direita e o machado permanece inteiro nas duas mãos. O fundo quadriculado do bruto foi removido somente a partir das bordas, seguido da retenção do componente principal conectado do personagem, evitando apagar peles, metal ou barba. A folha usa transparência real e um frame vazio entre quadros e percorre a linha inferior de `/arena`.

**Bárbaro Humano — Attack em validação (11/09/2026):** `assets/sprites/humano/animations/barbaro-ataque-basico-direita-v1-spaced-v1.png` contém 6 quadros a 8 FPS: antecipação, elevação do machado, aceleração, golpe horizontal, continuidade e recuperação. O centro dos pés usa uma âncora própria, a escala permanece constante e o machado completo cabe na célula mesmo durante sua extensão máxima. Um segundo dummy foi colocado na linha inferior da arena; o Bárbaro agora executa o roteiro completo de aproximação, ataque e reinício.

**Calibração de escala pelo Idle:** a comparação direta mostrou Walk e Attack aproximadamente 9% maiores que o Idle aprovado. O Idle permaneceu intacto; o Walk passou a 75 px de canvas renderizado com compensação vertical de 3 px, e o Attack passou a 94 px com pivô de 23 px. Esses valores igualam a altura corporal e a linha dos pés nos três estados apesar das dimensões diferentes das folhas.

**Correção de escala e contorno:** os resíduos cinza conectados ao personagem alteravam a medição da base e criavam flashes claros. O arquivo final do Attack usa uma paleta fixa compartilhada de 48 cores, sem dithering, remove somente a franja clara externa e fixa todas as botas em `y=557`. A reprodução usa altura de 103 px e deslocamento do pivô de 22 px, calibrados separadamente do Walk.


