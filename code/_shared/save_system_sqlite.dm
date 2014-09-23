save_system/sqlite
	var
		database/dbcon
		database/query/qcon
	ready = 0

	New()
		. = ..()

		dbcon = new("GOA.db")
		qcon = new
		ready = 1

	proc
		Quote(text)
			if(isnull(text))
				text = "NULL"

			else if(!text)
				text = "''"

			return text

		IsAllowedServer(addr)

			qcon.Add("SELECT * FROM `allowed_servers` WHERE `allowed_servers`.`ip` = ?", addr )

			if(!qcon.Execute(dbcon))
				world.log << "IsAllowedServer failed:[qcon.ErrorMsg()]"
				return 0

			if(!qcon.NextRow())
				return 0

			return 1

	GetCharacterNames(key)
		key = ckey(key)


		qcon.Add("SELECT `name` FROM `players` WHERE `ckey` = ?", key )

		if(!qcon.Execute(dbcon))
			world.log << "GetCharacterNames failed:[qcon.ErrorMsg()]"
			return 0

		var/list/chars = new

		while(qcon.NextRow())
			var/list/columns = qcon.GetRowData()
			chars += columns["name"]

		return chars

	IsNameUsed(name)

		qcon.Add("SELECT * FROM `players`")

		if(!qcon.Execute(dbcon))
			world.log << "IsNameUsed failed:[qcon.ErrorMsg()]"
			return 1

		while(qcon.NextRow())
			var/list/columns = qcon.GetRowData()
			if(columns["name"] == name)
				return 1

		return 0

	CreateSquad(name, leader)
		if(!name) return 0

		qcon.Add( "INSERT INTO `squads` (`leader`, `name`) VALUES ((SELECT `id` FROM `players` WHERE `name` = ?), ?)", leader, name)

		if(!qcon.Execute(dbcon))
			world.log << "CreateSquad failed:[qcon.ErrorMsg()]"
			return 0

		return 1

	DeleteSquad(name)
		if(!name) return 0

		qcon.Add( "DELETE FROM `squads` WHERE `name` = ?", name )

		if(!qcon.Execute(dbcon))
			world.log << "DeleteSquad failed:[qcon.ErrorMsg()]"
			return 0

		return 1

	ChangeSquadLeader(name, new_leader)
		if(!name) return 0

		qcon.Add( "UPDATE `squads` SET `leader` = (SELECT `id` FROM `players` WHERE `name` = ?) WHERE `name` = ?", new_leader , name )

		if(!qcon.Execute(dbcon))
			world.log << "ChangeSquadLeader failed:[qcon.ErrorMsg()]"
			return 0

		return 1

	GetSquadMemberCount(name)
		if(!name)
			return 0


		qcon.Add( "SELECT COUNT(*) FROM `players` WHERE `squad` = (SELECT `id` FROM `squads` WHERE `name` = ?)", name )

		if(!qcon.Execute(dbcon))
			world.log << "GetSquadMemberCount failed:[qcon.ErrorMsg()]"
			return 100

		if(qcon.NextRow())
			return text2num(qcon.GetColumn(1) )

		return 100

	GetSquadInfo(name)
		if(!name)
			return 0

		qcon.Add( "SELECT * FROM `squads` WHERE `name` = ?" , name )

		if(!qcon.Execute(dbcon))
			world.log << "GetSquadInfo(squad) failed:[qcon.ErrorMsg()]"
			return 0

		if(qcon.NextRow())
			var/list/info = qcon.GetRowData()
			var/leader = ""

			if(info["leader"])
				qcon.Add( "SELECT `name` FROM `players` WHERE `id` = ?", info["leader"])

				if(!qcon.Execute(dbcon))
					world.log << "GetSquadInfo(leader name) failed:[qcon.ErrorMsg()]"
					return 0

				if(qcon.NextRow())
					leader = qcon.GetColumn(1)

			var/list/ret = list("name" = info["name"], "leader" = leader)
			return list2params(ret)

		return 0


	CreateFaction(name, leader, village, mouse_icon, chat_icon, chuunin_item, member_limit)

		var/leader_id

		qcon.Add( "SELECT `id` FROM `players` WHERE `name` = ?", leader)

		if(!qcon.Execute(dbcon))
			world.log << "CreateFaction failed:[qcon.ErrorMsg()]"
			return 0

		if(qcon.NextRow())
			leader_id = text2num( qcon.GetColumn(1) )

		var/query_sql = {"
				INSERT INTO `factions` (`leader`, `name`, `village`, `mouse_icon`, `chat_icon`,`chuunin_item`, `member_limit`)
					VALUES (
						?,
						?,
						?,
						?,
						?,
						?,
						?
					)"}

		qcon.Add( "[query_sql]", leader_id, name,  village, mouse_icon, chat_icon, chuunin_item, member_limit)

		if(!qcon.Execute(dbcon))
			world.log << "CreateFaction failed:[qcon.ErrorMsg()]"
			return 0

		return 1

	DeleteFaction(name)

		if(!name)
			return 0

		qcon.Add( "DELETE FROM `factions` WHERE `name` = ?", name )

		if(!qcon.Execute(dbcon))
			world.log << "DeleteFaction failed:[qcon.ErrorMsg()]"
			return 0

		return 1


	ChangeFactionLeader(name, new_leader)

		if(new_leader)
			qcon.Add( "UPDATE `factions` SET `leader` = (SELECT `id` FROM `players` WHERE `name` = ?) WHERE `name` = ?", new_leader, name )

			if(!qcon.Execute(dbcon))
				world.log << "ChangeFactionLeader(with leader) failed:[qcon.ErrorMsg()]"
				return 0
		else
			qcon.Add( "UPDATE `factions` SET `leader` = NULL WHERE `name` = ?", name )

			if(!qcon.Execute(dbcon))
				world.log << "ChangeFactionLeader(no leader) failed:[qcon.ErrorMsg()]"
				return 0

		return 1

	ChangeFactionLimit(name, new_limit)

		if(new_limit)
			qcon.Add("UPDATE `factions` SET `member_limit` = ? WHERE `name` = ?", new_limit, name)

			if(!qcon.Execute(dbcon))
				world.log << "ChangeFactionLimit(with leader) failed:[qcon.ErrorMsg()]"
				return 0

		return 1

	ChangeFactionChuuninItem(name, new_chuunin_item as num)
		if(new_chuunin_item)
			qcon.Add("UPDATE `factions` SET `chuunin_item` = ? WHERE `name` = ?", new_chuunin_item, name)

			if(!qcon.Execute(dbcon))
				world.log << "ChangeFactionChuuninItem(with leader) failed:[qcon.ErrorMsg()]"
				return 0

		return 1

	ChangeFactionChuuninItemColor(name, new_chuunin_item_color)
		if(new_chuunin_item_color)
			qcon.Add("UPDATE `factions` SET `chuunin_item_color` = ? WHERE `name` = ?", new_chuunin_item_color, name )

			if(!qcon.Execute(dbcon))
				world.log << "ChangeFactionChuuninItemColor(with leader) failed:[qcon.ErrorMsg()]"
				return 0

		return 1

	GetFactionMemberCount(name)
		qcon.Add( "SELECT COUNT(*) FROM `players` WHERE `faction` = (SELECT `id` FROM `factions` WHERE `name` = ?)", name)

		if(!qcon.Execute(dbcon))
			world.log << "GetFactionMemberCount failed:[qcon.ErrorMsg()]"
			return 100

		if(qcon.NextRow())
			return text2num(qcon.GetColumn(1) )

		return 100


	GetFactionInfo(name)

		qcon.Add( "SELECT * FROM `factions` WHERE `name` = ?", name )

		if(!qcon.Execute(dbcon))
			world.log << "Faction info(1) failed:[qcon.ErrorMsg()]"
			return 0

		if(qcon.NextRow())
			var/list/info = qcon.GetRowData()
			var/leader = ""

			if(info["leader"])
				qcon.Add( "SELECT `name` FROM `players` WHERE `id` = ?" , info["leader"] )

				if(!qcon.Execute(dbcon))
					world.log << "Faction info(2) failed:[qcon.ErrorMsg()]"
					return 0

				if(qcon.NextRow())
					leader = qcon.GetColumn(1)

			var/list/ret = list("name" = info["name"], "leader" = leader, "village" = info["village"], "mouse_icon" = info["mouse_icon"], "chat_icon" = info["chat_icon"], "chuunin_item" = info["chuunin_item"],  "member_limit" = info["member_limit"])
			return ret//return list2params(ret)

		return 0

	GetHelpers()
		var
			helpers = list()

		qcon.Add( "SELECT (SELECT `name` FROM players WHERE `id` = `helpers`.`helper`) 'name', (SELECT `name` FROM `factions` WHERE `id` = `helpers`.`village`) 'village' FROM `helpers`")

		if(!qcon.Execute(dbcon))
			world.log << "GetHelpers failed:[qcon.ErrorMsg()]"
			return

		while(qcon.NextRow())
			var/list/info = qcon.GetRowData()

			if(!helpers[info["village"]])
				helpers[info["village"]] = list()

			helpers[info["village"]] += info["name"]

		return helpers

	AddHelper(name, village)
		qcon.Add("INSERT INTO `helpers` (`helper`, `village`) VALUES  ((SELECT `id` FROM players WHERE `name` = ?), (SELECT `id` FROM factions WHERE `name` = ?))",name,village )

		if(!qcon.Execute(dbcon))
			world.log << "AddHelper failed:[qcon.ErrorMsg()]"
			return 0

		return 1

	RemoveHelper(name, village)
		qcon.Add("DELETE FROM `helpers` WHERE `helper`= (SELECT `id` FROM players WHERE `name` = ?) AND `village` = (SELECT `id` FROM factions WHERE `name` = ?)", name, village)

		if(!qcon.Execute(dbcon))
			world.log << "RemoveHelper failed:[qcon.ErrorMsg()]"
			return 0

		return 1

	IsBanned(key, computer_id)

		key = ckey(key)

		qcon.Add("SELECT * FROM `key_bans` WHERE `key` = ? AND `expire_time` >= (DATETIME('now'))", key)

		if(!qcon.Execute(dbcon))
			world.log << "IsBanned(key check) failed:[qcon.ErrorMsg()]"
			return 1

		var/found_key = 0
		var/key_reason = ""
		var/key_expire = ""

		if(qcon.NextRow())
			var/list/columns = qcon.GetRowData()
			key_reason = columns["reason"]
			key_expire = columns["expire_time"]
			found_key = 1

		qcon.Add("SELECT * FROM `computer_bans` WHERE `computer_id` = ? AND `expire_time` >= (DATETIME('now'))", computer_id)

		if(!qcon.Execute(dbcon))
			world.log << "IsBanned(computer_id check) failed:[qcon.ErrorMsg()]"
			return 1

		var/found_computer = 0
		var/computer_reason = ""
		var/computer_expire = ""

		if(qcon.NextRow())
			var/list/columns = qcon.GetRowData()
			computer_reason = columns["reason"]
			computer_expire = columns["expire_time"]
			found_computer = 1

		var/is_banned = found_key || found_computer

		if(is_banned)
			var/final_reason = ""
			var/final_expire = ""

			if(found_key && found_computer)
				// Figure out which reason/expire time to use if both parts are already banned separately.
				if(key_reason != computer_reason && key_expire != computer_expire)
					qcon.Add("SELECT IF(CAST(? AS DATETIME)<CAST(? AS DATETIME),'key','computer_id')", computer_expire, key_expire)

					if(!qcon.Execute(dbcon))
						world.log << "IsBanned(date check) failed:[qcon.ErrorMsg()]"
						return 1

					var/use_ban = "key"
					if(qcon.NextRow())
						use_ban = qcon.GetColumn(1)

					if(use_ban == "key")
						final_reason = key_reason
						final_expire = key_expire
					else
						final_reason = computer_reason
						final_expire = computer_expire
				else // Bans already match, nothing to do.
					final_reason = key_reason
					final_expire = key_expire
			else
				if(found_key)
					final_reason = key_reason
					final_expire = key_expire
				else if(found_computer)
					final_reason = computer_reason
					final_expire = computer_expire

			if(found_key)
				if(key_reason != final_reason && key_expire != final_expire)
					// Update key ban info
					qcon.Add("UPDATE `key_bans` SET `reason` = ?, `expire_time` = ? WHERE `key` = ?", final_reason, final_expire, key)

					if(!qcon.Execute(dbcon))
						world.log << "IsBanned(key update) failed:[qcon.ErrorMsg()]"
						return 1
			else
				// Ban key if it matched IP and isn't already banned
				qcon.Add("INSERT IGNORE INTO `key_bans` (`key`,`reason`,`expire_time`) VALUES (?,?,?)", key, final_reason, final_expire)

				if(!qcon.Execute(dbcon))
					world.log << "IsBanned(key add) failed:[qcon.ErrorMsg()]"
					return 1

			if(found_computer)
				if(computer_reason != final_reason && computer_expire != final_expire)
					// Update computer ban info
					qcon.Add("UPDATE `computer_bans` SET `reason` = ?, `expire_time` = ? WHERE `computer_id` = ?", final_reason, final_expire, computer_id)

					if(!qcon.Execute(dbcon))
						world.log << "IsBanned(computer_id update) failed[dbcon.ErrorMsg()]"
						return 1
			else
				// Ban IP if it matched key and isn't already banned
				qcon.Add("INSERT IGNORE INTO `computer_bans` (`computer_id`,`reason`,`expire_time`) VALUES (?,?,?)", computer_id, final_reason, final_expire)

				if(!qcon.Execute(dbcon))
					world.log << "IsBanned(computer_id add) failed:[qcon.ErrorMsg()]"
					return 1

			// Add record of this particular association
			qcon.Add("INSERT IGNORE INTO `key_computer_pairs` (`key`, `computer_id`) VALUES (?, ?)", key, computer_id)

			if(!qcon.Execute(dbcon))
				world.log << "IsBanned(pair update) failed:[qcon.ErrorMsg()]"

			return list2params(list("reason" = final_reason, "expire_time" = final_expire))

		return 0

	AddBan(key, computer_id, reason, expire_time)

		key = ckey(key)

		// Add a ban. Uses database transation functionality so changes can be rolled back if something failed.
		qcon.Add("BEGIN TRANSACTION")

		if(!qcon.Execute(dbcon))
			world.log << "AddBan(start transaction) failed:[qcon.ErrorMsg()]"
			return 0

		if(key)
			qcon.Add("INSERT IGNORE INTO `key_bans` (`key`,`reason`,`expire_time`) VALUES (?,?,?)", key, reason, expire_time)

			if(!qcon.Execute(dbcon))
				world.log << "AddBan(add key ban) failed:[qcon.ErrorMsg()]"

				qcon.Add("ROLLBACK")

				if(!qcon.Execute(dbcon))
					world.log << "AddBan(failure recovery: add key ban) failed:[qcon.ErrorMsg()]"

				return 0

		if(computer_id)
			qcon.Add("INSERT IGNORE INTO `computer_bans` (`computer_id`,`reason`,`expire_time`) VALUES (?,?,?)", computer_id, reason, expire_time)

			if(!qcon.Execute(dbcon))
				world.log << "AddBan(add computer_id ban) failed:[qcon.ErrorMsg()]"

				qcon.Add("ROLLBACK")

				if(!qcon.Execute(dbcon))
					world.log << "AddBan(failure recovery: add computer_id ban) failed:[qcon.ErrorMsg()]"

				return 0

		if(key && computer_id)
			qcon.Add("INSERT IGNORE INTO `key_computer_pairs` (`key`, `computer_id`) VALUES (?, ?)", key, computer_id)

			if(!qcon.Execute(dbcon))
				world.log << "AddBan(pair ban) failed:[qcon.ErrorMsg()]"

				qcon.Add("ROLLBACK")

				if(!qcon.Execute(dbcon))
					world.log << "AddBan(failure recovery: pair ban) failed:[qcon.ErrorMsg()]"

				return 0

		qcon.Add("COMMIT")

		if(!qcon.Execute(dbcon))
			world.log << "AddBan(commit) failed:[qcon.ErrorMsg()]"

			qcon.Add("ROLLBACK")

			if(!qcon.Execute(dbcon))
				world.log << "AddBan(failure recovery: commit) failed:[qcon.ErrorMsg()]"

			return 0

		return 1

	RemoveBan(key, computer_id)
		key = ckey(key)

		// Remove a ban. Uses database transation functionality so changes can be rolled back if something failed.
		qcon.Add("BEGIN TRANSACTION")

		if(!qcon.Execute(dbcon))
			world.log << "RemoveBan(start transaction) failed:[dbcon.ErrorMsg()]"
			return 0

		if(key)
			qcon.Add("DELETE FROM `key_bans` WHERE `key` = (?)", key)

			if(!qcon.Execute(dbcon))
				world.log << "RemoveBan(remove key) failed:[qcon.ErrorMsg()]"

				qcon.Add("ROLLBACK")

				if(!qcon.Execute(dbcon))
					world.log << "RemoveBan(failure recovery: remove key) failed:[qcon.ErrorMsg()]"

				return 0

		if(computer_id)
			qcon.Add("DELETE FROM `computer_bans` WHERE `computer_id` = (?)", computer_id)

			if(!qcon.Execute(dbcon))
				world.log << "RemoveBan(remove computer_id) failed:[qcon.ErrorMsg()]"

				qcon.Add("ROLLBACK")

				if(!qcon.Execute(dbcon))
					world.log << "RemoveBan(failure recovery: remove computer_id) failed:[qcon.ErrorMsg()]"

				return 0

		qcon.Add("COMMIT")

		if(!qcon.Execute(dbcon))
			world.log << "RemoveBan(commit) failed:[qcon.ErrorMsg()]"

			qcon.Add("ROLLBACK")

			if(!qcon.Execute(dbcon))
				world.log << "RemoveBan(failure recovery: commit) failed:[qcon.ErrorMsg()]"

			return 0

		return 1

	SetInfoCardComment(name, village, new_comment)
		if(!village)
			return 0


		qcon.Add("UPDATE `players` SET ["`comment_[village]`"]=? WHERE `name` = ?", new_comment, name)

		if(!qcon.Execute(dbcon))
			world.log << "SetInfoCardComment failed:[qcon.ErrorMsg()]"
			return 0

		return 1

	GetInfoCard(name, village)
		var
			comment_field = village?"comment_[village]":null

		qcon.Add("SELECT `name`, (SELECT `village` FROM `factions` WHERE `factions`.`id` = `players`.`faction`) 'village', (SELECT `name` FROM `factions` WHERE `factions`.`id` = `players`.`faction`) 'faction', `rank`, `body_level`, `faction_points`, `missions_d`, `missions_c`, `missions_b`, `missions_a`, `missions_s`[comment_field?", `[comment_field]` 'comment'":""] FROM `players` WHERE `name` = ?", name)

		if(!qcon.Execute(dbcon))
			world.log << "GetInfoCard failed:[qcon.ErrorMsg()]"
			return 0

		if(qcon.NextRow())
			var/list/columns = qcon.GetRowData()
			return columns

		return 0

	RenameCharacter(old_name, new_name, key)

		qcon.Add("UPDATE `players` SET `name` = ? WHERE `name` = ? AND `ckey` = ?", new_name, old_name, ckey(key))


		if(!qcon.Execute(dbcon))
			world.log << "RenameCharacter failed:[qcon.ErrorMsg()]"
			return 0

		return 1

	DeleteCharacter(name, key)
		qcon.Add("DELETE FROM `players` WHERE `name` = ? AND `ckey` = ?" , name, ckey(key))

		if(!qcon.Execute(dbcon))
			world.log << "DeleteCharacter failed:[qcon.ErrorMsg()]"
			return 0

		return 1

	GetCharacter(name, key)
		key = ckey(key)

		var
			list
				L = new(5)
				inv
				bar
				strg
				nums
				lst

		qcon.Add("SELECT * FROM `players` WHERE `ckey` = ? AND `name` = ?", ckey(key), name)

		if(!qcon.Execute(dbcon))
			world.log << "GetCharacter failed:[qcon.ErrorMsg()]"
			return 0

		if(qcon.NextRow())
			var/list/columns = qcon.GetRowData()

			bar = new /list(10)
			for(var/i in 1 to 10)
				bar[i] = text2num(columns["macro[i]"])

			strg = new /list(10)
			strg[1]=columns["last_hosted_chuunin_time"]
			strg[2]=columns["last_hostile_key"]
			strg[3]=columns["rank"]
			strg[4]=columns["icon"]
			strg[5]=columns["name"]

			if(columns["faction"])
				qcon.Add("SELECT `name` FROM `factions` WHERE `id` = ?", columns["faction"])

				if(!qcon.Execute(dbcon))
					world.log << "GetCharacter(faction lookup) failed:[qcon.ErrorMsg()]"
					strg[6]="Missing"
				else
					if(qcon.NextRow())
						strg[6]=qcon.GetColumn(1)
					else
						strg[6]="Missing"
			else
				strg[6]="Missing"

			if(columns["squad"])
				qcon.Add("SELECT `name` FROM `squads` WHERE `id` = ?", columns["squad"])

				if(!qcon.Execute(dbcon))
					world.log << "GetCharacter(squad lookup) failed:[qcon.ErrorMsg()]"
					strg[7]=null
				else
					if(qcon.NextRow())
						strg[7]=qcon.GetColumn(1)
					else
						strg[7]=null
			else
				strg[7]=null

			strg[8]=columns["hair_color"]
			strg[9]=columns["clan"]
			strg[10]=columns["verify"]

			nums = new /list(41)
			nums[1]=text2num(columns["ezing"])
			nums[2]=text2num(columns["mission_cool"])
			nums[3]=text2num(columns["survivalist_cooldown"])
			nums[4]=text2num(columns["mutevote_cooldown"])
			nums[5]=text2num(columns["vote_cooldown"])
			nums[6]=text2num(columns["faction_points"])
			nums[7]=text2num(columns["headband_position"])
			nums[8]=text2num(columns["missions_d"])
			nums[9]=text2num(columns["missions_c"])
			nums[10]=text2num(columns["missions_b"])
			nums[11]=text2num(columns["missions_a"])
			nums[12]=text2num(columns["missions_s"])
			nums[13]=text2num(columns["bounty"])
			nums[14]=text2num(columns["hair_type"])
			nums[15]=text2num(columns["control"])
			nums[16]=text2num(columns["strength"])
			nums[17]=text2num(columns["intelligence"])
			nums[18]=text2num(columns["reflex"])
			nums[19]=text2num(columns["skill_points"])
			nums[20]=text2num(columns["level_points"])
			nums[21]=text2num(columns["money"])
			nums[22]=text2num(columns["stamina"])
			nums[23]=text2num(columns["current_stamina"])
			nums[24]=text2num(columns["chakra"])
			nums[25]=text2num(columns["current_chakra"])
			nums[26]=text2num(columns["max_wounds"])
			nums[27]=text2num(columns["current_wounds"])
			nums[28]=text2num(columns["body_points"])
			nums[29]=text2num(columns["body_level"])
			nums[30]=text2num(columns["kod"])
			nums[31]=text2num(columns["supplies"])
			nums[32]=text2num(columns["x"])
			nums[33]=text2num(columns["y"])
			nums[34]=text2num(columns["z"])
			nums[35]=text2num(columns["kills"])
			nums[36]=text2num(columns["deaths"])
			nums[37]=text2num(columns["eyecolor_red"])
			nums[38]=text2num(columns["eyecolor_green"])
			nums[39]=text2num(columns["eyecolor_blue"])
			nums[40]=text2num(columns["double_xp_time"])
			nums[41]=text2num(columns["triple_xp_time"])

			/*var/hash=md5("[nums[28]]["squad_delete"][nums[15]+nums[16]+nums[17]+nums[18]]["faction_info"][nums[29]]["get_chars"][nums[20]]["check_name"][nums[19]]")
			if(strg[10] != hash)
				world.log << "GetCharacter([key], [name]) failed: hash mismatch, deleting character"

				query_sql = "DELETE FROM `players` WHERE `id` = [Quote(columns["id"])]"
				query = dbcon.NewQuery(query_sql)

				if(!query.Execute())
					world.log << "GetCharacter(failed -- delete) failed:\n\t[query_sql]\n\t[query.ErrorMsg()]"

				return 0*/

			lst = new /list(8)
			lst[1]=columns["skills_passive"]

			var/skill_info[0]
			qcon.Add("SELECT * FROM `skills` WHERE `player` = ?", columns["id"])

			if(!qcon.Execute(dbcon))
				world.log << "GetCharacter(skill retrieval) failed:[qcon.ErrorMsg()]"
			else
				while(qcon.NextRow())
					var/list/skill = qcon.GetRowData()
					skill_info += skill["id"]
					skill_info += skill["cooldown"]
					skill_info += skill["uses"]

			lst[2]=dd_list2text(skill_info,"&")
			lst[3]=columns["puppet1"]
			lst[4]=columns["puppet2"]
			lst[5]=columns["puppet3"]
			lst[6]=columns["custmac"]
			lst[7]=columns["elements"]
			lst[1]=columns["skills_passive"]

			inv = list()
			qcon.Add("SELECT * FROM `items` WHERE `player` = ?", columns["id"])

			if(!qcon.Execute())
				world.log << "GetCharacter(item retrieval) failed:[qcon.ErrorMsg()]"
			else
				while(qcon.NextRow())
					var/list/item = qcon.GetRowData()
					inv += item["id"]
					inv += item["equipped"]

		if(!inv) inv = list()

		if(!bar) bar = new/list(10)
		if(bar.len < 10) bar.len = 10

		if(!strg) strg = new/list(10)
		if(strg.len < 10) strg.len = 10

		if(!nums) nums = new/list(39)
		if(nums.len < 41) nums.len = 41

		if(!lst) lst = new/list(7)
		if(lst.len < 7) lst.len = 7

		for(var/i in 1 to 7)
			if(!lst[i]) lst[i] = list()

		L[1]=inv//dd_list2text(inv,";")
		L[2]=bar//dd_list2text(bar,";")
		L[3]=strg//dd_list2text(strg,";")
		L[4]=nums//dd_list2text(nums,";")
		L[5]=lst//dd_list2text(lst,";")

		return L//dd_list2text(L,"$")

	SaveCharacter(key, inv[], bar[], strg[], nums[], lst[])
		//set waitfor = 0

		key = ckey(key)

		if(!key)
			world.log << "SaveCharacter(\"[strg[5]]\") failed: No key given"
			return 0

		if(strg && nums && lst)
			if(bar.len < 10) bar.len = 10
			for(var/i = 1; i <= nums.len; ++i)
				nums[i] = text2num(nums[i])
				if(!nums[i]) nums[i] = 0

			/*var/hash=md5("[nums[28]]["squad_delete"][nums[15]+nums[16]+nums[17]+nums[18]]["faction_info"][nums[29]]["get_chars"][nums[20]]["check_name"][nums[19]]")

			if(strg[10] != hash)
				world.log << "SaveCharacter(\"[strg[5]]\") failed: Verification failed."
				return 0*/

			qcon.Add("SELECT ckey FROM players WHERE name = ?", strg[5])

			if(!qcon.Execute(dbcon))
				world.log << "SaveCharacter failed:[qcon.ErrorMsg()]"
				return 0

			var/already_exists = 0
			if(qcon.NextRow())
				already_exists = 1
				var/list/data = qcon.GetRowData()

				if(data["ckey"] != key)
					return 0

			var/get_faction

			qcon.Add("SELECT `id` from `factions` WHERE `name` = '[strg[6]]'")

			if(!qcon.Execute(dbcon))
				world.log << "SaveCharacter (GetFaction) failed :[qcon.ErrorMsg()]"
				return 0

			if(qcon.NextRow())
				get_faction = qcon.GetColumn(1)

			var/get_squad

			if(strg[7])
				qcon.Add("SELECT `id` from `squads` WHERE `name` = '[strg[7]]'")

				if(!qcon.Execute(dbcon))
					world.log << "SaveCharacter (GetSquad) failed :[qcon.ErrorMsg()]"
					return 0

				if(qcon.NextRow())

					get_squad = qcon.GetColumn(1)
				else
					get_squad = "NULL"


			if(already_exists)

				qcon.Add("UPDATE `players` SET ezing = ?, mission_cool = ?, survivalist_cooldown = ?, mutevote_cooldown = ?, vote_cooldown = ?, faction_points = ?, headband_position = ?, missions_d = ?, missions_c = ?, missions_b = ?, missions_a = ?, missions_s = ?, bounty = ?, hair_type = ?, control = ?, strength = ?, intelligence = ?, reflex = ?, skill_points = ?, level_points = ?, money = ?, stamina = ?, current_stamina = ?, chakra = ?, current_chakra = ?, max_wounds = ?, current_wounds = ?, body_points = ?, body_level = ?, kod = ?, supplies = ?, x = ?, y = ?, z = ?, kills = ?, deaths = ?, eyecolor_red = ?, eyecolor_green = ?, eyecolor_blue = ?, double_xp_time = ?, triple_xp_time = ?, last_hosted_chuunin_time = ?, last_hostile_key = ?, rank = ?, icon = ?, name = ?, faction = ?, squad = ?, hair_color = ?, ckey = ?, clan = ?, verify = ?, skills_passive = ?, puppet1 = ?, puppet2 = ?, puppet3 = ?, custmac = ?, elements = ?, macro1 = ?, macro2 = ?, macro3 = ?, macro4 = ?, macro5 = ?, macro6 = ?, macro7 = ?, macro8 = ?, macro9 = ?, macro10 = ? WHERE name = ? AND ckey = ?", nums[1], nums[2], nums[3], nums[4], nums[5], nums[6], nums[7], nums[8], nums[9], nums[10], nums[11], nums[12], nums[13], nums[14], nums[15], nums[16], nums[17], nums[18], nums[19], nums[20], nums[21], nums[22], nums[23], nums[24], nums[25], nums[26], nums[27], nums[28], nums[29], nums[30], nums[31], nums[32], nums[33], nums[34], nums[35], nums[36], nums[37], nums[38], nums[39], nums[40], nums[41], strg[1], strg[2], strg[3], strg[4], strg[5], get_faction, get_squad, strg[8], key, strg[9], strg[10], Quote(lst[1]), Quote(lst[3]), Quote(lst[4]), Quote(lst[5]), Quote(lst[6]), Quote(lst[7]), bar[1]?bar[1]:"NULL", bar[2]?bar[2]:"NULL", bar[3]?bar[3]:"NULL", bar[4]?bar[4]:"NULL", bar[5]?bar[5]:"NULL", bar[6]?bar[6]:"NULL", bar[7]?bar[7]:"NULL", bar[8]?bar[8]:"NULL", bar[9]?bar[9]:"NULL", bar[10]?bar[10]:"NULL", strg[5], key)
			else
				qcon.Add("INSERT INTO `players` (ezing, mission_cool, survivalist_cooldown, mutevote_cooldown, vote_cooldown, faction_points, headband_position, missions_d, missions_c, missions_b, missions_a, missions_s, bounty, hair_type, control, strength, intelligence, reflex, skill_points, level_points, money, stamina, current_stamina, chakra, current_chakra, max_wounds, current_wounds, body_points, body_level, kod, supplies, x, y, z, kills, deaths, eyecolor_red, eyecolor_green, eyecolor_blue, last_hosted_chuunin_time, double_xp_time, triple_xp_time, last_hostile_key, rank, icon, name, faction, squad, hair_color, ckey, clan, verify, skills_passive, puppet1, puppet2, puppet3, custmac, elements, macro1, macro2, macro3, macro4, macro5, macro6, macro7, macro8, macro9, macro10) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", nums[1], nums[2], nums[3], nums[4], nums[5], nums[6], nums[7], nums[8], nums[9], nums[10], nums[11], nums[12], nums[13], nums[14], nums[15], nums[16], nums[17], nums[18], nums[19], nums[20], nums[21], nums[22], nums[23], nums[24], nums[25], nums[26], nums[27], nums[28], nums[29], nums[30], nums[31], nums[32], nums[33], nums[34], nums[35], nums[36],  nums[37], nums[38], nums[39], nums[40], nums[41], strg[1], strg[2], strg[3], strg[4], strg[5], get_faction, get_squad, strg[8], key, strg[9], strg[10], Quote(lst[1]), Quote(lst[3]), Quote(lst[4]), Quote(lst[5]), Quote(lst[6]), Quote(lst[7]), bar[1]?bar[1]:"NULL", bar[2]?bar[2]:"NULL", bar[3]?bar[3]:"NULL", bar[4]?bar[4]:"NULL", bar[5]?bar[5]:"NULL", bar[6]?bar[6]:"NULL", bar[7]?bar[7]:"NULL", bar[8]?bar[8]:"NULL", bar[9]?bar[9]:"NULL", bar[10]?bar[10]:"NULL")

			if(!qcon.Execute(dbcon))
				world.log << "SaveCharacter failed ([already_exists]):[qcon.ErrorMsg()]"
				return 0

			var/pid = 0

			qcon.Add("SELECT id FROM players WHERE name = ?", strg[5])

			if(!qcon.Execute(dbcon))
				world.log << "SaveCharacter(get player ID) failed:[qcon.ErrorMsg()]"
				return 0

			if(qcon.NextRow())
				pid = qcon.GetColumn(1)
			else
				world.log << "SaveCharacter(get player ID) failed: No save?"
				return 0

			var/current_skills[0]

			qcon.Add("SELECT id FROM skills WHERE player = ?", pid)

			if(!qcon.Execute(dbcon))
				world.log << "SaveCharacter(skills:check existing) failed:[qcon.ErrorMsg()]"
				return 0

			while(qcon.NextRow())
				current_skills += text2num(qcon.GetColumn(1) )

			var/skill_info[] = dd_text2list(lst[2], "&")
			var/skill_deletes[0]
			var/saved_skills[0]

			for(var/i = 0; i < skill_info.len;)
				var/id = text2num(skill_info[++i])
				var/cooldown = text2num(skill_info[++i])
				var/uses = text2num(skill_info[++i])

				if(!id || (id in saved_skills)) continue

				cooldown = cooldown?(cooldown):(0)
				uses = uses?(uses):(0)

				if(id in current_skills)
					qcon.Add("UPDATE skills SET cooldown=?, uses=? WHERE id=? AND player=?", cooldown, uses, id, pid)

					if(!qcon.Execute(dbcon))
						world.log << "SaveCharacter(skills:update) failed:[qcon.ErrorMsg()]"
						return 0
				else
					qcon.Add("INSERT INTO skills (id, cooldown, uses, player) VALUES ([id], [cooldown], [uses], [pid])")

					if(!qcon.Execute(dbcon))
						world.log << "SaveCharacter(skills:add) failed:[qcon.ErrorMsg()]"
						return 0

				saved_skills += id

			for(var/skill in current_skills)
				if(!(skill in saved_skills))
					skill_deletes += "id = [skill]"

			if(skill_deletes.len)
				var/skill_ids = ""

				for(var/i = 1, i < skill_deletes.len, ++i)
					skill_ids += skill_deletes[i]
					skill_ids += " OR "

				skill_ids += skill_deletes[skill_deletes.len]

				qcon.Add("DELETE FROM skills WHERE player = ? AND (?)", pid, skill_ids )

				if(!qcon.Execute(dbcon))
					world.log << "SaveCharacter(skills:delete) failed:[qcon.ErrorMsg()]"
					return 0

			var/current_items[0]
			qcon.Add("SELECT id FROM items WHERE player = ?", pid)

			if(!qcon.Execute(dbcon))
				world.log << "SaveCharacter(items:check existing) failed:[qcon.ErrorMsg()]"
				return 0

			while(qcon.NextRow())
				current_items += text2num(qcon.GetColumn(1) )

			var/items_info[] = inv//dd_text2list(lst[2], "&")
			var/item_deletes[0]
			var/saved_items[0]

			if(!istype(items_info, /list))
				items_info = list()

			for(var/i = 0; i < items_info.len;)
				var/id = text2num(items_info[++i])
				var/equipped = text2num(items_info[++i])

				if(!id || (id in saved_items)) continue

				equipped = equipped?(equipped):(0)

				if(id in current_items)
					qcon.Add("UPDATE items SET equipped=? WHERE id=? AND player=?", equipped, id, pid)

					if(!qcon.Execute(dbcon))
						world.log << "SaveCharacter(items:update) failed:[qcon.ErrorMsg()]"
						return 0
				else
					qcon.Add("INSERT INTO items (id, equipped, player) VALUES ([id], [equipped], [pid])")
					if(!qcon.Execute(dbcon))
						world.log << "SaveCharacter(items:add) failed:[qcon.ErrorMsg()]"
						return 0

				saved_items += id

			for(var/item in current_items)
				if(!(item in saved_items))
					item_deletes += "[item]"


			if(item_deletes.len)
				for(var/itemid in item_deletes)
					qcon.Add("DELETE FROM items WHERE player = ? AND id = ?", pid, itemid)

					if(!qcon.Execute(dbcon))
						world.log << "SaveCharacter(items: delete - id: [itemid]) failed:[qcon.ErrorMsg()]"
						return 0

				/*var/item_ids = ""

				for(var/i = 1, i < item_deletes.len, ++i)
					item_ids += item_deletes[i]
					item_ids += " OR "

				item_ids += item_deletes[item_deletes.len]

				qcon.Add("DELETE FROM items WHERE player = ? AND ?", pid, item_ids)

				if(!qcon.Execute(dbcon))
					world.log << "SaveCharacter(items:delete) failed:[qcon.ErrorMsg()]"
					return 0*/

			return 1

	DeleteItem(id, ckey)
		qcon.Add("select id from players where ckey = ?", ckey)
		if(!qcon.Execute(dbcon))
			return 0
		if(qcon.NextRow())
			var/player_id = qcon.GetColumn(1)

			qcon.Add("delete from items where id = ? and player = ?", id, player_id)
			if(!qcon.Execute(dbcon))
				return 0
			//world.log<<"DEBUG: DELETE ITEM WITH ID [id] FROM [ckey]"
			return 1
		return 0

	ClearSkills(ckey)
		qcon.Add("select id from players where ckey = ?", ckey)
		if(!qcon.Execute(dbcon))
			return 0
		if(qcon.NextRow())
			var/player_id = qcon.GetColumn(1)

			qcon.Add("delete from skills player = ?", player_id)
			if(!qcon.Execute(dbcon))
				return 0

			return 1
		return 0