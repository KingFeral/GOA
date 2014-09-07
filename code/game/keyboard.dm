
// File:    keyboard.dm
// Library: Forum_account.Sidescroller
// Author:  Forum_account
//
// Contents:
//   This file handles keyboard input. It adds keyboard macros
//   at runtime which call the KeyUp and KeyDown verbs. These
//   verbs call the key_up and key_down procs which you can
//   override to create new input behavior.

var/movement_key_to_dir[] = list("north" = NORTH,"east" = EAST,"south" = SOUTH,"west" = WEST,"northeast" = NORTHEAST,"northwest" = NORTHWEST,"southeast" = SOUTHEAST,"southwest" = SOUTHWEST)

mob
	var
		//building
		//building_over
		tmp/list/keys = list()
		tmp/list/movement_keys = list("north","east","south","west","northeast","northwest","southeast","southwest")
		input_lock = 0

	proc
		// You can override the key_down and key_up procs
		// to add new commands.
		key_down(k)
			/*if(building && building_over)
				if(k=="north")client.North()
				else if(k=="east")client.East()
				else if(k=="south")client.South()
				else if(k=="west")client.West()*/

			if(k in movement_keys)
				client.key_dir |= movement_key_to_dir[k]
				if(!client.moving) client.Start_Move()

		key_up(k)
			..(k)
			if(k in movement_keys)
				client.key_dir &= ~movement_key_to_dir[k]

		// While input is locked the KeyUp/KeyDown verbs still get called
		// but they don't call the key_up/key_down procs.
		lock_input()
			input_lock += 1

		unlock_input()
			input_lock -= 1
			if(input_lock < 0)
				input_lock = 0

		clear_input(unlock_input = 1)
			if(unlock_input)
				input_lock = 0
			for(var/k in keys)
				keys[k] = 0

	// These verbs are called for all key press and release events,
	// k is the key being pressed or released.
	verb
		KeyDown(k as text)
			set hidden = 1
			set instant = 1
			if(input_lock) return

			keys[k] = world.time
			key_down(k)

		KeyUp(k as text)
			set hidden = 1
			set instant = 1

			keys[k] = 0
			if(input_lock) return

			key_up(k)

client
	var/tmp/moving
	var/tmp/key_dir = 0

	proc/Start_Move()
		set waitfor = 0
		if(moving)
			return
		moving = TRUE

		do
			/*if(mob.keys["north"]) d |= NORTH
			if(mob.keys["northeast"]) d |= NORTHEAST
			if(mob.keys["northwest"]) d |= NORTHWEST
			if(mob.keys["south"]) d |= SOUTH
			if(mob.keys["southeast"]) d |= SOUTHEAST
			if(mob.keys["southwest"]) d |= SOUTHWEST
			if(mob.keys["east"]) d |= EAST
			if(mob.keys["west"]) d |= WEST*/
			//Move(get_step(mob.loc,key_dir), key_dir)
			step(mob, key_dir)
			//d = 0
			sleep(1)
		while(key_dir)

		moving = FALSE