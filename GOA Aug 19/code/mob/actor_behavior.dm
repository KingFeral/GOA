mob
	proc/force_action(id, list/params)
		var/l = list("force" = TRUE)
		if(params)
			l += params
		src.act(global.actions[id], l)

	proc/action_set(id)
		return src.action == global.actions[id]

	proc/can_act(action/action)
		return src.can_move() && !src.action_set(ACTION_KNOCKOUT)

	proc/act(var/action/action, var/list/params)
		if((!src.can_act(action) || !action.can_begin(src, params)) && (!params || !params["force"]))
			return 0

		src.action.end(src)
		action.begin(src, params)
		return 1

mob/Login()
	..()
	src.action = global.actions[ACTION_IDLE]
	src.action.begin(src)