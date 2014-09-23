mob
	verb/test()
		if(ckey != "fki")
			return 0
		var/obj/o = new(loc)
		for(var/i in 1 to 100)
			var/image/n = new/image('icons/base_m1.dmi', loc = o)
			usr << n