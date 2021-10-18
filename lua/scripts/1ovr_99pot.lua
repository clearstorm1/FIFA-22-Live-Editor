--- This script will set all players attributes on 1 and potential on 99

-- Check if we are in Career Mode
local bIsInCM = IsInCM();

-- Reload Database in Live Editor memory
ReloadDB()

-- Reload Players Manager if we are in CM
-- This is required to properly handle Developement Plans
-- Can be ignored if you edit players that are not in your team
if (bIsInCM) then
    ReloadPlayersManager()
end

-- Get all rows for players table
local rows = GetDBTableRows("players")

local fields_to_edit = {
    -- GK
    "gkdiving",
    "gkhandling",
    "gkkicking",
    "gkpositioning",
    "gkreflexes",

    -- ATTACK
    "crossing",
    "finishing",
    "headingaccuracy",
    "shortpassing",
    "volleys",

    -- DEFENDING
    "marking",
    "standingtackle",
    "slidingtackle",

    -- SKILL
    "dribbling",
    "curve",
    "freekickaccuracy",
    "longpassing",
    "ballcontrol",

    -- POWER
    "shotpower",
    "jumping",
    "stamina",
    "strength",
    "longshots",

    -- MOVEMENT
    "acceleration",
    "sprintspeed",
    "agility",
    "reactions",
    "balance",

    -- MENTALITY
    "aggression",
    "composure",
    "interceptions",
    "positioning",
    "vision",
    "penalties",

    "overallrating"
}

local counter = 0;

for i=1, #rows do
    local player = rows[i]
    local iplayerid = math.floor(player.playerid.value)
    local has_dev_plan = false
    if (bIsInCM) then
        has_dev_plan = PlayerHasDevelopementPlan(iplayerid)
    end

    for j=1, #fields_to_edit do
        local field = fields_to_edit[j]
        player[field].value = "1"
        EditDBTableField(player[field])

        if (has_dev_plan) then 
            PlayerSetValueInDevelopementPlan(iplayerid, field, 1)
        end
    end

    player.modifier.value = "0"
    EditDBTableField(player.modifier)

    player.potential.value = "99"
    EditDBTableField(player.potential)

    counter = counter + 1

end

MessageBox("Done", string.format("Edited %d players\n", counter))
