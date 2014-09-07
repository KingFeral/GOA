skill
	nara
		copyable = 0




		shadow_binding
			id = SHADOW_IMITATION
			name = "Shadow Binding"
			icon_state = "shadow_imitation"
			default_chakra_cost = 50
			default_cooldown = 10



			ChakraCost(mob/user)
				if(!user.mane)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(!user.mane)
					return ..(user)
				else
					return 0


			Use(mob/user)
				if(user.mane)
					user.combat("Remove!")
					user.mane=0
					ChangeIconState("shadow_imitation")
					return
				user.icon_state="Seal"
				//user.stunned=10
				user.Begin_Stun()
				sleep(15)
				viewers(user) << output("[user]: Shadow Binding!", "combat_output")
				var/targets[] = user.NearestTargets(num=3)
				if(targets && targets.len)
					for(var/mob/human/player/etarget in targets)
						spawn()
							var/obj/trailmaker/o=new/obj/trailmaker/Shadow()
							var/mob/result=Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,8,etarget)
							if(result)
								//user.stunned=0
								user.End_Stun()
								o.icon=0
								++user.mane
								ChangeIconState("cancel_shadow")
								result.underlays+='icons/shadow.dmi'
								result.maned=user.key
								var/cost=10
								var/resultx=Roll_Against(user.con+user.conbuff-user.conneg,result.str+result.strbuff-result.strneg,100)
								if(resultx>=6)
									cost=user.chakra/60
								if(resultx==5)
									cost=user.chakra/50
								if(resultx==4)
									cost=user.chakra/40
								if(resultx==3)
									cost=user.chakra/35
								if(resultx==2)
									cost=user.chakra/20
								if(resultx==1)
									cost=user.chakra/10
								var/rx=result.x
								var/ry=result.y
								//result.stunned = 3
								result.Timed_Stun(10)

								while(user && user.mane && user.curchakra>cost&&result&&result.x==rx&&result.y==ry)
									user.curchakra-=cost
									sleep(10)
								del(o)
								if(result)
									result.underlays-='icons/shadow.dmi'
									result.maned=0
									//result.stunned=1
									result.End_Stun()
									result.Timed_Stun(10)
									if(user) spawn()result.Hostile(user)
							if(user)
								user.mane = max(0, user.mane - 1)
								if(!user.mane)
									user.icon_state=""
									//user.stunned=0
									user.End_Stun()
									ChangeIconState("shadow_imitation")
				else
					var/obj/trailmaker/o=new/obj/trailmaker/Shadow()
					var/mob/result=Trail_Straight_Projectile(user.x,user.y,user.z,user.dir,o,8)
					if(result)
						spawn()
							//user.stunned=0
							user.End_Stun()
							o.icon=0
							user.mane=1
							ChangeIconState("cancel_shadow")
							var/cost=10
							result.underlays+='icons/shadow.dmi'
							result.maned=user.key
							var/resultx=Roll_Against(user.con+user.conbuff-user.conneg,result.str+result.strbuff-result.strneg,100)
							if(resultx>=6)
								cost=user.chakra/60
							if(resultx==5)
								cost=user.chakra/50
							if(resultx==4)
								cost=user.chakra/40
							if(resultx==3)
								cost=user.chakra/35
							if(resultx==2)
								cost=user.chakra/20
							if(resultx==1)
								cost=user.chakra/10
							var/rx=result.x
							var/ry=result.y
							//result.stunned = 3
							result.Timed_Stun(10)
							while(result&&user&&user.mane && user.curchakra>cost&& result.x==rx&&result.y==ry)
								user.curchakra-=cost
								sleep(20)
							del(o)

							if(result)
								result.underlays-='icons/shadow.dmi'
								result.maned=0
								//result.stunned=1
								result.End_Stun()
								result.Timed_Stun(10)
								if(user) spawn()result.Hostile(user)
							if(user)
								user.icon_state=""
								//user.stunned=0
								user.End_Stun()
								user.mane=0
								ChangeIconState("shadow_imitation")
					else if(user)
						user.icon_state=""
						//user.stunned=0
						user.End_Stun()
						user.mane=0




		shadow_neck_bind
			id = SHADOW_NECK_BIND
			name = "Shadow Neck Bind"
			icon_state = "shadow_neck_bind"
			default_chakra_cost = 100
			default_cooldown = 5



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.mane)
						Error(user, "Cannot be used without Shadow Binding active")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Shadow Neck Bind!", "combat_output")
				var/conmult = user.ControlDamageMultiplier()
				for(var/mob/human/x in oview(8))
					if(x.maned==user.key)
						var/obj/o =new/obj(locate(x.x,x.y,x.z))
						o.layer=MOB_LAYER+1
						o.icon='icons/shadowneckbind.dmi'
						spawn(18)
							if(x && !x.icon_state)
								flick("hurt",x)
						flick("choke",o)
						spawn(20)
							del(o)
						if(x) x.Dec_Stam((1000+(500*conmult)),0,user)
						spawn(50)if(x) x.Hostile(user)




		shadow_sewing
			id = SHADOW_SEWING_NEEDLES
			name = "Shadow Sewing"
			icon_state = "shadow_sewing_needles"
			default_chakra_cost = 200
			default_cooldown = 80
			var
				active_needles = 0



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.MainTarget())
						Error(user, "No Target")
						return 0

			proc
				Needle_Target_Update(list/needle_list, mob/target)
					for(var/obj/trailmaker/tm in needle_list)
						tm.trail_target = target

			Use(mob/human/user)
				viewers(user) << output("[user]: Shadow Sewing!", "combat_output")
				user.icon_state="Seal"
				spawn(10)
					user.icon_state = ""
				//user.stunned=10
				user.Begin_Stun()
				var/conmult = user.ControlDamageMultiplier()
				var/targets[] = user.NearestTargets(num=3)
				if(targets)
					if(targets.len == 1)
						var/mob/human/eTarget = user.NearestTarget()
						var/list/needle_list = new
						active_needles += 3
						spawn(1)
							var/obj/trailmaker/o=new/obj/trailmaker/Shadowneedle(locate(user.x,user.y,user.z))
							needle_list.Add(o)
							sleep(1)
							var/mob/human/result = Trail_Homing_ProjectileX(user.x,user.y,user.z,sewing_dir(user,1),o,20,eTarget,1,1,0,0,2,user)
							var/mob/human/orig_result = result
							if(result)
							//	result = result.Replacement_Start(user)
								if(result != orig_result) Needle_Target_Update(needle_list, result)
								//result.Damage(rand(400,(300+300*conmult)),rand(1,2),user,"Shadow Sewing Needle","Normal")
								result.Dec_Stam(rand(400,(300+300*conmult)), 0, user)
								result.Wound(rand(1,2),0,user)
								if(!result.ko && !result.protected)
									result.Timed_Move_Stun(30)
									spawn()Blood2(result,user)
									o.icon_state="still"
									spawn()result.Hostile(user)
							//spawn(5) if(result) result.Replacement_End()
							--active_needles
							if(active_needles <= 0)
								spawn(20)
									user.End_Stun()
							o.loc = null

						spawn(1)
							var/obj/trailmaker/o=new/obj/trailmaker/Shadowneedle(locate(user.x,user.y,user.z))
							needle_list.Add(o)
							var/mob/human/result = Trail_Homing_ProjectileX(user.x,user.y,user.z,sewing_dir(user,2),o,20,eTarget,1,1,0,0,2,user)
							var/mob/human/orig_result = result
							if(result)
								//result = result.Replacement_Start(user)
								if(result != orig_result) Needle_Target_Update(needle_list, result)
								//result.Damage(rand(400,(300+300*conmult)),rand(1,2),user,"Shadow Sewing Needle","Normal")
								result.Dec_Stam(rand(400,(300+300*conmult)), 0, user)
								result.Wound(rand(1,2),0,user)
								if(!result.ko && !result.protected)
									result.Timed_Move_Stun(30)
									spawn()Blood2(result,user)
									o.icon_state="still"
									spawn()result.Hostile(user)
							//spawn(5) if(result) result.Replacement_End()
							--active_needles
							if(active_needles <= 0)
								spawn(20)
									user.End_Stun()
							o.loc = null

						spawn(1)
							var/obj/trailmaker/o=new/obj/trailmaker/Shadowneedle(locate(user.x,user.y,user.z))
							needle_list.Add(o)
							sleep(1)
							var/mob/human/result = Trail_Homing_ProjectileX(user.x,user.y,user.z,sewing_dir(user,3),o,20,eTarget,1,1,0,0,2,user)
							var/mob/human/orig_result = result
							if(result)
								//result = result.Replacement_Start(user)
								if(result != orig_result) Needle_Target_Update(needle_list, result)
								//result.Damage(rand(400,(300+300*conmult)),rand(1,2),user,"Shadow Sewing Needle","Normal")
								result.Dec_Stam(rand(400,(300+300*conmult)), 0, user)
								result.Wound(rand(1,2),0,user)
								if(!result.ko && !result.protected)
									result.Timed_Move_Stun(30)
									spawn()Blood2(result,user)
									o.icon_state="still"
									spawn()result.Hostile(user)
							//spawn(5) if(result) result.Replacement_End()
							--active_needles
							if(active_needles <= 0)
								spawn(20)
									user.End_Stun()
							o.loc = null
					else
						for(var/mob/human/player/target in targets)
							++active_needles
							spawn()
								var/obj/trailmaker/o=new/obj/trailmaker/Shadowneedle(locate(user.x,user.y,user.z))
								var/mob/result = Trail_Homing_Projectile(user.x,user.y,user.z,user.dir,o,20,target,1,1,0,0,1,user)
								if(result)
									result.Dec_Stam(rand(600, (900+300*conmult)), 0, user)
									result.Wound(rand(2, 5), 0, user)
									if(!result.ko && !result.protected)
										//result.move_stun = 100
										result.Timed_Move_Stun(100)
										spawn()Blood2(result,user)
										o.icon_state="still"
										spawn()result.Hostile(user)
								--active_needles
								if(active_needles <= 0)
									//user.stunned = 0
									user.End_Stun()
								del(o)


