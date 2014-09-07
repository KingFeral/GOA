/*
 * Preferably temporary code to load a map at a location
 * with empty space. This is rather inefficient, and I
 * hope to devise a far better algorithm in the future.
 */
dynamic_map

	proc/jump_value(string) return length(copytext(string,1,findtext(string,"\"",2)-1))

	proc/map_max_x(string)
		var/a = findtext(string,"(1,1,1) = {\"") + 14
		return length(copytext(string,a,findtext(string,"\n",a)))/jump_value(string)

	proc/map_max_y(string)
		var/counter = 0
		var/end = findtext(string,"\"}")
		for(var/a = findtext(string,"(1,1,1) = {\"") + 14, a <= end, a ++)
			a = findtext(string,"\n",a) + 1
			counter ++
		return counter

	proc/map_max_z(string)
		var/counter = 1
		while(findtext(string,"(1,1,[counter]")) counter ++
		return counter - 1

	proc/matching_contents(list/a,list/b)
		if(!a.len || !b.len) return 0
		for(var/c in a) if(!(c in b)) return 0
		return 1

	proc/find_space(atom/low, atom/high, list/writable_atoms, preferences)
		var
			low_search_x = (low ? (low.x) : (1))
			low_search_y = (low ? (low.y) : (1))
			low_search_z = (low ? (low.z) : (1))

			high_search_x = (high ? (high.x) : (world.maxx))
			high_search_y = (high ? (high.y) : (world.maxy))
			high_search_z = (high ? (high.z) : (world.maxz))

			file_x = map_max_x(file_string)
			file_y = map_max_y(file_string)
			file_z = map_max_z(file_string)

			x = low_search_x - 1
			y = low_search_y
			z = low_search_z

			found_area = 0

		if(!writable_atoms) writable_atoms = new
		if(!(world.turf in writable_atoms)) writable_atoms += world.turf
		if(!(world.area in writable_atoms)) writable_atoms += world.area

		while(x + file_x <= high_search_x || y + file_y <= high_search_y || z + file_z - 1 <= high_search_z)
			x ++
			if(x + file_x > high_search_x)
				x = low_search_x
				y ++
				if(y + file_y > high_search_y)
					y = low_search_y
					z ++
					if(z + file_z > high_search_z) break
			var/list/section = section(locate(x,y,z),locate(x + file_x, y + file_y, z + file_z - 1))
			if(matching_contents(section, writable_atoms))
				found_area ++
				break

		if(found_area) return locate(x, y, z)
		if(preferences & APPEND_TO_LOW_EDGE) return locate(1, world.maxy, low.z)
		if(preferences & APPEND_TO_HIGH_EDGE) return locate(1, world.maxy, high.z)
		if(preferences & APPEND_TO_NEXT_Z) return locate(1, 1, ++ world.maxz)