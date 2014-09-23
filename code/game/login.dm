client/New()
	..()
	/*if(RP&&DeathList.Find(src.computer_id))
		src.mob=new/mob/spectator(null)
		return
	if(IsByondMember())
		src<<"Thank you for supporting BYOND by purchasing a membership. For being a member you will have exclusive access to the member only store which is shown on the Map as a gold BYOND logo.\n"
	else
		src<<"Please consider buying a BYOND membership, BYOND members have exclusive access to the BYOND MEMBER store which is denoted as a gold BYOND logo on the map. <b><u>Sign up <a href=\"https://secure.byond.com/members/?command=member_payment&hub_refer=14c825468d74de50\">here </a></b></u>\n"
	*/
	src << "Welcome to the Official GOA server!"
	src << "Join our community <a href='http://w11.zetaboards.com/NarutoGOA/index/'>forum</a>."
	src << "<big>Report bugs <a href = 'http://w11.zetaboards.com/NarutoGOA/forum/4128329/'>here</a>"
	Refresh_Bounties()
	CountPlayers()

world/IsBanned(key, addr, computer_id)
	if(ckey(key) in admins)
		return ..()

	/*if(copytext(key, 1, 6) == "Guest")
		return list("desc" = "Guest keys are disabled. Please create a key at https://secure.byond.com/?page=Join", "address" = addr)

		*/
	//if(SendInterserverMessage("is_banned", list("key" = ckey(key), "computer_id" = computer_id)))
	//	return list("desc" = "Game-wide banned.", "address" = addr)
	var/count=0
	for(var/client/C)
		if(block_alts && C.computer_id == computer_id && C.key != key)
			return list("desc" = "Multiple connections from a single computer are blocked on this server", "address" = addr)
		++count
	wcount=count
	if(wcount>maxplayers)
#if DM_VERSION >= 432
		world.game_state = 1
#endif
		return list("desc" = "Max player limit reached [wcount]/[maxplayers]", "address" = addr)
	else
		return ..()

client/Del()
	CountPlayers(1)
	if(!RP)
		var/mob/vrc=mob
		for(var/mob/charactermenu/x in world)
			if(!x.client)
				del(x)
		if(vrc)
			if(vrc.ko && !vrc.dojo && vrc.pk)
				vrc.FU=1
		world.SaveMob(mob,src, ckey)
		..()

	else
		var/mob/M = mob
		if(M)
			M.Store_RP()
	..()

mob/proc
	Store_RP()
		sleep(100)
		if(!src.client)
			if(src.curwound<src.maxwound)
				src.cache_loc=src.loc
				src.loc=locate(29,93,2)
mob/var/turf/cache_loc

/*world/proc/Cleanup(mob/vrc)
	var/obj/mapinfo/Minfo = locate("__mapinfo__[vrc.z]")
	if(Minfo)
		Minfo.PlayerLeft(vrc)
	vrc.invisibility=0
	vrc.loc=locate(0,0,0)
	vrc.MissionFail()
	sleep(30)
	del(vrc)
	online_admins << "[vrc] Logged Out and was cleaned."
	return ..()*/

proc/CountPlayers(mode=0)
	var/count=0
	for(var/client/C)
		++count
	if(mode) --count
	wcount = count
	if(wcount>maxplayers)
		world.game_state = 1
	else
		world.game_state = 0

mob/human/player
	Logout()
		online_admins << "[src.realname] has logged out."

		if(online_admins.Find(src))
			online_admins -= src

		if(!RP)
			/*tolog+=src.key
			if(tolog.len>5)
				tolog-=tolog[1]*/
			src.key=0

			src.MissionFail()
			src.density=0

			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo)
				Minfo.PlayerLeft(src)
				if(Minfo.in_war && faction)
					if(faction.village == Minfo.village_control)
						++Minfo.defender_deaths
					else if(faction.village == Minfo.attacking_village)
						++Minfo.attacker_deaths

			src.icon=null
			src.overlays=null
			src.loc=null
			if(map_pin)map_pin.loc = null
			if(map_pin_target)map_pin_target = null
			if(map_pin_self)map_pin_self = null
			if(map_pin_squad)map_pin_squad = null
			/*del map_pin
			del map_pin_target
			del map_pin_self
			del map_pin_squad*/
			sleep(50)
			del(src)
