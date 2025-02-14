local L = LibStub("AceLocale-3.0"):NewLocale("KHMRaidFrames", "zhCN", false)

if not L then return end

L["TOPLEFT"] = "左上"
L["LEFT"] = "左"
L["BOTTOMLEFT"] = "左下"
L["BOTTOM"] = "下"
L["BOTTOMRIGHT"] = "右下"
L["RIGHT"] = "右"
L["TOPRIGHT"] = "右上"
L["TOP"] = "上"
L["CENTER"] = "中"
L["KHMRaidFrames"] = "KHMRaidFrames"
L["Raid"] = "团队"
L["Buffs"] = "增益"
L["Num"] = "数量"
L["Size"] = "尺寸"
L["X Offset"] = "X 偏移"
L["Y Offset"] = "Y 偏移"
L["Grow Direction"] = "增长方向"
L["Debuffs"] = "减益"
L["Party"] = "小队"
L["Dispell Debuffs"] = "可驱散减益"
L["Anchor Point"] = "锚点"
L["Texture"] = "材质"
L["Hide Group Title"] = "隐藏小队标题"
L["Width"] = "宽度"
L["Height"] = "高度"
L["General"] = "常规"
L["Reset to Default"] = "重置为默认值"
L["Profiles"] = "配置"
L["Show\\Hide Test Frames"] = "显示或隐藏测试框体"
L["Glow Type"] = "高亮方式"
L["Color"] = "颜色"
L["Frequency"] = "透明度"
L["Glows"] = "高亮"
L["Enable"] = "启用"
L["Thickness"] = "厚度"
L["Border"] = "边框"
L["Tracking"] = "?追踪?"
L["Exclude"] = "排除"
L["Num In Row"] = "每行数量"
L["Rows Grow Direction"] = "横向增长方向"
L["Rejuvenation"] = "回春术"
L["Wildcards"] = "Wildcards"  -- 应该不是通配符，没法确定
L["-- Comments"] = "-- 注释"
L["Track auras"] = "追踪光环\n\n刷新任意光环可以应用设置，或者 /reload 重载界面。\n\n"
L["Exclude auras"] = "排除光环\n\n刷新任意光环可以应用设置，或者 /reload 重载界面。\n\n"
L["Block List"] = "黑名单"
L["Raid Icon"] = "团队标记"
L["Auras"] = "光环"
L["Aura Glow"] = "光环高亮"
L["Frame Glow"] = "框体高亮"
L["Use Default Colors"] = "使用默认颜色"
L["Exclude auras from Glows"] = "排除高亮的光环。\n\n刷新任意光环可以应用设置，或者 /reload 重载界面。\n\n"
L["Default Colors"] = "默认颜色"
L["Poison"] = "毒药"
L["Magic"] = "魔法"
L["Disease"] = "疾病"
L["Curse"] = "诅咒"
L["Physical"] = "物理（流血）"
L["Click Through Auras"] = "光环点击穿透"
L["Show Big Debuffs"] = "显示更大的减益图标"
L["Additional Auras Tracking"] = "额外光环追踪"
L["Track Auras that are not shown by default by Blizzard"] = "监控不在暴雪白名单中的光环。\n\n刷新任意光环可以应用设置，或者 /reload 重载界面。\n\n"
L["Big Debuffs"] = "大减益图标"	-- Should use on options, but now options and describe are both L["Show Big Debuffs"]
L["Enhanced Absorbs"] = "启用吸收盾"
L["UI will be reloaded to apply settings"] = "重载界面以应用设置。"
L["Always Show Party Frame"] = "总是显示框体"
L["Align Big Debuffs"] = "贴齐大图标"
L["You are in |cFFC80000<text>|r"] = "你目前在|cFFC80000<text>|r中"
L["Copy settings to |cFFffd100<text>|r"] = "复置配置到|cFFffd100<text>|r"
L["Raid settings"] = "团队设置"
L["Party settings"] = "小队设置"
L["Glows settings"] = "高亮设置"
L["Glow effect options for your Buffs and Debuffs"] = "光环高亮选项"
L["Glow effect options for your Frames"] = "框体高亮选项"
L["General options"] = "常规设置"
L["Dispell Debuffs options"] = "可驱散减益设置"
L["Raid Icon options"] = "团队标记设置"
L["Click Through Auras Desc"] = "移除指向光环时显示的鼠标提示。"
L["Enhanced Absorbs Desc"] = "总是显示吸收量。\n\n默认情况下，吸收数值以该材质在血量条上的比例来呈现，但在满血时只会在框体最右侧显示一条发亮材质。启用此选项能在满血时仍显示具体的比例。"
L["Always Show Party Frame Desc"] = "总是显示小队框体，即使你不在队伍中。"
L["Align Big Debuffs Desc"] = "将其他减益图标和大图标贴齐，并排显示。"
L["Name and Icons"] = "文字与图标"
L["Name and Icons options"] = "文字与图标选项"
L["Name"] = "名字"
L["Name Options"] = "名字选项"
L["Font"] = "字体"	-- two same string
L["Flags"] = "字体描边"
L["Name Options"] = "名字选项"
L["Font"] = "字体"	-- two same string
L["Flags"] = "描边"
L["None"] = "无"
L["OUTLINE"] = "细描边"
L["THICKOUTLINE"] = "粗描边"
L["MONOCHROME"] = "点阵字描边"
L["Status Text"] = "血量（状态）"
L["Status Text Options"] = "血量和状态文字（离线、死亡等）"
L["Show Server"] = "显示服务器"
L["Horizontal Justify"] = "水平对齐"
L["Role Icon"] = "职责标记"
L["Role Icon Options"] = "职责标记选项"
L["Custom Textures"] = "自定义材质"
L["Custom Textures desc"] = "需要重载界面才能应用设置。"
L["Custom Texture Options"] = "自定义材质的路径。\n\n例如：\n\nInterface\\AddOns\\KHMRaidFrames\\ \nIcons\\lyn-dps"
L["Healer"] = "治疗"
L["Damager"] = "伤害输出"
L["Tank"] = "坦克"
L["Vehicle"] = "载具"
L["Ready"] = "准备好了"
L["Not Ready"] = "还没准备好"
L["Waiting"] = "等待中"
L["Ready Check Icon"] = "就位确认图标"
L["Ready Check Icon Options"] = "就位确认选项"
L["Center Status Icon"] = "中央状态图标"
L["Center Status Icon Options"] = "中央状态图标选项（召唤、异位面、复活等）"
L["In Other Group"] = "在别的队伍"
L["Has Icoming Ressurection"] = "正在复活"
L["Incoming Summon Pending"] = "正在召唤"
L["Incoming Summon Accepted"] = "正在接受召唤"
L["Incoming Summon Declined"] = "正在拒绝召唤"
L["In Other Phase"] = "在别的位面"
L["Class Colored Names"] = "名字职业染色"
L["Class Colored Names desc"] = "以职业染色玩家名字"
L["Enable Masque Support"] = "Masque 美化"
L["Enable Masque Support Desc"] = "启用 Masque 美化，实验性功能。"
L["Show\\Hide Test Frames desc"] = "一个可供预览，用于调整光环设置的测试框架。注意：测试框架不显示高亮和 Masque 美化等额外效果的预览。"
L["Masque Reskin"] = "Masque 外观"
L["AdditionalTrackingHelpText"] = "你可以根据单位来过滤光环。例如："..
                                    "\n    回春术|cFFC80000::|r|cFFFFFFFFplayer|r"
