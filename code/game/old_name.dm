mob/human/var

	show_name = 1
	tmp/image/name_img[]
var/dmifont/Cambria8pt/namefont = new

mob/human
	New()
		set waitfor = 0
		. = ..()
		//FIXME: if(src.z==2&&src.x==25&&src.y==58)src.invisibility=100
		sleep(1)
		CreateName(255, 255, 255)
	Login()
		CreateName(255, 255, 255, 0, 0, 0)
		. = ..()

	proc/CreateName(r=255, g=255, b=255, br=0, bg=0, bb=0)
		set waitfor = 0
		if(!show_name) return
		if(name=="player")return

		if(name_img && istype(name_img,/list) && name_img.len)
			for(var/image/I in name_img)
				del I

		name_img = new /list()

		var/lines = round(32 / namefont.height)

		var/txt = namefont.KeyToBreakable(html_encode(name))
		txt = namefont.GetLines(txt, width = 128, maxlines = lines, flags = DF_WRAP_ELLIPSIS)

		var/size = namefont.RoundUp32(namefont.GetWidth(txt))
		var/icon/s = namefont.DrawText(txt, size / 2, 0, width = size, maxlines = lines, flags = DF_JUSTIFY_CENTER, icons_x = size / 32, icons_y = 1)

		s.DFP_Outline(rgb(r, g, b), rgb(br, bg, bb))

		var/image_tiles = s.setwidth-s.setpadding
		var/image/I

		#if DM_VERSION < 455
		for(var/xx = 0, xx < image_tiles, ++xx)
			// Names are only one tile tall, which makes this simpler.
			I = image(icon=s, icon_state="[xx],0", loc=src, layer=FLOAT_LAYER)
			I.pixel_x = (xx + (1 - image_tiles) / 2) * 32
			I.pixel_y = 10
			name_img += I
		#else
		if(world.map_format & TILED_ICON_MAP)
			for(var/xx = 0, xx < image_tiles, ++xx)
				// Names are only one tile tall, which makes this simpler.
				I = image(icon=s, icon_state="[xx],0", loc=src, layer=FLOAT_LAYER)
				I.pixel_x = (xx + (1 - image_tiles) / 2) * 32
				I.pixel_z = 10
				name_img += I
		else
			I = image(icon=s, icon_state="", loc=src, layer=FLOAT_LAYER)
			I.pixel_x = -((s.Width()-world.IconSizeX())/2)
			I.pixel_z = 10
			name_img += I
		#endif

		if(faction)
			var/village_icon = faction.chat_icon
			if(henged || phenged)
				if(transform_chat_icon)
					village_icon = transform_chat_icon
				else village_icon = null
			I = image(icon=faction_chat[village_icon], icon_state="", loc=src, layer=FLOAT_LAYER)
			I.pixel_z = 43
			I.pixel_x=5
			name_img += I

	MouseEntered()
		if(show_name)
			for(var/image/I in name_img)
				usr.client.images += I
		. = ..()
	MouseExited()
		if(show_name)
			for(var/image/I in name_img)
				usr.client.images -= I
		. = ..()