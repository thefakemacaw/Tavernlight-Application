-- Q2 - Fix or improve the implementation of the below method

-- Assumptions:
-- 1) We are using LuaSQL
-- 2) selectGuildQuery is a SQL query
-- 3) db is a SQL database
-- 4) All of the require headers exist and the database is connected.

-- Solution:
-- 1) I don't think this is properly using LuaSQL based on the resources I saw, so I changed
--      the code to properly fetch data from the database, assuming it was already connected.
-- 2) printSmallGuildNames() was not correctly printing all guilds whose size < memberCount.
--      If anything, it would have just printed one row of the results.
--      To resolve this, we need to iterate through the result.
--      Reference: https://www.tutorialspoint.com/lua/lua_database_access.htm

-- Print all guild names where guild size < memberCount
function printSmallGuildNames(memberCount)
    -- Execute selectGuildQuery
    local selectGuildQuery = [[SELECT name FROM guilds WHERE max_members < %d;]]
    local cursor, errorString = db:execute(string.format(selectGuildQuery, memberCount))

    -- Print db call for debugging
    print(cursor, errorString)

    -- Fetch the top row of the results from cursor
    local row = cursor:fetch({}, "a")

    -- Iterate through cursor rows and print the output
    while row do
        print(string.format("Guild: %s"), row.name)

        -- Then, get the next row from cursor results
        row = cursor:fetch({}, "a")
    end

    -- Close cursor
    cursor:close()
end
