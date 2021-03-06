var
	Compatibility=0
	list/npc_valid_skills = list(WINDMILL_SHURIKEN,KATON_FIREBALL,LEAF_WHIRLWIND,EXPLODING_KUNAI,/*KATON_TAJUU_PHOENIX,*/KATON_PHOENIX_FIRE,DOTON_IRON_SKIN,DOTON_CHAMBER,PARALYZE_GENJUTSU,SUITON_VORTEX,CHIDORI,FUUTON_PRESSURE_DAMAGE,CHIDORI_CURRENT,FUUTON_GREAT_BREAKTHROUGH,SLEEP_GENJUTSU,FUUTON_AIR_BULLET/*,SUITON_SYRUP_FIELD*/,LION_COMBO,IMPORTANT_BODY_PTS_DISTURB,POISON_MIST,TWIN_RISING_DRAGONS)

	const
		ACTION_WEAPON = 1
		ACTION_JUTSU = 2
		ACTION_KAWARIMI = 3
		ACTION_SHUNSHIN = 4
		ACTION_TAIJUTSU = 5
		ACTION_CLOSE = 6

// targeting.dm
mob
	proc/clear_targets()
		for(var/mob/t in targets)
			RemoveTarget(t)

	proc/clear_targeted_by()
		for(var/mob/tm in targeted_by)
			tm.RemoveTarget(src)

	Bump(mob/human/player/npc/n)
		if(!istype(n))
			return ..(n)
		if(MissionTarget && (MissionType == "Escort" || MissionType == "Escort PvP") && MissionTarget == n)
			n.loc = loc
			return
		..()

mob/human/player/npc
	combat_protection = 0

	Hostile(mob/attacker)
		..()
		if(onquest && attacker.MissionTarget == src && doesnotattack)
			doesnotattack = list(attacker) // only attack him.
			AddTarget(attacker)
	proc
		escort_step(d)
			set waitfor = 0
			sleep(5)
			step(src, d)

		escort_teleport()
			if(following && following.loc)
				loc = following.loc
				//world.log << "DEBUG: TELEPORT TRIGGERED!"

		reinitialize()
			for(var/mob/m in targeted_by)
				m.RemoveTarget(src)
			curstamina = stamina
			curchakra = chakra
			icon_state = ""
			Reset_Move_Stun()
			Reset_Stun()
			movepenalty = 0
			genjutsu = null
			clear_targets()

		AIinitialize()
			set waitfor = 0
			origx=src.x
			origy=src.y
			origz=src.z
			src.Get_Global_Coords()
			src.refresh_rank()
			if(!loc)
				while(!loc)
					sleep(5)
					AI_Loop()
			else
				AI_Loop()

			sleep(20)
			src.curstamina=src.stamina
			src.curchakra=src.chakra

