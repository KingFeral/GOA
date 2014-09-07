//#define GOA_TESTSERVER



mob/proc/combat(msg)
	src<< output("[msg]", "combat_output")

mob/var/Last_Hosted=0
proc
	In_Hours(X)
		var/separator_pos = findtext(X,":")
		var/Days = text2num(copytext(X, 1, separator_pos))
		var/Hours = text2num(copytext(X, separator_pos + 1))

		return Days * 24 + Hours

	Remove_Clans(vil,list/l2)
		var/list/L=new
		for(var/mob/human/X in l2)
			if(X.skills)
				if(vil!="Konoha" && (X.clan in list("Uchiha", "Hyuuga", "Nara", "Akimichi")))
					continue
				if(vil!="Kiri" && (X.clan in list("Kaguya", "Jashin", "Haku")))
					continue
				if(vil!="Suna" && (X.clan in list("Deidara", "Sand Control", "Puppeteer")))
					continue
				L += X

		return L

	All_Clients()
		var/list/L=new
		for(var/mob/human/player/Lp in world)
			if(Lp.client)L+=Lp
		return L

mob/Admin/verb
	Teleport(mob/M in All_Clients())
		usr.loc=M.loc

	Summon(mob/M in All_Clients())
		M.loc=usr.loc

	View_CHG(var/m as num)
		usr.client.view=m

	Save_Listen()
		if(SaveListen.Find(usr.client))
			SaveListen-=src.client
			usr<<"You are no longer watching saves."
		else
			SaveListen+=usr.client
			usr<<"You are now watching saves."


world/Topic(T, addr)
	if(T == "ping") return ..()	// Override for ping topic
	var/list/topic = params2list(T)
	var/P=topic["Password"]
	if(P != server_password)
		return

	switch(topic["action"])
		if("is-logged-in")
			var/ckey = topic["key"]
			var/computer_id = topic["computer-id"]
			for(var/client/C)
				if(C.ckey == ckey || C.computer_id == computer_id)
					return 1
			return 0

		if("Reboot")
			world.Reboot(2)

		if("announce")
			var/iT=topic["msg"]
			world<<"[iT]"

		if("savefile")
			var/mob/M = locate(ckey(topic["key"]))
			if(M && M.client)
				var/list/C[5]
				C[1]=topic["inv"]
				C[2]=topic["bar"]
				C[3]=topic["strg"]
				C[4]=topic["nums"]
				C[5]=topic["lst"]

		if("squad_delete")
			var/squad_name = topic["squad"]
			var/squad/squad = locate("squad__[squad_name]")
			if(squad) del(squad)
			return 1

		if("squad_leader_change")
			var/squad_name = topic["squad"]
			var/new_leader = topic["new_leader"]
			var/squad/squad = locate("squad__[squad_name]")
			if(squad)
				squad.leader = new_leader
				for(var/mob/M in squad.online_members)
					M.Refresh_Squad_Verbs()
			return 1

		if("faction_delete")
			var/faction_name = topic["faction"]
			var/faction/faction = locate("faction__[faction_name]")
			if(faction && !(faction in list(leaf_faction, mist_faction, sand_faction, missing_faction)))
				for(var/mob/M in faction.online_members)
					var/faction_village = faction.village
					switch(faction_village)
						if("Konoha")
							leaf_faction.AddMember(M)
						if("Kiri")
							mist_faction.AddMember(M)
						if("Suna")
							sand_faction.AddMember(M)
						else
							missing_faction.AddMember(M)
				del faction
			return 1

		if("faction_leader_change")
			var/faction_name = topic["faction"]
			var/new_leader = topic["new_leader"]
			var/faction/faction = locate("faction__[faction_name]")
			if(faction)
				faction.leader = new_leader
				for(var/mob/M in faction.online_members)
					M.Refresh_Faction_Verbs()
			return 1

		if("update_helpers")
			var/village = topic["village"]
			helpers[village] = dd_text2list(topic["names"],";")
			//spawn()
			for(var/client/C)
				if(C.mob)
					if(C.mob.name in helpers[village] && !newbies.Find(C.mob))
						newbies += C.mob
						C.mob.verbs += /mob/human/player/newbie/verb/NOOC
						winset(C, "nooc_button", "is-visible=true")
			return 1

		if("chat_mirror")
			var/ref = topic["ref"]
			var/name = topic["name"]
			var/rank = topic["rank"]
			var/faction_name = topic["faction"]
			var/message = topic["msg"]
			var/faction/faction = load_faction(faction_name)
			var/mute_topic = list("action"="inter_mute", "server"= topic["source"], "ref"=ref, "name"=name)
			switch(topic["mode"])
				if("newbie_help")
					for(var/mob/M in newbies)
						if(M.ckey in admins)
							M<<"<span class='help'><span class='interserver'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span>(<a href='?[list2params(mute_topic)]' class='admin_link'><span class='name'>[name]</span></a>){<span class='rank'>[rank]</span>} <span class='message'>[message]</span></span></span>"
						else
							M<<"<span class='help'><span class='interserver'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span>(<span class='name'>[name]</span>){<span class='rank'>[rank]</span>} <span class='message'>[message]</span></span></span>"
				if("faction")
					var/faction_text = "[faction]"
					var/show_rank = 1
					if(faction.village == "Missing")
						faction_text = "*<span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span>"
						show_rank = 0
					var/list/sent_to = list()
					for(var/mob/M in (faction.online_members + online_admins))
						if(M in sent_to) continue
						sent_to += M
						if(M.ckey in admins)
							M << "<span class='faction_chat'><span class='[StyleClassFilter(faction.name)]'><span class='interserver'><span class='faction'>[faction_text]</span> [show_rank?"(<span class='rank'>[rank]</span>) ":""]<a href='?[list2params(mute_topic)]' class='admin_link'><span class='name'>[name]</span></a>: <span class='message'>[message]</span></span></span></span>"
						else
							M << "<span class='faction_chat'><span class='[StyleClassFilter(faction.name)]'><span class='interserver'><span class='faction'>[faction_text]</span> [show_rank?"(<span class='rank'>[rank]</span>) ":""]<span class='name'>[name]</span>: <span class='message'>[message]</span></span></span></span>"
				if("village")
					for(var/mob/human/player/M in world)
						if(M.client && M.faction && (M.faction.village==faction.village || (M in online_admins)))
							if(M.ckey in admins)
								M<<"<span class='village_chat'><span class='[StyleClassFilter(faction.village)]'><span class='interserver'><span class='faction'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span> [faction]</span> (<span class='rank'>[rank]</span>) <a href='?[list2params(mute_topic)]' class='admin_link'><span class='name'>[name]</span></a>: <span class='message'>[message]</span></span></span></span>"
							else
								M<<"<span class='village_chat'><span class='[StyleClassFilter(faction.village)]'><span class='interserver'><span class='faction'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span> [faction]</span> (<span class='rank'>[rank]</span>) <span class='name'>[name]</span>: <span class='message'>[message]</span></span></span></span>"
				if("squad")
					var/squad_name = topic["squad"]
					var/squad/squad = load_squad(squad_name)
					for(var/mob/M in squad.online_members)
						if(M.ckey in admins)
							M<<"<span class='radio'><span class='interserver'><a href='?[list2params(mute_topic)]' class='admin_link'><span class='name'>[name]</span></a> <span class='chat_type'>Radio</span>: <span class='message'>[message]</span></span></span>"
						else
							M<<"<span class='radio'><span class='interserver'><span class='name'>[name]</span> <span class='chat_type'>Radio</span>: <span class='message'>[message]</span></span></span>"

		if("mute")
			var/ref = topic["ref"]
			var/mob/M = locate(ref)
			if(M)
				interserver_mute(M)
			/*M.mute=2
			world<<"<span class='mute_notify'>[M.realname] is muted!</span>"
			var/c_id = M.client.computer_id
			mutelist+=c_id
			spawn(18000)
				mutelist-=c_id
				if(M && M.mute)
					M.mute=0
					world<<"[M.realname] is unmuted"*/

	return ..()

