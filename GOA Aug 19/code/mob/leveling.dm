#define MAX_LEVEL 100

mob
	var/level = 1
	var/level_points = 6
	var/body_level = 0
	var/body_level_tnl = 1000

	proc/add_experience(amount = 0)
		set waitfor = 0

		src.body_level += amount

		while(src.level < MAX_LEVEL)
			if(src.body_level >= src.body_level_tnl)
				src.body_level -= src.body_level_tnl
				src.level += 1
				src.body_level = refresh_tnl(src.level)
			else
				break

proc/refresh_tnl(var/level)
	switch(level)
		if(1 to 19) return level * level * 15
		if(20 to 29) return level * level * 20
		if(30 to 49) return level * level * 25
		if(50 to 59) return level * level * 30
		if(60 to 69) return level * level * 40
		if(70 to 79) return level * level * 50
		if(80 to 90) return level * level * 55
		if(91) return level * level * 56
		if(92) return level * level * 58
		if(93) return level * level * 60
		if(94) return level * level * 62
		if(95) return level * level * 64
		if(96) return level * level * 66
		if(97) return level * level * 68
		if(98) return level * level * 70
		if(99) return level * level * 72
		if(100) return level * level * 74