local function hookScript(table, fn, cb)
    if table and table:HasScript(fn) then
        table:HookScript(fn, cb)
    end
end

local attached = GameTooltip and GameTooltip.HasScript and GameTooltip:HasScript("OnTooltipSetUnit")

local function addCurrentSeasonScoreToTooltip(tooltip, unit)
    if not unit then
        return
    end
    local name = UnitName(unit)
    if not name then
        return
    end
    local playerToken = "mouseover"
    local ratingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(playerToken)
    local currentSeasonScore = ratingSummary and ratingSummary.currentSeasonScore or 0
    if currentSeasonScore > 0 then
        tooltip:AddLine("M+ Score: " .. currentSeasonScore)
        tooltip:Show()
    end
end

if not attached and TooltipDataProcessor then
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit or 2, function(tooltip, data)
        local _, unit = tooltip:GetUnit()
        addCurrentSeasonScoreToTooltip(tooltip, unit)
    end)
end

hookScript(GameTooltip, "OnTooltipSetUnit", function(tooltip)
    local _, unit = tooltip:GetUnit()
    addCurrentSeasonScoreToTooltip(tooltip, unit)
end)
