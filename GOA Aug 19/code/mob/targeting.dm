mob
	var/tmp/active_targets[0]
	var/tmp/targets[0]
	var/tmp/image/target_image
	var/tmp/image/active_target_image
	var/tmp/targeted_by[0]

	proc/MaxActiveTargets()
		var/mult = 1
		if(passives[TRACKING])
			mult += passives[TRACKING]
		return 1 * mult

	proc/MaxTargets()
		var/mult = 1
		if(passives[TRACKING])
			mult += passives[TRACKING]
		return 3 * mult

	proc/add_target(var/character/target, var/active = TRUE, var/silent = FALSE, append)
		if(!target.can_target())
			return 0

		src.filter_targets()

		if(!append)
			for(var/r in src.targets)
				src.remove_target(r)

		if(isnull(target.target_image) || isnull(target.active_target_image))
			target.initialize_target_images()

		if(!(target in targets))
			targets += target
			target.targeted_by += src

		if(active && !(target in active_targets))
			active_targets += target
			if(client) client.images -= target.target_image
			src << target.active_target_image

			var/max_active = MaxActiveTargets()
			while(active_targets.len > max_active)
				var/character/T = active_targets[1]
				active_targets -= T
				if(client) client.images -= T.active_target_image
				src << T.target_image

			var/list/new_targets = targets.Copy()
			for(var/character/T in active_targets)
				new_targets -= T

			var/max_targets = MaxTargets() - active_targets.len
			if(max_targets >= 0)
				while(new_targets.len > max_targets)
					var/character/T =  new_targets[1]
					new_targets -= T
					T.targeted_by -= src
					if(client) client.images -= T.target_image
			targets = new_targets + active_targets
		else if(!(target in active_targets))
			if(src.client)
				src << target.target_image
		target_added(target, active, silent)

	proc/target_added(var/character/target, var/active = TRUE, var/silent = FALSE)

	proc/remove_target(var/character/M, var/in_filter)
		if(!M || !istype(M))
			return 0

		if(!in_filter)
			filter_targets()

		targets -= M
		active_targets -= M
		M.targeted_by -= src
		if(client)
			client.images -= M.active_target_image
			client.images -= M.target_image
			if(M.name_image)
				for(var/I in M.name_image)
					client.images -= I

	proc/main_target(var/list/params)
		filter_targets()

		if(active_targets.len)
			var/character/target = active_targets[active_targets.len]
			if((target in oview(src)) && target.action != global.actions[ACTION_KNOCKOUT])
				return target
			else
				var/distance = get_dist(src, target)
				for(var/character/T in active_targets)
					var/tmp_distance = get_dist(src, T)
					if(T.action != global.actions[ACTION_KNOCKOUT] && tmp_distance < distance)
						distance = tmp_distance
						target = T
				if((target in oview(src)) && target.action != global.actions[ACTION_KNOCKOUT])
					return target
		return null

	proc/nearest_target()
		filter_targets()

		if(active_targets.len)
			var/character/target = active_targets[active_targets.len]
			var/distance = get_dist(src, target)
			for(var/character/T in active_targets)
				var/tmp_distance = get_dist(src, T)
				if(T.action != global.actions[ACTION_KNOCKOUT] && tmp_distance < distance)
					distance = tmp_distance
					target = T
			if((target in oview(src)) && target.action != global.actions[ACTION_KNOCKOUT])
				return target
		return null

	proc/nearest_targets(var/max_distance, var/num = 1, var/active = TRUE)
		filter_targets()

		if(!max_distance)
			max_distance = VIEW_DISTANCE

		var/targets[] = active ? (src.active_targets.Copy()) : (src.targets.Copy())
		var/sorted_targets[] = list()

		while(targets.len && sorted_targets.len < num)
			var/next_target
			var/distance = max_distance
			for(var/character/T in targets)
				var/tmp_distance = get_dist(src, T)
				if(T.action != global.actions[ACTION_KNOCKOUT] && tmp_distance < distance)
					distance = tmp_distance
					next_target = T

			if(!next_target)
				break

			targets -= next_target
			sorted_targets += next_target

		return sorted_targets

	proc/target_next(var/add = 0)
		filter_targets()

		var/list/possible_targets = new()
		for(var/character/M in oview())
			possible_targets += M

		if(!possible_targets.len) return

		var/main_pos = possible_targets.Find(main_target())
		var/next_pos = (main_pos % possible_targets.len)+1	// BYOND uses 1-based lists which makes this more complicated than it needs to be.

		if(!add && active_targets.len)
			var/mob/last_target = active_targets[active_targets.len]
			remove_target(last_target)

		if(next_pos > possible_targets.len)
			next_pos = 1

		add_target(possible_targets[next_pos], active = 1, append = add)

	proc/target_prev(var/add = 0)
		filter_targets()

		var/list/possible_targets = new()
		for(var/character/M in oview())
			possible_targets += M

		if(!possible_targets.len) return

		var/main_pos = possible_targets.Find(main_target())
		var/prev_pos = main_pos - 1

		if(!add && active_targets.len)
			var/mob/last_target = active_targets[active_targets.len]
			remove_target(last_target)

		if(prev_pos < 1 || prev_pos > possible_targets.len)
			prev_pos = possible_targets.len

		add_target(possible_targets[prev_pos], active = 1, append = add)

	proc/can_target()
		return (src.body_replacement) ? (0) : (1)

	proc/filter_targets()
		if(src.targets.len)
			for(var/character/target in src.targets)
				if(get_dist(src, target) > VIEW_DISTANCE)
					src.remove_target(target,1)

		if(src.active_targets.len)
			for(var/character/target in src.active_targets)
				if(get_dist(src, target) > VIEW_DISTANCE)
					src.remove_target(target,1)

	proc/initialize_target_images()
		target_image        = image('media/obj/extras/target.dmi', src, icon_state = "hollow", layer = 15)
		active_target_image = image('media/obj/extras/target.dmi', src, icon_state = "active", layer = 15)


atom/DblClick(var/location, var/control, var/params)
	var/player/user = usr
	if(ischaracter(src))// TODO
		//if(!(KEY_MODIFY in user.client.controller.key_input))
		for(var/target in user.targets)
			user.remove_target(target)

		user.add_target(src, active = TRUE)

	else if(isturf(src))
		var/list/targview = view(3, src)
		if(user in targview)
			targview -= user
		var/character/possible_target = locate() in targview
		if(possible_target) //TODO
			//if(!(KEY_MODIFY in user.client.controller.key_input))
			for(var/target in user.targets)
				user.remove_target(target)

			user.add_target(possible_target, active = TRUE)

	else ..()




atom
	proc
		FaceTowards(atom/A)
			src.dir = angle2dir(get_real_angle(src, A))




character
	FaceTowards(atom/A)
		if(!src || !A)
			return
		if(src.stunned || src.action == global.actions[ACTION_KNOCKOUT])
			return
		..()