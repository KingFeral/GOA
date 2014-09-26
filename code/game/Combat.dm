

// combat flag

#define OFFENSE_FLAG 1
#define DEFENSE_FLAG 2

mob
	var
		tmp/combat_flag_offense = 0
		tmp/combat_flag_defense = 0
		tmp/combat_protection = 1

	new_player/verb/togglecombat()
		combat_protection = !combat_protection
		if(combat_protection)
			usr << "Combat protection flag toggled on!"
		else
			usr << "Combat protection flag toggled off!"

	proc/combat_flagged(flag)
		if(dojo || !pk)
			return 0
		if(flag)
			if(flag & OFFENSE_FLAG) return combat_flag_offense > world.time
			if(flag & DEFENSE_FLAG) return combat_flag_defense > world.time
		else
			return combat_flag_offense > world.time || combat_flag_defense > world.time

	proc/combat_flag(flag, time = 300)
		if(!flag)
			combat_flag_offense = world.time + time
			combat_flag_defense = world.time + time
		else
			if(flag & OFFENSE_FLAG) combat_flag_offense = world.time + time
			if(flag & DEFENSE_FLAG) combat_flag_defense = world.time + time

proc/opposite_dir(d)
	switch(d)
		if(NORTH) return SOUTH
		if(SOUTH) return NORTH
		if(EAST) return WEST
		if(WEST) return EAST
		if(NORTHEAST) return SOUTHWEST
		if(NORTHWEST) return SOUTHEAST
		if(SOUTHEAST) return NORTHEAST
		if(SOUTHWEST) return NORTHEAST

mob/proc/canmove()
	if(stunned || ko || maned || kaiten || incombo || paralysed) return FALSE
	return TRUE

mob
	var/tmp/dashtime = 0

mob/proc/dash(var/mob/Mob, var/distance)
	if(!Mob || !distance)
		return 0

	dashtime = world.time + 30

	while(distance > 0 && get_dist(src, Mob) > 1)
		if(!(distance % 2))
			sleep(1)
		var/turf/t = get_step_towards(src, Mob)
		var/mob/locate_mob = locate() in t
		if(!canmove() || !t || t.density || locate_mob) break
		step_towards(src, t)
		distance--

mob/var/afteryou=0
mob/var/tmp/lastdash=0

obj/interactable
	paper
		verb
			Interact()
				set hidden=1
				set src in oview(1)

mob/human/npc/shopnpc
	Dec_Stam()
		return
	Wound()
		return
	Hostile()
		return
	interact="Shop"
	verb
		Shop()
			set src in oview(1)
			set hidden=1
			src.Check_Sales(usr)

mob/human/npc/clothing_shop_npc
	interact="Shop"
	verb
		Shop()
			set src in oview(1)
			set hidden=1
			src.Check_Sales(usr)

mob/human/npc/doctornpc
	interact="Doctor"

	verb
		Heal()
			set src in oview(1)
			set hidden=1
			usr<<"Hello, if you need to recover there are beds to the right up the stairs. (press space/interact to get in one)"

obj
	haku_ice
		var/dissipate_count = 0
		icon = 'icons/haku_ice.dmi'
		New()
			set waitfor = 0
			. = ..()
			flick("create", src)
			while(loc)
				sleep(1)
				++dissipate_count
				for(var/mob/human/M in loc)
					if(M.clan == "Haku")
						dissipate_count = 0
						break
				if(dissipate_count > 50)// del src
					loc = null

/*obj/water
	Crossed(mob/m)
		if(!istype(m))
			return ..()

		if(m.clan == "Haku" && !m.body_replacement)
			new/obj/haku_ice(loc)
		else
			m.waterlogged = 1
			if(m.curchakra>5)
				m.curchakra-=5
			else if(m.curstamina>25)
				m.curstamina-=25

	Uncrossed(mob/m)
		if(!istype(m))
			return ..()

		m.waterlogged = 0*/



mob
	var/tmp/stunendall = 0
	var/tmp/movestunendall = 0
	var/tmp/list/slows[] = list()
	proc
		//Stun
		Timed_Stun(time)
			set waitfor = 0
			if(/*src.chambered || */src.IsProtected()) return
			if(isguard)
				isguard = 0
			Begin_Stun()
			while(time)
				if(stunendall) break
				time = max(time - 1, 0)
				sleep(1)
			End_Stun()

		Begin_Stun()
			//overlays += 'icons/new/stunned.dmi'
			stunned++

		End_Stun()
			stunned = max(0, --stunned)
			//if(!stunned)
			//	overlays -= 'icons/new/stunned.dmi'
			//stunned--
			//if(stunned < 0) stunned = 0
		Reset_Stun()
			set waitfor = 0
			stunned = 0
			stunendall = 1
			sleep(1)
			stunendall = 0

		//Move Stun
		Timed_Move_Stun(time,severity=2)
			set waitfor = 0
			if(skillspassive[BUILT_SOLID])
				if(prob(skillspassive[BUILT_SOLID] * 4))
					return
			if(/*src.chambered || */src.IsProtected()) return
			//Begin_Move_Stun()
			//if(client) client.run_count = 0
			runlevel = 0
			move_stun++
			slows.Add(severity)
			while(time > 0)
				if(movestunendall) break
				--time
				sleep(1)
			if(move_stun > 0) move_stun--
			slows.Remove(severity)
			//End_Move_Stun()
		Get_Move_Stun()
			. = 0
			if(slows.len)
				for(var/i in slows)
					if(!.)
						. = i
					else if(i > .)
						. = i
			if(Size)
				. += Size

		Reset_Move_Stun()
			set waitfor = 0
			move_stun = 0
			movestunendall = 1
			sleep(1)
			movestunendall = 0

mob/var/tmp/protectendall = 0
mob/proc
	Protect(protect_time as num)
		set waitfor = 0
		protected++
		while(protect_time > 0)
			if(protectendall)
				--protectendall
				if(protectendall < 0) protectendall = 0
				break

			protect_time--
			sleep(1)
		protected--
		if(protected < 0) protected = 0

	End_Protect()
		if(protected > 0)
			protectendall = protected
			protected = 0

	IsProtected() //Proc to consolidate some protect stuff so that the code doesn't need to be littered with similar vars. (Mainly for puppet shield though)
		if(protected/* || mole*/)
			return 1
		for(var/obj/Shield/s in oview(1,src))
			if(istype(src, /mob/human/Puppet))
				if(src == s.owner)
					return 1
			if(istype(src, /mob/human/player))
				if(Puppet1)
					if(Puppet1 == s.owner)
						return 1
				else if(Puppet2)
					if(Puppet2 == s.owner)
						return 1
		return 0

mob/var/movin=0
mob/var/afteryou_cool=0

mob
	proc/move_delay_me()
		// Used for sandmonsters and npcs.
		set waitfor = 0
		canmove = 0
		sleep(1)
		canmove = 1

