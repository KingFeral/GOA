skill/clan/akimichi
	pills
		default_cooldown = 5

		var/level
		var/duration

		IsUsable(combatant/user)
			. = ..()
			if(.)
				if(user.gate)
					Error(user, "An incompatible skill (Gates) is active.")
					return 0
				if(user.pill)
					if(user.pill >= level)
						Error(user, "You already have a pill of equal or normal power active!")
						return 0

		Use(combatant/user)
			set waitfor = 0
			if(user.strength.has_buff("pills"))
				user.strength.remove_buff("pills")
			if(user.control.has_buff("pills"))
				user.control.remove_buff("pills")

			var/strboost
			var/conboost
			switch(level)
				if(1)
					oviewers(user) << output("[user] ate a green pill!", "combat.output")
					user.combat_message("You ate the Spinach Pill! Your strength is greatly enhanced, but the strain on your body will cause damage.")
					strboost = user.strength.value * 0.3
					conboost = user.control.value * 0.3
				if(2)
					oviewers(user) << output("[user] ate a yellow pill!", "combat.output")
					user.combat_message("You ate the Curry Pill! You have gained super human strength and a great resistance to damage. However, the strain on your body is immense!")
					strboost = user.strength.value * 0.6
					conboost = user.control.value * 0.6
					user.add_appearance(new/image(icon = 'media/jutsu/clan/akimichi/chakra_shroud.dmi', layer = MOB_LAYER + 0.03), "curry_pill")
				if(3)
					oviewers(user) << output("[user] ate a red pill!", "combat.output")

			user.strength.add_buff("pills", strboost)
			user.control.add_buff("pills", conboost)
			user.pill = level

			var/pill_on_start = user.pill
			var/pill_stress = 10
			if(user.pill >= 2) pill_stress += 10
			if(user.pill >= 3) pill_stress += 20

			duration = (10 * 60 * 5) / 10
			while(duration > 0 && user && user.pill == pill_on_start)
				if(prob(pill_stress))
					user.take_damage(0, 1, source = "Pills Stress", class = "internal")
				sleep(10)

				duration -= 1

			if(user && user.pill == pill_on_start)
				user.strength.remove_buff("pills")
				user.control.remove_buff("pills")
				if(user.pill == 2)
					user.remove_appearance("curry_pill")

				user.pill = 0

				src.DoCooldown(user, pretime = 60)

		spinach
			id = SPINACH_PILL
			name = "Spinach Pill"
			icon_state = "spinach"
			level = 1

		curry
			id = CURRY_PILL
			name = "Curry Pill"
			icon_state = "curry"
			level = 2

	size_up_1
		id = SIZE_MULTIPLICATION
		name = "Size Multiplication"
		icon_state = "sizeup1"
		default_chakra_cost = 400
		default_cooldown = 150

		IsUsable(combatant/user)
			. = ..()
			if(.)
				if(user.gate)
					Error(user, "An incompatible skill (Gates) is active.")
					return 0
				if(user.size_up && user.size_up != 1)
					Error(user, "Size Multiplication is already active!")
					return 0

		ChakraCost(combatant/user)
			if(!user.size_up)
				return ..(user)
			else
				return 0

		Cooldown(combatant/user)
			if(!user.size_up)
				return ..(user)
			else
				return 0

		Use(combatant/user)
			if(user.size_up == 1)
				user.size_up = 0
				user.transform = null
				user.strength.remove_buff("size_up_1")
				if(user.running_speed > 4)
					user.running_speed = 4
				user.melee = global.melees[BASIC]

				ChangeIconState("sizeup1")
				Remove_Selected()
				DoCooldown(user)
			else

				user.icon_state = "Seal"
				user.stun()
				sleep(10)
				if(!user || user.action == global.actions[ACTION_KNOCKOUT])
					return
				var/matrix/m = new
				m.Scale(2)
				user.transform = m
				user.strength.add_buff("size_up_1", user.strength.value * 0.2)
				user.size_up = 1
				user.melee = global.melees[SIZE_MULTIPLICATION]
				user.refresh_move_delay()
				sleep(10)
				if(!user || user.action == global.actions[ACTION_KNOCKOUT])
					return
				//user.icon_state = ""
				user.running_speed = 0
				user.force_action(ACTION_IDLE)
				user.end_stun()

				ChangeIconState("sizedown")
				Add_Selected()

	size_up_2
		id = SUPER_SIZE_MULTIPLICATION
		name = "Super Size Multiplication"
		icon_state = "sizeup2"
		default_chakra_cost = 600
		default_cooldown = 300

		IsUsable(combatant/user)
			. = ..()
			if(.)
				if(user.gate)
					Error(user, "An incompatible skill (Gates) is active.")
					return 0
				if(user.size_up && user.size_up != 2)
					var/skill/sizeup1 = user.GetSkill(SIZE_MULTIPLICATION)
					if(sizeup1)
						sizeup1.Use(user)

		ChakraCost(combatant/user)
			if(!user.size_up)
				return ..(user)
			else
				return 0

		Cooldown(combatant/user)
			if(!user.size_up)
				return ..(user)
			else
				return 0

		Use(combatant/user)
			if(user.size_up == 2)
				user.size_up = 0
				user.transform = null
				user.strength.remove_buff("size_up_2")
				if(user.running_speed > 4)
					user.running_speed = 4
				user.melee = global.melees[BASIC]

				ChangeIconState("sizeup2")
				Remove_Selected()
				DoCooldown(user)
			else
				user.icon_state = "Seal"
				user.stun()
				sleep(10)
				if(!user || user.action == global.actions[ACTION_KNOCKOUT])
					return
				var/matrix/m = new
				m.Scale(3)
				user.transform = m
				user.strength.add_buff("size_up_2", user.strength.value * 0.3)
				user.size_up = 2
				user.melee = global.melees[SUPER_SIZE_MULTIPLICATION]
				user.refresh_move_delay()
				sleep(10)
				if(!user || user.action == global.actions[ACTION_KNOCKOUT])
					return
				//user.icon_state = ""
				user.running_speed = 0
				user.force_action(ACTION_IDLE)
				user.end_stun()

				ChangeIconState("sizedown")
				Add_Selected()

	meat_tank
		id = MEAT_TANK
		name = "Human Bullet Tank"
		icon_state = "meattank"
		default_chakra_cost = 300
		default_cooldown = 30

		Cooldown(combatant/user)
			if(!user.meat_tank)
				return ..(user)
			else
				return 0

		IsUsable(combatant/user)
			. = ..()
			if(.)
				if(user.size_up)
					Error(user, "An incompatible skill is active.")
					return 0

		Use(combatant/user)
			if(user.meat_tank)
				user.meat_tank = 0

				src.RemoveOverlay(CANCEL_SKILL_OVERLAY)
				src.Remove_Selected()
				src.DoCooldown(user)

				user.affirm_icon()
				user.remove_appearance("meat_tank")
				user.load_overlays()
			else
				//if(user.gate)
				//	user.combat("[src] closes the gates.")
				//	user.CloseGates()
				src.AddOverlay(CANCEL_SKILL_OVERLAY)
				src.Add_Selected()
				user.overlays = 0
				user.icon = 0
				user.meat_tank = 1
				user.refresh_move_delay()
				user.add_appearance(new/image(icon = 'media/jutsu/clan/akimichi/meat_tank.dmi', pixel_x = -16, pixel_y = -16), "meat_tank")

				var/tanklength = 200
				while(user && user.action != global.actions[ACTION_KNOCKOUT] && !user.asleep && user.meat_tank && tanklength>0)
					step(user,user.dir)

					sleep(user.move_delay)

					tanklength--
					//user.CombatFlag("offense")

				if(user && user.meat_tank)
					user.meat_tank = 0
					user.refresh_move_delay()
					user.force_action()
					user.remove_appearance("meat_tank")
					src.DoCooldown(user)
					src.Remove_Selected()
					user.affirm_icon()
					user.load_overlays()

