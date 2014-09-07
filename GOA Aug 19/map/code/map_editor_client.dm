var/map_editor_mode = 0

map_editor_client
	parent_type=/mob
	icon = 'map/media/extras/mob.dmi'

	var
		player/Main = null
		map_editor/Map_editor

	New(player/main, var/loc)
		Main = main
		src.loc = loc
		main.map_editor = src
		main.client.mob = src
		client.mouse_pointer_icon = 'map/media/extras/mouse.dmi'
		client.control_freak = CONTROL_FREAK_SKIN
		Map_editor = new(src)

	Logout()
		loc = null

	verb
		Close_Editor()
			winset(src.client, "main", "can-close=true")
			Main.loc = loc
			client.mouse_pointer_icon = null
			client.mob = Main
			map_editor_mode = 0
			//Save()

		Change_Selection(selection as text)
			if(selection == "grid")
				winset(src.client, "child2", "left=mapeditor_map2")
				winset(src.client, "child5", "left=mapeditor_grid")
				winset(src.client, "mapeditor", "size=416x689")

			else if(selection == "turfs")
				winset(src.client, "child2", "left=mapeditor_turfs")
				winset(src.client, "mapeditor", "size=416x436")

			else if(selection == "objs")
				winset(src.client, "child2", "left=mapeditor_objs")
				winset(src.client, "mapeditor", "size=416x436")

			else if(selection == "npcs")
				winset(src.client, "child2", "left=mapeditor_npcs")
				winset(src.client, "mapeditor", "size=416x436")

			else if(selection == "options")
				winset(src.client, "child2", "left=mapeditor_options")
				winset(src.client, "mapeditor", "size=416x436")

		Create_Map()
			Map_editor.create_map()

		Zoom_Out()
			if(winget(src.client, "map1", "icon-size") == "32")
				winset(src.client, "map1", "icon-size=16")
				Resize()

			else if(winget(src.client, "map1", "icon-size") == "16")
				winset(src.client, "map1", "icon-size=8")
				Resize()

			else if(winget(src.client, "map1", "icon-size") == "8")
				return

		Zoom_In()
			if(winget(src.client, "map1", "icon-size") == "8")
				winset(src.client, "map1", "icon-size=16")
				Resize()

			else if(winget(src.client, "map1", "icon-size") == "16")
				winset(src.client, "map1", "icon-size=32")
				Resize()

			else if(winget(src.client, "map1", "icon-size") == "32")
				return

		Resize()
			var/icon_size = text2num(winget(src, "map1", "icon-size"))
			var/size = winget(src, "map1", "size")
			var/x = copytext(size, 1, findtext(size, "x") )
			var/y = copytext( size, findtext(size, "x")+1 )

			x = text2num(x)
			y = text2num(y)

			x = Ceil(x/icon_size)
			y = Ceil(y/icon_size)

			client.view = "[x]x[y]"

	proc
		Save()
			var/dmm_suite/D = new()
			var/turf/south_west_deep = locate(1,1,1)
			var/turf/north_east_shallow = locate(world.maxx,world.maxy,world.maxz)
			D.save_map(south_west_deep, north_east_shallow, "map", flags=DMM_IGNORE_PLAYERS)

proc
	Make_Minimap(zlevel)
		var/Map/Minfo =  locate("__Map__[zlevel]")
		if(!Minfo) return

		////////Send the map to the mob's browser window
		var/icon/map = new

		//Display everything in the world
		for (var/y=world.maxy,y>0,--y)
			for (var/x=1,x<=world.maxx,++x)
				//Turfs
				var/turf/T=locate(x,y,zlevel)
				if (!T) continue
				var/icon/I
				if(T.icon)I=new(T.icon,T.icon_state, frame=1)
				else I=new('map/media/extras/transparent.dmi')
				var/under_overlays[0]
				for(var/O in T.underlays)
					if(O:icon)
						under_overlays += O
				for(var/O in T.overlays)
					if(O:icon)
						under_overlays += O
				//Movable atoms
				for (var/obj/A in T)
					if (A.icon) under_overlays += A

				ls_heapsort_cmp(under_overlays, /proc/layer_sort)
				for(var/O in under_overlays)
					var/icon/icon = new(O:icon, O:icon_state, O:dir, frame=1)
					if(O:layer < T.layer) I.Blend(icon,ICON_UNDERLAY)
					else I.Blend(icon,ICON_OVERLAY)

				//Output it
				map.Insert(I, "[Minfo.oX],[Minfo.oY]")
				sleep(-1)

		fcopy(map, "maps/media/extras/maps.dmi")

var
	AllTurfImages[0]
	AllObjImages[0]
	AllNPCImages[0]