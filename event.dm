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