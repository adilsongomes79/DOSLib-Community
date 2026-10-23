# DOSLib-Community

Community continuation of [DOSLib](https://github.com/dalefugier/DOSLib),
the LISP-callable utility library created by **Dale Fugier and Robert McNeel &
Associates**. This fork starts with support for **BricsCAD V27 on Windows x64**.

[Portugues](README.pt-BR.md) | [Build guide](BRX27_IDCAD.md) |
[Contributing](CONTRIBUTING.md) | [Changelog](CHANGELOG.md) |
[Acknowledgments](ACKNOWLEDGMENTS.md) |
[Original documentation](https://github.com/dalefugier/DOSLib/wiki)

## Why this fork?

The original project announced the end of maintenance after 34 years. Its source
and MIT license allow the community to continue this work. Our intention is to
keep DOSLib usable on newer CAD releases, preserve existing LISP contracts and
welcome contributions from other developers and users.

This is an independent community fork, not an official McNeel or BricsCAD release.
Thank you to the original authors and everyone who has contributed to DOSLib.

## Current status

| Target/check | Status |
| --- | --- |
| BricsCAD V27, Windows x64 Release | Built successfully |
| Loading in BricsCAD V27 | Reported successful by the maintainer |
| `(dos_version)` | Reported result: `(9 1 2)` |
| IDK/IDCAD startup | Reported successful by the maintainer |
| Full function regression / other user environments | Pending |
| Older CAD targets, Debug, Linux and macOS | Not validated by this fork |

The initial community package is **9.1.2-brx27.1**, an initial test candidate.
DOSLib itself still reports **9.1.2**. The **27** in `DOSLib27x64.brx` identifies
the target CAD release. Successful loading is not a complete regression test.

## Using the binary

1. Get the BricsCAD V27 Windows x64 package from
   [release 9.1.2-brx27.1](https://github.com/adilsongomes79/DOSLib-Community/releases/tag/v9.1.2-brx27.1).
2. Extract it to a folder you control. Check the included SHA-256 file if desired.
3. In **BricsCAD V27 with BRX support**, run `APPLOAD` and select `DOSLib27x64.brx`.
4. Run `(dos_version)`; the expected result is `(9 1 2)`.
5. Test the functions your application uses, including cancellation and file
   handling, before adopting the build in production.

If no release assets are available yet, build from source. This fork currently
targets Windows x64; this binary is not for AutoCAD, ZWCAD or a different BricsCAD
major version. Do not load multiple DOSLib builds into the same CAD session.

## Building from source

Install **Visual Studio 2022 or Build Tools 2022**, **MSVC v143 x64/x86**,
**ATL**, **MFC** and a Windows SDK. Obtain the **BRX SDK V27** separately from
[BricsCAD developer resources](https://bricscad.octave.com/developer-resources).

The BRX manual specifies Windows SDK 10.0.19041.0. The local successful build used
**BRX SDK 27.1.05.0**, **MSVC 14.44.35207** and **Windows SDK 10.0.26100.0**.
The build script can select an installed SDK; see the [build guide](BRX27_IDCAD.md).

From the repository root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\build_brx27.ps1
```

`-ExecutionPolicy Bypass` applies only to that PowerShell process; it does not
change the permanent Windows execution policy. SDKs and installers are not
included in this repository. Output: `bin/Release/brx/DOSLib27x64.brx`.

## Contributing

Bug reports, compatibility tests, focused fixes and documentation are welcome
in **English or Portuguese**. Please include the CAD version, exact function,
minimal reproduction and actual result. See [CONTRIBUTING.md](CONTRIBUTING.md).

The original [README](docs/UPSTREAM_README.md), [wiki](https://github.com/dalefugier/DOSLib/wiki)
and [project history](https://github.com/dalefugier/DOSLib) remain useful references.
This fork inherits other CAD configurations but does not claim to have validated them.

## License and credits

[MIT License](LICENSE). Original copyright (c) 1992-2026 Robert McNeel & Associates
is preserved. DOSLib is a trademark of Robert McNeel & Associates.
Community changes are distributed under the same license. Third-party SDKs and
Microsoft tooling remain subject to their own licenses.
