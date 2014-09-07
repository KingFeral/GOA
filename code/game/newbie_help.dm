var/list/newbies = list()
var/list/helpers = list()

mob/human/Topic(href,href_list[])
	if(!src)return
	switch(href_list["action"])
		if("admin")
			var/list/options = list("Mute", "Unmute", "Teleport", "Summon", "Give Money", "Give Level")
			var/command = input(usr, "What do you want to do referencing [src]?") in options
			if(command)
				switch(command)
					if("Mute")
						usr << "[src] is muted"
						mute=2
						var/c_id = client.computer_id
						mutelist+=c_id
						var/mob/M = src
						src = null
						spawn(18000)
							mutelist-=c_id
							if(M && M.mute)
								M.mute=0
					if("Unmute")
						if(client)
							mutelist -= client.computer_id
						if(src)
							mute = 0
					if("Teleport") usr.loc = loc
					if("Summon") loc = usr.loc
					if("Give Money")
						var/am = input(usr, "How much?") as num
						money += am
					if("Spectate")
						usr.spectate = TRUE
						usr.client.eye = src
					//if("Give Level")
					//	var/l = input(usr, "What level?") as num
					//	give_level(l, src)

		if("mute")
			mute=2
			//world<<"[realname] is muted"
			var/c_id = client.computer_id
			mutelist+=c_id
			var/mob/M = src
			src = null
			spawn(18000)
				mutelist-=c_id
				if(M && M.mute)
					M.mute=0
					//world<<"[M.realname] is unmuted"
		else
			. = ..()

mob/human/player
	newbie
		verb
			NOOC(var/t as text)
				winset(usr, "map", "focus=true")

				t = Replace_All(t,chat_filter)
				if(usr.mute||usr.tempmute)
					usr<<"You're muted"
				else
					if(usr.name!="" && usr.name!="player" && usr.initialized)
						usr.talkcool=20
						usr.talktimes+=1
						if(usr.talktimes>=8)
							usr<<"You have been temporarily muted for talking too quickly."
							usr.tempmute=1
							sleep(100)
							usr<<"temp mute lifted"
							usr.tempmute=0
							usr.talktimes=0
						if(usr.talkcooling==0)
							spawn()usr.talkcool()
						if(length(t) <= 500&&usr.say==1)
							usr.say=0
							var/rrank=usr.rank
							if((usr.faction in list(leaf_faction,mist_faction,sand_faction)) && usr.realname == usr.faction.leader)
								rrank="Kage"
							else
								var/all_helpers = list()
								for(var/village in helpers)
									all_helpers += helpers[village]
								if(usr.name in all_helpers)
									rrank = "Helper"
							for(var/mob/M in newbies)
								if(M.ckey in admins)
									M<<"<span class='help'><span class='villageicon'>\icon[faction_chat[usr.faction.chat_icon]]</span>(<a href='?src=\ref[usr];action=admin' class='admin_link'><span class='name'>[usr.realname]</span></a>){<span class='rank'>[rrank]</span>} <span class='message'>[html_encode(t)]</span></span>"
								else
									M<<"<span class='help'><span class='villageicon'>\icon[faction_chat[usr.faction.chat_icon]]</span>(<span class='name'>[usr.realname]</span>){<span class='rank'>[rrank]</span>} <span class='message'>[html_encode(t)]</span></span>"
							ChatLog("newbie") << "[time2text(world.timeofday, "hh:mm:ss")]\t[usr.realname]\t[html_encode(t)]"
							spawn() SendInterserverMessage("chat_mirror", list("mode" = "newbie_help", "ref" = "\ref[usr]", "name" = usr.realname, "rank" = rrank, "faction" = "[usr.faction]", "msg" = html_encode(t)))
							sleep(2)
							usr.say=1
						else
							world<<"[html_encode(usr.realname)]/[usr.key] is temporarily muted for spamming"
							usr.tempmute=1
							sleep(200)
							usr.tempmute=0