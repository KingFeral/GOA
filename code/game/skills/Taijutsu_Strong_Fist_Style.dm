

skill/taijutsu/strong_fist
	face_nearest = TRUE

	Cooldown(mob/user)
		return default_cooldown

	IsUsable(mob/user)
		. = ..()
		if(.)
			if(user.stance != STRONG_FIST)
				Error(user, "You need to be in Strong Fist stance to use this.")
				return 0

	stance
		id = STRONG_FIST
		name = "Taijutsu Stance: Strong Fist"
		icon_state = "Strong_Fist"
		default_cooldown = 3

		IsUsable(mob/user)
			if(user.scalpol)
				Error(user, "You cannot enter this stance while Chakra Scalpels are active")
				return 0
			return 1

		Use(mob/user)
			if(user.stance)
				user.combat("Your normalize your stance.")
				user.stance = null
			else
				user.combat("You enter Strong Fist stance.")
				user.stance = STRONG_FIST

	leaf_whirlwind
		// low damage; used to close the gap
		id = LEAF_WHIRLWIND
		name = "Leaf Whirlwind"
		icon_state = "leaf_whirlwind"
		default_stamina_cost = 350
		default_cooldown = 10

		Use(mob/user)
			set waitfor = 0
			viewers(user) << output("[user]: Leaf Great Whirlwind!", "combat_output")

			var/mob/human/etarget = user.NearestTarget() || locate() in get_step(user, user.dir)

			spawn()
				user.overlay('icons/senpuu.dmi', 8)
				user.icon_state = "KickA-1"
				spawn(8)
					user.icon_state = ""
				sleep(4)
				user.dir = turn(user.dir, 90)
				sleep(4)
				user.dir = turn(user.dir, 90)

			if(etarget)
				user.AppearBefore(etarget)
				user.Taijutsu(etarget)

				if(!etarget.icon_state)
					flick("hurt",etarget)

				//var/rfx_roll = Roll_Against((user.rfx + user.rfxbuff - user.rfxneg), (etarget.rfx + etarget.rfxbuff - etarget.rfxneg), 100)
				var/stamina_damage = ((user.str + user.strbuff - user.strneg) + (user.rfx + user.rfxbuff - user.rfxneg)) * 0.5
				stamina_damage += 100 * etarget.c
				stamina_damage = min(1350, stamina_damage)

				/*switch(rfx_roll)
					if(5 to 6)
						etarget.Wound(rand(2, 4), 0, user)
					if(4)
						etarget.Wound(rand(1, 3), 0, user)
					if(3)
						etarget.Wound(rand(0, 2), 0, user)*/

				etarget.Dec_Stam(stamina_damage, 0, user)
				etarget.increase_comboed(1)//etarget.c++
			else
				set_cooldown = 10

			user.Timed_Stun(2)
			user.can_use_F = world.time + 10

	leaf_great_whirlwind
		// higher damage; shorter range; knockback combo
		id = LEAF_GREAT_WHIRLWIND
		name = "Leaf Great Whirlwind"
		icon_state = "leaf_great_whirlwind"
		default_stamina_cost = 500
		default_cooldown = 70
		var/tmp/kicks = 0

		Cooldown(mob/user)
			if(kicks)
				return 1
			else
				return default_cooldown

		proc/kick(mob/etarget, mob/user)
			if(!etarget || !user || !kicks)
				return
			if(kicks == 3) // the first kick.
				viewers(user) << output("[user]: Leaf Great Whirlwind!", "combat_output")

			if(get_dist(user, etarget) <= 5)
				user.AppearBefore(etarget)
				user.FaceTowards(etarget)
				//var/rfx_roll = Roll_Against((user.rfx + user.rfxbuff - user.rfxneg), (etarget.rfx + etarget.rfxbuff - etarget.rfxneg), 100)
				var/stamina_damage = ((user.str + user.strbuff - user.strneg) + (user.rfx + user.rfxbuff - user.rfxneg)) * 0.5// * 3
				stamina_damage += 100 * etarget.c
				stamina_damage = min(1050, stamina_damage)

				if(!user.gate)
					for(var/i = (3 - kicks); i > 0; i--)
						stamina_damage *= 0.6

				/*switch(rfx_roll)
					if(5 to 6)
						etarget.Wound(rand(1, 4), 0, user)
					if(4)
						etarget.Wound(rand(1, 3), 0, user)
					if(3)
						etarget.Wound(rand(0, 2), 0, user)*/

				etarget.Dec_Stam(stamina_damage, 0, user)
				etarget.Knockback(3, get_dir(user, etarget))
				etarget.increase_comboed(1)//etarget.c++

		proc/start_timer(mob/user)
			set waitfor = 0
			sleep(100)
			if(!user)
				return
			if(kicks)
				kicks = 0
				user.combat("Leaf Great Whirlwind is no longer active.")
				DoCooldown(user)

		Use(mob/user)
			if(!kicks) // initial use
				if(user.gate)
					kicks = 1
				else
					kicks = 3
				user.combat("Leaf Great Whirlwind: Activate this skill again to attack your target. You have [kicks] charges <i>or</i> 10 seconds.")
				start_timer()
			else if(kicks > 0)
				spawn()
					//user.icon_state = "KickA-1"
					user.set_icon_state("KickA-1", 8)
					sleep(4)
					user.dir = turn(user.dir, 90)
					sleep(4)
					user.dir = turn(user.dir, 90)

				var/mob/mtarget = user.MainTarget()
				kick(mtarget, user)
				kicks = max(--kicks, 0)

