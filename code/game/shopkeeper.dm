mob/proc/Check_Sales(mob/human/player/p)
	//if(p.weight<200)
	p.shopping=1
	p.see_invisible=10
	p.canmove=0
	for(var/image/o in oview(8))
		p<<o

obj
	sale
		var
			currency = "Ryo"
			details = ""
		New()
			..()
			sleep(50)

			src.cost=round(src.cost)
			src.invisibility=10
			CostNumber(src,src.cost)

		Click()
			if(usr.shopping)
				var/brief = ""
				if(details) brief += "[name]: [details]\n\n"
				brief += "Are you sure you want to purchase [src] for [cost] [currency]?"
				if(alert(usr, brief, "Market", "Yes", "No") == "Yes")
					if(!special)
						var/a=0
						for(var/obj/items/ex in usr.contents)
							if(istype(ex,refr))
								a+=1+ex.equipped
								if(ex.equipped)
									a-=1
						if(!(a<=src.limit))
							usr<<"You cannot hold more of that Item"
							return 0

						switch(currency)
							if("Ryo")
								if(usr.money < cost)
									return
								usr.money -= cost
							if("Faction Points")
								if(usr.factionpoints < cost)
									return
								usr.factionpoints -= cost

						if(!stackable || !a)
							new refr(usr)
						else for(var/obj/items/usable/object in usr.contents)
							if(istype(object, refr))
								object.equipped++
								object.Refreshcountdd(usr)
					else
						usr << "You Bought some Ninja Supplies!"
						usr.supplies = usr.maxsupplies


obj/proc/CostNumber(obj/o,num)
	if(num>999999)
		num=999999
	var/string=num2text(num,7)

	var/image/d1
	var/image/d2
	var/image/d3
	var/image/d4
	var/image/d5
	var/image/d6

	var/i = 'icons/0numbers_small.dmi'

	//if(istype(src, /obj/sale/feudal)) i = '0numbers_feudal.dmi'
	var/obj/sale/s = src
	if(s.currency == "Faction Points") i = 'icons/0numbers_faction_points.dmi'

	if(length(string)>=6)
		d6=image(i,icon_state="[copytext(string,(length(string)-5),(length(string)-4))]",pixel_x=-26)
		o.overlays+=d6
	if(length(string)>=5)
		d5=image(i,icon_state="[copytext(string,(length(string)-4),(length(string)-3))]",pixel_x=-21)
		o.overlays+=d5
	if(length(string)>=4)
		d4=image(i,icon_state="[copytext(string,(length(string)-3),(length(string)-2))]",pixel_x=-16)
		o.overlays+=d4
	if(length(string)>=3)
		d3=image(i,icon_state="[copytext(string,(length(string)-2),(length(string)-1))]",pixel_x=-11)
		o.overlays+=d3
	if(length(string)>=2)
		d2=image(i,icon_state="[copytext(string,(length(string)-1),(length(string)))]",pixel_x=-6)
		o.overlays+=d2
	if(length(string)>=0)
		d1=image(i,icon_state="[copytext(string,length(string),length(string)+1)]",pixel_x=-1)
		o.overlays+=d1
