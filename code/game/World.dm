var
	//PASS="EOA8?rVD7yp-O%`Js:R+_qd1Ms9%P%x4QBl"
	server_password
	SkipCount = 10
	Lcount = 0
	voteclear = 10
	list
		DeathList// = new/list
		tolog// = new()

world
	mob=/mob/charactermenu
	view = "19x19"//8
	turf=/turf/denseempty
	name = "Naruto GOA"
	status = "{Public Server}"
	hub = "Masterdan.NarutoGOA"
	//hub_password = "ClvGEtZGCD6z0zp0"
	//tick_lag = 1
	loop_checks = 1
	//fps = 20
	//map_format = TOPDOWN_MAP

#if DM_VERSION >= 455
	//map_format = TOPDOWN_MAP
	map_format = TILED_ICON_MAP
	icon_size = 32
#endif


world/New()
	..()
	server_ticker()

proc/server_ticker()
	set waitfor = 0
	set background = 1
	while(world)
		var/time = world.timeofday
		var/hour = time2text(time, "hh")
		var/minute = time2text(time, "mm")
		if((hour == "11" || hour == "23") && minute == "55")
			world << "<span class = 'serverimportant'>The Official Servers are rebooting in <em>5</em> minutes!"
			clear_kill_log()
			world.WorldSave()
			sleep(3000)
			world << "<span class = 'serverimportant'>The Official Servers are rebooting!"
			world.Reboot(1)
		sleep(600)

mob/Admin/verb/saveall()
	world.WorldSave()
	online_admins << "World saved."

world
	proc
		WorldSave()
			set background = 1
			set waitfor = 0
			var/list/O = new
			for(var/mob/human/player/X in world)
				if(X.client)
					O+=X
			for(var/mob/M in O)
				if(M.client)
					M.client.SaveMob()
					sleep(100)
					sleep(-1)
			sleep(100)
			WorldSave()

		WSave()
			for(var/mob/human/player/O in world)
				if(O.client && O.initialized)
					spawn()world.SaveMob(O,O.client)

		WorldLoop_Status()
			set background = 1
			set waitfor = 0
			bingosort()
			sleep(3000)
			var/c = 0
			for(var/mob/human/player/X in world)
				if(X.client)
					c++
				if(X.ckey in admins)
					X << "World status changed"
			world.status = "{[sname]}([c]/[maxplayers])"

			wcount=c
			sleep(500)
			WorldLoop_Status()

		/*Worldloop_VoteClear()
			set background = 1 //infinite loops do well to be set as not high priority
			set waitfor = 0
			spawn()
				if(voteclear)
					voteclear--
					if(voteclear <= 0)
						Mute_Elects = new/list()
						voteclear = 10

				sleep(600)
				spawn() Worldloop_VoteClear()*/


		NameCheck(xname)
			return SendInterserverMessage("check_name", list("name" = xname))

	New()
		set waitfor = 0
		..()
		sleep(20)
		for(var/mob/human/player/npc/X in world)
			if(X.questable && !X.onquest&&X.difficulty!="A")
				switch(X.locationdisc)
					if("Kawa no Kuni")
						Town_Kawa+=X
					if("Cha no Kuni")
						Town_Cha+=X
					if("Ishi no Kuni")
						Town_Ishi+=X
					if("Konoha")
						Town_Konoha+=X
					if("Suna")
						Town_Suna+=X
					if("Kiri")
						Town_Mist+=X

		WorldLoop_Status()
		//Worldloop_VoteClear()

mob
	MasterAdmin/verb
		Ban(mob/M in All_Clients())
			set category = "Bans"
			if(M.client)
				SendInterserverMessage("add_ban", list("key" = M.ckey, "computer_id" = M.client.computer_id))
				src << "Banned [M] ([M.key], [M.client.computer_id])"
				del(M.client)

		Unban_Key(key as text)
			set category = "Bans"
			SendInterserverMessage("remove_ban", list("key" = ckey(key)))
			src << "Unbanned [key]"

		Unban_Computer(computer_id as text)
			set category = "Bans"
			SendInterserverMessage("remove_ban", list("computer_id" = computer_id))
			src << "Unbanned [computer_id]"

		Unban(key as text, computer_id as text)
			set category = "Bans"
			SendInterserverMessage("remove_ban", list("key" = ckey(key), "computer_id" = computer_id))
			src << "Unbanned [key], [computer_id]"

		Ban_Key(key as text)
			set category = "Bans"
			SendInterserverMessage("add_ban", list("key" = ckey(key)))
			src << "Banned [key]"

		Ban_Computer(computer_id as text)
			set category = "Bans"
			SendInterserverMessage("add_ban", list("computer_id" = computer_id))
			src << "Banned [computer_id]"

		Ban_Manual(key as text, computer_id as text)
			set category = "Bans"
			SendInterserverMessage("add_ban", list("key" = ckey(key), "computer_id" = computer_id))
			src << "Banned [key], [computer_id]"

		Give_Money(mob/M in All_Clients(), x as num)
			M.money+=x

		Set_Tick_Lag(x as num)
			if(x<1)
				x=1
			if(x>3)
				x=3
			world.tick_lag=x
			usr<<"world tick_lag=[world.tick_lag]"

		LOCATE(ex as num, ey as num, ez as num)
			usr.loc=locate(ex,ey,ez)

	Admin/verb
		Rename(mob/human/x in All_Clients())
			set category = "Registry"
			if(x.client)
				var/newname=input(usr,"Change His/Her name to what?") as text
				if(!newname || !length(newname))return

				if(!saves.IsNameUsed(newname))
					saves.RenameCharacter(x.name, newname, x.key)

					x.name=newname
					x.realname=newname

					x.client.SaveMob()
				else
					src << "That name is taken, cannot rename."
