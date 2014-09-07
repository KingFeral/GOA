
mob
	// combat commands.
	var/tmp/attack_timestamp = 0

	proc/attack_down()
		src.act(global.actions[ACTION_ATTACK])

	proc/defend_down()
		src.act(global.actions[ACTION_DEFEND])
		//src.icon_state = "Seal"

mob
	// knockout and death.
	proc/knockout()
		var/character/user = src
		var/action/user_action = src.action
		var/start_timestamp = src.action_timestamp

		flick("Knockout", user)

		user.icon_state = "Dead"

		var/wound_damage = rand(27, 33)
		user.wounds.increase(wound_damage)

		var/knockout_time = 0
		if(user.wounds.value < user.wounds.maximum_value)
			knockout_time = user.wounds.value + 100
			sleep(knockout_time)

			if(!user || user.action != user_action || user.action_timestamp != start_timestamp)
				return 0
		else
			user.combat_message("You have been wounded beyond your wound limit! You will die in <em>60 seconds</em> if you are not healed back to life!")
			knockout_time = 600

			sleep(knockout_time)

			if(!user || user.action != src || user.action_timestamp != start_timestamp)
				return 0

			if(user.wounds.value >= user.wounds.maximum_value)
				user.die()
				return

		if(user.clan == WILL_OF_FIRE)
			user.stamina.set_value(user.stamina.maximum_value * 1.25)
			user.chakra.set_value(user.chakra.maximum_value * 1.25)
		else
			var/durr = ((user.wounds.maximum_value - user.wounds.value) / user.wounds.maximum_value) / 2
			if(durr < 0)
				durr = 0
			user.stamina.set_value(user.stamina.maximum_value * durr + user.stamina.maximum_value / 2)

		if(user.chakra.value < user.chakra.maximum_value / 5)
			user.chakra.set_value(user.chakra.maximum_value / 5 + 20)

		user.force_action(ACTION_KNOCKOUT)
		user.timed_protect(30)
		user.reset_move_stun()

	proc/die()

mob
	// knockback.
	var/tmp/noknock

	proc/can_be_knockback()
		. = src.action != global.actions[ACTION_KNOCKOUT] /*&& !src.stunned*/ && !noknock

	proc/knockback(distance, direction)
		set waitfor = 0

		if(!src.can_be_knockback())
			return 0

		//src.knocked_back = 1
		src.animate_movement = 2
		if(!src.icon_state)
			src.icon_state = "hurt"

		if(!src.cant_react)
			src.reaction_stun(10)

		var/reflected = 0

		var/move_x = 0
		var/move_y = 0
		if(direction & NORTH) move_y++
		if(direction & SOUTH) move_y--
		if(direction & EAST) move_x++
		if(direction & WEST) move_x--

		. = 1
		while(src && distance > 0)
			var/turf/currentlocation = loc
			var/turf/nextlocation = get_step(currentlocation, direction)
			if(!nextlocation || nextlocation.density)
				. = 0
			else
				for(var/atom/movable/a in nextlocation)
					if(a.density)
						//debug("couldn't move due to [a]")
						. = 0
						break
			//debug("[. ? "COULD STEP" : "COULDN'T STEP"] TO [get_step(src,direction)]")
			if(.)
				var/turf/t = locate(x + move_x, y + move_y, z)
				if(t)
					//if(!t.Entered(src))
					//	break
					currentlocation.Exited(src)
					src.x += move_x
					src.y += move_y
					if(!t.Entered(src))
						break
					//if(!src.loc.Entered(src))
					//	break

			else if(!reflected)
				direction = pick(turn(direction, 145), turn(direction, -145))
				. = step(src, direction)
				reflected = 1
				// recalculate.
				move_x = 0
				move_y = 0
				if(direction & NORTH) move_y++
				if(direction & SOUTH) move_y--
				if(direction & EAST) move_x++
				if(direction & WEST) move_x--

			distance -= 1

			sleep(TICK_LAG*3)

		if(src)
			src.animate_movement = 1
			if(src.icon_state == "hurt")
				src.icon_state = ""

