mob
	var/tmp/mole

skill
	earth
		mole_hiding

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

					if(user.boneharden)
						Error(user, "You are channeling chakra to Bone Harden.")
						return 0

			Use(mob/human/user)
				set waitfor = 0
				viewers(user) << output("[user]: Earth: Iron Skin!", "combat_output")
				if(user.playergender=="male")
					user.icon='icons/base_m_stoneskin.dmi'
				else
					user.icon='icons/base_m_stoneskin.dmi'
				user.ironskin=1
				sleep(300 + round(50*user.ControlDamageMultiplier()))
				if(user)
					user.ironskin = 0
					user.reIcon()
					user.Affirm_Icon()

		dungeon_chamber
			id = DOTON_CHAMBER
			name = "Earth: Dungeon Chamber of Nothingness"
			icon_state = "Dungeon Chamber of Nothingness"
			default_chakra_cost = 100
			default_cooldown = 40
			default_seal_time = 10
			var/tmp/ready = FALSE

			SealTime(mob/user)
				var/mob/human/mtarget = user.MainTarget()
				if(mtarget && (mtarget.Get_Move_Stun() >= 2 || mtarget.dzed))
					default_seal_time = 6
				return ..(user)

			Cooldown(mob/user)
				if(icon_state == "doton_split_earth_turn_around_palm")
					return 0
				else
					return ..(user)

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.keys["shift"]) //shift modifies this jutsu to have it target yourself, so having no target is OK
						modified = 1
						return 1
					var/mob/human/mtarget = user.MainTarget()
					if(!mtarget)
					//if(!user.MainTarget())
						Error(user, "No Target")
						return 0
					if(mtarget.waterlogged)
						Error(user, "Your target is standing on water!")
						return 0


			Use(mob/human/user)
				//user.stunned=1
				if(icon_state == "doton_split_earth_turn_around_palm")
					var/skill/crush = user.GetSkill(DOTON_CHAMBER_CRUSH)
					//crush.Activate(user)
					if(crush && crush.IsUsable(user))
						user.Timed_Stun(30)
						viewers(user) << output("[user]: Earth: Split Earth Revolution Palm!", "combat_output")

						for(var/obj/earthcage/o in oview(8))
							if(o.owner != user || o.crushed ||  o.destroyed)
								continue
							o.crush(user)
							break

					ChangeIconState("Dungeon Chamber of Nothingness")
					RemoveOverlay('icons/activation.dmi')
					return

				AddOverlay('icons/activation.dmi')

				user.Timed_Stun(10)
				viewers(user) << output("[user]: Earth: Dungeon Chamber of Nothingness!", "combat_output")

				var/mob/human/player/etarget// = user.MainTarget()

				if(modified)
					etarget = user
				else
					etarget = user.MainTarget()
				if(etarget)

					var/turf/cageloc = etarget.loc
					var/obj/earthcage/cage = Doton_Cage(cageloc, user, 100)

					sleep(4)

					var/has_caged = 0
					for(var/mob/caged in cageloc)
						has_caged = TRUE
						caged.Timed_Stun(100)
						caged.paralysed = 1

					if(has_caged && etarget != user && user.HasSkill(DOTON_CHAMBER_CRUSH))
						ChangeIconState("doton_split_earth_turn_around_palm")

					spawn()
						while(user && cage.loc && etarget && etarget.loc == cageloc && etarget.paralysed && !(cage.destroyed || cage.crushed))
							sleep(2)

						if(cage && cage.loc && !(cage.destroyed || cage.crushed))
							for(var/mob/caged in cageloc)
								caged.layer = MOB_LAYER
								caged.paralysed = 0
								caged.combat("You are freed!")

						if(user)
							RemoveOverlay('icons/activation.dmi')
							ChangeIconState("Dungeon Chamber of Nothingness")
							DoCooldown(user)

		dungeon_chamber_crush
			id = DOTON_CHAMBER_CRUSH
			name = "Earth: Split Earth Revolution Palm"
			icon_state = "doton_split_earth_turn_around_palm"
			default_chakra_cost = 250
			default_cooldown = 100
			default_seal_time = 5

			IsUsable(mob/user)
				. = ..()
				if(.)
					var/found
					for(var/obj/earthcage/o in oview(8))
						if(o.owner == user && !(o.crushed || o.destroyed))
							found = 1
							break
					if(!found)
						Error(user, "No Valid Target")
						return 0

/*			Use(mob/human/user)
				set waitfor = 0
				//user.stunned=3
				user.Timed_Stun(30)
				viewers(user) << output("[user]: Earth: Split Earth Revolution Palm!", "combat_output")

				for(var/obj/earthcage/o in oview(8))
					if(o.owner != user || o.crushed ||  o.destroyed)
						continue
					o.crush(user)
					/*o.crushed = TRUE
					o.icon='icons/dotoncagecrushed.dmi'
					for(var/mob/human/m in oview(0,o))
						m.Crush(user)*/
					//break
*/


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
							M.Damage(rand(600,900)+200*conmult, 0, user, "Earth: Flowing River")//M.Dec_Stam(rand(600,900)+200*conmult,0,user)
							M.Hostile(user)

					for(var/turf/T in get_step(o,user_dir))
						if(T.density)
							distance=1
					sleep(1)

					distance--
					for(var/mob/human/player/M in o.gotmob)
						M.Damage(rand(70, 100) + 20 * conmult, 0, user, "Earth: Flowing River")//M.Dec_Stam(rand(70,100)+20*conmult,0,user)
						M.Hostile(user)
				del(O)
				del(o)

