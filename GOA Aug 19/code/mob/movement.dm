mob
	var/tmp/running_speed = 0

	proc/startrun()
		src.refresh_move_delay()
		src.icon_state = "Run"

	Move()
		if(frozen) return 0
		. = ..()

	can_move()
		return ..() && !src.action_set(ACTION_KNOCKOUT) && !stunned

	get_move_stun()
		. = 0
		if(slows && slows.len)
			for(var/slow_effect in slows)
				if(!.)
					. = slow_effect
				else if(slow_effect > .)
					. = slow_effect

		if(move_penalty)
			if(.)
				. += round(move_penalty / 50, 0.1)
			else
				. += round(move_penalty / 100, 0.1)

		if(size_up)
			. += size_up == 1 ? 0.25 : 0.5


	refresh_move_delay()
		var/default_delay = src.meat_tank ? 0.75 : src.action_set(ACTION_RUN) ? RUN_SPEED : WALK_SPEED

		src.move_delay = max(0, min(2.5, round(default_delay + src.get_move_stun(), 0.1)))

action
	run
		id = ACTION_RUN

		begin(character/user, list/params)
			..()
			user.startrun()

		end(character/user)
			..()
			user.icon_state = ""
			user.refresh_move_delay()

		proc/on_movement(combatant/user)
			if(user.running_speed < RUN_SPEED_THRESHOLD)
				user.act(global.actions[ACTION_IDLE])
			else
				if(!user.icon_state)
					user.icon_state = "Run"