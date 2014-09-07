player
	Moved()
		set waitfor = 0
		..()
		if(hascall(src.action, "on_movement"))
			call(src.action, "on_movement")(src)

		src.running_speed = max(0, min(10, ++src.running_speed))

		if(src.running_speed >= RUN_SPEED_THRESHOLD && !src.get_move_stun() && !src.action_set(ACTION_RUN))
			src.act(global.actions[ACTION_RUN])

		sleep(10)
		if(!src.client) return

		if(!src.client.moving)
			src.running_speed = max(0, --src.running_speed)