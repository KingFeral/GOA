trigger
	replacement
		icon_state = "kawarimi"

		can_use(combatant/user)
			. = ..() && !user.meat_tank

		Use()
			//set waitfor = 0
			var/character/replacement_log/r = new(user.loc, user, "regular")

			for(var/character/m in user.targeted_by)
				m.remove_target(user)
				m.add_target(r, active = 1, silent = 1)

			user.body_replacement = list()
			user.body_replacement["replacement"] = r
			user.body_replacement["steps"] = 10
			user.density = 0
			user.icon = null
			user.overlays = null
			user.underlays = null
			user.reset_move_stun()
			user.reset_stun()
			user.paralysed = 0
			user.protect()
			user.RemoveTrigger(src)

			sleep(50)
			if(user.body_replacement)
				user.body_replace()

trigger
	parent_type = /obj
	icon = 'media/jutsu/gui_triggers.dmi'
	layer = 11



	var
		character/user



	proc
		can_use(combatant/user)
			. = user.action != global.actions[ACTION_KNOCKOUT]
		Use()



	Click()
		if(usr == user && can_use(user))
			Use()


	New(loc)
		. = ..()
		if(ismob(loc))
			user = loc
			if(hascall(user, "AddTrigger"))
				call(user, "AddTrigger")(src)




mob
	var/list/triggers


	proc
		AddTrigger(trigger_type)
			if(!triggers)
				triggers = list()

			if(trigger_type)
				if(ispath(trigger_type, /trigger))
					triggers += new trigger_type(src)
				else if(istype(trigger_type, /trigger))
					triggers += trigger_type
				RefreshTriggers()


		RemoveTrigger(trigger/trigger)
			if(trigger)
				if(client) client.screen -= trigger
				triggers -= trigger
				if(!triggers.len)
					triggers = null
				trigger.loc = null
				RefreshTriggers()


		RefreshTriggers()
			if(client && triggers)
				for(var/i = 1; i <= triggers.len; ++i)
					var/trigger/T = triggers[i]
					client.screen -= T
					var/rev_index = triggers.len - i
					T.screen_loc = "1:8,[round(rev_index/2) + 2]:[rev_index%2*16]"
					client.screen += T