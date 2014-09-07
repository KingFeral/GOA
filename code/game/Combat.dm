mob/var/afteryou=0

obj/interactable
	paper
		verb
			Interact()
				set hidden=1
				set src in oview(1)

mob/human/npc/shopnpc
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
			//spawn()
			flick("create", src)
			while(src)
				sleep(1)
				++dissipate_count
				for(var/mob/human/M in loc)
					if(M.clan == "Haku")
						dissipate_count = 0
						break
				if(dissipate_count > 50) del src

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
			//spawn()
			while(time)
				if(stunendall) break
				time = max(time - 1, 0)
				sleep(1)
			End_Stun()
		Begin_Stun()
			stunned++
		End_Stun()
			stunned--
			if(stunned < 0) stunned = 0
		Reset_Stun()
			set waitfor = 0
			//spawn()
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
			//spawn()
			while(time > 0)
				if(movestunendall) break
				--time
				sleep(1)
			if(move_stun > 0) move_stun--
			slows.Remove(severity)
			//End_Move_Stun()
		Get_Move_Stun()
			var/highestslow
			if(slows.len)
				for(var/i in slows)
					if(!highestslow)
						highestslow = i
					else if(i > highestslow)
						highestslow = i
				return highestslow
			else
				return 0
		Reset_Move_Stun()
			spawn()
				move_stun = 0
				movestunendall = 1
				sleep(1)
				movestunendall = 0

