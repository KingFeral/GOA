obj/jutsu
	density = 0
	move_delay = 1
	var/tmp/combatant/owner
	var/tmp/pool_name
	var/tmp/pool_type
	var/tmp/stamina_dmg = 0
	var/tmp/wound_dmg = 0
	var/tmp/knockback = 0
	var/tmp/daze = 0
	var/tmp/poison = 0

	proc/initialize()

	proc/can_collide(character/obstacle)
		if(obstacle == owner)
			return 0
		if(obstacle.is_protected())
			return 0
		return 1

	proc/collide(character/collided)
		if(src.can_collide(collided))
			if(stamina_dmg || wound_dmg)
				collided.take_damage(stamina_dmg, wound_dmg, owner, source = name)
			if(knockback)
				collided.knockback(knockback, dir ? dir : owner.dir)

			if(daze)
				if(prob(daze))
					combat_graphic("daze", collided)
					collided.timed_stun(30)

			if(poison)
				collided.poison += poison

	proc/start_life()

	on_crossed(character/crossed)
		if(!ischaracter(crossed))
			return ..()

		collide(crossed)

	Moved()
		set waitfor = 0
		..()
		var/turf/t = get_step(src, src.dir)
		if(!t || !t.Enter(src))
			sleep(TICK_LAG * 3)
			src.dispose()
			return 0

	Bump(character/collided)
		if(ischaracter(collided))
			collide(collided)

	Bumped(character/collided)
		if(!ischaracter(collided))
			return ..()

		collide(collided)

	pooled()
		owner = null
		stamina_dmg = 0
		wound_dmg = 0
		knockback = 0
		daze = 0
		poison = 0
		move_delay = initial(move_delay)
		density = initial(density)
		. = ..()

	proc/mod(list/modifications)
		for(var/m in modifications)
			if(m in vars)
				vars[m] = modifications[m]

	New(location, combatant/user, list/params)
		. = ..()

		if(user)
			owner = user

		if(params)
			mod(params)