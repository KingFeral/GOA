/* Operations to load properly:
 *
 * atom_sets = new
 *
 * file_string = file2text(file)
 * length = length(file_string)
 *
 * parse_load_list()
 * get_map_size_data()
 * build_map()
 *
 * highx --
 * highy --
 * highz --
 */

dynamic_map
	var
		file_string
		location = 2
		length

		list
			atom_sets
			map_arrangement

		reference_length

	proc/is_ignored_load_type(type)
		if(ispath(type, /area) && (save_preferences & SKIP_AREA)) return 1
		if(ispath(type, /turf) && (save_preferences & SKIP_TURF)) return 1
		if(ispath(type, /obj) && (save_preferences & SKIP_OBJ)) return 1
		if(ispath(type, /mob) && (save_preferences & SKIP_MOB)) return 1

		return 0

	proc/parse_load_list()
		var
			load_list = copytext(file_string, 1, findtext(file_string, "(1,1,1)") - 2)

			start = 1
			end = 1

		do
			end = findtext(load_list, "\n", start)
			var/list/tile_set = parse_set(copytext(load_list, start, end))
			start = end + 1

			atom_sets[tile_set[1]] = tile_set[2]

		while(end)

	proc/parse_set(tile_set)
		. = list()
		var
			length = length(tile_set)
			location = reference_length + 7

		if(!reference_length)
			. += copytext(tile_set, 2, findtext(tile_set, "\"", 2))
			reference_length = length(.[1])
			location = reference_length + 7

		else . += copytext(tile_set, 2, reference_length + 2)

		var
			start = location
			list/data[0]

		for(location, location <= length, location ++)
			switch(text2ascii(tile_set, location))
				if(41) break

				if(44)
					data += text2path(copytext(tile_set, start, location))

					start = location + 1

				if(123)
					var
						type = text2path(copytext(tile_set, start, location))
						list/variable_data = parse_variable_data(tile_set, location)

					data[type] = variable_data[2]

					location = variable_data[1] + 1
					start = location + 1

		. += null
		.[2] = data

	proc/parse_variable_data(tile_set, location)
		var
			list/data[0]

			variable_found = 0
			skip_next_brace = 0

			length = length(tile_set)
			previous = location + 1
		location += 1
		for(location, location <= length, location ++)
			switch(text2ascii(tile_set, location))
				if(123) skip_next_brace = 1

				if(125)
					if(skip_next_brace) skip_next_brace = 0
					else
						data[data[data.len]] = correct_value(copytext(tile_set, previous, location))

						break

				if(61)
					if(!variable_found)
						data += copytext(tile_set, previous, location - 1)
						previous = location + 2

						variable_found = 1

				if(59)
					data[data[data.len]] = correct_value(copytext(tile_set, previous, location))

					previous = location + 2
					variable_found = 0

		return list(location, data)

	proc/correct_value(value)
		switch(text2ascii(value))
			if(48 to 57) return text2num(value)
			if(34) return parse_escape_sequences(copytext(value, 2, length(value)))
			if(39) return file(copytext(value, 2, length(value)))
			if(47) return text2path(value)
			if(108) return parse_list(value)
			if(110)
				if(value == "null") return null
				if(findtext(value, "newlist", 1, 8)) return parse_newlist(value)
				return new_object(value)

		return null

	proc/parse_list(value)
		. = list()

		var
			element

			has_association = 0

			parantheses_sum = 0

			length = length(value)
			previous = 6
		for(var/a = 7, a <= length, a ++)
			switch(text2ascii(value, a))
				if(34)
					do a = findtext(value, "\"", a) + 1
					while(text2ascii(value, a) - 1 == 92)

					a --

				if(40) parantheses_sum ++
				if(41) parantheses_sum --

				if(44)
					if(!parantheses_sum)
						if(!element) element = correct_value(compress_text(copytext(value, previous, a)))
						. += element

						if(has_association)
							var/association = correct_value(compress_text(copytext(value, previous, a)))
							if(!(isnum(element) && isnum(association))) .[element] = association

						element = null
						previous = a + 1

						has_association = 0

				if(61)
					if(!parantheses_sum)
						element = correct_value(compress_text(copytext(value, previous, a)))

						has_association = 1
						previous = a + 1

		if(!has_association) . += correct_value(compress_text(copytext(value, previous, length)))
		else .[element] = correct_value(compress_text(copytext(value, previous, length)))

	proc/parse_newlist(value)
		. = list()

		var
			in_brackets = 0
			in_quotes = 0

			previous = 9

			length = length(value)
			location = 9
		for(location, location <= length, location ++)
			switch(text2ascii(value, location))
				if(123) in_brackets ++
				if(125) in_brackets --

				if(34) if(text2ascii(value, location - 1) != 92) in_quotes = !in_quotes

				if(44)
					if(!in_brackets && !in_quotes)
						var/a = correct_value("new [copytext(value, previous, location)]()")
						if(!isobject(a)) INTERNAL_CRASH("Non-object found in newlist().", src)

						. += a

						previous = location + 1

		var/a = correct_value("new [copytext(value, previous, length)]()")
		if(!isobject(a)) INTERNAL_CRASH("Non-object found in newlist().", src)

		. += a

	proc/new_object(value)
		value = copytext(value, 5)

		var
			type = copytext(value, 1, findtext(value, "{") || findtext(value, "("))
			location = length(type) + 1

			list
				variables
				arguments[0]

		type = text2path(type)
		if(!type) INTERNAL_CRASH("Unknown type found in '[load_file]'.", src)

		if(text2ascii(value, location) == 123)
			var/list/data = parse_variable_data(value, location)

			location = data[1] + 1
			variables = data[2]

		arguments = parse_list("list" + copytext(value, location))
		if(!arguments.len) arguments = null

		var/datum/d
		if(arguments)
			d = new type(arglist(arguments))
			d.__NEW__ = arguments
		else d = new type

		for(var/a in variables)
			if(!(a in d.vars)) INTERNAL_CRASH("Unknown variable \"[a]\" for [d.type] in file '[load_file]'.", src)

			d.vars[a] = variables[a]

		return d

	proc/get_map_size_data()
		var/x = 0, y = -1, z = 0
		var/location = findtext(file_string, "(1,1,1) = {\"\n") + 13

		x = length(copytext(file_string, location,  findtext(file_string, "\n", location))) / reference_length

		var/end = findtext(file_string, "}", location)
		do
			y ++
			location = findtext(file_string, "\n", location) + 1
		while(location < end)

		location = 1
		do
			sleep(-1)
			z ++
			location = findtext(file_string, "(1,1,[z + 1])")
		while(location)

		if((lowx + x - 1) > world.maxx)
			maxx_revert_size = world.maxx
			world.maxx = lowx + x - 1

		if((lowy + y - 1) > world.maxy)
			maxy_revert_size = world.maxy
			world.maxy = lowy + y - 1

		if((lowz + z - 1) > world.maxz)
			maxz_revert_size = world.maxz
			world.maxz = lowz + z - 1

		highx = lowx + x
		highy = lowy + y
		highz = lowz + z

	proc/build_map()
		var
			location

			x = 1
			y = highx - lowx
			z = 0

		if(!map_arrangement)
			do
				location = findtext(file_string, "(1,1,[++ z]) = {\"\n")
				if(location)
					location += 12 + length("[z]")

					for(location, location <= length, location += reference_length)
						var/reference = copytext(file_string, location, location + reference_length)

						if(findtext(reference, "\n"))
							x = 1
							y --
							reference = copytext(file_string, ++ location, location + reference_length)

						if(findtext(reference, "\"")) break

						if(!(reference in atom_sets))
							INTERNAL_CRASH("Invalid reference (\"[reference]\") found in '[load_file]'", src)

						if(!(load_preferences & READ_IN_ONLY))
							var/list/data = atom_sets[reference]
							for(var/e in data) build_atom(e, data[e], locate(lowx + x - 1, lowy + y - 1, lowz + z - 1))

						else
							if(!map_arrangement) map_arrangement = new
							map_arrangement += reference

						x ++
					z ++
			while(location)

		else
			z ++
			for(var/a in map_arrangement)
				x ++

				if(x > (highx - lowx + 1))
					x = 1
					y ++

					if(y > (highy - lowy + 1))
						y = 1
						z ++

				if(!(map_arrangement[a] in atom_sets))
					INTERNAL_CRASH("Invalid reference (\"[map_arrangement[a]]\") found in '[load_file]'", src)

				var/list/data = atom_sets[map_arrangement[a]]
				for(var/e in data) build_atom(e, data[e], locate(x, y, z))

	proc/build_atom(type, list/vars, turf/location)
		if(is_ignored_load_type(type)) return

		var/atom/a = new type(location)
		for(var/e in vars)
			if(!(e in a.vars)) INTERNAL_CRASH("Unknown variable \"[e]\" for [a.type] in file '[load_file]'.", src)

			if(isobj(vars[e])) a.vars[e] = copy_object(vars[e], a)
			else a.vars[e] = vars[e]

		if(a) del a.__NEW__