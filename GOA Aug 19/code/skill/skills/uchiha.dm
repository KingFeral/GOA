skill/clan/copyable = 0

skill/clan/uchiha
	sharingan
		id = SHARINGAN
		name = "Sharingan"
		icon_state = "sharingan1"
		default_chakra_cost = 100
		default_cooldown = 30

		var/tmp/level

		Activate(combatant/user,mangekyou)
			var/level = 1
			var/mstoggle = mangekyou// || (user.client && (KEY_MODIFY in user.client.controller.key_input))
			if(user.HasSkill(SHARINGAN_TOMOE_UPGRADE_1))
				level++
			if(user.HasSkill(SHARINGAN_TOMOE_UPGRADE_2))
				level++
			if(level == 3 && mstoggle)
				if(user.HasSkill(SHARINGAN_MANGEKYOU_UPGRADE))
					level++
			src.level = level
			//if(level > 1)
			src.icon_state = "sharingan[level]"
			..()

		Cooldown(combatant/user)
			if(user.sharingan)
				return 3

			. = ..()

		Use(combatant/user)
			if(in_use)
				user.combat_message("You have deactivated your Sharingan.")
				user.reflex.remove_buff(id)
				user.intelligence.remove_buff(id)
				user.sharingan = 0
				user.calculate_stats()
				user.affirm_icon()
				src.RemoveOverlay(CANCEL_SKILL_OVERLAY)
				src.in_use=0
				return
			else
				var/rfxbuff = 0
				var/intbuff = 0
				switch(level)
					if(1)
						rfxbuff = user.reflex.value * 0.05
						intbuff = user.intelligence.value * 0.05
					if(2)
						rfxbuff = user.reflex.value * 0.25
						intbuff = user.intelligence.value * 0.25
					if(3)
						rfxbuff = user.reflex.value * 0.50
						intbuff = user.intelligence.value * 0.40

				viewers(user) << output("[user]: Sharingan!", "combat.output")

				user.combat_message("Your eyes open bright revealing [level < 4 ? (level == 1) ? "a Sharingan of a single tomoe." : "a Sharingan of [level] tomoes." : "a Mangekyou Sharingan!"]")

				user.reflex.add_buff(id, rfxbuff)
				user.intelligence.add_buff(id, intbuff)
				user.sharingan = src.level
				user.affirm_icon()
				user.calculate_stats()

				src.AddOverlay(CANCEL_SKILL_OVERLAY)
				src.in_use = 1

		genjutsu_reversal
			// Genjutsu Reversal: Allows the Uchiha to read and reverse a genjutsu effect casted, given the attacker's genjutsu effectiveness is lower.
			// Being an upgrade, this wouldn't be a skill of itself. Instead, like Sharingan Copy, the trigger event is given to the Uchiha when the genjutsu is casted given
			// the conditions are right (the Uchiha's genjutsu effectiveness exceeds the attacker's). This may or may not have an internal cooldown.
			id = SHARINGAN_UPGRADE_GENJUTSU_REVERSAL
			icon_state = "sharingan2"
			upgrade = 1

		tomoe_2
			id = SHARINGAN_TOMOE_UPGRADE_1
			icon_state = "sharingan2"
			upgrade = 1

		tomoe_3
			id = SHARINGAN_TOMOE_UPGRADE_2
			icon_state = "sharingan3"
			upgrade = 1

		mangekyou
			id = SHARINGAN_MANGEKYOU_UPGRADE
			icon_state = "sharingan2"
			upgrade = 1

	sharingan_copy
		id = SHARINGAN_COPY
		name = "Sharingan Copy"
		icon_state = "sharingancopy"
		var
			skill/copied_skill



		Activate(combatant/user)
			if(copied_skill)
				return copied_skill.Activate(user)
			else
				Error(user, "You do not have a copied skill.")
				return 0


		IconStateChanged(skill/sk, new_state)
			if(sk == copied_skill)
				ChangeIconState(new_state)



		proc
			CopySkill(id)
				var/skill_type = SkillType(id)
				var/skill/skill
				if(!skill_type)
					return
				else
					skill = new skill_type()
				//skill.master = src
				copied_skill = skill
				icon_overlays = list(icon('media/jutsu/gui_badges.dmi', "sharingan_copy"))
				icon = skill.icon
				icon_state = skill.icon_state
				/*for(var/skillcard/card in skillcards)
					card.icon = icon
					card.icon_state = icon_state
					card.overlays = icon_overlays*/
				return skill

	shackling_stakes
		id = SHACKLING_STAKES
		name = "Sharingan Genjutsu: Shackling Stakes"
		icon_state = "shackling_stakes"
		default_chakra_cost = 200
		default_cooldown = 90

mob
	var/tmp/sharingan
	var/tmp/lastwitnessing=0
	var/tmp/lastwitnessing_time=0