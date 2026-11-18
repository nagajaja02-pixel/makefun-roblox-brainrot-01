import { copyFileSync, existsSync, lstatSync, mkdirSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { buildDossier } from "./vendor/makefun-roblox.ts";

const repository = dirname(fileURLToPath(import.meta.url));
const output = resolve(process.env.MAKEFUN_OUTPUT_DIR || "/output");
if (output === repository || repository.startsWith(output + "/")) {
  throw new Error("Output must not contain the repository.");
}
mkdirSync(output, { recursive: true });

function copyTree(source: string, destination: string): void {
  const stat = lstatSync(source);
  if (!stat.isDirectory()) throw new Error("Expected an ordinary directory: " + source);
  mkdirSync(destination, { recursive: true });
  const entries = readdirSync(source, { withFileTypes: true }).sort((a, b) => a.name < b.name ? -1 : a.name > b.name ? 1 : 0);
  for (const entry of entries) {
    if (entry.name.startsWith(".")) continue;
    const from = join(source, entry.name);
    const to = join(destination, entry.name);
    if (entry.isDirectory()) copyTree(from, to);
    else if (entry.isFile()) copyFileSync(from, to);
    else throw new Error("Only regular files and directories are allowed: " + from);
  }
}

for (const name of ["game.rbxl", "PLAY.json"]) {
  const source = join(repository, name);
  if (!lstatSync(source).isFile()) throw new Error("Missing regular file: " + name);
  copyFileSync(source, join(output, name));
}
for (const name of ["src", "screenshots"]) {
  const destination = join(output, name);
  if (existsSync(destination)) rmSync(destination, { recursive: true });
  copyTree(join(repository, name), destination);
}
const dossier = buildDossier(output, {
  text_max_bytes: 65536,
  screenshots: { max: 4, max_bytes: 262144 },
  max_instances: 500000,
  scripts_max_source_bytes: 8 * 1024 * 1024,
  scripts_max_path_chars: 1048576,
});
writeFileSync(join(output, "dossier.json"), dossier);
console.log("Brainrot Blitz artifacts ready: " + output);
