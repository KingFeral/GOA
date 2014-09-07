character
	parent_type = /MapPaths/Pather
	icon = 'media/base/base_white.dmi'

	Login()
		src.client.set_focus(src)
		. = ..()