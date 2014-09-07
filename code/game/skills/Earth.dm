skill
	earth
		iron_skin
			id = DOTON_IRON_SKIN
			name = "Earth: Iron Skin"
			icon_state = "doton_iron_skin"
			default_chakra_cost = 150
			default_cooldown = 240



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.ironskin)
						Error(user, "Earth: Iron Skin is already active.")
						return 0


			Use(mob/human/user)
				if(user.boneharden)
					user.combat("Your bones unharden")
					user.boneharden=0
				viewers(user) << output("[user]: Earth: Iron Skin!", "combat_output")
				if(user.playergender=="male")
					user.icon='icons/base_m_stoneskin.dmi'
				else
					user.icon='icons/base_m_stoneskin.dmi'
				user.ironskin=1
				spawn(300 + round(50*user.ControlDamageMultiplier()))
					if(user)
						user.ironskin=0
						user.reIcon()




		dungeon_chamber
			id = DOTON_CHAMBER
			name = "Earth: Dungeon Chamber of Nothingness"
			icon_state = "Dungeon Chamber of Nothingness"
			default_chakra_cost = 100
			default_cooldown = 40
			default_seal_time = 5



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0


			Use(mob/human/user)
				//user.stunned=1
				user.Timed_Stun(10)
				viewers(user) << output("[user]: Earth: Dungeon Chamber of Nothingness!", "combat_output")

				var/mob/human/player/etarget = user.MainTarget()
				if(!etarget)
					for(var/mob/human/M in oview(1))
						if(!M.protected && !M.ko)
							etarget=M
				if(etarget)
					var/ex=etarget.x
					var/ey=etarget.y
					var/ez=etarget.z
					spawn()Doton_Cage(ex,ey,ez,100)
					sleep(4)
					if(etarget)
						if(ex==etarget.x&&ey==etarget.y&&ez==etarget.z)
							//etarget.stunned=10
							etarget.Timed_Stun(100)
							etarget.layer=MOB_LAYER-1
							etarget.paralysed=1
							spawn()
								while(etarget&&ex==etarget.x&&ey==etarget.y&&ez==etarget.z)
									sleep(2)
								if(etarget)
									etarget.paralysed=0
									//etarget.stunned=0
							spawn(100)
								if(etarget)
									etarget.paralysed=0




		dungeon_chamber_crush
			id = DOTON_CHAMBER_CRUSH
			name = "Earth: Split Earth Revolution Palm"
			icon_state = "doton_split_earth_turn_around_palm"
			default_chakra_cost = 250
			default_cooldown = 100
			default_seal_time = 5

			Use(mob/human/user)
				//user.stunned=3
				user.Timed_Stun(30)
				viewers(user) << output("[user]: Earth: Split Earth Revolution Palm!", "combat_output")

				for(var/obj/earthcage/o in oview(8))
					if(o.crushed)
						continue
					o.icon='icons/dotoncagecrushed.dmi'
					for(var/mob/human/m in oview(0,o))
						m.Crush(user)




		earth_flow_river
			id = DOTON_EARTH_FLOW
			name = "Earth: Earth Flow River"
			icon_state = "earthflow"
			default_chakra_cost = 400
			default_cooldown = 60
			default_seal_time = 5

			Use(mob/human/user)
				//user.stunned=1
				user.Timed_Stun(10)
				viewers(user) << output("[user]: Earth: Earth Flow River!", "combat_output")

				var/obj/O=new(locate(user.loc))
				O.icon='icons/earthflow.dmi'
				O.icon_state="overlay"
				O.dir=user.dir

				sleep(1)
				var/obj/trailmaker/Mud_Slide/o=new/obj/trailmaker/Mud_Slide(locate(user.x,user.y,user.z))
				o.density=0
				var/distance=15
				var/user_dir = user.dir
				while(o && distance>0 && user)
					if(!step(o, user_dir))
						break
					var/conmult = user.ControlDamageMultiplier()
					for(var/mob/human/player/M in o.loc)
						if(M!=user && !(M in o.gotmob))
							o.gotmob+=M
							M.Dec_Stam(rand(600,900)+200*conmult,0,user)
							spawn()M.Hostile(user)

					for(var/turf/T in get_step(o,user_dir))
						if(T.density)
							distance=1
					sleep(1)

					distance--
					for(var/mob/human/player/M in o.gotmob)
						M.Dec_Stam(rand(70,100)+20*conmult,0,user)
						spawn()M.Hostile(user)
				del(O)
				del(o)




mob/human/proc
	Crush(mob/u)
		src.Wound(rand(15,30),0,u)
		src.Dec_Stam(3000,0,u)
		spawn()Blood2(src,u)
		spawn()src.Hostile(u)