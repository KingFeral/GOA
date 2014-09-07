var/global/list
	developers = list("fki","tobirachi")
	online_developers = list()

mob
	// verbs.
	developer
		verb/setlevel(var/mob/m in players, var/level as num)
			set waitfor = 0
			while(m.level < level)
				sleep(3)
				m.add_experience(m.body_level_tnl)

		verb/variableanalysis()
		verb/edit()
		verb/manualedit()

	Login()
		..()
		if(src.ckey in global.developers)
			src.verbs += typesof(/mob/developer/verb)
			online_developers += src