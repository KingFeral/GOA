dynamic_map
	var
		id

		load_file

		lowx
		lowy
		lowz

		highx
		highy
		highz

		loop_amount = 100
		sleep_time = -1

		save_preferences = SKIP_NONE
		load_preferences = SKIP_NONE | LOAD_ON_READ
		delete_preferences = SKIP_NONE | REPLACE_AREA_ON_DELETE | RESET_MAX_COORDINATES

		clear_save_data = TRUE
		clear_load_data = TRUE

	New(_id)
		if(_id) id = _id
		else
			//Picks an arbitrary id for a map if none is provided.

			var/a = 0
			do id = "[++ a]"
			while(dynamic_maps && (id in dynamic_maps))

		if(!dynamic_maps) dynamic_maps = new
		dynamic_maps[id] = src

	proc/Load(file, atom/location)
		if((load_file || file_string) || !(atom_sets || map_arrangement))
			if(!fexists(file))
				INTERNAL_CRASH("'[file]' does not exist.", src)

			load_file = file

		if(!(load_preferences & READ_IN_ONLY))
			lowx = location.x
			lowy = location.y
			lowz = location.z

			atom_sets = new

			file_string = file2text(file)
			length = length(file_string)

		parse_load_list()
		get_map_size_data()

		if(!(load_preferences & READ_IN_ONLY)) build_map()

		highx --
		highy --
		highz --

	proc/Load_From_Template(id)
		var/dynamic_map/template = dynamic_maps ? ((id in dynamic_maps) && dynamic_maps[id]) : null
		if(template)
			atom_sets = template.atom_sets.Copy()
			map_arrangement = template.map_arrangement.Copy()

	proc/Load_On_Open_Area(file, atom/low, atom/high, list/writable_atoms, preferences)
		file = load_file
		file_string = file2text(file)

		var/atom/load_location = find_space(low, high, writable_atoms, preferences)
		if(load_location) Load(null, load_location)

	proc/Save(filename)
		condition = new
		position = new

		collect_atom_data()
		scan_block()

		convert_condition_list()
		convert_position_list()

		build_file(filename)

		if(clear_save_data) clear_initial_objects_list()

	Del()
		var/list/map_contents
		if(lowx && lowy && lowz && highx && highy && highz)
			map_contents = section(get_low_corner(), get_high_corner())

		if(!(delete_preferences & SKIP_AREA))
			for(var/area/a in map_contents)

				if(a.skip_delete) continue

				if(delete_preferences & REPLACE_AREA_ON_DELETE)
					var/list/vars = a.vars.Copy()
					var/area/new_area = new world.area(locate(a.x, a.y, a.z))
					for(var/e in new_area.vars)
						if(e in vars) new_area.vars[e] = vars[e]

				else del a

		if(!(delete_preferences & SKIP_TURF))
			for(var/turf/t in map_contents)
				if(t.skip_delete) continue
				del t

		if(!(delete_preferences & SKIP_OBJ))
			for(var/obj/o in map_contents)
				if(o.skip_delete) continue
				del o

		if(!(delete_preferences & SKIP_MOB))
			for(var/mob/m in map_contents)
				if(m.skip_delete) continue
				if(m.client && (m.client.skip_delete || (delete_preferences & SKIP_CLIENT))) continue

				del m

		if(delete_preferences & RESET_MAX_COORDINATES)
			if(highx > maxx_revert_size) world.maxx = maxx_revert_size
			if(highy > maxy_revert_size) world.maxy = maxy_revert_size
			if(highz > maxz_revert_size) world.maxz = maxz_revert_size

		dynamic_maps -= src.id

		..()

	proc/is_in_use()
		if(lowx && lowy && lowz && highx && highy && highz)
			var/list/map_contents = section(locate(lowx, lowy, lowz), locate(highx, highy, highz))

			for(var/mob/m in map_contents) if(m.client) return 1

		return 0

	proc/get_high_corner()
		if(highx > world.maxx) highx = world.maxx
		if(highy > world.maxy) highy = world.maxy
		if(highz > world.maxz) highz = world.maxy

		return locate(highx, highy, highz)

	proc/get_low_corner() return locate(lowx, lowy, lowz)