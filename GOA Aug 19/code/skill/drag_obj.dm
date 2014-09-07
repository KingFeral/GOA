drag_obj
	parent_type = /obj
	layer = HUD_LAYER + 0.001

	var/tmp/hud/placeholder/slot/slot

	MouseDrop(var/atom/object_under_mouse, var/dragged_from, var/container_obj, var/src_control, var/over_control)
		if(istype(object_under_mouse, /hud/placeholder/slot))
			var/hud/placeholder/slot/slot = object_under_mouse
			slot.set_slot(src, usr.client)
		else if(isskill(object_under_mouse) && object_under_mouse:slot && over_control == "mappane.map")
			var/skill/OUM = object_under_mouse
			OUM.slot.set_slot(src, usr.client)
			..()

hud/placeholder
	slot
		proc/set_slot(var/drag_obj/d, var/client/client)
			if(!(d in client.screen))
				client.screen += d

			for(var/i in 1 to 2)
				for(var/m in 1 to 10)
					var/drag_obj/dobj = client.macro_set[i][m]
					if(dobj && (dobj == d || m == id))
						client.screen -= dobj
						client.macro_set[i][m] = null

			var/screenloc
			switch(src.id)
				if(1)
					screenloc = "CENTER-4, 1:8"
				if(2)
					screenloc = "CENTER-3, 1:8"
				if(3)
					screenloc = "CENTER-2, 1:8"
				if(4)
					screenloc = "CENTER-1, 1:8"
				if(5)
					screenloc = "CENTER, 1:8"
				if(6)
					screenloc = "CENTER+1, 1:8"
				if(7)
					screenloc = "CENTER+2, 1:8"
				if(8)
					screenloc = "CENTER+3, 1:8"
				if(9)
					screenloc = "CENTER+4, 1:8"
				if(10)
					screenloc = "CENTER+5, 1:8"

			if(screenloc)
				d.screen_loc = screenloc
			else
				CRASH("failed to find screen position (id = [src.id])")
				return 0

			client.screen += d
			client.macro_set[client.current_macro_set][src.id] = d
			d.slot = src