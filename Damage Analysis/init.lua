local core_mainmenu = require("core_mainmenu")
local lib_helpers = require("solylib.helpers")
local lib_characters = require("solylib.characters")
local lib_unitxt = require("solylib.unitxt")
local lib_items = require("solylib.items.items")
local lib_items_list = require("solylib.items.items_list")
local lib_items_cfg = require("solylib.items.items_configuration")
local lib_menu = require("solylib.menu")
local cfg = require("Damage Analysis.configuration")
local cfgMonsters = require("Damage Analysis.monsters")
local optionsLoaded, options = pcall(require, "Damage Analysis.options")

local optionsFileName = "addons/Damage Analysis/options.lua"
local firstPresent = true
local ConfigurationWindow

if optionsLoaded then
    -- If options loaded, make sure we have all those we need
    options.configurationEnableWindow = lib_helpers.NotNilOrDefault(options.configurationEnableWindow, true)
    options.enable                    = lib_helpers.NotNilOrDefault(options.enable, true)

    options.ShowHealthBar     	      = lib_helpers.NotNilOrDefault(options.ShowHealthBar, true)
	options.ShowMonsterStats   	      = lib_helpers.NotNilOrDefault(options.ShowMonsterStats , true)
    options.targetChanged             = lib_helpers.NotNilOrDefault(options.targetChanged, false)
    options.targetAnchor              = lib_helpers.NotNilOrDefault(options.targetAnchor, 6)
    options.targetX                   = lib_helpers.NotNilOrDefault(options.targetX, 0)
    options.targetY                   = lib_helpers.NotNilOrDefault(options.targetY, -200)
    options.targetW                   = lib_helpers.NotNilOrDefault(options.targetW, 400)
    options.targetH                   = lib_helpers.NotNilOrDefault(options.targetH, 205)
    options.targetNoTitleBar          = lib_helpers.NotNilOrDefault(options.targetNoTitleBar, "NoTitleBar")
    options.targetNoResize            = lib_helpers.NotNilOrDefault(options.targetNoResize, "NoResize")
    options.targetNoMove              = lib_helpers.NotNilOrDefault(options.targetNoMove, "NoMove")
    options.targetNoScrollbar         = lib_helpers.NotNilOrDefault(options.targetNoScrollbar, "NoScrollbar")
    options.targetTransparentWindow   = lib_helpers.NotNilOrDefault(options.targetTransparentWindow, false)
    options.targetShowAccuracyAssist  = lib_helpers.NotNilOrDefault(options.targetShowAccuracyAssist, false)
    options.targetAccuracyThreshold     = lib_helpers.NotNilOrDefault(options.targetAccuracyThreshold, 90)
    options.targetEnableActivationRates = lib_helpers.NotNilOrDefault(options.targetEnableActivationRates, false)
	if options.targetEnableActivationRateItems == nil or type(options.targetEnableActivationRateItems) ~= "table" then
        options.targetEnableActivationRateItems = {}
    end
    options.targetEnableActivationRateItems.Hell     = lib_helpers.NotNilOrDefault(options.targetEnableActivationRateItems.hell, false)
    options.targetEnableActivationRateItems.Dark     = lib_helpers.NotNilOrDefault(options.targetEnableActivationRateItems.dark, false)
    options.targetEnableActivationRateItems.Blizzard = lib_helpers.NotNilOrDefault(options.targetEnableActivationRateItems.blizzard, false)
    options.targetEnableActivationRateItems.Arrest   = lib_helpers.NotNilOrDefault(options.targetEnableActivationRateItems.arrest, false)
    options.targetEnableActivationRateItems.Seize    = lib_helpers.NotNilOrDefault(options.targetEnableActivationRateItems.seize, false)
    options.targetEnableActivationRateItems.Chaos    = lib_helpers.NotNilOrDefault(options.targetEnableActivationRateItems.chaos, false)
    options.targetEnableActivationRateItems.Havoc    = lib_helpers.NotNilOrDefault(options.targetEnableActivationRateItems.havoc, false)

else
    options =
    {
        configurationEnableWindow = true,
        enable = true,
		
        ShowHealthBar = true,
		ShowMonsterStats  = true,
        targetChanged = false,
        targetAnchor = 6,
        targetX = 0,
        targetY = -200,
        targetW = 400,
        targetH = 205,
        targetNoTitleBar = "NoTitleBar",
        targetNoResize = "NoResize",
        targetNoMove = "NoMove",
        targetNoScrollbar = "NoScrollbar",
        targetTransparentWindow = false,
        targetShowAccuracyAssist = false,
        targetAccuracyThreshold = 90,
        targetEnableActivationRates = false,
        targetEnableActivationRateItems = {
            hell = false,
            dark = false,
            blizzard = false,
            arrest = false,
            seize = false,
            chaos = false,
            havoc = false,
		},

    }
end

