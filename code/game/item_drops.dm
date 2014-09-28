mob/human/npc/shopnpc
	War_Veteran
		pants=/obj/pants/black
		overshirt=/obj/shirt_sleeves/black
		armor=/obj/anbu_armor
		facearmor = /obj/anbu_mask/one
		hair_type=3
		hair_color="#C8C800"
		leaf
			name = "Leaf War Hero"
			pants=/obj/pants/blue
			overshirt=/obj/shirt_sleeves/blue
			armor=/obj/chuunin/leaf
			facearmor = /obj/headband/blue
			hair_type=99
			hair_color="#000000"
			Shop()
				if(usr.faction && usr.faction.village != "Konoha")
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
			Shop()
				if(usr.faction && usr.faction.village != "Kiri")
					return
				..()
		sand
			name = "Sand War Hero"
			pants=/obj/pants/black
			overshirt=/obj/shirt_sleeves/black
			armor=/obj/chuunin/sand
			facearmor = /obj/headband/red
			hair_type=99
			Shop()
				if(usr.faction && usr.faction.village != "Suna")
					return
				..()
/*mob/human/player/npc
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
				..()*/

obj/items/drops
	var/tmp/item_ref = null

	New()
		..()
		overlays += "sparkle"

	verb/get(mob/picked_up)
		set src in view(1)
		if(picked_up)
			usr = picked_up
		if(get_dist(src, usr) <= 1)
			var/has_item = 0
			for(var/obj/items/ex in usr.contents)
				if(istype(ex, item_ref))
					has_item += 1 + ex.equipped
					if(ex.equipped)
						has_item-- // subtract the equipped item

			if(!has_item)
				new item_ref(usr)
			else for(var/obj/items/usable/object in usr.contents)
				if(istype(object, item_ref))
					object.equipped++
					object.Refreshcountdd(usr)
		usr << "You picked up the [src]."
		loc = null

	Click()
		src.get(usr)
		/*if(get_dist(src, usr) <= 1)
			var/has_item = 0
			for(var/obj/items/ex in usr.contents)
				if(istype(ex, item_ref))
					has_item += 1 + ex.equipped
					if(ex.equipped)
						has_item-- // subtract the equipped item

			if(!has_item)
				new item_ref(usr)
			else for(var/obj/items/usable/object in usr.contents)
				if(istype(object, item_ref))
					object.equipped++
					object.Refreshcountdd(usr)

			usr << "You picked up the [src]."
			loc = null
			*/

	scrolls
		icon = 'icons/scrolls.dmi'
		double_experience
			name = "Double Experience Scroll"
			item_ref = /obj/items/usable/scrolls/double_experience
			icon_state = "Rare"

		triple_experience
			name = "Triple Experience Scroll"
			item_ref = /obj/items/usable/scrolls/triple_experience
			icon_state = "Legendary"

obj/items/usable
	scrolls
		icon = 'icons/scrolls.dmi'

		proc/Use(mob/user)

		double_experience
			name = "Double Experience Scroll"
			icon_state = "R-Scroll"
			code = 333

			Use(mob/user)
				if(usr.triple_xp_time > 0)
					usr << "You cannot stack double and triple experience."
					return
				usr.double_xp_time += 60 * 30
				usr << "The double experience scroll burns up in flames."
				usr << "Double experience gained for <strong>+30</strong> minutes."
				equipped--
				Refreshcountdd(user)
				//if(equipped <= 0)
				//	del(src)

		triple_experience
			name = "Triple Experience Scroll"
			icon_state = "L-Scroll"
			code = 334

			Use(mob/user)
				if(usr.double_xp_time > 0)
					usr << "You cannot stack double and triple experience."
					return
				usr.triple_xp_time += 60 * 30
				usr << "The triple experience scroll burns up in flames."
				usr << "Triple experience gained for <strong>+30</strong> minutes."
				equipped--
				Refreshcountdd(user)
				//if(equipped <= 0)
				//	del(src)

		Click()
			Use(usr)

mob
	var/double_xp_time = 0
	var/triple_xp_time = 0