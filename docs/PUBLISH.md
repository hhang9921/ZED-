# 发布到 GitHub

目标仓库：<https://github.com/hhang9921/ZED->。

## Git 仓库内容

提交 README、文档、固定版本清单、中文词表、补丁、脚本、工作流和许可证。

不提交 `source`、编译产物、安装程序、个人配置、完整日志、账号凭据或 `.cargo` 缓存。GitHub 普通仓库阻止超过 100 MiB 的文件；大型二进制使用 Releases。

```powershell
git status --short
git add README.md NOTICE.md LICENSE CHANGELOG.md CONTRIBUTING.md SECURITY.md `
  .gitignore .gitattributes .github zed-version.json docs scripts portable locales patches licenses
git commit -m "Add Windows Simplified Chinese patch and portable build documentation"
git push -u origin main
```

第一次创建仓库时，先配置你自己的 Git 提交身份；不要使用维护者的个人身份代替你。

## Release 附件

先运行构建、校验和打包脚本，然后在 GitHub 的 Releases 页面创建实验性预发行版 `v1.23.2-zh-CN.1`，上传：

- Windows x64 便携 ZIP。
- 同一构建对应的完整源码 TAR.GZ。
- `SHA256SUMS.txt`。

发布说明使用 `.github/RELEASE_NOTES.md`，并明确部分汉化和验证范围。GitHub 自动生成的仓库源码 ZIP 只包含补丁项目，**不能替代完整的修改后 Zed 源码附件**。

如果安装了 GitHub CLI，可用：

```powershell
gh auth login
gh release create v1.23.2-zh-CN.1 `
  ./dist/zed-zh-CN-v1.23.2-zh-CN.1-windows-x64.zip `
  ./dist/zed-zh-CN-v1.23.2-zh-CN.1-source.tar.gz `
  ./dist/SHA256SUMS.txt `
  --repo hhang9921/ZED- --target main --prerelease `
  --title "Zed 1.23.2 简体中文菜单实验版" `
  --notes-file .github/RELEASE_NOTES.md
```

没有 GitHub CLI 时，可在网页上传这些附件。不要把访问令牌写进脚本、仓库 URL 或文档。

## 可选自动检查

`docs/github-actions-validation.yml` 是 GitHub Actions 模板。将它复制到 `.github/workflows/validate.yml` 并提交后，可自动检查脚本语法和文档链接。当前发布凭据没有 `workflow` 权限，因此首次发布保留模板，不启用工作流；本地检查已经运行。

## 更新上游

1. 阅读新的官方版本变更。
2. 更新 `zed-version.json` 的版本、完整提交和 Rust 工具链。
3. 在干净的新源码目录迁移补丁，逐项检查动作标识、Windows 实例和 CLI 的一致性。
4. 验证菜单、终端、Python、WSL、插件和启动；更新验证记录。
5. 生成新的补丁、二进制、对应源码和校验和，再创建新的 Release。

参考：[大文件限制](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github)、[Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)。
