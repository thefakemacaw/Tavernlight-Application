-- Q5

-- Solution:
-- After trying (and failing) to get the looping to work for advanced spell animations, my original solution involved creating
-- individual functions to cast the spell on each of the areas in the array. However, once I was able to get the for loop to
-- correctly cast and animate the spell, I switched to the for loop implementation for advanced spell casts as this provides a
-- much more elegant solution to what I had previously. It's not a perfect replication, but I think it's generally accurate to
-- the video.

-- References:
-- Simple script guide: https://otland.net/threads/lua-how-to-make-a-simple-spell-script.118474/
-- What I originally referred to: https://otland.net/threads/advanced-special-spell.83382/
-- A thread using advanced spell cast animations: https://otland.net/threads/advanced-ice-storm-spell.288740/
-- Another looping advanced spell cast animation: https://otland.net/threads/tfs-1-2-looking-for-unique-area-spell.278764/

local combats = {}

-- Create areas where spell is cast
-- I used a 4x3 grid to recreate the spell AoE. However, this had the effect of the spell not
-- being centered on the player.
local areas = {
    {
        -- Area 1
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 1, 0, 0, 0, 0, 0, 0 },
        { 1, 0, 0, 2, 2, 0, 1, 1 },
        { 0, 1, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 1, 1, 0, 0, 0 }
    },
    {
        -- Area 2
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 1, 1, 0, 0, 1, 0, 0 },
        { 1, 0, 0, 2, 2, 0, 1, 1 },
        { 0, 1, 0, 1, 1, 1, 0, 0 },
        { 0, 0, 1, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 1, 1, 0, 0, 0 }
    },
    {
        -- Area 3
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 0, 0, 1, 0, 0 },
        { 1, 1, 1, 3, 3, 1, 1, 1 },
        { 0, 0, 0, 1, 1, 1, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 }
    },
    {
        -- Area 4
        { 0, 0, 0, 1, 1, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 1, 0, 0, 0 },
        { 1, 1, 0, 3, 3, 0, 1, 1 },
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 }
    },
    {
        -- Area 5
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 0, 0, 1, 0, 0 },
        { 0, 1, 0, 0, 0, 0, 0, 0 },
        { 1, 1, 0, 3, 3, 0, 1, 1 },
        { 0, 1, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 1, 0, 0, 0 }
    },
    {
        -- Area 6
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 0, 0, 1, 0, 0 },
        { 0, 1, 1, 0, 0, 1, 1, 0 },
        { 1, 1, 1, 3, 3, 1, 1, 1 },
        { 0, 1, 1, 1, 1, 1, 1, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 1, 0, 0, 0 }
    },
    {
        -- Area 7
        { 0, 0, 0, 1, 1, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 1, 1, 1, 0 },
        { 1, 1, 0, 3, 3, 1, 1, 1 },
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 }
    },
    {
        -- Area 8
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 0, 0, 1, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 1, 1, 0, 3, 3, 0, 1, 1 },
        { 0, 1, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 1, 0, 0, 0 }
    },
    {
        -- Area 9 (repeats Area 6)
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 0, 0, 1, 0, 0 },
        { 0, 1, 1, 0, 0, 1, 1, 0 },
        { 1, 1, 1, 3, 3, 1, 1, 1 },
        { 0, 1, 1, 1, 1, 1, 1, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 1, 0, 0, 0 }
    },
    {
        -- Area 10 (repeats Area 7)
        { 0, 0, 0, 1, 1, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 1, 1, 1, 0 },
        { 1, 1, 0, 3, 3, 1, 1, 1 },
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 }
    },
    {
        -- Area 11
        { 0, 0, 0, 1, 1, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 0, 0, 0 },
        { 0, 0, 1, 3, 3, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 }
    },
    {
        -- Area 12
        { 0, 0, 0, 1, 1, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 1, 1, 0, 0, 0 },
        { 0, 0, 1, 3, 3, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0 }
    }
}

-- Create combat instances for each area by iterating through the areas
for i = 1, #areas do
    combats[i] = Combat()
    combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
    combats[i]:setArea(createCombatArea(areas[i]))
end

-- Executes the spell cast for each subsequent area
local function castSpell(creatureId, variant, combatIndex)
    local creature = Creature(creatureId)
    if creature then
        combats[combatIndex]:execute(creature, variant)
    end
end

-- Casts the spell, iterating through each of the areas after
-- the first AoE
function onCastSpell(creature, variant)
    for i = 2, #areas do
        -- Need to pass creatureId because passing creature is unsafe
        addEvent(castSpell, 300 * (i - 1), creature:getId(), variant, i)
    end
    return combats[1]:execute(creature, variant)
end
