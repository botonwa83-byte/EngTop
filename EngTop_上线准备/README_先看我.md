# EngTop 上线准备包

生成于 2026-09-17，对应版本 1.0.0(1)，Bundle ID `com.engtopapp.app`。

> 隐私政策 / 用户协议 / 技术支持正文统一放在仓库根目录 `docs/`（`docs/index.html`、`docs/privacy.html`、`docs/terms.html`、`docs/support.html`）。

## 文件导览

| 文件 | 用途 |
|------|------|
| `00_上线总检查清单.md` | 从这里开始：阻断项、后台待办、已验证项 |
| `01_App Store商品信息.md` | 名称、副标题、关键词、描述、更新说明，可直接复制 |
| `04_App隐私问卷答案.md` | App Privacy 问卷答案，结论：不收集数据 |
| `05_审核备注_ReviewNotes.md` | 审核备注，中英双语，含内购测试路径 |
| `06_内购配置_IAP.md` | ASC 内购参数，产品 ID 与代码一致性核对 |
| `07_年龄分级问卷.md` | 年龄分级逐项答案，建议 4+ |
| `08_截图与素材清单.md` | 截图尺寸、建议取景、内购截图要求 |
| `09_GitHub_Pages_托管说明.md` | privacy / terms / support 静态页托管说明 |

## 本轮整改已完成的工程项

- **品牌统一**：内购产品 ID `com.engapex.app.full_unlock` → `com.engtopapp.app.full_unlock`（与 bundle id 前缀一致，否则 ASC 无法关联商品）；storekit 参考名、`PromoView` 的「ENG APEX」、注释中的 EngApex 残留全部改为 EngTop。
- **Pages 链接修正**：原 `.../engapex/` 站点并不存在（404），已统一为 `https://botonwa83-byte.github.io/EngTop/`；`docs/` 四个页面按 EngTop 品牌重写。
- **协议入口补齐**：新增 `EngLegal.swift` + `EngLegalLinksView`，付费墙底部与「更多」页「关于与协议」均可点击。
- **隐私清单**：新增 `EngTopApp/Resources/PrivacyInfo.xcprivacy`（UserDefaults / CA92.1）。
- **免费档单测**：新增 `PurchasePolicyTests`（产品 ID 一致性、前 3 关 isFree 标记、免费关不被锁）。

## 提交前仍需人工完成

1. ASC 创建内购 `com.engtopapp.app.full_unlock`（¥22，随版本提交）。
2. 推送仓库后启用 Pages（`main /docs`），验证三个 URL 可访问（旧的 engapex 链接是死链）。
3. 补齐 iPhone 6.9" 与 iPad 13" 截图。
4. 实机走一遍内购：购买 / 恢复 / 取消 / 删除重装恢复。
