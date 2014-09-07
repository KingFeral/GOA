/*
 ******************************
 * Deadron's Debugger Library *
 ******************************

 This is a convenient little library that assists in debugging your games.
 Mainly it lets you look at data in the game: You can see all the variables for Turfs,
 Areas, other mobs, objects, etc.  You can even go inside savefiles (though sometimes
 that has unexpected results, like creating the objects it reads in the savefile)..

 When you aren't sure why something is going wrong, run the game, call up the debugger
 and poke around.

 See the demo to find out all you need to know for setting this up.
*/

#define SPACES					"&nbsp;&nbsp;&nbsp;&nbsp;"

// Debugger release stuff
var/deadron/Debugger/dd_debugger

world/New()
	dd_debugger = new()
	return ..()

deadron/Debugger
	var
		list/extraControlPanelObjects			// Objects you want to add to the list that show up in ControlPanel().
												// Can be passed in new().

	Topic(T)
		var/O = locate(T)
		if (O)
			Debug(O)
			return

		var/list/commands = dd_text2list(T, ":")
		switch(commands[1])
			if ("control_panel")
				ControlPanel()
				return

			if ("savefile")
				var/savefile/F = new(commands[2])
				DebugSavefile(F, commands[3])
				return

			if ("mobs")
				var/all_mobs = 0
				switch(commands[2])
					if ("view")
						DebugMobs(all_mobs)
					if ("all")
						all_mobs = 1
						DebugMobs(all_mobs)
				return

			if ("objs")
				var/all_objs = 0
				switch(commands[2])
					if ("view")
						DebugObjs(all_objs)
					if ("all")
						all_objs = 1
						DebugObjs(all_objs)
				return

			if ("areas")
				DebugAreas()

			if ("turfs")
				DebugTurfs()
		return

	New(controlPanelObjects)
		extraControlPanelObjects = new()
		if (controlPanelObjects)
			extraControlPanelObjects += controlPanelObjects
		return ..()

	proc
		ControlPanel()
			var/page = "<H2>Deadron's Deft Debugger</H2>"
			page += "Pick an object to examine.<BR><BR>"

			page += "<table border=1 cellpadding=3>"

			page += "<tr>"
			page += "<td><a href=\"byond://#\ref[src]\ref[usr]\">[usr]</a></td>"
			page += "<td>&nbsp;</td>"
			page += "</tr>"

			page += "<tr>"
			var/area/area
			var/usr_loc = usr.loc
			if (usr_loc)
				area = usr.loc:loc
				page += "<td><a href=\"byond://#\ref[src]\ref[area]\">my area</a></td>"
			else
				page += "<td>&nbsp;</td>"

			page += "<td><a href=\"byond://#\ref[src]areas\">all areas</a></td>"
			page += "</tr>"

			if (world.maxx)
				// Only show turf options if there is a map.
				page += "<tr>"
				page += "<td><a href=\"byond://#\ref[src]\ref[usr.loc]\">my turf</a></td>"
				page += "<td><a href=\"byond://#\ref[src]turfs\">turfs in view</a></td>"
				page += "</tr>"

			page += "<tr>"
			page += "<td><a href=\"byond://#\ref[src]mobs:view\">mobs in view</a></td>"
			page += "<td><a href=\"byond://#\ref[src]mobs:all\">all mobs</a></td>"
			page += "</tr>"

			page += "<tr>"
			page += "<td><a href=\"byond://#\ref[src]objs:view\">objs in view</a></td>"
			page += "<td><a href=\"byond://#\ref[src]objs:all\">all objs</a></td>"
			page += "</tr>"
			page += "</table>"

			if (extraControlPanelObjects.len)
				page += "<br><br><br>"
				page += "<table border=1 cellpadding=3>"
				page += "<tr><th>Extra objects</th></tr>"
				var/current
				for (current in extraControlPanelObjects)
					page += "<tr><td><a href=\"byond://#\ref[src]\ref[current]\">[current]</a></td></tr>"
				page += "</table>"
			Browse(page)

		origControlPanel()
			var/page = "<H2>Deadron's Deft Debugger</H2>"
			page += "Pick an object to examine.<BR><BR>"

			var/area/area
			var/usr_loc = usr.loc
			if (usr_loc)
				area = usr.loc:loc
				page += "<a href=\"byond://#\ref[src]\ref[area]\">my area</a> | "

			page += "<a href=\"byond://#\ref[src]areas\">all areas</a><BR>"

			if (world.maxx)
				// Only show turf options if there is a map.
				page += "<a href=\"byond://#\ref[src]\ref[usr.loc]\">my turf</a> | "
				page += "<a href=\"byond://#\ref[src]turfs\">turfs in view</a><BR>"

			page += "<a href=\"byond://#\ref[src]\ref[usr]\">[usr]</a> | "
			page += "<a href=\"byond://#\ref[src]mobs:view\">mobs in view</a> | "
			page += "<a href=\"byond://#\ref[src]mobs:all\">all mobs</a><BR>"

			page += "<a href=\"byond://#\ref[src]objs:view\">objs in view</a> | "
			page += "<a href=\"byond://#\ref[src]objs:all\">all objs</a><BR><BR>"

			var/current
			for (current in extraControlPanelObjects)
				page += "<a href=\"byond://#\ref[src]\ref[current]\">[current]</a><BR>"
			Browse(page)

		Browse(page)
			usr << browse(page)
			// NOW: Have to add navigation.
