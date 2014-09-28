skill
	kaguya
		copyable = 0




		finger_bullets
			id = BONE_BULLETS
			name = "Piercing Finger Bullets"
			icon_state = "bonebullets"
			default_chakra_cost = 100
			default_cooldown = 20



			Use(mob/human/user)
				viewers(user) << output("[user]: Piercing Finger Bullets!", "combat_output")
				var/eicon='icons/bonebullets.dmi'
				var/estate=""

				user.set_icon_state("Throw2", 20)


				var/angle
				var/speed = 32
				var/spread = 18
				if(user.MainTarget()) angle = get_real_angle(user, user.MainTarget())
				else angle = dir2angle(user.dir)

				var/damage = 200+75*user.ControlDamageMultiplier()

				advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=damage, wounds=1)
				advancedprojectile_angle(eicon, estate, usr, speed, angle+spread, distance=10, damage=damage, wounds=1)
				advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds=1)
				advancedprojectile_angle(eicon, estate, usr, speed, angle-spread, distance=10, damage=damage, wounds=1)
				advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=damage, wounds=1)





		bone_harden
			id = BONE_HARDEN
			name = "Bone Harden"
			icon_state = "bone_harden"
			default_chakra_cost = 20
			default_cooldown = 80



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.ironskin)
						Error(user, "Cannot be used with Iron Skin active")
						return 0


			ChakraCost(mob/user)
				if(!user.boneharden)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(!user.boneharden)
					return ..(user)
				else
					return 0


			Use(mob/user)
				set waitfor = 0
				/*user.boneharden = 1
				user.combat("Your bones harden as you channel chakra through them! All incoming damage will be converted chakra damage for the next <strong>10</strong> seconds or until you run out of chakra.")
				var/time_limit = 100
				while(time_limit > 0 && user && user.boneharden && user.curchakra >= 0)
					time_limit--
					sleep(1)
				if(user.boneharden)
					user.combat("Your bones soften.")
					user.boneharden = 0
					DoCooldown(user)*/
				if(!user.boneharden)
					user.combat("Your Bones Harden")
					user.boneharden=1
					ChangeIconState("bone_harden_cancel")
					while(user && user.boneharden && user.curchakra >= 0)
						sleep(3)
					if(user && user.curchakra <= 0)
						user.combat("Your bones soften!")
						user.boneharden = FALSE
						ChangeIconState("bone_harden")
						DoCooldown(user)
				else
					user.combat("You halt the chakra flow to your bones, they become soft again")
					user.boneharden=0
					ChangeIconState("bone_harden")




		camellia_dance
			id = BONE_SWORD
			name = "Camellia Dance"
			icon_state = "bone_sword"
			default_chakra_cost = 100
			default_cooldown = 200



			Use(mob/user)
				viewers(user) << output("[user]: Camellia Dance!", "combat_output")
				user.hasbonesword = 1
				//user.boneuses=30
				var/o=new/obj/items/weapons/melee/sword/Bone_Sword(user)
				o:Use(user)




		young_bracken_dance
			id = SAWARIBI
			name = "Young Bracken Dance"
			icon_state = "sawarabi"
			base_charge = 150
			default_cooldown = 120
			default_seal_time = 10//30



			Use(mob/user)
				viewers(user) << output("[user]: Young Bracken Dance!", "combat_output")
				var/range=1 //200
				while(charge>base_charge && range<10)
					range+=1
					charge-=base_charge
				spawn SpireCircle(user.x,user.y,user.z,range,user)




		larch_dance
			id = BONE_SPINES
			name = "Larch Dance"
			icon_state = "bone_spines"
			default_chakra_cost = 100
			default_cooldown = 35



			Use(mob/user)
				set waitfor = 0
				user.larch_active = 1
				user.combat("Larch Dance is active. If you are hit within the next 10 seconds, it will activate!")
				var/timelimit = 100
				while(timelimit > 0 && user.larch_active)
					timelimit--
					sleep(1)
				if(user.larch_active)
					user.combat("Larch Dance is no longer active.")
					user.larch_active = 0
				else
					user.larch_active = 0
					user.Timed_Stun(20)
					sleep(2)
					viewers(user) << output("[user]: Larch Dance!", "combat_output")
					var/obj/o=new(locate(user.x,user.y,user.z))
					o.icon='icons/Dance of the Larch.dmi'
					flick("flick",o)
					for(var/mob/human/M in oview(1,user))
						Blood2(M)
						M.Damage(rand(100,500), rand(5,10), user, "Bone Spines")//M.Wound(rand(5,10),0,user)
						//M.Dec_Stam(rand(100,500),0,user)
						M.Hostile(user)
						//M.move_stun+=30
						M.Timed_Move_Stun(30)
					sleep(4)
					del(o)
					user.overlays+='icons/Dance of the Larch.dmi'
					user.larch=1
					user.ironskin=1
					sleep(100)
					user.ironskin=0
					user.larch=0
					//user.stunned+=2
					user.Timed_Stun(20)
					user.overlays-='icons/Dance of the Larch.dmi'
					var/obj/x=new(locate(user.x,user.y,user.z))
					x.icon='icons/Dance of the Larch.dmi'
					flick("unflick",x)
					sleep(4)
					del(x)

mob/var/tmp/larch_active=0