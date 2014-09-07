mob/var
	list/oppo=new/list()
	tmp/risk=0

mob/proc/register_opponent(mob/human/O)
	set waitfor = 0
	var/K
	if(!src.client)return
	if(O.client && !same_client(O, src))
		K = O.client.computer_id
	else
		return
	if(!src.oppo["[K]"] || src.oppo["[K]"] < world.time)
		src.oppo["[K]"] = world.time + 6000
		++src.risk
		sleep(10 * 60 * 10)
		if(!src)
			return
		--src.risk


proc/time2hours()
	var/D=text2num(time2text(world.realtime,"DD"))
	var/H=text2num(time2text(world.realtime,"hh"))
	return D*24 + H
