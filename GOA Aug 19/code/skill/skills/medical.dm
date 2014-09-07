skill/medical
	chakra_taijutsu_release
		id = CHAKRA_TAIJUTSU_RELEASE
		name = "Medical: Chakra Taijutsu Release"
		icon_state = "chakra_taijutsu_release"
		default_chakra_cost = 100
		default_cooldown = 10

		IsUsable(combatant/user)
			. = ..()
			if(.)
				if(user.melee == global.melees[CHAKRA_SCALPEL])
					Error(user, "You cannot do this with Chakra Scalpels are active.")
					return 0

		Use(combatant/user)
			user.stun()
			user.overlays+='media/jutsu/general/medical/sakurapunch.dmi'
			user.combat_message("Attack Quickly! Your chakra will drain until you attack.")
			sleep(5)
			user.overlays-='media/jutsu/general/medical/sakurapunch.dmi'
			user.end_stun()
			user.melee = global.melees[CHAKRA_TAIJUTSU_RELEASE]
			user.calculate_stats()
			spawn()
				while(user && user.melee == global.melees[CHAKRA_TAIJUTSU_RELEASE] && user.chakra.value > 100)
					user.chakra.decrease(100)
					sleep(10)
				if(user)
					user.melee = global.melees[BASIC]
					user.calculate_stats()

	chakra_scalpel
		id = CHAKRA_SCALPEL
		name = "Chakra Scalpel"
		icon_state = "mystical_palm_technique"
		default_chakra_cost = 100
		default_cooldown = 60

		IsUsable(combatant/user)
			. = ..()
			if(.)
				if(user.size_up)
					Error(user, "An incompatible skill is active.")
					return 0

		ChakraCost(combatant/user)
			if(user.melee != global.melees[CHAKRA_SCALPEL])
				return ..(user)
			else
				return 0

		Cooldown(combatant/user)
			if(user.melee != global.melees[CHAKRA_SCALPEL])
				return ..(user)
			else
				return 3

		Use(combatant/user)
			if(user.melee == global.melees[CHAKRA_SCALPEL])
				//user.special=0
				//user.scalpol=0
				user.melee = global.melees[BASIC]
				user.remove_appearance("chakra_scalpel")
				//user.weapon=new/list()
				//user.Load_Overlays()
				ChangeIconState("mystical_palm_technique")
			else
				if(user.client)
					user.combat_message("This skill requires precison. Wait between attacks for critical damage!")
				//user.scalpol=1
				user.melee = global.melees[CHAKRA_SCALPEL]
				//user.overlays += 'icons/chakrahands.dmi'
				var/list/newoverlays = list(
					new/image('media/jutsu/general/medical/chakra_scalpel.dmi'),
					new/image('media/jutsu/general/medical/chakra_effect.dmi'),
				)
				user.add_appearance(newoverlays, "chakra_scalpel")
				//user.special=/obj/chakrahands
				//user.removeswords()
				//user.weapon=list('icons/chakraeffect.dmi')
				//user.Load_Overlays()
				ChangeIconState("mystical_palm_technique_cancel")

melee/taijutsu/chakra_taijutsu_release
	id = CHAKRA_TAIJUTSU_RELEASE
	animations = list("PunchA-1", "PunchA-2")

	get_stamina_dmg(combatant/user)
		. = (250 + ((2 * user.strength.get_value()) + (user.control.get_value())) / 4)

		if(user.passives[MEDICAL_TRAINING])
			. *= 1 + 0.2 * user.passives[MEDICAL_TRAINING]

	hit(var/character/attacked, var/combatant/attacker)
		if(!attacked || !attacker)
			return

		attacked.take_damage(get_stamina_dmg(attacker), 0, attacker, source = "Chakra Taijutsu Release")
		attacked.Earthquake(5)
		attacked.add_move_penalty(min(10, attacker.passives[MEDICAL_TRAINING]))
		if(attacker)
			attacker.pixel_x = 0
			attacker.pixel_y = 0
		if(attacked)
			attacked.pixel_x = 0
			attacked.pixel_y = 0
		explosion(0, 0, attacked.loc, attacker)
		attacked.knockback(rand(10,10), attacker.dir)
		attacker.melee = global.melees[BASIC]

	combo()

melee/taijutsu/chakra_scalpel
	id = CHAKRA_SCALPEL
	animations = "w-attack"

	get_stamina_dmg(var/combatant/user)
		. = ((user.control.get_value()) * 0.4) * (1 + 0.2 * user.passives[MEDICAL_TRAINING]) * pick(0.6, 0.7, 0.8, 0.9, 1)

	get_wound_dmg(var/combatant/user)
		. = pick(0, 1)

	get_critical_dmg(var/combatant/user)
		. = round((get_stamina_dmg(user) * rand(20, 40)) / 10)

	animation(var/combatant/user)
		flick(animations, user)

	hit(var/character/attacked, var/combatant/attacker)
		if(!attacked.icon_state)
			flick("hurt", attacked)

		var/bleed = 0
		if(attacker.passives[OPEN_WOUNDS] && prob(3 * attacker.passives[OPEN_WOUNDS]))
			if(attacked.client)
				attacked.combat_message("[attacker] has vitally hit an organ and caused bleed damage!")
			if(attacker.client)
				attacker.combat_message("You have hit one of [attacked]'s vital organs and caused bleed damage!")

			bleed = pick(3, 6, 9)

		var/critical_chance = max(0, min(10, world.time - attacker.scalpel_timestamp)) * (1 + 0.2 * attacker.passives[MEDICAL_TRAINING])
		var/resist_evade = 3 * attacked.passives[EVASIVENESS]

		if(prob(critical_chance) && !prob(resist_evade))
			var/critical_dmg = src.get_critical_dmg(attacker)
			var/wound_dmg    = src.get_wound_dmg(attacker)
			if(bleed)
				bleed *= 2

			attacked.take_damage(critical_dmg, wound_dmg, attacker, source = "Chakra Scalpels")

			combat_graphic("critical", attacked)

			if(attacker.client)
				attacker.combat_message("Critical hit [attacked] for [critical_dmg] stamina damage and [wound_dmg] wounds!")
		else
			var/stamina_dmg  = src.get_stamina_dmg(attacker)
			var/wound_dmg    = src.get_wound_dmg(attacker)

			if(bleed)
				wound_dmg += pick(0, 1, 2, 3)

			attacked.take_damage(stamina_dmg, wound_dmg, attacker, source = "Chakra Scalpels")

			if(attacker.client)
				attacker.combat_message("Hit [attacked] for [stamina_dmg] stamina damage and [wound_dmg] wounds!")

		var/slow = 5 * (1 + 0.2 * attacker.passives[MEDICAL_TRAINING])
		attacked.add_move_penalty(slow)

		if(bleed)
			attacked.rend(bleed, attacker)

		attacker.scalpel_timestamp = world.time

mob
	var/tmp/scalpel_timestamp = 0
	var/tmp/poison
	var/tmp/bleeding

	proc/rend(var/time, var/combatant/cause)
		set waitfor = 0

		sleep(5)

		src.bleeding += 1

		while(src && time > 0 && src.bleeding > 0)
			blood_effect(src, cause)
			src.take_damage(100, 0, cause, "Rend", "internal")
			time -= 1
			sleep(15)
		if(src.bleeding)
			src.end_rend()

	proc/end_rend()
		src.bleeding = max(0, --src.bleeding)
		if(src.client)
			src.combat_message("You have recovered from internal bleeding.")