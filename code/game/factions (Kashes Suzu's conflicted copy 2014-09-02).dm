var
	list
		faction_mouse = list(
			"Konoha" = 'icons/mouse_icons/konohamouse.dmi',
			"Kiri" = 'icons/mouse_icons/mistmouse.dmi',
			"Suna" = 'icons/mouse_icons/sunamouse.dmi',
			"Ourico-Ame" = 'faction_icons/ourico-ame-mouse.dmi',
			"Mange-Sound" = 'faction_icons/mange-sound-mouse.png',
			"Zelko-Blitzkreig" = 'faction_icons/zelko-blitzkreig-mouse.dmi',
		)
		faction_chat = list(
			"Konoha" = 'pngs/Leaf.png',
			"Kiri" = 'pngs/Mist.png',
			"Suna" = 'pngs/Sand.png',
			"Missing" = 'pngs/Missing.png',
			"Ourico-Ame" = 'faction_icons/ourico-ame-chat.png',
			"Mange-Sound" = 'faction_icons/mange-sound-chat.png',
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
		rate = 0
		tmp
			mob/human/player/online_members[0]

	New(faction_name, faction_village, mob/human/player/leader_mob, faction_mouse_icon, faction_chat_icon, faction_chuunin_item=0, member_limit=0, topic_call=0)
		. = ..()
		name = faction_name
		tag = "faction__[faction_name]"
		village = faction_village
		var/leader_string
		if(ismob(leader_mob))
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
			//SendInterserverMessage("new_faction", list("name" = faction_name, "leader" = leader_string, "village" = faction_village, "mouse_icon" = mouse_icon, "chat_icon" = chat_icon, "chuunin_item" = chuunin_item, "member_limit" = member_limit))

	proc
		AddMember(mob/M)
			online_members += M
			M.faction = src
			if(mouse_icon) M.mouse_over_pointer = faction_mouse[mouse_icon]
			M.Refresh_Faction_Verbs()

		RemoveMember(mob/M)
			online_members -= M
			M.mouse_over_pointer = null

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
		leaf_faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["chuunin_item_color"], faction_info["member_limit"], 0)

		faction_info = saves.GetFactionInfo("Kirigakure")
		mist_faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["chuunin_item_color"], faction_info["member_limit"], 0)

		faction_info = saves.GetFactionInfo("Sunagakure")
		sand_faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["chuunin_item_color"], faction_info["member_limit"], 0)

		faction_info = saves.GetFactionInfo("Missing")
		missing_faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["chuunin_item_color"], faction_info["member_limit"], 0)

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
				//world.log << "Found leaf_faction [leaf_faction] - Konohagakure"
			if("Kirigakure")
				faction = mist_faction
				//world.log << "Found mist_faction [mist_faction] - Kirigakure"
			if("Sunagakure")
				faction = sand_faction
				//world.log << "Found sand_faction [sand_faction] - Sunagakure"
			if("Missing")
				faction = missing_faction
				//world.log << "Found missing_faction [missing_faction] - Missing"
			else
				faction = locate("faction__[faction_name]")
				//world.log << "Found faction__[faction_name] [faction] - [faction.village]"
		if(!faction)
			var/list/faction_info = saves.GetFactionInfo(faction_name)
			faction = new /faction(faction_info["name"], faction_info["village"], faction_info["leader"], faction_info["mouse_icon"], faction_info["chat_icon"], faction_info["chuunin_item"], faction_info["member_limit"], 0)
			faction.tag = "faction__[faction.name]"
			//world.log << "Loaded faction__[faction_name] [faction] - [faction.village]"
		return faction

