respecverbs/respecverb
	verb/respec()
		if(!istype(src, /mob/human) || !usr.initialized)
			return
		if(usr.respeced)
			usr << "You've already used your respec."
			usr.verbs -= /respecverbs/respecverb/verb/respec
			if(winexists(usr, "respecid"))
				winset(usr, "respecid", "parent=")
			return 0
		if(usr && usr.skills.len) //skills.len check is to make sure they have a character loaded.. seems odd but it's one of the simpler ways I can think of
			//if(mob.realname in respecers)
			//	usr << "You have already used your respec for this reboot cycle"
			//	return 0
			for(var/skill/sk in usr.skills)
				for(var/skillcard/sc in sk.skillcards) del(sc);del(sk)
			saves.ClearSkills(usr.ckey)

			for(var/i=1, i<=usr.skillspassive.len, i++)			usr.skillspassive[i]=0
			for(var/obj/gui/passives/Q in world)	usr.client.Passive_Refresh(Q);usr.elements = list()

			if(!usr.HasSkill(KAWARIMI))			usr.AddSkill(KAWARIMI)
			if(!usr.HasSkill(SHUNSHIN))			usr.AddSkill(SHUNSHIN)
			if(!usr.HasSkill(BUNSHIN))			usr.AddSkill(BUNSHIN)
			if(!usr.HasSkill(HENGE))			usr.AddSkill(HENGE)
			if(!usr.HasSkill(EXPLODING_NOTE))	usr.AddSkill(EXPLODING_NOTE)
			usr:AddSkill(WINDMILL_SHURIKEN)

			usr.str = 50
			usr.con = 50
			usr.rfx = 50
			usr.int = 50
			usr.skillpoints = 0
			usr.levelpoints = usr.blevel*6

			//mob.RecalculateStats()
			usr.RefreshSkillList()
			usr << "<strong>Your character has been respec'd."
			usr.respeced=1
			usr.verbs -= /respecverbs/respecverb/verb/respec
			winset(usr, "respecid", "parent=")
			usr.client.SaveMob()

mob
	var/respeced=1