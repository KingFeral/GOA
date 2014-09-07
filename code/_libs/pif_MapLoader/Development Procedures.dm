proc
	create_map(id, save_preferences, load_preferences, delete_preferences)
		var/dynamic_map/map = new(id)
		map.save_preferences = save_preferences
		map.load_preferences = load_preferences
		map.delete_preferences = delete_preferences

		return map

	create_map_on_section(id, atom/low, atom/high, save_preferences, load_preferences, delete_preferences)
		var/dynamic_map/map = new(id)

		map.lowx = low.x
		map.lowy = low.y
		map.lowz = low.z

		map.highx = high.x
		map.highy = high.y
		map.highz = high.z

		map.save_preferences = save_preferences
		map.load_preferences = load_preferences
		map.delete_preferences = delete_preferences

		return map

	find_map(id) return dynamic_maps ? ((id in dynamic_maps) && dynamic_maps[id]) : null

	get_map_at_location(atom/a)
		if(!istype(a)) return

		for(var/e in dynamic_maps)
			var/dynamic_map/map = dynamic_maps[e]
			if((a.x > map.lowx && a.x < map.highx) && (a.y > map.lowy && a.y < map.highy) && (a.z > map.lowx && a.z < map.highz))
				return map

		return null

#if		defined(PIF_MAPLOADER_COMPATABILITY_2)
	_load_map(id, file, atom/low)
#elif	!defined(PIF_MAPLOADER_COMPATABILITY_2)
	load_map(id, file, atom/low)
#endif
		var/dynamic_map/map = find_map(id) || new(id)
		map.Load(file, low)

		return map

	load_file_into_memory(id, file)
		var/dynamic_map/map = new(id)
		map.load_preferences |= READ_IN_ONLY

		map.Load(file)

		return map

	load_map_from_memory(template, id, location)
		var/dynamic_map/map = new(id)
		map.Load_From_Template(template)
		map.Load(null, location)

		return map

	load_map_on_space(id, file, atom/low, atom/high, list/writable, preferences)
		var/dynamic_map/map = find_map(id) || new(id)
		map.Load_On_Open_Area(file, low, high, writable, preferences)

		return map

	save_map(id, file)
		var/dynamic_map/map = find_map(id)
		if(map) map.Save(file)

	delete_map(id) del find_map(id)

	save_and_delete_map(id, file)
		save_map(id, file)
		delete_map(id)


	save_all_maps(list/exceptions, list/names)
		var/dynamic_map/map

		for(var/a in dynamic_maps)
			map = dynamic_maps[a]
			if((map in exceptions) || (map.id in exceptions)) continue

			if(map in names) map.Save(names[map])
			else if(map.id in names) map.Save(names[map.id])
			else map.Save("[map.id].dmm")

	delete_all_maps(list/exceptions)
		var/dynamic_map/map

		for(var/a in dynamic_maps)
			map = dynamic_maps[a]
			if((map in exceptions) || (map.id in exceptions)) continue

			del map

	save_and_delete_all_maps(list/exceptions, list/names)
		save_all_maps(exceptions, names)
		delete_all_maps(exceptions)

#if		defined(PIF_MAPLOADER_COMPATABILITY_2)
	_load_chunk(atom/low, id, preferences, file, lowx, lowy, lowz, highx, highy, highz)
#elif	!defined(PIF_MAPLOADER_COMPATABILITY_2)
	load_chunk(atom/low, id, preferences, file, lowx, lowy, lowz, highx, highy, highz)
#endif
		var/dynamic_map/map = new(id)

		map.lowx = low.x
		map.lowy = low.y
		map.lowz = low.z

		map.load_preferences = preferences

		map.load_file = file
		map.file_string = file_into_chunk(file, lowx, lowy, lowz, highx, highy, highz)
		map.length = length(map.file_string)

		map.atom_sets = new

		map.parse_load_list()
		map.get_map_size_data()
		map.build_map()

		return map

	load_chunk_into_memory(id, file, lowx, lowy, lowz, highx, highy, highz)
		var/dynamic_map/map = new(id)

		map.load_preferences = READ_IN_ONLY

		map.load_file = file
		map.file_string = file_into_chunk(file, lowx, lowy, lowz, highx, highy, highz)
		map.length = length(map.file_string)

		map.atom_sets = new

		map.parse_load_list()
		map.get_map_size_data()

		return map

	save_map_chunk(atom/low, atom/high, file, preferences)
		var/dynamic_map/map = new
		map.save_preferences = preferences

		map.lowx = low.x
		map.lowy = low.y
		map.lowz = low.z

		map.highx = high.x
		map.highy = high.y
		map.highz = high.z

		map.Save(file)

		map.delete_preferences = SKIP_ALL_BUT_(0)
		del map

	delete_map_chunk(atom/low, atom/high, preferences)
		var/dynamic_map/map = new

		map.lowx = low.x
		map.lowy = low.y
		map.lowz = low.z

		map.highx = high.x
		map.highy = high.y
		map.highz = high.z

		map.delete_preferences = preferences
		del map

	map_low_corner(id)
		var/dynamic_map/map = find_map(id)
		if(map) return map.get_low_corner()

	map_high_corner(id)
		var/dynamic_map/map = find_map(id)
		if(map) return map.get_high_corner()

	map_corners(id)
		var/dynamic_map/map = find_map(id)
		if(map) return list(map.get_low_corner(), map.get_high_corner())

	map_contents(id)
		var/dynamic_map/map = find_map(id)
		if(map && map.lowx && map.lowy && map.lowz && map.highx && map.highy && map.highz)
			return section(map_low_corner(id), map_high_corner(id))

		return list()

	is_in_use(id)
		var/dynamic_map/map = find_map(id)
		if(map) return map.is_in_use()

	set_load_preferences(id, preferences)
		var/dynamic_map/map = find_map(id)
		if(map) map.load_preferences = preferences

	set_save_preferences(id, preferences)
		var/dynamic_map/map = find_map(id)
		if(map) map.save_preferences = preferences

	set_delete_preferences(id, preferences)
		var/dynamic_map/map = find_map(id)
		if(map) map.delete_preferences = preferences

	set_save_data_handling(id, handling)
		var/dynamic_map/map = find_map(id)
		if(map)
			if(handling == null) map.clear_save_data = !map.clear_save_data
			else map.clear_save_data = handling

	set_load_data_handling(id, handling)
		var/dynamic_map/map = find_map(id)
		if(map)
			if(handling == null) map.clear_load_data = !map.clear_load_data
			else map.clear_load_data = handling

	set_loop_amount(id, amount)
		var/dynamic_map/map = find_map(id)
		if(map) map.loop_amount = amount

	set_sleep_time(id, time)
		var/dynamic_map/map = find_map(id)
		if(map) map.sleep_time = time