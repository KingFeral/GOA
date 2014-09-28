

effect
	parent_type = /obj
	layer = EFFECTS_LAYER
	//move_delay = TICK_LAG

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
	e.icon = 'icons/gatesmack.dmi'

	sleep(time)
	global.atom_pool.pool(e, "effects")

proc/smoke_effect(turf/location)
	set waitfor = 0
	if(!location)
		return

	var/effect/e = global.atom_pool.get_instance("/effect", /effect)

	e.loc = location
	e.icon = 'icons/smoke.dmi'

	sleep(8)
	global.atom_pool.pool(e, "effects")

proc/smoke_effect_2(turf/location)
	set waitfor = 0
	if(!location)
		return

	var/effect/e = global.atom_pool.get_instance("/effect", /effect)

	e.loc = location
	e.icon = 'icons/new/smoke.dmi'
	e.icon_state = "1"
	e.pixel_x = -16
	e.pixel_y = -16
	// TODO, format the map.

	sleep(6)
	global.atom_pool.pool(e, "effects")

proc/smoke_effect_3(turf/location)
	set waitfor = 0
	if(!location)
		return

	var/effect/e = global.atom_pool.get_instance("/effect", /effect)

	e.loc = location
	e.icon = 'icons/new/smoke.dmi'
	e.icon_state = "2"
	// TODO, format the map.

	sleep(6)
	global.atom_pool.pool(e, "effects")

proc/smoke_effect_4(turf/location)
	set waitfor = 0
	if(!location)
		return

	var/effect/e = global.atom_pool.get_instance("/effect", /effect)

	e.loc = location
	e.icon = 'icons/new/smoke.dmi'
	e.icon_state = "3"
	// TODO, format the map.

	sleep(6)
	global.atom_pool.pool(e, "effects")

/*
proc/appear_effect(turf/location, style)
	set waitfor = 0
	if(!location)
		return

	var/effect/e = global.atom_pool.get_instance("/effect", /effect)

	e.loc = location
	e.icon = 'media/skill/basic/appear.dmi'
	if(style == "body_flicker")
		e.icon_state = "[style]"
	else
		e.icon_state = "speed"

	sleep(3)
	global.atom_pool.pool(e, "/effect")

proc/combat_graphic(var/graphic, var/atom/location)
	set waitfor = 0

	if(!location)
		return 0

	location = ischaracter(location) || isobj(location) ? location:loc : location

	var/atom_pool/ap = global.atom_pool
	var/effect/e = ap.get_instance("effects", /effect)

	e.icon = 'media/obj/extra/combat_graphic.dmi'
	e.icon_state = graphic
	e.loc = location
	e.pixel_x = -16
	e.pixel_y = -16
	animate(e, pixel_y = 24, alpha = 10, time = 10, loop = 1)
	sleep(10)
	animate(e)
	ap.pool(e, "/effect")

proc/gentle_fist_effect(var/character/user, var/variation = 1)
	set waitfor = 0
	if(!user || !user.loc)
		return

	var/effect/e = global.atom_pool.get_instance("/effect", /effect)

	e.loc = user.loc
	if(variation == 1)
		e.icon = 'media/obj/extra/gentle_fist_hit_1.dmi'
	else
		e.icon = 'media/obj/extra/gentle_fist_hit_2.dmi'

	e.icon_state = "[rand(1, 4)]"

	e.pixel_x = rand(-6, 6)
	e.pixel_y = rand(-6, 6)

	sleep(4)
	global.atom_pool.pool(e, "/effect")*/

proc/punch_effect(var/mob/user, var/xoff, var/yoff)
	set waitfor = 0
	if(!user || !user.loc)
		return

	var/effect/e = global.atom_pool.get_instance("/effect", /effect)

	e.loc = user.loc
	e.icon = 'icons/twack.dmi'

	e.pixel_x = 0 + xoff
	e.pixel_y = 0 + yoff

	sleep(5)
	global.atom_pool.pool(e, "/effect")

proc/blood_effect(var/mob/user, var/mob/attacker)
	set waitfor = 0

	if(!user || !user.loc)
		return

	var/effect/e = global.atom_pool.get_instance("/effect", /effect)

	e.loc = user.loc

	var/pk = 0
	for(var/area/O in orange(0, user))
		if(!O.safe)
			pk = 1
	if(pk)
		e.owner = user

		if(attacker && attacker.clan == "Jashin")
			attacker.Blood_Add(user)

	//e.step_x = user.step_x
	//e.step_y = user.step_y

	e.layer = MOB_LAYER + 0.1

	e.icon = 'icons/blood.dmi'
	e.icon_state = "[rand(1, 7)]"
	sleep(6)
	e.icon_state = "l[e.icon_state]"
	e.layer = TURF_LAYER + 0.1

	sleep(600)
	global.atom_pool.pool(e, "/effect")