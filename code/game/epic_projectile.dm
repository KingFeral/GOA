/*
M_Projectile system made by Masterdan (M get it?)
	version: 1.0
	-System features pixel movement based projectiles
	-Pixel based collision.
	-Handles momentum and collisions with other moving objects
	-hit detection is based on an atom's radius variable (distance in pixels from the center of the icon) and momentum exchange is dependant on an atom's weight variable (default is 150, a 1 weight object will have very little push to a 3000 weight object)
	-can easily define behavior for different projectiles apon hitting another projectile, hitting a solid object, hitting a solid turf, hitting a mob.
	-can handle multi tile graphics (set your radius appropriately! (64x64 graphic would have a radius (half the width) of 32.)


M_Projectile_Coord(obj/projectile/O,mob/user,power,iterations,speed,tx,ty)

		O: a projectile, one that has been initiated. you can simply do new/obj/projectile/whatever(src.loc) in this parameter in most code situations, but really pass any projectile object you want.
		user: the person using this projectile
		power: this is the damage variable, it will be passed on apon collision with a player or npc to be used however you want.
		iterations:this is how many ticks movement will occur for.  If your using 32 speed then iterations is equal to the number of tiles (approx)
			that you will move (assuming straight projectile)
		speed: 32 is a typical 1 tile per tick speed, experiment on ranges from 10 being slow and 60+ being veeery fast
			**there might be issues with multi_icon graphics if you set speed above 64 and certainly issues if you try to set it above 127
		tx=specific x coordinate (see below)
		ty=specific y coordinate (see below)

		!Note!
		Used when you want to give specific pixel by pixel coordinates.
		var/specific_x=(src.x-1)*32 +16 +src.pixel_x
		var/specific_y=(src.y-1)*32 + 16 + src.pixel_y
		get_specific_coords() is useful, call src.get_specific_coords() and it will refresh the atom's p_x and p_y variables
			to be the specific_x and specific_y variables calculated exactly as demonstrated above. This is the coordinate system used here

M_Projectile_Target(O,mob/user,power,iterations,speed,atom/target)
		O: a projectile, one that has been initiated. you can simply do new/obj/projectile/whatever(src.loc) in this parameter in most code situations, but really pass any projectile object you want.
		user: the person using this projectile
		power: this is the damage variable, it will be passed on apon collision with a player or npc to be used however you want.
		iterations:this is how many ticks movement will occur for.  If your using 32 speed then iterations is equal to the number of tiles (approx)
			that you will move (assuming straight projectile)
		speed: 32 is a typical 1 tile per tick speed, experiment on ranges from 10 being slow and 60+ being veeery fast
			**there might be issues with multi_icon graphics if you set speed above 64 and certainly issues if you try to set it above 127
		target: a turf, object or mob. This is simply a reference that the projectile will be aimed to. It will calculate the trajectory once and if the reference moves it may miss.

		!Note!
		used when you want to fire a projectile at a certain turf/obj/mob, does not home but simply sets the angle to the reference.

M_Projectile_Degree(O,mob/user,power,iterations,speed,degree)
		O: a projectile, one that has been initiated. you can simply do new/obj/projectile/whatever(src.loc) in this parameter in most code situations, but really pass any projectile object you want.
		user: the person using this projectile
		power: this is the damage variable, it will be passed on apon collision with a player or npc to be used however you want.
		iterations:this is how many ticks movement will occur for.  If your using 32 speed then iterations is equal to the number of tiles (approx)
			that you will move (assuming straight projectile)
		speed: 32 is a typical 1 tile per tick speed, experiment on ranges from 10 being slow and 60+ being veeery fast
			**there might be issues with multi_icon graphics if you set speed above 64 and certainly issues if you try to set it above 127
		degree: any degree angle, using this convention: http://math.rice.edu/~pcmi/sphere/degrad.gif

		!Note!
		Fires a projectile using a specific degree, sets the trajectory directly.

M_Projectile_Straight(O,mob/user,power,iterations,speed)
		O: a projectile, one that has been initiated. you can simply do new/obj/projectile/whatever(src.loc) in this parameter in most code situations, but really pass any projectile object you want.
		user: the person using this projectile
		power: this is the damage variable, it will be passed on apon collision with a player or npc to be used however you want.
		iterations:this is how many ticks movement will occur for.  If your using 32 speed then iterations is equal to the number of tiles (approx)
			that you will move (assuming straight projectile)
		speed: 32 is a typical 1 tile per tick speed, experiment on ranges from 10 being slow and 60+ being veeery fast
			**there might be issues with multi_icon graphics if you set speed above 64 and certainly issues if you try to set it above 127


		!Note!
		Fires a projectile at an angle based on which direction user is facing (ie EAST= 0degrees, WEST=180 degrees etc)


M_Projectile(obj/projectile/O,mob/user,power,xmom,ymom,iterations)
	*This proc is the one that all the preceeding procs use after calculating xmom and ymom.
		O: a projectile, one that has been initiated. you can simply do new/obj/projectile/whatever(src.loc) in this parameter in most code situations, but really pass any projectile object you want.
		user: the person using this projectile
		power: this is the damage variable, it will be passed on apon collision with a player or npc to be used however you want.
		iterations:this is how many ticks movement will occur for.  If your using 32 speed then iterations is equal to the number of tiles (approx)
			that you will move (assuming straight projectile)
		speed: 32 is a typical 1 tile per tick speed, experiment on ranges from 10 being slow and 60+ being veeery fast
			**there might be issues with multi_icon graphics if you set speed above 64 and certainly issues if you try to set it above 127

		xmom: the amount of pixels to add/subtract to the projectiles pixel x coordinate per iteration
		ymom: the amount of pixels to add/subtract to the projectiles pixel y coordinate per iteration

		!Note!
		the most direct way to use this projectile system, if you know exactly how many pixels you want this thing to move in which direction then use this master proc.

get_specific_coords()
	used atom/proc/get_specific_coords (aka obj,mob,turf) ie( src.get_specific.coords())
	simply refreshes the objects p_x and p_y varibles, these are pixel based coordinates that take pixel_x and pixel_y into account in positioning and hit detection for the projectile system.
Expand('icon.dmi')
	used atom/movable/proc/Expand() (aka obj,mob)
	used when you have an icon file as a parameter that is larger than 32x32, the icon should have only one state with no name. This icon can have many directions and be animated. This will cause
	whatever called the proc will have this multi-tile icon be broken up and placed on top of it.  This uses Byond4.0's handling of multitile graphics. To use this
	go into a new icon, set the dimensions equal to the size of the graphic your going to use (always use .png), then in the frame you want to place a graphic in, click the import button. Find the graphic you want and voila it will be part of
	the multitile graphic.  Used in this demo with the BlackSlash example, really powerful code.
	ie:
		var/obj/projectile/O = new/obj/projectile(locate(3,3,3))
		O.Expand('Fireball.dmi')

*/
proc/M_Projectile_Coord(obj/projectile/O,mob/user,power,iterations,speed,tx,ty,list/Misc)
	if(user)
		user.get_specific_coords()
		var/deg=arctan2(ty-user.p_y,tx-user.p_x)  //arctan2(dy,dx)
		M_Projectile_Degree(O,user,power,iterations,speed,deg,Misc)
