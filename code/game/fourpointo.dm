mob/var/Size=0

var/Sizeup_Compat=0
mob/var/list
	iSizeup1=new
	iSizeup2=new
mob
	proc
		Akimichi_Revert()
			usr.Aki=0

			usr.Affirm_Icon()
			usr.Load_Overlays()
			usr.layer=MOB_LAYER

		Akimichi_Grow(Sc)//64 or 96
			sleep(-1)
			usr=src
			//src.stunned=100
			src.Begin_Stun()
			src.icon_state="Seal"

			if(Sizeup_Compat)
				Akimichi_Grow_C(Sc)
				return

			usr.Aki=1
			var/icon/I=usr.Affirm_Icon_Ret()

			if(Sc>96)
				Sc=96
//#if DM_VERSION >= 455
/*			I.Scale(Sc,Sc)
			usr.layer=MOB_LAYER+5

			var/pixel_x = -((I.Width()-world.IconSizeX())/2)

			var/list/Olay=usr.Load_OlayRet()
			var/list/scaled_olay = list()
			for(var/X in Olay)
				sleep(-1)

				var/icon/O

				if(istype(X, /icon))
					O = X
				else
					O = new /icon (X)

				O.Scale(Sc, Sc)
				scaled_olay += O

			usr.icon = null
			usr.overlays.Cut()

			var/obj/icon = new
			icon.icon = I
			icon.pixel_x = pixel_x
			icon.layer = -100
			usr.overlays += icon

			for(var/icon/J in scaled_olay)
				sleep(-1)
				var/obj/overlay = new
				overlay.icon = J
				overlay.pixel_x = pixel_x
				overlay.layer = -1
				usr.overlays += overlay*/
