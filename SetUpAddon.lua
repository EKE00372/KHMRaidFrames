local KHMRaidFrames = LibStub("AceAddon-3.0"):GetAddon("KHMRaidFrames")
local L = LibStub("AceLocale-3.0"):GetLocale("KHMRaidFrames")

local _G, CompactRaidFrameContainer = _G, CompactRaidFrameContainer

-- SETUP
function KHMRaidFrames:OnInitialize()
     self:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED")
end

function KHMRaidFrames:Setup()
    local defaults_settings = self:Defaults()
    self.db = LibStub("AceDB-3.0"):New("KHMRaidFramesDB", defaults_settings)

    local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    local LibDualSpec = LibStub("LibDualSpec-1.0")
    LibDualSpec:EnhanceDatabase(self.db, "KHMRaidFrames")
    LibDualSpec:EnhanceOptions(profiles, self.db)

    self.config = LibStub("AceConfigRegistry-3.0")
    self.config:RegisterOptionsTable("KHMRaidFrames", self:SetupOptions())
    self.config:RegisterOptionsTable("KHM Profiles", profiles)
    self.config:RegisterOptionsTable("KHM Profile Stuff", self:SetupProfiles())

    self.dialog = LibStub("AceConfigDialog-3.0")
    self.dialog.general = self.dialog:AddToBlizOptions("KHMRaidFrames", L["KHMRaidFrames"])
    self.dialog.profiles = self.dialog:AddToBlizOptions("KHM Profiles", L["Profiles"], "KHMRaidFrames")
    self.dialog.stuff = self.dialog:AddToBlizOptions("KHM Profile Stuff", L["KHM Profile Stuff"], "KHMRaidFrames")

    self:SecureHookScript(self.dialog.general, "OnShow", "OnOptionShow")
    self:SecureHookScript(self.dialog.general, "OnHide", "OnOptionHide")

    self:RegisterChatCommand("khm", function()
        InterfaceOptionsFrame_OpenToCategory("KHMRaidFrames")
        InterfaceOptionsFrame_OpenToCategory("KHMRaidFrames")
    end)

    self:RegisterChatCommand("лрь", function()
        InterfaceOptionsFrame_OpenToCategory("KHMRaidFrames")
        InterfaceOptionsFrame_OpenToCategory("KHMRaidFrames")
    end)

    self:RegisterChatCommand("кд", function() ReloadUI() end)

    self:RegisterChatCommand("rl", function() ReloadUI() end)

    self:SetInternalVariables()
end

function KHMRaidFrames:SetInternalVariables()
    self.componentScale = 1

    self:GetRaidProfileSettings()

    self.isOpen = false

    self.maxFrames = 10
    self.virtual = {
        shown = false,
        frames = {},
        groupType = "raid",
    }
    self.aurasCache = {}
    self.processedFrames = {}
    self.glowingFrames = {
        auraGlow = {
            buffFrames = {},
            debuffFrames = {},
        },
        frameGlow = {
            buffFrames = {},
            debuffFrames = {},
        },
    }

    self.rolesCache = {}
    self.iconRolesCache = {}

    -- throttling refreshes
    self.refreshingSettings = false
    self.reloadingSettings = false
    self.profileThrottleSecs = 0.5
    self.refreshThrottleSecs = 0.1

    if self.db.profile.Masque then
        local Masque = LibStub("Masque", true)

        if Masque then
            self.Masque = {}
            self.Masque.buffFrames = Masque:Group("KHMRaidFrames", "Buff Auras")
            self.Masque.debuffFrames = Masque:Group("KHMRaidFrames", "Debuff Auras")
        end
    end

    self:GetVirtualFrames()

    self.textures, self.sortedTextures = self.GetTextures()
    self.fonts, self.sortedFonts = self.GetFons()
end
--

-- HOOKS
function KHMRaidFrames:COMPACT_UNIT_FRAME_PROFILES_LOADED()
    self:Setup()

    self.db.RegisterCallback(self, "OnProfileChanged", function(...) self:SafeRefresh() end)
    self.db.RegisterCallback(self, "OnProfileCopied", function(...) self:SafeRefresh() end)
    self.db.RegisterCallback(self, "OnProfileReset", function(...) self:SafeRefresh() end)

    self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
    self:RegisterEvent("PLAYER_ROLES_ASSIGNED", "OnEvent")
    self:RegisterEvent("RAID_TARGET_UPDATE", "OnEvent")
    self:RegisterEvent("PLAYER_TALENT_UPDATE", "OnEvent")

    self:SecureHook("CompactRaidFrameContainer_LayoutFrames")
    self:SecureHook("CompactUnitFrame_UpdateHealPrediction")
    self:SecureHook("CompactUnitFrame_UpdateAuras")

    self:HookNameAndIcons()

    -- custom interface display
    self:SecureHook(self.dialog, "FeedGroup", function() self:CustomizeOptions() end)

    self:SecureHook("CompactUnitFrameProfiles_ApplyProfile")

    self:SafeRefresh()
