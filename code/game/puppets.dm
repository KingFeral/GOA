mob
	var
		Puppets[2]
		puppetsave[][]
		tmp/puppetsout
mob/human/Puppet/proc
	Melee(mob/u)
		var/nopk
		for(var/area/O in oview(0,src))
			if(istype(O,/area/nopkzone))
				nopk=1
			else
				nopk=0
		if(nopk)
			return
		if(!src.stunned)
			if(!src.coold)
				flick("Melee",src)
				src.coold+=src.meleecost
				for(var/mob/human/X in oview(1,src))
					if(X==u.MainTarget()&& !X.ko && !X.protected)
						if(!X.icon_state)
							flick("hurt",X)
						X.Dec_Stam(((rand(50,200)*src.meleedamage)/100))
						X.Wound(((rand(50,200)*src.wounddamage)/100))
						X.Hostile(u)
						var/b=pick(1,2,3)
						if(b==3)
							Blood2(X)
						return
				for(var/mob/human/X in get_step(src,src.dir))
					if(!X.ko && !X.protected)
						if(!X.icon_state)
							flick("hurt",X)
						X.Dec_Stam(((rand(50,200)*src.meleedamage)/100))
						X.Wound(((rand(50,200)*src.wounddamage)/100))
						X.Poison+=src.Pmod
						X.Hostile(u)
						var/b=pick(1,2,3)
						if(b==3)
							Blood2(X)
						return
	Def(mob/u)
		if(!src.stunned)
			walk_towards(src,u)
			sleep(5)
			walk(src,0)
			src.AppearAt(u.x,u.y,u.z)

	pwalk_towards(mob/human/Puppet/a,atom/b,lag=0,dur=60)
		if(a.walking) return
		else a.walking = 1

		var/howclose
		if(b.density) howclose = 1
		else howclose = 0

		var/lastloc

		while(a && !a.stunned && !a.stopwalking && b && get_dist(a,b) > howclose && dur > 0 && lastloc != a.loc)
			if(!b.density)
				howclose = 0
				if(istype(b,/turf))
					for(var/atom/atom in b)
						if(atom.density)
							howclose = 1
				else
					for(var/atom/atom in b.loc)
						if(atom.density)
							howclose = 1
			lastloc = a.loc
			var/success = step_towards(a,b)
			if(!success)
				a.dir = turn(a.dir,45)
				var/suc = step(a,a.dir)
				if(!suc)
					a.dir = turn(a.dir,-90)
					step(a,a.dir)
			dur -= 1+lag
			sleep(1+lag)

		if(a)
			a.walking = 0
			a.stopwalking = 0

mob
	human
		Puppet
			var
				saveindex=0
				coold=0
				coold2[20]
				meleedamage=0
				wounddamage=0
				meleecost=1
				Pmod=0
				walking
				stopwalking

			Karasu
				icon='icons/puppet1.dmi'
				initialized=1
				protected=0
				ko=0
				str=65
				con=65
				rfx=65
				int=65
				stamina=5000
				curstamina=5000
				chakra=300
				meleedamage=200
				wounddamage=2
				meleecost=2

				Advanced
					str = 80
					con = 80
					rfx = 80
					int = 80
					stamina = 6000
					curstamina = 6000
					chakra = 400
					meleedamage = 400

				Master
					str = 95
					con = 95
					rfx = 95
					int = 95
					stamina = 7000
					curstamina = 7000
					chakra = 500
					meleedamage = 600

