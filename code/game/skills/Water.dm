
mob
	var/tmp/water_collision

skill
	water
		giant_vortex
			id = SUITON_VORTEX
			name = "Water: Giant Vortex"
			icon_state = "giant_vortex"
			default_chakra_cost = 200
			default_cooldown = 60
			default_seal_time = 5

			SealTime(mob/user)
				if(user.waterlogged)
					default_seal_time = 2.5
				return ..(user)

			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Giant Vortex!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()
				var/stamina_damage = 100 * conmult
				if(!user.waterlogged)
					stamina_damage = round(stamina_damage/2)
				//world.log << "STAMINA DAMAGE: [stamina_damage]"

				user.Timed_Stun(10)
				if(user.dir == NORTHEAST || user.dir == SOUTHEAST)
					user.dir = EAST
				else if(user.dir == NORTHWEST || user.dir == SOUTHWEST)
					user.dir = WEST
				wet_proj(user.x,user.y,user.z,'icons/watervortex.dmi',"",user,9,stamina_damage,3)
				if(user.dir==NORTH||user.dir==SOUTH)
					wet_proj(user.x+1,user.y,user.z,'icons/watervortex.dmi',"",user,9,stamina_damage,0)
					wet_proj(user.x-1,user.y,user.z,'icons/watervortex.dmi',"",user,9,stamina_damage,0)
					wet_proj(user.x+2,user.y,user.z,'icons/watervortex.dmi',"",user,9,stamina_damage,0)
					wet_proj(user.x-2,user.y,user.z,'icons/watervortex.dmi',"",user,9,stamina_damage,0)
				if(user.dir==EAST||user.dir==WEST)
					wet_proj(user.x,user.y-1,user.z,'icons/watervortex.dmi',"",user,9,stamina_damage,0)
					wet_proj(user.x,user.y+1,user.z,'icons/watervortex.dmi',"",user,9,stamina_damage,0)
					wet_proj(user.x,user.y-2,user.z,'icons/watervortex.dmi',"",user,9,stamina_damage,0)
					wet_proj(user.x,user.y+2,user.z,'icons/watervortex.dmi',"",user,9,stamina_damage,0)



		bursting_water_shockwave
			id = SUITON_SHOCKWAVE
			name = "Water: Bursting Water Shockwave"
			icon_state = "exploading_water_shockwave"
			default_chakra_cost = 500
			default_cooldown = 120
			default_seal_time = 15



			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Bursting Water Shockwave!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()
				var/stamina_damage = 250 * conmult
				if(!user.waterlogged)
					stamina_damage = round(stamina_damage/2)

				user.Timed_Stun(15)
				if(user.dir == NORTHEAST || user.dir == SOUTHEAST)
					user.dir = EAST
				else if(user.dir == NORTHWEST || user.dir == SOUTHWEST)
					user.dir = WEST
				wet_proj(user.x,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),6)
				if(user.dir==NORTH||user.dir==SOUTH)
					wet_proj(user.x+1,user.y,user.z,'icons/watershockwave.dmi',"",user,14,stamina_damage,0)
					wet_proj(user.x-1,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x+2,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x-2,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x+3,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x-3,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x+4,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x-4,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x+5,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x-5,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
				if(user.dir==EAST||user.dir==WEST)
					wet_proj(user.x,user.y+1,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x,user.y-1,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x,user.y+2,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x,user.y-2,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x,user.y+3,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x,user.y-3,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x,user.y+4,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x,user.y-4,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x,user.y+5,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)
					wet_proj(user.x,user.y-5,user.z,'icons/watershockwave.dmi',"",user,14,(stamina_damage),0)




		water_dragon
			id = SUITON_DRAGON
			name = "Water: Water Dragon Projectile"
			icon_state = "water_dragon_blast"
			default_chakra_cost = 400
			default_cooldown = 90
			default_seal_time = 10



			/*IsUsable(mob/user)
				. = ..()
				if(.)
					if(!Iswater(user.x,user.y,user.z))
						Error(user, "You must be standing on water to use this technique.")
						return 0*/


			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Water Dragon Projectile!", "combat_output")

				//user.stunned=10
				user.Begin_Stun()

				var
					conmult = user.ControlDamageMultiplier()
					stamina_damage = 1000 + 1300 * conmult
					targets[] = user.NearestTargets(num = 10)

				//if(!user.waterlogged)
				//	stamina_damage *= 0.6

				if(targets && targets.len)
					var/count = 0
					for(var/mob/m in targets)
						user.water_dragon(m, ++count)

					while(user && user.water_dragons)
						sleep(1)
				else
					var/obj/trailmaker/o = new/obj/trailmaker/Water_Dragon()
					var/mob/result = Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,8)
					if(result)
						result.Knockback(2,o.dir)
						//new/Event(1, "delayed_delete", list(o))
						result.Damage(stamina_damage, 0, user, "Water: Water Dragon")//result.Dec_Stam(stamina_damage, 0, user)
						result.Hostile(user)
						o.dispose()

				user.End_Stun()

	/*			if(etarget)
					var/obj/trailmaker/o=new/obj/trailmaker/Water_Dragon()
					var/mob/result=Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,etarget)
					if(result)
						result.Knockback(2,o.dir)
						spawn(1)
							del(o)
						result.Dec_Stam((1000 + 1000*conmult),0,user)
						result.Hostile(user)
				else
					var/obj/trailmaker/o=new/obj/trailmaker/Water_Dragon()
					var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,8)
					if(result)
						result.Knockback(2,o.dir)
						spawn(1)
							del(o)
						result.Dec_Stam((1000 + 1000*conmult),0,user)
						result.Hostile(user)
				//user.stunned=0
				user.End_Stun()*/

		collision_destruction
			id = SUITON_COLLISION_DESTRUCTION
			name = "Water: Collision Destruction"
			icon_state = "watercollision"
			default_chakra_cost = 450
			default_cooldown = 70
			default_seal_time = 10

			SealTime(mob/user)
				if(!activated)
					default_seal_time = 0
				else
					if(user.waterlogged || user.NearWater(4))
						default_seal_time = 7.5
					else
						default_seal_time = 10
				return ..(user)

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(activated && !user.MainTarget())
						Error(user, "No Target")
						return 0
					/*if(!user.NearWater(4))
						Error(user, "Must be near water")
						return 0*/

			ChakraCost(mob/user)
				if(activated)
					return 0
				else
					return ..(user)

			Cooldown(mob/user)
				if(activated)
					return 0
				else
					return ..(user)

			proc/defend(mob/user)
				set waitfor = 0
				user.Timed_Stun(50)
				user.Protect()
				user.set_icon_state("Seal", 50)

				var/obj/Shield/s = new/obj/Shield/water_collision(user.loc,user)
				s.power = ((1000 + 650 * user.ControlDamageMultiplier()) * 0.2) / 4

				sleep(50)

				user.End_Protect()

				s.dispose()

			Use(mob/human/user)
				if(!activated)
					AddOverlay('icons/activation.dmi')
					activated = 1
					user.combat("Water Collision Destruction is now active. <strong>Defend</strong> to use this technique as a shield or activate it again to attack your target. Lasts for 5 seconds.")
					user.water_collision = world.time + 50
					var/recorded_timestamp = user.water_collision
					spawn()
						var/time = 5
						while(user && user.water_collision == recorded_timestamp && time > 0)
							time--
							sleep(10)
						if(user)
							RemoveOverlay('icons/activation.dmi')
							if(user.water_collision == recorded_timestamp)
								set_cooldown = 20
								DoCooldown(user)
				else
					user.Timed_Stun(30)

					viewers(user) << output("[user]: Water: Collision Destruction!", "combat_output")

					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/player/etarget = user.MainTarget()
					if(etarget)
						if(etarget.Get_Move_Stun() >= 2 || etarget.dzed)
							etarget.icon_state = "hurt"
							etarget.Timed_Stun(5)
						user.set_icon_state("Seal", 30)
						etarget.overlay('icons/watersurround.dmi', 5)
						var/turf/L=etarget.loc
						sleep(5)
						//var/hit=0
						if(L && L==etarget.loc)
							//hit=1
							etarget.Timed_Stun(50)

						var/obj/fxobj/O = new(locate(L.x,L.y,L.z), 50)
						O.layer = MOB_LAYER + 3
						O.overlays.Add(image('icons/watercollisiondestruction.dmi',icon_state="0,1",pixel_x=-16,pixel_y=16),
						image('icons/watercollisiondestruction.dmi',icon_state="1,1",pixel_x=16,pixel_y=16),
						image('icons/watercollisiondestruction.dmi',icon_state="0,0",pixel_x=-16,pixel_y=-16),
						image('icons/watercollisiondestruction.dmi',icon_state="1,0",pixel_x=16,pixel_y=-16))

						var/damage = (1000 + 900 * conmult) * 0.2
						if(!user.waterlogged && !user.NearWater(4))
							damage *= 0.6
						var/damage_times = 5
						var/list/already_hit = list()
						while(user && etarget && etarget.loc && damage_times > 0 && O.loc)
							for(var/mob/m in view(1, O.loc))
								if(m == user || m.ko || m.IsProtected())
									continue
								if(m.loc == O.loc) // full hit
									m.Damage(damage, 0, user, "Water: Water Collision")
									m.Hostile(user)
								else
									if(!(etarget.realname in already_hit))
										already_hit += etarget.realname
										etarget.Timed_Move_Stun(50, 2)
									m.Damage(damage * 0.4, 0, user, "Water: Water Collision")
									m.Hostile(user)
							sleep(10)
							damage_times--
						if(O && O.loc != null)
							O.dispose()
						if(user)
							RemoveOverlay('icons/activation.dmi')
							DoCooldown(user)

