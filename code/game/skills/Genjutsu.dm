mob
	var/tmp/genjutsu[]

	proc/go_to_sleep(mob/user)
		set waitfor = 0

		if(src.client)
			src.client.screen += global.sleep_genjutsu

		var/image/illusion
		var/effect_counter = 0

		for(var/i in 1 to 3)
			if(user.icon_state != "Seal")
				break

			/*var/resist = (src.isguard && src.con >= 150) ? (src.con + src.conbuff - src.conneg) : (src.int + src.intbuff - src.intneg) + 10 * src.skillspassive[GENJUTSU_MASTERY]
			var/effect = (user.int + user.intbuff - user.intneg) + 10 * user.skillspassive[GENJUTSU_MASTERY]*/

			var
				effect_roll
				resist_roll

			if(isguard)
				effect_roll = (user.con)
				resist_roll = (con)
			else
				effect_roll = (user.int + user.intbuff - user.intneg) + 10 * user.skillspassive[GENJUTSU_MASTERY]
				resist_roll = (src.int + src.intbuff - src.intneg) + 10 * src.skillspassive[GENJUTSU_MASTERY]

			var/roll = Roll_Against(effect_roll, resist_roll, 100)
			if(roll >= 3)
				if(src.client)
					src.client.screen -= global.sleep_genjutsu
				switch(++effect_counter)
					if(1)
						src.Timed_Move_Stun(50, 1)
						illusion = new('icons/genjutsu2.dmi', loc = src)
						src.genjutsu = list("name" = "sleep", "user" = user, "image" = illusion)
						src << illusion
						user << illusion
					if(2)
						src.Timed_Move_Stun(100, 2)
						src.combat("Sleep is setting in.")
					if(3)
						src.Timed_Stun(200)
						src.combat("You fall asleep.")
						src.asleep = TRUE
						flick("Knockout", src)
						src.icon_state = "Dead"
						var/turf/target_loc = src.loc
						while(src && src.stunned && src.asleep && src.loc == target_loc)
							sleep(3)
						if(src && src.asleep)
							src.asleep = FALSE
							src.End_Stun()
							src.icon_state = ""
			sleep(10)

		if(illusion)
			if(user.client)
				user.client.screen -= illusion
			illusion.loc = null
			if(src.client)
				src.client.screen -= illusion
		user.genjutsu = null
		if(src.client)
			src.client.screen -= global.sleep_genjutsu

	proc/set_icon_state(var/state, var/time = 0)
		set waitfor = 0
		icon_state = state
		if(time)
			sleep(time)
			if(icon_state == state)
				icon_state = ""

var/global/obj/sleep_genjutsu/sleep_genjutsu = new

obj/sleep_genjutsu
	icon = 'icons/genjutsu2.dmi'
	screen_loc = "SOUTHWEST to NORTHEAST"
	layer = 4
	alpha = 160

