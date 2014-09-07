proc/Trail_Homing_Projectile(dx, dy, dz, xdir, obj/jutsu/trailmaker/proj, xdur, character/M, dontdelete, hitinnocent, modx, mody, lag=0, mob/U)
	if(M)
		proj.loc = locate(dx, dy, dz)
		proj.dir = xdir
		var/i = xdur
		proj.density = 0

		if(modx == -1)
			proj.dir = WEST
		else if(modx==1)
			proj.dir=EAST
		if(mody==-1)
			proj.dir |= SOUTH
		else if(mody==1)
			proj.dir |= NORTH

		if(modx || mody)
			step(proj, proj.dir)
			sleep(1)
			step(proj, proj.dir)
			sleep(3)

		proj.density = 1
		var/mob/hit
		while(M && proj && i > 0 && !hit)
			proj.dir = angle2dir(get_real_angle(proj, M))

			var/hit_human = 0
			for(var/character/R in get_step(proj, proj.dir))
				if(R)
					hit_human = 1
					R.timed_move_stun(10)

			if(hit_human)
				proj.density = 0

			step(proj, proj.dir)

			if(hit_human)
				proj.density = 1

			for(var/character/F in proj.loc)
				if(F == M || (hitinnocent && F != U))
					hit = F
					break

			sleep(1+lag)
			i--

		if(hit)
			return hit
	global.atom_pool.pool(proj, proj.pool_name)
	return 0

proc/Trail_Straight_Projectile(dx, dy, dz, xdir, obj/jutsu/trailmaker/proj, xdur, character/maker)
	proj.loc = locate(dx, dy, dz)
	proj.dir = xdir
	proj.owner = maker
	var/i = xdur
	var/mob/hit
	while(proj && i > 0 && !hit)
		var/will_hit = 0
		for(var/character/R in get_step(proj, proj.dir))
			if(R)
				will_hit = 1
				R.timed_move_stun(10)
		if(proj)
			if(will_hit)
				proj.density = 0
			if(step(proj, proj.dir))
				if(will_hit)
					proj.density = 1
				for(var/character/F in proj.loc)
					if(F != maker && !F.is_protected() && F.action != global.actions[ACTION_KNOCKOUT])
						hit = F
						break
			else
				proj.dispose()
			sleep(1)
			i--
	if(hit)
		return hit
	else
		if(proj)
			global.atom_pool.pool(proj, proj.pool_name)
		return 0

obj
	trail
		watertrail
			layer = MOB_LAYER+2
			icon = 'media/jutsu/elemental/water/water_dragon_trail.dmi'
		shadowtrail
			layer = OBJ_LAYER
			icon = 'media/jutsu/clan/nara/shadow_trail.dmi'
		shadowtrail2
			layer = OBJ_LAYER
			icon = 'media/jutsu/clan/nara/shadow_trail2.dmi'
		falsedarknesstrail
			layer = OBJ_LAYER
			icon = 'media/jutsu/elemental/lightning/false_darkness.dmi'

obj/jutsu/trailmaker
	density = 1
	var/tmp/list/trails = list()
	var/tmp/character/target
	var/tmp/first

	pooled()
		for(var/atom/movable/t in trails)
			t.dispose()
			trails -= t
		target = null
		first  = 0
		trails = null
		. = ..()

	unpooled()
		trails = list()
		. = ..()