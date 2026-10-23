# DOSLib-Community

Continuidade comunitaria da [DOSLib](https://github.com/dalefugier/DOSLib),
biblioteca de utilitarios acessiveis por LISP, criada por **Dale Fugier e
Robert McNeel & Associates**. O primeiro trabalho deste fork e o suporte ao
**BricsCAD V27 para Windows x64**.

[English](README.md) | [Compilacao](BRX27_IDCAD.md) |
[Contribuir](CONTRIBUTING.md) | [Alteracoes](CHANGELOG.md)

## Objetivo

Depois do anuncio de encerramento da manutencao original, queremos ajudar a
manter esse projeto disponivel para a comunidade, preservar as funcoes existentes
e permitir que outros desenvolvedores contribuam com novas compatibilidades.

Este e um fork comunitario independente, sem representar uma versao oficial
da McNeel ou da BricsCAD. Nosso agradecimento aos autores originais e a todos
que contribuiram para a DOSLib.

## O que foi validado

- Compilacao Release para BricsCAD V27, Windows x64, sem erros nem avisos.
- O mantenedor relatou carregamento bem-sucedido no BricsCAD V27,
  retorno `(9 1 2)` para `(dos_version)` e inicializacao do IDK/IDCAD.
- A cobertura completa das funcoes e os testes em outros ambientes ainda estao
  pendentes. Outros CADs, Debug, Linux e macOS nao foram validados por este fork.

O pacote inicial **9.1.2-brx27.1** e um candidato para testes. A versao interna
da biblioteca continua **9.1.2**; o **27** em `DOSLib27x64.brx` indica o CAD de destino.

## Como usar

1. Baixe o pacote Windows x64 para BricsCAD V27 em
   [Releases](https://github.com/adilsongomes79/DOSLib-Community/releases).
   Se ainda nao houver arquivos publicados, use o guia de compilacao.
2. Extraia os arquivos e, no BricsCAD V27 com suporte BRX, use `APPLOAD`
   para carregar `DOSLib27x64.brx`.
3. Execute `(dos_version)`; o retorno esperado e `(9 1 2)`.
4. Teste as operacoes reais do seu aplicativo, inclusive cancelamentos,
   caminhos com espacos/acentos e manipulacao de arquivos, antes do uso em producao.

Nao carregue duas versoes da DOSLib na mesma sessao. Este binario e especifico
para BricsCAD V27 Windows x64.

## Compilar e contribuir

Instale Build Tools/Visual Studio 2022 com C++ v143, ATL, MFC e Windows SDK,
alem do BRX SDK V27 obtido diretamente do fornecedor.
Consulte [BRX27_IDCAD.md](BRX27_IDCAD.md) para comandos e versoes.

Relatos de problemas, testes em outros ambientes, correcoes e documentacao
sao bem-vindos em portugues ou ingles. Veja [CONTRIBUTING.md](CONTRIBUTING.md).

## Licenca e creditos

[Licenca MIT](LICENSE), preservando o copyright original de Robert McNeel &
Associates. DOSLib e uma marca de Robert McNeel & Associates.
SDKs e ferramentas de terceiros seguem suas respectivas licencas e nao fazem
parte deste repositorio.
