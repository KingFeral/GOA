world
	name = "GOA Mapmaking Kit"
	view = 10
	maxx = 1
	maxy = 1
	maxz = 1

var
	rock_turf_types = list(/turf/Terrain/rockyground,/turf/Terrain/Dirt,/turf/Terrain/LightDirt,/turf/Terrain/Sand,/turf/Terrain/DDGrass,/turf/Terrain/DGrass,/turf/Terrain/Grass)
	flower_turf_types = list(/turf/Terrain/DDGrass,/turf/Terrain/DGrass,/turf/Terrain/Grass)
	rock_types = typesof(/obj/rocks)
	flower_types = list(/obj/flowers/flower2,/obj/flowers/flower1,/obj/flowers/flower3,/obj/flowers/flower4,/obj/flowers/flower5)

mob
	verb
		Change_Z(zlevel as num)
			set category = "Movement"
			z = zlevel
			usr << "Warped to Z [zlevel]."

		Toggle_Density()
			set category = "Movement"
			density = !density
			usr << "You are now [density?"dense":"not dense"]."

		//Based on Crispy.Mapper
		Export_Map_Image(zlevel as num)
			set category = "Map Images"
			var/obj/mapinfo/Minfo =  locate("__mapinfo__[zlevel]")
			if(!Minfo) return

			usr << "Exporting map image for z-[zlevel]: [Minfo.oX],[Minfo.oY]"

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

					var/underlays[0]
					var/overlays[0]
					for(var/O in T.underlays)
						if(O:icon)
							if(O:layer <= T.layer)
								underlays += O
							else
								overlays += O

					for(var/O in T.overlays)
						if(O:icon)
							if(O:layer >= T.layer)
								overlays += O
							else
								underlays += O

					for (var/obj/A in T)
						if (A.icon)
							if(A.layer >= T.layer)
								overlays += A
							else
								underlays += A

					ls_heapsort_cmp(underlays, /proc/underlay_sort)
					ls_heapsort_cmp(overlays, /proc/overlay_sort)
					for(var/O in underlays)
						var/icon/icon = new(O:icon, O:icon_state, O:dir, frame=1)
						I.Blend(icon,ICON_UNDERLAY)
					for(var/O in overlays)
						var/icon/icon = new(O:icon, O:icon_state, O:dir, frame=1)
						I.Blend(icon,ICON_OVERLAY)

					//Output it
					map.Insert(I, "[x],[y]")
					sleep(-1)

			fcopy(map, "minimap_out/map_[Minfo.oX]_[Minfo.oY].dmi")

		Export_All_Maps()
			set category = "Map Images"
			for(var/z in 1 to world.maxz)
				Export_Map_Image(z)
			usr << "Maps done."

		Process_Map(zlevel as num)
			set category = "Processing"
			for(var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
				T.Process()
				for(var/atom/A in T)
					A.Process()
					sleep(-1)
				sleep(-1)
			usr << "Processed map [zlevel]."

		Scatter_Rocks(zlevel as num, turf_type in rock_turf_types, percentage as num)
			set category = "Processing"
			percentage = min(percentage, 100)
			for(var/turf/X in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
				var/fail=0
				if(locate(/obj) in X)
					fail=1
				if(istype(X,turf_type) && !fail)
					if(prob(percentage))
						var/Fe=pick(rock_types)
						var/obj/F=new Fe(X.loc)
						F.loc=X
						F.pixel_x=rand(0,25)
						F.pixel_y=rand(0,25)

		Scatter_Flowers(zlevel as num, turf_type in flower_turf_types, percentage as num)
			set category = "Processing"
			percentage = min(percentage, 100)
			for(var/turf/X in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
				var/fail=0
				if(locate(/obj) in X)
					fail=1
				if(istype(X,turf_type) && !fail)
					if(prob(percentage))
						var/Fe=pick(flower_types)
						var/obj/F=new Fe(X.loc)
						F.loc=X
						F.pixel_x=rand(0,32)
						F.pixel_y=rand(0,32)


		Load_Map(map as text)
			set category = "Files"
			load_map("[map]", "[map].dmm", locate(1,1,1))
			usr << "Loaded map '[map].dmm'."

		Load_Map_With_Processing(map as text)
			set category = "Files"
			var/orig_z = world.maxz
			Load_Map(map)
			for(var/zlevel in orig_z to world.maxz)
				Process_Map(zlevel)

		Save_Map(map as text)
			set category = "Files"
			if(fexists("[map]dump.dmm"))
				fdel("[map]dump.dmm")
			save_map("[map]","[map]dump.dmm",SKIP_CLIENT)
			usr << "Saved map '[map]dump.dmm'."

proc
	layer_sort(x, y)
		return x:layer - y:layer
	overlay_sort(x, y)
		if(x:layer < 0 || y:layer < 0)
			if(x:layer < 0 && y:layer < 0)
				return x:layer - y:layer
			else if(x:layer < 0)
				return -1
			else
				return 1
		return x:layer - y:layer
	underlay_sort(x, y)
		if(x:layer < 0 || y:layer < 0)
			if(x:layer < 0 && y:layer < 0)
				return x:layer - y:layer
			else if(x:layer < 0)
				return 1
			else
				return -1
		return x:layer - y:layer