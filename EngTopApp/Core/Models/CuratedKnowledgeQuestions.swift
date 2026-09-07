import Foundation

enum CuratedKnowledgeQuestions {
    static let all: [KnowledgePracticeQuestion] = [
        q("p-be-1", "p-be", "I ___ a student.", ["am", "is", "are", "be"], 0, "I 与 am 搭配。"),
        q("p-be-2", "p-be", "They ___ good friends.", ["am", "is", "are", "be"], 2, "复数主语 They 与 are 搭配。"),
        q("p-articles-1", "p-articles", "This is ___ apple.", ["a", "an", "the", "some"], 1, "apple 以元音音素开头，用 an。"),
        q("p-present-1", "p-present", "Tom ___ to school every day.", ["go", "goes", "going", "went"], 1, "一般现在时中第三人称单数动词加 -es。"),
        q("p-questions-1", "p-questions", "___ you like milk?", ["Are", "Do", "Does", "Is"], 1, "主语是 you，实义动词 like 的疑问句用 Do。"),
        q("p-can-1", "p-can", "She can ___ very well.", ["swims", "swam", "swim", "swimming"], 2, "情态动词 can 后接动词原形。"),
        q("p-plurals-1", "p-plurals", "Two ___ are playing.", ["child", "childs", "children", "childrens"], 2, "child 的复数是不规则形式 children。"),
        q("p-some-any-1", "p-some-any", "Do you have ___ pencils?", ["some", "any", "much", "a"], 1, "一般疑问句通常使用 any。"),
        q("p-prepositions-1", "p-prepositions", "The ball is ___ the table, not on it.", ["under", "at", "from", "with"], 0, "与 on 相对的方位是 under。"),
        q("p-present-progress-1", "p-present-progress", "Look! The dog ___ running.", ["am", "is", "are", "be"], 1, "现在进行时为 be + doing，dog 是单数。"),
        q("j1-pronouns-1", "j1-pronouns", "Lucy is my friend. I often help ___.", ["she", "her", "hers", "herself"], 1, "动词 help 后使用宾格 her。"),
        q("j1-there-1", "j1-there", "There ___ two books on the desk.", ["is", "are", "was", "be"], 1, "就近主语 two books 是复数，用 are。"),
        q("j1-present-cont-1", "j1-present-cont", "Listen! Someone ___ at the door.", ["knocks", "knocked", "is knocking", "knock"], 2, "Listen 提示动作此刻正在发生。"),
        q("j1-past-1", "j1-past", "We ___ the museum last Sunday.", ["visit", "visits", "visited", "are visiting"], 2, "last Sunday 是一般过去时标志。"),
        q("j1-count-1", "j1-count", "How much ___ do you need?", ["apples", "books", "water", "chairs"], 2, "How much 修饰不可数名词 water。"),
        q("j1-subject-1", "j1-subject", "Everyone ___ here on time.", ["are", "is", "be", "were"], 1, "everyone 作主语时谓语用单数。"),
        q("j1-negative-1", "j1-negative", "He ___ like coffee.", ["isn't", "doesn't", "don't", "not"], 1, "第三人称单数实义动词否定用 doesn't。"),
        q("j1-connectors-1", "j1-connectors", "I was tired, ___ I finished my homework.", ["and", "but", "or", "because"], 1, "前后意思形成转折，用 but。"),
        q("j1-exclamatory-1", "j1-exclamatory", "___ beautiful flowers they are!", ["What", "How", "What a", "How a"], 0, "中心词是复数名词 flowers，用 What。"),
        q("j1-frequency-question-1", "j1-frequency-question", "___ do you exercise? Twice a week.", ["How long", "How often", "How soon", "How far"], 1, "Twice a week 回答频率，用 How often。"),
        q("j2-future-1", "j2-future", "I think it ___ tomorrow.", ["rains", "rained", "will rain", "is raining"], 2, "tomorrow 表示将来，使用 will rain。"),
        q("j2-comparative-1", "j2-comparative", "This river is ___ than that one.", ["long", "longer", "longest", "the longer"], 1, "than 是比较级标志。"),
        q("j2-superlative-1", "j2-superlative", "Mount Qomolangma is ___ mountain in the world.", ["high", "higher", "the highest", "highest"], 2, "范围 in the world 表示最高级，前加 the。"),
        q("j2-modal-1", "j2-modal", "You ___ wear a seat belt in a car.", ["must", "may", "could", "would"], 0, "交通安全规则用 must 表示必须。"),
        q("j2-infinitive-1", "j2-infinitive", "She hopes ___ a doctor.", ["become", "became", "becoming", "to become"], 3, "hope 后接 to do。"),
        q("j2-gerund-1", "j2-gerund", "I enjoy ___ English stories.", ["read", "to read", "reading", "reads"], 2, "enjoy 后接动名词 doing。"),
        q("j2-frequency-1", "j2-frequency", "At eight last night, I ___ TV.", ["watch", "watched", "was watching", "am watching"], 2, "过去具体时刻正在发生，用过去进行时。"),
        q("j2-conditional-1", "j2-conditional", "If it ___ tomorrow, we will stay home.", ["rain", "rains", "will rain", "rained"], 1, "真实条件句遵循主将从现。"),
        q("j2-both-either-1", "j2-both-either", "Neither Tom nor Jack ___ at home.", ["are", "were", "is", "be"], 2, "neither...nor 就近一致，Jack 是单数。"),
        q("j2-present-perfect-basic-1", "j2-present-perfect-basic", "I ___ this film twice.", ["see", "saw", "have seen", "am seeing"], 2, "twice 表示截至现在的经历，用现在完成时。"),
        q("j3-perfect-1", "j3-perfect", "She ___ here since 2020.", ["lives", "lived", "has lived", "is living"], 2, "since 2020 与现在完成时连用。"),
        q("j3-passive-1", "j3-passive", "The classroom ___ every day.", ["cleans", "is cleaned", "cleaned", "was cleaning"], 1, "教室是被打扫，使用一般现在时被动。"),
        q("j3-object-clause-1", "j3-object-clause", "Could you tell me ___?", ["where is the bank", "where the bank is", "where was the bank", "the bank is where"], 1, "宾语从句使用陈述语序。"),
        q("j3-relative-1", "j3-relative", "The woman ___ teaches us English is kind.", ["which", "whose", "who", "where"], 2, "先行词 woman 指人，关系词在从句中作主语，用 who。"),
        q("j3-adverbial-1", "j3-adverbial", "___ he was tired, he kept working.", ["Because", "Although", "If", "So"], 1, "前后存在让步关系，用 Although。"),
        q("j3-tag-1", "j3-tag", "You have finished the work, ___?", ["have you", "haven't you", "do you", "don't you"], 1, "前肯后否，助动词沿用 have。"),
        q("j3-nonfinite-1", "j3-nonfinite", "The boy ___ under the tree is my brother.", ["stand", "stood", "standing", "stands"], 2, "standing 作后置定语，表示主动进行。"),
        q("j3-modal-passive-1", "j3-modal-passive", "The problem must ___ at once.", ["solve", "be solved", "solved", "be solving"], 1, "情态动词被动结构为 must be done。"),
        q("j3-reading-title-1", "j3-reading-title", "选择文章标题时最重要的是？", ["覆盖全文核心", "使用最长选项", "包含所有细节", "照抄第一句"], 0, "标题应概括全文对象与核心观点，范围不能过大或过小。"),
        q("j3-writing-check-1", "j3-writing-check", "完成作文后应优先检查哪一组？", ["人称、时态、主谓一致", "字体颜色", "句子数量是否相同", "是否全部使用长句"], 0, "人称、时态和主谓一致是最常见且可快速修正的错误。")
        ,q("p-colors-1", "p-colors", "The sky is ___.", ["blue", "seven", "Monday", "doctor"], 0, "blue 是颜色词。")
        ,q("p-family-1", "p-family", "My father ___ a teacher.", ["am", "is", "are", "be"], 1, "father 是第三人称单数，与 is 搭配。")
        ,q("p-school-1", "p-school", "Please ___ your book.", ["open", "opens", "opened", "opening"], 0, "课堂指令祈使句使用动词原形。")
        ,q("p-weather-1", "p-weather", "How is the weather? It is ___.", ["sunny", "Sunday", "seven", "student"], 0, "sunny 描述天气。")
        ,q("p-food-1", "p-food", "I'd like ___ rice, please.", ["some", "a", "an", "many"], 0, "rice 是不可数名词，用 some。")
        ,q("p-body-1", "p-body", "I have two ___.", ["foot", "foots", "feet", "feets"], 2, "foot 的复数是不规则形式 feet。")
        ,q("p-demonstratives-1", "p-demonstratives", "___ are my pencils.", ["This", "That", "These", "It"], 2, "pencils 是复数且指近处，用 These。")
        ,q("p-numbers-1", "p-numbers", "Today is my ___ birthday.", ["twelve", "twelfth", "twelf", "two"], 1, "生日顺序使用序数词 twelfth。")
        ,q("p-time-1", "p-time", "I get up ___ seven o'clock.", ["in", "on", "at", "for"], 2, "具体时刻前用 at。")
        ,q("p-routines-1", "p-routines", "I ___ my teeth every morning.", ["brush", "brushes", "brushed", "brushing"], 0, "主语 I 使用动词原形。")
        ,q("j1-possessive-pronoun-1", "j1-possessive-pronoun", "This pencil is ___.", ["my", "me", "mine", "I"], 2, "空格后没有名词，使用名词性物主代词 mine。")
        ,q("j1-reflexive-1", "j1-reflexive", "She made the cake by ___.", ["her", "hers", "herself", "she"], 2, "by oneself 表示独自完成，she 对应 herself。")
        ,q("j1-invitation-1", "j1-invitation", "Would you like to join us? ___.", ["Yes, I'd love to", "No, I don't", "Yes, I am", "That's all"], 0, "接受邀请可用 Yes, I'd love to。")
        ,q("j1-thanks-1", "j1-thanks", "Thanks for helping me. ___.", ["Never mind", "You are welcome", "I'm sorry", "Here you are"], 1, "回应感谢用 You are welcome。")
        ,q("j1-shopping-1", "j1-shopping", "___ is this T-shirt? It is 50 yuan.", ["How many", "How much", "How long", "How often"], 1, "询问价格用 How much。")
        ,q("j1-directions-1", "j1-directions", "The bank is ___ the school and the park.", ["between", "under", "into", "during"], 0, "两者之间用 between。")
        ,q("j1-reading-detail-1", "j1-reading-detail", "阅读细节题首先应该做什么？", ["回原文定位关键词", "只看标题", "选择最长选项", "凭感觉猜"], 0, "人名、数字、地点等关键词可以帮助快速定位。")
        ,q("j1-listening-keywords-1", "j1-listening-keywords", "听力中听到 7:30，最可能对应哪个选项？", ["seven fifteen", "half past seven", "eight thirty", "six thirty"], 1, "7:30 即 half past seven。")
        ,q("j2-advice-1", "j2-advice", "You look tired. ___ take a rest?", ["Why not", "How much", "How long", "What about"], 0, "Why not + 动词原形可用于提建议。")
        ,q("j2-health-1", "j2-health", "You have a fever. You ___ see a doctor.", ["should", "couldn't", "would", "might not"], 0, "提出健康建议用 should。")
        ,q("j2-travel-1", "j2-travel", "What time does the train ___?", ["leave", "leaves", "left", "leaving"], 0, "does 后接动词原形。")
        ,q("j2-telephone-1", "j2-telephone", "May I speak to Lily? ___", ["Speaking", "Yes, I am Lily", "I speak", "Tell"], 0, "电话中本人接听可说 Speaking。")
        ,q("j2-purpose-1", "j2-purpose", "He went to the library ___ a book.", ["borrow", "borrowing", "to borrow", "borrowed"], 2, "to do 表示去图书馆的目的。")
        ,q("j2-cause-1", "j2-cause", "It was raining, ___ we took an umbrella.", ["but", "so", "or", "although"], 1, "下雨导致带伞，使用 so。")
        ,q("j2-linking-1", "j2-linking", "The music sounds ___.", ["beautiful", "beautifully", "beauty", "beautify"], 0, "sound 是系动词，后接形容词作表语。")
        ,q("j2-too-enough-1", "j2-too-enough", "The box is ___ heavy for me to carry.", ["enough", "too", "very enough", "so enough"], 1, "too...to 表示太重而无法搬动。")
        ,q("j2-environment-1", "j2-environment", "We should ___ water in our daily life.", ["waste", "save", "pollute", "drop"], 1, "环保语境中应节约水资源。")
        ,q("j2-reading-structure-1", "j2-reading-structure", "文章先提出问题，后给出解决办法，这是什么结构？", ["问题—解决", "时间顺序", "人物对话", "总分并列"], 0, "先 problem 后 solution 是常见篇章结构。")
        ,q("j2-listening-intent-1", "j2-listening-intent", "Would you like some tea? No, thanks. 说话者在做什么？", ["接受邀请", "礼貌拒绝", "请求帮助", "表达惊讶"], 1, "No, thanks 是礼貌拒绝。")
        ,q("j3-tenses-review-1", "j3-tenses-review", "I ___ my homework already.", ["finish", "finished", "have finished", "am finishing"], 2, "already 常与现在完成时连用。")
        ,q("j3-passive-tenses-1", "j3-passive", "The letter ___ yesterday.", ["sent", "was sent", "is sent", "sends"], 1, "yesterday 与一般过去时被动 was sent 搭配。")
        ,q("j3-reported-1", "j3-reported", "He said that he ___ tired.", ["is", "was", "will be", "has"], 1, "主句是过去时，间接引语通常时态后移。")
        ,q("j3-conditional-review-1", "j3-conditional-review", "If you work hard, you ___ make progress.", ["will", "would", "have", "are"], 0, "主将从现：主句用 will。")
        ,q("j3-word-building-1", "j3-word-building", "The opposite of careful is ___.", ["careless", "uncare", "discare", "carely"], 0, "care + less 构成反义词 careless。")
        ,q("j3-phrasal-1", "j3-phrasal", "Please ___ the lights before leaving.", ["turn off", "turn on", "look after", "put up"], 0, "离开前应关灯，用 turn off。")
        ,q("j3-cloze-1", "j3-cloze", "He was ill; ___, he went to school.", ["however", "because", "so", "and"], 0, "前后形成转折，用 however。")
        ,q("j3-reading-attitude-1", "j3-reading-attitude", "文章多次使用 helpful、useful、important，作者态度最可能是？", ["支持", "反对", "怀疑", "冷漠"], 0, "积极评价词表明作者支持该观点。")
        ,q("j3-reading-types-1", "j3-reading-types", "Which question asks for the writer's purpose?", ["Why did the writer write the passage?", "When did it happen?", "Who was there?", "How many people?"], 0, "询问写作目的对应 purpose 题。")
        ,q("j3-notice-1", "j3-notice", "通知中最不能缺少的是？", ["时间、地点和活动", "作者年龄", "天气预报", "故事结局"], 0, "通知的核心信息是时间、地点、活动和对象。")
        ,q("j3-narrative-1", "j3-narrative", "记叙文中 finally 通常引出什么？", ["结局", "原因", "人物介绍", "背景时间"], 0, "finally 常用于叙事的最后结果。")
        ,q("j3-writing-cohesion-1", "j3-writing-cohesion", "Which word shows a contrast?", ["however", "also", "first", "because"], 0, "however 表示转折。")
        ,q("j3-translation-1", "j3-translation", "“我每天花半小时读英语”中，花时间应使用哪个结构？", ["spend time doing", "take time do", "cost time to doing", "pay time do"], 0, "spend + 时间 + doing 是固定结构。")
        ,q("p-phonics-1", "p-phonics", "Which word begins with the /ʃ/ sound?", ["ship", "chair", "this", "zip"], 0, "sh 在 ship 中发 /ʃ/。")
        ,q("p-silent-e-1", "p-silent-e", "Which word has the long /eɪ/ sound?", ["cap", "map", "cake", "cat"], 2, "末尾不发音 e 使 a 发字母音，cake /keɪk/。")
        ,q("p-blends-1", "p-blends", "Which word starts with the blend /bl/?", ["blue", "shoe", "tree", "clock"], 0, "blue 以辅音连缀 bl 开头。")
        ,q("p-spelling-1", "p-spelling", "Which sentence uses capitals correctly?", ["i am from china.", "I am from China.", "I Am From china.", "i am from China."], 1, "句首、I 和专有名词 China 要大写。")
        ,q("p-like-1", "p-like", "She ___ playing the piano.", ["like", "likes", "liking", "liked every day"], 1, "一般现在时第三人称单数用 likes。")
        ,q("p-hobbies-1", "p-hobbies", "What is your hobby? ___.", ["I like drawing", "I am ten", "It is sunny", "At school"], 0, "询问爱好可回答 I like doing。")
        ,q("p-polite-1", "p-polite", "___ I use your ruler, please?", ["May", "Must", "Need", "Shall not"], 0, "May I...? 是礼貌请求许可。")
        ,q("j1-possessive-1", "j1-possessive", "This is ___ room.", ["Tom and Jack", "Tom's and Jack", "Tom and Jack's", "Tom's and Jack's one"], 2, "两人共有的房间只在最后一个名字后加 's。")
        ,q("j1-quantifiers-1", "j1-quantifiers", "There is ___ water in the bottle.", ["a few", "a little", "many", "few"], 1, "water 不可数，肯定意义用 a little。")
        ,q("j1-adverbs-1", "j1-adverbs", "The girl sings ___.", ["beautiful", "beauty", "beautifully", "more beautiful"], 2, "修饰动词 sings 使用副词 beautifully。")
        ,q("j1-prepositions-1", "j1-prepositions", "Please listen ___ the teacher carefully.", ["at", "to", "for", "with"], 1, "listen to 是固定搭配。")
        ,q("j1-imperative-rules-1", "j1-imperative-rules", "___ eat in the classroom.", ["Not", "Doesn't", "Don't", "Isn't"], 2, "否定祈使句使用 Don't + 动词原形。")
        ,q("j1-infinitive-purpose-1", "j1-infinitive-purpose", "I got up early ___ the bus.", ["catch", "to catch", "catching", "caught"], 1, "to catch 表示早起的目的。")
        ,q("j2-verb-forms-1", "j2-verb-forms", "The past participle of write is ___.", ["wrote", "written", "writing", "writes"], 1, "write-wrote-written。")
        ,q("j2-preposition-time-1", "j2-preposition-time", "He has studied English ___ three years.", ["since", "for", "at", "during ago"], 1, "一段时间 three years 前用 for。")
        ,q("j2-used-to-1", "j2-used-to", "My father ___ walk to work, but now he drives.", ["uses to", "used to", "is used to", "was used"], 1, "used to do 表示过去常常。")
        ,q("j2-question-forms-1", "j2-question-forms", "___ do you prefer, tea or coffee?", ["What", "Which", "Where", "When"], 1, "在明确范围中选择使用 Which。")
        ,q("j2-social-1", "j2-social", "Could I borrow your dictionary? ___.", ["Of course", "That's wrong", "Never", "I don't know it"], 0, "Of course 是礼貌同意请求。")
        ,q("j2-relative-basic-1", "j2-relative-basic", "This is the bike ___ my father bought me.", ["who", "where", "that", "whose"], 2, "先行词 bike 指物，关系词作宾语可用 that。")
        ,q("j2-voice-1", "j2-voice", "English ___ in many countries.", ["speaks", "is spoken", "spoke", "speaking"], 1, "English 是被使用的语言，用被动语态。")
        ,q("j3-perfect-continuity-1", "j3-perfect-continuity", "Tom has ___ this book for a week.", ["borrowed", "bought", "kept", "lent"], 2, "for a week 要与延续性动词 kept 搭配。")
        ,q("j3-object-order-1", "j3-object-order", "I wonder ___.", ["what is he doing", "what he is doing", "is he doing what", "what does he do now"], 1, "宾语从句用陈述语序。")
        ,q("j3-relative-choice-1", "j3-relative-choice", "The boy ___ father is a pilot won the prize.", ["who", "which", "whose", "that"], 2, "关系词在从句中表示所属，用 whose。")
        ,q("j3-conjunctions-1", "j3-conjunctions", "Please call me ___ you arrive.", ["because", "when", "although", "unless not"], 1, "when 引导时间状语从句。")
        ,q("j3-synonyms-1", "j3-synonyms", "The word 'purchase' is closest in meaning to ___.", ["sell", "buy", "lose", "borrow"], 1, "purchase 与 buy 同义。")
        ,q("j3-context-1", "j3-context", "The ground was soaked after the storm. 'soaked' most likely means ___.", ["very wet", "very dry", "very clean", "very hard"], 0, "暴风雨后的地面应是湿透的，可由语境判断。")
        ,q("j3-sequence-1", "j3-sequence", "Which word normally comes at the end of a process?", ["First", "Next", "Then", "Finally"], 3, "Finally 引出最后一步。")
        ,q("j3-summary-1", "j3-summary", "A good summary should ___.", ["include every example", "state the main idea briefly", "copy the whole passage", "add a new opinion"], 1, "摘要应简洁概括主要内容，不增加新观点。")
        ,q("j3-email-1", "j3-email", "Which closing is suitable for an email to a friend?", ["Best wishes", "No entry", "Once upon a time", "Breaking news"], 0, "Best wishes 是常见邮件结尾。")
        ,q("j3-opinion-1", "j3-opinion", "Which phrase introduces an opinion?", ["In my opinion", "At seven o'clock", "For three days", "Turn left"], 0, "In my opinion 用于引出个人观点。")
        ,q("j3-punctuation-1", "j3-punctuation", "Which sentence is punctuated correctly?", ["Where are you.", "Where are you?", "where are you?", "Where, are you?"], 1, "特殊疑问句首字母大写并以问号结尾。")
    ]

    static func forPoint(_ id: String) -> [KnowledgePracticeQuestion] { all.filter { $0.id.hasPrefix(id + "-") } }

    private static func q(_ id: String, _ point: String, _ prompt: String, _ options: [String], _ answer: Int, _ explanation: String) -> KnowledgePracticeQuestion {
        KnowledgePracticeQuestion(id: id, knowledgePointID: id.split(separator: "-").dropLast().joined(separator: "-"), prompt: prompt, options: options, answer: answer, explanation: explanation)
    }
}