proc/M_Projectile_Target(O,mob/user,power,iterations,speed,atom/target,list/Misc)
	if(target && user)
		target.get_specific_coords()
		user.get_specific_coords()
		var/deg=arctan2(target.p_y-user.p_y,target.p_x-user.p_x)  //arctan2(dy,dx)

		M_Projectile_Degree(O,user,power,iterations,speed,deg,Misc)
proc/M_Projectile_Degree(O,mob/user,power,iterations,speed,degree,list/Misc) //given a degree
	var/xmom=speed*cos(degree)
	var/ymom=speed*sin(degree)
	M_Projectile(O,user,power,xmom,ymom,iterations,Misc)
proc/M_Projectile_Straight(O,mob/user,power,iterations,speed,list/Misc) //fires in the direction user is facing
	var/degree=0
	spawn(50)if(O)del(O)
	if(user)
		switch(user.dir)
			if(EAST)
				degree=0
			if(NORTHEAST)
				degree=45
			if(NORTH)
				degree=90
			if(NORTHWEST)
				degree=135
			if(WEST)
				degree=180
			if(SOUTHWEST)
				degree=225
			if(SOUTH)
				degree=270
			if(SOUTHEAST)
				degree=315

	var/xmom=speed*cos(degree)
	var/ymom=speed*sin(degree)
	M_Projectile(O,user,power,xmom,ymom,iterations,Misc)