mob
	proc
		PuppetSkill(oindex,mob/u)
			var/mob/etarget= u.MainTarget()
			usr=src
			var/nopk
			for(var/area/O in oview(0,src))
				if(istype(O,/area/nopkzone))
					nopk=1
				else
					nopk=0
			if(nopk)
				return
			switch(oindex)
				if(1)//knife launcher
					var/eicon='icons/projectiles.dmi'
					var/estate="knife-m"

					//var/r=rand(3,10)
					if(etarget)
						src.dir = angle2dir_cardinal(get_real_angle(src, etarget))

					var/angle
					var/speed = 32
					//var/spread = 9
					if(etarget) angle = get_real_angle(src, etarget)
					else angle = dir2angle(src.dir)

					var/damage = 900

					spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=damage, wounds="passive", ignore_list = list(u))
		/*			if(etarget)
						var/angle = get_real_angle(src, etarget)
						var/speed = 32
						var/momx=speed*cos(angle)
						var/momy=speed*sin(angle)

						spawn()advancedprojectile(eicon,estate,src,momx,momy,10,900,r,100,1)

					else
						if(src.dir==NORTH)
							spawn()advancedprojectile(eicon,estate,src,0,32,10,900,r,100,1)

						if(src.dir==SOUTH)
							spawn()advancedprojectile(eicon,estate,src,0,-32,10,900,r,100,1)

						if(src.dir==EAST)
							spawn()advancedprojectile(eicon,estate,src,32,0,10,900,r,100,1)

						if(src.dir==WEST)
							spawn()advancedprojectile(eicon,estate,src,-32,0,10,900,r,100,1)

						return*/

				if(2)//poison bomb
					flick("hand",src)
					var/eicon='icons/poison.dmi'
					var/estate="ball"
					if(!etarget)
						etarget=straight_proj2(eicon,estate,8,src)
						if(etarget)
							var/ex=etarget.x
							var/ey=etarget.y
							var/ez=etarget.z
							spawn()AOEPoison(ex,ey,ez,1,100,50,u,6,1)
							spawn()PoisonCloud(ex,ey,ez,1,50)
					else
						var/ex=etarget.x
						var/ey=etarget.y
						var/ez=etarget.z
						var/mob/x=new/mob(locate(ex,ey,ez))

						projectile_to(eicon,estate,src,x)
						del(x)
						spawn()AOEPoison(ex,ey,ez,1,100,50,u,6,1)
						spawn()PoisonCloud(ex,ey,ez,1,50)
					usr.icon_state=""

				if(3)//Body crush
					if(!etarget)
						for(var/mob/human/X in get_step(src,src.dir))
							etarget=X
					if(get_dist(src, etarget) <= 1)
						var/orig_loc = etarget.loc

						//src.stunned=10
						Timed_Stun(100)
						sleep(15)
						if(etarget && etarget.loc == orig_loc)
							//etarget.stunned=10
							etarget.Timed_Stun(30)
							src.layer++
							src.icon_state="hid"
							src.loc=orig_loc
							var/image/e=image(icon='icons/puppet1.dmi',icon_state="bindunder")
							etarget.underlays+=e
							etarget.icon_state="hurt"
							flick("bindover",src)
							sleep(30)
							src.icon_state=""
							if(etarget)
								etarget.icon_state=""
								etarget.underlays-=e
								//etarget.stunned=2
								etarget.Dec_Stam(rand(2000,3500))
								etarget.Wound(rand(4,9))
								etarget.Hostile(u)
							src.layer=MOB_LAYER
							del(e)

				if(4)//Poison tipped blade
					u<<"[src] releases poison onto its blades."
					src:Pmod=4

				if(5)//Needle Gun
					src.icon_state="gun"
					src:coold+=3000
					var/c=20
					var/ewoundmod=100
					var/eicon='icons/projectiles.dmi'
					var/estate="needle-m"
					var/evel=150

					while(c>0)
						spawn()
							if(src.dir==NORTH)
								spawn()advancedprojectile(eicon,estate,src,rand(-10,10),32,10,ewoundmod,0,evel,0,src)

							if(src.dir==SOUTH)
								spawn()advancedprojectile(eicon,estate,src,rand(-10,10),-32,10,ewoundmod,0,evel,0,src)

							if(src.dir==EAST)
								spawn()advancedprojectile(eicon,estate,src,32,rand(-10,10),10,ewoundmod,0,evel,0,src)

							if(src.dir==WEST)
								spawn()advancedprojectile(eicon,estate,src,-32,rand(-10,10),10,ewoundmod,0,evel,0,src)
						spawn()


							if(src.dir==NORTH)
								spawn()advancedprojectile(eicon,estate,src,rand(-10,10),32,10,ewoundmod,0,evel,0,src)

							if(src.dir==SOUTH)
								spawn()advancedprojectile(eicon,estate,src,rand(-10,10),-32,10,ewoundmod,0,evel,0,src)

							if(src.dir==EAST)
								spawn()advancedprojectile(eicon,estate,src,32,rand(-10,10),10,ewoundmod,0,evel,0,src)

							if(src.dir==WEST)
								spawn()advancedprojectile(eicon,estate,src,-32,rand(-10,10),10,ewoundmod,0,evel,0,src)
						c--
						sleep(2)
					src:coold-=3000
					if(src:coold<0)
						src:coold=0
					src.icon_state=""

				if(6)//shield
					//src.stunned=100
					Begin_Stun()
					noknock++
					src.icon_state="shield"
					sleep(5)
					var/obj/S=new/obj/Shield(locate(src.x,src.y,src.z))
					sleep(50)
					//src.stunned=0
					End_Stun()
					noknock--
					src.icon_state=""
					del(S)

