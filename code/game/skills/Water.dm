skill
	water
		giant_vortex
			id = SUITON_VORTEX
			name = "Water: Giant Vortex"
			icon_state = "giant_vortex"
			default_chakra_cost = 200
			default_cooldown = 60
			default_seal_time = 5



			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Giant Vortex!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()

				//user.stunned=1.5
				user.Timed_Stun(10)
				spawn()wet_proj(user.x,user.y,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),2)
				if(user.dir==NORTH||user.dir==SOUTH)
					spawn()wet_proj(user.x+1,user.y,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),0)
					spawn()wet_proj(user.x-1,user.y,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),0)
				if(user.dir==EAST||user.dir==WEST)
					spawn()wet_proj(user.x,user.y-1,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),0)
					spawn()wet_proj(user.x,user.y+1,user.z,'icons/watervortex.dmi',"",user,9,(225*conmult+700),0)




		bursting_water_shockwave
			id = SUTION_SHOCKWAVE
			name = "Water: Bursting Water Shockwave"
			icon_state = "exploading_water_shockwave"
			default_chakra_cost = 500
			default_cooldown = 120
			default_seal_time = 15



			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Bursting Water Shockwave!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()

				//user.stunned=3
				user.Timed_Stun(15)
				spawn()wet_proj(user.x,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),6)
				if(user.dir==NORTH||user.dir==SOUTH)
					spawn()wet_proj(user.x+1,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-1,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+2,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-2,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+3,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-3,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+4,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-4,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x+5,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x-5,user.y,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
				if(user.dir==EAST||user.dir==WEST)
					spawn()wet_proj(user.x,user.y+1,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-1,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+2,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-2,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+3,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-3,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+4,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-4,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y+5,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)
					spawn()wet_proj(user.x,user.y-5,user.z,'icons/watershockwave.dmi',"",user,14,(1000+500*conmult),0)




		water_dragon
			id = SUITON_DRAGON
			name = "Water: Water Dragon Projectile"
			icon_state = "water_dragon_blast"
			default_chakra_cost = 100
			default_cooldown = 90
			default_seal_time = 10



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!Iswater(user.x,user.y,user.z))
						Error(user, "You must be standing on water to use this technique.")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Water: Water Dragon Projectile!", "combat_output")

				//user.stunned=10
				user.Begin_Stun()
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()

				if(etarget)
					var/obj/trailmaker/o=new/obj/trailmaker/Water_Dragon()
					var/mob/result=Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,etarget)
					if(result)
						result.Knockback(2,o.dir)
						spawn(1)
							del(o)
						result.Dec_Stam((1000 + 1000*conmult),0,user)
						spawn()result.Hostile(user)
				else
					var/obj/trailmaker/o=new/obj/trailmaker/Water_Dragon()
					var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,8)
					if(result)
						result.Knockback(2,o.dir)
						spawn(1)
							del(o)
						result.Dec_Stam((1000 + 1000*conmult),0,user)
						spawn()result.Hostile(user)
				//user.stunned=0
				user.End_Stun()

		collision_destruction
			id = SUITON_COLLISION_DESTRUCTION
			name = "Water: Collision Destruction"
			icon_state = "watercollision"
			default_chakra_cost = 450
			default_cooldown = 70
			default_seal_time = 15



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0
					if(!user.NearWater(4))
						Error(user, "Must be near water")
						return 0


			Use(mob/human/user)
				//user.stunned=5
				user.Timed_Stun(30)

				viewers(user) << output("[user]: Water: Collision Destruction!", "combat_output")

				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					user.icon_state="Seal"
					etarget.overlays+='icons/watersurround.dmi'
					spawn(5)etarget.overlays-='icons/watersurround.dmi'
					var/turf/L=etarget.loc
					sleep(5)
					var/hit=0
					if(L && L==etarget.loc)
						hit=1
						etarget.Timed_Stun(70)
						//etarget.stunned=7
						//user.stunned=7

					var/obj/O =new(locate(L.x,L.y,L.z))
					O.layer=MOB_LAYER+3
					O.overlays+=image('icons/watercollisiondestruction.dmi',icon_state="0,1",pixel_x=-16,pixel_y=16)
					O.overlays+=image('icons/watercollisiondestruction.dmi',icon_state="1,1",pixel_x=16,pixel_y=16)
					O.overlays+=image('icons/watercollisiondestruction.dmi',icon_state="0,0",pixel_x=-16,pixel_y=-16)
					O.overlays+=image('icons/watercollisiondestruction.dmi',icon_state="1,0",pixel_x=16,pixel_y=-16)
					var/found=0

					for(var/obj/Water/X in oview(4,user))
						found++
						break
					if(found>10)found=10
					if(hit && etarget)
						etarget.Dec_Stam((1400 + 400*conmult + found*50),0,user)
						spawn()etarget.Hostile(user)
					sleep(50)
					//if(etarget)etarget.stunned=0
					//user.stunned=0
					etarget.End_Stun()
					user.End_Stun()
					if(O)del(O)
					user.icon_state=""