atom/movable/var/vectorized=0
proc/M_Projectile(atom/movable/O,mob/user,power,xmom,ymom,iterations,list/Misc) //o is a type path, ie /obj/projectile/Black_Slash, xmom and ymom are how many pixels to move x and y per iteration, distance is how many iterations
	if(abs(xmom)+abs(ymom)<5)
		del(O)
		return
	var/wnd=0
	var/daze=0
	var/ignore_list[]
	if(Misc && Misc["Wound"]) wnd=Misc["Wound"]
	if(Misc && Misc["Daze"]) daze=Misc["Daze"]
	if(Misc && Misc["ignore"]) ignore_list = Misc["ignore"]
	O.vectorized=1
	O.powner=user

	if(user&& O)
		O.pwr=power
		O.momx=xmom/2
		O.momy=ymom/2
		O.momentum=iterations*2
		var/speed = sqrt(O.momx*O.momx + O.momy*O.momy)
		var/degre=arctan2(ymom,xmom)
		O.dir=angle2dir(degre)

		for(var/obj/OG in O.Grabbed)
			OG.dir=O.dir

		var/xpiggybank=0
		var/ypiggybank=0
		//check destiny
		var/turf/Winner=null

		if(!O.ignoredense)
			var/X2=max(min(O.x + round(xmom*iterations/32),100),1)
			var/Y2=max(min(O.y + round(ymom*iterations/32),100),1)
			var/turf/A1=locate(O.x,O.y,O.z)
			var/turf/A2=locate(X2,Y2,O.z)
			var/list/Lin= get_line(A1,A2)
			var/list/collideds=new
			for(var/turf/T in Lin)
				/*var/image/I = image('projectile_test.dmi', T, "line_check", 1000)
				user.client << I
				spawn(100)
					if(user && user.client) user.client.images -= I*/
				for(var/obj/Oz in T)
					if(Oz.density && !Oz.vectorized)
						collideds+=T
						break

				if(T.density) collideds+=T

			var/mindist=100
			for(var/turf/T in collideds)
				var/dx = O.x - T.x
				var/dy = O.y - T.y
				var/dist=sqrt(dx*dx+dy*dy)
				if(dist<mindist)
					mindist=dist
					Winner=T

		/*if(Winner && user.client)
			var/image/I = image('projectile_test.dmi', Winner, "dense_obstacle", 1000)
			user.client << I
			spawn(100)
				if(user && user.client) user.client.images -= I*/

		while(O && O.loc && O.momentum>0)
			while(O && O.clashin)
				sleep(1)

			O.get_specific_coords()
			var/turf/TT=get_real_loc(O)
			if(!TT||!O)
				if(O)del(O)
				return

			if(Winner && TT==Winner)
				O.landed(0)

			if(!O || !O.loc)return

			if(!O.ignoreprojectiles)
				// Was /atom/movable, but BYOND only allows /atom/movable to be /mob or /obj.
				// There's another loop for mobs below, so simply do /obj here.
				var/speed_tiles = speed/32
				var/distance = max(1, round(0.99+speed_tiles)+round((O.radius-16)/32))
				for(var/obj/m in oview(distance,O))
					if(m.vectorized && m.powner != O.powner && physics_intersection(O,m))
						O.landed(m,power,wnd,daze)
						if(!O || !O.loc) return

			if(!O.ignoremobs)
				for(var/mob/human/m in oview(2,O))
					if(m!=user && !(m in ignore_list) && physics_stationary(O,m))
						O.pixel_x+=O.momx
						O.pixel_y+=O.momy

						O.landed(m,power,wnd,daze)
						if(!O || !O.loc) return

			//move!-
			if(!O || !O.loc)return

			var/new_pixel_x = O.pixel_x
			var/new_pixel_y = O.pixel_y

			xpiggybank += O.momx
			if(abs(xpiggybank) > 1)
				var/diff = round(xpiggybank)
				new_pixel_x+=diff
				xpiggybank-=diff

			ypiggybank+=O.momy
			if(abs(ypiggybank) > 1)
				var/diff = round(ypiggybank)
				new_pixel_y+=diff
				ypiggybank-=diff

			while(O && O.momentum && new_pixel_x>16 &&((O.x)+1 < world.maxx))
				O.x+=1
				new_pixel_x-=32
				if(Winner && O.loc==Winner)
					O.pixel_x = 0
					O.pixel_y = 0
					O.landed(0)
					break

			while(O && O.momentum && new_pixel_y>16&&((O.y)+1 < world.maxy))
				O.y+=1
				new_pixel_y-=32
				if(Winner && O.loc==Winner)
					O.pixel_x = 0
					O.pixel_y = 0
					O.landed(0)
					break

			while(O && O.momentum && new_pixel_x<-16&&((O.x)-1 >1))
				O.x-=1
				new_pixel_x+=32
				if(Winner && O.loc==Winner)
					O.pixel_x = 0
					O.pixel_y = 0
					O.landed(0)
					break

			while(O && O.momentum && new_pixel_y<-16&&((O.y)-1 >1))
				O.y-=1
				new_pixel_y+=32
				if(Winner && O.loc==Winner)
					O.pixel_x = 0
					O.pixel_y = 0
					O.landed(0)
					break

			O.pixel_y = new_pixel_y
			O.pixel_x = new_pixel_x

			O.Relocate()
			// -----

			sleep(1)
			O.momentum--

		if(!O || !O.loc)
			return

		if(istype(O,/obj/projectile))
			O.loc = null
			O:owner = null
			O.powner = null
			return

		if(istype(O,/mob))
			while(O.pixel_x>16 &&((O.x)+1 < world.maxx))
				O.x+=1
				O.pixel_x-=32
			while(O.pixel_y>16&&((O.y)+1 < world.maxy))
				O.y+=1
				O.pixel_y-=32
			while(O.pixel_x<-16&&((O.x)-1 >1))
				O.x-=1
				O.pixel_x+=32
			while(O.pixel_y<-16&&((O.y)-1 >1))
				O.y-=1
				O.pixel_y+=32
			while(O.pixel_x != 0 && O.pixel_y != 0)
				if(O.pixel_x < 0)
					++O.pixel_x
				else
					--O.pixel_x
				if(O.pixel_y < 0)
					++O.pixel_y
				else
					--O.pixel_y
				sleep(1)

		if(O)
			O.vectorized=0