melee/taijutsu
	size_up_1
		name = "Giant Fist"
		id = SIZE_MULTIPLICATION

		get_stamina_dmg(combatant/user)
			. = user.strength.get_value() * pick(1.25, 1.50, 1.75, 2)

		hit(var/character/attacked, var/combatant/attacker)
			if(!attacked || !attacker)
				return

			gate_smack_effect(attacked.loc)
			attacked.take_damage(get_stamina_dmg(attacker), 0, attacker, source = name)
			attacked.Earthquake(5)
			attacked.add_move_penalty(10)
			if(attacker)
				attacker.pixel_x = 0
				attacker.pixel_y = 0
			if(attacked)
				attacked.pixel_x = 0
				attacked.pixel_y = 0
			attacked.knockback(rand(5, 10), attacker.dir)

		combo()

	size_up_2
		name = "Super-sized Fist"
		id = SUPER_SIZE_MULTIPLICATION

		get_stamina_dmg(combatant/user)
			. = rand(user.strength.get_value() * 2, user.strength.get_value()* 4)

		hit(var/character/attacked, var/combatant/attacker)
			if(!attacked || !attacker)
				return

			gate_smack_effect(attacked.loc)
			attacked.take_damage(get_stamina_dmg(attacker), 0, attacker, source = name)
			attacked.Earthquake(5)
			attacked.add_move_penalty(10)
			if(attacker)
				attacker.pixel_x = 0
				attacker.pixel_y = 0
			if(attacked)
				attacked.pixel_x = 0
				attacked.pixel_y = 0
			attacked.knockback(rand(5, 10), attacker.dir)

		combo()

character
	Bumped(combatant/bumped_me)
		if(istype(bumped_me))
			if(bumped_me.meat_tank)
				bumped_me.meat_tank(src)
		else
			return ..()

mob
	var/tmp/size_up
	var/tmp/meat_tank
	var/tmp/pill

	proc/meat_tank(character/hit)
		set waitfor = 0

		if(!hit.is_protected())
			gate_smack_effect(hit.loc,5)
			var/stamina_dmg = (src.strength.get_value()) * rand(1, 3) + 400
			hit.take_damage(stamina_dmg, 0, src, source = "Meat Tank")
			if(!hit.meat_tank)
				//hit.loc = src.loc
				hit.Move(src.loc)
				hit.knockback(rand(5,10), turn(src.dir, 180))
			else
				hit.knockback(rand(5,10), src.dir)