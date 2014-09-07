



/***********************************************************/
// Atom variables and functions.
/***********************************************************/

atom

	var

		// This value must be set to specify which type of autojoining the object
		// uses. When an object is created or deleted, if this autojoin var is true,
		// it will attempt to match it with the appropriate type of autojoining
		// and align it with nearby atoms. Acceptable values are: 13, 16
		autojoin = 0

	// Whenever an object is created or deleted, it will call the Autojoin function
	// which will tell all nearby objects to reconnect themselves, so if the new
	// or removed object changed the join-structure of the 2neighboring tiles, they
	// will readjust themselves.
	New()
		..()
		if(autojoining && src.autojoin)
			autojoining.Join(src)

	Del()
		if(autojoining && src.autojoin)
			autojoining.Join(src)
		..()


	// The JoinMatch proc is used to determine whether two tiles can join together
	// or not. You can override this function to provide your own requirements.
	proc/JoinMatch(direction)
		var/turf/T = get_step(src, direction)

		// Connect to the edges of the map.
		if(!T)
			return 1

		// Connect to turfs of the same type.
		if(isturf(src))
			if(T.type == src.type)
				return 1

		// Connect to objects on the same type in that turf.
		else
			for(var/atom/movable/M in T)
				if(M.type == src.type)
					return 1

		return 0




/***********************************************************/
// Autojoining variables and functions.
/***********************************************************/

var/autojoining/autojoining = new()

autojoining

	var/const

		// These are used for bit-flag directions.
		N  = 1
		E  = 2
		S  = 4
		W  = 8
		NE = 16
		NW = 32
		SE = 64
		SW = 128

	var
		list/dir_to_bit = list(1, 16, 0, 4, 2, 8, 0, 64, 128, 32)


	// Telling an object to Autojoin will have the object and all objects within
	// a one-tile radius to reconnect themselves. The type of connection made
	// depends on each object's autojoin setting.
	proc/Join(atom/A)
		var/center = isturf(A) ? A : A.loc
		for(var/atom/N in range(center, 1))
			switch(N.autojoin)
				if(13)
					src.Autojoin13(N)
				if(16)
					src.Autojoin16(N)
				if(47)
					src.Autojoin47(N)
/*
				if(82)
					src.Autojoin82(N)
				if(161)
					src.Autojoin161(N)
*/
		return


	// This is use to assign adjust byte values by bit and mask. The object must
	// also be able to connect to the adjoining tile.
	proc/Match(atom/object, direction, byte, bit, mask=0)
		if((byte & mask) == mask && object.JoinMatch(direction))
			byte |= bit
		else
			byte &= ~bit
		return byte


	// *** 13-STATE AUTOJOINING *** //
	proc/Autojoin13(atom/A)
		var/byte = 0
		byte = src.Match(A, NORTH, byte, N)
		byte = src.Match(A, EAST, byte, E)
		byte = src.Match(A, SOUTH, byte, S)
		byte = src.Match(A, WEST, byte, W)
		byte = src.Match(A, NORTHEAST, byte, NE)
		byte = src.Match(A, SOUTHEAST, byte, SE)
		byte = src.Match(A, SOUTHWEST, byte, SW)
		byte = src.Match(A, NORTHWEST, byte, NW)
		A.icon_state = "[src.GetState13(byte)]"
		return


	// Check to see which directions are and aren't joinable. These are arranged in
	// order of most common to least common in order to use as few checks as possible.
	proc/GetState13(byte)

		// For for match combinations including diagonal directions.
		switch(byte)
			if(N|E|S|W|NE|SE|SW)
				return 12
			if(N|E|S|W|SE|SW|NW)
				return 11
			if(N|E|S|W|NE|SE|NW)
				return 10
			if(N|E|S|W|NE|SW|NW)
				return 9

		// If no diagonal matches were found, then check using only cardinals.
		switch(byte & (N|E|S|W))
			if(N|W)
				return 8
			if(N|E|W)
				return 7
			if(N|E)
				return 6
			if(N|S|W)
				return 5
			if(N|E|S)
				return 4
			if(S|W)
				return 3
			if(E|S|W)
				return 2
			if(E|S)
				return 1

		// Could not connect to anything.
		return 13


	// *** 16-STATE AUTOJOINING *** //
	proc/Autojoin16(atom/A)
		var/byte = 0
		byte = src.Match(A, NORTH, byte, 1)
		byte = src.Match(A, EAST, byte, 2)
		byte = src.Match(A, SOUTH, byte, 4)
		byte = src.Match(A, WEST, byte, 8)
		A.icon_state = "[byte]"
		return


	// *** 47-STATE AUTOJOINING *** //
	proc/Autojoin47(atom/A)
		var/byte = 0
		byte = src.Match(A, NORTH, byte, 1)
		byte = src.Match(A, EAST, byte, 4)
		byte = src.Match(A, SOUTH, byte, 16)
		byte = src.Match(A, WEST, byte, 64)
		byte = src.Match(A, NORTHEAST, byte, 2, 5)
		byte = src.Match(A, SOUTHEAST, byte, 8, 20)
		byte = src.Match(A, SOUTHWEST, byte, 32, 80)
		byte = src.Match(A, NORTHWEST, byte, 128, 65)
		A.icon_state = "[byte]"
		return

/*
	// *** 82-STATE AUTOJOINING *** //
	// Provided by Lummox JR
	proc/Autojoin82(atom/A)
		var/byte = 0
		for(var/direction in 1 to 10)
			var/bit = dir_to_bit[direction]
			if(bit && A.JoinMatch(direction))
				byte |= bit
		byte ^= (byte << 1) & ((byte << 7) | (byte >> 1)) & 170
		A.icon_state = "[byte]"
		return

	// *** 161-STATE AUTOJOINING *** //
	// Provided by Lummox JR
	proc/Autojoin161(atom/A)
		var/byte = 0
		for(var/direction in 1 to 10)
			var/bit = dir_to_bit[direction]
			if(bit && A.JoinMatch(direction))
				byte |= bit
		byte &= (byte << 1) | (byte << 7) | (byte >> 1) | 85
		A.icon_state = "[byte]"
		return
*/