mob/var/tmp/protectendall = 0
mob/proc
	Protect(protect_time as num)
		protected++
		spawn()
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

		var/i=0
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
						return 0

		if(src.Tank)
			for(var/mob/human/Xe in get_step(src,src.dir))
				if(Xe!=src && !Xe.ko && !Xe.protected && (Xe.client/*||istype(Xe,/mob/human/player/npc/kage_bunshin)*/))
					var/obj/t = new/obj(Xe.loc)
					t.icon='icons/gatesmack.dmi'
					flick("smack",t)
					del(t)
					spawn()Xe.Dec_Stam((src.str+src.strbuff-strneg)*pick(1,3)+400,1,src)
					spawn()Xe.Hostile(src)
					if(!Xe.Tank)
						Xe.loc=locate(src.x,src.y,src.z)
						Xe.icon_state="Hurt"


					spawn()
						if(!Xe.Tank)
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
		if(!EN[14])
			return ..()
		if(src.zetsu)
			return ..()
		if(!src.movedrecently)
			src.movedrecently++
			if(src.movedrecently>10)
				src.movedrecently=10

		if(src.isguard)
			src.icon_state=""
			src.isguard=0
		for(var/obj/Bonespire/P in get_step(src,src.dir))
			if(P.causer==src)
				P.density=0
				spawn(2)
					if(P)
						P.density=1
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

		. = ..()
		if(body_replacement)
			body_replacement["steps"]--
			if(body_replacement["steps"] <= 0)
				var/mob/human/body_replacement/b = body_replacement["ref"]
				b.activate()

		if(src.HasSkill(BLOOD_BIND))
			for(var/obj/undereffect/B in src.loc)
				if(B.uowner)src.Blood_Add(B.uowner)

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
					wa=1
					src.Get_Global_Coords()
		//~~~~
		if(!afteryou_cool && wa && rockshinobis < 50)
			if(pick(0,1))
				var/squadsize=pick(1,2,3,4)
				squadsize=min(squadsize,afteryou)
				afteryou_cool=1
				rockshinobis += squadsize
				//afteryou-=squadsize
				spawn(30)
					var/lvl=1
					if(MissionClass=="D")
						lvl=limit(1,round(src.blevel * rand(0.4,1)),30)
					if(MissionClass=="C")
						lvl=limit(1,round(src.blevel * rand(0.7,1.1)),60)
					if(MissionClass=="B")
						lvl=limit(1,round(src.blevel * rand(0.8,1.2)),80)
					if(MissionClass=="A")
						lvl=limit(1,round(src.blevel * rand(0.9,1.3)),100)
					if(MissionClass=="S")
						lvl=limit(1,round(src.blevel * rand(1,1.3)),100)

					Ambush(src,lvl,squadsize)

		else
			if(wa)
				spawn(600)
					afteryou_cool=0
		if(wa && leading && leading:z != z)
			leading:loc = loc
		//for(var/mob/human/player/npc/Q in oview(5))
		//	if(Q.following==src)
		//		Q.nextstep=src.dir
			//for(var/area/XE in oview(src,0))
			//	if(istype(XE,/area/nopkzone))
			//		src.Hostile()
		if(istype(src,/mob/human/sandmonster)||istype(src,/mob/human/player/npc))
			canmove=0
			spawn(1)
				canmove=1
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
			if(usr.lastwitnessing && usr.sharingan && usr:HasSkill(SHARINGAN_COPY))
				var/skill/uchiha/sharingan_copy/copy = usr:GetSkill(SHARINGAN_COPY)
				var/skill/copied = copy.CopySkill(usr.lastwitnessing)
				usr.combat("<b><font color=#faa21b>Copied [copied]!</b></font>")
				usr.lastwitnessing=0
				return
			if(usr.incombo)
				return

			if(((usr.usedelay>0&&usr.pk)||usr.stunned||handseal_stun||usr.paralysed)&&!usr.ko)
				return
			usr.usedelay++

			var/o=0
			var/inttype=0
			if(usr.leading)usr.leading=0

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
								spawn()Poof(dx,dy,dz)
							else
								X:exploading=0
								spawn()explosion(rand(1000,2500),dx,dy,dz,usr)
								X.icon=0
								X.targetable=0
								X.invisibility=100
								X.density=0
								sleep(5)
						if(usr.client.eye!=usr.client.mob&&usr.client)
							usr.client.eye = usr.client.mob
							usr.controlmob = 0
						if(X)
							if(locate(X) in usr.pet)
								usr.pet-=X
							X.loc=null
				usr.tajuu=0
				//usr.RecalculateStats()
				usr.controlmob=0
				if(usr.client && usr.client.mob)
					usr.client.eye=usr.client.mob
					src.hidestat=0
			spawn(30)
				usr.Respawn()
			for(var/obj/interactable/oxe in oview(1))
				oxe:Interact()
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
				for(var/mob/human/M in oview(2, usr))
					if(!new_target)
						new_target = M
					if(get_dist(M, usr) < get_dist(usr, new_target))
						new_target = M
				if(new_target) usr.AddTarget(new_target, active=1)

			if(usr.henged)
				usr.name=usr.realname
				usr.henged=0
				usr.mouse_over_pointer=faction_mouse[usr.faction.mouse_icon]
				Poof(usr.x,usr.y,usr.z)
				usr:CreateName(255, 255, 255)
				usr.Affirm_Icon()
				usr.Load_Overlays()
mob/proc/Blood_Add(mob/V)
	if(V)
		if(!bloodrem.Find(V))
			bloodrem+=V

		spawn(600)
			bloodrem-=V

