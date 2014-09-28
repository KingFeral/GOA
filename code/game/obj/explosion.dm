proc/explosion(var/stamina_dmg = 0, var/wound_dmg = 0, var/atom/location, var/mob/user, var/list/params)
	if(!params || !istype(params, /list))
		params = list()

	if(!("distance" in params)) params["distance"] = 4
	if(!("knockback" in params)) params["knockback"] = 0

	var/atom_pool/ap = global.atom_pool
	var/explosion/center/e = ap.get_instance("/explosion/center", /explosion/center)
	e.initialize(arglist(args))


explosion
	parent_type = /obj
	density = 0
	icon = 'icons/explosion2.dmi'

	on_crossed(var/mob/crossed)
		. = ismob(crossed)

	on_uncrossed(var/mob/uncrossed)
		. = ismob(uncrossed)

	center
		var/tmp/stamina_dmg = 0
		var/tmp/wound_dmg = 0
		var/tmp/knockback = 0
		var/tmp/distance = 0
		var/tmp/list/waves = list()
		var/tmp/list/collided
		var/tmp/ignore_owner

		proc/initialize(var/stamina_dmg = 0, var/wound_dmg = 0, var/atom/location, var/mob/user, var/list/params)
			set waitfor = 0
			if(!location || !user)
				return

			src.owner = user
			src.loc = location

			if(!isnull(params))
				for(var/r in params)
					src.vars[r] = params[r]

			src.stamina_dmg = stamina_dmg
			if(owner.skillspassive[TRAP_MASTERY])
				stamina_dmg *= 1 + (0.03 * owner.skillspassive[TRAP_MASTERY])
			src.wound_dmg = wound_dmg

			var/list/all_directions = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
			for(var/d in all_directions)
				var/explosion/wave/w = global.atom_pool.get_instance("explosion_waves", /explosion/wave)
				w.initialize(src, direction = d, distance = src.distance)
				waves += w

			while(waves && waves.len)
				sleep(3)

			global.atom_pool.pool(src, src.pool_name)

		proc/can_collide(mob/hit)
			. = 1
			if(hit in collided)
				return 0
			if(hit == owner && ignore_owner)
				return 0

		proc/collided(var/mob/hit)
			if((stamina_dmg < 1 && wound_dmg < 1) || !can_collide(hit))
				return
			if(hit)
				if(!src.collided)
					src.collided = list()
				hit.Damage(stamina_dmg, wound_dmg, owner, "Explosion")
				hit.Hostile(owner)
				hit.set_icon_state("hurt", 10)
				if(knockback)
					hit.Knockback(knockback, get_dir_adv(src, hit))
				src.collided += hit

		// Handles on crossing events.
		Crossed(var/mob/crossing)
			if(istype(crossing) && can_collide(crossing))
				src.collided(crossing)
			else
				. = ..()

		Uncrossed(var/mob/uncrossing)
			if(istype(uncrossing) && can_collide(uncrossing))
				src.collided(uncrossing)
			else
				. = ..()

		pooled()
			src.stamina_dmg = 0
			src.wound_dmg = 0
			src.knockback = 0
			src.waves = null
			owner = null
			ignore_owner = 0

			if(src.collided)
				src.collided = null

			. = ..()

		unpooled()
			waves = list()
			collided = list()

	wave
		var/tmp/moving
		var/tmp/explosion/center/center
		var/tmp/distance

		proc/begin_movement()
			set waitfor = 0

			if(src.moving)
				return

			src.moving = TRUE

			while(loc != null && src.moving)
				if(!canStep(src, direction = src.dir, collision_layer = COLLIDE_OBJS))
					break
				step(src, src.dir)
				sleep(TICK_LAG*2)

			if(src.loc == null)
				return

			global.atom_pool.pool(src, src.pool_name)

		pooled()
			src.moving = FALSE
			if(center)
				if(center.waves)
					center.waves -= src
				center = null
			src.distance = 0
			. = ..()

		unpooled()
			set waitfor = 0
			sleep(100)
			if(src.loc == null)
				return
			atom_pool.pool(src, pool_name)

		on_crossed(var/mob/crossed)
			. = ..()
			if(. && center.can_collide(crossed))
				src.center.collided(crossed)

		on_uncrossed(var/mob/uncrossed)
			. = ..()
			if(. && center.can_collide(uncrossed))
				src.center.collided(uncrossed)

		Moved()
			var/turf/t = get_step(src, src.dir)
			if(isnull(t))
				global.atom_pool.pool(src, src.pool_name)
				return 0

			for(var/mob/m in view(1, src.loc))
				if(center && center.can_collide(m))
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
				global.atom_pool.pool(src, src.pool_name)

		// Handles on crossing events.
		Crossed(var/mob/crossing)
			if(istype(crossing) && center.can_collide(crossing))
				src.center.collided(crossing)
			else
				. = ..()

		Uncrossed(var/mob/uncrossing)
			if(istype(uncrossing) && center.can_collide(uncrossing))
				src.center.collided(uncrossing)
			else
				. = ..()

		proc/initialize(var/explosion/center/c, var/direction, var/distance)
			if(c)
				src.center = c
				src.loc = c
				src.dir = direction
				src.distance = distance
				src.begin_movement()