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
        ,q("p-family-2", "p-family", "My mother ___ a nurse.", ["am", "is", "are", "be"], 1, "第三人称单数 mother 与 is 搭配。")
        ,q("p-school-2", "p-school", "Please ___ the window.", ["close", "closes", "closed", "closing"], 0, "祈使句使用动词原形。")
        ,q("p-colors-2", "p-colors", "The grass is ___.", ["green", "great", "glass", "glad"], 0, "green 表示绿色。")
        ,q("p-food-2", "p-food", "Would you like ___ orange?", ["a", "an", "some", "any"], 1, "orange 以元音音素开头，用 an。")
        ,q("p-weather-2", "p-weather", "It is cold. Please put ___ your coat.", ["on", "in", "at", "to"], 0, "put on 表示穿上。")
        ,q("p-hobbies-2", "p-hobbies", "I enjoy ___.", ["read", "reading", "reads", "to reading"], 1, "enjoy 后接动名词。")
        ,q("p-time-2", "p-time", "We have lunch ___ noon.", ["in", "on", "at", "for"], 2, "具体时刻 noon 前用 at。")
        ,q("p-routines-2", "p-routines", "She ___ to bed at nine.", ["go", "goes", "going", "went"], 1, "主语 she 为第三人称单数。")
        ,q("p-demonstratives-2", "p-demonstratives", "___ is my new bike.", ["These", "Those", "This", "They"], 2, "单数近指用 This。")
        ,q("j1-possessive-2", "j1-possessive", "This is ___ book.", ["Tom", "Toms", "Tom's", "Toms'"], 2, "单数名词所有格加 's。")
        ,q("j1-negative-2", "j1-negative", "They ___ play soccer on rainy days.", ["doesn't", "don't", "isn't", "not"], 1, "主语 they 用 don't 构成否定。")
        ,q("j1-frequency-2", "j1-frequency", "He ___ watches TV after dinner.", ["usual", "usually", "usualy", "use"], 1, "频率副词 usually 修饰动词 watches。")
        ,q("j1-directions-2", "j1-directions", "Go straight and turn ___.", ["left", "bread", "quiet", "early"], 0, "问路指示中 turn left 表示左转。")
        ,q("j2-modal-2", "j2-modal", "You ___ be quiet in the library.", ["must", "may", "would", "could"], 0, "图书馆规则用 must 表示必须。")
        ,q("j2-advice-2", "j2-advice", "How about ___ a walk?", ["take", "to take", "taking", "takes"], 2, "How about 后接动名词。")
        ,q("j2-purpose-2", "j2-purpose", "She studies hard ___ pass the exam.", ["so", "to", "but", "because"], 1, "to do 表示目的。")
        ,q("j2-environment-2", "j2-environment", "We should ___ plastic bags.", ["reuse", "waste", "throw", "pollute"], 0, "环保语境提倡重复使用。")
        ,q("j3-email-2", "j3-email", "Which greeting suits a formal email?", ["Dear Mr. Wang,", "Hey bro,", "Yo!", "See ya!"], 0, "正式邮件常用 Dear + 称呼。")
        ,q("j3-opinion-2", "j3-opinion", "___, reading every day is helpful.", ["In my opinion", "At noon", "On the desk", "Turn right"], 0, "In my opinion 用于引出观点。")
        ,q("p-family-3", "p-family", "My brother and I ___ students.", ["am", "is", "are", "be"], 2, "并列主语与 are 搭配。")
        ,q("p-school-3", "p-school", "There are two ___ in my pencil case.", ["pen", "pens", "penses", "penes"], 1, "two 后接可数名词复数 pens。")
        ,q("p-colors-3", "p-colors", "The sky is ___ on a sunny day.", ["blue", "bread", "blackboard", "busy"], 0, "晴天的天空通常是 blue。")
        ,q("p-food-3", "p-food", "How many ___ do you want?", ["juice", "water", "apples", "rice"], 2, "How many 修饰可数名词复数 apples。")
        ,q("p-weather-3", "p-weather", "It is raining. Take an ___.", ["umbrella", "uniform", "uncle", "upstairs"], 0, "下雨时带 umbrella 雨伞。")
        ,q("p-hobbies-3", "p-hobbies", "He likes ___ pictures.", ["draw", "drawing", "draws", "drew"], 1, "like 后接动名词表示喜欢做某事。")
        ,q("p-time-3", "p-time", "We have English ___ Monday.", ["at", "in", "on", "for"], 2, "具体某一天前用 on。")
        ,q("p-routines-3", "p-routines", "They ___ breakfast at seven.", ["has", "have", "having", "had"], 1, "主语 they 使用 have。")
        ,q("p-demonstratives-3", "p-demonstratives", "___ are my shoes over there.", ["This", "That", "These", "Those"], 3, "远处复数用 Those。")
        ,q("j1-possessive-3", "j1-possessive", "The girls are ___ friends.", ["Lucy", "Lucys", "Lucy's", "Lucys'"], 2, "单数专有名词所有格加 's。")
        ,q("j1-negative-3", "j1-negative", "Mary ___ watch TV on school nights.", ["don't", "doesn't", "isn't", "not"], 1, "第三人称单数否定用 doesn't。")
        ,q("j1-frequency-3", "j1-frequency", "I ___ go swimming in summer.", ["often", "tomorrow", "yesterday", "already"], 0, "often 表示经常，属于频率副词。")
        ,q("j1-directions-3", "j1-directions", "The library is ___ the bank.", ["next to", "quickly", "happy", "during"], 0, "next to 表示紧邻。")
        ,q("j2-modal-3", "j2-modal", "___ I borrow your ruler?", ["May", "Must", "Should", "Need"], 0, "May I...? 用于礼貌请求许可。")
        ,q("j2-advice-3", "j2-advice", "You have a cold. You should ___ warm.", ["keep", "keeps", "keeping", "kept"], 0, "should 后接动词原形 keep。")
        ,q("j2-purpose-3", "j2-purpose", "They went outside ___ play basketball.", ["for", "to", "but", "so"], 1, "to play 表示出去的目的。")
        ,q("j2-environment-3", "j2-environment", "Planting trees can make the air ___.", ["cleaner", "clean", "cleans", "cleaning"], 0, "make + 宾语 + 形容词比较级 cleaner。")
        ,q("j3-email-3", "j3-email", "Which phrase politely asks for help?", ["Could you help me, please?", "Give me that!", "Go away!", "I don't care."], 0, "Could you...please? 是礼貌请求。")
        ,q("j3-opinion-3", "j3-opinion", "I agree ___ you.", ["to", "with", "at", "on"], 1, "agree with sb. 表示同意某人。")
        ,q("j3-perfect-advanced-1", "j3-perfect", "By the time we arrived, the film ___.", ["began", "has begun", "had begun", "begins"], 2, "到达发生在过去，电影开始更早，使用过去完成时。")
        ,q("j3-passive-advanced-1", "j3-passive", "A new bridge ___ in our town next year.", ["builds", "will build", "will be built", "is building"], 2, "桥是被建造，且 next year 表将来，用将来时被动。")
        ,q("j3-relative-advanced-1", "j3-relative", "The book ___ cover is blue belongs to me.", ["who", "which", "whose", "where"], 2, "关系词在从句中修饰 cover，表示所属，用 whose。")
        ,q("j3-object-advanced-1", "j3-object-clause", "Nobody knows whether he ___ tomorrow.", ["comes", "came", "will come", "has come"], 2, "tomorrow 表示将来，宾语从句按实际时间使用将来时。")
        ,q("j3-adverbial-advanced-1", "j3-adverbial", "You won't improve ___ you practise regularly.", ["if", "unless", "because", "although"], 1, "unless 相当于 if not，表示除非经常练习。")
        ,q("j3-modal-passive-2", "j3-modal-passive", "School rules must ___.", ["follow", "be followed", "followed", "be following"], 1, "情态动词被动结构为 must be done。")
        ,q("j3-word-building-2", "j3-word-building", "Regular exercise is ___ to our health.", ["benefit", "beneficial", "benefited", "benefits"], 1, "be 动词后用形容词 beneficial 作表语。")
        ,q("j3-phrasal-2", "j3-phrasal", "The meeting was ___ because of the storm.", ["put off", "put on", "put away", "put out"], 0, "put off 表示推迟。")
        ,q("j3-cloze-2", "j3-cloze", "She failed once; ___ giving up, she tried a new method.", ["instead of", "because of", "thanks to", "as for"], 0, "后文继续尝试，与放弃相反，用 instead of。")
        ,q("j3-reading-types-2", "j3-reading-types", "Which detail best supports a writer's opinion?", ["A relevant fact or example", "An unrelated date", "A repeated title", "A guess without evidence"], 0, "相关事实或例子才能有效支撑观点。")
        ,q("j3-summary-2", "j3-summary", "When summarizing two paragraphs, you should first ___.", ["find their shared main idea", "copy every sentence", "add personal stories", "ignore repeated ideas"], 0, "跨段概括先提取共同中心，再删去重复细节。")
        ,q("j3-context-2", "j3-context", "The path was 'treacherous', so we walked slowly and carefully. Treacherous most likely means ___.", ["dangerous", "beautiful", "short", "crowded"], 0, "slowly and carefully 提示道路危险。")
        ,q("j3-sequence-2", "j3-sequence", "Which connector shows an unexpected contrast?", ["However", "Therefore", "Moreover", "For example"], 0, "However 引出与前文预期相反的信息。")
        ,q("j3-translation-2", "j3-translation", "Translate '我到家时，他已经离开了。'", ["When I got home, he had left.", "When I get home, he leaves.", "He leaves before I got home.", "I had got home when he leaves."], 0, "先发生的离开用过去完成时，后发生的到家用一般过去时。")
        ,q("j3-punctuation-2", "j3-punctuation", "Which sentence uses the comma correctly?", ["Although it was raining, we went out.", "Although, it was raining we went out.", "Although it was, raining we went out.", "Although it was raining we, went out."], 0, "状语从句位于主句前时，通常用逗号分隔。")
        ,q("j3-reported-2", "j3-reported", "Tom said, 'I am busy.' Tom said that he ___.", ["is busy", "was busy", "will be busy", "has busy"], 1, "主句为过去时，转述时 am 通常后移为 was。")
        ,q("j3-conditional-review-2", "j3-conditional-review", "If everyone ___ less plastic, the environment will improve.", ["uses", "will use", "used", "is using"], 0, "真实条件句遵循主将从现。")
        ,q("j3-perfect-continuity-2", "j3-perfect-continuity", "He has kept the book ___ two weeks.", ["since", "for", "from", "during"], 1, "一段时间 two weeks 前用 for。")
        ,q("j3-hard-1", "j3-perfect", "This is the first time I ___ the museum.", ["visit", "visited", "have visited", "had visited"], 2, "This is the first time 后常用现在完成时。")
        ,q("j3-hard-2", "j3-passive", "The problem needs ___.", ["solve", "solving", "solved", "to solving"], 1, "need doing 表示需要被做。")
        ,q("j3-hard-3", "j3-relative", "All ___ can be done has been done.", ["what", "that", "which", "who"], 1, "先行词为 all 时关系代词常用 that。")
        ,q("j3-hard-4", "j3-object-clause", "I wonder ___ he has finished the task.", ["that", "whether", "what", "which"], 1, "wonder 后用 whether/if 表示是否。")
        ,q("j3-hard-5", "j3-adverbial", "Hard as the task was, she ___.", ["gave it up", "completed up", "completed it", "will complete"], 2, "as 引导让步，主句说明仍然完成。")
        ,q("j3-hard-6", "j3-word-building", "His explanation was highly ___.", ["convince", "convincing", "convinced", "conviction"], 1, "修饰 explanation 用 convincing。")
        ,q("j3-hard-7", "j3-phrasal", "We must ___ a solution before Friday.", ["come up with", "look down on", "run out of", "get away"], 0, "come up with 表示想出。")
        ,q("j3-hard-8", "j3-cloze", "The evidence seemed weak; ___, it changed the result.", ["nevertheless", "therefore", "besides", "similarly"], 0, "前后构成出乎意料的转折。")
        ,q("j3-hard-9", "j3-reading-types", "An inference must be based on ___.", ["text evidence", "personal preference", "the longest option", "outside rumors"], 0, "推断必须以文本证据为基础。")
        ,q("j3-hard-10", "j3-summary", "A summary should omit ___.", ["the central idea", "minor examples", "key causes", "the conclusion"], 1, "摘要应删去次要例证。")
        ,q("j3-hard-11", "j3-context", "Her response was ambiguous; nobody knew whether she agreed. Ambiguous means ___.", ["unclear", "angry", "immediate", "honest"], 0, "后文 nobody knew 提示含义不明确。")
        ,q("j3-hard-12", "j3-sequence", "Which pair signals cause and result?", ["because / therefore", "although / however", "first / next", "for example / such as"], 0, "because 表原因，therefore 表结果。")
        ,q("j3-hard-13", "j3-translation", "Only then ___ the truth.", ["I understood", "did I understand", "I did understand", "understood I"], 1, "Only+状语置于句首，主句部分倒装。")
        ,q("j3-hard-14", "j3-punctuation", "Choose the correct sentence.", ["My goal, however, remains unchanged.", "My goal however remains, unchanged.", "My, goal however remains unchanged.", "My goal however, remains unchanged."], 0, "插入语 however 两侧应用逗号。")
        ,q("j3-hard-15", "j3-reported", "She asked me where I ___ the day before.", ["go", "went", "had gone", "will go"], 2, "转述过去之前的动作使用过去完成时。")
        ,q("j3-hard-16", "j3-conditional-review", "Unless you hurry, you ___ the bus.", ["miss", "missed", "will miss", "have missed"], 2, "unless 从句用一般现在时，主句用一般将来时。")
        ,q("j3-hard-17", "j3-perfect-continuity", "The old man has been dead ___ ten years.", ["since", "for", "from", "by"], 1, "延续状态加时间段用 for。")
        ,q("j3-hard-18", "j3-passive", "Neither answer can ___ correct.", ["consider", "be considered", "considered", "be considering"], 1, "情态动词被动为 can be done。")
        ,q("j3-hard-19", "j3-opinion", "Which sentence presents a qualified opinion?", ["This may work in some cases.", "This always works.", "Everyone agrees.", "There is no doubt ever."], 0, "may 和 some cases 限定范围，表达更严谨。")
        ,q("j3-hard-20", "j3-email", "Which sentence is most appropriate in a formal request?", ["I would appreciate it if you could reply.", "Reply now!", "You must answer me.", "Why haven't you replied?"], 0, "条件句式使正式请求更礼貌。")
        ,q("j3-relative-choice-2", "j3-relative-choice", "This is the village ___ I was born.", ["which", "who", "where", "whose"], 2, "先行词 village 表地点，关系词在从句中作地点状语，用 where。")
        ,q("j3-notice-2", "j3-notice", "A complete school notice should clearly state ___.", ["time, place and participants", "only the writer's mood", "an unrelated story", "no practical details"], 0, "通知必须交代时间、地点、对象等关键信息。")
        ,q("j3-challenge-21", "j3-perfect", "It is three years since he ___ his hometown, but he still keeps in touch with us.", ["has left", "left", "had left", "leaves"], 1, "It is + 时间段 + since 从句中，since 后通常用一般过去时表示动作发生的起点。")
        ,q("j3-challenge-22", "j3-passive-tenses", "By the end of last month, all the donated books ___ to village schools.", ["sent", "were sent", "had been sent", "have been sent"], 2, "by the end of last month 表示过去截止点；书被寄送，因此用过去完成时的被动语态 had been sent。")
        ,q("j3-challenge-23", "j3-modal-passive", "The medicine ___ beyond children's reach, or it may cause an accident.", ["must keep", "must be kept", "can keep", "may be keeping"], 1, "medicine 是 keep 的承受者，规则要求用 must be kept。")
        ,q("j3-challenge-24", "j3-relative", "The reason ___ he gave for being late was not the one ___ we had expected.", ["why / that", "that / that", "why / what", "which / what"], 1, "第一个从句中 gave 缺宾语，用 that；第二个从句中 expected 也缺宾语，先行词 one 后可用 that。")
        ,q("j3-challenge-25", "j3-relative-choice", "Mr. Lee is the only teacher in our school ___ has worked in Antarctica.", ["which", "whose", "whom", "that"], 3, "先行词由 the only 修饰且指人时，限制性定语从句通常用 that。")
        ,q("j3-challenge-26", "j3-object-clause", "Could you tell me ___ after the experiment is completed?", ["what will the students discuss", "what the students will discuss", "what did the students discuss", "the students will discuss what"], 1, "宾语从句使用陈述语序；实验完成之后将讨论，故用 what the students will discuss。")
        ,q("j3-challenge-27", "j3-reported", "The guide asked us, 'Have you ever visited a cave before?' The guide asked us ___.", ["that we had ever visited a cave before", "whether had we ever visited a cave before", "whether we had ever visited a cave before", "if we ever visit a cave before"], 2, "一般疑问句转述用 whether/if 引导、陈述语序，并把现在完成时后移为过去完成时。")
        ,q("j3-challenge-28", "j3-conditional-review", "If the weather had been better yesterday, we ___ the outdoor experiment.", ["would complete", "would have completed", "will have completed", "completed"], 1, "这是与过去事实相反的条件句：if 从句用 had done，主句用 would have done。")
        ,q("j3-challenge-29", "j3-adverbial", "No matter ___ difficult the puzzle appears, there is usually a logical way to solve it.", ["what", "how", "which", "whether"], 1, "how 修饰形容词 difficult，no matter how 表示“无论多么”。")
        ,q("j3-challenge-30", "j3-perfect-continuity", "How long is it since the factory ___ producing these machines?", ["has stopped", "stopped", "has begun", "had stopped"], 1, "How long is it since...? 的 since 从句用一般过去时；stop 是时间起点动作。")
        ,q("j3-challenge-31", "j3-word-building", "The new evidence made the witness's earlier statement seem ___.", ["rely", "reliable", "unreliable", "reliably"], 2, "seem 后接形容词；新证据使先前证词不可信，需用带否定前缀的 unreliable。")
        ,q("j3-challenge-32", "j3-phrasal", "The scientist refused to ___ the possibility that the result was caused by human error.", ["rule out", "break down", "take after", "bring up with"], 0, "rule out 表示“排除可能性”；语境说明科学家拒绝排除人为错误这一可能。")
        ,q("j3-challenge-33", "j3-cloze", "The plan looked practical at first. ___, a closer examination revealed several hidden costs.", ["Likewise", "Moreover", "Nevertheless", "For instance"], 2, "前句认为可行，后句发现问题，逻辑上是让步转折，用 Nevertheless。")
        ,q("j3-challenge-34", "j3-context", "Unlike his impulsive brother, Daniel is prudent and considers every consequence before acting. 'Prudent' means ___.", ["careless", "cautious", "stubborn", "generous"], 1, "Unlike 和 considers every consequence 提示 Daniel 做事谨慎，prudent 意为 cautious。")
        ,q("j3-challenge-35", "j3-reading-types", "A passage describes falling bee populations, explains their role in pollination, and calls for fewer harmful chemicals. Which title best captures its purpose?", ["How Honey Is Packaged", "Why Bees Matter and How to Protect Them", "The History of Farm Machines", "Ways to Grow Larger Flowers"], 1, "标题需同时覆盖核心对象、重要性和保护倡议，不能只抓住局部细节。")
        ,q("j3-challenge-36", "j3-summary", "Paragraph 1 explains that sleep strengthens memory. Paragraph 2 reports that students who slept well recalled more words. Which is the best summary?", ["Students were given a list of words.", "Sleep may improve learning by helping the brain store memories.", "Every student needs exactly eight hours of sleep.", "Memory is the only purpose of sleep."], 1, "该项综合了两段的共同主旨，并避免把单个细节或未经支持的绝对结论当作中心。")
        ,q("j3-challenge-37", "j3-sequence", "The alarm failed to ring. ___, Mia missed the early bus; ___, she arrived before the meeting because her father drove her.", ["However / therefore", "As a result / nevertheless", "For example / moreover", "Meanwhile / similarly"], 1, "错过公交是前因的结果，用 As a result；最终仍准时与预期相反，用 nevertheless。")
        ,q("j3-challenge-38", "j3-translation", "Choose the best translation of '直到完成数据核对，研究人员才公布结果。'", ["The researchers did not announce the results until they had checked the data.", "Until the researchers announced the results, they check the data.", "The researchers had announced the results until checking the data.", "Not until checking the data the researchers announced the results."], 0, "not...until 表示“直到……才”；核对先于公布，用过去完成时能清楚体现先后关系。")
        ,q("j3-challenge-39", "j3-punctuation", "Which sentence is punctuated correctly?", ["The task had three stages: collecting data, checking facts, and writing the report.", "The task had three stages; collecting data checking facts and writing the report.", "The task had three stages, collecting data; checking facts, and writing the report.", "The task had: three stages collecting data, checking facts and writing the report."], 0, "冒号用于引出前面完整分句所概括的项目列表，列表各项用逗号分隔。")
        ,q("j3-challenge-40", "j3-opinion", "Which claim is best supported by the evidence 'In a survey of 600 students, those who reviewed weekly made fewer repeated errors'?", ["Weekly review guarantees perfect scores for everyone.", "Students never learn from mistakes without a survey.", "Regular review may help students avoid making the same mistakes again.", "All forms of daily practice are ineffective."], 2, "证据支持“可能有助于减少重复错误”的有限结论，不能推出保证、从不或全部无效等绝对判断。")
    ]

    static func forPoint(_ id: String) -> [KnowledgePracticeQuestion] { all.filter { $0.knowledgePointID == id } }

    static func coverageQuestion(for point: JuniorKnowledgePoint) -> KnowledgePracticeQuestion {
        let example = point.examples.first ?? "Practice this sentence."
        return KnowledgePracticeQuestion(id: point.id + "-coverage", knowledgePointID: point.id,
            prompt: "关于“\(point.title)”，下面哪项示例正确？",
            options: [example, "以上规则不需要看语境", "只要句子够长就一定正确", "中文意思相同即可"], answer: 0,
            explanation: "\(point.summary) 示例：\(example)", kind: "识别")
    }

    private static func q(_ id: String, _ point: String, _ prompt: String, _ options: [String], _ answer: Int, _ explanation: String) -> KnowledgePracticeQuestion {
        KnowledgePracticeQuestion(id: id, knowledgePointID: point, prompt: prompt, options: options, answer: answer, explanation: explanation, kind: "应用")
    }
}
