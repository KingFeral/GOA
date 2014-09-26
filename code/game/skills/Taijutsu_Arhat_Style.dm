

mob
	var/tmp/stance // as skill id.

skill/taijutsu/arhat_style
	face_nearest = TRUE

	IsUsable(mob/user)
		. = ..()
		if(.)
			if(user.stance != ARHAT_FIST)
				Error(user, "You need to be in Arhat Fist stance to use this.")
				return 0

	stance
		id = ARHAT_FIST
		name = "Taijutsu Stance: Arhat Fist"
		icon_state = "Arhat_Fist"
		default_cooldown = 3

		IsUsable(mob/user)
			return 1

	rock_attack
		// attack for pure damage.
		id = ROCK_ATTACK
		name = "Rock Attack"
		icon_state = "Arhat_Fist"
		default_stamina_cost = 300
		default_cooldown = 90

	thrusting_shoulder
		// knockback attack.
		id = THRUSTING_SHOULDER
		name = "Thrusting Shoulder"
		icon_state = "Arhat_Fist"
		default_stamina_cost = 300
		default_cooldown = 90

	crumbling_palm
		// slowdown attack.
		id = CRUMBLING_PALM
		name = "Crumbling Palm"
		icon_state = "Arhat_Fist"
		default_stamina_cost = 300
		default_cooldown = 90

	rising_knee
		// stun attack.
		id = RISING_KNEE
		name = "Rising Knee"
		icon_state = "Arhat_Fist"
		default_stamina_cost = 300
		default_cooldown = 90

	upwards_palm
		// silence attack.
		id = UPWARDS_PALM
		name = "Upwards Palm"
		icon_state = "Arhat_Fist"
		default_stamina_cost = 300
		default_cooldown = 90

	pressure_palm
		// does AOE damage to neighboring tiles relative to the target.
		id = PRESSURE_PALM
		name = "Pressure Palm"
		icon_state = "Arhat_Fist"
		default_stamina_cost = 300
		default_cooldown = 90