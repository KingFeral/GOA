character
	key_down(k, client/client)
		if(k in global.movement_keys)
			src.client.begin_movement()
		else
			if(k in global.key_commands)
				var/key_command = global.key_commands[k]
				if(hascall(src, "[key_command]_down"))
					call(src, "[key_command]_down")()
			else if(hascall(src, "[k]_down"))
				call(src, "[k]_down")()

	key_up(k, client/client)
		if(k in global.key_commands)
			var/key_command = global.key_commands[k]
			if(hascall(src, "[key_command]_up"))
				call(src, "[key_command]_up")()
		else if(hascall(src, "[k]_up"))
			call(src, "[k]_up")()

var/global/list/key_commands = list(
	"a" = "attack",
	"d" = "defend",
	"f" = "activate",
	"u" = "untarget",
	"q" = "target_nearest",
	"w" = "target_farthest",
	"space" = "interact",
	"1" = "macro1",
	"2" = "macro2",
	"3" = "macro3",
	"4" = "macro4",
	"5" = "macro5",
	"6" = "macro6",
	"7" = "macro7",
	"8" = "macro8",
	"9" = "macro9",
	"0" = "macro10",
)