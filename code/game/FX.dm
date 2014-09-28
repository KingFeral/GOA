proc
	Iswater(atom/location)//(dx,dy,dz)
		if(!location)
			return 0
		else if(args.len == 3) // for direct locations
			var/xx = args[1]
			var/yy = args[2]
			var/zz = args[3]
			location = locate(xx,yy,zz)

		var/result=0
		var/turf/sourceloc = location//locate(dx, dy, dz)
		var/turf/water/X1 = istype(sourceloc, /turf/water)
		var/obj/water/X2 = locate(/obj/water) in sourceloc//locate(dx, dy, dz)hprojectile_to
		/*if(X1)
			result=1
		if(X2)
			result=1*/
		if(X1||X2)return 1
		if(!result)
			//var/turf/Tt = locate(dx,dy,dz)
			//if(Tt)
			if(location.underlays.Find('icons/water.dmi'))
				result=1
			for(var/Uu in location.underlays)
				var/t="[Uu:icon]"
				if(t=="icons/water.dmi")
					result=1

		return result

mob
	proc/Earthquake(max_steps=5, offset_min=-2, offset_max=2)
		set waitfor = 0
		for(var/mob/M in viewers())
			if(M.client)
				M.earthquake_effect(max_steps, offset_min, offset_max)


	proc/earthquake_effect(max_steps, offset_min, offset_max)
		set waitfor = 0
		var/steps = 0
		while(src && src.client && steps < max_steps)
			src.client.pixel_y = rand(offset_min, offset_max)
			sleep(1)
			++steps

	proc/Facedir(mob/x)
		if(src.stunned||src.paralysed||src.ko||handseal_stun)
			return
		var/north=0
		var/east=0
		var/sevx = abs(x.x-src.x)
		var/sevy = abs(x.y-src.y)

		if(x.x > src.x)
			east=1
		else
			east=2
		if(x.y>src.y)
			north=1
		else
			north=2
		if(east==1 && north==1)
			if(sevx>sevy)
				src.dir=EAST
			else
				src.dir=NORTH
		if(east==0 && north==1)
			src.dir=NORTH
		if(east==2 && north==1)
			if(sevx>sevy)
				src.dir=WEST
			else
				src.dir=NORTH
		if(east==1 && north==0)
			src.dir=EAST
		if(east==2 && north==0)
			src.dir=WEST
		if(east==0 && north ==2)
			src.dir=SOUTH
		if(east==1 && north==2)
			if(sevx>sevy)
				src.dir=EAST
			else
				src.dir=SOUTH
		if(east==2 && north==2)
			if(sevx>sevy)
				src.dir=WEST
			else
				src.dir=SOUTH




obj
	proc/Facedir(atom/x)
		var/north=0
		var/east=0
		var/sevx = abs(x.x-src.x)
		var/sevy = abs(x.y-src.y)

		if(x.x > src.x)
			east=1
		else
			east=2
		if(x.y>src.y)
			north=1
		else
			north=2
		if(east==1 && north==1)
			if(sevx>sevy)
				src.dir=EAST
			else
				src.dir=NORTH
		if(east==0 && north==1)
			src.dir=NORTH
		if(east==2 && north==1)
			if(sevx>sevy)
				src.dir=WEST
			else
				src.dir=NORTH
		if(east==1 && north==0)
			src.dir=EAST
		if(east==2 && north==0)
			src.dir=WEST
		if(east==0 && north ==2)
			src.dir=SOUTH
		if(east==1 && north==2)
			if(sevx>sevy)
				src.dir=EAST
			else
				src.dir=SOUTH
		if(east==2 && north==2)
			if(sevx>sevy)
				src.dir=WEST
			else
				src.dir=SOUTH


obj
	overfx
		icon='icons/appear.dmi'
		density=0
		layer=MOB_LAYER+1
		New()
			set waitfor = 0
			sleep(4)
			loc = null

	overfx2
		icon='icons/appeartai.dmi'
		density=0
		layer=MOB_LAYER+1
		New()
			set waitfor = 0
			sleep(3)
			//del(src)
			loc = null

obj
	Poison_Poof
		icon='icons/poison2.dmi'
		icon_state="cloud"
		layer = MOB_LAYER+3
		animate_movement=0
		New()
			set waitfor = 0
			..()
			var/c=0
			for(var/obj/Poison_Poof/X in oview(0))
				c++
			if(c>1)
				del(src)
			else
				src.underlays+=image('icons/poison2.dmi',icon_state="l",pixel_x=-32,layer=MOB_LAYER+2)
				src.underlays+=image('icons/poison2.dmi',icon_state="r",pixel_x=32,layer=MOB_LAYER+2)

				src.underlays+=image('icons/poison2.dmi',icon_state="tr",pixel_y=32,pixel_x=16,layer=MOB_LAYER+2)
				src.underlays+=image('icons/poison2.dmi',icon_state="br",pixel_y=-32,pixel_x=16,layer=MOB_LAYER+2)
				src.underlays+=image('icons/poison2.dmi',icon_state="tl",pixel_y=32,pixel_x=-16,layer=MOB_LAYER+2)
				src.underlays+=image('icons/poison2.dmi',icon_state="bl",pixel_y=-32,pixel_x=-16,layer=MOB_LAYER+2)



obj/sandshield

	var
		list/dependants=new
	New()
		set waitfor = 0
		..()
		dependants+=new/obj/sandparts/bl(locate(src.x-1,src.y,src.z))
		dependants+=new/obj/sandparts/bm(locate(src.x,src.y,src.z))
		dependants+=new/obj/sandparts/br(locate(src.x+1,src.y,src.z))
		dependants+=new/obj/sandparts/tl(locate(src.x-1,src.y+1,src.z))
		dependants+=new/obj/sandparts/tm(locate(src.x,src.y+1,src.z))
		dependants+=new/obj/sandparts/tr(locate(src.x+1,src.y+1,src.z))


	Del()
		for(var/obj/x in src.dependants)
			del(x)
		..()
obj
	hspike
		density=1
		layer=MOB_LAYER+1
		icon='icons/HakuSpikes.dmi'
		Del()
			if(loc == null)
				return ..()
			loc = null
proc
	Haku_Spikes(dx,dy,dz)
		set waitfor = 0
		var/obj/x1=new/obj/hspike(locate(dx-1,dy+1,dz))
		var/obj/x2=new/obj/hspike(locate(dx,dy+1,dz))
		var/obj/x3=new/obj/hspike(locate(dx+1,dy+1,dz))
		var/obj/x4=new/obj/hspike(locate(dx-1,dy,dz))
		var/obj/x5=new/obj/hspike(locate(dx,dy,dz))
		var/obj/x6=new/obj/hspike(locate(dx+1,dy,dz))
		var/obj/x7=new/obj/hspike(locate(dx-1,dy-1,dz))
		var/obj/x8=new/obj/hspike(locate(dx,dy-1,dz))
		var/obj/x9=new/obj/hspike(locate(dx+1,dy-1,dz))
		//bot,mid,top  ,left,mid,right
		x1.icon_state="top-leftd"
		x2.icon_state="top-midd"
		x3.icon_state="top-rightd"
		x4.icon_state="mid-leftd"
		x5.icon_state="mid-midd"
		x6.icon_state="mid-rightd"
		x7.icon_state="bot-leftd"
		x8.icon_state="bot-midd"
		x9.icon_state="bot-rightd"
		flick("top-left",x1)
		flick("top-mid",x2)
		flick("top-right",x3)
		flick("mid-left",x4)
		flick("mid-mid",x5)
		flick("mid-right",x6)
		flick("bot-left",x7)
		flick("bot-mid",x8)
		flick("bot-right",x9)
		sleep(96)
		del(x1)
		del(x2)
		del(x3)
		del(x4)
		del(x5)
		del(x6)
		del(x7)
		del(x8)
		del(x9)



obj
	Bonespire
		var
			causer=0
		icon='icons/sawarabi.dmi'
		density=1
		New(loc,mob/cause)
			..()
			var/conbuff = 1
			if(cause)
				conbuff=(cause.con+cause.conbuff-cause.conneg)/100
			sleep(1)
			src.icon_state="fin"
			flick("flick",src)

			for(var/mob/human/player/X in oview(0,src))
				if(!X.icon_state)
					flick("hurt",X)
				X.Damage(rand(1500, 5000) + 1000 * conbuff, 10, cause)//X.Dec_Stam(rand(1500,5000) + 1000*conbuff, 0, cause)
				X.Hostile(cause)
				//X.Wound(10, 0, cause)
				Blood2(X)
				//X.move_stun+=30
				X.Timed_Move_Stun(30)
			/*sleep(400)
			causer = null
			loc = null*/
		Del()
			if(loc == null)
				return ..()
			causer = null
			Causer = null
			loc = null


proc
	SpireCircle(bx, by, bz, finrad, mob/cause)
		var/rad = 0
		var/rad2 = 0
		var/nx = bx
		var/ny = by
		var/nx2 = bx
		var/list/listx = new()
		var/nx3 = bx
		var/nx4 = bx

		while(rad < finrad)
			rad += 2
			rad2 += 1
			nx = bx + rad
			nx2 = bx + rad2
			nx3 = bx - rad
			nx4 = bx - rad2
			var/diff = 0
			var/diff2 = 1

			spawn()
				var/mx2 = nx2

				if(rad2 == 1)
					listx += new /obj/Bonespire(locate(bx, ny+rad2, bz), cause)
					listx += new /obj/Bonespire(locate(bx, ny-rad2, bz), cause)
				else
					listx += new /obj/Bonespire(locate(bx, ny+rad2-1, bz), cause)
					listx += new /obj/Bonespire(locate(bx, ny-rad2+1, bz), cause)

				while(mx2 > bx)
					listx += new /obj/Bonespire(locate(mx2, ny-diff2, bz), cause)
					listx += new /obj/Bonespire(locate(mx2, ny+diff2, bz), cause)

					mx2 -= 2
					diff2 += 2

			spawn()
				var/mx = nx
				while(mx > bx)
					if(diff)
						listx += new /obj/Bonespire(locate(mx, ny+diff, bz), cause)
						listx += new /obj/Bonespire(locate(mx, ny-diff, bz), cause)

					mx -= 2
					diff += 2

			var/diff3 = 0
			var/diff4 = 1

			spawn()
				var/mx2 = nx4

				if(rad2 == 1)
					listx += new /obj/Bonespire(locate(bx+rad2, ny, bz), cause)
					listx += new /obj/Bonespire(locate(bx-rad2, ny, bz), cause)
				else
					listx += new /obj/Bonespire(locate(bx+rad2-1, ny, bz), cause)
					listx += new /obj/Bonespire(locate(bx-rad2+1, ny, bz), cause)

				while(mx2 < bx)
					listx += new /obj/Bonespire(locate(mx2, ny+diff4, bz), cause)
					listx += new /obj/Bonespire(locate(mx2, ny-diff4, bz), cause)
					mx2 += 2
					diff4 += 2

			spawn()
				var/mx = nx3
				while(mx < bx)
					if(diff3)
						listx += new /obj/Bonespire(locate(mx, ny+diff3, bz), cause)
						listx += new /obj/Bonespire(locate(mx, ny-diff3, bz), cause)

					mx += 2
					diff3 += 2

			rad2 += 1
			sleep(2)

		sleep(5)
		for(var/obj/Bonespire/E in listx)
			E.causer = cause
		new/Event(600, "delayed_delete", listx)

obj
	Testspire
		icon='icons/sawarabi.dmi'
		icon_state="fin"

obj
	sandparts
		icon='icons/Gaara.dmi'
		layer=MOB_LAYER+1
		bl
			icon_state="B-L"
			New()
				..()
				flick("bottom-L",src)

		br
			icon_state="B-R"
			New()
				..()
				flick("bottom-R",src)

		bm
			icon_state="B-M"
			New()
				..()
				flick("bottom-mid",src)

		tl
			icon_state="T-L"
			New()
				..()
				flick("top-L",src)

		tr
			icon_state="T-R"
			New()
				..()
				flick("top-R",src)

		tm
			icon_state="T-M"
			New()
				..()
				flick("top-mid",src)

mob/human
	sandmonster
		combat_protection = 0
		var/hp=3
		var/tired=0
		density=1
		icon='icons/gaarasand.dmi'
		icon_state=""

		proc/begin_life()
			set waitfor = 0
			. = 1
			while(.)
				. = 0
				if(owner && get_dist(owner, src) < 20)
					. = 1
				sleep(50)
			if(owner)
				owner.pet -= src
			del(src)

		New()
			src.underlays.Add(image('icons/sand-up.dmi',pixel_y=-10),
			image('icons/sand-down.dmi',pixel_y=10),
			image('icons/sand-right.dmi',pixel_x=-10),
			image('icons/sand-left.dmi',pixel_x=10))
			src.nopkloop()
		proc
			P_Attack(mob/human/etarget,mob/human/owner)
				if(tired>world.time)return
				tired=world.time+15

				for(var/mob/human/x in oview(7,src))
					if(x==etarget)
						walk_to(src,x,1,1)
						sleep(1)
						var/hit=0
						if(get_dist(src,x)<=1)hit=1
						else
							sleep(1)
						if(get_dist(src,x)<=1)hit=1
						else
							sleep(1)
						if(get_dist(src,x)<=1)hit=1
						else
							sleep(1)
						if(hit)
							attack_reaction()
							//etarget.Dec_Stam(src.con*rand(50,150)/100)
							etarget.Damage(src.con*rand(50,150)/100, )
							if(!etarget.icon_state)
								flick("hurt",etarget)
							etarget.Hostile(owner)

		var
			mob/owner

		proc/attack_reaction()
			set waitfor = 0
			src.overlays+=image('icons/Gaara.dmi',icon_state="sand-spikes")
			sleep(9)
			src.overlays-=image('icons/Gaara.dmi',icon_state="sand-spikes")
			src.density=0
			walk_to(src,owner,0,1)
			sleep(6)
			src.density=1
			walk(src,0)

		/*Del()
			if(loc == null)
				return ..()
			src.invisibility=99
			src.density=0
			src.loc=locate(0,0,0)
			owner = null
			loc = null
*/
	/*	Dec_Stam()
			return
		Wound()
			return*/

		Damage()
			return

