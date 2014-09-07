mob/proc/Check_Sales(mob/human/player/p)
	if(p.weight<200)
		p.shopping=1
		p.see_invisible=10
		p.canmove=0
		for(var/image/o in oview(8))
			p<<o

obj
	sale
		New()
			..()
			sleep(50)

			src.cost=round(src.cost)
			src.invisibility=10
			CostNumber(src,src.cost)

		Click()
			var/a=0
			for(var/obj/items/ex in usr.contents)
				if(istype(ex,refr))
					a+=1+ex.equipped
					if(ex.equipped)
						a-=1
			if(a<=src.limit)
				if(usr.shopping&&usr.weight<200)
					if(usr.money>=src.cost)
						usr.money-=src.cost

						if(special==0)
							spawn() alert(usr,"You Bought \a [src]")
							if(!src.stackable||a==0)
								new src.refr(usr)
							else
								for(var/obj/items/usable/tx in usr.contents)
									if(istype(tx,refr))
										tx.equipped++
										tx.Refreshcountdd(usr)

						else
							if(special=="Supplies")
								spawn() alert(usr,"You Bought some Ninja Supplies!")
								usr.supplies=usr.maxsupplies
					else
						usr<<"You don't have enough money!"
			else
				usr<<"You cannot hold more of that Item"

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

	if(length(string)>=0)
		d1=image('icons/0numbers_small.dmi',icon_state="[copytext(string,length(string),length(string)+1)]",pixel_x=-1)
		o.overlays+=d1
	if(length(string)>=2)
		d2=image('icons/0numbers_small.dmi',icon_state="[copytext(string,(length(string)-1),(length(string)))]",pixel_x=-6)
		o.overlays+=d2
	if(length(string)>=3)
		d3=image('icons/0numbers_small.dmi',icon_state="[copytext(string,(length(string)-2),(length(string)-1))]",pixel_x=-11)
		o.overlays+=d3
	if(length(string)>=4)
		d4=image('icons/0numbers_small.dmi',icon_state="[copytext(string,(length(string)-3),(length(string)-2))]",pixel_x=-16)
		o.overlays+=d4
	if(length(string)>=5)
		d5=image('icons/0numbers_small.dmi',icon_state="[copytext(string,(length(string)-4),(length(string)-3))]",pixel_x=-21)
		o.overlays+=d5
	if(length(string)>=6)
		d6=image('icons/0numbers_small.dmi',icon_state="[copytext(string,(length(string)-5),(length(string)-4))]",pixel_x=-26)
		o.overlays+=d6
