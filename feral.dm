mob
	verb/test()
		if(ckey != "fki")
			return 0
		if(someproc())
			usr << "SUCCESSFUL TEST"
		else
			usr << "FAILED TEST"

	proc/someproc()
		set waitfor = 0
		var/i = 0
		for()
			i++
			if(i > 10)
				return 1
			sleep(1)