mob/proc/nopkloop()
	set waitfor = 0
	for(var/area/nopkzone/x in oview(0,src))
		del(src)
	sleep(10)
	src.nopkloop()
obj/gatesaura
	icon='icons/gateaura.dmi'
	bl
		icon_state="bl"
		pixel_x=-16
	br
		icon_state="br"
		pixel_x=16
	tl
		icon_state="tl"
		pixel_x=-16
		pixel_y=32
	tr
		icon_state="tr"
		pixel_x=16
		pixel_y=32
obj/oodamaexplosion
	layer=OBJ_LAYER
	New()
		src.overlays+=image('icons/oodamahit.dmi',icon_state = "bl",pixel_x=-16,pixel_y=-16)
		src.overlays+=image('icons/oodamahit.dmi',icon_state = "br",pixel_x=16,pixel_y=-16)
		src.overlays+=image('icons/oodamahit.dmi',icon_state = "tl",pixel_x=-16,pixel_y=16)
		src.overlays+=image('icons/oodamahit.dmi',icon_state = "tr",pixel_x=16,pixel_y=16)
obj/oodamarasengan
	icon='icons/oodamarasengan.dmi'
	icon_state="rasengan"
	New()
		flick("create",src)
obj/rasengan
	icon='icons/rasengan.dmi'
	icon_state="rasengan"
	New()
		flick("create",src)
mob/proc/Affirm_Icon_Ret()
	if(istype(src,/mob/human/Puppet/Karasu))
		return
	if(src.icon_name=="base_m"||src.icon_name=="base_m1")
		return new/icon('icons/base_m1.dmi')

	if(src.icon_name=="base_m2")
		return new/icon('icons/base_m2.dmi')

	if(src.icon_name=="base_m3")
		return new/icon('icons/base_m3.dmi')

mob/proc/Affirm_Icon()
	set waitfor = 0
	if(src.Size || src.Tank)
		return
	if(istype(src,/mob/human/Puppet/Karasu))
		return

	var/icon
	switch(src.icon_name)
		if("base_m", "base_m1")
			icon='icons/base_m1.dmi'
		if("base_m2")
			icon='icons/base_m2.dmi'
		if("base_m3")
			icon='icons/base_m3.dmi'

	if(src.gate>=3)
		icon='icons/base_m_gates.dmi'

	else if(src.ironskin==1)
		icon='icons/base_m_stoneskin.dmi'

	if(src.sharingan)
		var/icon/i = new(icon)
		i.SwapColor(rgb(007,007,007),rgb(180,0,0))
		i.SwapColor(rgb(93,95,93),rgb(220,50,50))
		icon = i
	else if(src.byakugan)
		var/icon/i = new(icon)
		i.SwapColor(rgb(007,007,007),rgb(235,235,255))
		i.SwapColor(rgb(93,95,93),rgb(235,235,255))
		icon = i
	else if(src.eyecolor_red || src.eyecolor_green || src.eyecolor_blue)
		var/icon/i = new(icon)
		i.SwapColor(rgb(007,007,007),rgb(src.eyecolor_red,src.eyecolor_green,src.eyecolor_blue))
		i.SwapColor(rgb(93,95,93),rgb(src.eyecolor_red,src.eyecolor_green,src.eyecolor_blue))
		icon = i

	if(src.scalpol)
		src.overlays += 'icons/chakrahands.dmi'


	src.icon=icon
obj
	special
		layer=FLOAT_LAYER-13
		sharingan
			icon='icons/sharingan.dmi'
		byakugan
			icon='icons/byakugan.dmi'
turf/water
	icon='icons/water.dmi'
	density=0
	layer=TURF_LAYER+1
	still
		icon_state="still"
	moveing
		icon_state="move"
	water_sides

		tl
			icon_state="tl"
		tr
			icon_state="tr"
		bl
			icon_state="bl"
		br
			icon_state="br"

	/*Del()
		for(var/obj/haku_ice/ice in src)
			del(ice)
		return ..()*/


obj/windblast
	layer=MOB_LAYER
	projdisturber=1
	icon='icons/windblast.dmi'
	density=0
	wplus
		icon_state="x+1"
	wminus
		icon_state="x-1"
	windtrail
		icon_state="trail"



proc
	wet_proj(dx,dy,dz,eicon,estate,mob/human/u,dist,epower,emag,sticky,dur=1200)
		set waitfor = 0
		var/obj/proj/M = new/obj/proj(locate(dx, dy, dz))
		M.projdisturber = 1
		M.density = 0
		M.icon = eicon
		M.icon_state = estate

		switch(u.dir)
			if(NORTHEAST, NORTHWEST)
				M.dir = NORTH
			if(SOUTHEAST, SOUTHWEST)
				M.dir = SOUTH
			else
				M.dir = u.dir

		if(emag >= 1)
			Wet_cap(M.x, M.y, M.z, M.dir, emag, dur, sticky)
			Wet(M.x, M.y, M.z, M.dir, emag, dur, sticky)

		sleep(1)
		var/stepsleft = dist
		while(stepsleft > 0 && M)
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M, M.dir))
					if(istype(O, /mob/human))
						if(O != u)
							hit = O

				M.loc = get_step(M, M.dir)

				sleep(1)

				if(emag>=1)
					Wet(M.x, M.y, M.z, M.dir, emag, dur, sticky)

				walk(M, 0)
				stepsleft--
				if(hit)
					//hit = hit.Replacement_Start(u)
					if(epower) hit.Damage(epower, 0, u, "Water Projectile", "Normal")
					if(sticky) hit.Timed_Stun(40)
					//spawn(1)
					if(hit)
						hit.Knockback(1, M.dir)
						if(u)
							if(hit)
								hit.Hostile(u)

		M.loc = get_step(M, M.dir)

		if(emag >= 1)
			Wet_cap(M.x, M.y, M.z, M.dir, emag, dur, sticky)

		sleep(1)

		M.loc = null

proc
	Wet_cap(start_x, start_y, start_z, xdir, mag, xdur, sticky)
		set waitfor = 0
		var
			side_dx = 0
			side_dy = 0
			water_type
			sides[0]

		switch(xdir)
			if(NORTH)
				side_dx = 1
				if(sticky) water_type = /obj/water_sides/sticky/wu
				else water_type = /obj/water_sides/wu
			if(SOUTH)
				side_dx = 1
				if(sticky) water_type = /obj/water_sides/sticky/wd
				else water_type = /obj/water_sides/wd
			if(EAST)
				side_dy = 1
				if(sticky) water_type = /obj/water_sides/sticky/wr
				else water_type = /obj/water_sides/wr
			if(WEST)
				side_dy = 1
				if(sticky) water_type = /obj/water_sides/sticky/wl
				else water_type = /obj/water_sides/wl
			else
				CRASH("Unsupported xdir ([xdir])")

		//sides += new water_type(locate(start_x, start_y, start_z))
		if(!(locate(water_type) in locate(start_x, start_y, start_z)))
			sides += new water_type(locate(start_x, start_y, start_z))
		while(mag > 1)
			//sides.Add(
			//new water_type(locate(start_x + (mag-1)*side_dx, start_y + (mag-1)*side_dy, start_z)),
			//new water_type(locate(start_x - (mag-1)*side_dx, start_y - (mag-1)*side_dy, start_z)))
			var/turf/t1 = locate(start_x + (mag-1)*side_dx, start_y + (mag-1)*side_dy, start_z)
			var/turf/t2 = locate(start_x - (mag-1)*side_dx, start_y - (mag-1)*side_dy, start_z)
			if(!(locate(water_type) in t1)) sides += new water_type(t1)
			if(!(locate(water_type) in t2)) sides += new water_type(t2)
			--mag

		sleep(xdur)
		for(var/obj/O in sides)
			O.dispose()

	Wet(start_x, start_y, start_z, xdir, mag, xdur, sticky)
		set waitfor = 0
		var
			side_dx = 0
			side_dy = 0
			side_type1
			side_type2
			water_type = /obj/water
			water[0]

		if(sticky) water_type = /obj/water/sticky

		switch(xdir)
			if(NORTH)
				side_dx = 1
				if(sticky)
					side_type1 = /obj/water_sides/sticky/wr
					side_type2 = /obj/water_sides/sticky/wl
				else
					side_type1 = /obj/water_sides/wr
					side_type2 = /obj/water_sides/wl
			if(SOUTH)
				side_dx = 1
				if(sticky)
					side_type1 = /obj/water_sides/sticky/wr
					side_type2 = /obj/water_sides/sticky/wl
				else
					side_type1 = /obj/water_sides/wr
					side_type2 = /obj/water_sides/wl
			if(EAST)
				side_dy = 1
				if(sticky)
					side_type1 = /obj/water_sides/sticky/wu
					side_type2 = /obj/water_sides/sticky/wd
				else
					side_type1 = /obj/water_sides/wu
					side_type2 = /obj/water_sides/wd
			if(WEST)
				side_dy = 1
				if(sticky)
					side_type1 = /obj/water_sides/sticky/wu
					side_type2 = /obj/water_sides/sticky/wd
				else
					side_type1 = /obj/water_sides/wu
					side_type2 = /obj/water_sides/wd
			else
				CRASH("Unsupported xdir ([xdir])")

		if(!(locate(water_type) in locate(start_x, start_y, start_z)))
			water.Add(new water_type(locate(start_x, start_y, start_z)),
			new side_type1(locate(start_x + mag * side_dx, start_y + mag * side_dy, start_z)),
			new side_type2(locate(start_x - mag * side_dx, start_y - mag * side_dy, start_z)))
		while(mag > 1)
			var/t1 = locate(start_x + (mag-1)*side_dx, start_y + (mag-1)*side_dy, start_z)
			var/t2 = locate(start_x - (mag-1)*side_dx, start_y - (mag-1)*side_dy, start_z)
			if(!locate(water_type) in t1) water += new water_type(t1)
			if(!locate(water_type) in t2) water += new water_type(t2)
			//water.Add(new water_type(locate(start_x + (mag-1)*side_dx, start_y + (mag-1)*side_dy, start_z)),
			//new water_type(locate(start_x - (mag-1)*side_dx, start_y - (mag-1)*side_dy, start_z)))

			--mag

		sleep(xdur)
		for(var/obj/O in water)
			O.dispose()
