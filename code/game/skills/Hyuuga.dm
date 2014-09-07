skill
	hyuuga
		copyable = 0




		byakugan
			id = BYAKUGAN
			name = "Byakugan"
			icon_state = "byakugan"
			default_chakra_cost = 80
			default_cooldown = 240



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.byakugan)
						Error(user, "Byakugan is already active")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]: Byakugan!", "combat_output")
				user.byakugan=1
				user.Affirm_Icon()
				spawn(Cooldown(user)*10)
					if(user)
						user.byakugan=0
						user.Affirm_Icon()
						user.combat("The Byakugan wore off")
						if(user.gentlefist==1)
							user.gentlefist=0
							user.overlays-='icons/hakkehand.dmi'
							user.special=0
							user.Load_Overlays()




		kaiten
			id = KAITEN
			name = "Eight Trigrams Palm: Turning the Tide"
			icon_state = "kaiten"
			default_chakra_cost = 90
			default_cooldown = 10



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.byakugan)
						Error(user, "Byakugan is required to use this skill")
						return 0


			Use(mob/user)
				var/obj/b1=new/obj/kbl(locate(user.x,user.y,user.z))
				var/obj/b2=new/obj/kbr(locate(user.x,user.y,user.z))
				var/obj/b3=new/obj/ktl(locate(user.x,user.y,user.z))
				var/obj/b4=new/obj/ktr(locate(user.x,user.y,user.z))
				spawn()AOExk(user.x,user.y,user.z,1,150,30,user,0,1,1)
				user.kaiten=1
				user.protected=5
				//user.stunned=3.2
				user.Timed_Stun(30)
				spawn(30)
					user.kaiten=0
					del(b1)
					del(b2)
					del(b3)
					del(b4)




		trigrams_64_palms
			id = HAKKE_64
			name = "Eight Trigrams: 64 Palms"
			icon_state = "64 palms"
			default_chakra_cost = 500
			default_cooldown = 120
			face_nearest = 1



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.byakugan)
						Error(user, "Byakugan is required to use this skill")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Eight Trigrams: 64 Palms!", "combat_output")
				//user.stunned=10
				user.Timed_Stun(100)

				var/mob/human/player/etarget = user.NearestTarget()
				if(!etarget)
					for(var/mob/human/M in oview(1,user))
						if(!M.ko && !M.protected)
							etarget=M
				if(etarget && !etarget.ko)
					spawn()
						Hakke_Circle(user,etarget)
					if(etarget.dzed)
						//etarget.stunned+=3
						etarget.Timed_Stun(30)
					sleep(10)
					if((etarget in oview(1, user)) && !etarget.ko)
						//etarget.stunned=5
						etarget.Timed_Stun(50)
						spawn()user.Taijutsu(etarget)
						user.Hakke_Pwn(etarget)
						if(etarget && user)
							etarget.curchakra=0
							etarget.chakrablocked=60
							etarget.Dec_Stam(3000+user.ControlDamageMultiplier()*500,0,user)
							spawn()etarget.Hostile(user)
					if(user) user.End_Stun()//user.stunned=0
				else
					Hakke_Circle(user,0)
					//user.stunned=0
					user.End_Stun()



		gentle_fist
			id = GENTLE_FIST
			name = "Gentle Fist"
			icon_state = "gentle_fist"
			default_chakra_cost = 100
			default_cooldown = 30



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.byakugan)
						Error(user, "Byakugan is required to use this skill")
						return 0
					if(user.gentlefist)
						Error(user, "Gentle Fist is already active")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Gentle Fist!", "combat_output")
				user.gentlefist=1
				user.overlays+='icons/hakkehand.dmi'
				user.special=/obj/hakkehand