mob
	var/tmp/water_dragons = 0

mob/proc/water_dragon(mob/target, count = 0)
	set waitfor = 0
	if(!src || !target)
		return

	water_dragons++

	var
		obj/trailmaker/o = new/obj/trailmaker/Water_Dragon()
		mob/result = Trail_Homing_Projectile(x, y, z, dir, o, 20, target, lag = (waterlogged) ? 0 : 1)
		conmult = ControlDamageMultiplier()
		stamina_damage = 1000 + 1300 * conmult * (1 - 0.2 * count)

	if(!waterlogged)
		stamina_damage *= 0.6

	if(result)
		result.Knockback(2, o.dir)
		//new/Event(1, "delayed_delete", list(o))
		result.Damage(stamina_damage, 0, src, "Water: Water Dragon")//result.Dec_Stam(stamina_damage, 0, src)
		result.Hostile(src)
		o.dispose()
	water_dragons--

obj/Shield/water_collision
	New(loc, mob/owner)
		set waitfor = 0
		if(!owner)
			return
		src.owner = owner
		owner.dir = SOUTH
		overlays.Add(image('icons/watercollisiondestruction.dmi',icon_state="0,1",pixel_x=-16,pixel_y=16),
		image('icons/watercollisiondestruction.dmi',icon_state="1,1",pixel_x=16,pixel_y=16),
		image('icons/watercollisiondestruction.dmi',icon_state="0,0",pixel_x=-16,pixel_y=-16),
		image('icons/watercollisiondestruction.dmi',icon_state="1,0",pixel_x=16,pixel_y=-16))
		sleep(3)
		var/time = 5
		while(owner && loc != null && time > 0)
			owner.dir = NORTH
			wet_proj(owner.x,owner.y+1,owner.z,'icons/watervortex.dmi',"",owner,10,power,4)
			owner.dir = EAST
			wet_proj(owner.x+1,owner.y,owner.z,'icons/watervortex.dmi',"",owner,10,power,4)
			owner.dir = SOUTH
			wet_proj(owner.x,owner.y-1,owner.z,'icons/watervortex.dmi',"",owner,10,power,4)
			owner.dir = WEST
			wet_proj(owner.x-1,owner.y,owner.z,'icons/watervortex.dmi',"",owner,10,power,4)
			sleep(10)
			time--
		if(loc != null)
			dispose()

	dispose()
		owner = null
		loc = null