skill
	medic
		face_nearest = 1
		heal
			id = MEDIC
			name = "Medical: Heal"
			icon_state = "medical_jutsu"
			default_chakra_cost = 60
			default_cooldown = 5
			var/tmp/wounds_healed=0

			Use(mob/user)
				var/mob/human/player/etarget = user.NearestTarget()
				if(!etarget)
					for(var/mob/human/M in get_step(user,user.dir))
						etarget=M
						break

				if(etarget&&(etarget in oview(user,1)))
					var/turf/p=etarget.loc
					user.icon_state="Throw2"

					//user.stunned=2
					user.usemove=1
					user.Timed_Stun(20)
					var/heal_loc = user.loc
					sleep(20)
					if(etarget && etarget.x==p.x && etarget.y==p.y && user && user.loc == heal_loc && user.usemove)
						etarget.overlays+='icons/base_chakra.dmi'
						sleep(3)
						if(!etarget)
							return
						user.icon_state=""
						etarget.overlays-='icons/base_chakra.dmi'

						//if(etarget.gate >= 4)
						//	user.combat("Heal is not effective on [etarget]!")
						//	return

						var/conroll=rand(1,2*(user.con+user.conbuff-user.conneg))
						var/woundroll=rand(round((etarget.curwound)/3),(etarget.curwound))
						if(conroll>woundroll && woundroll)
							var/effect=round(conroll/(woundroll))//*pick(1,2,3)
							if(user.skillspassive[MEDICAL_TRAINING])effect*=(1 + 0.2*user.skillspassive[MEDICAL_TRAINING])
							if(effect>etarget.curwound)
								effect=etarget.curwound

							var/old_wound = etarget.curwound
							etarget.curwound-=effect
							if(old_wound >= etarget.maxwound && etarget.curwound < etarget.maxwound)
								etarget.curstamina = etarget.stamina * 0.1
							user.combat("Healed [etarget] [effect] Wound")
							if(etarget.curwound<=0)
								etarget.curwound=0
							var/obj/mapinfo/m = locate("__mapinfo__[user.z]")
							if(m && m.in_war)
								wounds_healed += effect
								if(wounds_healed >= 100)
									wounds_healed -= 100
									user << "You gained a Factionpoint."
									user.factionpoints++
						else
							user.combat("You failed to do any healing!")
					user.icon_state=""




		poison_mist
			id = POISON_MIST
			name = "Medical: Poison Mist"
			icon_state = "poisonbreath"
			default_chakra_cost = 420
			default_cooldown = 60



			Use(mob/human/user)
				var/mox=0
				var/moy=0
				//user.icon_state="Seal"
				user.set_icon_state("Seal", 50)
				if(user.dir==NORTH)
					moy=1
				if(user.dir==SOUTH)
					moy=-1
				if(user.dir==EAST)
					mox=1
				if(user.dir==WEST)
					mox=-1
				if(!mox&&!moy)
					return
				//user.stunned=10
				user.Begin_Stun()

				var/list/smogs=new()
				var/flagloc

				/*spawn()
					while(user && poisoning)
						var/list/poi=new()
						for(var/obj/XQ in smogs)
							for(var/mob/human/player/MA in view(0,XQ))
								if(!poi.Find(MA))
									poi+=MA
						for(var/mob/PP in poi)
							var/PEn0r=1 + round(1*user.ControlDamageMultiplier())
							if(PEn0r>5)
								PEn0r=5
							if(PP.protected || PP.ko)
								PEn0r=0
							PP.Poison+=PEn0r
							if(PP.bleeding && user.skillspassive[OPEN_WOUNDS])
								var/stamina_dmg = 10 * user.skillspassive[OPEN_WOUNDS]
								if(user.skillspassive[MEDICAL_TRAINING])
									stamina_dmg *= 1 + 0.05 * user.skillspassive[MEDICAL_TRAINING]
								PP.Dec_Stam(stamina_dmg, 0, user)
								PP.Poison += round(user.skillspassive[OPEN_WOUNDS] / 2)
							if(PP.movepenalty<20)
								PP.movepenalty=25
							PP.Hostile(user)

						sleep(3)*/

				flagloc=locate(user.x+mox,user.y+moy,user.z)

				//spawn()
				var/obj/Poison_Poof/S1=new/obj/Poison_Poof(flagloc, user)
				var/obj/Poison_Poof/S2=new/obj/Poison_Poof(flagloc, user)
				var/obj/Poison_Poof/S3=new/obj/Poison_Poof(flagloc, user)
				var/obj/Poison_Poof/S4=new/obj/Poison_Poof(flagloc, user)
				var/obj/Poison_Poof/S5=new/obj/Poison_Poof(flagloc, user)
				smogs.Add(S1,S2,S3,S4,S5)
				/*smogs+=S1
				smogs+=S2
				smogs+=S3
				smogs+=S4
				smogs+=S5*/
				if(mox==1||mox==-1)
					if(S1)S1.Spread(5*mox,6,192,smogs)
					if(S2)S2.Spread(6.5*mox,4,192,smogs)
					if(S3)S3.Spread(8*mox,0,192,smogs)
					if(S4)S4.Spread(5*mox,-6,192,smogs)
					if(S5)S5.Spread(6.5*mox,-4,192,smogs)
				else
					if(S1)S1.Spread(6,5*moy,192,smogs)
					if(S2)S2.Spread(4,6.5*moy,192,smogs)
					if(S3)S3.Spread(0,8*moy,192,smogs)
					if(S4)S4.Spread(-6,5*moy,192,smogs)
					if(S5)S5.Spread(-4,6.5*moy,192,smogs)

				sleep(5)
				flagloc=locate(user.x+mox*2,user.y+moy*2,user.z)
				var/obj/Poison_Poof/S6=new/obj/Poison_Poof(flagloc, user)
				var/obj/Poison_Poof/S7=new/obj/Poison_Poof(flagloc, user)

				var/obj/Poison_Poof/S8=new/obj/Poison_Poof(flagloc, user)
				var/obj/Poison_Poof/S9=new/obj/Poison_Poof(flagloc, user)
				smogs.Add(S6,S7,S8,S9)
				/*smogs+=S1
				smogs+=S2

				smogs+=S4
				smogs+=S5*/
				if(mox==1||mox==-1)
					if(S6)S6.Spread(5*mox,6,160,smogs)
					if(S7)S7.Spread(6.5*mox,4,160,smogs)
					if(S8)S8.Spread(5*mox,-6,160,smogs)
					if(S9)S9.Spread(6.5*mox,-4,160,smogs)
				else
					if(S6)S6.Spread(6,5*moy,160,smogs)
					if(S7)S7.Spread(4,6.5*moy,160,smogs)
					if(S8)S8.Spread(-6,5*moy,160,smogs)
					if(S9)S9.Spread(-4,6.5*moy,160,smogs)

				sleep(35)
				if(user)
					//user.stunned=0
					user.End_Stun()
					user.icon_state=""



		chakra_scalpel
			id = MYSTICAL_PALM
			name = "Medical: Chakra Scalpel"
			icon_state = "mystical_palm_technique"
			default_chakra_cost = 100
			default_cooldown = 90

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.stance)
						Error(user, "Exit your stance first")
						return 0

			ChakraCost(mob/user)
				if(!user.scalpol)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(!user.scalpol)
					return ..(user)
				else
					return 0


			Use(mob/human/user)
				set waitfor = 0
				if(user.scalpol)
					user.special=0
					user.scalpol=0
					user.weapon=new/list()
					user.Load_Overlays()
					user.scalpoltime=0
					RemoveOverlay('icons/activation.dmi')
					ChangeIconState("mystical_palm_technique")
				else
					AddOverlay('icons/activation.dmi')
					user.combat("Your hands are now equipped with chakra scalpels! This skill will drain your chakra heavily while active. Wait between attacks for a higher chance to critical hit.")
					user.scalpol=1
					user.overlays+='icons/chakrahands.dmi'
					user.special=/obj/chakrahands
					user.removeswords()
					user.weapon=list('icons/chakraeffect.dmi')
					user.Load_Overlays()
					ChangeIconState("mystical_palm_technique_cancel")
					var/reduced_drain = 4 * user.skillspassive[MEDICAL_TRAINING]
					var/regenlag = world.tick_lag
					while(user && user.scalpol && user.curchakra >= 0)
						user.scalpoltime = min(10, user.scalpoltime + 1 * regenlag)
						user.curchakra -= 80 - reduced_drain
						sleep(10)
					if(user && user.scalpol)
						src.Use(user)
						DoCooldown(user)


		cherry_blossom_impact
			id = CHAKRA_TAI_RELEASE
			name = "Medical: Cherry Blossom Impact"
			icon_state = "chakra_taijutsu_release"
			default_chakra_cost = 100
			default_cooldown = 10



			Use(mob/human/user)
				set waitfor = 0
				//user.stunned=1
				user.Timed_Stun(5)
				user.overlays+='icons/sakurapunch.dmi'
				user.combat("Attack Quickly! Your chakra will drain until you attack.")
				sleep(5)
				user.overlays-='icons/sakurapunch.dmi'
				//if(user.stunned<=1)
				//	user.stunned=0
				user.sakpunch=1
				sleep(10)
				while(user && user.sakpunch && user.curchakra>100)
					user.curchakra-=100
					sleep(10)
				if(user) user.sakpunch=0




		body_disruption_stab
			id = IMPORTANT_BODY_PTS_DISTURB
			name = "Medical: Body Disruption Stab"
			icon_state = "important_body_ponts_disturbance"
			default_chakra_cost = 100
			default_cooldown = 180



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 2)
						Error(user, "Target too far ([distance]/2 tiles)")
						return 0


			Use(mob/human/user)
				var/mob/human/player/etarget = user.NearestTarget()
				var/con_roll = Roll_Against((user.con+user.conbuff-user.conneg), (etarget.con+etarget.conbuff-etarget.conneg), 100)
				//var/CX=rand(1,(user.con+user.conbuff-user.conneg))
				//var/Cx=rand(1,(etarget.con+etarget.conbuff-etarget.conneg))
				//if(CX>Cx)
				if(con_roll >= 3)
					user.combat("Nervous system disruption succeeded!")
					etarget.combat("Your nervous system has been attacked, you are unable to control your muscles!")
					etarget.overlays+='icons/disturbance.dmi'
					spawn(20)
						etarget.overlays-='icons/disturbance.dmi'
					etarget.movement_map = list()
					var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
					var/list/dirs2 = dirs.Copy()
					for(var/orig_dir in dirs)
						var/new_dir = pick(dirs2)
						dirs2 -= new_dir
						etarget.movement_map["[orig_dir]"] = new_dir
					spawn(600)
						if(etarget && etarget.movement_map)
							etarget.movement_map = null
				else
					user.combat("Nervous system disruption failed!")




		creation_rebirth
			id = PHOENIX_REBIRTH
			name = "Medical: Creation Rebirth"
			icon_state = "pheonix_rebirth"
			default_chakra_cost = 800
			default_cooldown = 1200
			copyable = 0



			Use(mob/human/user)
				//user.protected=10
				user.Protect(100)
				user.icon_state="hurt"
				user.overlays+='icons/rebirth.dmi'
				//user.stunned+=3
				user.Timed_Stun(30)
				spawn(30)
					user.overlays-='icons/rebirth.dmi'
					user.protected=0
					user.icon_state=""
				sleep(30)
				if(!user.ko)
					var/oldwound=user.curwound
					user.curwound-=100
					if(user.curwound<0)
						user.curwound=0
					var/oldstam=user.curstamina
					user.curstamina=round(user.stamina*1.25)
					user.combat("[oldwound-user.curwound] Wounds and [user.curstamina - oldstam] Stamina healed!")




		poisoned_needles
			id = POISON_NEEDLES
			name = "Medical: Poisoned Needles"
			icon_state = "poison_needles"
			default_supply_cost = 5
			default_cooldown = 60
			face_nearest = 0



			Use(mob/human/user)
				user.icon_state="Throw1"
				//user.stunned=10
				user.Begin_Stun()
				sleep(5)
				var/list/hit=new
				var/oX=0
				var/oY=0
				var/devx=0
				var/devy=0
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					user.dir = angle2dir_cardinal(get_real_angle(user, etarget))
				if(user.dir==NORTH)
					oY=1
					devx=8
				if(user.dir==SOUTH)
					oY=-1
					devx=8
				if(user.dir==EAST)
					oX=1
					devy=8
				if(user.dir==WEST)
					oX=-1
					devy=8
				spawn()
					if(user)
						hit+=advancedprojectile_returnloc(/obj/needle,user,(32*oX),(32*oY),5,100,user.x,user.y,user.z)
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +devx,32*oY + devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +1.5*devx,32*oY + 1.5*devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +-1*devx,32*oY + -1*devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn()
					if(user)
						var/turf/T=advancedprojectile_returnloc(/obj/needle,user,32*oX +-1.5*devx,32*oY + -1.5*devy,5,100,user.x,user.y,user.z)
						for(var/mob/human/mX in locate(T.x,T.y,T.z))
							hit+=mX
				spawn(5)
					if(user)
						//user.stunned=0
						user.End_Stun()
						user.icon_state=""
				spawn(20)
					for(var/mob/human/M in hit)
						spawn()
							if(M && !M.ko && !M.protected && M!=user)
								M.Poison += 2 + (0.2 * M.skillspassive[MEDICAL_TRAINING])//rand(4,8)
								if(M.bleeding && user.skillspassive[OPEN_WOUNDS])
									var/stamina_dmg = 50 * user.skillspassive[OPEN_WOUNDS]
									if(user.skillspassive[MEDICAL_TRAINING])
										stamina_dmg *= 1 + 0.05 * user.skillspassive[MEDICAL_TRAINING]
									M.Damage(stamina_dmg, 0, user, "Poison", "Internal")//M.Dec_Stam(stamina_dmg, 0, user)
									M.poison(user.skillspassive[OPEN_WOUNDS] / 2)//M.Poison += round(user.skillspassive[OPEN_WOUNDS] / 2)
								M.Hostile(user)



