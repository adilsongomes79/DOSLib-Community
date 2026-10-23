# Contributing to DOSLib-Community

Thank you for helping continue DOSLib. Small, focused fixes, CAD compatibility
reports, documentation and reproducible test cases are welcome.

## Scope and compatibility

- Keep existing `dos_*` names, argument handling, return values and cancellation
  behavior compatible unless a breaking change is explicitly discussed.
- Preserve the original copyright, MIT license and upstream history.
- Isolate SDK-specific adaptations with the appropriate version conditions.
- Do not include proprietary SDK files, installers, private CAD projects, license
  keys, credentials or generated build output in pull requests.
- Existing AutoCAD, older BricsCAD and ZWCAD configurations are inherited;
  keeping them in the solution does not mean they were tested by this fork.

## Build and test

Follow [the build guide](BRX27_IDCAD.md). The BRX SDK must be obtained separately
from its vendor. To propose a code change, report the configuration, toolset,
BRX SDK and Windows SDK used, plus the build result.

For runtime checks, state the exact CAD version and edition, Windows version,
function and minimal LISP call, expected result and actual result. Test normal
and cancel paths when relevant. Use disposable drawings and files for tests
that modify data. Remove personal paths and business data before sharing.

Compilation, loading, a single function call and full application validation
are different checks. Mark untested cases clearly; do not infer full coverage
from `(dos_version)` or a successful application startup.

## Pull requests

Describe the problem and observable behavior after the fix. Include a focused
reproduction and validation results. English and Portuguese contributions are
welcome. Open an issue before broad refactoring or changes to LISP contracts.

## Em portugues

Contribuicoes em portugues sao bem-vindas. Preserve nomes, parametros, retornos
e cancelamentos das funcoes `dos_*`. Informe as versoes do CAD e dos SDKs,
o resultado da compilacao e exatamente quais testes fez no CAD. Nao envie
SDKs, instaladores, credenciais, projetos de clientes ou arquivos temporarios.