mob
	// combat support, background stuff, help, etc.
	var/tmp/regenerating
	var/tmp/list/regeneration = list("stamina" = 10, "chakra" = 10)

	proc/calculate_stats()
		var/stamina_mult = 1
		var/chakra_mult = 1

		if(src.clan == YOUTH)
			stamina_mult = 1.5
		else if(src.clan == CAPACITY)
			stamina_mult = 1.25
			chakra_mult = 1.5

		// Jutsu regeneration effects.
		var/stamina_regen_mult = 1
		var/chakra_regen_mult = 1

		if(src.sharingan)
			switch(src.sharingan)
				if(1)
					chakra_regen_mult = 0.7 + 0.01 * src.passives[CHAKRA_EFFICIENCY]
				if(2)
					chakra_regen_mult = 0.8 + 0.01 * src.passives[CHAKRA_EFFICIENCY]
				else
					chakra_regen_mult = 0.9 + 0.01 * src.passives[CHAKRA_EFFICIENCY]

		if(src.pill)
			if(src.pill == 1)
				stamina_regen_mult *= 1.10
				chakra_regen_mult *= 1.5
			else if(src.pill == 2)
				stamina_regen_mult *= 1.25
				chakra_regen_mult *= 2

		if(src.bone_harden)
			chakra_regen_mult *= 0.6

		if(src.gate < 3)
			stamina.set_maximum_value(2000 + (src.level * 25 + (src.strength.get_value()) * 13) * stamina_mult)
			chakra.set_maximum_value((500 + (src.control.get_value()) * 5) * chakra_mult)
		else
			stamina.set_maximum_value(2000 + (src.level * 25 + (src.strength.get_value()) * 18) * stamina_mult)
			chakra.set_maximum_value((500 + (src.control.get_value()) * 7) * chakra_mult)

		src.regeneration["stamina"] = round(stamina_regen_mult * src.stamina.maximum_value / 100)
		src.regeneration["chakra"] = round(((src.chakra.maximum_value * 0.6 / 100) + src.level * 0.4) * chakra_regen_mult)

		if(src.on_water)
			src.regeneration["chakra"] *= 0.6

	proc/regenerate()
		set waitfor = 0

		if(src.regenerating)
			return 0

		src.regenerating = TRUE
		src.calculate_stats()

		while(\
			src.stamina.value < src.stamina.maximum_value || \
			src.chakra.value < src.chakra.maximum_value
			)

			if(!src.stamina.value && src.action != global.actions[ACTION_KNOCKOUT])
				src.knockout()

			while(src.action == global.actions[ACTION_KNOCKOUT])
				sleep(10)

			// begin regenerating.
			var/can_regenerate = 1//!src.on_water
			if(can_regenerate)
				if(src.chakra.value < src.chakra.maximum_value)
					src.chakra.increase(src.regeneration["chakra"])
				else if(src.stamina.value < src.stamina.maximum_value)
					src.stamina.increase(src.regeneration["stamina"])

			sleep(10)

		if(src)
			src.regenerating = FALSE

	proc/take_damage(var/stamina_damage, var/wound_damage, var/combatant/attacker, var/source, var/class = "normal")
		set waitfor = 0

		if(!src || src.action == global.actions[ACTION_KNOCKOUT] || (stamina_damage < 1 && wound_damage < 1))
			return

		var/piercing_stamina_damage = 0
		var/iron_skin_stamina_damage = 0
		var/bone_harden_stamina_damage = 0
		var/deflection_stamina_damage = 0

		if(attacker && attacker != src)
			if(attacker.passives[BLINDSIDE] && !src.byakugan && source != "Rend")
				src.filter_targets()
				if((!(attacker in src.active_targets)))
					if(attacker in src.targets)
						stamina_damage *= (1 + 0.025 * attacker.passives[BLINDSIDE])
						wound_damage *= (1 + 0.025 * attacker.passives[BLINDSIDE])
					else
						stamina_damage *= (1 + 0.05 * attacker.passives[BLINDSIDE])
						wound_damage *= (1 + 0.05 * attacker.passives[BLINDSIDE])

			if(source == "Taijutsu" && attacker.passives[PIERCING_STRIKE])
				piercing_stamina_damage = round(stamina_damage * 3 * attacker.passives[PIERCING_STRIKE] / 100)
				stamina_damage -= piercing_stamina_damage

		if(class != "internal")
			if(src.is_protected())
				if(source == "Taijutsu" && piercing_stamina_damage > 0)
					stamina_damage = 0
					wound_damage = 0
				else
					return

			if(src.sandarmor)
				wound_damage = 0
				var/sandarmor_damage = stamina_damage + wound_damage * 50
				var/runoff_damage = src.sandarmor - sandarmor_damage
				src.sandarmor = max(0, src.sandarmor - sandarmor_damage)
				if(src.sandarmor)
					if(src.client)
						src.combat_message("Your Sand Armor absorbed [sandarmor_damage][attacker && attacker != src ? " from [attacker]" : ""]!")
					if(attacker && attacker != src && attacker.client)
						attacker.combat_message("You dealt [sandarmor_damage] to [src]'s Sand Armor!")
					return
				else
					if(src.client)
						src.combat_message("Your Sand Armor absorbed [sandarmor_damage][attacker && attacker != src ? " from [attacker]" : ""] and shattered!")
					if(attacker && attacker != src && attacker.client)
						attacker.combat_message("You dealt [sandarmor_damage] to [src]'s Sand Armor and shattered it!")

					stamina_damage = abs(runoff_damage)

			if(src.bone_harden)
				bone_harden_stamina_damage = round((stamina_damage / 3) + (wound_damage * 20))
				var/runoff_damage = src.chakra.value - bone_harden_stamina_damage
				src.chakra.decrease(bone_harden_stamina_damage)
				if(!src.chakra.value)
					stamina_damage += abs(runoff_damage)
					src.bone_harden = 0
				else
					stamina_damage = 0
					wound_damage = 0

			if(src.pill == 2)
				stamina_damage *= 0.7
				wound_damage *= 0.8

			if(src.size_up)
				if(src.size_up == 1)
					stamina_damage *= 0.8
					wound_damage *= 0.9
				else
					stamina_damage *= 0.7
					wound_damage *= 0.8

				wound_damage = min(20, wound_damage)

			if(src.meat_tank)
				wound_damage = min(10, wound_damage)

			if(src.action == global.actions[ACTION_DEFEND])
				stamina_damage *= 0.5

			switch(src.clan)
				if(BATTLE_CONDITIONED)
					stamina_damage *= 0.8
					wound_damage *= 0.85
				if(JASHIN)
					wound_damage = min(100, wound_damage)

		if(class == "normal")
			if(src.iron_skin)
				stamina_damage *= 0.5
				iron_skin_stamina_damage = wound_damage * 50
				wound_damage = 0

			if(wound_damage > 0)
				//var/effective_armor = src.action == global.actions[ACTION_DEFEND] ? 1 : armor_count / 100

				//effective_armor = max(0, min(effective_armor, 1))

				wound_damage *= 1 - round((((armor_count) / (armor_count * 1.2 + 180))))

			if(src.passives[BUILT_SOLID] && wound_damage > 0)
				var/checked_wounds = 0

				while(checked_wounds < wound_damage && (deflection_stamina_damage + 150) < src.stamina.value)
					++checked_wounds
					if(prob(2 * passives[BUILT_SOLID]))
						--wound_damage
						deflection_stamina_damage += 150

		var/total_stamina_damage = max(0, round(stamina_damage + piercing_stamina_damage + deflection_stamina_damage + iron_skin_stamina_damage + bone_harden_stamina_damage))
		var/stamina_message = ""
		if(total_stamina_damage > 0)
			var/detailed_stamina_message = ""

			if(piercing_stamina_damage || deflection_stamina_damage || iron_skin_stamina_damage || bone_harden_stamina_damage)
				detailed_stamina_message = " ([stamina_damage]"
				if(piercing_stamina_damage)
					detailed_stamina_message += " + [piercing_stamina_damage] Piercing"
				if(deflection_stamina_damage)
					detailed_stamina_message += " + [deflection_stamina_damage] Deflection"
				if(iron_skin_stamina_damage)
					detailed_stamina_message += " + [iron_skin_stamina_damage] Iron Skin"
				if(bone_harden_stamina_damage)
					detailed_stamina_message += " + [bone_harden_stamina_damage] Bone Harden"
				detailed_stamina_message += ")"

			stamina_message = "[total_stamina_damage][detailed_stamina_message] stamina damage"

		wound_damage = max(0, round(wound_damage))
		var/wound_message = "[wound_damage ? "[wound_damage] wound damage" : ""]"
		var/join_message = "[stamina_damage && wound_damage ? " and " : ""]"

		if(source != "Gates Stress" && source != "Pills Stress" && src.client)
			src.combat_message("You took [stamina_message][join_message][wound_message][attacker? " from [attacker]" : ""][source && source != "Taijutsu" ? "'s [source]" : ""]!")
		if(src && attacker && attacker != src && attacker.client)
			attacker.combat_message("You dealt [stamina_message][join_message][wound_message] to [src][source && source != "Taijutsu" ? " with your [source]" : ""]!")

		src.stamina.decrease(total_stamina_damage)
		src.wounds.increase(wound_damage)
		if(wound_damage > 0 && source != "Chakra Scalpels" && source != "Gates Stress" && source != "Pills Stress") blood_effect(src, attacker)
		src.damaged_by(attacker)

		if(!src.stamina.value && source != "Knockout")
			src.knockout()

		if(attacker && attacker.clan == RUTHLESS)
			attacker.adrenaline += round(total_stamina_damage / 100) + wound_damage * 2

	proc/damaged_by(combatant/attacker)
		src.usemove = 0
		src.regenerate()

	proc/combat_message(combatmsg)
		if(src.client)
			src << output(combatmsg, "combatoutputpane.output")

#define OFFENSE_FLAG	1
#define DEFENSE_FLAG	2

mob
	// combat flag.
	var/tmp/list/combat_flag

	proc/combat_flag(var/time, var/flag)
		if(!flag)
			if(!src.combat_flag)
				src.combat_flag = list()

			src.combat_flag["offense"] = world.time + time * 10
			src.combat_flag["defense"] = world.time + time * 10

		else
			if(flag & OFFENSE_FLAG) src.combat_flag["offense"] = world.time + time * 10
			if(flag & DEFENSE_FLAG) src.combat_flag["defense"] = world.time + time * 10

	proc/combat_flagged(var/flag)
		if(isnull(src.combat_flag))
			return 0

		if(flag & OFFENSE_FLAG && world.time < src.combat_flag["offense"]) return 1
		if(flag & DEFENSE_FLAG && world.time < src.combat_flag["defense"]) return 1

mob
	// combat status effects.
	var/tmp/stunned

	var/tmp/protected = 0
	var/tmp/protected_source

	var/tmp/move_slow = 0
	var/tmp/move_stun = 0
	var/tmp/move_penalty = 0
	var/tmp/list/slows

	var/tmp/cant_react
	var/tmp/frozen

	proc/reaction_stun(duration)
		set waitfor = 0

		src.begin_reaction_stun()

		while(src.cant_react > 0 && duration > 0)
			duration--
			sleep(1)

		if(src.cant_react)
			src.end_reaction_stun()

	proc/begin_reaction_stun()
		src.cant_react++

	proc/end_reaction_stun()
		src.cant_react = max(0, src.cant_react - 1)

	proc/reset_reaction_stun()
		src.cant_react = 0

	proc/timed_stun(var/time)
		set waitfor = 0

		if(src.is_protected())
			return

		src.stun()

		while(time && stunned > 0)
			time = max(time - 1, 0)
			sleep(1)

		end_stun()

	proc/stun()
		if(src.action == global.actions[ACTION_DEFEND])
			src.force_action(ACTION_IDLE)

		stunned++

	proc/end_stun()
		stunned = max(0, stunned - 1)

	proc/reset_stun()
		stunned = 0

	proc/add_move_penalty(var/penalty)
		set waitfor = 0

		if(src.is_protected())
			return

		if(src.action == global.actions[ACTION_RUN])
			src.force_action(ACTION_IDLE)

		if(src.move_penalty)
			src.move_penalty += penalty
			src.refresh_move_delay()
		else
			src.move_penalty = penalty
			src.refresh_move_delay()
			while(src && src.move_penalty)
				if(prob(33))
					src.move_penalty = max(0, src.move_penalty - 5)
					src.refresh_move_delay()
				sleep(10)

	proc/timed_protect(var/duration, var/source = "")
		set waitfor = 0

		src.protect(source)

		while(src && duration)
			duration = max(0, --duration)
			sleep(1)

		if(src)
			src.end_protect()

	proc/protect(var/source)
		src.protected++
		src.protected_source = "[source]"

	proc/end_protect()
		src.protected = max(0, --src.protected)
		if(!src.protected)
			src.protected_source = ""

	proc/is_protected()
		return src.protected || src.action == global.actions[ACTION_KNOCKOUT]

	proc/timed_move_stun(var/time, var/severity = 1)
		set waitfor = 0

		if(src.is_protected()) return

		if(!src.slows)
			src.slows = list()

		if(src.action == global.actions[ACTION_RUN])
			src.force_action(ACTION_IDLE)

		src.move_stun++
		src.slows += severity
		src.refresh_move_delay()

		while(time && move_stun)
			time = max(0, --time)
			sleep(1)

		if(move_stun > 0)
			move_stun = max(0, move_stun - 1)

		src.slows -= severity
		if(!src.slows.len)
			src.slows = null

		src.refresh_move_delay()

	proc/reset_move_stun()
		src.slows = null
		src.move_stun = 0
		src.refresh_move_delay()

	proc/timed_freeze(time)
		set waitfor = 0

		src.frozen += 1

		while(time && frozen > 0)
			time = max(time - 1, 0)
			sleep(1)

		if(src)
			src.frozen -= 1

action
	knockout
		id = ACTION_KNOCKOUT

		begin(character/user)
			..()
			user.knockout()

	attack
		id = ACTION_ATTACK

		can_begin(combatant/user)
			return ..() && world.time >= user.attack_timestamp

		begin(combatant/user)
			..()
			//user.attack_down()
			var/nearest_target = user.nearest_target()
			if(nearest_target)
				if(user.gate >= 4)
					var/within_distance = get_dist(nearest_target, user)
					if(within_distance < 5)
						user.AppearBefore(nearest_target)
						sleep(1)

				user.FaceTowards(nearest_target)

			var/start_timestamp = user.action_timestamp
			user.melee.animation(user)

			var/attack_delay = 4//(src.weapon && user.weapon.weight >= 50) ? 6 : 4
			var/attack_range = 1

			if(user.size_up == 1)
				attack_delay = 15
				attack_range = 2
			else if(user.size_up == 2)
				attack_range = 3
				attack_delay = 30

			if(user.get_move_stun())
				attack_delay += user.get_move_stun()

			var/last_turf = user.loc
			var/iterations = 0
			var/character/attacked

			do
				last_turf = get_step(last_turf, user.dir)
				attacked = locate() in last_turf
			while(++iterations < attack_range && (!attacked || attacked.action == global.actions[ACTION_KNOCKOUT] || attacked.paralysed))

			if(attacked)
				if(user.melee.can_hit(attacked))
					user.melee.hit(attacked, user)

			user.attack_timestamp = world.time + attack_delay

			if(user.running_speed > 4)
				user.running_speed = 4

			user.timed_freeze(1) // Just stop movement briefly.

			if(user.action == user && user.action_timestamp == start_timestamp)
				//src.force_action(ACTION_IDLE)()
				user.force_action(ACTION_IDLE)

	defend
		id = ACTION_DEFEND

		begin(combatant/user)
			..()
			//user.defend_down()
			user.icon_state = "Seal"

		proc/on_movement(combatant/user)
			user.force_action(ACTION_IDLE)

proc/roll_against(var/a, var/d, var/m)
	var/outcome = ((a*rand(5,10))/(d*rand(5,10))) *m
	//var/rank=0
	//critical
	if(outcome >=200)
		.=6  //way dominated
	if(outcome <200 && outcome >=150)
		.=5 //dominated
	if(outcome<150 && outcome>=100)
		.=4 //won
	if(outcome<100 && outcome>=75)
		.=3 //not fully, but hit
	if(outcome<75 && outcome >=50)
		.=2 //skimmed
	if(outcome<50 && outcome >=25)
		.=1 //might have some effect.
	if(outcome <25)
		.=0 //failed roll
	if(.<2)
		var/underdog=rand(1,6)
		if(underdog==6)
			.=4