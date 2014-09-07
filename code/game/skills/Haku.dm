skill
	haku
		copyable = 0




		sensatsu_suisho
			id = ICE_NEELDES
			name = "Sensatsusuishô"
			icon_state = "ice_needles"
			default_chakra_cost = 200
			default_cooldown = 30
			default_seal_time = 8



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0
					if(!user.NearWater(10))
						Error(user, "Must be near water")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Sensatsusuishô!", "combat_output")

				var/atom/found = user.ClosestWater(10)
				if(!found) return

				var/mob/human/etarget = user.MainTarget()
				var/obj/Q = new/obj/waterblob(locate(found.x,found.y,found.z))

				var/steps = 50
				while(steps > 0 && etarget && Q && (Q.x!=etarget.x || Q.y!=etarget.y) && Q.z==etarget.z && user)
					sleep(1)
					step_to(Q, etarget)
					--steps

				if(!etarget)
					Q.loc = null
					return
				if(!Q) return
				Q.icon_state="none"
				flick("water-needles",Q)
				sleep(1)
				if(!etarget)
					Q.loc = null
					return
				if(!Q) return

				var/list/EX=new
				EX+=new/obj/iceneedle(locate(Q.x+1,Q.y,Q.z))
				EX+=new/obj/iceneedle(locate(Q.x-1,Q.y,Q.z))
				EX+=new/obj/iceneedle(locate(Q.x,Q.y-1,Q.z))
				EX+=new/obj/iceneedle(locate(Q.x,Q.y+1,Q.z))
				EX+=new/obj/iceneedle(locate(Q.x+1,Q.y-1,Q.z))
				EX+=new/obj/iceneedle(locate(Q.x+1,Q.y+1,Q.z))
				EX+=new/obj/iceneedle(locate(Q.x-1,Q.y-1,Q.z))
				EX+=new/obj/iceneedle(locate(Q.x-1,Q.y+1,Q.z))
				var/turf/P = Q.loc

				Q.loc = null
				Q = null

				for(var/obj/M in EX)
					M.Facedir(P)

				sleep(1)

				var/needle_hit = 0
				while(!needle_hit)
					for(var/obj/M in EX)
						if((M.x!=P.x) || (M.y!=P.y))
							step_to(M,P,0)
						else
							needle_hit = 1

					sleep(1)

				for(var/obj/M in EX)
					if(M)
						M.icon_state="NeedleHit"

				sleep(1)

				if(!user)
					for(var/obj/O in EX)
						O.loc = null
					return

				var/conmult = user.ControlDamageMultiplier()

				for(var/mob/human/O in P)
					//O.move_stun+=3
					O.Timed_Stun(20)
					O.Dec_Stam((rand(400,1300)+300*conmult),0,user)
					O.Wound(rand(1,3),0,user)
					O.Hostile(user)
					Blood2(O,user)

				for(var/mob/human/O in oview(1,P))
					O.Dec_Stam((rand(200,300)+70*conmult),0,user)
					O.Hostile(user)

				spawn(30)
					for(var/obj/O in EX)
						O.loc = null




		ice_explosion
			id = ICE_SPIKE_EXPLOSION
			name = "Ice Explosion"
			icon_state = "ice_spike_explosion"
			default_chakra_cost = 350
			default_cooldown = 80
			default_seal_time = 10



			Use(mob/human/user)
				//user.stunned=6
				user.Timed_Stun(60)
				viewers(user) << output("[user]: Ice Explosion!", "combat_output")

				spawn(2)Haku_Spikes(user.x,user.y+1,user.z)
				spawn(1)Haku_Spikes(user.x-1,user.y+2,user.z)
				spawn(1)Haku_Spikes(user.x-1,user.y,user.z)
				spawn(1)Haku_Spikes(user.x+1,user.y+2,user.z)
				spawn(1)Haku_Spikes(user.x+1,user.y,user.z)
				var/conmult = user.ControlDamageMultiplier()
				for(var/mob/human/X in oview(2,user))
					X.Dec_Stam(rand(800,2000)+750*conmult,0,user)
					X.Wound(rand(3,6),0,user)
					X.Hostile(user)
					Blood2(X)




		demonic_ice_crystal_mirrors
			id = DEMONIC_ICE_MIRRORS
			name = "Demonic Ice Crystal Mirrors"
			icon_state = "demonic_ice_mirrors"
			default_chakra_cost = 550
			default_cooldown = 180
			default_seal_time = 3



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0
					if(!user.NearWater(10))
						Error(user, "Must be near water")
						return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: Demonic Ice Crystal Mirrors!", "combat_output")

				var/mob/human/etarget = user.MainTarget()
				var/conmult = user.ControlDamageMultiplier()
				//user.stunned=999
				//user.protected=999
				user.Begin_Stun()
				user.Protect(1000)

				if(etarget)
					user.invisibility=10
					spawn(250)
						if(user && user.invisibility==10)
							user.invisibility=0

					if(!etarget.x)
						user.invisibility=0
						//user.stunned=0
						//user.protected=0
						user.Reset_Stun()
						user.End_Protect()
						return

					var/list/ret = Mirrors(etarget, user)
					if(!ret || !istype(ret)) return
					var/list/mirrorlist = ret["mirrors"]
					var/turf/cen = ret["center"]

					sleep(20)

					var/demonmirrored = 0

					var/list/Gotchad=new
					for(var/mob/G in range(2,cen))
						if(G!=user)
							demonmirrored = 1
							Gotchad+=G
							//G.stunned+=13
							G.Timed_Stun(130)
							spawn() G.Hostile(user)

					if(demonmirrored)
						for(var/obj/M in mirrorlist)
							if(M.icon!='icons/Haku.dmi')
								flick("Throw1",M)

							for(var/mob/OG in Gotchad)
								spawn() if(OG) projectile_to('icons/projectiles.dmi',"needle-m",M,OG)
								if(!OG.icon_state)
									OG.icon_state="Hurt"
									spawn(10)
										if(OG && OG.icon_state=="Hurt")
											OG.icon_state=""

						for(var/mob/G in range(2,cen))
							if(G != src)
								if(!G.ironskin)
									G.overlays += 'icons/needlepwn.dmi'

						sleep(2)

						for(var/i in 1 to 5)
							for(var/obj/M in mirrorlist)
								if(M.icon!='icons/Haku.dmi')
									flick("Throw1",M)

								for(var/mob/OG in Gotchad)
									spawn()projectile_to('icons/projectiles.dmi',"needle-m",M,OG)

								sleep(2)

						spawn(5)
							for(var/mob/OG in Gotchad)
								OG.Wound(rand(15,40),0,user)
								OG.Dec_Stam(rand(500,1000)+500*conmult,0,user)

						//user.stunned=0
						user.End_Stun()
						//user.protected=0
						user.End_Protect()
						user.invisibility=0

						for(var/obj/M in mirrorlist)
							del(M)

						spawn(100)
							for(var/mob/OG in Gotchad)
								OG.overlays-='icons/needlepwn.dmi'

					else
						//user.stunned=0
						user.End_Stun()
						//user.protected=0
						user.End_Protect()
						user.invisibility=0
						for(var/M in mirrorlist)
							del(M)
						return

				//user.protected=0
				user.End_Protect()
				//user.stunned=0
				user.End_Stun()
				user.invisibility=0