atom/var
	eb=0
	clashin=0
	p_x=0
	p_y=0
	radius=16
	weight=1
	momentum=0
	momx=0
	momy=0
	trailx=0
	traily=0
	landed=0
	pwr=0
	bouncy=0
	push=0
	ignoredense=0
	ignoreprojectiles=0
	ignoremobs=0
	powner=0
atom/movable
	proc/landed(atom/movable/O,pow,wnd,daze)


proc/get_real_loc(atom/movable/O)
	var/turf/T
	var/X= O.x+ round((O.pixel_x +16)/32)
	var/Y=O.y+round((O.pixel_y+16)/32)
	T=locate(X,Y,O.z)
	return T
//EXAMPLES!!------------------------------------------------------------------------------------------------------
obj/projectile
	animate_movement=0
	density=0
	layer=MOB_LAYER+2



	wave
		ignoredense=1
		ignoreprojectiles=0
		ignoremobs=0
		bouncy=0
	/*	Black_Slash
			layer=MOB_LAYER+2
			push=1
			radius=96/2  //this is the range in which from the center of the object out that will hit things.
			weight=3000 //Weight is the variable for knockback, this move has quite a bit of force.
			New(loc,mob/o)
				..()
				sleep(1)
				src.Expand('blackslash.dmi')*/
		New(loc,mob/o)
			..()
			src.powner=o
		landed(atom/movable/O,pow,wnd,daze)
			..()
			if(src.landed || src.clashin)
				return
			src.landed=1
			if(!O)
				sleep(10)
				del(src) //hit a wall!
			if(istype(O,/mob/human/player))
				//world << "THE ONE THATS CALLED"
				var/mob/human/player/Oc=O
				src.Grabbed+=Oc  //this means the wave will no longer cause damage to that specific player, 1 time hit max per projectile of this type
				spawn()Oc.Collide(src)//the mob gets hit by src. Cause knockback check.
				Oc.Dec_Stam(pow)

			if(istype(O,/obj/projectile))
				Clash(O,src)


	solid
		ignoredense=0
		ignoreprojectiles=0
		ignoremobs=0
		bouncy=1
		var/landed_state=""
		Shuriken
			radius=6
			weight=1
			icon='icons/projectiles.dmi'
			icon_state="shuriken-m"
		New(loc,mob/o)
			..()
			src.powner=o
		landed(atom/movable/O,pow,wnd,daze)
			if(src.landed)
				return
			src.landed=1
			if(!O)
				src.icon_state=pick("shuriken-m-clashed1","shuriken-m-clashed2","shuriken-m-clashed3") //sets the projectile to its landed in a turf icon state
				sleep(50)
				src.landed=2
				del(src) //hit a wall!
			if(istype(O,/mob/human/player))
				var/mob/human/player/Oc=O
				Oc.Dec_Stam(pow)  //hurt the player it hits = the power variable
				Blood(O.x,O.y,O.z)  //ew blood
				src.loc=null  //go away invisible
				sleep(20) //give it some time before deletion to avoid runtimes
				del(src)
			if(istype(O,/obj/projectile))
				var/obj/projectile/Oc=O
				if(Oc.landed!=2)  //dont clash with projectiles that are sticking in turfs!
					Clash(O,src) //clash O and src together

//--------------------------------------------------------------------------------------------------
mob/landed(atom/movable/O,pow,wnd,daze)
	momentum = 0
	if(!O)
		O = loc
	/*if(client)
		var/image/I = image('projectile_test.dmi', O, "dense_obstacle", 1000)
		client << I
		spawn(100)
			if(client) client.images -= I*/

