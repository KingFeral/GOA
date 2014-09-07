map_editor
	var
		grids[0]
		maps[0]
		builders[0]
		map_editor_client/owner

		map_builder/selected = null

	New(map_editor_client/m)
		owner = m
		initialize_grids()
		initialize_maps()
		initialize_builders()
		update_editor_grids()

	proc/set_selected(map_builder/m)
		if(src.selected)
			src.selected.icon_state = "select"
		src.selected = m
		selected.icon_state = "selected"
		src.update_editor_grids()

	proc

		initialize_maps()

			for( var/Map/M )
				owner:client.screen += M
				maps += M

				if(M.oX != 0 && M.oY != 0)
					for( var/grid/G in grids)
						if(M.oX == G.oX && M.oY == G.oY)
							M.screen_loc = G.screen_loc

			update_map_grid()

		initialize_grids()
			for( var/x in typesof(/grid) )
				var/grid/G = new x(owner.client)
				if(G.name=="grid")
					del G

					continue

				grids += G

		initialize_builders()
			for( var/x in typesof(/map_builder) )
				var/map_builder/MB = new x()
				if(MB.name=="map builder"||MB.name=="turfs")
					del MB

					continue

				builders += MB

		update_map_grid()

			var/grid_item = 0

			for(var/Map/M in maps)
				owner << output(M, "map_grid:[++grid_item]")

			winset(owner, "map_grid", "cells=[grid_item]")

		update_editor_grids()
			winset(owner,"turf_grid",{"cells="2x[builders.len]""})

			var/i=0
			for(var/map_builder/turfs/MBT in builders)
				owner << output(MBT,"turf_grid:1,[++i]")
				var/image/img = new/image(icon = MBT.ref_icon, icon_state = MBT.ref_icon_state)
				owner << output("<span class='buildericon'><IMG CLASS=icon SRC=\ref[img.icon] ICONSTATE='[img.icon_state]'>", "turf_grid:2,[i]")

		create_map()

			world.maxz += 1

			var/Map/map = new()
			map.loc = locate(1,world.maxy,world.maxz)
			map.icon_state = "default"
			owner:client.screen += map

			maps += map

			for(var/x = 1 to world.maxx)
				for(var/y = 1 to world.maxy)
					if(x < world.maxx || y < world.maxy)
						new/turf/dirt( locate( x, y, world.maxz ) )