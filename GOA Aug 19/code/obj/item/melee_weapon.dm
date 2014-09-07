item/equip
	weapon
		equip_slot = "weapon"

		var/weapon_type
		var/static_stamina_dmg
		var/cooldown = 1

		proc/use(combatant/user)

		melee
			var/list/stat_dmg
			var/list/stat_mult
			var/woundmod = 0
			var/self_stun = 5

			use(combatant/user)
				flick("w-attack", user)

				var/character/targ = user.nearest_target()
				if(targ)
					user.FaceTowards(targ)

				if(src.self_stun)
					user.timed_stun(src.self_stun)

				var/character/m = locate() in get_step(user, user.dir)
				if(!m || m.action == global.actions[ACTION_KNOCKOUT])
					return

				var/stamina_dmg = 0
				var/wound_dmg = 0

				stamina_dmg += src.static_stamina_dmg
				if(src.stat_dmg)
					for(var/stat in src.stat_dmg)
						var/attribute/attrobj = user.vars[stat]
						var/stat_multiplier = (src.stat_mult && (stat in src.stat_mult)) ? src.stat_mult[stat] : 1
						stamina_dmg += round(attrobj.get_value() * stat_multiplier)

				stamina_dmg *= 1 + 0.06 * user.passives[WEAPON_MASTERY]
				stamina_dmg *= pick(0.6, 0.7, 0.8, 0.9, 1)

				var/bleed = 0
				if(src.weapon_type == "knife" || src.weapon_type == "sword")
					if(prob(user.passives[OPEN_WOUNDS] * 3))
						bleed = rand(2, 5)
						wound_dmg += rand(0, 3)

					var/reflex_roll = roll_against(user.reflex.get_value(), m.reflex.get_value(), 100)
					if(reflex_roll > 3)
						if(src.weapon_type == "knife")
							wound_dmg += 1
						else
							wound_dmg += round(0.5 * (rand(src.woundmod / 3, round(src.woundmod / 1.5))))

						if(bleed)
							bleed *= 2

				if(m)
					m.take_damage(stamina_dmg, wound_dmg, user, source = name)

					if(!m.icon_state)
						flick("hurt", m)

					if(bleed)
						m.rend(bleed, user)

		proc/can_use(combatant/user)
			. = user.can_move() && !user.cant_react && world.time >= user.weapon_timestamp

		proc/set_cooldown(combatant/user)
			user.weapon_timestamp = world.time + cooldown * 10

character
	var/tmp/weapon_timestamp = 0