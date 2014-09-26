mob
	var
		tmp
			active_targets[0]
			targets[0]
			target_img
			active_target_img
			targeted_by[0]



	New()
		. = ..()
		target_img = image('icons/target2.dmi', src, layer=15)
		active_target_img = image('icons/target.dmi', src, layer=15)



	proc
		// Returns the maximum number of concurrent active targets a player may have.
		MaxActiveTargets()
			var/mult = 1
			if(skillspassive[TRACKING])
				mult += skillspassive[TRACKING]
			return 1 * mult


		// Returns the maximum number of concurrent total targets a player may have. (Should be >= MaxActiveTargets())
		MaxTargets()
			var/mult = 1
			if(skillspassive[TRACKING])
				mult += skillspassive[TRACKING]
			return 3 * mult


		// Add new target, setting it as an active target if approrpriate.
		AddTarget(mob/M, active=0, silent=0)
			if(istype(M, /mob/corpse) || !targetable)
				return
			FilterTargets()
			// Some things override new? In any case, this is a failsafe.
			if(!M.target_img) M.target_img = image('icons/target2.dmi', M, layer=15)
			if(!M.active_target_img) M.active_target_img = image('icons/target.dmi', M, layer=15)

			if(!(M in targets))
				targets += M
				M.targeted_by += src

			if(active && !(M in active_targets))
				active_targets += M
				if(client) client.images -= M.target_img
				src << M.active_target_img

				var/max_active = MaxActiveTargets()
				while(active_targets.len > max_active)
					var/mob/T = active_targets[1]
					active_targets -= T
					if(client) client.images -= T.active_target_img
					src << T.target_img

				var/list/new_targets = targets.Copy()
				for(var/mob/T in active_targets)
					new_targets -= T

				var/max_targets = MaxTargets() - active_targets.len
				if(max_targets >= 0)
					while(new_targets.len > max_targets)
						var/mob/T =  new_targets[1]
						new_targets -= T
						T.targeted_by -= src
						if(client) client.images -= T.target_img
				targets = new_targets + active_targets
			else if(!(M in active_targets))
				src << M.target_img
			TargetAdded(M, active, silent)


		// Called when a target has been sucessfully added
		TargetAdded(mob/M, active=0, silent=0)
			if(!silent)
				var/analyze_level = skillspassive[ANALYTICAL]
				if(!active)
					// If you're not actively targeting them, drop the effect of analyze passive one level.
					analyze_level = max(0, analyze_level - 1)

				var/targicon
				if(!istype(M, /mob/human/npc) && M.faction && M.faction.chat_icon)
					targicon = "<span class='villageicon'>\icon[faction_chat[M.faction.chat_icon]]</span> "
					if(M.henged||M.phenged)
						if(M.transform_chat_icon)
							targicon = "<span class='villageicon'>\icon[faction_chat[M.transform_chat_icon]]</span> "
						else targicon = null

				var/target_msg = "[targicon] Targeting [M.name]"
				var/analytical = skillspassive[ANALYTICAL]
				if(analytical >= 3 && (M.stunned || M.Poison || M.asleep))
					target_msg += " (Status: [M.stunned ? "<strong>Stunned</strong> | " : ""][M.Poison ? "<strong>Poisoned</strong> | " : ""][M.asleep ? "<strong>Asleep</strong>" : ""])"
				if(analytical)
					if(analytical >= 2)
						if(M.sandarmor && analytical >= 4)
							target_msg += "\n\t<strong>Stamina:</strong> (Sandarmor Shield: [M.sandarmor]) [M.curstamina]/[M.stamina] (<b>[round(M.curstamina / M.stamina*100)]</b>%)"
						else
							target_msg += "\n\t<strong>Stamina:</strong> [M.curstamina]/[M.stamina] (<b>[round(M.curstamina / M.stamina*100)]</b>%)"
						if(M.boneharden && analytical >= 4)
							target_msg += "\n\t<strong>Chakra:</strong> (Bone Harden: [M.curchakra * 2]) [M.curchakra]/[M.chakra] (<b>[round(M.curchakra / M.chakra*100)]</b>%)"
						else
							target_msg += "\n\t<strong>Chakra:</strong> [M.curchakra]/[M.chakra] (<b>[round(M.curchakra / M.chakra*100)]</b>%)"
						if(analytical >= 3)
							target_msg += "\n\t<strong>Wounds:</strong> [M.curwound] (<b>[round(M.curwound / M.maxwound*100)]</b>%)"
						else
							target_msg += "\n\t<strong>Wounds:</strong> [M.curwound]"
						if(analytical >= 5)
							target_msg += "\n\t<strong>Level:</strong> [M.blevel]"
							target_msg += "\n\t<strong>Strength:</strong> [M.str]"
							target_msg += "\n\t<strong>Control:</strong> [M.con]"
							target_msg += "\n\t<strong>Reflex:</strong> [M.rfx]"
							target_msg += "\n\t<strong>Intelligence:</strong> [M.int]"
					else
						target_msg += "\n\t<strong>Stamina:</strong> [M.curstamina]"
						target_msg += "\n\t<strong>Chakra:</strong> [M.chakra]"

				src << target_msg
				if((M.henged || M.phenged) && Roll_Against((int + intbuff - intneg), (M.int + M.intbuff - M.intneg), 100))
					src << "You notice something suspicious about [M]."
	/*			switch(analyze_level)
					if(1)
						src << "Analyzed [M]: <b>[round(M.curstamina/M.stamina*100)]</b>% Stamina -- <b>[round(M.curchakra/M.chakra*100)]</b>% Chakra -- <b>[round(M.curwound/M.maxwound*100)]</b>% Wound\s"
					if(2)
						src << "Analyzed [M]: <b>[M.curstamina]</b> Stamina -- <b>[M.curchakra]</b> Chakra -- <b>[M.curwound]</b> Wound\s"
					if(3)
						var/T = "Analyzed [M]: [M.stunned?"<b>Stunned</b> -- ":""]<b>[M.curstamina]</b>/[M.stamina] Stamina -- <b>[M.curchakra]</b>/[M.chakra] Chakra -- <b>[M.curwound]</b> Wound\s"
						if(M.henged||M.phenged)
							if(M.int+M.intbuff-M.intneg<int+intbuff-intneg)
								T+="\nSomething seems suspicious about [M]!"
						var/difference=round(blevel/M.blevel *100)
						if(difference<25)
							T+="\nYou are way more inexperienced than [M]!"
						else if(difference<50)
							T+="\nYou are far less experienced than [M]."
						else if(difference<75)
							T+="\nYou are somewhat less experienced than [M]."
						else if(difference<120)
							T+="\nYou are similar in experience to [M]."
						else if(difference<140)
							T+="\nYou slightly more experienced than [M]."
						else if(difference<160)
							T+="\nYou are significantly more experienced than [M]."
						else if(difference<180)
							T+="\nYou are far more experienced than [M]."
						else if(difference<200)
							T+="\nYou are way more experienced than [M]."
						else
							T+="\nYou are out of [M]'s league!"
						src << T
					else
						src << "Targeting [M]"*/


		// Remove a target.
		RemoveTarget(mob/M, in_filter=0)
			if(!in_filter) FilterTargets()
			if(!M) return
			targets -= M
			active_targets -= M
			M.targeted_by -= src
			if(client)
				client.images -= M.active_target_img
				client.images -= M.target_img


		// Returns the 'main' active target (the target most recently set as active)
		MainTarget()
			FilterTargets()
			if(active_targets.len)
				var/mob/target = active_targets[active_targets.len]
				if((target in oview(src)) && !target.ko)
					return target
				else
					var/distance = get_dist(src, target)
					for(var/mob/T in active_targets)
						var/tmp_distance = get_dist(src, T)
						if(!T.ko && tmp_distance < distance)
							distance = tmp_distance
							target = T
					if((target in oview(src)) && !target.ko)
						return target
			return null


		// Returns the closest (up to) n targets, within distance.
		NearestTargets(max_distance, num=1, active=1)
			FilterTargets()
			if(!max_distance)
				max_distance = world.view+1
			var/targets[] = active?(src.active_targets.Copy()):(src.targets.Copy())
			var/sorted_targets[] = list()
			// Targets is about 20 elements at max. A simple sort is good enough, for now.
			while(targets.len && sorted_targets.len < num)
				var/next_target
				var/distance = max_distance
				for(var/mob/T in targets)
					var/tmp_distance = get_dist(src, T)
					if(!T.ko && tmp_distance < distance)
						distance = tmp_distance
						next_target = T
				if(!next_target)	//no more targets in range
					break
				targets -= next_target
				sorted_targets += next_target
			return sorted_targets

		// returns the closest target within view
		NearestTarget()
			FilterTargets()
			if(active_targets.len)
				var/mob/target = active_targets[active_targets.len]
				var/distance = get_dist(src, target)
				for(var/mob/T in active_targets)
					var/tmp_distance = get_dist(src, T)
					if(!T.ko && tmp_distance < distance)
						distance = tmp_distance
						target = T
				if((target in oview(src)) && !target.ko)
					return target
			return null

		// Targets the 'next' mob in view()-order from the current main target.
		// 	add: if true, adds the new target as an active target rather than replacing previous main target.
		TargetNext(add=0)
			FilterTargets()
			var/list/possible_targets = new()
			for(var/mob/human/M in oview())
				possible_targets += M
			if(squad)
				possible_targets -= squad.online_members

			if(!possible_targets.len) return

			var/main_pos = possible_targets.Find(MainTarget())
			var/next_pos = (main_pos % possible_targets.len)+1	// BYOND uses 1-based lists which makes this more complicated than it needs to be.

			if(!add && active_targets.len)
				var/mob/last_target = active_targets[active_targets.len]
				RemoveTarget(last_target)

			if(next_pos > possible_targets.len)
				next_pos = 1

			AddTarget(possible_targets[next_pos], active=1)


		// Targets the 'previous' mob in view()-order from the current main target.
		// 	add: if true, adds the new target as an active target rather than replacing previous main target.
		TargetPrev(add=0)
			FilterTargets()
			var/list/possible_targets = new()
			for(var/mob/human/M in oview())
				possible_targets += M
			if(squad)
				possible_targets -= squad.online_members

			if(!possible_targets.len) return

			var/main_pos = possible_targets.Find(MainTarget())
			var/prev_pos = main_pos - 1

			if(!add && active_targets.len)
				var/mob/last_target = active_targets[active_targets.len]
				RemoveTarget(last_target)

			if(prev_pos < 1 || prev_pos > possible_targets.len)
				prev_pos = possible_targets.len

			AddTarget(possible_targets[prev_pos], active=1)


		// Adds your target(s) to the squad shared target list.
		// Shared targets are removed after 10 seconds.
		AddTargetsToSquad(all=0)


		// Sets (or adds) your target(s) to the squad shared target list.
		// These targets should be trackable as long as at least one person in the squad can track them sucessfully.
		UseSquadTargets(add=0)


		// Removes null/otherwise invalid targets
		FilterTargets()
			for(var/target in targets)
				if(!target)
					targets -= target
				else
					if(istype(target, /atom))
						var/atom/T = target
						if(skillspassive[TRACKING] >= 1)
							var/coords = Global_Coords()
							var/target_coords = T.Global_Coords()
							if(coords && target_coords)
								var/dist = 100
								dist += 100 * skillspassive[TRACKING]
								/*if(skillspassive[TRACKING] == 2)
									dist = 300
								else if(skillspassive[TRACKING] >= 3)
									dist = 700*/
								if(abs(coords[1] - target_coords[1]) > dist || abs(coords[2] - target_coords[2]) > dist)
									RemoveTarget(T, in_filter=1)
							else if(!(T in oview(10, src)))
								RemoveTarget(T, in_filter=1)
						else if(!(T in oview(10, src)))
							RemoveTarget(T, in_filter=1)
			for(var/target in active_targets)
				if(!target)
					active_targets -= target
			for(var/targeter in targeted_by)
				if(!targeter)
					targeted_by -= targeter
				else
					if(istype(target, /mob))
						target:FilterTargets()



	verb
		mactarget_next()
			TargetNext()


		mactarget_prev()
			TargetPrev()


		mactarget_plus_next()
			TargetNext(add=1)


		mactarget_plus_prev()
			TargetPrev(add=1)


		mactarget_squad_set()
			AddTargetsToSquad()


		mactarget_squad_set_all()
			AddTargetsToSquad(all=1)


		mactarget_squad_select()
			UseSquadTargets()


		mactarget_squad_add()
			UseSquadTargets(add=1)



	DblClick(location, control, params_text)
		var/list/params = params2list(params_text)

		if(!params["shift"])
			for(var/mob/T in usr.targets)
				usr.RemoveTarget(T)

		usr.AddTarget(src, active=1)




atom
	proc
		FaceTowards(atom/A)
			dir = angle2dir(get_real_angle(src, A))

atom/DblClick(location, control)
	//world.log << "CONTROL IS: [control]"
	if(ismob(src) || control != "mappane.map")
		return ..()
	else
		var/turf/relative_location = isobj(src) ? loc : src
		if(relative_location)
			for(var/mob/nearest in oview(4, relative_location))
				if(nearest == usr)
					continue
				if(!usr.keys["shift"])
					for(var/t in usr.targets)
						usr.RemoveTarget(t)
				usr.AddTarget(nearest, silent = 0, active = 1)
				break



mob
	FaceTowards(atom/A)
		if(handseal_stun||stunned||paralysed||ko)
			return
		..()