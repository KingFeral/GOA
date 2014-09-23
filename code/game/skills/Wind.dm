skill
	wind
		pressure_damage
			id = FUUTON_PRESSURE_DAMAGE
			name = "Wind: Pressure Damage"
			icon_state = "futon_pressure_damage"
			base_charge = 300
			default_cooldown = 120



			Use(mob/human/user)
				//user.stunned=5
				user.Timed_Stun(20)
				var/obj/multipart/P
				var/dir = user.dir
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir
				switch(dir)
					if(NORTH)
						P=new/obj/multipart/Pressure/PNORTH(locate(user.x,user.y+1,user.z),1)
					if(SOUTH)
						P=new/obj/multipart/Pressure/PSOUTH(locate(user.x,user.y-1,user.z),1)
					if(EAST)
						P=new/obj/multipart/Pressure/PEAST(locate(user.x+1,user.y,user.z),1)
					if(WEST)
						P=new/obj/multipart/Pressure/PWEST(locate(user.x-1,user.y,user.z),1)
					else
						return
				P.dir=dir
				var/distance=10
				while(P && distance>0)
					for(var/obj/p in P.parts)
						for(var/mob/M in p.loc)
							if(!M.pressured && M!=user)
								M.pressured=1
								spawn(100)
									if(M&&M.pressured)
										M.pressured=0
								P.Pwned+=M
								//M.stunned+=90
								M.Begin_Stun()
								M.animate_movement=2

					step(P,P.dir)

					sleep(2)
					distance--

				var/damage=500 + charge * 1.5 + round(250*user.ControlDamageMultiplier())

				for(var/mob/OP in P.Pwned)
					OP.pressured=0
					OP.animate_movement=1
					OP.End_Stun()
					//OP.stunned-=90
					//if(OP.stunned<0)
					//	OP.stunned=0
					if(!OP.ko && !OP.protected)

						user.combat("[src]: Hit [OP] for [damage] damage!")
						OP.Dec_Stam(damage,0,user)
						OP.Hostile(user)

				P.Del()
				//user.stunned=0



		blade_of_wind
			id = FUUTON_WIND_BLADE
			name = "Wind: Blade of Wind"
			icon_state = "blade_of_wind"
			default_chakra_cost = 450
			default_cooldown = 90
			face_nearest = 1



			/*IsUsable(mob/user)
				. = ..()
				var/mob/human/target = user.NearestTarget()
				if(. && target)
					var/distance = get_dist(user, target)
					if(distance > 1)
						Error(user, "Target too far ([distance]/1 tiles)")
						return 0*/


			Use(mob/human/user)
				user.removeswords()
				user.overlays+=/obj/sword/w1
				user.overlays+=/obj/sword/w2
				user.overlays+=/obj/sword/w3
				user.overlays+=/obj/sword/w4

				viewers(user) << output("[user]: Wind: Blade of Wind!", "combat_output")

				user.Timed_Stun(6)

				//var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.NearestTarget()

				var/dmg_mult = 1
				if(etarget)
					var/dist = get_dist(user, etarget)
					if(dist == 2)
						dmg_mult = 0.7
					else if(dist != 1)
						etarget = null
				else
					for(var/mob/human/X in get_step(user,user.dir))
						if(!X.ko && !X.IsProtected())
							etarget=X

				flick("w-attack",user)
				sleep(1)

				if(etarget)
					//etarget = etarget.Replacement_Start(user)

					if(dmg_mult == 1) etarget.Timed_Stun(10)
					else etarget.Timed_Stun(5)

					var/result=Roll_Against(user.rfx+user.rfxbuff-user.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,100)
					var/rfxmult = (user.rfx+user.rfxbuff-user.rfxneg)/100
					if(result>=5)
						user.combat("[user] critically hit [etarget] with the Wind Sword")
						etarget.combat("[user] critically hit [etarget] with the Wind Sword")

						//etarget.Damage(round(rand(1000+125*rfxmult,(1000+500*rfxmult))*dmg_mult),round(rand(10,20)*dmg_mult),user,"Wind Sword","Normal")
						etarget.Dec_Stam(round(rand(1000+125*rfxmult,(1000+500*rfxmult))*dmg_mult),0,user)
						etarget.Wound(round(rand(10,20)*dmg_mult),0,user)
					else if(result==4)
						user.combat("[user] hit [etarget] with the Wind Sword")
						etarget.combat("[user] hit [etarget] with the Wind Sword")

						//etarget.Damage(round(rand(800+100*rfxmult,(800+400*rfxmult))*dmg_mult),round(rand(5,15)*dmg_mult),user,"Wind Sword","Normal")
						etarget.Dec_Stam(round(rand(800+100*rfxmult,(800+400*rfxmult))*dmg_mult),0,user)
						etarget.Wound(round(rand(10,20)*dmg_mult),0,user)
					else if(result==3)
						user.combat("[user] managed to partially hit [etarget] with the Wind Sword")
						etarget.combat("[user] managed to partially hit [etarget] with the Wind Sword")
						etarget.Dec_Stam(round(rand(500+60*rfxmult,(500+250*rfxmult))*dmg_mult),0,user)
						etarget.Wound(round(rand(3,8)*dmg_mult),0,user)

						//etarget.Damage(round(rand(500+60*rfxmult,(500+250*rfxmult))*dmg_mult),round(rand(3,8)*dmg_mult),user,"Wind Sword","Normal")
					else if(result<3)
						user.combat("You Missed!!!")
						if(!user.icon_state)
							flick("hurt",user)

					if(result>=3)
						Blood2(etarget,user)
						etarget.Hostile(user)

					//spawn(5) if(etarget) etarget.Replacement_End()

				user.overlays-=/obj/sword/w1
				user.overlays-=/obj/sword/w2
				user.overlays-=/obj/sword/w3
				user.overlays-=/obj/sword/w4
				user.removeswords()
				user.addswords()




		great_breakthrough
			id = FUUTON_GREAT_BREAKTHROUGH
			name = "Wind: Great Breakthrough"
			icon_state = "great_breakthrough"
			default_chakra_cost = 70
			default_cooldown = 15
			default_seal_time = 3



			Use(mob/human/user)
				viewers(user) << output("[user]: Wind: Great Breakthrough!", "combat_output")

				user.icon_state="HandSeals"
				//user.stunned=5
				user.Begin_Stun()

				var/dir = user.dir
				var/mob/human/player/etarget = user.MainTarget()
				if(etarget)
					dir = angle2dir_cardinal(get_real_angle(user, etarget))
					user.dir = dir

				WaveDamage(user,3,(200+150*user.ControlDamageMultiplier()),3,14)
				Gust(user.x,user.y,user.z,user.dir,3,14)

				//user.stunned=0
				user.End_Stun()
				user.icon_state=""




		air_bullet
			id = FUUTON_AIR_BULLET
			name = "Wind: Refined Air Bullet"
			icon_state = "fuuton_air_bullet"
			default_chakra_cost = 350
			default_cooldown = 30
			default_seal_time = 10



			Use(mob/human/user)
				var/ux=user.x
				var/uy=user.y
				var/uz=user.z
				var/startdir=user.dir

				var/conmult = user.ControlDamageMultiplier()
				var/mob/human/player/etarget = user.MainTarget()

				if(!etarget)
					etarget=straight_proj3(/obj/wind_bullet,8,user)
					if(etarget)
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						spawn()explosion_spread((1000+1500*conmult),ex,ey,ez,user)
					else
						if(startdir==EAST)
							explosion_spread((1000+1500*conmult),ux+8,uy,uz,user)
						if(startdir==WEST)
							explosion_spread((1000+1500*conmult),ux-8,uy,uz,user)
						if(startdir==NORTH)
							explosion_spread((1000+1500*conmult),ux,uy+8,uz,user)
						if(startdir==SOUTH)
							explosion_spread((1000+1500*conmult),ux,uy-8,uz,user)
				else
					var/ex=etarget.x
					var/ey=etarget.y
					var/ez=etarget.z
					var/mob/x=new/mob(locate(ex,ey,ez))

					projectile_to2(/obj/wind_bullet,user,x)
					//del(x)
					x.dispose()
					explosion_spread((1000+1500*conmult),ex,ey,ez,user)




	rasenshuriken
		id = FUUTON_RASENSHURIKEN
		name = "Wind: Rasenshuriken"
		icon_state = "rasenshuriken"
		default_chakra_cost = 500
		default_cooldown = 140



		Use(mob/human/player/user)
			viewers(user) << output("[user]: Wind: Rasenshuriken!", "combat_output")
			//user.stunned=10
			user.Timed_Stun(30)
			/*var/obj/x = new(locate(user.x,user.y,user.z))
			x.layer=MOB_LAYER-1
			x.icon='icons/oodamarasengan.dmi'
			x.dir=user.dir
			flick("create",x)
			user.overlays+=/obj/oodamarasengan
			spawn(30)
				del(x)*/
			sleep(30)
			if(user)
				user.rasengan=3
				//user.stunned=0
				user.combat("Press <b>A</b> before the Rasenshuriken dissapates to use it on someone. If you take damage it will dissipate!")
				spawn(100)
					if(user && user.rasengan==3)
						user.Rasenshuriken_Fail()




