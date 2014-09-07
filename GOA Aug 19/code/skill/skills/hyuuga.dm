melee/taijutsu/gentle_fist
	name = "Gentle Fist"
	id = GENTLE_FIST
	animations = list("PunchA-1", "PunchA-2")

	combo_effect(var/character/attacked, var/combatant/attacker)
		gentle_fist_effect(attacked)

	get_stamina_dmg(var/combatant/user)
		. = (user.control.get_value()) * pick(0.6, 0.7, 0.8, 0.9, 1)

	get_wound_dmg(var/combatant/user)
		. = prob(50) ? pick(1, 2) : 0

	get_critical_dmg(var/combatant/user)
		. = round((user.control.get_value()) * rand(15, 40) / 10) * (1 + 0.10 * user.passives[FORCE])

mob
	var/tmp/byakugan