//#else
			var/list/Olay=usr.Load_OlayRet()
			for(var/X in Olay)
				I.Blend(X,ICON_OVERLAY)

			I.Scale(Sc,Sc)
			usr.layer=MOB_LAYER+5

			var/pix=0
			if(Sc>32 && Sc<65)
				pix=16

			var/icon/spliticon1=new/icon()
			var/icon/spliticon2=new/icon()
			var/icon/spliticon3=new/icon()
			var/icon/spliticon4=new/icon()
			var/icon/spliticon5=new/icon()
			var/icon/spliticon6=new/icon()
			var/icon/spliticon7=new/icon()
			var/icon/spliticon8=new/icon()
			var/icon/spliticon9=new/icon()

			for(var/state in icon_states(I,0))

				if(!(findtext(state,"PunchA-1") || length(state)<5))
					continue

				sleep(1)
				sleep(-1)
			    // look for "x,y" pattern
				var/pos = findtext(state,",")
				if(!pos) continue // not a coord
				var/x_off = text2num(copytext(state,pos-1,pos))
				if(x_off==null) continue // not a coord or out of bounds
				var/y_off = text2num(copytext(state,pos+1))
				if(y_off==null) continue // ditto
				if(x_off==0 && y_off==0)
					var/icon/new_icon=icon(I, state)

					if(length(state)<=4)
						//new_icon=icon(I, "[x_off],[y_off]")
						spliticon1.Insert(new_icon,"",moving=1,delay=3)

					else
						spliticon1.Insert(new_icon,"PunchA-1",moving=0,delay=3)


				if(x_off==1 && y_off==0)
					var/icon/new_icon=icon(I, state)

					if(length(state)<=4)
						//new_icon=icon(I, "[x_off],[y_off]")
						spliticon2.Insert(new_icon,"",moving=1,delay=3)

					else
						spliticon2.Insert(new_icon,"PunchA-1",moving=0,delay=3)

				if(x_off==2 && y_off==0)
					var/icon/new_icon=icon(I, state)

					if(length(state)<=4)
						//new_icon=icon(I, "[x_off],[y_off]")
						spliticon3.Insert(new_icon,"",moving=1,delay=3)

					else
						spliticon3.Insert(new_icon,"PunchA-1",moving=0,delay=3)


				if(x_off==0 && y_off==1)
					var/icon/new_icon=icon(I, state)

					if(length(state)<=4)
						//new_icon=icon(I, "[x_off],[y_off]")
						spliticon4.Insert(new_icon,"",moving=1,delay=3)

					else
						spliticon4.Insert(new_icon,"PunchA-1",moving=0,delay=3)


				if(x_off==1 && y_off==1)
					var/icon/new_icon=icon(I, state)

					if(length(state)<=4)
						//new_icon=icon(I, "[x_off],[y_off]")
						spliticon5.Insert(new_icon,"",moving=1,delay=3)

					else
						spliticon5.Insert(new_icon,"PunchA-1",moving=0,delay=3)
				if(x_off==2 && y_off==1)
					var/icon/new_icon=icon(I, state)

					if(length(state)<=4)
						//new_icon=icon(I, "[x_off],[y_off]")
						spliticon6.Insert(new_icon,"",moving=1,delay=3)

					else
						spliticon6.Insert(new_icon,"PunchA-1",moving=0,delay=3)
				if(x_off==0 && y_off==2)
					var/icon/new_icon=icon(I, state)

					if(length(state)<=4)
						//new_icon=icon(I, "[x_off],[y_off]")
						spliticon7.Insert(new_icon,"",moving=1,delay=3)

					else
						spliticon7.Insert(new_icon,"PunchA-1",moving=0,delay=3)

				if(x_off==1 && y_off==2)
					var/icon/new_icon=icon(I, state)

					if(length(state)<=4)
						//new_icon=icon(I, "[x_off],[y_off]")
						spliticon8.Insert(new_icon,"",moving=1,delay=3)

					else
						spliticon8.Insert(new_icon,"PunchA-1",moving=0,delay=3)
				if(x_off==2 && y_off==2)
					var/icon/new_icon=icon(I, state)

					if(length(state)<=4)
						//new_icon=icon(I, "[x_off],[y_off]")
						spliticon9.Insert(new_icon,"",moving=1,delay=3)

					else
						spliticon9.Insert(new_icon,"PunchA-1",moving=0,delay=3)

					//""

			var/obj/X1=new/obj/achu
			var/obj/X2=new/obj/achu
			var/obj/X3=new/obj/achu
			var/obj/X4=new/obj/achu
			var/obj/X5=new/obj/achu
			var/obj/X6=new/obj/achu
			var/obj/X7=new/obj/achu
			var/obj/X8=new/obj/achu
			var/obj/X9=new/obj/achu

			X1.icon=spliticon1
			X1.pixel_x=-32+pix
			X2.icon=spliticon2
			X2.pixel_x=pix
			X3.icon=spliticon3
			X3.pixel_x=32+pix
			X4.icon=spliticon4
			X4.pixel_y=32
			X4.pixel_x=-32+pix
			X5.icon=spliticon5
			X5.pixel_y=32
			X5.pixel_x=pix
			X6.icon=spliticon6
			X6.pixel_x=32+pix
			X6.pixel_y=32
			X7.icon=spliticon7
			X7.pixel_y=64
			X7.pixel_x=-32+pix
			X8.icon=spliticon8
			X8.pixel_y=64
			X8.pixel_x=pix
			X9.icon=spliticon9
			X9.pixel_x=32+pix
			X9.pixel_y=64

			if(Sc==64)
				iSizeup1=new/list()
				iSizeup1+=X1
				iSizeup1+=X2
				iSizeup1+=X3
				iSizeup1+=X4
				iSizeup1+=X5
				iSizeup1+=X6
				iSizeup1+=X7
				iSizeup1+=X8
				iSizeup1+=X9

			else
				iSizeup2=new/list()
				iSizeup2+=X1
				iSizeup2+=X2
				iSizeup2+=X3
				iSizeup2+=X4
				iSizeup2+=X5
				iSizeup2+=X6
				iSizeup2+=X7
				iSizeup2+=X8
				iSizeup2+=X9

			usr.icon=null
			usr.overlays+=X1//image(spliticon1,usr,pixel_x=-32,pixel_y=0)
			usr.overlays+=X2//image(spliticon2,usr,pixel_x=0,pixel_y=0)
			usr.overlays+=X3//image(spliticon3,usr,pixel_x=32,pixel_y=0)
			usr.overlays+=X4//image(spliticon4,usr,pixel_x=-32,pixel_y=32)
			usr.overlays+=X5//image(spliticon5,usr,pixel_x=0,pixel_y=32)
			usr.overlays+=X6//image(spliticon6,usr,pixel_x=32,pixel_y=32)
			usr.overlays+=X7//image(spliticon7,usr,pixel_x=-32,pixel_y=64)
			usr.overlays+=X8//image(spliticon8,usr,pixel_x=0,pixel_y=64)
			usr.overlays+=X9//image(spliticon9,usr,pixel_x=32,pixel_y=64)
