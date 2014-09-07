proc
	AwardMedal(medal, player)
		if(world.SetMedal(medal, player))
			player << "<b>You have been awarded the \"[medal]\" medal!</b>"