/*
proc
	wet_proj(dx,dy,dz,eicon,estate,mob/human/u,dist,epower,emag)
		set waitfor = 0
		//world.log << "EPOWER IS [epower]"
		if(emag>=1)
			if(u.dir==NORTH)
				Wet_cap(u.x,u.y,u.z,SOUTH,emag,1200)
			if(u.dir==SOUTH)
				Wet_cap(u.x,u.y,u.z,NORTH,emag,1200)
			if(u.dir==WEST)
				Wet_cap(u.x,u.y,u.z,EAST,emag,1200)
			if(u.dir==EAST)
				Wet_cap(u.x,u.y,u.z,WEST,emag,1200)

		var/obj/proj/M = new/obj/proj(locate(dx,dy,dz))
		M.projdisturber=1
		M.density=0
		M.icon=eicon
		M.icon_state=estate

		if(u.dir==NORTH||u.dir==SOUTH||u.dir==EAST||u.dir==WEST)
			M.dir=u.dir
		if(u.dir==NORTHEAST||u.dir==NORTHWEST)
			M.dir=NORTH
		else if(u.dir==SOUTHEAST|u.dir==SOUTHWEST)
			M.dir=SOUTH
		sleep(1)
		var/stepsleft=dist
		//var/alreadyhit[] = list()
		var/list/hitlist = list()
		while(stepsleft>0 && M )
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M,M.dir))
					if(istype(O,/mob/human))
						if(O!=u)
							hit=O
							break

			//	walk(M,M.dir)
				if(M.dir==NORTH)
					M.y++
				if(M.dir==SOUTH)
					M.y--
				if(M.dir==EAST)
					M.x++
				if(M.dir==WEST)
					M.x--
				sleep(1)
				if(emag>=1)
					Wet(M.x,M.y,M.z,M.dir,emag,1200)
				walk(M,0)
				stepsleft--
				if(hit && (!(hit.realname in hitlist) || hitlist[hit.realname] < 5))
					hit.Timed_Stun(5)
					hit.Damage(epower, 0, u, "Water Wave")
					hitlist[hit.realname]++
					if(hit)
						hit.Knockback(1,M.dir)
						if(u)
							if(hit)
								hit.Hostile(u)
		if(M.dir==NORTH)
			M.y++
		if(M.dir==SOUTH)
			M.y--
		if(M.dir==EAST)
			M.x++
		if(M.dir==WEST)
			M.x--
		if(emag>=1)
			Wet_cap(M.x,M.y,M.z,M.dir,emag,1200)
		sleep(1)
		M.dispose()//del(M)




proc/Wet_cap(dx,dy,dz,xdir,mag,xdur)
	set waitfor = 0
	switch(mag)
		if(1)
			var/obj/Water_sides/w1

			if(xdir==NORTH)
				w1=new/obj/Water_sides/wu(locate(dx,dy,dz))
			if(xdir==SOUTH)
				w1=new/obj/Water_sides/wd(locate(dx,dy,dz))
			if(xdir==WEST)
				w1=new/obj/Water_sides/wl(locate(dx,dy,dz))
			if(xdir==EAST)
				w1=new/obj/Water_sides/wr(locate(dx,dy,dz))
			sleep(xdur)
			del(w1)
		if(2)
			var/obj/Water_sides/w1
			var/obj/Water_sides/w2
			var/obj/Water_sides/w3
			if(xdir==NORTH)
				w1=new/obj/Water_sides/wu(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wu(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wu(locate(dx+1,dy,dz))
			if(xdir==SOUTH)
				w1=new/obj/Water_sides/wd(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wd(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wd(locate(dx+1,dy,dz))
			if(xdir==WEST)
				w1=new/obj/Water_sides/wl(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wl(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wl(locate(dx,dy-1,dz))
			if(xdir==EAST)
				w1=new/obj/Water_sides/wr(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wr(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wr(locate(dx,dy-1,dz))
			sleep(xdur)
			w1.dispose()//del(w1)
			w2.dispose()//del(w2)
			w3.dispose()//del(w3)
		if(3)
			var/obj/Water_sides/w1
			var/obj/Water_sides/w2
			var/obj/Water_sides/w3
			var/obj/Water_sides/w4
			var/obj/Water_sides/w5
			if(xdir==NORTH)
				w1=new/obj/Water_sides/wu(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wu(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wu(locate(dx+1,dy,dz))
				w4=new/obj/Water_sides/wu(locate(dx-2,dy,dz))
				w5=new/obj/Water_sides/wu(locate(dx+2,dy,dz))
			if(xdir==SOUTH)
				w1=new/obj/Water_sides/wd(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wd(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wd(locate(dx+1,dy,dz))
				w4=new/obj/Water_sides/wd(locate(dx-2,dy,dz))
				w5=new/obj/Water_sides/wd(locate(dx+2,dy,dz))
			if(xdir==WEST)
				w1=new/obj/Water_sides/wl(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wl(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wl(locate(dx,dy-1,dz))
				w4=new/obj/Water_sides/wl(locate(dx,dy+2,dz))
				w5=new/obj/Water_sides/wl(locate(dx,dy-2,dz))
			if(xdir==EAST)
				w1=new/obj/Water_sides/wr(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wr(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wr(locate(dx,dy-1,dz))
				w4=new/obj/Water_sides/wr(locate(dx,dy+2,dz))
				w5=new/obj/Water_sides/wr(locate(dx,dy-2,dz))
			sleep(xdur)
			w1.dispose()//del(w1)
			w2.dispose()//del(w2)
			w3.dispose()//del(w3)
			w4.dispose()//del(w4)
			w5.dispose()//del(w5)
		if(4)
			var/obj/Water_sides/w1
			var/obj/Water_sides/w2
			var/obj/Water_sides/w3
			var/obj/Water_sides/w4
			var/obj/Water_sides/w5
			var/obj/Water_sides/w6
			var/obj/Water_sides/w7
			if(xdir==NORTH)
				w1=new/obj/Water_sides/wu(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wu(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wu(locate(dx+1,dy,dz))
				w4=new/obj/Water_sides/wu(locate(dx-2,dy,dz))
				w5=new/obj/Water_sides/wu(locate(dx+2,dy,dz))
				w6=new/obj/Water_sides/wu(locate(dx-3,dy,dz))
				w7=new/obj/Water_sides/wu(locate(dx+3,dy,dz))
			if(xdir==SOUTH)
				w1=new/obj/Water_sides/wd(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wd(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wd(locate(dx+1,dy,dz))
				w4=new/obj/Water_sides/wd(locate(dx-2,dy,dz))
				w5=new/obj/Water_sides/wd(locate(dx+2,dy,dz))
				w6=new/obj/Water_sides/wd(locate(dx-3,dy,dz))
				w7=new/obj/Water_sides/wd(locate(dx+3,dy,dz))
			if(xdir==WEST)
				w1=new/obj/Water_sides/wl(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wl(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wl(locate(dx,dy-1,dz))
				w4=new/obj/Water_sides/wl(locate(dx,dy+2,dz))
				w5=new/obj/Water_sides/wl(locate(dx,dy-2,dz))
				w6=new/obj/Water_sides/wl(locate(dx,dy+3,dz))
				w7=new/obj/Water_sides/wl(locate(dx,dy-3,dz))
			if(xdir==EAST)
				w1=new/obj/Water_sides/wr(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wr(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wr(locate(dx,dy-1,dz))
				w4=new/obj/Water_sides/wr(locate(dx,dy+2,dz))
				w5=new/obj/Water_sides/wr(locate(dx,dy-2,dz))
				w6=new/obj/Water_sides/wr(locate(dx,dy+3,dz))
				w7=new/obj/Water_sides/wr(locate(dx,dy-3,dz))
			sleep(xdur)
			w1.dispose()//del(w1)
			w2.dispose()//del(w2)
			w3.dispose()//del(w3)
			w4.dispose()//del(w4)
			w5.dispose()//del(w5)
			w6.dispose()//del(w1)
			w7.dispose()//del(w2)
		if(5)
			var/obj/Water_sides/w1
			var/obj/Water_sides/w2
			var/obj/Water_sides/w3
			var/obj/Water_sides/w4
			var/obj/Water_sides/w5
			var/obj/Water_sides/w6
			var/obj/Water_sides/w7
			var/obj/Water_sides/w8
			var/obj/Water_sides/w9
			if(xdir==NORTH)
				w1=new/obj/Water_sides/wu(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wu(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wu(locate(dx+1,dy,dz))
				w4=new/obj/Water_sides/wu(locate(dx-2,dy,dz))
				w5=new/obj/Water_sides/wu(locate(dx+2,dy,dz))
				w6=new/obj/Water_sides/wu(locate(dx-3,dy,dz))
				w7=new/obj/Water_sides/wu(locate(dx+3,dy,dz))
				w8=new/obj/Water_sides/wu(locate(dx-4,dy,dz))
				w9=new/obj/Water_sides/wu(locate(dx+4,dy,dz))
			if(xdir==SOUTH)
				w1=new/obj/Water_sides/wd(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wd(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wd(locate(dx+1,dy,dz))
				w4=new/obj/Water_sides/wd(locate(dx-2,dy,dz))
				w5=new/obj/Water_sides/wd(locate(dx+2,dy,dz))
				w6=new/obj/Water_sides/wd(locate(dx-3,dy,dz))
				w7=new/obj/Water_sides/wd(locate(dx+3,dy,dz))
				w8=new/obj/Water_sides/wd(locate(dx-4,dy,dz))
				w9=new/obj/Water_sides/wd(locate(dx+4,dy,dz))
			if(xdir==WEST)
				w1=new/obj/Water_sides/wl(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wl(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wl(locate(dx,dy-1,dz))
				w4=new/obj/Water_sides/wl(locate(dx,dy+2,dz))
				w5=new/obj/Water_sides/wl(locate(dx,dy-2,dz))
				w6=new/obj/Water_sides/wl(locate(dx,dy+3,dz))
				w7=new/obj/Water_sides/wl(locate(dx,dy-3,dz))
				w8=new/obj/Water_sides/wl(locate(dx,dy+4,dz))
				w9=new/obj/Water_sides/wl(locate(dx,dy-4,dz))
			if(xdir==EAST)
				w1=new/obj/Water_sides/wr(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wr(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wr(locate(dx,dy-1,dz))
				w4=new/obj/Water_sides/wr(locate(dx,dy+2,dz))
				w5=new/obj/Water_sides/wr(locate(dx,dy-2,dz))
				w6=new/obj/Water_sides/wr(locate(dx,dy+3,dz))
				w7=new/obj/Water_sides/wr(locate(dx,dy-3,dz))
				w8=new/obj/Water_sides/wr(locate(dx,dy+4,dz))
				w9=new/obj/Water_sides/wr(locate(dx,dy-4,dz))
			sleep(xdur)
			w1.dispose()//del(w1)
			w2.dispose()//del(w2)
			w3.dispose()//del(w3)
			w4.dispose()//del(w4)
			w5.dispose()//del(w5)
			w6.dispose()//del(w1)
			w7.dispose()//del(w2)
			w8.dispose()//del(w3)
			w9.dispose()//del(w4)
		else//if(mag>=6)
			var/obj/Water_sides/w1
			var/obj/Water_sides/w2
			var/obj/Water_sides/w3
			var/obj/Water_sides/w4
			var/obj/Water_sides/w5
			var/obj/Water_sides/w6
			var/obj/Water_sides/w7
			var/obj/Water_sides/w8
			var/obj/Water_sides/w9
			var/obj/Water_sides/w10
			var/obj/Water_sides/w11
			if(xdir==NORTH)
				w1=new/obj/Water_sides/wu(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wu(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wu(locate(dx+1,dy,dz))
				w4=new/obj/Water_sides/wu(locate(dx-2,dy,dz))
				w5=new/obj/Water_sides/wu(locate(dx+2,dy,dz))
				w6=new/obj/Water_sides/wu(locate(dx-3,dy,dz))
				w7=new/obj/Water_sides/wu(locate(dx+3,dy,dz))
				w8=new/obj/Water_sides/wu(locate(dx-4,dy,dz))
				w9=new/obj/Water_sides/wu(locate(dx+4,dy,dz))
				w10=new/obj/Water_sides/wu(locate(dx-5,dy,dz))
				w11=new/obj/Water_sides/wu(locate(dx+5,dy,dz))
			if(xdir==SOUTH)
				w1=new/obj/Water_sides/wd(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wd(locate(dx-1,dy,dz))
				w3=new/obj/Water_sides/wd(locate(dx+1,dy,dz))
				w4=new/obj/Water_sides/wd(locate(dx-2,dy,dz))
				w5=new/obj/Water_sides/wd(locate(dx+2,dy,dz))
				w6=new/obj/Water_sides/wd(locate(dx-3,dy,dz))
				w7=new/obj/Water_sides/wd(locate(dx+3,dy,dz))
				w8=new/obj/Water_sides/wd(locate(dx-4,dy,dz))
				w9=new/obj/Water_sides/wd(locate(dx+4,dy,dz))
				w10=new/obj/Water_sides/wd(locate(dx-5,dy,dz))
				w11=new/obj/Water_sides/wd(locate(dx+5,dy,dz))
			if(xdir==WEST)
				w1=new/obj/Water_sides/wl(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wl(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wl(locate(dx,dy-1,dz))
				w4=new/obj/Water_sides/wl(locate(dx,dy+2,dz))
				w5=new/obj/Water_sides/wl(locate(dx,dy-2,dz))
				w6=new/obj/Water_sides/wl(locate(dx,dy+3,dz))
				w7=new/obj/Water_sides/wl(locate(dx,dy-3,dz))
				w8=new/obj/Water_sides/wl(locate(dx,dy+4,dz))
				w9=new/obj/Water_sides/wl(locate(dx,dy-4,dz))
				w10=new/obj/Water_sides/wl(locate(dx,dy+5,dz))
				w11=new/obj/Water_sides/wl(locate(dx,dy-5,dz))
			if(xdir==EAST)
				w1=new/obj/Water_sides/wr(locate(dx,dy,dz))
				w2=new/obj/Water_sides/wr(locate(dx,dy+1,dz))
				w3=new/obj/Water_sides/wr(locate(dx,dy-1,dz))
				w4=new/obj/Water_sides/wr(locate(dx,dy+2,dz))
				w5=new/obj/Water_sides/wr(locate(dx,dy-2,dz))
				w6=new/obj/Water_sides/wr(locate(dx,dy+3,dz))
				w7=new/obj/Water_sides/wr(locate(dx,dy-3,dz))
				w8=new/obj/Water_sides/wr(locate(dx,dy+4,dz))
				w9=new/obj/Water_sides/wr(locate(dx,dy-4,dz))
				w10=new/obj/Water_sides/wr(locate(dx,dy+5,dz))
				w11=new/obj/Water_sides/wr(locate(dx,dy-5,dz))
			sleep(xdur)
			w1.dispose()//del(w1)
			w2.dispose()//del(w2)
			w3.dispose()//del(w3)
			w4.dispose()//del(w4)
			w5.dispose()//del(w5)
			w6.dispose()//del(w1)
			w7.dispose()//del(w2)
			w8.dispose()//del(w3)
			w9.dispose()//del(w4)
			w10.dispose()//del(w5)
			w11.dispose()//del(w1)

proc/Wet(dx,dy,dz,xdir,mag,xdur)
	set waitfor = 0
	var/obj/Water_sides/ws1
	var/obj/Water_sides/ws2
	switch(mag)
		if(1)
			var/obj/Water/w1= new/obj/Water(locate(dx,dy,dz))

			if(xdir==NORTH||xdir==SOUTH)
				ws1=new/obj/Water_sides/wr(locate(dx+1,dy,dz))
				ws2=new/obj/Water_sides/wl(locate(dx-1,dy,dz))
			if(xdir==WEST||xdir==EAST)
				ws1=new/obj/Water_sides/wu(locate(dx,dy+1,dz))
				ws2=new/obj/Water_sides/wd(locate(dx,dy-1,dz))
			sleep(xdur)
			ws1.dispose()//del(ws1)
			ws2.dispose()//del(ws2)
			w1.dispose()//del(w1)
		if(2)
			var/obj/Water/w1= new/obj/Water(locate(dx,dy,dz))
			var/obj/Water/w2
			var/obj/Water/w3
			if(xdir==1||xdir==2)
				w2=new/obj/Water(locate(dx-1,dy,dz))
				w3=new/obj/Water(locate(dx+1,dy,dz))
				ws1=new/obj/Water_sides/wr(locate(dx+2,dy,dz))
				ws2=new/obj/Water_sides/wl(locate(dx-2,dy,dz))
			if(xdir==8||xdir==4)
				w2=new/obj/Water(locate(dx,dy-1,dz))
				w3=new/obj/Water(locate(dx,dy+1,dz))
				ws1=new/obj/Water_sides/wu(locate(dx,dy+2,dz))
				ws2=new/obj/Water_sides/wd(locate(dx,dy-2,dz))
			sleep(xdur)
			ws1.dispose()//del(ws1)
			ws2.dispose()//del(ws2)
			w1.dispose()//del(w1)
			w2.dispose()
			w3.dispose()
		if(3)
			var/obj/Water/w1= new/obj/Water(locate(dx,dy,dz))
			var/obj/Water/w2
			var/obj/Water/w3
			var/obj/Water/w4
			var/obj/Water/w5
			if(xdir==NORTH||xdir==SOUTH)
				w2=new/obj/Water(locate(dx-1,dy,dz))
				w3=new/obj/Water(locate(dx+1,dy,dz))
				w4=new/obj/Water(locate(dx-2,dy,dz))
				w5=new/obj/Water(locate(dx+2,dy,dz))
				ws1=new/obj/Water_sides/wr(locate(dx+(mag),dy,dz))
				ws2=new/obj/Water_sides/wl(locate(dx-(mag),dy,dz))
			if(xdir==WEST||xdir==EAST)
				w2=new/obj/Water(locate(dx,dy-1,dz))
				w3=new/obj/Water(locate(dx,dy+1,dz))
				w4=new/obj/Water(locate(dx,dy-2,dz))
				w5=new/obj/Water(locate(dx,dy+2,dz))
				ws1=new/obj/Water_sides/wu(locate(dx,dy+(mag),dz))
				ws2=new/obj/Water_sides/wd(locate(dx,dy-(mag),dz))
			sleep(xdur)
			ws1.dispose()//del(ws1)
			ws2.dispose()//del(ws2)
			w1.dispose()//del(w1)
			w2.dispose()//del(w1)
			w3.dispose()//del(w1)
			w4.dispose()
			w5.dispose()
		if(4)
			var/obj/Water/w1= new/obj/Water(locate(dx,dy,dz))
			var/obj/Water/w2
			var/obj/Water/w3
			var/obj/Water/w4
			var/obj/Water/w5
			var/obj/Water/w6
			var/obj/Water/w7
			if(xdir==NORTH||xdir==SOUTH)
				w2=new/obj/Water(locate(dx-1,dy,dz))
				w3=new/obj/Water(locate(dx+1,dy,dz))
				w4=new/obj/Water(locate(dx-2,dy,dz))
				w5=new/obj/Water(locate(dx+2,dy,dz))
				w6=new/obj/Water(locate(dx-3,dy,dz))
				w7=new/obj/Water(locate(dx+3,dy,dz))
				ws1=new/obj/Water_sides/wr(locate(dx+(mag),dy,dz))
				ws2=new/obj/Water_sides/wl(locate(dx-(mag),dy,dz))
			if(xdir==WEST||xdir==EAST)
				w3=new/obj/Water(locate(dx,dy+1,dz))
				w4=new/obj/Water(locate(dx,dy-2,dz))
				w5=new/obj/Water(locate(dx,dy+2,dz))
				w6=new/obj/Water(locate(dx,dy-3,dz))
				w7=new/obj/Water(locate(dx,dy+3,dz))
				ws1=new/obj/Water_sides/wu(locate(dx,dy+(mag),dz))
				ws2=new/obj/Water_sides/wd(locate(dx,dy-(mag),dz))
			sleep(xdur)
			ws1.dispose()//del(ws1)
			ws2.dispose()//del(ws2)
			w1.dispose()//del(w1)
			w2.dispose()//del(w1)
			w3.dispose()//del(w1)
			w4.dispose()
			w5.dispose()
			w6.dispose()
			w7.dispose()
		if(5)
			var/obj/Water/w1= new/obj/Water(locate(dx,dy,dz))
			var/obj/Water/w2
			var/obj/Water/w3
			var/obj/Water/w4
			var/obj/Water/w5
			var/obj/Water/w6
			var/obj/Water/w7
			var/obj/Water/w8
			var/obj/Water/w9
			if(xdir==NORTH||xdir==SOUTH)
				w2=new/obj/Water(locate(dx-1,dy,dz))
				w3=new/obj/Water(locate(dx+1,dy,dz))
				w4=new/obj/Water(locate(dx-2,dy,dz))
				w5=new/obj/Water(locate(dx+2,dy,dz))
				w6=new/obj/Water(locate(dx-3,dy,dz))
				w7=new/obj/Water(locate(dx+3,dy,dz))
				w8=new/obj/Water(locate(dx-3,dy,dz))
				w9=new/obj/Water(locate(dx+3,dy,dz))
				ws1=new/obj/Water_sides/wr(locate(dx+(mag),dy,dz))
				ws2=new/obj/Water_sides/wl(locate(dx-(mag),dy,dz))
			if(xdir==WEST||xdir==EAST)
				w2=new/obj/Water(locate(dx,dy-1,dz))
				w3=new/obj/Water(locate(dx,dy+1,dz))
				w4=new/obj/Water(locate(dx,dy-2,dz))
				w5=new/obj/Water(locate(dx,dy+2,dz))
				w6=new/obj/Water(locate(dx,dy-3,dz))
				w7=new/obj/Water(locate(dx,dy+3,dz))
				w8=new/obj/Water(locate(dx,dy-4,dz))
				w9=new/obj/Water(locate(dx,dy+4,dz))

				ws1=new/obj/Water_sides/wu(locate(dx,dy+(mag),dz))
				ws2=new/obj/Water_sides/wd(locate(dx,dy-(mag),dz))
			sleep(xdur)
			ws1.dispose()//del(ws1)
			ws2.dispose()//del(ws2)
			w1.dispose()//del(w1)
			w2.dispose()//del(w1)
			w3.dispose()//del(w1)
			w4.dispose()
			w5.dispose()
			w6.dispose()
			w7.dispose()
			w8.dispose()
			w9.dispose()
		else
			var/obj/Water/w1= new/obj/Water(locate(dx,dy,dz))
			var/obj/Water/w2
			var/obj/Water/w3
			var/obj/Water/w4
			var/obj/Water/w5
			var/obj/Water/w6
			var/obj/Water/w7
			var/obj/Water/w8
			var/obj/Water/w9
			var/obj/Water/w10
			var/obj/Water/w11
			if(xdir==NORTH||xdir==SOUTH)
				w2=new/obj/Water(locate(dx-1,dy,dz))
				w3=new/obj/Water(locate(dx+1,dy,dz))
				w4=new/obj/Water(locate(dx-2,dy,dz))
				w5=new/obj/Water(locate(dx+2,dy,dz))
				w6=new/obj/Water(locate(dx-3,dy,dz))
				w7=new/obj/Water(locate(dx+3,dy,dz))
				w8=new/obj/Water(locate(dx-4,dy,dz))
				w9=new/obj/Water(locate(dx+4,dy,dz))
				w10=new/obj/Water(locate(dx-5,dy,dz))
				w11=new/obj/Water(locate(dx+5,dy,dz))
				ws1=new/obj/Water_sides/wr(locate(dx+(mag),dy,dz))
				ws2=new/obj/Water_sides/wl(locate(dx-(mag),dy,dz))
			if(xdir==WEST||xdir==EAST)
				w2=new/obj/Water(locate(dx,dy-1,dz))
				w3=new/obj/Water(locate(dx,dy+1,dz))
				w4=new/obj/Water(locate(dx,dy-2,dz))
				w5=new/obj/Water(locate(dx,dy+2,dz))
				w6=new/obj/Water(locate(dx,dy-3,dz))
				w7=new/obj/Water(locate(dx,dy+3,dz))
				w8=new/obj/Water(locate(dx,dy-4,dz))
				w9=new/obj/Water(locate(dx,dy+4,dz))
				w10=new/obj/Water(locate(dx,dy-5,dz))
				w11=new/obj/Water(locate(dx,dy+5,dz))
				ws1=new/obj/Water_sides/wu(locate(dx,dy+(mag),dz))
				ws2=new/obj/Water_sides/wd(locate(dx,dy-(mag),dz))
			sleep(xdur)
			ws1.dispose()//del(ws1)
			ws2.dispose()//del(ws2)
			w1.dispose()//del(w1)
			w2.dispose()//del(w1)
			w3.dispose()//del(w1)
			w4.dispose()
			w5.dispose()
			w6.dispose()
			w7.dispose()
			w8.dispose()
			w9.dispose()
			w10.dispose()
			w11.dispose()
*/

