/* Operations to save properly:
 *
 * condition = new
 * position = new
 *
 * collect_atom_data()
 * scan_block()
 *
 * convert_condition_list()
 * convert_position_list()
 *
 * build_file()
 *
 */

dynamic_map
	var
		list
			initial_objects
			unique_atoms

			block

			position
			condition

		holding_z = 0

	proc/evaluate_position(string)
		string += ","

		var
			x
			y
			z

			len = length(string)
			c = 1

		for(var/a = 1, a <= len, a ++)
			if(text2ascii(string, a) == 44)

				if(!x) x = text2num(copytext(string, c, a))
				else if(!y) y = text2num(copytext(string, c, a))
				else if(!z) z = text2num(copytext(string, c, a))

				c = a + 1

		. = ((highx - lowx + 1) * ((highy + lowy) - y - 1)) + x + ((highx - lowx + 1) * (highy - lowy + 1) * (z - 1))

	proc/collect_atom_data()
		var/list/atoms = section(locate(lowx, lowy, lowz), locate(highx, highy, highz))
		unique_atoms = new

		var/loop_counter = 0
		for(var/atom/a in atoms)
			SLEEP_ON_LOOP(++ loop_counter)

			var/atom/b = is_unlike_initial(a)
			if(b && !is_ignored_save_type(a))
				unique_atoms[b] = sort(get_unique_vars(b) - "vars" - "x" - "y" - "z" - "loc")

	proc/is_unlike_initial(datum/a)
		if(istype(a, /area))
			return 0
		if(!initial_objects) initial_objects = new
		var/datum/initial

		if(a.type in initial_objects) initial = initial_objects[a.type]
		else
			initial = new a.type(determine_holding_area(a))
			initial_objects[a.type] = initial

		for(var/b in a.vars - list("x", "y", "z", "loc", "vars"))
			if(!issaved(a.vars[b])) continue
			if(b == "contents" && (istype(a, /turf) || istype(a, /area))) continue

			if(istype(a.vars[b], /datum) && initial.vars[b] != a.vars[b]) return a
			else if(istype(a.vars[b], /list) && !are_equal_lists(a.vars[b], initial.vars[b], \
				(b == "verbs" || b == "underlays" || b == "overlays" || b == "contents")))
				return a
			else if(!istype(a.vars[b], /list) && a.vars[b] != initial.vars[b]) return a

		return 0

	proc/determine_holding_area(datum/a)
		if(!holding_z) holding_z = ++ world.maxz

		if(istype(a) && !istype(a, /atom)) return

		if(istype(a, /atom/movable)) return locate(1, 1, holding_z)

		var/x = (initial_objects.len % world.maxx)+1
		var/y = (initial_objects.len % world.maxy)+1

		//return locate(initial_objects.len % world.maxx, (initial_objects.len / world.maxx) % world.maxy, holding_z)
		return locate(x, y, holding_z)

	proc/are_equal_lists(list/a, list/b, ignore_assocation = 0)
		if(!a || !b) return 0

		if(a.len != b.len) return 0
		if(a.len == 0 && b.len == 0) return 1

		for(var/e = 1, e <= a.len, e ++)
			var/i = (!ignore_assocation && isnum(a[e]) ? (a.Find(e)) : (a[e]))
			var/o = (!ignore_assocation && isnum(b[e]) ? (b.Find(e)) : (b[e]))

			if(!i || !o) return 0

			if(istype(i, /list))
				if(istype(o, /list) && !.(i, o)) return 0
				else if(!istype(o, /list)) return 0

			else if(i)
				if(o && i != o) return 0
				else if(!o) return 0

			if(!ignore_assocation && istype(a[i], /list))
				if(istype(b[o], /list) && !.(a[i], b[o])) return 0
				else if(!istype(b[o], /list)) return 0

			else if(!ignore_assocation && a[i])
				if(b[o] && a[i] != b[o]) return 0
				else if(!b[o]) return 0

		return 1

	proc/get_unique_vars(datum/a)
		. = list()

		var/datum/initial = initial_objects[a.type]

		for(var/e in a.vars - "vars" - ((isarea(a) || isturf(a)) ? "contents" : null) - "x" - "y" - "z" - "loc")
			if(istype(a.vars[e], /datum) && initial.vars[e] != a.vars[e]) .[e] = a.vars[e]
			else if(istype(a.vars[e], /list) && !are_equal_lists(a.vars[e], initial.vars[e], \
				(e == "verbs" || e == "underlays" || e == "overlays" || e == "contents")))
				.[e] = a.vars[e]
			else if(!istype(a.vars[e], /list) && a.vars[e] != initial.vars[e]) .[e] = a.vars[e]

	proc/is_ignored_save_type(atom/a)
		if(a.skip_save) return 1

		if(istype(a, /area) && (save_preferences & SKIP_AREA)) return 1
		if(istype(a, /turf) && (save_preferences & SKIP_TURF)) return 1
		if(istype(a, /obj) && (save_preferences & SKIP_OBJ)) return 1
		if(istype(a, /mob))
			if(a:client && (save_preferences & SKIP_CLIENT)) return 1
			else if(a:client && !(save_preferences & SKIP_CLIENT)) return 0

			if(save_preferences & SKIP_MOB) return 1

		return 0

	proc/scan_block()
		block = section(locate(lowx, lowy, lowz), locate(highx, highy, highz))

		var/loop_counter = 0
		for(var/atom/a in block)
			SLEEP_ON_LOOP(++ loop_counter)

			if(is_ignored_save_type(a)) continue

			if("[a.x - lowx + 1], [a.y - lowy + 1], [a.z - lowz + 1]" in condition)
				condition["[a.x - lowx + 1], [a.y - lowy + 1], [a.z - lowz + 1]"] += a
			else condition["[a.x - lowx + 1], [a.y - lowy + 1], [a.z - lowz + 1]"] = list(a)

		del block

	proc/convert_condition_list()
		. = list()

		position.len = (highx - lowx + 1) * (highy - lowy + 1) * (highz - lowz + 1)

		var/loop_counter = 0
		for(var/a in condition)
			SLEEP_ON_LOOP(++ loop_counter)

			var/element = convert_element(condition[a])
			if(!(element in .)) . += element
			position[evaluate_position(a)] = element

		condition = .
		combinations(condition.len)

	proc/combinations(x)
		var/list/combinations[0]

		var/amount = round(log(52, x)) + 1
		if(52 ** (amount) == x) amount ++

		var/list/num[amount]
		for(var/a = 1 to num.len) num[a] = 1

		for(var/a = 1 to x)

			SLEEP_ON_LOOP(a)

			var/string
			for(var/e in num) string = "[num2letter(e)][string]"
			combinations += string

			count_list(num)

		for(var/a = 1 to combinations.len) condition[condition[a]] = combinations[a]

	proc/count_list(list/list)
		var/rollover = 0

		for(var/a = 1 to list.len)
			if(a == 1)
				list[a] ++

				if(list[a] == 53)
					list[a] = 1
					rollover = 1

			else if(rollover)
				list[a] ++

				if(list[a] == 53) list[a] = 1
				else rollover = 0

	proc/convert_element(list/l)
		var
			area/area
			turf/turf

			list
				objs[0]
				mobs[0]
				other[0]

		for(var/atom/a in l)
			if(istype(a, /area)) area = a

			else if(istype(a, /turf)) turf = a

			else if(istype(a, /obj))
				objs += a.type
				if(a in unique_atoms) objs[a.type] = unique_atoms[a]

			else if(istype(a, /mob))
				mobs += a.type
				if(a in unique_atoms) mobs[a.type] = unique_atoms[a]

			else
				other += a.type
				if(a in unique_atoms) other[a.type] = unique_atoms[a]

		//objs = sort(objs)
		//mobs = sort(mobs)
		//other = sort(other)

		. = "("

		if(!area && turf.loc) area = turf.loc

		for(var/a in other) . += "[a][format_vars(other[a])],"
		for(var/a in mobs) . += "[a][format_vars(mobs[a])],"
		for(var/a in objs) . += "[a][format_vars(objs[a])],"

		. += "[turf.type][format_vars((turf in unique_atoms) && unique_atoms[turf])],"
		. += "[area.type][format_vars((area in unique_atoms) && unique_atoms[area])],"

		. = copytext(., 1, length(.)) + ")"

	proc/escape_strings(string)
		. = ""

		var
			previous = 1

			length = length(string)
		for(var/a = 1, a <= length, a ++)
			switch(text2ascii(string, a))
				if(9)	//tab
					. += copytext(string, previous, a) + "\\t"
					previous = a + 1

				if(10)	//linebreak
					. += copytext(string, previous, a) + "\\n"
					previous = a + 1

				if(34)	//quote
					. += copytext(string, previous, a) + "\\\""
					previous = a + 1

				if(91)	//left bracket
					. += copytext(string, previous, a) + "\\\["
					previous = a + 1

				if(92)	//backslash
					. += copytext(string, previous, a) + "\\\\"
					previous = a + 1

				if(255) //newline suppression
					. += copytext(string, previous, a) + "\\..."
					previous = a + 1

		. += copytext(string, previous)

	proc/format_vars(list/vars)
		if(!vars || !vars.len) return

		. = "{"

		var/loop_counter = 0
		for(var/a in vars - "x" - "y" - "z" - "loc" - "vars" - "client")
			SLEEP_ON_LOOP(++ loop_counter)

			. += "[a] = "

			if(isnum(vars[a]) || ispath(vars[a])) . += "[vars[a]]"
			else if(isfile(vars[a])) . += "'[vars[a]]'"
			else if(istext(vars[a])) . += "\"[escape_strings(vars[a])]\""
			else if(istype(vars[a], /list))
				. += "[format_list(vars[a], (a == "verbs" || a == "underlays" || a == "overlays" || a == "contents"))]"
			else if(isnull(vars[a])) . += "null"
			else if(isobject(vars[a]))
				var/datum/e = vars[a]

				. += "new [e.type || e]"

				e = is_unlike_initial(e)
				if(e) . += format_vars(get_unique_vars(e) - "vars")
				. += "()"

			. += "; "

		. = copytext(., 1, length(.) - 1) + "}"

	proc/format_list(list/l, skip_association = 0)
		. = "list("

		var/loop_counter = 0
		for(var/a in l)
			SLEEP_ON_LOOP(++ loop_counter)

			if(isnum(a) || ispath(a)) . += "[a]"
			else if(isfile(a)) . += "'[a]'"
			else if(istext(a)) . += "\"[escape_strings(a)]\""
			else if(istype(a, /list)) . += "[.(a)]"
			else if(isnull(a)) . += "null"

			if(isobject(a))
				. = "[skip_association ? "new " : ""][.]"
				. += "[skip_association ? "" : "new "][a:type]"

				var/datum/e = is_unlike_initial(a)
				if(e)
					if(skip_association)
						var/unique_vars = format_vars(get_unique_vars(e))
						if(unique_vars) . += "{[unique_vars]}"

					else if(!skip_association) . += "[format_vars(get_unique_vars(e), 1)]"

				. += "()"

			if(!skip_association && (!isnum(a) || a <= l.len && a > 0) && l[a])

				if(!isnum(a) && isnum(l[a]) || ispath(l[a])) . += " = [l[a]]"
				else if(isfile(l[a])) . += " = '[escape_strings(l[a])]'"
				else if(istext(l[a])) . += " = \"[l[a]]\""
				else if(istype(l[a], /list)) . += " = [.(l[a])]"
				else if(isnull(l[a])) . += " = null"

				else if(isobject(a))
					. = "new[.]"
					. += "[a:type]"

					var/datum/e = is_unlike_initial(a)
					if(e)
						var/unique_vars = format_vars(get_unique_vars(e))
						if(unique_vars) . += " = {[unique_vars]}"

			. += ", "

		var/len = length(.)
		. = copytext(., 1, len && len - 1) + ")"

	proc/convert_position_list()
		. = list()

		var/loop_counter = 0
		for(var/a = 1 to position.len)
			SLEEP_ON_LOOP(++ loop_counter)

			. += condition[position[a]]
		position = .

	proc/build_file(filename)
		var/loop_counter = 0
		for(var/a in condition)
			if(!(++ loop_counter % 26))
				sleep(-1)

				text2file(copytext(., 1, length(.)), "[filename]")
				. = null

			. += "\"[condition[a]]\" = [a]\n"

		var
			x = 1
			y = 1
			z = 1

			x_bound = highx - lowx + 1
			y_bound = highy - lowy + 1
			z_bound = highz - lowz + 1

		. += "\n(1,1,[z]) = {\"\n"

		for(var/a in position)
			x ++
			. += "[a]"

			if(x > x_bound)
				x = 1
				y ++
				. += "\n"

				if(y > y_bound)
					y = 1
					z ++
					. += "\"}\n"

					if(z > z_bound) break

					. += "\n(1,1,[z]) = {\"\n"

		text2file(copytext(., 1, length(.)), "[filename]")

	proc/clear_initial_objects_list()
		var/atom
			first
			last

		for(var/a in initial_objects)
			var/atom/e = initial_objects[a]
			if(istype(e) && e.z)
				first = e
				break

		for(var/a = initial_objects.len, a > 0, a --)
			var/atom/e = initial_objects[initial_objects[a]]
			if(istype(e) && e.z)
				last = e
				break

		if(first && last) world.maxz -= (last.z - first.z + 1)
		else world.maxz --

		del initial_objects