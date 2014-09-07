proc/alertn(client/x,y,z,az,a1,a2,a3,a4,a5,a6)
	if(!x) return
	if(ismob(x))
		x = x:client

	if(!z)
		z=""
	var/list/zz=new/list()

	if(az)
		zz+=az
	if(a1)
		zz+=a1
	if(a2)
		zz+=a2
	if(a3)
		zz+=a3
	if(a4)
		zz+=a4
	if(a5)
		zz+=a5
	if(a6)
		zz+=a6

	while(x && x.inputting)
		sleep(1)
	if(!x) return
	x.inputting = 1

	var/answer
	if(!zz||!zz.len)
		answer=alert(x,y,z)
	else if(zz.len == 1)
		answer = alert(x, y, z, zz[1])
	else if(zz.len == 2)
		answer = alert(x, y, z, zz[1], zz[2])
	else if(zz.len == 3)
		answer = alert(x, y, z, zz[1], zz[2], zz[3])
	else
		answer=input(x,y,z) in zz
	x.inputting = 0
	return answer
proc
	input2(client/x,y,z,az)//for lists
		if(x)
			if(ismob(x))
				x = x:client
			while(x && x.inputting)
				sleep(1)
			if(!x) return
			x.inputting = 1
			var/answer = input(x, y, z) in az
			if(x) x.inputting = 0
			return answer

	input3(client/x,y,z,az)//for lists of mobs
		if(x)
			var/list/tz=new/list()
			for(var/mob/o in az)
				tz+=o.name
			if(ismob(x))
				x = x:client
			while(x && x.inputting)
				sleep(1)
			if(!x) return
			x.inputting = 1
			var/answer=input(x, y, z) in tz
			if(x) x.inputting = 0
			for(var/mob/o in az)
				if(o.name==answer)
					return o

	input4(client/x,y,z,az)//for lists of objs
		if(x)
			var/list/tz=new/list()
			for(var/obj/o in az)
				tz+=o.name
			if(ismob(x))
				x = x:client
			while(x && x.inputting)
				sleep(1)
			if(!x) return
			x.inputting = 1
			var/answer=input(x, y, z) in tz
			if(x) x.inputting = 0
			for(var/obj/o in az)
				if(o.name==answer)
					return o

	input_text(client/user,message as text, title as text, default as text, submit = "Ok" as text)
		if(ismob(user))
			user = user:client
		while(user && user.inputting)
			sleep(1)
		if(!user) return
		user.inputting = 1
		var/answer = input(user, message, title, default) as text
		if(user) user.inputting = 0
		return answer

	input_num(client/user,message as text, title as text, default as text, submit = "Ok" as text)
		if(ismob(user))
			user = user:client
		while(user && user.inputting)
			sleep(1)
		if(!user) return
		var/answer = input(user, message, title, default) as num
		if(user) user.inputting = 0
		return answer
client/var
	inputting=0