// Earth Chamber of Nothingness
obj/earthcage
	icon = 'icons/dotoncage.dmi'
	icon_state = "blank"
	layer = MOB_LAYER
	density = 0
	var/tmp/health = 3000
	var/tmp/crushed
	var/tmp/destroyed

	proc/Damage(damage)
		health -= damage
		if(health <= 0)
			crumble()

	New(turf/loc, mob/user, lifetime)
		set waitfor = 0
		..()
		if(!user)
			dispose()
			return
		owner = user

		overlays = list(
		image(src.icon, "Creation 0,0", layer = src.layer, pixel_x = -32, pixel_y = -32),
		image(src.icon, "Creation 1,0", layer = src.layer, pixel_y = -32),
		image(src.icon, "Creation 2,0", layer = src.layer, pixel_x = 32, pixel_y = -32),
		image(src.icon, "Creation 0,1", layer = src.layer, pixel_x = -32),
		image(src.icon, "Creation 1,1", layer = src.layer, layer = layer + 0.01),
		image(src.icon, "Creation 2,1", layer = src.layer, pixel_x = 32),
		image(src.icon, "Creation 0,2", layer = src.layer, pixel_x = -32, pixel_y = 32),
		image(src.icon, "Creation 1,2", layer = src.layer, pixel_y = 32),
		image(src.icon, "Creation 2,2", layer = src.layer, pixel_x = 32, pixel_y = 32)
		)
		sleep(8)

		overlays = list(
		image(src.icon, "0,0", layer = src.layer, pixel_x = -32, pixel_y = -32),
		image(src.icon, "1,0", layer = src.layer, pixel_y = -32),
		image(src.icon, "2,0", layer = src.layer, pixel_x = 32, pixel_y = -32),
		image(src.icon, "0,1", layer = src.layer, pixel_x = -32),
		image(src.icon, "1,1", layer = src.layer, layer = layer + 0.01),
		image(src.icon, "2,1", layer = src.layer, pixel_x = 32),
		image(src.icon, "0,2", layer = src.layer, pixel_x = -32, pixel_y = 32),
		image(src.icon, "1,2", layer = src.layer, pixel_y = 32),
		image(src.icon, "2,2", layer = src.layer, pixel_x = 32, pixel_y = 32)
		)
		sleep(lifetime)
		dispose()

	proc/crush(mob/user)
		set waitfor = 0
		crushed = TRUE
		overlays = list(
		image(src.icon, "Crush 0,0", layer = src.layer, pixel_x = -32, pixel_y = -32),
		image(src.icon, "Crush 1,0", layer = src.layer, pixel_y = -32),
		image(src.icon, "Crush 2,0", layer = src.layer, pixel_x = 32, pixel_y = -32),
		image(src.icon, "Crush 0,1", layer = src.layer, pixel_x = -32),
		image(src.icon, "Crush 1,1", layer = src.layer, layer = layer + 0.01),
		image(src.icon, "Crush 2,1", layer = src.layer, pixel_x = 32),
		image(src.icon, "Crush 0,2", layer = src.layer, pixel_x = -32, pixel_y = 32),
		image(src.icon, "Crush 1,2", layer = src.layer, pixel_y = 32),
		image(src.icon, "Crush 2,2", layer = src.layer, pixel_x = 32, pixel_y = 32)
		)

		for(var/mob/m in loc)
			m.Damage(3000, rand(15, 30), user, "Earth Chamber Crush")//m.Dec_Stam(3000, -1, user)
			//m.Wound(rand(15, 30), 0, user)
			Blood2(m, user)
			m.paralysed = 0
			m.Reset_Stun()
			m.Timed_Stun(30)

	proc/crumble()
		set waitfor = 0
		destroyed = TRUE
		overlays = null
		overlays.Add(
		image(src.icon, "Crumble 0,0", layer = src.layer, pixel_x = -32, pixel_y = -32),
		image(src.icon, "Crumble 1,0", layer = src.layer, pixel_y = -32),
		image(src.icon, "Crumble 2,0", layer = src.layer, pixel_x = 32, pixel_y = -32),
		image(src.icon, "Crumble 0,1", layer = src.layer, pixel_x = -32),
		image(src.icon, "Crumble 1,1", layer = src.layer, layer = layer + 0.01),
		image(src.icon, "Crumble 2,1", layer = src.layer, pixel_x = 32),
		image(src.icon, "Crumble 0,2", layer = src.layer, pixel_x = -32, pixel_y = 32),
		image(src.icon, "Crumble 1,2", layer = src.layer, pixel_y = 32),
		image(src.icon, "Crumble 2,2", layer = src.layer, pixel_x = 32, pixel_y = 32)
		)

		for(var/mob/m in loc)
			m.paralysed = 0
			m.combat("You have been freed!")

		sleep(50)
		if(loc != null)
			dispose()

	dispose()
		for(var/mob/m in loc)
			m.paralysed = 0
			m.combat("You have been freed!")

		loc = null

proc/Doton_Cage(turf/spawnlocation, mob/user, dur)
	. = new/obj/earthcage(spawnlocation, user, dur)
/*
mob/human/proc
	Crush(mob/u)
		//src.Wound(rand(15,30),0,u)
		//src.Dec_Stam(3000,0,u)
		Blood2(src,u)
		src.Hostile(u)*/