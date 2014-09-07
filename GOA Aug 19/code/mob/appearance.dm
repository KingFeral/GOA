mob
	var/base_name
	var/hair_type
	var/hair_color
	var/tmp/list/appearances

	proc/add_appearance(image/image, id)
		if(!appearances)
			appearances = list()

		if(id in appearances)
			remove_appearance(id)

		if(islist(image))
			for(var/image/i in image)
				overlays += i
		else
			overlays += image
		appearances[id] = image

	proc/remove_appearance(id)
		if(id in appearances)
			var/appearance_info = appearances[id]
			if(islist(appearance_info))
				for(var/image/i in appearance_info)
					overlays -= i
			else
				overlays -= appearance_info

			appearances[id] = null
			appearances -= id

	proc/load_overlays()
		//var/list/overlays = list()
		overlays = null

		for(var/id in appearances)
			if(islist(appearances[id]))
				for(var/image/img in appearances[id])
					overlays += img
			else
				overlays += appearances[id]

		//src.overlays = overlays

	proc/hide_overlays()
		for(var/id in appearances)
			if(islist(appearances[id]))
				for(var/image/img in appearances[id])
					overlays -= img
			else
				overlays -= appearances[id]

	proc/reIcon()
		switch(base_name)
			if("base_brown")
				icon = 'media/base/base_brown.dmi'
			if("base_pale")
				icon = 'media/base/base_pale.dmi'
			else
				icon = 'media/base/base_white.dmi'

	proc/affirm_icon()
		var/icon
		if(src.gate >= 3)
			icon = 'media/base/base_gates.dmi'
		else if(src.iron_skin)
			icon = 'media/base/base_iron_skin.dmi'
		else
			switch(base_name)
				if("base_brown")
					icon = 'media/base/base_brown.dmi'
				if("base_pale")
					icon = 'media/base/base_pale.dmi'
				else
					icon = 'media/base/base_white.dmi'

		if(src.sharingan)
			var/icon/i = new(icon)
			i.SwapColor(rgb(007, 007, 007), rgb(180, 0, 0))
			i.SwapColor(rgb(93, 95, 93), rgb(220, 50, 50))
			icon = i
		else if(src.byakugan)
			var/icon/i = new(icon)
			i.SwapColor(rgb(007, 007, 007), rgb(160, 200, 170))
			i.SwapColor(rgb(93, 95, 93), rgb(160, 200, 170))
			icon = i

		src.icon = icon

atom/movable
	proc/mimick_appearance(var/atom/movable/m)
		src.icon = m.icon
		src.icon_state = m.icon_state
		src.overlays += m.overlays
		src.underlays += m.underlays