obj
	Shield
		layer=MOB_LAYER+3
		density=0
		New()
			..()
			src.overlays+=image('icons/shield.dmi',icon_state="tl",pixel_x=-16,pixel_y=16)
			src.overlays+=image('icons/shield.dmi',icon_state="tr",pixel_x=16,pixel_y=16)
			src.overlays+=image('icons/shield.dmi',icon_state="bl",pixel_x=-16,pixel_y=-16)
			src.overlays+=image('icons/shield.dmi',icon_state="br",pixel_x=16,pixel_y=-16)
			sleep(70)
			del(src)

mob/human/Puppet
	proc
		PuppetRegen(mob/u)
			while(u)
				if(src.icon_state=="hurt")
					src.icon_state=0
				//if(src.stunned)
				//	src.stunned--
				//	if(src.stunned<0)
				//		src.stunned=0
				//if(move_stun)
				//	move_stun = max(0, move_stun-10)
				if(src.coold)
					src.coold--
				var/i=1
				while(i<20)
					if(src.coold2[i])
						src.coold2[i]--
					i++
				if(src.curstamina<0 || src.curwound>50)
					Poof(src.x,src.y,src.z)
					/*if(u.Puppet1==src)
						//u.cooldown[73]=300
						//spawn()u.CoolD(73)
						/*for(var/obj/gui/M in u.contents)
							if(M.sindex==73)
								M.overlays+='icons/dull.dmi'*/
					if(u.Puppet2==src)
						//u.cooldown[74]=300
						//spawn()u.CoolD(74)
						/*for(var/obj/gui/M in u.contents)
							if(M.sindex==74)
								M.overlays+='icons/dull.dmi'*/*/
					sleep(3)
					del(src)
				sleep(5)
			del(src)

