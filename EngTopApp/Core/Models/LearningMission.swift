import Foundation

/// 通用学习能力，与英语专项能力分开，避免把“会英语”和“会学习”混成一个分数。
enum LearningAbility: String, CaseIterable, Identifiable, Codable {
    case information
    case reasoning
    case transfer
    case expression
    case planning
    case reflection

    var id: String { rawValue }

    var title: String {
        switch self {
        case .information: return "信息提取"
        case .reasoning: return "逻辑推理"
        case .transfer: return "迁移应用"
        case .expression: return "表达组织"
        case .planning: return "学习规划"
        case .reflection: return "反思纠错"
        }
    }

    var subtitle: String {
        switch self {
        case .information: return "找到真正重要的信息"
        case .reasoning: return "用证据想清楚为什么"
        case .transfer: return "把学过的内容用到新场景"
        case .expression: return "把想法说清楚、写完整"
        case .planning: return "把目标拆成可执行步骤"
        case .reflection: return "知道错在哪里、下一步练什么"
        }
    }

    var systemImage: String {
        switch self {
        case .information: return "text.magnifyingglass"
        case .reasoning: return "arrow.triangle.branch"
        case .transfer: return "arrow.triangle.2.circlepath"
        case .expression: return "text.bubble"
        case .planning: return "calendar.badge.clock"
        case .reflection: return "person.crop.circle.badge.questionmark"
        }
    }

    /// 完成能力任务时，映射到现有英语能力以复用 XP 和每日计划。
    var linkedLanguageAbility: Ability {
        switch self {
        case .information, .reasoning, .reflection: return .reading
        case .transfer, .expression, .planning: return .expression
        }
    }
}

enum LearningMissionKind: String, CaseIterable, Codable, Identifiable {
    case observe
    case infer
    case apply
    case organize
    case plan
    case reflect

    var id: String { rawValue }

    var title: String {
        switch self {
        case .observe: return "看懂信息"
        case .infer: return "找出依据"
        case .apply: return "换个场景使用"
        case .organize: return "组织表达"
        case .plan: return "拆解计划"
        case .reflect: return "复盘改进"
        }
    }
}

struct LearningMission: Identifiable, Codable, Equatable {
    let id: String
    let stage: StudyStage
    let ability: LearningAbility
    let kind: LearningMissionKind
    let title: String
    let subtitle: String
    let context: String
    let prompt: String
    let options: [String]
    let answer: Int
    let explanation: String
    let transferPrompt: String
    let reflectionPrompt: String
}