mob/var
	obj/Contract=0
	Contract2=0
proc/Poof(location)//(dx,dy,dz)
	smoke_effect(location)

obj/jashin_circle
	layer=OBJ_LAYER+0.9
	density=0
	icon='icons/jashinsymbol.dmi'


proc/Blood2(mob/X,mob/human/U)
	blood_effect(X, U)


proc/ChidoriFX(mob/human/o)
	set waitfor = 0
	var/obj/c = new/obj/effect()
	o.icon_state="PunchA-2"
	c.icon='icons/chidori2.dmi'
	if(o.dir==NORTH)
		c.pixel_y+=22
	if(o.dir==SOUTH)
		c.pixel_y-=22
	if(o.dir==EAST)
		c.pixel_x+=22
	if(o.dir==WEST)
		c.pixel_x-=22
	o.overlays+=c
	sleep(20)
	o.overlays-=c
	c.loc = null
	o.icon_state=""
obj/ForcePressure
	icon='icons/wind.dmi'
	layer=MOB_LAYER+1
	density=0
	New(loc,dirx)
		set waitfor = 0
		..()
		src.dir=dirx
		sleep(20)
		del(src)
	Del()
		if(loc == null)
			return ..()
		loc = null

proc/Force_pressure(dx,dy,dz,obj/O)
	set waitfor = 0
	var/Odir=NORTH
	if(O)Odir=O.dir
	sleep(3)
	var/obj/X=new/obj/ForcePressure(locate(dx,dy,dz),Odir)
	if(X)X.dir=Odir
obj
	var
		list/parts=new
		spawner=0
		list/Pwned=new
		center_x
		center_y
	multipart
		Pressure
			PEAST
				//#if DM_VERSION < 455
				icon='pngs/pressure-east.png'
				icon_state="1,1"
				center_x = 1
				center_y = 1
				//#else
				//icon = 'icons/pressure.dmi'
				//center_x = 2
				//center_y = 1
				//#endif
				spawner=1
				dir=EAST
				density=0
				layer=MOB_LAYER+2
			PWEST
				//#if DM_VERSION < 455
				icon='pngs/pressure-west.png'
				icon_state="0,1"
				center_x = 0
				center_y = 1
				//#else
				//icon = 'icons/pressure.dmi'
				//center_x = 0
				//center_y = 1
				//#endif
				spawner=1
				dir=WEST
				density=0
				layer=MOB_LAYER+2
			PSOUTH
				//#if DM_VERSION < 455
				icon='pngs/pressure-south.png'
				icon_state="1,0"
				center_x = 1
				center_y = 0
				//#else
				//icon = 'icons/pressure.dmi'
				//center_x = 1
				//center_y = 0
				//#endif
				spawner=1
				dir=SOUTH
				density=0
				layer=MOB_LAYER+2
			PNORTH
				//#if DM_VERSION < 455
				icon='pngs/pressure-north.png'
				icon_state="1,1"
				center_x = 1
				center_y = 1
				//#else
				//icon = 'icons/pressure.dmi'
				//center_x = 1
				//center_y = 2
				//#endif
				spawner=1
				dir=NORTH
				density=0
				layer=MOB_LAYER+2


			Move()
				Force_pressure(src.x,src.y,src.z,src)
				return ..()
		Del()
			if(src.spawner)
				for(var/obj/X in src.parts)
					if(X!=src)
						del(X)
			..()
		New(loc,spawnr)
			..()

			if(spawnr)
				src.spawner=1
			else
				src.spawner=0

			if(!src.spawner)
				return 1

			//#if DM_VERSION >= 455
/*			var/icon/I = new(icon)

			pixel_x = -((I.Width()-world.IconSizeX())/2)
			pixel_y = -((I.Height()-world.IconSizeY())/2)

			parts += src

			var/tiles_x = -round(-(I.Width() / world.IconSizeX()))
			var/tiles_y = -round(-(I.Height() / world.IconSizeY()))

			for(var/tile_x in 0 to (tiles_x-1))
				for(var/tile_y in 0 to (tiles_y-1))
					var/offset_x = tile_x - center_x
					var/offset_y = tile_y - center_y

					if(offset_x == 0 && offset_y == 0)
						continue

					var/obj/multipart/X = new type(locate(x + offset_x, y + offset_y, z), 0)
					X.icon = null
					X.dir = dir
					parts += X*/

			//#else
			var/centerx=center_x
			var/centery=center_y

			src.parts+=src
			var/list/States=icon_states(src.icon)

			for(var/S in States)

				if(length(S) && S!=src.icon_state)
					var/list/eL= Return_Coordinates(S)
					var/px=eL[1]
					var/py=eL[2]

					var/obj/multipart/X=new type(locate((src.x+px-centerx),(src.y+py-centery),src.z),0)
					X.icon_state=S
					X.dir=src.dir
					src.parts+=X
			//#endif

			for(var/obj/X in src.parts)
				if(X!=src)
					X.parts=src.parts

		Move()
			if(src.spawner)
				var/blocked=0
				for(var/obj/X in src.parts)
					var/atom/Ox=get_step(X,X.dir)
					if(!Ox || !Ox.Enter(X))
						blocked++
				var/turf/T=get_step(src,src.dir)
				if(!T||T.density)
					return 0

				if(!blocked)
					for(var/obj/X in src.parts)
						if(X!=src)
							step(X,X.dir)
					for(var/mob/X in src.Pwned)
					//	if(abs(X.x-src.x)<4 && abs(X.y-src.y)<4)
						if(X) X.loc=loc//locate(src.x,src.y,src.z)

			return ..()





