#define HUD_SCREEN_BORDER	"screen_border"
#define HUD_PLACEHOLDERS "placeholders"
#define HUD_BAR_BACKGROUND "bar_background"
#define HUD_STAMINA_BAR "stamina_bar"
#define HUD_CHAKRA_BAR "chakra_bar"
#define HUD_WOUND_BAR "wound_bar"

hud
	parent_type = /obj
	layer = HUD_LAYER

	screen_border
		icon = 'skin images/new_mapborder.png'
		screen_loc = "1, 1"

	placeholder
		icon = 'icons/new/hud/macro_slots.dmi'
		stub
			var/tmp/list/tree = list()

			proc/get_hud_bundle()
				return tree

			New()
				// outter
				var/hud/placeholder/a = new
				var/hud/placeholder/b = new

				a.icon_state = "left"
				a.screen_loc = "CENTER-5, 1:4"

				b.icon_state = "right"
				b.screen_loc = "CENTER+5, 1:4"

				tree += a
				tree += b

				var/list/screen_position = list(
					"CENTER-4:-1, 1:4",
					"CENTER-3, 1:4",
					"CENTER-2, 1:4",
					"CENTER-1, 1:4",
					"CENTER, 1:4",
					"CENTER+1, 1:4",
					"CENTER+2, 1:4",
					"CENTER+3, 1:4",
					"CENTER+4, 1:4",
					"CENTER+5, 1:4",
				)

				// slots
				for(var/i in 1 to 10)
					var/hud/placeholder/slot/s = new
					s.overlays += new/image('icons/new/hud/macro_numbers.dmi', "slot[i]", layer = HUD_LAYER + 0.002)
					s.screen_loc = screen_position[i]
					s.id = i

					tree += s
		slot
			icon_state = "slot"
			var/id

	proc/refresh(var/client/client)

	proc/reveal(var/client/client)
		client.screen += src
		refresh(client)

	proc/hide(var/client/client)
		client.screen -= src
		refresh(client)

hud_manager
	var/tmp/list/huds = list()

	proc/refresh(var/client)
		if(args.len < 2) return

		for(var/i in 2 to args.len)
			var/id = args[i]
			if(id in huds)
				if(islist(huds[id])) for(var/hud/hud in huds[id])
					hud.refresh(client)
				else
					var/hud/tmphud = huds[id]
					tmphud.refresh(client)

	proc/reveal(var/client)
		if(args.len < 2) return

		for(var/i in 2 to args.len)
			var/id = args[i]
			if(id in huds)
				if(islist(huds[id])) for(var/hud/hud in huds[id])
					hud.reveal(client)
				else
					var/hud/tmphud = huds[id]
					tmphud.reveal(client)

	proc/hide(var/client)
		if(args.len < 2) return

		for(var/i in 2 to args.len)
			var/id = args[i]
			if(id in huds)
				if(islist(huds[id])) for(var/hud/hud in huds[id])
					hud.hide(client)
				else
					var/hud/tmphud = huds[id]
					tmphud.hide(client)

	proc/store(var/id, var/hud_path)
		if(!ispath(hud_path)) return

		var/hud/hud = new hud_path

		if(hascall(hud, "get_hud_bundle"))
			hud = call(hud, "get_hud_bundle")()

		huds[id] = hud

	proc/initiate()
		store(HUD_SCREEN_BORDER, /hud/screen_border)
		store(HUD_PLACEHOLDERS, /hud/placeholder/stub)//placeholders
		store(HUD_STAMINA_BAR, /hud/bar/stamina)
		store(HUD_CHAKRA_BAR, /hud/bar/chakra)
		store(HUD_WOUND_BAR, /hud/bar/wound)
		store(HUD_BAR_BACKGROUND, /hud/bar_background)

var/global/hud_manager/hud_manager = new