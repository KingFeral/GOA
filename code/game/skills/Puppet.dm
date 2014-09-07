skill
	puppet
		copyable = 0




		puppet_summoning
			default_cooldown = 60



			var
				puppet_num



			Cooldown(mob/user)
				var/puppet_var = "Puppet[puppet_num]"
				var/mob/human/Puppet/puppet = user.vars[puppet_var]
				if(!puppet)
					return ..(user)
				else
					return 0


			Use(mob/human/user)
				viewers(user) << output("[user]: [src]!", "combat_output")
				var/puppet_var = "Puppet[puppet_num]"
				var/mob/human/Puppet/puppet = user.vars[puppet_var]
				if(!puppet && user.Puppets.len >= puppet_num && user.Puppets[puppet_num])
					var/obj/items/Puppet/P1=user.Puppets[puppet_num]
					var/typ = P1.summon
					Poof(user.x,user.y,user.z)

					puppet = new typ(user.loc)
					puppet.rfx = user.rfx
					puppet.name = P1.name
					puppet.faction = user.faction
					P1.incarnation = puppet
					user.vars[puppet_var] = puppet
					spawn() puppet.PuppetRegen(user)
				else if(puppet)
					Poof(puppet.x,puppet.y,puppet.z)
					del(puppet)




			first
				id = PUPPET_SUMMON1
				name = "Summoning: First Puppet"
				icon_state = "puppet1"
				puppet_num = 1




			second
				id = PUPPET_SUMMON2
				name = "Summoning: Second Puppet"
				icon_state = "puppet2"
				puppet_num = 2




		puppet_transform
			id = PUPPET_HENGE
			name = "Puppet Transform"
			icon_state = "puppethenge"
			default_chakra_cost = 50
			default_cooldown = 25



			IsUsable(mob/user)
				. = ..()
				if(.)
					if(!user.Primary)
						Error(user, "Must be directly controlling a puppet")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Puppet Transform!", "combat_output")
				if(user.Primary)
					var/mob/human/puppet = user.Primary
					if(!puppet.icon_state)
						flick(puppet,"Seal")
					Poof(puppet.x,puppet.y,puppet.z)

					puppet.icon=user.icon
					puppet.realname=puppet.name
					puppet.name=user.name
					puppet.overlays=user.overlays
					puppet.mouse_over_pointer=user.mouse_over_pointer
					puppet.phenged=1
					spawn(1200)//recover
						if(puppet && puppet.phenged)
							puppet.mouse_over_pointer=faction_mouse[puppet.faction.mouse_icon]
							puppet.name=puppet.realname
							puppet.phenged=0
							Poof(puppet.x,puppet.y,puppet.z)
							puppet.overlays=0
							puppet.icon=initial(puppet.icon)




		puppet_swap
			id = PUPPET_SWAP
			name = "Puppet Swap"
			icon_state = "puppetswap"
			default_chakra_cost = 100
			default_cooldown = 45



			IsUsable(mob/user)
				. = ..()
				if(.)
					var/list/valid=new
					if(user.Puppet1 && user.Puppet1.z==user.z)
						valid+=user.Puppet1
					if(user.Puppet2 && user.Puppet2.z==user.z)
						valid+=user.Puppet2
					if(!valid.len)
						Error(user, "No valid puppet")
						return 0



			Use(mob/human/user)
				viewers(user) << output("[user]: Puppet Swap!", "combat_output")
				var/list/valid=new
				if(user.Puppet1 && user.Puppet1.z==user.z)
					valid+=user.Puppet1
				if(user.Puppet2 && user.Puppet2.z==user.z)
					valid+=user.Puppet2
				if(length(valid))
					var/mob/sw=pick(valid)
					Poof(user.x,user.y,user.z)
					var/turf/Tq=user.loc
					user.loc=sw.loc
					sw.loc=Tq
					walk(sw,0)
					user.client.eye=sw
					user.Primary=sw
