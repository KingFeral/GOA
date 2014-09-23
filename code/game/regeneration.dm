mob/human/player/New()
	. = ..()
	if(!istype(src,/mob/human/player/npc))
		src.regeneration()
	src.regeneration2()
	//src.comboregen()
// set a daily kill limit. (as in you stop gaining kill benefits from an ip/id after x amount of kills)
mob
	proc
		relieve_bounty()
			var/mob/jerk=0
			for(var/mob/ho in world)
				if(ho.client)
					if(ho.key==src.lasthostile)
						jerk=ho

			if(jerk && jerk!=src)
				if(!jerk.faction || !src.faction || (jerk.faction.village!=src.faction.village)||jerk.faction.village=="Missing")
					world<<"<span class='death_info'><span class='name'>[src.realname]</span> has been killed by <span class='name'>[jerk.realname]</span>!</span>"
					if(!same_client(jerk, src))
						jerk.bounty+=round(10+src.blevel*3)/3
						if(jerk.squad)
							for(var/mob/human/m in jerk.squad.online_members - jerk)
								if(get_dist(jerk, m) > 25)
									continue
								if(m.MissionType == "Maraud" && (faction && faction.village == m.MissionTarget) && RankGrade2() >= 2)
									var/credits = RankGrade2() - 1
									m.MissionCredit += credits
									m << "<strong>+[credits]</strong> Credits"
									if(m.MissionCredit >= 10)
										m.MissionComplete()

								if(src==m.MissionTarget && (m.MissionType=="Assasinate Player PvP" || m.MissionType == "Rendezvous (Intercept)" || m.MissionType == "Maraud(Intercept)"))
									m.MissionComplete()

					if(jerk.MissionType == "Maraud" && (faction && faction.village == jerk.MissionTarget) && RankGrade2() >= 2)
						var/credits = RankGrade2() - 1
						jerk.MissionCredit += credits
						jerk << "<strong>+[credits]</strong> Credits"
						if(jerk.MissionCredit >= 10)
							jerk.MissionComplete()

					if(src==jerk.MissionTarget && (jerk.MissionType=="Assasinate Player PvP" || jerk.MissionType == "Rendezvous (Intercept)" || jerk.MissionType == "Maraud(Intercept)"))
						jerk.MissionComplete()


					if(jerk.faction/* && jerk.faction.village=="Missing"*/ && !same_client(jerk, src))
						jerk<<"You gained [src.bounty] dollars for [src.realname]'s bounty!"
						jerk.money+=src.bounty
						src.bounty=0
				else
					world<<"<span class='death_info'><span class='betrayal'><span class='name'><b><u>[jerk.realname]</span> has killed <span class='name'>[src.realname]</span> and they are in the same village!</span></span>"
			else
				world<<"<span class='death_info'><span class='name'>[src]</span> has died!</span>"

proc/clear_kill_log()
	if(fexists("kill_log.sav"))
		fdel("kill_log.sav")
	kill_log = list()

proc/save_kill_log()
	if(kill_log.len)
		var/savefile/f = new("kill_log.sav")
		f << kill_log

proc/load_kill_log()
	if(fexists("kill_log.sav"))
		var/savefile/f = new("kill_log.sav")
		f >> kill_log

world/New()
	..()
	load_kill_log()

world/Del()
	save_kill_log()
	..()

var/global/kill_log[] = list()

