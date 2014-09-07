var
	dontdoshit=0
	fuckupcount=0
	server_password//="EOA8?rVD7yp-O%`Js:R+_qd1Ms9%P%x4QBl"
	list/Serverlist=new
	save_system/sqlite/saves
	sql_host
	sql_database
	sql_user
	sql_password

check_ref
	var
		success = 0
		count = 0

proc
	// Mirror a topic message to every connected server, except the source server.
	mirror(href, addr, file)
		spawn() for(var/X in (Serverlist - addr))
			world.Export("[X]?[href]", file)
	mirror_check(href, addr, file)
		var/check_ref/ret = new
		var/launched = 0
		for(var/X in (Serverlist - addr))
			++launched
			spawn()
				var/val =  world.Export("[X]?[href]", file)
				++ret.count
				ret.success = ret.success || val
		while(launched > ret.count && !ret.success)
			sleep(1)
		return ret.success

	update_helpers(addr)
		var/list/helpers = saves.GetHelpers()

		for(var/village in helpers)
			var/topic = list("action" = "update_helpers", "village" = village, "names" = dd_list2text(helpers[village],";"), "Password"=server_password)
			if(!addr)
				mirror(list2params(topic))
			else
				world.Export("[addr]?[list2params(topic)]")

world/proc
	Reeb()
		dontdoshit=1

		shutdown()

	// Make sure servers are still connected.
	Server_Loop()
		set background = 1
		set waitfor = 0
		while(world)
			for(var/X in Serverlist)
				spawn()
					if(!world.Export("[X]?ping"))
						world.log << "Removed server [X]: Ping failed"
						Serverlist -= X

			sleep(600)	// Repeat every minute.

world/New()
	..()
	var/ini_reader/IRead = new("config.ini", INIREADER_INI)
	var/list/Dict = IRead.ReadSetting("settings")

	//sql_host=Dict["SQL_Host"]
	//sql_database=Dict["SQL_Database"]
	//sql_user=Dict["SQL_User"]
	//sql_password=Dict["SQL_Password"]
	server_password = Dict["server_password"]

	// Connect to MySQL database.
	saves = new /save_system/sqlite()//(sql_host, sql_database, sql_user, sql_password)
	if(!saves.ready)
		del world

	// Start up ping loop.
	Server_Loop()

world/Topic(href, addr)
	//world.log << "from [addr]: [href]"

	if(!saves.IsAllowedServer(copytext(addr, 1, findtext(addr, ":"))))
		return 0

	// Let pings go through without a password
	if(href == "ping") return ..()
	if(dontdoshit) return

	var/T[] = params2list(href)
	var/P=T["Password"]

	if(P!=server_password)
		return

#if DM_VERSION >= 462
	if(findtextEx(addr, ":"))
#else
	if(findText(addr, ":"))
#endif
		// It's a server we don't already know about -- assume it's new.
		if(!(addr in Serverlist))
			world.log << "Added server [addr]"
			Serverlist += addr
	else
		// Server without a port!
		// The announce scripts trigger this, so let them through
		// Anything else should be ignored because it's a copy of the game running in DS
		if(T["action"] != "announce")
			return


	switch(T["action"])
		if("newserver")
			spawn()
				update_helpers(addr)
		if("announce")
			mirror(href, addr)

		if("chat_mirror")
			T["source"] = addr
			mirror(list2params(T), addr)

		if("mute")
			world.Export("[T["server"]]?[href]")


		if("is-logged-in")
			return mirror_check(href, addr)

		if("get_chars")
			. = saves.GetCharacterNames(T["key"])

			if(istype(., /list))
				. = list2params(.)


			return .

		if("check_name")
			return saves.IsNameUsed(T["name"])

		if("new_squad")
			return saves.CreateSquad(T["name"], T["leader"])

		if("squad_delete")
			. =  saves.DeleteSquad(T["squad"])

			if(. && !T["nomirror"])
				mirror(href, addr)

			return .

		if("squad_leader_change")
			. = saves.ChangeSquadLeader(T["squad"], T["new_leader"])

			if(.)
				mirror(href, addr)

			return .

		if("squad_member_count")
			return saves.GetSquadMemberCount(T["squad"])

		if("squad_info")
			. =  saves.GetSquadInfo(T["squad"])

			if(istype(., /list))
				. = list2params(.)

			return .

		if("new_faction")
			return saves.CreateFaction(T["name"], T["leader"], T["village"], T["mouse_icon"], T["chat_icon"], T["chuunin_item"], T["member_limit"])

		if("faction_delete")
			. =  saves.DeleteFaction(T["faction"])

			if(. && !T["nomirror"])
				mirror(href, addr)

			return .

		if("faction_leader_change")
			. = saves.ChangeFactionLeader(T["faction"], T["new_leader"])

			if(.)
				mirror(href, addr)

			return .

		if("faction_member_count")
			return saves.GetFactionMemberCount(T["squad"])

		if("faction_info")
			. =  saves.GetFactionInfo(T["faction"])

			if(istype(., /list))
				. = list2params(.)

			return .

		if("add_helper")
			. = saves.AddHelper(T["name"], T["village"])

			if(.)
				update_helpers()

			return .

		if("remove_helper")
			. = saves.RemoveHelper(T["name"], T["village"])

			if(.)
				update_helpers()

			return .

		if("is_banned")
			return saves.IsBanned(T["key"], T["computer_id"])

		if("add_ban")
			return saves.AddBan(T["key"], T["computer_id"])

		if("remove_ban")
			return saves.RemoveBan(T["key"], T["computer_id"])

		if("char_info_set_comment")
			return saves.SetInfoCardComment(T["char"], T["village"], T["comment"])

		if("char_info_card")
			. =  saves.GetInfoCard(T["char"], T["village"])

			if(istype(., /list))
				. = list2params(.)

			return .

		if("rename_save")
			return saves.RenameCharacter(T["name_old"], T["name_new"])

		if("delete_save")
			return saves.DeleteCharacter(T["char"], T["key"])

		if("get_save")
			. = saves.GetCharacter(T["char"], T["key"])

			if(istype(., /list))
				var/encoded[0]

				for(var/list/L in .)
					encoded += dd_list2text(L,";")

				. = dd_list2text(encoded,"$")

			return .

		if("update_save")
			return saves.SaveCharacter(T["key"], T["inv"], T["bar"], T["strg"], T["nums"], T["lst"])

		if("removeserver")
			world.log << "Removed server [addr]: Requested removal"
			Serverlist -= addr
	return ..()

proc
/*
	Replace proc
	This replaces word in text with replace
	All three arguments are expected to be text
*/
	Replace(text,word,replace)
		var/pos = findtext(text,word)
		while(pos)
			text = copytext(text,1,pos) + replace + copytext(text,pos+length(word))
			pos = findtext(text,word)
		return text

/*
	Replace All proc
	replace_list: list in the format word = replace
	replaces each word with it's replace entry
*/
	Replace_All(text,replace_list)
		for(var/word in replace_list)
			var/pos = findtext(text,word)
			while(pos)
				text = copytext(text,1,pos) + replace_list[word] + copytext(text,pos+length(word))
				pos = findtext(text,word)
		return text

	Escape_String(str)
		return Replace_All(str, list(";" = " ", "$" = " ", "&" = " "))

proc/Sanitize(X)
	var/Y="NULL"
	if(isnull(X))
		Y="NULL"
	else
		Y="[X]"
	return Y

