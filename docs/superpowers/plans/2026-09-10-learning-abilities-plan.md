# 学习能力训练营 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在现有英语题库 App 中加入能力训练营、成长档案和真实情境任务，让学生看到并练习英语之外的信息提取、推理、迁移、表达、规划和反思能力。

**Architecture:** 新增独立的 `LearningAbility`、`LearningMission` 内容目录和 `LearningProgressStore` 离线进度层。训练营页面读取静态任务目录和进度存储，完成任务时通过现有 `EngStore` 映射到英语能力并增加 XP；驾驶舱只增加入口和成长摘要，不改变已有算法引擎。

**Tech Stack:** Swift 5, SwiftUI, iOS 16, XCTest, UserDefaults, XcodeGen.

**Spec:** `docs/superpowers/specs/2026-09-10-learning-abilities-design.md`

## Global Constraints

- 保留现有 `Ability` 枚举和四 Tab 信息架构。
- 不引入网络服务或第三方依赖。
- 任务判定使用结构化选择和学生自评，不声称 AI 自动批改开放表达。
- 内容必须覆盖小学、初一、初二和初三。
- 生产代码先有失败测试，再实现。

### Task 1: 内容模型与成长引擎

**Files:**
- Create: `EngTopApp/Core/Models/LearningMission.swift`
- Create: `EngTopApp/Core/Engine/LearningProgressStore.swift`
- Test: `EngTopAppTests/LearningAbilityTests.swift`

**Interfaces:**
- `LearningAbility: String, CaseIterable, Identifiable, Codable`
- `LearningMission: Identifiable`
- `LearningMissionCatalog.all: [LearningMission]`
- `LearningMissionStat`
- `LearningProgressEngine.score(for:)`
- `LearningProgressStore.record(_:correct:transferCompleted:reflectionCompleted:)`
- `LearningProgressStore.recommendedMission`

- [x] **Step 1: Write the failing tests** in `LearningAbilityTests.swift` for content coverage, score calculation, and recommendation.
- [x] **Step 2: Run the focused test target** and verify the new test is compiled and fails because the new model is missing.
- [x] **Step 3: Add the model, catalog, scoring engine, and UserDefaults store** with 12+ concrete missions.
- [x] **Step 4: Run the focused test target** and verify all new tests pass.

### Task 2: Training-camp screens

**Files:**
- Create: `EngTopApp/Features/Learning/LearningGymView.swift`
- Modify: `EngTopApp/App/EngTopApp.swift`
- Modify: `EngTopApp/Features/More/MoreView.swift`

**Interfaces:**
- `LearningGymView`
- `LearningMissionView`

- [x] **Step 1: Add the training-camp list** with ability summary, stage filter, recommendation and mission cards.
- [x] **Step 2: Add the mission detail flow** with answer state, explanation, transfer text entry and reflection confirmation.
- [x] **Step 3: Connect the page to `MoreView` and keep the existing four-tab layout.**
- [x] **Step 4: Build the app target** to catch SwiftUI and project-file errors.

### Task 3: Dashboard integration

**Files:**
- Modify: `EngTopApp/Features/Dashboard/DashboardView.swift`

- [x] **Step 1: Add a “今日能力任务” card** that opens the recommended mission.
- [x] **Step 2: Add a compact “学习能力成长” summary** with six progress bars and completed-task count.
- [x] **Step 3: Run all unit tests and build the app target.**

### Task 4: Verification

**Files:**
- No additional source files.

- [x] **Step 1: Run the complete XCTest suite on the available iOS simulator.**
- [x] **Step 2: Run `git diff --check` and inspect the changed-file summary.**
- [x] **Step 3: Report exact test and build results, including any pre-existing warnings.**

## 进度记录（2026-09-10 完成本阶段）

**验证结果**

- `xcodebuild -scheme EngTopApp ... build` → BUILD SUCCEEDED
- `xcodebuild -scheme EngTopApp ... test`（iPhone 17 模拟器）→ 66 tests, 0 failures
  - AbilityEngineTests 2 / KnowledgeCatalogTests 11 / LearningAbilityTests 3 / ScoreEngineTests 50
- 遗留警告（非本次引入）：`MockEngine.swift:76` `var quotas` 未发生变异，建议改 `let`。

**本阶段交付**

- 能力训练营：`LearningMission`（16 个任务，覆盖 4 个学段 × 6 项学习能力，每项能力 ≥2 个任务）、
  `LearningProgressStore`（离线进度 + 成长值 `正确率×70 + 迁移×20 + 反思×10`）、
  `LearningGymView` / `LearningMissionView`（情境 → 作答 → 解析 → 迁移 → 反思 → 记录）。
- 驾驶舱新增「今日能力任务」入口与六维学习能力成长摘要；`MoreView` 新增能力训练营入口，四 Tab 结构未变。
- 补齐一个更早中断的收尾：知识点专项练习固定每点 20 题，分两批（每批 10 题）。

**同时修复的中断点（非本计划范围，但阻塞验证）**

- `KnowledgePracticeFactory` 此前只返回策展题（每点 0–5 题），而测试与练习页批量逻辑都已按「每点 20 题、每批 10 题」写好。
  现改为：人工策展题优先 + `KnowledgePracticeGenerator` 从知识点自身的规则摘要、示例、能力、学段派生巩固题补齐到 20 题。
  派生题不臆造真题出处，干扰项取自同阶段其它知识点的真实内容；145 个知识点 × 20 = 2900 题，答案位置分布均衡（750/751/722/677）。
- `QuestionBank.generatedSimulation`（30 道）已移除：选项恒为 `are/is/be/was` 且答案恒为 `are`，多数题干答案错误；
  同时把语法填空塞进 L2（完形关卡）并打乱 6 套模考的模块配比，导致 `testEveryLevelHasQuestions` 与
  `testFixedPapersAreDeterministicAndBalanced` 失败。修正后两项测试恢复通过。

**下一阶段待办（明天）**

1. 重新设计「仿真题批次」：若确需每批 30 道的成组练习，需要为每道题单独写正确选项与答案，并按模块归属levelId，不能套用同一组选项。
2. 知识点专项练习的人工题库扩充：当前每点 5 道策展题以内，其余为派生巩固题；按 `docs/KNOWLEDGE_EXPANSION_PLAN.md` 继续分批补真策展题。
3. `Question.source` 字段目前无生产者、也无 UI 展示：要么接上「来源」展示（注意不臆造年份/卷型），要么删除。