mob
	proc
		valid_kill(mob/killed)
			if(!global.kill_log[realname])
				global.kill_log[src.realname] = list()
			if(global.kill_log[src.realname][killed.realname] >= 3)
				return 0
			if(same_client(src, killed))
				return 0
			global.kill_log[src.realname][killed.realname]++
			return 1

		Killed(mob/owned)
			if(!same_client(owned, src) && src.valid_kill(owned) && owned.faction.village != faction.village)
				var/worth = owned.blevel / (src.blevel * 5)
				owned.kills -= worth
				owned.kills = max(0, owned.kills)
				src.kills += worth
				if(owned != MissionTarget)
					var/gain = 0
					switch(owned.ninrank)
						if("D") gain = 1500
						if("C") gain = 2500
						if("B") gain = 4000
						if("A") gain = 6000
					if(src.squad)
						var/higher_up_boost = 0
						for(var/mob/m in src.squad.online_members)
							if(get_dist(m, src) <= 25)
								switch(m.rank)
									if("Academy Student", "Genin", "Chuunin")
										gain *= 1.1
									else
										if(!higher_up_boost && m.realname == squad.leader)
											higher_up_boost = 1
											gain *= 1.2
						for(var/mob/m in src.squad.online_members - src)
							if(get_dist(m, src) <= 25)
								m.body += gain
								m<<"You have gained [gain] experience points!"
					src.body += gain
					src << "You have gained [gain] experience points!"
					if(hascall(src, "bodycheck"))
						call(src, "bodycheck")()

		Respawn()
			set waitfor = 0
			sleep(30)
			//if(RP)
			//	return
			if(!ko || curwound<maxwound)
				return
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.in_war && faction && (faction.village == Minfo.village_control || faction.village == Minfo.attacking_village))
				if(faction.village == Minfo.village_control)
					++Minfo.defender_deaths
				else if(faction.village == Minfo.attacking_village)
					++Minfo.attacker_deaths

				var/adjacent[0]
				for(var/x in list(Minfo.oX-1, Minfo.oX+1))
					if(x >= 1 && x <= map_coords.len)
						var/obj/mapinfo/map = map_coords[x][Minfo.oY+1]
						if(map)
							adjacent += map
				for(var/y in list(Minfo.oY, Minfo.oY+2))
					var/list/map_col = map_coords[Minfo.oX]
					if(y >= 1 && y <= map_col.len)
						var/obj/mapinfo/map = map_col[y]
						if(map)
							adjacent += map

				var/controlled_maps[0]
				for(var/obj/mapinfo/map in adjacent)
					if(map.village_control == faction.village)
						controlled_maps += map
				if(controlled_maps.len)
					var/turf/new_loc
					while(!new_loc || !new_loc.Enter(src))
						var/obj/mapinfo/map = pick(controlled_maps)
						if(map.oX < Minfo.oX)
							new_loc = locate(1, rand(1, world.maxy), z)
						else if(map.oX > Minfo.oX)
							new_loc = locate(world.maxx, rand(1, world.maxy), z)
						else if(map.oY < Minfo.oY)
							new_loc = locate(rand(1, world.maxx), world.maxy, z)
						else // map.oX == Minfo.oX && map.oY >= Minfo.oY
							new_loc = locate(rand(1, world.maxx), 1, z)
						sleep(-1)
					loc = new_loc
					ko = 0
					curstamina = stamina
					curchakra = chakra
					curwound = 0

					Reset_Stun()
					Reset_Move_Stun()
					Timed_Stun(10)
					for(var/obj/trigger/kawarimi/T in triggers)
						RemoveTrigger(T)

					var/mob/killer = null
					for(var/mob/M in world)
						if(M.client)
							if(M.key == lasthostile)
								killer = M
								break
					if(killer)
						world<<"<span class='death_info'><span class='name'>[src.realname]</span> has been killed by <span class='name'>[killer.realname]</span>!</span>"
						killer<<"Gained a Faction Point"
						killer.factionpoints++
						killer.Killed(src)

			else if(src.rank!="Academy Student")
				new/mob/corpse(src.loc,src)
				//src.stunned=2
				Timed_Stun(20)
				var/mob/jerk=0
				for(var/mob/ho in world)
					if(ho.client)
						if(ho.key==src.lasthostile)
							jerk=ho
				if(jerk)
					jerk.Killed(src)
				src.relieve_bounty()
				if(Minfo)
					Minfo.PlayerLeft(src)
				var/Re=0
				for(var/obj/Respawn_Pt/R in world)
					if(faction)
						switch(faction.village)
							if("Konoha")
								if(R.ind == 1)
									Re = R
									break
							if("Suna")
								if(R.ind == 2)
									Re = R
									break
							if("Kiri")
								if(R.ind == 3)
									Re = R
									break
							else
								if(R.ind == 0)
									Re = R
									break
					else
						if(R.ind == 0)
							Re = R
							break

				var/foundbed=0
				if(Re)
					var/list/pfrom=new
					for(var/obj/interactable/hospitalbed/o in oview(15,Re))
						pfrom+=o

					var/obj/interactable/hospitalbed/F=0
					F=pick(pfrom)
					if(F && istype(F))
						foundbed=1
						src.loc=F.loc
						Minfo = locate("__mapinfo__[z]")
						if(Minfo)
							Minfo.PlayerEntered(src)
						src.icon_state="hurt"
						F.Interact(src)

				if(!foundbed)
					var/obj/interactable/hospitalbed/o = locate(/obj/interactable/hospitalbed) in world
					src.loc=o.loc
					Minfo = locate("__mapinfo__[z]")
					if(Minfo)
						Minfo.PlayerEntered(src)
					src.icon_state="hurt"
					o.Interact(src)

				src.curstamina=1
				src.curwound=src.maxwound-1
				src.waterlogged=0
				src.swamplogged=0
				src<<"You have woken up in a hospital bed, you should rest here until your wounds are gone."
				//src.stunned=2
				Timed_Stun(20)
			else
				if(Minfo)
					Minfo.PlayerLeft(src)
				src.loc=locate(10,91,3)
				Minfo = locate("__mapinfo__[z]")
				if(Minfo)
					Minfo.PlayerEntered(src)
				src.curwound=0
				src.curstamina=src.stamina

				src.waterlogged=0
				src.swamplogged=0
				src.curstamina=src.stamina

				Reset_Stun()
