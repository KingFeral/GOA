var/no_bunshin_skills = list(KAWARIMI, BUNSHIN, KAGE_BUNSHIN, TAJUU_KAGE_BUNSHIN, HENGE, EXPLODING_KAGE_BUNSHIN,
                             GATE1, GATE2, GATE3, GATE4, GATE5, MEDIC, POISON_MIST, POISON_NEEDLES, MASOCHISM,
                             IMMORTALITY, BLOOD_BIND, PUPPET_SUMMON1, PUPPET_SUMMON2, MEAT_TANK, SPINACH_PILL, CURRY_PILL, DOTON_IRON_SKIN, KAWARIMI,
                             SAND_SUMMON, SAND_UNSUMMON, SAND_SHIELD, DESERT_FUNERAL, SAND_ARMOR, SAND_SHURIKEN, SHUNSHIN,
                             PUPPET_HENGE, PUPPET_SWAP, EXPLODING_KUNAI, EXPLODING_NOTE, DOTON_CHAMBER_CRUSH, CHIDORI_NEEDLES,
                             CHIDORI_CURRENT, FUUTON_GREAT_BREAKTHROUGH, FUUTON_PRESSURE_DAMAGE, FUUTON_AIR_BULLET, MANIPULATE_ADVANCING_BLADES,
                             KAITEN, SHADOW_IMITATION, SHADOW_NECK_BIND, ICE_SPIKE_EXPLOSION, SAWARIBI, BONE_HARDEN, WOUND_REGENERATION,
                             EXPLODING_SPIDER, EXPLODING_BIRD, C3, PHOENIX_REBIRTH, DOTON_CHAMBER, KATON_PHOENIX_FIRE, KATON_FIREBALL, KATON_ASH_BURNING,
                             TWIN_RISING_DRAGONS)


mob
	var/tmp/body_replacement[]

