proc/explosion(var/stamina_dmg = 0, var/wound_dmg = 0, var/atom/location, var/combatant/user, var/list/params)
	if(isnull(params))
		params = list()

	if(!("distance" in params)) params["distance"] = 4
	if(!("knockback" in params)) params["knockback"] = 0

	var/atom_pool/ap = global.atom_pool
	var/explosion/center/e = ap.get_instance("explosion", /explosion/center)
	e.initialize(arglist(args))

explosion
	parent_type = /obj
	density = 0
	icon = 'media/obj/extras/explosion.dmi'

	on_crossed(var/character/crossed)
		. = ischaracter(crossed)

	on_uncrossed(var/character/uncrossed)
		. = ischaracter(uncrossed)

	center
		var/tmp/stamina_dmg = 0
		var/tmp/wound_dmg = 0
		var/tmp/knockback = 0
		var/tmp/distance = 0
		var/tmp/character/owner
		var/tmp/list/waves = list()
		var/tmp/list/collided
		var/tmp/ignore_owner

		proc/initialize(var/stamina_dmg = 0, var/wound_dmg = 0, var/atom/location, var/combatant/user, var/list/params)
			if(!location || !user)
				return

			src.owner = user
			src.loc = location

			if(!isnull(params))
				for(var/r in params)
					src.vars[r] = params[r]

			src.stamina_dmg = stamina_dmg
			src.wound_dmg = wound_dmg

			var/list/all_directions = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
			for(var/d in all_directions)
				var/explosion/wave/w = global.atom_pool.get_instance("explosion_waves", /explosion/wave)
				w.initialize(src, direction = d, distance = src.distance)

		proc/collided(var/character/collided)
			if(!knockback)
				return 0

			if(collided)
				if(collided == src.owner && src.ignore_owner)
					return 0
				if(isnull(src.collided))
					src.collided = list()
				if(!(collided in src.collided))
					collided.take_damage(stamina_dmg, wound_dmg, owner, "Explosion")
					if(knockback)
						collided.knockback(knockback, get_dir_adv(src, collided))
					src.collided += collided

		// Handles on crossing events.
		Crossed(var/character/crossing)
			if(istype(crossing))
				src.collided(crossing)
			else
				. = ..()

		Uncrossed(var/character/uncrossing)
			if(istype(uncrossing))
				src.collided(uncrossing)
			else
				. = ..()

		pooled()
			src.stamina_dmg = 0
			src.wound_dmg = 0
			src.knockback = 0
			src.waves = null

			if(src.collided)
				for(var/character/m in src.collided)
					if(m.icon_state == "hurt")
						m.icon_state = ""
				src.collided = null

			. = ..()

	wave
		var/tmp/moving
		var/tmp/explosion/center/center
		var/tmp/distance

		proc/begin_movement()
			set waitfor = 0

			if(src.moving)
				return

			src.moving = TRUE

			while(src.moving)
				step(src, src.dir)
				sleep(TICK_LAG)

			if(src.loc == null)
				return

			global.atom_pool.pool(src, "explosion_waves")

		pooled()
			src.moving = FALSE
			src.center = null
			src.distance = 0
			. = ..()

		on_crossed(var/character/crossed)
			. = ..()
			if(.)
				src.center.collided(crossed)

		on_uncrossed(var/character/uncrossed)
			. = ..()
			if(.)
				src.center.collided(uncrossed)

		Moved()
			var/turf/t = get_step(src, src.dir)
			if(isnull(t))
				global.atom_pool.pool(src, "explosion_waves")
				return 0

			for(var/character/m in view(1, src.loc))
				src.center.collided(m)

			if(distance > 0)
				distance -= 1
				if(distance >= 3)
					icon_state = "1"
				else if(distance >= 2)
					icon_state = "2"
				else
					icon_state = "3"
			else
				global.atom_pool.pool(src, "explosion_waves")

		// Handles on crossing events.
		Crossed(var/character/crossing)
			if(istype(crossing))
				src.center.collided(crossing)
			else
				. = ..()

		Uncrossed(var/character/uncrossing)
			if(istype(uncrossing))
				src.center.collided(uncrossing)
			else
				. = ..()

		New(var/explosion/center/c, var/direction)
			..()

		proc/initialize(var/explosion/center/c, var/direction, var/distance)
			if(c)
				src.center = c
				src.loc = c
				src.dir = direction
				src.distance = distance
				src.begin_movement()