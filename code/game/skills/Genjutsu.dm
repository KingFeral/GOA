mob
	proc/cast_sleep(var/mob/target)
		set waitfor = 0

		if(target.client)
			target.client.screen += global.sleep_genjutsu

		var/image/illusion
		var/effect_counter = 0

		for(var/i in 1 to 3)
			sleep(10)

			if(src.icon_state != "Seal")
				break

			var/resist = (target.isguard && target.con >= 150) ? (target.con + target.conbuff - target.conneg) : (target.int + target.intbuff - target.intneg) + 10 * target.skillspassive[GENJUTSU_MASTERY]
			var/effect = (src.int + src.intbuff - src.intneg) + 10 * src.skillspassive[GENJUTSU_MASTERY]
			var/roll = Roll_Against(effect, resist, 100)
			if(roll >= 3)
				switch(++effect_counter)
					if(1)
						target.Timed_Move_Stun(50, 1)
						illusion = new('icons/genjutsu2.dmi', loc = target)
						target << illusion
						src << illusion
					if(2)
						target.Timed_Move_Stun(100, 2)
						target.combat("Sleep is setting in.")
					if(3)
						target.Timed_Stun(200)
						target.combat("You fall asleep.")
						target.asleep = TRUE
						flick("Knockout", target)
						target.icon_state = "Dead"
						var/turf/target_loc = target.loc
						while(target && target.stunned && target.loc == target_loc)
							sleep(3)
						if(target && target.asleep)
							target.asleep = FALSE
							target.End_Stun()
							target.icon_state = ""

		if(illusion)
			if(client)
				client.screen -= illusion
			illusion.loc = null
			if(target.client)
				target.client.screen -= illusion
		if(target.client)
			target.client.screen -= global.sleep_genjutsu

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

				var/list/targets = user.NearestTargets(8)

				for(var/mob/human/m in targets)
					user.cast_sleep(m)

				var/time = 30
				while(time > 0 && user && active)
					time--
					sleep(1)

				if(user && active)
					Use(user)

			/*
				user.set_icon_state("Seal", time = 30)
				user.Timed_Stun(30)

				var/turf/user_location = user.loc
				var/iterations = 3
				var/list/affected = list()
				var/list/points = list()

				while(user.loc == user_location && user.icon_state == "Seal" && iterations > 0)
					var/list/targets_in_range = user.NearestTargets(8)

					for(var/mob/human/m in targets_in_range)
						if(m.client && !(global.sleep_genjutsu in m.client.screen))
							m.client.screen += global.sleep_genjutsu

						var/enemy_stat = (m.isguard && m.con >= 150) ? (m.con + m.conbuff - m.conneg) : (m.int + m.intbuff - m.intneg)
						var/roll = Roll_Against((user.int - user.intneg + user.intbuff) + 10 * user.skillspassive[19], (enemy_stat), 100)
						affected += m
						points[m.realname] += roll

					iterations--
					sleep(10)

				for(var/mob/human/m in affected)
					if(m.client)
						m.client.screen -= global.sleep_genjutsu

					var/score = points[m.realname]
					if(score >= 9) // sleep.
						m.combat("Your body collapses and you fall asleep!")
						m.Timed_Stun(200)
						m.asleep = TRUE
						flick("Knockout", m)
						m.icon_state = "Dead"
						var/turf/m_loc = m.loc
						spawn()
							while(m && m.stunned && m.asleep && m.loc == m_loc)
								sleep(3)
							if(m && m.asleep)
								m.asleep = FALSE
								m.End_Stun()
								if(m.icon_state == "Dead" && !m.ko)
									m.icon_state = ""

					else if(score >= 6) // drowsy.
						m.combat("You feel tired.")
						m.Timed_Move_Stun(100, severity = 2)

				affected = null
				points = null
*/


	/*			user.icon_state = "Seal"
				user.stunned = 5

				spawn(50)
					user.icon_state = ""

				var/mob/human/target = user.MainTarget()
				var/turf/center = user.loc

				if(target)
					center = target.loc

				if(center)
					var/r = limit(1, round((user.int+user.intbuff-user.intneg)/75) + 1, 5)
					var/images[0]
					var/area[0]

					for(var/turf/T in range(center, r))
						images += image('icons/genjutsu2.dmi', T)
						area += T

					for(var/image/I in images)
						world << I

					var/resisted[0]
					var/failed_resist[0]

					var/time = 20
					while(time > 0)
						sleep(1)
						for(var/mob/human/M in range(center, r))
							if(M.isguard && M.skillspassive[21] && !(M in failed_resist))
								var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(M.con+M.conbuff-M.conneg)*(1 + 0.05*(M.skillspassive[21]-1)),100)
								if(resist_roll < 4)
									resisted += M
								else
									failed_resist += M
						--time

					for(var/mob/human/M in range(center, r))
						if(M != user && !(M in resisted))
							M.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							flick("Knockout", M)
							M.icon_state = "Dead"
							M.asleep = 1
							M.stunned = 20
							spawn()
								while(M && M.stunned>0 && M.asleep)
									sleep(1)
								if(M)
									M.icon_state=""
									M.asleep=0


					for(var/image/I in images)
						del I*/




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
				for(var/mob/human/t in targeting_me) spawn
					if(t in oview(user))
						var/enemy_stat = (t.isguard && t.con >= 150) ? (t.con + t.conbuff - t.conneg) : (t.int + t.intbuff - t.intneg)
						var/roll = Roll_Against((user.int - user.intneg + user.intbuff) + 10 * user.skillspassive[19], (enemy_stat), 100)
						var/image/genjutsu = new(icon = 'icons/genjutsu.dmi', loc = t)
						if(user.client) user << genjutsu
						if(t.client) t << genjutsu
						if(roll >= 5)
							t.Timed_Stun(50)
							while(t && t.stunned)
								sleep(3)
							if(user.client) user.client.images -= genjutsu
							if(t.client) t.client.images -= genjutsu
							genjutsu.loc = null
						else if(roll >= 3)
							t.Timed_Move_Stun(50, 2)
							sleep(50)
							if(user.client) user.client.images -= genjutsu
							if(t.client) t.client.images -= genjutsu
							genjutsu.loc = null
						else
							if(user.client) user.client.images -= genjutsu
							if(t.client) t.client.images -= genjutsu
							genjutsu.loc = null



		/*		user.icon_state = "Seal"
				user.stunned = 2
				sleep(20)
				user.icon_state = ""

				user.FilterTargets()
				for(var/mob/human/T in user.targeted_by)
					if(T in oview(user))
						var/image/o = image('icons/genjutsu.dmi' ,T)
						T << o
						user << o
						var/result=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(T.int+T.intbuff-T.intneg)*(1 + 0.05*T.skillspassive[19]),100)
						T.FilterTargets()
						if(!(user in T.active_targets))
							--result
						if(T.skillspassive[21] && T.isguard)
							var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(T.con+T.conbuff-T.conneg)*(1 + 0.05*(T.skillspassive[21]-1)),100)
							if(resist_roll < 4)
								result = 1
						if(result >= 6)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 100
						if(result == 5)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 80
						if(result == 4)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 50
						if(result == 3)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 30
						if(result == 2)
							T.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
							T.move_stun = 10
						spawn()
							while(T && T.move_stun > 0 && T.icon_state != "ko")
								sleep(1)
							del(o)*/




		darkness
			id = DARKNESS_GENJUTSU
			name = "Genjutsu: Darkness"
			icon_state = "paralyse_genjutsu"
			default_chakra_cost = 800
			default_cooldown = 200



			Use(mob/user)
				user.icon_state="Seal"
				spawn(20)
					user.icon_state=""
				var/mob/human/etarget = user.MainTarget()
				if(etarget)
					var/result=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(etarget.int+etarget.intbuff-etarget.intneg)*(1 + 0.05*etarget.skillspassive[19]),80)
					if(etarget.skillspassive[21] &&etarget.isguard)
						var/resist_roll=Roll_Against((user.int+user.intbuff-user.intneg)*(1 + 0.05*user.skillspassive[19]),(etarget.con+etarget.conbuff-etarget.conneg)*(1 + 0.05*(etarget.skillspassive[21]-1)),100)
						if(resist_roll < 4)
							result = 1
					var/image/I = image('icons/shroud.dmi',etarget)
					user<<I

					var/d=0
					if(result>=6)
						d=60
					if(result==5)
						d=30
					if(result==4)
						d=20
					if(result==3)
						d=16
					if(result==2)
						d=10
					if(d > 0)
						etarget.gen_effective_int = user.int+user.intbuff-user.intneg*1 + 0.05*user.skillspassive[19]
						etarget.sight=(BLIND|SEE_SELF|SEE_OBJS)
						spawn(d*10)
							if(etarget) etarget.sight=0

							del(I)
