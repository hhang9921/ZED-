# WSL 和 Python 环境

编辑器界面运行在 Windows；通过 Zed 的 WSL 项目模式，让语言服务器、终端和任务在 Linux 中运行。

## 图形界面打开

在汉化版按 `Ctrl+Shift+P`，查找 `projects: open folder in wsl`，选择发行版和项目。命令面板目前仍使用英文。

不要仅把终端设置为 `wsl.exe`，这不会自动把 Python 语言服务器也迁移到 WSL。

## 使用便携包中的 CLI

在解压目录运行，替换实际发行版和 Linux 项目路径：

```powershell
./bin/cli.exe --zed "$PWD/bin/zed.exe" `
  --user-data-dir "$env:LOCALAPPDATA/Zed-zh-CN" `
  --wsl Ubuntu-24.04 -n /mnt/e/code/your-project
```

目录名称包含空格时保留引号。上述 `/mnt/e` 对应 Windows 的 E 盘；新电脑的盘符和路径可能不同。

## Python 工具链

打开 WSL 项目后，在工具链选择器中选择该项目的 Linux 解释器，例如 `venv/bin/python` 或 `.venv/bin/python`。多服务项目应分别选择各自的虚拟环境。

Windows Python 不能直接使用 WSL 的 Linux 虚拟环境。Windows 上安装 Python 不会影响正确选择的 WSL 工具链。

本项目不为你的业务项目安装 Python 依赖，也不附带维护者的 WSL 配置。

参考：[Zed WSL 支持](https://zed.dev/docs/remote-development)、[Python 工具链](https://zed.dev/docs/languages/python)。