proc/Trail_Homing_ProjectileX(dx,dy,dz,xdir,obj/trailmaker/proj,xdur,mob/human/M,dontdelete,hitinnocent,modx,mody,lag,mob/U)
	if(M)
		proj.trail_target = M
		proj.loc=locate(dx,dy,dz)
		proj.dir=xdir
		var/i = xdur
		proj.density=0

		if(modx==-1)
			proj.dir=WEST
			step(proj,proj.dir)
			sleep(1)
			step(proj,proj.dir)
			sleep(1)
		else if(modx==1)
			proj.dir=EAST
			step(proj,proj.dir)
			sleep(1)
			step(proj,proj.dir)
			sleep(1)

		if(mody==-1)
			proj.dir=SOUTH
			step(proj,proj.dir)
			sleep(1)
			step(proj,proj.dir)
			sleep(1)
		else if(mody==1)
			proj.dir=NORTH
			step(proj,proj.dir)
			sleep(1)
			step(proj,proj.dir)
			sleep(1)

		if(modx || mody)
			sleep(2)

		proj.density=1

		var/mob/hit
		var/sewingstep=0
		while(sewingstep<=1)
			step(proj,proj.dir)
			sewingstep++
			sleep(2)

		sleep(3)

		while(proj.trail_target && proj && i>0 && !hit)
			proj.dir = angle2dir(get_real_angle(proj, proj.trail_target))

			var/hit_human = 0
			for(var/mob/human/R in get_step(proj,proj.dir))
				if(R && /*!R.mole && */R!=U)
					hit_human = 1
					R.Timed_Move_Stun(10)

			if(hit_human)
				proj.density=0

			step(proj,proj.dir)

			if(hit_human)
				proj.density=1

			for(var/mob/human/F in proj.loc)
				if(F==proj.trail_target || (hitinnocent && F!=U))
					hit=F
					break

			sleep(world.tick_lag * lag)
			i--

		if(hit)
			return hit
	proj.loc = null
	return 0