local function SaveOptions(options)
    local file = io.open(optionsFileName, "w")
    if file ~= nil then
        io.output(file)

        io.write("return\n")
        io.write("{\n")
        io.write(string.format("    configurationEnableWindow = %s,\n", tostring(options.configurationEnableWindow)))
        io.write(string.format("    enable = %s,\n", tostring(options.enable)))
        io.write("\n")
        io.write(string.format("    ShowHealthBar = %s,\n", tostring(options.ShowHealthBar)))
		io.write(string.format("    ShowMonsterStats = %s,\n", tostring(options.ShowMonsterStats)))
        io.write(string.format("    targetChanged = %s,\n", tostring(options.targetChanged)))
        io.write(string.format("    targetAnchor = %i,\n", options.targetAnchor))
        io.write(string.format("    targetX = %i,\n", options.targetX))
        io.write(string.format("    targetY = %i,\n", options.targetY))
        io.write(string.format("    targetW = %i,\n", options.targetW))
        io.write(string.format("    targetH = %i,\n", options.targetH))
        io.write(string.format("    targetNoTitleBar = \"%s\",\n", options.targetNoTitleBar))
        io.write(string.format("    targetNoResize = \"%s\",\n", options.targetNoResize))
        io.write(string.format("    targetNoMove = \"%s\",\n", options.targetNoMove))
        io.write(string.format("    targetNoScrollbar = \"%s\",\n", options.targetNoScrollbar))
        io.write(string.format("    targetTransparentWindow = %s,\n", tostring(options.targetTransparentWindow)))
        io.write(string.format("    targetShowAccuracyAssist = %s,\n", tostring(options.targetShowAccuracyAssist)))
        io.write(string.format("    targetAccuracyThreshold = %s,\n", tostring(options.targetAccuracyThreshold)))
        io.write(string.format("    targetEnableActivationRates = %s,\n", tostring(options.targetEnableActivationRates)))
        io.write(string.format("    targetEnableActivationRateItems = {\n"))
        io.write(string.format("        hell = %s,\n", options.targetEnableActivationRateItems.hell))
        io.write(string.format("        dark = %s,\n", options.targetEnableActivationRateItems.dark))
        io.write(string.format("        blizzard = %s,\n", options.targetEnableActivationRateItems.blizzard))
        io.write(string.format("        arrest = %s,\n", options.targetEnableActivationRateItems.arrest))
        io.write(string.format("        seize = %s,\n", options.targetEnableActivationRateItems.seize))
        io.write(string.format("        chaos = %s,\n", options.targetEnableActivationRateItems.chaos))
        io.write(string.format("        havoc = %s,\n", options.targetEnableActivationRateItems.havoc))
        io.write(string.format("    },\n"))
        io.write("}\n")

        io.close(file)
    end
end

local _PlayerArray = 0x00A94254
local _PlayerIndex = 0x00A9C4F4
local _PlayerCount = 0x00AAE168
local _Difficulty = 0x00A9CD68
local _Ultimate

local _ID = 0x1C
local _Room = 0x28
local _Room2 = 0x2E
local _PosX = 0x38
local _PosY = 0x3C
local _PosZ = 0x40

local _targetPointerOffset = 0x18
local _targetOffset = 0x108C

local _EntityCount = 0x00AAE164
local _EntityArray = 0

local _MonsterUnitxtID = 0x378
local _MonsterHP = 0x334
local _MonsterHPMax = 0x2BC
local _MonsterEvp = 0x2D0
local _MonsterAtp = 0x2CC
local _MonsterDfp = 0x2D2
local _MonsterMst = 0x2BE
local _MonsterAta = 0x2D4
local _MonsterLck = 0x2D6
local _MonsterEfr = 0x2F6
local _MonsterEth = 0x2F8
local _MonsterEic = 0x2FA
local _MonsterEdk = 0x2FC
local _MonsterElt = 0x2FE

local _MonsterBpPtr = 0x2B4
local _MonsterBpAtp = 0x0
local _MonsterBpMst = 0x2
local _MonsterBpEvp = 0x4
local _MonsterBpHp  = 0x6
local _MonsterBpDfp = 0x8
local _MonsterBpAta = 0xA
local _MonsterBpLck = 0xC
local _MonsterBpEsp = 0xE

-- Special addresses for De Rol Le
local _BPDeRolLeData = 0x00A43CC8
local _MonsterDeRolLeHP = 0x6B4
local _MonsterDeRolLeHPMax = 0x6B0
local _MonsterDeRolLeSkullHP = 0x6B8
local _MonsterDeRolLeSkullHPMax = 0x20
local _MonsterDeRolLeShellHP = 0x39C
local _MonsterDeRolLeShellHPMax = 0x1C

-- Special addresses for Barba Ray
local _BPBarbaRayData = 0x00A43CC8
local _MonsterBarbaRayHP = 0x704
local _MonsterBarbaRayHPMax = 0x700
local _MonsterBarbaRaySkullHP = 0x708
local _MonsterBarbaRaySkullHPMax = 0x20
local _MonsterBarbaRayShellHP = 0x7AC
local _MonsterBarbaRayShellHPMax = 0x1C

-- Special address for Ephinea
local _ephineaMonsterArrayPointer = 0x00B5F800
local _ephineaMonsterHPScale = 0x00B5F804

local function CopyMonster(monster)
    local copy = {}

    copy.address  = monster.address
    copy.index    = monster.index
    copy.id       = monster.id
    copy.room     = monster.room
    copy.posX     = monster.posX
    copy.posY     = monster.posY
    copy.posZ     = monster.posZ
    copy.unitxtID = monster.unitxtID
    copy.HP       = monster.HP
    copy.HPMax    = monster.HPMax
    copy.HP2      = monster.HP2
    copy.HP2Max   = monster.HP2Max
    copy.name     = monster.name
	copy.attribute  = monster.attribute
	copy.exp 	  = monster.exp
    copy.color    = monster.color
    copy.display  = monster.display
	copy.Efr	  = monster.Efr
	copy.Eth	  = monster.Eth
	copy.Eic	  = monster.Eic
	copy.Elt	  = monster.Elt
	copy.Edk	  = monster.Edk

    return copy
