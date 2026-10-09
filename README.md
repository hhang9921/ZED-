# Zed Windows 简体中文补丁

为 Windows x64 版 Zed 接入 `rust-i18n`，提供菜单及部分标题栏的简体中文翻译。

这是基于官方源码构建的**非官方、实验性版本**，与 Zed Industries 无隶属关系。当前不是完整汉化：设置页面、命令面板及其他功能模块仍有英文。

[下载 Releases](https://github.com/hhang9921/ZED-/releases) · [换电脑使用](docs/PORTABLE.md) · [源码构建](docs/BUILD.md) · [GitHub 发布](docs/PUBLISH.md) · [已知限制](docs/LIMITATIONS.md)

## 下载后使用

1. 在 Releases 下载名称含 `windows-x64.zip` 的便携包，同时下载 `SHA256SUMS.txt`。
2. 完整解压 ZIP，不要只取出 `zed.exe`。
3. 双击解压目录中的 `Launch.cmd`。

便携包无需安装 Rust 或 Visual Studio。语言已编译为简体中文，官方 Zed 的 `settings.json` 不能直接加载此翻译文件。

配置和扩展保存在 `%LOCALAPPDATA%\Zed-zh-CN`；首次启动只生成 `{"auto_update": false}`，不附带维护者的账号、项目或编辑器配置。此版本使用独立 Windows 实例标识，可与官方 Zed 同时运行。

## 当前版本

| 项目 | 固定值 |
| --- | --- |
| 补丁版本 | `v1.23.2-zh-CN.1` |
| 官方源码版本 | `v1.23.2` |
| 官方提交 | `c0199504b9cce79bc27524950022ed701bc3ebd5` |
| Rust | `1.98.1` |
| rust-i18n | `4.2.0`，通过 Cargo.lock 固定 |
| 平台 | Windows x64 / `x86_64-pc-windows-msvc` |
| 翻译范围 | 主菜单、子菜单、部分标题栏按钮和提示 |

构建配置以 [`zed-version.json`](zed-version.json) 为准。此版本关闭自动更新，后续更新请下载本仓库新的 Release。

## 从源码构建

安装 Git for Windows、PowerShell 7、Rust，以及包含 C++ 编译工具、Spectre 库、Windows SDK 和 CMake 的 Visual Studio Build Tools。

```powershell
git clone https://github.com/hhang9921/ZED-.git
cd ZED-
rustup toolchain install 1.98.1 --profile minimal
pwsh -File ./scripts/Build-Windows.ps1
pwsh -File ./scripts/Package-Windows.ps1
```

脚本会下载固定版本的官方源码，核对提交，再应用补丁。已有源码不会被强制重置。编译工具自动通过 `vswhere` 查找，也可以使用 `-BuildToolsPath` 指定路径。

详细步骤和故障排查见 [BUILD.md](docs/BUILD.md)。Python 和 WSL 的使用见 [WSL.md](docs/WSL.md)。

## 项目结构

```text
.
├── README.md                 # 项目介绍
├── zed-version.json          # 固定版本及构建参数
├── locales/zh-CN.yml         # 可编辑的中文词表
├── patches/zed-zh-CN.patch   # 对官方源码的完整修改
├── scripts/                 # 准备源码、构建、打包、校验
├── portable/Launch.cmd      # 便携包启动入口
├── docs/                    # 使用、构建、发布和限制文档
├── licenses/                # 保留的第三方许可文本
├── source/zed/              # 本地源码，自动下载，不提交到 Git
├── original-files/          # 本地原始文件快照，不提交到 Git
└── dist/                    # 二进制包、源码包及校验和，不提交到 Git
```

`source/`、`original-files/`、`dist/` 已被 `.gitignore` 排除。其他电脑克隆仓库后，可以通过脚本恢复源码。分发二进制时，同时提供对应的完整源码包。

## 验证状态

2026-10-09 已完成 Windows 源码构建、翻译函数测试、程序启动和 Ubuntu-24.04 WSL 项目打开。首次构建约 20 分钟，其他电脑的耗时会不同。

自动截图工具超时，未完成中文菜单的视觉验收；程序的性能、所有菜单动作和其他 Windows 配置尚未全面回归。完整记录见 [VERIFICATION.md](docs/VERIFICATION.md)。

## 贡献与许可

欢迎修正翻译或报告问题，请先阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。

本项目补丁与脚本采用 GPL-3.0-or-later；上游 Zed、GPUI、Rust 依赖及终端组件保留各自许可。见 [LICENSE](LICENSE) 和 [NOTICE.md](NOTICE.md)。Zed 名称及商标归其权利人所有。