skill
	body_replacement
		id = KAWARIMI
		name = "Body Replacement"
		icon_state = "kawarimi"
		default_chakra_cost = 100
		default_cooldown = 30


		Use(mob/user)
			set waitfor = 0
			user.combat("If you press <b>z</b> or <b>click</b> the log icon on the left side of your screen within the next <strong>2 minutes</strong>, you will be teleported back to this location.")

			for(var/obj/trigger/kawarimi/replacement in user.triggers)
				user.RemoveTrigger(replacement)

			var/obj/trigger/kawarimi/replacement = new(user, user.x, user.y, user.z)
			user.AddTrigger(replacement)
			user.replacement_loc = user.loc

			sleep(1200) // Two minutes
			if(user)
				if(replacement in user.triggers)
					user.combat("Your Kawarimi trigger is no longer active.")
					user.RemoveTrigger(replacement)
					user.replacement_loc = 0
	/*		set waitfor = 0
			user.combat("If you press <b>z</b> or <b>click</b> the log icon on the left side of your screen within the next <strong>30 seconds</strong>, you will become invisible and replace yourself with a log disguise! After 5 seconds or 10 steps, whichever comes first, you will reappear and trick those targeting you.")

			for(var/obj/trigger/kawarimi/T in user.triggers)
				user.RemoveTrigger(T)

			var/obj/trigger/kawarimi/T = new/obj/trigger/kawarimi(user)
			user.AddTrigger(T)

			sleep(300)
			if(user && T && (T in user.triggers))
				user.RemoveTrigger(T)*/




	body_flicker
		id = SHUNSHIN
		name = "Body Flicker"
		icon_state = "shunshin"
		default_chakra_cost = 80
		default_cooldown = 25

		ChakraCost(mob/user)
			if(user.gate)
				return 0
			return ..(user)

		StaminaCost(mob/user)
			if(user.gate)
				return 80
			return 0

		SealTime(mob/user)
			if(user.skillspassive[SPEED_DEMON])
				return 0
			else
				return ..(user)

		Use(mob/human/user)
			set waitfor = 0
			var/mob/human/player/etarget = user.MainTarget()

			if(!user.icon_state)
				flick(user, "Seal")

			if(!user)
				return

			if(!etarget)
				user.combat("<b>Double-click</b> on an empty section of ground within 5 seconds to teleport there.")
				user.shun = 1
				sleep(50)
				user.shun = 0

			else
				if(etarget && etarget.z == user.z)
					if(user.skillspassive[SPEED_DEMON] >= 2)
						user.AppearBehind(etarget)
						user.Timed_Stun(1)
						if(user.skillspassive[SPEED_DEMON] <= 2)
							user.timed_reaction_stun(5)
					else
						user.AppearBefore(etarget)
						user.Timed_Stun(20)

			//user.stunned += 2.6 - (0.5 * user.skillspassive[4])
			//var/stuntime = 2.6 - (0.5 * user.skillspassive[SPEED_DEMON])
			//user.Timed_Stun(stuntime * 10)


		Cooldown(mob/user)
			if(user.skillspassive[SPEED_DEMON] >= 4)
				if(user.skillspassive[SPEED_DEMON] == 5)
					return 10
				else
					return 20
			return default_cooldown
		/*	if(user.skillspassive[4] == 5)
				return 0
			else
				return ..()
*/



	clone
		id = BUNSHIN
		name = "Clone"
		icon_state = "bunshin"
		default_chakra_cost = 10
		default_cooldown = 30



		Use(mob/user)
			if(!user.icon_state)
				flick(user,"Seal")

			var/mob/human/player/npc/bunshin/o = new/mob/human/player/npc/bunshin(locate(user.x,user.y,user.z))
			o.icon = user.icon
			o.overlays = user.overlays
			o.name = "[user.name]"
			o.bunshinowner = user.key
			o.faction = user.faction
			o.dir = user.dir
			o.mouse_over_pointer = user.mouse_over_pointer
			o.life = 30

			Poof(o.loc)//(o.x,o.y,o.z)

			o.CreateName(255, 255, 255)

			user.BunshinTrick(list(o))




	shadow_clone
		id = KAGE_BUNSHIN
		name = "Shadow Clone"
		icon_state = "kagebunshin"
		default_chakra_cost = 150
		default_cooldown = 60



		Use(mob/user)
			for(var/mob/human/player/npc/kage_bunshin/O in world)
				if(O.ownerkey==user.key)
					del(O)
			flick("Seal",user)

			viewers(user) << output("[user]: Shadow Clone!", "combat_output")
			var/mob/human/player/npc/kage_bunshin/X = new/mob/human/player/npc/kage_bunshin(locate(user.x,user.y,user.z))
			user.client.eye=X
			X.ownerkey=user.key
			user.controlmob=X

			X.icon=user.icon
			X.overlays=user.overlays
			X.underlays=user.underlays
			X.faction=user.faction
			X.mouse_over_pointer=user.mouse_over_pointer
			X.con=user.con
			X.str=user.str
			X.rfx=user.rfx
			X.int=user.int

			X.name="[user.name]"
			X.CreateName(255, 255, 255)

			X.regeneration2()

			if(user) user.BunshinTrick(list(X))




	multiple_shadow_clone
		id = TAJUU_KAGE_BUNSHIN
		name = "Multiple Shadow Clone"
		icon_state = "taijuu_kage_bunshin"
		default_chakra_cost = 200
		default_cooldown = 60
		var/used_chakra



		ChakraCost(mob/user)
			used_chakra = user.curchakra * 3 / 4
			if(used_chakra > default_chakra_cost)
				return used_chakra
			else
				return default_chakra_cost


		Use(mob/user)
			set waitfor = 0
			for(var/mob/human/player/npc/kage_bunshin/O in world)
				if(O.ownerkey==user.key)
					O.loc = null
			flick("Seal",user)

			viewers(user) << output("[user]: Multiple Shadow Clone!", "combat_output")
			user.combat("<b>Click</b> to move your bunshins. Press <b>F</b> to have them attack your target(s).")
			user.tajuu=1
			//user.RecalculateStats()
			var/list/options=new
			for(var/turf/x in oview(4,user))
				if(!x.density)
					options+=x
			var/list/B = new
			var/am=0


			while(used_chakra>default_chakra_cost && am<=20 && options.len)
				used_chakra-=default_chakra_cost
				var/turf/next=pick(options)
				Poof(next)//(next.x,next.y,next.z)
				B+=new/mob/human/player/npc/kage_bunshin(locate(next.x,next.y,next.z))
				am++

			var/ico
			var/list/over

			ico = user.icon
			over = user.overlays.Copy()


			for(var/mob/human/player/npc/kage_bunshin/O in B)
				O.Squad=B
				for(var/skill/s in user.skills)
					if(!(s.id in no_bunshin_skills))
						O.AddSkill(s.id, skillcard=0, add_unknown=0)

				O.icon=ico
				O.faction=user.faction
				O.mouse_over_pointer=user.mouse_over_pointer
				O.temp=1200
				O.overlays+=over
				O.name=user.name
				O.con=user.con
				O.str=user.str
				O.rfx=user.rfx
				O.int=user.int
				O.blevel=user.blevel
				O.stamina=O.blevel*55 + O.str*20
				O.chakra=190 + O.blevel*10 + O.con*2.5
				O.curstamina=O.stamina
				O.curchakra=O.chakra
				O.staminaregen=round(O.stamina/100)
				O.chakraregen=round((O.chakra*3)/100)
				O.AIinitialize()

				O.owner=user
				O.ownerkey=user.key

				O.killable=1

				user.pet=1

			user.BunshinTrick(B)

			sleep(600)
			if(B && B.len)
				for(var/mob/human/player/npc/kage_bunshin/U in B)
					if(U)
						var/turf/u_loc = U.loc
						if(u_loc) Poof(u_loc.loc)//(u_loc.x,u_loc.y,u_loc.z)
						U.loc = null
				if(user)
					user.tajuu = 0
					//user.RecalculateStats()




	exploding_shadow_clone
		id = EXPLODING_KAGE_BUNSHIN
		name = "Exploding Shadow Clone"
		icon_state = "exploading bunshin"
		default_chakra_cost = 250
		default_cooldown = 45


		Use(mob/user)
			viewers(user) << output("[user]: Shadow Clone!", "combat_output")
			for(var/mob/human/player/npc/kage_bunshin/O in world)
				if(O.ownerkey==user.key)
					del(O)
			flick("Seal",user)
			var/mob/human/player/npc/kage_bunshin/X = new/mob/human/player/npc/kage_bunshin(user.loc)
			if(user.client) user.client.eye=X

			X.ownerkey=user.key
			user.controlmob=X
			X.icon=user.icon
			X.overlays=user.overlays
			X.underlays=user.underlays
			X.con=user.con
			X.str=user.str
			X.rfx=user.rfx
			X.int=user.int
			X.exploading=1
			X.name="[user.name]"
			X.CreateName(255, 255, 255)
			X.regeneration2()

			user.BunshinTrick(list(X))




	transform
		id = HENGE
		name = "Transform"
		icon_state = "henge"
		default_chakra_cost = 40
		default_cooldown = 60



		IsUsable(mob/user)
			. = ..()
			if(.)
				if(!user.MainTarget())
					Error(user, "No Target")
					return 0


		Use(mob/human/player/user)

			if(!user.icon_state)
				flick(user,"Seal")

			viewers(user) << output("[user]: Transform!", "combat_output")
			var/mob/human/player/etarget = user.MainTarget()

			if(etarget && !istype(etarget, /mob/human/clay) && !istype(etarget, /mob/human/sandmonster))
				Poof(user.loc)//(user.x, user.y, user.z)

				user.icon = etarget.icon
				user.name = etarget.name

				user.CreateName(255, 255, 255)

				user.overlays= etarget.overlays
				user.mouse_over_pointer = etarget.mouse_over_pointer
				user.henged = 1




	rasengan
		id = RASENGAN
		name = "Rasengan"
		icon_state = "rasengan"
		default_chakra_cost = 300
		default_cooldown = 40



		Use(mob/human/player/user)
			set waitfor = 0
			viewers(user) << output("[user]: Rasengan!", "combat_output")
			//user.stunned=10
			user.Timed_Stun(100)
			var/obj/x = new/obj/fxobj(locate(user.x,user.y,user.z), 30)
			x.layer=MOB_LAYER+1
			x.icon='icons/rasengan.dmi'
			x.dir=user.dir
			flick("create",x)
			user.overlays+=/obj/rasengan

			sleep(10)
			if(user)
				//user.stunned=0
				user.End_Stun()
				user.combat("Press <b>A</b> to use Rasengan on someone. If you take damage it will dissipate!")
				user.rasengan=1




	oodama_rasengan
		id = OODAMA_RASENGAN
		name = "Large Rasengan"
		icon_state = "oodama_rasengan"
		default_chakra_cost = 500
		default_cooldown = 140



		Use(mob/human/player/user)
			set waitfor = 0
			viewers(user) << output("[user]: Large Rasengan!", "combat_output")
			//user.stunned=10
			user.Timed_Stun(100)
			var/obj/x = new(locate(user.x,user.y,user.z), 30)
			x.layer=MOB_LAYER-1
			x.icon='icons/oodamarasengan.dmi'
			x.dir=user.dir
			flick("create",x)
			user.overlays+=/obj/oodamarasengan

			sleep(30)
			if(user)
				user.rasengan=2
				//user.stunned=0
				user.End_Stun()
				user.combat("Press <b>A</b> before the Oodama Rasengan dissapates to use it on someone. If you take damage it will dissipate!")
				sleep(100)
				if(user && user.rasengan==2)
					user.ORasengan_Fail()




	camouflaged_hiding
		id = CAMOFLAGE_CONCEALMENT
		name = "Camouflaged Hiding"
		icon_state = "Camouflage Concealment Technique"
		default_chakra_cost = 100
		default_cooldown = 60
		default_seal_time = 5



		Use(mob/human/player/user)
			user.camo=1
			user.icon='icons/base_invisible.dmi'
			user.overlays=0
			Poof(user.loc)//(user.x,user.y,user.z)




	chakra_leech
		id = CHAKRA_LEECH
		name = "Chakra Leech"
		icon_state = "chakra_leach"
		default_chakra_cost = 100
		default_cooldown = 60



		Use(mob/human/player/user)
			//user.stunned=2
			user.Timed_Stun(20)
			user.icon_state="Throw2"
			sleep(5)
			user.overlays+='icons/leech.dmi'
			var/mob/gotcha=0
			var/turf/getloc=0
			for(var/mob/human/eX in get_step(user,user.dir))
				if(!eX.ko && !eX.protected)
					eX.overlays+='icons/leech.dmi'
					//eX.move_stun=30
					eX.Timed_Move_Stun(30)
					gotcha=eX
					getloc=locate(eX.x,eX.y,eX.z)
			while(gotcha && gotcha.loc==getloc && (abs(user.x-gotcha.x)*abs(user.y-gotcha.y))<=1)
				//user.stunned=2
				user.Timed_Stun(20)
				sleep(5)
				if(!gotcha) break
				var/conmult = user.ControlDamageMultiplier()
				gotcha.curchakra-= round(50*conmult)
				user.curchakra+=round(50*conmult)
				gotcha.Hostile(user)
				if(gotcha.curchakra<0)
					gotcha.overlays-='icons/leech.dmi'
					gotcha.curstamina=0
					gotcha=0

				if(user.curchakra>user.chakra*1.5)
					user.curchakra=user.chakra*1.5
			user.overlays-='icons/leech.dmi'
			if(gotcha)
				gotcha.overlays-='icons/leech.dmi'
			user.icon_state=""




