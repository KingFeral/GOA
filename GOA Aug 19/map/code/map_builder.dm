map_builder
	parent_type = /obj
	icon = 'map/media/extras/icons.dmi'
	icon_state = "select"

	var
		ref
		ref_icon
		ref_icon_state
		isSelected = 0
		can_fill = TRUE

	Click()
		var/map_editor_client/mc = usr
		mc.Map_editor.set_selected(src)

	turfs
		grass_1
			name = "Grass 1"
			ref="/turf/grass/grass_1"
			//ref = "grass"
			ref_icon = 'map/media/turf/grass.dmi'
			ref_icon_state = "1"

		grass_2
			name = "Grass 2"
			ref="/turf/grass/grass_2"
			//ref = "grass2"
			ref_icon = 'map/media/turf/grass.dmi'
			ref_icon_state = "2"

		grass_3
			name = "Grass 3"
			ref="/turf/grass/grass_3"
			//ref = "grass3"
			ref_icon = 'map/media/turf/grass.dmi'
			ref_icon_state = "3"

		dirt
			name = "Dirt"
			ref = "/turf/dirt"
			ref_icon = 'map/media/turf/dirt.dmi'

		sand
			name = "Sand"
			ref = "/turf/sand"
			ref_icon = 'map/media/turf/sand_dirt.dmi'
			ref_icon_state="15"