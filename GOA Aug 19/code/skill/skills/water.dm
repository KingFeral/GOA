skill/elemental/water
	giant_water_colliding_wave
		icon_state = "exploading_water_shockwave"
		name = "Water: Giant Water Colliding Waves"
		id = WATER_GIANT_WATER_COLLIDING_WAVE
		default_seal_time = 10
		default_cooldown = 1//180
		base_charge = 150
		max_charge = 3000

		Use(combatant/user)
			user.icon_state = "Seal"
			user.stun()

			if(charge)
				var/conmult = user.ControlDamageMultiplier()
				var/list/mods = list(
					"stamina_dmg" = ((charge *  0.4) * conmult) * 0.6 + 2000,
					"wound_dmg"   = rand(charge / 250, charge / 160),
					"radius"      = round((charge) / 100),
					"knockback"   = 3,
					"daze"		  = 50,
					"distance"    = round(charge / 100),

				)
				var/reach =  round(charge / 100)// * 10
				var/list/directions = list(1, 2, 4, 8, 5, 6, 9, 10)

				for(var/d in directions) spawn
					var/obj/jutsu/trailmaker/water_wave/o = global.atom_pool.get_instance("water_wave_trailmaker", /obj/jutsu/trailmaker/water_wave)
					o.mod(mods)
					Trail_Straight_Projectile(user.x, user.y, user.z, d, o, reach, user)

				Wet(user.x, user.y, user.z, user.dir, 1, 900, user = user)

				sleep(10)

				if(user)
					if(user.icon_state == "Seal")
						user.icon_state = ""
					user.end_stun()

	grand_waterfall_technique
		icon_state = "giant_vortex"
		name = "Grand Waterfall Technique"
		id = WATER_GRAND_WATERFALL
		default_chakra_cost = 10
		default_seal_time = 5
		face_nearest = TRUE

		SealTime(combatant/user)
			. = ..()
			if(.)
				if(user.on_water())
					. = max(0, . - 3)

		Use(combatant/user)
			user.stun()

			viewers(user) << output("[user]: Water: Grand Waterfall Technique!", "combat.output")

			var/conmult = user.ControlDamageMultiplier()

			if(!user.on_water)
				user.timed_stun(5)

			if(user.dir == NORTHEAST || user.dir == SOUTHEAST)
				user.dir = EAST
			else if(user.dir == NORTHWEST || user.dir == SOUTHWEST)
				user.dir = WEST

			var/stamina_dmg = (user.control.get_value() * 0.6 + 125 * conmult)

			var/list/mods = list(
				icon = 'media/jutsu/elemental/water/shockwave.dmi',
				move_delay = 0.75,
				knockback  = 1,
				stamina_dmg = stamina_dmg,
				distance = 10,
				wave_type = "water",
				owner = user,
			)

			wave("water_waves", /obj/jutsu/wave/water, user.loc, user.dir, 2, user, mods = mods)

			user.end_stun()

	starch_syrup
		id = WATER_STARCH_SYRUP
		name = "Starch Syrup Capture Field"
		icon_state = "syrup_capture"
		default_seal_time = 3
		default_chakra_cost = 10
		default_cooldown = 1//60
		face_nearest = TRUE

		Use(combatant/user)
			user.stun()

			viewers(user) << output("[user]: Starch Syrup Capture Field!", "combat.output")

			var/conmult = user.ControlDamageMultiplier()

			if(!user.on_water)
				user.timed_stun(5)

			if(user.dir == NORTHEAST || user.dir == SOUTHEAST)
				user.dir = EAST
			else if(user.dir == NORTHWEST || user.dir == SOUTHWEST)
				user.dir = WEST

			var/stamina_dmg = (user.control.get_value() * 0.6 + 125 * conmult)
			var/list/mods = list(
				icon = 'media/jutsu/elemental/water/syrup.dmi',
				move_delay = 0.75,
				stamina_dmg = stamina_dmg,
				distance = 10,
				wave_type = "syrup",
				owner = user,
			)

			wave("syrup_waves", /obj/jutsu/wave/syrup, user.loc, user.dir, 1, user, mods = mods)

			user.end_stun()

	water_dragon_bullet
		icon_state = "water_dragon_blast"
		name = "Water: Water Dragon Bullet"
		id = WATER_WATER_DRAGON
		default_chakra_cost = 10
		default_seal_time = 5

		IsUsable(combatant/user)
			. = ..()
			if(.)
				if(!user.on_water())
					Error(user, "You are not standing on water!")
					return 0

		Use(combatant/user)
			viewers(user) << output("[user]: Water: Water Dragon Projectile!", "combat_output")

			user.stun()
			var/conmult = user.ControlDamageMultiplier()
			var/character/etarget = user.main_target()

			if(etarget)
				var/obj/jutsu/trailmaker/o = global.atom_pool.get_instance("water_dragon", /obj/jutsu/trailmaker/water_dragon)//new/obj/jutsu/trailmaker/water_dragon()
				var/character/result = Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,etarget)
				if(result)
					result.knockback(2, o.dir)
					result.take_damage((1250+1500*conmult), 0, user, source = "Water Dragon")
				sleep(1)
				global.atom_pool.pool(o, o.pool_name)
			else
				var/obj/jutsu/trailmaker/o = global.atom_pool.get_instance("water_dragon", /obj/jutsu/trailmaker/water_dragon)//new/obj/jutsu/trailmaker/water_dragon()
				var/character/result = Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,8)
				if(result)
					result.knockback(2, o.dir)
					result.take_damage((1250+1500*conmult), 0, user, source = "Water Dragon")
				sleep(1)
				global.atom_pool.pool(o, o.pool_name)
			user.end_stun()