mob/human/player/npc
	var
		mob/lasthurtme = null

	proc/load_skills()
		set waitfor = 0
		for(var/m in src.skillsx)
			src.AddSkill(m, skillcard=0, add_unknown=0)

	proc/start_ai_loop()
		set waitfor = 0
		if(auto_ai)
			Get_Global_Coords()
			if(!loc)
				while(!loc)
					sleep(5)
					AI_Loop()
			else
				AI_Loop()

	New()
		set waitfor = 0
		..()
		if(src.questable)
			src.dietype=0
			src.doesnotattack=1
		if(!faction)
			while(!leaf_faction && !mist_faction && !sand_faction && !missing_faction) sleep(10)
			switch(locationdisc)
				if("Konoha") faction = leaf_faction
				if("Suna") faction = sand_faction
				if("Kiri") faction = mist_faction
				else
					faction = missing_faction

			if(faction!=missing_faction)mouse_over_pointer = faction_mouse[faction.mouse_icon]

			CreateName(255, 255, 255)

		if(src.pants=="random")
			src.pants=pick(typesof(/obj/pants))

		if(src.overshirt=="random")
			src.overshirt=pick(typesof(/obj/shirt))

		if(src.hair_type==99)
			src.hair_type=pick(1,2,3,4,5,6,7,8,9,10,0)
		src.Affirm_Icon()
		origx=src.x
		origy=src.y
		origz=src.z
		if(src.projectiles)
			src.getweapon()
		src.completeLoad_Overlays()
		src.npcregeneration() //!
		src.load_skills()
		skillspassive[TRACKING] = 3
		src.Stun_Drain() //!
		src.start_ai_loop()
		stamina=blevel*55 +str*20
		chakra=190 +blevel*10 + con*2.5
		refresh_rank()
		curstamina=stamina
		curchakra=chakra
		staminaregen=round(stamina/100)
		chakraregen=round((chakra*3)/100)

	interact="Talk"

	verb
		Talk()
			set src in oview(1)
			set hidden=1
			for(var/mob/human/player/X in world)
				if((X.ckey in admins) && X.z == src.z)
					X<<"usr=[usr], src=[src], MissionTarget=[usr.MissionTarget], MissionType=[usr.MissionType]"
			if(MainTarget() && usr.MissionTarget == src && (usr.MissionType == "Escort" || usr.MissionType == "Escort PvP"))
				alert(usr,"Sorry, I will calm down.")
				FilterTargets()
				for(var/mob/T in targets)
					RemoveTarget(T)
				return
			if(!MainTarget())
				if(src.onquest && usr.MissionTarget==src)
					if(usr.MissionType=="Delivery")
						usr << "Thank you very much!"
						if(usr.MissionType=="Delivery")
							usr.MissionType=0

							usr.MissionComplete()
						return
					if((usr.MissionType=="Escort"||usr.MissionType=="Escort PvP") && !src.following)
						usr << "Hello, I need to get to [usr.MissionLocation].  Press Space/Interact and I will stop following you."
						if(usr.z == src.z)
							src.following = usr
							usr.leading = src
							clear_targets()
							//FilterTargets()
							//for(var/mob/T in targets)
							//	RemoveTarget(T)
						return
				else
					var/list/choicelist=new
					choicelist+="Ask about them"
					if(src.chattopic)
						choicelist+=src.chattopic

					choicelist+="Nevermind"

					var/Talkbout=input2(usr,"NPC Chat Options:","NPC",choicelist)
					if(Talkbout=="Ask about them")
						alert(usr,"[src.message]")
					else if(Talkbout!="Nevermind")
						usr.TalkTopic(src,Talkbout)

	verb
		Shop()
			set src in oview(1)
			set hidden=1
			if(!MainTarget())
				src.Check_Sales(usr)

mob/human
	str=50
	con=50
	rfx=50
	int=50
	stamina=1000
	chakra=300
	icon='icons/base_m1.dmi'
	icon_state=""

