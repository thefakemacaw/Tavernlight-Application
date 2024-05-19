// Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

/*
 * Assumptions:
 * 1) IOLoginData::loadPlayerByName(player, recipient) is populating the player passed in the function based
 *    on stored data associated with "recipient". It returns a Player object, and if it fails, it should
 *	  return nullptr.
 * 2) If a player doesn't exist for the recipient name when calling g_game.getPlayerByName(), it returns nullptr.
 * 	  Same goes for Item::CreateItem() - if there isn't an item that exists for the given itemId, it returns nullptr.
 *
 * Solution:
 * 1) I started by looking at the code. I added comments to figure out what was happening.
 * 2) Quick reminder for what could cause memory leaks in C++ (not comprehensive):
 *		a) Whenever the "new" keyword is used, we need a corresponding "delete" keyword.
 *		   Using "new" means we're using heap memory to allocate and store the data
 *		b) A wrong pointer assignment could cause a memory leak
 * 3) With this in mind, let's see what could possibly be causing the memory leak here:
 *		a) player = new Player(nullptr); --> seems like a culprit since there's no corresponding delete for it.
 *		   In this case, we need to delete when the player object fails to be populated by loadPlayerByName().
 *		   If this method succeeds, it would contain the player data of the player associated with recipient.
 *		   However, if it fails, we are returning from addItemToPlayer() without deleting the allocated data.
 */

/*
 * Adds an item to the player's inventory
 *
 * Parameters:
 *	std::string& recipient: the player's name
 *  uint16_t itemId:        the ID number of the item the player will receive
 */
void Game::addItemToPlayer(const std::string &recipient, uint16_t itemId)
{
	// Get the in-game player object associated with recipient name
	Player *player = g_game.getPlayerByName(recipient);

	// If the player is not in-game, attempt to load their information from recipient name
	if (!player)
	{
		// Create an empty player object to load player information into
		player = new Player(nullptr);

		if (!IOLoginData::loadPlayerByName(player, recipient))
		{
			delete player; // resolve the mem leak
			return;
		}
	}

	// Create the item for the given itemId
	Item *item = Item::CreateItem(itemId);

	// If there isn't an item associated with the given itemId, return
	if (!item)
	{
		return;
	}

	// Add the item to the inventory of player
	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	// Updates and saves the new player info if they're offline
	if (player->isOffline())
	{
		IOLoginData::savePlayer(player);
	}
}