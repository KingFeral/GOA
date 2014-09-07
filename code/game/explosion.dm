mob
	var
		motion=0

obj
	Explosion
		icon='icons/explosion2.dmi'
		density=1
		layer=MOB_LAYER+1
		New(loc,mob/e,dam,dist,xoff,yoff,dontknock)
			..()
			if(xoff)src.pixel_x=xoff
			if(yoff)src.pixel_y=yoff
			src.icon_state="center"
			spawn(2)
				src.density=0
				var/list/ldirs=list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST)
				for(var/D in ldirs)
					spawn()new/obj/Push_Wave(src.loc,e,D,dam,dist,xoff,yoff,dontknock)
				sleep(2)
				del(src)
	Push_Wave
		icon='icons/explosion2.dmi'
		density=0
		layer=MOB_LAYER+1
		var
			exempt
			list/owned=new
			pow=0

			moves=0
		New(loc,mob/e,xdir,dam,dist,xoff,yoff,dontknock)
			..()
			spawn(100)
				if(src)
					del(src)
			if(!dontknock)
				push=1
			src.pow=dam
			if(xoff)src.pixel_x=xoff
			if(yoff)src.pixel_y=yoff
			if(e)src.owner=e
			src.dir=xdir
			if(dist>=3)src.icon_state="1"
			else if(dist>=2)src.icon_state="2"
			else src.icon_state="3"
			src.moves=dist
			spawn(1)walk(src,src.dir,2)



		Move(new_loc, dir=0)
			if(src.push)
				for(var/mob/human/X in oview(1,src))
					spawn()
						if(X!=src.exempt)
							if(!X.motion)
								X.motion=1
								owned+=X
								X.icon_state="hurt"
								spawn()
									if(X)
										X.Dec_Stam(src.pow,0,src.owner,1)
										X.Hostile(src.owner)

						if(X)X.animate_movement=2
						spawn(5)
							if(X&&!X.motion && X.animate_movement==2)
								X.animate_movement=1
						if(X)
							var/s=step(X,src.dir)
							if(!s)del(src)
			if(src.moves>=3)src.icon_state="1"
			else if(src.moves>=2)src.icon_state="2"
			else src.icon_state="3"
			src.moves--
			if(src.moves<=0)
				src.icon=0
				sleep(2)
				del(src)

			. = ..()
			if(!(. && new_loc))	// Movement failed or hit edge of map
				del src

		Del()
			src.loc=null
			sleep(10)
			for(var/mob/X in src.owned)
				X.motion=0
				if(X.icon_state=="hurt")
					X.icon_state=""
				src.owned-=X
			..()