mob/human/player/npc
	var
		patrol_spot = 1
		mob/human/player/following = null
	proc
		stop_following()
			if(!following)
				return
			following.leading = null
			following = null
			//FilterTargets()
			//for(var/mob/T in targets)
			//	RemoveTarget(T)
			clear_targets()

			walk(src,0)
		Stun_Drain()
			set background = 1
			set waitfor = 0
			sleep(10)
			while(loc)
				if(z && invisibility<2)
					//if(move_stun)
					//	move_stun = max(0, move_stun-10)
					//if(stunned)
					//	stunned--
					if(tired)
						tired--
				sleep(10)

		npcDie()
			set waitfor = 0
			if(src.onquest)
				var/questdone=0

				for(var/mob/human/player/X in ohearers(8))
					if(X.MissionTarget==src)
						questdone=1
						if(X.MissionType=="Escort"||X.MissionType=="Escort PvP")
							X.MissionFail(0, "The person you were to escort has died!")
						else if(X.MissionType=="Assasinate"||X.MissionType=="Kill Npc PvP"||X.MissionType=="Invade PvP")
							X.MissionComplete()

				if(questdone)
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.onquest=1
					sleep(100)
					src.onquest=0
					src.curwound=0
					FilterTargets()
					for(var/mob/T in targets)
						RemoveTarget(T)
					src.curstamina=src.stamina
					src.density=1
					src.targetable=1
					src.icon_state=""
					src.loc=locate(src.origx,src.origy,src.origz)

			//lasthurtme = null
			FilterTargets()

			if(following)
				following.leading = null
				following = null

			clear_targets()
			clear_targeted_by()
			/*for(var/mob/T in targets)
				RemoveTarget(T)*/

			switch(src.dietype) //0=KO,no death 1=delayed respawn 2=death till repop
				if(0)
					doesnotattack = 1
					src.icon_state="Dead"
					sleep(200)
					blevel = initial(blevel)
					con = initial(con)
					str = initial(str)
					rfx = initial(rfx)
					int = initial(int)
					stamina=blevel*55 +str*20
					chakra=190 +blevel*10 + con*2.5
					curstamina=stamina
					curchakra=chakra
					staminaregen=round(stamina/100)
					chakraregen=round((chakra*3)/100)
					src.icon_state=""
					curwound = 0
					/*for(var/mob/T in targets)
						RemoveTarget(T)
					for(var/mob/human/player/npc/X in ohearers(5))
						X.FilterTargets()
						if(src in X.targets)
							X.RemoveTarget(src)*/

				if(1)
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.dead=1

					if(nisguard)
						var/mob/human/killer = lasthurtme
						if(!killer)
							for(var/mob/attacker in hearers(20, src))
								if(!attacker.client)
									continue
								if(lasthostile == attacker.key)
									//world << "FOUND [killer]"
									killer = attacker
									break

						if(killer && killer.faction != src.faction && killer.faction.village != src.faction.village)
							if(prob(5))
								if(pick(0, 0, 1))
									new/obj/items/drops/scrolls/triple_experience(loc)
								else
									new/obj/items/drops/scrolls/double_experience(loc)
							var/gain = exp_worth()
							var/mgain = pick(3,4,5,6,7,8,9,10)*src.blevel

							if(killer.squad)
								var/higher_up_boost = 0
								for(var/mob/m in killer.squad.online_members)
									if(m.z == killer.z && get_dist(m, src) <= 25)
										switch(m.rank)
											if("Academy Student", "Genin", "Chuunin")
												gain *= 1.1
											else
												if(!higher_up_boost && squad && m && m.realname == squad.leader)
													higher_up_boost = 1
													gain *= 1.2
								for(var/mob/m in killer.squad.online_members - killer)
									if(get_dist(m, src) <= 25 && m.z == killer.z)
										m.body += gain
										m.money += mgain
										m<<"You have gained [gain] experience points!"
										m<<"You have gained [mgain] ryo!"
							killer.body += gain
							killer << "You have gained [gain] experience points!"
							killer.bodycheck()
							killer.money += mgain
							killer << "You have gained [mgain] ryo!"

					sleep(respawndelay)
					// TODO, pool these.
					//new src.type (locate(src.origx,src.origy,src.origz))
					//del(src)
					var/turf/respawn = locate(origx, origy, origz)
					if(respawn)
						loc = respawn
						reinitialize()

				if(2)
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.dead=1

				if(3)//exp gain
					src.density=0
					src.icon_state="Dead"
					src.targetable=0
					src.dead=1

					if(prob(rand(0, 5)))
						if(pick(0, 0, 1))
							new/obj/items/drops/scrolls/triple_experience(loc)
						else
							new/obj/items/drops/scrolls/double_experience(loc)

					if(istype(src,/mob/human/player/npc/creep))
						var/mob/human/player/npc/creep/C=src
						var/mob/human/player/X = C.lasthurtme
						if(X)
							var/gain = exp_worth()//min(1200,round(600 * src.blevel/X.blevel))*lp_mult
							var/mgain = 100 + pick(3,4,5,6,7,8,9,10)*src.blevel
							if(X.squad)
								var/higher_up_boost = 0
								for(var/mob/m in X.squad.online_members)
									if(m.z == src.z && get_dist(m, src) <= 25)
										switch(m.rank)
											if("Academy Student", "Genin", "Chuunin")
												gain *= 1.1
											else
												if(!higher_up_boost && (m && m.realname == X.squad.leader))
													higher_up_boost = 1
													gain *= 1.2
								for(var/mob/m in X.squad.online_members - X)
									if(get_dist(m, src) <= 25 && m.z == X.z)
										m.body += gain
										m.money += mgain
										m<<"You have gained [gain] experience points!"
										m<<"You have gained [mgain] ryo!"
							X.body+=gain
							X<<"You have gained [gain] experience points!"
							X.bodycheck()
							X.money+=mgain
							X<<"You have gained [mgain] ryo!"
						//C.lasthurtme=null
					sleep(100)
					del(src)

			sleep(10)
			npcregeneration()

		getweapon()
			switch(src.projectiles)
				if(1)
					var/x=new/obj/items/weapons/projectile/Kunai_p(src)
					x:Use(src)
				if(2)
					var/x=new/obj/items/weapons/projectile/Shuriken_p(src)
					x:Use(src)
				if(3)
					var/x=new/obj/items/weapons/projectile/Needles_p(src)
					x:Use(src)
				if(4)
					var/x=new/obj/items/weapons/projectile/Kunai_p(src)
					x:Use(src)

		AI_Loop()
			set waitfor = 0
			sleep(rand(0, 50))
			while(loc)
				AI_Tick()
				sleep(1)

		AI_Tick()
			if(dead)
				return

			if(following)
				if(following in ohearers(10,src))
					walk_to(src,following,1,1)
			else if(Squad)
				var/mob/human/player/npc/leader = Squad[1]
				if(!leader)
					Squad -= src
					Squad[1] = src
					leader = src
				if(leader.dead || !leader.loc)
					var/sloc = Squad.Find(src)
					Squad[sloc] = leader
					Squad[1] = src
					leader = src
				if(leader == src)
					var/list/merged_targets = targets.Copy()
					var/list/merged_actives = active_targets.Copy()
					for(var/mob/human/player/npc/M in Squad)
						merged_targets |= M.targets
						merged_actives |= M.active_targets
					for(var/mob/human/player/npc/M in Squad)
						M.targets = merged_targets.Copy()
						M.active_targets = merged_actives.Copy()
				else
					if(get_dist(src, leader) > 10 || (leader.loc && src.z != leader.z))
						AppearAt(leader.x, leader.y, leader.z)

			if(!following)
				var/mob/human/player/target = targets.len ? targets[targets.len] : null//MainTarget() Feral: cutting down on filter calls
				if(target && !target.ko && get_dist(target, src) < 10)
					AI_Attack(target)
				else
					/*if(targets.len)
						var/mob/latest_target = targets[targets.len]
						if(get_dist(src, latest_target) > 10)
							RemoveTarget(latest_target)
							step_to(src,targets[1])*/
					if(patrol)
						AI_Patrol()
					else
						AI_Random_Move()

		AI_Target(mob/human/player/M)
			set waitfor = 0
			if(!M || M.ko || (doesnotattack==1 || istype(doesnotattack, /list) && !(M in doesnotattack)) || (M.combat_protection && M.MissionTarget != src))
				return
			AddTarget(M, active=1)

		AI_Canmove()
			return !stunned && !ko && !maned && !kaiten && !incombo

		AI_Patrol()
			var/busy=0
			var/maxspot=min(length(px), length(py))

			if(patrol_spot < maxspot)
				var/turf/targ=locate(px[patrol_spot],py[patrol_spot],z)
				step_to(src, targ)
				busy++
				if(get_dist(src, targ) <= 1)
					patrol_spot++

			else
				var/turf/targ=locate(origx,origy,z)
				step_to(src, targ)
				busy++
				if(get_dist(src, targ) <= 1)
					patrol_spot = 1

			if(busy > 200)
				AppearAt(origx,origy,origz)
				busy = 0

		AI_Random_Move()
			if(!loc || !AI_Canmove())
				return

			var/list/dirs = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)
			var/success = 0

			while(dirs.len && !success)
				var/dir = pick(dirs)
				dirs -= dir
				success = step(src, dir)
			sleep(rand(10,35))

		AI_Determine_Attack(mob/human/player/M)
			var/jutsu_priority = con/str
			var/distance = max(1,get_dist(src,M))
			var/health_val = curstamina/max(1,stamina)
			var/chakra_val = curchakra/max(1,chakra)

			var/tai_val = health_val * 1/jutsu_priority * (3/distance)
			var/jutsu_val = chakra_val * jutsu_priority * (distance/3)
			var/weapon_val = distance/3
			//var/kawarimi_val = 1 - health_val

			var/valid_jutsu = 0
			//var/valid_kawa = 0
			var/valid_shun = 0

			if(!(rasengan || sakpunch2 || skillusecool))
				for(var/skill/sk in skills)
					if((!(sk.id in list(KAWARIMI, SHUNSHIN))) && !sk.cooldown)
						valid_jutsu = 1
					//else if(sk.id == KAWARIMI && !sk.cooldown)
					//	valid_kawa = 1
					else if(sk.id == SHUNSHIN && !sk.cooldown)
						valid_shun = 1

			var/list/liked_options = list()
			if(tai_val > 1.5)
				liked_options += ACTION_TAIJUTSU
			if(jutsu_val > 0.5 && valid_jutsu && !skillusecool && CanUseSkills())
				liked_options += ACTION_JUTSU
			if(weapon_val > 1)
				liked_options += ACTION_TAIJUTSU
			//if(kawarimi_val > 0.5 && !AIKawa && valid_kawa)
			//	liked_options += ACTION_KAWARIMI

			var/action
			if(!liked_options.len || prob(10)) // Do something unexpected
				var/list/valid_options = list(ACTION_TAIJUTSU)
				//if(projectiles)
				//	valid_options += ACTION_WEAPON
				if(valid_jutsu)
					valid_options += ACTION_JUTSU
				//if(valid_kawa)
				//	valid_options += ACTION_KAWARIMI
				if(valid_shun)
					valid_options += ACTION_SHUNSHIN
				action = pick(valid_options)
			else
				action = pick(liked_options)

			if(rasengan || sakpunch2) // Punch them if we're using rasengan or ctr
				action = ACTION_TAIJUTSU

			if(distance > 3 && action != ACTION_TAIJUTSU && action != ACTION_SHUNSHIN)
				action = ACTION_CLOSE
				/*if(jutsu_priority >= 1)
					action = ACTION_CLOSE
				else
					action = ACTION_TAIJUTSU
				*/

			if((M.stunned || M.paralysed) && action != ACTION_CLOSE)
				action = list()
				if(get_dist(src, M) > 1)
					action += ACTION_SHUNSHIN
				action += ACTION_JUTSU
			else
				if(action == ACTION_TAIJUTSU && get_dist(src, M) > 1 && valid_shun)
					action = list(ACTION_SHUNSHIN, ACTION_TAIJUTSU)

			return action

		AI_Attack(mob/human/player/M)
			// allow mission target civilians to fight back.
			var/cancel=0
			if(src.doesnotattack)
				cancel = 1
				if(islist(doesnotattack) && (M in doesnotattack))
					cancel = 0

			if(cancel)
				return

			if(AI_Canmove())
				if(!istype(src, /mob/human/player/npc/kage_bunshin) && (M.faction && M.faction == faction)) // ((!M.faction || !faction) || M.faction.village == faction.village))
					RemoveTarget(M)
					return
				usr = src

				curchakra=chakra

				var/attacks=AI_Determine_Attack(M)
				if(islist(attacks))
					for(var/attack in attacks)
						switch(attack)
							if(ACTION_WEAPON)
								var/steps = 0
								while(get_dist(src,M) <= 3 && steps < 10)
									++steps
									step_away(src,M)
									sleep(1)
								if(get_dist(src,M) > 3)
									src.supplies=100
									src.usedelay=0
									usr.usev()

							if(ACTION_JUTSU)
								if(M)
									var/list/options = list()
									for(var/skill/sk in skills)
										if(!(sk.id in list(KAWARIMI, SHUNSHIN)))
											options += sk
									if(options.len)
										var/skill/x
										do
											x = pick(options)
											options -= x
										while(options.len && !x.IsUsable(src))
										if(x && x.IsUsable(src))
											x.Activate(src)

							if(ACTION_KAWARIMI)
								if(src.HasSkill(KAWARIMI))
									var/skill/x = src.GetSkill(KAWARIMI)
									x.Activate(src)

							if(ACTION_SHUNSHIN)
								if(M&&src&&M.z==src.z && src.HasSkill(SHUNSHIN))
									var/skill/x = src.GetSkill(SHUNSHIN)
									x.Activate(src)

							if(ACTION_TAIJUTSU)
								/*if(rasengan || sakpunch2)
									src.AppearBehind(M)
									src.rand_attack_ani()
									src.attackv(M)
									src.icon_state=""*/

								if(get_dist(src,M) <= 3)
									var/steps = 0
									while(get_dist(src,M) > 1 && steps < 10)
										++steps
										step_to(src,M)
										sleep(1)

									if(get_dist(src,M) <= 1)
										src.rand_attack_ani()
										//src.attackv(M)
										for(var/i in 1 to rand(2,5))
											if(get_dist(src, M) > 1)
												break
											if(M)
												src.FaceTowards(M)
												src.attackv(M)
											sleep(3)
										src.icon_state=""


							if(ACTION_CLOSE)
								if(get_dist(src,M) > 3)
									var/steps = 0
									while(get_dist(src,M) > 3 && steps < 10)
										++steps
										step_to(src,M)
										sleep(1)

						sleep(1)
				else
					switch(attacks)
						if(ACTION_WEAPON)
							var/steps = 0
							while(get_dist(src,M) <= 3 && steps < 10)
								++steps
								step_away(src,M)
								sleep(1)
							if(get_dist(src,M) > 3)
								src.supplies=100
								src.usedelay=0
								usr.usev()

						if(ACTION_JUTSU)
							if(M)
								var/list/options = list()
								for(var/skill/sk in skills)
									if(!(sk.id in list(KAWARIMI, SHUNSHIN)))
										options += sk
								if(options.len)
									var/skill/x
									do
										x = pick(options)
										options -= x
									while(options.len && !x.IsUsable(src))
									if(x && x.IsUsable(src))
										x.Activate(src)

						if(ACTION_KAWARIMI)
							if(src.HasSkill(KAWARIMI))
								var/skill/x = src.GetSkill(KAWARIMI)
								x.Activate(src)

						if(ACTION_SHUNSHIN)
							if(M&&src&&M.z==src.z && src.HasSkill(SHUNSHIN))
								var/skill/x = src.GetSkill(SHUNSHIN)
								x.Activate(src)

						if(ACTION_TAIJUTSU)
							/*if(rasengan || sakpunch2)
								src.AppearBehind(M)
								src.rand_attack_ani()
								src.attackv(M)
								src.icon_state=""*/

							if(get_dist(src,M) <= 3)
								var/steps = 0
								while(get_dist(src,M) > 1 && steps < 10)
									++steps
									step_to(src,M)
									sleep(1)

								if(get_dist(src,M) <= 1)
									src.rand_attack_ani()
									//src.attackv(M)
									for(var/i in 1 to rand(2,5))
										if(get_dist(src, M) > 1)
											break
										if(M)
											src.FaceTowards(M)
											src.attackv(M)
										sleep(3)
									src.icon_state=""


						if(ACTION_CLOSE)
							if(get_dist(src,M) > 3)
								var/steps = 0
								while(get_dist(src,M) > 3 && steps < 10)
									++steps
									step_to(src,M)
									sleep(1)

