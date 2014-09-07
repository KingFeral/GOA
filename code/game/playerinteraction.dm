mob
	var/tmp/whispertoggleoff
mob/human/player
	verb
		Whisper_Ref(var/mob_ref as text, var/msg as text)
			set hidden = 1
			var/mob/M = locate(mob_ref)
			if(M) Whisper(M, msg)
		Whisper_Toggle()
			set hidden = 1
			if(usr.whispertoggleoff)
				usr << "You are now able to send and receive whispers."
				usr.whispertoggleoff = 0
			else
				usr << "You are no longer able to send and receive whispers."
				usr.whispertoggleoff = 1
		Whisper(var/mob/human/player/x in world, var/msg as text)
			if(!x.client) return
			if(usr.whispertoggleoff)
				usr << "You are currently not able to send whispers"
				return
			if(x.whispertoggleoff)
				usr << "[x.realname] is currently not able to receive whispers"
				return
			var/has_whisper_window = (winexists(x, "whisper__[x.realname]") == "MAIN")
			if(usr.mute||usr.tempmute)
				if(has_whisper_window)
					winshow(usr, "whisper__[x.realname]")
					usr << output("You're muted!", "whisper__[x.realname].whisper_chat_output")
				else
					usr << "You're muted"

			else
				msg = Replace_All(msg, whitespace_only_chat_filter)
				if(usr.name)
					usr.talkcool=20
					usr.talktimes+=1
					if(usr.talktimes>=8)
						usr << "You have been temporarily muted for talking too quickly."
						usr.tempmute=1
						sleep(100)
						usr << "temp mute lifted"
						usr.tempmute=0
						usr.talktimes=0
						return
					if(usr.talkcooling==0)
						spawn()usr.talkcool()
					if(length(msg) <= 500&&usr.say==1)
						usr.say=0
						if(!has_whisper_window)
							winclone(usr, "whisper_popup", "whisper__[x.realname]")
							winset(usr, "whisper__[x.realname].whisper_chat_input", "command=\"Whisper-Ref \\\"\ref[x]\\\" \\\"\"")
							winset(usr, "whisper__[x.realname]", "title=\"[x.realname]\"")
						winshow(usr, "whisper__[x.realname]")
						if(!x.client)
							usr.say = 1
							return
						if(winexists(x, "whisper__[usr.realname]") != "MAIN")
							winclone(x, "whisper_popup", "whisper__[usr.realname]")
							winset(x, "whisper__[usr.realname].whisper_chat_input", "command=\"Whisper-Ref \\\"\ref[usr]\\\" \\\"\"")
							winset(x, "whisper__[usr.realname]", "title=\"[usr.realname]\"")
						spawn()
							if(x && x.client && winget(x, "whisper__[usr.realname]", "is-visible") != "true")
								if(x.ckey in admins)
									x << "You have recieved a whisper message from <a href='?src=\ref[usr];action=admin' class='admin_link'>[usr.realname]</a>. <a href='?[list2params(list("src"="\ref[x]", "action"="view_whisper", "name"="[usr.realname]"))]'>\[View]</a>"
								else
									x << "You have recieved a whisper message from [usr.realname]. <a href='?[list2params(list("src"="\ref[x]", "action"="view_whisper", "name"="[usr.realname]"))]'>\[View]</a>"
						usr << output("[usr]: <font color=#52ad4d>[html_encode(msg)]", "whisper__[x.realname].whisper_chat_output")
						if(x.ckey in admins)
							x << output("<a href='?src=\ref[usr];action=admin' class='admin_link'>[usr]</a>: <font color=#52ad4d>[html_encode(msg)]", "whisper__[usr.realname].whisper_chat_output")
						else
							x << output("[usr]: <font color=#52ad4d>[html_encode(msg)]", "whisper__[usr.realname].whisper_chat_output")
						sleep(2)
						usr.say=1
					else
						world<<"[html_encode(usr.name)]/[usr.key] is temporarily muted for spamming"
						usr.tempmute=1
						sleep(200)
						usr.tempmute=0

	Topic(href, href_list)
		switch(href_list["action"])
			if("view_whisper")
				winshow(src, "whisper__[href_list["name"]]")
			else
				return ..()

mob
	human/player
		verb
			Check_Map()
				src.Look_Map()
				src.hidestat=1

