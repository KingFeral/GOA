mob/human/player/npc
	var
		tmp/doesnotattack

	War_Hero
		wander = 0
		interact = "Talk"
		dietype = 1
		doesnotattack = 1
		con = 600
		str = 600
		int = 600
		rfx = 600
		stamina = 12000
		chakra = 3000
		Talk()
			set src in oview(1)
			var
				items[] = list()

			usr << "<strong>[name]:</strong>I am here to reward the strong and spit on the weak! Exchange your Faction Points for PvP rewards here."

			items["Double Experience Scroll (5 Faction Points)"] = list(/obj/items/usable/scrolls/double_experience, 5)
			items["Triple Experience Scroll (10 Faction Points)"] = list(/obj/items/usable/scrolls/triple_experience, 10)

			var/i = input(usr, "Choose a reward..", "War Hero Exchange") in items
			if(i)
				var/c = input(usr, "Are you sure you want [i]?", "Confirm") in list("No", "Yes")
				if(c && c == "Yes")
					var/list/itemlist = items[i]
					var/cost = itemlist[2]
					if(usr.factionpoints >= cost)
						usr.factionpoints -= cost
						var/itemtype = itemlist[1]
						new itemtype(usr)


		leaf
			name = "Leaf War Hero"
			pants=/obj/pants/blue
			overshirt=/obj/shirt_sleeves/blue
			armor=/obj/chuunin/leaf
			facearmor = /obj/headband/blue
			hair_type=99
			hair_color="#000000"
			locationdisc="Konoha"
			Talk()
				if(usr.faction && usr.faction.village != faction.village)
					return
				..()
		mist
			name = "Mist War Hero"
			pants=/obj/pants/black
			overshirt=/obj/shirt_sleeves/black
			armor=/obj/chuunin/mist
			facearmor = /obj/headband/black
			hair_type=99
			hair_color="#000000"
			locationdisc="Kiri"
			Talk()
				if(usr.faction && usr.faction.village != faction.village)
					return
				..()
		sand
			name = "Sand War Hero"
			pants=/obj/pants/black
			overshirt=/obj/shirt_sleeves/black
			armor=/obj/chuunin/sand
			facearmor = /obj/headband/red
			hair_type=99
			locationdisc="Suna"
			Talk()
				if(usr.faction && usr.faction.village != faction.village)
					return
				..()

obj/items/drops
	var/tmp/item_ref = null

	verb/get()
		set src in view(1)
		new item_ref(usr)
		usr << "You picked up the [src]."
		loc = null

	Click()
		if(get_dist(src, usr) < 1)
			new item_ref(usr)
			usr << "You picked up the [src]."
			loc = null

	scrolls
		icon = 'icons/scrolls.dmi'
		double_experience
			item_ref = /obj/items/usable/scrolls/double_experience
			icon_state = "Rare"

		triple_experience
			item_ref = /obj/items/usable/scrolls/triple_experience
			icon_state = "Legendary"

obj/items/usable
	scrolls
		icon = 'icons/scrolls.dmi'

		proc/Use(mob/user)

		double_experience
			icon_state = "Rare_Gui"
			code = 333

			Use(mob/user)
				user << "Disabled until I fix them."
				return
				if(usr.triple_xp_time > 0)
					usr << "You cannot stack double and triple experience."
					return
				usr.double_xp_time += 60 * 10
				usr << "The double experience scroll burns up in flames."
				usr << "Double experience gained for <strong>+10</strong> minutes."
				del(src)

		triple_experience
			icon_state = "Legendary_Gui"
			code = 334

			Use(mob/user)
				user << "Disabled until I fix them."
				return
				if(usr.double_xp_time > 0)
					usr << "You cannot stack double and triple experience."
					return
				usr.triple_xp_time += 60 * 10
				usr << "The triple experience scroll burns up in flames."
				usr << "Triple experience gained for <strong>+10</strong> minutes."
				del(src)

		Click()
			Use(usr)

mob
	var/double_xp_time = 0
	var/triple_xp_time = 0