L["Export Profile"] = "导出配置"
L["Import Profile"] = "导入配置"
L["Are You sure?"] = "你确定？"
L["Transparency"] = "透明度"
L["Sync Profiles"] = "|cFFffd100Sync Profiles|r"
L["Sync Profiles Desc"] = "Автоматически переключать профиль на соответствующй в настройках \"Профили Рейда\""
L["KHM Profile Stuff"] = "KHM Profile Stuff"
L["Profile: |cFFC80000<text>|r"] = "配置档：|cFFC80000<text>|r"
L["Abbreviate Large Numbers"] = "大数值缩写"	-- didn't use?
L["Abbreviate Numbers"] = "数值缩写"	-- didn't use?
L["Abbreviate"] = "缩写"
L["Abbreviate Desc"] = "100 -> 100"..
                        "\n1000 -> 1K"..
                        "\n1000000 -> 1M"
L["buffsAndDebuffs"] = "增益与减益"
L["Don\'t Show Status Text"] = "不显示状态文字"
L["Don\'t Show Status Text Desc"] = "只显示血量数值，不显示死亡、离线等状态文字。"
L["Leader Icon"] = "队长图标"
L["Leader Icon Options"] = "队长图标选项"
L["Leader Icon Texture"] = "队长图标材质"
L["Precision"] = "精确格式"
L["Show Percents"] = "显示百分比"
L["Formatting"] = "格式"
L["Class Colored Text"] = "文字职业染色"
L["Auto Scaling"] = "自动缩放"
L["Auto Scaling Desc"] = "下列元素将跟随默认设置自动缩放： \n|cFFffd100y增益光环|r，\n|cFFffd100减益光环|r，\n|cFFffd100就位确认图标|r，\n|cFFffd100状态文字|r，\n|cFFffd100中央状态图标|r。\n\n"..
                        "一些由插件提供的元素也会一起缩放：\n|cFFffd100团队标记|r，\n|cFFffd100队长标记|r，\n|cFFffd100名字|r。"
L["Hide Element"] = "隐藏元素"
L["Show Resource Only For Healers"] = "只显示治疗者的资源"
L["Show Resource Only For Healers Desc"] = "要调整此选项，请务必启用暴雪团队框体设置的“显示能量条”。"
L["Power Bar Height"] = "高度"
L["Power Bar"] = "能量条"
L["Power Bar Texture"] = "材质"
L["Healthbar"] = "血量条"
L["Healthbar Color"] = "血量条颜色"
L["Healthbar Color Desc"] = "要调整此选项，请务必禁用暴雪团队框体设置的“显示职业颜色”。"
L["Healthbar Background Color"] = "血量条背景颜色"
L["Background Color"] = "背景颜色"
L["Background Transparency"] = "背景透明度"
L["Power Bar Transparency"] = "能量条背景透明度"
L["Advanced Transparency"] = "进阶透明度"	-- didn't use?
L["Health Transparency"] = "血量条透明度"	-- didn't use?
L["Health Background Transparency"] = "血量条背景透明度"	-- didn't use?
L["Textures & Frames"] = "材质与框体"
L["Dark"] = "暗"	-- didn't use?
L["Light"] = "亮"	-- didn't use?
L["Out of Range"] = "超出距离"	-- didn't use?