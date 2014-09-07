Map
	density=0
	parent_type = /obj
	icon = 'map/media/extras/maps.dmi'
	icon_state = "default"
	var
		oX=0
		oY=0
		village_control = "Missing"
		can_capture = 1
		base_capture = 1

	New()
		. = ..()
		tag = "__Map__[z]"
		name = "Map z[z] ([oX], [oY])"
		//map_coords[oX][oY+1] = src

	DblClick()
		Make_Minimap(src.z)

	MouseDrop(obj/over_object, src_location, over_location, src_control, over_control, params_text)
		if(src == over_object)
			return

		if(istype(over_object, /grid) )
			var/grid/G = over_object
			oX = G.oX
			oY = G.oY
			name = "Map z[z] ([oX], [oY])"
			tag = "__Map__[z]"
			//map_coords[oX][oY+1] = src
			screen_loc = G.screen_loc

	proc
		CanLeave(player/P)
			return 1

		CanEnter(player/P)
			return 1

		PlayerEntered(player/P)

		PlayerLeft(player/P)


var
	map_coords[9][10]

atom
	var
		gx=9000
		gy=9000
	proc

		Global_Coords()
			Get_Global_Coords()
			if(gx && gy)
				var/XY[2]
				XY[1]=gx
				XY[2]=gy
				return XY

		Get_Global_Coords()
			var/Map/Minfo =  locate("__Map__[z]")
			if(Minfo)
				var/Map/M=Minfo
				gy = 100 - y + (M.oY) * 100
				gx = x + (M.oX - 1) * 100
			else
				gy = 0
				gx = 0