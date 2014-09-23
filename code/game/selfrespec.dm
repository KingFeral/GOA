client
	verb/respec()
		if(mob.realname in respecers)
			mob << "You've already respeced this reboot."
			return 0
		if(mob && mob.skills.len) //skills.len check is to make sure they have a character loaded.. seems odd but it's one of the simpler ways I can think of
			//if(mob.realname in respecers)
			//	usr << "You have already used your respec for this reboot cycle"
			//	return 0
			for(var/skill/sk in mob.skills)
				for(var/skillcard/sc in sk.skillcards) del(sc);del(sk)
			saves.ClearSkills(ckey)

			for(var/i=1, i<=mob.skillspassive.len, i++)			mob.skillspassive[i]=0
			for(var/obj/gui/passives/Q in world)	mob.client.Passive_Refresh(Q);mob.elements = list()

			if(!mob.HasSkill(KAWARIMI))			mob.AddSkill(KAWARIMI)
			if(!mob.HasSkill(SHUNSHIN))			mob.AddSkill(SHUNSHIN)
			if(!mob.HasSkill(BUNSHIN))			mob.AddSkill(BUNSHIN)
			if(!mob.HasSkill(HENGE))			mob.AddSkill(HENGE)
			if(!mob.HasSkill(EXPLODING_NOTE))	mob.AddSkill(EXPLODING_NOTE)
			mob:AddSkill(WINDMILL_SHURIKEN)

			mob.str = 50
			mob.con = 50
			mob.rfx = 50
			mob.int = 50
			mob.skillpoints = 0
			mob.levelpoints = mob.blevel*6

			//mob.RecalculateStats()
			mob.RefreshSkillList()
			mob << "<font color=#800080>Your character has been respec'd."
			respecers.Add(mob.realname)