mob
	var/tmp/poison_loop = 0

	proc/poison(amount)
		set waitfor = 0
		if(clan == "Battle Conditioned")
			return
		Poison += amount
		if(poison_loop)
			return
		poison_loop = 1
		var/poison_multiplier = 1
		var/regenlag = world.tick_lag
		var/sleeptime = 10 * regenlag
		while(src && Poison > 0)
			curchakra -= round(Poison / 2 * poison_multiplier) * regenlag
			curstamina -= round(Poison * poison_multiplier) * regenlag
			++Recovery
			if(Recovery >= 2)
				Recovery = 0
				Poison -= 1 * regenlag
			sleep(sleeptime)

obj
	chakrahands
		icon='icons/chakrahands.dmi'
		layer=FLOAT_LAYER




	Poison_Poof
		var
			tmp/poisoned[] = list()

		New(location, mob/user)
			set waitfor = 0
			..(location)
			if(!user)
				loc = null
				return
			owner = user

			for(var/mob/m in view(0))
				if(m == owner)
					continue
				poisoned += m

			var/life_time = 80
			while(loc && life_time > 0)
				life_time -= 10

				for(var/mob/m in poisoned)
					if(!m.IsProtected() && !m.ko && m != owner)
						var/PEn0r=1 + round(1 * owner.ControlDamageMultiplier())
						if(PEn0r>5)
							PEn0r=5
						if(m.protected || m.ko)
							PEn0r=0
						m.Poison+=PEn0r
						if(m.bleeding && owner.skillspassive[OPEN_WOUNDS])
							var/stamina_dmg = 10 * owner.skillspassive[OPEN_WOUNDS]
							if(owner.skillspassive[MEDICAL_TRAINING])
								stamina_dmg *= 1 + 0.05 * owner.skillspassive[MEDICAL_TRAINING]
							m.Damage(stamina_dmg, 0, owner, "Poison")//m.Dec_Stam(stamina_dmg, 0, owner)
							m.poison(owner.skillspassive[OPEN_WOUNDS] / 2)//m.Poison += round(owner.skillspassive[OPEN_WOUNDS] / 2)
						if(m.movepenalty<20)
							m.movepenalty=25
						m.Hostile(owner)

				sleep(10)
			if(loc)
				poisoned = null
				owner = null
				loc = null

		Crossed(mob/human/crossed)
			if(!istype(crossed))
				return ..()
			if(!(crossed in poisoned) && crossed != owner)
				poisoned += crossed

		Uncrossed(mob/human/uncrossed)
			if(!istype(uncrossed))
				return ..()
			poisoned -= uncrossed


		Del()
			if(loc == null)
				return ..()
			owner = null
			poisoned = null
			loc = null

		proc
			PixelMove(dpixel_x, dpixel_y, list/smogs)
				var/new_pixel_x = pixel_x + dpixel_x
				var/new_pixel_y = pixel_y + dpixel_y


				while(abs(new_pixel_x) > 16)
					var/kloc = loc
					if(new_pixel_x > 16)
						new_pixel_x -= 32
						var/Phail=0

						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						x++

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc, owner)

					else if(new_pixel_x < -16)
						new_pixel_x += 32

						var/Phail=0
						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						x--

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc, owner)

				while(abs(new_pixel_y) > 16)
					var/kloc = loc
					if(new_pixel_y > 16)
						new_pixel_y -= 32

						var/Phail=0
						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						y++

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc, owner)

					else if(new_pixel_y < -16)
						new_pixel_y += 32

						var/Phail=0
						for(var/obj/Poison_Poof/x in oview(0,src))
							Phail=1
							break

						y--

						if(!Phail)
							smogs+=new/obj/Poison_Poof(kloc, owner)

				pixel_x = new_pixel_x
				pixel_y = new_pixel_y


			Spread(motx,moty,mom,list/smogs)
				set waitfor = 0
				while(mom>0)
					PixelMove(motx/3, moty/3, smogs)
					sleep(1)

					PixelMove(motx/3, moty/3, smogs)
					sleep(1)

					PixelMove(motx/3, moty/3, smogs)
					sleep(1)

					mom -= (abs(motx)+abs(moty))
