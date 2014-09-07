client
	var/tmp/moving

	proc/begin_movement()
		set waitfor = 0

		if(src.moving) return 0

		var/d = src.dir_from_keys()
		if(!d) return 0

		src.moving = TRUE

		//var/character/focus = src.focus
		sleep(TICK_LAG)

		do
			focus.Move(get_step(focus, d), d)

			world << focus.move_delay
			sleep(focus.move_delay)

			d = src.dir_from_keys()

		while(d)

		src.moving = FALSE

		if(focus && call(focus, "action_set")(ACTION_RUN))
			call(focus, "force_action")(ACTION_IDLE)

	proc/dir_from_keys()
/*
		if(keys["north"]) . |= NORTH
		if(keys["south"]) . |= SOUTH
		if(keys["east"]) . |= EAST
		if(keys["west"]) . |= WEST*/

		var/mdir
		var/compatible = 0
		var/keycount = 0
		var/mostrecent
		for(var/i in global.movement_keys)
			if(keys[i])
				keycount++
				if(mostrecent)
					if(keys[i] > keys[mostrecent])
						mostrecent = i
				else
					mostrecent = i

		if(keycount == 2)
			if(keys["north"])
				if(keys["west"])
					mdir = NORTHWEST
					compatible = 1
				else if(keys["east"])
					mdir = NORTHEAST
					compatible = 1
			else if(keys["south"])
				if(keys["west"])
					mdir = SOUTHWEST
					compatible = 1
				else if(keys["east"])
					mdir = SOUTHEAST
					compatible = 1

		if(!compatible)
			switch(mostrecent)
				if("northwest") mdir = NORTHWEST
				if("northeast") mdir = NORTHEAST
				if("north") mdir = NORTH
				if("east") mdir = EAST
				if("southwest") mdir = SOUTHWEST
				if("southeast") mdir = SOUTHEAST
				if("south") mdir = SOUTH
				if("west") mdir = WEST

		return mdir

	North()
	South()
	East()
	West()
	Northeast()
	Northwest()
	Southwest()
	Southeast()

var/global/list/movement_keys = list(
	"north","northeast","northwest",
	"south","southeast","southwest",
	"east","west"
)