end

function KHMRaidFrames:OnEvent(event, ...)
    local groupType = IsInRaid() and "raid" or "party"

    if event == "PLAYER_REGEN_ENABLED" then
        if self.deffered then
            self:GetRaidProfileSettings()
            self:SafeRefresh()

            InterfaceOptionsFrame_OpenToCategory("KHMRaidFrames")
            InterfaceOptionsFrame_OpenToCategory("KHMRaidFrames")

            self.deffered = false
        end
    elseif event == "PLAYER_REGEN_DISABLED" and self.isOpen then
        self:HideAll()
        self.deffered = true
    elseif event == "RAID_TARGET_UPDATE" then
        self:UpdateRaidMark(groupType)
        self:CustomizeOptions()
    elseif event == "PLAYER_ROLES_ASSIGNED" then
        self:UpdateRaidMark(groupType)
        self:CustomizeOptions()
        self.UpdateLeaderIcon()
        self.UpdateResourceBars()
    elseif event == "PLAYER_TALENT_UPDATE" and not IsInGroup() then
        self.UpdateResourceBars()
    end
end

function KHMRaidFrames:HookNameAndIcons()
    local dbParty = self.db.profile.party.nameAndIcons
    local dbRaid = self.db.profile.raid.nameAndIcons

    if (dbParty.name.enabled or dbRaid.name.enabled) and not self:IsHooked("CompactUnitFrame_UpdateName") then
        self:SecureHook(
            "CompactUnitFrame_UpdateName",
            function(frame)
                if self.SkipFrame(frame) then return end

                self:SetUpNameInternal(frame, IsInRaid() and "raid" or "party")
            end
        )
    end

    if (dbParty.statusText.enabled or dbRaid.statusText.enabled) and not self:IsHooked("CompactUnitFrame_UpdateStatusText") then
        self:SecureHook(
            "CompactUnitFrame_UpdateStatusText",
            function(frame)
                if self.SkipFrame(frame) then return end

                self.SetUpStatusTextInternal(frame, IsInRaid() and "raid" or "party")
            end
        )
    end

    if (dbParty.roleIcon.enabled or dbRaid.roleIcon.enabled) and not self:IsHooked("CompactUnitFrame_UpdateRoleIcon") then
        self:SecureHook(
            "CompactUnitFrame_UpdateRoleIcon",
            function(frame)
                if self.SkipFrame(frame) then return end

            self:SetUpRoleIconInternal(frame, IsInRaid() and "raid" or "party")
         end
        )
    end

    if (dbParty.readyCheckIcon.enabled or dbRaid.readyCheckIcon.enabled) and not self:IsHooked("CompactUnitFrame_UpdateReadyCheck") then
        self:SecureHook(
            "CompactUnitFrame_UpdateReadyCheck",
            function(frame)
                if self.SkipFrame(frame) then return end

                self:SetUpReadyCheckIconInternal(frame, IsInRaid() and "raid" or "party")
            end
        )
    end

    if (dbParty.centerStatusIcon.enabled or dbRaid.centerStatusIcon.enabled) and not self:IsHooked("CompactUnitFrame_UpdateCenterStatusIcon") then
        self:SecureHook(
            "CompactUnitFrame_UpdateCenterStatusIcon",
            function(frame)
                if self.SkipFrame(frame) then return end

                self:SetUpCenterStatusIconInternal(frame, IsInRaid() and "raid" or "party")
            end
        )
    end
end
--

-- PROFILES
function KHMRaidFrames:CompactUnitFrameProfiles_ApplyProfile(profile)
    if self:GetRaidProfileSettings() then
        self.deffered = true
        return
    end

    self.processedFrames = {}

    if self.db:GetCurrentProfile() ~= profile then
        self.SyncProfiles(profile)
    end

    if not self.reloadingSettings then
        self.reloadingSettings = true
        C_Timer.After(self.profileThrottleSecs, function()
            self.ReloadSetting()
        end)
    end
end

function KHMRaidFrames.ReloadSetting()
    KHMRaidFrames.RevertResourceBar()
    KHMRaidFrames:SafeRefresh()
    KHMRaidFrames.reloadingSettings = false
end