mob
	var
		tmp/faction/faction
	proc
		Refresh_Faction_Verbs()
			var/client/C = client
			if(!C && usr && usr.client)
				C = usr.client
			if(faction)
				//No verbs for these categories yet
				//verbs += typesof(/mob/faction_verbs/verb)
				if(C) winset(usr, "faction_menu", "parent=menu;name=\"&Faction\"")
				if(faction.leader == realname)
					//verbs += typesof(/mob/faction_verbs/leader/verb)
					if(C) winset(C, "faction_leader_menu", "parent=faction_menu;name=\"&Leader\"")
				if(faction.village != "Missing")
					verbs += typesof(/mob/faction_verbs/non_missing/verb)
					if(C)
						winset(C, "vsay_button", "is-visible=true")
						winset(C, "faction_verb_vsay", "parent=faction_menu;name=\"&Village Say\";command=Village-Say")
						winset(C, "faction_verb_vleave", "parent=faction_menu;name=\"L&eave Village\";command=Leave-Village")
				if(!(faction in list(leaf_faction, mist_faction, sand_faction, missing_faction)))
					verbs += typesof(/mob/faction_verbs/non_default/verb)
					if(C)
						winset(C, "fsay_button", "is-visible=true")
						winset(C, "faction_verb_fsay", "parent=faction_menu;name=\"&Faction Say\";command=Faction-Say")
						winset(C, "faction_verb_fleave", "parent=faction_menu;name=\"L&eave Faction\";command=Leave-Faction")
					if(faction.leader == realname)
						verbs += typesof(/mob/faction_verbs/leader/non_default/verb)
						if(C)
							winset(C, "faction_verb_finvite", "parent=faction_leader_menu;name=\"&Invite\";command=Invite-to-Faction")
							winset(C, "faction_verb_fkick", "parent=faction_leader_menu;name=\"&Kick\";command=Kick-from-Faction")
				if(faction in list(leaf_faction, mist_faction, sand_faction))
					if(faction.leader == realname)
						verbs += typesof(/mob/faction_verbs/leader/default_non_missing/verb)
						if(C)
							winset(C, "arena_host_menu", "parent=faction_leader_menu;name=\"&Arena\"")
							winset(C, "arena_host_verb_start", "parent=arena_host_menu;name=\"&Start Torunament\";command=Start-Tourney")
							winset(C, "arena_host_verb_end", "parent=arena_host_menu;name=\"&End Torunament\";command=End-Tourney")
							winset(C, "arena_host_verb_send", "parent=arena_host_menu;name=\"&Send Player to Arena\";command=Send-to-Arena")
							winset(C, "arena_host_verb_fight", "parent=arena_host_menu;name=\"Start &Fight\";command=Start-Fight")
							winset(C, "arena_host_verb_winner", "parent=arena_host_menu;name=\"Declare &Winner\";command=Declare-Winner")
							winset(C, "subfaction_menu", "parent=faction_leader_menu;name=\"&Village Factions\"")
							winset(C, "subfaction_verb_create", "parent= subfaction_menu; name=\"&Create New Faction...\";command=Create-Faction-KAGE")
							winset(C, "subfaction_verb_change", "parent= subfaction_menu; name=\"Change Faction &Leader...\";command=Change-Faction-Leader-KAGE")
							winset(C, "faction_verb_vinvite", "parent=faction_leader_menu;name=\"&Invite\";command=Invite-to-Village")
							winset(C, "faction_verb_vkick", "parent=faction_leader_menu;name=\"&Kick\";command=Kick-from-Village")
							winset(C, "faction_verb_chuunin", "parent=faction_leader_menu;name=\"Host &Chuunin Exam\";command=Host-Chuunin-Exam")
							winset(C, "faction_verb_rank", "parent=faction_leader_menu;name=\"&Promote Villager\";command=Change-Rank")
							winset(C, "faction_verb_infocard", "parent=faction_leader_menu;name=\"Change I&nfo Card Comment\";command=Set-Info-Card-Comment")
							winset(C, "faction_verb_addhelper", "parent=faction_leader_menu;name=\"A&dd Helper\";command=Add-Helper")
							winset(C, "faction_verb_removehelper", "parent=faction_leader_menu;name=\"&Remove Helper\";command=Remove-Helper")
							winset(C, "faction_verb_mute", "parent=faction_leader_menu;name=\"&Mute\";command=Mute-KAGE")
							winset(C, "faction_verb_unmute", "parent=faction_leader_menu;name=\"&Unmute\";command=Unmute-KAGE")
							winset(C, "faction_verb_unmuteall", "parent=faction_leader_menu;name=\"Unmute &Everyone\";command=Unmute-All-KAGE")
			else
				if(C)
					winset(C, "vsay_button", "is-visible=false")
					winset(C, "fsay_button", "is-visible=false")
					winset(C, "faction_menu", "parent=")
					winset(C, "faction_leader_menu", "parent=")
				verbs -= typesof(/mob/faction_verbs/non_missing)
				verbs -= typesof(/mob/faction_verbs/non_default/verb)
				verbs -= typesof(/mob/faction_verbs/leader/non_default/verb)

