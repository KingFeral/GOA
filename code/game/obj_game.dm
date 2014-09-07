obj
	caltrops
		icon='icons/caltrop.dmi'
		density=0
		layer=OBJ_LAYER
		var/uses=1
		proc/E(mob/human/o)
			src.uses--
			usr=o
			if(istype(usr,/mob/human/player))
				if(!usr.icon_state)
					flick("hurt",usr)
				usr.Dec_Stam(400 * 1 + 0.05 * owner.skillspassive[TRAP_MASTERY], 0, owner)
				usr.Wound(rand(1,3) * 1 + 0.05 * owner.skillspassive[TRAP_MASTERY])
				//usr.move_stun+=20
				usr.Timed_Move_Stun(20)
				if(owner && owner.skillspassive[TRAP_MASTERY])
					if(prob(owner.skillspassive[TRAP_MASTERY] * 2))
						usr.Timed_Stun(30)
			if(src.uses<=0 || !owner)
				//del(src)
				owner = null
				loc = null
			..()

	trip
		icon='icons/tripwire.dmi'
		density=0
		layer=OBJ_LAYER
		var/setoff=0
		proc/E(mob/human/o)
			usr=o
			//usr.move_stun=10
			usr.Timed_Move_Stun(10)
			if(istype(usr,/mob/human))
				src.Setoff(usr)
			..()
		proc
			Setoff(mob/human/o)
				if(o == owner) return
				src.setoff=1
				spawn()
					for(var/obj/explosive_tag/x in oview(1,src))
						spawn() if(x) x.Setoff(o)
					for(var/obj/trip/m in oview(1,src))
						if(m.setoff==0)
							spawn() if(m) m.Setoff(o)

				spawn(10)del(src)

	explosive_tag
		icon='icons/note.dmi'
		var/trapskill=0
		proc/Setoff(mob/human/o)
			var/xx=src.x
			var/xy=src.y
			var/xz=src.z
			usr=o
			src.icon=0
			var/r1=rand(0,10)
			var/r2=rand(0,10)
			var/r3=rand(0,10)
			var/r4=rand(0,10)
			if(r1>5)
				r1=1
			else
				r1=0
			if(r2>5)
				r2=1
			else
				r2=0
			if(r3>5)
				r3=1
			else
				r3=0
			if(r4>5)
				r4=1
			else
				r4=0
			if(r1)spawn()explosion(400*(1+0.3*trapskill),xx-1,xy-1,xz,usr,1)
			if(r2)spawn()explosion(400*(1+0.3*trapskill),xx+1,xy+1,xz,usr,1)
			if(r3)spawn()explosion(400*(1+0.3*trapskill),xx+1,xy-1,xz,usr,1)
			if(r4)spawn()explosion(400*(1+0.3*trapskill),xx-1,xy+1,xz,usr,1)
			explosion(600*(1+0.3*trapskill),xx,xy,xz,usr)
			del(src)

	interactable
		hospitalbed
			verb
				Interact(var/mob/q)
					set hidden=1
					set src in oview(1)
					if(q)
						usr=q
					if(!usr) return
					if(usr.MissionTime)
						if(usr.Missionstatus)
							usr.MissionFail()
					if(q)
						usr=q
					if(!usr) return
					for(var/mob/human/player/x in oview(0,usr))
						usr<<"That bed is taken!"
						return
					if(usr.sleeping)
						return
					usr<<"You lie down in the bed"
					usr.loc=locate(src.x,src.y,src.z)
					usr.dir=SOUTH
					usr.sleeping=1
					var/rest=0
					while(usr && usr.sleeping && usr.x==src.x && usr.y==src.y && usr.z==src.z)
						if(rest>100)
							usr.icon_state="hurt"
							if(usr.curstamina<usr.stamina)
								usr.curstamina+=usr.stamina/20
							if(usr.curstamina>usr.stamina)
								usr.curstamina=usr.stamina
							if(usr.curwound>0)
								usr.curwound-=rand(2,5)
							//usr.stunned=0
							usr.Reset_Stun()
						rest+=10

						sleep(10)
					if(usr)
						usr.icon_state=""
						usr.sleeping=0
		bed
			verb
				Interact()
					set hidden=1
					set src in oview(1)
					if(usr.MissionTime)
						if(usr.Missionstatus)
							usr.MissionFail()
					for(var/mob/human/player/x in oview(0,src))
						usr<<"That bed is taken!"
						return
					if(usr.sleeping)
						return
					usr<<"You lie down in the bed"
					usr.loc=locate(src.x,src.y,src.z)
					usr.dir=SOUTH
					usr.sleeping=1
					var/rest=0
					while(usr && usr.sleeping && usr.x==src.x && usr.y==src.y && usr.z==src.z)
						if(rest>100)
							usr.icon_state="hurt"
							if(usr.curstamina<usr.stamina)
								usr.curstamina+=usr.stamina/20
							if(usr.curstamina>usr.stamina)
								usr.curstamina=usr.stamina
							if(usr.curwound>0)
								usr.curwound-=rand(2,5)
							//usr.stunned=0
							usr.Reset_Stun()
						rest+=10

						sleep(10)
					if(usr)
						usr.icon_state=""
						usr.sleeping=0