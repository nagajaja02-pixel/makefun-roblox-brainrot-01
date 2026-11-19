import { copyFileSync, mkdirSync, readdirSync, lstatSync, writeFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { buildDossier } from './vendor/makefun-roblox.ts';

const root = dirname(fileURLToPath(import.meta.url));
const output = resolve(process.env.MAKEFUN_OUTPUT_DIR || '/output');
if (output === root) throw new Error('Output directory must differ from the source directory');
mkdirSync(output, { recursive: true });

function copyTree(source: string, target: string): void {
  mkdirSync(target, { recursive: true });
  const entries = readdirSync(source, { withFileTypes: true }).sort((a, b) => a.name < b.name ? -1 : a.name > b.name ? 1 : 0);
  for (const entry of entries) {
    if (entry.name.startsWith('.')) continue;
    const from = join(source, entry.name);
    const to = join(target, entry.name);
    if (entry.isDirectory()) copyTree(from, to);
    else if (entry.isFile()) copyFileSync(from, to);
    else throw new Error('Only regular files and directories may be packaged');
  }
}

const place = join(root, 'game.rbxl');
const placeStat = lstatSync(place);
if (!placeStat.isFile() || placeStat.size === 0) throw new Error('game.rbxl must be a nonempty regular file');
if (placeStat.size > 32 * 1024 * 1024) throw new Error('game.rbxl exceeds 32 MiB');
copyFileSync(place, join(output, 'game.rbxl'));
copyFileSync(join(root, 'PLAY.json'), join(output, 'PLAY.json'));
copyTree(join(root, 'src'), join(output, 'src'));
copyTree(join(root, 'screenshots'), join(output, 'screenshots'));
const dossier = buildDossier(output, {
  text_max_bytes: 65536,
  screenshots: { max: 4, max_bytes: 262144 },
  max_instances: 500000,
  scripts_max_source_bytes: 8388608,
  scripts_max_path_chars: 1048576,
});
writeFileSync(join(output, 'dossier.json'), dossier);
