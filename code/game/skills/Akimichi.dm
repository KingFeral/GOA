skill
	akimichi
		copyable = 0




		spinach_pill
			id = SPINACH_PILL
			name = "Spinach Pill"
			icon_state = "spinach"
			default_chakra_cost = 0
			default_cooldown = 10



			Use(mob/user)
				set waitfor = 0
				if(user.gate)
					user.combat("[usr] closes the gates.")
					user.CloseGates()
				if(user.pill<1)
					user.pill=1
					oviewers(user) << output("[user] ate a green pill!", "combat_output")
					user.combat("You ate the Spinach Pill! Your strength is greatly enhanced, but the strain on your body will cause damage.")
					sleep(6000)
					if(user && user.pill==1)
						user.pill=0
						user.combat("The Spinach Pill wore off")
						user.strbuff = 0
						user.conbuff=0
						src.DoCooldown(user,0,60)




		curry_pill
			id = CURRY_PILL
			name = "Curry Pill"
			icon_state = "curry"
			default_chakra_cost = 0
			default_cooldown = 10



			Use(mob/human/user)
				set waitfor = 0
				if(user.gate)
					user.combat("[usr] closes the gates.")
					user.CloseGates()
				if(user.pill<=1)
					user.pill=2
					oviewers(user) << output("[user] ate a yellow pill!", "combat_output")
					user.combat("You ate the Curry Pill! You have gained super human strength and a great resistance to damage. However, the strain on your body is immense!")
					user.overlays+='icons/Chakra_Shroud.dmi'
					sleep(3000)
					if(user && user.pill==2)
						user.pill=0

						user.combat("The Curry Pill wore off")
						user.overlays-='icons/Chakra_Shroud.dmi'
						user.strbuff = 0
						user.conbuff=0
						src.DoCooldown(user,0,300)




		size_multiplication
			id = SIZEUP1
			name = "Size Multiplication"
			icon_state = "sizeup1"
			default_chakra_cost = 400
			default_cooldown = 200


			ChakraCost(mob/user)
				if(!user.Size)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(!user.Size)
					return ..(user)
				else
					return 0


			Use(mob/human/user)
				set waitfor =0
				if(user.Size == 1)
					user.Size=0
					user.Akimichi_Revert()
					ChangeIconState("sizeup1")
				else
					if(user.gate)
						user.combat("[user] closes the gates.")
						user.CloseGates()
					if(length(usr.iSizeup1)>2)
						user.icon_state="Seal"
						sleep(50)
						user.layer=MOB_LAYER+2.1
						user.icon_state=""
						for(var/OX in usr.iSizeup1)
							user.overlays+=OX
						user.Size=1
						user.icon=0
					else
						user.layer=MOB_LAYER+2.1
						user.Akimichi_Grow(64)
						user.Size=1
					ChangeIconState("sizedown")

					sleep(1200)
					if(user && user.Size == 1)
						user.Size=0
						user.Akimichi_Revert()
						ChangeIconState("sizeup1")




		super_size_multiplication
			id = SIZEUP2
			name = "Super Size Multiplication"
			icon_state = "sizeup2"
			default_chakra_cost = 500
			default_cooldown = 200


			ChakraCost(mob/user)
				if(!user.Size)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(!user.Size)
					return ..(user)
				else
					return 0


			Use(mob/human/user)
				set waitfor=0
				if(user.Size == 2)
					user.Size=0
					user.Akimichi_Revert()
					ChangeIconState("sizeup2")
				else
					if(user.gate)
						user.combat("[user] closes the gates.")
						user.CloseGates()
					if(length(usr.iSizeup2)>2)
						user.icon_state="Seal"
						sleep(50)
						user.layer=MOB_LAYER+2.1
						user.icon_state=""
						for(var/OX in usr.iSizeup2)
							user.overlays+=OX
						user.Size=2
						user.icon=0
					else
						user.layer=MOB_LAYER+2.1
						user.Akimichi_Grow(96)
						user.Size=2
					ChangeIconState("sizedown")

					sleep(1200)
					if(user && user.Size == 2)
						user.Size=0
						user.Akimichi_Revert()
						ChangeIconState("sizeup2")




		human_bullet_tank
			id = MEAT_TANK
			name = "Human Bullet Tank"
			icon_state = "meattank"
			default_chakra_cost = 300
			default_cooldown = 30



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.Size)
						Error(user, "An incompatible skill is active")
						return 0


			Use(mob/human/user)
				if(user.gate)
					user.combat("[src] closes the gates.")
					user.CloseGates()
				user.overlays=0
				user.icon=0
				user.Tank=1
				user.overlays+=image('icons/meattank.dmi',icon_state="0,0",pixel_x=-16)
				user.overlays+=image('icons/meattank.dmi',icon_state="1,0",pixel_x=16)
				user.overlays+=image('icons/meattank.dmi',icon_state="0,1",pixel_x=-16,pixel_y=32)
				user.overlays+=image('icons/meattank.dmi',icon_state="1,1",pixel_x=16,pixel_y=32)

				sleep(150)
				if(user)
					user.Tank=0
					user.Affirm_Icon()
					user.Load_Overlays()
