skill
	var
		name
		icon = 'icons/gui.dmi'
		icon_state
		list/icon_overlays
		id
		default_chakra_cost = 0
		default_stamina_cost = 0
		default_supply_cost = 0
		default_cooldown = 0
		default_seal_time = 0
		base_charge = 0
		charging = 0
		charge = 0
		copyable = 1
		cooldown
		uses
		skillcards[0]
		skill/master
		face_nearest = 0
		modified

	proc
		IsUsable(mob/user)
			if(cooldown > 0)
				Error(user, "Cooldown Time ([cooldown] seconds)")
				return 0
			else if(user.curchakra < ChakraCost(user))
				Error(user, "Insufficient Chakra ([user.curchakra]/[ChakraCost(user)])")
				return 0
			else if(user.curstamina < StaminaCost(user))
				Error(user, "Insufficient Stamina ([user.curstamina]/[StaminaCost(user)])")
				return 0
			else if(user.supplies < SupplyCost(user))
				Error(user, "Insufficient Supplies ([user.supplies]/[SupplyCost(user)])")
				return 0
			else if(user.gate && ChakraCost(user) && !istype(src, /skill/taijutsu/gates))
				Error(user, "This skill cannot be used while a gate is active")
				return 0
			else if(user.Size==1 && !istype(src, /skill/akimichi/size_multiplication))
				Error(user, "This skill cannot be used while Size Multiplication is active")
				return 0
			else if(user.Size==2 && !istype(src, /skill/akimichi/super_size_multiplication))
				Error(user, "This skill cannot be used while a Super Size Multiplication is active")
				return 0
			return 1


		Cooldown(mob/user)
			if(user.skillspassive[6])
				return round(default_cooldown * (1 - user.skillspassive[SEAL_KNOWLEDGE] * 0.03))
			else
				return default_cooldown


		ChakraCost(mob/user)
			if(base_charge)
				return base_charge
			else if(user.skillspassive[5])
				return round(default_chakra_cost * (1 - user.skillspassive[CHAKRA_EFFICIENCY] * 0.04))
			else
				return default_chakra_cost


		StaminaCost(mob/user)
			return default_stamina_cost


		SupplyCost(mob/user)
			return default_supply_cost

		SealTime(mob/user)
			var/time = default_seal_time
			if(user.move_stun) time = time*2+5
			if(user.skillspassive[SEAL_KNOWLEDGE]) time = max(0, time - 0.25 * user.skillspassive[SEAL_KNOWLEDGE])
			return time


		Use(mob/user)


		Activate(mob/human/user)
			if(user.leading)
				user.leading=0
				return

			if(user.rasengan==1)
				user.Rasengan_Fail()
			else if(user.rasengan==2)
				user.ORasengan_Fail()

			if(user.isguard)
				user.icon_state=""
				user.isguard=0

			if(user.zetsu)
				user.invisibility=1
				user.density=1
				user.targetable=1
				user.protected=0
				user.zetsu=0

			if(user.camo)
				user.Affirm_Icon()
				user.Load_Overlays()
				user.camo=0

			if(charging)
				charging = 0
				return

			if(user.skillusecool || !user.CanUseSkills() || !IsUsable(user) || (user.mane && !istype(src,/skill/nara)))
				return



			user.skillusecool = 1

			user.curchakra -= ChakraCost(user)
			user.curstamina -= StaminaCost(user)
			user.supplies -= SupplyCost(user)

			if(base_charge)
				user.combat("[src]: Use this skill again to stop charging.")
				charge = base_charge
				charging = 1
				var/chakra_charge = 1
				while(charging && user && user.CanUseSkills())
					if(chakra_charge)
						var/charge_amt = min(base_charge, user.curchakra)
						user.curchakra -= charge_amt
						charge += charge_amt
						user.combat("[src]: Charged [charge] chakra.")
						if(user.curchakra <= 0)
							user.combat("[src]: Out of chakra. Use this skill again to finish charging.")
							chakra_charge = 0
					sleep(5)
				if(!user)
					return
				else if(!user.CanUseSkills())
					user.skillusecool = 0
					return

			if(face_nearest)
				if(user.NearestTarget()) user.FaceTowards(user.NearestTarget())
			else
				if(user.MainTarget()) user.FaceTowards(user.MainTarget())

			for(var/mob/human/player/XE in oview(8))
				var/can_copy = 0
				if(copyable && XE.HasSkill(SHARINGAN_COPY) && !XE.HasSkill(id))
					can_copy = 1
					XE.lastwitnessing=id
					spawn(50)
						if(XE) XE.lastwitnessing=0
				if(XE.sharingan)
					XE.combat("<font color=#faa21b>{Sharingan} [user] used [src].[can_copy?" Press <b>Space</b> within 5 Seconds to copy this skill.":""]</font>")

			user.lastskill = id

			++uses

			DoSeals(user)

			if(user && user.CanUseSkills())
				Use(user)

			if(!user) return

			/*if(user.lastskill == SHUNSHIN)
				spawn(3) if(user) user.skillusecool = 0
			else
				spawn(1) if(user) user.skillusecool = 0*/
			spawn(3) if(user) user.skillusecool = 0

			DoCooldown(user)


		DoSeals(mob/human/user)
			var/time = SealTime(user)
			if(time)
				user.icon_state="HandSeals"
				user.handseal_stun = 1
				for(, time > 0, --time)
					sleep(1)
					if(!user || !user.CanUseSkills())
						break
				if(user)
					user.icon_state=""
					user.handseal_stun = 0


		DoCooldown(mob/user, resume = 0)
			set waitfor = 0
			if(!resume) cooldown = Cooldown(user)

			for(var/skillcard/card in skillcards)
				card.overlays -= 'icons/dull.dmi'
			if(master)
				for(var/skillcard/card in master.skillcards)
					card.overlays -= 'icons/dull.dmi'

			if(!cooldown) return

			for(var/skillcard/card in skillcards)
				card.overlays += 'icons/dull.dmi'
			if(master)
				for(var/skillcard/card in master.skillcards)
					card.overlays += 'icons/dull.dmi'

			while(cooldown > 0)
				sleep(10)
				--cooldown

			for(var/skillcard/card in skillcards)
				card.overlays -= 'icons/dull.dmi'
			if(master)
				for(var/skillcard/card in master.skillcards)
					card.overlays -= 'icons/dull.dmi'


		Error(mob/user, message)
			user.combat("[src] can not be used currently: [message]")


		ChangeIconState(new_state)
			icon_state = new_state
			for(var/skillcard/card in skillcards)
				card.icon_state = new_state
			if(master)
				master.IconStateChanged(src, new_state)


		IconStateChanged(skill/sk, new_state)

		AddOverlay(overlay)
			for(var/skillcard/card in skillcards)
				card.overlays += overlay
			//if(master)
			//	master.OverlayAdded(src, overlay)


		RemoveOverlay(overlay)
			for(var/skillcard/card in skillcards)
				card.overlays -= overlay
			//if(master)
			//	master.OverlayRemoved(src, overlay)

