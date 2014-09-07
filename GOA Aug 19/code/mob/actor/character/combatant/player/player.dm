player
	parent_type = /combatant

	Login()
		..()

		hud_manager.reveal(src.client,
		HUD_SCREEN_BORDER,
		HUD_PLACEHOLDERS,
		HUD_BAR_BACKGROUND,
		HUD_STAMINA_BAR,
		HUD_CHAKRA_BAR,
		HUD_WOUND_BAR,
		)

		global.players += src

	Logout()
		set waitfor = 0

		//if(src.combat_flagged())

		global.players -= src

		del(src)

var/global/list/players = list()
//var/global/list/unreadable_variables = list("type","parent_type","verbs","vars","group","loc","locs","key","ckey")