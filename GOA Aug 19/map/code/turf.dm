turf

	#ifdef MAP_EDITOR
	Click()
		if(map_editor_mode)
			var/map_editor_client/MEC = usr
			if(MEC.Map_editor.selected)
				var/Ref = MEC.Map_editor.selected.ref
				var/x = text2path("[Ref]")
				if(x)
					new x(src)
			else
				MEC << "No turf selected."
	#endif

	grass
		grass_1
			icon='map/media/turf/grass_dirt.dmi'
			icon_state="15"
			autojoin=16

		grass_2
			icon='map/media/turf/dgrass_dirt.dmi'
			icon_state="15"
			autojoin=16

		grass_3
			icon='map/media/turf/d2grass_dirt.dmi'
			icon_state="15"
			autojoin=16

		JoinMatch(D)
			var/turf/step = get_step(src,D)

			if( step && istype(step,/turf/grass) )
				return 1

			else if( step && istype(step,/turf/sand) )

				if( src.type == /turf/grass/grass_2 )
					src.icon='map/media/turf/dgrass_sand.dmi'

				else if( src.type == /turf/grass/grass_3 )
					src.icon='map/media/turf/d2grass_sand.dmi'

				else
					src.icon='map/media/turf/grass_sand.dmi'

				..()

	dirt
		icon = 'map/media/turf/dirt.dmi'

		JoinMatch(D)
			var/turf/step = get_step(src,D)

			if( step && step.type==src.type )
				return 1
			else
				..()

	sand
		icon = 'map/media/turf/sand_dirt.dmi'
		icon_state="15"
		autojoin=16

		JoinMatch(D)
			var/turf/step = get_step(src,D)
			if( step && ( step.type == src.type || istype(step,/turf/grass) ) )
				return 1

			else if( step && istype(step,/turf/water) )
				src.icon='map/media/turf/sand_water.dmi'

			else
				..()

	water
		autojoin=16
		icon_state="15"
		icon='map/media/turf/water_dirt.dmi'

		JoinMatch(D)

			var/turf/step = get_step(src,D)

			if(step&&step.type==src.type)
				return 1

			else if( step && istype(step,/turf/sand) )
				src.icon='map/media/turf/water_sand.dmi'

			else if( step && istype(step,/turf/grass) )
				src.icon='map/media/turf/water_grass.dmi'

			else
				..()