obj
	Gustfx
		density=0
		icon='icons/gust.dmi'
		projdisturber=1

		proc/begin_life(delay=0)
			set waitfor = 0
			icon_state="blow"
			walk(src, dir)
			sleep(delay)
			walk(src, 0)
			loc = null

proc/Gust(dx,dy,dz,xdir,mag,xdist)
	var/list/xlist[]=new()
	if(mag==1)
		if(xdir==NORTH||xdir==SOUTH)
			xlist+=new/obj/Gustfx(locate(dx,dy,dz))
		if(xdir==EAST||xdir==WEST)
			xlist+=new/obj/Gustfx(locate(dx,dy,dz))

	if(mag==2)
		if(xdir==NORTH||xdir==SOUTH)
			xlist+=new/obj/Gustfx(locate(dx,dy,dz))
			xlist+=new/obj/Gustfx(locate(dx+1,dy,dz))
			xlist+=new/obj/Gustfx(locate(dx-1,dy,dz))
		if(xdir==EAST||xdir==WEST)
			xlist+=new/obj/Gustfx(locate(dx,dy,dz))
			xlist+=new/obj/Gustfx(locate(dx,dy+1,dz))
			xlist+=new/obj/Gustfx(locate(dx,dy-1,dz))
	if(mag==3)
		if(xdir==NORTH||xdir==SOUTH)
			xlist+=new/obj/Gustfx(locate(dx,dy,dz))
			xlist+=new/obj/Gustfx(locate(dx+1,dy,dz))
			xlist+=new/obj/Gustfx(locate(dx+2,dy,dz))
			xlist+=new/obj/Gustfx(locate(dx-1,dy,dz))
			xlist+=new/obj/Gustfx(locate(dx-2,dy,dz))
		if(xdir==EAST||xdir==WEST)
			xlist+=new/obj/Gustfx(locate(dx,dy,dz))
			xlist+=new/obj/Gustfx(locate(dx,dy+1,dz))
			xlist+=new/obj/Gustfx(locate(dx,dy-1,dz))
			xlist+=new/obj/Gustfx(locate(dx,dy+2,dz))
			xlist+=new/obj/Gustfx(locate(dx,dy-2,dz))

	for(var/obj/Gustfx/o in xlist)
		o.dir = xdir
		o.begin_life(xdist)
	del(xlist)
proc/PoisonCloud(dx,dy,dz,mag,dur)
	set waitfor = 0
	var/list/xlist=new
	if(mag==1)

		var/obj/P1= new/obj/Poison(locate(dx-1,dy+1,dz))
		P1.pixel_x=12
		P1.pixel_y=-12
		var/obj/P2= new/obj/Poison(locate(dx-1,dy,dz))
		P2.pixel_x=8

		var/obj/P3= new/obj/Poison(locate(dx-1,dy-1,dz))
		P3.pixel_x=12
		P3.pixel_y=12

		var/obj/P4= new/obj/Poison(locate(dx,dy+1,dz))
		P4.pixel_y=-8


		var/obj/P5= new/obj/Poison(locate(dx,dy-1,dz))
		P5.pixel_y=8
		var/obj/P6= new/obj/Poison(locate(dx+1,dy+1,dz))
		P6.pixel_x=-12
		P6.pixel_y=-12
		var/obj/P7= new/obj/Poison(locate(dx+1,dy,dz))
		P7.pixel_x=-8

		var/obj/P8= new/obj/Poison(locate(dx+1,dy-1,dz))
		P8.pixel_x=-12
		P8.pixel_y=12
		xlist+= new/obj/Poison(locate(dx,dy,dz))
		xlist.Add(P1,P2,P3,P4,P5,P6,P7,P8)
		/*xlist+=P1
		xlist+=P2
		xlist+=P3
		xlist+=P4
		xlist+=P5
		xlist+=P6
		xlist+=P7
		xlist+=P8*/
	for(var/obj/vx in xlist)
		vx.projdisturber=1

	sleep(dur)
	for(var/obj/vv in xlist)
		del(vv)
proc/Fire(dx,dy,dz,mag,dur)
	set waitfor = 0
	var/list/xlist=new
	if(mag==1)
		xlist.Add(new/obj/Fire/f1(locate(dx-1,dy+mag,dz)),
		new/obj/Fire/f2(locate(dx-1,dy,dz)),
		new/obj/Fire/f3(locate(dx-1,dy-1,dz)),
		new/obj/Fire/f4(locate(dx,dy+1,dz)),
		new/obj/Fire/f5(locate(dx,dy,dz)),
		new/obj/Fire/f6(locate(dx,dy-1,dz)),
		new/obj/Fire/f7(locate(dx+1,dy+mag,dz)),
		new/obj/Fire/f8(locate(dx+1,dy,dz)),
		new/obj/Fire/f9(locate(dx+1,dy-mag,dz)))

	if(mag>=2)

		xlist.Add(new/obj/Fire/f5(locate(dx-1,dy-1,dz)),
		new/obj/Fire/f5(locate(dx+1,dy-1,dz)),
		new/obj/Fire/f5(locate(dx-1,dy+1,dz)),
		new/obj/Fire/f5(locate(dx+1,dy+1,dz)),
		new/obj/Fire/f5(locate(dx,dy-1,dz)),
		new/obj/Fire/f5(locate(dx+1,dy,dz)),
		new/obj/Fire/f5(locate(dx-1,dy,dz)),
		new/obj/Fire/f5(locate(dx,dy+1,dz)),


		new/obj/Fire/f4(locate(dx,dy+2,dz)),
		new/obj/Fire/f1(locate(dx-1,dy+2,dz)),
		new/obj/Fire/f7(locate(dx+1,dy+2,dz)),

		new/obj/Fire/f1(locate(dx-2,dy+1,dz)),
		new/obj/Fire/f2(locate(dx-2,dy,dz)),
		new/obj/Fire/f3(locate(dx-2,dy-1,dz)),

		new/obj/Fire/f3(locate(dx-1,dy-2,dz)),
		new/obj/Fire/f6(locate(dx,dy-2,dz)),
		new/obj/Fire/f9(locate(dx+1,dy-2,dz)),

		new/obj/Fire/f7(locate(dx+2,dy+1,dz)),
		new/obj/Fire/f8(locate(dx+2,dy,dz)),
		new/obj/Fire/f9(locate(dx+2,dy-1,dz)),

		new/obj/Fire/f5(locate(dx,dy,dz)))
	for(var/obj/vx in xlist)
		vx.projdisturber=1

	sleep(dur)
	for(var/obj/vv in xlist)
		//del(vv)
		vv.dispose()

proc/Ash(dx,dy,dz,dur)
	set waitfor = 0
	var/list/X=new
	X.Add(new/obj/Ash/f5(locate(dx,dy,dz)),
	new/obj/Ash/f5(locate(dx+1,dy,dz)),
	new/obj/Ash/f5(locate(dx+2,dy,dz)),
	new/obj/Ash/f5(locate(dx+3,dy,dz)),
	new/obj/Ash/f5(locate(dx-1,dy,dz)),
	new/obj/Ash/f5(locate(dx-2,dy,dz)),
	new/obj/Ash/f5(locate(dx-3,dy,dz)),
	new/obj/Ash/f5(locate(dx,dy+1,dz)),
	new/obj/Ash/f5(locate(dx,dy+2,dz)),
	new/obj/Ash/f5(locate(dx,dy+3,dz)),
	new/obj/Ash/f5(locate(dx,dy-1,dz)),
	new/obj/Ash/f5(locate(dx,dy-2,dz)),
	new/obj/Ash/f5(locate(dx,dy-3,dz)),

	new/obj/Ash/f5(locate(dx+1,dy+3,dz)),
	new/obj/Ash/f5(locate(dx+2,dy+3,dz)),
	new/obj/Ash/f5(locate(dx-1,dy+3,dz)),
	new/obj/Ash/f5(locate(dx-2,dy+3,dz)),
	new/obj/Ash/f5(locate(dx+1,dy-3,dz)),
	new/obj/Ash/f5(locate(dx+2,dy-3,dz)),
	new/obj/Ash/f5(locate(dx-1,dy-3,dz)),
	new/obj/Ash/f5(locate(dx-2,dy-3,dz)),
	new/obj/Ash/f5(locate(dx+1,dy+2,dz)),
	new/obj/Ash/f5(locate(dx+2,dy+2,dz)),
	new/obj/Ash/f5(locate(dx-1,dy+2,dz)),
	new/obj/Ash/f5(locate(dx-2,dy+2,dz)),
	new/obj/Ash/f5(locate(dx+1,dy-2,dz)),
	new/obj/Ash/f5(locate(dx+2,dy-2,dz)),
	new/obj/Ash/f5(locate(dx-1,dy-2,dz)),
	new/obj/Ash/f5(locate(dx-2,dy-2,dz)),
	new/obj/Ash/f5(locate(dx-3,dy+2,dz)),
	new/obj/Ash/f5(locate(dx+3,dy+2,dz)),
	new/obj/Ash/f5(locate(dx+3,dy-2,dz)),
	new/obj/Ash/f5(locate(dx-3,dy-2,dz)),
	new/obj/Ash/f5(locate(dx+1,dy+1,dz)),
	new/obj/Ash/f5(locate(dx+2,dy+1,dz)),
	new/obj/Ash/f5(locate(dx-1,dy+1,dz)),
	new/obj/Ash/f5(locate(dx-2,dy+1,dz)),
	new/obj/Ash/f5(locate(dx+1,dy-1,dz)),
	new/obj/Ash/f5(locate(dx+2,dy-1,dz)),
	new/obj/Ash/f5(locate(dx-1,dy-1,dz)),
	new/obj/Ash/f5(locate(dx-2,dy-1,dz)),
	new/obj/Ash/f5(locate(dx-3,dy+1,dz)),
	new/obj/Ash/f5(locate(dx+3,dy+1,dz)),
	new/obj/Ash/f5(locate(dx+3,dy-1,dz)),
	new/obj/Ash/f5(locate(dx-3,dy-1,dz)),

	new/obj/Ash/f4(locate(dx,dy+4,dz)),
	new/obj/Ash/f4(locate(dx-1,dy+4,dz)),
	new/obj/Ash/f4(locate(dx+1,dy+4,dz)),

	new/obj/Ash/f6(locate(dx,dy-4,dz)),
	new/obj/Ash/f6(locate(dx-1,dy-4,dz)),
	new/obj/Ash/f6(locate(dx+1,dy-4,dz)),

	new/obj/Ash/f8(locate(dx+4,dy,dz)),
	new/obj/Ash/f8(locate(dx+4,dy+1,dz)),
	new/obj/Ash/f8(locate(dx+4,dy-1,dz)),

	new/obj/Ash/f2(locate(dx-4,dy-1,dz)),
	new/obj/Ash/f2(locate(dx-4,dy+1,dz)),
	new/obj/Ash/f2(locate(dx-4,dy,dz)),

	new/obj/Ash/f1(locate(dx-4,dy+2,dz)),
	new/obj/Ash/f1(locate(dx-3,dy+3,dz)),
	new/obj/Ash/f1(locate(dx-2,dy+4,dz)),

	new/obj/Ash/f7(locate(dx+4,dy+2,dz)),
	new/obj/Ash/f7(locate(dx+3,dy+3,dz)),
	new/obj/Ash/f7(locate(dx+2,dy+4,dz)),

	new/obj/Ash/f3(locate(dx-4,dy-2,dz)),
	new/obj/Ash/f3(locate(dx-3,dy-3,dz)),
	new/obj/Ash/f3(locate(dx-2,dy-4,dz)),

	new/obj/Ash/f9(locate(dx+4,dy-2,dz)),
	new/obj/Ash/f9(locate(dx+3,dy-3,dz)),
	new/obj/Ash/f9(locate(dx+2,dy-4,dz)))
	for(var/obj/O1 in X)
		O1.projdisturber=1

	sleep(dur)
	for(var/obj/O in X)
		//del(O)
		O.dispose()
	X = null


obj
	effect
		layer= MOB_LAYER+2
		density=0
	undereffect
		layer= MOB_LAYER-1
		density=0
		var/uowner=0

obj
	sword
		b1
			icon = 'icons/bsword1.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=-24
			pixel_y = -23

		b2
			icon = 'icons/bsword2.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=12
			pixel_y =12
		b3
			icon = 'icons/bsword3.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=-0
			pixel_y = 20

		b4
			icon = 'icons/bsword4.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_y=-21
		s1
			icon = 'sword1/sword1.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=-24
			pixel_y = -23

		s2
			icon = 'sword1/sword2.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=12
			pixel_y =12
		s3
			icon = 'sword1/sword3.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=-0
			pixel_y = 20

		s4
			icon = 'sword1/sword4.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_y=-21
		z1
			icon = 'icons/zabsword1.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=-24
			pixel_y = -23

		z2
			icon = 'icons/zabsword2.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=12
			pixel_y =12
		z3
			icon = 'icons/zabsword3.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=-0
			pixel_y = 20

		z4
			icon = 'icons/zabsword4.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_y=-21
		w1
			icon = 'icons/windsword1.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=-24
			pixel_y = -23

		w2
			icon = 'icons/windsword2.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=12
			pixel_y =12
		w3
			icon = 'icons/windsword3.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_x=-0
			pixel_y = 20

		w4
			icon = 'icons/windsword4.dmi'
			density = 0
			layer = MOB_LAYER+1
			pixel_y=-21