//#endif
			//usr.stunned=0
			usr.End_Stun()
			usr.icon_state=""

		//usr.Load_Overlays(0,X)

		Akimichi_Grow_C(Sc)//64 or 96
			sleep(-1)
			usr=src
			src.Begin_Stun()
			src.icon_state="Seal"
			usr.Aki=1
			if(Sc>96)
				Sc=96
			var/pix=0
			if(Sc>32 && Sc<65)
				pix=16
			usr.layer=MOB_LAYER+5

			var/obj/X1=new/obj/achu
			var/obj/X2=new/obj/achu
			var/obj/X3=new/obj/achu
			var/obj/X4=new/obj/achu
			var/obj/X5=new/obj/achu
			var/obj/X6=new/obj/achu
			var/obj/X7=new/obj/achu
			var/obj/X8=new/obj/achu
			var/obj/X9=new/obj/achu

			X1.pixel_x=-32+pix
			X2.pixel_x=pix

			X3.pixel_x=32+pix

			X4.pixel_y=32
			X4.pixel_x=-32+pix
			X5.pixel_y=32
			X5.pixel_x=pix

			X6.pixel_x=32+pix
			X6.pixel_y=32

			X7.pixel_y=64
			X7.pixel_x=-32+pix
			X8.pixel_y=64
			X8.pixel_x=pix

			X9.pixel_x=32+pix
			X9.pixel_y=64

			usr.overlays=0
			usr.icon=0
			//usr.stunned=0
			usr.End_Stun()
			usr.icon_state=""
			if(Sc==64)
				if(usr.icon_name=="base_m1")
					X1.icon='icons-x2/base_m1-1-1.dmi'
					X2.icon='icons-x2/base_m1-2-1.dmi'
					X4.icon='icons-x2/base_m1-1-2.dmi'
					X5.icon='icons-x2/base_m1-2-2.dmi'
				if(usr.icon_name=="base_m2")
					X1.icon='icons-x2/base_m2-1-1.dmi'
					X2.icon='icons-x2/base_m2-2-1.dmi'
					X4.icon='icons-x2/base_m2-1-2.dmi'
					X5.icon='icons-x2/base_m2-2-2.dmi'
				if(usr.icon_name=="base_m3")
					X1.icon='icons-x2/base_m3-1-1.dmi'
					X2.icon='icons-x2/base_m3-2-1.dmi'
					X4.icon='icons-x2/base_m3-1-2.dmi'
					X5.icon='icons-x2/base_m3-2-2.dmi'

				iSizeup1=new/list()
				iSizeup1+=X1
				iSizeup1+=X2

				iSizeup1+=X4
				iSizeup1+=X5
				del(X3)
				del(X6)
				del(X7)
				del(X8)
				del(X9)

			else
				if(usr.icon_name=="base_m1")
					X1.icon='icons-x3/base_m1-1-1.dmi'
					X2.icon='icons-x3/base_m1-2-1.dmi'
					X3.icon='icons-x3/base_m1-3-1.dmi'
					X4.icon='icons-x3/base_m1-1-2.dmi'
					X5.icon='icons-x3/base_m1-2-2.dmi'
					X6.icon='icons-x3/base_m1-3-2.dmi'
					X7.icon='icons-x3/base_m1-1-3.dmi'
					X8.icon='icons-x3/base_m1-2-3.dmi'
					X9.icon='icons-x3/base_m1-3-3.dmi'
				if(usr.icon_name=="base_m2")
					X1.icon='icons-x3/base_m2-1-1.dmi'
					X2.icon='icons-x3/base_m2-2-1.dmi'
					X4.icon='icons-x3/base_m2-1-2.dmi'
					X5.icon='icons-x3/base_m2-2-2.dmi'
					X6.icon='icons-x3/base_m1-3-2.dmi'
					X7.icon='icons-x3/base_m2-1-3.dmi'
					X8.icon='icons-x3/base_m2-2-3.dmi'
					X9.icon='icons-x3/base_m2-3-3.dmi'
				if(usr.icon_name=="base_m3")
					X1.icon='icons-x3/base_m3-1-1.dmi'
					X2.icon='icons-x3/base_m3-2-1.dmi'
					X4.icon='icons-x3/base_m3-1-2.dmi'
					X5.icon='icons-x3/base_m3-2-2.dmi'
					X6.icon='icons-x3/base_m3-3-2.dmi'
					X7.icon='icons-x3/base_m3-1-3.dmi'
					X8.icon='icons-x3/base_m3-2-3.dmi'
					X9.icon='icons-x3/base_m3-3-3.dmi'
				iSizeup2=new/list()
				iSizeup2+=X1
				iSizeup2+=X2
				iSizeup2+=X3
				iSizeup2+=X4
				iSizeup2+=X5
				iSizeup2+=X6
				iSizeup2+=X7
				iSizeup2+=X8
				iSizeup2+=X9
			usr.overlays+=X1//image(spliticon1,usr,pixel_x=-32,pixel_y=0)
			usr.overlays+=X2//image(spliticon2,usr,pixel_x=0,pixel_y=0)
			usr.overlays+=X3//image(spliticon3,usr,pixel_x=32,pixel_y=0)
			usr.overlays+=X4//image(spliticon4,usr,pixel_x=-32,pixel_y=32)
			usr.overlays+=X5//image(spliticon5,usr,pixel_x=0,pixel_y=32)
			usr.overlays+=X6//image(spliticon6,usr,pixel_x=32,pixel_y=32)
			usr.overlays+=X7//image(spliticon7,usr,pixel_x=-32,pixel_y=64)
			usr.overlays+=X8//image(spliticon8,usr,pixel_x=0,pixel_y=64)
			usr.overlays+=X9//image(spliticon9,usr,pixel_x=32,pixel_y=64)