mob/human
	Move(turf/loc,dirr)
		if(!src.loc)
			for(var/obj/Respawn_Pt/R in world)
				if((!faction || (faction.village=="Missing"&&R.ind==0))||(faction.village=="Konoha"&&R.ind==1)||(faction.village=="Suna"&&R.ind==2)||(faction.village=="Kiri"&&R.ind==3))
					loc = R.loc
					break
		if(!loc)
			return
		if(!src.canwalk)
			return
		if(src.justwalk)
			..()
			return
		if(istype(src,/mob/human/clay))
			. = ..()
			for(var/area/XE in oview(src,0))
				if(istype(XE,/area/nopkzone))
					var/mob/human/clay/spider/S = src
					if(istype(src,/mob/human/clay/spider) && S.owner && istype(S.owner,/mob/human/player))
						for(var/obj/trigger/exploding_spider/T in S.owner.triggers)
							if(T.spider == src) S.owner.RemoveTrigger(T)
					del src
			return
		if(istype(src,/mob/human/Puppet))
			for(var/area/nopkzone/S in oview(src,0))
				src.curwound=900
				src.curstamina=0
				src.Hostile()
		if(istype(src,/mob/human/sandmonster)||istype(src,/mob/human/player/npc))
			if(src.icon_state!="D-funeral" && !src.stunned)
				goto fin
			else
				return 0
		if(!density||canmove==0||stunned||kstun||asleep||mane||ko||src.icon_state=="ko"||!src.initialized||handseal_stun)
			return
		if(src.client && src.client.inputting)
			return 0
		if(src.incombo)
			return 0
		if(src.frozen)
			return 0

		if(istype(src,/mob/spectator))
			src.density=0
			src.icon=null
			goto fin

		/*var/i=0
		i=Iswater(loc.x,loc.y,loc.z)
		if(i)
			var/obj/haku_ice/ice = locate(/obj/haku_ice) in loc
			if(!ice)
				if(clan == "Haku")
					new /obj/haku_ice(loc)
				else
					if(curchakra>5)
						curchakra-=5
						waterlogged=1
						watercount++
					else if(curstamina>25)
						curstamina-=25
						waterlogged=1
						watercount++
					else
						return 0*/

		if(src.Tank)
			for(var/mob/human/Xe in get_step(src,src.dir))
				if(Xe!=src && !Xe.ko && !Xe.IsProtected()/*||istype(Xe,/mob/human/player/npc/kage_bunshin)*/)
					var/obj/t = new/obj(Xe.loc)
					t.icon='icons/gatesmack.dmi'
					flick("smack",t)
					del(t)
					Xe.Dec_Stam((src.str+src.strbuff-strneg)*pick(1,3)+400,1,src)
					Xe.Hostile(src)
					if(!Xe.Tank)
						Xe.loc=locate(src.x,src.y,src.z)
						Xe.icon_state="Hurt"

						Xe.Knockback(5,turn(src.dir, 180))
					else
						Xe.Knockback(5,src.dir)
					Xe.icon_state=""
				else
					src.loc=locate(Xe.x,Xe.y,Xe.z)


			if(movin)
				return ..()
			if(dirr==src.dir)
				src.movin=1
				walk(src,src.dir,1)
				sleep(3)
				walk(src,0)
				src.movin=0
				return 1
			else
				return ..()
		//if(!EN[14])
		//	return ..()
		if(src.zetsu)
			return ..()
		if(!src.movedrecently)
			src.movedrecently++
			if(src.movedrecently>10)
				src.movedrecently=10

		if(src.isguard)
			src.icon_state=""
			src.isguard=0

		for(var/turf/P in get_step(src,src.dir))
			if(!P.icon || P.type==/turf)
				return 0
		if(src.sleeping)
			src.sleeping=0
			src.icon_state=""
		if(length(carrying))
			for(var/mob/X in carrying)
				X.loc=src.loc
		fin

		var/mob/human/player/npc/escort
		for(var/mob/human/player/npc/Q in oview(5))
			if(Q.following == src)
				Q.nextstep = dirr
				escort = Q
				//call(escort, "escort_step")()
				break

		. = ..()

		// TODO, move this to effect/crossed()
		if(clan == "Jashin" && src.HasSkill(BLOOD_BIND))
			for(var/effect/B in src.loc)
				if(B.icon == 'icons/blood.dmi' && B.owner)src.Blood_Add(B.owner)

		src.Get_Global_Coords()

		//Levelwarp
		var/wa=0
		if(src.x==100 && (src.dir==EAST||src.dir==NORTHEAST||src.dir==SOUTHEAST))

			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/y=src.y
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/obj/mapinfo/NM
				for(var/obj/mapinfo/OP in world)
					if(OP.oX==eX+1 && OP.oY==eY)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(1,y,NM.z)
					//if(leading) leading.loc = loc
					wa=1
					src.Get_Global_Coords()


		if(src.x==1 && (src.dir==WEST||src.dir==NORTHWEST||src.dir==SOUTHWEST))
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/y=src.y
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/obj/mapinfo/NM
				for(var/obj/mapinfo/OP in world)
					if(OP.oX==eX-1 && OP.oY==eY)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(100,y,NM.z)
					//if(leading) leading.loc = loc
					wa=1
					src.Get_Global_Coords()

		if(src.y==100 && (src.dir==NORTH||src.dir==NORTHEAST||src.dir==NORTHWEST))
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/x=src.x
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/obj/mapinfo/NM
				for(var/obj/mapinfo/OP in world)
					if(OP.oX==eX && OP.oY==eY-1)
						NM=OP
						break
 			if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(x,1,NM.z)
					//if(leading) leading.loc = loc
					wa=1
					src.Get_Global_Coords()

		if(src.y==1 && (src.dir==SOUTH||src.dir==SOUTHWEST||src.dir==SOUTHEAST))
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/x=src.x
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/obj/mapinfo/NM
				for(var/obj/mapinfo/OP in world)
					if(OP.oX==eX && OP.oY==eY+1)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(x,100,NM.z)
					//if(leading) leading.loc = loc
					wa=1
					src.Get_Global_Coords()
		//~~~~

		if(wa && !combat_protection && afteryou_cool < world.time && rockshinobis < 50)
			if(pick(0, 1))
				new/Event(50, "rock_shinobi_ambush", list(src))

		if(escort && wa)
			//escort.loc = loc
			call(escort, "escort_teleport")()
			/*step(escort, escort.nextstep)
			if(wa)
				step(escort, escort.nextstep)*/

		//else if(wa)
		//		new/Event(600, "reset_ambush_time", list(src))

		//if(wa && leading && leading:z != z)
		//	leading:loc = loc

			// F: Not sure what this is for.
			//for(var/area/XE in oview(src,0))
			//	if(istype(XE,/area/nopkzone))
			//		src.Hostile()
		if(istype(src,/mob/human/sandmonster)||istype(src,/mob/human/player/npc))
			//new/Event(1, "move_delay", list(src))
			call(src, "move_delay_me")()
			return
		for(var/obj/x in oview(0))
			if(istype(x,/obj/caltrops))
				x:E(src)
		for(var/obj/x in oview(1))
			if(istype(x,/obj/trip))
				x:E(src)
		src.runlevel++
		if(src.runlevel>8)
			src.runlevel=8
		//decrease_running_speed()

		//(10)
		//new/Event(10, "decrease_running_speed", list(src))
		spawn(10)
			src.runlevel--
			if(src.icon_state=="Run" &&src.runlevel<3)
				src.icon_state=""
		if(src.runlevel>4 &&!src.Size)
			if(!src.icon_state &&!src.rasengan &&!src.larch)
				src.icon_state="Run"
		else
			if(src.icon_state=="Run")
				src.icon_state=""

		canmove=0
		if(!dancing_shadow)
			sleep(1)
		if(usr.Size==1)
			src.movepenalty=25
		if(usr.Size==2)
			src.movepenalty=35
		if(src.movepenalty>50)
			src.movepenalty=50
		/*if(get_move_stun())
			if(!movepenalty)
				movepenalty = 10
			sleep(round(movepenalty/5))
		else
			sleep(round(movepenalty/10))*/
		var/slowstun = Get_Move_Stun()
		if(slowstun || movepenalty) sleep(round(movepenalty / 10) + slowstun)
		if(src.leading)
			sleep(1)
		canmove=1


mob/Bump(obstacle)
	//bumped(obstacle)
	if(hascall(obstacle, "on_bump"))
		call(obstacle, "on_bump")(src)
	else
		..()

atom
	proc/bumped(atom/movable/am)


obj/Bonespire
	proc/on_bump(mob/crossing)
		set waitfor = 0
		if(!istype(crossing))
			return ..()
		if(causer == crossing)
			density = 0
			sleep(2)
			density = 1
			return 1
		return 0

