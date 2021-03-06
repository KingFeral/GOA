skill
	weapon
		face_nearest = 1
		windmill_shuriken
			id = WINDMILL_SHURIKEN
			name = "Windmill Shuriken"
			icon_state = "windmill"
			default_supply_cost = 8
			default_cooldown = 30



			Use(mob/user)
				viewers(user) << output("[user]: Windmill Shuriken!", "combat_output")
				var/eicon = 'icons/projectiles.dmi'
				var/estate = "windmill-m"
				var/mob/human/player/etarget = user.NearestTarget()

				var/r = rand(0,3)//rand(3,10)
				var/angle
				var/speed = 48
				if(etarget) angle = get_real_angle(user, etarget)
				else angle = dir2angle(user.dir)

				spawn() advancedprojectile_angle(eicon, estate, user, speed, angle, distance=10, damage=900, wounds=r, radius=16)
				//advancedprojectile(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,mob/trueowner,radius)
				//spawn() advancedprojectile(eicon, estate, user, speed*cos(angle), speed*sin(angle), 10, 900, r, 100, 1)




		exploding_kunai
			id = EXPLODING_KUNAI
			name = "Exploding Kunai"
			icon_state = "explkunai"
			default_supply_cost = 20
			default_cooldown = 10



			Use(mob/user)
				user.removeswords()
				var/startdir=user.dir
				flick("Throw1",user)
				var/eicon='icons/projectiles.dmi'
				var/estate="explkunai"

				var/mob/human/player/etarget = user.NearestTarget()
				if(!etarget)
					etarget=straight_proj2(eicon,estate,8,user)
					if(etarget)
						/*var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z*/
						//explosion(1200,ex,ey,ez,user)
						explosion(1200, 0, etarget.loc, user)
					else
						var/explosion_location
						switch(startdir)
							if(EAST)
								explosion_location = locate(user.x+8, user.y, user.z)
								if(explosion_location)
									explosion(1200, 0, explosion_location, user)
							if(WEST)
								explosion_location = locate(user.x-8, user.y, user.z)
								if(explosion_location)
									explosion(1200, 0, explosion_location, user)
							if(NORTH)
								explosion_location = locate(user.x, user.y+8, user.z)
								if(explosion_location)
									explosion(1200, 0, explosion_location, user)
							if(SOUTH)
								explosion_location = locate(user.x, user.y-8, user.z)
								if(explosion_location)
									explosion(1200, 0, explosion_location, user)
				else
					/*var/ex=etarget.x
					var/ey=etarget.y
					var/ez=etarget.z*/
					var/mob/x=new/mob(etarget.loc)

					projectile_to(eicon,estate,user,x)
					//del(x)
					x.dispose()
					//explosion(1500,ex,ey,ez,user)
					explosion(1500, 0, etarget.loc, user)
				user.addswords()




		exploding_note
			id = EXPLODING_NOTE
			name = "Exploding Note"
			icon_state = "explnote"
			default_supply_cost = 10
			default_cooldown = 30
			skill_delay = 0
			var/obj/explosive_tag/etag

			SupplyCost(mob/user)
				if(etag)
					return 0
				else
					return ..(user)

			Cooldown(mob/user)
				if(etag)
					return 0
				else
					return ..(user)

			Use(mob/user)
				set waitfor = 0
				if(!etag)
					AddOverlay('icons/activation.dmi')
					etag = new/obj/explosive_tag(user.loc)
					user.combat("To detonate the tag, press this skill again.")
					etag.owner = user
					etag.trapskill = user.skillspassive[TRAP_MASTERY]
					sleep(14000)
					if(etag)
						etag.dispose()
				else if(user)
					RemoveOverlay('icons/activation.dmi')
					//explosion(2000, etag.x, etag.y, etag.z, user)
					explosion(2000, 0, etag.loc, user)
					etag.dispose()
					etag = null

		manipulate_advancing_blades
			id = MANIPULATE_ADVANCING_BLADES
			name = "Manipulate Advancing Blades"
			icon_state = "Manipulate Advancing Blades"
			default_supply_cost = 30
			default_chakra_cost = 50
			default_cooldown = 30



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.qued || user.qued2)
						Error(user, "A conflicting skill is already activated")
						return 0


			Use(mob/user)
				user.icon_state="Seal"
				//user.stunned=10
				user.Begin_Stun()
				user.dir=SOUTH
				var/obj/X=new/obj(user.loc)
				X.layer=MOB_LAYER+1
				X.icon='icons/advancing.dmi'
				flick("form",X)

				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				sleep(2)
				flick("Throw1",user)
				sleep(2)
				flick("Throw2",user)
				user.overlays+=image('icons/advancing.dmi',icon_state="over")
				user.underlays+=image('icons/advancing.dmi',icon_state="under")
				sleep(2)
				user.qued=1

				user.icon_state=""
				//user.stunned=0
				user.End_Stun()
				del(X)




		shuriken_shadow_clone
			id = SHUIRKEN_KAGE_BUNSHIN
			name = "Shuriken Shadow Clone"
			icon_state = "Shuriken Kage Bunshin no Jutsu"
			default_supply_cost = 1
			default_chakra_cost = 300
			default_cooldown = 60



			Use(mob/user)
				var/d=  user.dir
				flick("Throw1",user)
				var/obj/Du = new/obj(user.loc)
				Du.icon='icons/projectiles.dmi'
				Du.icon_state="shuriken-m"
				Du.density=0


				//sleep(1)
				//walk(Du,user.dir)
				step(Du, d)
				//sleep(2)
				flick("Seal",user)
				for(var/mob/X in oview(0,Du))
					//var/ex=Du.x
					//var/ey=Du.y
					//var/ez=user.z
					Poof(Du.loc)//(ex,ey,ez)
					del(Du)
					return
				var/dx=Du.x
				var/dy=Du.y
				var/dz=user.z
				Poof(Du.loc)//(dx,dy,dz)
				del(Du)
				user.ShadowShuriken(dx,dy,dz,user)




		twin_rising_dragons
			id = TWIN_RISING_DRAGONS
			name = "Twin Rising Dragons"
			icon_state = "Twin Rising Dragons"
			default_supply_cost = 100
			default_chakra_cost = 100
			default_cooldown = 120



			Use(mob/user)
				user.icon_state="Throw1"
				//user.stunned=10
				user.Begin_Stun()
				user.overlays+='icons/twindragon.dmi'
				var/ammo=20
				sleep(15)
				while(ammo>0)
					/*var/xoff=rand(-32,32)
					var/yoff=rand(-32,32)
					while(abs(xoff)+abs(yoff)<32)
						xoff=rand(-32,32)
						yoff=rand(-32,32)*/

					sleep(1)

					var/angle = rand(0, 360)
					var/speed = rand(32, 64)
					spawn() advancedprojectile_angle('icons/twin_proj.dmi', "[pick(1,2,3,4)]", user, speed, angle, distance=7, damage=900, wounds=1, radius=16)
					//advancedprojectilen(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,mob/trueowner,radius)
					//spawn()advancedprojectilen('icons/twin_proj.dmi',"[pick(1,2,3,4)]",user,xoff,yoff,7,900,1,60,1,user)
					Poof(user.loc)//(user.x,user.y,user.z)
					ammo--
				user.icon_state=""
				user.overlays-='icons/twindragon.dmi'
				//user.stunned=0
				user.End_Stun()