proc
	sewing_dir(mob/m, var/which = 0)
		if(which == 1)

			if(m.dir == NORTH)
				return EAST
			else if(m.dir == SOUTH)
				return EAST
			else if(m.dir == EAST)
				return NORTH
			else if(m.dir == NORTHEAST)
				return NORTH
			else if(m.dir == SOUTHEAST)
				return NORTH
			else if( m.dir == WEST)
				return NORTH
			else if( m.dir == NORTHWEST)
				return NORTH
			else if( m.dir == SOUTHWEST)
				return NORTH

		else if(which == 2)
			if(m.dir == NORTH)
				return NORTH
			else if(m.dir == SOUTH)
				return SOUTH
			else if( m.dir == EAST)
				return EAST
			else if( m.dir == NORTHEAST)
				return EAST
			else if( m.dir == SOUTHEAST)
				return EAST
			else if( m.dir == WEST)
				return WEST
			else if( m.dir == NORTHWEST)
				return WEST
			else if( m.dir == SOUTHWEST)
				return WEST

		else if(which == 3)

			if(m.dir == NORTH)
				return WEST
			if(m.dir == SOUTH)
				return WEST
			else if( m.dir == EAST)
				return SOUTH
			else if( m.dir == NORTHEAST)
				return SOUTH
			else if( m.dir == SOUTHEAST)
				return SOUTH
			else if( m.dir == WEST)
				return SOUTH
			else if( m.dir == NORTHWEST)
				return SOUTH
			else if( m.dir == SOUTHWEST)
				return SOUTH
