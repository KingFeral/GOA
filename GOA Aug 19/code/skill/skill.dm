skill
	parent_type = /drag_obj
	name
	icon = 'media/jutsu/gui.dmi'
	icon_state

	var/list/icon_overlays
	var/id
	var/default_chakra_cost = 0
	var/default_stamina_cost = 0
	var/default_supply_cost = 0
	var/default_cooldown = 0
	var/default_seal_time = 0
	var/base_charge = 0
	var/charging = 0
	var/charge = 0
	var/max_charge
	var/copyable = 1
	var/cooldown
	var/tmp/coolingdown
	var/uses
	var/face_nearest = 0
	var/upgrade // These are in the background.
	var/tmp/in_use

	proc/Error(combatant/user, message)
		user.combat_message("[src] cannot be used currently: [message]")

	proc/IsUsable(combatant/user)

		if(cooldown > 0)
			Error(user, "Cooldown Time ([cooldown] seconds)")
			return 0

		else if(user.chakra.value < ChakraCost(user))
			Error(user, "Insufficient Chakra ([user.chakra.value]/[ChakraCost(user)])")
			return 0

		else if(user.stamina.value < StaminaCost(user))
			Error(user, "Insufficient Stamina ([user.stamina.value]/[StaminaCost(user)])")
			return 0

	/*	else if(user.supplies < SupplyCost(user))
			Error(user, "Insufficient Supplies ([user.supplies]/[SupplyCost(user)])")
			return 0*/

		if(user.body_replacement)
			Error(user, "You cannot use skills while in Body Replacement!")
			return 0

		if(user.melee == global.melees[CHAKRA_SCALPEL])
			if(!istype(src, /skill/medical) &&  !istype(src, /skill/clan/uchiha/sharingan))
				Error(user, "You cannot use non-medical skills while Chakra Scalpels are active.")
				return 0

		if(user.meat_tank && !istype(src, /skill/clan/akimichi/meat_tank))
			return 0
