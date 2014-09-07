mob
	// misc.
	proc/interact_down()
		var/character/user = usr
		if(user.lastwitnessing && (user.lastwitnessing_time && world.time > user.lastwitnessing_time) && user.sharingan && user:HasSkill(SHARINGAN_COPY))
			var/skill/clan/uchiha/sharingan_copy/copy = user:GetSkill(SHARINGAN_COPY)
			var/skill/copied = copy.CopySkill(user.lastwitnessing)
			user.combat_message("<b><font color=#faa21b>Copied [copied]!</b></font>")
			user.lastwitnessing = 0
			user.lastwitnessing_time = 0
			return

		for(var/character/ch in oview(4, user))
			user.add_target(ch, active = TRUE, append = (user.client.keys["shift"]))
			break()

	proc/activate_down()
		if(usr.equip["weapon"])
			var/item/equip/weapon/e = usr.equip["weapon"]
			if(e.can_use(usr))
				e.use(usr)
				e.set_cooldown(usr)

	// targeting.
	proc/target_nearest_down()
		usr.target_next((usr.client.keys["shift"]))

	proc/target_farthest_down()
		usr.target_prev((usr.client.keys["shift"]))

	proc/untarget_down()
		for(var/target in usr.targets)
			usr.remove_target(target)