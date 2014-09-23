mob
	var/tmp/chidori

skill
	lightning
		chidori
			id = CHIDORI
			name = "Lightning: Chidori"
			icon_state = "chidori"
			default_chakra_cost = 400
			default_cooldown = 90
			default_seal_time = 5



			Use(mob/human/user)
				viewers(user) << output("[user]: Lightning: Chidori!", "combat_output")
				user.chidori = 1
				var/conmult = user.ControlDamageMultiplier()
				user.overlays+='icons/chidori.dmi'

				var/mob/human/etarget = user.MainTarget()
				//user.Begin_Stun()
				if(!etarget)
					//snd(user,'sounds/chidori_run.wav',vol=30)
					//user.End_Stun()
					user.usemove=1
					sleep(10)
					if(!user.usemove) //didn't I comment this out?
						user.chidori=0
						return
					user.usemove=0
					var/ei=7
					while(!etarget && ei>0)
						for(var/mob/human/o in get_step(user,user.dir))
							if(!o.ko&&!o.IsProtected())
								etarget=o
						ei--
						walk(user,user.dir)
						sleep(1)
						walk(user,0)

					if(etarget)
						//etarget = etarget.Replacement_Start(user)
						var/rfxdamage=(user.rfx+user.rfxbuff-user.rfxneg)

						var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
						if(result>=5)
							user.combat("[user] critically hit [etarget] with the Chidori")
							etarget.combat("[user] critically hit [etarget] with the Chidori")
							//etarget.Damage(rfxdamage*rand(5,7)+1000,rand(20,50),user,"Lightning: Chidori","Normal")
							etarget.Dec_Stam(rfxdamage*rand(5,7)+1000, 0, user)
							etarget.Wound(rand(20,50), 0, user)
						if(result==4)
							user.combat("[user] hit [etarget] with the Chidori")
							etarget.combat("[user] hit [etarget] with the Chidori")
							//etarget.Damage(rfxdamage*rand(3,5)+600,rand(15,25),user,"Lightning: Chidori","Normal")
							etarget.Dec_Stam(rfxdamage*rand(3,5)+600, 0, user)
							etarget.Wound(rand(15,25), 0, user)
						if(result==3)
							user.combat("[user] managed to partially hit [etarget] with the Chidori")
							etarget.combat("[user] managed to partially hit [etarget] with the Chidori")
							//etarget.Damage(rfxdamage*rand(1,3)+200,rand(5,10),user,"Lightning: Chidori","Normal")
							etarget.Dec_Stam(rfxdamage*rand(1,3)+200, 0, user)
							etarget.Wound(rand(5,10), 0, user)
						if(result>=0)
							ChidoriFX(user)
							etarget.Timed_Move_Stun(50)
							Blood2(etarget,user)
							etarget.Hostile(user)
							user.Taijutsu(etarget)

					//	spawn(5) if(etarget) etarget.Replacement_End()
					user.overlays-='icons/chidori.dmi'
				else if(etarget)
					//snd(user,'sounds/chidori.wav',vol=30)
					//user.usemove=1

					//user.canmove = 0 //from when this loop was used for autopilot
					var/i=20
					while(user && etarget && get_dist(user,etarget) > 1 && i > 0)
						etarget = user.MainTarget()
						//if(i < 3) step_to(user,etarget)
						sleep(1)
						i--
					//user.canmove = 1 //from when this loop was used for autopilot

					etarget = user.MainTarget()
					var/inrange=(etarget in oview(user, 1))
					//user.Timed_Stun(5)
					spawn(2) user.overlays-='icons/chidori.dmi'

					if(etarget/* && user.usemove*/ && inrange)
						//user.usemove=0
					//	etarget = etarget.Replacement_Start(user)
						var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,70)
						if(result>=5)
							user.combat("[user] critically hit [etarget] with the Chidori")
							etarget.combat("[user] critically hit [etarget] with the Chidori")
							//etarget.Damage(rand(1500,2000)+conmult*650,rand(10,20),user,"Lightning: Chidori","Normal")
							etarget.Dec_Stam(rand(1500,2000)+conmult*650,0,user)
							etarget.Wound(rand(10,20),0,user)
						if(result==4)
							user.combat("[user] hit [etarget] with the Chidori")
							etarget.combat("[user] hit [etarget] with the Chidori")
							//etarget.Damage(rand(1500,2000)+conmult*500,rand(10,15),user,"Lightning: Chidori","Normal")
							etarget.Dec_Stam(rand(1500,2000)+conmult*500,0,user)
							etarget.Wound(rand(10,15),0,user)
						if(result==3)
							user.combat("[user] managed to partially hit [etarget] with the Chidori")
							etarget.combat("[user] managed to partially hit [etarget] with the Chidori")
							//etarget.Damage(rand(1500,2000)+conmult*500,rand(2,7),user,"Lightning: Chidori","Normal")
							etarget.Dec_Stam(rand(1000,1500)+conmult*500,0,user)
							etarget.Wound(rand(2,7),0,user)
						if(result<3)
							user.combat("[user] missed [etarget] with the Chidori!")
							etarget.combat("[user] missed [etarget] with the Chidori!")
							//etarget.Damage(rand(750,1250)+conmult*250,0,user,"Lightning: Chidori","Normal")

						//if(user.AppearMyDir(etarget))
						if(result>=3)
							ChidoriFX(user)
							etarget.Timed_Move_Stun(50)
							Blood2(etarget,user)
							etarget.Hostile(user)
							user.Taijutsu(etarget)
						if(result<3)
							user.combat("You Missed!!!")
							if(!user.icon_state)
								flick("hurt",user)
						//spawn(5) if(etarget) etarget.Replacement_End()
				user.chidori=0




		chidori_spear
			id = CHIDORI_SPEAR
			name = "Lightning: Chidori Spear"
			icon_state = "raton_sword_form_assasination_technique"
			default_chakra_cost = 350
			default_cooldown = 150
			face_nearest = 1



			Use(mob/human/user)
				set waitfor = 0
				viewers(user) << output("[user]: Lightning: Chidori Spear!", "combat_output")

				//user.stunned=10
				user.Timed_Stun(100)

				user.overlays+='icons/ratonswordoverlay.dmi'
				sleep(5)

				var/obj/trailmaker/o=new/obj/trailmaker/Raton_Sword()
				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,14,user)
				if(result)
					new/Event(50, "delayed_delete", list(o))
					result.Dec_Stam(rand(1500,4300),1,user)
					result.Wound(rand(10,20),1,user)
					Blood2(result,user)
					result.Hostile(user)
					//result.move_stun=50
					result.Timed_Move_Stun(50)
					sleep(30)
						//user.stunned=0
					user.End_Stun()
					user.overlays-='icons/ratonswordoverlay.dmi'
				else
					//user.stunned=0
					user.End_Stun()
					user.overlays-='icons/ratonswordoverlay.dmi'




		chidori_current
			id = CHIDORI_CURRENT
			name = "Lightning: Chidori Current"
			icon_state = "chidori_nagashi"
			default_chakra_cost = 100
			default_cooldown = 20
			face_nearest = 1



			Use(mob/human/user)
				set waitfor = 0
				viewers(user) << output("[user]: Lightning: Chidori Current!", "combat_output")

				user.icon_state="Seal"
				user.Timed_Stun(30)
				user.noknock++

				var/conmult = user.ControlDamageMultiplier()

				//snd(user,'sounds/chidori_nagashi.wav',vol=30)
				if(!Iswater(user.loc))
					for(var/turf/x in oview(1))
						Electricity(x.x,x.y,x.z,30)
					AOEcc(user.x,user.y,user.z,1,(250+150*conmult),(50+25*conmult),30,user,0,1.5,1)
				else if(Iswater(user.loc) || user.waterlogged)
					for(var/turf/x in oview(2))
						Electricity(x.x,x.y,x.z,30)
					AOEcc(user.x,user.y,user.z,2,(250+150*conmult),(50+25*conmult),30,user,0,1.5,1)
				Electricity(user.x,user.y,user.z,30)
				sleep(30)
				user.noknock--
				user.icon_state=""




		chidori_needles
			id = CHIDORI_NEEDLES
			name = "Lightning: Chidori Needles"
			icon_state = "chidorisenbon"
			default_chakra_cost = 200
			default_cooldown = 30
			face_nearest = 1



			Use(mob/human/user)
				set waitfor = 0
				viewers(user) << output("[user]: Lightning: Chidori Needles!", "combat_output")
				var/eicon='icons/chidorisenbon.dmi'
				var/estate=""

				user.set_icon_state("Throw1", 30)
				user.overlays+='icons/raitonhand.dmi'

				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					user.dir = angle2dir_cardinal(get_real_angle(user, etarget))

				var/angle
				var/speed = 32
				var/spread = 9
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)

				var/damage = 100+50*user.ControlDamageMultiplier()

				advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*6, distance=10, damage=damage, wounds=1, daze=15)
				advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*3, distance=10, damage=damage, wounds=1, daze=15)
				advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1, daze=15)
				advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*3, distance=10, damage=damage, wounds=1, daze=15)
				advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*6, distance=10, damage=damage, wounds=1, daze=15)
				sleep(30)
				user.overlays-='icons/raitonhand.dmi'


turf/Entered(mob/crossing)
	if(!istype(crossing))
		return ..()

	if(/*!crossing.waterlogged && */Iswater(x, y, z))
		if(!crossing.body_replacement && crossing.clan == "Haku")
			new/obj/haku_ice(src)
		else
			crossing.waterlogged = 1
			if(crossing.curchakra >= 5)
				crossing.curchakra -= 5
			else if(crossing.curstamina >= 25)
				crossing.curstamina -= 25

	if(locate(/obj/elec) in src)
		crossing.Timed_Stun(10)

turf/Exited(mob/e)
	if(!istype(e))
		return ..()

	e.waterlogged = 0