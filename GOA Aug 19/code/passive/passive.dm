mob
	var/tmp/list/passives = list()

client/var/list/passive_imgs   = list()
client/var/list/_passive_cache = list()

client/proc/Passive_Refresh(var/passive/Of)
	var/combatant/mob = src.mob

	_passive_cache.len = mob.passives.len
	passive_imgs.len = mob.passives.len

	var/lvln=mob.passives[Of.id]
	if(!lvln || lvln < 0)
		lvln = 0

	if(_passive_cache[Of.id] == lvln)
		return

	for(var/image/I in passive_imgs[Of.id])
		images -= I

	var/lvl = "[lvln]"

	if(length(lvl)<=1)
		var/image/I = Of.digit1[lvl]

		passive_imgs[Of.id] = list(I)
		src << I
		_passive_cache[Of.id] = lvln

	else
		var/dig1 = copytext(lvl,1,2)
		var/dig2 = copytext(lvl,2)
		var/image/I1 = Of.digit1["[dig2]"]
		var/image/I2 = Of.digit2["[dig1]"]

		passive_imgs[Of.id] = list(I1, I2)
		src << I1
		src << I2
		_passive_cache[Of.id] = lvln

passive
	parent_type = /obj
	icon = 'passives.dmi'
	var/id
	var/tmp/description
	var/tmp/maximum
	var/tmp/list/digit1 = list()
	var/tmp/list/digit2 = list()

	New()
		..()
		digit1["1"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="1",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["2"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="2",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["3"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="3",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["4"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="4",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["5"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="5",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["6"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="6",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["7"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="7",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["8"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="8",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["9"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="9",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit1["0"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="0",pixel_x=16,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["1"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="1",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["2"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="2",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["3"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="3",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["4"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="4",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["5"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="5",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)
		digit2["0"] = new/image('media/font/font_cambria.dmi',loc=src.loc,icon_state="0",pixel_x=10,pixel_y=-20,layer=MOB_LAYER+10)

	Click()
		//var/player/user

		//TODO