/*
		else if(user.gate && ChakraCost(user) && !istype(src, /skill/taijutsu/gates))
			Error(user, "This skill cannot be used while a gate is active")
			return 0

		else if(user.Size==1 && !istype(src, /skill/akimichi/size_multiplication))
			Error(user, "This skill cannot be used while Size Multiplication is active")
			return 0

		else if(user.Size==2 && !istype(src, /skill/akimichi/super_size_multiplication))
			Error(user, "This skill cannot be used while a Super Size Multiplication is active")
			return 0*/
		return 1

	proc/Cooldown(combatant/user)
		if(user)
			if(user.passives[SEAL_KNOWLEDGE])
				return round(default_cooldown * (1 - user.passives[SEAL_KNOWLEDGE] * 0.03))
			else
				return default_cooldown

	proc/ChakraCost(combatant/user)
		if(user.passives[CHAKRA_EFFICIENCY])
			return round(default_chakra_cost * (1 - user.passives[CHAKRA_EFFICIENCY] * 0.04))
		else
			return default_chakra_cost

	proc/StaminaCost(combatant/user)
		return default_stamina_cost

	proc/SupplyCost(combatant/user)
		return default_supply_cost

	proc/SealTime(combatant/user)
		var/time = default_seal_time
		if(user.passives[SEAL_KNOWLEDGE])
			time = max(0, time - 0.25 * user.passives[SEAL_KNOWLEDGE])
		if(user.move_stun) time = time * 2 + 5
		return time

	proc/Use(combatant/user)

	proc/Activate(combatant/user)
		if(user.action == global.actions[ACTION_DEFEND])
			//user.begin_idle()
			user.force_action(ACTION_IDLE)

		if(!user.CanUseSkills())
			return

		if(charging)
			charging = 0
			return

		if(!IsUsable(user))
			return

		var/stamina_cost = StaminaCost(user)
		var/chakra_cost = ChakraCost(user)
		//var/supply_cost = SupplyCost(user)

		if(stamina_cost)
			user.stamina.decrease(stamina_cost)
		if(chakra_cost)
			user.chakra.decrease(chakra_cost)
		//if(supply_cost)
		//	user.supplies -= supply_cost
			//if(user.client) user.refresh_inventory()

		Add_Selected()

		if(base_charge)
			if(user.client)
				user.combat_message("[src]: Use this skill again to stop charging.")
			charge = base_charge
			charging = 1
			var/chakra_charge = 1
			while(charging && user)
				if(chakra_charge && (!max_charge || charge < max_charge))
					var/charge_amt = min(base_charge, user.chakra.value)
					user.chakra.decrease(charge_amt)
					charge += charge_amt
					if(user.client)
						user.combat_message("[src]: Charged [charge] chakra.")
					if(user.chakra.value <= 0)
						user.combat_message("[src]: Out of chakra. Use this skill again to finish charging.")
						chakra_charge = 0
				sleep(5)
			if(!user)
				Remove_Selected()
				return
			else if(!user.CanUseSkills())
				user.skillusecool = 0
				Remove_Selected()
				return


		user.regenerate()

		var/face_towards = user.nearest_target() ? user.nearest_target() : null
		if(face_nearest)
			if(face_towards)
				user.FaceTowards(face_towards)
		else if(face_towards)
			face_towards = user.main_target()
			if(face_towards)
				user.FaceTowards(face_towards)

		var/witnessing_time = world.time
		for(var/combatant/XE in oview(8))
			if(copyable && XE.sharingan >= 2/*&& XE.HasSkill(SHARINGAN_COPY)*/ && !XE.HasSkill(id))
				XE.combat_message("<font color=#faa21b>{Sharingan} [user] used [src]. Press <b>Space</b> within 5 Seconds to copy this skill.</font>")
				XE.lastwitnessing = id
				XE.lastwitnessing_time = witnessing_time
				//spawn(50)
				//	if(XE && XE.lastwitnessing_time == witnessing_time) XE.lastwitnessing=0
			else if(XE.sharingan)
				XE.combat_message("<font color=#faa21b>{Sharingan} [user] used [src].</font>")

		user.lastskill = id
		++uses

		if(!SealTime(user) || user.begin_handseals(list("skill" = src)))
			Use(user)

		if(!user) return

		spawn(1)
			if(user) user.skillusecool = 0

		Remove_Selected()
		DoCooldown(user)


	proc/DoCooldown(combatant/user, resume = 0, pretime = 0)
		set waitfor = 0

		if(!pretime)
			if(!resume)
				cooldown = Cooldown(user)
		else
			cooldown = pretime

		if(!cooldown||coolingdown) return

		coolingdown = 1

		overlays += 'media/jutsu/dull.dmi'

		while(cooldown >= 1)
			sleep(10)
			--cooldown
		coolingdown=0

		overlays -= 'media/jutsu/dull.dmi'

	proc/ChangeIconState(new_state)
		IconStateChanged(new_state)

	proc/IconStateChanged(new_state)
		icon_state = new_state

	proc/AddOverlay(overlay)
		overlays += overlay

	proc/RemoveOverlay(overlay)
		overlays -= overlay

	proc/Remove_Selected()
		overlays -= 'media/obj/extras/selected.dmi'

	proc/Add_Selected()
		overlays += 'media/obj/extras/selected.dmi'

	Click()
		var/combatant/user = usr
		src.Activate(user)

skill
	proc/macro_activate()
		if(args && args[1])
			Activate(args[1])

proc/Error(combatant/m, message)
	if(m.client)
		m.combat_message(message)