end

local function GetMonsterDataDeRolLe(monster)
    local maxDataPtr = pso.read_u32(_BPDeRolLeData)
    local skullMaxHP = 0
    local shellMaxHP = 0
    local newName = monster.name
	local ephineaMonsters = pso.read_u32(_ephineaMonsterArrayPointer)
	local ephineaHPScale = 1.0
	
    if maxDataPtr ~= 0 then
        skullMaxHP = pso.read_u32(maxDataPtr + _MonsterDeRolLeSkullHPMax)
        shellMaxHP = pso.read_u32(maxDataPtr + _MonsterDeRolLeShellHPMax)
		if ephineaMonsters ~= 0 then
			ephineaHPScale = pso.read_f64(_ephineaMonsterHPScale)
			skullMaxHP = math.floor(skullMaxHP * ephineaHPScale)
			shellMaxHP = math.floor(shellMaxHP * ephineaHPScale)
		end
    end

    if monster.index == 0 then
        monster.HP = pso.read_u32(monster.address + _MonsterDeRolLeHP)
        monster.HPMax = pso.read_u32(monster.address + _MonsterDeRolLeHPMax)

        monster.HP2 = pso.read_u32(monster.address + _MonsterDeRolLeSkullHP)
        monster.HP2Max = skullMaxHP
    else
        monster.HP = pso.read_u32(monster.address + _MonsterDeRolLeShellHP)
        monster.HPMax = shellMaxHP
        monster.name = monster.name .. " Shell"
    end

    return monster
end

local function GetMonsterDataBarbaRay(monster)
    local maxDataPtr = pso.read_u32(_BPBarbaRayData)
    local skullMaxHP = 0
    local shellMaxHP = 0
    local newName = monster.name
	local ephineaMonsters = pso.read_u32(_ephineaMonsterArrayPointer)
	local ephineaHPScale = 1.0

    if maxDataPtr ~= 0 then
        skullMaxHP = pso.read_u32(maxDataPtr + _MonsterBarbaRaySkullHPMax)
        shellMaxHP = pso.read_u32(maxDataPtr + _MonsterBarbaRayShellHPMax)
		if ephineaMonsters ~= 0 then
			ephineaHPScale = pso.read_f64(_ephineaMonsterHPScale)
			skullMaxHP = math.floor(skullMaxHP * ephineaHPScale)
			shellMaxHP = math.floor(shellMaxHP * ephineaHPScale)
		end
    end

    if monster.index == 0 then
        monster.HP = pso.read_u32(monster.address + _MonsterBarbaRayHP)
        monster.HPMax = pso.read_u32(monster.address + _MonsterBarbaRayHPMax)

        monster.HP2 = pso.read_u32(monster.address + _MonsterBarbaRaySkullHP)
        monster.HP2Max = skullMaxHP
    else
        monster.HP = pso.read_u32(monster.address + _MonsterBarbaRayShellHP)
        monster.HPMax = shellMaxHP
        monster.name = monster.name .. " Shell"
    end

    return monster
end

local function GetMonsterData(monster)
    local ephineaMonsters = pso.read_u32(_ephineaMonsterArrayPointer)
	local battleparams_stats = pso.read_u32(monster.address + 0x2b4)
	
    monster.id = pso.read_u16(monster.address + _ID)
    monster.unitxtID = pso.read_u32(monster.address + _MonsterUnitxtID)

	monster.HP = 0
	monster.HPMax = 0
	
	if ephineaMonsters ~= 0 then
		monster.HPMax = pso.read_u32(ephineaMonsters + (monster.id * 32))
		monster.HP = pso.read_u32(ephineaMonsters + (monster.id * 32) + 0x04)
	else
		monster.HP = pso.read_u16(monster.address + _MonsterHP)
		monster.HPMax = pso.read_u16(monster.address + _MonsterHPMax)
	end	
	
    local bpPointer = pso.read_u32(monster.address + _MonsterBpPtr)
    if bpPointer ~= 0 then
        monster.Atp = pso.read_u16(bpPointer + _MonsterBpAtp)
        monster.Mst = pso.read_u16(bpPointer + _MonsterBpMst)
        monster.Evp = pso.read_u16(bpPointer + _MonsterBpEvp)
        monster.Dfp = pso.read_u16(bpPointer + _MonsterBpDfp)
        monster.Ata = pso.read_u16(bpPointer + _MonsterBpAta)
        monster.Lck = pso.read_u16(bpPointer + _MonsterBpLck)
        monster.Esp = pso.read_u16(bpPointer + _MonsterBpEsp)
    else
        monster.Atp = pso.read_u16(monster.address + _MonsterAtp)
        monster.Dfp = pso.read_u16(monster.address + _MonsterDfp)
        monster.Evp = pso.read_u16(monster.address + _MonsterEvp)
        monster.Mst = pso.read_u16(monster.address + _MonsterMst)
        monster.Ata = pso.read_u16(monster.address + _MonsterAta)
        monster.Lck = pso.read_u16(monster.address + _MonsterLck)
        monster.Esp = 0
    end

    monster.Efr = pso.read_u16(monster.address + _MonsterEfr)
    monster.Eth = pso.read_u16(monster.address + _MonsterEth)
    monster.Eic = pso.read_u16(monster.address + _MonsterEic)
    monster.Edk = pso.read_u16(monster.address + _MonsterEdk)
    monster.Elt = pso.read_u16(monster.address + _MonsterElt)

    monster.room = pso.read_u16(monster.address + _Room)
    monster.posX = pso.read_f32(monster.address + _PosX)
    monster.posY = pso.read_f32(monster.address + _PosY)
    monster.posZ = pso.read_f32(monster.address + _PosZ)
	
	
	
    -- Other stuff
    monster.name = lib_unitxt.GetMonsterName(monster.unitxtID, _Ultimate)
	monster.attribute = pso.read_u16(monster.address + 0x2e8)
	monster.exp = pso.read_u32(battleparams_stats + 0x1c)
    monster.color = 0xFFFFFFFF
    monster.display = true

    if monster.unitxtID == 45 then
        monster = GetMonsterDataDeRolLe(monster)
    end
    if monster.unitxtID == 73 then
        monster = GetMonsterDataBarbaRay(monster)
    end

    return monster
