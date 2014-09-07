

attribute
	strength
		id = STRENGTH
		value = 50

	control
		id = CONTROL
		value = 50

	reflex
		id = REFLEX
		value = 50

	intelligence
		id = INTELLIGENCE
		value = 50


attribute
	var/id
	var/tmp/value = 0
	var/tmp/list/buffs
	var/tmp/list/debuffs
	var/tmp/character/user

	proc/set_value(value)
		src.value = value
		src.update()

	proc/get_value(var/include_modifiers)
		. = src.value

		if(include_modifiers)
			if(src.buffs)
				for(var/buff in src.buffs)
					. += src.buffs[buff]

			if(src.debuffs)
				for(var/debuff in src.debuffs)
					. += src.debuffs[debuff]

	proc/has_buff(var/buff_ID)
		return buff_ID in src.buffs

	proc/has_debuff(var/debuff_ID)
		return debuff_ID in src.debuffs

	proc/clear_buffs()
		src.buffs = null

		src.update()

	proc/clear_debuffs()
		src.debuffs = null

		src.update()

	proc/add_buff(var/buff_ID, var/buff_amount)
		if(!src.buffs)
			src.buffs = list()

		if(buff_ID in src.buffs)
			src.buffs[buff_ID] += buff_amount
		else
			src.buffs[buff_ID] = buff_amount

		src.update()

	proc/remove_buff(var/buff_ID)
		if(buff_ID in src.buffs)
			src.buffs -= buff_ID
			if(!src.buffs.len)
				src.buffs = null

			src.update()

	proc/add_debuff(var/debuff_ID, var/debuff_amount)
		if(!src.debuffs)
			src.debuffs = list()

		if(debuff_ID in src.debuffs)
			src.debuffs[debuff_ID] += debuff_amount
		else
			src.debuffs[debuff_ID] = debuff_amount

		src.update()

	proc/remove_debuff(var/debuff_ID)
		if(debuff_ID in src.debuffs)
			src.debuffs -= debuff_ID
			if(!src.debuffs.len)
				src.debuffs = null

			src.update()

	proc/increase(amount)
		value += amount
		update()

	proc/update()

	New(var/character/user)
		if(user)
			src.user = user
			src.update()

mob
	var/tmp/attribute/strength/strength
	var/tmp/attribute/control/control
	var/tmp/attribute/reflex/reflex
	var/tmp/attribute/intelligence/intelligence

	New()
		src.initialize_attributes()
		. = ..()

	proc/initialize_attributes()
		src.strength = new/attribute/strength(src)
		src.control = new/attribute/control(src)
		src.reflex = new/attribute/reflex(src)
		src.intelligence = new/attribute/intelligence(src)