item/equip/weapon
	projectile
		//var/supply_cost
		var/throw_amount = 1
		var/projectile_state

		use(combatant/user)
			flick("Throw1", user)

		//	user.supplies -= src.supply_cost

			var/character/t = user.nearest_target()
			if(t)
				user.FaceTowards(t)

			//var/angle = t ? get_real_angle(user, t) : dir2angle(user.dir)

			var/spreadx = 0
			var/spready = 0
			if(user.dir & NORTH || user.dir & SOUTH)		spreadx += 1
			if(user.dir & EAST || user.dir &  WEST)			spready += 1

			if(user.dir == SOUTHWEST)
				spready *= -1
			else if(user.dir == NORTHEAST)
				spreadx *= -1

			var/list/mods = list(
				name = name,
				icon = 'media/obj/extras/projectiles.dmi',
				icon_state = projectile_state,
				damage = static_stamina_dmg,
				velocity = 14,
			)

			var/projectile/p = global.atom_pool.get_instance("projectiles", /projectile)
			p.initialize(user.loc, user, mods)

			if(throw_amount >= 3)
				p = global.atom_pool.get_instance("projectiles", /projectile)
				mods["spread_x"] = spreadx * 1
				mods["spread_y"] = spready * 1
				p.initialize(user.loc, user, mods)

				p = global.atom_pool.get_instance("projectiles", /projectile)
				mods["spread_x"] = spreadx * -1
				mods["spread_y"] = spready * -1
				p.initialize(user.loc, user, mods)

			if(throw_amount >= 5)
				p = global.atom_pool.get_instance("projectiles", /projectile)
				mods["spread_x"] = spreadx * 2
				mods["spread_y"] = spready * 2
				p.initialize(user.loc, user, mods)

				p = global.atom_pool.get_instance("projectiles", /projectile)
				mods["spread_x"] = spreadx * -2
				mods["spread_y"] = spready * -2
				p.initialize(user.loc, user, mods)

	/*	can_use(combatant/user)
			. = ..()
			if(.)
				var/temp_supplies = user.supplies - src.supply_cost
				if(temp_supplies < 0)
					Error(user, "You do not have enough supplies ([user.supplies] / [src.supplies])!")
					return 0*/