obj/jutsu/trailmaker/water_wave
	name = "Water Wave"
	icon = 'media/jutsu/elemental/water/shockwave.dmi'
	pool_name = "water_waves"
	pool_type = /obj/jutsu/wave/water
	density = 0

	var/tmp/radius = 1
	var/tmp/distance = 0

	Move()
		//var/atom/last_loc = loc

		. = ..()

		if(.)
			Wet(src.x, src.y, src.z, src.dir, src.radius, 900, user = src.owner, filter = TRUE)
		else
		//	if(!.)
		//		debug(". returned null")
			src.dispose()

	dispose()
		global.atom_pool.pool(src, src.pool_name)

	Moved()
		//distance -= 1

		for(var/character/c in view(1, src))
			if(can_collide(c))
				collide(c)

	//	if(distance <= 0)
	//		global.atom_pool.pool(src, src.pool_name)

	pooled()
		radius = initial(radius)
		distance = 0
		. = ..()

obj/jutsu/wave/water
	name = "Water Wave"
	icon = 'media/jutsu/elemental/water/shockwave.dmi'
	pool_name = "water_waves"
	pool_type = /obj/jutsu/wave/water

	Move()
		. = ..()
		if(.)
			Wet(src.x, src.y, src.z, src.dir, src.radius, 900, user = src.owner)
		else
			src.dispose()

	dispose()
		global.atom_pool.pool(src, src.pool_name)

obj/water
	icon='media/turf/tile/water.dmi'
	layer=TURF_LAYER+0.1
	density=0
	attributes = list("water")
	var/tmp/character/owner

	Crossed(character/crossed_me)
		if(istype(crossed_me))
			if(!crossed_me.on_water)
				crossed_me.on_water = TRUE
				crossed_me.calculate_stats()
			/*if(crossed_me.chakra.value > 5)
				crossed_me.chakra.decrease(5)
			else if(crossed_me.stamina.value > 25)
				crossed_me.stamina.decrease(25)
			else
				crossed_me.stamina.set_value(0)*/
			if(!crossed_me.regenerating)
				crossed_me.regenerate()

	Uncrossed(character/uncrossed_me)
		if(istype(uncrossed_me))
			uncrossed_me.on_water = 0
			uncrossed_me.calculate_stats()

	dispose()
		for(var/character/c in loc)
			src.Uncrossed(c)
		if(attributes)
			if(loc && loc.attributes)
				loc.remove_attribute(attributes)
		. = ..()

	New()
		set waitfor = 0
		. = ..()
		if(attributes && loc)
			if("sticky" in loc.attributes)
				if("water" in attributes)
					attributes -= "water"
			loc.set_attribute(attributes)
		sleep(5)
		for(var/character/c in loc)
			src.Crossed(c)

	wl
		icon_state="left"
	wr
		icon_state="right"
	wd
		icon_state="down"
	wu
		icon_state="up"
	w0l
		icon_state="left"
	w0r
		icon_state="right"
	w0d
		icon_state="down"
	w0u
		icon_state="up"