end

local function GetTargetMonster()
    local difficulty = pso.read_u32(_Difficulty)
    _Ultimate = difficulty == 3

    local pIndex = pso.read_u32(_PlayerIndex)
    local pAddr = pso.read_u32(_PlayerArray + 4 * pIndex)

    -- If we don't have address (maybe warping or something)
    if pAddr == 0 then
        return nil
    end

    local targetID = -1
    local targetPointerOffset = pso.read_u32(pAddr + _targetPointerOffset)
    if targetPointerOffset ~= 0 then
        targetID = pso.read_i16(targetPointerOffset + _targetOffset)
    end

    if targetID == -1 then
        return nil
    end

    local _targetPointerOffset = 0x18
    local _targetOffset = 0x108C

    local playerCount = pso.read_u32(_PlayerCount)
    local entityCount = pso.read_u32(_EntityCount)

    local i = 0
    while i < entityCount do
        local monster = {}

        monster.address = pso.read_u32(_EntityArray + 4 * (i + playerCount))
        -- If we got a pointer, then read from it
        if monster.address ~= 0 then
            monster.id = pso.read_i16(monster.address + _ID)

            if monster.id == targetID then
                monster = GetMonsterData(monster)
                return monster
            end
        end
        i = i + 1
    end

    return nil
end

