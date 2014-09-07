initial
	parent_type = /mob

	Login()
		src << "Welcome to the official Naruto GOA server!"

		var/initial/old_mob = src

		client.mob = new/player(locate_tag("start"))

		old_mob.dispose()