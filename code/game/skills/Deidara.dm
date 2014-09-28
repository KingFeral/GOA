skill
	deidara
		copyable = 0




		exploding_bird
			id = EXPLODING_BIRD
			name = "Exploding Bird"
			icon_state = "exploading bird"
			default_chakra_cost = 300
			default_cooldown = 15



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.MainTarget()
				if(.)
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 10)
						Error(user, "Target too far ([distance]/10 tiles)")
						return 0


			Use(mob/human/user)
				set waitfor = 0
				flick("Throw1",user)

				/*var/hit=0
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(!etarget.protected && !etarget.ko)
						hit=1
				if(hit)*/
				var/conmult = user.ControlDamageMultiplier()
				var/targets[] = user.NearestTargets(num = 10)
				var/stamina_damage = rand(800 + 200 * conmult, (1200 + 200 * conmult))
				if(targets && targets.len)
					for(var/mob/m in targets)
						var/mob/human/clay/bird/b = new(user.loc, stamina_damage, user)
						stamina_damage *= 0.90 // Lower damage for each subsequent target.
						if(b)
							Poof(b.loc)
							Homing_Projectile_bang(user, b, 10, m, 1)

	/*			var/mob/human/clay/bird/B=new/mob/human/clay/bird(locate(user.x,user.y,user.z),rand(600+200*conmult, (1000+200*conmult)),user)
				if(B)
					Poof(B.loc)//(B.x,B.y,B.z)
					Homing_Projectile_bang(user,B,10,etarget,1)
				sleep(50)
				if(B)
					B.Explode()*/




		exploding_spider
			id = EXPLODING_SPIDER
			name = "Exploding Spider"
			icon_state = "exploading spider"
			default_chakra_cost = 300
			default_cooldown = 30

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.keys && user.keys["shift"]) //shift modifies this jutsu to have the spider stay stationary and not chase
						modified = 1

			Use(mob/human/user)
				flick("Throw1",user)
				user.combat("<b>Drag</b> spiders to move them. Press <b>z</b>, <b>click</b> the spider icon on the left side of your screen, or <b>double-click</b> the spider to detonate it.")
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/clay/spider/B=new/mob/human/clay/spider(user.loc,1000+(550*conmult),user,modified)
				B.owner=user
				var/obj/trigger/exploding_spider/T = new(user, B)

				user.AddTrigger(T)
				if(B) Poof(B.loc)//(B.x,B.y,B.z)




		c3
			id = C3
			name = "C3"
			icon_state = "c3"
			default_chakra_cost = 800
			default_cooldown = 160
			var/used_chakra



			ChakraCost(mob/user)
				used_chakra = user.curchakra
				if(used_chakra > default_chakra_cost)
					return used_chakra
				else
					return default_chakra_cost


			Use(mob/human/user)
				set waitfor = 0
				var/p
				user.usemove=1

				//user.stunned+=10
				user.Timed_Stun(15)
				user.icon_state="Seal"
				sleep(15)
				user.icon_state=""
				//user.stunned=0
				if(user && user.usemove)
					p=used_chakra
					flick("Throw1",user)
					var/obj/C3 = new/obj(locate(user.x,user.y,user.z))
					C3.icon='icons/C3.dmi'
					C3.layer=MOB_LAYER+2.1
					sleep(2)
					step(C3,user.dir)
					sleep(2)
					step(C3,user.dir)
					Poof(C3.loc)//(C3.x,C3.y,C3.z)
					C3.icon=null
					C3.overlays+=image('icons/C3_tl.dmi',pixel_x=-16,pixel_y=32)
					C3.overlays+=image('icons/C3_tr.dmi',pixel_x=16,pixel_y=32)
					C3.overlays+=image('icons/C3_bl.dmi',pixel_x=-16)
					C3.overlays+=image('icons/C3_br.dmi',pixel_x=16)
					var/P=p*5 + 3250*user.ControlDamageMultiplier() + rand(200,1000)
					C3.power=P
					var/obj/trigger/C3/T = new(usr, C3)

					user.combat("The C3 will automatically detonate after flashing. If you wish to detonate it faster, press <b>z</b> or <b>click</b> the C3 icon on the left side of your screen,")
					user.AddTrigger(T)
					var/bw=5
					sleep(bw * 25)

					if(user && T && (T in user.triggers))
						user.RemoveTrigger(T)
					if(C3)
						C3.overlays = 0
						//explosion(P, C3.x, C3.y, C3.z, user, 0, 6)
						explosion(P, 0, C3.loc, user, list("distance" = 6))
						new/Event(pick(1, 2, 3), "delayed_explosion", list(P,C3.x+1,C3.y+1,C3.z,user,0,6))
						new/Event(pick(1, 2, 3), "delayed_explosion", list(P,C3.x-1,C3.y+1,C3.z,user,0,6))
						new/Event(pick(1, 2, 3), "delayed_explosion", list(P,C3.x-1,C3.y-1,C3.z,user,0,6))
						new/Event(pick(1, 2, 3), "delayed_explosion", list(P,C3.x-1,C3.y-1,C3.z,user,0,6))
						new/Event(pick(3, 4, 5), "delayed_explosion", list(P,C3.x-2,C3.y+2,C3.z,user,0,6))
						new/Event(pick(3, 4, 5), "delayed_explosion", list(P,C3.x+2,C3.y-2,C3.z,user,0,6))
						new/Event(pick(3, 4, 5), "delayed_explosion", list(P,C3.x+2,C3.y+2,C3.z,user,0,6))
						new/Event(pick(3, 4, 5), "delayed_explosion", list(P,C3.x-2,C3.y-2,C3.z,user,0,6))


						C3.loc = null