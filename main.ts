import { copyFileSync, mkdirSync, readdirSync, writeFileSync } from 'node:fs';
import { basename, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { buildDossier } from './vendor/makefun-roblox.ts';

const root = fileURLToPath(new URL('.', import.meta.url));
const output = resolve(process.env.MAKEFUN_OUTPUT_DIR ?? '/output');

function copyDirectory(relative: string): void {
  mkdirSync(join(output, relative), { recursive: true });
  for (const entry of readdirSync(join(root, relative), { withFileTypes: true })) {
    if (entry.name.startsWith('.')) continue;
    const child = join(relative, entry.name);
    if (entry.isDirectory()) copyDirectory(child);
    else if (entry.isFile()) copyFileSync(join(root, child), join(output, child));
    else throw new Error(`Unsupported artifact entry: ${child}`);
  }
}

mkdirSync(output, { recursive: true });
for (const file of ['game.rbxl', 'PLAY.json']) {
  copyFileSync(join(root, file), join(output, basename(file)));
}
for (const directory of ['src', 'screenshots']) copyDirectory(directory);

const dossier = buildDossier(output, {
  text_max_bytes: 65536,
  screenshots: { max: 4, max_bytes: 262144 },
  max_instances: 500000,
  scripts_max_source_bytes: 8 * 1024 * 1024,
  scripts_max_path_chars: 1048576,
});
writeFileSync(join(output, 'dossier.json'), dossier);
