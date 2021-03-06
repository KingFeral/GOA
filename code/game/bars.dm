client
	var/tmp/stamina_state = 0
	var/tmp/chakra_state = 0
	var/tmp/wound_state = 0

hud
	bar_background
		icon = 'icons/new/hud/background.dmi'
		layer = HUD_LAYER - 0.001
		screen_loc = "WEST:16, NORTH - 2:16"

hud/bar
	stamina
		hide(var/client/client)
			if(client.stamina_state)
				client.screen -= global.stamina_bar[client.stamina_state]
			client.stamina_state = 0

		refresh(var/client/client)
			if(client.stamina_state)
				client.screen -= global.stamina_bar[client.stamina_state]

			var/mob/mob = client.mob
			var/bar_state = max(0, min(99, round((mob.curstamina / mob.stamina) * 100))) + 1
			client.screen += global.stamina_bar[bar_state]
			client.stamina_state = bar_state

	New()
		for(var/index in 1 to global.stamina_bar.len)
			var/atom/movable/b = new(null)
			b.screen_loc = "WEST+2:5, NORTH:-7"
			b.icon = 'icons/new/hud/stamina_bar.dmi'
			b.icon_state = "[index]"
			b.layer = HUD_LAYER

			global.stamina_bar[index] = b

	chakra
		hide(var/client/client)
			if(client.chakra_state)
				client.screen -= global.chakra_bar[client.chakra_state]
			client.chakra_state = 0

		refresh(var/client/client)
			if(client.chakra_state)
				client.screen -= global.chakra_bar[client.chakra_state]

			var/mob/mob = client.mob
			var/bar_state = max(0, min(99, round((mob.curchakra / mob.chakra) * 100))) + 1
			client.screen += global.chakra_bar[bar_state]
			client.chakra_state = bar_state

		New()
			for(var/index in 1 to global.chakra_bar.len)
				var/atom/movable/b = new(null)
				b.screen_loc = "WEST+2:-7, NORTH-1:10"
				b.icon = 'icons/new/hud/chakra_bar.dmi'
				b.icon_state = "[index]"
				b.layer = HUD_LAYER

				global.chakra_bar[index] = b

	wound
		hide(var/client/client)
			if(client.wound_state)
				client.screen -= global.wound_bar[client.wound_state]
			client.wound_state = 0

		refresh(var/client/client)
			if(client.wound_state)
				client.screen -= global.wound_bar[client.wound_state]

			var/mob/mob = client.mob
			var/bar_state = max(0, min(99, round((mob.curwound/ mob.maxwound) * 100))) + 1
			client.screen += global.wound_bar[bar_state]
			client.wound_state = bar_state

		New()
			for(var/index in 1 to global.wound_bar.len)
				var/atom/movable/b = new(null)
				b.screen_loc = "WEST:16, NORTH-2:16"
				b.icon = 'icons/new/hud/wound_bar.dmi'
				b.icon_state = "[index]"
				b.layer = HUD_LAYER

				global.wound_bar[index] = b

var/global/list/stamina_bar[100]
var/global/list/chakra_bar[100]
var/global/list/wound_bar[100]