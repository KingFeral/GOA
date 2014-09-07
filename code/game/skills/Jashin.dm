skill
	jashin
		copyable = 0




		stab_self
			id = MASOCHISM
			name = "Stab Self"
			icon_state = "masachism"
			default_chakra_cost = 0
			default_cooldown = 3



			Use(mob/user)
				oviewers(user) << output("[user] stabbed himself!", "combat_output")
				user.combat("You stabbed yourself!")
				user.Wound(10,3,user)
				Blood2(user)




		blood_possession
			id = BLOOD_BIND
			name = "Sorcery: Death-Ruling Possession Blood"
			icon_state = "blood contract"
			default_chakra_cost = 450
			default_cooldown = 200

			Activate(mob/user)
				user.bloodrem = list()
				for(var/obj/undereffect/b in user.loc)
					if(b.icon == 'icons/blood.dmi' && b.uowner && b.uowner != user)
						user.bloodrem += b.uowner
				..()

			Use(mob/user)
				var/list/Choose=user.bloodrem.Copy()
				for(var/mob/human/F in Choose)
					if(F.protected||F.ko||F.z!=user.z)
						Choose-=F

				var/mob/T=new()
				T.name="Nevermind"
				Choose+=T
				var/mob/C=input3(user,"Pick somebody to put a curse on","Blood Contract",Choose)
				if(C!=T)
					user.bloodrem.Cut()
					var/obj/jashin_circle/J=new(user.loc)
					user.Contract=J
					user.Contract2=C
					user.icon='icons/jashin_base.dmi'
					spawn(1800)
						if(J)
							J.loc = null
							if(user)
								user.Contract = null
								user.Contract2=0
								user.Affirm_Icon()




		wound_regeneration
			id = WOUND_REGENERATION
			name = "Wound Regeneration"
			icon_state = "wound regeneration"
			default_chakra_cost = 100
			default_cooldown = 20



			Use(mob/user)
				user.overlays+='icons/base_chakra.dmi'
				user.usemove=1
				sleep(5)
				user.overlays-='icons/base_chakra.dmi'

				sleep(25)
				if(!user)
					return
				if(user.usemove)
					user.curwound-=5
					user.usemove=0
				if(user.curwound<0)
					user.curwound=0




		immortality
			id = IMMORTALITY
			name = "Immortality"
			icon_state = "imortality"
			default_chakra_cost = 400
			default_cooldown = 300



			Use(mob/user)
				if(user.immortality<900)
					var/found=0
					for(var/mob/corpse/C in oview(10,user))
						found=1
						user.immortality+=60+C.blevel*10
						user.combat("You pray to Jashin to grant you immortality and sacrifice [C], you gain [60+C.blevel*10] seconds of Immortality!")
						//user.icon_state="Chakra"
						user.set_icon_state("Chakra", time = 30)
						//user.stunned=10
						user.Timed_Stun(100)

						sleep(100)
						//user.icon_state=""
						if(C)del(C)
						//user.stunned=0
						break
					if(!found)
						return
					if(user.immortality>900)
						user.immortality=900
