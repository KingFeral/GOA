skill/general
	body_flicker
		id = BODY_FLICKER
		name = "Body Flicker"
		icon_state = "shunshin"
		default_chakra_cost = 100
		default_cooldown = 30
		default_seal_time = 6

		SealTime(combatant/user)
			if(user.passives[SPEED_DEMON] >= 1)
				return 0
			else
				return default_seal_time

		Cooldown(combatant/user)
			if(user.passives[SPEED_DEMON] >= 4)
				if(user.passives[SPEED_DEMON] == 4)
					default_cooldown = 10
				else
					default_cooldown = 1
			else
				return default_cooldown

		Use(combatant/user)
			var/character/etarget = user.main_target()

			if(!user.icon_state)
				flick(user, "Seal")

			sleep(1)

			if(!etarget)
				if(user.client)
					user.combat_message("<b>Double-click</b> on an empty section of ground within <em>5 seconds</em> to teleport there.")
				user.shunshin = 1
				spawn(50)
					if(user) user.shunshin = 0
			else
				if(etarget.z == user.z)
					if(user.passives[SPEED_DEMON] >= 2)
						user.AppearBehind(etarget, "body_flicker")
						if(user.passives[SPEED_DEMON] < 3)
							user.reaction_stun(5)
					else
						user.AppearBefore(etarget, "speed")
						user.timed_stun(25)

	body_replacement
		id = BODY_REPLACEMENT
		name = "Body Replacement"
		icon_state = "kawarimi"
		default_chakra_cost = 50
		default_cooldown = 1//30
		default_seal_time = 3

		Use(combatant/user)
			set waitfor = 0

			for(var/trigger/replacement/r in user.triggers)
				user.RemoveTrigger(r)

			var/duration = 300 + (user.intelligence.get_value() - 50)
			if(user.client)
				user.combat_message("Pressing Z within the next <em>[round(duration / 10)] seconds</em> will allow you replace yourself with a log and make a quick escape!")

			src.Add_Selected()

			var/trigger/replacement/r = new(user)

			var/deactivation_time = world.time + duration
			while((r in user.triggers) && world.time < deactivation_time)
				sleep(3)

			if(user)
				src.Remove_Selected()
				if(r in user.triggers)
					user.RemoveTrigger(r)

					src.DoCooldown(user)

mob
	var/tmp/replacement_type
	var/tmp/combatant/user

character/replacement_log
	proc/trigger()
		if(!src || !src.user)
			return

		for(var/character/m in src.targeted_by) spawn
			m.add_target(src.user, active = TRUE, silent = TRUE)

			//if(src)
			//	if(src.user)
			//		src.user.BunshinTrick(list(src))

		if(src.replacement_type == "exploding")
			new/obj/exploding_log(src.loc)
		else
			new/obj/log(src.loc)

		src.dispose()

	dispose()
		src.user = null
		..()

	New(var/location, var/combatant/user, var/replacement_type = "regular")
		set waitfor = 0

		if(!user)
			loc = null
			return 0
		..()

		src.user = user
		src.name = user.name
		src.dir = user.dir
		src.replacement_type = replacement_type
		src.mimick_appearance(user)
		if(src.icon_state == "Run")
			src.icon_state = ""

		src.set_attributes(user)
		src.calculate_stats()

		while(src.loc != null)
			src.Move(get_step(src, src.dir), src.dir)
			sleep(2)

obj/log
	icon = 'media/jutsu/general/log.dmi'
	icon_state = ""
	density = 1
	New()
		set waitfor = 0
		..()
		smoke_effect(src.loc)
		src.icon_state = "kawa"
		sleep(20)
		src.dispose()

obj/exploding_log
	icon = 'media/jutsu/general/exploding_log.dmi'
	density = 1

	New(var/location, var/combatant/user)
		set waitfor = 0
		..()
		smoke_effect(src.loc)
		sleep(1.5)
		explosion(2000, src.x, src.y, src.z, user)
		src.dispose()

mob
	var/tmp/shunshin
	var/tmp/henged
	var/tmp/transform_chat_icon
	var/tmp/list/body_replacement

character
	proc/body_replace()
		set waitfor = 0
		var/character/user = src
		var/character/replacement_log/r = user.body_replacement["replacement"]
		if(r)
			r.trigger()

		user.body_replacement = null
		user.density = 1
		user.reIcon()
		user.load_overlays()
		user.affirm_icon()
		user.end_protect()

		var/skill/general/body_replacement/replacement = user.GetSkill(BODY_REPLACEMENT)
		replacement.DoCooldown(user)

	proc/set_attributes(character/m)
		strength.set_value(m.strength.value)

		control.set_value (m.control.value)

		reflex.set_value(m.reflex.value)

		intelligence.set_value(m.intelligence.value)