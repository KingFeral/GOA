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
				flick("Throw1",user)

				var/hit=0
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					if(!etarget.protected && !etarget.ko)
						hit=1
				if(hit)
					var/conmult = user.ControlDamageMultiplier()
					var/mob/human/clay/bird/B=new/mob/human/clay/bird(locate(user.x,user.y,user.z),rand(600, (1000+200*conmult)),user)
					spawn(1)Poof(B.x,B.y,B.z)
					spawn(3)Homing_Projectile_bang(user,B,8,etarget,1)
					spawn(50)
						if(B)
							B.Explode()




		exploding_spider
			id = EXPLODING_SPIDER
			name = "Exploding Spider"
			icon_state = "exploading spider"
			default_chakra_cost = 300
			default_cooldown = 30

			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.keys["shift"]) //shift modifies this jutsu to have the spider stay stationary and not chase
						modified = 1

			Use(mob/human/user)
				flick("Throw1",user)
				user.combat("<b>Drag</b> spiders to move them. Press <b>z</b>, <b>click</b> the spider icon on the left side of your screen, or <b>double-click</b> the spider to detonate it.")
				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/clay/spider/B=new/mob/human/clay/spider(user.loc,rand(600,2000)+(400*conmult),user)
				var/obj/trigger/exploding_spider/T = new(user, B)
				var/mob/human/target = user.MainTarget()
				if(!modified && target)
					spawn(10) if(target && B) B.MouseDrop(target)
				user.AddTrigger(T)
				spawn(1) if(B) Poof(B.x,B.y,B.z)




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
				var/p
				user.usemove=1

				//user.stunned+=10
				user.Timed_Stun(15)
				user.icon_state="Seal"
				sleep(15)
				user.icon_state=""
				//user.stunned=0
				if(user.usemove)
					p=used_chakra
					flick("Throw1",user)
					var/obj/C3 = new/obj(locate(user.x,user.y,user.z))
					C3.icon='icons/C3.dmi'
					C3.layer=MOB_LAYER+2.1
					sleep(2)
					step(C3,user.dir)
					sleep(2)
					step(C3,user.dir)
					spawn()Poof(C3.x,C3.y,C3.z)
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
					while(bw>0 && C3)
						switch(bw)
							if(5)
								spawn(12)flick("blink",C3)
							if(4)
								spawn(5)flick("blink",C3)
								spawn(16)flick("blink",C3)
							if(3)
								spawn()flick("blink",C3)
								spawn(10)flick("blink",C3)
							if(2)
								spawn()flick("blink",C3)
								spawn(5)flick("blink",C3)
								spawn(10)flick("blink",C3)
							if(1)
								spawn(0)flick("blink",C3)
								spawn(2)flick("blink",C3)
								spawn(3)flick("blink",C3)
								spawn(5)flick("blink",C3)

						sleep(bw*5)
						bw--
					if(user)
						user.RemoveTrigger(T)
					if(C3)
						C3.overlays=0
						spawn()
							if(C3 && user) explosion(P,C3.x,C3.y,C3.z,user,0,6)
						spawn(pick(1,2,3))
							if(C3 && user) explosion(P,C3.x+1,C3.y+1,C3.z,user,0,6)
						spawn(pick(1,2,3))
							if(C3 && user) explosion(P,C3.x-1,C3.y+1,C3.z,user,0,6)
						spawn(pick(1,2,3))
							if(C3 && user) explosion(P,C3.x-1,C3.y-1,C3.z,user,0,6)
						spawn(pick(1,2,3))
							if(C3 && user) explosion(P,C3.x-1,C3.y-1,C3.z,user,0,6)
						spawn(pick(3,4,5))
							if(C3 && user) explosion(P,C3.x-2,C3.y+2,C3.z,user,0,6)
						spawn(pick(3,4,5))
							if(C3 && user) explosion(P,C3.x+2,C3.y-2,C3.z,user,0,6)
						spawn(pick(3,4,5))
							if(C3 && user) explosion(P,C3.x+2,C3.y+2,C3.z,user,0,6)
						spawn(pick(3,4,5))
							if(C3 && user) explosion(P,C3.x-2,C3.y-2,C3.z,user,0,6)
						spawn(6)
							del(C3)