mob/MasterAdmin/verb
	Create_Faction(faction_name as text, village as text, leader_name as text|mob in world, mouse_icon as null|anything in faction_mouse, chat_icon as anything in faction_chat, chuunin_item as null|num, member_limit as num)
		set desc = "(faction, village, leader name, mouse icon, chat icon) Create a new faction"
		var/list/faction_info = saves.GetFactionInfo(faction_name)//params2list(SendInterserverMessage("faction_info", list("faction" = faction_name)))
		if(!faction_info["name"])
			var/faction/faction = new /faction(faction_name, village, leader_name, mouse_icon, chat_icon, chuunin_item, member_limit, 1)
			faction.tag = "faction__[faction.name]"
			if(ismob(leader_name))
				faction.AddMember(leader_name)
				leader_name:Refresh_Faction_Verbs()
		else
			usr << "There is already a faction using that name!"
	Change_Faction_Leader(faction_name as text, leader_name as text|mob in world)
		set desc = "(faction, leader name) Change the leader of a faction."
		var/faction/faction = load_faction(faction_name)
		if(!faction)
			src << "That faction (\"[faction_name]\") does not exist."
		else
			faction.leader = "[leader_name]"
			if(ismob(leader_name))
				faction.AddMember(leader_name)
				leader_name:Refresh_Faction_Verbs()
			saves.ChangeFactionLeader(faction_name, faction.leader)//SendInterserverMessage("faction_leader_change", list("faction" = faction_name, "new_leader" = faction.leader))