skill
	genjutsu
		temple_of_nirvana
			id = SLEEP_GENJUTSU
			name = "Genjutsu: Temple of Nirvana"
			icon_state = "sleep_genjutsu"
			default_chakra_cost = 250
			default_cooldown = 120

			var
				active = FALSE

			ChakraCost(mob/user)
				if(active)
					return 0
				else
					return ..(user)

			Cooldown(mob/user)
				if(active)
					return 0
				else
					return ..(user)

			Use(mob/user)
				set waitfor = 0

				if(active)
					if(user.icon_state == "Seal")
						user.icon_state = ""
					active = FALSE
					RemoveOverlay('icons/activation.dmi')
					DoCooldown(user)
					return

				active = TRUE
				AddOverlay('icons/activation.dmi')
				user.Timed_Stun(30)
				user.set_icon_state("Seal", time = 30)

				var/list/targets = user.NearestTargets(8, num = 10)

				for(var/mob/human/m in targets)
					m.go_to_sleep(user)

				var/time = 30
				while(time > 0 && user && active)
					time--
					sleep(1)

				if(user && active)
					Use(user)


		fear
			id = PARALYZE_GENJUTSU
			name = "Genjutsu: Fear"
			icon_state = "paralyse_genjutsu"
			default_chakra_cost = 100
			default_cooldown = 60



			Use(mob/user)
				set waitfor = 0
				flick("Seal", user)
				user.Timed_Stun(10)

				var/list/targeting_me = user.targeted_by
				for(var/mob/human/t in targeting_me)
					if(t in oview(user))
						t.fear_genjutsu(user)
						/*
						var/enemy_stat = (t.isguard && t.con >= 150) ? (t.con + t.conbuff - t.conneg) : (t.int + t.intbuff - t.intneg)
						var/roll = Roll_Against((user.int - user.intneg + user.intbuff) + 10 * user.skillspassive[19], (enemy_stat), 100)
						var/image/genjutsu = new(icon = 'icons/genjutsu.dmi', loc = t)

					//	if(user.client)
						user << genjutsu
					//	if(t.client)
						t << genjutsu
						t.genjutsu = list("name" = "fear", "user" = user, "image" = genjutsu, "timestamp" = world.time, "effectiveness" = (user.con + user.conbuff - user.conneg))

						var/recorded_timestamp = t.genjutsu["timestamp"]

						if(roll >= 5)
							t.Timed_Stun(50)

						else if(roll >= 3)
							t.Timed_Move_Stun(50, 2)

						while(t && (t.genjutsu && t.genjutsu["timestamp"] == recorded_timestamp) && (t.stunned || t.move_stun))
							sleep(2)
						if(user)
							if(user.client)
								user.client.images -= genjutsu
						if(t)
							if(t.client)
								t.client.images -= genjutsu

						genjutsu.loc = null*/



		darkness
			id = DARKNESS_GENJUTSU
			name = "Genjutsu: Darkness"
			icon_state = "paralyse_genjutsu"
			default_chakra_cost = 800
			default_cooldown = 200



			Use(mob/user)
				user.set_icon_state("Seal", 20)
				var/mob/human/etarget = user.MainTarget()
				if(etarget)
					var/result=Roll_Against((user.int+user.intbuff-user.intneg)+ (10 *user.skillspassive[GENJUTSU_MASTERY]),(etarget.int+etarget.intbuff-etarget.intneg)+ (10 *etarget.skillspassive[GENJUTSU_MASTERY]),80)
					if(etarget.con>=150 &&etarget.isguard)
						var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)+ (10 *user.skillspassive[GENJUTSU_MASTERY]),(etarget.con+etarget.conbuff-etarget.conneg),100)
						if(resist_roll < 4)
							result = 1
					var/image/I = image('icons/shroud.dmi',etarget)
					user<<I
					etarget.genjutsu = list("name" = "darkness", "user" = user, "image" = I, "timestamp" = world.time, "effectiveness" = (user.con + user.conbuff - user.conneg))
					var/recorded_timestamp = etarget.genjutsu["timestamp"]

					var/d=0
					if(result>=5)
						d = 15
					if(result==4)
						d = 10
					if(result==3)
						d = 5
					if(d > 0)
						etarget.gen_effective_int = user.int+user.intbuff-user.intneg + (10 *user.skillspassive[GENJUTSU_MASTERY])
						etarget.sight = (BLIND|SEE_SELF|SEE_OBJS)
						while(user && etarget && etarget.genjutsu && etarget.genjutsu["timestamp"] == recorded_timestamp && etarget.genjutsu["user"] == user && d>0)
							d--
							sleep(10)
						if(user)
							if(user.client) user.client.images -= I
						if(etarget)// && etarget.genjutsu && etarget.genjutsu["timestamp"] == recorded_timestamp)
							etarget.sight = 0
							if(etarget.genjutsu && etarget.genjutsu["timestamp"] == recorded_timestamp)
								etarget.gen_effective_int = 0
								etarget.genjutsu = null
							if(etarget.client) etarget.client.images -= I
						I.loc = null


mob/proc/fear_genjutsu(mob/user)
	set waitfor = 0
	var
		effect_roll
		resist_roll

	if(isguard)
		effect_roll = (user.con)
		resist_roll = (con)
	else
		effect_roll = (user.int + user.intbuff - user.intneg) + 10 * user.skillspassive[GENJUTSU_MASTERY]
		resist_roll = (src.int + src.intbuff - src.intneg) + 10 * src.skillspassive[GENJUTSU_MASTERY]

	var/image/genjutsu = new(icon = 'icons/genjutsu.dmi', loc = src)
	user << genjutsu
	src << genjutsu
	src.genjutsu = list("name" = "fear", "user" = user, "image" = genjutsu, "timestamp" = world.time, "effectiveness" = (user.con + user.conbuff - user.conneg))

	var/recorded_timestamp = src.genjutsu["timestamp"]
	var/roll = Roll_Against(effect_roll,resist_roll,100)

	if(roll >= 5)
		src.Timed_Stun(50)

	else if(roll >= 3)
		src.Timed_Move_Stun(50, 2)

	while(src && (src.genjutsu && src.genjutsu["timestamp"] == recorded_timestamp) && (src.stunned || src.move_stun))
		sleep(2)
	if(user)
		if(user.client)
			user.client.images -= genjutsu
	if(src)
		if(src.client)
			src.client.images -= genjutsu

	genjutsu.loc = null