obj/Poison
	icon='icons/poison.dmi'
	icon_state="cloud"
	density=0
	layer=MOB_LAYER+1

	Del()
		if(loc == null)
			return ..()
		loc = null

obj/Fire
	dispose()
		loc = null

	f1
		icon='icons/katon.dmi'
		icon_state="1"
		density=0
		layer=MOB_LAYER+1
	f2
		icon='icons/katon.dmi'
		icon_state="2"
		density=0
		layer=MOB_LAYER+1
	f3
		icon='icons/katon.dmi'
		icon_state="3"
		density=0
		layer=MOB_LAYER+1
	f4
		icon='icons/katon.dmi'
		icon_state="4"
		density=0
		layer=MOB_LAYER+1
	f5
		icon='icons/katon.dmi'
		icon_state="5"
		density=0
		layer=MOB_LAYER+1
	f6
		icon='icons/katon.dmi'
		icon_state="6"
		density=0
		layer=MOB_LAYER+1
	f7
		icon='icons/katon.dmi'
		icon_state="7"
		density=0
		layer=MOB_LAYER+1
	f8
		icon='icons/katon.dmi'
		icon_state="8"
		density=0
		layer=MOB_LAYER+1
	f9
		icon='icons/katon.dmi'
		icon_state="9"
		density=0
		layer=MOB_LAYER+1
obj/Ash
	dispose()
		loc = null

	f1
		icon='icons/ashfire.dmi'
		icon_state="1"
		density=0
		layer=MOB_LAYER+1
	f2
		icon='icons/ashfire.dmi'
		icon_state="2"
		density=0
		layer=MOB_LAYER+1
	f3
		icon='icons/ashfire.dmi'
		icon_state="3"
		density=0
		layer=MOB_LAYER+1
	f4
		icon='icons/ashfire.dmi'
		icon_state="4"
		density=0
		layer=MOB_LAYER+1
	f5
		icon='icons/ashfire.dmi'
		icon_state="5"
		density=0
		layer=MOB_LAYER+1
	f6
		icon='icons/ashfire.dmi'
		icon_state="6"
		density=0
		layer=MOB_LAYER+1
	f7
		icon='icons/ashfire.dmi'
		icon_state="7"
		density=0
		layer=MOB_LAYER+1
	f8
		icon='icons/ashfire.dmi'
		icon_state="8"
		density=0
		layer=MOB_LAYER+1
	f9
		icon='icons/ashfire.dmi'
		icon_state="9"
		density=0
		layer=MOB_LAYER+1

mob
	var/tmp/fire_counter = 0
	var/tmp/fire_counter_cooldown = 0

	proc/increase_fire_counter(amount)
		set waitfor = 0
		fire_counter += amount
		var/old_amount = fire_counter
		sleep(10)
		if(!src)
			return
		if(fire_counter == old_amount)
			fire_counter = 0

proc/AOEPoison(xx,xy,xz,radius,stamdamage,duration,mob/human/attacker,poi,stun)
	set waitfor = 0
	var/obj/M=new/obj(locate(xx,xy,xz))
	var/i=duration
	while(i>0)
		i-=10
		for(var/mob/human/O in oview(radius,M))
			AOEPoisoned(O, attacker, stamdamage, poi)
		sleep(10)
	//del(M)
	M.loc = null

proc/AOEPoisoned(mob/poisoned, mob/attacker, stamdamage, poison)
	set waitfor = 0
	if(!poisoned)
		return
	if(!poisoned.ko && !poisoned.IsProtected())
		poisoned.Timed_Stun(11)
	//poisoned.Dec_Stam(stamdamage, 0, attacker)
	poisoned.Damage(stamdamage, 0, attacker, "Poison", "Internal")
	// TODO, poison should be its own proc.
	poisoned.Poison += poison
	poisoned.Hostile(attacker)

proc/AOEFire(xx,xy,xz,radius,stamdamage,duration,mob/human/attacker,wo,stun)
	set waitfor = 0
	var/obj/M=new/obj(locate(xx,xy,xz))
	var/i=duration
	while(i>0)
		i-=5
		for(var/mob/human/O in oview(radius,M))
			AOEFireed(O, attacker, stamdamage, wo, stun)
		sleep(5)
	M.loc = null

proc/AOEFireed(mob/hit, mob/attacker, stamdamage, wounds, stun)
	set waitfor = 0
	if((attacker.con + attacker.conbuff - attacker.conneg) >= (hit.str + hit.strbuff - hit.strneg))
		hit.Timed_Move_Stun(15, 3)
	hit.Damage(stamdamage, rand(0, wounds), attacker, "Fire")//hit.Wound(rand(0, wounds), 0, attacker)
	hit.increase_fire_counter(1)
	if(hit.fire_counter >= 3 && hit.fire_counter_cooldown < world.time)
		//explosion(stamdamage * 3, hit.x, hit.y, hit.z, attacker, dist = 3, dontknock=1)
		explosion(stamdamage * 5, 0, hit.loc, attacker, list("distance" = 3, "ignore_owner" = 1))
		hit.Timed_Stun(15)
		hit.movepenalty += 10
		hit.fire_counter = 0
		//hit.fire_counter_cooldown = world.time + 30
	//hit.Dec_Stam(stamdamage,0,attacker)
	hit.Hostile(attacker)

proc/AOE(xx,xy,xz,radius,stamdamage,duration,mob/human/attacker,wo,stun,source)
	set waitfor = 0
	var/obj/M=new/obj(locate(xx,xy,xz))
	var/i=duration
	while(i>0)
		i-=10
		for(var/mob/human/O in oview(radius,M))
			AOEed(O, attacker, stamdamage, wo, stun,source)
		sleep(10)
	M.loc = null

proc/AOEed(mob/hit, mob/attacker, stamdamage, wounds, stun, source)
	set waitfor = 0
	hit.Damage(0, rand(0, wounds), attacker, source)//hit.Wound(rand(0,wounds),0,attacker)
	if(stun)
		stun = stun*10
		if(hit.move_stun<stun)
			hit.Timed_Move_Stun(stun)
	hit.Timed_Stun(10)
	hit.Damage(stamdamage, 0, attacker, source)//hit.Dec_Stam(stamdamage,0,attacker)
	hit.Hostile(attacker)

proc/AOEx(xx,xy,xz,radius,stamdamage,duration,mob/human/attacker,wo,stun,source)
	set waitfor = 0
	var/obj/M=new/obj(locate(xx,xy,xz))
	var/i=duration
	while(i>0)
		i-=10
		for(var/mob/human/O in oview(radius,M))
			if(O!=attacker)
				AOExed(O, attacker, stamdamage, wo, stun,source)
		sleep(10)
	M.loc = null

proc/AOExed(mob/hit, mob/attacker, stamdamage, wounds, stun, source)
	set waitfor = 0
	//hit.Wound(rand(0,wounds),0,attacker)
	if(stun)
		stun = stun*10
		if(hit.move_stun<stun)
			hit.Timed_Move_Stun(stun)
	//hit.Dec_Stam(stamdamage,0,attacker)
	hit.Damage(stamdamage, rand(0, wounds), attacker, source)
	hit.Hostile(attacker)

mob/var/justwalk=0
proc/AOExk(xx,xy,xz,radius,stamdamage,duration,mob/human/attacker,wo,stun,knock)
	set waitfor = 0
	var/obj/M=new/obj(locate(xx,xy,xz))
	var/i=duration
	while(i>0)
		i-=10
		for(var/mob/human/O in oview(radius,M))
			if(O!=attacker)
				AOExked(xx,xy,xz,O,attacker,stamdamage,wo,stun,knock)
		sleep(10)
	del(M)

proc/AOExked(xx,xy,xz,mob/O, mob/attacker, stamdamage, wo, stun, knock, source)
	set waitfor = 0
	if(O && O != attacker)
		O.Damage(stamdamage, rand(0,wo), attacker, source)//O.Wound(rand(0,wo),0,attacker)
		//O.Dec_Stam(stamdamage,0,attacker)
		O.Hostile(attacker)
		if(O && knock)
			var/ns=0
			var/ew=0
			if(O.x>xx)
				ew=1
			if(O.x<xx)
				ew=2
			if(O.y<xy)
				ns=2
			if(O.y>xy)
				ns=1
			if(O&&ns==1 &&ew==0)
				O.Knockback(knock+1,NORTH)
			if(O&&ns==2 &&ew==0)
				O.Knockback(knock+1,SOUTH)
			if(O&&ns==1 &&ew==1)
				O.Knockback(knock+1,NORTHEAST)
			if(O&&ns==1 &&ew==2)
				O.Knockback(knock+1,NORTHWEST)
			if(O&&ns==2 &&ew==1)
				O.Knockback(knock+1,SOUTHEAST)
			if(O&&ns==2 &&ew==2)
				O.Knockback(knock+1,SOUTHWEST)
			if(O&&ns==0 &&ew==1)
				O.Knockback(knock+1,EAST)
			if(O&&ns==0 &&ew==2)
				O.Knockback(knock+1,WEST)
		if(O) O.Timed_Move_Stun(stun)//O.move_stun+=stun*10

proc/AOExk2(xx,xy,xz,radius,stamdamage,duration,mob/human/attacker,wo,stun,knock)
	set waitfor = 0
	var/obj/M=new/obj(locate(xx,xy,xz))
	var/i=duration
	while(i>0)
		i-=10
		for(var/mob/human/O in oview(radius,M))
			AOExked(xx,xy,xz,O,attacker,stamdamage,wo,stun,knock)
		sleep(10)
	//del(M)
	M.loc = null


proc/AOEcc(xx, xy, xz, radius, stamdamage, stamdamage2, duration, mob/human/attacker, wo, stun, knock)
	set waitfor = 0
	var/obj/M = new /obj(locate(xx, xy, xz))
	var/i = duration
	var/list/gotcha[] = list()
	while(i > 0)
		i -= 10
		for(var/mob/human/O in oview(radius, M))
			if(O != attacker)
				AOEcced(gotcha, O, attacker,stamdamage,stamdamage2,wo,stun,knock)
		sleep(10)
	for(var/mob/human/O in oview(radius, M))
		AOExked(xx,xy,xz,O,attacker,stamdamage,wo,stun,knock)
	M.loc = null

proc/AOEcced(list/gotcha, mob/O, mob/attacker, stamdamage,stamdamage2,wo,stun,knock)
	set waitfor = 0
	if(O && O != attacker && !O.IsProtected())
		if(!gotcha.Find(O.realname))
			O.Damage(stamdamage, rand(0,wo), attacker, "Lightning: Chidori Current")//O.Dec_Stam(stamdamage2, 0, attacker)
			//O.Wound(rand(0, wo), 0, attacker)
			gotcha.Add(O.realname)
		else
			O.Damage(stamdamage2, rand(0,wo), attacker, "Lightning: Chidori Current")//O.Dec_Stam(stamdamage2, 0, attacker)
			//O.Wound(rand(0, wo), 0, attacker)
		O.Hostile(attacker)
		if(!O)
			return
		if(!O.ko && O.icon_state != "hurt") O.icon_state = "hurt"
		O.Timed_Stun(15)
		O.Timed_Move_Stun(stun*10)

mob/var/tmp/noknock=0
mob/proc/Knockback(k,xdir)
	set waitfor = 0

	if(!istype(src,/mob/human/npc)&&src.paralysed==0&&/*!src.stunned&&*/!src.ko&&!src.mane&&!noknock)
		if(!src.icon_state)
			src.icon_state="hurt"
		if(!src.cantreact)
			src.timed_reaction_stun(10)
		src.animate_movement=2
		var/i=k
		var/reflected = 0

		while(i>0 &&src)
			src.kstun=2
			var/pass=1
			var/turf/T=get_step(src,xdir)
			for(var/atom/o in get_step(src,xdir))
				if(o)
					if(o.density==1)
						pass=0
			if(!T)
				pass=0
			else
				if(T.density==1)
					pass=0
			if(xdir==NORTH)
				if(pass)
					src.y++
				else if(!reflected)
					i /= 2
					i = round(i,1)
					xdir = pick(SOUTHEAST, SOUTHWEST)
					reflected = 1
					continue
			if(xdir==SOUTH)
				if(pass)
					src.y--
				else if(!reflected)
					i /= 2
					i = round(i,1)
					xdir = pick(NORTHEAST, NORTHWEST)
					reflected = 1
					continue
			if(xdir==EAST)
				if(pass)
					src.x++
				else if(!reflected)
					i /= 2
					i = round(i,1)
					xdir = pick(NORTHWEST, SOUTHWEST)
					reflected = 1
					continue
			if(xdir==WEST)
				if(pass)
					src.x--
				else if(!reflected)
					i /= 2
					i = round(i,1)
					xdir = pick(NORTHEAST, SOUTHEAST)
					reflected = 1
					continue
			if(xdir==NORTHWEST)
				if(pass)
					src.y++
					src.x--
				else if(!reflected)
					i /= 2
					i = round(i,1)
					xdir = pick(EAST, SOUTH)
					reflected = 1
					continue
			if(xdir==NORTHEAST)
				if(pass)
					src.y++
					src.x++
				else if(!reflected)
					i /= 2
					i = round(i,1)
					xdir = pick(WEST, SOUTH)
					reflected = 1
					continue
			if(xdir==SOUTHEAST)
				if(pass)
					src.x++
					src.y--
				else if(!reflected)
					i /= 2
					i = round(i,1)
					xdir = pick(WEST, NORTH)
					reflected = 1
					continue
			if(xdir==SOUTHWEST)
				if(pass)
					src.x--
					src.y--
				else if(!reflected)
					i /= 2
					i = round(i,1)
					xdir = pick(EAST, NORTH)
					reflected = 1
					continue
			sleep(1)
			i--
		src.kstun=0
		if(src)
			src.animate_movement=1
			if(src.icon_state=="hurt")
				src.icon_state=""
