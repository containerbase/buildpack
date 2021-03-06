import shell from 'shelljs';
import { opts } from './utils.js';

const version = opts.release;
const dry = opts.dryRun;

shell.echo(`Publish version: ${version}`);
process.env.TAG = version;

if (dry) {
  shell.echo('DRY-RUN: done.');
  shell.exit(0);
}

shell.echo('Pushing docker images');

const r = shell.exec('docker buildx bake --progress plain push');
if (r.code) {
  shell.exit(1);
}
