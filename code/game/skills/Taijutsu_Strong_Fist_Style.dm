

skill/taijutsu/strong_fist
	face_nearest = TRUE

	IsUsable(mob/user)
		. = ..()
		if(.)
			if(user.stance != STRONG_FIST)
				Error(user, "You need to be in Arhat Fist stance to use this.")
				return 0

	stance
		id = STRONG_FIST
		name = "Taijutsu Stance: Strong Fist"
		icon_state = "Strong_Fist"
		default_cooldown = 3

		IsUsable(mob/user)
			return 1

	leaf_whirlwind
		// low damage; used to close the gap
		id = LEAF_WHIRLWIND
		name = "Pressure Palm"
		icon_state = "leaf_whirlwind"
		default_stamina_cost = 300
		default_cooldown = 90

	leaf_great_whirlwind
		// higher damage; shorter range; knockback combo
		id = LEAF_GREAT_WHIRLWIND
		name = "Pressure Palm"
		icon_state = "leaf_great_whirlwind"
		default_stamina_cost = 300
		default_cooldown = 90

	leaf_gale
		// stun/slow attack
		id = LEAF_GALE
		name = "Pressure Palm"
		icon_state = "leaf_gale"
		default_stamina_cost = 300
		default_cooldown = 90

	leaf_rising_wind
		// silences the target for five seconds
		id = LEAF_RISING_WIND
		name = "Pressure Palm"
		icon_state = "leaf_rising_wind"
		default_stamina_cost = 300
		default_cooldown = 90

	leaf_strong_whirlwind
		// hits all targets within a one-tile range with a strong kick for a possible daze
		id = LEAF_STRONG_WHIRLWIND
		name = "Pressure Palm"
		icon_state = "leaf_great_whirlwind"
		default_stamina_cost = 300
		default_cooldown = 90

	dancing_leaf_shadow
		// speeds up the user's movement speed (Meat Tank-like speed) and turns their next combo into a knockup attack. Attacks cost stamina while active.
		id = DANCING_LEAF_SHADOW
		name = "Pressure Palm"
		icon_state = "shadow_dance"
		default_stamina_cost = 300
		default_cooldown = 90