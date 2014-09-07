proc/arctan(x)
	var/y=arcsin(x/sqrt(1+x*x))
	//if(usr) usr << "arctan([x]): y = [y]"
	if(x>=0) return y
	return -y

proc/arctan2(dy, dx)
	//if(usr) usr << "arctan2([dy], [dx]):"
	if(dy == 0)
		if(dx > 0)
			//if(usr) usr << "	return 0"
			return 0
		else if(dx == 0)
			//if(usr) usr << "	return 0"
			return 0
		else
			//if(usr) usr << "	return 180"
			return 180
	if(dx == 0)
		if(dy > 0)
			//if(usr) usr << "	return 90"
			return 90
		else if(dy == 0)
			//if(usr) usr << "	return 0"
			return 0
		else
			//if(usr) usr << "	return -90"
			return -90
	else
		var/angle = arctan(dy/dx)
		if(dx < 0)
			angle = 180 - angle
		if(dy < 0)
			angle = -angle
		//if(usr) usr << "	return [angle]"
		return angle

proc/get_real_angle(atom/A, atom/B)
	var/dx = B.x - A.x
	var/dy = B.y - A.y
	//if(usr) usr << "get_real_angle([A], [B]): dx=[dx], dy=[dy]"
	return arctan2(dy, dx)

proc
	dir2ref(d)
		switch(d)
			if(NORTH)//NORTH
				return 1
			if(NORTHEAST)//NORTHEAST
				return 2
			if(EAST)//EAST
				return 3
			if(SOUTHEAST)//SOUTHEAST
				return 4
			if(SOUTH)//SOUTH
				return 5
			if(SOUTHWEST)//SOUTHWEST
				return 6
			if(WEST)//WEST
				return 7
			if(NORTHWEST)//NORTHWEST
				return 8

	dir2angle(d)
		switch(d)
			if(NORTH)//NORTH
				return 90
			if(NORTHEAST)//NORTHEAST
				return 45
			if(EAST)//EAST
				return 0
			if(SOUTHEAST)//SOUTHEAST
				return -45
			if(SOUTH)//SOUTH
				return -90
			if(SOUTHWEST)//SOUTHWEST
				return -135
			if(WEST)//WEST
				return 180
			if(NORTHWEST)//NORTHWEST
				return 135

	angle2dir(angle)
		angle = normalize_angle(angle)
		switch(angle)
			if(-180 to -157.5, 157.5 to 180)
				return WEST
			if(-157.5 to -112.5)
				return SOUTHWEST
			if(-112.5 to -67.5)
				return SOUTH
			if(-67.5 to -22.5)
				return SOUTHEAST
			if(-22.5 to 22.5)
				return EAST
			if(22.5 to 67.5)
				return NORTHEAST
			if(67.5 to 112.5)
				return NORTH
			if(112.5 to 157.5)
				return NORTHWEST

	normalize_angle(angle)
		while(angle > 180)
			angle -= 360
		while(angle <= -180)
			angle += 360
		return angle

	dircount(sdir,fdir)
		var/x=sdir
		if(x==fdir)
			return 0
		var/c=0
		do
			x++
			if(x>8)
				x=1
			c++
		while(x!=fdir)

		return c

	// Bresenham's line algorithm
	// Adapted from wikipedia pseudocode
	// Returns a list of turfs in a line from A to B
	get_line(atom/A, atom/B)
		if(!A || !B)
			return list()
		// Can't handle Z-level changes
		if(A.z != B.z)
			return list()

		var
			x0 = A.x
			x1 = B.x
			y0 = A.y
			y1 = B.y

		var/vertical = abs(y1-y0) > abs(x1-x0)
		// Mirror vertical lines, because it only works with "horizontal" lines
		if(vertical)
			x0 = A.y
			y0 = A.x
			x1 = B.y
			y1 = B.x

		// Mirror lines going the wrong direction
		if(x0 > x1)
			var/temp = x0
			x0 = x1
			x1 = temp

			temp = y0
			y0 = y1
			y1 = temp

		var
			dx = x1 - x0
			dy = abs(y1 - y0)
			error = 0
			derror = dy / dx
			ystep = y0<y1?1:-1
			y = y0

		var/line[0]
		for(var/x in x0 to x1)
			if(vertical)
				line += locate(y, x, A.z)
			else
				line += locate(x, y, A.z)
			error += derror
			if(error >= 0.5)
				y += ystep
				error -= 1

		return line
