

item
	parent_type = /drag_obj

	var/id
	var/description
	var/weight

	equip
		var/equip_slot
		var/list/user_overlays

		proc/macro_activate()
			if(args && args[1])
				equip(args[1])

		proc/equip(character/user)
			for(var/equip in user.equip)
				if(!user.equip[equip]) continue()

				if(user.equip[equip] == src)
					user.equip[equip] = null
					user.remove_appearance(src.id)
					src.overlays -= 'media/obj/extras/Equipped.dmi'
					return

			if(src.equip_slot)
				for(var/item/equip/e in user.contents)
					if(user.equip[src.equip_slot] == e)
						user.equip[src.equip_slot] = null
						user.remove_appearance(e.id)
						e.overlays -= 'media/obj/extras/Equipped.dmi'
						break()

				user.equip[src.equip_slot] = src

			user.add_appearance(src.user_overlays, src.id)

			overlays += 'media/obj/extras/Equipped.dmi'

			. = 1

		Click()
			src.equip(usr)

	New(location, item_id, list/modifications)
		..(location)

		if(item_id)
			src.id = item_id

		if(modifications)
			src.modifications = modifications

		if(item_id)
			var/spawner/s = global.item_spawners[item_id]
			if(isnull(s))
				CRASH("Undefined item_id (`[item_id]`)")
				return 0

			s.build(src)

mob
	var/tmp/armor_count = 0

	var/tmp/supplies
	var/tmp/special_supplies

	var/tmp/list/equip = list(
		"shirt" = null,
		"undershirt" = null,
		"overshirt" = null,
		"arms" = null,
		"pants" = null,
		"shoes" = null,
		"glasses" = null,
		"cloak" = null,

		// armor...
		"face_armor" = null,
		"chest_armor" = null,
		"leg_armor" = null,
		"arm_armor" = null,

		"weapon" = null,
	)