mob/var/AIKawa=0

mob/human
	var
		cooldown2=0
		list/Squad=0

mob/human/player/npc/creep/var/ambusher=0

proc/Ambush(mob/Tgt,lvl,num,notambush)
	if(!Tgt || !Tgt.pk)
		return
	var/list/S=new
	var/list/Landing=new
	Landing+=oview(6,Tgt)
	for(var/atom/O in oview(6,Tgt))
		if(O.density && (Landing.Find(O)||Landing.Find(O.loc)))
			if(istype(O,/turf))Landing-=O
			else Landing-=O.loc

	for(var/turf/O in oview(2,Tgt))
		if(Landing.Find(O))Landing-=O //too close

	while(num && length(Landing))
		num--
		var/turf/La=pick(Landing)
		Landing-=La
		// TODO, these should use the atom pool.. as should most atoms
		var/mob/human/player/npc/M = /*atom_pool.get_instance("mob/human/player/npc/creep", /mob/human/player/npc/creep)*/new/mob/human/player/npc/creep(La, lvl)
		Poof(La)//(La.x, La.y, La.z)
		//M.loc = La
		//M.blevel = lvl
		//M.reinitialize(Tgt)
		S+=M

	for(var/mob/human/player/npc/creep/M in S)
		M.npc_walk_to(M, speed = 2, duration = 3)
		M.Squad=S
		if(!notambush)M.ambusher=1
		M.mouse_over_pointer = new/image(icon = 'icons/mouse_icons/village_symbols.dmi', icon_state = "?") //'icons/mouse_icons/rockmouse.dmi'
		if(istype(Tgt,/mob))
			M.AI_Target(Tgt)