/*mob
	EZ
		verb
			EZ_Remove_Flag()
				if(usr.ezing)
					usr.Show_reCAPTCHA()

				usr.verbs-=/mob/EZ/verb/EZ_Remove_Flag
				winset(usr, "ez_remove_verb", "parent=")*/
var
	wregenlag=1



mob/human
	proc
		KO()
			if(ko) return
			if(istype(src, /mob/human/player/npc) && src:lasthurtme)
				var/mob/attacker = src:lasthurtme
				if(attacker && attacker.client)
					attacker.ez_count = 0
					attacker.ez_immune = 30
			else if(client)
				for(var/mob/m in ohearers(10, src))
					if(m.key == lasthostile)
						m.ez_count = 0
						m.ez_immune = 30

			ez_count = 0
			ez_immune = 60
			if(!pk)
				curstamina = stamina
				curwound = 0

			else if(gate >= 4)
				src.Wound(rand(27,33),3)
				src.curstamina=src.stamina * ((maxwound-curwound)/maxwound)
				src.curchakra=max(round(src.chakra/4), curchakra)

			else
				if(src.pill>=2)
					src.overlays-='icons/Chakra_Shroud.dmi'
					src.strbuff=0
					src.conbuff =0
					src.pill=0
					src.combat("The effects from the pill(s) wore off.")
					for(var/skill/akimichi/curry_pill/currypill in skills)
						currypill.DoCooldown(src,0,300)

				src.Poison=0
				src.Wound(rand(27,33),3)
				src.ko=1

				sleep(10)

				flick("Knockout",src)

				src.icon_state="Dead"
				src.layer=TURF_LAYER

				for(var/obj/items/Heavenscroll/II in src.contents)
					II.Drop()
				for(var/obj/items/Earthscroll/EI in src.contents)
					EI.Drop()

				var/maxwound1=100
				if(clan == "Will of Fire")
					maxwound1=130
				else if(clan == "Jashin")
					maxwound1=150
					if(immortality)
						maxwound1=300

				if(src.curwound<maxwound1||(src.immortality&&src.cexam!=5))
					sleep(src.curwound + 100)
					if(src.ko && src.curwound<300)
						if(clan == "Will of Fire")
							src.curstamina=src.stamina
							if(curwound >= 100)
								src.curstamina=src.stamina*1.25
								src.curchakra=src.chakra*1.25
							if(skillspassive[ENDURANCE])
								curstamina *= 1 + 0.03 * skillspassive[ENDURANCE]
						else
							var/durr=((maxwound-curwound)/maxwound)/2
							if(durr<0)
								durr=0
							src.curstamina=src.stamina * durr + src.stamina/2
							if(skillspassive[ENDURANCE])
								curstamina *= 1 + 0.03 * skillspassive[ENDURANCE]
						if(src.curchakra<src.chakra/5)
							src.curchakra=src.chakra/5 +20

					//if(clan == "Will of Fire")
					//	combat("The Will of Fire burns within you..!")
					//	WOF_adrenaline()
					//src.protected=3
					Protect(30)
					Reset_Stun()
					//Reset_Move_Stun()
					movepenalty = round(movepenalty * 0.6)
					//src.stunned=0
					src.ko=0
					src.icon_state=""
					combat_flag(DEFENSE_FLAG, time = 120)
				else
					Die()

		Die()
			if(cexam == 5)
				src.curwound=0
				src.curstamina=src.stamina
				src.curchakra=src.chakra

				src.cexam=4
				src.inarena=0
				src.CArena()

			else if(inarena)
				world<<"<font color=Blue size= +1>[src] Has lost!</font>"
				src.inarena=0
				src.curwound=0
				src.curstamina=src.stamina
				src.curchakra=src.chakra
				if(src.oldx &&src.oldy && src.oldz)
					src.loc=locate(src.oldx,src.oldy,src.oldz)
					src.oldx=0
					src.oldy=0
					src.oldz=0

			else if(dojo)
				var/ei=0
				var/dist=1000
				var/obj/SPWN=0
				for(var/obj/dojorespawn/Dj in world)
					if(Dj.z==src.z)
						if(get_dist(Dj,src)<dist)
							dist=get_dist(Dj,src)
							SPWN=Dj
				var/obj/dojorespawn/Respawn=SPWN

				ei+=5
				if(Respawn)
					src.curwound=0
					src.loc=locate(Respawn.x,Respawn.y-1,Respawn.z)
				else
					src.curwound=0
				Reset_Move_Stun()
				src.curwound=0
				src.curstamina = 1
				src<<"You were Defeated"

			else
				for(var/mob/human/Xe in world)
					if(Xe.Contract2==src)
						if(Xe.Contract)
							Xe.Contract.loc = null
							Xe.Contract = null
						Xe.Contract2=0
						Xe.Affirm_Icon()
				if(!RP)
					src<<"You're wounded beyond your limit, to respawn at a hospital press Space. If you are not brought back to life in 60 seconds you'll automatically respawn."
					var/count=0

					while(curwound>=maxwound)
						//src.stunned=1000
						if(!stunned) Begin_Stun()
						count++
						if(count > 60)
							src.Respawn()
							break
						sleep(10)


		GateStress()
			if(gate)
				var/stress=0

				switch(gate)
					if(1)
						stress = 65
					if(2)
						stress = 80
					if(3)
						stress = 140
					if(4)
						stress = 175
					if(5)
						stress = 250

				gatestress += stress / str * 100 * wregenlag

				var/wound_stress = 150
				if(clan == "Youth")
					wound_stress = 300

				while(gatestress > wound_stress)
					gatestress -= wound_stress
					/*if(gate < 4)
						Dec_Stam(100, 3, src)
					else
						Wound(1,3)*/

				gatetime+=1 * wregenlag

				var/overgated = 0
				if((clan != "Youth" && gatetime>600) || gatetime>1200)
					overgated = 1

				if(overgated)
					Wound(300,3)
					CloseGates()
					src<<"The stress from the gates have taken a significant toll on your body."
					Hostile(src)

	/*	comboregen()
			set background = 1
			set waitfor = 0
			while(1)
				if(c)
					var/lc=c
					sleep(30)
					if(c==lc)
						c=0
				sleep(10)*/

		regeneration2()
			set background = 1
			set waitfor = 0
			while(src)
				while(!initialized)
					sleep(3)
				if(immortality)
					immortality-=0.1
					if(immortality<0)
						immortality=0
				if(!client)
					sleep(50)
				//if(!EN[13])
				//	sleep(300)
				//	regeneration2()
				//	return
				if(!pk || !client)
					sleep(10)

					kstun-=1

					cc-=10
					attackbreak-=40
				else
					if(kstun)
						kstun-=0.10

					if(cc)
						cc--
					if(attackbreak)
						attackbreak-=2

				double_xp_time = max(0, double_xp_time - 0.1)
				triple_xp_time = max(0, triple_xp_time - 0.1)

				if(kstun<0)
					src.kstun=0

				if(cc<0)
					cc=0
				if(attackbreak<0)
					attackbreak=0
				sleep(1)


		regeneration()
			set background = 1
			set waitfor = 0

			while(src)
				while(!initialized)
					sleep(3)

				if(client && client.inactivity > 6000 && !(ckey in admins)) //10 minutes
					src << "You were booted for inactivity."
					client.SaveMob()
					del(client)
					return

				if(Tank)
					step(src,dir)

				if(!client)
					sleep(50)

				var/regenlag=wregenlag


				sleep(10 *regenlag)
				strbuff-=src.astrbuff
				rfxbuff-=src.arfxbuff
				conbuff-=src.aconbuff
				astrbuff=0
				arfxbuff=0
				aconbuff=0

				if(pill==1)
					if(prob(10))
						src.Wound(1,3)
					strbuff=round(src.str * 0.30)
					conbuff=round(src.con * 0.10)

				else if(pill==2)
					if(prob(25))
						Wound(1,3)
					strbuff=round(src.str * 0.60)
					conbuff=round(src.con * 0.30)


				curchakra = min(chakra*3, curchakra)

				if(scalpol)
					scalpoltime = min(10, scalpoltime + 1*regenlag)
				if(alertcool)
					alertcool = max(0, alertcool - 1*regenlag)
				if(MissionCool)
					MissionCool = max(0, MissionCool - 1*regenlag)

				strbuff = max(0, strbuff)
				rfxbuff = max(0, rfxbuff)
				intbuff = max(0, intbuff)
				conbuff = max(0, conbuff)
				Poison = max(0, min(100, Poison))
				adren = min(100, adren)

				if(adren)
					if(strbuff<round(str*adren/200))
						astrbuff=round(str*(adren/200))-strbuff
						strbuff+=astrbuff
					if(rfxbuff<round(rfx*(adren/200)))
						arfxbuff=round(rfx*(adren/200))-rfxbuff
						rfxbuff+=arfxbuff
					if(conbuff<round(con*(adren/200)))
						aconbuff=round(con*(adren/200))-conbuff
						conbuff+=aconbuff
					if(prob(33))
						adren-=1*regenlag

				//if(stunned>300 && !pk)
				//	stunned=0

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

				if(!pk)
					nopktime++
				else
					nopktime=0


				if(movepenalty)
					if(!pk)
						movepenalty=0
					else if(prob(33))
						movepenalty-=5
						if(movepenalty<0)
							movepenalty=0

				if(clan == "Will of Fire")
					maxwound=130
				else if(clan == "Jashin")
					maxwound=150

				if(client)
					if(!client.eye)
						client.eye=client.mob

					if(controlmob || tajuu)
						for(var/obj/gui/skillcards/interactcard/x in client.screen)
							x.icon_state="ibunshindispell"
					else
						for(var/obj/gui/skillcards/interactcard/x in client.screen)
							if(x.icon_state=="ibunshindispell")
								x.icon_state="interact0"

					if(MissionTimeLeft > 0)
						MissionTimeLeft--
						if(MissionTimeLeft <= 0)
							MissionFail()
							alert(src,"You ran out of time!")

					if(cexam==5)
						if(!pk)
							cexam=4

							world<<"<span class='chuunin_exam'>[src] ran out of the match!</span>"

							curwound=0
							curstamina=src.stamina
							curchakra=src.chakra
							CArena()

					if(chuuninwatch && !haschuuninwatch)
						verbs+=/mob/Chuunin/verb/Watch_Fight_Chuunin
						winset(src, "chuunin_menu", "parent=menu;name=\"&Chuunin Exam\"")
						winset(src, "chuunin_verb_watch", "parent=chuunin_menu;name=\"&Watch Fight\";command=Watch-Fight-Chuunin")
						haschuuninwatch=1
					else if(haschuuninwatch && !chuuninwatch)
						verbs-=/mob/Chuunin/verb/Watch_Fight_Chuunin
						winset(src, "chuunin_menu", "parent=")
						winset(src, "chuunin_verb_watch", "parent=")
						haschuuninwatch=0

					if(cexam)
						verbs+=/mob/Chuunin/verb/Leave_Exam
						winset(src, "chuunin_menu", "parent=menu;name=\"&Chuunin Exam\"")
						winset(src, "chuunin_verb_leave", "parent=chuunin_menu;name=\"&Leave Exam\";command=Leave-Exam")
					else if(rank == "Genin" && chuuninreg)
						winset(src, "chuunin_menu", "parent=menu;name=\"&Chuunin Exam\"")
						winset(src, "chuunin_verb_join", "parent=chuunin_menu;name=\"&Enter Exam\";command=Join-Chuunin")
						verbs+=/mob/Chuunin/verb/Join_Chuunin

					if(tourney && !has_tourney_verbs)
						verbs+=typesof(/mob/Tourney/verb)
						winset(src, "tourney_menu", "parent=menu;name=\"&Tournament\"")
						winset(src, "tourney_verb_check", "parent=tourney_menu;name=\"&Check Registered Fighters\";command=Check-Registered-Fighters")
						winset(src, "tourney_verb_watch", "parent=tourney_menu;name=\"&Watch Fight\";command=Watch-Fight")
						has_tourney_verbs=1
					else if(!tourney && has_tourney_verbs)
						verbs-=typesof(/mob/Tourney/verb)
						winset(src, "tourney_verb_watch", "parent=")
						winset(src, "tourney_verb_check", "parent=")
						winset(src, "tourney_menu", "parent=")
						has_tourney_verbs=0

				/*if(protected)
					protected-=1*regenlag
					if(protected<=0)
						protected=0*/

				if(!pk && gate)
					CloseGates()

				if(client || RP)
					if(!pk&&!AFK&&curstamina>=stamina && curchakra>=src.chakra && client.inactivity >= 600)
						AFK=1

					if(pk||(AFK && client.inactivity <600))
						AFK=0

					if(!pk&&!AFK2&&curstamina>=stamina && curchakra>=chakra)
						AFK2=1

					if(pk)
						AFK2=0

					if(usedelay>0)
						usedelay--
						if(usedelay<0)
							usedelay=0


					if(movedrecently)
						movedrecently--
					if(movedrecently<0)
						movedrecently=0

					if(skillspassive[BOMBARDMENT])
						maxsupplies=100 + 20*skillspassive[BOMBARDMENT]
					else
						maxsupplies=100

					var/maxwound1=100
					var/maxwound2=200
					if(clan == "Will of Fire")
						maxwound1=130
						maxwound2=230
					else if(clan == "Jashin")
						maxwound1=150
						maxwound2=250
						if(immortality)
							maxwound1=300
							maxwound2=99999

					if(curwound>(maxwound1*1.5)&& (gate))
						CloseGates()
				/*	if(curwound>(maxwound1*1.5) && pill >= 2)
						src.overlays-='icons/Chakra_Shroud.dmi'
						src.strbuff=0
						src.pill=0
						src.combat("The effects from the pill(s) wore off.")
						src.curstamina = 0
						for(var/skill/akimichi/curry_pill/currypill in skills)
							currypill.DoCooldown(src,0,300)*/

					if(curwound>=maxwound2 && !immortality)
						curstamina=0

					if(curstamina<=0)
						KO()

					//if(client.computer_id in DeathList)
					//	return

					if(ko)
						if(curstamina>0)
							//protected=3
							//stunned=0
							Protect(30)
							Reset_Move_Stun()
							Reset_Stun()
							ko=0
							icon_state=""
					//end ko stuff

					if(layer!=MOB_LAYER && !ko &&!incombo)
						sleep(10)
						if(!incombo)
							layer=MOB_LAYER


					/*if(hasbonesword)
						if(boneuses<=0)
							hasbonesword=0
							boneuses=0
							for(var/obj/items/weapons/xox in contents)
								if(istype(xox,/obj/items/weapons/melee/sword/Bone_Sword))
									weapon=new/list

									xox.loc = null
							Load_Overlays()*/

					var/stammultiplier=1
					var/chakramultiplier=1
					if(clan == "Youth")
						stammultiplier=1.5
						//chakramultiplier=0.5
					else if(clan == "Capacity")
						stammultiplier=1.25
						chakramultiplier=1.5

					/*if(gate >= 5)
						rfxbuff=src.rfx*0.5
						strbuff=src.str*0.6
					else if(gate>=3)
						rfxbuff=src.rfx*0.5
						strbuff=src.str*0.5
					else if(gate>=1)
						rfxbuff=src.rfx*0.3
						strbuff=src.str*0.3*/

					if(clan == "Will of Fire" && ((curwound / 100) * 100) >= 25)
						var/boost_multiplier = 1

						//for(var/i in 1 to curwound step 25)
						//	boost_multiplier++
						for(var/i = (curwound - 25); i >= 25; i -= 25)
							boost_multiplier++

						boost_multiplier = min(4, boost_multiplier)

						strbuff = round(str * (0.0625 * boost_multiplier))
						rfxbuff = round(rfx * (0.0625 * boost_multiplier))
						conbuff = round(con * (0.0625 * boost_multiplier))
						intbuff = round(int * (0.0625 * boost_multiplier))

					/*if(gate)
						GateStress()
					else
						if(gatetime)
							gatetime-=regenlag
						if(gatetime<=0)
							gatetime=0*/

					var/cmul=1
					var/smul=1
					if(skillspassive[REGENERATION])
						cmul*=0.06*skillspassive[REGENERATION] + 1
						smul*=0.06*skillspassive[REGENERATION] + 1

					if(soldierpillboost > world.time)
						smul *= 1.5//1.2

					if(gentle_fist_block)
						if(gentle_fist_timestamp + 100 < world.time)
							gentle_fist_block = max(0, --gentle_fist_block)
						gentle_fist_block = min(40, gentle_fist_block)
						cmul *= 1-(gentle_fist_block*0.01)

					if(boneharden)
						cmul *= 0.65

					if(gate < 3)
						stamina=2000+(blevel*25 +(str+strbuff+strneg)*13)*stammultiplier
						chakra=(500 + (con+conbuff+conneg)*5)*chakramultiplier
					else
						stamina=2000+(blevel*25 +(str+strbuff+strneg)*18)*stammultiplier
						chakra=(500 + (con+conbuff+conneg)*7)*chakramultiplier

					/*if(pill == 1)
						//chakra *= 1.1
						cmul *= 1.25
						//smul *= 1.10
					else if(pill == 2)
						//chakra *= 1.3
						cmul *= 1.5
						//smul *= 1.25
*/

					chakraregen = round(cmul*(chakra*1.5)/100)
					//chakraregen = round(cmul * ((chakra * 0.6) / 100 + (blevel * 0.4)))
					//chakraregen = round(((con + conbuff - conneg - 50) / 10) * cmul)
					staminaregen=round(smul*stamina/100)

					if(skillspassive[POWERHOUSE])
						chakra *= 1 + skillspassive[POWERHOUSE] * 0.02
					if(skillspassive[ENDURANCE])
						stamina *= 1 + skillspassive[ENDURANCE] * 0.02

					if(chakrablocked>0)
						chakraregen=0
						chakrablocked-=1*regenlag
						if(chakrablocked<0)
							chakrablocked=0



					if(asleep)
						icon_state="Dead"


					/*waterlogged=0

					for(var/obj/Water/x in loc)
						waterlogged=1
					for(var/turf/water/x in loc)
						waterlogged=1

					if(!waterlogged)
						waterlogged=Iswater(x, y, z)

					if(waterlogged)
						var/obj/haku_ice/ice = locate(/obj/haku_ice) in loc
						if(ice)
							waterlogged = 0
							//chakraregen *= 0.75
					*/

					if(waterlogged&&!protected)
						if(curchakra<15)
							curstamina=0

					if(!paralysed && !incombo)
						layer=MOB_LAYER
					if(maned && !stunned)
						Timed_Stun(10)
						//if(stunned<2)
						//	stunned=3

					var/missregen=0

					if(Poison)
						if(prob(50))
							missregen=1

					if(client && client.inputting)
						missregen=1

					if(!missregen)
						var/r = 10//(blevel >= 20) ? (5) : (10)
						if(risk == 1)
							r += 2
						else if(risk >= 2)
							r += 5
						else if(risk >= 3)
							r += 10
						else if(risk >= 4)
							r += 15
						if(dominating_faction == faction.village)
							r += 5
						if(double_xp_time)r *= 2
						if(triple_xp_time)r *= 3
						/*var/r = 5
						if(risk == 1)
							r += 4
						else if(risk > 1)
							r += 7

						if(src.blevel<20)
							r=max(10,r)*/

						if((curwound < maxwound || immortality) && !ko && !mane && !maned && !waterlogged  && !RP)
							if(curchakra < chakra)
								if(chakraregen*regenlag > (chakra-curchakra))
									curchakra= chakra
								else
									curchakra += chakraregen*regenlag
									if(nopktime<100)
										if(!ezing)body+=r*regenlag*lp_mult
										bodycheck()

								if(clan == "Capacity" && curstamina<stamina)
									curstamina += (staminaregen * 0.25) * regenlag

							else if(curstamina<stamina)
								if((staminaregen)*regenlag > (stamina-curstamina))
									curstamina=stamina
								else
									curstamina+=staminaregen*regenlag
									if(!ezing)body+=r*regenlag*lp_mult
									bodycheck()

					if(Poison)
						var/poison_multiplier = 1
						if(clan == "Battle Conditioned")
							Poison = 0
						else
							curchakra -= round(Poison / 2 * poison_multiplier) * regenlag
							curstamina -= round(Poison * poison_multiplier) * regenlag

							++Recovery
							if(Recovery >= 2)
								Recovery = 0
								Poison -= 1 * regenlag

					refresh_rank()