mob/proc/Collide(obj/projectile/O)
	var/r=O.weight/src.weight  //how much does this object weigh compared to your guy? shuriken might be 1/150 so less than 1, greater than 1 means the object hitting you is heavier than you!
	var/i= round(O.momentum * r) //10 more space movements left? but weight only half as much as the mob, would only cause 5 momentum
	if(i>=2)//only bother with significant knockback, otherwise assume the mob is not overwhelmed by it
		if(i>10)i=10
		var/mx=O.momx * i
		var/my=O.momy*i
		if(abs(mx)<20)  //we cant accept overly minor momentums because it wont result in a complete coordinate change and will look bad.
			mx=0
		if(abs(my)<20)
			my=0
		mx*=1/i
		my*=1/i
		for(var/obj/B in O.Grabbed)B.Grabbed+=src
		if(!src in O.Grabbed)O.Grabbed+=src

		src.Knockback_new(mx,my,i,O.push)
mob/proc/Knockback_new(mx,my,i,push) //if push then the knockback will stun the opponent
	src.animate_movement=0
	var/xpiggybank=0
	var/ypiggybank=0
	src.momentum=i
	src.momx=mx
	src.momy=my
	var/speed = sqrt(momx*momx + momy*momy)
	if(push)
		var/em=src.momentum
		if(em>5)em=5
		if(src.stunned<em)
			src.stunned=em
	sleep(1)
	while(src.momentum>0)
		if(src)
			var/list/suspects=new/list()
			src.get_specific_coords()
			var/turf/E=locate(src.x+round(src.pixel_x/32),src.y+round(src.pixel_y/32),src.z)
			for(var/turf/T in oview(round((src.radius-16)/32)+1,E))
				if(T.density)
					if(physics_stationary(src,T))
						src.get_specific_coords()
						src.momentum=0

			var/speed_tiles = speed/32
			var/distance = max(1, round(0.99+speed_tiles)+round((radius-16)/32))
			for(var/atom/movable/m in oview(distance,src))
				if(!(src in m.Grabbed) && m!=src)
					suspects+=m

			for(var/obj/m in suspects)
				if(istype(m,/obj/projectile))
					var/obj/projectile/M=m
					if(physics_stationary(src,M))
						src.momentum=0
				else if(m.density)
					if(physics_stationary(src,m))
						src.momentum=0

			for(var/mob/human/player/m in suspects)
				if(m!=src&&physics_stationary(src,m))
					src.momentum=0

			//move!-
			if(src.momentum)
				xpiggybank+=mx
				if(abs(xpiggybank) > 1)
					var/sign = xpiggybank>=0?1:-1
					var/diff = round(abs(xpiggybank))
					pixel_x+=diff*sign
					xpiggybank-=diff*sign

				ypiggybank+=my
				if(abs(ypiggybank) > 1)
					var/sign = ypiggybank>=0?1:-1
					var/diff = round(abs(ypiggybank))
					pixel_y+=diff*sign
					ypiggybank-=diff*sign

				if(src.pixel_x>32 &&((src.x)+1 < world.maxx))
					src.x+=1
					src.pixel_x-=32
				if(src.pixel_y>32&&((src.y)+1 < world.maxy))
					src.y+=1
					src.pixel_y-=32
				if(src.pixel_x<-32&&((src.x)-1 >1))
					src.x-=1
					src.pixel_x+=32
				if(src.pixel_y<-32&&((src.y)-1 >1))
					src.y-=1
					src.pixel_y+=32

		sleep(1)

		if(src.momentum)src.momentum--

	while(src.pixel_x>32)
		if((src.x)+1 < world.maxx)src.x+=1
		src.pixel_x-=32
	while(src.pixel_y>32)
		if((src.y)+1 < world.maxy)src.y+=1
		src.pixel_y-=32
	while(src.pixel_x<-32)
		if((src.x)-1 >1)src.x-=1
		src.pixel_x+=32
	while(src.pixel_y<-32)
		if((src.y)-1 >1)src.y-=1
		src.pixel_y+=32
	if(src.pixel_x>16)
		src.x+=1
	src.pixel_x=0
	if(src.pixel_y>16)
		src.y+=1
	src.pixel_y=0
	if(src.pixel_x<-16)
		src.x-=1
	src.pixel_x=0
	if(src.pixel_y<-16)
		src.y-=1
	src.pixel_y=0

	src.animate_movement=1

atom/movable/Del()
	for(var/obj/projectile/O in src.Grabbed)
		O.loc=null

	..()

mob
	weight=150
atom/movable/proc/Relocate()
	for(var/obj/projectile/M in src.Grabbed)
		spawn()
			var/obj/projectile/eM=M
			eM.x=src.x+eM.trailx
			eM.y=src.y+eM.traily
			eM.z=src.z
			M.pixel_x=src.pixel_x
			M.pixel_y=src.pixel_y
	..()


atom/movable/var/list/Grabbed=new/list()