function KHMRaidFrames:GetRaidProfileSettings(profile)
    if InCombatLockdown() then return true end

    profile = profile or GetActiveRaidProfile()
    local settings = GetRaidProfileFlattenedOptions(profile)

    if not settings then return end

    self.horizontalGroups = settings.horizontalGroups
    self.displayMainTankAndAssist =  settings.displayMainTankAndAssist

    if self.keepGroupsTogether ~= settings.keepGroupsTogether then
        self.processedFrames = {}
    end

    self.keepGroupsTogether = settings.keepGroupsTogether
    self.displayBorder = settings.displayBorder
    self.frameWidth = settings.frameWidth
    self.frameHeight = settings.frameHeight
    self.displayPowerBar = settings.displayPowerBar
    self.displayPets = settings.displayPets
    self.useCompactPartyFrames = GetCVar("useCompactPartyFrames") == "1"

    self.componentScale = min(self.frameHeight / self.NATIVE_UNIT_FRAME_HEIGHT, self.frameWidth / self.NATIVE_UNIT_FRAME_WIDTH)
end

function KHMRaidFrames.SyncProfiles(profile)
    if KHMRaidFrames_SyncProfiles then
        local dbProfiles = KHMRaidFrames.db:GetProfiles()

        for _, v in ipairs(dbProfiles) do
            if profile == v then
                KHMRaidFrames.db:SetProfile(profile)

                if not KHMRaidFrames.displayPowerBar then
                    KHMRaidFrames.db.profile.raid.frames.showResourceOnlyForHealers = false
                    KHMRaidFrames.db.profile.party.frames.showResourceOnlyForHealers = false
                end

                KHMRaidFrames.RevertName()
                KHMRaidFrames.RevertStatusText()
                KHMRaidFrames.RevertRoleIcon()
                KHMRaidFrames.RevertReadyCheckIcon()
                KHMRaidFrames.RevertStatusIcon()
                KHMRaidFrames.UpdateLeaderIcon()
                KHMRaidFrames:UpdateRaidMark()

                KHMRaidFrames:CustomizeOptions()
                KHMRaidFrames:HookNameAndIcons()
            end
        end
    end
end
--

-- CONFIG PANEL CLOSE/OPEN
function KHMRaidFrames:OnOptionShow()
    if InCombatLockdown() then
        self:HideAll()
        self.deffered = true
        return
    end

    self.isOpen = true
    self:ShowRaidFrame()
    self:ConfigOptionsOpen()
end

function KHMRaidFrames:OnOptionHide()
    self.isOpen = false

    self:HideRaidFrame()
end

function KHMRaidFrames:ShowRaidFrame()
    if not InCombatLockdown() and not IsInGroup() and self.useCompactPartyFrames then
        CompactRaidFrameContainer:Show()
        CompactRaidFrameManager:Show()
    end
end

function KHMRaidFrames:HideRaidFrame()
    if not self.db.profile.party.frames.showPartySolo and not InCombatLockdown() and not IsInGroup() and self.useCompactPartyFrames then
        CompactRaidFrameContainer:Hide()
        CompactRaidFrameManager:Hide()
    end

    self:HideVirtual()
end

function KHMRaidFrames:HideAll()
    _G["InterfaceOptionsFrame"]:Hide()
end
--

