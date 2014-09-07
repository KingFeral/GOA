melee/taijutsu
	basic
		name = null
		id = BASIC

		combo_effect(var/character/attacked, var/combatant/attacker)
			punch_effect(attacked, rand(-6, 6), rand(-8, 8))

		get_stamina_dmg(var/combatant/user)
			. = (user.strength.get_value()) * pick(0.6, 0.7, 0.8, 0.9, 1)

		get_critical_dmg(var/combatant/user)
			. = round((user.strength.get_value()) * rand(15, 40) / 10) * (1 + 0.10 * user.passives[FORCE])


melee
	var/name
	var/id
	var/tmp/list/animations = list("PunchA-1", "PunchA-2", "KickA-1", "KickA-2")

	proc/combo_effect(var/character/attacked, var/combatant/attacker)

	proc/get_stamina_dmg(var/combatant/user)
		. = 0

	proc/get_wound_dmg(var/combatant/user)
		. = 0

	proc/get_critical_dmg(var/combatant/user)
		. = 0

	proc/can_hit(var/character/attacked, var/combatant/user)
		. = attacked.can_be_hit(user)

	proc/hit(var/character/attacked, var/combatant/attacker)
		set waitfor = 0

		if(attacked.action == global.actions[ACTION_DEFEND])
			if(attacker.client)
				attacker.combat_message("[attacked] blocked your attack!")

			if(attacker.comboing && attacked.name in attacker.comboing)
				attacker.comboing[attacked.name] = max(0, attacker.comboing[attacked.name] - 2)
				if(!attacker.comboing[attacked.name])
					attacker.comboing -= attacked.name
					if(!attacker.comboing.len)
						attacker.comboing = null

			attacker.attack_timestamp = world.time + 10

			spawn()
				punch_effect(attacked, rand(-8, 8), rand(-8, 8))
				punch_effect(attacked, rand(-6, 12), rand(-6, 12))
				punch_effect(attacked, rand(8, 16), rand(8, 16))

			attacker.knockback(1, get_dir_adv(attacked, attacker))
			if(attacker.client) attacker.Earthquake(5)

			sleep(10)
			attacked.force_action(ACTION_IDLE)
			attacked.reaction_stun(10)
			return

		if(!attacker.comboing)
			attacker.comboing = list()

		if(attacker.comboing[attacked.name] < 11/*(1 + attacked.passives[FLURRY])*/ && (attacked.name in attacker.comboing))
			attacker.comboing[attacked.name] += 1
		else
			attacker.comboing[attacked.name] = 1

		src.combo(attacked, attacker)

	proc/combo(var/character/attacked, var/combatant/attacker)
		set waitfor = 0

		flick("hurt", attacked)

		src.combo_effect(attacked, attacker)

		if(attacker.comboing && attacker.comboing[attacked.name] > 3 && prob(40))
			attacker.combo_pushback(attacked)

		var/stamina_dmg = src.get_stamina_dmg(attacker)
		var/wound_dmg   = src.get_wound_dmg(attacker)
		var/critical_damage = 0

		var/critical_chance = 5
		var/resist_daze = 4 * attacked.passives[BUILT_SOLID]
		var/resist_evade = 3 * attacked.passives[EVASIVENESS]

		if(attacker.passives[FLURRY] && attacker.comboing && attacker.comboing[attacked.name])
			var/boost = min(attacker.comboing[attacked.name], attacker.passives[FLURRY])//(attacker.comboing[attacked.name] > attacker.passives[FLURRY]) ? attacker.passives[FLURRY] : attacker.comboing[attacked.name]
			stamina_dmg *= 1 + 0.2 * boost

		// critical
		if(prob(critical_chance) && !prob(resist_evade))
			combat_graphic("critical", attacked)

			critical_damage = src.get_critical_dmg(attacker)

			attacked.timed_move_stun(20)

		if(attacked)
			attacked.add_move_penalty(4)
			if(attacked.move_penalty > 15)
				attacked.move_penalty = 15

		var/total_stamina_dmg = max(0, round(stamina_dmg + critical_damage))
		if(total_stamina_dmg > 0)
			var/detailed_msg = "[critical_damage > 0 ? " ([stamina_dmg] stamina damage + [critical_damage] critical damage)" : ""]"

			if(attacked.client)
				attacked.combat_message("[attacker] has hit you for [total_stamina_dmg][detailed_msg] stamina damage with their [name ? "[name]" : "taijutsu"]!")
			if(attacker.client)
				attacker.combat_message("You hit [attacked] for [total_stamina_dmg][detailed_msg] stamina damage with your [name ? "[name]" : "taijutsu"]!")

		for(var/combatant/m in viewers(1, attacked) - list(attacked, attacker))
			m.combat_message("[attacked] has been hit for [total_stamina_dmg]!")

		attacked.take_damage(total_stamina_dmg, wound_dmg, attacker, "Taijutsu")

		// daze
		if(attacker.comboing && (attacked.name in attacker.comboing) && attacker.comboing[attacked.name] > 5 && (!attacked.comboed || world.time - attacked.comboed[attacker.name] > 50))
			if(!prob(resist_daze) && !prob(resist_evade))
				src.daze(attacked, attacker)

		sleep(3)
		if(attacked)
			attacked.pixel_x = 0
			attacked.pixel_y = 0
		if(attacker)
			attacker.pixel_x = 0
			attacker.pixel_y = 0

	proc/daze(var/character/attacked, var/combatant/attacker)
		set waitfor = 0
		if(!attacked.comboed)
			attacked.comboed = list()
		attacked.comboed[attacker.name] = world.time

		combat_graphic("daze", attacked)

		attacked.icon_state = "hurt"

		var/daze_time = 1 + 1 * 0.2 * attacker.passives[FLURRY]
		attacked.timed_stun(daze_time * 10)

		punch_effect(attacked)

		for(var/character/m in viewers(1, attacked))
			if(m.client)
				m.combat_message("[attacked] has been dazed!")

		while(attacked && attacked.stunned)
			if(attacked.icon_state != "hurt")
				attacked.icon_state = "hurt"
			sleep(3)

		if(attacked && attacked.icon_state == "hurt")
			attacked.icon_state = ""

	proc/animation(var/combatant/user)
		flick(pick(animations), user)


mob
	var/tmp/melee/melee

combatant
	proc/combo_pushback(var/character/c)
		set waitfor = 0

		if(!src || !c)
			return

		c.knockback(1, src.dir)

		sleep(TICK_LAG*3)

		step(src, get_dir_adv(src, c))

	can_be_hit(var/combatant/attacker)
		if(src.action == global.actions[ACTION_KNOCKOUT])
			return 0

		if(src.bone_spines)
			var/wound_damage = rand(2, 4)
			attacker.take_damage(0, wound_damage, src, "Bone Spines")
			attacker.timed_stun(3)
			return 0

		return TRUE

	New()
		..()
		src.melee = global.melees[BASIC]

mob
	var/tmp/list/comboing
	var/tmp/list/comboed

character
	proc/can_be_hit(var/combatant/attacker)
		return src.action_set(ACTION_KNOCKOUT) ? (0) : (1)


var/global/list/melees = list(
	BASIC							= new/melee/taijutsu/basic,
	GENTLE_FIST						= new/melee/taijutsu/gentle_fist,
	CHAKRA_SCALPEL					= new/melee/taijutsu/chakra_scalpel,
	CHAKRA_TAIJUTSU_RELEASE			= new/melee/taijutsu/chakra_taijutsu_release,
	SIZE_UP_1						= new/melee/taijutsu/size_up_1,
	SIZE_UP_2						= new/melee/taijutsu/size_up_2,
	)