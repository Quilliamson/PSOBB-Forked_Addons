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
			
			if imgui.Checkbox("Show Min Max Damage", _configuration.ShowDamage) then
                _configuration.ShowDamage = not _configuration.ShowDamage
                this.changed = true
            end
			
			if imgui.Checkbox("Show Special Ailment", _configuration.ShowAilment) then
                _configuration.ShowAilment = not _configuration.ShowAilment
                this.changed = true
            end
			
			if imgui.Checkbox("Show Monster Stats", _configuration.ShowMonsterStats) then
                _configuration.ShowMonsterStats = not _configuration.ShowMonsterStats
                this.changed = true
            end

            imgui.PushItemWidth(100)
            success, _configuration.targetHardThreshold = imgui.InputInt("Hard Accuracy Threshold %", _configuration.targetHardThreshold)
            imgui.PopItemWidth()
            if success then
                if _configuration.targetHardThreshold < 50 then
                    _configuration.targetHardThreshold = 50
                end
                if _configuration.targetHardThreshold > 100 then
                    _configuration.targetHardThreshold = 100
                end
                this.changed = true
            end   
			
			imgui.PushItemWidth(100)
            success, _configuration.targetSpecialThreshold = imgui.InputInt("Special Accuracy Threshold %", _configuration.targetSpecialThreshold)
            imgui.PopItemWidth()
            if success then
                if _configuration.targetSpecialThreshold < 25 then
                    _configuration.targetSpecialThreshold = 25
                end
                if _configuration.targetSpecialThreshold > 100 then
                    _configuration.targetSpecialThreshold = 100
                end
                this.changed = true
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