// TODO, make these recycle instead of garbage collect!

proc
	Wet_cap(start_x, start_y, start_z, xdir, mag, xdur, sticky, combatant/user)
		set waitfor = 0
		if(xdir & xdir - 1)
			xdir = SOUTH
		var
			side_dx = 0
			side_dy = 0
			water_type
			sides[0]

		switch(xdir)
			if(NORTH)
				side_dx = 1
				if(sticky) water_type = /obj/water/sticky/wu
				else water_type = /obj/water/wu
			if(SOUTH)
				side_dx = 1
				if(sticky) water_type = /obj/water/sticky/wd
				else water_type = /obj/water/wd
			if(EAST)
				side_dy = 1
				if(sticky) water_type = /obj/water/sticky/wr
				else water_type = /obj/water/wr
			if(WEST)
				side_dy = 1
				if(sticky) water_type = /obj/water/sticky/wl
				else water_type = /obj/water/wl
			else
				CRASH("Unsupported xdir ([xdir])")

		sides += new water_type(locate(start_x, start_y, start_z))
		while(mag > 1)
			sides += new water_type(locate(start_x + (mag-1)*side_dx, start_y + (mag-1)*side_dy, start_z))
			sides += new water_type(locate(start_x - (mag-1)*side_dx, start_y - (mag-1)*side_dy, start_z))

			--mag

		for(var/obj/water/w in sides)
			w.owner = user

		sleep(xdur)
		for(var/obj/O in sides)
			O.dispose()

	Wet(start_x, start_y, start_z, xdir, mag, xdur, sticky, combatant/user, filter)
		set waitfor = 0
		if(xdir & xdir - 1)
			xdir = SOUTH
		var
			side_dx = 0
			side_dy = 0
			side_type1
			side_type2
			water_type = /obj/water
			water[0]

		if(sticky) water_type = /obj/water/sticky

		switch(xdir)
			if(NORTH)
				side_dx = 1
				if(sticky)
					side_type1 = /obj/water/sticky/wr
					side_type2 = /obj/water/sticky/wl
				else
					side_type1 = /obj/water/wr
					side_type2 = /obj/water/wl
			if(SOUTH)
				side_dx = 1
				if(sticky)
					side_type1 = /obj/water/sticky/wr
					side_type2 = /obj/water/sticky/wl
				else
					side_type1 = /obj/water/wr
					side_type2 = /obj/water/wl
			if(EAST)
				side_dy = 1
				if(sticky)
					side_type1 = /obj/water/sticky/wu
					side_type2 = /obj/water/sticky/wd
				else
					side_type1 = /obj/water/wu
					side_type2 = /obj/water/wd
			if(WEST)
				side_dy = 1
				if(sticky)
					side_type1 = /obj/water/sticky/wu
					side_type2 = /obj/water/sticky/wd
				else
					side_type1 = /obj/water/wu
					side_type2 = /obj/water/wd
			//else
			//	CRASH("Unsupported xdir ([xdir])")


		if(!filter || (water_type != /obj/water || !(locate(water_type) in locate(start_x, start_y, start_z))))
			water += new water_type(locate(start_x, start_y, start_z))
			water += new side_type1(locate(start_x + mag * side_dx, start_y + mag * side_dy, start_z))
			water += new side_type2(locate(start_x - mag * side_dx, start_y - mag * side_dy, start_z))
			while(mag > 1)
				water += new water_type(locate(start_x + (mag-1)*side_dx, start_y + (mag-1)*side_dy, start_z))
				water += new water_type(locate(start_x - (mag-1)*side_dx, start_y - (mag-1)*side_dy, start_z))

				--mag

			for(var/obj/water/w in water)
				w.owner = user

			sleep(xdur)
			for(var/obj/O in water)
				O.dispose()

