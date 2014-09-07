obj
	trigger
		icon = 'icons/gui_triggers.dmi'
		layer = 11



		var
			mob/user



		proc
			Use()



		Click()
			if(usr == user && !user.ko)
				Use()


		New(loc)
			. = ..()
			if(ismob(loc))
				user = loc




mob
	var/triggers[0]


	proc
		AddTrigger(trigger_type)
			if(trigger_type)
				if(ispath(trigger_type, /obj/trigger))
					triggers += new trigger_type(src)
				else if(istype(trigger_type, /obj/trigger))
					triggers += trigger_type
				RefreshTriggers()


		RemoveTrigger(obj/trigger/trigger)
			if(trigger)
				if(client) client.screen -= trigger
				triggers -= trigger
				trigger.loc = null
				RefreshTriggers()


		RefreshTriggers()
			if(client)
				for(var/i = 1; i <= triggers.len; ++i)
					var/obj/trigger/T = triggers[i]
					client.screen -= T
					var/rev_index = triggers.len - i
					T.screen_loc = "1:8,[round(rev_index/2) + 2]:[rev_index%2*16]"
					client.screen += T


obj
	trigger
		kawarimi
			icon_state = "kawarimi"



			var
				recall_x
				recall_y
				recall_z
				replacement_type



			New(loc)//, kx, ky, kz)
				. = ..(loc)
				/*recall_x = kx
				recall_y = ky
				recall_z = kz*/


			Use()
				if(!user.incombo)
					var/mob/human/body_replacement/b = new/mob/human/body_replacement(user.loc, user)
					user.body_replacement = list()
					user.body_replacement["steps"] = 10
					user.body_replacement["ref"] = b

					for(var/mob/targeting_me in user.targeted_by)
						if(targeting_me in oview(user))
							targeting_me.RemoveTarget(user)
							targeting_me.AddTarget(b, active = 1, silent = 1)

					b.targetable = null

					user.icon = null
					user.icon_state = ""
					user.overlays = null
					user.underlays = null
					user.Reset_Move_Stun()
					user.Reset_Stun()
					user.Protect(10)
					user.movepenalty = 0
					user.cantreact = TRUE

					var/timelimit = 50
					while(timelimit > 0 && (user.body_replacement || b.loc != null))
						timelimit--
						sleep(1)
					if(!user)
						return
					if(b.loc != null)
						b.activate()
						/*user.reIcon()
						user.Affirm_Icon()
						user.Load_Overlays()
						user.body_replacement = null*/

						//var/skill/body_replacement/r = user.GetSkill(KAWARIMI)
						//r.DoCooldown(user)
					user.RemoveTrigger(src)


		/*		if(!user.incombo)
					if(recall_z == user.z)
						Poof(user.x, user.y, user.z)

						new/obj/log(locate(user.x,user.y,user.z))
						user.loc = locate(recall_x,recall_y,recall_z)

						user.stunned=2

						user.RemoveTrigger(src)*/




		C3
			icon_state="C3"



			var/obj/C3



			New(loc, tagobj)
				. = ..(loc)
				C3 = tagobj


			Use()
				if(!C3)
					user.RemoveTrigger(src)
				else
					C3.overlays=0

					var/P=C3.power

					spawn()
						if(user && C3) explosion(P, C3.x, C3.y, C3.z, user, 0, 6)
					spawn(pick(1,2,3))
						if(user && C3) explosion(P, C3.x+1, C3.y+1, C3.z, user, 0, 6)
					spawn(pick(1,2,3))
						if(user && C3) explosion(P, C3.x-1, C3.y+1, C3.z, user, 0, 6)
					spawn(pick(1,2,3))
						if(user && C3) explosion(P, C3.x-1, C3.y-1, C3.z, user, 0, 6)
					spawn(pick(1,2,3))
						if(user && C3) explosion(P, C3.x-1, C3.y-1, C3.z, user, 0, 6)
					spawn(pick(3,4,5))
						if(user && C3) explosion(P, C3.x-2, C3.y+2, C3.z, user, 0, 6)
					spawn(pick(3,4,5))
						if(user && C3) explosion(P, C3.x+2, C3.y-2, C3.z, user, 0, 6)
					spawn(pick(3,4,5))
						if(user && C3) explosion(P, C3.x+2, C3.y+2, C3.z, user, 0, 6)
					spawn(pick(3,4,5))
						if(user && C3) explosion(P, C3.x-2, C3.y-2, C3.z, user, 0, 6)

					spawn(6) del(C3)

					user.RemoveTrigger(src)




		explosive_tag
			icon_state = "exploding tag"



			var
				obj/explosive_tag/ex_tag



			New(loc, tagobj)
				. = ..(loc)
				ex_tag = tagobj


			Use()
				if(!ex_tag)
					user.RemoveTrigger(src)
				else if(ex_tag in oview(8, user))
					var/xx = ex_tag.x
					var/xy = ex_tag.y
					var/xz = ex_tag.z
					del(ex_tag)

					explosion(2000, xx, xy, xz, user)
					user.RemoveTrigger(src)




		exploding_spider
			icon_state = "exploding spider"



			var
				mob/human/clay/spider/spider



			New(loc, spidermob)
				. = ..(loc)
				spider = spidermob


			Use()
				if(!spider)
					user.RemoveTrigger(src)
				else if(spider in oview(8, user))
					spider.Explode()
					user.RemoveTrigger(src)




