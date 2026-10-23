# DOSLib para BricsCAD V27 — compilacao local

Foram acrescentadas as configuracoes `Debug_BRX27|x64` e `Release_BRX27|x64`
ao projeto e a solucao, alem do reconhecimento de `BRX27` em `source/ArxVer.h`.
As configuracoes anteriores foram preservadas. A interface LISP `dos_*` nao foi alterada.
O callback de teclado de `dos_getsecret` passa a retornar `bool` na configuracao
BRX27, conforme `AcedFilterWinMsgFn` do SDK V27, preservando os demais alvos.

## Requisitos

O manual `PortingManual.txt` do BRX SDK V27 especifica Visual Studio 2022,
toolset v143 e Windows SDK 10.0.19041.0. O DOSLib tambem usa ATL e MFC.
Instalar o BRX SDK nao instala essas ferramentas da Microsoft.

- SDK instalado: `C:\Program Files\Bricsys\BRXSDK\BRX27.1.05.0`.
- Visual Studio 2022 ou Build Tools, com ferramentas C++ MSVC v143 para x64/x86,
  bibliotecas ATL e MFC correspondentes e Windows SDK 10.0.19041.0.

## Compilacao

Na raiz desta pasta, executar no PowerShell:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\build_brx27.ps1
```

Para outro caminho do SDK ou MSBuild:

```powershell
.\scripts\build_brx27.ps1 -SdkPath 'D:\SDK\BRX27' -MSBuildPath 'D:\VS\MSBuild\Current\Bin\MSBuild.exe'
```

Tambem e possivel abrir `source/DOSLib.sln` e selecionar `Release_BRX27|x64`.
O projeto aceita a propriedade MSBuild `Brx27SdkDir`, a variavel de ambiente
`BRX27_SDK_PATH` ou, na ausencia das duas, o caminho padrao instalado acima.
Se o Windows SDK 10.0.19041.0 estiver ausente, o script procura um SDK Windows 10/11
instalado com headers, bibliotecas x64 e compilador de recursos. Tambem aceita
`-WindowsSdkVersion` para selecionar explicitamente uma versao. O projeto aberto
diretamente no Visual Studio continua usando 10.0.19041.0 por padrao.

O script reconhece ferramentas presentes mesmo quando o instalador registra a
instancia como incompleta; nesse caso, exibe um aviso e o MSBuild verifica os
componentes necessarios. Isso nao confirma a integridade de toda a instalacao.

Saida esperada: `bin/Release/brx/DOSLib27x64.brx`.

## Estado da validacao

Ambiente local: BRX SDK 27.1.05.0, MSVC v143 14.44.35207 com ATL/MFC,
Windows SDK 10.0.26100.0 (diferente da versao de referencia do manual BRX).
Compilacao Release_BRX27 concluida em 23/10/2026 com zero erros e zero avisos.
Binario gerado em `bin/Release/brx/DOSLib27x64.brx`.
As ferramentas host x64 foram selecionadas para evitar o erro LNK1101 observado
no linker host x86. O caminho padrao do BRX SDK tambem considera `ProgramW6432`
para localizar corretamente a instalacao em Program Files quando MSBuild e 32 bits.

Depois de compilar, validar o carregamento no BricsCAD V27 e as funcoes DOSLib
usadas pelo IDCAD, incluindo dialogs, arquivos, caminhos e retornos de cancelamento.
Uma compilacao bem-sucedida nao substitui esses testes de execucao.

Para o primeiro teste, abrir o BricsCAD V27, usar `APPLOAD` e selecionar
`bin/Release/brx/DOSLib27x64.brx`. Depois executar `(dos_version)` na linha LISP.
Esse teste apenas confirma o carregamento e a consulta de versao; ainda e preciso
testar as rotinas reais do IDCAD. A biblioteca mantem a versao original 9.1.2.0;
o numero 27 no nome do binario identifica o CAD de destino.

Em 23/10/2026, o mantenedor relatou carregamento bem-sucedido no BricsCAD V27,
retorno `(9 1 2)` em `(dos_version)` e inicializacao do IDK/IDCAD. Esse relato
nao representa cobertura completa das funcoes da biblioteca.

## Pacote comunitario

O pacote inicial usa o identificador `9.1.2-brx27.1`, sem alterar o retorno LISP.
Depois de compilar e registrar as alteracoes no Git, executar:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\package_brx27.ps1
```

O ZIP e os checksums ficam em `artifacts/`. O pacote inclui o binario, LICENSE,
creditos, instrucoes, changelog e informacao do commit de origem. Nao inclui
SDKs, instaladores nem arquivos de projetos de clientes. Publicar inicialmente
como pre-release/candidato para testes, indicando os limites acima.

Manter o arquivo LICENSE e os avisos originais ao distribuir fontes ou binarios derivados.
