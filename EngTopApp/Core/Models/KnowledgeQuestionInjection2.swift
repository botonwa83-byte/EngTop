import Foundation

/// 知识点有效练习题·第二轮注入包（151 道）。
///
/// 第一轮 `KnowledgeQuestionInjection` 解决的是「有没有题」——把 32 个零真题知识点补齐到 2 道；
/// 这一轮解决的是「够不够练」——把每个知识点的题量下限统一抬到 **3 道**。
///
/// 目标口径：145 个知识点，每个至少 3 道人工真题。
/// 本轮共补 151 道，覆盖 93 个题量不足 3 道的知识点：
///
/// | 批次 | 题量 | 说明 |
/// |---|---|---|
/// | `primaryBatch`   | 40 | 小学 24 个知识点 |
/// | `juniorOneBatch` | 45 | 初一 27 个知识点 |
/// | `juniorTwoBatch` | 45 | 初二 27 个知识点 |
/// | `juniorThreeBatch`| 21 | 初三 15 个知识点 |
///
/// 出题原则（这一轮的质检重点）：
/// 1. **同一知识点的题不重复考同一个点**——每个知识点内部错开子技能，
///    例如 `p-some-any` 分别考肯定句与否定句，`j1-adverbs` 分别考形容词与副词，
///    `j3-reading-attitude` 分别考客观审慎与热情支持；
/// 2. **干扰项必须是真实存在的错误形式**，而不是凑数的荒谬选项——
///    常见错误来源：忽略第三人称单数、忽略不规则复数、混淆近义疑问词、
///    误用动词形式、中式搭配、张冠李戴的连接词；
/// 3. **题干都尽量给足语境线索**（时间状语、答语、提示词），
///    让学生能靠规则推出答案，而不是靠语感猜；
/// 4. 不臆造「某年某卷」的真题出处，全部为作者编写的原创练习。
enum KnowledgeQuestionInjection2 {
    /// 小学批次（40 道）：编号 `inj2-p-*`。
    static let primaryBatch: [KnowledgePracticeQuestion] = [
        // p-present 一般现在时：三单 vs 复数主语
        q("inj2-p-present-1", "p-present", "My father ___ TV every evening.",
          ["watch", "watching", "watched", "watches"], 3, "主语 My father 是第三人称单数，一般现在时动词加 -es，用 watches。", "选词填空"),
        q("inj2-p-present-2", "p-present", "We ___ to school from Monday to Friday.",
          ["go", "goes", "going", "went"], 0, "主语 We 是复数，一般现在时用动词原形 go。", "选词填空"),

        // p-questions 一般疑问句：实义动词 vs be 动词
        q("inj2-p-questions-1", "p-questions", "___ she like apples?",
          ["Does", "Do", "Is", "Are"], 0, "主语 she 是第三人称单数，实义动词 like 的一般疑问句用 Does。", "选词填空"),
        q("inj2-p-questions-2", "p-questions", "___ Tom from Canada? — Yes, he is.",
          ["Do", "Is", "Does", "Are"], 1, "句中 from 前需要 be 动词，一般疑问句把 be 提前；答语 he is 提示用 Is。", "选词填空"),

        // p-articles 冠词：泛指 vs 独一无二
        q("inj2-p-articles-1", "p-articles", "I have ___ orange every morning.",
          ["a", "the", "an", "some"], 2, "orange 以元音音素开头，用不定冠词 an。", "选词填空"),
        q("inj2-p-articles-2", "p-articles", "Look at ___ moon! It's bright tonight.",
          ["a", "an", "some", "the"], 3, "世界上独一无二的事物前用定冠词 the。", "选词填空"),

        // p-plurals 不规则复数：man / tooth
        q("inj2-p-plurals-1", "p-plurals", "There are many ___ in the park.",
          ["man", "mans", "men", "mens"], 2, "man 的复数是不规则形式 men。", "选词填空"),
        q("inj2-p-plurals-2", "p-plurals", "I brush my ___ twice a day.",
          ["tooth", "tooths", "teeths", "teeth"], 3, "tooth 的复数是不规则形式 teeth。", "选词填空"),

        // p-can 能力：疑问形式 + 语义理解
        q("inj2-p-can-1", "p-can", "___ you play the piano? — Yes, I can.",
          ["Do", "Can", "Are", "Is"], 1, "询问能力用情态动词 Can 开头，答语 Yes, I can 也印证这一点。", "选词填空"),
        q("inj2-p-can-2", "p-can", "Tom can swim, but he can't ride a bike. What can Tom do?",
          ["骑自行车", "两样都会", "游泳", "两样都不会"], 2, "can swim 表示会游泳，can't ride 表示不会骑车，他会的只有游泳。", "理解"),

        // p-numbers 基数词与序数词
        q("inj2-p-numbers-1", "p-numbers", "There are ___ months in a year.",
          ["twelfth", "twelveth", "twenty", "twelve"], 3, "表示数量用基数词 twelve；twelfth 是序数词，用来表示顺序。", "选词填空"),
        q("inj2-p-numbers-2", "p-numbers", "January is the ___ month of the year.",
          ["first", "one", "once", "one time"], 0, "表示顺序用序数词，第一是 first。", "选词填空"),

        // p-like 喜好表达：三单 + 否定
        q("inj2-p-like-1", "p-like", "My brother ___ playing basketball.",
          ["like", "likes", "liking", "liked"], 1, "主语 My brother 是第三人称单数，动词用 likes。", "选词填空"),
        q("inj2-p-like-2", "p-like", "I like apples, but I ___ bananas.",
          ["like", "doesn't like", "don't like", "am not like"], 2, "主语是 I，一般现在时的否定用 don't + 动词原形，即 don't like。", "选词填空"),

        // p-body 身体与健康：病症表达 + 建议
        q("inj2-p-body-1", "p-body", "— What's the matter? — I have a ___.",
          ["tooth", "toothache", "teeth", "ticket"], 1, "表示身体不适用 have a + 病症，牙痛是 have a toothache。", "选词填空"),
        q("inj2-p-body-2", "p-body", "I have a bad headache. I should ___.",
          ["eat more sweets", "run very fast", "see a doctor", "watch TV all night"], 2, "头痛难受时应去看医生，其余做法都不利于身体恢复。", "语境选择"),

        // p-prepositions 方位介词
        q("inj2-p-prepositions-1", "p-prepositions", "The picture is ___ the wall.",
          ["on", "in", "under", "between"], 0, "贴在墙面上、与表面接触，用 on the wall。", "选词填空"),
        q("inj2-p-prepositions-2", "p-prepositions", "The bank is ___ the post office and the hotel.",
          ["in", "between", "on", "under"], 1, "表示「在两者之间」用 between ... and ...。", "选词填空"),

        // p-phonics 自然拼读：/tʃ/ 与 /aɪ/
        q("inj2-p-phonics-1", "p-phonics", "Which word begins with the same sound as “chair”?",
          ["ship", "chicken", "kite", "sun"], 1, "chair 与 chicken 都以 /tʃ/ 开头；ship 以 /ʃ/ 开头，音不同。", "识别"),
        q("inj2-p-phonics-2", "p-phonics", "Which word has the same vowel sound as “bike”?",
          ["big", "sit", "like", "six"], 2, "bike 与 like 里的字母 i 都读长音 /aɪ/，其余三个读短音 /ɪ/。", "识别"),

        // p-spelling 拼写与大小写
        q("inj2-p-spelling-1", "p-spelling", "Which sentence is written correctly?",
          ["I like English.", "i like english.", "I Like english.", "i Like English."], 0, "句首字母和语言名称 English 都要大写。", "识别"),
        q("inj2-p-spelling-2", "p-spelling", "Which word is spelled correctly?",
          ["beatiful", "beautiful", "beautifull", "beautyful"], 1, "beautiful 的拼写是 b-e-a-u-t-i-f-u-l，注意 au 与 i 的顺序。", "识别"),

        // p-silent-e 开闭音节
        q("inj2-p-silent-e-1", "p-silent-e", "Which word has a short vowel sound?",
          ["note", "nose", "not", "name"], 2, "not 是闭音节，o 读短音 /ɒ/；note、nose、name 词尾有 e，元音读长音。", "识别"),
        q("inj2-p-silent-e-2", "p-silent-e", "Read “kit” and “kite”. Which word has the long /aɪ/ sound?",
          ["kit", "两个都是", "两个都不是", "kite"], 3, "kite 词尾的 e 不发音，i 读长音 /aɪ/；kit 是闭音节，读短音。", "识别"),

        // p-blends 辅音连缀
        q("inj2-p-blends-1", "p-blends", "Which word begins with the “st” blend?",
          ["shoe", "tree", "chair", "street"], 3, "street 以 st 连缀开头；shoe、tree、chair 的开头分别是 sh、tr、ch。", "识别"),
        q("inj2-p-blends-2", "p-blends", "Which word begins with the “tr” blend?",
          ["train", "dress", "cloud", "plant"], 0, "train 以 tr 连缀开头；dress、cloud、plant 的开头分别是 dr、cl、pl。", "识别"),

        // p-some-any
        q("inj2-p-some-any-1", "p-some-any", "There is ___ milk in the glass.",
          ["any", "many", "a", "some"], 3, "肯定句中一般用 some 修饰名词。", "选词填空"),
        q("inj2-p-some-any-2", "p-some-any", "I don't have ___ brothers.",
          ["any", "some", "many", "a"], 0, "否定句中一般用 any。", "选词填空"),

        // p-present-progress 现在进行时
        q("inj2-p-present-progress-1", "p-present-progress", "Look! The children ___ football.",
          ["play", "are playing", "plays", "played"], 1, "Look! 提示动作正在发生，主语 The children 是复数，用 are + doing，即 are playing。", "选词填空"),
        q("inj2-p-present-progress-2", "p-present-progress", "— What ___ you doing? — I'm reading.",
          ["is", "am", "are", "do"], 2, "主语 you 搭配 are，构成现在进行时 are doing。", "选词填空"),

        // p-polite 礼貌请求
        q("inj2-p-polite-1", "p-polite", "___ you please pass me the salt?",
          ["Must", "Need", "Shall not", "Could"], 3, "Could you please ...? 是常见的礼貌请求句式。", "选词填空"),
        q("inj2-p-polite-2", "p-polite", "— Thank you very much. — ___",
          ["You're welcome.", "I'm sorry.", "Yes, I am.", "Never mind."], 0, "回应感谢用 You're welcome.；Never mind. 一般用来回应道歉。", "语境选择"),

        // p-nouns 名词复数拼写
        q("inj2-p-nouns-1", "p-nouns", "There are three ___ on the desk.",
          ["box", "boxs", "boxies", "boxes"], 3, "以 x 结尾的名词变复数加 -es，即 boxes。", "选词填空"),

        // p-be 主语与 be 搭配
        q("inj2-p-be-1", "p-be", "My mother ___ a teacher.",
          ["am", "are", "is", "be"], 2, "主语 My mother 是第三人称单数，be 动词用 is。", "选词填空"),

        // p-have 一般疑问句形式
        q("inj2-p-have-1", "p-have", "___ your sister have a pet?",
          ["Does", "Do", "Is", "Has"], 0, "主语 your sister 是第三人称单数，一般疑问句用 Does + 动词原形 have。", "选词填空"),

        // p-imperative be 的祈使式
        q("inj2-p-imperative-1", "p-imperative", "___ quiet, please. The baby is sleeping.",
          ["Are", "Be", "Is", "Being"], 1, "祈使句以动词原形开头，be 动词的祈使形式是 Be。", "选词填空"),

        // p-wh 询问原因
        q("inj2-p-wh-1", "p-wh", "___ are you crying? — Because I lost my key.",
          ["What", "How", "Why", "Who"], 2, "答语用 Because 说明原因，所以问句用 Why。", "选词填空"),

        // p-commands 课堂指令
        q("inj2-p-commands-1", "p-commands", "老师说 “Open your books to page ten.”，她让同学们做什么？",
          ["把书合上", "抄写第十页", "大声朗读第十页", "打开书翻到第十页"], 3, "open 是打开，page ten 是第十页。", "理解"),

        // p-syllables 重音
        q("inj2-p-syllables-1", "p-syllables", "单词 computer 的重音在第几个音节？",
          ["第一个", "第二个", "第三个", "没有重音"], 1, "com-PU-ter 的重音落在第二个音节上。", "识别"),

        // p-past-basic 过去式
        q("inj2-p-past-basic-1", "p-past-basic", "They ___ football in the park last Saturday.",
          ["played", "play", "plays", "playing"], 0, "last Saturday 是过去时间标志，用过去式 played。", "选词填空"),
    ]

