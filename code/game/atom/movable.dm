atom/movable
	Move(var/atom/location, var/direction)
		//if(!src.can_move())
		//	return 0

		. = ..()

		var/atom/last_location = src.loc

		if(.)
			src.Moved(last_location, location, direction)

	proc/Moved(var/atom/last_location, var/atom/new_location, var/direction)
		set waitfor = 0

	//proc/refresh_move_delay()

	//proc/get_move_stun()
	//	. = 0

	//proc/can_move()
	//	return src.can_move

	Bump(var/atom/obstacle)
		obstacle.Bumped(src)

	Crossed(var/atom/movable/crossed)
		if(hascall(crossed, "on_crossed"))
			call(crossed, "on_crossed")(src)

	Uncrossed(var/atom/movable/uncrossed)
		if(hascall(uncrossed, "on_uncrossed"))
			call(uncrossed, "on_uncrossed")(src)

	New()
		..()
		if(loc)
			loc.Entered(src)

atom
	proc/Bumped(var/atom/movable/bumper)

	proc/on_crossed(var/atom/movable/crossed)
		return 1
	proc/on_uncrossed(var/atom/movable/uncrossed)
		return 1