obj/var/power=0


//replacement log
obj/explosive_log
	density = 1
	icon = 'icons/exploding_log.dmi'

	New(loc, mob/owner)
		set waitfor = 0
		..()
		sleep(3)
		explosion(2000, x, y, z, owner)

mob/human/body_replacement
	//targetable = null
	var/tmp/mob/owner = null
	var/tmp/replacement_type

	Timed_Stun()
		set waitfor = 0
		icon_state = "hurt"
		sleep(10)
		activate()

	proc/activate()
		if(!owner)
			owner = null
			loc = null
			return
		icon_state = "Seal"
		sleep(5)
		if(!owner)
			return

		for(var/mob/m in targeted_by)
			m.RemoveTarget(src)
			if(owner)
				var/introll = Roll_Against((m.int + m.intbuff - m.intneg) * (1 + 0.05 * m.skillspassive[TRACKING]), (owner.int + owner.intbuff - owner.intneg) + 10 * owner.skillspassive[CLONE_MASTERY], 100)
				if(introll < 3 && get_dist(m, owner) >= 8)
					introll = 3
				if(introll >= 5)
					m.AddTarget(owner, active = 1, silent = 1)
				else if(introll >= 3)
					m.AddTarget(owner, active = 0, silent = 1)

		Poof(x, y, z)
		if(replacement_type == "explosive")
			new/obj/explosive_log(loc, owner)
		else
			new/obj/log(loc)

		if(owner)
			owner.reIcon()
			owner.Affirm_Icon()
			owner.Load_Overlays()
			owner.body_replacement = null
			owner.cantreact = FALSE

			var/skill/body_replacement/r = owner.GetSkill(KAWARIMI)
			r.DoCooldown(owner)

		owner = null
		loc = null

	New(loc, mob/summoner)
		..()
		if(!summoner)
			loc = null
			return
		owner = summoner
		icon = summoner.icon
		icon_state = summoner.icon_state
		overlays += summoner.overlays
		underlays += summoner.underlays
		dir = summoner.dir
		//start_walking()
		spawn()
			//var/direction = summoner.dir
			while(loc != null)
				var/turf/t = get_step(src, dir)
				if(t && t.Enter(src))
					loc = t
				else
					icon_state = "Seal"
					sleep(3)
				sleep(pick(1, 2))

	Del()
		if(loc == null)
			return ..()
		if(owner)
			activate()
		owner = null
		loc = null