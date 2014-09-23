#define islist(l) istype(l, /list)

Event
	var/procname
	var/arguments[]

	New(ticks, procname, arguments[])
		if(!procname)
			del(src)
			return
		src.procname = procname
		if(arguments)
			src.arguments = arguments
		global.scheduler.schedule(src, ticks)

	proc/fire()
		if(hascall(event_handler, "[procname]"))
			call(event_handler, "[procname]")(arglist(arguments))

var/global/event_handler/event_handler = new

event_handler
	proc/entered_sand_turf(mob/who, turf/Terrain/Sand/sand)
		set waitfor = 0
		if(istype(who,/mob/human) && who:client && !sand.show_enter_track)
			sand.show_enter_track = 1
			if(who:runlevel<4)
				sand.enter_tracks.dir = who.dir
				sand.overlays+=sand.enter_tracks
				//spawn(200)
				sleep(200)
				sand.overlays-=sand.enter_tracks
				sand.show_enter_track = 0
			else
				sand.enter_runtracks.dir = who.dir
				sand.overlays+=sand.enter_runtracks
				//spawn(200)
				sleep(200)
				sand.overlays-=sand.enter_runtracks
				sand.show_enter_track = 0

	proc/exited_sand_turf(mob/who, turf/Terrain/Sand/sand)
		set waitfor = 0
		if(istype(who,/mob/human) && who:client && !sand.show_exit_track)
			sand.show_exit_track = 1
			if(who:runlevel<4)
				sand.exit_tracks.dir = who.dir
				sand.overlays+=sand.exit_tracks
				//spawn(200)
				sleep(200)
				sand.overlays-=sand.exit_tracks
				sand.show_exit_track = 0
			else
				sand.exit_runtracks.dir = who.dir
				sand.overlays+=sand.exit_runtracks
				//spawn(200)
				sleep(200)
				sand.overlays-=sand.exit_runtracks
				sand.show_exit_track = 0

	proc/rock_shinobi_ambush(mob/target)
		set waitfor = 0
		if(!target)
			return
		var/squadsize=min(50 - rockshinobis, pick(1,2,3,4))
		squadsize=min(squadsize,target.afteryou)
		target.afteryou_cool=world.time + 3000
		//rockshinobis += squadsize
		if(!target)
			return
		rockshinobis += squadsize
		var/lvl=1
		switch(target.MissionClass)
			if("D")
				lvl=limit(1,round(target.blevel * rand(0.4,1)),30)
			if("C")
				lvl=limit(1,round(target.blevel * rand(0.7,1.1)),60)
			if("B")
				lvl=limit(1,round(target.blevel * rand(0.8,1.2)),60)
			if("A")
				lvl=limit(1,round(target.blevel * rand(0.9,1.3)),81)
			if("S")
				lvl=limit(1,round(target.blevel * rand(1,1.3)),100)

		Ambush(target,lvl,squadsize)

	proc/reset_ambush_time(mob/ambushed)
		set waitfor = 0
		if(ambushed)
			ambushed.afteryou_cool = 0

	proc/move_delay(mob/moving)
		set waitfor = 0
		if(!moving)
			return
		moving.canmove = 0
		sleep(1)
		if(moving) moving.canmove = 1

	proc/decrease_running_speed(mob/moving)
		set waitfor = 0
		if(!moving)
			return
		moving.runlevel--
		if(moving.icon_state == "Run" && moving.runlevel < 3)
			moving.icon_state = ""
		if(moving.runlevel > 4 && !moving.Size)
			if(!moving.icon_state && !moving.rasengan && !moving.larch)
				moving.icon_state = "Run"
		else
			if(moving.icon_state == "Run")
				moving.icon_state = ""

	proc/clone_dissipate(mob/human/player/npc/kage_bunshin/clone)
		set waitfor = 0
		if(!clone)
			return
		var/dx=clone.x
		var/dy=clone.y
		var/dz=clone.z
		if(!clone:exploading)
			Poof(clone.loc)//(dx,dy,dz)
		else
			clone:exploading=0
			explosion(rand(1000,2500),dx,dy,dz,clone)
			clone.icon=0
			clone.targetable=0
			clone.invisibility=100
			clone.density=0
			sleep(5)
		clone:dead=1
		clone.Begin_Stun()
		clone.loc=locate(0,0,0)
		for(var/mob/human/player/p in players)
			if(p.key == clone:ownerkey)
				p.controlmob=0
				p.client.eye=p.client.mob
		clone.invisibility=100
		clone.target=-15
		clone.targetable=0
		clone.density=0
		clone.targetable=0
		sleep(100)
		clone.loc = null

	proc/fire_dragon_end(mob/user, mob/hit, image/overlay)
		set waitfor = 0
		if(user)
			user.overlays -= overlay
			user.End_Stun()
		if(hit)
			hit.Reset_Move_Stun()

	proc/delayed_delete()
		set waitfor = 0
		if(!args || !args.len)
			return
		for(var/a in args)
			if(islist(a))
				for(var/b in a)
					del(b)
			else
				del(a)

	proc/remove_overlays(atom/a)
		set waitfor = 0
		if(!args || !a || args.len < 2)
			return

		if(islist(a))
			for(var/atom/m in a)
				for(var/i in 2 to args.len)
					m.overlays -= args[i]
		else
			for(var/i in 2 to args.len)
				a.overlays -= args[i]


	proc/delayed_explosion(damage, x, y, z, mob/user, dontknock, distance)
		set waitfor = 0
		explosion(damage, x, y, z, user, dontknock, distance)

	proc/trigger_AI_Attack(mob/human/player/npc/kage_bunshin/X, mob/etarget)
		set waitfor = 0
		if(!X || !etarget)
			return
		X.AI_Target(etarget)
		if(prob(50) && !(X.skillusecool || X.rasengan || X.sakpunch2))
			if(!(X.AppearBehind(etarget)))
				X.AI_Attack(etarget)
		else
			X.AI_Attack(etarget)

	proc/save_loop(client/client)
		set waitfor = 0
		if(client)
			client.Saveloop()

	proc/refresh_item_count(obj/items/o, mob/m)
		set waitfor = 0
		if(o && m)
			o:Refreshcountdd(m)