//			usr << browse(page, "window=debug;size=300x300")

		DebugMobs(all_mobs = 0)
			var/page = "<a href=\"byond://#\ref[src]control_panel\">\[Debugger control panel]</a><BR><BR>"
			var/mob/M
			if (all_mobs)
				page += "<strong>Mobs in world:</strong><BR>"
				for (M in world)
					page += "<a href=\"byond://#\ref[src]\ref[M]\">[M]</a><BR>"
			else
				page += "<strong>Mobs in view:</strong><BR>"
				for (M in view(usr))
					page += "<a href=\"byond://#\ref[src]\ref[M]\">[M]</a><BR>"
			Browse(page)

		DebugObjs(all_objs = 0)
			var/page
			var/obj/O
			if (all_objs)
				page += "<strong>Objs in world:</strong><BR>"
				for (O in world)
					page += "<a href=\"byond://#\ref[src]\ref[O]\">[O.type]: [O]</a><BR>"
			else
				page += "<strong>Objs in view:</strong><BR>"
				for (O in view(usr))
					page += "<a href=\"byond://#\ref[src]\ref[O]\">[O]</a><BR>"
			Browse(page)

		DebugAreas()
			var/page = "<strong>Areas in world:</strong><BR>"
			var/area/A
			for (A in world)
				page += "<a href=\"byond://#\ref[src]\ref[A]\">[A]</a><BR>"
			Browse(page)

		DebugTurfs()
			var/page = "<strong>Turfs in view:</strong><BR>"
			var/turf/T
			for (T in view(usr))
				page += "x:[T.x] y:[T.y] -- <a href=\"byond://#\ref[src]\ref[T]\">[T]</a><BR>"
			Browse(page)

		Debug(O)
			// Workaround here to lists not being caught by istype() for some reason.
			if (istype(O, /list))
				DebugList(O)
			else if (istype(O, /savefile))
				DebugSavefile(O)
			else
				DebugObject(O)

		DebugList(list/L)
			var/length = L.len
			var/page = "<H2>List with [length] items</H2>"

			page += "<table>"
			var/current
			var/count
			for (count = 1, count <= length, count++)
				page += "<tr>"
				current = L[count]
				page += "<td>[count]</td>" + _outputText(current)
				page += "</tr>"
			if (!length)
				page += "<tr><td>\[no items]</td></tr>"
			page += "</table>"
			Browse(page)

		DebugObject(O)
		/*	var/page = "<H2>[O]</H2>"

			// dd_sortedtextlist() doesn't preserve associated list values so can't just sort the variables list.
			var/list/variables = O:vars
			var/list/sorted_names = dd_sortedtextlist(variables)

			// NOW: Sort this.
			page += "<table border=1 cellpadding=3>"
			page += "<tr><th>Variable name</th><th>Value</th><th>Type</th></tr>"
			var/V
			for(V in sorted_names)
				page += "<tr>"
				var/this_var = variables[V]
				page += "<td>[V]</td>" + _outputText(this_var)
				page += "</tr>"
			page += "</table>"
			Browse(page)*/

		origDebugObject(O)
			var/page = "<H2>[O]</H2>"
			var/variables = O:vars

			// NOW: Sort this.
			page += "<table>"
			var/V
			for(V in variables)
				page += "<tr>"
				var/this_var = variables[V]
				page += "<td>[V]</td>" + _outputText(this_var)
				page += "</tr>"
			page += "</table>"
			Browse(page)

		DebugSavefile(savefile/F, directory = "/")
			var/page = "<H2>[F]</H2>"
			page += "[directory]<BR><BR>"

			F.cd = directory
			var/list/dirs = F.dir
			if (!dirs.len)
				var/value
				F >> value
				page += "[value]"

				// Handle any additional values in this directory.
				while(value)
					F >> value
					if (value)
						page += "<BR>[value]"
				Browse(page)
				return

			var/current_value
			var/current_dir
			var/list/current_subdirs
			var/current
			for (current in dirs)
				if (directory == "/")
					current_dir = "/[current]"
				else
					current_dir = "[directory]/[current]"

				// See if it is a directory -- if not, it's a value, so show the value.
				F.cd = current_dir
				current_subdirs = F.dir
				if (current_subdirs.len)
					page += "<a href=\"byond://#\ref[src]savefile:[F]:[current_dir]\">[current]</a>[SPACES]\[directory]<BR>"
				else
					F >> current_value
					page += "[current] = <strong>[current_value]</strong>[SPACES]\[value]<BR>"
					while(current_value)
						F >> current_value
						if (current_value)
							page += "<BR>[SPACES][current_value][SPACES]\[value]<BR>"

				// Go back to parent directory.
				F.cd = directory
			Browse(page)

		_outputText(O)
			if (istext(O))
				return "<td><strong>[O]</strong></td><td>\[text]</td>"
			else if (isnum(O))
				return "<td><strong>[O]</strong></td><td>\[number]</td>"
			else if (isnull(O))
				return "<td>&nbsp;</td><td>\[null]</td>"
			else if (istype(O, /list))
				return "<td><a href=\"byond://#\ref[src]\ref[O]\">[O]</a></td><td>\[list]</td>"
			else if (istype(O, /savefile))
				var/directory = "/"
				return "<td><a href=\"byond://#\ref[src]savefile:[O]:[directory]\">[O]</a></td><td>\[savefile]</td>"
			return "<td><a href=\"byond://#\ref[src]\ref[O]\">[O]</a></td><td>\[object]</td>"


