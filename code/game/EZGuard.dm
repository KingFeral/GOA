mob
	var
		Dojotime=0
		Ztime=0
		Social=0
		Skilltime=0
		Staminatime=0
		ezing=0
		lastskill=0
		watercount=0

mob
	var/tmp/ez_count = 0

var/global/obj/ez_flag/ez_flag = new

obj/ez_flag
	icon = 'icons/ez_flag.dmi'
	screen_loc = "1, 2"
	layer = 60
	mouse_opacity = 2

	proc/remove(var/mob/user)
		set waitfor = 0
		if(user.client && user.client.inputopen) return 0
		user.client.inputopen = TRUE
		while(1)
			var/n = rand(10, 100000)
			var/code = copytext(md5("[n]"), 1, 5)
			var/i = input(user, "Enter this text: [code]") as text
			if(!user || !user.client)
				return 0
			else if(i != code)
				continue
			else
				break
			sleep(10)
		if(user)
			if(user.client)
				user.client.screen -= src
				user.client.inputopen = FALSE
			user.ezing = 0
			user.ez_count = 0
			user << "You removed your EZ flag."
			user.EZ_Loop()

	Click()
		remove(usr)

client
	var/tmp/inputopen = FALSE

client/Topic(var/href, var/list/hreflist)
	if(hreflist && hreflist["action"])
		if(hreflist["action"] == "remove-ez-flag")
			global.ez_flag.remove(src.mob)
	..()

mob/proc
	set_ez_flag()
		client.screen += global.ez_flag
		ezing = 1

	EZ_Loop()
		set background = 1
		set waitfor = 0

		var/last_body = body
		var/list/list_of_mobs = list()

		while(client)
			if(curstamina >= stamina && curchakra >= chakra || blevel < 20)
				sleep(100)
				continue

			if(body != last_body)
				last_body = body

				for(var/mob/human/m in ohearers(2, src))
					if(m.client && !same_client(m, src))
						if(!(m.realname in list_of_mobs) || list_of_mobs[m.realname] <= world.time)
							ez_count = 0
						list_of_mobs[m.realname] = world.time + 4200

				ez_count++
				if(ez_count >= 5)
					client << "You have been flagged for repetitive training! Click the flag icon at the bottom-left of your screen to begin gaining experience again."
					set_ez_flag()
					break
			sleep(600)

var
	EZOFF=0
mob/Admin/verb
	EZ_Checker_Toggle()
		if(EZOFF)
			EZOFF=0
			for(var/mob/human/player/X in world)
				if(X.client)
					spawn()X.EZ_Loop()
		else
			EZOFF=1
		usr<<"EZOFF=[EZOFF]"