enum LearningMissionCatalog {
    static let all: [LearningMission] = [
        mission("primary-information", .primary, .information, .observe,
                "读懂活动安排", "从通知中找出关键时间",
                "English Club meets on Tuesday at 3:30 p.m. in Room 204. Please bring a notebook.",
                "When does English Club meet?",
                ["Tuesday at 3:00 p.m.", "Tuesday at 3:30 p.m.", "Thursday at 3:30 p.m.", "Thursday at 4:00 p.m."], 1,
                "先找表示日期和时间的词，再把 Tuesday 与 3:30 p.m. 配对。",
                "把活动换成你的课外班，并用英语说出日期、时间和地点。",
                "我能指出题干中的日期、时间和地点。"),
        mission("primary-reasoning", .primary, .reasoning, .infer,
                "从线索做判断", "用两条线索推断人物计划",
                "The weather report says it will be sunny and hot. Ben packs a hat and a bottle of water before leaving home.",
                "What can we infer about Ben?",
                ["He is going to sleep.", "He is preparing for an outdoor activity.", "He forgot his school bag.", "He does not like water."], 1,
                "天气炎热、帽子和水瓶共同指向户外活动，这是由多条线索得出的合理推断。",
                "观察今天的天气，为一次户外活动写出两件需要准备的物品。",
                "我能说出支持判断的两条线索。"),
        mission("primary-transfer", .primary, .transfer, .apply,
                "把句型用到生活里", "把学过的请求句迁移到借文具",
                "You have learned “Can I ...?” and “please”. A classmate has the pencil you need.",
                "Which sentence is the most polite?",
                ["Give me your pencil.", "Can I borrow your pencil, please?", "Your pencil is blue.", "I have a pencil."], 1,
                "请求别人帮忙时，需要使用 Can I ...? 并加 please 表示礼貌。",
                "把 pencil 换成 ruler、book 或 eraser，再说出一个新请求。",
                "我能在新物品和新人物中正确替换词语。"),
        mission("primary-expression", .primary, .expression, .organize,
                "介绍一个熟悉的人", "选择完整的自我介绍开头",
                "You are meeting a new friend at school. You want to introduce yourself clearly.",
                "Which is the best opening?",
                ["My name is Lily. I am in Class 4.", "Lily school happy.", "Class 4 is my name.", "I like because Lily."], 0,
                "清楚的介绍先说姓名，再补充班级等信息，句子需要有完整的主语和谓语。",
                "继续补充两句：你的兴趣和一个你擅长的事情。",
                "我能把人物、班级和兴趣按顺序说清楚。"),

        mission("junior1-information", .juniorOne, .information, .observe,
                "读懂校园通知", "从通知中提取行动要求",
                "Notice: The school library will close at 5 p.m. on Friday. Students should return books before Thursday.",
                "What should students do before Thursday?",
                ["Join a sports club.", "Return their library books.", "Stay in the library until 5 p.m.", "Bring books to class on Friday."], 1,
                "题目问的是行动要求，should return books 是直接信息，时间词 before Thursday 说明截止时间。",
                "把 library books 换成 homework，写出一个你本周需要完成的截止任务。",
                "我能区分通知中的时间、地点和行动要求。"),
        mission("junior1-reasoning", .juniorOne, .reasoning, .infer,
                "分辨原因和结果", "用连接词判断逻辑关系",
                "Lucy took an umbrella because dark clouds covered the sky. Ten minutes later, it began to rain.",
                "Why did Lucy take an umbrella?",
                ["Because she wanted to play tennis.", "Because she saw signs of rain.", "Because the umbrella was new.", "Because she was going to school yesterday."], 1,
                "because 后面给出原因，dark clouds 是将要下雨的证据；后一句是结果。",
                "用 because 说出一次你提前准备物品的原因。",
                "我能用 because 或 so 解释一件事的原因和结果。"),
        mission("junior1-planning", .juniorOne, .planning, .plan,
                "安排一晚学习时间", "把大目标拆成可执行步骤",
                "You have 60 minutes tonight: review 10 words, finish a reading passage, and check tomorrow’s schoolbag.",
                "Which plan is the most workable?",
                ["Do everything at the same time.", "Review words 15 minutes, read 35 minutes, check the bag 10 minutes.", "Read for 60 minutes and skip the other tasks.", "Wait until bedtime and choose randomly."], 1,
                "好计划要把目标分成有顺序、有时长的步骤，还要留出完成检查的时间。",
                "把今天的英语任务拆成三步，并为每一步写一个时长。",
                "我能把一个大目标拆成三步并安排时间。"),
        mission("junior1-reflection", .juniorOne, .reflection, .reflect,
                "找到错误原因", "从结果回到自己的学习过程",
                "You chose “went” in the sentence “She ___ to the museum every Sunday.” The correct answer is “goes”.",
                "What is the most useful reflection?",
                ["I am just bad at English.", "I ignored every Sunday and did not check the subject.", "The answer was too short.", "I will guess faster next time."], 1,
                "有效反思要指出被忽略的时间标志 every Sunday 和主语 She，并形成下一次的检查动作。",
                "写出你的检查动作：先看什么，再看什么？",
                "我能把错误改写成下一次可以执行的检查步骤。"),

        mission("junior2-information", .juniorTwo, .information, .observe,
                "读懂出行信息", "从时刻表中选择合适班次",
                "Bus 12 leaves at 8:10, 8:40 and 9:20. Your lesson starts at 9:00. The bus ride takes 25 minutes.",
                "Which bus should you take?",
                ["8:10", "8:40", "9:20", "Any bus after 9:00"], 0,
                "8:40 到达约 9:05，可能迟到；8:10 到达约 8:35，能留出缓冲时间。",
                "把 lesson 换成一次约会，写出你会提前多久出发以及为什么。",
                "我会同时考虑出发时间、路程和迟到风险。"),
        mission("junior2-reasoning", .juniorTwo, .reasoning, .infer,
                "观点需要证据", "区分事实、观点和支持证据",
                "Mia says reading before bed helps her sleep. She keeps a notebook: on six nights she read for 15 minutes and fell asleep quickly.",
                "Which sentence is the strongest evidence for Mia’s idea?",
                ["Reading is always fun.", "Her notebook records six nights with the same result.", "Mia has a blue notebook.", "Everyone should read at night."], 1,
                "六次记录属于可核对的观察结果，比“总是”“应该”等没有数据的说法更能支持观点。",
                "为你自己的一个学习观点记录三次事实，再判断它是否得到支持。",
                "我能用具体记录支持一个观点，而不是只说自己的感觉。"),
        mission("junior2-transfer", .juniorTwo, .transfer, .apply,
                "把建议句型迁移到健康情境", "把 should 用在真实问题中",
                "Your friend stays up late and feels tired in class. You have learned “You should ...” for giving advice.",
                "Which advice is the most helpful?",
                ["You should sleep earlier and put your phone away.", "You are a phone.", "Sleep is yesterday.", "I tired because."], 0,
                "建议要针对问题给出可执行动作：早点睡，并把手机放远。",
                "把情境换成“忘记带作业”，写一句 should 建议。",
                "我能把句型换到新问题里，并让建议真正可执行。"),
        mission("junior2-expression", .juniorTwo, .expression, .organize,
                "组织一段观点", "选择有观点、理由和例子的表达",
                "You are answering: Why should students join a school club?",
                "Which answer is best organized?",
                ["Clubs are there.", "I think clubs help students make friends because they work together. For example, a music club can plan a concert.", "Join clubs.", "Friends and music and school."], 1,
                "完整观点通常包含观点、because 引出的理由和 for example 引出的具体例子。",
                "用同样结构回答：Why should students read every day?",
                "我能用“观点 + 理由 + 例子”组织三句话。"),

        mission("junior3-planning", .juniorThree, .planning, .plan,
                "规划一个小项目", "让目标、步骤和检查点互相对应",
                "Your team will make an English poster about saving water in one week.",
                "Which plan is the clearest?",
                ["Wait until the last day.", "Day 1 choose the message, Day 2 collect facts, Day 3 write and design, Day 4 check English, Day 5 share.", "Everyone does the same drawing.", "Only the fastest student works."], 1,
                "清晰项目计划要有阶段、产出和检查点，最后的语言检查能减少表达错误。",
                "为一个“英语阅读分享”项目写出三步计划和一个检查点。",
                "我能让每一步都对应一个明确产出。"),
        mission("junior3-reflection", .juniorThree, .reflection, .reflect,
                "复盘阅读失分", "从错误选项找到策略漏洞",
                "In a reading question, you chose an option because it repeated a word from the passage. The option changed the writer’s meaning.",
                "What should you try next time?",
                ["Choose the option with the most repeated words.", "Check the whole sentence and compare the option with the writer’s attitude.", "Read only the first line.", "Skip every question with a long passage."], 1,
                "阅读不能只看词汇重复，还要核对完整语义、范围和作者态度。",
                "拿一道做错的阅读题，写下“我看到的证据”和“我忽略的限制”。",
                "我能说明一个选项为什么看似正确但实际越界。"),
        mission("junior3-transfer", .juniorThree, .transfer, .apply,
                "把环保表达用到新主题", "迁移 should、because 和 so",
                "You learned: We should save water because it is important. Now write advice for reducing food waste.",
                "Which sentence transfers the structure best?",
                ["We should waste food because it is important.", "We should take only what we need because food is valuable.", "Food was yesterday.", "Important water and food."], 1,
                "迁移时保留句子骨架，再替换主题词和原因；逻辑关系仍要成立。",
                "把主题换成节约纸张，写出一句 should + because 的句子。",
                "我能保留结构，同时让新主题和理由匹配。"),
        mission("junior3-expression", .juniorThree, .expression, .organize,
                "写一封清楚的邮件", "按目的、细节和礼貌结尾组织信息",
                "You need to ask your teacher for one more day to finish a project.",
                "Which email sentence is the clearest opening?",
                ["Give me another day.", "Could I have one more day to finish the project because I need to check the data?", "Project one day teacher.", "I finish maybe."], 1,
                "礼貌邮件先明确请求，再补充原因；Could I ...? 比直接命令更合适。",
                "把 project 换成 homework，并补一句礼貌结尾。",
                "我能在表达目的后补充理由，并保持礼貌语气。")
    ]

    private static func mission(
        _ id: String,
        _ stage: StudyStage,
        _ ability: LearningAbility,
        _ kind: LearningMissionKind,
        _ title: String,
        _ subtitle: String,
        _ context: String,
        _ prompt: String,
        _ options: [String],
        _ answer: Int,
        _ explanation: String,
        _ transferPrompt: String,
        _ reflectionPrompt: String
    ) -> LearningMission {
        LearningMission(
            id: id,
            stage: stage,
            ability: ability,
            kind: kind,
            title: title,
            subtitle: subtitle,
            context: context,
            prompt: prompt,
            options: options,
            answer: answer,
            explanation: explanation,
            transferPrompt: transferPrompt,
            reflectionPrompt: reflectionPrompt
        )
    }
}
