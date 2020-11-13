local KHMRaidFrames = LibStub("AceAddon-3.0"):GetAddon("KHMRaidFrames")

if not InCombatLockdown() then
    CompactRaidFrameContainer_TryUpdate(CompactRaidFrameContainer)
end

local _G = _G
local CUF_AURA_BOTTOM_OFFSET = 2
local NATIVE_UNIT_FRAME_HEIGHT = 36
local NATIVE_UNIT_FRAME_WIDTH = 72   
local powerBarHeight = 8


function KHMRaidFrames:Defaults()
    local powerBarUsedHeight, componentScale = self.displayPowerBar and powerBarHeight or 0, min(self.frameHeight / NATIVE_UNIT_FRAME_HEIGHT, self.frameWidth / NATIVE_UNIT_FRAME_WIDTH)

    local buffSize = 11 * componentScale
    local defaults_settings = {profile = {party = {}, raid = {}}}

    local commons = {
            frames = {
                hideGroupTitles = false,
                texture = "Interface\\RaidFrame\\Raid-Bar-Hp-Fill",                
            },        
            dispelDebuffFrames = {
                num = 3,
                numInRow = 3,
                rowsGrowDirection = "TOP",
                anchorPoint = "TOPRIGHT",
                growDirection = "LEFT",
                size = 12,
                xOffset = -3,
                yOffset = -2,
                exclude = {},
                excludeStr = "",          
                glow = {
                    type = "pixel",
                    options = self:GetGlowOptions(),
                    tracking = {},
                    trackingStr = "",    
                    enabled = false,
                    useDefaultsColors = true,
                },
                frameGlow = {
                    type = "pixel",
                    options = self:GetGlowOptions(),
                    tracking = {},
                    trackingStr = "",    
                    enabled = false,
                    useDefaultsColors = true,                                                           
                },                  
            },
            debuffFrames = {
                num = 3,
                numInRow = 3,
                rowsGrowDirection = "TOP",                
                anchorPoint = "BOTTOMLEFT",
                growDirection = "RIGHT",
                size = buffSize,
                xOffset = 3,
                yOffset = CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight,
                exclude = {},
                excludeStr = "",                
                glow = {
                    type = "pixel",
                    options = self:GetGlowOptions(),
                    tracking = {},
                    trackingStr = "",    
                    enabled = false,
                    useDefaultsColors = true,
                },
                frameGlow = {
                    type = "pixel",
                    options = self:GetGlowOptions(),
                    tracking = {},
                    trackingStr = "",    
                    enabled = false,
                    useDefaultsColors = true,                                                           
                },                                
            },
            buffFrames = {
                num = 3,
                numInRow = 3,
                rowsGrowDirection = "TOP",                  
                anchorPoint = "BOTTOMRIGHT",
                growDirection = "LEFT",
                size = buffSize,
                xOffset = -3,
                yOffset = CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight,
                exclude = {},
                excludeStr = "",                 
                glow = {
                    type = "pixel",
                    options = self:GetGlowOptions(),
                    tracking = {},
                    trackingStr = "",    
                    enabled = false,
                    useDefaultsColors = true,
                },
                frameGlow = {
                    type = "pixel",
                    options = self:GetGlowOptions(),
                    tracking = {},
                    trackingStr = "",    
                    enabled = false,
                    useDefaultsColors = true,                                                           
                },                               
            },
            raidIcon = {
                enabled = true,
                size = 30,
                xOffset = 0,
                yOffset = 0,
                anchorPoint = "TOP",
            },      
    }
    defaults_settings.profile.party = commons
    defaults_settings.profile.raid = commons

    return defaults_settings
end

function KHMRaidFrames:RestoreDefaults(groupType, frameType)
    if InCombatLockdown() then
        print("Can not refresh settings while in combat")      
        return
    end

    local defaults_settings = self:Defaults()["profile"][groupType][frameType]

    for k, v in pairs(defaults_settings) do
        self.db.profile[groupType][frameType][k] = v
    end

    self:SafeRefresh()
end
