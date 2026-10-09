# 上游与第三方说明

本项目是在 Zed 官方 v1.23.2 源码上添加的非官方中文补丁，不由 Zed Industries 发布、认证或维护。

## Zed

- 上游：<https://github.com/zed-industries/zed>
- 固定提交：`c0199504b9cce79bc27524950022ed701bc3ebd5`
- 修改：`rust-i18n` 菜单及部分标题栏翻译；Windows 应用和 CLI 使用独立 `zh-CN` 实例标识。
- Zed 应用的 GPL-3.0-or-later 和相关 Apache-2.0 组件保留其原有许可。上游各文件和 crate 的许可仍适用。
- 许可证副本在 `licenses` 和完整源码包中。

## rust-i18n

- 上游：<https://github.com/longbridge/rust-i18n>
- 版本：4.2.0，许可文本见 `licenses/rust-i18n-MIT.txt`。
- 原文键缺失时保持原文字；没有借用其他社区汉化项目的翻译或补丁。

## Windows 终端组件

- ConPTY / OpenConsole 来自 Microsoft Terminal 的官方组件包。
- 来源及固定下载 URL 记录在 `zed-version.json`。
- 保留 Microsoft Terminal 许可文本。

## 分发

本项目脚本和补丁采用 GPL-3.0-or-later。分发实验性二进制时，同时附上同一版本的完整修改后源码、构建步骤、版本清单和许可证；不要仅提供二进制或只提供本仓库的补丁源码。

Zed 名称和商标属于相应权利人；此项目不代表官方发布。
