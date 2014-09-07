item/equip
	armor
		var/armor_value = 0
		var/reflex_reduction = 0

		equip(combatant/user)
			. = ..()
			if(.)
				user.armor_count += src.armor_value
				if(src.reflex_reduction)
					user.reflex.add_debuff(src.id, src.reflex_reduction)
			else
				user.armor_count = max(0, user.armor_count - src.armor_value)
				if(user.reflex.has_debuff(src.id))
					user.reflex.remove_debuff(src.id)