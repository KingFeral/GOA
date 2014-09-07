

proc/debug()
	for(var/message in args)
		var/out_message = "DEBUG: [message]"
		world     << out_message
		world.log << out_message

/*
mob/verb/makeangles()
	if(key != "FKI")
		return
	var/icon/I=new(input(usr,"pick an icon")as icon)
	var/i=180
	while(i>=-180)
		var/angle=i
		var/icon/I2 = new(I)
		I2.Turn(angle)
		I.Insert(I2,"[i]")
		i-=10
	usr<<ftp(I,"[I.icon]")


mob/verb/makebars()
	if(key != "FKI")
		return
	var/icon/i = icon('bar.dmi')
	var/icon/j
	var/icon/building = icon()
	var/iwidth = i.Width()
	var/iheight = i.Height()
	for(var/count=0;count<=100;count++)
		j = icon(i)
		j.Crop(1,1,round(iwidth*(count/100)),iheight)
		j.Crop(1,1,iwidth,iheight)
		building.Insert(j,"[count]")

	usr << ftp(building,"bar.dmi")*/


player
	Login()
		..()
		for(var/skill/j in all_skills)
			if(j.id)
				AddSkill(j.id)

		for(var/item_id in global.item_spawners)
			give_item(item_id, src)

		src.update_grids()

	verb
		test()
			debug("stalled")
			return



		test2()
			var/icon/i = icon('media/jutsu/dull.dmi')
			var/icon/j
			var/icon/building = icon()
			var/iwidth = i.Width()
			var/iheight = i.Height()
			for(var/count=0;count<=32;count++)
				j = icon(i)
				j.Crop(1,1,iwidth,round(iheight*(count/32)))
				j.Crop(1,1,iwidth,iheight)
				building.Insert(j,"[count]")

			usr << ftp(building,"media/obj/extras/dull2.dmi")

mob
	proc/refresh_inventory()
		if(!src.client) return

		. = 0
		src << output("Armor Count: [armor_count] \nSpecial Supplies: [special_supplies]", "inventorypane.grid:[++.]")
		for(var/item/i in contents)
			src << output(i, "inventorypane.grid:[++.]")

		winset(src, "inventorypane.grid", "cells = [.]")