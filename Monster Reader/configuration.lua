local function ConfigurationWindow(configuration)
    local this =
    {
        title = "Monster Reader - Configuration",
        open = false,
        changed = false,
    }

    local _configuration = configuration

    local _showWindowSettings = function()
        local success
        local anchorList =
        {
            "Top Left (Disabled)", "Left", "Bottom Left",
            "Top", "Center", "Bottom",
            "Top Right", "Right", "Bottom Right",
        }

        if imgui.TreeNodeEx("General", "DefaultOpen") then
            if imgui.Checkbox("Enable", _configuration.enable) then
                _configuration.enable = not _configuration.enable
                this.changed = true
            end

            if imgui.Checkbox("Invert monster list", _configuration.invertMonsterList) then
                _configuration.invertMonsterList = not _configuration.invertMonsterList
                this.changed = true
            end
            if imgui.Checkbox("Show current room only", _configuration.showCurrentRoomOnly) then
                _configuration.showCurrentRoomOnly = not _configuration.showCurrentRoomOnly
                this.changed = true
            end
            if imgui.Checkbox("Show monster status", _configuration.showMonsterStatus) then
                _configuration.showMonsterStatus = not _configuration.showMonsterStatus
                this.changed = true
            end
            if imgui.Checkbox("Show monster ID", _configuration.showMonsterID) then
                _configuration.showMonsterID = not _configuration.showMonsterID
                this.changed = true
            end

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("HP") then
            if imgui.Checkbox("Enable", _configuration.mhpEnableWindow) then
                _configuration.mhpEnableWindow = not _configuration.mhpEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("Hide when menus are open", _configuration.mhpHideWhenMenu) then
                _configuration.mhpHideWhenMenu = not _configuration.mhpHideWhenMenu
                this.changed = true
            end
            if imgui.Checkbox("Hide when symbol chat/word select is open", _configuration.mhpHideWhenSymbolChat) then
                _configuration.mhpHideWhenSymbolChat = not _configuration.mhpHideWhenSymbolChat
                this.changed = true
            end
            if imgui.Checkbox("Hide when the menu is unavailable", _configuration.mhpHideWhenMenuUnavailable) then
                _configuration.mhpHideWhenMenuUnavailable = not _configuration.mhpHideWhenMenuUnavailable
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.mhpNoTitleBar == "NoTitleBar") then
                if _configuration.mhpNoTitleBar == "NoTitleBar" then
                    _configuration.mhpNoTitleBar = ""
                else
                    _configuration.mhpNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.mhpNoResize == "NoResize") then
                if _configuration.mhpNoResize == "NoResize" then
                    _configuration.mhpNoResize = ""
                else
                    _configuration.mhpNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.mhpNoMove == "NoMove") then
                if _configuration.mhpNoMove == "NoMove" then
                    _configuration.mhpNoMove = ""
                else
                    _configuration.mhpNoMove = "NoMove"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.mhpTransparentWindow) then
                _configuration.mhpTransparentWindow = not _configuration.mhpTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.mhpAnchor = imgui.Combo("Anchor", _configuration.mhpAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.mhpX = imgui.InputInt("X", _configuration.mhpX)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.mhpY = imgui.InputInt("Y", _configuration.mhpY)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.mhpW = imgui.InputInt("Width", _configuration.mhpW)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.mhpH = imgui.InputInt("Height", _configuration.mhpH)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.TreePop()
        end

        if imgui.TreeNodeEx("Target") then
            if imgui.Checkbox("Enable", _configuration.targetEnableWindow) then
                _configuration.targetEnableWindow = not _configuration.targetEnableWindow
                this.changed = true
            end

            if imgui.Checkbox("Show Monster Name", _configuration.targetShowMonsterName) then
                _configuration.targetShowMonsterName = not _configuration.targetShowMonsterName
                this.changed = true
            end

            if imgui.Checkbox("Show Monster Resistance", _configuration.targetShowMonsterStats) then
                _configuration.targetShowMonsterStats = not _configuration.targetShowMonsterStats
                this.changed = true
            end

            if imgui.Checkbox("Show Accuracy Assist", _configuration.targetShowAccuracyAssist) then
                _configuration.targetShowAccuracyAssist = not _configuration.targetShowAccuracyAssist
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.targetAccuracyThreshold = imgui.InputInt("Accuracy Threshold %", _configuration.targetAccuracyThreshold)
            imgui.PopItemWidth()
            if success then
                if _configuration.targetAccuracyThreshold < 50 then
                    _configuration.targetAccuracyThreshold = 50
                end
                if _configuration.targetAccuracyThreshold > 100 then
                    _configuration.targetAccuracyThreshold = 100
                end
                this.changed = true
            end   
            
            if imgui.Checkbox("Enable Activation Rates", _configuration.targetEnableActivationRates) then
                _configuration.targetEnableActivationRates = not _configuration.targetEnableActivationRates
                this.changed = true
            end            
            if _configuration.targetEnableActivationRates then
                if imgui.TreeNodeEx("Specials to Display") then 
                    if imgui.Checkbox("Hell", _configuration.targetEnableActivationRateItems.hell) then
                        _configuration.targetEnableActivationRateItems.hell = not _configuration.targetEnableActivationRateItems.hell
                        _configuration.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 43)
                    if imgui.Checkbox("Dark", _configuration.targetEnableActivationRateItems.dark) then
                        _configuration.targetEnableActivationRateItems.dark = not _configuration.targetEnableActivationRateItems.dark
                        _configuration.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Blizzard", _configuration.targetEnableActivationRateItems.blizzard) then
                        _configuration.targetEnableActivationRateItems.blizzard = not _configuration.targetEnableActivationRateItems.blizzard
                        _configuration.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 15)
                    if imgui.Checkbox("Arrest", _configuration.targetEnableActivationRateItems.arrest) then
                        _configuration.targetEnableActivationRateItems.arrest = not _configuration.targetEnableActivationRateItems.arrest
                        _configuration.changed = true
                        this.changed = true
                    end                    
                    imgui.SameLine(0, 15)
                    if imgui.Checkbox("Seize", _configuration.targetEnableActivationRateItems.seize) then
                        _configuration.targetEnableActivationRateItems.seize = not _configuration.targetEnableActivationRateItems.seize
                        _configuration.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Chaos", _configuration.targetEnableActivationRateItems.chaos) then
                        _configuration.targetEnableActivationRateItems.chaos = not _configuration.targetEnableActivationRateItems.chaos
                        _configuration.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 36)
                    if imgui.Checkbox("Havoc", _configuration.targetEnableActivationRateItems.havoc) then
                        _configuration.targetEnableActivationRateItems.havoc = not _configuration.targetEnableActivationRateItems.havoc
                        _configuration.changed = true
                        this.changed = true
                    end
                    imgui.TreePop()
                end
            end 
            
            if imgui.Checkbox("No title bar", _configuration.targetNoTitleBar == "NoTitleBar") then
                if _configuration.targetNoTitleBar == "NoTitleBar" then
                    _configuration.targetNoTitleBar = ""
                else
                    _configuration.targetNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.targetNoResize == "NoResize") then
                if _configuration.targetNoResize == "NoResize" then
                    _configuration.targetNoResize = ""
                else
                    _configuration.targetNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.targetNoMove == "NoMove") then
                if _configuration.targetNoMove == "NoMove" then
                    _configuration.targetNoMove = ""
                else
                    _configuration.targetNoMove = "NoMove"
                end
                this.changed = true
            end
            if imgui.Checkbox("No scrollbar", _configuration.targetNoScrollbar == "NoScrollbar") then
                if _configuration.targetNoScrollbar == "NoScrollbar" then
                    _configuration.targetNoScrollbar = ""
                else
                    _configuration.targetNoScrollbar = "NoScrollbar"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.targetTransparentWindow) then
                _configuration.targetTransparentWindow = not _configuration.targetTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.targetAnchor = imgui.Combo("Anchor", _configuration.targetAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.targetX = imgui.InputInt("X", _configuration.targetX)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.targetY = imgui.InputInt("Y", _configuration.targetY)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.targetW = imgui.InputInt("Width", _configuration.targetW)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.targetH = imgui.InputInt("Height", _configuration.targetH)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end

            imgui.TreePop()
        end
		
		if imgui.TreeNodeEx("foRec") then
            if imgui.Checkbox("Enable", _configuration.foRecEnableWindow) then
                _configuration.foRecEnableWindow = not _configuration.foRecEnableWindow
                this.changed = true
            end
			
			if imgui.Checkbox("Show Efficiency-Based Casts", _configuration.foRecShowEfficiencyBased) then
                _configuration.foRecShowEfficiencyBased = not _configuration.foRecShowEfficiencyBased
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.foRecNoTitleBar == "NoTitleBar") then
                if _configuration.foRecNoTitleBar == "NoTitleBar" then
                    _configuration.foRecNoTitleBar = ""
                else
                    _configuration.foRecNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.foRecNoResize == "NoResize") then
                if _configuration.foRecNoResize == "NoResize" then
                    _configuration.foRecNoResize = ""
                else
                    _configuration.foRecNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.foRecNoMove == "NoMove") then
                if _configuration.foRecNoMove == "NoMove" then
                    _configuration.foRecNoMove = ""
                else
                    _configuration.foRecNoMove = "NoMove"
                end
                this.changed = true
            end
            if imgui.Checkbox("No scrollbar", _configuration.foRecNoScrollbar == "NoScrollbar") then
                if _configuration.foRecNoScrollbar == "NoScrollbar" then
                    _configuration.foRecNoScrollbar = ""
                else
                    _configuration.foRecNoScrollbar = "NoScrollbar"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.foRecTransparentWindow) then
                _configuration.foRecTransparentWindow = not _configuration.foRecTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.foRecAnchor = imgui.Combo("Anchor", _configuration.foRecAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.foRecChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.foRecX = imgui.InputInt("X", _configuration.foRecX)
            imgui.PopItemWidth()
            if success then
                _configuration.foRecChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.foRecY = imgui.InputInt("Y", _configuration.foRecY)
            imgui.PopItemWidth()
            if success then
                _configuration.foRecChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.foRecW = imgui.InputInt("Width", _configuration.foRecW)
            imgui.PopItemWidth()
            if success then
                _configuration.foRecChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.foRecH = imgui.InputInt("Height", _configuration.foRecH)
            imgui.PopItemWidth()
            if success then
                _configuration.foRecChanged = true
                this.changed = true
            end

            imgui.TreePop()
        end
		
		if imgui.TreeNodeEx("Target2") then
            if imgui.Checkbox("Enable", _configuration.target2EnableWindow) then
                _configuration.target2EnableWindow = not _configuration.target2EnableWindow
                this.changed = true
            end

            if imgui.Checkbox("No title bar", _configuration.target2NoTitleBar == "NoTitleBar") then
                if _configuration.target2NoTitleBar == "NoTitleBar" then
                    _configuration.target2NoTitleBar = ""
                else
                    _configuration.target2NoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.target2NoResize == "NoResize") then
                if _configuration.target2NoResize == "NoResize" then
                    _configuration.target2NoResize = ""
                else
                    _configuration.target2NoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.target2NoMove == "NoMove") then
                if _configuration.target2NoMove == "NoMove" then
                    _configuration.target2NoMove = ""
                else
                    _configuration.target2NoMove = "NoMove"
                end
                this.changed = true
            end
            if imgui.Checkbox("No scrollbar", _configuration.target2NoScrollbar == "NoScrollbar") then
                if _configuration.target2NoScrollbar == "NoScrollbar" then
                    _configuration.target2NoScrollbar = ""
                else
                    _configuration.target2NoScrollbar = "NoScrollbar"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.target2TransparentWindow) then
                _configuration.target2TransparentWindow = not _configuration.target2TransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.target2Anchor = imgui.Combo("Anchor", _configuration.target2Anchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.target2Changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.target2X = imgui.InputInt("X", _configuration.target2X)
            imgui.PopItemWidth()
            if success then
                _configuration.target2Changed = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(100)
            success, _configuration.target2Y = imgui.InputInt("Y", _configuration.target2Y)
            imgui.PopItemWidth()
            if success then
                _configuration.target2Changed = true
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.target2W = imgui.InputInt("Width", _configuration.target2W)
            imgui.PopItemWidth()
            if success then
                _configuration.target2Changed = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(100)
            success, _configuration.target2H = imgui.InputInt("Height", _configuration.target2H)
            imgui.PopItemWidth()
            if success then
                _configuration.target2Changed = true
                this.changed = true
            end

            imgui.TreePop()
        end
    end

    this.Update = function()
        if this.open == false then
            return
        end

        local success

        imgui.SetNextWindowSize(500, 400, 'FirstUseEver')
        success, this.open = imgui.Begin(this.title, this.open)

        _showWindowSettings()

        imgui.End()
    end

    return this
end

return
{
    ConfigurationWindow = ConfigurationWindow,
}
