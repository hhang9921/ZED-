# Windows 源码构建

## 依赖

- Windows x64。
- Git for Windows。
- PowerShell 7.2 或更高版本，使用 `pwsh` 运行本项目脚本。
- Rustup 和 Rust `1.98.1` 的 MSVC 工具链。
- Visual Studio 2022 Build Tools 或 Visual Studio，包含“使用 C++ 的桌面开发”。
- x64/x86 MSVC 编译工具和对应的 C++ Spectre 缓解库。
- Windows SDK；本次验证使用 `10.0.26100`。
- Visual Studio 的 C++ CMake 工具。

参考上游的 [Windows 构建说明](https://zed.dev/docs/development/windows)。需要联网下载官方源码、Cargo 依赖和 Microsoft ConPTY 组件。

## 构建

```powershell
git clone https://github.com/hhang9921/ZED-.git
cd ZED-
rustup toolchain install 1.98.1 --profile minimal
pwsh -File ./scripts/Prepare-Source.ps1
pwsh -File ./scripts/Build-Windows.ps1
```

在本机指定自定义编译工具目录的例子：

```powershell
pwsh -File ./scripts/Build-Windows.ps1 -BuildToolsPath E:/tools/VSBuildTools -Jobs 8
```

`Build-Windows.ps1` 自动执行源码准备；因此不必每次手动运行 `Prepare-Source.ps1`。脚本使用锁定的 Cargo.lock，构建 `zed.exe` 和 `cli.exe`，然后补齐 x64 终端组件。

产物位于 `source/zed/target/release-fast`，日志位于 `build-logs/build-windows.log`。如果内存紧张，可以降低 `-Jobs`。不要把本机首次构建的约 20 分钟视为其他电脑的时间保证。

## 编辑中文词表

修改 `locales/zh-CN.yml`，保留 `_version: 1` 和占位符，然后重新运行构建。源码准备脚本会将它复制到 `crates/title_bar/locales/zh-CN.yml`。

新增词条不会自动汉化任意界面。对应代码必须调用翻译入口，且原文字键必须一致。当前补丁只接入了菜单和部分标题栏文字。

直接修改 `source/zed` 中的 Rust 代码后，先审阅变更，再更新补丁。不要对有未保存修改的源码目录执行强制重置。

## 打包

```powershell
pwsh -File ./scripts/Package-Windows.ps1
```

生成 `dist` 中的 Windows 便携 ZIP、完整修改后源码 TAR.GZ，以及 `SHA256SUMS.txt`。源码包排除 `.git` 和 `target`，保留源码、Cargo.lock、资产、许可证和上游构建脚本。

对已有构建产物打包时，可以指定目录：

```powershell
pwsh -File ./scripts/Package-Windows.ps1 -BuildDirectory C:/path/to/target/release-fast
```

指定的产物必须来自同一固定源码和补丁；不要将官方二进制冒充补丁构建。

## 排查

| 问题 | 处理 |
| --- | --- |
| 找不到 C++ 工具或 SDK | 在 Visual Studio Installer 中补齐上述组件，或指定 `-BuildToolsPath` |
| 找不到 Cargo | 安装 Rustup，确认 `.cargo/bin` 可用 |
| Git 路径过长 | 先使用较短源码路径；确需修改系统长路径设置时按上游文档处理 |
| 补丁不能应用 | 核对源码提交和本地修改；脚本不会强制覆盖已有源码 |
| ConPTY 下载或解压失败 | 用 PowerShell 7 单独运行 `Get-ConPty.ps1 -Destination ./source/zed/target/release-fast` |
| 翻译不生效 | 确认启动的是汉化包，且对应界面在当前翻译范围内 |

本项目不自动安装编译依赖，也不修改系统安全设置或全局 PATH。

构建完成后，脚本会运行上游 `script/generate-licenses.ps1`，按需安装 `cargo-about 0.8.2` 并生成 `licenses/DEPENDENCIES.md`。该步骤也需要网络；许可证生成失败时应先解决错误，再打包公开发布。