/*			viewers(user) << output("[user]: Leaf Great Whirlwind!", "combat_output")

			spawn()
				user.icon_state = "KickA-1"
				sleep(4)
				user.dir = turn(user.dir, 90)
				sleep(4)
				user.dir = turn(user.dir, 90)

			var/list/targets = user.NearestTargets(max_distance = 5, num = 3)
			if(targets && targets.len)
				if(targets.len > 1)
					for(var/mob/etarget in targets)
						if(user.stunned || !etarget || get_dist(user, etarget) > 5)
							break
						user.AppearBefore(etarget)
						user.FaceTowards(etarget)
						var/rfx_roll = Roll_Against((user.rfx + user.rfxbuff - user.rfxneg), (etarget.rfx + etarget.rfxbuff - etarget.rfxneg), 100)
						var/str_mult = user.strength_damage_mult()
						switch(rfx_roll)
							if(5 to 6)
								//etarget.Dec_Stam(rand(600, 800) * str_mult, 0, user)
								etarget.Wound(rand(2, 4), 0, user)
								//etarget.Knockback(4, user.dir)
							if(4)
								//etarget.Dec_Stam(rand(450, 600) * str_mult, 0, user)
								etarget.Wound(rand(1, 3), 0, user)
								//etarget.Knockback(3, user.dir)
							if(3)
								//etarget.Dec_Stam(rand(250, 400) * str_mult, 0, user)
								etarget.Wound(rand(0, 2), 0, user)
								//etarget.Knockback(2, user.dir)

						smack(etarget, rand(-6,6), rand(-8,8))
						etarget.c++
						user.Taijutsu(etarget)
						etarget.Knockback(3, user.dir)

						sleep(pick(1, 2, 3))

				else // single target
					var/mob/etarget = targets[1]
					for(var/iteration in 1 to 3)
						if(user.stunned || !etarget || get_dist(user, etarget) > 10)
							break
						user.AppearBefore(etarget)
						user.FaceTowards(etarget)
						var/rfx_roll = Roll_Against((user.rfx + user.rfxbuff - user.rfxneg), (etarget.rfx + etarget.rfxbuff - etarget.rfxneg), 100)
						var/str_mult = user.strength_damage_mult()
						switch(rfx_roll)
							if(5 to 6)
								etarget.Dec_Stam(rand(600, 800) * str_mult, 0, user)
								etarget.Wound(rand(2, 4), 0, user)
								etarget.Knockback(3, user.dir)
							if(4)
								etarget.Dec_Stam(rand(450, 600) * str_mult, 0, user)
								etarget.Wound(rand(1, 3), 0, user)
								etarget.Knockback(3, user.dir)
							if(3)
								etarget.Dec_Stam(rand(250, 400) * str_mult, 0, user)
								etarget.Wound(rand(0, 2), 0, user)
								etarget.Knockback(3, user.dir)
							else
								etarget.Dec_Stam(100 * str_mult, 0, user)
								//etarget.Wound(rand(0, 2), 0, user)
								etarget.Knockback(1, user.dir)
						if(rfx_roll >= 3)
							smack(etarget, rand(-6,6), rand(-8,8))
							etarget.c++
							user.Taijutsu(etarget)
						sleep(pick(1, 2, 2))
			else
				set_cooldown = 10

			spawn(8)
				user.icon_state = ""*/

	leaf_gale
		// low kicks the enemy, stunning them.
		id = LEAF_GALE
		name = "Leaf Gale"
		icon_state = "gale_wind"
		default_stamina_cost = 450
		default_cooldown = 90

		Use(mob/user)
			viewers(user) << output("[user]: Leaf Gale!", "combat_output")

			spawn()
				user.icon_state = "KickA-1"
				spawn(8)
					user.icon_state = ""
				sleep(4)
				user.dir = turn(user.dir, 90)
				sleep(4)
				user.dir = turn(user.dir, 90)

			var/mob/etarget = locate() in get_step(user, user.dir)
			if(etarget)
				if(!etarget.IsProtected())
					//var/rfx_roll = Roll_Against((user.rfx + user.rfxbuff - user.rfxneg), (etarget.rfx + etarget.rfxbuff - etarget.rfxneg), 100)
					var/str_mult = user.strength_damage_mult()
					var/base_damage = 0

					/*switch(rfx_roll)
						if(5 to 6)
							etarget.Wound(rand(1, 3), 0, user)
						if(4)
							etarget.Wound(rand(1, 2), 0, user)
						if(3)
							etarget.Wound(rand(0, 2), 0, user)*/

					etarget.combat("You stumble from [user]'s attack!")
					etarget.Dec_Stam(base_damage * str_mult, 0, user)
					etarget.movepenalty += 10
					flick("Knockout", etarget)

					etarget.set_icon_state("Dead", 30)
					etarget.overlay('icons/new/stunned.dmi', 30)
					etarget.Timed_Stun(30)
					etarget.increase_comboed(1)//etarget.c++
					user.Taijutsu(etarget)
					smack(etarget, rand(-6,6), rand(-8,8))
			else
				set_cooldown = 10

			user.Timed_Stun(3)

	leaf_rising_wind
		// silences the target for five seconds
		id = LEAF_RISING_WIND
		name = "Leaf Rising Wind"
		icon_state = "rising_wind"
		default_stamina_cost = 450
		default_cooldown = 90

		Use(mob/user)
			viewers(user) << output("[user]: Leaf Rising Wind!", "combat_output")

			flick("KickA-2", user)
			var/mob/etarget = locate() in get_step(user, user.dir)
			if(etarget)
				if(!etarget.IsProtected())
					var/rfx_roll = Roll_Against((user.rfx + user.rfxbuff - user.rfxneg), (etarget.rfx + etarget.rfxbuff - etarget.rfxneg), 100)
					//var/str_mult = user.strength_damage_mult()
					var/stamina_damage = (((user.str + user.strbuff - user.strneg) * 0.6) + ((user.rfx + user.rfxbuff - user.rfxneg) * 0.4))
					stamina_damage += stamina_damage * (1 + 0.3 * etarget.c)

					switch(rfx_roll)
						if(5 to 6)
							etarget.Wound(rand(1, 3), 0, user)
						if(4)
							etarget.Wound(rand(1, 2), 0, user)
						if(3)
							etarget.Wound(rand(0, 2), 0, user)

					etarget.Earthquake(15)
					etarget.Dec_Stam(stamina_damage, 0, user)
					etarget.increase_comboed(1)//etarget.c++
					user.Taijutsu(etarget)
					smack(etarget, rand(-6,6), rand(-8,8))
					etarget.set_icon_state("hurt", 10)
					etarget.timed_reaction_stun(50)
			else
				set_cooldown = 10

			user.Timed_Stun(3)

	leaf_strong_whirlwind
		// hits all targets within a one-tile range for a knockback
		id = LEAF_STRONG_WHIRLWIND
		name = "Leaf Strong Whirlwind"
		icon_state = "leaf_strong_whirlwind"
		default_stamina_cost = 350
		default_cooldown = 60

		Use(mob/user)
			viewers(user) << output("[user]: Leaf Strong Whirlwind!", "combat_output")

			var/obj/fxobj/temp = new(user.loc, 8)
			var/whirlwind_icon = 'icons/new/skills/taijutsu/leaf_strong_whirlwind.dmi'
			temp.overlays.Add(
				image(whirlwind_icon, "1,0", pixel_y = -32, layer = MOB_LAYER + 0.01),
				image(whirlwind_icon, "2,0", pixel_x = 32, pixel_y = -32, layer = MOB_LAYER + 0.01),
				image(whirlwind_icon, "0,0", pixel_x = -32, pixel_y = -32, layer = MOB_LAYER + 0.01),
				image(whirlwind_icon, "1,1", layer = MOB_LAYER + 0.01), // center
				image(whirlwind_icon, "0,1", pixel_x = -32, layer = MOB_LAYER + 0.01),
				image(whirlwind_icon, "2,1", pixel_x = 32, layer = MOB_LAYER + 0.01),
				image(whirlwind_icon, "1,2", pixel_y = 32, layer = MOB_LAYER + 0.01),
				image(whirlwind_icon, "0,2", pixel_x = -32, pixel_y = 32, layer = MOB_LAYER + 0.01),
				image(whirlwind_icon, "2,2", pixel_x = 32, pixel_y = 32, layer = MOB_LAYER + 0.01),
				)

			spawn()
				user.icon_state = "KickA-1"
				spawn(8)
					user.icon_state = ""
				sleep(4)
				user.dir = turn(user.dir, 90)
				sleep(4)
				user.dir = turn(user.dir, 90)

			for(var/mob/m in oview(1, user))
				if(m.IsProtected() || m.ko)
					continue
				//var/rfx_roll = Roll_Against((user.rfx + user.rfxbuff - user.rfxneg), (m.rfx + m.rfxbuff - m.rfxneg), 100)
				var/str_mult = user.strength_damage_mult()
				m.Dec_Stam(600 + rand(350, 500) * str_mult, 0, user)
				m.Timed_Stun(5)
				m.Knockback(4, get_dir(user.loc, m))
				user.Taijutsu(m)
				smack(m, rand(-6, 6), rand(-8, 8))

			user.Timed_Stun(10)

	dancing_leaf_shadow
		// speeds up the user's movement speed (Meat Tank-like speed) and turns their next combo into a knockup attack. Attacks cost stamina while active.
		id = DANCING_LEAF_SHADOW
		name = "Dancing Leaf Shadow"
		icon_state = "shadow_dance"
		default_stamina_cost = 300
		default_cooldown = 60

		Cooldown(mob/user)
			if(user.dancing_shadow)
				return 1
			else
				return default_cooldown

		Use(mob/user)
			set waitfor = 0
			if(user.dancing_shadow)
				RemoveOverlay("cancel")
				user.combat("You deactivated Dancing Leaf Shadow.")
				user.dancing_shadow = FALSE
			else
				user.dancing_shadow = TRUE
				user.combat("Dancing Leaf Shadow has been activated, increasing your speed as a result! Your next combo will cause a knockback at the expense of stamina.")
				AddOverlay("cancel")
				/*while(user && user.dancing_shadow)
					step(user, user.dir)
					sleep(10)*/

mob
	var/tmp/dancing_shadow

mob
	proc/overlay(o, delay)
		set waitfor = 0
		if(!delay)
			return
		overlays += o
		sleep(delay)
		overlays -= o

mob
	proc/lift(duration)
		// lifts src into the air (usually due to an attack)
		duration = round(duration / 2)
		if(!duration || duration <= 0)
			return
		incombo = 1
		icon_state = "hurt"
		var/obj/shadow = new(loc)
		shadow.icon = 'icons/shadow.dmi'
		shadow.density = 0
		shadow.layer = layer - 0.001
		var/time = duration
		while(time > 0)
			pixel_y += 3
			time--
			sleep(1)
		while(time < duration)
			pixel_y -= 3
			time++
			sleep(1)
		incombo = 0
		shadow.loc = null