mob/var/pill=0
mob/var/combo=0
mob
	proc
		Dec_Stam(x,xpierce,mob/attacker, hurtall,taijutsu, internal)
			//set waitfor =0
			if(istype(attacker, /mob/human/player/npc/kage_bunshin))
				x /= 4

			if(skillspassive[KEEN_EYE] && HasSkill(lastskill) || (clan == "Uchiha" && HasSkill(SHARINGAN_COPY)))
				if(clan == "Uchiha")
					var/skill/uchiha/sharingan_copy/s = GetSkill(SHARINGAN_COPY)
					if(s && s.copied_skill && s.copied_skill.id == lastskill)
						x *= 1 - 0.01 * skillspassive[KEEN_EYE]
				else if(HasSkill(lastskill))
					x *= 1 - 0.01 * skillspassive[KEEN_EYE]

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
				Poof(src.x,src.y,src.z)
				new/obj/log(locate(src.x,src.y,src.z))
				var/turf/T=locate(src.AIKawa)
				if(T)
					src.loc=locate(src.AIKawa)
				src.AIKawa=null
				return

			if((src.pill==2 || src.Size) && !internal)
				if(x>2)
					x=round(x*0.70)
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

			if(x<=0)
				return

			if(src.ironskin==1&&!xpierce && !internal)
				src.curstamina-=round(x/2)
				return
			src.combat("<font color=#eca940>You took [x] Stamina damage from [attacker]!")
			if(attacker && x && attacker.client&&istype(src,/mob/human/player/npc/creep))
				var/mob/human/player/npc/creep/C=src
				C.lasthurtme=attacker
			src.curstamina-=x
			if(attacker&&attacker.clan == "Ruthless")
				attacker.adren+=round(x/200)
			if(src.asleep)
				src.asleep=0
				//src.stunned=0
				src.End_Stun()
		Wound(x,xpierce, mob/attacker, reflected)
			//set waitfor = 0
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
				x = round(x*0.80)
			if(Size && xpierce < 3)
				if(x>2)
					x=round(x*0.70)
				if(x>20)
					x=20
			if(clan == "Jashin" && xpierce < 3)
				if(x>100)
					x=100
			if(clan == "Battle Conditioned" && !xpierce)
				x *= 0.85
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
				spawn()src.Dec_Stam(stamhurt,attacker=attacker,internal=1)

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

	/*		var/p1= x* (100-Ax)/100
			var/p2= x* (Ax)/100 *(100/(src.str+src.strbuff-src.strneg))
			if(x>=1 && (p1+p2)<=1)
				if(Ax<100)
					p1=1
					p2=0*/

			usr=src
			if(istype(src, /mob/human) && src:HasSkill(MASOCHISM))
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
				spawn(200)
					src.rfxbuff-=R
					src.strbuff-=S
					if(src.rfxbuff<=0)
						src.rfxbuff=0
					if(src.strbuff<=0)
						src.strbuff=0

			//if(xpierce<2)
			//	x=round(p1 + p2, 1)
			if(x<=0)
				return
			src.curwound+=x
			src.combat("<font color=#eca940>You took [x] Wound damage from [attacker]!")
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
			if(client&&attacker&&attacker.clan == "Ruthless")
				attacker.adren+=x

			if(src.asleep)
				src.asleep=0
				//src.stunned=0
				src.End_Stun()