mob
	proc/get_ninja_grade()
		. = 0
		. += min(70, blevel)
		. += max(0, round((src.kills) / 3 * 30))
		. = round(.)

mob/human/player/verb
	Check_Ninja_Report_Card()
		refresh_rank()
		var/grade = get_ninja_grade()
		usr << "Level Grade: <b>[blevel]</b>/100"
		usr << "Faction Points: [src.factionpoints]"
		usr << "Kill/Death Ratio Grade: [src.kills]/3.0"
		usr << "Total Grade <b>[grade]</b>%/100%"
		if(usr.faction && usr.faction.village != "Missing")
			usr << "Note that your Faction Rank (Genin, Chuunin etc) will effect what percent is required for each letter grade."
		usr << "Current Rank: [ninrank]"

mob/proc/refresh_rank()
	set waitfor = 0
	var/r="D"
	var/grade = get_ninja_grade()
	var/pos=RankGrade() //1-5
	//grade+=min(70,blevel)//min(60,round(src.blevel/80 *60)) //60% of grade based on level
//	grade+=min(10,round(src.factionpoints/500 *10)) //10% of grade based on factionpoints

	//grade+=min(30,round((src.kills))/3 * 30)) //30% based on kill2deaths
	if(pos==1 && grade>30 || pos==2 && grade>20 || pos==3 && grade>17 || pos==4 && grade>15 ||pos==5 && grade>10)
		r="C"
	if(pos==1 && grade>60 || pos==2 && grade>40 || pos==3 && grade>35 || pos==4 && grade>30 ||pos==5 && grade>27)
		r="B"
	if(pos==1 && grade>85 || pos==2 && grade>80 || pos==3 && grade>75 || pos==4 && grade>70 ||pos==5 && grade>65)
		r="A"
	//if(pos==1 && grade>98 || pos==2 && grade>95 || pos==3 && grade>93 || pos==4 && grade>89 ||pos==5 && grade>85)
	if(grade >= 100)
		r = "S"
	src.ninrank=r