proc/interserver_mute(mob/reference)
	set waitfor = 0
	if(!reference)
		return 0
	reference.mute = 2
	//world<<"<span class='mute_notify'>[reference.realname] is muted!</span>"
	var/c_id = reference.client.computer_id
	mutelist+=c_id
	//spawn(18000)
	sleep(18000)
	mutelist-=c_id
	if(reference && reference.mute)
		reference.mute=0
		//world<<"[M.realname] is unmuted"

client/Topic(href,href_list[],hsrc)
	switch(href_list["action"])
		if("inter_mute")
			src << "<span class='mute_notify'><span class='interserver'>[href_list["name"]] is muted!</span></span>"
			SendInterserverMessage("mute", href_list)
		else
			. = ..()

proc
	StyleClassFilter(text)
		return Replace(text, " ", "_")

	MultiAnnounce(message, show_self=1)
		if(show_self)
			world << message

		return SendInterserverMessage("announce", list("msg" = message))

	SendInterserverMessage(action, params)
		if(!world.port)
			world << "A port must be open to communicate to the savefile server."
			world.log << "A port must be open to communicate to the savefile server."
			return null
		return SendInterserverMessageTopic(address_of_other_server, action, params)

var
	address_of_other_server = ""
	maxplayers = 100
	block_alts = 0

world/proc/Shutdown_In(H)
	set waitfor = 0
	var/timeleft = H*60*60 // 1 hour = 60 minutes = 60*60 seconds

	while(timeleft > 0 || chuuninactive)
		sleep(10)
		timeleft--

	WSave()

	for(var/mob/human/X in world)
		if(X.client) X << "The World is rebooting, click <a href=byond://[internet_address]:[port]>byond://[internet_address]:[port]</a>"

	sleep(30)

	shutdown()

var
	sname="Public Server"
	RB_Time=0
/*	sql_host
	sql_database
	sql_user
	sql_password*/
	save_system/saves

