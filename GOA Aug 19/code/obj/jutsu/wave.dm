obj/jutsu/wave
	move_delay = 0.75 // TICK_LAG * 3
	var/tmp/radius = 1
	var/tmp/distance = 0
	var/tmp/list/children = list()
	var/tmp/list/collided = list()
	var/tmp/obj/jutsu/parent

	pooled()
		children = null
		collided = null
		radius = initial(radius)
		distance = 0
		parent = null
		. = ..()

	can_collide(character/collided)
		if(collided == owner)
			return 0
		else if(collided.name in src.collided)
			return 0
		else
			return 1

	collide(character/collided)
		if(parent)
			return parent.collide(collided)

		if(isnull(src.collided))
			src.collided = list()

		if(src.can_collide(collided))
			src.collided += collided.name
			collided.take_damage(stamina_dmg, wound_dmg, owner, source = name)
			if(knockback)
				collided.knockback(knockback, dir ? dir : owner.dir)

			if(daze)
				if(prob(daze))
					combat_graphic("daze", collided)
					collided.timed_stun(30)

			if(poison)
				collided.poison += poison

	start_life()
		set waitfor = 0

		for(var/obj/jutsu/wave/w in children)
			walk(w, w.dir, w.move_delay)

		walk(src, src.dir, src.move_delay)

	Move()
		. = ..()
		if(. && distance > 0)
			distance -= 1
		else
			global.atom_pool.pool(src, src.pool_name)
	/*	distance -= 1
		if(distance > 0)
			. = ..()
		else
			global.atom_pool.pool(src, src.pool_name)*/

	initialize(turf/location, direction, amount, combatant/user, list/mods)
		mods["loc"] = location
		mods["dir"] = direction
		mods["owner"] = user
		src.mod(mods)

		var/xoffset = 0
		var/yoffset = 0

		if(dir & NORTH || dir & SOUTH)
			xoffset = 1
		else if(dir & EAST || dir & WEST)
			yoffset = 1

		var/next_x_top = x + xoffset
		var/next_y_top = y + yoffset

		var/next_x_bottom = x - xoffset
		var/next_y_bottom = y - yoffset

		var/obj/jutsu/wave/j = null

		mods["parent"] = src

		children = list()
		for(var/i in 1 to amount) // null?
			j = global.atom_pool.get_instance(src.pool_name, src.pool_type)
			mods["loc"] = locate(next_x_top, next_y_top, location.z)
			mods["dir"] = direction
			j.mod(mods)
			//j.owner = user
			children += j

			j = global.atom_pool.get_instance(src.pool_name, src.pool_type)
			mods["loc"] = locate(next_x_bottom, next_y_bottom, location.z)
			mods["dir"] = direction
			j.mod(mods)
			//j.owner = user
			children += j

			next_x_top += xoffset
			next_y_top += yoffset
			next_x_bottom -= xoffset
			next_y_bottom -= yoffset


proc/wave(wave_pool, wave_path, turf/location, dir, amount, combatant/user, list/mods)
	set waitfor = 0

	if(!wave_path || amount < 1 || !user || !mods)
		return

	var/obj/jutsu/wave/j = global.atom_pool.get_instance(wave_pool, wave_path)
	if(!j)
		return
	j.initialize(location, dir, amount, user, mods)
	j.start_life()

	mods = null