mob
	proc
		Look_Map()
			Get_Global_Coords()
			if(!EN[11] || spectate || !client)
				return
			src.hidestat=1
			src.spectate=1
			src.client.eye=locate(92,9,2)
			src<<"<font size=+1>Viewing Map, Hit the Interact Button or Space to return. (Only your vision has changed, your character is still in the same spot.)</font>"
			spawn()
				var
					byakugan_pins[0]
					target_pins[0]
					squad_pins[0]
					alert_cache[0]
				while(client && src.spectate)
					for(var/image/x in byakugan_pins)
						client.images -= x
					for(var/image/x in target_pins)
						client.images -= x
					for(var/image/x in squad_pins)
						client.images -= x
					for(var/zlevel in 1 to world.maxz)
						var/obj/mapinfo/Minfo = locate("__mapinfo__[zlevel]")
						if(Minfo && faction && !Minfo.in_war && (Minfo.village_control == faction.village || online_admins.Find(src)))
							var/image/alert = Minfo.alert_imgs[Minfo.alert_level+1]
							if(alert && (!alert_cache[Minfo] || alert_cache[Minfo] != alert))
								client.images -= alert_cache[Minfo]
								alert_cache[Minfo] = alert
								src << alert
					if(byakugan)
						var/list/US =src.Global_Coords()
						if(US)
							var/gx=US[1]
							var/gy=US[2]
							for(var/client/C)
								var/mob/X = C.mob
								if(X && X.pk && X!=src)
									var/list/L=X.Global_Coords()
									if(L)
										var/mx=L[1]
										var/my=L[2]
										var/di=300
										if(abs(mx-gx)<di && abs(my-gy)<di && X.map_pin)
											src << X.map_pin
											byakugan_pins += X.map_pin
					if(src.skillspassive[TRACKING])
						FilterTargets()
						for(var/mob/M in src.targets)
							M.Get_Global_Coords()
							if(M.map_pin_target)
								src << M.map_pin_target
								target_pins += M.map_pin_target
					if(src.MissionTarget && src.Hastargetpos)
						MissionTarget.Get_Global_Coords()
						if(MissionTarget.map_pin_target)
							src << MissionTarget.map_pin_target
							target_pins += MissionTarget.map_pin_target
					if(squad)
						for(var/mob/X in squad.online_members)
							if(!X)
								squad.online_members -= X
								continue
							X.Get_Global_Coords()
							if(X.map_pin_squad)
								src << X.map_pin_squad
								squad_pins += X.map_pin_squad
					sleep(10)
				if(client)
					for(var/image/x in byakugan_pins)
						client.images -= x
					for(var/image/x in target_pins)
						client.images -= x
					for(var/image/x in squad_pins)
						client.images -= x
					for(var/map in alert_cache)
						client.images -= alert_cache[map]

mob
	var
		MissionPins[]
		image
			map_pin
			map_pin_target
			map_pin_self
			map_pin_squad

	Get_Global_Coords()
		. = ..()
		var/obj/mapinfo/Minfo =  locate("__mapinfo__[z]")
		if(Minfo)
			var/tile_x = MAP_START_X+Minfo.oX-1
			var/tile_y = MAP_START_Y-Minfo.oY
			var/pixel_x = round(x*(32/100))-15
			var/pixel_y = round(y*(32/100))-16

			if(!map_pin)
				map_pin = new/image('icons/pins.dmi',icon_state="white",loc=locate(tile_x,tile_y,2),pixel_x=pixel_x,pixel_y=pixel_y)
				if(client) online_admins << map_pin
			else
				map_pin.loc = locate(tile_x,tile_y,2)
				map_pin.pixel_x=pixel_x
				map_pin.pixel_y=pixel_y

			if(!map_pin_target)
				map_pin_target = new/image('icons/pins.dmi',icon_state="red",loc=locate(tile_x,tile_y,2),pixel_x=pixel_x,pixel_y=pixel_y)
			else
				map_pin_target.loc = locate(tile_x,tile_y,2)
				map_pin_target.pixel_x=pixel_x
				map_pin_target.pixel_y=pixel_y

			if(!map_pin_self)
				map_pin_self = new/image('icons/pins.dmi',icon_state="blue",loc=locate(tile_x,tile_y,2),pixel_x=pixel_x,pixel_y=pixel_y)
				if(client) src << map_pin_self
			else
				map_pin_self.loc = locate(tile_x,tile_y,2)
				map_pin_self.pixel_x=pixel_x
				map_pin_self.pixel_y=pixel_y

			if(!map_pin_squad)
				map_pin_squad = new/image('icons/pins.dmi',icon_state="squad",loc=locate(tile_x,tile_y,2),pixel_x=pixel_x,pixel_y=pixel_y)
			else
				map_pin_squad.loc = locate(tile_x,tile_y,2)
				map_pin_squad.pixel_x=pixel_x
				map_pin_squad.pixel_y=pixel_y

		else
			if(map_pin) map_pin.loc = null
			if(map_pin_target) map_pin_target.loc = null
			if(map_pin_self) map_pin_self.loc = null
			if(map_pin_squad) map_pin_squad.loc = null
