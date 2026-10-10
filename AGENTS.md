# Orientação para trabalhar no RPG Game

Leia primeiro `docs/MAPA-DO-PROJETO.md`. Ele reúne o conceito, as fontes por assunto, o estado encontrado e as divergências conhecidas. Para localizar qualquer arquivo ou pasta, consulte `docs/INVENTARIO-ARQUIVOS.md` e confirme o caminho no disco.

## Fontes e contexto

- Regras de jogo: `docs/design-doc.md`. O documento mistura histórico e decisões; prefira os trechos explicitamente aprovados/consolidados, sem tratar toda proposta como decisão.
- Atualização de 09/09/2026: navegador aprovado; referência de chances/cores em `docs/referencias/raridades-qualidades-2026-09-09.png`. São 5 raridades (inclui Épico); Excepcional supera Excelente. Bônus atuais de raridade: 0/1/3/5/7; de qualidade: 0/1/2/3. A imagem é referência histórica; as tabelas do design incorporam as revisões posteriores. Atributos começam em 1 cada, além dos 30 pontos variáveis e bônus. Consulte as tabelas atualizadas do design, não os valores antigos.
- Arte por raça/classe: seção **Brief consolidado pra gerar a matriz de 36 numa passada só (regras finais aprovadas)** de `docs/sprite-briefs.md`.
- Portrait oficial: `Arte Promocional/Raca-Classe/Versao 2 - Matriz Unica/Matriz-36-combinacoes-FINAL-v1.png`.
- Proporções raciais: `Arte Promocional/Racas/racas-do-mundo-concept-v3-simplificado.png` e decisões de altura em `docs/design-doc.md`.
- `Claude outputs/sprite-briefs.md` é uma versão histórica menos atualizada; não a use para substituir decisões de `docs/`.
- O levantamento inicial sem código é histórico: agora existe `invocacao-web/`, protótipo React/TypeScript/Vinext da invocação com D1. Leia seu README e o mapa antes de editar. A raiz geral continua separada do checkout do site.

## Cuidados de continuidade

- Distinguir decisão documentada, arquivo existente, experimento e funcionalidade implementada.
- Ficha do herói: qualidade = cor de uma estrela ao lado do nome; raridade = borda da moldura. **ID de 32 bits somente ao Aceitar**, nunca na revelação. Invocar custa 10; reciclar devolve 5 sem criar ID. Protótipo possui alocação central no banco da implantação; candidatos têm token de operação. Troca, compra e venda seguem futuras; proprietário separado do ID, moeda/pagamentos indefinidos.
- Portrait e sprite de arena são entregas diferentes. A matriz aprovada não é uma spritesheet animada pronta para importar.
- Ladino e Assassino designam a mesma classe nos materiais atuais. Morto-vivo usa Cultista Sombrio no lugar do Clérigo; classe exclusiva versus reskin continua em aberto.
- Não retomar automaticamente regras antigas: Elfo tem a altura do Humano; besta é de Halfling/Morto-vivo; Guerreiro Anão usa machado; Clérigo usa emblema solar.
- Preserve os originais dos packs e o histórico de arte. Ao produzir derivados, deixe clara a fonte e o destino.
- Atualize o mapa quando novas decisões, sistemas ou pastas alterarem a organização. O inventário é uma fotografia datada, não um índice atualizado automaticamente.
- Estas notas orientam a retomada a partir dos arquivos; novas instruções do usuário prevalecem.
