

mob/var
	obj/mapicon
	obj/pinred
	obj/pinblue
	obj/pinwhite
	obj/pingreen

obj/pin
	icon='icons/new/minimap/pins.dmi'
	var/mob/pinowner

mob/human/New()
	..()
	Pinspawn()
	maploop()

mob/proc/maploop()
	set background = 1
	set waitfor = 0
	while(src && src.client)
		for(var/obj/pin/O in src.client.screen)
			if(!O:pinowner)
				src.client.screen-=O
		if(src.squad)
			for(var/mob/M in squad.online_members)
				src.client.screen+=M.pingreen
		//if(src.z==MAINMAP)
		for(var/obj/pin/X in src.client.screen)
			if(X.icon_state=="squad")
				if(!X.pinowner)src.client.screen-=X
				if(src.squad)
					if(X.pinowner!=src.MissionTarget &&(!(X.pinowner in src.squad.online_members)))
						src.client.screen-=X
				else
					if(X.pinowner!=src.MissionTarget)
						src.client.screen-=X
		if(src.MissionTarget)
			src.client.screen+=src.MissionTarget:pingreen

		sleep(10)

mob
	verb
		Check_Map()
			src.Look_Map()
		checkmap()
			src.Look_Map()

mob
	proc/Pinspawn()
		set waitfor = 0
		if(!src.pinblue)
			src.pinblue= new/obj/pin()
			src.pinblue.icon_state="black"
			src.pinblue.layer=3.3
		if(!src.pingreen)
			src.pingreen= new/obj/pin()
			src.pingreen.icon_state="squad"
			src.pingreen.layer=3.1
		if(!src.pinwhite)
			src.pinwhite= new/obj/pin()
			src.pinwhite.icon_state="white"
			src.pinwhite.layer=3
		if(!src.pinred)
			src.pinred= new/obj/pin()
			src.pinred.icon_state="red"
			src.pinred.layer=3.2
		src.pinblue:pinowner=src
		src.pinred:pinowner=src
		src.pingreen:pinowner=src
		src.pinwhite:pinowner=src
		src.pinblue.icon='icons/new/minimap/pins.dmi'
		src.pinblue.icon_state="black"
		if(src.client)src.client.screen+=src.pinblue
		sleep(30)
		src.Pinrefresh()
		if(src.client)src.Reload_Map()

	proc/Pinrefresh()
		var/obj/mapinfo/Minfo =  locate("__mapinfo__[z]")
		if(Minfo)
			var/m_x = round(x*(32/100))-15
			var/m_y = round(y*(32/100))-16

			if(!src.pinblue)return

			var/m_X = MAP_START_X+Minfo.oX-1
			var/m_Y = MAP_START_Y-Minfo.oY

			src.pinblue.screen_loc="map2:[m_X]:[m_x],[m_Y]:[m_y]"
			src.pingreen.screen_loc="map2:[m_X]:[m_x],[m_Y]:[m_y]"
			src.pinred.screen_loc="map2:[m_X]:[m_x],[m_Y]:[m_y]"
			src.pinwhite.screen_loc="map2:[m_X]:[m_x],[m_Y]:[m_y]"

	proc/Reload_Map()
		if(!src.mapicon)
			src.mapicon=new/obj()
			src.mapicon.screen_loc="map2:1,1"
			src.mapicon.layer=TURF_LAYER
			src.mapicon.icon='map/map.png'

		if(src.client)
			src.client.screen+=src.mapicon
			winset(src, "minimap", "is-visible=true")
		src.Pinrefresh()

	proc/Refresh_Map()
		if(!src.mapicon)
			src.mapicon=new/obj()
			src.mapicon.screen_loc="map2:1,1"
			src.mapicon.layer=TURF_LAYER
		var/obj/I=src.mapicon
		I.icon='map/map.png'

		if(src.client)
			src.client.screen+=	I
			src.Pinrefresh()

mob/TargetAdded(mob/human/M, active=0, silent=0)
	if(M&&M.pinred)
		if(src.client) src.client.screen+=M.pinred
	..()
mob/RemoveTarget(mob/human/M, in_filter=0)
	if(M&& M.pinred)
		if(src.client) src.client.screen-=M.pinred
	..()

mob/verb/popupmap()

	if(winget(src, "minimap_window", "is-visible")=="true")
		winset(src, "minimap_window", "is-visible=false")
		winset(src, "minimap_window_child", "left=map_pane2")
	else
		winset(src, "child1", "left=map_pane")
		winset(src, "minimap_window", "is-visible=true")
		winset(src, "minimap_window_child", "left=map_pane2")
		winset(src,"child1","focus=true")