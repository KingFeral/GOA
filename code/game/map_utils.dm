mob/MasterdanVerb/verb
	//Based on Crispy.Mapper
	Make_Minimap(zlevel = usr.z as num)
		var/obj/mapinfo/Minfo =  locate("__mapinfo__[zlevel]")
		if(!Minfo) return

		usr << "Making minimap for z-[zlevel]: [Minfo.oX],[Minfo.oY]"

		////////Send the map to the mob's browser window
		var/icon/map = new

		//Display everything in the world
		for (var/y=world.maxy,y>0,--y)
			sleep()
			for (var/x=1,x<=world.maxx,++x)
				//Turfs
				var/turf/T=locate(x,y,zlevel)
				if (!T) continue
				var/icon/I
				if(T.icon)I=new(T.icon,T.icon_state, frame=1)
				else I=new('icons/transparent.dmi')
				var/under_overlays[0]
				for(var/O in T.underlays)
					if(O:icon)
						under_overlays += O
				for(var/O in T.overlays)
					if(O:icon)
						under_overlays += O
				//Movable atoms
				for (var/obj/A in T)
					//Make sure it's allowed to be displayed
					/*var/allowed=1
					for (var/X in denytypes)
						if (istype(A,X))
							allowed=0
							break
					if (!allowed) continue*/

					if (A.icon) under_overlays += A

				ls_heapsort_cmp(under_overlays, /proc/layer_sort)
				for(var/O in under_overlays)
					var/icon/icon = new(O:icon, O:icon_state, O:dir, frame=1)
					if(O:layer < T.layer) I.Blend(icon,ICON_UNDERLAY)
					else I.Blend(icon,ICON_OVERLAY)

				//Output it
				map.Insert(I, "[x],[y]")
				sleep(-1)

		fcopy(map, "minimap_out/map_[Minfo.oX]_[Minfo.oY].dmi")

	Make_All_Minimaps()
		for(var/z in 1 to world.maxz)
			Make_Minimap(z)
		usr << "Maps done."

	Map_Info(zlevel = usr.z as num)
		var/obj/mapinfo/Minfo =  locate("__mapinfo__[zlevel]")
		if(!Minfo) return

		usr << "Map [Minfo.oX],[Minfo.oY]([zlevel]):"
		usr << "\tControlled by: [Minfo.village_control]"
		if(Minfo.can_capture)
			usr << "\tCan be captured."
		usr << "\tPlayer Counts:"
		for(var/village in Minfo.village_players)
			usr << "\t\t[village] -- [Minfo.village_players[village]]"
		if(Minfo.in_war)
			usr << "\tBeing attacked by: [Minfo.attacking_village]"
			usr << "\t\t[Minfo.attacker_deaths] attacker deaths."
			usr << "\t\t[Minfo.defender_deaths] defender deaths."

		var/map_x = Minfo.oX
		var/map_y = Minfo.oY

		var/adjacent[0]
		for(var/x in list(map_x-1, map_x+1))
			if(x >= 1 && x <= map_coords.len)
				var/obj/mapinfo/map = map_coords[x][map_y+1]
				if(map)
					adjacent += map
		for(var/y in list(map_y, map_y+2))
			var/list/map_col = map_coords[map_x]
			if(y >= 1 && y <= map_col.len)
				var/obj/mapinfo/map = map_col[y]
				if(map)
					adjacent += map
		if(adjacent.len)
			usr << "\tAdjacent Maps:"
			for(var/obj/mapinfo/map in adjacent)
				usr << "\t\t[map.oX],[map.oY] ([map.z]) \"[map.village_control]\""

	All_Map_Info()
		for(var/z in 1 to world.maxz)
			Map_Info(z)

	Add_Players(zlevel = usr.z as num, village in list("Konoha", "Kiri", "Suna", "Missing"), num_players as num)
		var/obj/mapinfo/Minfo =  locate("__mapinfo__[zlevel]")
		if(!Minfo) return

		Minfo.village_players[village] += num_players
		Minfo.RefreshAlert()
		if(Minfo.can_capture) Check_War(Minfo, village)

	Add_Attacker_Deaths(zlevel = usr.z as num, num_players as num)
		var/obj/mapinfo/Minfo =  locate("__mapinfo__[zlevel]")
		if(!Minfo) return
		Minfo.attacker_deaths += num_players

	Add_Defender_Deaths(zlevel = usr.z as num, num_players as num)
		var/obj/mapinfo/Minfo =  locate("__mapinfo__[zlevel]")
		if(!Minfo) return
		Minfo.defender_deaths += num_players

	Debug()
		dd_debugger.extraControlPanelObjects = list()
		for(var/list/map_row in map_coords)
			dd_debugger.extraControlPanelObjects += map_row
		dd_debugger.ControlPanel()
		winshow(usr, "browser-popup", 1)

proc
	layer_sort(x, y)
		return x:layer - y:layer