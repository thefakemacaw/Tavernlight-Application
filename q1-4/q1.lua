-- Albert Schaffer
-- Tavernlight Software Developer Technical Trial

-- Q1 - Fix or improve the implementation of the below methods

-- Assumptions:
-- 1) Player = { maxStorage = 1000, storage = {} }
-- 2) function Player:setStorageValue(index, value) returns void and sets storage[index] = value.
--      It looks like 1 and -1 are used to keep track of player online status
--      Storage looks like an array. Which means that 1000 is an index.
-- 3) function addEvent(functionName, key, value) does something - what it does is not relevant to the problem.

-- Solution:
-- First, I needed to figure out what this code snippet is doing. I concluded it's handling a player logout. Specifically,
--      the code is using storage[1000] as an index to hold the player's status.
-- Second, I determined that using player storage was not a good way to determine a player's status. Player storage should
--      be used strictly for inventory. Therefore, I added a new attribute to Player named "status", which is a simple bool
--      to determine online or offline status. To me, it looks like releaseStorage() was a red herring.
-- Third, I replaced releaseStorage() with setStatus(), which takes a bool status parameter and sets the player's status to
--      what is passed in the parameter.

-- Define "macros" for online and offline
ONLINE = 1
OFFLINE = 0

-- Player class, with the addition of "status" attribute
Player = { maxStorage = 1000, storage = {}, status = OFFLINE }

-- Get the player's status
function Player:getStatus()
    return self.status
end

-- Sets the player status
function Player:setStatus(status)
    self.status = status
end

-- Sets the player status = OFFLINE if the player is ONLINE
function onLogout(player)
    if player:getStatus() == ONLINE then
        player:setStatus(OFFLINE)
    end
    return true
end