client
	DblClick(atom/thing, atom/loc, control, params)
		if(mob.shun && isloc(loc))
			if(!loc || !loc.Enter(usr) || !loc.icon || loc.type == /turf || !(loc in oview(mob)))
				return

			if(!mob.loc.icon || mob.loc.type==/turf || mob.loc.density)
				return

			var/area/ex = loc.loc
			if(ex.covericon)
				return

			mob.shun = 0

			//mob.stunned += 2.7 - (0.5 * mob.skillspassive[4])
			if(mob.skillspassive[SPEED_DEMON] < 3)
				mob.Timed_Stun(2.7 - 0.5 * mob.skillspassive[4])
			mob:AppearAt(loc.x, loc.y, loc.z)
		else
			..()




mob/human/player/npc
	bunshin
		auto_ai = 0
		initialized=1
		protected=0
		ko=0



		var
			bunshinowner=1
			bunshintype=0
			life=60



		New()
			set waitfor = 0
			..()
			while(loc && src.life > 0)
				sleep(10)
				src.life--

			if(src.invisibility<=2)
				Poof(loc)//(src.x,src.y,src.z)
			src.invisibility = 101
			src.targetable = 0
			src.density = 0
			//new/Event(30, "delayed_delete", list(src))
			dispose()

		Del()
			if(loc == null)
				return ..()
			loc = null



		Dec_Stam()
			return


		Wound()
			return


		Hostile(mob/human/player/attacker)
			. = ..()
			/*if(bunshintype == 0)
				Poof(loc)//(x, y, z)
				invisibility = 100
				loc = null
				targetable = 0
				density = 0
				// Didn't this just happen two lines above? Not even a sleep to give other stuff a chance to mess it up.
				targetable = 0
				loc = null*/
			dispose()

		dispose()
			/*if(owner)
				var/mob/user = owner
				if(istype(user.pet, /list))
					user.pet -= src
				if(user.controlmob == src || user.client.eye == src)
					user.controlmob = null
					user.client.eye = user.client.mob
			owner = null*/
			squad = null
			Squad = null
			skills = null
			clear_targets()
			clear_targeted_by()
			loc = null


	kage_bunshin
		auto_ai = 0
		initialized=1
		protected=0
		ko=0



		var
			ownerkey=""
			owner=""
			temp=0
			exploading=0
			attack_cd

		dispose()
			if(owner)
				var/mob/user = owner
				if(istype(user.pet, /list))
					user.pet -= src
				if(user.controlmob == src || user.client.eye == src)
					user.controlmob = null
					user.client.eye = user.client.mob
			owner = null
			squad = null
			Squad = null
			skills = null
			clear_targets()
			clear_targeted_by()
			loc = null

		proc/destroyed()
			set waitfor = 0
			var/dx=src.x
			var/dy=src.y
			var/dz=src.z
			if(!src:exploading)
				Poof(loc)//(dx,dy,dz)
			else
				src:exploading=0
				explosion(rand(1000,2500),dx,dy,dz,src)
				src.icon=0
				src.targetable=0
				src.invisibility=100
				src.density=0
				//sleep(5)
			src:dead=1
			src.Begin_Stun()
			//src.loc=locate(0,0,0)
			for(var/mob/human/player/p in players)
				if(p.key==src:ownerkey && p.controlmob == src)
					p.controlmob=0
					p.client.eye=p.client.mob
					break
			src.invisibility=100
			//src.target=-15
			//clear_targets()
			//clear_targeted_by()
			src.targetable=0
			src.density=0
			//src.targetable=0
			dispose()

		New()
			set waitfor = 0
			..()
			src.Stun_Drain()

			sleep(10)
			if(temp)
				new/Event(temp, "clone_dissipate", list(src))
				//src.Hostile()


		Dec_Stam()
			return


		Wound()
			return


		Hostile(mob/human/player/attacker)
			destroyed()
			return


