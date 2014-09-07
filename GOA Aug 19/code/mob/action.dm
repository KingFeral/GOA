action
	idle
		id = ACTION_IDLE

		begin(character/user, list/params)
			..()
			user.icon_state = ""
			user.refresh_move_delay()

		set_previous()

		end(character/user, list/params)
			..()
			user.icon_state = ""


var/global/list/actions = list(
	ACTION_IDLE			= new/action/idle,
	ACTION_RUN			= new/action/run,
	ACTION_KNOCKOUT		= new/action/knockout,
	ACTION_ATTACK		= new/action/attack,
	ACTION_DEFEND		= new/action/defend,
	ACTION_HANDSEALS	= new/action/handseals,
	)

action
	var/id

	proc/set_current(character/user)
		user.action = src
		user.action_timestamp = world.time

	proc/set_previous(character/user)
		user.last_action = src
		user.last_action_timestamp = world.time

	proc/can_begin(character/user)
		//return user.action != global.actions[ACTION_KNOCKOUT]
		return TRUE

	proc/begin(character/user, list/params)
		src.set_current(user)

	proc/end(character/user)
		src.set_previous(user)