mob/proc
	Rasenshuriken_Fail()
		src.rasengan=0
		src.overlays-=/obj/rasengan
		src.overlays-=/obj/rasengan2
		var/obj/o=new/obj(locate(src.x,src.y,src.z))
		o.layer=MOB_LAYER+1
		o.icon='icons/rasengan.dmi'
		flick("failed",o)
		spawn(50)
			del(o)
	Rasenshuriken_Hit(mob/x,mob/u,xdir)
		u.overlays-=/obj/rasengan
		u.overlays-=/obj/rasengan2
		u.rasengan=0
		var/conmult=(u.con+u.conbuff-u.conneg)/100
		x.cantreact=1
		spawn(30)	// Can we please not forget to make sure things are still valid after any sleep or spawn call.
			if(x)	x.cantreact=0
		var/obj/o=new/obj(locate(x.x,x.y,x.z))
		o.icon='icons/rasengan.dmi'
		o.layer=MOB_LAYER+1
		if(!x.icon_state)
			x.icon_state="hurt"

		flick("hit",o)

		x.Earthquake(10)
		spawn(50)
			del(o)
		sleep(10)
		if(x)
			x.Knockback(10,xdir)
			if(x)	// Knockback sleeps, I think. It really shouldn't though.
				explosion(50,x.x,x.y,x.z,u,1)
				x.Dec_Stam(1000+500*conmult,0,u)
				//x.stunned+=3
				x.Timed_Stun(30)
				if(!x.ko)
					x.icon_state=""
				x.Hostile(u)