mob
	proc
		NearWater(range=world.view)
			for(var/obj/Water/X in oview(src, range))
				return 1
			for(var/turf/X in oview(src, range))
				if(Iswater(X.x,X.y,X.z))
					return 1
			return 0


		ClosestWater(range=world.view)
			var/closest
			var/closest_dist = 1e40
			for(var/obj/Water/X in oview(src, range))
				if(get_dist(src, X) < closest_dist)
					closest = X
					closest_dist = closest_dist
			for(var/turf/X in oview(src, range))
				if(Iswater(X.x,X.y,X.z) && get_dist(src, X) < closest_dist)
					closest = X
					closest_dist = closest_dist
			return closest




proc
	Mirrors(mob/target, mob/user)
		if(!target || !user) return

		var/atom/water = user.ClosestWater(10)
		if(!water) return

		var/obj/Q = new/obj/waterblob(locate(water.x,water.y,water.z))
		while(get_dist(Q, target) > 1)
			step_to(Q, target)
			sleep(1)
			if(!Q || !target || !user) return

		var/turf/cen = Q.loc
		Q.loc = null
		Q = null

		var/mirrorlist[0]
		mirrorlist+=Make_Mirror(cen, -2, 0, "Right", user, pixel_x = -16)
		mirrorlist+=Make_Mirror(cen, -2, 1, "Right", user)
		mirrorlist+=Make_Mirror(cen, -2, -1, "Right", user)
		mirrorlist+=Make_Mirror(cen, -1, 2, "Back", user)
		mirrorlist+=Make_Mirror(cen, 0, 2, "Back", user, pixel_y = 16)
		mirrorlist+=Make_Mirror(cen, 1, 2, "Back", user)
		mirrorlist+=Make_Mirror(cen, 2, 0, "Left", user, pixel_x = 16)
		mirrorlist+=Make_Mirror(cen, 2, 1, "Left", user)
		mirrorlist+=Make_Mirror(cen, 2, -1, "Left", user)
		mirrorlist+=Make_Mirror(cen, -1, -2, "Back", user, hide = 1)
		mirrorlist+=Make_Mirror(cen, 0, -2, "Back", user, pixel_y = -16, hide = 1)
		mirrorlist+=Make_Mirror(cen, 1, -2, "Back", user, hide = 1)
		return list("center" = cen, "mirrors" = mirrorlist)


	Make_Mirror(atom/start, dx, dy, state, mob/user, pixel_x=0, pixel_y=0, hide=0)
		if(!user || !start)
			return

		var/turf/mirror_loc=locate(start.x+dx,start.y+dy,user.z)
		if(!mirror_loc) return

		var/obj/mirror/X=new/obj/mirror(mirror_loc)
		X.invisibility = 101

		switch(state)
			if("Back")
				if(!hide)
					X.icon=user.icon
					X.overlays+=user.overlays
				X.underlays+=/obj/mirror/Back
				X.overlays+=/obj/mirror/Front

			if("Right", "Left")
				X.icon='icons/Haku.dmi'
				X.icon_state=state

		X.pixel_x=pixel_x
		X.pixel_y=pixel_y

		spawn()
			var/obj/Q = new/obj/waterblob(start)
			while(Q.loc != mirror_loc)
				step_to(Q, mirror_loc)
				sleep(1)
				if(!user)
					del(Q)
					return

			Q.icon_state="none"
			switch(state)
				if("Right")
					Q.dir=EAST
				if("Left")
					Q.dir=WEST
				if("Back")
					Q.dir=NORTH
			flick("formmirrors",Q)
			sleep(12)
			del(Q)
			X.invisibility = 0

		return X




obj
	mirror
		layer=MOB_LAYER
		density=1




		Back
			icon='icons/Haku.dmi'
			icon_state="Back"




		Front
			icon='icons/Haku.dmi'
			icon_state="Front"



		New()
			..()
			spawn(900)
				del(src)




	waterblob
		icon='icons/Haku.dmi'
		icon_state="water"
		layer=MOB_LAYER+3
		density=0




	iceneedle
		icon='icons/Haku.dmi'
		icon_state="Needles"
		layer=MOB_LAYER+3
		density=0



		New()
			..()
			flick("formNeedles",src)