proc/Clash(obj/projectile/O1,obj/projectile/O2)
	if(!O1||!O2)
		if(O1)O1.clashin=0
		if(O2)O2.clashin=0
		return

	O1.clashin=1
	O2.clashin=1
	var/bank[4]
	O1.get_specific_coords()
	O2.get_specific_coords()
	if(!O1||!O2)
		if(O1)O1.clashin=0
		if(O2)O2.clashin=0
		return
	O1.get_specific_coords()
	O2.get_specific_coords()

	var/dx=O2.p_x - O1.p_x
	var/dy=O2.p_y - O1.p_y
	var/d=sqrt(dx*dx + dy*dy)
	var/ax=dx/d
	var/ay=dy/d
	var/va1=O1.momx*ax + O1.momy*ay
	var/vb1=-(O1.momx*ay +O1.momy*ax)
	var/va2=O2.momx*ax + O2.momy*ay
	var/vb2=-(O2.momx*ay +O2.momy*ax)
	var/ed=0.9 //elasticity

	var/vaP1=va1 + (1+ed)*(va2-va1)/(1+O1.weight/O2.weight)
	var/vaP2=va2 + (1+ed)*(va1-va2)/(1+O2.weight/O1.weight)
	var/vx1=vaP1*ax-vb1*ay
	var/vy1=vaP1*ay+vb1*ax
	var/vx2=vaP2*ax-vb2*ay
	var/vy2=vaP2*ay+vb2*ax
	if(O2.weight/O1.weight > 0.1 && O1.bouncy)
		O1.momx=vx1
		O1.momy=vy1
	else if(O2.weight/O1.weight > 0.3)
		O1.momx+=vx1
		O1.momy+=vy1
	if(O1.weight/O2.weight > 0.1 && O2.bouncy)
		O2.momx=vx2
		O2.momy=vy2
	else if(O1.weight/O2.weight > 0.3)
		O2.momx+=vx2
		O2.momy+=vy2
	bank[1]=0
	bank[2]=0
	bank[3]=0
	bank[4]=0
	if(O1)O1.clashin=0
	if(O2)O2.clashin=0


proc/Return_Coordinates(s)

	var/l=findtext(s,",")
	var/x=text2num(copytext(s,1,l))

	var/y=text2num(copytext(s,l+1,lentext(s)+1))

	var/Li[2]
	Li[1]=x
	Li[2]=y

	return Li


proc/line2line_intersection(obj/projectile/A1,obj/projectile/A2)//A1 and A2 are both moving objects
	A1.get_specific_coords()
	A2.get_specific_coords()

	var/A[2]
	var/B[2]
	var/C[2]
	A[1]=A1.momy
	A[2]=A2.momy
	B[1]=-A1.momx
	B[2]=-A2.momx
	C[1]=A[1]*A1.p_x+B[1]*A1.p_y
	C[2]=A[2]*A2.p_x+B[2]*A2.p_y
	var/det= A[1]*B[2] - A[2]*B[1]
	if(det!=0) //parallel!
		var/intx=(B[2]*C[1]-B[1]*C[2])/det //xintercept
		var/inty=(A[1]*C[2]-A[2]*C[1])/det //yintercept
		if((intx>=min(A1.p_x,A1.p_x+A1.momx) && intx<=max(A1.p_x,A1.p_x+A1.momx))&&(inty>=min(A1.p_y,A1.p_y+A1.momy) && inty<=max(A1.p_y,A1.p_y+A1.momy)))
			//uhoh, that intersect is on this line SEGMENT too!!
			return 1 //smack!

	return 0
proc/angle(dx, dy)
    if(!dy)
        return dx?(dx>0?90:270):0
    return arctan(dx/dy)


proc/physics_stationary(obj/projectile/A1,atom/A2)//A1 is moving, A2 is not.
	if(A1 && A2)
		A1.get_specific_coords()
		A2.get_specific_coords()
		var/i=0
		var/dist=0
		while(i<=4)
			var/A1p_x=A1.p_x
			var/A1p_y=A1.p_y
			if(i!=0)
				A1p_x+=A1.momx /i
				A1p_y+=A1.momy /i
			dist = sqrt((A2.p_x - A1p_x)**2 +(A2.p_y - A1p_y)**2)
			if(dist<(A1.radius+A2.radius))
				return 1
			i++

proc/physics_intersection(atom/movable/A1,atom/movable/A2)
	if(!A1||!A2)return
	A1.get_specific_coords()
	A2.get_specific_coords()
	var/ua
	var/ub
	var/denom_1 = A2.momy*A1.momx
	var/denom_2 = A2.momx*A1.momy
	if(denom_1 != denom_2)
		var/denom = denom_1 - denom_2
		var/dy = A1.p_y-A2.p_y
		var/dx = A1.p_x-A2.p_x
		ua=((A2.momx*dy - A2.momy*dx)/denom)
		ub=((A1.momx*dy - A1.momy*dx)/denom)
	else
		ua = 0
		ub = 0

	if(ua>0 && ua<1 && ub>0 && ub<1) return 1