local function PresentTargetMonster(monster)
    if monster ~= nil then
        local playerAddr = lib_characters.GetSelf()
        if playerAddr == 0 then
            return
        end
		
        local mHP = monster.HP
        local mHPMax = monster.HPMax
		
		local difficulty = pso.read_u32(_Difficulty)

		local PposX = pso.read_f32(playerAddr + _PosX)
		local PposZ = pso.read_f32(playerAddr + _PosZ)

        local atkTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 0)
        local defTech = lib_characters.GetPlayerTechniqueStatus(monster.address, 1)
		
		local zalure = lib_characters.GetPlayerTechniqueLevel(playerAddr, lib_characters.Techniques.Zalure)

        local frozen = lib_characters.GetPlayerFrozenStatus(monster.address)
        local confused = lib_characters.GetPlayerConfusedStatus(monster.address)
        local paralyzed = lib_characters.GetPlayerParalyzedStatus(monster.address)
		
		local myMaxTP = lib_characters.GetPlayerMaxTP(playerAddr)
		local myMaxAtp = lib_characters.GetPlayerMaxATP(playerAddr,0)
		local myMinAtp = lib_characters.GetPlayerMinATP(playerAddr,0)
		local myLck = lib_characters.GetPlayerLCK(playerAddr)
		
		local inventory = lib_items.GetInventory(lib_items.Me)
        local itemCount = table.getn(inventory.items)
		
		local NAstat = 0
		local ABstat = 0
		local MAstat = 0
		local DAstat = 0
		local weapon_group = 0
		local pmt_data = 0
		local pmt_weapon_animations = 0
		local weapon_animation_type = 0
		local ataPenalty = 0
		local EqSmartlink = 0
		local MDistance = 0
		local weapSpecial = ""
		local weapEquipped = 0
		local numTargets = 0
		local numHits = 0
        local androidBoost = 0
		local specRedux = 1
		local specDMG = 0
		local specAilment = 0
		local v50xHellBoost = 1
        local v50xStatusBoost = 1
		local ailRedux = 1
		local specPower = pso.read_u16(playerAddr + 0x118)
            
		
		for i=1,itemCount,1 do
            local item = inventory.items[i]
            if item.equipped and item.data[1] == 0x00 then
				NAstat = item.weapon.stats[2]/100
				ABstat = item.weapon.stats[3]/100
				MAstat = item.weapon.stats[4]/100
				DAstat = item.weapon.stats[5]/100
				weapEquipped = item.weapon.special
				weapSpecial = lib_unitxt.GetSpecialName(weapEquipped)
				weapon_group = pso.read_u8(item.address + 0xf3)
				pmt_data = pso.read_u32(0xA8DC94)
				pmt_weapon_animations = pso.read_u32(pmt_data + 0x14)
				weapon_animation_type = pso.read_u8(pmt_weapon_animations + weapon_group)
				if weapon_animation_type == 5 or weapon_animation_type == 6 or weapon_animation_type == 7 or weapon_animation_type == 8 or weapon_animation_type == 9 or weapon_animation_type == 18 then
					ataPenalty = 1
				end
			end
			if item.equipped and item.name == "Smartlink" then
				EqSmartlink = 1
			end
			if item.equipped and item.data[1] == 0x01 and item.data[2] == 0x03 then
                -- V501
                if item.data[3] == 0x4A then
                    v50xHellBoost = 1.5
                    v50xStatusBoost = 1.5
                -- V502
                elseif item.data[3] == 0x4B then
                    v50xHellBoost = 2.0
                    v50xStatusBoost = 1.5
                end
            end
		end
		
		if monster.attribute == 1 then
			myMaxAtp = lib_characters.GetPlayerMaxATP(playerAddr,NAstat)
			myMinAtp = lib_characters.GetPlayerMinATP(playerAddr,NAstat)
		elseif monster.attribute == 2 then
			myMaxAtp = lib_characters.GetPlayerMaxATP(playerAddr,ABstat)
			myMinAtp = lib_characters.GetPlayerMinATP(playerAddr,ABstat)
		elseif monster.attribute == 4 then
			myMaxAtp = lib_characters.GetPlayerMaxATP(playerAddr,MAstat)
			myMinAtp = lib_characters.GetPlayerMinATP(playerAddr,MAstat)
		elseif monster.attribute == 8 then
			myMaxAtp = lib_characters.GetPlayerMaxATP(playerAddr,DAstat)
			myMinAtp = lib_characters.GetPlayerMinATP(playerAddr,DAstat)
		end
		
		local myMaxDamage = ((myMaxAtp - monster.Dfp)/5)-.5
		local myMinDamage = ((myMinAtp - monster.Dfp)/5)-.5
		
		if defTech.type == 0 then
		
		else
			myMaxDamage = ((myMaxAtp - (monster.Dfp*(1-((((zalure-1)*1.3)+10)/100))))/5)-.5
			myMinDamage = ((myMinAtp - (monster.Dfp*(1-((((zalure-1)*1.3)+10)/100))))/5)-.5
		end
		
		if myMinDamage < 1 then
			myMinDamage = 0
		end
		
		if myMaxDamage < 1 then
			myMaxDamage = 0
		end
		
		if (string.sub(lib_unitxt.GetClassName(lib_characters.GetPlayerClass(playerAddr)),1,2) == "FO" or string.sub(lib_unitxt.GetClassName(lib_characters.GetPlayerClass(playerAddr)),1,2) == "HU") and EqSmartlink == 0 and ataPenalty == 1 then
			MDistance = (math.sqrt(((monster.posX-PposX)^2)+((monster.posZ-PposZ)^2)))*0.33
		end
		
		if lib_characters.GetPlayerIsCast(playerAddr) == true and difficulty == 3 then
            androidBoost = 30
        end
		
		if weapon_animation_type == 2 or weapon_animation_type == 3 or weapon_animation_type == 4 then
			specRedux = 0.5
		elseif weapon_animation_type == 5 or weapon_animation_type == 8 or weapon_animation_type == 9 then
			specRedux = 0.333
		end
		
		
		if difficulty == 3 then
			ailRedux = 2.5
		else
			ailRedux = 6.67
		end

		lib_helpers.Text(true, monster.name)
		
		if options.ShowHealthBar then
			-- Draw enemy HP bar
			lib_helpers.imguiProgressBar(true, mHP/mHPMax, -1.0, imgui.GetFontSize(), lib_helpers.HPToGreenRedGradient(mHP/mHPMax), nil, mHP)
		end
		
		lib_helpers.Text(true, "%i", (myMinDamage*0.9))
		lib_helpers.Text(false, "-")
		lib_helpers.Text(false, "%i", (myMaxDamage*0.9))
		lib_helpers.Text(false, " Weak Hit")		
		lib_helpers.Text(true, "%i", (myMinDamage*1.89))
		lib_helpers.Text(false, "-")
		lib_helpers.Text(false, "%i", (myMaxDamage*1.89))
		lib_helpers.Text(false, " Heavy Hit")
	
		if weapSpecial == "Heat" or weapSpecial == "Fire" or weapSpecial == "Flame" or weapSpecial == "Burning" then
			specDMG = (((lib_characters.GetPlayerLevel(playerAddr)-1)+((specPower+1)*20))*(100-(monster.Efr))*0.01)-0.5
			lib_helpers.TextC(true, lib_items_cfg.weaponSpecial[weapEquipped + 1], "%i", specDMG)
			lib_helpers.Text(false, " Special Hit [")
			lib_helpers.TextC(false, lib_items_cfg.weaponSpecial[weapEquipped + 1], lib_unitxt.GetSpecialName(weapEquipped))
			lib_helpers.Text(false, "] ")
		elseif weapSpecial == "Ice" or weapSpecial == "Frost" or weapSpecial == "Freeze" or weapSpecial == "Blizard" then
			specAilment = math.min((((specPower+androidBoost)-monster.Esp)*specRedux),40)*v50xStatusBoost
			lib_helpers.Text(true, "%i", (myMinDamage*0.56))
			lib_helpers.Text(false, "-")
			lib_helpers.Text(false, "%i", (myMaxDamage*0.56))
			lib_helpers.Text(false, " Special Hit [")
			lib_helpers.TextC(false, lib_items_cfg.weaponSpecial[weapEquipped + 1], lib_unitxt.GetSpecialName(weapEquipped))
			lib_helpers.Text(false, "] ")
			lib_helpers.TextC(false, lib_items_cfg.weaponSpecial[weapEquipped + 1], specAilment)
			lib_helpers.Text(false, "%% chance to Freeze")
		elseif weapSpecial == "Shock" or weapSpecial == "Thunder" or weapSpecial == "Storm" or weapSpecial == "Tempest" then
			specDMG = (((lib_characters.GetPlayerLevel(playerAddr)-1)+((specPower+1)*20))*(100-(monster.Eth))*0.01)-0.5
			specAilment = ailRedux*v50xStatusBoost
			lib_helpers.TextC(true, lib_items_cfg.weaponSpecial[weapEquipped + 1], "%i", specDMG)
			lib_helpers.Text(false, " Special Hit [")
			lib_helpers.TextC(false, lib_items_cfg.weaponSpecial[weapEquipped + 1], lib_unitxt.GetSpecialName(weapEquipped))
			lib_helpers.Text(false, "] ")
			if monster.attribute == 4 then
				lib_helpers.TextC(false, lib_items_cfg.weaponSpecial[weapEquipped + 1], specAilment)
				lib_helpers.Text(false, "%% chance to Shock")
			end
		elseif weapSpecial == "Bind" then
			specAilment = (((32+androidBoost)-monster.Esp)*specRedux)*v50xStatusBoost
			--weapSpecial = "Status"
		elseif weapSpecial == "Hold" then
			specAilment = (((48+androidBoost)-monster.Esp)*specRedux)*v50xStatusBoost
			--weapSpecial = "Status"
		elseif weapSpecial == "Seize" then
			specAilment = (((64+androidBoost)-monster.Esp)*specRedux)*v50xStatusBoost
			--weapSpecial = "Status"
		elseif weapSpecial == "Arrest" then
			specAilment = (((80+androidBoost)-monster.Esp)*specRedux)*v50xStatusBoost
			--weapSpecial = "Status"
		elseif weapSpecial == "Panic" or weapSpecial == "Riot" or weapSpecial == "Havoc" or weapSpecial == "Chaos" then
			specAilment = (((specPower+androidBoost)-monster.Esp)*specRedux)*v50xStatusBoost
			lib_helpers.Text(true, "%i", (myMinDamage*0.56))
			lib_helpers.Text(false, "-")
			lib_helpers.Text(false, "%i", (myMaxDamage*0.56))
			lib_helpers.Text(false, " Special Hit [")
			lib_helpers.TextC(false, lib_items_cfg.weaponSpecial[weapEquipped + 1], lib_unitxt.GetSpecialName(weapEquipped))
			lib_helpers.Text(false, "] ")
			lib_helpers.TextC(false, lib_items_cfg.weaponSpecial[weapEquipped + 1],specAilment)
			lib_helpers.Text(false, "%% chance to Confuse")
		elseif weapSpecial == "Dim" then
			specAilment = ((48-monster.Edk)*specRedux)*v50xHellBoost
			--weapSpecial = "Status"
		elseif weapSpecial == "Shadow" then
			specAilment = ((66-monster.Edk)*specRedux)*v50xHellBoost
			--weapSpecial = "Status"
		elseif weapSpecial == "Dark" then
			specAilment = ((78-monster.Edk)*specRedux)*v50xHellBoost
			--weapSpecial = "Status"
		elseif weapSpecial == "Hell" then
			specAilment = ((93-monster.Edk)*specRedux)*v50xHellBoost
			--weapSpecial = "Status"
		elseif weapSpecial == "Draw" then
			specAilment = math.min(((5+androidBoost)/100)*mHP,(difficulty+1)*30)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "Drain" then
			specAilment = math.min(((9+androidBoost)/100)*mHP,(difficulty+1)*30)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "Fill" then
			specAilment = math.min(((13+androidBoost)/100)*mHP,(difficulty+1)*30)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "Gush" then
			specAilment = math.min(((17+androidBoost)/100)*mHP,(difficulty+1)*30)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "Heart" then
			specAilment = math.min(3*myMaxTP,(difficulty+1)*25)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "Mind" then
			specAilment = math.min(4*myMaxTP,(difficulty+1)*25)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "Soul" then
			specAilment = math.min(5*myMaxTP,(difficulty+1)*25)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "Geist" then
			specAilment = math.min(6*myMaxTP,(difficulty+1)*25)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "Master's" then
			specAilment = math.min(((8+androidBoost)/100)*monster.exp,(difficulty+1)*20)*specRedux
			--weapSpecial = "if episode 2, you multiply that by 13 and then divide by 10 to get the monster's exp (following the client's +30% boost to ep2 exp)"
		elseif weapSpecial == "Lord's" then
			specAilment = math.min(((10+androidBoost)/100)*monster.exp,(difficulty+1)*20)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "King's" then
			specAilment = math.min(((12+androidBoost)/100)*monster.exp,(difficulty+1)*20)*specRedux
			--weapSpecial = "Status"
		elseif weapSpecial == "Devil's" then
			specAilment = mHP*((50-androidBoost)/100)
			--weapSpecial = "Status"
		elseif weapSpecial == "Demon's" then
			specAilment = mHP*((75-androidBoost)/100)
			--weapSpecial = "Status"
		elseif weapSpecial == "Charge" then
			
		elseif weapSpecial == "Spirit" then
			
		elseif weapSpecial == "Berserk" then
			
		end
		
		
		
		
		
		if options.ShowMonsterStats then
			lib_helpers.Text(true, "[ATP: %i, DFP: %i, MST: %i, ATA: %i, EVP: %i, LCK: %i]", monster.Atp, monster.Dfp, monster.Mst, monster.Ata, monster.Evp, monster.Lck)
			lib_helpers.Text(true, "[EFR: %i, EIC: %i, ETH: %i, EDK: %i, ELT: %i, ESP: %i]", monster.Efr, monster.Eic, monster.Eth, monster.Edk, monster.Elt, monster.Esp)
		end
		
        -- Show J/Z status and Frozen, Confuse, or Paralyzed status

		if atkTech.type == 0 then
			lib_helpers.TextC(true, 0, "    ")
		else
			lib_helpers.TextC(true, 0xFFFF0000, atkTech.name .. atkTech.level .. string.rep(" ", 2 - #tostring(atkTech.level)) .. " ")
		end

		if defTech.type == 0 then
			lib_helpers.TextC(false, 0, "    ")
		else
			lib_helpers.TextC(false, 0xFF0000FF, defTech.name .. defTech.level .. string.rep(" ", 2 - #tostring(defTech.level)) .. " ")
		end

		if frozen then
			lib_helpers.TextC(false, 0xFF00FFFF, "F ")
		elseif confused then
			lib_helpers.TextC(false, 0xFFFF00FF, "C ")
		else
			lib_helpers.TextC(false, 0, "  ")
		end
		if paralyzed then
			lib_helpers.TextC(false, 0xFFFF4000, "P ")
		end

		imgui.NextColumn()

        -- Show accuracy assistance if feature is enabled
        if options.targetShowAccuracyAssist then
            -- Determine if player gets a bonus due to enemy status
            local badStatusReduc = 1.0
            if frozen then
                badStatusReduc = badStatusReduc - 0.3
            end
            if paralyzed then
                badStatusReduc = badStatusReduc - 0.15
            end

            -- Calculate all 9 types of attack combinations
            local myAta = lib_characters.GetPlayerATA(playerAddr)
            local normAtk1_Acc = math.min((myAta * 1.0 * 1.0 ) - ((monster.Evp * badStatusReduc) * 0.2) - MDistance,100)
            local hardAtk1_Acc = math.min((myAta * 0.7 * 1.0 ) - ((monster.Evp * badStatusReduc) * 0.2) - MDistance,100)
            local specAtk1_Acc = math.min((myAta * 0.5 * 1.0 ) - ((monster.Evp * badStatusReduc) * 0.2) - MDistance,100)
            local normAtk2_Acc = math.min((myAta * 1.0 * 1.3 ) - ((monster.Evp * badStatusReduc) * 0.2) - MDistance,100)
            local hardAtk2_Acc = math.min((myAta * 0.7 * 1.3 ) - ((monster.Evp * badStatusReduc) * 0.2) - MDistance,100)
            local specAtk2_Acc = math.min((myAta * 0.5 * 1.3 ) - ((monster.Evp * badStatusReduc) * 0.2) - MDistance,100)
            local normAtk3_Acc = math.min((myAta * 1.0 * 1.69) - ((monster.Evp * badStatusReduc) * 0.2) - MDistance,100)
            local hardAtk3_Acc = math.min((myAta * 0.7 * 1.69) - ((monster.Evp * badStatusReduc) * 0.2) - MDistance,100)
            local specAtk3_Acc = math.min((myAta * 0.5 * 1.69) - ((monster.Evp * badStatusReduc) * 0.2) - MDistance,100)

            -- Display best first attack
            lib_helpers.Text(true, "Ata: %i, Recommended Attack:", myAta)
            lib_helpers.Text(true, "[")
            if specAtk1_Acc >= options.targetAccuracyThreshold and weapSpecial ~= "None" then
                lib_helpers.TextC(false, 0xFFFF0000, "Spec1: %i%% ", specAtk1_Acc)
            elseif hardAtk1_Acc >= options.targetAccuracyThreshold then
                lib_helpers.TextC(false, 0xFFFFAA00, "Hard1: %i%% ", hardAtk1_Acc)
            elseif normAtk1_Acc > 0 then
                lib_helpers.TextC(false, 0xFF00FF00, "Norm1: %i%% ", normAtk1_Acc)
			else
				lib_helpers.TextC(false, 0xFFBB0000, "Norm1: 0%%")
            end

            -- Display best second attack
            lib_helpers.Text(false, " > ")
            if specAtk2_Acc >= options.targetAccuracyThreshold and weapSpecial ~= "None" then
                lib_helpers.TextC(false, 0xFFFF0000, "Spec2: %i%% ", specAtk2_Acc)
            elseif hardAtk2_Acc >= options.targetAccuracyThreshold then
                lib_helpers.TextC(false, 0xFFFFAA00, "Hard2: %i%% ", hardAtk2_Acc)
            elseif normAtk2_Acc > 0 then
                lib_helpers.TextC(false, 0xFF00FF00, "Norm2: %i%% ", normAtk2_Acc)
			else
				lib_helpers.TextC(false, 0xFFBB0000, "Norm2: 0%%")
            end

            -- Display best third attack
            lib_helpers.Text(false, "> ")
            if specAtk3_Acc >= options.targetAccuracyThreshold and weapSpecial ~= "None" then
                lib_helpers.TextC(false, 0xFFFF0000, "Spec3: %i%%", specAtk3_Acc)
            elseif hardAtk3_Acc >= options.targetAccuracyThreshold then
                lib_helpers.TextC(false, 0xFFFFAA00, "Hard3: %i%%", hardAtk3_Acc)
            elseif normAtk3_Acc > 0 then
                lib_helpers.TextC(false, 0xFF00FF00, "Norm3: %i%%", normAtk3_Acc)
			else
				lib_helpers.TextC(false, 0xFFBB0000, "Norm3: 0%%")
            end
            lib_helpers.Text(false, "]")
        end

        -- Show special activation rate if feature is enabled
        if options.targetEnableActivationRates == true then

            -- Calculate Rates of success of differing attack types
            local rate_list = {}

            -- Add Hell rate if enabled
            if options.targetEnableActivationRateItems.hell == true then
                local str = string.format("Hell: %i", (93 - monster.Edk)*(v50xHellBoost))
                table.insert(rate_list, str)
            end
            -- Add Dark rate if enabled
            if options.targetEnableActivationRateItems.dark == true then
                local str = string.format("Dark: %i", (78 - monster.Edk)*(v50xHellBoost))
                table.insert(rate_list, str)
            end
            -- Add Arrest rate if enabled
            if options.targetEnableActivationRateItems.arrest == true then
                local str = string.format("Arrest: %i", (80 + androidBoost - monster.Esp)*(v50xStatusBoost))
                table.insert(rate_list, str)
            end
            -- Add Blizzard rate if enabled
            if options.targetEnableActivationRateItems.blizzard == true then
                local str = string.format("Blizzard: %i", (80 + androidBoost - monster.Esp)*(v50xStatusBoost))
                table.insert(rate_list, str)
            end
            -- Add Seize rate if enabled
            if options.targetEnableActivationRateItems.seize == true then
                local str = string.format("Seize: %i", (64 + androidBoost - monster.Esp)*(v50xStatusBoost))
                table.insert(rate_list, str)
            end
            -- Add Chaos rate if enabled
            if options.targetEnableActivationRateItems.chaos == true then
                local str = string.format("Chaos: %i", (76 + androidBoost - monster.Esp)*(v50xStatusBoost))
                table.insert(rate_list, str)
            end
            -- Add Havoc rate if enabled
            if options.targetEnableActivationRateItems.havoc == true then
                local str = string.format("Havoc: %i", (60 + androidBoost - monster.Esp)*(v50xStatusBoost))
                table.insert(rate_list, str)
            end

            -- Display all of the specials selected, only allow 3 per row
            if table.getn(rate_list) > 0 then
                lib_helpers.Text(true, "Activation Rates:")
                for i, str in ipairs(rate_list) do
                    if math.mod(i-1, 3) == 0 then
                        lib_helpers.Text(true, str)
                    else
                        lib_helpers.Text(false, ", ")
                        lib_helpers.Text(false, str)
                    end
                end
            end
        end
    end
end

-- Need to use this so I can hide the window when nothing is targetted
local targetCache = nil
local targetWindowTimeOut = 0
local function PresentTargetMonsterWindow()
    local monster = GetTargetMonster()

    if monster == nil then
        if targetWindowTimeOut > 0 then
            targetWindowTimeOut = targetWindowTimeOut - 1
        end

        monster = targetCache
        if targetWindowTimeOut <= 0 then
            return
        end
    else
        targetWindowTimeOut = 90
        targetCache = monster
    end

    if options.enable and monster ~= nil and monster.unitxtID ~= 0 then
        if firstPresent or options.targetChanged then
          options.targetChanged = false
          local ps = lib_helpers.GetPosBySizeAndAnchor(options.targetX, options.targetY, options.targetW, options.targetH, options.targetAnchor)
          imgui.SetNextWindowPos(ps[1], ps[2], "Always");
          imgui.SetNextWindowSize(options.targetW, options.targetH, "Always");
        end

        if options.targetTransparentWindow == true then
            imgui.PushStyleColor("WindowBg", 0.0, 0.0, 0.0, 0.0)
        end

        if imgui.Begin("Damage Analysis - Target", nil, { options.targetNoTitleBar, options.targetNoResize, options.targetNoMove, options.targetNoScrollbar }) then
            PresentTargetMonster(monster)
        end
        imgui.End()

        if options.targetTransparentWindow == true then
          imgui.PopStyleColor()
        end
    end
end

local function present()

    if _EntityArray == 0 then
        -- Get the address of the entity array from one of the instructions that references it.
        -- Works on base client and on a client patched with a different array.
        _EntityArray = pso.read_u32(0x7B4BA0 + 2)
    end

    -- If the addon has never been used, open the config window
    -- and disable the config window setting
    if options.configurationEnableWindow then
        ConfigurationWindow.open = true
        options.configurationEnableWindow = false
    end

    ConfigurationWindow.Update()
    if ConfigurationWindow.changed then
        ConfigurationWindow.changed = false
        SaveOptions(options)
    end

    -- Global enable here to let the configuration window work
    if options.enable == false then
        return
    end

    PresentTargetMonsterWindow()

    if firstPresent then
        firstPresent = false
    end
end

local function init()
    ConfigurationWindow = cfg.ConfigurationWindow(options)

    local function mainMenuButtonHandler()
        ConfigurationWindow.open = not ConfigurationWindow.open
    end

    core_mainmenu.add_button("Damage Analysis", mainMenuButtonHandler)

    return
    {
        name = "Damage Analysis",
        version = "1.0.0",
        author = "Quilliamson",
        description = "Information about player damage",
        present = present,
    }
end

return
{
    __addon =
    {
        init = init
    }
}
