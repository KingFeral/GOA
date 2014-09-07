item/equip
	apparel
		var/customizable = 1
		var/color_mod

		equip(combatant/user)
			. = ..()
			if(.)
				if(src.customizable && !src.color_mod) // on first equip.
					var/add_color = alert(user, "Do you want to add color to this item? You will only be able to apply color to this item once. Pressing \"No\" will leave this item the way it is.", "Customize [src.name]", "Yes", "No")
					if(!add_color) return
					if(add_color == "Yes")
						var/mcolor_r = round((input(user, "Choose how much red.") as num) * 1)
						var/mcolor_g = round((input(user, "Choose how much green.") as num) * 1)
						var/mcolor_b = round((input(user, "Choose how much blue.") as num) * 1)

						if(!user) return

						user.remove_appearance(src.id)

						src.color_mod = rgb(mcolor_r, mcolor_g, mcolor_b)

						for(var/image/img in src.user_overlays)
							img.color = src.color_mod

						user.add_appearance(src.user_overlays, src.id)
					else
						src.color_mod = -1