    /// 初一批次（45 道）：编号 `inj2-j1-*`。
    static let juniorOneBatch: [KnowledgePracticeQuestion] = [
        // j1-pronouns 主格 / 宾格
        q("inj2-j1-pronouns-1", "j1-pronouns", "This is my brother. ___ is a doctor.",
          ["Him", "His", "He", "Himself"], 2, "主语位置用主格 He。", "选词填空"),
        q("inj2-j1-pronouns-2", "j1-pronouns", "Please give the book to ___.",
          ["I", "my", "mine", "me"], 3, "介词 to 后面用宾格 me。", "选词填空"),

        // j1-there 就近原则 / 不可数名词
        q("inj2-j1-there-1", "j1-there", "There ___ a pen and two books on the desk.",
          ["are", "be", "have", "is"], 3, "There be 遵循就近原则，最靠近的是单数 a pen，用 is。", "选词填空"),
        q("inj2-j1-there-2", "j1-there", "There ___ some water in the bottle.",
          ["is", "are", "have", "has"], 0, "water 是不可数名词，按单数处理，用 is。", "选词填空"),

        // j1-count 量词 / much 修饰不可数
        q("inj2-j1-count-1", "j1-count", "I'd like two ___ of bread.",
          ["piece", "breads", "pieces", "bread"], 2, "bread 不可数，用数量词 piece；two 后面接复数 pieces。", "选词填空"),
        q("inj2-j1-count-2", "j1-count", "There isn't much ___ in the fridge.",
          ["apple", "apples", "eggs", "milk"], 3, "much 只能修饰不可数名词，四个选项中只有 milk 不可数。", "选词填空"),

        // j1-adverbs 形容词 vs 副词
        q("inj2-j1-adverbs-1", "j1-adverbs", "He is a ___ driver.",
          ["carefully", "care", "careful", "carefulness"], 2, "修饰名词 driver 要用形容词 careful。", "选词填空"),
        q("inj2-j1-adverbs-2", "j1-adverbs", "Please listen ___.",
          ["careful", "care", "careless", "carefully"], 3, "修饰动词 listen 要用副词 carefully。", "选词填空"),

        // j1-connectors 因果 / 选择
        q("inj2-j1-connectors-1", "j1-connectors", "It was raining, ___ we stayed at home.",
          ["and", "so", "but", "or"], 1, "前半句是原因、后半句是结果，用 so 连接。", "选词填空"),
        q("inj2-j1-connectors-2", "j1-connectors", "Would you like tea ___ coffee?",
          ["and", "but", "or", "so"], 2, "在两者之间选择用 or。", "选词填空"),

        // j1-prepositions 动词短语搭配
        q("inj2-j1-prepositions-1", "j1-prepositions", "I'm waiting ___ my friend at the gate.",
          ["at", "to", "with", "for"], 3, "wait for 是固定搭配，表示等待某人。", "选词填空"),
        q("inj2-j1-prepositions-2", "j1-prepositions", "Don't worry. I'll take care ___ your dog.",
          ["of", "for", "at", "with"], 0, "take care of 是固定搭配，表示照顾。", "选词填空"),

        // j1-quantifiers 可数与不可数
        q("inj2-j1-quantifiers-1", "j1-quantifiers", "There are too ___ cars on the road.",
          ["much", "many", "little", "a little"], 1, "cars 是可数名词复数，用 many。", "选词填空"),
        q("inj2-j1-quantifiers-2", "j1-quantifiers", "I have ___ money, so I can't buy the ticket.",
          ["few", "a few", "little", "a little"], 2, "money 不可数，表示「几乎没有」用 little。", "选词填空"),

        // j1-frequency-question 疑问词辨析
        q("inj2-j1-frequency-question-1", "j1-frequency-question", "— ___ do you watch TV? — Every evening.",
          ["How long", "How soon", "How far", "How often"], 3, "答语 Every evening 表示频率，所以问句用 How often。", "选词填空"),
        q("inj2-j1-frequency-question-2", "j1-frequency-question", "— ___ will the film begin? — In five minutes.",
          ["How soon", "How often", "How long", "How far"], 0, "In five minutes 表示「多久以后」，用 How soon 提问。", "选词填空"),

        // j1-invitation 接受 / 回应 Would you mind
        q("inj2-j1-invitation-1", "j1-invitation", "— Would you like some tea? — ___",
          ["Yes, please.", "Yes, I would like.", "No, I don't.", "Here you are."], 0, "接受对方提供的食物常用 Yes, please.。", "语境选择"),
        q("inj2-j1-invitation-2", "j1-invitation", "— Would you mind opening the window? — ___",
          ["Yes, please.", "Of course not.", "You're welcome.", "Never mind."], 1, "Would you mind ...? 回答「不介意」常用 Of course not.。", "语境选择"),

        // j1-thanks 道歉 / 感谢的回应
        q("inj2-j1-thanks-1", "j1-thanks", "— I'm sorry I'm late. — ___",
          ["You're welcome.", "Never mind.", "Thank you.", "That's right."], 1, "回应道歉常用 Never mind.，表示没关系。", "语境选择"),
        q("inj2-j1-thanks-2", "j1-thanks", "— Thank you for helping me. — ___",
          ["Never mind.", "I'm sorry.", "You're welcome.", "Yes, please."], 2, "回应感谢用 You're welcome.。", "语境选择"),

        // j1-shopping 尺码 / 表达购买意向
        q("inj2-j1-shopping-1", "j1-shopping", "— ___ do you want? — Size M, please.",
          ["How much", "How many", "What size", "What colour"], 2, "答语 Size M 说明对方在问尺码，用 What size。", "选词填空"),
        q("inj2-j1-shopping-2", "j1-shopping", "— Can I help you? — ___",
          ["Yes, I help you.", "You're welcome.", "Goodbye.", "I'd like a T-shirt, please."], 3, "购物时说明想买什么用 I'd like ...。", "语境选择"),

        // j1-possessive-pronoun 形容词性 / 名词性
        q("inj2-j1-possessive-pronoun-1", "j1-possessive-pronoun", "Is this ___ book, Tom?",
          ["you", "yours", "your", "yourself"], 2, "修饰名词 book 要用形容词性物主代词 your。", "选词填空"),
        q("inj2-j1-possessive-pronoun-2", "j1-possessive-pronoun", "The red bag is ___ , not mine.",
          ["her", "she", "herself", "hers"], 3, "后面不接名词、单独使用，要用名词性物主代词 hers。", "选词填空"),

        // j1-reflexive
        q("inj2-j1-reflexive-1", "j1-reflexive", "I made this cake ___.",
          ["me", "my", "mine", "myself"], 3, "主语是 I，对应的反身代词是 myself。", "选词填空"),
        q("inj2-j1-reflexive-2", "j1-reflexive", "The little boy can dress ___ now.",
          ["himself", "he", "him", "his"], 0, "dress oneself 表示自己穿衣服，主语是 he，用 himself。", "选词填空"),

        // j1-exclamatory 形容词 / 名词短语
        q("inj2-j1-exclamatory-1", "j1-exclamatory", "___ beautiful the flowers are!",
          ["What", "What a", "How", "How a"], 2, "感叹的中心词是形容词 beautiful，用 How。", "选词填空"),
        q("inj2-j1-exclamatory-2", "j1-exclamatory", "___ interesting book it is!",
          ["What", "What a", "How", "What an"], 3, "感叹可数名词单数，且 interesting 以元音音素开头，用 What an。", "选词填空"),

        // j1-imperative-rules 规则 / must 的否定回答
        q("inj2-j1-imperative-rules-1", "j1-imperative-rules", "We ___ wear a uniform at school. It's a school rule.",
          ["must", "can", "may", "need"], 0, "表示必须遵守的规则用 must。", "选词填空"),
        q("inj2-j1-imperative-rules-2", "j1-imperative-rules", "— Must I finish it now? — No, you ___.",
          ["mustn't", "needn't", "can't", "shouldn't"], 1, "Must 开头的一般疑问句，否定回答用 needn't，表示「不必」。", "选词填空"),

        // j1-infinitive-purpose 表目的
        q("inj2-j1-infinitive-purpose-1", "j1-infinitive-purpose", "He went to the shop ___ some milk.",
          ["buy", "to buy", "buying", "bought"], 1, "to buy 说明去商店的目的，用动词不定式表目的。", "选词填空"),
        q("inj2-j1-infinitive-purpose-2", "j1-infinitive-purpose", "We use a dictionary ___ new words.",
          ["look up", "looking up", "to look up", "looked up"], 2, "to look up 表示使用词典的目的或用途。", "选词填空"),

        // j1-reading-detail 细节定位策略
        q("inj2-j1-reading-detail-1", "j1-reading-detail", "做细节题时，最可靠的做法是：",
          ["根据题干关键词回原文找依据", "凭印象直接作答", "选读起来最顺的选项", "选最长的选项"], 0, "细节题必须在原文找到对应依据，不能凭感觉。", "策略"),
        q("inj2-j1-reading-detail-2", "j1-reading-detail", "原文写 “The library opens at 8:30 a.m.”，题目问图书馆的开放时间。答案应来自：",
          ["自己的猜测", "原文这一句", "别处的常识", "选项的长短"], 1, "细节题的答案要在原文对应句中找到。", "策略"),

        // j1-listening-keywords 时间听辨 / 最小对立词
        q("inj2-j1-listening-keywords-1", "j1-listening-keywords", "听到 “The meeting starts at a quarter to nine.”，会议开始的时间是：",
          ["9:15", "8:45", "9:45", "8:15"], 1, "a quarter to nine 是「九点差一刻」，即 8:45。", "理解"),
        q("inj2-j1-listening-keywords-2", "j1-listening-keywords", "听力中 thirteen 和 thirty 容易混淆，区分的关键是：",
          ["两个词完全同音", "只看语调高低", "重音位置不同", "只能靠猜"], 2, "thirteen 重音在 -teen，thirty 重音在词首 thir-。", "策略"),

        // j1-prep 具体某一天
        q("inj2-j1-prep-1", "j1-prep", "My birthday is ___ October 1st.",
          ["in", "at", "on", "for"], 2, "具体到某一天用介词 on。", "选词填空"),

        // j1-frequency 频率副词
        q("inj2-j1-frequency-1", "j1-frequency", "She ___ goes to bed before ten. It happens every night.",
          ["sometimes", "always", "never", "hardly"], 1, "每晚都发生表示频率为 100%，用 always。", "选词填空"),

        // j1-sentence 基本句型
        q("inj2-j1-sentence-1", "j1-sentence", "She opened the window. 这个句子属于哪种基本句型？",
          ["主谓", "主系表", "主谓双宾", "主谓宾"], 3, "She 是主语，opened 是及物动词，the window 是宾语，属主谓宾结构。", "识别"),

        // j1-whose 疑问代词
        q("inj2-j1-whose-1", "j1-whose", "___ kind of music do you like?",
          ["What", "Which", "Whose", "Who"], 0, "What kind of ... 用来询问种类。", "选词填空"),

        // j1-frequency-count 次数表达
        q("inj2-j1-frequency-count-1", "j1-frequency-count", "I visit my grandparents three ___ a month.",
          ["time", "times", "timing", "timed"], 1, "表示次数用 three times。", "选词填空"),

        // j1-there-transform 特殊疑问句转换
        q("inj2-j1-there-transform-1", "j1-there-transform", "对 “There are twenty students in the class.” 中的 twenty 提问，正确的是：",
          ["How much students are there in the class?", "How many students are there in the class?", "How many students there are in the class?", "What many students are there?"], 1, "对数量提问用 How many + 复数名词，并保持 are there 的疑问语序。", "句型转换"),

        // j1-spelling-rules 三单变化
        q("inj2-j1-spelling-rules-1", "j1-spelling-rules", "play 的第三人称单数形式是：",
          ["plays", "plaies", "playes", "play"], 0, "元音字母 + y 结尾的动词直接加 -s，即 plays。", "识别"),

        // j1-indefinite 不定代词
        q("inj2-j1-indefinite-1", "j1-indefinite", "There is ___ wrong with my bike. It doesn't work.",
          ["anything", "everything", "something", "nothing"], 2, "肯定句中表示「某事物」用 something。", "选词填空"),

        // j1-ordinal-date 日期表达
        q("inj2-j1-ordinal-date-1", "j1-ordinal-date", "— What's the date today? — It's ___.",
          ["the first May", "May one", "first of the May", "May the first"], 3, "日期表达为「月份 + the + 序数词」，即 May the first。", "选词填空"),
    ]

