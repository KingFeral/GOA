skill
	taijutsu
		face_nearest = 1
		leaf_great_whirlwind
			id = LEAF_GREAT_WHIRLWIND
			name = "Taijutsu: Leaf Great Whirlwind"
			icon_state = "leaf_great_whirlwind"
			default_stamina_cost = 100
			default_cooldown = 20



			Use(mob/human/user)
				viewers(user) << output("[user]: Leaf Great Whirlwind!", "combat_output")

				var/mob/human/etarget = user.NearestTarget()
				if(!etarget)
					for(var/mob/human/M in get_step(user,user.dir))
						etarget=M

				spawn()
					user.overlays+='icons/senpuu.dmi'
					spawn(8)
						user.overlays-='icons/senpuu.dmi'
					user.icon_state="KickA-1"
					spawn(8)
						user.icon_state=""
					sleep(4)
					user.dir=turn(user.dir,90)
					sleep(4)
					user.dir=turn(user.dir,90)

				if(etarget)
					user.AppearBefore(etarget)
					spawn()user.Taijutsu(etarget)
					if(!etarget.icon_state)
						flick("hurt",etarget)
					var/result=Roll_Against(user.str+user.strbuff-user.strneg,etarget.str+etarget.strbuff-etarget.strneg,60)
					if(result>=6)
						etarget.Dec_Stam(700,0,user)
						etarget.Knockback(6,user.dir)
					if(result==5)
						etarget.Dec_Stam(550,0,user)
						etarget.Knockback(5,user.dir)
					if(result==4)
						etarget.Dec_Stam(400,0,user)
						etarget.Knockback(4,user.dir)
					if(result==3)
						etarget.Dec_Stam(300,0,user)
						etarget.Knockback(3,user.dir)
					if(result==2)
						etarget.Dec_Stam(150,0,user)
						etarget.Knockback(2,user.dir)
					if(result==1)
						etarget.Dec_Stam(100,0,user)
						etarget.Knockback(1,user.dir)

					spawn()
						if(etarget)
							etarget.Hostile(user)

				//user.stunned += 0.2
				user.Timed_Stun(2)




		lion_combo
			id = LION_COMBO
			name = "Taijutsu: Lion Combo"
			icon_state = "lioncombo"
			default_stamina_cost = 600
			default_cooldown = 60



			IsUsable(mob/user)
				. = ..()
				if(.)
					var/target = user.NearestTarget()
					if(!target)
						Error(user, "No Target")
						return 0
					var/distance = get_dist(user, target)
					if(distance > 1)
						Error(user, "Target too far ([distance]/1 tiles)")
						return 0


			Use(mob/human/user)
				var/mob/human/etarget = user.NearestTarget()
				if(!etarget)
					return
				if(etarget.dzed)
					//etarget.stunned+=3
					etarget.Timed_Stun(30)
				var/vx=etarget.x
				var/vy=etarget.y
				var/vz=etarget.z
				user.overlays+='icons/senpuu.dmi'
				spawn(20)
					if(user) user.overlays-='icons/senpuu.dmi'
				sleep(15)
				if(etarget && etarget.ko) return
				if(user && get_dist(user, etarget) < 1)//if(user && etarget && etarget.x==vx && etarget.y==vy && etarget.z==vz)
					spawn() user.Taijutsu(etarget)

					user.AppearBefore(etarget)
					flick("KickA-1",user)
					if(etarget.larch)
						return
					if(!user)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						return
					if(!etarget)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						return
					var/LOx=user.x
					var/LOy=user.y
					var/LOz=user.z

					user.Begin_Stun()//user.stunned=15
					etarget.Begin_Stun()//etarget.stunned=15
					sleep(2)
					if(!user)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					etarget.loc=locate(vx,vy,vz)
					user.AppearBefore(etarget)
					sleep(3)
					if(!user)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					user.incombo=1
					etarget.incombo=1
					user.x=vx
					user.y=vy
					user.z=vz
					var/obj/S=new/obj(locate(vx,vy,vz))
					S.density=0
					S.icon='icons/shadow.dmi'

					etarget.dir=SOUTH
					user.protected=10
					etarget.protected=10
					user.dir=SOUTH
					var/obj/O = new/obj(locate(vx,vy,vz))
					O.density=0
					O.icon='icons/appeartai.dmi'
					spawn(5)
						del(O)

					etarget.icon_state="hurt"
					etarget.layer=MOB_LAYER+13
					user.layer=MOB_LAYER+12
					etarget.pixel_y=3
					user.pixel_y=etarget.pixel_y

					etarget.y=user.y
					var/E=50
					spawn()
						user.pixel_x = 8
						user.pixel_y += 5
					while(etarget&&user&&E>0)
						etarget.pixel_y += 4
						user.pixel_y += 4

						E-=2
						sleep(1)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return

					S.loc=locate(vx,vy,vz)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					user.dir=WEST
					user.icon_state="Throw1"
					user.pixel_y=etarget.pixel_y+3
					etarget.y=user.y

					user.pixel_x=8

					flick("PunchA-1",user)
					spawn()smack(etarget,5,8)
					etarget.pixel_y+=5
					sleep(1)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					etarget.pixel_y++
					sleep(1)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					etarget.pixel_y++
					sleep(1)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					etarget.pixel_y++
					sleep(1)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return

					user.pixel_y+=8
					user.icon_state=""
					user.pixel_y=etarget.pixel_y-3
					etarget.y=user.y
					user.pixel_x=8
					flick("KickA-1",user)
					spawn()smack(etarget,2,4)
					sleep(4)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					etarget.layer=MOB_LAYER+12
					user.layer=MOB_LAYER+13

					flick("KickA-2",user)
					spawn()smack(etarget,5,6)
					sleep(4)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					user.pixel_x=0
					user.dir=NORTH
					user.pixel_y=etarget.pixel_y+6
					etarget.y=user.y
					user.pixel_x=0
					flick("KickA-1",user)
					spawn() if(etarget) smack(etarget,0,8)
					sleep(2)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					etarget.pixel_y-=2
					sleep(2)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					etarget.pixel_y-=2
					etarget.layer=MOB_LAYER+13
					user.layer=MOB_LAYER+12

					user.dir=EAST
					user.pixel_y=etarget.pixel_y+3
					etarget.y=user.y
					user.pixel_x=-8
					flick("KickA-2",user)
					spawn()smack(etarget,-5,6)
					sleep(4)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					etarget.layer=MOB_LAYER+12
					user.layer=MOB_LAYER+13

					flick("KickA-1",user)
					spawn()smack(etarget,-2,4)
					sleep(2)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					spawn() if(etarget) etarget.Fallpwn()
					sleep(2)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						etarget.loc=locate(vx,vy,vz)
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						user.loc=locate(LOx,LOy,LOz)
						return
					user.overlays+='icons/appeartai.dmi'
					user.pixel_x=0
					user.pixel_y=0
					user.loc=locate(LOx,LOy,LOz)
					etarget.loc=locate(vx,vy,vz)
					etarget.dir=SOUTH
					user.AppearBefore(etarget)
					sleep(6)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						return
					user.overlays-='icons/appeartai.dmi'
					sleep(4)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						return
					user.protected=0
					etarget.protected=0
					sleep(2)
					if(!user)
						del(S)
						etarget.pixel_x=0
						etarget.pixel_y=0
						etarget.incombo=0
						etarget.protected=0
						etarget.icon_state=""
						etarget.End_Stun()
						return
					if(!etarget)
						del(S)
						user.pixel_x=0
						user.pixel_y=0
						user.incombo=0
						user.protected=0
						user.icon_state=""
						user.End_Stun()
						return
					user.incombo=0
					user.End_Stun()
					del(S)
					var/multiplier=(user.str+user.strbuff-user.strneg)/(etarget.str+etarget.strbuff-etarget.strneg)
					var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,100)
					etarget.Hostile(user)
					sleep(1)
					if(etarget && user)
						if(result>=5)
							etarget.Dec_Stam(2000*multiplier,0,user)
						if(result==4)
							etarget.Dec_Stam(1700*multiplier,0,user)
						if(result==3)
							etarget.Dec_Stam(1400*multiplier,0,user)
						if(result==2)
							etarget.Dec_Stam(1000*multiplier,0,user)
						if(result==1)
							etarget.Dec_Stam(700*multiplier,0,user)
						if(result<=0)
							user.combat("[etarget] managed to defend himself from all of your attacks!")
							etarget.combat("You managed to defend yourself from all of [user]'s attacks!")
							(oviewers(user)-etarget) << output("[etarget] managed to defend himself from all of [user]'s attacks!", "combat_output")
						etarget.Hostile(user)
					if(user)
						user.layer=MOB_LAYER




		nirvana_fist
			id = NIRVANA_FIST
			name = "Taijutsu: Achiever of Nirvana Fist"
			icon_state = "achiever_of_nirvana_fist"
			default_stamina_cost = 150
			default_cooldown = 40



			IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(. && target)
					var/distance = get_dist(user, target)
					if(distance > 1)
						Error(user, "Target too far ([distance]/1 tiles)")
						return 0


			Use(mob/human/user)
				flick("PunchA-1",user)
				viewers(user) << output("[user]: Achiever of Nirvana Fist!", "combat_output")

				var/mob/human/etarget = user.NearestTarget()
				if(etarget)
					spawn()smack(etarget,0,0)
					spawn()smack(etarget,-6,0)
					spawn()smack(etarget,6,0)
					var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,100)

					if(etarget)
						var/stamina_dmg = ((user.str + user.strbuff - user.strneg) * 0.6) + 300
						if(user.skillspassive[FLURRY])
							stamina_dmg *= 1 + 0.1 * user.skillspassive[FLURRY]
						if(result>=6)
							etarget.Dec_Stam(stamina_dmg,0,user)
							spawn()
								etarget.Knockback(3,user.dir)
								//etarget.move_stun+=2
								etarget.Timed_Move_Stun(60, 1)

						else if(result==5)
							etarget.Dec_Stam(stamina_dmg,0,user)
							spawn()
								etarget.Knockback(3,user.dir)
								//etarget.move_stun+=1.5
								etarget.Timed_Move_Stun(45, 1)
						else if(result==4)
							etarget.Dec_Stam(stamina_dmg,0,user)
							spawn()
								etarget.Knockback(2,user.dir)
								//etarget.move_stun+=1
								etarget.Timed_Move_Stun(30)
						else if(result==3)
							etarget.Dec_Stam(stamina_dmg ,0,user)
							spawn()
								etarget.Knockback(1,user.dir)
								etarget.Timed_Move_Stun(20)
						else
							user.combat("You missed!")
							etarget.combat("[user] missed!")

						if(result >= 3)
							if(!etarget.icon_state)
								etarget.icon_state = "hurt"
							if(etarget)
								spawn() etarget.Hostile(user)

						spawn()user.Taijutsu(etarget)


					spawn()
						while(etarget.move_stun>0)
							sleep(1)
							if(!etarget)
								break
						if(etarget)
							if(!etarget.ko)
								etarget.icon_state=""
					if(etarget)
						spawn()etarget.Hostile(user)




		gates
			default_chakra_cost = 300
			default_cooldown = 400
			copyable = 0



			var
				level
				time_multiplier
				icon_time = 50
				prev_gate
				overlay_icons[]
				underlay_icons[]



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.gate == level)
						return 1
					else if(level == 1)
						if(user.gate)
							Error(user, "You must not have a gate active.")
							return 0
						else
							return 1
					else if(user.gate != (level - 1))
						Error(user, "You must have the previous gate active.")
						return 0


			ChakraCost(mob/user)
				if(user.gate != level)
					return ..(user)
				else
					return 0


			Cooldown(mob/user)
				if(user.gate != level)
					return ..(user)
				else
					return 0


			Use(mob/human/user)
				if(user.gate == level)
					viewers(user) << output("[user] closes the gates.", "combat_output")
					user.CloseGates(cooldown=0)
					ChangeIconState("gate[level]")
				else
					viewers(user) << output("[user]: [src]!", "combat_output")
					if(!user.gate)
						user.overlays += 'icons/gatepower.dmi'
					if(level == 3)
						user.icon = 'icons/base_m_gates.dmi'
					if(level == 4)
						spawn(icon_time) user.curstamina = user.stamina
					user.gate=level
					if(overlay_icons)
						for(var/I in overlay_icons)
							user.overlays += I
							spawn(icon_time)
								user.overlays -= I
					if(underlay_icons)
						for(var/I in underlay_icons)
							user.underlays += I
							spawn(icon_time)
								user.underlays -= I
					if(user.clan == "Youth")
						user.curchakra=user.chakra
					if(prev_gate)
						var/skill/taijutsu/gates/s = user.GetSkill(prev_gate)
						s.ChangeIconState("gate[s.level]")
						spawn() s.DoCooldown(user)
					ChangeIconState("cancelgates")
					spawn((user.str+user.rfx)*time_multiplier)
						if(user && user.gate==level)
							viewers(user) << output("[user] exhausts gate [user.gate].", "combat_output")
							user.CloseGates()




			one
				id = GATE1
				name = "Opening Gate"
				icon_state = "gate1"
				level = 1
				time_multiplier = 4




			two
				id = GATE2
				prev_gate = GATE1
				name = "Energy Gate"
				icon_state = "gate2"
				level = 2
				time_multiplier = 3
				overlay_icons = list('icons/rockslifting.dmi')




			three
				id = GATE3
				prev_gate = GATE2
				name = "Life Gate"
				icon_state = "gate3"
				level = 3
				time_multiplier = 2.5
				overlay_icons = list('icons/gate3chakra.dmi')




			four
				id = GATE4
				prev_gate = GATE3
				name = "Pain Gate"
				icon_state = "gate4"
				level = 4
				time_multiplier = 2
				overlay_icons = list('icons/gate3chakra.dmi')
				underlay_icons = list(/obj/gatesaura/bl, /obj/gatesaura/br, /obj/gatesaura/tl, /obj/gatesaura/tr)
				icon_time = 30




			five
				id = GATE5
				prev_gate = GATE4
				name = "Limit Gate"
				icon_state = "gate5"
				level = 5
				time_multiplier = 1.5
				overlay_icons = list('icons/gate5.dmi')
				icon_time = 5




