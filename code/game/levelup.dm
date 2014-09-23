mob/human/var/tmp
	_img_str_cache
	_img_con_cache
	_img_int_cache
	_img_rfx_cache
	_img_levelpoints_cache
	_img_skillpoints_cache


mob/human/proc/Refresh_Stat_Screen()
	set waitfor = 0
	//if(!EN[9])
	//	return
	if(!src)
		return
	if(!client)
		return
	if(_img_str_cache != round(str))
		//del Screen_Num[4]
		if(Screen_Num[4])
			var/image/cache_image = Screen_Num[4]
			cache_image.loc = null
		var/turf/over_loc = locate_tag("maptag_skilltree_str")
		Screen_Num[4]=DisplayNumber(over_loc.x,over_loc.y,over_loc.z,round(str))
		_img_str_cache = round(str)
	if(_img_con_cache != round(con))
		if(Screen_Num[5])
			var/image/cache_image = Screen_Num[5]
			cache_image.loc = null
		var/turf/over_loc = locate_tag("maptag_skilltree_con")
		Screen_Num[5]=DisplayNumber(over_loc.x,over_loc.y,over_loc.z,round(con))
		_img_con_cache = round(con)
	if(_img_int_cache != round(int))
		if(Screen_Num[6])
			var/image/cache_image = Screen_Num[6]
			cache_image.loc = null
		var/turf/over_loc = locate_tag("maptag_skilltree_int")
		Screen_Num[6]=DisplayNumber(over_loc.x,over_loc.y,over_loc.z,round(int))
		_img_int_cache = round(int)
	if(_img_rfx_cache != round(rfx))
		if(Screen_Num[7])
			var/image/cache_image = Screen_Num[7]
			cache_image.loc = null
		var/turf/over_loc = locate_tag("maptag_skilltree_rfx")
		Screen_Num[7]=DisplayNumber(over_loc.x,over_loc.y,over_loc.z,round(rfx))
		_img_rfx_cache = round(rfx)

	//Refresh_Gold()
	Refresh_Levelpoints()
	Refresh_Skillpoints()

mob/human/proc/Refresh_Levelpoints()
	if(_img_levelpoints_cache != levelpoints)
		if(Screen_Num[1])
			var/image/cache_image = Screen_Num[1]
			cache_image.loc = null
		var/turf/over_loc = locate_tag("maptag_skilltree_attrib")
		Screen_Num[1]=DisplayNumberO(over_loc.x,over_loc.y,over_loc.z,levelpoints,"levelpoints")
		_img_levelpoints_cache = levelpoints

mob/human/proc/Refresh_Skillpoints()
	if(_img_skillpoints_cache != skillpoints)
		if(Screen_Num[2])
			var/image/cache_image1 = Screen_Num[2]
			cache_image1.loc = null
		if(Screen_Num[3])
			var/image/cache_image1 = Screen_Num[3]
			cache_image1.loc = null
		var/turf/over_loc = locate_tag("maptag_skilltree_skillpoints_clan")
		Screen_Num[2]=DisplayNumberO(over_loc.x,over_loc.y,over_loc.z,skillpoints,"skillpoints")
		over_loc = locate_tag("maptag_skilltree_skillpoints_nonclan")
		Screen_Num[3]=DisplayNumberO(over_loc.x,over_loc.y,over_loc.z,skillpoints,"skillpoints")
		_img_skillpoints_cache = skillpoints

image/var
	group=0
mob/var/jashinfix=0

mob/human/proc/Level_Up(S)
	if(clan == "Genius")
		src.skillpoints+=55
		if(S == "int") src.skillpoints+=98

	else if(clan == "Jashin")
		src.skillpoints+=25
		if(S == "int") src.skillpoints+=19
	else
		src.skillpoints+=45
		if(S == "int") src.skillpoints+=35

	if(!(levelpoints % 6))
		var/clan_divider = (src.clan == "Genius") ? (8) : (10)
		if((++str - 50) % clan_divider == 0) skillspassive[STRENGTH]++
		if((++con - 50) % clan_divider == 0) skillspassive[CONTROL]++
		if((++rfx - 50) % clan_divider == 0) skillspassive[REFLEX]++
		if((++int - 50) % clan_divider == 0) skillspassive[INTELLIGENCE]++

	src.Refresh_Stat_Screen()

	for(var/obj/gui/passives/gauge/Q in global.passives)
		if(Q.pindex==CONTROL || Q.pindex==STRENGTH || Q.pindex==INTELLIGENCE || Q.pindex==REFLEX)
			var/client/C=src.client
			if(C)C.Passive_Refresh(Q)

	//Refresh_Levelpoints()
	//Refresh_Skillpoints()

