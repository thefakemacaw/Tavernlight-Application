-- Q3 - Fix or improve the name and the implementation of the below method

-- Assumptions:
-- 1) Player = { playerId = 0, membername = nil }
-- 2) Party = { players = {} }
-- 3) Party:removePlayer(player) performs the deletion of the player from the party

-- Solution:
-- 1) I first renamed the function to leavePlayerParty to match what the function is doing.
--      That is, the function is first getting the player's party, then calling upon the party:removePlayer()
--      function to remove the player from their party. I.e. it represents a player choosing to leave their party.
-- 2) Then, to improve/fix the function, I moved the loop logic to Party:removePlayer(), and just let leavePlayerParty()
--      call party:removePlayer() to handle the removal of the player's name from the party. I think this is a much
--      more elegant solution to what was given because we're no longer messing around with getting the player for the
--      given playerId and instead just getting the player's party from the player "object" directly.
-- Note: Based on what I read online, I don't believe Lua offers any other way to remove an element from a table aside from a for loop,
--      so I kept the loop to find the player in the party.

-- Player class contains playerId and party attributes
Player = { playerId = 0, party = "" }

-- Get the Player Party
function Player:getParty()
    return self.party
end

-- Party class, which contains a table of Players
Party = { players = {} }

-- Party:removePlayer() now contains the for loop that was previously
-- in do_sth_with_PlayerParty() to handle Player removal
function Party:removePlayer(player)
    -- Perform the deletion
    for k, v in self.players do
        if v == player then
            self.players[k] = nil
        end
    end
end

-- do_sth_with_PlayerParty() has been renamed to leavePlayerParty()
-- Gets the user's party removes the player from their party
function leavePlayerParty(player)
    local party = player:getParty()
    print(party)
    party:removePlayer(player)
end
