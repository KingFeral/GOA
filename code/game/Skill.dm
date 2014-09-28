var/global/bypass_stuns[] = list(
	BONE_HARDEN,
	SAND_ARMOR
	)

var/global/scalpels_only[] = list(
	MEDIC,
	POISON_MIST,
	MYSTICAL_PALM,
	IMPORTANT_BODY_PTS_DISTURB,
	PHOENIX_REBIRTH,
	POISON_NEEDLES,
	KAWARIMI,
	)

var/list/noncombat_skills = list(
	BYAKUGAN,
	SHARINGAN1,
	SHARINGAN2,
	STRONG_FIST,
	ARHAT_FIST,
	WRESTLING,
	CURRY_PILL,
	SPINACH_PILL,
	)

mob
	var/tmp/skillcooldown=0
	var/tmp/lastskilltime=0

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
		noskillbar
		tmp/set_cooldown = 0 // used when a skill is canceled for whatever reason and should not use its default cooldown.
		tmp/skill_delay = 1 // 1/10 seconds
		tmp/cooling_down = 0
		tmp/activated = 0

	proc
		IsUsable(mob/user)
			//if(user.skillusecool > world.time || user.skillcooldown)
			//	return 0
			if(user.sixty_four_palms > world.time)
				Error(user, "You cannot use any skills while Sixty Four Palms stance is activated.")
				return 0
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
			//else if(user.scalpol && !(id in scalpels_only))
			//	Error(user, "You can only use medical ninjutsu and Body Replacement while Chakra Scalpels are active.")
			//	return 0
			else if(user.gate && ChakraCost(user) && !istype(src, /skill/taijutsu/gates) && !(istype(src, /skill/body_replacement) || istype(src, /skill/body_flicker)))
				Error(user, "This skill cannot be used while a gate is active")
				return 0
			else if(user.Size==1 && !istype(src, /skill/akimichi/size_multiplication))
				Error(user, "This skill cannot be used while Size Multiplication is active")
				return 0
			else if(user.Size==2 && !istype(src, /skill/akimichi/super_size_multiplication))
				Error(user, "This skill cannot be used while a Super Size Multiplication is active")
				return 0
			if(!(istype(src, /skill/taijutsu/strong_fist) || istype(src, /skill/weapon)) && user.stance == STRONG_FIST)
				Error(user, "This skill cannot be used while Strong Fist is active")
				return 0
			if(user.client && user.keys["shift"])
				modified = 1
			return 1


		Cooldown(mob/user)
			if(user.skillspassive[SEAL_KNOWLEDGE])
				return round(default_cooldown * (1 - user.skillspassive[SEAL_KNOWLEDGE] * 0.03))
			else
				return default_cooldown


		ChakraCost(mob/user)
			if(base_charge)
				return base_charge
			else if(user.skillspassive[CHAKRA_EFFICIENCY])
				. = round(default_chakra_cost * (1 - user.skillspassive[CHAKRA_EFFICIENCY] * 0.04))
				//return round(default_chakra_cost * (1 - user.skillspassive[CHAKRA_EFFICIENCY] * 0.04))
			else
				. = default_chakra_cost
				//return default_chakra_cost
			if(user.clan == "Youth")
				. *= 1.4


		StaminaCost(mob/user)
			if(user.clan == "Youth")
				return default_stamina_cost * 0.4
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
			//set waitfor = 0
			if(user.leading)
				user.leading = 0
				return

			if(user.rasengan==1)
				user.Rasengan_Fail()
			else if(user.rasengan==2)
				user.ORasengan_Fail()

			if(!user)
				return

			if(user.isguard)
				user.icon_state = ""
				user.isguard = 0

			/**
			 * What is this?
			if(user.zetsu)
				user.invisibility=1
				user.density=1
				user.targetable=1
				user.protected=0
				user.zetsu=0
			*
			*/

			if(user.camo)
				var/skill/camouflaged_hiding/camou = user.GetSkill(CAMOUFLAGE_CONCEALMENT)
				if(camou)
					camou.deactivate(user, time = 50)
				//user.Affirm_Icon()
				//user.Load_Overlays()
				//user.camo = 0

			if(charging)
				charging = 0
				return

			if(user.skillusecool > world.time || user.skillcooldown || (user.handseal_stun && !istype(src, /skill/body_flicker)) || !user.CanUseSkills(id) || !IsUsable(user) || (user.mane && !istype(src,/skill/nara)))
				return

			user.skillcooldown = 1
			user.curchakra -= ChakraCost(user)
			user.curstamina -= StaminaCost(user)
			user.supplies -= SupplyCost(user)
			//user.combat_flag()

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
					user.skillusecool = world.time
					return

			if(face_nearest)
				if(user.NearestTarget()) user.FaceTowards(user.NearestTarget())
			else
				if(user.MainTarget()) user.FaceTowards(user.MainTarget())

			var/witnessing_time = world.time + 50
			for(var/mob/human/player/XE in oview(8))
				var/can_copy = 0
				if(copyable && XE.HasSkill(SHARINGAN_COPY) && !XE.HasSkill(id))
					can_copy = 1
					XE.lastwitnessing=id
					XE.lastwitnessing_time = witnessing_time

				if(XE.sharingan)
					XE.combat("<font color=#faa21b>{Sharingan} [user] used [src].[can_copy?" Press <b>Space</b> within 5 Seconds to copy this skill.":""]</font>")

			user.lastskill = id
			user.lastskilltime = world.time

			++uses

			DoSeals(user)

			if(user && user.CanUseSkills(id))
				if(user.controlmob && id != EXPLODING_KAGE_BUNSHIN)
					Use(user.controlmob)
				else
					Use(user)

			if(!user) return
			if(!user.controlmob && skill_delay)
				user.skillusecool = world.time + skill_delay
			user.skillcooldown = 0

			DoCooldown(user)


		DoSeals(mob/human/user)
			var/time = SealTime(user)
			if(time)
				if(user.controlmob)
					user = user.controlmob
				user.icon_state="HandSeals"
				user.handseal_stun = 1
				for(, time > 0, --time)
					sleep(1)
					if(!user || !user.CanUseSkills())
						break
				if(user)
					user.icon_state = ""
					user.handseal_stun = 0
					default_seal_time = initial(default_seal_time)

		DoCooldown(mob/user, resume = 0,presettime=0)
			set waitfor = 0
			if(presettime)
				cooldown = presettime
			else
				if(set_cooldown)
					cooldown = set_cooldown
				else if(!resume) cooldown = Cooldown(user)

			if(!cooldown || cooling_down)
				return

			for(var/skillcard/card in skillcards)
				card.overlays -= 'icons/dull.dmi'
				//card.overlays -= 'icons/activation.dmi'
			if(master)
				for(var/skillcard/card in master.skillcards)
					card.overlays -= 'icons/dull.dmi'
					//card.overlays -= 'icons/activation.dmi'

			cooling_down = 1

			for(var/skillcard/card in skillcards)
				card.overlays += 'icons/dull.dmi'
			if(master)
				for(var/skillcard/card in master.skillcards)
					card.overlays += 'icons/dull.dmi'

			while(cooldown > 0)
				sleep(10)
				--cooldown

			set_cooldown = 0
			modified = 0
			cooling_down = 0
			activated = 0

			for(var/skillcard/card in skillcards)
				card.overlays -= 'icons/dull.dmi'
			if(master)
				for(var/skillcard/card in master.skillcards)
					card.overlays -= 'icons/dull.dmi'


		Error(mob/user, message)
			if(user.client)
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
		noskillbar



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
		if(sk.noskillbar) noskillbar = 1


	Click()
		skill.Activate(usr)


	MouseDrop(obj/over_object, src_location, over_location, src_control, over_control, params_text)
		if(src == over_object)
			return

		if(noskillbar)
			var/skill/skill = src.skill
			if(skill.id >= 1300 && skill.id <= 1360)
				usr << "[src] does not need to go on your skill bar. The Opening Gate skill card will automatically update as needed."
			return

	/*	var
			spot
			obj/new_obj
			obj/slot_1 = locate(/obj/gui/placeholder/placeholder1) in usr.player_gui
			obj/slot_2 = locate(/obj/gui/placeholder/placeholder2) in usr.player_gui
			obj/slot_3 = locate(/obj/gui/placeholder/placeholder3) in usr.player_gui
			obj/slot_4 = locate(/obj/gui/placeholder/placeholder4) in usr.player_gui
			obj/slot_5 = locate(/obj/gui/placeholder/placeholder5) in usr.player_gui
			obj/slot_6 = locate(/obj/gui/placeholder/placeholder6) in usr.player_gui
			obj/slot_7 = locate(/obj/gui/placeholder/placeholder7) in usr.player_gui
			obj/slot_8 = locate(/obj/gui/placeholder/placeholder8) in usr.player_gui
			obj/slot_9 = locate(/obj/gui/placeholder/placeholder9) in usr.player_gui
			obj/slot_10 = locate(/obj/gui/placeholder/placeholder0) in usr.player_gui


		/*if(istype(over_object, /obj/gui/placeholder) || istype(over_object, /skillcard))
			if(over_object == slot_1)
				spot = 1
				new_obj = slot_1
			else if(over_object == slot_2)
				spot = 2
				new_obj = slot_2
			else if(over_object == slot_3)
				spot = 3
				new_obj = slot_3
			else if(over_object == slot_4)
				spot = 4
				new_obj = slot_4
			else if(over_object == slot_5)
				spot = 5
				new_obj = slot_5
			else if(over_object == slot_6)
				spot = 6
				new_obj = slot_6
			else if(over_object == slot_7)
				spot = 7
				new_obj = slot_7
			else if(over_object == slot_8)
				spot = 8
				new_obj = slot_8
			else if(over_object == slot_9)
				spot = 9
				new_obj = slot_9
			else if(over_object == slot_10)
				spot = 10
				new_obj = slot_10*/

		if( (istype(over_object,slot_1)) || (istype(over_object, /skillcard) && over_object in slot_1.contents))
			new_obj = slot_1
			spot=1

		if( istype(over_object, slot_2) || (istype(over_object, /skillcard) && over_object in slot_2.contents ))
			new_obj = slot_2
			spot=2

		if( istype(over_object, slot_3) || (istype(over_object, /skillcard) && over_object in slot_3.contents ))
			new_obj = slot_3
			spot=3

		if( istype(over_object,slot_4) || (istype(over_object, /skillcard) && over_object in slot_4.contents ))
			new_obj = slot_4
			spot=4

		if( istype(over_object, slot_5) || (istype(over_object, /skillcard) && over_object in slot_5.contents ))
			new_obj = slot_5
			spot=5

		if( istype(over_object, slot_6) || (istype(over_object, /skillcard) && over_object in slot_6.contents ))
			new_obj = slot_6
			spot=6

		if( istype(over_object, slot_7) || (istype(over_object, /skillcard) && over_object in slot_7.contents ))
			new_obj = slot_7
			spot=7

		if( istype(over_object, slot_8) || (istype(over_object, /skillcard) && over_object in slot_8.contents ))
			new_obj = slot_8
			spot=8

		if( istype(over_object, slot_9) || (istype(over_object, /skillcard) && over_object in slot_9.contents ))
			new_obj = slot_9
			spot=9

		if( istype(over_object, slot_10) || (istype(over_object, /skillcard) && over_object in slot_10.contents ))
			new_obj = slot_10
			spot=10

		if(spot)
			if(usr.vars["macro[spot]"])
				if(istype(usr.vars["macro[spot]"], /skill))
					var/skill/s = usr.vars["macro[spot]"]
					for(var/skillcard/c in s.skillcards)
						if(c.screen_loc == new_obj.screen_loc)
							usr.client.screen -= c
							usr.player_gui -= c
							//new_obj.contents -= src

			for(var/i in 1 to 10)
				var/skill/slot = usr.vars["macro[i]"]
				if(!slot)
					continue
				if(slot.id == skill.id)
					for(var/skillcard/sc in slot.skillcards)
						usr.client.screen -= sc
						usr.player_gui -= sc
					usr.vars["macro[i]"] = null

			//new_obj.contents += src
			usr.player_gui += src
			src.screen_loc = new_obj.screen_loc
			usr.client.screen += src
			usr.vars["macro[spot]"] = skill*/

		var/params = params2list(params_text)

		var/screen_loc = params["screen-loc"]
		var/screen_loc_lst = dd_text2list(screen_loc, ",")
		var/screen_loc_non_pixel_lst = list()

		for(var/loc in screen_loc_lst)
			var/loc_lst = dd_text2list(loc, ":")
			screen_loc_non_pixel_lst += loc_lst[1]

		screen_loc = dd_list2text(screen_loc_non_pixel_lst, ",")

		if(istype(over_object, /obj/gui/placeholder) || istype(over_object, /skillcard))
			var/obj/ob = over_object
			//world.log << "MY SCREEN LOC: [screen_loc]"
			var/spot = screen_loc2spot[ob.screen_loc]
			/*switch(screen_loc)
				if("6,1")
					spot=1
				if("7,1")
					spot=2
				if("8,1")
					spot=3
				if("9,1")
					spot=4
				if("10,1")
					spot=5
				if("11,1")
					spot=6
				if("12,1")
					spot=7
				if("13,1")
					spot=8
				if("14,1")
					spot=9
				if("15,1")
					spot=10*/

			if(spot)
				if(usr.vars["macro[spot]"])
					var/skill/s = usr.vars["macro[spot]"]
					for(var/skillcard/c in s.skillcards)
						if(c.screen_loc == ob.screen_loc)
							usr.client.screen -= c
							usr.player_gui -= c
				for(var/i in 1 to 10)
					var/skill/slot = usr.vars["macro[i]"]
					if(!slot)
						continue
					if(slot.id == skill.id)
						for(var/skillcard/sc in slot.skillcards)
							usr.client.screen -= sc
							usr.player_gui -= sc
						usr.vars["macro[i]"] = null
				usr.player_gui += src
				src.screen_loc = ob.screen_loc//screen_loc
				usr.client.screen += src
				usr.vars["macro[spot]"] = skill