mob/human/player/npc
	proc/npc_walk_to(mob/target, speed = 1, duration)
		set waitfor = 0
		if(!target)
			return
		walk_to(src, target, 0, speed)
		sleep(duration)
		walk(src, null)


var/rockshinobis=0

mob/human/player/npc/creep
	RankGrade()
		switch(blevel)
			if(1 to 31) ninrank = "C"
			if(32 to 67) ninrank = "B"
			if(68 to 99) ninrank = "A"
			else ninrank = "S"
		return ninrank

	pooled()
		//world.log << "DEBUG, ROCK SHINOBI WAS POOLED!"
		rockshinobis--
		skills = null
		squad = null
		Squad = null
		clear_targets()
		clear_targeted_by()
		lasthurtme = null
		loc = null

	Del()
		rockshinobis--
		..()

	reinitialize(mob/enemy)
		set_difficulty(enemy)
		src.refresh_rank()
		if(src.rfx>150)src.delay = 4
		if(src.rfx>200)src.delay = 3
		if(src.rfx>250)src.delay = 2
		if(src.rfx>350)src.delay = 1

		skills = list()
		var/points = round(int / 40)
		var/list/valid_skills = npc_valid_skills.Copy()//list(WINDMILL_SHURIKEN,KATON_FIREBALL,LEAF_WHIRLWIND,NIRVANA_FIST,EXPLODING_KUNAI,/*KATON_TAJUU_PHOENIX,*/KATON_PHOENIX_FIRE,DOTON_IRON_SKIN,DOTON_CHAMBER,PARALYZE_GENJUTSU,SUITON_VORTEX,CHIDORI,FUUTON_PRESSURE_DAMAGE,CHIDORI_CURRENT,FUUTON_GREAT_BREAKTHROUGH,SLEEP_GENJUTSU,FUUTON_AIR_BULLET/*,SUITON_SYRUP_FIELD*/,LION_COMBO,IMPORTANT_BODY_PTS_DISTURB,POISON_MIST,TWIN_RISING_DRAGONS)
		while(points && valid_skills.len)
			points--
			var/newskill = pick(valid_skills)
			valid_skills -= newskill
			AddSkill(newskill)

		..()

	New(loc,lvl)
		set waitfor = 0
		..()
		lvl+=pick(-2,-1,0,1,2)
		lvl=max(1,lvl)
		src.name="Bandit ([lvl])"

		src.blevel=lvl

		switch(pick(1,2,3,4))
			if(1)//jutsu user
				int=50+(lvl-1)*4
				rfx=50+(lvl-1)*2
				con=50+(lvl-1)*3
				str=50+(lvl-1)*1
			if(2)//tank
				int=50+(lvl-1)*1
				rfx=50+(lvl-1)*2
				con=50+(lvl-1)*3
				str=50+(lvl-1)*4
			if(3)//Well rounded
				int=50+round((lvl-1)*2.5)
				rfx=50+round((lvl-1)*2.5)
				con=50+round((lvl-1)*2.5)
				str=50+round((lvl-1)*2.5)
			if(4)//taijutsu user
				int=50+round((lvl-1)*1)
				rfx=50+round((lvl-1)*4)
				con=50+round((lvl-1)*1)
				str=50+round((lvl-1)*4)
		src.stamina=(src.blevel*55 +(src.str)*20)
		src.chakra=(100 + (src.con)*8)
		src.staminaregen=round(src.stamina/100)
		src.chakraregen=round((src.chakra*1.5)/100)
		src.refresh_rank()
		if(src.rfx>150)src.delay=4
		if(src.rfx>200)src.delay=3
		if(src.rfx>250)src.delay=2
		if(src.rfx>350)src.delay=1
		var/points=round(int/50)
		var/list/valid_skills=list(WINDMILL_SHURIKEN,KATON_FIREBALL,LEAF_WHIRLWIND,EXPLODING_KUNAI,/*KATON_TAJUU_PHOENIX,*/KATON_PHOENIX_FIRE,DOTON_IRON_SKIN,DOTON_CHAMBER,PARALYZE_GENJUTSU,SUITON_VORTEX,CHIDORI,FUUTON_PRESSURE_DAMAGE,CHIDORI_CURRENT,FUUTON_GREAT_BREAKTHROUGH,SLEEP_GENJUTSU,FUUTON_AIR_BULLET/*,SUITON_SYRUP_FIELD*/,LION_COMBO,IMPORTANT_BODY_PTS_DISTURB,POISON_MIST,TWIN_RISING_DRAGONS)
		while(points && valid_skills.len)
			points--
			var/newskill = pick(valid_skills)
			valid_skills -= newskill
			skillsx+=newskill
		sleep(60*10*5)
		del(src)
		//if(loc)atom_pool.pool(src, "[src.type]")

	nisguard=0
	hostile=1
	name = "Bandit"
	//name="Rock Shinobi"
	//locationdisc="Hidden Rock"
	wander=1
	questable=0
	blevel=30
	delay=5

	dietype=3//0=KO,no death 1=delayed respawn 2=death till repop 3=expgain
	str=100
	guard=0
	interact
	con=100
	rfx=100
	int=100
	stamina=4000
	chakra=700
	pants=/obj/pants/black
	undershirt=/obj/fishnet
	overshirt
	armor=/obj/plate/body/brown
	facearmor = /obj/headband/black
	hair_type=99
	hair_color="#000000"
	killable=1
	projectiles=2
	message ="..."

	skillsx=list(KAWARIMI,SHUNSHIN,BUNSHIN)