obj/jutsu/trailmaker/water_dragon
	icon = 'media/jutsu/elemental/water/water_dragon.dmi'
	pool_name = "water_dragon"
	pool_type = /obj/jutsu/trailmaker/water_dragon

	Move()
		set waitfor = 0
		var/turf/old_loc = src.loc
		var/d = ..()
		if(d)
			var/obj/O = new(old_loc)
			O.dir = src.dir
			var/obj/m = new /obj/trail/watertrail(O)
			m.dir = O.dir
			m.icon_state = "patch"
			var/obj/n = new /obj/trail/watertrail(O)
			n.dir = O.dir
			n.icon_state = "patch"

			var/dir_angle = dir2angle(O.dir)
			var/dir_y = round(sin(dir_angle), 1)
			var/dir_x = round(cos(dir_angle), 1)

			src.pixel_y = 16 * dir_y
			src.pixel_x = 16 * dir_x

			O.pixel_y = 16 * dir_y
			O.pixel_x = 16 * dir_x

			m.pixel_y = -16 * dir_y
			m.pixel_x = -16 * dir_x

			n.pixel_y = 16 * dir_y
			n.pixel_x = 16 * dir_x

			O.underlays += m
			spawn(1) O.underlays += n
			O.icon = 'media/jutsu/elemental/water/water_dragon_trail.dmi'
			src.trails += O
		return d

	pooled()
		var/rdir
		var/list/d = list(NORTHWEST, SOUTHWEST, NORTHEAST, SOUTHEAST)
		for(var/obj/o in src.trails)
			if(o.dir in d)
				rdir = SOUTH
			else
				rdir = o.dir
			Wet(o.x, o.y, o.z, rdir, 1, 900)
			o.loc = null
		. = ..()

obj/jutsu/wave/syrup
	name = "Wave of Starch Syrup"
	icon = 'media/jutsu/elemental/water/syrup.dmi'
	icon_state = "wave"
	pool_name = "syrup_waves"
	pool_type = /obj/jutsu/wave/syrup
	distance = 10
	layer = MOB_LAYER - 0.4

	collide(character/collided)
		if(isnull(src.collided))
			src.collided = list()

		if(src.can_collide(collided))
			src.collided += collided.name
			if(collided.client)
				collided.combat_message("[owner]'s syrup has caught you!")
			if(owner.client)
				owner.combat_message("Your syrup has caught [collided]!")
			if(owner.control.get_value() >= collided.strength.get_value())
				//collided.can_move = FALSE
				collided.syrup(30, owner)
			else
				collided.add_move_penalty(30)

	Move()
		. = ..()
		if(.)
			Wet(src.x, src.y, src.z, src.dir, src.radius, 600, sticky = TRUE, user = src.owner)

obj/water
	sticky
		icon = 'media/jutsu/elemental/water/syrup.dmi'
		layer = MOB_LAYER - 0.5

		Crossed(character/crossed_me)
			if(istype(crossed_me))
				if(crossed_me != owner && !crossed_me.syrup && (!owner.syrup_caught || (!(crossed_me.name in owner.syrup_caught) || world.time >= owner.syrup_caught[crossed_me.name])))
					if(crossed_me.strength.get_value() > owner.control.get_value())
						crossed_me.timed_move_stun(20, severity = 2)
						if(crossed_me.client)
							crossed_me.combat_message("Your feet are sticky with syrup!")
					else
						crossed_me.syrup(30, owner)
						if(crossed_me.client)
							crossed_me.combat_message("You are stuck in sticky syrup!")
					crossed_me.calculate_stats()
				if(!crossed_me.regenerating)
					crossed_me.regenerate()

		Uncrossed(character/uncrossed_me)
			if(istype(uncrossed_me))
				uncrossed_me.syrup = 0

		New()
			if(name == "sticky")
				attributes = list("sticky")
			. = ..()

		wl
			icon_state="left"
		wr
			icon_state="right"
		wd
			icon_state="down"
		wu
			icon_state="up"
		w0l
			icon_state="left"
		w0r
			icon_state="right"
		w0d
			icon_state="down"
		w0u
			icon_state="up"

mob
	var/tmp/syrup
	var/tmp/list/syrup_caught

	proc/syrup(timelimit, combatant/catcher)
		set waitfor = 0
		if(src.syrup)
			return

		if(!catcher.syrup_caught)
			catcher.syrup_caught = list()

		if(catcher.syrup_caught[name] > world.time)
			return

		if(src.client)
			src.combat_message("You have been binded by [catcher ? "[catcher]'s starch syrup" : "by the syrup"]!")

		syrup += 1

		while(timelimit > 0 && syrup)
			timelimit -= 1
			sleep(1)

		if(src)
			src.end_syrup()

		if(catcher) catcher.syrup_caught[name] = world.time + 30

	proc/end_syrup()
		syrup = max(0, syrup - 1)

mob
	var/tmp/on_water

	proc/on_water()
		return src.on_water