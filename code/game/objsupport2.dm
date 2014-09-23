obj/Water_sides
	icon='icons/water.dmi'
	layer=TURF_LAYER+0.1
	density=0
	var
		sleepdie=100
	wl
		icon_state="left"
	wr
		icon_state="right"
	wd
		icon_state="down"
	wu
		icon_state="up"
	w0l
		icon_state="left"
	w0r
		icon_state="right"
	w0d
		icon_state="down"
	w0u
		icon_state="up"

	Del()
		if(loc == null) return ..()
		loc = null

obj/Water

	icon='icons/water.dmi'
	icon_state="still"
	layer=TURF_LAYER+1
	water_sides
		move
			icon_state="move"
		tl
			icon_state="tl"
		tr
			icon_state="tr"
		bl
			icon_state="bl"
		br
			icon_state="br"
	water_fod
		icon='icons/fodturf.dmi'
		icon_state="water"
		tl
			icon_state="water_tl"
		tr
			icon_state="water_tr"
		bl
			icon_state="water_bl"
		br
			icon_state="water_br"
	var
		sleepdie=0
	Enter(atom/movable/O)
		if(istype(O,/mob/human))
			if(O:curchakra>=15)
				O:curchakra-=15
				O:waterlogged=1
				return 1
			else
				return 0
		else
			return 1

	Exit(atom/movable/O)
		if(istype(O,/mob/human))
			O:waterlogged=0
			return 1
		else
			return 1
		..()