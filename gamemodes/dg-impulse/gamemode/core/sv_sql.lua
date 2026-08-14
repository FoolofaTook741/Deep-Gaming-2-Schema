-- Uses https://github.com/FredyH/MySQLOO/releases

function GM:DatabaseConnected()
    local sqlQuery = mysql:Create("impulse_players") -- if not table exist, make it.
        sqlQuery:Create("id", "int unsigned NOT NULL AUTO_INCREMENT") -- index
        sqlQuery:Create("steam_name", "varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL") -- steam name
        sqlQuery:Create("rpname", "varchar(70) NOT NULL") -- rpname
        sqlQuery:Create("steamid", "varchar(25) NOT NULL") -- steamid
        sqlQuery:Create("group", "varchar(70) NOT NULL") -- usergroup
        sqlQuery:Create("rpgroup", "int(11) unsigned DEFAULT 0") -- rpgroup
        sqlQuery:Create("rpgrouprank", "varchar(255)") -- rpgroup rank string
        sqlQuery:Create("xp", "int(11) unsigned DEFAULT NULL") -- xp
        sqlQuery:Create("cp_xp", "int(11) unsigned DEFAULT NULL") -- cp faction xp
        sqlQuery:Create("money", "int(11) unsigned DEFAULT NULL") -- money
        sqlQuery:Create("bankmoney", "int(11) unsigned DEFAULT NULL") -- banked money
        sqlQuery:Create("skills", "longtext") -- json skill data seperated from data to avoid corrruption
        sqlQuery:Create("ammo", "text")
        sqlQuery:Create("model", "varchar(160) NOT NULL") -- model
        sqlQuery:Create("skin", "tinyint") -- skin
        sqlQuery:Create("cosmetic", "longtext") -- cosmetic extra data
        sqlQuery:Create("data", "longtext") -- general data
        sqlQuery:Create("firstjoin", "int(11) unsigned NOT NULL") -- first join date
        sqlQuery:Create("languages", "int(11) unsigned DEFAULT NULL")
        sqlQuery:Create("sterilizedcredits", "int(11) unsigned DEFAULT 0")
        sqlQuery:Create("discord_id", "bigint(20) unsigned DEFAULT NULL") -- linked discord id
        sqlQuery:Create("civic_merits", "int(11) NOT NULL DEFAULT 0") -- civic merits
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    local sqlQuery = mysql:Create("impulse_inventory") -- if not table exist, make it.
        sqlQuery:Create("id", "int unsigned NOT NULL AUTO_INCREMENT") -- index
        sqlQuery:Create("uniqueid", "varchar(64) NOT NULL") -- string unique itemid
        sqlQuery:Create("ownerid", "int(11) unsigned DEFAULT NULL") -- owner db id
        sqlQuery:Create("storagetype", "tinyint NOT NULL") -- where item is stored
        sqlQuery:Create("data", "text") -- item data
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    local sqlQuery = mysql:Create("impulse_group_inventory") -- if not table exist, make it.
        sqlQuery:Create("id", "int unsigned NOT NULL AUTO_INCREMENT") -- index
        sqlQuery:Create("uniqueid", "varchar(25) NOT NULL") -- string unique itemid
        sqlQuery:Create("groupid", "int(11) unsigned DEFAULT NULL") -- owner db id
        sqlQuery:Create("storagetype", "tinyint NOT NULL") -- where item is stored
        sqlQuery:Create("data", "text") -- item data
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    local sqlQuery = mysql:Create("impulse_reports")
        sqlQuery:Create("id", "int unsigned NOT NULL AUTO_INCREMENT")
        sqlQuery:Create("reporter", "varchar(25) NOT NULL")
        sqlQuery:Create("mod", "varchar(25) NOT NULL")
        sqlQuery:Create("message", "text")
        sqlQuery:Create("start", "datetime")
        sqlQuery:Create("claimwait", "int(11) unsigned NOT NULL")
        sqlQuery:Create("closewait", "int(11) unsigned NOT NULL")
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    local sqlQuery = mysql:Create("impulse_whitelists")
        sqlQuery:Create("id", "int unsigned NOT NULL AUTO_INCREMENT")
        sqlQuery:Create("steamid", "varchar(25) NOT NULL")
        sqlQuery:Create("team", "varchar(90) NOT NULL")
        sqlQuery:Create("level", "int(11) unsigned NOT NULL")
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    local sqlQuery = mysql:Create("impulse_refunds")
        sqlQuery:Create("id", "int unsigned NOT NULL AUTO_INCREMENT")
        sqlQuery:Create("steamid", "varchar(25) NOT NULL")
        sqlQuery:Create("item", "varchar(75) NOT NULL")
        sqlQuery:Create("date", "int(11) unsigned NOT NULL")
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    local sqlQuery = mysql:Create("impulse_rpgroups")
        sqlQuery:Create("id", "int unsigned NOT NULL AUTO_INCREMENT")
        sqlQuery:Create("ownerid", "int(11) unsigned DEFAULT NULL") -- owner db id
        sqlQuery:Create("name", "varchar(255) NOT NULL")
        sqlQuery:Create("type", "int(11) unsigned DEFAULT 0")
        sqlQuery:Create("maxsize", "int(11) unsigned NOT NULL")
        sqlQuery:Create("maxstorage", "int(11) unsigned NOT NULL")
        sqlQuery:Create("ranks", "longtext")
        sqlQuery:Create("data", "longtext")
        sqlQuery:Create("storageupgrade", "tinyint NOT NULL DEFAULT 0") -- storage upgrade level
        sqlQuery:Create("groupbank", "bigint(20) NOT NULL DEFAULT 0") -- group bank balance
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    local sqlQuery = mysql:Create("impulse_data")
        sqlQuery:Create("id", "int unsigned NOT NULL AUTO_INCREMENT")
        sqlQuery:Create("name", "varchar(255) NOT NULL")
        sqlQuery:Create("data", "longtext")
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    -- Discord link/sync queue
    local sqlQuery = mysql:Create("discord_sync_queue")
        sqlQuery:Create("steamid", "varchar(32) NOT NULL") -- Steam2 ID
        sqlQuery:Create("discord_id", "varchar(32) NOT NULL") -- Discord user ID
        sqlQuery:Create("created_at", "timestamp NULL DEFAULT current_timestamp()") -- queue creation time
        sqlQuery:PrimaryKey("steamid")
    sqlQuery:Execute()

    -- Auction listings
    local sqlQuery = mysql:Create("impulse_auctions")
        sqlQuery:Create("id", "int(10) unsigned NOT NULL AUTO_INCREMENT") -- index
        sqlQuery:Create("seller_steamid", "varchar(20) NOT NULL") -- seller Steam2 ID
        sqlQuery:Create("seller_name", "varchar(64) NOT NULL DEFAULT ''") -- seller name
        sqlQuery:Create("item_class", "varchar(64) NOT NULL") -- item unique class
        sqlQuery:Create("item_data", "text NOT NULL") -- serialized item data
        sqlQuery:Create("item_name", "varchar(128) NOT NULL DEFAULT ''") -- display name
        sqlQuery:Create("item_category", "varchar(64) NOT NULL DEFAULT 'Misc'") -- item category
        sqlQuery:Create("item_quantity", "smallint(5) unsigned NOT NULL DEFAULT 1") -- quantity
        sqlQuery:Create("duration_chosen", "tinyint(3) unsigned NOT NULL") -- auction duration
        sqlQuery:Create("posted_at", "int(10) unsigned NOT NULL") -- posting timestamp
        sqlQuery:Create("expires_at", "int(10) unsigned NOT NULL") -- expiry timestamp
        sqlQuery:Create("starting_bid", "int(10) unsigned NOT NULL DEFAULT 1") -- starting bid
        sqlQuery:Create("reserve_price", "int(10) unsigned DEFAULT NULL") -- reserve price
        sqlQuery:Create("buyout_price", "int(10) unsigned DEFAULT NULL") -- buyout price
        sqlQuery:Create("current_bid", "int(10) unsigned NOT NULL DEFAULT 0") -- current highest bid
        sqlQuery:Create("high_bidder_steamid", "varchar(20) DEFAULT NULL") -- current highest bidder
        sqlQuery:Create("bid_count", "smallint(5) unsigned NOT NULL DEFAULT 0") -- total bids
        sqlQuery:Create("last_bid_at", "int(10) unsigned DEFAULT NULL") -- last bid timestamp
        sqlQuery:Create("deposit_paid", "int(10) unsigned NOT NULL DEFAULT 0") -- listing deposit
        sqlQuery:Create("status", "tinyint(3) unsigned NOT NULL DEFAULT 0") -- auction status
        sqlQuery:Create("is_collaborator", "tinyint(1) NOT NULL DEFAULT 0") -- collaborator auction flag
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    -- Auction history
    local sqlQuery = mysql:Create("impulse_auction_history")
        sqlQuery:Create("id", "int(10) unsigned NOT NULL AUTO_INCREMENT") -- index
        sqlQuery:Create("auction_id", "int(10) unsigned NOT NULL") -- auction id
        sqlQuery:Create("event_type", "tinyint(3) unsigned NOT NULL COMMENT '0=bid 1=sale 2=expired 3=cancelled'") -- auction event
        sqlQuery:Create("actor_steamid", "varchar(20) NOT NULL") -- player responsible for event
        sqlQuery:Create("amount", "int(10) unsigned NOT NULL DEFAULT 0") -- credit amount
        sqlQuery:Create("placed_at", "int(10) unsigned NOT NULL") -- event timestamp
        sqlQuery:Create("was_outbid", "tinyint(1) NOT NULL DEFAULT 0") -- whether bidder was outbid
        sqlQuery:Create("item_class", "varchar(64) DEFAULT NULL") -- item class
        sqlQuery:Create("item_name", "varchar(128) DEFAULT NULL") -- item name
        sqlQuery:Create("item_quantity", "smallint(5) unsigned NOT NULL DEFAULT 1") -- item quantity
        sqlQuery:Create("seller_steamid", "varchar(20) DEFAULT NULL") -- seller Steam2 ID
        sqlQuery:Create("item_received", "tinyint(1) NOT NULL DEFAULT 0") -- item delivery state
        sqlQuery:Create("credits_received", "tinyint(1) NOT NULL DEFAULT 0") -- credit delivery state
        sqlQuery:Create("seller_payout", "int(10) unsigned DEFAULT NULL") -- seller payout
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    -- Server bans shared with Discord moderation
    local sqlQuery = mysql:Create("impulse_bans")
        sqlQuery:Create("id", "int(11) NOT NULL AUTO_INCREMENT") -- index
        sqlQuery:Create("steamid", "varchar(32) NOT NULL") -- punished Steam2 ID
        sqlQuery:Create("admin_steamid", "varchar(32) NOT NULL") -- issuing admin Steam2 ID
        sqlQuery:Create("reason", "text DEFAULT NULL") -- ban reason
        sqlQuery:Create("length_minutes", "int(11) NOT NULL DEFAULT 0") -- ban length
        sqlQuery:Create("created_at", "int(11) NOT NULL") -- creation timestamp
        sqlQuery:Create("expires_at", "int(11) DEFAULT NULL") -- expiry timestamp
        sqlQuery:Create("active", "tinyint(1) NOT NULL DEFAULT 1") -- active state
        sqlQuery:Create("removed_by", "varchar(32) DEFAULT NULL") -- admin that removed ban
        sqlQuery:Create("removed_at", "int(11) DEFAULT NULL") -- removal timestamp
        sqlQuery:Create("source", "enum('ingame','discord') NOT NULL DEFAULT 'ingame'") -- source of ban
        sqlQuery:Create("admin_steamname", "varchar(64) NOT NULL DEFAULT ''") -- issuing admin Steam name
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    -- Online player cache used by external services / Discord bot
    local sqlQuery = mysql:Create("impulse_onlineplayers")
        sqlQuery:Create("steamid", "varchar(32) NOT NULL") -- Steam2 ID
        sqlQuery:Create("name", "varchar(70) NOT NULL") -- RP name
        sqlQuery:Create("updated_at", "int(11) NOT NULL") -- last player list update
        sqlQuery:PrimaryKey("steamid")
    sqlQuery:Execute()

    -- Actions queued by external services for the game server
    local sqlQuery = mysql:Create("impulse_pendingactions")
        sqlQuery:Create("id", "int(11) NOT NULL AUTO_INCREMENT") -- index
        sqlQuery:Create("action_type", "varchar(20) NOT NULL") -- action type
        sqlQuery:Create("payload", "text NOT NULL") -- action payload
        sqlQuery:Create("status", "varchar(10) NOT NULL DEFAULT 'pending'") -- processing status
        sqlQuery:Create("result_message", "text DEFAULT NULL") -- processing result
        sqlQuery:Create("created_at", "int(11) NOT NULL") -- creation timestamp
        sqlQuery:Create("processed_at", "int(11) DEFAULT NULL") -- processed timestamp
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    -- Player warnings shared with Discord moderation
    local sqlQuery = mysql:Create("impulse_warns")
        sqlQuery:Create("id", "int(11) NOT NULL AUTO_INCREMENT") -- index
        sqlQuery:Create("steamid", "varchar(32) NOT NULL") -- warned Steam2 ID
        sqlQuery:Create("admin_steamid", "varchar(32) NOT NULL") -- issuing admin Steam2 ID
        sqlQuery:Create("reason", "text DEFAULT NULL") -- warning reason
        sqlQuery:Create("created_at", "int(11) NOT NULL") -- creation timestamp
        sqlQuery:Create("active", "tinyint(1) NOT NULL DEFAULT 1") -- active state
        sqlQuery:Create("removed_by", "varchar(32) DEFAULT NULL") -- admin that removed warning
        sqlQuery:Create("removed_at", "int(11) DEFAULT NULL") -- removal timestamp
        sqlQuery:Create("source", "enum('ingame','discord') NOT NULL DEFAULT 'ingame'") -- source of warning
        sqlQuery:Create("admin_steamname", "varchar(64) NOT NULL DEFAULT ''") -- issuing admin Steam name
        sqlQuery:PrimaryKey("id")
    sqlQuery:Execute()

    -- Temporary Discord account linking tokens
    local sqlQuery = mysql:Create("link_tokens")
        sqlQuery:Create("token", "varchar(64) NOT NULL") -- unique link token
        sqlQuery:Create("discord_id", "varchar(32) NOT NULL") -- Discord user ID
        sqlQuery:Create("expires_at", "bigint(20) NOT NULL") -- token expiry
        sqlQuery:PrimaryKey("token")
    sqlQuery:Execute()

end

timer.Create("impulsedb.Think", 1, 0, function()
    mysql:Think()
end)