mob/faction_verbs
	non_missing
		verb
			Village_Say(var/t as text)
				set category="Faction"
				winset(usr, "map", "focus=true")

				t = Replace_All(t,chat_filter)
				if(mute||tempmute)
					src<<"You're Muted"
				else
					if(name!="")
						talkcool=20
						talktimes+=1
						if(talktimes>=2 && rank=="Academy Student")
							src<<"Sorry new players cannot talk that fast, take a breather before each message."
							return
						if(talktimes>=8)
							src<<"You have been temporarily muted for talking too quickly."
							tempmute=1
							sleep(100)
							src<<"temp mute lifted"
							tempmute=0
							talktimes=0
						if(talkcooling==0)
							spawn()talkcool()
						if(length(t) <= 500&&say==1)
							say=0
							var/rrank=rank
							if((faction in list(leaf_faction,mist_faction,sand_faction)) && realname == faction.leader)
								rrank="Kage"
							for(var/mob/human/player/P in world)
								if(P.client && P.faction && (P.faction.village==faction.village || (P in online_admins)))
									if(P.ckey in admins)
										P<<"<span class='village_chat'><span class='[StyleClassFilter(faction.village)]'><span class='faction'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span> [faction]</span> (<span class='rank'>[rrank]</span>) <a href='?src=\ref[usr];action=mute' class='admin_link'><span class='name'>[realname]</span></a>: <span class='message'>[html_encode(t)]</span></span></span>"
									else
										P<<"<span class='village_chat'><span class='[StyleClassFilter(faction.village)]'><span class='faction'><span class='villageicon'>\icon[faction_chat[faction.chat_icon]]</span> [faction]</span> (<span class='rank'>[rrank]</span>) <span class='name'>[realname]</span>: <span class='message'>[html_encode(t)]</span></span></span>"
							ChatLog("village") << "[time2text(world.timeofday, "hh:mm:ss")]\t[faction.village]\t[realname]\t[html_encode(t)]"
							spawn() SendInterserverMessage("chat_mirror", list("mode" = "village", "ref" = "\ref[src]", "name" = realname, "rank" = rrank, "faction" = "[faction]", "msg" = html_encode(t)))
							sleep(2)
							say=1
						else
							world<<"[html_encode(realname)]/[key] is temporarily muted for spamming"
							tempmute=1
							sleep(200)
							tempmute=0
			Leave_Village()
				set category="Faction"
				if(usr.blevel<15)
					usr<<"You can't leave your village until you're at least level 15"
					return
				if(alert(usr,"Leaving a village is very serious, it's very difficult to get invited back into a village.  Don't do this if your new or dont fully understand the consequences.",,"No","Yes")=="Yes")
					if(alert(usr,"LEAVE YOUR VILLAGE?!",,"No","Yes")=="Yes")
						world<<"[usr] has abandoned [usr.faction.village] and become a missing nin."
						faction.RemoveMember(src)
						missing_faction.AddMember(src)
						if(rank != "Genin" && rank != "Academy Student")
							rank = "Chuunin"
	non_default
		verb
			Faction_Say(msg as text)
				set category="Faction"
				msg = Replace_All(msg,chat_filter)
				if(mute||tempmute)
					src<<"You're Muted"
				else if(name!="")
					talkcool=20
					talktimes+=1
					if(talktimes>=2 && rank=="Academy Student")
						src<<"Sorry new players cannot talk that fast, take a breather before each message."
						return

					if(talktimes>=8)
						src<<"You have been temporarily muted for talking too quickly."
						tempmute=1
						sleep(100)
						src<<"temp mute lifted"
						tempmute=0
						talktimes=0

					if(talkcooling==0)
						spawn()talkcool()

					if(length(msg) <= 500&&say==1)
						say=0
						var/faction_text = "[faction]"
						var/show_rank = 1
						if(faction.village == "Missing")
							faction_text = "<span class=villageicon>\icon[faction_chat[faction.chat_icon]]</span>"
							show_rank = 0
						var/list/sent_to = list()
						for(var/mob/M in (faction.online_members + online_admins))
							if(M in sent_to) continue
							sent_to += M
							if(M.ckey in admins)
								M << "<span class='faction_chat'><span class='[StyleClassFilter(faction.name)]'><span class='faction'>[faction_text]</span> [show_rank?"(<span class='rank'>[rank]</span>) ":""]<a href='?src=\ref[usr];action=mute' class='admin_link'><span class='name'>[realname]</span></a>: <span class='message'>[html_encode(msg)]</span></span></span>"
							else
								M << "<span class='faction_chat'><span class='[StyleClassFilter(faction.name)]'><span class='faction'>[faction_text]</span> [show_rank?"(<span class='rank'>[rank]</span>) ":""]<span class='name'>[realname]</span>: <span class='message'>[html_encode(msg)]</span></span></span>"
						ChatLog("faction") << "[time2text(world.timeofday, "hh:mm:ss")]\t[faction]\t[realname]\t[html_encode(msg)]"
						spawn() SendInterserverMessage("chat_mirror", list("mode" = "faction", "ref" = "\ref[src]", "name" = realname, "rank" = rank, "faction" = "[faction]", "msg" = html_encode(msg)))
						sleep(2)
						say=1
					else
						world<<"[html_encode(realname)]/[key] is temporarily muted for spamming"
						tempmute=1
						sleep(200)
						tempmute=0

			Leave_Faction()
				set category="Faction"
				if(faction && input2(src,"Are you sure you want to leave your faction?","Leave faction",list("Yes","No")) == "Yes")
					var/faction_village = faction.village
					switch(faction_village)
						if("Konoha")
							leaf_faction.AddMember(src)
						if("Kiri")
							mist_faction.AddMember(src)
						if("Suna")
							sand_faction.AddMember(src)
						else
							missing_faction.AddMember(src)
					Refresh_Faction_Verbs()
					src << "You have left your faction."
	leader
		default_non_missing
			verb
				Create_Faction_KAGE(faction_name as text, mob/leader as mob in world, member_limit as num)
					set desc = "(faction, leader, limit) Create a new faction"
					if(!leader.faction || leader.faction.village != faction.village)
						src << "The leader must be in your village."
					var/list/faction_info = saves.GetFactionInfo(faction_name)//params2list(SendInterserverMessage("faction_info", list("faction" = faction_name)))
					if(!faction_info["name"])
						var/faction/new_faction = new /faction(faction_name, faction.village, leader, faction.mouse_icon, faction.chat_icon, faction.chuunin_item, member_limit, 1)
						new_faction.tag = "faction__[new_faction.name]"
						new_faction.AddMember(leader)
						leader:Refresh_Faction_Verbs()
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tcreate_faction\t[src]\t[faction]\t[faction_name]\t[leader]\t[member_limit]"
					else
						usr << "There is already a faction using that name!"

				Change_Faction_Leader_KAGE(faction_name as text, mob/leader as mob in world)
					set desc = "(faction, leader name) Change the leader of a faction."
					if(!leader.faction || leader.faction.village != faction.village)
						src << "The leader must be in your village."
					var/faction/change_faction = load_faction(faction_name)
					if(!change_faction)
						src << "That faction (\"[faction_name]\") does not exist."
					else
						if(change_faction.village != faction.village)
							src << "You can only change factions in your own village!"
							return
						if(change_faction == faction)
							src << "You cannot change the leader of your own faction!"
							return
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tchange_faction_leader\t[src]\t[faction]\t[faction_name]\t[change_faction.leader]\t[leader]"
						change_faction.leader = "[leader]"
						change_faction.AddMember(leader)
						leader:Refresh_Faction_Verbs()
						saves.ChangeFactionLeader(change_faction.name, change_faction.leader)//SendInterserverMessage("faction_leader_change", list("faction" = change_faction.name, "new_leader" = change_faction.leader))

				Set_Info_Card_Comment(mob/M in world)
					var/comment = input("Edit Comment:", "Info Card [M]", GetComment(M, lowertext(faction.village))) as null|message
					if(comment)
						var/success = saves.SetInfoCardComment("[M]", lowertext(faction.village), comment)//params2list(SendInterserverMessage("char_info_set_comment", list("char" = "[M]", "village" = lowertext(faction.village), "comment" = comment)))
						if(success)
							src << "[faction.village] info comment for [M] changed."
							file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tchange_info_card_comment\t[src]\t[faction]\t[faction.village]\t[M]\t[comment]"
						else src << "[faction.village] info comment for [M] could not be changed."

				Start_Tourney()
					set category="Faction Leader"
					tourney=1
					world<<"<font color=Blue size= +1>[usr] has started a Tourney, you can watch by clicking on Watch_Fight in your commands tab!</font>"
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tstart_tournament\t[src]\t[faction]"
				End_Tourney()
					set category="Faction Leader"
					tourney=0
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tend_tournament\t[src]\t[faction]"
				Send_to_Arena()
					set category="Faction Leader"
					var/list/X = new
					for(var/mob/human/player/O in world)
						if(O.client && O.faction && O.faction.village==src.faction.village && O.RankGrade()>=1)
							X+=O
					var/mob/human/player/x=input(usr,"Put who in the arena?","Arena") as null|anything in X
					if(x && x.client)
						if(x.shopping)
							x.shopping=0
							x.canmove=1
							x.see_invisible=0
						x.oldx=x.x
						x.oldy=x.y
						x.oldz=x.z
						x.pk=0
						x.dojo=1
						x.inarena=1
						//x.stunned=30
						x.Timed_Stun(30)
						x<<"Wait for 1,2,3 Go."
						world<<"<font color=Blue size= +1>[x] Has entered the Arena!</font>"
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tsend_to_arena\t[src]\t[faction]\t[x]"
						x.loc=locate(69,72,3)
				Start_Fight()
					set category="Faction Leader"
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tstart_fight\t[src]\t[faction]"
					world<<"On Go"
					sleep(10)
					world<<"3"
					sleep(10)
					world<<"2"
					sleep(10)
					world<<"1"
					sleep(10)
					world<<"0, GO!"
					for(var/mob/human/player/x in world)
						if(x.inarena==1 && !x.cexam)
							x.pk=1
							x.dojo=0
							//x.stunned=0
							x.Reset_Stun()
							x.curwound=0

				Declare_Winner()
					set category="Faction Leader"
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tend_fight\t[src]\t[faction]"
					for(var/mob/human/player/x in world)
						if(x.inarena==1 &&x.z==3)
							world<<"<font color=Blue size= +1>[x] Has won!</font>"
							x.inarena=0
							x.curwound=0
							x.curstamina=x.stamina
							x.curchakra=x.chakra

							if(x.oldx &&x.oldy && x.oldz)
								x.loc=locate(x.oldx,x.oldy,x.oldz)
								x.oldx=0
								x.oldy=0
								x.oldz=0
				Change_Rank()
					set category="Faction Leader"
					var/list/X = new
					for(var/mob/human/player/O in world)
						if(O.client && O.faction && O.faction.village==src.faction.village && O.RankGrade()>=2)
							X+=O
					var/mob/human/player/P=input(usr,"Change Whos rank? (max of 3 Elite Jounin, These are people powerful enough and mature enough to be potential future kage candidates.)","Rank") as null|anything in X
					if(P)
						var/rank = input(usr,"Which Rank?")in list("Chuunin","Special Jounin","Jounin","Elite Jounin")
						if(P)
							P.rank=rank
							world<<"{[usr.faction.village]} [P]'s rank is now [P.rank]"
							file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tchange_rank\t[src]\t[faction]\t[P]\t[P.rank]"
				Host_Chuunin_Exam()
					set category = "Faction Leader"
					if(In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted)  <0)
						usr.Last_Hosted=0
					if(In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted) >48)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\thost_chuunin\t[src]\t[faction]"
						world<<"<span class='chuunin_exam'>[usr.realname] has decided to host a chuunin exam.</span>"
						MultiAnnounce("<span class='chuunin_exam'>[usr.realname] has decided to host a chuunin exam. (<a href='[world.url]'>Join server</a>)</span>", 0)
						sleep(130)
						if(chuuninactive) return
						usr.Last_Hosted=time2text(world.realtime,"DD:hh")
						world.Auto_Chuunin()
					else
						usr<<"You last hosted a chuunin on [usr.Last_Hosted] (Day:Hour), thats [In_Hours(time2text(world.realtime,"DD:hh"))-In_Hours(usr.Last_Hosted)] /48 Hours ago."
				Invite_to_Village()
					set category="Faction Leader"
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village=="Missing") li+=X
					var/list/l2=li.Copy()
					li=Remove_Clans(usr.faction.village,l2)

					if(length(li)<1)
						usr<<"No candidates! Player must be Missing and not be in a Clan"
						return

					var/mob/human/M=input(usr,"Who do you wish to Invite","Invite") as null|anything in li
					if(M)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tvillage_invite\t[src]\t[faction]\t[M]"
						var/cert=alert(M,"Are you sure?!","Invite", "Yes", "No")
						if(cert=="No")return

						var/accept=input(M,"You have been invited to join [usr.faction.village]<br>This will remove you from any factions you are currently a member of.","Accept?", "Yes", "No")
						if(accept=="Yes")
							world<<"[M] has joined [faction.village]"
							M.faction.RemoveMember(M)
							faction.AddMember(M)
				Kick_from_Village()
					set category="Faction Leader"
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village && X!=src) li+=X
					var/mob/human/M=input(usr,"Who do you wish to kick from the village","Kick") as null|anything in li
					if(!M)
						return
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tvillage_kick\t[src]\t[faction]\t[M]"
					world<<"[M] has been exiled from [M.faction.village]!"
					M.faction.RemoveMember(M)
					missing_faction.AddMember(M)
				Add_Helper()
					set category = "Faction Leader"
					if(length(helpers[usr.faction.name]) >= 10)
						alert(usr, "Your village has reached its helper cap")
						return
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village) li+=X
					var/mob/human/M=input(usr,"Who do you wish to make a helper?","Add Helper") as null|anything in li
					if(M)
						if(length(helpers[usr.faction.name]) >= 10)
							alert(usr, "Your village has reached its helper cap")
							return
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tadd_helper\t[src]\t[faction]\t[M]"
						saves.AddHelper(M.name, usr.faction.name)//SendInterserverMessage("add_helper", list("name" = M.name, "village" = usr.faction.name))
				Remove_Helper()
					set category = "Faction Leader"
					var/name=input(usr,"Who do you wish to remove helper status from?","Remove Helper") as null|anything in helpers[usr.faction.name]
					if(name)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tremove_helper\t[src]\t[faction]\t[name]"
						saves.RemoveHelper(name, usr.faction.name)//SendInterserverMessage("remove_helper", list("name" = name, "village" = usr.faction.name))
				Mute_KAGE()
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village && !X.mute) li+=X
					var/mob/human/M=input(usr,"Who do you wish to mute?","Mute") as null|anything in li
					if(M)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tmute\t[src]\t[faction]\t[M]"
						M.mute=1
						world<<"[M] is muted"
						var/c_id = M.client.computer_id
						mutelist+=c_id
						src = null
						spawn(18000)
							mutelist-=c_id
							if(M && M.mute)
								M.mute=0
								world<<"[M.realname] is unmuted"
				Unmute_KAGE()
					var/list/li = new
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village && X.mute==1) li+=X
					var/mob/human/M=input(usr,"Who do you wish to unmute?","Unmute") as null|anything in li
					if(M)
						file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tunmute\t[src]\t[faction]\t[M]"
						M.mute=0
						mutelist-=M.client.computer_id
						world<<"[M] is unmuted"
				Unmute_All_KAGE()
					file("logs/kage_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tunmute_all\t[src]\t[faction]"
					for(var/mob/human/X in world)
						if(X.client && X.faction && X.faction.village==usr.faction.village && X.mute==1)
							X.mute=0
							mutelist-=X.client.computer_id
							world<<"[X] is unmuted"
		non_default
			verb
				Invite_to_Faction(mob/M in oview())
					set category="Faction Leader"
					if(faction && (!M.faction || M.faction.village == faction.village))
						if(faction.member_limit)
							var/faction_members = saves.GetFactionMemberCount(faction.name)//SendInterserverMessage("faction_member_count", list("faction" = faction.name))
							if(faction_members < faction.member_limit)
								usr << "Your faction is full!"
								return

						file("logs/faction_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tfaction_invite\t[src]\t[faction]\t[M]"
						if(input2(M,"Would you like to join [src]'s faction \"[faction]\"?","Faction Invite",list("Yes","No")) == "Yes")
							if(faction.member_limit)
								var/faction_members = saves.GetFactionMemberCount(faction.name)//SendInterserverMessage("faction_member_count", list("faction" = faction.name))
								if(faction_members < faction.member_limit)
									usr << "Your faction is full!"
									return
							M.faction.RemoveMember(M)
							faction.AddMember(M)

				Kick_from_Faction(mob/M in (faction.online_members-src))
					set category="Faction Leader"
					if(input2(src,"Are you sure you would like to kick [M] from your faction?","Faction Kick",list("Yes","No")) == "Yes")
						file("logs/faction_[time2text(world.realtime, "YYYY-MM-DD")].log") << "[time2text(world.timeofday, "hh:mm:ss")]\tfaction_kick\t[src]\t[faction]\t[M]"
						faction.RemoveMember(M)
						switch(faction.village)
							if("Konoha")
								M.faction = leaf_faction
							if("Kiri")
								M.faction = mist_faction
							if("Suna")
								M.faction = sand_faction
							else
								M.faction = missing_faction
						M.faction.AddMember(M)