var/list/screen_loc2spot = list(
	"5:16,1" = 1,
	"6:16,1" = 2,
	"7:16,1" = 3,
	"8:16,1" = 4,
	"9:16,1" = 5,
	"10:16,1" = 6,
	"11:16,1" = 7,
	"12:16,1" = 8,
	"13:16,1" = 9,
	"14:16,1" = 10,
)

mob

	proc

		AddSkill(id, skillcard=1, add_unknown=1)
			if(!id) return
			var/skill_type = SkillType(id)
			var/skill/skill
			if(!skill_type)
				return
			skill = new skill_type()
			if(skill)
				skills += skill
			if(skillcard)
				new /skillcard(src, skill)
				RefreshSkillList()
			return skill

		AddItem(code)
			var/item_type = ItemType(code)
			//var/obj/items/equipable/item
			if(!item_type)
				return
			else
				if(ispath(item_type, /obj/items/usable))
					// check for stacking
					var/has_item = 0
					for(var/obj/items/ex in usr.contents)
						if(istype(ex, item_type))
							has_item += 1 + ex.equipped
							if(ex.equipped)
								has_item-- // subtract the equipped item

					if(!has_item)
						new item_type(src)
					else for(var/obj/items/usable/object in usr.contents)
						if(istype(object, item_type))
							object.equipped++
							object.Refreshcountdd(usr)
				else
					new item_type(src)

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
			if(clan == "Capacity")
				. += round(curchakra * 0.04)
			if(skillspassive[PURE_POWER])
				. += 10 * skillspassive[PURE_POWER]
			. = round((. / 150)) * 1.5

		strength_damage_mult()
			. = ((str + strbuff - strneg) / 150)// * 1.5

		CanUseSkills(inskill = 0)
			if(inskill && (inskill in bypass_stuns))
				return !cantreact && !spectate && !larch && !frozen && !sleeping && !ko && canattack && !kstun && !Tank && pk
			return !cantreact && !spectate && !larch && !frozen && !sleeping && !ko && canattack && !stunned && !kstun && !Tank && pk


		RefreshSkillList()
			if(client)
				var/grid_item = 0
				for(var/skillcard/X in contents)
					if(client && !(X.skill.id in list(GATE2,GATE2,GATE3,GATE4,GATE5,GATE6/*,GATE7,GATE8*/,DOTON_CHAMBER_CRUSH))) src << output(X, "skills_grid:[++grid_item]")
				if(client) winset(src, "skills_grid", "cells=[grid_item]")


		AppearBefore(mob/human/x,effect=/obj/overfx2, nofollow=0)
			set waitfor = 0
			if(!x) return
			if(!src.loc)return

			var/turf/t = get_step(x, x.dir)
			var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
			while((!t || t.density) && dirs.len)
				var/dir = pick(dirs)
				dirs -= dir
				t = get_step(x, dir)
			if(t && !t.density && t.Enter(src))
				new effect(t)
				src.FaceTowards(x)
				//src.Move(t)
				src.loc.Exited(src)
				src.loc=t
				src.loc.Entered(src)

				if(!nofollow)
					for(var/mob/human/player/npc/N in ohearers(10))
						N.FilterTargets()
						if(src in N.targets)
							N.AppearBehind(src, nofollow=1)
			return 1


		AppearBehind(mob/human/x, effect=/obj/overfx, nofollow=0)
			set waitfor = 0
			if(!x) return
			if(!src.loc)return

			var/turf/t = get_step(x, turn(x.dir, 180))
			var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
			while((!t || t.density) && dirs.len)
				var/dir = pick(dirs)
				dirs -= dir
				t = get_step(x, dir)
			if(t && !t.density && t.Enter(src))
				new effect(t)
				src.FaceTowards(x)
				//src.Move(t)
				src.loc.Exited(src)
				src.loc=t
				if(!src.loc)return
				src.loc.Entered(src) //t.Entered(src)

				if(!nofollow)
					for(var/mob/human/player/npc/N in ohearers(10))
						N.FilterTargets()
						if(src in N.targets)
							N.AppearBehind(src, nofollow=1)


		AppearMyDir(mob/human/x, effect=/obj/overfx, nofollow=0)
			set waitfor = 0
			if(!x) return 0
			if(!src.loc)return

			var/turf/t = get_step(x, dir)
			var/list/dirs = list(turn(dir, 45), turn(dir, -45))
			while((!t || t.density) && dirs.len)
				var/dir = pick(dirs)
				dirs -= dir
				t = get_step(x, dir)
			if(t && !t.density && t.Enter(src))
				new effect(t)
				src.FaceTowards(x)
				//src.Move(t)
				src.loc.Exited(src)
				src.loc=t
				src.loc.Entered(src) //t.Entered(src)
				if(!src.loc)return
				//src.Move(t, src.dir)
				if(!nofollow)
					for(var/mob/human/player/npc/N in ohearers(10))
						N.FilterTargets()
						if(src in N.targets)
							N.AppearBehind(src, nofollow=1)
				return 1
			return 0


		AppearAt(ax,ay,az, effect=/obj/overfx, nofollow=0)
			set waitfor = 0
			if(!src.loc)return
			var/turf/target_location = locate(ax, ay, az)
			if(!target_location)
				return 0
			src.loc.Exited(src)
			src.loc = target_location
			src.loc.Entered(src)//t.Entered(src)
			if(!src.loc)return
			//src.Move(locate(ax,ay,az), src.dir)
			//if(!src.Move(locate(ax,ay,az)))
			//	return 0
			if(effect) new effect(locate(ax,ay,az))
			if(!nofollow)
				for(var/mob/human/player/npc/N in ohearers(10))
					N.FilterTargets()
					if(src in N.targets)
						N.AppearBehind(src, nofollow=1)
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