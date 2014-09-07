client
	var/tmp/current_macro_set = 1
	var/tmp/list/macro_set = list(
		list(null,null,null,null,null,null,null,null,null,null),
		list(null,null,null,null,null,null,null,null,null,null),
	)

mob
	proc/tab_down()
		for(var/drag_obj/d in client.macro_set[client.current_macro_set])
			client.screen -= d

		if(client.current_macro_set == 1)
			client.current_macro_set++
		else
			client.current_macro_set = 1

		for(var/drag_obj/d in client.macro_set[client.current_macro_set])
			client.screen += d

mob
	proc/macro1_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][1]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)

	proc/macro2_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][2]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)

	proc/macro3_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][3]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)

	proc/macro4_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][4]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)

	proc/macro5_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][5]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)

	proc/macro6_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][6]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)

	proc/macro7_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][7]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)

	proc/macro8_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][8]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)

	proc/macro9_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][9]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)

	proc/macro10_down()
		var/drag_obj/d = client.macro_set[client.current_macro_set][10]
		if(d && hascall(d, "macro_activate"))
			call(d, "macro_activate")(usr)