mob
	proc/CanUseSkills(inskill = 0)
		return action != global.actions[ACTION_KNOCKOUT] && !stunned

	proc/begin_handseals(list/params)
		. = act(global.actions[ACTION_HANDSEALS], params)

	proc/ControlDamageMultiplier()
		var/conmult = (control.get_value()) // 150
		if(src.passives[PURE_POWER])
			conmult += 10 * src.passives[PURE_POWER]
		return round(conmult / 150) + ((conmult * 0.6) / 50)//round(conmult / 150) + 2.5

	proc/AddSkill(id)
		if(src.HasSkill(id))
			return 0

		var/skill_type = SkillType(id)
		var/skill/skill
		if(!skill_type)
			return 0
		else
			skill = new skill_type()
		//skills += skill
		src.contents += skill
		refresh_skill_list()
		return skill



	proc/RemoveSkill(var/skill_id)
		var/skill/skill = src.GetSkill(skill_id)
		if(skill)

			del(skill)

			src.refresh_skill_list()

	proc/HasSkill(id)
		for(var/skill/skill in contents)
			if(skill.id == id)
				return 1
		return 0

	proc/GetSkill(id)
		for(var/skill/skill in contents)
			if(skill.id == id)
				return skill

	proc/refresh_skill_list()
		if(client)
			var/grid_item = 0
			for(var/skill/X in contents)
				if(client)
					if(!X.upgrade)
						src << output(X, "skillspane.grid:[++grid_item]")
			if(client) winset(src, "skillspane.grid", "cells=[grid_item]")

mob
	proc/AppearBefore(character/x,style="speed")
		if(!x)return

		var/turf/t = get_step(x, x.dir)
		var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
		while((!t || t.density) && dirs.len)
			var/dir = pick(dirs)
			dirs -= dir
			t = get_step(x, dir)
		if(t && !t.density)
			//new effect(t)
			appear_effect(t,style)
			t.Enter(src)
			src.loc=t
			src.FaceTowards(x)


	proc/AppearBehind(character/x,style="speed")
		if(!x)return

		var/turf/t = get_step(x, turn(x.dir, 180))
		var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
		while((!t || t.density) && dirs.len)
			var/dir = pick(dirs)
			dirs -= dir
			t = get_step(x, dir)
		if(t && !t.density)// && t.Enter(src))
			//new effect(t)
			appear_effect(t,style)
			t.Enter(src)
			src.loc=t
			src.FaceTowards(x)


	proc/AppearMyDir(character/x,style="speed")
		if(!x)return 0

		var/turf/t = get_step(x, dir)
		var/list/dirs = list(turn(dir, 45), turn(dir, -45))
		while((!t || t.density) && dirs.len)
			var/dir = pick(dirs)
			dirs -= dir
			t = get_step(x, dir)
		if(t && !t.density)// && t.Enter(src))
			//new effect(t)
			appear_effect(t,style)
			t.Enter(src)
			src.loc=t
			src.FaceTowards(x)


			return 1
		return 0


	proc/AppearAt(ax,ay,az)
		//new effect(locate(ax,ay,az))
		src.loc=locate(ax,ay,az)


action
	handseals
		id = ACTION_HANDSEALS

		can_begin(combatant/user, list/params)
			. = ..() && user.action != src

		begin(combatant/user, list/params)
			//set waitfor = 0
			..()
			var/start_timestamp = user.action_timestamp
			var/skill/skill = params && params["skill"] ? params["skill"] : null
			var/sealtime = skill ? skill.SealTime(user) : params && params["time"] ? params["time"] : 0
			if(sealtime)
				user.icon_state = "HandSeals"

				for(, sealtime > 0, --sealtime)
					sleep(1)
					if(!user || !user.CanUseSkills())
						break

				if(user && user.action_timestamp == start_timestamp && user.action == src && user.CanUseSkills())
					user.force_action(ACTION_IDLE)
					. = 1

		end(combatant/user, list/params)
			..()
			user.icon_state = ""

mob
	var/tmp/lastskill
	var/tmp/skillusecool
	var/tmp/drag_obj/macro1
	var/tmp/drag_obj/macro2
	var/tmp/drag_obj/macro3
	var/tmp/drag_obj/macro4
	var/tmp/drag_obj/macro5
	var/tmp/drag_obj/macro6
	var/tmp/drag_obj/macro7
	var/tmp/drag_obj/macro8
	var/tmp/drag_obj/macro9
	var/tmp/drag_obj/macro10

proc
	SkillType(id)
		for(var/skill/skill in all_skills)
			if(skill.id == id)
				return skill.type

var
	all_skills[0]


world/New()
	. = ..()

	for(var/type in typesof(/skill))
		all_skills += new type()