skill
	fire
		face_nearest = 1
		grand_fireball
			id = KATON_FIREBALL
			name = "Fire: Grand Fireball"
			icon_state = "grand_fireball"
			default_chakra_cost = 150
			default_cooldown = 60
			default_seal_time = 5



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(. && target)
					var/distance = get_dist(user, target)
					if(distance > 5)
						Error(user, "Target too far ([distance]/5 tiles)")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Fire: Grand Fireball!", "combat_output")

				user.icon_state = "Seal"
				user.overlays += 'icons/breathfire.dmi'
				//user.stunned=5
				user.Timed_Stun(20)

				//AOE(x,y,z,radius,stamdamage,duration)
				var/dir = user.dir
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir
				var/conmult = user.ControlDamageMultiplier()
				if(dir == NORTH)
					spawn() AOE(user.x, user.y + 3, user.z, 2, (100 + conmult * 50), 50, user, 3, 1)
					spawn() Fire(user.x, user.y + 3, user.z, 2, 50)

				if(dir == SOUTH)
					spawn() AOE(user.x, user.y - 3, user.z, 2, (100 + conmult * 30), 50, user, 3, 1)
					spawn() Fire(user.x, user.y- 3, user.z, 2, 50)

				if(dir == EAST)
					spawn() AOE(user.x + 3, user.y, user.z, 2, (100 + conmult * 30), 50, user, 3, 1)
					spawn() Fire(user.x + 3, user.y, user.z, 2, 50)

				if(dir == WEST)
					spawn() AOE(user.x - 3, user.y, user.z, 2, (100 + conmult * 30), 50, user, 3, 1)
					spawn() Fire(user.x - 3, user.y, user.z, 2, 50)

				spawn(20)
					user.icon_state = ""
					user.overlays -= 'icons/breathfire.dmi'



		hosenka
			id = KATON_PHOENIX_FIRE
			name = "Fire: Hôsenka"
			icon_state = "katon_phoenix_immortal_fire"
			default_chakra_cost = 50
			default_cooldown = 10



			Use(mob/human/user)
				user.icon_state="Seal"

				viewers(user) << output("[user]: Fire: Hôsenka!", "combat_output")

				spawn()
					var/eicon='icons/fireball.dmi'
					var/estate=""
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/player/etarget = user.NearestTarget()

					if(!etarget)
						etarget=straight_proj2(eicon,estate,8,user)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()AOE(ex,ey,ez,1,(100 +30*conmult),20,user,3,1)
							spawn()Fire(ex,ey,ez,1,20)
					else
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						var/mob/x=new/mob(locate(ex,ey,ez))

						projectile_to(eicon,estate,user,x)
						del(x)
						spawn()AOE(ex,ey,ez,1,(100 +30*conmult),20,user,3,1)
						spawn()Fire(ex,ey,ez,1,20)
					user.icon_state=""



		burning_ash
			id = KATON_ASH_BURNING
			name = "Fire: Ash Accumulation Burning"
			icon_state = "katon_ash_product_burning"
			default_chakra_cost = 450
			default_cooldown = 120
			default_seal_time = 10



			Use(mob/human/user)
				viewers(user) << output("[user]: Fire: Ash Accumulation Burning!", "combat_output")

				user.icon_state="Seal"
				user.overlays+='icons/breathfire2.dmi'
				//user.stunned=10
				user.Timed_Stun(30)
				var/dir = user.dir
				var/mob/human/player/etarget = user.NearestTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir
				var/conmult = user.ControlDamageMultiplier()
				//AOE(x,y,z,radius,stamdamage,duration)
				if(dir==NORTH)
					spawn()AOE(user.x,user.y+5,user.z,4,(75+40*conmult),90,user,2,1)
					spawn()Ash(user.x,user.y+5,user.z,100)
				if(dir==SOUTH)
					spawn()AOE(user.x,user.y-5,user.z,4,(75+40*conmult),90,user,2,1)
					spawn()Ash(user.x,user.y-5,user.z,100)
				if(dir==EAST)
					spawn()AOE(user.x+5,user.y,user.z,4,(75+40*conmult),90,user,2,1)
					spawn()Ash(user.x+5,user.y,user.z,100)
				if(dir==WEST)
					spawn()AOE(user.x-5,user.y,user.z,4,(75+40*conmult),90,user,2,1)
					spawn()Ash(user.x-5,user.y,user.z,100)
				spawn(30)
					if(user)
						user.icon_state=""
						user.overlays-='icons/breathfire2.dmi'



		fire_dragon_flaming_projectile
			id = KATON_DRAGON_FIRE
			name = "Fire: Fire Dragon Flaming Projectile"
			icon_state = "dragonfire"
			default_chakra_cost = 500
			default_cooldown = 70
			default_seal_time = 7



			Use(mob/human/user)
				user.icon_state="Seal"
				viewers(user) << output("[user]: Fire: Fire Dragon Flaming Projectile!", "combat_output")
				//user.stunned=15
				user.Begin_Stun()
				var/image/I2=image('icons/dragonfire.dmi',icon_state="overlay")
				user.overlays+=I2
				var/obj/trailmaker/o=new/obj/trailmaker/Dragon_Fire()
				o.layer=MOB_LAYER+2

				var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,14,user)
				if(result)
					//result.move_stun=100
					result.Timed_Move_Stun(100)

					spawn(45)
						del(o)
						user.overlays-=I2
						user.End_Stun()
						//if(result)result.move_stun=0
						if(result)
							result.Reset_Move_Stun()
					o.overlays+=image('icons/dragonfire.dmi',icon_state="hurt")
					var/turf/T=result.loc
					var/conmult = user.ControlDamageMultiplier()
					result.Dec_Stam(rand(1500,2000)+500*conmult,0,user)
					spawn()result.Wound(rand(5,10)+round(conmult),0,user)
					var/ie=3
					while(result&&T==result.loc && ie>0)
						ie--
						result.Dec_Stam(rand(250,600)+50*conmult,0,user)
						spawn()result.Wound(rand(1,3)+round(conmult/2),0,user)
						spawn()result.Hostile(user)
						sleep(15)

				else
					//user.stunned=0
					user.End_Stun()
					user.overlays-=I2
				user.icon_state=""