proc/WaveDamage(mob/human/u,mag,dam,knockback,xdist,source)
	set waitfor = 0
	var/dir = u.dir
	var/turf/center = u.loc
	var/distance = xdist
	var/list/hit = list()
	for(, center && distance > 0; --distance)
		center = get_step(center, dir)
		if(!center) return
		var/dir1 = turn(dir, 90)
		var/dir2 = turn(dir, -90)
		var/turf/T1 = center
		var/turf/T2 = center
		var/list/effect_turfs = list(center)
		for(var/i = 0, i < mag, ++i)
			T1 = get_step(T1, dir1)
			T2 = get_step(T2, dir2)
			effect_turfs += T1
			effect_turfs += T2

		for(var/turf/T in effect_turfs)
			for(var/mob/human/M in T)
				if(!istype(M, /mob/human/npc) && !(M in hit))
					hit += M
					if(M) M.Knockback(knockback,dir)
					M.Damage(dam, 0, u, source)//M.Dec_Stam(dam,0,u)
					if(M) M.Hostile(u)

		sleep(1)




proc/Electricity(dx,dy,dz,dur)
	set waitfor = 0
	var/obj/elec/o = new/obj/elec(locate(dx,dy,dz))
	var/i = dur
	while(i>0)
		var/r=rand(1,15)
		o.icon_state="[r]"
		sleep(1)
		i--
	o.loc = null

obj
	elec
		icon='icons/electricity.dmi'
		icon_state=""
		density=0


obj
	var
		mob/Causer

proc/Trail_Straight_Projectile(dx,dy,dz,xdir,obj/trailmaker/proj,xdur,mob/maker)
	proj.loc=locate(dx,dy,dz)
	proj.dir=xdir
	var/i = xdur
	var/mob/hit
	while(proj&&i>0 && !hit)
		var/will_hit = 0
		for(var/mob/human/R in get_step(proj,proj.dir))
			if(R)
				will_hit=1
				//R.move_stun+=10
				R.Timed_Move_Stun(10)
		if(proj)
			if(will_hit)
				proj.density = 0
			step(proj,proj.dir)
			if(will_hit)
				proj.density = 1
			for(var/mob/human/F in proj.loc)
				if(F!=maker &&!F.protected &&!F.ko)
					hit=F
					break
			sleep(1)
			i--
	if(hit)
		return hit
	else
		if(proj)
			proj.loc = null
		return 0

mob/human/clay
	var/power=0
	var/mob/owner
	var/tmp/explosionsize = 3
	icon='icons/clay-animals.dmi'
	bird
		icon_state="bird"
	spider
		explosionsize = 5
		icon_state="spider"
		mouse_drag_pointer=MOUSE_HAND_POINTER
		New(location, damage, mob/user,modified)
			set waitfor = 0
			..()
			sleep(10)
			if(user && user.keys && !user.keys["shift"])
				var/mob/target = user.MainTarget()
				if(target) walk_to(src, target, 0, 2)
					//MouseDrop(target,0,target)

		MouseDrop(D,turf/Start,turf/getta)
			if(usr==src.owner)
				if(D)
					walk_to(src,D,0,2)
				else
					walk_to(src,getta,0,2)

		DblClick()
			if(usr==src.owner)
				src.Explode()
				..()

	New(loc,p,mob/u)
		..()
		src.power=p
		src.owner=u

	dispose()
		walk(src, 0)
		owner = null
		loc = null

	proc
		Explode()
			set waitfor = 0
			if(src.icon)
				if(istype(src, /mob/human/clay/bird))
					for(var/mob/m in loc)
						m.Timed_Stun(10)
				src.icon = null
				src.density=0
				//explosion(src.power,src.x,src.y,src.z,src.owner,0,src.explosionsize)
				if(src.owner && src.loc)
					explosion(src.power, 0, src.loc, src.owner, list("distance" = src.explosionsize))
				if(owner && istype(owner,/mob/human/player))
					for(var/obj/trigger/exploding_spider/T in owner.triggers)
						if(T.spider == src) owner.RemoveTrigger(T)
				dispose()

proc/Homing_Projectile_bang(mob/U,mob/human/clay/proj,xdur,mob/human/M,lag)
	set waitfor = 0
	if(M && U && proj)
		proj.dir=U.dir
		var/i = 8
		if(xdur>8)
			i=xdur
		proj.density=0
		var/mob/hit
		while(i>0 && !hit)

			var/DesiredAngle
			if(M&& proj)/*
				var/d1=0
				var/d2=0
				if(M.x>proj.x)
					d1=EAST
				if(M.x<proj.x)
					d1=WEST
				if(M.y>proj.y)
					d2=NORTH
				if(M.y<proj.y)
					d2=SOUTH*/
				DesiredAngle=get_real_angle(proj, M)
				var/angle = DesiredAngle - dir2angle(proj.dir)
				angle = normalize_angle(angle)
				//if(usr) usr << "DesiredAngle: [DesiredAngle], CurrentAngle: [dir2angle(proj.dir)] Angle: [angle], [dir2angle(angle2dir(angle))]"
				proj.dir = turn(proj.dir, dir2angle(angle2dir(angle)))

				for(var/mob/human/R in get_step(proj,proj.dir))
					if(R)
						proj.density=0
						//proj.loc = R.loc
						//R.move_stun+=10
						//R.Timed_Stun(15)
						hit = R
						//	if(proj) proj.density=1
			if(proj)
				walk(proj,proj.dir)
				sleep(1)
				walk(proj,0)
				for(var/mob/human/F in oview(0,proj))
					if(F!=U)
						hit=F
				sleep(1)//+lag
			i--
		if(!proj) return
		if(hit)
			hit.movepenalty += 10
			proj.Explode()
		else
			proj.Explode()

proc/Trail_Homing_Projectile(dx,dy,dz,xdir,obj/trailmaker/proj,xdur,mob/human/M,dontdelete,hitinnocent,modx,mody,lag,mob/U)
	if(M)
		proj.loc=locate(dx,dy,dz)
		proj.dir=xdir
		var/i = xdur
		proj.density=0

		if(modx==-1)
			proj.dir=WEST
			step(proj,proj.dir)
			sleep(1)
			step(proj,proj.dir)
			sleep(1)
		else if(modx==1)
			proj.dir=EAST
			step(proj,proj.dir)
			sleep(1)
			step(proj,proj.dir)
			sleep(1)

		if(mody==-1)
			proj.dir=SOUTH
			step(proj,proj.dir)
			sleep(1)
			step(proj,proj.dir)
			sleep(1)
		else if(mody==1)
			proj.dir=NORTH
			step(proj,proj.dir)
			sleep(1)
			step(proj,proj.dir)
			sleep(1)

		if(modx || mody)
			sleep(2)

		proj.density=1
		var/mob/hit
		while(M && proj && i>0 && !hit)
			proj.dir = angle2dir(get_real_angle(proj, M))

			var/hit_human = 0
			for(var/mob/human/R in get_step(proj,proj.dir))
				if(R)
					hit_human = 1
					//R.move_stun+=10
					R.Timed_Move_Stun(10)

			if(hit_human)
				proj.density=0

			step(proj,proj.dir)

			if(hit_human)
				proj.density=1

			for(var/mob/human/F in proj.loc)
				if(F==M || (hitinnocent && F!=U))
					hit=F
					break

			sleep(1+lag)
			i--

		if(hit)
			return hit
	del(proj)
	return 0

proc
	angle2dir_cardinal(angle)
		angle = normalize_angle(angle)
		switch(angle)
			if(-180 to -135, 135 to 180)
				return WEST
			if(-135 to -45)
				return SOUTH
			if(-45 to 45)
				return EAST
			if(45 to 135)
				return NORTH



atom/movable/proc/CT()
	if(src.dir==NORTH)
		src.dir=NORTHEAST
	else if(src.dir==NORTHEAST)
		src.dir=EAST
	else if(src.dir==EAST)
		src.dir=SOUTHEAST
	else if(src.dir==SOUTHEAST)
		src.dir=SOUTH
	else if(src.dir==SOUTH)
		src.dir=SOUTHWEST
	else if(src.dir==SOUTHWEST)
		src.dir=WEST
	else if(src.dir==WEST)
		src.dir=NORTHWEST
	else if(src.dir==NORTHWEST)
		src.dir=NORTH
atom/movable/proc/CCT()
	if(src.dir==NORTH)
		src.dir=NORTHWEST
	else if(src.dir==NORTHEAST)
		src.dir=NORTH
	else if(src.dir==EAST)
		src.dir=NORTHEAST
	else if(src.dir==SOUTHEAST)
		src.dir=EAST
	else if(src.dir==SOUTH)
		src.dir=SOUTHEAST
	else if(src.dir==SOUTHWEST)
		src.dir=SOUTH
	else if(src.dir==WEST)
		src.dir=SOUTHWEST
	else if(src.dir==NORTHWEST)
		src.dir=WEST