/*
obj/poisonsmoke
	icon = 'icons/smoke2.dmi'
	icon_state = "poison"
	pixel_x = -32
	pixel_y = -32
	layer = 6.1
	var/tmp/mob/human/muser
	New()
		spawn() while(src.loc != null)
			for(var/mob/M in src.loc)
				if(M != muser && !M.ko && !M.IsProtected())
					M.Poison = max(M.Poison,10) //This is 30 seconds, because you only lose a stack of poison every 3 seconds per old code. I don't see the point of it but I'm leaving it as is. We could just raise these numbers and allow it to lower every second.
					M.Timed_Move_Stun(40)
					M.Hostile(muser)
			sleep(10)
obj/smoke
	icon = 'icons/smoke2.dmi'
	icon_state = "smoke"
	pixel_x = -32
	pixel_y = -32
	layer = 6.1
	mouse_opacity = 0
	var/ignited = 0
	proc
		Ignite(obj/smoke/smoke,turf/aloc)
			if(smoke.ignited) return 0
			smoke.ignited = 1
			smoke.icon_state = ""
			flick("ignition",smoke)
			//snd(src,'sounds/explosion_fire.wav',vol=10)
			var/mob/human/attacker = owner
			for(var/mob/M in loc)
				spawn()
					//M = M.Replacement_Start(attacker)
					//M.Damage(round(rand(1000,2000)+rand(200,300)*attacker.ControlDamageMultiplier()),15,attacker,"Fire: Ash Burning Product","Normal")
					//M.Dec_Stam
					M.Hostile(attacker)
					//spawn(5) if(M) M.Replacement_End()
			spawn()
				for(var/obj/smoke/s in range(10,smoke))
					spawn
						if(!s.ignited)
							if(aloc) s.FaceTowards(aloc)
							s.Ignite(s,aloc)
					//sleep(1)
			spawn()
				for(var/mob/m in view(1,smoke))
					if(m <> owner)
						m.Timed_Stun(40)
			spawn(5) smoke.loc=null

proc/AshSmoke(mob/human/user, dx, dy, dz, direction)
	var/obj/smoke/o = new/obj/smoke(locate(dx, dy, dz))
	o.owner = user
	spawn(120) if(o) o.loc = null
	if(direction == NORTH)
		o.pixel_y -= 16
		o.pixel_x += 0
	else if(direction == SOUTH)
		o.pixel_y += 16
		o.pixel_x += 0
	else if(direction == EAST)
		o.pixel_y += 0
		o.pixel_x -= 16
	else if(direction == WEST)
		o.pixel_y += 0
		o.pixel_x += 16
	spawn(rand(1,4))
		while(o.pixel_y != -32 || o.pixel_x != -32)
			if(o.pixel_y > -32)
				o.pixel_y -= 1
			else if(o.pixel_y < -32)
				o.pixel_y += 1
			if(o.pixel_x > -32)
				o.pixel_x -= 1
			else if(o.pixel_x < -32)
				o.pixel_x += 1
			sleep(rand(1,4))

proc/PoisonSmoke(mob/human/user, dx, dy, dz, direction)
	var/obj/poisonsmoke/o = new/obj/poisonsmoke(locate(dx, dy, dz))
	o.owner = user
	o.muser = user
	spawn(120) if(o) o.loc = null
	if(direction == NORTH)
		o.pixel_y -= 16
		o.pixel_x += 0
	else if(direction == SOUTH)
		o.pixel_y += 16
		o.pixel_x += 0
	else if(direction == EAST)
		o.pixel_y += 0
		o.pixel_x -= 16
	else if(direction == WEST)
		o.pixel_y += 0
		o.pixel_x += 16
	spawn(rand(1,4))
		while(o.pixel_y != -32 || o.pixel_x != -32)
			if(o.pixel_y > -32)
				o.pixel_y -= 1
			else if(o.pixel_y < -32)
				o.pixel_y += 1
			if(o.pixel_x > -32)
				o.pixel_x -= 1
			else if(o.pixel_x < -32)
				o.pixel_x += 1
			sleep(rand(1,4))

mob/verb/Sm()
	if(ckey in admins)
		var/s = input("What radius size?") as num
		var/f = input("How far (1,2,3)?") as num
		var/t = input("What type (ash, poison)?")
		SmokeSpread(usr.loc, type=t, size=s, delay=2, far=f)

proc/SmokeSpread(turf/source, type=0, size=3, delay=2, far=3)
	var/direction
	if(usr.dir == NORTHEAST || usr.dir == SOUTHEAST)
		direction = EAST
	else if(usr.dir == NORTHWEST || usr.dir == SOUTHWEST)
		direction = WEST
	else
		direction = usr.dir

	var/obj/L = new/obj(source)
	L.dir = direction
	var/obj/C = new/obj(source)
	C.dir = direction
	var/obj/R = new/obj(source)
	R.dir = direction

	var/length = size*2+1
	var/threshold1 = round(length*0.66)
	var/firstin1 = 1
	var/threshold2 = round(length*0.33)
	var/firstin2 = 1
	var/threshold3 = length*0
	var/firstin3 = 1

	var/min = 0
	switch(far)
		if(1) min = threshold1
		if(2) min = threshold2
		if(3) min = threshold3

	while(length>min)
		if(length>threshold1 && far>=1)
			if(firstin1)
				L.dir = turn(L.dir,45)
				R.dir = turn(R.dir,-45)
				firstin1=0
		else if(length>threshold2 && far>=2)
			if(firstin2)
				L.dir = turn(L.dir,-45)
				R.dir = turn(R.dir,45)
				firstin2=0
		else if(length>threshold3 && far>=3)
			if(firstin3)
				L.dir = turn(L.dir,-45)
				R.dir = turn(R.dir,45)
				firstin3=0

		step(L,L.dir)
		step(C,C.dir)
		step(R,R.dir)

		var/num = 0
		if(C.dir == NORTH)
			while(L.x+num < C.x)
				if(type == "ash") AshSmoke(usr,L.x+num,L.y,L.z,direction)
				else if(type == "poison") PoisonSmoke(usr,L.x+num,L.y,L.z,direction)
				num++
			num = 0
			while(R.x-num > C.x)
				if(type == "ash") AshSmoke(usr,R.x-num,R.y,R.z,direction)
				else if(type == "poison") PoisonSmoke(usr,R.x-num,R.y,R.z,direction)
				num++
		if(C.dir == SOUTH)
			while(L.x-num > C.x)
				if(type == "ash") AshSmoke(usr,L.x-num,L.y,L.z,direction)
				else if(type == "poison") PoisonSmoke(usr,L.x-num,L.y,L.z,direction)
				num++
			num = 0
			while(R.x+num < C.x)
				if(type == "ash") AshSmoke(usr,R.x+num,R.y,R.z,direction)
				else if(type == "poison") PoisonSmoke(usr,R.x+num,R.y,R.z,direction)
				num++
		if(C.dir == WEST)
			while(L.y+num < C.y)
				if(type == "ash") AshSmoke(usr,L.x,L.y+num,L.z,direction)
				else if(type == "poison") PoisonSmoke(usr,L.x,L.y+num,L.z,direction)
				num++
			num = 0
			while(R.y-num > C.y)
				if(type == "ash") AshSmoke(usr,R.x,R.y-num,R.z,direction)
				else if(type == "poison") PoisonSmoke(usr,R.x,R.y-num,R.z,direction)
				num++
		if(C.dir == EAST)
			while(L.y-num > C.y)
				if(type == "ash") AshSmoke(usr,L.x,L.y-num,L.z,direction)
				else if(type == "poison") PoisonSmoke(usr,L.x,L.y-num,L.z,direction)
				num++
			num = 0
			while(R.y+num < C.y)
				if(type == "ash") AshSmoke(usr,R.x,R.y+num,R.z,direction)
				else if(type == "poison") PoisonSmoke(usr,R.x,R.y+num,R.z,direction)
				num++
		if(type == "ash") AshSmoke(usr,C.x,C.y,C.z,direction)
		else if(type == "poison") PoisonSmoke(usr,C.x,C.y,C.z,direction)
		sleep(delay)
		length--*/