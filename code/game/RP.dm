var/RP=0
mob/var/list/carrying=new
proc
	RPMode()
		for(var/turf/warp/EpicWarp/W in world)
			if(W.RPdis)
				del(W)

		for(var/mob/human/player/npc/X in world)
			if(X.nisguard)
				del(X)
		for(var/area/nopkzone/W in world)
			var/turf/T=W.loc
			del(W)
			new/area/pkzone(locate(T))
mob
	spectator
		density=0
		New()
			..()
			src<<"You've been logged on as a spectator, this means you have died this round on your current IP Address"
mob/corpse
	layer=MOB_LAYER-0.1
	density=0
	var/carryingme=0
	New(loc,mob/M)
		..()
		src.icon=M.icon
		src.overlays+=M.overlays
		src.name="[M.name]'s Corpse"
		src.icon_state="Dead"
		src.dir=M.dir
		src.blevel=M.blevel
		new/Event(3000, "delayed_delete", list(src))

	Del()
		if(loc == null)
			return ..()
		if(carryingme)
			carryingme:carrying -= src
		carryingme = null
		loc = null
		//if(RP)
		//	M.invisibility=100
		//	M.density=0
		//	M.stunned=9999999
	Click()
		if(carryingme)
			var/mob/human/X = carryingme
			X.carrying-=src
			carryingme=0

		else
			usr.carrying+=src
			carryingme=usr
			usr<<"You start carrying [src]"
