# Fluxo de PR com verificação Babysitter (monorepo)

Objetivo: antes do merge, ter **pass/fail explícito** do CLI Babysitter neste repositório, com saída acionável (comandos `health` e `configure validate`).

## Como o Babysitter é acionado (gatilhos)

Há **dois canais** diferentes — não confundir:

| Canal | O que é | Quem / quando aciona |
|--------|---------|----------------------|
| **Gate neste repo (CI + script)** | O CLI `babysitter` compilado do monorepo corre `health` e `configure validate` via `npm run verify:babysitter`. | **Automático:** em cada **pull request** (e em `workflow_dispatch` manual no GitHub), o job *Lint, Tests, Package* em `.github/workflows/ci.yml` corre o passo **Babysitter CLI gate** logo após `npm run build:sdk`. Não depende da skill no Cursor. |
| **Skill Babysitter no Cursor CLI** | Orquestração / processos no IDE (babysit, harness, etc.). | **Humano / agente** no ambiente local; é complementar ao gate de PR, não o substitui. |

**Resumo para o board:** na PR, o Babysitter “acende” sozinho no GitHub Actions quando o workflow de CI corre; falha bloqueia merge na prática (check vermelho). Opcionalmente, cada dev pode correr o mesmo comando localmente antes de abrir a PR.

## Comando mínimo (local)

Na raiz do repositório, após dependências e build do SDK:

```bash
npm ci
npm run build:sdk
npm run verify:babysitter
```

- **Sucesso:** termina com código 0 e mensagem `verify:babysitter: OK`.
- **Falha:** código ≠ 0; leia a seção **Next Steps** do `babysitter health` ou os erros de `configure validate`.

O script fixa o diretório de trabalho na **raiz do monorepo** (evita avisos enganosos de `.a5c` quando o `npm exec` aponta para `packages/sdk`).

## Na PR (CI)

O workflow [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) executa `npm run verify:babysitter` após o build do SDK. Se este passo falhar, a PR fica vermelha até corrigir o que o CLI indicar.

## Checklist rápido para quem abre PR

1. `npm ci` e `npm run build:sdk` localmente (ou confiar no CI após push).
2. `npm run verify:babysitter` antes de pedir review (opcional mas recomendado).
3. Conferir o artefato `babysitter-gate.log` no job de CI se o gate falhar no remoto.

## Fluxo de branch (empresa)

Regras de branch e script `git-start-iva-task.sh` ficam no repositório/processos da **IVAN CRUZ PROJETOS** (`docs/branching.md` lá); este documento cobre só o **gate Babysitter neste monorepo**.
