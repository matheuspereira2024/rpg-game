import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import sharp from '../invocacao-web/node_modules/.pnpm/sharp@0.34.5/node_modules/sharp/lib/index.js';

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(scriptDir, '..');
const source = path.join(
  root,
  'Arte Promocional',
  'Raca-Classe',
  'Versao 2 - Matriz Unica',
  'Matriz-36-combinacoes-FINAL-v1.png',
);
const outputRoot = path.join(root, 'assets', 'portraits');

const races = [
  { slug: 'humano', name: 'Humano' },
  { slug: 'orc', name: 'Orc' },
  { slug: 'halfling', name: 'Halfling', scale: 0.92 },
  { slug: 'anao', name: 'Anão' },
  { slug: 'elfo', name: 'Elfo' },
  { slug: 'morto-vivo', name: 'Morto-vivo' },
];
const classes = [
  { slug: 'cacador', name: 'Caçador' },
  { slug: 'assassino', name: 'Assassino' },
  { slug: 'mago', name: 'Mago' },
  { slug: 'clerigo', name: 'Clérigo' },
  { slug: 'guerreiro', name: 'Guerreiro' },
  { slug: 'barbaro', name: 'Bárbaro' },
];

// The generated matrix is not a mathematically uniform grid. These cuts follow
// the actual empty gutters, so staffs, shields, bows and axes stay intact.
const xCuts = [0, 211, 397, 592, 794, 1016, 1240];
const yCuts = [0, 231, 454, 644, 847, 1055, 1268];
const canvasSize = 256;
const darkThreshold = 14;
const sourcePadding = 5;

const { data, info } = await sharp(source).removeAlpha().raw().toBuffer({ resolveWithObject: true });
if (info.width !== 1240 || info.height !== 1268 || info.channels !== 3) {
  throw new Error(`Matriz inesperada: ${info.width}x${info.height}, ${info.channels} canais.`);
}

function contentBounds(left, top, width, height) {
  let minX = left + width;
  let minY = top + height;
  let maxX = left - 1;
  let maxY = top - 1;
  for (let y = top; y < top + height; y++) {
    for (let x = left; x < left + width; x++) {
      const offset = (y * info.width + x) * 3;
      if (data[offset] + data[offset + 1] + data[offset + 2] > darkThreshold) {
        minX = Math.min(minX, x);
        minY = Math.min(minY, y);
        maxX = Math.max(maxX, x);
        maxY = Math.max(maxY, y);
      }
    }
  }
  if (maxX < minX || maxY < minY) throw new Error(`Célula vazia em ${left},${top}.`);
  minX = Math.max(left, minX - sourcePadding);
  minY = Math.max(top, minY - sourcePadding);
  maxX = Math.min(left + width - 1, maxX + sourcePadding);
  maxY = Math.min(top + height - 1, maxY + sourcePadding);
  return { left: minX, top: minY, width: maxX - minX + 1, height: maxY - minY + 1 };
}

const manifest = [];
for (let row = 0; row < races.length; row++) {
  const race = races[row];
  const raceDir = path.join(outputRoot, race.slug);
  await fs.mkdir(raceDir, { recursive: true });
  for (let column = 0; column < classes.length; column++) {
    const baseClass = classes[column];
    const heroClass = race.slug === 'morto-vivo' && baseClass.slug === 'clerigo'
      ? { slug: 'cultista-sombrio', name: 'Cultista Sombrio' }
      : baseClass;
    const cell = {
      left: xCuts[column],
      top: yCuts[row],
      width: xCuts[column + 1] - xCuts[column],
      height: yCuts[row + 1] - yCuts[row],
    };
    // The undead cultist's green particles cross the gutter above it. Exclude
    // those seven pixels only from the Elven Cleric cell while keeping the
    // cultist's own crop at its clean row boundary.
    if (row === 4 && column === 3) cell.height = 1048 - cell.top;
    const bounds = contentBounds(cell.left, cell.top, cell.width, cell.height);
    let image = sharp(source).extract(bounds);
    let targetWidth = bounds.width;
    let targetHeight = bounds.height;
    const fitScale = Math.min(1, 240 / bounds.width, 240 / bounds.height);
    const scale = Math.min(race.scale ?? 1, fitScale);
    if (scale < 1) {
      targetWidth = Math.max(1, Math.round(bounds.width * scale));
      targetHeight = Math.max(1, Math.round(bounds.height * scale));
      image = image.resize(targetWidth, targetHeight, { kernel: sharp.kernel.lanczos3 });
    }
    const portraitBuffer = await image.png({ compressionLevel: 9 }).toBuffer();
    const destination = path.join(raceDir, `${heroClass.slug}.png`);
    await sharp({
      create: { width: canvasSize, height: canvasSize, channels: 3, background: '#000000' },
    })
      .composite([{ input: portraitBuffer, left: Math.floor((canvasSize - targetWidth) / 2), top: Math.floor((canvasSize - targetHeight) / 2) }])
      .png({ compressionLevel: 9 })
      .toFile(destination);
    manifest.push({
      race: race.name,
      class: heroClass.name,
      file: path.relative(root, destination).replaceAll('\\', '/'),
      canvas: `${canvasSize}x${canvasSize}`,
      scale: scale === 1 ? '100%' : `${Math.round(scale * 100)}%`,
      sourceCell: cell,
      sourceContent: bounds,
    });
  }
}

await fs.writeFile(
  path.join(outputRoot, 'manifest.json'),
  `${JSON.stringify({ source: path.relative(root, source).replaceAll('\\', '/'), order: { rows: races.map(r => r.name), columns: classes.map(c => c.name) }, portraits: manifest }, null, 2)}\n`,
  'utf8',
);

const thumbs = await Promise.all(manifest.map(async item => ({ input: await fs.readFile(path.join(root, item.file)), width: canvasSize, height: canvasSize })));
await sharp({ create: { width: canvasSize * 6, height: canvasSize * 6, channels: 3, background: '#000000' } })
  .composite(thumbs.map((thumb, index) => ({ input: thumb.input, left: (index % 6) * canvasSize, top: Math.floor(index / 6) * canvasSize })))
  .png({ compressionLevel: 9 })
  .toFile(path.join(outputRoot, '_contato-36.png'));

console.log(`Gerados ${manifest.length} portraits em ${outputRoot}`);
