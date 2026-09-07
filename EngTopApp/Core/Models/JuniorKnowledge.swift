import Foundation

enum StudyStage: String, CaseIterable, Identifiable, Codable {
    case primary, juniorOne, juniorTwo, juniorThree
    var id: String { rawValue }
    var title: String {
        switch self { case .primary: return "小学"; case .juniorOne: return "初一"; case .juniorTwo: return "初二"; case .juniorThree: return "初三" }
    }
}

struct JuniorKnowledgePoint: Identifiable, Codable {
    let id: String
    let stage: StudyStage
    let ability: Ability
    let title: String
    let summary: String
    let examples: [String]
}

enum JuniorKnowledgeCatalog {
    static let all: [JuniorKnowledgePoint] = [
        p("p-nouns", .primary, .vocabulary, "名词与复数", "认识人、物、地点，并掌握单复数", ["book / books", "child / children"]),
        p("p-be", .primary, .wordOrder, "be 动词", "am、is、are 和主语的搭配", ["I am happy.", "They are friends."]),
        p("p-have", .primary, .vocabulary, "have 与 has", "表达拥有和日常物品", ["I have a bike.", "She has a cat."]),
        p("p-present", .primary, .tense, "一般现在时", "习惯、事实和日常作息", ["I get up at seven."]),
        p("p-questions", .primary, .wordOrder, "一般疑问句", "用 be 或 do 开启问句", ["Are you ready?", "Do you like milk?"]),
        p("j1-pronouns", .juniorOne, .wordOrder, "人称代词", "主格、宾格与形容词性物主代词", ["She helps me.", "This is my bag."]),
        p("j1-there", .juniorOne, .wordOrder, "There be 句型", "描述某处存在的人或物", ["There is a tree."]),
        p("j1-present-cont", .juniorOne, .tense, "现在进行时", "描述此刻正在发生的动作", ["He is running."]),
        p("j1-past", .juniorOne, .tense, "一般过去时", "讲述已经发生的事情", ["We visited the museum."]),
        p("j1-prep", .juniorOne, .vocabulary, "时间与地点介词", "in、on、at、under、behind 等", ["at school", "on Monday"]),
        p("j2-future", .juniorTwo, .tense, "一般将来时", "计划、预测和即将发生的事", ["I will call you.", "She is going to travel."]),
        p("j2-comparative", .juniorTwo, .expression, "形容词比较级", "比较两个人或事物", ["Tom is taller than me."]),
        p("j2-modal", .juniorTwo, .wordOrder, "情态动词", "can、should、must 等表达能力和建议", ["You should try."]),
        p("j2-infinitive", .juniorTwo, .expression, "动词不定式", "to do 表达目的和计划", ["I want to learn."]),
        p("j2-reading", .juniorTwo, .reading, "阅读线索", "代词指代、连接词和上下文复现", ["However signals a turn."]),
        p("j3-perfect", .juniorThree, .tense, "现在完成时", "经历、结果与持续状态", ["I have finished my work."]),
        p("j3-passive", .juniorThree, .wordOrder, "被动语态", "突出动作承受者", ["The book was written in 2020."]),
        p("j3-object-clause", .juniorThree, .expression, "宾语从句", "把完整句子放进表达中", ["I think that it is useful."]),
        p("j3-relative", .juniorThree, .reading, "定语从句", "用从句补充名词信息", ["The boy who won is my friend."]),
        p("j3-writing", .juniorThree, .expression, "英语写作结构", "开头、展开、结尾与连接词", ["First... Then... Finally..."])
        ,p("p-articles", .primary, .wordOrder, "冠词 a / an / the", "表达一个、特指和泛指", ["a book", "the sun"])
        ,p("p-plurals", .primary, .vocabulary, "不规则复数", "常见名词的特殊复数形式", ["man / men", "foot / feet"])
        ,p("p-can", .primary, .expression, "can 表达能力", "用 can 提问和回答能力", ["Can you swim?"])
        ,p("p-imperative", .primary, .wordOrder, "祈使句", "指令、请求和提醒", ["Open the door, please."])
        ,p("p-wh", .primary, .reading, "特殊疑问词", "who、what、where、when、why、how", ["Where are you?"])
        ,p("j1-count", .juniorOne, .vocabulary, "可数与不可数名词", "数量表达与量词搭配", ["two apples", "some water"])
        ,p("j1-frequency", .juniorOne, .tense, "频率副词", "always、usually、sometimes、never 的位置", ["I usually walk to school."])
        ,p("j1-adverbs", .juniorOne, .expression, "副词用法", "用副词说明动作方式和程度", ["She speaks slowly."])
        ,p("j1-connectors", .juniorOne, .reading, "并列连词", "and、but、or、so、because 的逻辑", ["I stayed home because it rained."])
        ,p("j1-prepositions", .juniorOne, .vocabulary, "动词与介词搭配", "look at、listen to、wait for 等词块", ["listen to music"])
        ,p("j2-gerund", .juniorTwo, .expression, "动名词", "动词 ing 作主语或宾语", ["Reading is fun."])
        ,p("j2-advice", .juniorTwo, .expression, "提建议的句型", "Why not、Let us、How about 等", ["Why not take a break?"])
        ,p("j2-object", .juniorTwo, .wordOrder, "双宾语", "人和物两个宾语的语序", ["She gave me a gift."])
        ,p("j2-conditional", .juniorTwo, .reading, "条件句", "if 引导的真实条件", ["If it rains, we will stay home."])
        ,p("j2-passages", .juniorTwo, .reading, "段落主旨", "从首句、重复词和结尾概括中心", ["The main idea is..."])
        ,p("j3-adverbial", .juniorThree, .reading, "状语从句", "时间、原因、条件和让步关系", ["Although it was late, he kept reading."])
        ,p("j3-indirect", .juniorThree, .expression, "宾语从句时态", "陈述语序与时态呼应", ["She asked where I lived."])
        ,p("j3-tag", .juniorThree, .wordOrder, "反意疑问句", "肯定陈述加否定附加问句", ["You like English, don't you?"])
        ,p("j3-speech", .juniorThree, .listening, "听力场景预测", "校园、购物、问路、电话和计划", ["Could you tell me the way?"])
        ,p("j3-summary", .juniorThree, .reading, "阅读归纳与推断", "区分事实、观点和合理推断", ["The writer suggests that..."])
        ,p("p-numbers", .primary, .vocabulary, "基数词与序数词", "年龄、日期、数量和顺序", ["three books", "the first day"])
        ,p("p-time", .primary, .vocabulary, "日期与时间表达", "星期、月份、整点和半点", ["at half past six"])
        ,p("p-like", .primary, .expression, "喜好与日常表达", "like、love、want、need 的使用", ["I like apples."])
        ,p("p-commands", .primary, .listening, "课堂指令", "听懂 stand up、open、listen 等指令", ["Listen and repeat."])
        ,p("j1-subject", .juniorOne, .wordOrder, "主谓一致", "主语单复数决定动词形式", ["He likes music."])
        ,p("j1-possessive", .juniorOne, .vocabulary, "名词所有格", "表达谁的物品和关系", ["Tom's pencil"])
        ,p("j1-quantifiers", .juniorOne, .vocabulary, "数量词", "many、much、few、little、a lot of", ["many students"])
        ,p("j1-frequency-question", .juniorOne, .reading, "How often 提问", "询问频率并使用次数表达", ["How often do you exercise?"])
        ,p("j1-directions", .juniorOne, .listening, "问路与指路", "turn left、across from、next to", ["Go straight ahead."])
        ,p("j2-verb-forms", .juniorTwo, .tense, "动词三态变化", "原形、过去式和过去分词", ["go / went / gone"])
        ,p("j2-articles", .juniorTwo, .wordOrder, "零冠词", "球类、学科、三餐和专有名词", ["play basketball", "have breakfast"])
        ,p("j2-linking", .juniorTwo, .expression, "系动词与表语", "look、feel、become 后接形容词", ["The soup tastes good."])
        ,p("j2-question-tags", .juniorTwo, .wordOrder, "反意疑问基础", "前肯后否、前否后肯", ["It is cold, isn't it?"])
        ,p("j2-health", .juniorTwo, .expression, "健康与建议", "身体状况、should 和 take care", ["You should see a doctor."])
        ,p("j3-sequence", .juniorThree, .reading, "事件顺序", "first、next、then、finally 组织信息", ["First, mix the flour."])
        ,p("j3-synonyms", .juniorThree, .reading, "同义替换", "识别题干与原文的同义表达", ["quick = fast"])
        ,p("j3-context", .juniorThree, .vocabulary, "语境猜词", "利用上下文和构词线索猜测词义", ["unhappy means not happy"])
        ,p("j3-email", .juniorThree, .expression, "应用文格式", "邮件、通知、倡议和邀请", ["Dear ..., Best wishes"])
        ,p("j3-opinion", .juniorThree, .expression, "观点表达", "I think、In my opinion、because", ["In my opinion, reading helps."])
        ,p("p-colors", .primary, .vocabulary, "颜色与外貌", "颜色、身高、外貌和衣物描述", ["The bag is blue."])
        ,p("p-family", .primary, .vocabulary, "家庭与人物", "家庭成员、职业和关系", ["My aunt is a doctor."])
        ,p("p-school", .primary, .listening, "校园生活", "课程、教室、文具和课堂活动", ["We have English on Monday."])
        ,p("p-weather", .primary, .expression, "天气与季节", "询问和描述天气、季节", ["What is the weather like?"])
        ,p("p-food", .primary, .expression, "食物与点餐", "食物喜好、数量和礼貌点餐", ["I'd like some noodles."])
        ,p("p-body", .primary, .vocabulary, "身体与健康", "身体部位、感觉和简单建议", ["My head hurts."])
        ,p("p-prepositions", .primary, .wordOrder, "方位介词", "in、on、under、next to、between", ["The cat is under the table."])
        ,p("j1-sentence", .juniorOne, .wordOrder, "五大基本句型", "主谓、主系表、主谓宾等句子骨架", ["Birds fly.", "She is kind."])
        ,p("j1-negative", .juniorOne, .wordOrder, "否定句", "not、don't、doesn't、didn't 的位置", ["He doesn't like tea."])
        ,p("j1-whose", .juniorOne, .vocabulary, "疑问代词与所有", "whose、which、what kind of", ["Whose book is this?"])
        ,p("j1-frequency-count", .juniorOne, .tense, "频率与次数", "once、twice、every day 等表达", ["I read twice a week."])
        ,p("j1-invitation", .juniorOne, .expression, "邀请与回应", "Would you like、Would you mind", ["Would you like to join us?"])
        ,p("j1-thanks", .juniorOne, .expression, "感谢与道歉", "Thank you、Sorry、Never mind", ["Thanks for your help."])
        ,p("j1-shopping", .juniorOne, .listening, "购物与价格", "尺寸、颜色、价格和购买表达", ["How much is it?"])
        ,p("j2-adjectives", .juniorTwo, .vocabulary, "形容词与副词比较", "原级、比较级、最高级", ["the most interesting book"])
        ,p("j2-superlative", .juniorTwo, .expression, "最高级", "三者或以上比较", ["This is the best day."])
        ,p("j2-frequency", .juniorTwo, .tense, "过去进行时", "描述过去某时正在进行的动作", ["I was reading at eight."])
        ,p("j2-future-plan", .juniorTwo, .tense, "be going to 计划", "近期计划和预测", ["We are going to visit Beijing."])
        ,p("j2-purpose", .juniorTwo, .expression, "目的状语", "in order to、so that 表达目的", ["He studies hard to pass."])
        ,p("j2-cause", .juniorTwo, .reading, "原因与结果", "because、so、as a result 的逻辑", ["It rained, so we stayed home."])
        ,p("j2-relative-basic", .juniorTwo, .reading, "定语从句入门", "who、which、that 修饰名词", ["The book that I bought is new."])
        ,p("j2-voice", .juniorTwo, .wordOrder, "主动与被动辨析", "识别动作发出者和承受者", ["People speak English here."])
        ,p("j2-travel", .juniorTwo, .listening, "旅行与交通", "问时间、路线、车票和住宿", ["When does the train leave?"])
        ,p("j2-telephone", .juniorTwo, .listening, "电话与留言", "接听、转接、留言和回电", ["May I speak to Kate?"])
        ,p("j3-tenses-review", .juniorThree, .tense, "时态综合辨析", "根据时间标志选择正确时态", ["since、for、already、yet"])
        ,p("j3-nonfinite", .juniorThree, .expression, "非谓语动词", "to do、doing、done 的基础区别", ["I saw him running."])
        ,p("j3-subjunctive", .juniorThree, .expression, "虚拟与愿望", "wish、if only、would like", ["I wish I could fly."])
        ,p("j3-conjunctions", .juniorThree, .reading, "从属连词", "when、while、before、after、although", ["Call me when you arrive."])
        ,p("j3-inversion", .juniorThree, .wordOrder, "倒装与强调基础", "常见强调句和倒装识别", ["It was Tom who helped me."])
        ,p("j3-word-building", .juniorThree, .vocabulary, "构词法", "前后缀、词性转换和词根猜词", ["careful / careless"])
        ,p("j3-phrasal", .juniorThree, .vocabulary, "动词短语", "get、take、make、put 等高频短语", ["take care of"])
        ,p("j3-cloze", .juniorThree, .reading, "完形逻辑", "搭配、语境、转折和复现线索", ["however、instead、therefore"])
        ,p("j3-reading-types", .juniorThree, .reading, "阅读题型", "细节、主旨、推理、词义和标题", ["What is the best title?"])
        ,p("j3-notice", .juniorThree, .expression, "通知与倡议", "时间地点、对象、要求和号召", ["Everyone is welcome."])
        ,p("j3-narrative", .juniorThree, .expression, "记叙文叙事", "人物、事件、冲突、转折和结局", ["At last, they solved the problem."])
        ,p("j3-argument", .juniorThree, .expression, "观点与论证", "提出观点、给出理由、举例和总结", ["There are two reasons."])
        ,p("p-phonics", .primary, .listening, "字母与自然拼读", "字母音、短元音、常见字母组合", ["sh / ch / th"])
        ,p("p-spelling", .primary, .vocabulary, "拼写与大小写", "单词拼写、首字母和标点", ["Monday", "I am Tom."])
        ,p("p-routines", .primary, .expression, "日常作息", "起床、上学、运动和睡觉", ["I go to bed at nine."])
        ,p("p-hobbies", .primary, .expression, "兴趣与能力", "喜欢的活动、会做的事情", ["I can draw."])
        ,p("j1-possessive-pronoun", .juniorOne, .wordOrder, "物主代词", "形容词性与名词性物主代词", ["my book", "The book is mine."])
        ,p("j1-reflexive", .juniorOne, .wordOrder, "反身代词", "myself、yourself 等的基本用法", ["I made it myself."])
        ,p("j1-exclamatory", .juniorOne, .expression, "感叹句", "What 和 How 引导的感叹", ["What a nice day!"])
        ,p("j1-there-transform", .juniorOne, .wordOrder, "句型转换", "肯定、否定、一般疑问和特殊疑问互换", ["There is a pen."])
        ,p("j1-spelling-rules", .juniorOne, .vocabulary, "名词动词变形规则", "复数、三单、过去式的拼写变化", ["study / studies"])
        ,p("j2-preposition-time", .juniorTwo, .vocabulary, "时间介词辨析", "in、on、at、for、since、during", ["since 2020", "for two years"])
        ,p("j2-question-forms", .juniorTwo, .wordOrder, "疑问句综合", "一般、特殊、选择和反意疑问", ["Do you walk or ride?"])
        ,p("j2-direct-speech", .juniorTwo, .expression, "直接引语", "引号、说话人和基本标点", ["He said, \"I am ready.\""])
        ,p("j2-social", .juniorTwo, .expression, "社交礼貌", "请求、许可、拒绝和接受", ["Could I borrow your pen?"])
        ,p("j2-environment", .juniorTwo, .reading, "环境与责任", "环保、节约和公共规则词汇", ["We should save water."])
        ,p("j3-conditional-review", .juniorThree, .tense, "条件句综合", "主将从现、祈使句和情态句型", ["If you study, you will improve."])
        ,p("j3-reported", .juniorThree, .expression, "间接引语基础", "陈述句和一般疑问句转述", ["He said that he was tired."])
        ,p("j3-ellipsis", .juniorThree, .reading, "省略与替代", "避免重复，理解 so、do、one 等替代", ["I like tea and so does she."])
        ,p("j3-punctuation", .juniorThree, .expression, "标点与段落", "逗号、句号、问号和段落衔接", ["First, ... Finally, ..."])
        ,p("j3-translation", .juniorThree, .expression, "汉译英组织", "确定主干、时态、词块和连接", ["把意思装配成句子"])
        ,p("p-silent-e", .primary, .listening, "开音节与闭音节", "辨别元音字母长音和短音", ["cap / cape"])
        ,p("p-blends", .primary, .listening, "辅音连缀", "bl、cl、st、tr 等连续辅音", ["blue", "street"])
        ,p("p-syllables", .primary, .listening, "音节与重音", "按音节拼读并感知单词重音", ["ta-ble", "ba-NA-na"])
        ,p("p-demonstratives", .primary, .wordOrder, "指示代词", "this、that、these、those 的远近与单复数", ["These are my shoes."])
        ,p("p-some-any", .primary, .vocabulary, "some 与 any", "肯定、否定和疑问中的数量表达", ["Do you have any milk?"])
        ,p("p-present-progress", .primary, .tense, "现在进行时入门", "be 加 doing 表达正在发生", ["They are playing."])
        ,p("p-past-basic", .primary, .tense, "一般过去时入门", "用过去式讲述昨天和上周", ["I watched TV yesterday."])
        ,p("p-polite", .primary, .expression, "礼貌请求", "please、may、could 的基础表达", ["May I come in?"])
        ,p("j1-indefinite", .juniorOne, .vocabulary, "不定代词", "something、anything、everyone 等", ["Everyone is here."])
        ,p("j1-ordinal-date", .juniorOne, .vocabulary, "日期完整表达", "月份、序数词和年份", ["September the seventh"])
        ,p("j1-imperative-rules", .juniorOne, .expression, "规则与禁止", "must、have to、Don't 构成规则", ["Don't run in the hall."])
        ,p("j1-infinitive-purpose", .juniorOne, .expression, "不定式表目的", "用 to do 说明为什么做", ["I went out to buy bread."])
        ,p("j1-reading-detail", .juniorOne, .reading, "细节定位", "用人名、数字、地点回原文找答案", ["Find the key word first."])
        ,p("j1-listening-keywords", .juniorOne, .listening, "听力关键词", "抓人物、时间、数字和地点", ["Listen for seven thirty."])
        ,p("j2-present-perfect-basic", .juniorTwo, .tense, "现在完成时入门", "have/has done 表达经历与结果", ["She has seen the film."])
        ,p("j2-used-to", .juniorTwo, .tense, "used to", "表达过去经常但现在不再", ["I used to be shy."])
        ,p("j2-too-enough", .juniorTwo, .expression, "too 与 enough", "表达程度过高或足够", ["He is old enough to go."])
        ,p("j2-both-either", .juniorTwo, .wordOrder, "both / either / neither", "两者的肯定、任一和否定", ["Neither answer is right."])
        ,p("j2-exclamation", .juniorTwo, .expression, "感叹句综合", "What 与 How 的结构辨析", ["How beautiful the city is!"])
        ,p("j2-reading-structure", .juniorTwo, .reading, "篇章结构", "总分、并列、因果、问题解决", ["problem and solution"])
        ,p("j2-listening-intent", .juniorTwo, .listening, "说话意图", "从语气和回应判断建议、邀请、拒绝", ["I'd love to, but..."])
        ,p("j3-perfect-continuity", .juniorThree, .tense, "完成时持续用法", "since、for 与延续性动词", ["I have lived here for five years."])
        ,p("j3-passive-tenses", .juniorThree, .tense, "被动语态时态", "不同时态中的 be done", ["The bridge will be built."])
        ,p("j3-modal-passive", .juniorThree, .wordOrder, "情态动词被动", "情态动词加 be done", ["Rules must be followed."])
        ,p("j3-relative-choice", .juniorThree, .reading, "关系词选择", "who、which、that、whose 的先行词", ["The girl whose bag is red..."])
        ,p("j3-object-order", .juniorThree, .wordOrder, "宾语从句语序", "疑问词后使用陈述语序", ["Do you know where he lives?"])
        ,p("j3-reading-attitude", .juniorThree, .reading, "作者态度", "从评价词判断支持、反对和客观", ["The writer is positive."])
        ,p("j3-reading-title", .juniorThree, .reading, "标题归纳", "用主题对象和核心观点选择标题", ["Choose the broad but accurate title."])
        ,p("j3-listening-inference", .juniorThree, .listening, "听力推断", "结合语气、关系和隐含信息判断", ["What does the speaker mean?"])
        ,p("j3-writing-cohesion", .juniorThree, .expression, "写作衔接", "代词、连接词和同义表达避免重复", ["Besides, however, therefore"])
        ,p("j3-writing-check", .juniorThree, .expression, "写作检查", "检查人称、时态、主谓、拼写和标点", ["Check tense and agreement."])
    ]

    private static func p(_ id: String, _ stage: StudyStage, _ ability: Ability, _ title: String, _ summary: String, _ examples: [String]) -> JuniorKnowledgePoint {
        JuniorKnowledgePoint(id: id, stage: stage, ability: ability, title: title, summary: summary, examples: examples)
    }

    static func points(stage: StudyStage? = nil, ability: Ability? = nil, query: String = "") -> [JuniorKnowledgePoint] {
        let keyword = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return all.filter { point in
            (stage == nil || point.stage == stage) &&
            (ability == nil || point.ability == ability) &&
            (keyword.isEmpty || point.title.lowercased().contains(keyword) || point.summary.lowercased().contains(keyword) || point.examples.joined(separator: " ").lowercased().contains(keyword))
        }
    }
}