mob/var/list/Screen_Num//[10]
mob/proc/DisplayNumber(dx,dy,dz,num,group)
	if(num>999999)
		num=999999
	var/string=num2text(round(num),7)

	var/image/d1


	if(length(string)>=1)
		d1=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,length(string),length(string)+1)]",pixel_x=0)
		src<<d1
		src.Imgs+=d1
		d1.group=group
	if(length(string)>=2)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-1),(length(string)))]",pixel_x=-6)
	if(length(string)>=3)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-2),(length(string)-1))]",pixel_x=-12)
	if(length(string)>=4)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-3),(length(string)-2))]",pixel_x=-18)
	if(length(string)>=5)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-4),(length(string)-3))]",pixel_x=-24)
	if(length(string)>=6)
		d1.overlays+=image('icons/0numbers_small.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-5),(length(string)-4))]",pixel_x=-30)
	return d1
mob/proc/DisplayNumberO(dx,dy,dz,num,group)
	if(num>999999)
		num=999999
	var/string=num2text(round(num),7)

	var/image/d1


	if(length(string)>=1)
		d1=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,length(string),length(string)+1)]")
		src<<d1
		src.Imgs+=d1
		d1.group=group
	if(length(string)>=2)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-1),(length(string)))]",pixel_x=-12)
	if(length(string)>=3)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-2),(length(string)-1))]",pixel_x=-24)
	if(length(string)>=4)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-3),(length(string)-2))]",pixel_x=-36)
	if(length(string)>=5)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-4),(length(string)-3))]",pixel_x=-48)
	if(length(string)>=6)
		d1.overlays+=image('icons/0numbers.dmi',locate(dx,dy,dz),icon_state="[copytext(string,(length(string)-5),(length(string)-4))]",pixel_x=-60)
	return d1

obj/digit
	icon='icons/0numbers.dmi'


obj/gui/fakecards/arrow/Click(location, control, params)
	//var/result[] = params2list(params)
	if(usr.keys["shift"]) // right-clicked.
		if(hascall(src, "on_shift_click"))
			call(src, "on_shift_click")(usr)
	else
		..()

obj/gui/fakecards/arrow
	proc/get_stat_name()
		switch(name)
			if("str_uparrow") return "Strength"
			if("rfx_uparrow") return "Reflex"
			if("int_uparrow") return "Intelligence"
			if("con_uparrow") return "Control"

mob
	verb/addpoints()
		var/mob/user = src

		if (user.initialized)
			var
				list
					increase_stats = list(
											"Control",
											"Strength",
											"Intelligence",
											"Reflex"
										)

			var
				choose_stat = input("What stat do you want to increase?") as anything in increase_stats | null
				invest_points = input(user, "How many Attribute Points do you want to invest in [choose_stat]?") as num | null

			invest_points = min(invest_points, usr.levelpoints)

			if (invest_points < 1)
				user << "You did not input a sufficient amount of points."
				return

			if (user.levelpoints >= 1)
				for (var/b = invest_points, b >= 1, b--)
					if(choose_stat == "Control")
						if(!user.increase_con()) break
					else if(choose_stat == "Strength")
						if(!user.increase_str()) break
					else if(choose_stat == "Reflex")
						if(!user.increase_rfx()) break
					else if(choose_stat == "Intelligence")
						if(!user.increase_int()) break
					if (user.levelpoints <= 0 || !user)
						break
				if(user&&user.client)
					//user.client.updateSkilltreeHub()
					for(var/obj/gui/passives/passive in world)
						user.client.Passive_Refresh(passive)