    /// 初二批次（45 道）：编号 `inj2-j2-*`。
    static let juniorTwoBatch: [KnowledgePracticeQuestion] = [
        // j2-infinitive
        q("inj2-j2-infinitive-1", "j2-infinitive", "My father wants ___ a new car.",
          ["to buy", "buy", "buying", "bought"], 0, "want to do 是固定搭配，故用动词不定式 to buy。", "选词填空"),
        q("inj2-j2-infinitive-2", "j2-infinitive", "It's important ___ English every day.",
          ["practise", "to practise", "practising", "practised"], 1, "It is + 形容词 + to do 结构中用不定式，故填 to practise。", "选词填空"),

        // j2-gerund 介词后接动名词
        q("inj2-j2-gerund-1", "j2-gerund", "Thank you for ___ me.",
          ["help", "helping", "to help", "helped"], 1, "介词 for 后面接动名词 helping。", "选词填空"),
        q("inj2-j2-gerund-2", "j2-gerund", "He is good at ___ football.",
          ["play", "to play", "playing", "played"], 2, "be good at 里的 at 是介词，后面接动名词 playing。", "选词填空"),

        // j2-conditional 主将从现
        q("inj2-j2-conditional-1", "j2-conditional", "If you ___ hard, you will pass the exam.",
          ["works", "will work", "worked", "work"], 3, "if 条件状语从句用一般现在时表示将来：主语 you 用动词原形 work，主句才用 will。", "选词填空"),
        q("inj2-j2-conditional-2", "j2-conditional", "I will call you if I ___ the news.",
          ["get", "gets", "will get", "got"], 0, "条件从句中不用 will，用一般现在时 get。", "选词填空"),

        // j2-linking 系动词 + 形容词 / 系动词不用被动
        q("inj2-j2-linking-1", "j2-linking", "The music sounds ___.",
          ["beautiful", "beautifully", "beauty", "beautify"], 0, "sound 是系动词，后面接形容词作表语；beautiful 是形容词，beautifully 才是副词。", "选词填空"),
        q("inj2-j2-linking-2", "j2-linking", "— How does the soup taste? — It ___ delicious.",
          ["is tasted", "tastes", "tasting", "taste"], 1, "taste 是系动词，不用被动语态；主语 It 是第三人称单数，用 tastes。", "选词填空"),

        // j2-health
        q("inj2-j2-health-1", "j2-health", "— I have a bad cold. — ___",
          ["You should eat more ice cream.", "You must run five kilometres now.", "You needn't see a doctor at all.", "You should drink more water and have a rest."], 3, "感冒时应多喝水、多休息，其余建议都不合理。", "语境选择"),
        q("inj2-j2-health-2", "j2-health", "To keep healthy, we should ___ every day.",
          ["do exercise", "eat junk food", "stay up late", "drink no water"], 0, "保持健康应每天锻炼，故选 do exercise。", "语境选择"),

        // j2-frequency 过去进行时
        q("inj2-j2-frequency-1", "j2-frequency", "At eight last night, they ___ TV.",
          ["watch", "watched", "were watching", "are watching"], 2, "表示过去某一时刻正在进行，主语 they 用 were + doing，即 were watching。", "选词填空"),
        q("inj2-j2-frequency-2", "j2-frequency", "While I ___ my homework, the phone rang.",
          ["do", "did", "am doing", "was doing"], 3, "while 从句表示另一动作发生时正在进行的动作，用过去进行时 was doing。", "选词填空"),

        // j2-cause 原因 / 结果
        q("inj2-j2-cause-1", "j2-cause", "___ he was ill, he didn't go to school.",
          ["So", "But", "Or", "Because"], 3, "从句说明原因，用 Because 引导原因状语从句。", "选词填空"),
        q("inj2-j2-cause-2", "j2-cause", "The road was closed. ___, we had to take another way.",
          ["As a result", "Although", "In addition", "For example"], 0, "前句是原因、后句是结果，用 As a result 衔接。", "语境选择"),

        // j2-relative-basic 人 / 物
        q("inj2-j2-relative-basic-1", "j2-relative-basic", "The girl ___ is singing is my sister.",
          ["which", "where", "whose", "who"], 3, "先行词 the girl 指人，关系代词用 who。", "选词填空"),
        q("inj2-j2-relative-basic-2", "j2-relative-basic", "I like the book ___ has a red cover.",
          ["which", "who", "whose", "whom"], 0, "先行词 the book 指物，关系代词用 which。", "选词填空"),

        // j2-voice 被动语态
        q("inj2-j2-voice-1", "j2-voice", "The bridge ___ ten years ago.",
          ["was built", "builds", "built", "is building"], 0, "桥是被建造的，过去时被动语态为 was + 过去分词 built。", "选词填空"),
        q("inj2-j2-voice-2", "j2-voice", "The classroom ___ every day.",
          ["cleans", "is cleaned", "cleaned", "is cleaning"], 1, "教室是被打扫的，一般现在时被动语态为 is + 过去分词 cleaned。", "选词填空"),

        // j2-travel
        q("inj2-j2-travel-1", "j2-travel", "— ___ does the flight take? — About three hours.",
          ["How long", "How often", "How far", "How much"], 0, "答语 About three hours 表示时长，用 How long 提问。", "选词填空"),
        q("inj2-j2-travel-2", "j2-travel", "想询问车票价格，正确的问法是：",
          ["How many is the ticket?", "How much is the ticket?", "How long is the ticket?", "What money is the ticket?"], 1, "询问价格用 How much。", "语境选择"),

        // j2-telephone
        q("inj2-j2-telephone-1", "j2-telephone", "— Hello, may I speak to Kate? — ___",
          ["Yes, I'm Kate's.", "Hold on, please.", "Speaking to me.", "You're welcome."], 1, "需要请对方稍等或去叫人时用 Hold on, please.。", "语境选择"),
        q("inj2-j2-telephone-2", "j2-telephone", "— Can I take a message? — ___",
          ["No, I don't like it.", "Yes, I'm fine.", "Yes, please tell her to call me back.", "Hold the line forever."], 2, "留言时应说明要转达的具体内容。", "语境选择"),

        // j2-preposition-time since / during
        q("inj2-j2-preposition-time-1", "j2-preposition-time", "I have lived here ___ 2019.",
          ["for", "in", "during", "since"], 3, "since 后接时间点，表示「从那时起」；for 后接时间段。", "选词填空"),
        q("inj2-j2-preposition-time-2", "j2-preposition-time", "Don't talk ___ the class.",
          ["during", "for", "since", "from"], 0, "during 表示「在……期间」。", "选词填空"),

        // j2-question-forms 反意 + 交通方式
        q("inj2-j2-question-forms-1", "j2-question-forms", "— You don't like coffee, ___? — No, I don't.",
          ["don't you", "do you", "are you", "aren't you"], 1, "前句是否定，反意部分用肯定形式 do you。", "选词填空"),
        q("inj2-j2-question-forms-2", "j2-question-forms", "— ___ do you go to school, by bus or by bike? — By bike.",
          ["What", "Which", "How", "Why"], 2, "询问交通方式用 How。", "选词填空"),

        // j2-social 答应 / 委婉拒绝
        q("inj2-j2-social-1", "j2-social", "— Could you please open the door? — ___",
          ["Yes, I could.", "Never mind.", "Sure, no problem.", "Here you are."], 2, "答应请求常用 Sure, no problem.。", "语境选择"),
        q("inj2-j2-social-2", "j2-social", "— Would you like to go with us? — ___",
          ["Yes, I would like.", "No, I don't go.", "I'm fine, thank you.", "I'm afraid I can't. I have to study."], 3, "委婉拒绝用 I'm afraid I can't.，并说明原因。", "语境选择"),

        // j2-too-enough
        q("inj2-j2-too-enough-1", "j2-too-enough", "The box is ___ heavy for me to carry.",
          ["enough", "too", "very", "so"], 1, "too + 形容词 + for sb. to do 表示「太……而不能」。", "选词填空"),
        q("inj2-j2-too-enough-2", "j2-too-enough", "The shoes are big ___ for me.",
          ["too", "very", "enough", "so"], 2, "形容词 + enough 表示「足够……」。", "选词填空"),

        // j2-both-either
        q("inj2-j2-both-either-1", "j2-both-either", "I have two sisters. ___ of them are teachers.",
          ["Both", "Either", "Neither", "All"], 0, "两者都……用 Both，后面的谓语用复数 are。", "选词填空"),
        q("inj2-j2-both-either-2", "j2-both-either", "You can take ___ of the two books. They are both interesting.",
          ["both", "either", "neither", "all"], 1, "两者中任取一个用 either。", "选词填空"),

        // j2-reading-structure
        q("inj2-j2-reading-structure-1", "j2-reading-structure", "一篇介绍熊猫的说明文，先说外形，再说食物，最后说栖息地。这种结构是：",
          ["因果链", "问题—解决", "时间顺序", "并列展开"], 3, "从不同方面依次介绍同一对象，属于并列展开。", "理解"),
        q("inj2-j2-reading-structure-2", "j2-reading-structure", "记叙文按「早晨—中午—晚上」的顺序展开，这属于：",
          ["时间顺序", "空间顺序", "因果顺序", "总分结构"], 0, "按时间推进来组织内容是时间顺序。", "理解"),

        // j2-listening-intent
        q("inj2-j2-listening-intent-1", "j2-listening-intent", "— Why don't we go for a walk? — That's a good idea. 说话人是在：",
          ["提出建议", "表达不满", "拒绝邀请", "请求帮助"], 0, "Why don't we ...? 用来提出建议，答语表示赞同。", "理解"),
        q("inj2-j2-listening-intent-2", "j2-listening-intent", "— It's really cold in here. — I'll close the window. 第二个人表达的是：",
          ["拒绝对方的请求", "主动去做对方暗示的事", "抱怨天气太冷", "邀请对方外出"], 1, "用 I'll do ... 回应对方的暗示，即主动去做对方暗示的事。", "理解"),

        // j2-reading 代词指代
        q("inj2-j2-reading-1", "j2-reading", "Tom bought a new bike. ___ is blue and very fast.",
          ["He", "They", "It", "She"], 2, "用代词指代前句中的 a new bike（物），用 It。", "选词填空"),

        // j2-object 介词提前
        q("inj2-j2-object-1", "j2-object", "Please pass the salt ___.",
          ["me", "to me", "for me", "at me"], 1, "把物提前时用 pass sth. to sb. 的结构。", "选词填空"),

        // j2-passages 段落主旨
        q("inj2-j2-passages-1", "j2-passages", "短文写道：“The club meets every Friday. Members do experiments and share ideas. Last month they built a small robot.” 这段主要介绍的是：",
          ["一位学生的一天", "机器人的发展历史", "学校的课程表", "一个科学社团的活动"], 3, "三句话都围绕科学社团的活动展开，主旨应覆盖全部句子。", "理解"),

        // j2-articles 零冠词
        q("inj2-j2-articles-1", "j2-articles", "I like ___ history best.",
          ["a", "an", "无需冠词", "the"], 2, "学科名称前一般不加冠词，故 history 前无需冠词。", "选词填空"),

        // j2-question-tags
        q("inj2-j2-question-tags-1", "j2-question-tags", "Tom can swim, ___?",
          ["can't he", "can he", "does he", "doesn't he"], 0, "前肯后否，用情态动词 can 的否定形式 can't he。", "选词填空"),

        // j2-adjectives 比较级
        q("inj2-j2-adjectives-1", "j2-adjectives", "This book is ___ than that one.",
          ["more interesting", "interesting", "most interesting", "the most interesting"], 0, "多音节形容词的比较级用 more + 原级，后面接 than，故用 more interesting。", "选词填空"),

        // j2-future-plan 迹象预测
        q("inj2-j2-future-plan-1", "j2-future-plan", "Look at those black clouds! It ___ rain.",
          ["was going to", "goes to", "went to", "is going to"], 3, "根据眼前迹象作预测用 be going to，主语 It 用 is going to。", "选词填空"),

        // j2-direct-speech 直接引语改间接引语
        q("inj2-j2-direct-speech-1", "j2-direct-speech", "他说：“I am ready.” 改为间接引语，正确的一项是：",
          ["He said that I am ready.", "He said that he was ready.", "He says that he is ready.", "He said that he is ready."], 1, "主句是过去时，间接引语的人称和时态要相应变化：I → he，am → was。", "句型转换"),

        // j2-exclamation
        q("inj2-j2-exclamation-1", "j2-exclamation", "___ fast the boy runs!",
          ["What", "What a", "How", "How a"], 2, "感叹的中心词是副词 fast，用 How。", "选词填空"),
    ]

