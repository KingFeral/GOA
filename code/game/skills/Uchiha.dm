skill
	uchiha
		copyable = 0




		sharingan_1
			id = SHARINGAN1
			name = "Sharingan"
			icon_state = "sharingan1"
			default_chakra_cost = 150
			default_cooldown = 150



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]: Sharingan!", "combat_output")
				user.sharingan=1

				var/buffrfx=round(user.rfx*0.25)
				var/buffint=round(user.int*0.25)

				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)

					user.special=0
					user.sharingan=0

					user.Affirm_Icon()
					user.combat("Your sharingan deactivates.")




		sharingan_2
			id = SHARINGAN2
			name = "Sharingan"
			icon_state = "sharingan2"
			default_chakra_cost = 350
			default_cooldown = 250



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(user.sharingan)
						Error(user, "Sharingan is already active")
						return 0


			Cooldown(mob/user)
				return default_cooldown


			Use(mob/user)
				viewers(user) << output("[user]: Sharingan!", "combat_output")
				user.sharingan=1

				var/buffrfx=round(user.rfx*0.5)
				var/buffint=round(user.int*0.33)

				user.rfxbuff+=buffrfx
				user.intbuff+=buffint
				user.Affirm_Icon()

				spawn(Cooldown(user)*10)
					if(!user) return
					user.rfxbuff-=round(buffrfx)
					user.intbuff-=round(buffint)

					user.special=0
					user.sharingan=0

					user.Affirm_Icon()
					user.combat("Your sharingan deactivates.")




		sharingan_copy
			id = SHARINGAN_COPY
			name = "Sharingan Copy"
			icon_state = "sharingancopy"
			var
				skill/copied_skill



			Activate(mob/user)
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
						skill = new /skill()
						skill.id = id
						skill.name = "Unknown Skill ([id])"
					else
						skill = new skill_type()
					skill.master = src
					copied_skill = skill
					icon_overlays = list(icon('icons/gui_badges.dmi', "sharingan_copy"))
					icon = skill.icon
					icon_state = skill.icon_state
					for(var/skillcard/card in skillcards)
						card.icon = icon
						card.icon_state = icon_state
						card.overlays = icon_overlays
					return skill
