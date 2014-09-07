

effect
	parent_type = /obj
	layer = EFFECTS_LAYER
	//move_delay = TICK_LAG

	var/tmp/character/owner

	pooled()
		icon = null
		icon_state = null
		overlays = null
		underlays = null

		pixel_x = 0
		pixel_y = 0

		layer = EFFECTS_LAYER

		alpha = 255

		if(owner)
			owner = null

		//src.move_delay = 1

		. = ..()

proc/gate_smack_effect(turf/location,time=10)
	set waitfor = 0
	if(!location)
		return

	var/effect/e = global.atom_pool.get_instance("effects", /effect)

	e.loc = location
	e.icon = 'media/obj/extras/gatesmack.dmi'

	sleep(time)
	global.atom_pool.pool(e, "effects")

proc/smoke_effect(turf/location)
	set waitfor = 0
	if(!location)
		return

	var/effect/e = global.atom_pool.get_instance("effects", /effect)

	e.loc = location
	e.icon = 'media/obj/extras/smoke.dmi'

	sleep(8)
	global.atom_pool.pool(e, "effects")

proc/appear_effect(turf/location, style)
	set waitfor = 0
	if(!location)
		return

	var/effect/e = global.atom_pool.get_instance("effects", /effect)

	e.loc = location
	e.icon = 'media/jutsu/general/appear.dmi'
	if(style == "body_flicker")
		e.icon_state = "[style]"
	else
		e.icon_state = "speed"

	sleep(3)
	global.atom_pool.pool(e, "effects")

proc/combat_graphic(var/graphic, var/atom/location)
	set waitfor = 0

	if(!location)
		return 0

	location = ischaracter(location) || isobj(location) ? location:loc : location

	var/atom_pool/ap = global.atom_pool
	var/effect/e = ap.get_instance("effects", /effect)

	e.icon = 'media/obj/extras/combat_graphic.dmi'
	e.icon_state = graphic
	e.loc = location
	e.pixel_x = -16
	e.pixel_y = -16
	animate(e, pixel_y = 24, alpha = 10, time = 10, loop = 1)
	sleep(10)
	animate(e)
	ap.pool(e, "effects")

proc/gentle_fist_effect(var/character/user, var/variation = 1)
	set waitfor = 0
	if(!user || !user.loc)
		return

	var/effect/e = global.atom_pool.get_instance("effects", /effect)

	e.loc = user.loc
	if(variation == 1)
		e.icon = 'media/obj/extras/gentle_fist_hit_1.dmi'
	else
		e.icon = 'media/obj/extras/gentle_fist_hit_2.dmi'

	e.icon_state = "[rand(1, 4)]"

	e.pixel_x = rand(-6, 6)
	e.pixel_y = rand(-6, 6)

	sleep(4)
	global.atom_pool.pool(e, "effects")

proc/punch_effect(var/character/user, var/xoff, var/yoff)
	set waitfor = 0
	if(!user || !user.loc)
		return

	var/effect/e = global.atom_pool.get_instance("effects", /effect)

	e.loc = user.loc
	e.icon = 'media/obj/extras/hit.dmi'

	e.pixel_x = rand(-6, 6) + xoff
	e.pixel_y = rand(-6, 6) + yoff

	sleep(5)
	global.atom_pool.pool(e, "effects")

proc/blood_effect(var/character/user, var/combatant/attacker)
	set waitfor = 0

	if(!user || !user.loc)
		return

	var/effect/e = global.atom_pool.get_instance("effects", /effect)

	e.loc = user.loc
	e.owner = user

	//e.step_x = user.step_x
	//e.step_y = user.step_y

	e.layer = MOB_LAYER + 0.1

	e.icon = 'media/obj/extras/blood.dmi'
	e.icon_state = "[rand(1, 7)]"
	sleep(6)
	e.icon_state = "l[e.icon_state]"
	e.layer = TURF_LAYER + 0.1

	sleep(600)
	global.atom_pool.pool(e, "effects")