skillcard
	parent_type = /obj
	layer = 11



	var
		skill/skill



	New(loc, skill/sk)
		..(loc)
		skill = sk
		name = sk.name
		icon = sk.icon
		icon_state = sk.icon_state
		overlays = sk.icon_overlays
		mouse_drag_pointer = icon('icons/guidrag.dmi', sk.icon_state)
		if(sk.cooldown || (istype(sk, /skill/uchiha/sharingan_copy) && sk:copied_skill && sk:copied_skill:cooldown)) overlays += 'icons/dull.dmi'
		sk.skillcards += src


	Click()
		skill.Activate(usr)


	MouseDrop(obj/over_object, src_location, over_location, src_control, over_control, params_text)
		if(src == over_object)
			return

		var/params = params2list(params_text)

		var/screen_loc = params["screen-loc"]
		var/screen_loc_lst = dd_text2list(screen_loc, ",")
		var/screen_loc_non_pixel_lst = list()

		for(var/loc in screen_loc_lst)
			var/loc_lst = dd_text2list(loc, ":")
			screen_loc_non_pixel_lst += loc_lst[1]

		screen_loc = dd_list2text(screen_loc_non_pixel_lst, ",")

		if(istype(over_object, /obj/gui/placeholder) || istype(over_object, /skillcard))
			var/spot
			switch(screen_loc)
				if("2,1")
					spot=1
				if("3,1")
					spot=2
				if("4,1")
					spot=3
				if("5,1")
					spot=4
				if("6,1")
					spot=5
				if("7,1")
					spot=6
				if("8,1")
					spot=7
				if("9,1")
					spot=8
				if("10,1")
					spot=9
				if("11,1")
					spot=10

			if(spot)
				if(usr.vars["macro[spot]"])
					var/skill/s = usr.vars["macro[spot]"]
					for(var/skillcard/c in s.skillcards)
						if(c.screen_loc == screen_loc)
							usr.client.screen -= c
							usr.player_gui -= c
				usr.player_gui += src
				src.screen_loc = screen_loc
				usr.client.screen += src
				usr.vars["macro[spot]"] = skill