mob
	proc
		Hostile(mob/human/player/attacker)
			set waitfor = 0
			if(attacker && src.faction && attacker.faction && (src.faction.village!=attacker.faction.village ||src.faction.village=="Missing"))
				spawn() src.register_opponent(attacker)
				spawn() attacker.register_opponent(src)
			if(istype(src,/mob/human/clay))
				spawn() src:Explode()
				return

			if(phenged)
				if(faction)mouse_over_pointer=faction_mouse[faction.mouse_icon]
				src.name=src.realname
				src.phenged=0
				spawn() Poof(src.x,src.y,src.z)
				src.overlays=0
				src:CreateName(255, 255, 255)
				var/mob/example=new src.type()
				src.icon=example.icon
				del(example)

			if(src.medicing)
				src.medicing=0
			if(src.qued)
				spawn() src.Deque(0)
			if(src.qued2)
				spawn() src.Deque2(0)
			src.mane=0
			src.usemove=0
			src.combo=0
			if(src.leading)
				src.leading=0
			if(istype(src,/mob/human/player/npc))
				if(attacker && attacker!=src && attacker.faction && src.faction && attacker.faction.village != src.faction.village && !(attacker.MissionTarget==src && (attacker.MissionType=="Escort"||attacker.MissionType=="Escort PvP")))
					if(!istype(attacker,/mob/human/player/npc/creep) && !(istype(attacker, /mob/human/player/npc) && src:nisguard))
						spawn() src:AI_Target(attacker)
			if(src.henged)
				src.henged=0
				src.mouse_over_pointer=faction_mouse[faction.mouse_icon]
				src.name=src.realname
				spawn() Poof(src.x,src.y,src.z)
				src:CreateName(255, 255, 255)
				src.Affirm_Icon()
				src.Load_Overlays()


			if(src.sleeping)
				combat("You were startled awake!")
			src.sleeping=0
			src.combo=0
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
				if(src:bunshintype==0)
					spawn() Poof(src.x,src.y,src.z)
					src.invisibility=100
					src.target=-15
					src.loc=locate(0,0,0)
					src.targetable=0
					src.density=0
					src.targetable=0
					src.loc=locate(0,0,0)
					spawn(500)
						del(src)
			if(istype(src,/mob/human/player/npc/kage_bunshin))
				spawn()
					var/dx=src.x
					var/dy=src.y
					var/dz=src.z
					if(!src:exploading)
						spawn()Poof(dx,dy,dz)
					else
						src:exploading=0
						spawn()explosion(rand(1000,2500),dx,dy,dz,src)
						src.icon=0
						src.targetable=0
						src.invisibility=100
						src.density=0
						sleep(5)
					src:dead=1
					//src.stunned=100
					src.Begin_Stun()

					src.loc=locate(0,0,0)
					for(var/mob/human/player/p in world)
						if(p.key==src:ownerkey)
							p.controlmob=0
							p.client.eye=p.client.mob
					src.invisibility=100
					src.target=-15
					src.targetable=0
					src.density=0
					src.targetable=0
					spawn(100)
						del(src)

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
				var/onit=0
				var/list/options=new/list()
				for(var/turf/x in oview(8,src))
					if(!x.density)
						options+=x

				if(length(options))
					spawn() for(var/mob/human/player/npc/OMG in world)
						if(!OMG.client && OMG.z==z && onit < 2)
							// TODO: I think this sleep should be a spawn or something. This loop must be really slow otherwise.
							// ...In fact, that slowness is probably the cause a bunch of the guard issues.
							sleep(200)
							if(OMG && attacker && OMG.z == attacker.z)
								var/turf/nextt = pick(options)
								options -= nextt
								if(OMG.nisguard && OMG.faction.village == faction.village && attacker && !(istype(attacker, /mob/human/player/npc) && attacker:nisguard))
									onit++
									OMG.AppearAt(nextt.x, nextt.y, nextt.z)
									spawn() OMG.AI_Target(attacker)
									if(get_dist(attacker, OMG) > 10)
										walk_to(OMG, attacker, 4, 1)

									spawn()
										var/eie = 0
										while(attacker && OMG && get_dist(attacker, OMG) > 20 && eie < 10)
											eie++
											step_to(OMG, src, 4)
											sleep(5)
										if(OMG)
											walk(OMG, 0)
										spawn() if(OMG && attacker) OMG.AI_Target(attacker)
										if(OMG && attacker && get_dist(attacker, OMG) > 10)
											if(OMG.z == attacker.z)
												OMG.AppearAt(attacker.x, attacker.y, attacker.z)


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

