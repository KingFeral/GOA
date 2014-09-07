var
	list
		faction_mouse = list(
			"Konoha" 		= 'media/faction/mouse_icons/konoha_mouse.dmi',
			"Kiri" 			= 'media/faction/mouse_icons/kiri_mouse.dmi',
			"Suna" 			= 'media/faction/mouse_icons/suna_mouse.dmi',
		)
		faction_chat = list(
			"Konoha" 		= 'media/faction/chat_icons/konoha_chat.png',
			"Kiri" 			= 'media/faction/chat_icons/kiri_chat.png',
			"Suna" 			= 'media/faction/chat_icons/suna_chat.png',
			"Missing" 		= 'media/faction/chat_icons/missing_chat.png',
		)

faction
	var
		leader
		village
		name
		mouse_icon
		chat_icon
		chuunin_item
		member_limit
		tmp
			player/online_members[0]

	New(faction_name, faction_village, var/player/leader_mob, faction_mouse_icon, faction_chat_icon, faction_chuunin_item=0, member_limit=0, topic_call=0)
		. = ..()

		name = faction_name
		tag = "faction__[faction_name]"
		village = faction_village

		var/leader_string

		if(istype(leader_mob,/player) )
			online_members += leader_mob
			leader_string = leader_mob.name
		else
			leader_string = leader_mob

		leader = leader_string
		mouse_icon = faction_mouse_icon
		chat_icon = faction_chat_icon

		if(faction_chuunin_item && !isnum(faction_chuunin_item))
			faction_chuunin_item = text2num("[faction_chuunin_item]")

		chuunin_item = faction_chuunin_item

		if(topic_call)
			saves.CreateFaction(faction_name, leader_string, faction_village, mouse_icon, chat_icon, chuunin_item, member_limit)

	proc
		AddMember(mob/P)
			online_members += P
			P.faction = src
			if(mouse_icon) P.mouse_over_pointer = faction_mouse[mouse_icon]
			//P.Refresh_Faction_Verbs()

		RemoveMember(mob/P)
			//if(P.faction == missing_faction) return

			online_members -= P
			P.mouse_over_pointer = null

			if(P.faction.name in list("Konohagakure", "Sunagakure", "Kirigakure"))
				missing_faction.AddMember(P)
			else
				switch(P.faction.village)
					if("Konoha")
						leaf_faction.AddMember(P)
					if("Kiri")
						mist_faction.AddMember(P)
					if("Suna")
						sand_faction.AddMember(P)
					else
						missing_faction.AddMember(P)

mob
	var/tmp/faction/faction

var
	faction
		leaf_faction
		mist_faction
		sand_faction
		missing_faction

proc
	initialize_basic_factions()
		var/list/faction_info
		faction_info = saves.GetFactionInfo("Konohagakure")
		leaf_faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["member_limit"], 0)

		faction_info = saves.GetFactionInfo("Kirigakure")
		mist_faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["member_limit"], 0)

		faction_info = saves.GetFactionInfo("Sunagakure")
		sand_faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["member_limit"], 0)

		faction_info = saves.GetFactionInfo("Missing")
		missing_faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["member_limit"], 0)

		leaf_faction.tag = "faction__[leaf_faction.name]"
		mist_faction.tag = "faction__[mist_faction.name]"
		sand_faction.tag = "faction__[sand_faction.name]"
		missing_faction.tag = "faction__[missing_faction.name]"
		world.log << "Basic factions loaded"

	load_faction(faction_name)
		var/faction/faction
		switch(faction_name)
			if("Konohagakure")
				faction = leaf_faction
				world.log << "Found leaf_faction [leaf_faction] - Konohagakure"
			if("Kirigakure")
				faction = mist_faction
				world.log << "Found mist_faction [mist_faction] - Kirigakure"
			if("Sunagakure")
				faction = sand_faction
				world.log << "Found sand_faction [sand_faction] - Sunagakure"
			if("Missing")
				faction = missing_faction
				world.log << "Found missing_faction [missing_faction] - Missing"
			else
				faction = locate("faction__[faction_name]")
				world.log << "Found faction__[faction_name] [faction] - [faction.village]"
		if(!faction)
			var/list/faction_info = params2list(saves.GetFactionInfo("name" = faction_name))
			faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["member_limit"], 0)
			faction.tag = "faction__[faction.name]"
			world.log << "Loaded faction__[faction_name] [faction] - [faction.village]"
		return faction