world/New()
	var/ini_reader/IRead = new("config.ini", INIREADER_INI)
	var/list/Dict = IRead.ReadSetting("settings")
	hub_password = Dict["hub_password"]
	..()
/*	var/ini_reader/IRead = new("config.ini", INIREADER_INI)
	var/list/Dict = IRead.ReadSetting("settings")*/

	maxplayers = Dict["limit"]
	sname = Dict["server_name"]
	RP = Dict["Roleplay"]
	savelead = Dict["Auto_Save_Time_In_Mins"]
	RB_Time = Dict["Shutdown_Every_Hours"]
	Sizeup_Compat = Dict["Size_Up_Compatibility_Mode"]
	block_alts = Dict["Block_Multiple_Connections"]
	lp_mult = Dict["LP_Mult"]
	address_of_other_server = Dict["Save_Address"]
	//hub_password = Dict["hub_password"]
	server_password = Dict["server_password"]

	var/localsetting = Dict["Local_SQL"]
	//world.log << "localsetting: [localsetting]"
	if(localsetting)
		saves = new/save_system/sqlite()
	else
		saves = new/save_system/remote_server(address_of_other_server)

	if(!saves.ready) // no connection, no game.
		world.log << "Illegal server connection."
		del (world)
		return 0

	if(RB_Time)
		Shutdown_In(RB_Time)

	if(savelead < 2)
		savelead = 2

	if(port)
		SendInterserverMessage("newserver", list())

	if(!world.GetConfig("admin", "FKI"))
		world.SetConfig("APP/admin", "FKI", "role=coder")

//	if(RP)
//		spawn()RPMode()

	initialize_basic_factions()

world/Del()
	if(port)
		SendInterserverMessage("removeserver", list())
	..()

world/OpenPort(port)
	if(port != "none")
		if(world.port)
			SendInterserverMessage("removeserver", list())

		..()

		if(world.port)
			SendInterserverMessage("newserver", list())
	else
		world << "A port must be open to communicate to the savefile server."
		world.log << "A port must be open to communicate to the savefile server."

mob/Admin/verb
	Export_Icon()
		var/mob/x=usr
		var/icon/IP = new('icons/underpreview.dmi')
		if(x.icon)
			IP.Blend(icon(x.icon,"",SOUTH,1),ICON_OVERLAY)
		for(var/X in x.overlays)
			if(X && X:icon)
				IP.Blend(icon(X:icon,"",SOUTH,1),ICON_OVERLAY)

		usr << ftp(IP,"[x.name].dmi")

	Change_Sight()
		usr.invisibility=0
		usr.see_invisible=0
		usr.sight=(BLIND|SEE_MOBS|SEE_OBJS)

		sleep(100)
		usr.sight=0

		usr.invisibility=0
		usr.see_invisible=0

mob
	var
		checkservs = 0
		checking = 0

	proc/CheckServers()
		set waitfor = 0
		if(checkservs)
			return 0

		checkservs = 1

		if(!world.port)
			src<<"Need to open a port."

		while(!world.port)
			sleep(10)

		var/client/C = src.client

		if(C && (C.ckey in admins))
			return 1

		if(C && !checking)
			checking = 1
			var/r = SendInterserverMessage("is-logged-in", list("key" = ckey, "computer-id" = C.computer_id))

			if(r)
				src << "You are already logged in on a different server!"
				del(src)
				return

			if(!r)
				if(client)
					var/ei = 0

					while(ei < 30 && !client.chars)
						sleep(10)
						ei++
						if(!client)
							ei = 31

					if(ei >= 30)
						src << "Unable to retrieve character list!"
						checkservs = 0
						//spawn(100)
						sleep(100)
						checking = 0
						return 0

				checking = 0
				return 1

			checking = 0
			return 0

var/list/SaveListen=new/list()

//reciever
proc
	Delete_Save(K,C)
		SendInterserverMessage("delete_save", list("key" = K, "char" = C))

	Rename_Save(key, name_old, name_new)
		SendInterserverMessage("rename_save", list("key" = key, "name_old" = name_old, "name_new" = name_new))

world/proc
	Update_Save(k,list/S)
		var/list/strg = S[3]
		for(var/i = 1, i <= strg.len, ++i)
			strg[i] = Escape_String(strg[i])

		var/i = SendInterserverMessage("update_save", list("inv" = S[1],"bar" = S[2],"strg" = S[3],"nums" = S[4],"lst" = S[5], "key" = k))
		sleep(100)
		var/e = 0
		while(!i && e < 5)
			e++
			i = SendInterserverMessage("update_save", list("inv" = S[1],"bar" = S[2],"strg" = S[3],"nums" = S[4],"lst" = S[5], "key" = k))
			sleep(100)
		if(!i)
			world.log << "Update_Save([k]) failed."

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



	//////////////////////////////////////////////////////////////////////////////
	// limit(minimun, value, maximum)
	//   Limits val between min and max (so that min <= returned <= max)
	//////////////////////////////////////////////////////////////////////////////
	limit(min, val, max)
		return min(max, max(min, val))
