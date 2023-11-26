local _PlayerArray = 0x00A94254
local _PlayerIndex = 0x00A9C4F4
local _PlayerCount = 0x00AAE168
local _EntityCount = 0x00AAE164
local _EntityArray = 0x00AAD720

local _MonsterIndex = "1"
local _MonsterAddress = ""
local _MonsterMem = {}
local _Now = 0

local function GetMonsterAddress(monsterIndex)
    local playerCount = pso.read_u32(_PlayerCount)
    local entityCount = pso.read_u32(_EntityCount)
    
    return (monsterIndex ~= nil) and pso.read_u32(_EntityArray + 4 * (monsterIndex - 1 + playerCount)) or 0
end

local function GetMonsterData(monsterAddress)
    local monsterMem = {}

    if monsterAddress ~= 0 then
        pso.read_mem(monsterMem, monsterAddress, 0x4000)
    end
    
    return monsterMem
end

local function present()
    local s1, s2
    
    imgui.Begin("Monster Data")
    
    imgui.PushItemWidth(30)
    s1, _MonsterIndex = imgui.InputText("", _MonsterIndex, 3)
    imgui.SameLine(0, 5)
    imgui.PushItemWidth(90)
    s2, _MonsterAddress = imgui.InputText(" ", _MonsterAddress, 11)
    
    if s1 or _MonsterAddress == "" then
        local monsterIndex = tonumber(_MonsterIndex)
        _MonsterAddress = "0x" .. string.format("%08X", GetMonsterAddress(monsterIndex))
    end
    
    local monsterAddress = tonumber(string.sub(_MonsterAddress, 3), 16)
    local success, monsterMem = pcall(GetMonsterData, monsterAddress)
    local k,v
    
    if success then
        for k,v in ipairs(monsterMem) do
            if k % 0x10 == 0x1 then
                imgui.Text(string.format("%04X", k-1))
                imgui.SameLine(0, 5)
            end
            
            if _Now - _MonsterMem[k].lastChange > 5 * 30 then
                imgui.TextColored(1.0, 1.0, 1.0, 1.0, string.format("%02X", v))
            elseif _Now - _MonsterMem[k].lastChange > 2 * 30 then
                imgui.TextColored(1.0, 1.0, 0.0, 1.0, string.format("%02X", v))
            else
                imgui.TextColored(1.0, 0.0, 0.0, 1.0, string.format("%02X", v))
            end
            
            if _MonsterMem[k].value ~= v then
                _MonsterMem[k].value = v
                _MonsterMem[k].lastChange = _Now
            end
            
            if k % 0x10 ~= 0x0 then
                imgui.SameLine(0, 5)
            end
        end
    else
        imgui.Text(monsterMem)
    end
    
    _Now = _Now + 1

    imgui.End()
end

local function init()
    local i
    
    for i=1,0x4000 do
        table.insert(_MonsterMem, { value = 0x00, lastChange = 0 })
    end

    return
    {
        name = "Monster Memory",
        version = "0.1.0",
        author = "staphen",
        description = "Memory dump for monsters",
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