mob
	proc/Graphiked2()
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

	proc/Combo(mob/M,r)
		if(src.skillspassive[FLURRY]&& src.combo<(1+src.skillspassive[FLURRY]))
			src.combo++
			var/C=src.combo
			spawn(50)
				if(src.combo==C)
					src.combo=0
		if(M && src)
			var/boom=0
			if(src.sakpunch2||usr.Size)
				src.sakpunch2=0
				boom=1
			var/blk=0

			spawn()if(M) M.Hostile(src)

			if(src.scalpol)
				//src.scalpoltime
				if(!M.icon_state)
					flick("hurt",M)


				//var/critchan2=//src.scalpoltime/10 * rand(2,5)
				//critchan2 = min(critchan2, 33)
				//src.scalpoltime=0
				if(prob((scalpoltime*2)))
				//Critical..
					var/critdamx=round((usr.con+usr.conbuff)*rand(20,40)/10)
					var/wounddam=round(((rand(1,4)/2)*(usr.con+usr.conbuff-usr.conneg))/150)
					M.Dec_Stam(critdamx, 0, usr)
					M.movepenalty += round(10 * 1 + 0.05 * usr.skillspassive[MEDICAL_TRAINING])
					src.combat("Critical hit [M] for [critdamx] Stamina damage and [wounddam] Wounds!")
					spawn() if(M) M.Graphiked2()
					M.Wound(wounddam, 0, usr)
				else
					var/critdamx=(usr.con + usr.conbuff - usr.conneg) * pick(0.6, 0.7, 0.8, 0.9, 1)//round((usr.con+usr.conbuff)*rand(50,100)/100)
					if(usr.skillspassive[MEDICAL_TRAINING])
						critdamx *= 1 + 0.04 * usr.skillspassive[MEDICAL_TRAINING]
					var/wounddam=pick(0,1)
					M.Dec_Stam(critdamx, 0, usr)
					//M.movepenalty+=10
					M.movepenalty += round(5 * 1 + 0.05 * usr.skillspassive[MEDICAL_TRAINING])
					src.combat("Hit [M] for [critdamx] Stamina damage and [wounddam] Wounds!")

					M.Wound(wounddam, 0, usr)

				if(src.skillspassive[OPEN_WOUNDS] && prob(usr.skillspassive[OPEN_WOUNDS] * 3))
					M.combat("[src]'s Scalpel blade has caused internal bleeding!")
					var/bleed = pick(2, 4, 6)
					M.bleed(bleed, src)

				src.scalpoltime=0
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
				M.cantreact = 1
				spawn(10)
					M.cantreact = 0
				return

			if(M.skillspassive[BRUTALITY] && M.weapon_ref && istype(M.weapon_ref, /obj/items/weapons/melee))
				if(prob(5 * M.skillspassive[BRUTALITY]))
					flick("w-attack", M)
					M.FaceTowards(src)
					M.Timed_Stun(5)
					M.combat("You counter attack [src] with your [M.weapon_ref.name]!")
					combat("[M] countered your attack!")
					var/stamina_dmg = M.weapon_ref.get_stamina_damage() * 0.2
					spawn Dec_Stam(stamina_dmg, 0, M)
					flick("hurt", src)
					spawn Knockback(2, M.dir)
					Timed_Move_Stun(30, 2)
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


		//	var/deltamove=0

			if(src.gentlefist)
				spawn() if(M) M.Chakrahit3()
				gentle_fist_hit(M)
				/*
				if(prob(60)) M.Wound(pick(1,2),0,src)
				++M.gentle_fist_block
				spawn(100)
					if(M) --M.gentle_fist_block*/
			else
				spawn()smack(M,rand(-10,10),rand(-5,15))
			var/critdam=0
			var/critchan=5

			if(boom)
				M.Earthquake(5)
				//critdam=round((usr.con+usr.conbuff+usr.str+usr.strbuff)*rand(1,2)) +800
				critdam = ((str + strbuff - strneg) * 2 + (con + conbuff - conneg)) / 2
				if(skillspassive[MEDICAL_TRAINING])
					critdam *= 1 + 0.2 * skillspassive[MEDICAL_TRAINING]
				if(usr.Size==1)
					critdam=round((usr.str+usr.strbuff)*rand(2,4)) +800
				if(usr.Size==2)
					critdam=round((usr.str+usr.strbuff)*rand(3,5.5)) +800
				M.Dec_Stam(critdam,0,usr)
				M.movepenalty+=usr.skillspassive[MEDICAL_TRAINING]//20
				if(!usr.Size)
					src.combat("Hit [M] for [critdam] damage with a chakra infused critical hit!!")
				else
					src.combat("Hit [M] for [critdam] with your massive fist!!")
				spawn() if(M) M.Graphiked2()

				if(!usr.Size)spawn()explosion(50,M.x,M.y,M.z,usr,1)
				if(src)
					src.pixel_x=0
					src.pixel_y=0
				if(M)
					M.pixel_y=0
					M.pixel_x=0
				M.Knockback(rand(5,10),src.dir)
				return
			if(prob(critchan) && !prob(M.skillspassive[EVASIVENESS] * 3))
				//Critical..

				if(!usr.gentlefist)
					critdam=round((usr.str+usr.strbuff)*rand(15,40)/10) *(1+0.10*src.skillspassive[FORCE])
				else
					critdam=round((usr.con+usr.conbuff)*rand(15,40)/10)*(1+0.10*src.skillspassive[FORCE])
				M.movepenalty+=10
				src.combat("Critical hit!")
				spawn()if(M) M.Graphiked2()



			var/damage_stat=0
			if(!usr.gentlefist)
				damage_stat = (usr.str + usr.strbuff - usr.strneg) * pick(0.6, 0.7, 0.8, 0.9, 1)//usr.str+usr.strbuff-usr.strneg
			else
				damage_stat = (usr.con + usr.conbuff - usr.conneg) * pick(0.6, 0.7, 0.8, 0.9, 1)//usr.con+usr.conbuff-usr.conneg

			//var/m=damage_stat/150

			//if(src.gate>=5)
			//	m*=1.5

			var/dam = damage_stat

			/*switch(outcome)
				if(6)
					deltamove+=3
					M.c+=4
					dam=round(150*m)
				if(5)
					deltamove+=2
					M.c+=3.5
					dam=round(115*m)
				if(4)
					deltamove+=1
					M.c+=3
					dam=round(100*m)
				if(3)
					deltamove+=1
					M.c+=2.5
					dam=round(70*m)
				if(2)
					//deltamove+=3
					M.c+=2
					dam=round(40*m)
				if(1)
					//deltamove+=3
					M.c+=2
					dam=round(30*m)
				if(0)
					//deltamove+=2
					M.c+=2
					dam=round(20*m)*/

			if(M.c>13)
				if(prob(60))
					spawn()if(M) M.Knockback(1,src.dir)
					spawn(1)
						step(src,src.dir)
			if(combo)
				dam*=1+0.10*combo
			var/DD=dam+critdam

			M.Dec_Stam(DD, 0, usr,0,1)

			for(var/mob/human/v in view(1))
				if(v.client)
					v.combat("[M] was hit for [DD] damage by [src]!")

			//M.movepenalty += deltamove
			M.movepenalty = min(15, M.movepenalty + 3)
			var/dazeresist=4*M.skillspassive[BUILT_SOLID]
			var/evaderesist=3*M.skillspassive[EVASIVENESS]

			if(M.c > 20 && !M.cc &&!prob(dazeresist) && !prob(evaderesist))//combo pwned!!
				M.dzed=1
				M.cc=150
				M.icon_state="hurt"
				var/dazed=30
				dazed*= 1 + 0.1*src.skillspassive[FLURRY]
				//M.move_stun=round(dazed,0.1)
				M.Timed_Stun(dazed)

				spawn() if(M) M.Graphiked('icons/dazed.dmi')
				spawn() if(M) smack(M,0,0)
				src.combat("[M] is dazed!")
				spawn()
					while(M&&M.stunned)
						sleep(1)
					if(M)
						M.icon_state=""
						M.dzed=0
						M.c=0

			sleep(3)
			if(src)
				src.pixel_x=0
				src.pixel_y=0
			if(M)
				M.pixel_y=0
				M.pixel_x=0


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

			spawn(10)
				usr.sakpunch2=0

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
						spawn()flick("PunchA-1",usr)

					if(ans==2)
						spawn()flick("PunchA-2",usr)
					if(ans==3)
						spawn()flick("KickA-1",usr)
					if(ans==4)
						spawn()flick("KickA-2",usr)
					if(ans==5)
						usr.icon_state="PunchA-1"
						spawn(6)
							usr.icon_state=""

				if(usr.sleeping || usr.mane || !usr.canattack)
					return

				if(usr.NearestTarget()) usr.FaceTowards(usr.NearestTarget())

				if(!usr.pk)
					if(!usr.nudge)
						usr.combat("Nudge")
						usr.nudge=1

						spawn(10)
							usr.nudge=0
						for(var/mob/human/player/o in get_step(usr,usr.dir))
							if(o.density==1 && !o.sleeping)
								o.Knockback(1,usr.dir)
								//o.move_stun=5
								//o.density=0
								//spawn(5)
								//	o.density=1

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

			if(usr.attackbreak)
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
				spawn() flick("w-attack",usr)
			else
				if(usr.larch)
					rx = 1
				if(!istype(usr,/mob/human/player/npc))
					if(usr.Size)
						usr.icon_state="PunchA-1"
						spawn(6)
							usr.icon_state=""

					else if(!weirdflick)
						if(rx>=1 && rx<=3)
							spawn()flick("PunchA-1",usr)
							r=1

						if(rx>=4 && rx<=6)
							spawn()flick("PunchA-2",usr)
							r=2
						if(rx==7)
							spawn()flick("KickA-1",usr)
							r=3
						if(rx==8)
							spawn()flick("KickA-2",usr)
							r=4

					else
						if(rx>=1 && rx<=3)
							spawn()
								r=1
								usr.icon_state="PunchA-1"
								sleep(5)
								usr.icon_state=""

						if(rx>=4 && rx<=6)
							spawn()
								r=2
								usr.icon_state="PunchA-2"
								sleep(5)
								usr.icon_state=""

						if(rx==7)
							spawn()
								r=3
								usr.icon_state="KickA-1"
								sleep(5)
								usr.icon_state=""
						if(rx==8)
							spawn()
								r=4
								usr.icon_state="KickA-2"
								sleep(5)
								usr.icon_state=""

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

			usr.canattack = 0
			spawn(4+deg)
				usr.canattack = 1

			var/mob/target
			if(M)
				target = M
			else
				target = usr.NearestTarget()

			var/mob/T

			if(target)
				if(usr.gate >= 4 && !usr.gatepwn)
					if(get_dist(target, usr) < 5)
						usr:AppearBefore(target)
						usr.dir = get_dir(src, target)
						sleep(1)
				else
					if(target in oview(attack_range))
						T = target

				if(M)
					T = M

				if(T && !T.ko && !T.paralysed)
					if(usr.gate >= 5)
						var/obj/smack=new/obj(locate(T.x,T.y,T.z))
						smack.icon='icons/gatesmack.dmi'
						smack.layer=MOB_LAYER+1
						flick("smack",smack)
						spawn(4)
							del(smack)

					usr.Combo(T,r)

					spawn()usr.Taijutsu(T)
					return

			var/last_turf = usr.loc
			var/iterations = 0

			do
				last_turf = get_step(last_turf,usr.dir)
				T=locate() in last_turf
			while(++iterations < attack_range && (!T || T.ko || T.paralysed))

			if(T&&T.ko==0&&T.paralysed==0)
				if(usr.gate >= 5)
					var/obj/smack=new/obj(locate(T.x,T.y,T.z))
					smack.icon='icons/gatesmack.dmi'
					smack.layer=MOB_LAYER+1
					flick("smack",smack)
					spawn(4)
						del(smack)

				usr.Combo(T,r)

				spawn()usr.Taijutsu(T)

		defendv()
			set name= "Defend"
			set hidden=1

			for(var/mob/human/sandmonster/M in usr.pet)
				spawn() if(M) M.Return_Sand_Pet(usr)

			if(usr.Size||usr.Tank)
				return

			if(!EN[16])
				return

			//usr.usedelay++

			if(usr.leading)
				usr.leading=0
				return

			if(usr.cantreact || usr.spectate || usr.larch || usr.sleeping || usr.mane || usr.ko || !usr.canattack)
				return

			if(usr.skillspassive[21] && usr.gen_effective_int && !usr.gen_cancel_cooldown)
				var/cancel_roll = Roll_Against(usr.gen_effective_int,(usr.con+usr.conbuff-usr.conneg)*(1 + 0.05*(usr.skillspassive[21]-1)),100)
				if(cancel_roll < 3)
					if(usr.sight == (BLIND|SEE_SELF|SEE_OBJS)) // darkness gen
						usr.sight = 0

				usr.gen_cancel_cooldown = 1
				spawn(100)
					usr.gen_cancel_cooldown = 0

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
		if(!M) return
		if(wregenlag>2)
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