mob/proc
	CloseGates(cooldown=1)
		var/gate_lv = gate
		src.gate=0
		for(var/skill/taijutsu/gates/s in skills)
			if(s.level == gate_lv)
				s.ChangeIconState("gate[s.level]")
				if(cooldown) spawn() s.DoCooldown(src)
		src.Load_Overlays()
		spawn(10)
			if(src.curstamina>src.stamina)
				src.curstamina=src.stamina
			src.strbuff=0
			src.rfxbuff=0
			src.underlays=0
			src.Affirm_Icon()
			src.Hostile(src)


	Taijutsu(mob/M)
		if(M)
			if(M.larch)
				spawn()
					Blood2(src)
					src.Wound(rand(5,10))
					src.Dec_Stam(rand(100,500))
					src.Hostile(M)
					//src.move_stun+=3
					src.Timed_Move_Stun(3)


	Fallpwn()
		var/E=src.pixel_y
		while(E>10)
			E-=10
			src.pixel_y-=10
			sleep(1)
		sleep(1)
		src.pixel_y=0
		explosion(1,src.x,src.y,src.z,src,1)
		src.incombo=0
		src.pixel_x=0
		//src.stunned=2
		Timed_Stun(20)
		sleep(20)
		src.icon_state=""
		src.layer=MOB_LAYER
