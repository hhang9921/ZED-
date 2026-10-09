# 在另一台 Windows 电脑上使用

此版本支持 Windows x64，不提供 ARM64、Linux 或 macOS 汉化包。

## 下载和启动

1. 从 <https://github.com/hhang9921/ZED-/releases> 下载 `windows-x64.zip`。
2. 同时下载 `SHA256SUMS.txt`，使用下面的命令检查 ZIP 的 SHA256，并与文件中的对应行比较。
3. 完整解压，再双击 `Launch.cmd`。

```powershell
Get-FileHash ./zed-zh-CN-v1.23.2-zh-CN.1-windows-x64.zip -Algorithm SHA256
```

解压后的目录包含 `bin/zed.exe`、`bin/cli.exe`、`bin/conpty.dll`、`bin/OpenConsole.exe`、启动脚本、版本信息及许可证。不能删掉配套终端组件，也不能只复制主程序。

可以把解压目录放在其他盘符或带空格的目录中。配置保存在 `%LOCALAPPDATA%\Zed-zh-CN`，与官方版分离。

## 迁移自己的设置

如果只需要相同主题、字体和快捷键，先关闭汉化版，然后从旧电脑复制自己的 `config/settings.json`、`config/keymap.json` 到新电脑同名配置目录。没有这些文件时可以跳过。

保持 `settings.json` 中 `"auto_update": false`。不要把个人设置、账号令牌或聊天数据库上传到公开 GitHub 仓库。便携包本身不包含维护者的配置。

WSL 发行版、Python 虚拟环境和项目依赖需要在新电脑上重新准备；复制 Windows 编辑器不会迁移它们。Linux 虚拟环境通常应在目标电脑重新创建，不宜直接跨机器复制。

## 更新与回滚

关闭汉化版，解压新的 Release 到一个新目录，再用新的 `Launch.cmd` 启动。配置目录保持相同。

回滚时关闭汉化版，继续打开原来的官方 Zed。汉化版不会覆盖官方安装。

## 当前限制

这是菜单及部分标题栏汉化。设置页和命令面板等仍有英文；没有可在设置中切换的语言开关。

源码构建没有代码签名。遇到系统安全提示时，先核对下载来源和校验和，不要关闭系统安全功能。