    /// 初三批次（21 道）：编号 `inj2-j3-*`。
    static let juniorThreeBatch: [KnowledgePracticeQuestion] = [
        // j3-synonyms
        q("inj2-j3-synonyms-1", "j3-synonyms", "原文写 “The task was tough.”，题干用 difficult。tough 与 difficult 的关系是：",
          ["意思相反", "近义替换", "毫无关系", "拼写相近"], 1, "tough 与 difficult 都表示「困难的」，属于同义替换。", "理解"),
        q("inj2-j3-synonyms-2", "j3-synonyms", "原文写 “He gave up smoking.”，题干写 “He stopped smoking.”。这类题考查的是：",
          ["数字计算", "词性判断", "同义替换的识别", "时态呼应"], 2, "give up 与 stop 同义，题干换一种表达复现原文的意思。", "理解"),

        // j3-narrative
        q("inj2-j3-narrative-1", "j3-narrative", "记叙文中 “Suddenly, a strong wind blew the door open.” 这一句最可能出现在：",
          ["开头介绍人物时", "结尾总结道理时", "冲突或转折处", "文章标题中"], 2, "suddenly 引出突发变化，常用来推动情节转折。", "理解"),
        q("inj2-j3-narrative-2", "j3-narrative", "记叙文六要素中，story 的 “why” 对应的是：",
          ["人物的名字", "故事发生的时间", "故事的结尾", "事情的起因"], 3, "六要素 who / what / when / where / why / how 中，why 指事情的起因。", "理解"),

        // j3-reading-attitude
        q("inj2-j3-reading-attitude-1", "j3-reading-attitude", "作者写道：“The plan sounds good, but it may bring new problems.” 作者的态度是：",
          ["完全支持", "强烈反对", "毫不关心", "客观审慎"], 3, "先承认优点、再指出可能的问题，属于客观审慎。", "理解"),
        q("inj2-j3-reading-attitude-2", "j3-reading-attitude", "作者写道：“What a wonderful idea! It will certainly change our life.” 作者的态度是：",
          ["热情支持", "客观中立", "怀疑保留", "讽刺挖苦"], 0, "wonderful、certainly 等评价词表现出热情支持。", "理解"),

        // j3-reading-title
        q("inj2-j3-reading-title-1", "j3-reading-title", "短文讲 “a boy learns to cook to help his busy mother”。最合适的标题是：",
          ["How to Cook Well", "Busy Mothers in China", "A Boy's Kitchen Help", "The Best Food in Town"], 2, "标题要同时覆盖人物与核心事件，既不过宽也不过窄。", "理解"),
        q("inj2-j3-reading-title-2", "j3-reading-title", "选标题时，应当避免下面哪一类选项？",
          ["能概括全文主旨的", "用词简洁的", "与主题相关的", "只覆盖文中某一个细节的"], 3, "只覆盖个别细节的标题无法概括全文。", "策略"),

        // j3-writing-cohesion
        q("inj2-j3-writing-cohesion-1", "j3-writing-cohesion", "要避免 “Tom is my friend. Tom is good at maths.” 的重复，更好的写法是：",
          ["Tom is my friend. Tom is good at maths.", "Tom is my friend, Tom good at maths.", "Tom is my friend and Tom good at maths.", "Tom is my friend. He is good at maths."], 3, "第二次提到 Tom 用代词 He 代替，避免重复。", "应用"),
        q("inj2-j3-writing-cohesion-2", "j3-writing-cohesion", "表示递进关系，最合适的连接词是：",
          ["Besides", "However", "Therefore", "Instead"], 0, "Besides 表示「此外」，用来补充递进。", "选词填空"),

        // j3-writing-check
        q("inj2-j3-writing-check-1", "j3-writing-check", "“He go to school by bus every day.” 这句话的错误是：",
          ["拼写错误", "时态错误，应用过去式", "介词错误", "主谓不一致，应用 goes"], 3, "主语 He 是第三人称单数，一般现在时的动词应为 goes。", "辨错"),
        q("inj2-j3-writing-check-2", "j3-writing-check", "检查作文时，下面哪一项不属于语言检查的重点？",
          ["段落的排版颜色", "时态是否一致", "主谓是否一致", "拼写与标点"], 0, "时态、主谓一致、拼写标点是语言检查的重点；排版颜色与语言正确性无关。", "策略"),

        // j3-writing
        q("inj2-j3-writing-1", "j3-writing", "写一段提出建议的短文，结尾最合适的句子是：",
          ["Once upon a time ...", "See you tomorrow.", "I hope these suggestions are helpful.", "Turn left at the corner."], 2, "建议类短文结尾常呼应主题，表达希望建议有帮助。", "应用"),

        // j3-indirect 陈述语序
        q("inj2-j3-indirect-1", "j3-indirect", "把 “Where does he live?” 变成宾语从句：Do you know ___ ?",
          ["where does he live", "where he live", "where did he lives", "where he lives"], 3, "宾语从句要用陈述语序，主语 he 后接第三人称单数形式，即 where he lives。", "句型转换"),

        // j3-speech 场景预测
        q("inj2-j3-speech-1", "j3-speech", "听到 “Could you check in this bag for me, and when will we board?” 最可能发生在：",
          ["学校", "医院", "邮局", "机场"], 3, "check in 与 board（登机）都是机场场景的常用表达。", "理解"),

        // j3-subjunctive 虚拟语气
        q("inj2-j3-subjunctive-1", "j3-subjunctive", "If I ___ you, I would take the doctor's advice.",
          ["am", "was", "were", "will be"], 2, "与现在事实相反的虚拟条件句中，be 动词一律用 were。", "选词填空"),

        // j3-inversion 强调句
        q("inj2-j3-inversion-1", "j3-inversion", "It was in the park ___ I met my old friend.",
          ["that", "which", "where", "what"], 0, "强调句为 It was + 被强调部分 + that + 其余部分。", "选词填空"),

        // j3-notice
        q("inj2-j3-notice-1", "j3-notice", "写一则活动通知，正文中必须交代清楚的要素是：",
          ["作者的血型", "昨天的天气", "时间、地点和联系方式", "故事的结局"], 2, "通知要交代清楚时间、地点、对象和联系方式等实际信息。", "应用"),

        // j3-argument
        q("inj2-j3-argument-1", "j3-argument", "议论文中 “For example, ...” 之后通常紧接：",
          ["一个全新的观点", "支撑观点的具体例子", "全文总结", "相反结论"], 1, "For example 引出例子，用来支撑前面提出的观点。", "理解"),

        // j3-ellipsis
        q("inj2-j3-ellipsis-1", "j3-ellipsis", "— I didn't go to the party. — Me ___.（表示「我也没去」）",
          ["too", "neither", "either", "also"], 1, "Me neither. 表示「我也不」，与前句的否定保持一致。", "选词填空"),

        // j3-listening-inference
        q("inj2-j3-listening-inference-1", "j3-listening-inference", "听到 “W: Would you like another cup of tea? M: I've already had three.” 男士的意思是：",
          ["他不想再喝了", "他还想再喝一杯", "他不喜欢喝茶", "他一共要喝三杯"], 0, "已经喝了三杯，暗示委婉拒绝再来一杯。", "理解"),
    ]

    /// 第二轮注入的全部题目（151 道）。
    static let all: [KnowledgePracticeQuestion] = primaryBatch + juniorOneBatch + juniorTwoBatch + juniorThreeBatch

    private static func q(_ id: String, _ point: String, _ prompt: String,
                          _ options: [String], _ answer: Int,
                          _ explanation: String, _ kind: String) -> KnowledgePracticeQuestion {
        KnowledgePracticeQuestion(id: id, knowledgePointID: point, prompt: prompt,
                                  options: options, answer: answer,
                                  explanation: explanation, kind: kind)
    }
}