mob/var/movement_map
client
	West()
		if(src.mob.controlmob)
			step(mob.controlmob,WEST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,WEST) in oview(20,src.mob))
				step(src.mob.Primary,WEST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x>0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[WEST]"]
			step(mob, dir)
			return
		..()

	East()
		if(src.mob.controlmob)
			step(mob.controlmob,EAST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,EAST) in oview(20,src.mob))
				step(src.mob.Primary,EAST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_x<0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))
		if(user &&user.pixel_y)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))

		if(mob.movement_map)
			var/dir = mob.movement_map["[EAST]"]
			step(mob, dir)
			return
		..()

	North()
		if(src.mob.controlmob)
			step(mob.controlmob,NORTH)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,NORTH) in oview(20,src.mob))
				step(src.mob.Primary,NORTH)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y<0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[NORTH]"]
			step(mob, dir)
			return
		..()

	South()
		if(src.mob.controlmob)
			step(mob.controlmob,SOUTH)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,SOUTH) in oview(20,src.mob))
				step(src.mob.Primary,SOUTH)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y>0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[SOUTH]"]
			step(mob, dir)
			return
		..()

	Southeast()
		if(src.mob.controlmob)
			step(mob.controlmob,SOUTHEAST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,SOUTHEAST) in oview(20,src.mob))
				step(src.mob.Primary,SOUTHEAST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y>0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x<0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[SOUTHEAST]"]
			step(mob, dir)
			return
		..()

	Northeast()
		if(src.mob.controlmob)
			step(mob.controlmob,NORTHEAST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,NORTHEAST) in oview(20,src.mob))
				step(src.mob.Primary,NORTHEAST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y<0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x<0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[NORTHEAST]"]
			step(mob, dir)
			return
		..()

	Southwest()
		if(src.mob.controlmob)
			step(mob.controlmob,SOUTHWEST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,SOUTHWEST) in oview(20,src.mob))
				step(src.mob.Primary,SOUTHWEST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y>0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x>0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[SOUTHWEST]"]
			step(mob, dir)
			return
		..()

	Northwest()
		if(src.mob.controlmob)
			step(mob.controlmob,NORTHWEST)
			return
		if(src.mob.Primary)
			if(get_step(src.mob.Primary,NORTHWEST) in oview(20,src.mob))
				step(src.mob.Primary,NORTHWEST)
				return

		var/mob/user=src.mob
		if(user &&user.pixel_y<0)
			user.pixel_y-=user.pixel_y/abs(user.pixel_y) *min(8,abs(user.pixel_y))
		if(user &&user.pixel_x>0)
			user.pixel_x-=user.pixel_x/abs(user.pixel_x) *min(8,abs(user.pixel_x))

		if(mob.movement_map)
			var/dir = mob.movement_map["[NORTHWEST]"]
			step(mob, dir)
			return
		..()
mob
	verb
		interactv()
			set name="Interact"
			set hidden = 1
			if(usr.camo)
				usr.Affirm_Icon()
				usr.Load_Overlays()
				usr.camo=0
			if(usr.lastwitnessing && usr.lastwitnessing_time >= world.time && usr.sharingan && usr:HasSkill(SHARINGAN_COPY))
				var/skill/uchiha/sharingan_copy/copy = usr:GetSkill(SHARINGAN_COPY)
				var/skill/copied = copy.CopySkill(usr.lastwitnessing)
				usr.combat("<b><font color=#faa21b>Copied [copied]!</b></font>")
				usr.lastwitnessing=0
				return
			if(usr.incombo)
				return

			//if(((usr.usedelay>0&&usr.pk)||usr.stunned||handseal_stun||usr.paralysed)&&!usr.ko)
			//	return
			//usr.usedelay++

			var/o=0
			var/inttype=0
			if(usr.leading)
				//usr.leading=0
				call(usr.leading, "stop_following")()
				return
			if(usr.spectate && usr.client)
				usr.spectate=0
				usr.client.eye=usr.client.mob
				src.hidestat=0
				return
			if(usr.controlmob || usr.tajuu)
				for(var/mob/human/player/npc/kage_bunshin/X in world)
					if(X.ownerkey==usr.key || X.owner==usr)
						var/dx=X.x
						var/dy=X.y
						var/dz=X.z
						if(dx&&dy&&dz)
							if(!X:exploading)
								Poof(X.loc)//(dx,dy,dz)
							else
								X:exploading=0
								explosion(rand(1000,2500),dx,dy,dz,usr)
								X.icon=0
								X.targetable=0
								X.invisibility=100
								X.density=0
								sleep(5)
						if(usr.client.eye!=usr.client.mob&&usr.client)
							usr.client.eye = usr.client.mob
							usr.controlmob = 0
						if(X)
							//if(locate(X) in usr.pet)
							//	usr.pet-=X
							X.dispose()
							//X.loc=null
							//X.owner = null
				usr.tajuu=0
				//usr.RecalculateStats()
				usr.controlmob=0
				if(usr.client && usr.client.mob)
					usr.client.eye=usr.client.mob
					src.hidestat=0

			if(usr.curwound >= usr.maxwound && usr.ko)
				usr.Respawn()
				return

			for(var/obj/interactable/oxe in oview(1))
				oxe:Interact()
				return

			for(var/mob/human/Puppet/p in ohearers(1))
				if(Puppet1 && !Primary)
					Primary = Puppet1
					walk(Primary, 0)
					client.eye = Puppet1
					return
				else if(Puppet2 && Puppet2 != Primary)
					if(!Puppet1 || Puppet1 == Primary)
						Primary = Puppet2
						walk(Primary, 0)
						client.eye = Puppet2
						return
			if(Primary && (Puppet1 || Puppet2))
				Primary = 0
				client.eye =  client.mob
				return

			for(var/mob/human/npc/x in oview(1))
				if(x == usr.MainTarget())
					o=1
					inttype=x.interact
				if(o)
					if(inttype=="Talk")
						x:Talk()
					if(inttype=="Shop")
						x:Shop()

			for(var/mob/human/player/npc/x in oview(1))
				if(x == usr.MainTarget())
					o=1
					inttype=x.interact
					if(x.MainTarget() && !usr.Missionstatus)
						o=0
				if(o)
					if(inttype=="Talk")
						x:Talk()
					if(inttype=="Shop")
						x:Shop()

			if(!usr.MainTarget())
				for(var/obj/explosive_tag/U in oview(0,usr))
					usr.Tag_Interact(U)
					return
				var/new_target
				for(var/mob/human/M in oview(4, usr))
					if(!new_target)
						new_target = M
					if(get_dist(M, usr) < get_dist(usr, new_target))
						new_target = M
				if(new_target) usr.AddTarget(new_target, active=1)

			if(usr.henged)
				usr.name=usr.realname
				usr.henged=0
				usr.mouse_over_pointer=faction_mouse[usr.faction.mouse_icon]
				Poof(usr.loc)//(usr.x,usr.y,usr.z)
				usr:CreateName(255, 255, 255)
				usr.Affirm_Icon()
				usr.Load_Overlays()

mob/proc/Blood_Add(mob/V)
	set waitfor = 0
	if(V)
		if(!bloodrem.Find(V))
			bloodrem+=V
		sleep(600)
		bloodrem-=V

mob/var/pill=0
mob/var/combo=0
mob
	proc
		Dec_Stam(x,xpierce,mob/attacker, hurtall,taijutsu, internal)
			if(combat_protection && !dojo && attacker && attacker != src && attacker.client && attacker.blevel >= 20)
				attacker << "A force stops you from harming [realname]!"
				return
			if(attacker && attacker.combat_protection && src && !combat_protection)
				attacker.combat_protection = 0
				attacker << "Combat protection flag toggled off."

			if(istype(attacker, /mob/human/player/npc/kage_bunshin))
				x /= 4

			if(leading)
				call(leading, "stop_following")()

			if(skillspassive[KEEN_EYE] && HasSkill(lastskill) || (clan == "Uchiha" && HasSkill(SHARINGAN_COPY)))
				if(clan == "Uchiha")
					var/skill/uchiha/sharingan_copy/s = GetSkill(SHARINGAN_COPY)
					if(s && s.copied_skill && s.copied_skill.id == lastskill)
						x *= 1 - 0.02 * skillspassive[KEEN_EYE]
				else if(HasSkill(lastskill))
					x *= 1 - 0.02 * skillspassive[KEEN_EYE]

			if(!internal && attacker && attacker.skillspassive[BLINDSIDE] && attacker != src && !byakugan)
				FilterTargets()
				if(!(attacker in active_targets))
					if(attacker in targets)
						x*= (1 + 0.005*attacker.skillspassive[BLINDSIDE])
					else
						x*= (1 + 0.05*attacker.skillspassive[BLINDSIDE])
			if(taijutsu && attacker && !internal && attacker.skillspassive[PIERCING_STRIKE])
				var/pr=attacker.skillspassive[PIERCING_STRIKE] *6
				var/y=x*pr/100
				x-=y
				src.combat("<font color=#eca940>You took [y] Piercing Stamina damage from [attacker]!")
				src.curstamina-=y
			if(!xpierce && !internal && length(src.pet))
				for(var/mob/human/sandmonster/S in src.pet)
					if(S.loc==src.loc)
						flick("hurt",S)
						S.hp--
						if(S.hp<=0)
							del(S)
						return

			if(src.AIKawa && !internal)
				Poof(loc)//(src.x,src.y,src.z)
				new/obj/log(locate(src.x,src.y,src.z))
				var/turf/T=locate(src.AIKawa)
				if(T)
					src.loc=locate(src.AIKawa)
				src.AIKawa=null
				return

			//if((src.pill==2 || src.Size) && !internal)
			//	if(x>2)
			//		x=round(x*0.70)
			var/fu=0
			for(var/area/nopkzone/oox in oview(0,src))
				fu=1
			if(fu)
				return
			if((locate(/obj/Shield) in oview(1,src)) && !internal)
				return
			if(src.ko)
				return
			if(src.isguard && !internal)
				var/y=x/2
				x=y
			if(clan == "Battle Conditioned" && !internal)
				var/y=round(x*0.8)
				x=y
			if(src.protected && !internal)
				return
			if(attacker&&attacker!=src && !ko)
				if(!client)
					if(attacker.client)
						lasthostile = attacker.key
				else
					lasthostile = attacker.key
			if(sandarmor && !xpierce && !internal)
				sandarmor = max(0, sandarmor - x)
				if(sandarmor)
					combat("<font color=#eca940>Your sand armor absorbed [x] from [attacker]!")
				else
					combat("<font color=#eca940>Your sand armor absorbed [x] from [attacker] and broke!")
				return
			if(boneharden && !internal)
				while(curchakra > 0 && x > 0)
					--curchakra
					x -= 3
				x = max(0, x)

			if(src.kaiten && !internal)
				return

			x=round(x)
			if(x<=0)
				return
			if(client && x >= 2500 && attacker && attacker != src)
				ez_count = max(0, ez_count - 3)

			if(src.ironskin==1&&!xpierce && !internal)
				src.curstamina-=round(x/2)
				return
			src.combat("<font color=#eca940>You took [x] Stamina damage from [attacker]!")
			if(!client && attacker && x && attacker.client && istype(src, /mob/human/player/npc))
				var/mob/human/player/npc/C=src
				C.lasthurtme=attacker
			src.curstamina-=x

			if(((!client &&  istype(src, /mob/human/player/npc) && src:nisguard) || client) &&attacker&&attacker.clan == "Ruthless")
				attacker.adren+=round(x/150)

			if(src.asleep)
				src.asleep=0
				//src.stunned=0
				src.End_Stun()

		Wound(x,xpierce, mob/attacker, reflected)
			//set waitfor = 0
			if(combat_protection && !dojo && attacker && attacker != src && attacker.client && attacker.blevel >= 20)
				attacker << "A force stops you from harming [realname]!"
				return
			if(attacker && attacker.combat_protection && src && !combat_protection)
				attacker.combat_protection = 0
				attacker << "Combat protection flag toggled off."

			if(istype(attacker, /mob/human/player/npc/kage_bunshin))
				x /= 4

			if(reflected && !src.ko)
				src.curwound+=x
				src.combat("<font color=#eca940>You took [x] Wound damage from [attacker]!")
				return

			if(attacker && attacker.skillspassive[BLINDSIDE] && attacker != src && !byakugan)
				FilterTargets()
				if(!(attacker in active_targets))
					if(attacker in targets)
						x*= (1 + 0.005*attacker.skillspassive[BLINDSIDE])
					else
						x*= (1 + 0.05*attacker.skillspassive[BLINDSIDE])

			if(src.Tank && x>10 && xpierce < 3)
				x=10

			if(pill == 2 && xpierce < 3)
				x = round(x*0.70)

			if(Size && xpierce < 3)
				if(x>2)
					x=round(x*0.70)
				if(x>20)
					x=20
			if(clan == "Jashin" && xpierce < 3)
				if(x>100)
					x=100
			if(clan == "Battle Conditioned" && !xpierce)
				x *= 0.7
			if(src.skillspassive[BUILT_SOLID] && xpierce < 3)
				var/y=0
				var/stamhurt=0
				while(y<x && (stamhurt+120) < curstamina)
					y++
					if(prob(4*src.skillspassive[BUILT_SOLID]))
						x--
						stamhurt+=120
				if(stamhurt > 0 && src.clan == "Battle Conditioned")
					stamhurt *= 0.8
				src.Dec_Stam(stamhurt,attacker=attacker,internal=1)

			if(attacker!=src)
				var/fu=0
				for(var/area/nopkzone/oox in oview(0,src))
					fu=1
				if(fu)
					return
			//	if(!xpierce)
			//		if(clan == "Battle Conditioned")
			//			var/y=round(x*0.85)
			//			x=y
				if((locate(/obj/Shield) in oview(1,src)) && xpierce < 3)
					return
				if(src.ko)
					return
				if(src.protected && xpierce < 3)
					return
			if(attacker&&attacker!=src && !ko)
				if(!client)
					if(attacker.client)
						lasthostile = attacker.key
				else
					lasthostile = attacker.key
				//if(istype(src,/mob/human/player/npc))
				//	if(!src:aggro)
				//		return
				if(src.sandarmor && !xpierce)
					src.sandarmor = max(0, sandarmor - x * 20)
					if(sandarmor)
						combat("<font color=#eca940>Your sand armor absorbed [x] from [attacker]!")
					else
						combat("<font color=#eca940>Your sand armor absorbed [x] from [attacker] and broke!")
					return
				if(boneharden && xpierce < 2)
					while(curchakra >= 20 && x>=1)
						curchakra -= 20
						--x
			//	if(src.dojo)
				//	return


				if(src.kaiten && xpierce < 3)
					return
				if(istype(src,/mob/human/npc))
					return
				if(src.ironskin==1&&!xpierce)
					src.Dec_Stam(x*100,1,attacker)
					return
			var/Ax=src.AC
			if(src.isguard)
				Ax=100
			if(Ax>100)
				Ax=100

			x *= 1 - round((((Ax) / (Ax * 1.2 + 180))))

			usr=src
			if(clan == "Jashin")//if(istype(src, /mob/human) && src:HasSkill(MASOCHISM))
				jashin_boost()

			//if(xpierce<2)
			//	x=round(p1 + p2, 1)
			x = round(x)
			if(x<=0)
				return
			src.curwound+=x
			src.combat("<font color=#eca940>You took [x] Wound damage from [attacker]!")

			if(clan == "Will of Fire" && !wof_adren_loop)
				wof_adrenaline()

			if(usr.Contract &&!reflected)
				var/obj/C = usr.Contract
				if(usr.loc==C.loc)
					if(usr.Contract2)
						var/mob/F=usr.Contract2
						F.Wound(x,3,usr,1)
						if(F)
							F.Hostile(usr)
						if(F)	// Runtime error here: bunshins? getting deleted by hostile. Added a couple checks to prevent it.
							F.combat("You've taken Wound damage from the Blood Contract with [usr]!!")
							combat("Your blood contract with [F] has given them [x] wound damage!!")
			if(((!client && istype(src, /mob/human/player/npc) && src:nisguard) || client) &&attacker&&attacker.clan == "Ruthless")
				attacker.adren+=x

			if(src.asleep)
				src.asleep=0
				//src.stunned=0
				src.End_Stun()

mob
	proc/jashin_boost()
		set waitfor = 0
		var/Rlim=round(src.rfx/2.5)-src.rfxbuff
		var/Slim=round(src.str/2.5)-src.strbuff
		if(Rlim<0)
			Rlim=0
		if(Slim<0)
			Slim=0
		var/R=round(src.rfx/10)
		var/S=round(src.str/10)
		if(R>Rlim)
			R=Rlim
		if(S>Slim)
			S=Slim
		src.rfxbuff+=R
		src.strbuff+=S
		sleep(200)
		src.rfxbuff-=R
		src.strbuff-=S
		if(src.rfxbuff<=0)
			src.rfxbuff=0
		if(src.strbuff<=0)
			src.strbuff=0

mob
	proc
		Hostile(mob/human/player/attacker)
			set waitfor = 0
			if(attacker && src.faction && attacker.faction && (src.faction.village!=attacker.faction.village ||src.faction.village=="Missing"))
				src.register_opponent(attacker)
				attacker.register_opponent(src)
			if(istype(src,/mob/human/clay))
				src:Explode()
				return

			if(phenged)
				if(faction)mouse_over_pointer=faction_mouse[faction.mouse_icon]
				src.name=src.realname
				src.phenged=0
				Poof(loc)//(src.x,src.y,src.z)
				src.overlays=0
				src:CreateName(255, 255, 255)
				var/mob/example=new src.type()
				src.icon=example.icon
				del(example)

			if(src.medicing)
				src.medicing=0
			if(src.qued)
				src.Deque(0)
			if(src.qued2)
				src.Deque2(0)
			src.mane = 0
			src.usemove = 0
			src.combo = 0

			if(src && attacker && attacker != src)
				combat_flag(DEFENSE_FLAG, 90)
				attacker.combat_flag(OFFENSE_FLAG, 120)

			if(src.leading)
				//src.leading=0
				call(leading, "stop_following")()

			if(istype(src,/mob/human/player/npc))
				if(attacker && attacker!=src && attacker.faction && src.faction && attacker.faction.village != src.faction.village && !(attacker.MissionTarget==src && (attacker.MissionType=="Escort"||attacker.MissionType=="Escort PvP")))
					if(!istype(attacker,/mob/human/player/npc/creep) && !(istype(attacker, /mob/human/player/npc) && src:nisguard))
						src:AI_Target(attacker)
			if(src.henged)
				src.henged=0
				src.mouse_over_pointer=faction_mouse[faction.mouse_icon]
				src.name=src.realname
				Poof(loc)//(src.x,src.y,src.z)
				src:CreateName(255, 255, 255)
				src.Affirm_Icon()
				src.Load_Overlays()


			if(src.sleeping)
				combat("You were startled awake!")
			src.sleeping=0
			src.combo=0
			if(attacker)
				if(attacker!=src && !ko)
					if(!client)
						if(attacker.client)
							lasthostile = attacker.key
					else
						lasthostile = attacker.key
			if(istype(src,/mob/human/npc))
				return
			if(istype(src,/mob/human/sandmonster))
				var/mob/human/sandmonster/xi =src
				xi.hp--
				if(xi.hp<=0)
					del(xi)
				return
			if(src.rasengan==1)
				src.Rasengan_Fail()
			if(src.rasengan==2)
				src.ORasengan_Fail()
			if(istype(src,/mob/human/player/npc/bunshin))
				if(hascall(src, "destroy"))
					call(src, "destroy")()
				/*if(src:bunshintype==0)
					Poof(loc)//(src.x,src.y,src.z)
					src.invisibility=100
					src.target=-15
					src.loc=locate(0,0,0)
					src.targetable=0
					src.density=0
					src.targetable=0
					src.loc=locate(0,0,0)
					loc = null*/
			if(istype(src,/mob/human/player/npc/kage_bunshin))
				var/mob/human/player/npc/kage_bunshin/k = src
				k.destroyed()

			if(attacker && attacker != src && !ko && curstamina > 0)
				if(istype(attacker, /mob/human/player/npc/kage_bunshin))
					var/mob/human/player/npc/kage_bunshin/a = attacker
					src.lasthostile = a.ownerkey
				else
					src.lasthostile = attacker.key

			if(src.asleep)
				src.asleep=0
				//src.stunned=0
				src.End_Stun()
				src.icon_state=""

			if(attacker&&attacker.client&&src.faction&&attacker.faction&&src.faction.village!=attacker.faction.village && !src.alertcool)
				src.alertcool=180
				for(var/mob/human/player/npc/OMG in ohearers(src))
					if(OMG.nisguard && OMG.faction.village == faction.village && !OMG.doesnotattack && !OMG.targets.len && !OMG.ko)
						OMG.AI_Target(attacker)


obj
	skilltree
		Passive_C
			Click()
				usr.client.eye=locate_tag("maptag_skilltree_passive")
				usr.spectate=1
				usr.hidestat=1
				for(var/obj/gui/passives/gauge/Q in world)
					if(Q.pindex==25||Q.pindex==26||Q.pindex==27||Q.pindex==28)
						var/client/C=usr.client
						if(C)C.Passive_Refresh(Q)
		Nonclan_C
			Click()
				usr.client.eye=locate_tag("maptag_skilltree_nonclan")
				usr.spectate=1
				usr.hidestat=1
				usr:refreshskills()
		Clan_C
			Click()
				usr.client.eye=locate_tag("maptag_skilltree_clan")
				usr.spectate=1
				usr.hidestat=1
				usr:refreshskills()

mob/human/player
	verb
		check_skill_tree()
			if(!usr.controlmob)
				if(!EN[9])
					return
				client.eye=locate_tag("maptag_skilltree_select")
				usr.spectate=1
				usr.hidestat=1
				usr:Refresh_Stat_Screen()
var
	fourpointo=1
mob
	var
		c=0
		cc=0
		isguard=0
		dzed=0
		criticaltime=0
		brutalitytime=0

mob
	proc/Graphiked2()
		set waitfor = 0
		var/image/O = image('icons/critical.dmi',src,icon_state="1",pixel_x=-6)
		var/image/O2 = image('icons/critical.dmi',src,icon_state="2",pixel_x=26)
		world<<O
		world<<O2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		O2.pixel_y+=2
		sleep(1)
		del(O)
		del(O2)

	proc/Graphiked(icon/I)
		set waitfor = 0
		var/image/O = image(I,src)
		world<<O
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		O.pixel_y+=2
		sleep(1)
		del(O)

	proc/increase_combo()
		set waitfor = 0
		combo++
		var/recorded_combo = combo
		sleep(50)
		if(combo == recorded_combo)
			combo = 0

	proc/timed_reaction_stun(time)
		set waitfor = 0
		cantreact++
		sleep(time)
		cantreact--

	proc/Combo(mob/M,r)
		if(src.skillspassive[FLURRY]&& src.combo<(1+src.skillspassive[FLURRY]))
			increase_combo()
		if(M && src)
			var/boom=0
			if(src.sakpunch2||usr.Size)
				src.sakpunch2=0
				boom=1
			var/blk=0

			if(M) M.Hostile(src)

			if(src.scalpol)
				//src.scalpoltime
				if(!M.icon_state)
					flick("hurt",M)


				//var/critchan2=//src.scalpoltime/10 * rand(2,5)
				//critchan2 = min(critchan2, 33)
				//src.scalpoltime=0
				if(prob((scalpoltime*2) + usr.skillspassive[MEDICAL_TRAINING]) && M.criticaltime < world.time)
					M.criticaltime = world.time + 100
				//Critical..
					var/critdamx=round((usr.con-usr.conneg)*rand(20,40)/10)
					var/wounddam=round(((rand(1,4)/2)*(usr.con-usr.conneg))/150)
					if(lastdash)
						lastdash = 0
						critdamx *= 0.6
					M.Dec_Stam(critdamx, 0, usr)
					M.movepenalty += round(10 * 1 + 0.05 * usr.skillspassive[MEDICAL_TRAINING])
					src.combat("Critical hit [M] for [critdamx] Stamina damage and [wounddam] Wounds!")
					if(M) M.Graphiked2()
					M.Wound(wounddam, 0, usr)
				else
					var/critdamx=(usr.con + usr.conbuff - usr.conneg) * pick(0.6, 0.7, 0.8, 0.9, 1)//round((usr.con+usr.conbuff)*rand(50,100)/100)
					if(usr.skillspassive[MEDICAL_TRAINING])
						critdamx *= 1 + 0.04 * usr.skillspassive[MEDICAL_TRAINING]
					if(lastdash)
						lastdash = 0
						critdamx *= 0.6
					var/wounddam=pick(0,1)
					M.Dec_Stam(critdamx, 0, usr)
					//M.movepenalty+=10
					//M.movepenalty += 0 + 0.5 * usr.skillspassive[MEDICAL_TRAINING]
					//M.movepenalty = min(30, M.movepenalty)
					src.combat("Hit [M] for [critdamx] Stamina damage and [wounddam] Wounds!")

					M.Wound(wounddam, 0, usr)

				if(src.skillspassive[OPEN_WOUNDS] && prob(usr.skillspassive[OPEN_WOUNDS] * 3))
					M.combat("[src]'s Scalpel blade has caused internal bleeding!")
					var/bleed = pick(2, 4, 6)
					M.bleed(bleed, src)

				src.scalpoltime=0
				return

			if(!M)
				return

			for(var/mob/human/P in get_step(M,M.dir))
				if(P==src)
					blk=1

			if(M.isguard && src && blk && !boom)
				src.combat("[M] Blocked!")
				M.c--
				src.attackbreak+=10
				flick("hurt",src)

				M.icon_state=""
				M.isguard=0
				M.timed_reaction_stun(5 - round(((rfx - 50) / 100)))//(10)
				return

			if(M.skillspassive[BRUTALITY] && M.weapon_ref && istype(M.weapon_ref, /obj/items/weapons/melee) && !M.handseal_stun && !M.kstun)
				if(M.brutalitytime < world.time && prob(5 * M.skillspassive[BRUTALITY]))
					M.brutalitytime = world.time + 100
					flick("w-attack", M)
					M.FaceTowards(src)
					M.Timed_Stun(3)
					M.combat("You counter attack [src] with your [M.weapon_ref.name]!")
					combat("[M] countered your attack!")
					var/stamina_dmg = M.weapon_ref.get_stamina_damage(M) * 0.2
					Dec_Stam(stamina_dmg, 0, M)
					set_icon_state("hurt", 30)
					Knockback(2, M.dir)
					if(istype(src, /mob/human/player/npc/kage_bunshin))
						call(src, "destroyed")()
						return
					Timed_Move_Stun(30, 2)
					timed_reaction_stun(10)
					return

			usr=src

			if(!M.icon_state)
				flick("hurt",M)

			var/xp=0
			var/yp=0
			if(M.x>src.x)
				xp=1
			if(M.x<src.x)
				xp=-1
			if(M.y>src.y)
				yp=1
			if(M.y<src.y)
				yp=-1
			src.pixel_x=4*xp
			src.pixel_y=4*yp


			if(src.gentlefist)
				if(M) M.Chakrahit3()
				gentle_fist_hit(M)

			else
				smack(M,rand(-10,10),rand(-5,15))
			var/critdam=0
			var/critchan=5

			if(boom)
				M.Earthquake(5)
				critdam = round((((usr.con - usr.conneg) * 2) + (usr.str - usr.strneg)) * 0.5)
				if(skillspassive[MEDICAL_TRAINING])
					critdam *= min(3, 1 + 0.2 * skillspassive[MEDICAL_TRAINING])
				if(usr.Size==1)
					critdam=round((usr.str+usr.strbuff)*rand(2,4)) +800
				if(usr.Size==2)
					critdam=round((usr.str+usr.strbuff)*rand(3,5.5)) +800
				M.Dec_Stam(critdam,0,usr)
				if(!usr.Size)
					M.movepenalty+=usr.skillspassive[MEDICAL_TRAINING] +rand(0,5)
				else
					M.movepenalty+=20
				if(!usr.Size)
					src.combat("Hit [M] for [critdam] damage with a chakra infused critical hit!!")
				else
					src.combat("Hit [M] for [critdam] with your massive fist!!")
				if(M) M.Graphiked2()

				if(!usr.Size)explosion(50,M.x,M.y,M.z,usr,1)
				if(src)
					src.pixel_x=0
					src.pixel_y=0
				if(M)
					M.pixel_y=0
					M.pixel_x=0
				M.Knockback(rand(5,10),src.dir)
				return
			if(prob(critchan) && !prob(M.skillspassive[EVASIVENESS] * 3) && M.criticaltime < world.time)
				M.criticaltime = world.time + 100
				//Critical..

				if(!usr.gentlefist)
					critdam=round((usr.str+usr.strbuff)*rand(15,20)/10) *(1+0.10*src.skillspassive[FORCE])
				else
					critdam=round((usr.con+usr.conbuff)*rand(15,20)/10)*(1+0.10*src.skillspassive[FORCE])
				M.movepenalty+=10
				src.combat("Critical hit!")
				if(M) M.Graphiked2()



			var/damage_stat=0
			if(!usr.gentlefist)
				damage_stat = (usr.str + usr.strbuff - usr.strneg) * pick(0.4, 0.5, 0.6)//usr.str+usr.strbuff-usr.strneg
			else
				damage_stat = (usr.con + usr.conbuff - usr.conneg) * pick(0.4, 0.5, 0.6)//usr.con+usr.conbuff-usr.conneg

			//var/m=damage_stat/150

			//if(src.gate>=5)
			//	m*=1.5

			var/outcome = Roll_Against(usr.rfx+usr.rfxbuff-usr.rfxneg, M.rfx+M.rfxbuff-M.rfxneg, rand(80,120))
			var/dam = damage_stat
			var/deltamove = 0

			switch(outcome)
				if(6)
					deltamove += 8
					M.increase_comboed(4.5)
					//M.c+=4
					//dam=round(150*m)
				if(5)
					deltamove += 6
					M.increase_comboed(3.5)
					//M.c+=3.5
					//dam=round(115*m)
				if(4)
					deltamove += 6
					M.increase_comboed(3)
					//M.c+=3
					//dam=round(100*m)
				if(3)
					deltamove += 5
					M.increase_comboed(2.5)
					//M.c+=2.5
					//dam=round(70*m)
				else
					M.increase_comboed(1)

			var/wound_damage = 0
			if(usr.stance == STRONG_FIST && prob(20))
				wound_damage = rand(0, 1)//rand(0, round(outcome / 3))

			//M.c += 4
			//M.increase_comboed(4)
			if(M.c>13)
				if(prob(40))
					combo_advance(M)

			if(combo)
				dam += dam * (0.2 * combo)
				//dam*=1+0.20*combo
			var/DD=dam+critdam

			M.Dec_Stam(DD, 0, usr,0,1)
			if(wound_damage)
				M.Wound(wound_damage, 0, usr)

			for(var/mob/human/v in view(1))
				if(v.client)
					v.combat("[M] was hit for [DD] damage by [src]!")

			//M.movepenalty += deltamove
			M.movepenalty = min(30, M.movepenalty + deltamove)
			var/dazeresist=4*M.skillspassive[BUILT_SOLID]
			var/evaderesist=3*M.skillspassive[EVASIVENESS]

			if(M.c > 20 && !M.cc &&!prob(dazeresist) && !prob(evaderesist))//combo pwned!!
				combo_daze(M)

			sleep(3)
			if(src)
				src.pixel_x=0
				src.pixel_y=0
			if(M)
				M.pixel_y=0
				M.pixel_x=0

mob
	proc/increase_comboed(amount)
		set waitfor = 0
		if(!src)
			return
		c += amount
		var/old_c = c
		sleep(30)
		if(c == old_c)
			c = 0

	proc/combo_advance(mob/comboed)
		set waitfor = 0
		if(!comboed)
			return
		comboed.Knockback(1, dir)
		sleep(1)
		step(src, get_dir(src, comboed))

	proc/combo_daze(mob/comboed)
		set waitfor = 0
		if(!comboed)
			return
		comboed.dzed=1
		comboed.cc=150
		comboed.icon_state="hurt"
		var/dazed=10
		dazed*= 1 + 0.1*src.skillspassive[FLURRY]
		//M.move_stun=round(dazed,0.1)
		comboed.Timed_Stun(dazed)

		comboed.Graphiked('icons/dazed.dmi')
		smack(comboed,0,0)
		src.combat("[comboed] is dazed!")
		while(comboed&&comboed.stunned)
			sleep(1)
		if(comboed)
			comboed.icon_state=""
			comboed.dzed=0
			comboed.c=0
			comboed.cc=0

mob/var/camo=0


mob

	proc
		attackv(mob/M)
			set name = "Attack"
			set hidden = 1
			var/weirdflick=0
			//if(!EN[16])
			//	return
			if(src.Tank)
				return

			if(src.controlmob)
				usr=controlmob
				src=controlmob
				weirdflick=1

			if(src.camo)
				src.Affirm_Icon()
				src.Load_Overlays()
				src.camo=0

			if(usr.sakpunch)
				usr.sakpunch=0
				usr.sakpunch2=1
			else if(usr.sakpunch2)
				usr.sakpunch2 = 0


			if(usr.leading)
				usr.leading=0
				return

			if(usr.cantreact)
				return

			if(puppetsout == 2 && !Primary)
				if(Puppet2 in ohearers())
					var/mob/human/ptarget = usr.MainTarget()
					if(ptarget && !ptarget.ko) Puppet2.pwalk_towards(Puppet2,ptarget,2,20)
					Puppet2.Melee(usr)
					return

			var/r=0
			if(!M)
				if(usr.zetsu)
					usr.invisibility=0
					usr.density=1
					usr.targetable=1
					usr.protected=0
					usr.zetsu=0

				if(usr.incombo || usr.frozen || usr.ko)
					return

				if(usr.isguard)
					usr.icon_state=""
					usr.isguard=0

				Pk_Check()

				if(istype(usr,/mob/human/player/npc))
					var/ans=pick(1,2,3,4)
					if(usr.Size)ans=5
					r=ans
					if(ans==1)
						flick("PunchA-1",usr)

					if(ans==2)
						flick("PunchA-2",usr)
					if(ans==3)
						flick("KickA-1",usr)
					if(ans==4)
						flick("KickA-2",usr)
					if(ans==5)
						usr.set_icon_state("PunchA-1", 6)

				if(usr.sleeping || usr.mane || usr.canattack>world.time)
					return

				if(usr.NearestTarget()) usr.FaceTowards(usr.NearestTarget())

				if(!usr.pk)
					if(usr.nudge <= world.time)
						usr.combat("Nudge")
						usr.nudge=world.time+10
						for(var/mob/human/player/o in get_step(usr,usr.dir))
							if(o.density==1 && !o.sleeping)
								o.Knockback(1,usr.dir)

						for(var/mob/human/clay/o in get_step(usr,usr.dir))
							o.Explode()
					return

			if(rasengan)
				// And a bit more specific to the rasengans: They all do the exact same thing except with different overlays and proc calls.
				var/mob/Targ = NearestTarget()

				if(!M && Targ)
					FaceTowards(Targ)
					/*var/dist = get_dist(Targ,src)
					if(dist <= 2)
						step_towards(src,Targ)*/

				if(rasengan == 1)
					overlays -= /obj/rasengan
					overlays += /obj/rasengan2
					//sleep(1)
					flick("PunchA-1", src)

					var/i = 0
					for(var/mob/human/o in get_step(src, dir))
						if(!o.ko && !o.IsProtected())
							i = 1
							if(rasengan == 1)
								Rasengan_Hit(o, src, dir)
					if(!i)
						Rasengan_Fail()
					return

				if(rasengan == 2)
					overlays -= /obj/oodamarasengan
					overlays += /obj/oodamarasengan2
					//sleep(1)
					flick("PunchA-1", src)
					var/i = 0
					for(var/mob/human/o in get_step(src, dir))
						if(!o.ko && !o.IsProtected())
							i = 1
							if(rasengan == 2)
								ORasengan_Hit(o, src, dir)
					if(!i)
						ORasengan_Fail()
					return

				if(rasengan == 3)
					sleep(1)
					flick("PunchA-1", src)
					var/i = 0
					for(var/mob/human/o in get_step(src, dir))
						if(!o.ko && !o.IsProtected())
							i = 1
							if(rasengan == 3)
								Rasenshuriken_Hit(o, src, dir)
					if(!i)
						Rasenshuriken_Fail()
					return

			if(usr.Aki)
				weirdflick=1

			if(usr.stunned||usr.kstun||usr.handseal_stun)
				return

			if(usr.client && usr.attackbreak)
				return

			var/trfx=usr.rfx+usr.rfxbuff-usr.rfxneg
			if(trfx<75)
				usr.attackbreak=10
			else if(trfx<100)
				usr.attackbreak=8
			else if(trfx<125)
				usr.attackbreak=6
			else if(trfx<150)
				usr.attackbreak=5
			else if(trfx<175)
				usr.attackbreak=4
			else if(trfx<200)
				usr.attackbreak=3
			else if(trfx<250)
				usr.attackbreak=2

			var/rx=rand(1,8)

			if(usr.gentlefist)
				rx=rand(1,6)
			if(usr.scalpol)
				flick("w-attack",usr)
			else
				if(usr.larch)
					rx = 1
				if(!istype(usr,/mob/human/player/npc))
					if(usr.Size)
						usr.set_icon_state("PunchA-1", 6)

					else if(!weirdflick)
						if(rx>=1 && rx<=3)
							flick("PunchA-1",usr)
							r=1

						if(rx>=4 && rx<=6)
							flick("PunchA-2",usr)
							r=2
						if(rx==7)
							flick("KickA-1",usr)
							r=3
						if(rx==8)
							flick("KickA-2",usr)
							r=4

					else
						if(rx>=1 && rx<=3)
							r=1
							usr.set_icon_state("PunchA-1", 5)

						if(rx>=4 && rx<=6)
							r=2
							usr.set_icon_state("PunchA-2", 5)

						if(rx==7)
							r=3
							usr.set_icon_state("KickA-1", 5)
						if(rx==8)
							r=4
							usr.set_icon_state("KickA-2", 5)


			var/deg=0
			var/hassword=usr.hassword
			var/attack_range = 1
			if(hassword)deg+=2
			if(usr.Size==1)
				deg=15
				attack_range = 2
			if(usr.Size==2)
				deg=25
				attack_range = 2

			if(usr.move_stun)
				deg = (deg * 1.5) + 5

			usr.canattack = world.time+(4+deg)

			var/mob/target
			if(M)
				target = M
			else
				target = usr.NearestTarget()

			var/mob/T

			if(target)
				/*if(usr.gate >= 4 && !usr.gatepwn)
					if(get_dist(target, usr) <= gate + 1)
						//usr:AppearBefore(target)
						//usr.dir = get_dir(src, target)
						var/turf/appear
						var/direction = get_dir(usr, target)
						if(direction)
							appear = get_step(target, turn(target.dir,180))//opposite_dir(direction))
							if(appear)
								usr.loc = appear
								usr.FaceTowards(target)
								sleep(1)
				else*/
				if(target in oview(attack_range))
					T = target

				if(M)
					T = M

				var/mob/nearesttarget = usr.NearestTarget()
				//world.log << "DEBUG: 1"
				if(usr.client && (dashtime < world.time || (gate && gate < 4)) && nearesttarget)
					var/distance = get_dist(usr, nearesttarget)
					//world.log << "DEBUG: 2"
					if(!rasengan && (lastskill != SHUNSHIN || lastskilltime + 20 < world.time))
						if(gate)
							if(gate && distance <= min(3, gate))
								dash(nearesttarget, gate + 1)
								FaceTowards(nearesttarget)
						else
							//world.log << "DEBUG: 3"
							if(get_dist(nearesttarget, usr) <= 2) // If the user did use shunshin, check that they only used it over a second ago.
								dash(nearesttarget, 1)
								FaceTowards(nearesttarget)

				if(T && !T.ko && !T.paralysed)
					if(usr.gate >= 5)
						gate_smack_effect(T.loc,4)

					usr.Combo(T,r)

					usr.Taijutsu(T)
					return

			var/last_turf = usr.loc
			var/iterations = 0

			do
				last_turf = get_step(last_turf,usr.dir)
				T=locate() in last_turf
			while(++iterations < attack_range && (!T || T.ko || T.paralysed))

			if(T&&T.ko==0&&T.paralysed==0)
				if(usr.gate >= 5)
					gate_smack_effect(T.loc, 4)

				usr.Combo(T,r)

				usr.Taijutsu(T)

		defendv()
			set name= "Defend"
			set hidden=1

			if(usr.Puppet1)
				var/mob/human/Puppet/P =usr.Puppet1
				if(P) P.Def(usr)
			if(usr.Puppet2)
				var/mob/human/Puppet/P =usr.Puppet2
				if(P) P.Def(usr)
			usr.Primary = 0
			if(usr.client)
				usr.client.eye = usr.client.mob

			for(var/mob/human/sandmonster/M in usr.pet)
				if(M) M.Return_Sand_Pet(usr)

			if(usr.Size||usr.Tank)
				return

		//	if(!EN[16])
		//		return

			//usr.usedelay++

			if(usr.leading)
				usr.leading=0
				return

			if(usr.cantreact || usr.asleep||usr.spectate || usr.larch || usr.sleeping || usr.mane || usr.ko || !usr.canattack)
				return

			if(!usr.gen_cancel_cooldown && usr.genjutsu && usr.genjutsu["effectiveness"])
				usr.break_genjutsu()

			if(usr.MainTarget()) usr.FaceTowards(usr.MainTarget())

			if(usr.rasengan==1)
				usr.Rasengan_Fail()
			if(usr.rasengan==2)
				usr.ORasengan_Fail()

			if(usr.controlmob)
				usr=usr.controlmob

			if(usr.stunned||usr.kstun||usr.handseal_stun)
				return

			if(usr.isguard==0)
				usr.icon_state="Seal"
				usr.isguard=1
/*
// genjutsu.dm
#define DARKNESS_GENJUTSU "darkness genjutsu"
#define FEAR_GENJUTSU "fear genjutsu"
#define SLEEP_GENJUTSU "sleep genjutsu"

genjutsu
	darkness
		id = DARKNESS_GENJUTSU

		activate(mob/user)

		cancel(mob/user)
			sight = 0

	fear
		id = FEAR_GENJUTSU

		activate(mob/user)

	nirvana
		id = SLEEP_GENJUTSU

		activate(mob/user)

genjutsu
	var/id

	proc/activate(mob/user)
	proc/cancel(mob/user)

var/global/genjutsu[] = list(
	DARKNESS_GENJUTSU = new/genjutsu/darkness,
	FEAR_GENJUTSU = new/genjutsu/fear,
	SLEEP_GENJUTSU = new/genjutsu/nirvana,
	)
*/
mob
	proc/break_genjutsu()
		set waitfor = 0
		var/cancel_roll = Roll_Against(usr.genjutsu["effectiveness"],(usr.con+usr.conbuff-usr.conneg),100)
		if(cancel_roll < 3)
			if(genjutsu)
				switch(genjutsu["name"])
					if("darkness")
						src.sight = 0
						if(client)
							client.images -= genjutsu["image"]
							if(genjutsu["user"])
								var/mob/user = genjutsu["user"]
								if(user.client) user.client.images -= genjutsu["image"]
					if("fear")
						Reset_Stun()
						Reset_Move_Stun()
						if(client) client.images -= genjutsu["image"]
						if(genjutsu["user"])
							var/mob/user = genjutsu["user"]
							if(user.client) user.client.images -= genjutsu["image"]
				var/image/g = genjutsu["image"]
				g.loc = null
				genjutsu = null

		src.gen_cancel_cooldown = 1
		sleep(100)
		src.gen_cancel_cooldown = 0

mob/proc/Get_Hair_RGB()
	src.hair_color=input(usr, "What color would you like your hair to be?") as color

obj
	skilltree
		Back
			Click()
				usr.client.eye=usr.client.mob
				usr.hidestat=0
				usr.spectate=0
mob/human/npc/dojoowner
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1
			alert(usr,"Welcome to the Dojo, this place isnt quite a pk zone and its not quite a no-pk zone. In the dojo, you can fight but youll never be wounded, its a safe place to spar and train.")
mob/human/npc/barber
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1
			switch(input2(usr,"Would you like to get your hair cut?", "Barber",list ("Yes","No")))
				if("Yes")
					usr.hidestat=1
					usr.GoCust()

mob/human/npc/headbandguy
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1
			if(usr.rank!="Academy Student")
				for(var/obj/items/equipable/Headband/x in usr.contents)
					del(x)
				switch(input2(usr,"What Type of Headband would you like?", "Headband",list ("Blue","Black","Red")))
					if("Red")
						new/obj/items/equipable/Headband/Red(usr)
					if("Blue")
						new/obj/items/equipable/Headband/Blue(usr)
					if("Black")
						new/obj/items/equipable/Headband/Black(usr)
			else
				usr<<"You get a Headband only when you graduate!"
mob/human/npc
	New()
		..()
		Load_Overlays()

mob/human/npc/teachernpc3
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1

mob/human/npc/teachernpc2
	interact="Talk"
	verb
		Talk()
			set src in oview(1)
			set hidden=1

proc
	smack(mob/M,dx,dy)
		set waitfor = 0
		punch_effect(M, dx, dy)
	/*	if(wregenlag>2)
			return
		var/Px=dx+M.pixel_x
		var/Py=dy+M.pixel_y
		var/obj/X=new/obj(M.loc)
		X.pixel_x=Px
		X.pixel_y=Py
		X.layer=M.layer
		X.layer++
		X.density=0
		X.icon='icons/twack.dmi'
		flick("fl",X)
		sleep(7)
		X.loc = null
		//del(X)
*/
//teacher!
mob/human/npc/teachernpc
	interact="Talk"
	verb
		Talk_r()
			set src in oview(1)
			alert(usr,"In Naruto GOA, you don't talk to npcs by right clicking on them, double click an npc first to target it (signified by a red arrow) then press Space or the button labeled 'Spc' on the screen.")
		Talk()
			set src in oview(1)
			set hidden=1

mob
	var/tmp/gentle_fist_timestamp = 0

	proc/gentle_fist_hit(mob/hit)
		set waitfor = 0
		if(prob(60))
			hit.Wound(1, 0, src)
		++hit.gentle_fist_block
		hit.gentle_fist_timestamp = world.time
		//sleep(600)
		//if(!hit)
		//	return
		//--hit.gentle_fist_block