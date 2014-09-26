client/var/list/passive_imgs=new/list()
client/var/list/_passive_cache=new/list()
client/proc/Passive_Refresh(var/obj/gui/passives/Of)
	_passive_cache.len = mob.skillspassive.len
	passive_imgs.len = mob.skillspassive.len
	var/lvln=mob.skillspassive[Of.pindex]
	if(!lvln || lvln < 0)
		lvln = 0
	if(_passive_cache[Of.pindex] == lvln)
		return

	for(var/image/I in passive_imgs[Of.pindex])
		images -= I

	var/lvl="[lvln]"

	if(length(lvl)<=1)
		var/image/I=Of.digit1[lvl]
		passive_imgs[Of.pindex] = list(I)
		src << I
		_passive_cache[Of.pindex] = lvln

	else
		var/dig1=copytext(lvl,1,2)
		var/dig2=copytext(lvl,2)
		var/image/I1=Of.digit1["[dig2]"]
		var/image/I2=Of.digit2["[dig1]"]
		passive_imgs[Of.pindex] = list(I1, I2)
		src << I1
		src << I2
		_passive_cache[Of.pindex] = lvln

var/global/passives[] = list()

obj/gui/passives
	var/list/digit1=new/list()
	var/list/digit2=new/list()
	var/disc
	var/pindex=0
	var/max=0
	New()
		..()
		global.passives += src
		digit1["1"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="1",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["2"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="2",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["3"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="3",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["4"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="4",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["5"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="5",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["6"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="6",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["7"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="7",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["8"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="8",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["9"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="9",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["0"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="0",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["1"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="1",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["2"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="2",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["3"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="3",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["4"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="4",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["5"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="5",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["0"]=new/image('fonts/Cambria8ptblk.dmi',loc=src.loc,icon_state="0",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
	Click() // TODO, automate.
		if(istype(src, /obj/gui/passives/gauge))
			return
		if(istype(src, /obj/gui/passives/int/Keen_Eye))
			usr << "This is disabled at the moment."
			return 0

		var/mob/human/user = usr
		var/details = "[name] \n\nDescription: [disc] \n\nYou currently have [user.skillspassive[pindex] >= 1 ? user.skillspassive[pindex] : "0"] [name] passives out of [max]."

		switch(input2(user, details, "Skill", list("Purchase Passive", "Nevermind")))
			if("Purchase Passive")
				if(!src.pindex)
					return 0

				if(user.skillspassive[pindex] >= max)
					//user.Output("<b>Notice:</b> You already have the maximum amount of [name] passives.")
					return 0

				var/purchase = input(user, "How many passives do you want to invest in [name]?", "Buy Passive") as num | null
				if(!purchase || purchase <= 0)
					return 0

				var/passive_type
				if(istype(src, /obj/gui/passives/con)) passive_type = CONTROL
				else if(istype(src, /obj/gui/passives/str)) passive_type = STRENGTH
				else if(istype(src, /obj/gui/passives/int)) passive_type = INTELLIGENCE
				else if(istype(src, /obj/gui/passives/rfx)) passive_type = REFLEX

				if(!passive_type)
					return 0

				while(purchase > 0 && user.skillspassive[passive_type] > 0 && user.skillspassive[src.pindex] < src.max)
					purchase--
					user.skillspassive[passive_type]--
					user.skillspassive[src.pindex]++

				if(user.client)
					user.client.Passive_Refresh(src)

					for(var/obj/gui/passives/gauge/gauge in passives)
						user.client.Passive_Refresh(gauge)

	gauge
		str
			pindex=STRENGTH
		rfx
			pindex=REFLEX
		int
			pindex=INTELLIGENCE
		con
			pindex=CONTROL
	str
		Endurance
			max=5
			pindex=ENDURANCE
			disc="For each level of this passive, you recover from knockouts with 3% more stamina. Additionally, your maximum stamina is increased by 2%. Your stamina regeneration rate is not affected."
		Built_Solid
			max=20
			pindex=BUILT_SOLID
			disc="For every level of this passive, you are resistant to 4% of all daze and slowdown effects on you, and you have a 2% chance to convert 1 wound into 120 stamina damage."
		Piercing_Strike
			max=10
			pindex=PIERCING_STRIKE
			disc="For each level of this passive, 6% of taijutsu damage blows through all forms of defense."
		Force
			max=10
			pindex=FORCE
			disc="For each level of this passive, your taijutsu critical hits deal an additional 10% damage."
		Brutality
			max=10
			pindex=BRUTALITY
			disc="For each level of this passive, you have a 5% chance to instantly counterattack melee attacks and deal 20% of your equipped melee weapon's damage to an attacker. This effect will not activate while stunned or dazed."
		Flurry
			max=10
			pindex=FLURRY
			disc="For each level of this passive, your successive taijutsu attacks deal 20% more damage than the last until you are hit, stacking up to the number of points in this passive. Additionally for every point of this passive, the duration of your daze effects is increased by 20%."
	rfx
		Bombardment
			max=5
			pindex=BOMBARDMENT
			disc="For each level of this passive, your chance for projectile weapons to inflict 1-4 additional wounds is increased by 3%, and your maximum supply capacity is increased by 20."
		Evasiveness
			max=10
			disc="For each level of this passive, your chance to be dazed or hit critically by melee is reduced by 3%."
			pindex=EVASIVENESS
		Blindside
			max=20
			pindex=BLINDSIDE
			disc="For each level of this passive, your damage against opponents who do not have you targeted is increased by 5%."
		Speed_Demon
			max=5
			pindex=SPEED_DEMON
			disc="\
			Level 1: Allows you to use Shunshin without performing handseals. \n\
			Level 2: Allows you to move directly behind a targeted enemy with Shunshin and removes its stun. \n\
			Level 3: Allows you to perform an action immediately after finishing Shunshin. \n\
			Level 4: Reduces the cooldown of Shunshin by 10 seconds. \n\
			Level 5: Reduces the cooldown of Shunshin by 15 seconds."
		Open_Wounds
			max=10
			pindex=OPEN_WOUNDS
			disc="For each level of this passive, your chance for melee weaponry to cause an enemy to bleed is increased by 3%. Additionally, your poison gains sting damage, causing your poison to deal additional damage over time and be more effective on enemies who are bleeding for longer."
		Weapon_Mastery
			max=10
			pindex=WEAPON_MASTERY
			disc="For each level of this passive, your damage done by swords and melee kunai is increased by 6%. Additionally, your chance to deflect all weaponry while defending with a weapon is increased by 2% (kunai), 5% (ANBU sword), and 10% (decapitator)."
	int
		Tracking
			max=5
			pindex=TRACKING
			disc="For each level of this passive, you will maintain your target on an enemy for a longer distance and become 10% more resistant to bunshin tricks."
		Analytical
			max=5
			pindex=ANALYTICAL
			disc="\
			Level 1: Allows you to analyze your target's current stamina and chakra values. \n\
			Level 2: Allows you to analyze your target's wounds and see more information about their stamina and chakra. \n\
			Level 3: Allows you to analyze your target's status (stunned, poisoned, sleep, ...) and see more information about their wounds. \n\
			Level 4: Allows you to analyze your target's skill modifications (sand armor, bone armor, etc.). \n\
			Level 5: Allows you to analyze your target's level and stats."
		Genjutsu_Mastery
			max=10
			pindex=GENJUTSU_MASTERY
			disc="For each level of this passive, Intelligence for the purpose of genjutsu is increased by 10."
		Trap_Mastery
			max=15
			pindex=TRAP_MASTERY
			disc="For each level of this passive, all explosives deal 2% additional damage. Caltrops also deal 5% additional damage and have a 2% increased chance to stun after damaging a player."
		Clone_Mastery
			max=10
			pindex=CLONE_MASTERY
			disc="For each level of this passive, your Intelligence for the purpose of bunshin tricks is increased by 10."
		Keen_Eye
			max=20
			pindex=KEEN_EYE
			disc="For each level of this passive, all damage taken by jutsus that you have learned is reduced by 2%."
	con
		Chakra_Efficiency
			max=10
			pindex=CHAKRA_EFFICIENCY
			disc="For each level of this passive, chakra costs for all jutsus are reduced by 4%."
		Powerhouse
			max=10
			pindex=POWERHOUSE
			disc="For each level of this passive, your maximum chakra amount is increased by 2%."
		Medical_Training
			max=15
			pindex=MEDICAL_TRAINING
			disc="For each level of this passive, the damage and healing done by all medical jutsus is increased by 20%, and all poison damage is increased by 5%."
		Pure_Power
			max=10
			pindex=PURE_POWER
			disc="For each level of this passive, Control for the purpose of ninjutsu is increased by 10."
		Regeneration
			pindex=REGENERATION
			disc = "For each level of this passive, Chakra and Stamina regenerate 6% faster."
			max=10
		Seal_Knowledge
			pindex=SEAL_KNOWLEDGE
			max=10
			disc="For each level of this passive, the duration of seals used to perform jutsu is decreased by .25 seconds, and their cooldowns are reduced by 3%."

var/const
	STRENGTH = 1
	CONTROL = 2
	INTELLIGENCE = 3
	REFLEX = 4

	// STRENGTH
	FORCE = 10
	FLURRY = 11
	BUILT_SOLID = 12
	BRUTALITY = 13
	PIERCING_STRIKE = 14
	ENDURANCE = 15 // additionally, the user stands up with 3% more stamina.

	// CONTROL
	SEAL_KNOWLEDGE = 20
	CHAKRA_EFFICIENCY = 21
	REGENERATION = 22
	MEDICAL_TRAINING = 23
	PURE_POWER = 24
	POWERHOUSE = 25

	// INTELLIGENCE
	GENJUTSU_MASTERY = 30
	CLONE_MASTERY = 31
	KEEN_EYE = 32
	TRAP_MASTERY = 33
	TRACKING = 34
	ANALYTICAL = 35

	// REFLEX
	BLINDSIDE = 40
	WEAPON_MASTERY = 41
	OPEN_WOUNDS = 42
	BOMBARDMENT = 43
	EVASIVENESS = 44
	SPEED_DEMON = 45