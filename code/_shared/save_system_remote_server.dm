save_system/remote_server
	var
		server_address

		tmp
			_char_name_requests_cache
			_char_name_response_cache
			_requesting_char_names = 0

	New(server)
		..()
		if(!istext(server)) server = "[server]"
		//world.log << "server: [server]"
		var/server_online = world.Export("[server]?ping")
		world.log << server_online
		if(server_online)
			server_address = server
			ready = 1

	GetCharacterNames(key)
		//return SendInterserverMessageTopic(server_address, "get_chars", list("key" = key))
		if(!_char_name_requests_cache)
			_char_name_requests_cache = list(key)
		else if(!(key in _char_name_requests_cache))
			_char_name_requests_cache += key

		if(!_requesting_char_names)
			_requesting_char_names = 1
			sleep(20)
			//var/char_name_requests = _char_name_requests_cache
			_char_name_requests_cache = null
			_requesting_char_names = 0
			_char_name_response_cache = params2list(SendInterserverMessageTopic(server_address, "get_chars", list("key" = key)))

		else
			while(!_char_name_response_cache || !_char_name_response_cache[key])
				sleep(10)
				if(!_char_name_requests_cache)
					_char_name_requests_cache = list(key)

				else if(!(key in _char_name_requests_cache))
					_char_name_requests_cache += key

		var/names = _char_name_response_cache
		if(istext(names))
			names = list(names)
		if(!names)
			names = list()

		_char_name_response_cache[key] = null
		_char_name_response_cache -= key
		return names

	IsNameUsed(name)
		return SendInterserverMessageTopic(server_address, "check_name", list("name" = name))

	CreateSquad(name, leader)
		return SendInterserverMessageTopic(server_address, "new_squad", list("name" = name, "leader" = leader))

	DeleteSquad(name)
		return SendInterserverMessageTopic(server_address, "squad_delete", list("squad" = name))

	ChangeSquadLeader(name, new_leader)
		return SendInterserverMessageTopic(server_address, "squad_leader_change", list("squad" = name, "new_leader" = new_leader))

	GetSquadMemberCount(name)
		return SendInterserverMessageTopic(server_address, "squad_member_count", list("squad" = name))

	GetSquadInfo(name)
		return params2list(SendInterserverMessageTopic(server_address, "squad_info", list("squad" = name)))

	CreateFaction(name, leader, village, mouse_icon, chat_icon, chuunin_item, member_limit)
		return SendInterserverMessageTopic(server_address, "new_faction", list("name" = name, "leader" = leader, "village" = village, "mouse_icon" = mouse_icon, "chat_icon" = chat_icon, "chuunin_item" = chuunin_item, "member_limit" = member_limit))

	DeleteFaction(name)
		return SendInterserverMessageTopic(server_address, "faction_delete", list("faction" = name))

	ChangeFactionLeader(name, new_leader)
		return SendInterserverMessageTopic(server_address, "faction_leader_change", list("faction" = name, "new_leader" = new_leader))

	ChangeFactionLimit(name, new_limit)
		return SendInterserverMessageTopic(server_address, "faction_limit_change", list("faction" = name, "new_limit" = new_limit))

	ChangeFactionChuuninItem(name, new_chuunin_item)
		return SendInterserverMessageTopic(server_address, "faction_chuunin_item_change", list("faction" = name, "new_chuunin_item" = new_chuunin_item))

	ChangeFactionChuuninItemColor(name, new_chuunin_item_color)
		return SendInterserverMessageTopic(server_address, "faction_chuunin_item_color_change", list("faction" = name, "new_chuunin_item_color" = new_chuunin_item_color))

	GetFactionMemberCount(name)
		return SendInterserverMessageTopic(server_address, "faction_member_count", list("faction" = name))

	GetFactionInfo(name)
		return params2list(SendInterserverMessageTopic(server_address, "faction_info", list("faction" = name)))

	GetHelpers()
		// Not implemented as request. Automatically updated when helper change registered by saves.

	AddHelper(name, village)
		return SendInterserverMessageTopic(server_address, "add_helper", list("name" = name, "village" = village))

	RemoveHelper(name, village)
		return SendInterserverMessageTopic(server_address, "remove_helper", list("name" = name, "village" = village))

	IsBanned(key, computer_id)
		return SendInterserverMessageTopic(server_address, "is_banned", list("key" = key, "computer_id" = computer_id))

	AddBan(key, computer_id, reason, expire_time)
		var/list/topic = list("reason" = reason, "expire_time" = expire_time)
		if(key)
			topic["key"] = key
		if(computer_id)
			topic["computer_id"] = computer_id
		return SendInterserverMessageTopic(server_address, "add_ban", topic)

	RemoveBan(key, computer_id)
		var/list/topic = list()
		if(key)
			topic["key"] = key
		if(computer_id)
			topic["computer_id"] = computer_id
		return SendInterserverMessageTopic(server_address, "remove_ban", topic)

	SetInfoCardComment(name, village, new_comment)
		return SendInterserverMessageTopic(server_address, "char_info_set_comment", list("char" = name, "village" = village, "comment" = new_comment))

	GetInfoCard(name, village)
		return params2list(SendInterserverMessageTopic(server_address, "char_info_card", list("char" = name, "village" = village)))

	RenameCharacter(old_name, new_name, key)
		return SendInterserverMessageTopic(server_address, "rename_save", list("key" = key, "name_old" = old_name, "name_new" = new_name))

	DeleteCharacter(name, key)
		return SendInterserverMessageTopic(server_address, "delete_save", list("char" = name, "key" = ckey(key)))

	GetCharacter(name, key)
		var/text_char = SendInterserverMessageTopic(server_address, "get_save", list("char" = name, "key" = key))
		var/list/encoded_char = dd_text2List(text_char,"$")
		var/list/char = list()
		for(var/L in encoded_char)
			char += list(dd_text2List(L,";"))

		return char

	SaveCharacter(key, inv[], bar[], strg[], nums[], lst[])
		strg = strg.Copy()
		for(var/i = 1, i <= strg.len, ++i)
			strg[i] = Escape_String(strg[i])

		var/i = SendInterserverMessageTopic(server_address, "update_save", list("inv" = inv, "bar" = bar,"strg" = strg,"nums" = nums,"lst" = lst, "key" = key))
		sleep(100)
		var/e = 0
		while(!i && e < 5)
			e++
			i = SendInterserverMessageTopic(server_address, "update_save", list("inv" = inv, "bar" = bar,"strg" = strg,"nums" = nums,"lst" = lst, "key" = key))
			sleep(100)

		if(!i)
			world.log << "SaveCharacter([key]) failed."

		return i
/*
	GetBuildsByClan(clan)
		var/list/text_builds = params2list(SendInterserverMessageTopic(server_address, "get_builds", list("clan" = clan)))
		var/list/builds = list()
		for(var/text_build in text_builds)
			builds += list(params2list(text_build))

		return builds

	GetFullBuild(name, creator)
		return Text2Build(SendInterserverMessageTopic(server_address, "get_full_build", list("name" = name, "creator" = creator)))

	SaveBuild(list/build_info)
		return SendInterserverMessageTopic(server_address, "save_build", list("build" = Build2Text(build_info)))

	DeleteBuild(name, creator)
		return Text2Build(SendInterserverMessageTopic(server_address, "delete_build", list("name" = name, "creator" = creator)))
*/