obj
	achu
		layer=MOB_LAYER+0.1




mob/proc
	Load_OlayRet()
		if(!EN[15])
			return
		usr.underlays=0
		var/L[0]
		var/icon/h1i


		switch(src.hair_type)
			if(1)
				h1i=new('icons/hair1.dmi')
			if(2)
				h1i=new('icons/hair2.dmi')
			if(3)
				h1i=new('icons/hair3.dmi')
			if(4)
				h1i=new('icons/hair4.dmi')
			if(5)
				h1i=new('icons/hair5.dmi')
			if(6)
				h1i=new('icons/hair6.dmi')
			if(7)
				h1i=new('icons/hair7.dmi')
			if(8)
				h1i=new('icons/hair8.dmi')
			if(9)
				h1i=new('icons/hair9.dmi')
			if(10)
				h1i=new('icons/hair10.dmi')
			if(11)
				h1i=new('icons/hair11.dmi')
			if(12)
				h1i=new('icons/hair12.dmi')
			if(13)
				h1i=new('icons/hair13.dmi')

		if(h1i)
			if(EN[1])h1i.Blend(src.hair_color)
			var/icon/h2i
			if(src.hair_type==11)
				h2i=new('icons/hair11o.dmi')
				if(EN[1])h2i.Blend(src.hair_color)

			L+= h1i
			if(h2i)
				L+= h2i

		if(special)
			var/atom/T = new special()

			if(T.icon)L+=T.icon
		if(undershirt)
			var/atom/T = new undershirt()

			if(T.icon)L+=T.icon
		if(pants)
			var/atom/T = new pants()

			if(T.icon)L+=T.icon
		if(overshirt)
			var/atom/T = new overshirt()

			if(T.icon)L+=T.icon
		if(shoes)
			var/atom/T = new shoes()

			if(T.icon)L+=T.icon
		if(legarmor)
			var/atom/T = new legarmor()

			if(T.icon)L+=T.icon
		if(armor)
			var/atom/T = new armor()

			if(T.icon)L+=T.icon
		if(armarmor)
			var/atom/T = new armarmor()

			if(T.icon)L+=T.icon
		if(armarmor2)
			var/atom/T = new armarmor2()

			if(T.icon)L+=T.icon
		if(glasses)
			var/atom/T = new glasses()

			if(T.icon)L+=T.icon
		if(facearmor)
			var/atom/T = new facearmor()

			if(T.icon)L+=T.icon
		if(cloak)
			var/atom/T = new cloak()

			if(T.icon)L+=T.icon
		if(sholder)
			var/atom/T = new sholder()

			if(T.icon)L+=T.icon
		if(back)
			var/atom/T = new back()

			if(T.icon)L+=T.icon

		return L