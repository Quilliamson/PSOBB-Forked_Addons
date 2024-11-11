local function ConfigurationWindow(configuration)
    local this =
    {
        title = "Damage Analysis - Configuration",
        open = false,
        changed = false,
    }

    local _configuration = configuration

    local function PresentColorEditor(label, default, custom)
        custom = custom or 0xFFFFFFFF
    
        local changed = false
        local i_default =
        {
            bit.band(bit.rshift(default, 24), 0xFF),
            bit.band(bit.rshift(default, 16), 0xFF),
            bit.band(bit.rshift(default, 8), 0xFF),
            bit.band(default, 0xFF)
        }
        local i_custom =
        {
            bit.band(bit.rshift(custom, 24), 0xFF),
            bit.band(bit.rshift(custom, 16), 0xFF),
            bit.band(bit.rshift(custom, 8), 0xFF),
            bit.band(custom, 0xFF)
        }
    
        local ids = { "##X", "##Y", "##Z", "##W" }
        local fmt = { "A:%3.0f", "R:%3.0f", "G:%3.0f", "B:%3.0f" }
    
        imgui.BeginGroup()
        imgui.PushID(label)
    
        imgui.PushItemWidth(50)
        for n = 1, 4, 1 do
            local changedDragInt = false
            if n ~= 1 then
                imgui.SameLine(0, 5)
            end
    
            changedDragInt, i_custom[n] = imgui.DragInt(ids[n], i_custom[n], 1.0, 0, 255, fmt[n])
            if changedDragInt then
                this.changed = true
            end
        end
        imgui.PopItemWidth()
    
        imgui.SameLine(0, 5)
        imgui.ColorButton(i_custom[2] / 255, i_custom[3] / 255, i_custom[4] / 255, i_custom[1] / 255)
        if imgui.IsItemHovered() then
            imgui.SetTooltip(
                string.format(
                    "#%02X%02X%02X%02X",
                    i_custom[4],
                    i_custom[1],
                    i_custom[2],
                    i_custom[3]
                )
            )
        end
    
        imgui.SameLine(0, 5)
        imgui.Text(label)
    
        default =
        bit.lshift(i_default[1], 24) +
        bit.lshift(i_default[2], 16) +
        bit.lshift(i_default[3], 8) +
        bit.lshift(i_default[4], 0)
    
        custom =
        bit.lshift(i_custom[1], 24) +
        bit.lshift(i_custom[2], 16) +
        bit.lshift(i_custom[3], 8) +
        bit.lshift(i_custom[4], 0)
    
        if custom ~= default then
            imgui.SameLine(0, 5)
            if imgui.Button("Revert") then
                custom = default
                this.changed = true
            end
        end
    
        imgui.PopID()
        imgui.EndGroup()
    
        return custom
    end

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
			
			-- if imgui.Checkbox("4K Resolution Support", _configuration.reso4K) then
                -- _configuration.reso4K = not _configuration.reso4K
				-- this.changed = true
                -- if _configuration.reso4K then
					-- _configuration.targetX = 0
					-- _configuration.targetY = -250
					-- _configuration.targetW = 565
					-- _configuration.targetH = 335
					
					-- _configuration.foRecX = 0
					-- _configuration.foRecY = -250
					-- _configuration.foRecW = 565
					-- _configuration.foRecH = 265
					
					-- _configuration.target2X = -425
					-- _configuration.target2Y = -250
					-- _configuration.target2W = 280
					-- _configuration.target2H = 230
					
					-- _configuration.RateX = 395
					-- _configuration.RateY = -250
					-- _configuration.RateW = 220
					-- _configuration.RateH = 300
					
					-- _configuration.mhpX = 190
					-- _configuration.mhpY = 5
					-- _configuration.mhpW = 1800
					-- _configuration.mhpH = 500
				-- else
					-- _configuration.targetX = 0
					-- _configuration.targetY = -150
					-- _configuration.targetW = 285
					-- _configuration.targetH = 190
					
					-- _configuration.foRecX = 0
					-- _configuration.foRecY = -150
					-- _configuration.foRecW = 285
					-- _configuration.foRecH = 150
					
					-- _configuration.target2X = -215
					-- _configuration.target2Y = -150
					-- _configuration.target2W = 145
					-- _configuration.target2H = 130
					
					-- _configuration.RateX = 205
					-- _configuration.RateY = -150
					-- _configuration.RateW = 120
					-- _configuration.RateH = 170
					
					-- _configuration.mhpX = 100
					-- _configuration.mhpY = 5
					-- _configuration.mhpW = 900
					-- _configuration.mhpH = 200
				-- end
				-- _configuration.targetChanged = true
				-- _configuration.foRecChanged = true
				-- _configuration.target2Changed = true
				-- _configuration.RateChanged = true
				-- _configuration.mhpChanged = true
            -- end
			
			if imgui.Checkbox("Show Rare Drops", _configuration.ShowRares) then
                _configuration.ShowRares = not _configuration.ShowRares
                this.changed = true
            end
			
			if imgui.Checkbox("Show Monster Name", _configuration.ShowMonsterName) then
                _configuration.ShowMonsterName = not _configuration.ShowMonsterName
                this.changed = true
            end
			
			if imgui.Checkbox("Show Health Bar", _configuration.ShowHealthBar) then
                _configuration.ShowHealthBar = not _configuration.ShowHealthBar
                this.changed = true
            end

            imgui.TreePop()
        end
		
		if imgui.TreeNodeEx("Special Weapon Damage Analysis") then
			if imgui.Checkbox("Enable", _configuration.targetEnableWindow) then
                _configuration.targetEnableWindow = not _configuration.targetEnableWindow
                this.changed = true
            end
			
			if imgui.Checkbox("Show Min Max Damage", _configuration.ShowDamage) then
                _configuration.ShowDamage = not _configuration.ShowDamage
                this.changed = true
            end
			
			if imgui.Checkbox("Show Special & Hit Chance", _configuration.ShowHit) then
                _configuration.ShowHit = not _configuration.ShowHit
                this.changed = true
            end

            imgui.PushItemWidth(150)
            success, _configuration.targetHardThreshold = imgui.InputInt("Hard Accuracy Threshold %", _configuration.targetHardThreshold)
            imgui.PopItemWidth()
            if success then
                if _configuration.targetHardThreshold < 25 then
                    _configuration.targetHardThreshold = 25
                end
                if _configuration.targetHardThreshold > 100 then
                    _configuration.targetHardThreshold = 100
                end
                this.changed = true
            end   
			
			imgui.PushItemWidth(150)
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

            imgui.PushItemWidth(150)
            success, _configuration.targetX = imgui.InputInt("X", _configuration.targetX)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(150)
            success, _configuration.targetY = imgui.InputInt("Y", _configuration.targetY)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(150)
            success, _configuration.targetW = imgui.InputInt("Width", _configuration.targetW)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(150)
            success, _configuration.targetH = imgui.InputInt("Height", _configuration.targetH)
            imgui.PopItemWidth()
            if success then
                _configuration.targetChanged = true
                this.changed = true
            end
			imgui.TreePop()
		end
		
		if imgui.TreeNodeEx("Monster HP - Room View") then
            if imgui.Checkbox("Enable", _configuration.mhpEnableWindow) then
                _configuration.mhpEnableWindow = not _configuration.mhpEnableWindow
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
			if imgui.Checkbox("Show monster weakness", _configuration.showMonsterResist) then
				_configuration.showMonsterResist = not _configuration.showMonsterResist
				this.changed = true
			end
			if imgui.Checkbox("Show monster status ailment", _configuration.showMonsterStatus) then
				_configuration.showMonsterStatus = not _configuration.showMonsterStatus
				this.changed = true
			end
			if imgui.Checkbox("Custom Rare Monster Color", _configuration.customRareMonsterColorEnabled) then
				_configuration.customRareMonsterColorEnabled = not _configuration.customRareMonsterColorEnabled
				this.changed = true
			end
            if _configuration.customRareMonsterColorEnabled then
                success, _configuration.customRareMonsterSpeed = imgui.SliderInt("Color Transition Speed", _configuration.customRareMonsterSpeed, 0, 40)
                if success then
                    this.changed = true
                end
                _configuration.customRareMonsterColorStart = PresentColorEditor("Color Start", 0xFFBF5814, _configuration.customRareMonsterColorStart)
                _configuration.customRareMonsterColorEnd = PresentColorEditor("Color End", 0xFFFCAA33, _configuration.customRareMonsterColorEnd)
            end
			if imgui.Checkbox("Show Megid %", _configuration.showMonsterID) then
				_configuration.showMonsterID = not _configuration.showMonsterID
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

            imgui.PushItemWidth(150)
            success, _configuration.mhpX = imgui.InputInt("X", _configuration.mhpX)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(150)
            success, _configuration.mhpY = imgui.InputInt("Y", _configuration.mhpY)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(150)
            success, _configuration.mhpW = imgui.InputInt("Width", _configuration.mhpW)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(150)
            success, _configuration.mhpH = imgui.InputInt("Height", _configuration.mhpH)
            imgui.PopItemWidth()
            if success then
                _configuration.mhpChanged = true
                this.changed = true
            end

            imgui.TreePop()
        end
		
		if imgui.TreeNodeEx("Force - Recommended Techs") then
            if imgui.Checkbox("Enable", _configuration.foRecEnableWindow) then
                _configuration.foRecEnableWindow = not _configuration.foRecEnableWindow
                this.changed = true
            end
			
			if imgui.Checkbox("Show Efficiency-Based Casts", _configuration.foRecShowEfficiencyBased) then
                _configuration.foRecShowEfficiencyBased = not _configuration.foRecShowEfficiencyBased
                this.changed = true
            end
			
			if imgui.Checkbox("Show Tech Damage", _configuration.foRecShowDamage) then
                _configuration.foRecShowDamage = not _configuration.foRecShowDamage
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

            imgui.PushItemWidth(150)
            success, _configuration.foRecX = imgui.InputInt("X", _configuration.foRecX)
            imgui.PopItemWidth()
            if success then
                _configuration.foRecChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(150)
            success, _configuration.foRecY = imgui.InputInt("Y", _configuration.foRecY)
            imgui.PopItemWidth()
            if success then
                _configuration.foRecChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(150)
            success, _configuration.foRecW = imgui.InputInt("Width", _configuration.foRecW)
            imgui.PopItemWidth()
            if success then
                _configuration.foRecChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(150)
            success, _configuration.foRecH = imgui.InputInt("Height", _configuration.foRecH)
            imgui.PopItemWidth()
            if success then
                _configuration.foRecChanged = true
                this.changed = true
            end

            imgui.TreePop()
        end
		
		if imgui.TreeNodeEx("Separate Enemy Stats") then
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

            imgui.PushItemWidth(150)
            success, _configuration.target2X = imgui.InputInt("X", _configuration.target2X)
            imgui.PopItemWidth()
            if success then
                _configuration.target2Changed = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(150)
            success, _configuration.target2Y = imgui.InputInt("Y", _configuration.target2Y)
            imgui.PopItemWidth()
            if success then
                _configuration.target2Changed = true
                this.changed = true
            end

            imgui.PushItemWidth(150)
            success, _configuration.target2W = imgui.InputInt("Width", _configuration.target2W)
            imgui.PopItemWidth()
            if success then
                _configuration.target2Changed = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(150)
            success, _configuration.target2H = imgui.InputInt("Height", _configuration.target2H)
            imgui.PopItemWidth()
            if success then
                _configuration.target2Changed = true
                this.changed = true
            end

            imgui.TreePop()
        end
		
		if imgui.TreeNodeEx("Separate Activation Rates") then
            if imgui.Checkbox("Enable", _configuration.RateEnableWindow) then
                _configuration.RateEnableWindow = not _configuration.RateEnableWindow
                this.changed = true
            end
			
			if imgui.Checkbox("Show Activation Rates", _configuration.RateEnableActivationRates) then
                _configuration.RateEnableActivationRates = not _configuration.RateEnableActivationRates
                this.changed = true
            end            
            if _configuration.RateEnableActivationRates then
                if imgui.TreeNodeEx("Specials to Display") then 
                    if imgui.Checkbox("Hell", _configuration.RateEnableActivationRateItems.hell) then
                        _configuration.RateEnableActivationRateItems.hell = not _configuration.RateEnableActivationRateItems.hell
                        _configuration.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 43)
                    if imgui.Checkbox("Dark", _configuration.RateEnableActivationRateItems.dark) then
                        _configuration.RateEnableActivationRateItems.dark = not _configuration.RateEnableActivationRateItems.dark
                        _configuration.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Blizzard", _configuration.RateEnableActivationRateItems.blizzard) then
                        _configuration.RateEnableActivationRateItems.blizzard = not _configuration.RateEnableActivationRateItems.blizzard
                        _configuration.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 15)
                    if imgui.Checkbox("Arrest", _configuration.RateEnableActivationRateItems.arrest) then
                        _configuration.RateEnableActivationRateItems.arrest = not _configuration.RateEnableActivationRateItems.arrest
                        _configuration.changed = true
                        this.changed = true
                    end                    
                    imgui.SameLine(0, 15)
                    if imgui.Checkbox("Seize", _configuration.RateEnableActivationRateItems.seize) then
                        _configuration.RateEnableActivationRateItems.seize = not _configuration.RateEnableActivationRateItems.seize
                        _configuration.changed = true
                        this.changed = true
                    end
                    if imgui.Checkbox("Chaos", _configuration.RateEnableActivationRateItems.chaos) then
                        _configuration.RateEnableActivationRateItems.chaos = not _configuration.RateEnableActivationRateItems.chaos
                        _configuration.changed = true
                        this.changed = true
                    end
                    imgui.SameLine(0, 36)
                    if imgui.Checkbox("Havoc", _configuration.RateEnableActivationRateItems.havoc) then
                        _configuration.RateEnableActivationRateItems.havoc = not _configuration.RateEnableActivationRateItems.havoc
                        _configuration.changed = true
                        this.changed = true
                    end
                    imgui.TreePop()
                end
            end 

            if imgui.Checkbox("No title bar", _configuration.RateNoTitleBar == "NoTitleBar") then
                if _configuration.RateNoTitleBar == "NoTitleBar" then
                    _configuration.RateNoTitleBar = ""
                else
                    _configuration.RateNoTitleBar = "NoTitleBar"
                end
                this.changed = true
            end
            if imgui.Checkbox("No resize", _configuration.RateNoResize == "NoResize") then
                if _configuration.RateNoResize == "NoResize" then
                    _configuration.RateNoResize = ""
                else
                    _configuration.RateNoResize = "NoResize"
                end
                this.changed = true
            end
            if imgui.Checkbox("No move", _configuration.RateNoMove == "NoMove") then
                if _configuration.RateNoMove == "NoMove" then
                    _configuration.RateNoMove = ""
                else
                    _configuration.RateNoMove = "NoMove"
                end
                this.changed = true
            end
            if imgui.Checkbox("No scrollbar", _configuration.RateNoScrollbar == "NoScrollbar") then
                if _configuration.RateNoScrollbar == "NoScrollbar" then
                    _configuration.RateNoScrollbar = ""
                else
                    _configuration.RateNoScrollbar = "NoScrollbar"
                end
                this.changed = true
            end

            if imgui.Checkbox("Transparent window", _configuration.RateTransparentWindow) then
                _configuration.RateTransparentWindow = not _configuration.RateTransparentWindow
                this.changed = true
            end

            imgui.Text("Position and Size")
            imgui.PushItemWidth(200)
            success, _configuration.RateAnchor = imgui.Combo("Anchor", _configuration.RateAnchor, anchorList, table.getn(anchorList))
            imgui.PopItemWidth()
            if success then
                _configuration.RateChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(150)
            success, _configuration.RateX = imgui.InputInt("X", _configuration.RateX)
            imgui.PopItemWidth()
            if success then
                _configuration.RateChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 38)
            imgui.PushItemWidth(150)
            success, _configuration.RateY = imgui.InputInt("Y", _configuration.RateY)
            imgui.PopItemWidth()
            if success then
                _configuration.RateChanged = true
                this.changed = true
            end

            imgui.PushItemWidth(150)
            success, _configuration.RateW = imgui.InputInt("Width", _configuration.RateW)
            imgui.PopItemWidth()
            if success then
                _configuration.RateChanged = true
                this.changed = true
            end

            imgui.SameLine(0, 10)
            imgui.PushItemWidth(150)
            success, _configuration.RateH = imgui.InputInt("Height", _configuration.RateH)
            imgui.PopItemWidth()
            if success then
                _configuration.RateChanged = true
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
