var
	save_system/sqlite/saves

save_system/sqlite
	var
		database/dbcon
		database/query/qcon
		ready = 0

	New()
		. = ..()

		dbcon = new("GOA.db")
		qcon = new

	proc
		Quote(text)
			if(isnull(text))
				text="NULL"
			else
				text="[text]"

	CreateFaction(name, leader, village, mouse_icon, chat_icon, chuunin_item, member_limit)
		var
			query_sql = {"
				INSERT INTO `factions` (`leader`, `name`, `village`, `mouse_icon`, `chat_icon`,`chuunin_item`, `member_limit`)
					VALUES (
						(SELECT `id` FROM `players` WHERE `name` = ?),
						?,
						?,
						?,
						?,
						?,
						?
					)"}

		qcon.Add( "[query_sql]",leader, name,  village, mouse_icon, chat_icon, chuunin_item, member_limit)

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

/*	GetFactionMemberCount(name)
		qcon.Add( "SELECT COUNT(*) FROM `players` WHERE `faction` = (SELECT `id` FROM `factions` WHERE `name` = ?)", name)

		if(!qcon.Execute(dbcon))
			world.log << "GetFactionMemberCount failed:[qcon.ErrorMsg()]"
			return 100

		if(qcon.NextRow())
			var/list/columns = qcon.GetRowData()
			return text2num(columns[1])

		return 100*/

	GetFactionInfo(name)

		qcon.Add( "SELECT * FROM `factions` WHERE `name` = ?", name )

		if(!qcon.Execute(dbcon))
			world.log << "Faction info([name]) failed:[qcon.ErrorMsg()]"
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
					var/list/columns = qcon.GetRowData()
					leader = columns["leader"]


			var/list/ret = list("name" = info["name"], "leader" = leader, "village" = info["village"], "mouse_icon" = info["mouse_icon"], "chat_icon" = info["chat_icon"], "chuunin_item" = info["chuunin_item"], "member_limit" = info["member_limit"])
			return ret

		return 0

	GetLastLoginDate(ckey)
		qcon.Add( "SELECT * FROM `players` WHERE `ckey` = ?", ckey )

		if(!qcon.Execute(dbcon))
			world.log << "GetLastLoginDate ([ckey]) failed:[qcon.ErrorMsg()]"
			return 0

		var/row = qcon.GetRowData()
		if(!isnull(row))
			. = row["last_login_date"]
			row = null

	SetLastLoginDate(ckey)
		qcon.Add( "UPDATE `players` SET `last_login_date` = ? WHERE `ckey` = ?", time2text(world.timeofday, "DDD MMM DD hh:mm:ss"), ckey )

		if(!qcon.Execute(dbcon))
			world.log << "SetLastLoginDate ([ckey]) failed:[qcon.ErrorMsg()]"
			return 0

