local function ConfigurationWindow(configuration)
    local this =
    {
        title = "Damage Analysis - Configuration",
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

			if imgui.Checkbox("Show Health Bar", _configuration.ShowHealthBar) then
                _configuration.ShowHealthBar = not _configuration.ShowHealthBar
                this.changed = true
            end
			
			if imgui.Checkbox("Show Monster Stats", _configuration.ShowMonsterStats) then
                _configuration.ShowMonsterStats = not _configuration.ShowMonsterStats
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