-- DEFAULTS RELATED FUNCTIONS
function KHMRaidFrames:Defaults()
    local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

    local defaults_settings = {profile = {party = {}, raid = {}, glows = {}}}
    KHMRaidFrames.font = SharedMedia.DefaultMedia.font or "Friz Quadrata TT"

    local commons = {
            frames = {
                hideGroupTitles = false,
                texture = "Blizzard Raid Bar",
                clickThrough = false,
                enhancedAbsorbs = false,
                showPartySolo = false,
                tracking = {},
                trackingStr = "",
                autoScaling = true,
                showResourceOnlyForHealers = false,
                alpha = 1.0,
            },
            dispelDebuffFrames = {
                num = 3,
                numInRow = 3,
                rowsGrowDirection = "TOP",
                anchorPoint = "TOPRIGHT",
                growDirection = "LEFT",
                size = 12,
                xOffset = 0,
                yOffset = 0,
                exclude = {},
                excludeStr = "",
                alpha = 1.0,
            },
            debuffFrames = {
                num = 3,
                numInRow = 3,
                rowsGrowDirection = "TOP",
                anchorPoint = "BOTTOMLEFT",
                growDirection = "RIGHT",
                size = 11,
                xOffset = 0,
                yOffset = 0,
                exclude = {},
                excludeStr = "",
                bigDebuffSize = 11 + 9,
                showBigDebuffs = true,
                smartAnchoring = true,
                alpha = 1.0,
            },
            buffFrames = {
                num = 3,
                numInRow = 3,
                rowsGrowDirection = "TOP",
                anchorPoint = "BOTTOMRIGHT",
                growDirection = "LEFT",
                size = 11,
                xOffset = 0,
                yOffset = 0,
                exclude = {},
                excludeStr = "",
                alpha = 1.0,
            },
            raidIcon = {
                enabled = false,
                size = 15,
                xOffset = 0,
                yOffset = 0,
                anchorPoint = "TOP",
                alpha = 1.0,
            },
            nameAndIcons = {
                name = {
                    font = KHMRaidFrames.font,
                    size = 11,
                    flag = "None",
                    hJustify = "LEFT",
                    xOffset = 0,
                    yOffset = -1,
                    showServer = true,
                    classColoredNames = false,
                    enabled = false,
                    hide = false,
                },
                statusText = {
                    font = KHMRaidFrames.font,
                    size = 12,
                    flag = "None",
                    hJustify = "CENTER",
                    xOffset = 0,
                    yOffset = 0,
                    enabled = false,
                    abbreviateNumbers = false,
                    precision = 0,
                    notShowStatuses = false,
                    showPercents = false,
                    color = {1, 1, 1, 1},
                    classColoredText = false,
                },
                roleIcon = {
                    size = 12,
                    xOffset = 0,
                    yOffset = 0,
                    healer = "",
                    damager = "",
                    tank = "",
                    vehicle = "",
                    toggle = false,
                    enabled = false,
                    colors = {
                        healer = {1, 1, 1, 1},
                        damager = {1, 1, 1, 1},
                        tank = {1, 1, 1, 1},
                        vehicle = {1, 1, 1, 1},
                    },
                    hide = false,
                },
                readyCheckIcon  = {
                    size = 15 ,
                    xOffset = 0,
                    yOffset = 0,
                    ready = "",
                    notready = "",
                    waiting = "",
                    toggle = false,
                    enabled = false,
                    colors = {
                        ready = {1, 1, 1, 1},
                        notready = {1, 1, 1, 1},
                        waiting = {1, 1, 1, 1},
                    },
                    hide = false,
                },
                centerStatusIcon = {
                    size = 22,
                    xOffset = 0,
                    yOffset = 0,
                    inOtherGroup = "",
                    hasIncomingResurrection = "",
                    hasIncomingSummonPending = "",
                    hasIncomingSummonAccepted = "",
                    hasIncomingSummonDeclined = "",
                    inOtherPhase = "",
                    toggle = false,
                    enabled = false,
                    colors = {
                        inOtherGroup = {1, 1, 1, 1},
                        hasIncomingResurrection = {1, 1, 1, 1},
                        hasIncomingSummonPending = {1, 1, 1, 1},
                        hasIncomingSummonAccepted = {1, 1, 1, 1},
                        hasIncomingSummonDeclined = {1, 1, 1, 1},
                        inOtherPhase = {1, 1, 1, 1},
                    },
                    hide = false,
                },
                leaderIcon = {
                    size = 10 ,
                    xOffset = 0,
                    yOffset = 0,
                    anchorPoint = "TOPRIGHT",
                    icon = "",
                    enabled = false,
                    alpha = 1.0,
                    colors = {
                        icon = {1, 1, 1, 1},
                    },
                },
            },
    }
    defaults_settings.profile.party = commons
    defaults_settings.profile.raid = commons

    defaults_settings.profile.glows = {
        auraGlow = {
            buffFrames = {
                type = "pixel",
                options = self.GetGlowOptions(),
                tracking = {},
                trackingStr = "",
                enabled = false,
                useDefaultsColors = true,
            },
            debuffFrames = {
                type = "pixel",
                options = self.GetGlowOptions(),
                tracking = {},
                trackingStr = "",
                enabled = false,
                useDefaultsColors = true,
            },
            defaultColors = self.defuffsColors,
        },
        frameGlow = {
            buffFrames = {
                type = "pixel",
                options = self.GetGlowOptions(),
                tracking = {},
                trackingStr = "",
                enabled = false,
                useDefaultsColors = true,
            },
            debuffFrames = {
                type = "pixel",
                options = self.GetGlowOptions(),
                tracking = {},
                trackingStr = "",
                enabled = false,
                useDefaultsColors = true,
            },
            defaultColors = self.defuffsColors,
        },
        glowBlockList = {
            tracking = {},
            trackingStr = "",
        },
    }

    defaults_settings.profile.Masque = false

    return defaults_settings
end

function KHMRaidFrames:RestoreDefaults(groupType, frameType, subType)
    if InCombatLockdown() then
        print("Can not refresh settings while in combat")
        return
    end

    local defaults_settings = subType and self:Defaults()["profile"][groupType][frameType][subType]

    for k, v in pairs(defaults_settings) do
        self.db.profile[groupType][frameType][k] = v
    end

    self:SafeRefresh(groupType)
end

function KHMRaidFrames:CopySettings(dbFrom, dbTo)
    if InCombatLockdown() then
        print("Can not refresh settings while in combat")
        return
    end

    for k, v in pairs(dbFrom) do
        if dbTo[k] ~= nil then
            dbTo[k] = v
        end
    end

    self:SafeRefresh(groupType)
end
--