obj/items
	Puppet
		var
			inuse=0
			incarnation=0
			summon=/mob/human/Puppet/Karasu
		verb/Change_Name()
			var/newname=input_text(usr,"Change [src]'s name to what?")
			if(!world.Name_No_Good(newname))
				var/oldname=src.name
				var/xname=newname
				newname=world.Name_Correct(xname)
				src.name=newname
				usr<<"[oldname]'s name has been changed to [src.name]"
			else
				usr<<"Thats a bad name!"
		verb/Destroy()
			switch(input2(usr,"Really Destroy [src]?!", list("No","Yes")))
				if("Yes")
					del(src)
		Karasu
			code=105
			summon=/mob/human/Puppet/Karasu
			icon='icons/puppet1.dmi'
			icon_state="gui"

		Advanced_Karasu
			code=218
			summon=/mob/human/Puppet/Karasu/Advanced
			icon='icons/puppet1.dmi'
			icon_state="gui"

		Master_Karasu
			code=219
			summon=/mob/human/Puppet/Karasu/Master
			icon='icons/puppet1.dmi'
			icon_state="gui"

		Click()
			Use(usr)

		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0)
				var/list/listpuppets=new
				if(usr:HasSkill(PUPPET_SUMMON1))
					listpuppets+="Puppet 1"
				if(usr:HasSkill(PUPPET_SUMMON2))
					listpuppets+="Puppet 2"
				listpuppets+="Unequip"
				listpuppets+="Nevermind"
				usr.Puppets.len=2
				switch(input2(usr,"Which Puppet slot do you want to assign [src] to?","Puppet Equip",listpuppets))
					if("Puppet 1")
						if(!usr.Puppet1)
							usr.Puppets[1]=src
							src.overlays+='icons/Equipped1.dmi'
						else
							usr<<"Put away Puppet 1 first."

					if("Puppet 2")
						if(!usr.Puppet2)
							usr.Puppets[2]=src
							src.overlays+='icons/Equipped2.dmi'
						else
							usr<<"Put away Puppet 2 first."
					if("Unequip")
						src.overlays=0
						for(var/obj/x in usr.Puppets)
							if(x==src)
								usr.Puppets.Remove(x)

	Puppet_Stuff
		var/oindex=0
		var/costz=5
		Hidden_Knife_Shot
			icon='icons/gui.dmi'
			icon_state="mouthknife"
			oindex=1
			costz=2
			code=106
		Poison_Bomb
			icon='icons/gui.dmi'
			icon_state="poisonbomb"
			oindex=2
			costz=5
			code=107
		Body_Crush
			icon='icons/gui.dmi'
			icon_state="armbind"
			oindex=3
			costz=5
			code=108
		Poison_Tipped_Blade
			icon='icons/gui.dmi'
			icon_state="mild-poison"
			oindex=4
			costz=3
			code=109
		Needle_Gun
			icon='icons/gui.dmi'
			icon_state="needlegun"
			oindex=5
			code=110
			costz=5
		Chakra_Shield
			icon='icons/gui.dmi'
			icon_state="chakrashield"
			oindex=6
			costz=3
			code=111

		Click()
			Use(usr)

		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0&&usr.pk==1&&src.equipped)
				var/obj/items/Puppet/host=usr.Puppets[src.equipped]
				if(host)
					var/mob/human/Puppet/T=host.incarnation
					if(T && (T in oview(20,usr))&& !T.coold &&!T.coold2[oindex])
						T.coold2[oindex]=costz*10
						T.PuppetSkill(oindex,u)

		verb
			Install()
				var/list/equipto=new
				for(var/obj/X in usr.Puppets)
					equipto+=X
				var/obj/items/Puppet/P = input4(usr,"Equip to which puppet?","Equip", equipto)
				if(!P)
					usr<<"Equip some puppets first maybe."
					return
				if(P.incarnation)
					usr<<"You cannot Install Components while your puppet is out!"
					return

				var/ind=0
				var/count=0
				if(usr.Puppets.len < 2)
					usr.Puppets.len = 2
				if(usr.Puppets[1]==P)
					ind=1
				if(usr.Puppets[2]==P)
					ind=2
				for(var/obj/items/Puppet_Stuff/W in usr.contents)
					if(W.equipped==ind)
						count++
				if(count>2)
					usr<<"A puppet can only equip 3 items."
					return
				if(ind==1)
					src.overlays+='icons/Equipped1.dmi'
				if(ind==2)
					src.overlays+='icons/Equipped2.dmi'
				src.install=ind
				src.equipped=ind

			UnInstall()
				src.equipped=0
				src.overlays=0
obj
	var
		install=0