var/global/record[] = list()
var/r = 0
mob
	verb/viewr()
		for(var/a in record)
			world << "level [a] total exp: [record[a]]"
mob
	MasterdanVerb
		verb
			Set_Level(mob/human/player/M in All_Clients(), level as num)
				level = min(100, level)
				//M.blevel=1
				//r=0
				while(M && M.blevel < level)
					//r += Req2Level(M.blevel)
					//global.record["[M.blevel]"] = r
					M.body=Req2Level(M.blevel)//+1
					M.bodycheck()
					sleep(2)
				usr<<"Complete!"

var/lp_mult=1
mob/human
	proc
		bodycheck()
			if(src.body>=Req2Level(src.blevel) && blevel < 100)
				var/rollover_exp = 0 + (src.body - Req2Level(src.blevel))
				src.body = rollover_exp
				src.blevel++

				if(src.blevel==20)
					src<<"<b><font color=#fff>Now that you are past level 20, you will gain lower level points by training in the dojo. To level up the fastest you need to fight enemy ninja!</font></b>"

				if(src.blevel==100)
					src<<"<b><font color=#fff>You have reached the level cap!</font></b>"

				var/all_helpers = list()
				for(var/village in helpers)
					all_helpers += helpers[village]

				/*if(src.blevel >= 20 && (src in newbies) && !(src.name in all_helpers) && !(ckey in admins))
					newbies -= src
					verbs -= /mob/human/player/newbie/verb/NOOC
					winset(src, "nooc_button", "is-visible=false")
					if(winget(src, "default_input", "command") == "NOOC")
						winset(src, "default_input", "command=Say")
						winset(src, "nooc_button", "is-checked=false")
						winset(src, "say_button", "is-checked=true")*/

				src.levelpoints+=6

				src.Refresh_Levelpoints()
				src.Refresh_Skillpoints()

proc
	Req2Level(l)
		if(l in 1 to 50)
			return round(l * l * 25 + 1000, 100)
		else
			var/mult = 25 + (l - 50)
			mult = min(mult, 40)
			return round((l * l * mult + 100)*1.5, 100)