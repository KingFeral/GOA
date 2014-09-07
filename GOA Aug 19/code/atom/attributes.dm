atom
	var/tmp/list/attributes

	proc/set_attribute()
		if(!args)
			return

		if(!attributes)
			attributes = list()

		for(var/a in args)
			if(islist(a))
				for(var/b in a)
					attributes |= b
			else if(istext(a))
				attributes |= a

	proc/remove_attribute()
		if(!args || !attributes)
			return

		for(var/a in args)
			if(islist(a))
				for(var/b in a)
					attributes -= b
			else if(istext(a))
				attributes -= a

	proc/is_water()
		if(src.icon == 'media/turf/tile/water.dmi')
			return 1

		if(attributes && attributes["water"])
			return 1