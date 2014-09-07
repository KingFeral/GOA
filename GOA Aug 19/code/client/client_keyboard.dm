datum
	proc
		key_up(k, client/c)
		key_down(k, client/c)

var
	const
		CUSTOM  = "|1|2|3|4|5|6|7|8|9|0|space|shift|ctrl|alt|tab|a|d|f|z|q|w|u|west|east|north|south|northeast|southeast|northwest|southwest|"

client
	var
		list/keys = CUSTOM

		input_lock = 0

		atom/movable/focus

		use_numpad = 1

		// 1 = translate numpad4 to 4
		// 0 = leave numpad4 as "numpad4"
		translate_numpad_to_numbers = 1

		list/__numpad_mappings = list("numpad0" = "0", "numpad1" = "1", "numpad2" = "2", "numpad3" = "3", "numpad4" = "4", "numpad5" = "5", "numpad6" = "6", "numpad7" = "7", "numpad8" = "8", "numpad9" = "9", "divide" = "/", "multiply" = "*", "subtract" = "-", "add" = "+", "decimal" = ".")

	proc
		lock_input()
			input_lock = 1

		unlock_input()
			input_lock = 0

		clear_input(unlock_input = 1)
			if(unlock_input)
				unlock_input()

			for(var/k in keys)
				keys[k] = 0

	verb
		KeyDown(k as text)
			set hidden = 1
			set instant = 1

			if(input_lock) return

			if(!use_numpad)
				if(k == "northeast")
					k = "page up"
				else if(k == "southeast")
					k = "page down"
				else if(k == "northwest")
					k = "home"
				else if(k == "southwest")
					k = "end"

			if(translate_numpad_to_numbers)
				if(k in __numpad_mappings)
					k = __numpad_mappings[k]

			keys[k] = 1

			if(focus)
				if(hascall(focus, "key_down"))
					focus.key_down(k, src)
				else
					CRASH("'[focus]' does not have a key_down proc.")

		KeyUp(k as text)
			set hidden = 1
			set instant = 1

			if(!use_numpad)
				if(k == "northeast")
					k = "page up"
				else if(k == "southeast")
					k = "page down"
				else if(k == "northwest")
					k = "home"
				else if(k == "southwest")
					k = "end"

			if(translate_numpad_to_numbers)
				if(k in __numpad_mappings)
					k = __numpad_mappings[k]

			keys[k] = 0

			if(input_lock) return

			if(focus)
				if(hascall(focus, "key_up"))
					focus.key_up(k, src)
				else
					CRASH("'[focus]' does not have a key_up proc.")

	New()
		..()
		src.set_macros()

client
	var
		__default_action = list(
			"north" = "North",
			"south" = "South",
			"east" = "East",
			"west" = "West",
			"southeast" = "Southeast",
			"southwest" = "Southwest",
			"northeast" = "Northeast",
			"northwest" = "Northwest",
			"center" = "Center")

	proc
		key_up(k, client/c)


		key_down(k, client/c)

	proc
		set_focus(datum/d)
			src.focus = d

		set_macros()
			var/macros = params2list(winget(src, null, "macro"))

			if(istext(keys))
				keys = split(keys, "|")

			for(var/m in macros)
				for(var/k in keys)
					if(!k) continue()

					keys[k] = 0

					var/escaped = list2params(list("[k]"))

					winset(src, "[m][k]Down", "parent=[m];name=[escaped];command=KeyDown+[escaped]")
					winset(src, "[m][k]Up", "parent=[m];name=[escaped]+UP;command=KeyUp+[escaped]")