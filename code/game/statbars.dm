obj
	stambar
		layer=10
	//	icon='stambar.dmi'
		var
			segment=0
	chakrabar
		layer=10
	//	pixel_y=9
	//	pixel_x=-1
	//	icon='chakrabar.dmi'
		var
			segment=0
	woundbar
		layer=10
	//	icon='woundbar.dmi'
		var
			segment=0
	stambarbase
		layer=10
		icon='icons/chakrabar.dmi'
		var
			segment=0
		New(client/C)
			var/obj/stambar/o1=new/obj/stambar(C)
			var/obj/stambar/o2=new/obj/stambar(C)
			var/obj/stambar/o3=new/obj/stambar(C)
			var/obj/stambar/o4=new/obj/stambar(C)
			var/obj/stambar/o5=new/obj/stambar(C)
			o1.segment=1
			o2.segment=2
			o3.segment=3
			o4.segment=4
			o5.segment=5
			if(C)
				C.mob.player_gui+=o1
				C.mob.player_gui+=o2
				C.mob.player_gui+=o3
				C.mob.player_gui+=o4
				C.mob.player_gui+=o5

			o2.overlays+=image('icons/stambar.dmi',pixel_y=14,pixel_x=-1)
			o3.overlays+=image('icons/stambar.dmi',pixel_y=14,pixel_x=-1)
			o4.overlays+=image('icons/stambar.dmi',pixel_y=14,pixel_x=-1)
			o5.overlays+=image('icons/stambar.dmi',pixel_y=14,pixel_x=-1)
			o1.screen_loc="2,17"
			o2.screen_loc="3,17"
			o3.screen_loc="4,17"
			o4.screen_loc="5,17"
			o5.screen_loc="6,17"
			o1.layer++
			o1.overlays+=image('icons/stambar.dmi',icon_state="0,0",pixel_y=-10,layer=11)
			o2.overlays+=image('icons/stambar.dmi',icon_state="1,0",pixel_y=-10,layer=11)
			o3.overlays+=image('icons/stambar.dmi',icon_state="2,0",pixel_y=-10,layer=11)
			o4.overlays+=image('icons/stambar.dmi',icon_state="3,0",pixel_y=-10,layer=11)
			o5.overlays+=image('icons/stambar.dmi',icon_state="4,0",pixel_y=-10,layer=11)
			o1.overlays+=image('icons/stambar.dmi',icon_state="0,1",pixel_y=22,layer=11)
			o2.overlays+=image('icons/stambar.dmi',icon_state="1,1",pixel_y=22,layer=11)
			o3.overlays+=image('icons/stambar.dmi',icon_state="2,1",pixel_y=22,layer=11)
			o4.overlays+=image('icons/stambar.dmi',icon_state="3,1",pixel_y=22,layer=11)
			o5.overlays+=image('icons/stambar.dmi',icon_state="4,1",pixel_y=22,layer=11)

			if(C)
				C.screen+=o1
				C.screen+=o2
				C.screen+=o3
				C.screen+=o4
				C.screen+=o5
				..()
	chakrabarbase
		layer=10
		icon='icons/chakrabar.dmi'
		var
			segment=0
		New(client/C)
			var/obj/chakrabar/o1=new/obj/chakrabar(C)
			var/obj/chakrabar/o2=new/obj/chakrabar(C)
			var/obj/chakrabar/o3=new/obj/chakrabar(C)
			var/obj/chakrabar/o4=new/obj/chakrabar(C)
			var/obj/chakrabar/o5=new/obj/chakrabar(C)
			o1.segment=1
			o2.segment=2
			o3.segment=3
			o4.segment=4
			o5.segment=5
			if(C)
				C.mob.player_gui+=o1
				C.mob.player_gui+=o2
				C.mob.player_gui+=o3
				C.mob.player_gui+=o4
				C.mob.player_gui+=o5
			o2.overlays+=image('icons/chakrabar.dmi',pixel_y=14,pixel_x=-1)
			o3.overlays+=image('icons/chakrabar.dmi',pixel_y=14,pixel_x=-1)
			o4.overlays+=image('icons/chakrabar.dmi',pixel_y=14,pixel_x=-1)
			o5.overlays+=image('icons/chakrabar.dmi',pixel_y=14,pixel_x=-1)
			o1.screen_loc="7:16,17:0"
			o2.screen_loc="8:16,17:0"
			o3.screen_loc="9:16,17:0"
			o4.screen_loc="10:16,17:0"
			o5.screen_loc="11:16,17:0"
			o1.layer++
			o1.overlays+=image('icons/chakrabar.dmi',icon_state="0,0",pixel_y=-7,layer=11)
			o2.overlays+=image('icons/chakrabar.dmi',icon_state="1,0",pixel_y=-7,layer=11)
			o3.overlays+=image('icons/chakrabar.dmi',icon_state="2,0",pixel_y=-7,layer=11)
			o4.overlays+=image('icons/chakrabar.dmi',icon_state="3,0",pixel_y=-7,layer=11)
			o5.overlays+=image('icons/chakrabar.dmi',icon_state="4,0",pixel_y=-7,layer=11)
			o1.overlays+=image('icons/chakrabar.dmi',icon_state="0,1",pixel_y=25,layer=11)
			o2.overlays+=image('icons/chakrabar.dmi',icon_state="1,1",pixel_y=25,layer=11)
			o3.overlays+=image('icons/chakrabar.dmi',icon_state="2,1",pixel_y=25,layer=11)
			o4.overlays+=image('icons/chakrabar.dmi',icon_state="3,1",pixel_y=25,layer=11)
			o5.overlays+=image('icons/chakrabar.dmi',icon_state="4,1",pixel_y=25,layer=11)

			if(C)
				C.screen+=o1
				C.screen+=o2
				C.screen+=o3
				C.screen+=o4
				C.screen+=o5
				..()
	woundbarbase
		layer=10
		icon='icons/woundbar.dmi'
		var
			segment=0
		New(client/C)
			var/obj/woundbar/o1=new/obj/woundbar(C)
			var/obj/woundbar/o2=new/obj/woundbar(C)
			var/obj/woundbar/o3=new/obj/woundbar(C)
			var/obj/woundbar/o4=new/obj/woundbar(C)
			var/obj/woundbar/o5=new/obj/woundbar(C)
			o1.segment=1
			o2.segment=2
			o3.segment=3
			o4.segment=4
			o5.segment=5
			if(C)
				C.mob.player_gui+=o1
				C.mob.player_gui+=o2
				C.mob.player_gui+=o3
				C.mob.player_gui+=o4
				C.mob.player_gui+=o5
			o2.overlays+=image('icons/woundbar.dmi',pixel_y=14,pixel_x=-1)
			o3.overlays+=image('icons/woundbar.dmi',pixel_y=14,pixel_x=-1)
			o4.overlays+=image('icons/woundbar.dmi',pixel_y=14,pixel_x=-1)
			o5.overlays+=image('icons/woundbar.dmi',pixel_y=14,pixel_x=-1)
			o1.screen_loc="13,17"
			o2.screen_loc="14,17"
			o3.screen_loc="15,17"
			o4.screen_loc="16,17"
			o5.screen_loc="17,17"
			o1.layer++
			o1.overlays+=image('icons/woundbar.dmi',icon_state="0,0",pixel_y=-8,layer=11)
			o2.overlays+=image('icons/woundbar.dmi',icon_state="1,0",pixel_y=-8,layer=11)
			o3.overlays+=image('icons/woundbar.dmi',icon_state="2,0",pixel_y=-8,layer=11)
			o4.overlays+=image('icons/woundbar.dmi',icon_state="3,0",pixel_y=-8,layer=11)
			o5.overlays+=image('icons/woundbar.dmi',icon_state="4,0",pixel_y=-8,layer=11)
			o1.overlays+=image('icons/woundbar.dmi',icon_state="0,1",pixel_y=24,layer=11)
			o2.overlays+=image('icons/woundbar.dmi',icon_state="1,1",pixel_y=24,layer=11)
			o3.overlays+=image('icons/woundbar.dmi',icon_state="2,1",pixel_y=24,layer=11)
			o4.overlays+=image('icons/woundbar.dmi',icon_state="3,1",pixel_y=24,layer=11)
			o5.overlays+=image('icons/woundbar.dmi',icon_state="4,1",pixel_y=24,layer=11)

			if(C)
				C.screen+=o1
				C.screen+=o2
				C.screen+=o3
				C.screen+=o4
				C.screen+=o5
				..()