proc/physics_intersectionold(obj/projectile/A1,obj/projectile/A2)//A1 and A2 are both moving objects (alternative)
	if(!A1||!A2)return
	A1.get_specific_coords()
	A2.get_specific_coords()
	var/X1[2]
	var/Y1[2]
	var/X2[2]
	var/Y2[2]


	var/angle1=angle(A1.momx, A1.momy) //angle of movement
	var/angle2=angle(A2.momx, A2.momy) //angle of movement
	X1[1] = A1.radius * cos(angle1+90)
	Y1[1] = A1.radius* sin(angle1+90)
	X1[2] = A1.radius * cos(angle1-90)
	Y1[2] = A1.radius* sin(angle1-90)
	X2[1] = A2.radius * cos(angle2+90)
	Y2[1] = A2.radius* sin(angle2+90)
	X2[2] = A2.radius * cos(angle2-90)
	Y2[2] = A2.radius* sin(angle2-90)
	//we now have the x and y coordinates for the width bounds of these 2d objects
	//we will now see if the lines of these intersect, /O/|O|
	var/result=0
	var/i=1
	while(i<4)
		var/A1p_x
		var/A2p_x
		var/A1p_y
		var/A2p_y
		switch(i)
			if(1) //1v1
				A1p_x=X1[1]
				A1p_y=Y1[1]
				A2p_x=X2[1]
				A2p_y=X2[1]
			if(2) //1v2
				A1p_x=X1[1]
				A1p_y=Y1[1]
				A2p_x=X2[2]
				A2p_y=X2[2]
			if(3) //2v1
				A1p_x=X1[2]
				A1p_y=Y1[2]
				A2p_x=X2[1]
				A2p_y=X2[1]
			if(4) //2v2
				A1p_x=X1[2]
				A1p_y=Y1[2]
				A2p_x=X2[2]
				A2p_y=X2[2]
		i++
		var/div = (A2p_x - A1p_x)*(A2.momx - A1.momx) + (A2p_y - A1p_y)*(A2.momy - A1.momy)
		var/denom = sqrt((A2.momx - A1.momx)**2 + (A2.momy - A1.momy)**2) ** 2
		if(denom == 0)
			// They will stay the same distance forever
			continue
		else
			var/time_closest = div / denom
			if(time_closest < 0)
				// They will be heading apart forever
				continue
			else
				if(time_closest<=1)
					//collide
					result=1
	return result
proc/check_clash(atom/A1,atom/A2)
	A1.get_specific_coords()
	A2.get_specific_coords()
	var/list/onec=list(A1.p_x,A1.p_y)
	var/list/twoc=list(A2.p_x,A2.p_y)
	var/xint=0
	var/yint=0
	if(((onec[1]+A1.radius >twoc[1]-A2.radius)&& (onec[1]+A1.radius <twoc[1]+A2.radius))|| ((twoc[1]+A1.radius >onec[1]-A2.radius)&& (twoc[1]+A1.radius <onec[1]+A2.radius)))  //A1 rightside
		xint=1
	if(((onec[2]+A1.radius >twoc[2]-A2.radius)&& (onec[2]+A1.radius <twoc[2]+A2.radius))|| ((twoc[2]+A1.radius >onec[2]-A2.radius)&& (twoc[2]+A1.radius <onec[2]+A2.radius)))  //A1 rightside
		yint=1
	if(xint&&yint)//collision
		return 1
	else
		return 0
atom/proc/get_specific_coords()
	src.p_x=(src.x-1)*32 + 16+ src.pixel_x
	src.p_y=(src.y-1)*32 + 16+ src.pixel_y


atom/movable/proc/Expand(icon/e)  //turns a multi tile icon into one big image
	var/mx=0
	var/my=0
	var/list/statez=icon_states(e)
	for(var/I in statez)
		if(length(I))
			var/list/L=Return_Coordinates(I)
			if((L[1])>mx)mx=L[1]
			if((L[2])>my)my=L[2]
	var/i=0
	var/pxoff=0
	var/pyoff=0
	if((my+1)%2==0 && src.dir==WEST||src.dir==EAST||src.dir==SOUTHEAST||src.dir==SOUTHWEST||src.dir==NORTHEAST||src.dir==NORTHWEST)//iseven
		pyoff=-16

	while(i<=my) //0,0 -> mx,my
		var/i2=0
		while(i2<=mx)

			var/obj/projectile/t=new()
			t.icon=e
			t.icon_state="[i],[i2]"
			t.dir=src.dir
			t.trailx=round(i-round(mx/2))

			t.traily=round(i2-round(my/2))
			t.eb=1
			t.loc=locate(src.x+t.trailx,src.y+t.traily,src.z)
			src.Grabbed+=t

			i2++
		i++
	src.pixel_x=pxoff
	src.pixel_y=pyoff
	for(var/obj/OO in src.Grabbed)
		OO.pixel_x=src.pixel_x