obj
	oodamarasengan
		icon='icons/oodamarasengan.dmi'
		icon_state="rasengan"
		layer=MOB_LAYER+1
	oodamarasengan2
		icon='icons/oodamarasengan.dmi'
		icon_state="PunchA-1"
		layer=MOB_LAYER+1
obj
	rasengan
		icon='icons/rasengan.dmi'
		icon_state="rasengan"
		layer=MOB_LAYER+1
	rasengan2
		icon='icons/rasengan.dmi'
		icon_state="PunchA-1"
		layer=MOB_LAYER+1




mob/proc
	Shunshin_Teleport(atom/dest)
		icon_state="Run"
		canwalk=0
		var/shun_speed = (32+skillspassive[4]*10)
		var/dx = dest.x - x
		var/dy = dest.y - y
		var/distance = sqrt(dx*dx + dy*dy)
		var/shun_time = round(distance*32/shun_speed)
		//M_Projectile_Target(O,mob/user,power,iterations,speed,atom/target)
		M_Projectile_Target(src,src,0,shun_time,shun_speed,dest)
		canwalk=1
		icon_state=""

	ORasengan_Fail()
		set waitfor = 0
		src.rasengan=0
		src.overlays-=/obj/oodamarasengan
		src.overlays-=/obj/oodamarasengan2
		var/obj/o=new/obj(locate(src.x,src.y,src.z))
		o.layer=MOB_LAYER-1
		o.icon='icons/oodamarasengan.dmi'
		flick("failed",o)
		sleep(50)
		o.loc = null
	ORasengan_Hit(mob/x,mob/u,xdir)
		u.overlays-=/obj/oodamarasengan
		u.overlays-=/obj/oodamarasengan2
		u.rasengan=0
		var/conmult=(u.con+u.conbuff-u.conneg)/100
		x.timed_reaction_stun(10)
		var/obj/o=new/obj/oodamaexplosion(locate(x.x,x.y,x.z))
		o.layer=MOB_LAYER-1
		if(!x.icon_state)
			x.icon_state="hurt"

		x.Timed_Stun(20)
		u.Timed_Stun(20)
		x.Wound(rand(15,30),0,u)
		x.Earthquake(20)
		sleep(20)
		o.loc = null
		//x.stunned=0
		//u.stunned=0
		x.Knockback(10,xdir)
		explosion(50,x.x,x.y,x.z,u,1)
		if(x)
			x.Dec_Stam(2000+1500*conmult,0,u)

			//x.stunned+=3
			x.Timed_Stun(30)
			if(!x.ko)
				x.icon_state=""
			x.Hostile(u)
	Rasengan_Fail()
		src.rasengan=0
		src.overlays-=/obj/rasengan
		src.overlays-=/obj/rasengan2
		var/obj/o=new/obj(locate(src.x,src.y,src.z))
		o.layer=MOB_LAYER+1
		o.icon='icons/rasengan.dmi'
		flick("failed",o)
		sleep(50)
		o.loc=null
	Rasengan_Hit(mob/x,mob/u,xdir)
		u.overlays-=/obj/rasengan
		u.overlays-=/obj/rasengan2
		u.rasengan=0
		var/conmult=(u.con+u.conbuff-u.conneg)/100
		x.timed_reaction_stun()
		var/obj/o=new/obj/fxobj(locate(x.x,x.y,x.z),50)
		o.icon='icons/rasengan.dmi'
		o.layer=MOB_LAYER+1
		if(!x.icon_state)
			x.icon_state="hurt"

		flick("hit",o)

		x.Earthquake(10)

		sleep(10)
		if(x)
			x.Knockback(10,xdir)
			if(x)	// Knockback sleeps, I think. It really shouldn't though.
				explosion(50,x.x,x.y,x.z,u,1)
				x.Dec_Stam(1000+1000*conmult,0,u)
				//x.stunned+=3
				x.Timed_Stun(30)
				if(!x.ko)
					x.icon_state=""
				x.Hostile(u)


	BunshinTrick(list/bunshins)
		FilterTargets()
		for(var/mob/M in targeted_by)
			var/max_targets = M.MaxTargets()
			var/active = (src in M.active_targets)
			if(!active)
				max_targets -= M.MaxActiveTargets()

			var/result=Roll_Against((int+intbuff-intneg) + (10 * skillspassive[CLONE_MASTERY]),(M.int+M.intbuff-M.intneg) * (1 + 0.1 * M.skillspassive[TRACKING]),100)
			if(result > 3 && !M.sharingan)
				var/list/valid_targets = list(src)
				if(result >= 5) // full clone trick.
					valid_targets -= src
				valid_targets += bunshins
				var/picked_targets = 0
				while(valid_targets.len && picked_targets < max_targets)
					var/target = pick(valid_targets)
					valid_targets -= target
					M.AddTarget(target, active, silent=1)
					++picked_targets
			else
				var/list/valid_targets = bunshins.Copy()
				var/picked_targets = 0
				while(valid_targets.len && picked_targets < (max_targets - 1))
					var/target = pick(valid_targets)
					valid_targets -= target
					M.AddTarget(target, 0, silent=1)
					++picked_targets
				M.AddTarget(src, active, silent=1)

obj/fxobj
	New(location, life_time)
		set waitfor = 0
		if(!life_time)
			loc = null
			return
		..()
		sleep(life_time)
		loc = null