obj
	trail
		watertrail
			layer=MOB_LAYER+2
			icon='icons/watertrail.dmi'
		shadowtrail
			layer=OBJ_LAYER
			icon='icons/shadowbindtrail.dmi'
		shadowtrail2
			layer=OBJ_LAYER
			icon='icons/shadowneedletrail.dmi'
	trailmaker
		layer=MOB_LAYER+1
		density=1
		var
			list/trails=new
			first=0
			trail_target

	/*Del()
			if(loc == null) return ..()

			for(var/obj/trail in trails)
				trail.loc = null

			trails = null
			trail_target = null
			loc = null*/

		Raton_Sword
			icon='icons/ratonsword.dmi'
			Move()
				set waitfor = 0
				var/turf/old_loc = src.loc
				var/d = ..()
				if(d)
					if(first==0)
						first=1
					else
						var/obj/O = new(old_loc)
						O.dir = src.dir
						O.icon = 'icons/ratonsword.dmi'
						O.icon_state="trail"
						src.trails += O
				return d

			Del()
				for(var/obj/o in src.trails)
					o.loc = null
				..()

		Dragon_Fire
			icon='icons/dragonfire.dmi'
			Move()
				set waitfor = 0
				var/turf/old_loc = src.loc
				var/d = ..()
				if(d)
					if(first==0)
						first=1
					else
						var/obj/O = new(old_loc)
						O.dir = src.dir
						O.icon = 'icons/dragonfire.dmi'
						O.icon_state="tail"
						src.trails += O
						O.layer=MOB_LAYER+2
				return d

			Del()
				for(var/obj/o in src.trails)
					o.loc = null
				..()

		Mud_Slide
			icon='icons/earthflow.dmi'
			var/list/gotmob=new
			Move()
				set waitfor = 0
				var/turf/old_loc = src.loc
				var/d = ..()
				if(loc.density)
					loc = old_loc
					walk(src, 0)
				if(d)
					if(length(gotmob))
						for(var/mob/M in gotmob)
							if(get_dist(M,src)<=2)
								var/turf/T=locate(src.x,src.y,src.z)
								if(T&&!T.density)M.loc=locate(T.x,T.y,T.z)
							else
								gotmob-=M

					if(first==0)
						first=1
					else
						var/obj/O = new(old_loc)
						O.dir = src.dir
						O.icon = 'icons/earthflow.dmi'
						O.icon_state="tail"
						src.trails += O
				return d

			Del()
				if(loc == null)
					return ..()
				for(var/obj/o in src.trails)
					o.loc = null
				trails = null
				loc = null

		Shadowneedle
			density=1
			layer=MOB_LAYER
			icon='icons/shadowneedle2.dmi'
			pixel_y=-10
			Move()
				set waitfor = 0
				var/turf/old_loc = src.loc
				var/d = ..()
				if(d)
					var/obj/O = new(old_loc)
					O.dir = src.dir
					var/obj/m=new/obj/trail/shadowtrail2(O)
					m.dir=O.dir
					m.icon_state="patch"
					var/obj/n=new/obj/trail/shadowtrail2(O)
					n.dir=O.dir
					n.icon_state="patch"
					if(O.dir==NORTHEAST)
						src.pixel_y=16
						src.pixel_x=16
						O.pixel_y=16
						O.pixel_x=16
						m.pixel_y=-16
						m.pixel_x=-16
						n.pixel_y=16
						n.pixel_x=16
					if(O.dir==SOUTHEAST)
						src.pixel_y=-16
						src.pixel_x=16
						O.pixel_y=-16
						O.pixel_x=16
						m.pixel_y=16
						m.pixel_x=-16
						n.pixel_y=-16
						n.pixel_x=16
					if(O.dir==NORTHWEST)
						src.pixel_y=16
						src.pixel_x=-16
						O.pixel_y=16
						O.pixel_x=-16
						m.pixel_y=-16
						m.pixel_x=16
						n.pixel_y=16
						n.pixel_x=-16
					if(O.dir==SOUTHWEST)
						src.pixel_y=-16
						src.pixel_x=-16
						O.pixel_y=-16
						O.pixel_x=-16
						m.pixel_y=16
						m.pixel_x=16
						n.pixel_y=-16
						n.pixel_x=-16
					if(O.dir==NORTH)
						src.pixel_y=16
						src.pixel_x=0
						O.pixel_y=16
						m.pixel_y=-16
						n.pixel_y=16

					if(O.dir==SOUTH)
						src.pixel_y=-16
						src.pixel_x=0
						O.pixel_y=-16
						m.pixel_y=16
						n.pixel_y=-16
					if(O.dir==EAST)
						src.pixel_x=16
						src.pixel_y=0
						O.pixel_x=16
						m.pixel_x=-16
						n.pixel_x=16
					if(O.dir==WEST)
						src.pixel_x=-16
						src.pixel_y=0
						O.pixel_x=-16
						m.pixel_x=16
						n.pixel_x=-16
					O.underlays+=m
					O.underlays+=n
					O.icon = 'icons/shadowneedletrail.dmi'
					src.trails += O
				return d

			Del()
				for(var/obj/o in src.trails)
					o.loc = null
				..()

		Shadow
			density=0
			layer=OBJ_LAYER
			icon='icons/shadowbind.dmi'
			pixel_y=-10
			Move()
				set waitfor = 0
				var/turf/old_loc = src.loc
				var/d = ..()
				if(d)
					var/obj/O = new(old_loc)
					O.dir = src.dir
					var/obj/m=new/obj/trail/shadowtrail(O)
					m.dir=O.dir
					m.icon_state="patch"
					var/obj/n=new/obj/trail/shadowtrail(O)
					n.dir=O.dir
					n.icon_state="patch"
					if(O.dir==NORTHEAST)
						src.pixel_y=16
						src.pixel_x=16
						O.pixel_y=16
						O.pixel_x=16
						m.pixel_y=-16
						m.pixel_x=-16
						n.pixel_y=16
						n.pixel_x=16
					if(O.dir==SOUTHEAST)
						src.pixel_y=-16
						src.pixel_x=16
						O.pixel_y=-16
						O.pixel_x=16
						m.pixel_y=16
						m.pixel_x=-16
						n.pixel_y=-16
						n.pixel_x=16
					if(O.dir==NORTHWEST)
						src.pixel_y=16
						src.pixel_x=-16
						O.pixel_y=16
						O.pixel_x=-16
						m.pixel_y=-16
						m.pixel_x=16
						n.pixel_y=16
						n.pixel_x=-16
					if(O.dir==SOUTHWEST)
						src.pixel_y=-16
						src.pixel_x=-16
						O.pixel_y=-16
						O.pixel_x=-16
						m.pixel_y=16
						m.pixel_x=16
						n.pixel_y=-16
						n.pixel_x=-16
					if(O.dir==NORTH)
						src.pixel_y=16
						src.pixel_x=0
						O.pixel_y=16
						m.pixel_y=-16
						n.pixel_y=16

					if(O.dir==SOUTH)
						src.pixel_y=-16
						src.pixel_x=0
						O.pixel_y=-16
						m.pixel_y=16
						n.pixel_y=-16
					if(O.dir==EAST)
						src.pixel_x=16
						src.pixel_y=0
						O.pixel_x=16
						m.pixel_x=-16
						n.pixel_x=16
					if(O.dir==WEST)
						src.pixel_x=-16
						src.pixel_y=0
						O.pixel_x=-16
						m.pixel_x=16
						n.pixel_x=-16
					O.pixel_y-=10
					src.pixel_y-=10
					O.underlays+=m
					O.underlays+=n
					O.icon = 'icons/shadowbindtrail.dmi'
					src.trails += O
				return d

			Del()
				for(var/obj/o in src.trails)
					o.loc = null
				..()

		Water_Dragon
			density=1
			layer=MOB_LAYER+2
			icon='icons/waterdragon.dmi'

			Move()
				var/turf/old_loc = src.loc
				var/d = ..()
				if(d)
					var/obj/O = new(old_loc)
					O.dir = src.dir
					var/obj/m=new/obj/trail/watertrail(O)
					m.dir=O.dir
					m.icon_state="patch"
					var/obj/n=new/obj/trail/watertrail(O)
					n.dir=O.dir
					n.icon_state="patch"
					if(O.dir==NORTHEAST)
						src.pixel_y=16
						src.pixel_x=16
						O.pixel_y=16
						O.pixel_x=16
						m.pixel_y=-16
						m.pixel_x=-16
						n.pixel_y=16
						n.pixel_x=16
					if(O.dir==SOUTHEAST)
						src.pixel_y=-16
						src.pixel_x=16
						O.pixel_y=-16
						O.pixel_x=16
						m.pixel_y=16
						m.pixel_x=-16
						n.pixel_y=-16
						n.pixel_x=16
					if(O.dir==NORTHWEST)
						src.pixel_y=16
						src.pixel_x=-16
						O.pixel_y=16
						O.pixel_x=-16
						m.pixel_y=-16
						m.pixel_x=16
						n.pixel_y=16
						n.pixel_x=-16
					if(O.dir==SOUTHWEST)
						src.pixel_y=-16
						src.pixel_x=-16
						O.pixel_y=-16
						O.pixel_x=-16
						m.pixel_y=16
						m.pixel_x=16
						n.pixel_y=-16
						n.pixel_x=-16
					if(O.dir==NORTH)
						src.pixel_y=16
						src.pixel_x=0
						O.pixel_y=16
						m.pixel_y=-16
						n.pixel_y=16

					if(O.dir==SOUTH)
						src.pixel_y=-16
						src.pixel_x=0
						O.pixel_y=-16
						m.pixel_y=16
						n.pixel_y=-16
					if(O.dir==EAST)
						src.pixel_x=16
						src.pixel_y=0
						O.pixel_x=16
						m.pixel_x=-16
						n.pixel_x=16
					if(O.dir==WEST)
						src.pixel_x=-16
						src.pixel_y=0
						O.pixel_x=-16
						m.pixel_x=16
						n.pixel_x=-16
					O.underlays+=m
					O.underlays+=n
					O.icon = 'icons/watertrail.dmi'
					src.trails += O
				return d

			Del()
				for(var/obj/o in src.trails)
					o.loc = null
				..()

obj
	kbl
		icon='icons/kaiten.dmi'
		layer=MOB_LAYER+2
		density=0
		icon_state="bl"
		pixel_x=-16
		pixel_y=-12
	kbr
		icon='icons/kaiten.dmi'
		layer=MOB_LAYER+2
		density=0
		icon_state="br"
		pixel_x=16
		pixel_y=-12
	ktl
		icon='icons/kaiten.dmi'
		layer=MOB_LAYER+2
		density=0
		icon_state="tl"
		pixel_y=20
		pixel_x=-16
	ktr
		icon='icons/kaiten.dmi'
		layer=MOB_LAYER+2
		density=0
		icon_state="tr"
		pixel_y=20
		pixel_x=16

proc/Hakke_Circle(mob/u,mob/t)
	set waitfor = 0
	var/list/listx=new
	listx.Add(image('icons/hakke64.dmi',locate(u.x,u.y,u.z),icon_state="1,1",layer=TURF_LAYER+1),
	image('icons/hakke64.dmi',locate(u.x,u.y+1,u.z),icon_state="1,2",layer=TURF_LAYER+1),
	image('icons/hakke64.dmi',locate(u.x,u.y-1,u.z),icon_state="1,0",layer=TURF_LAYER+1),
	image('icons/hakke64.dmi',locate(u.x-1,u.y+1,u.z),icon_state="0,2",layer=TURF_LAYER+1),
	image('icons/hakke64.dmi',locate(u.x-1,u.y-1,u.z),icon_state="0,0",layer=TURF_LAYER+1),
	image('icons/hakke64.dmi',locate(u.x-1,u.y,u.z),icon_state="0,1",layer=TURF_LAYER+1),
	image('icons/hakke64.dmi',locate(u.x+1,u.y+1,u.z),icon_state="2,2",layer=TURF_LAYER+1),
	image('icons/hakke64.dmi',locate(u.x+1,u.y-1,u.z),icon_state="2,0",layer=TURF_LAYER+1),
	image('icons/hakke64.dmi',locate(u.x+1,u.y,u.z),icon_state="2,1",layer=TURF_LAYER+1))
	for(var/image/i in listx)
		u<<i
		if(t)
			t<<i

	sleep(100)
	for(var/image/x in listx)
		del(x)
	listx = null

mob
	proc/hakke_animation(iterations)
		set waitfor = 0
		if(!src)
			return
		for(, iterations > 0, iterations--)
			flick("PunchA-1",src)
			sleep(1)
			flick("PunchA-2",src)

mob/proc/Hakke_Pwn(mob/e)
	if(!stunned && e)
		viewers(src) << output("[src]: Eight Trigrams: 64 Palms!", "combat_output")
		//src.stunned+=10
		Begin_Stun()
		e.Begin_Stun()
		//e.stunned+=10
		//src.Facedir(e)
		src.overlays+='icons/hakkehand.dmi'
		e.combat("[src]: Two")
		src.combat("[src]: Two")
		hakke_animation(1)
		if(e) e.Chakrahit()
		sleep(6)
		if(!e || !src) return
		e.combat("[src]: Four")
		src.combat("[src]: Four")
		hakke_animation(2)
		if(e) e.Chakrahit()
		sleep(6)
		if(!e || !src) return
		e.combat("[src]: Eight")
		src.combat("[src]: Eight")
		hakke_animation(2)
		if(e) e.Chakrahit()
		sleep(6)
		if(!e || !src) return
		e.combat("[src]: Sixteen")
		src.combat("[src]: Sixteen")
		hakke_animation(4)
		if(e) e.Chakrahit()
		if(e) e.Chakrahit()
		sleep(6)
		if(!e || !src) return
		e.combat("[src]: Thirty-two")
		src.combat("[src]: Thirty-two")
		hakke_animation(8)
		if(e) e.Chakrahit()
		if(e) e.Chakrahit()
		if(e) e.Chakrahit()

		sleep(6)
		if(!e || !src) return
		e.combat("[src]: Sixty Four!")
		src.combat("[src]: Sixty Four!")
		hakke_animation(16)
		if(e) e.Chakrahit()
		if(e) e.Chakrahit()
		if(e) e.Chakrahit()
		if(e) e.Chakrahit()
		//e.stunned=0
		e.End_Stun()
		e.Knockback(3,src.dir)
		e.curchakra = 0
		var/chakrablock_effect = 60 * (1 + 0.1 * e.c)
		e.chakrablocked += chakrablock_effect
		var/damage = (3000 + src.ControlDamageMultiplier() * 500) + (con + conbuff - conneg) * e.c
		e.Damage(damage, 0, src, "64 Palms")//etarget.Dec_Stam(3000+user.ControlDamageMultiplier()*500,0,user)
		e.Hostile(src)
		src.overlays -= 'icons/hakkehand.dmi'
		src.End_Stun()

mob/proc/Chakrahit()
	set waitfor = 0
	var/obj/o=new/obj/effect(locate(src.x,src.y,src.z))
	o.icon='icons/chakrahit.dmi'
	var/r=rand(1,4)
	flick("[r]",o)
	sleep(20)
	//del(o)
	o.loc = null

mob/proc/Chakrahit2()
	set waitfor = 0
	var/obj/o=new/obj/effect(locate(src.x,src.y,src.z))
	o.icon='icons/chakrahit.dmi'
	var/r=rand(1,4)
	flick("[r]",o)
	sleep(4)
	//del(o)
	o.loc = null

mob/proc/Chakrahit3()
	set waitfor = 0
	var/obj/o=new/obj/effect(locate(src.x,src.y,src.z))
	o.icon='icons/chakrahit2.dmi'
	var/r=rand(1,4)
	flick("[r]",o)
	sleep(4)
	//del(o)
	o.loc = null

obj
	explosion
		layer=MOB_LAYER+1
		tr
			icon='icons/expltr.dmi'
			pixel_x=16
			pixel_y=16
		tl
			icon='icons/expltl.dmi'
			pixel_x=-16
			pixel_y=16
		br
			icon='icons/explbr.dmi'
			pixel_x=16
			pixel_y=-16
		bl
			icon='icons/explbl.dmi'
			pixel_x=-16
			pixel_y=-16
/*proc
	explosion(power,dx,dy,dz,mob/u,dontknock,dist)
		set waitfor = 0
		var/d=4
		if(dist)d=dist
		if(u && u.skillspassive[TRAP_MASTERY])
			power *= 1+ 0.02 * u.skillspassive[TRAP_MASTERY]
		new/obj/Explosion(locate(dx,dy,dz),u,power,d,0,0,dontknock)*/

proc
	explosion_spread(power,dx,dy,dz,mob/u,dontknock)
		//explosion(power,dx,dy,dz,u,0,6)
		var/explosion_location = locate(dx, dy, dz)
		if(!explosion_location || !u)
			return
		explosion((dontknock) ? 0 : power, 0, explosion_location, u, list("distance" = 6))

mob/proc/Tag_Interact(obj/explosive_tag/U)
	switch(input(usr,"What do you want to do to this Explosive Tag", "Trap",) in list("Disarm","Set Trap","Hide","Nothing"))
		if("Set Trap")
			if(U)U.icon_state="blank"
			var/obj/o=new/obj/trip(usr.loc)
			o.owner = usr
			if(o)o.dir=usr.dir

		if("Disarm")
			//src.stunned+=1
			Timed_Stun(10)
			sleep(10)
			if(U)
				if(U.owner && istype(U.owner, /mob/human/player))
					for(var/obj/trigger/explosive_tag/T in U.owner:triggers)
						if(T.ex_tag == U)
							U.owner:RemoveTrigger(T)
				del(U)
				src.combat("Disarmed the Explosive Note!")
		if("Hide")
			//src.stunned+=1
			Timed_Stun(10)
			sleep(10)
			if(U)
				U.icon_state="blank"

obj
	wind_bullet
		New()
			src.overlays+=image('icons/windbullet.dmi',icon_state = "dl",pixel_x=-16,pixel_y=-16)
			src.overlays+=image('icons/windbullet.dmi',icon_state = "dr",pixel_x=16,pixel_y=-16)
			src.overlays+=image('icons/windbullet.dmi',icon_state = "ul",pixel_x=-16,pixel_y=16)
			src.overlays+=image('icons/windbullet.dmi',icon_state = "ur",pixel_x=16,pixel_y=16)