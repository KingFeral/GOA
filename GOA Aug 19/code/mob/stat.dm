

stat
	stamina
		id = STAMINA
		value = 3000
		minimum_value = 0
		maximum_value = 1000

		update()
			//debug_msg("UPDATED STAMINA")
			//if(user.client)
			//	global.hud_handler.refresh_hud(user.client, id)

	chakra
		id = CHAKRA
		value = 300
		minimum_value = 0
		maximum_value = 300

		update()
			//debug_msg("UPDATED CHAKRA")
			//if(user.client)
			//	global.hud_handler.refresh_hud(user.client, id)

	wounds
		id = WOUNDS
		value = 0
		minimum_value = 0
		maximum_value = 100

		update()
			//debug_msg("UPDATED WOUNDS")
			//if(user.client)
			//	global.hud_handler.refresh_hud(user.client, id)

stat
	var/id
	var/tmp/value = 0
	var/tmp/minimum_value = 0
	var/tmp/maximum_value = 0
	var/tmp/character/user

	proc/set_value(var/value)
		src.value = value
		src.update()

	proc/set_minimum_value(var/value)
		src.minimum_value = value
		src.update()

	proc/set_maximum_value(var/value)
		src.maximum_value = value
		src.update()

	proc/increase(var/value)
		src.value = min(src.value + value, src.maximum_value)
		src.update()

	proc/decrease(var/value)
		src.value = max(0, src.value - value)
		src.update()

	proc/update()

	New(var/character/user)
		if(user)
			src.user = user
			src.update()

mob
	var/tmp/stat/stamina/stamina
	var/tmp/stat/chakra/chakra
	var/tmp/stat/wounds/wounds

	New()
		src.initialize_stats()
		. = ..()

	proc/initialize_stats()
		src.stamina = new/stat/stamina(src)
		src.chakra = new/stat/chakra(src)
		src.wounds = new/stat/wounds(src)