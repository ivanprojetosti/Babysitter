# Verificação Babysitter antes da PR (fluxo dev)

Objetivo: após criar o branch e commitar, obter **pass/fail explícito** localmente e repetir o mesmo sinal na PR via CI.

## Comando mínimo (local)

Na raiz do monorepo:

```bash
npm run verify:dev
```

Isso executa `scripts/verify-babysitter-dev.sh`: `build:sdk` + `smoke:cli` do pacote `@a5c-ai/babysitter-sdk` (mesma família de checagem do job **SDK smoke CLI** em `.github/workflows/ci.yml`).

- **Passou:** pode abrir/atualizar a PR com confiança de que o binário e o artefato compilado sobem.
- **Falhou:** a saída do `smoke:cli` ou do `build` indica o estágio que quebrou (sem depender de “repo oficial” externo — tudo roda neste workspace).

### Variáveis opcionais

| Variável | Efeito |
|----------|--------|
| `BABYSITTER_VERIFY_KEEP_RUNS=1` | Não apaga o diretório temporário de runs usado no smoke (útil para inspecionar `.a5c`-style artifacts sob `/tmp`). |

## O que a PR já valida (GitHub Actions)

O workflow `CI` em `.github/workflows/ci.yml` roda lint, metadata, build, testes unitários do SDK, validações de plugins e, na matriz `packages-sdk`, o **SDK smoke CLI** com diretório de runs dedicado.

Se `npm run verify:dev` passar localmente e o CI da PR falhar, compare o log do job correspondente no GitHub (artefatos `sdk-artifacts-*` / `test-logs`).

## Skill no Cursor CLI

Ter a skill do Babysitter no Cursor **não substitui** o gate acima: a skill orquestra agentes; este script/CI garantem que o **pacote e o CLI** do repositório continuam íntegros após as mudanças.