mob

	proc

		AddSkill(id, skillcard=1, add_unknown=1)
			var/skill_type = SkillType(id)
			var/skill/skill
			if(!skill_type)
				if(add_unknown)
					skill = new /skill()
					skill.id = id
					skill.name = "Unknown Skill ([id])"
			else
				skill = new skill_type()
			if(skill)
				skills += skill
			if(skillcard)
				new /skillcard(src, skill)
			return skill

		AddItem(code)
			var/item_type = ItemType(code)
			var/obj/items/equipable/item
			if(!item_type)
				return
			else
				item = new item_type()
			item.Move(src)

		HasSkill(id)
			for(var/skill/skill in skills)
				if(skill.id == id)
					return 1
			return 0


		GetSkill(id)
			for(var/skill/skill in skills)
				if(skill.id == id)
					return skill


		ControlDamageMultiplier()
			//var/conmult=(con + conbuff - conneg)/150
			//if(skillspassive[24]) conmult *= 1 + 0.04 * skillspassive[24]
			//return conmult
			. = (con + conbuff - conneg)
			if(skillspassive[PURE_POWER])
				. += 10 * skillspassive[PURE_POWER]
			. = round((. / 150)) * 1.5


		CanUseSkills(inskill = 0)
			return !cantreact && !spectate && !larch && !frozen && !sleeping && !ko && canattack && !stunned && !kstun && !Tank && pk


		RefreshSkillList()
			if(client)
				var/grid_item = 0
				for(var/skillcard/X in contents)
					if(client) src << output(X, "skills_grid:[++grid_item]")
				if(client) winset(src, "skills_grid", "cells=[grid_item]")


		AppearBefore(mob/human/x,effect=/obj/overfx2, nofollow=0)
			if(!x) return

			var/turf/t = get_step(x, x.dir)
			var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
			while((!t || t.density) && dirs.len)
				var/dir = pick(dirs)
				dirs -= dir
				t = get_step(x, dir)
			if(t && !t.density)
				new effect(t)
				src.FaceTowards(x)
				//src.Move(t)
				src.loc=t
				src.Move() //t.Entered(src)

				if(!nofollow)
					for(var/mob/human/player/npc/N in ohearers(10))
						N.FilterTargets()
						if(src in N.targets)
							spawn()N.AppearBehind(src, nofollow=1)
			return 1


		AppearBehind(mob/human/x, effect=/obj/overfx, nofollow=0)
			if(!x) return

			var/turf/t = get_step(x, turn(x.dir, 180))
			var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
			while((!t || t.density) && dirs.len)
				var/dir = pick(dirs)
				dirs -= dir
				t = get_step(x, dir)
			if(t && !t.density)
				new effect(t)
				src.FaceTowards(x)
				//src.Move(t)
				src.loc=t
				src.Move() //t.Entered(src)

				if(!nofollow)
					for(var/mob/human/player/npc/N in ohearers(10))
						N.FilterTargets()
						if(src in N.targets)
							spawn()N.AppearBehind(src, nofollow=1)


		AppearMyDir(mob/human/x, effect=/obj/overfx, nofollow=0)
			if(!x) return 0

			var/turf/t = get_step(x, dir)
			var/list/dirs = list(turn(dir, 45), turn(dir, -45))
			while((!t || t.density) && dirs.len)
				var/dir = pick(dirs)
				dirs -= dir
				t = get_step(x, dir)
			if(t && !t.density)
				new effect(t)
				src.FaceTowards(x)
				//src.Move(t)
				src.loc=t
				src.Move() //t.Entered(src)

				if(!nofollow)
					for(var/mob/human/player/npc/N in ohearers(10))
						N.FilterTargets()
						if(src in N.targets)
							spawn()N.AppearBehind(src, nofollow=1)
				return 1
			return 0


		AppearAt(ax,ay,az, effect=/obj/overfx, nofollow=0)
			src.loc=locate(ax,ay,az)
			src.Move() //t.Entered(src)
			//if(!src.Move(locate(ax,ay,az)))
			//	return 0
			if(effect) new effect(locate(ax,ay,az))
			if(!nofollow)
				for(var/mob/human/player/npc/N in ohearers(10))
					N.FilterTargets()
					if(src in N.targets)
						spawn()N.AppearBehind(src, nofollow=1)
			return 1




proc
	SkillType(id)
		for(var/skill/skill in all_skills)
			if(skill.id == id)
				return skill.type

	ItemType(code)
		for(var/obj/item in all_items)
			if(item.code == code)
				return item.type

	ExampleSkill(id)
		for(var/skill/skill in all_skills)
			if(skill.id == id)
				return skill




var
	all_skills[0]
	all_items[0]




world/New()
	. = ..()
	for(var/type in typesof(/skill))
		all_skills += new type()

	for(var/type in typesof(/obj/items))
		all_items += new type()