mob
	proc/set_difficulty(mob/hunter)
		var/lvl=1
		switch(hunter.MissionClass)
			if("D")
				lvl=limit(1,round(30 * rand(0.4,1)),30)
			if("C")
				lvl=limit(25,round(hunter.blevel * rand(0.7,1.1)),40)
			if("B")
				lvl=limit(45,round(hunter.blevel * rand(0.8,1.2)),50)
			if("A")
				lvl=limit(65,round(hunter.blevel * rand(0.9,1.3)),85)
			if("S")
				lvl=limit(90,round(hunter.blevel * rand(1,1.3)),100)
		switch(pick(1,2,3,4))
			if(1)//jutsu user
				int=50+(lvl-1)*4
				rfx=50+(lvl-1)*2
				con=50+(lvl-1)*3
				str=50+(lvl-1)*1
			if(2)//tank
				int=50+(lvl-1)*1
				rfx=50+(lvl-1)*2
				con=50+(lvl-1)*3
				str=50+(lvl-1)*4
			if(3)//Well rounded
				int=50+round((lvl-1)*2.5)
				rfx=50+round((lvl-1)*2.5)
				con=50+round((lvl-1)*2.5)
				str=50+round((lvl-1)*2.5)
			if(4)//taijutsu user
				int=50+round((lvl-1)*1)
				rfx=50+round((lvl-1)*4)
				con=50+round((lvl-1)*1)
				str=50+round((lvl-1)*4)
		blevel = lvl
		src.stamina=(src.blevel*55 +(src.str)*20)
		src.chakra=(100 + (src.con)*8)
		src.staminaregen=round(src.stamina/100)
		src.chakraregen=round((src.chakra*1.5)/100)