mob/proc
	Pk_Check()

		for(var/area/A in locate(src.x,src.y,src.z))
			if(A&&istype(A,/area))
				if(A.safe==1)
					src.pk=0
				else
					src.pk=1
mob
	var
		stathid=0
mob/human/player/proc
	StatBar_Refresh()
		set background = 1
		if(!EN[8])
			sleep(200)
			spawn()StatBar_Refresh()
			return
		if(!src.client) return
		if(src.loc && src.loc.loc)
			if(src.loc.loc:safe==1)
				src.pk=0
			else
				src.pk=1
		if(!src.stamina||!src.chakra||!src.maxwound)
			spawn(100)src.StatBar_Refresh()
			return
		var/S=round((src.curstamina/src.stamina)*128)
		var/C=round((src.curchakra/src.chakra)*128)
		var/W=round((src.curwound/src.maxwound)*128)
		if(src.hidestat && !src.stathid)

			for(var/atom/X in src.player_gui)
				X.invisibility=99
			stathid=1

			spawn(20)src.StatBar_Refresh()
			return
		else if(stathid && !src.hidestat)
			for(var/atom/X in src.player_gui)
				X.invisibility=0
				stathid=0
		if(S<0)
			S=0
		if(C<0)
			C=0
		if(W<0)
			W=0
		for(var/obj/stambar/s in usr.client.screen)
			if(s.segment>=2)
				var/a=0

				a=S - (s.segment-2)*32
				if(a>32)
					a=32
				if(a<0)
					a=0
				s.icon_state="[a]"
		for(var/obj/chakrabar/s in usr.client.screen)
			if(s.segment>=2)
				var/a=0

				a=C - (s.segment-2)*32
				if(a>32)
					a=32
				if(a<0)
					a=0
				s.icon_state="[a]"

		for(var/obj/woundbar/s in usr.client.screen)
			if(s.segment>=2)
				var/a=0

				a=W - (s.segment-2)*32
				if(a>32)
					a=32
				if(a<0)
					a=0
				s.icon_state="[a]"
		spawn(10*wregenlag)src.StatBar_Refresh()