# GitHub Pages 托管说明（隐私政策 / 用户协议 / 技术支持）

> 静态页面已放在本仓库根目录 `docs/`，推送并启用 Pages 即可。

## ⚠️ 本轮修正

原来的三个链接指向 `https://botonwa83-byte.github.io/engapex/`，该站点并不存在（返回 404），会导致审核直接打不开隐私政策。现已统一：

| 用途 | 新链接 |
|------|--------|
| 隐私政策 | `https://botonwa83-byte.github.io/EngTop/privacy.html` |
| 用户协议 | `https://botonwa83-byte.github.io/EngTop/terms.html` |
| 技术支持 | `https://botonwa83-byte.github.io/EngTop/support.html` |
| 首页 | `https://botonwa83-byte.github.io/EngTop/` |

## 仓库与文件

- 仓库：`botonwa83-byte/EngTop`

```text
docs/
├── index.html      首页（汇总三个链接）
├── privacy.html    隐私政策（ASC 必填 URL）
├── terms.html      用户协议（EULA）
└── support.html    技术支持（ASC 支持网址）
```

## 启用步骤

1. 提交并推送：

```sh
cd /Users/fengwang/Documents/trae_projects/EngTop
git add docs
git commit -m "docs: rewrite EngTop launch policy pages"
git push
```

2. 打开 GitHub 仓库 → Settings → Pages：

- Source 选 `Deploy from a branch`
- Branch 选 `main`
- 目录选 `/docs`
- 保存后等待 1–2 分钟

3. 用 curl 或浏览器确认三个链接返回 200 再提交审核：

```sh
curl -I https://botonwa83-byte.github.io/EngTop/privacy.html
```

## App 内对应位置

- `EngTopApp/Core/Engine/EngLegal.swift` → `EngLegal.termsURL / privacyURL / supportURL`
- 付费墙底部（`PaywallView`）与「更多」页「关于与协议」（`MoreView`）共用 `EngLegalLinksView`

## 备注

- GitHub 免费账户通常要求仓库 Public 才能使用 Pages。
- 也可改用 Cloudflare Pages / Vercel 等任意静态托管，只需同步替换 App 内 URL。
- 页面为纯静态、自适应，无需构建。