mob/human/proc
	rand_attack_ani()
		var/ans=pick(1,2,3,4)
		switch(ans)
			if(1)
				src.icon_state="PunchA-1"

			if(2)
				src.icon_state="PunchA-2"
			if(3)
				src.icon_state="KickA-1"
			if(4)
				src.icon_state="KickA-2"

var/npcdelay=3

mob/human/player/npc
	proc
		npcregeneration()
			set background = 1
			set waitfor = 0
			/*if(src.protected) //this is no longer npcregeneration()'s responsibility
				src.protected-=1*npcdelay*/

			if(src.alertcool)
				src.alertcool-=1*npcdelay
				if(src.alertcool<0)
					src.alertcool=0
			if(!src.loc)sleep(20)
			while(!dead && src.loc)
				sleep(10*npcdelay)
				if(!targets.len/*!MainTarget()*/) /* Feral:.. cutting down on filterTarget calls */
					src.curwound = max(0, curwound-1)
			//		if(src.curwound<0)
			//			src.curwound=0

				var/area/A
				if(loc)
					A = loc.loc
				if(istype(A,/area/nopkzone))
					pk = 0
					dojo = 1
					risk = 0
				else if(istype(A,/area/pkzone_dojo))
					pk = 1
					dojo = 1
					risk = 0
				else
					pk = 1
					dojo = 0

				if(src.asleep)
					//src.icon_state="Dead"
					sleep(100)
					src.asleep=0
					src.icon_state=""

				if(usedelay>0)
					usedelay--
					if(usedelay<0)
						usedelay=0

				//ko stuff
				if(src.curwound>=200)
					src.curstamina=0

				if(src.curstamina<=0)
					//src.Damage(0,rand(32,37),src,"KO","Internal")
					Damage(0, rand(32,37), null, "KO", "Internal")//src.Wound(rand(32,37),1)
					src.ko=1
					sleep(10)
					flick("Knockout",src)
					src.icon_state="Dead"
					src.layer=TURF_LAYER+1
					if(src.curwound<100)
						sleep(src.curwound +100)
						src.curstamina=src.stamina * ((maxwound-curwound)/maxwound)
						if(src.curchakra<src.chakra/5)
							src.curchakra=src.chakra/5 +20
						src.Protect(30)
						src.Reset_Stun()
						src.ko=0
						src.icon_state=""

					else
						src.npcDie()
						break

				if(src.ko)
					if(src.curstamina>0)
						src.ko=0
						src.icon_state=""
				//end ko stuff
				if(src.layer!=MOB_LAYER && !src.ko &&!src.incombo)
					src.layer=MOB_LAYER

				if(curwound<maxwound&&!mane&&!maned &&!waterlogged)
					if(curchakra<chakra)
						if(chakraregen > (chakra-curchakra))
							curchakra= chakra
						else
							curchakra +=chakraregen*npcdelay

					else
						if(curstamina<stamina)
							if((staminaregen) > (stamina-curstamina))
								curstamina=stamina
							else
								curstamina+=staminaregen*npcdelay