proc/arctan(x)
	var/y=arcsin(x/sqrt(1+x*x))
	//if(usr) usr << "arctan([x]): y = [y]"
	if(x>=0) return y
	return -y

proc/arctan2(dy, dx)
	//if(usr) usr << "arctan2([dy], [dx]):"
	if(dy == 0)
		if(dx > 0)
			//if(usr) usr << "	return 0"
			return 0
		else if(dx == 0)
			//if(usr) usr << "	return 0"
			return 0
		else
			//if(usr) usr << "	return 180"
			return 180
	if(dx == 0)
		if(dy > 0)
			//if(usr) usr << "	return 90"
			return 90
		else if(dy == 0)
			//if(usr) usr << "	return 0"
			return 0
		else
			//if(usr) usr << "	return -90"
			return -90
	else
		var/angle = arctan(dy/dx)
		if(dx < 0)
			angle = 180 - angle
		if(dy < 0)
			angle = -angle
		//if(usr) usr << "	return [angle]"
		return angle

proc/get_real_angle(atom/A, atom/B)
	var/dx = B.x - A.x
	var/dy = B.y - A.y
	//if(usr) usr << "get_real_angle([A], [B]): dx=[dx], dy=[dy]"
	return arctan2(dy, dx)

proc
	dir2ref(d)
		switch(d)
			if(NORTH)//NORTH
				return 1
			if(NORTHEAST)//NORTHEAST
				return 2
			if(EAST)//EAST
				return 3
			if(SOUTHEAST)//SOUTHEAST
				return 4
			if(SOUTH)//SOUTH
				return 5
			if(SOUTHWEST)//SOUTHWEST
				return 6
			if(WEST)//WEST
				return 7
			if(NORTHWEST)//NORTHWEST
				return 8

	dir2angle(d)
		switch(d)
			if(NORTH)//NORTH
				return 90
			if(NORTHEAST)//NORTHEAST
				return 45
			if(EAST)//EAST
				return 0
			if(SOUTHEAST)//SOUTHEAST
				return -45
			if(SOUTH)//SOUTH
				return -90
			if(SOUTHWEST)//SOUTHWEST
				return -135
			if(WEST)//WEST
				return 180
			if(NORTHWEST)//NORTHWEST
				return 135

	angle2dir(angle)
		angle = normalize_angle(angle)
		switch(angle)
			if(-180 to -157.5, 157.5 to 180)
				return WEST
			if(-157.5 to -112.5)
				return SOUTHWEST
			if(-112.5 to -67.5)
				return SOUTH
			if(-67.5 to -22.5)
				return SOUTHEAST
			if(-22.5 to 22.5)
				return EAST
			if(22.5 to 67.5)
				return NORTHEAST
			if(67.5 to 112.5)
				return NORTH
			if(112.5 to 157.5)
				return NORTHWEST

	normalize_angle(angle)
		while(angle > 180)
			angle -= 360
		while(angle <= -180)
			angle += 360
		return angle

	dircount(sdir,fdir)
		var/x=sdir
		if(x==fdir)
			return 0
		var/c=0
		do
			x++
			if(x>8)
				x=1
			c++
		while(x!=fdir)

		return c

	// Bresenham's line algorithm
	// Adapted from wikipedia pseudocode
	// Returns a list of turfs in a line from A to B
	get_line(atom/A, atom/B)
		// Can't handle Z-level changes
		if(A.z != B.z)
			return list()

		var
			x0 = A.x
			x1 = B.x
			y0 = A.y
			y1 = B.y

		var/vertical = abs(y1-y0) > abs(x1-x0)
		// Mirror vertical lines, because it only works with "horizontal" lines
		if(vertical)
			x0 = A.y
			y0 = A.x
			x1 = B.y
			y1 = B.x

		// Mirror lines going the wrong direction
		if(x0 > x1)
			var/temp = x0
			x0 = x1
			x1 = temp

			temp = y0
			y0 = y1
			y1 = temp

		var
			dx = x1 - x0
			dy = abs(y1 - y0)
			error = 0
			derror = dy / dx
			ystep = y0<y1?1:-1
			y = y0

		var/line[0]
		for(var/x in x0 to x1)
			if(vertical)
				line += locate(y, x, A.z)
			else
				line += locate(x, y, A.z)
			error += derror
			if(error >= 0.5)
				y += ystep
				error -= 1

		return line
