

skill/taijutsu/wrestling
	face_nearest = TRUE

	IsUsable(mob/user)
		. = ..()
		if(.)
			if(user.stance != STRONG_FIST)
				Error(user, "You need to be in Arhat Fist stance to use this.")
				return 0

	stance
		id = WRESTLING
		name = "Taijutsu Stance: Wrestling"
		icon_state = "wrestling"
		default_cooldown = 3

		IsUsable(mob/user)
			return 1

	powerbomb
		// low damage; used to close the gap
		id = POWERBOMB
		name = "Powerbomb"
		icon_state = "Power_Bomb"
		default_stamina_cost = 300
		default_cooldown = 90

	drop_kick
		// higher damage; shorter range; knockback combo
		id = DROP_KICK
		name = "Drop Kick"
		icon_state = "Drop_Dick"
		default_stamina_cost = 300
		default_cooldown = 90

	lariat
		// stun/slow attack
		id = LARIAT
		name = "Lariat"
		icon_state = "Lariat"
		default_stamina_cost = 300
		default_cooldown = 90

	knee_drop
		// silences the target for five seconds
		id = KNEE_DROP
		name = "Knee Drop"
		icon_state = "Knee_Drop"
		default_stamina_cost = 300
		default_cooldown = 90

	kidney_punch
		// hits all targets within a one-tile range with a strong kick for a possible daze
		id = KIDNEY_PUNCH
		name = "Kidney Punch"
		icon_state = "wrestling"
		default_stamina_cost = 300
		default_cooldown = 90

	iron_claw
		// speeds up the user's movement speed (Meat Tank-like speed) and turns their next combo into a knockup attack. Attacks cost stamina while active.
		id = IRON_CLAW
		name = "Iron Claw"
		icon_state = "Iron_Claw"
		default_stamina_cost = 300
		default_cooldown = 90