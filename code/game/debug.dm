
mob
	Admin
		verb
			Change_Icon(atom/A in world, new_icon as file)
				A.icon = new_icon

			Change_Icon_State(atom/A in world, new_state as text)
				A.icon_state = new_state

			Create_Effect(icon_file as file, state as text)
				var/obj/effect = new(loc)
				effect.icon = icon_file
				effect.icon_state = state

			Delete(atom/A in world)
				del A

			Earthquake2(max_steps=5 as num, offset_min=-2 as num, offset_max=2 as num)
				var/steps = 0
				var/last = 1
				var/last_clients[0]

				while(steps < max_steps)
					for(var/mob/M in (last_clients - viewers()))
						if(M.client)
							M.client.pixel_y = 0

					last_clients = new

					for(var/mob/M in viewers())
						if(M.client)
							last_clients += M
							M.client.pixel_y = last?(offset_min):(offset_max)
					sleep(1)
					++steps
					last = !last

				for(var/mob/M in last_clients)
					if(M.client)
						M.client.pixel_y = 0

			Give_Skill(mob/human/player/x in All_Clients(), skill_id as num)
				if(!x.HasSkill(skill_id))
					x.AddSkill(skill_id)
					x.RefreshSkillList()

			Reset_Cooldowns(mob/human/player/x in All_Clients())
				for(var/skill/S in x.skills)
					S.cooldown = 0
