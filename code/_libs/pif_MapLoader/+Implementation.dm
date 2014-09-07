//These are variables and variable-related functions that aren't
//part of the /dynamic_map datum but are still essential to the
//proper functioning of the library.

world/New()
	..()

	maxx_revert_size = world.maxx
	maxy_revert_size = world.maxy
	maxz_revert_size = world.maxz

var
	maxx_revert_size
	maxy_revert_size
	maxz_revert_size

	list/dynamic_maps = new

datum
	var
		skip_save = 0
		skip_delete = 0

area/skip_delete = 1

client
	var
		skip_save = 1
		skip_delete = 1

//These functions are used in several different places within the
//program, and they don't constitute being part of the /dynamic_map
//datum, so they are placed here.

proc/file_into_chunk(file, lowx, lowy, lowz, highx, highy, highz)
	var
		z_counter = 0

		file_data = file2text(file)
	. = copytext(file_data, 1, findtext(file_data, "(1,1,1)") - 3)

	for(var/z = lowz, z <= highz, z ++)
		var
			beginning = findtext(file_data, "(1,1,[z])") + 13
			section = copytext(file_data, beginning, findtext(file_data, "\"}", beginning) - 1)

			previous = 1
			location = findtext(section, "\n")

		. += "\n\n(1,1,[++ z_counter]) = {\"\n"

		for(var/a = 1 to highy)
			if(a >= lowy) . += copytext(section, previous + lowx - 1, previous + highx) + "\n"

			previous = location + 1
			location = findtext(section, "\n", location + 1)

		. += "\"}"

#ifndef FIZZY_SECTION
#define FIZZY_SECTION

proc/section(atom/low, atom/high)
	. = list()

	for(var/z = low.z to high.z)
		var/list/block = block(locate(low.x, low.y, z), locate(high.x, high.y, z))

		for(var/atom/t in block)

			if(t.loc && !(t.loc in .)) . += t.loc
			for(var/atom/a in t) if(!(a in .)) . += a

		. += block

#endif

#ifndef FIZZY_SORT
#define FIZZY_SORT

#define ASCENDING	 1
#define DESCENDING	-1

proc/sort(list/l, order = 1)
	. = list()

	while(l.len)
		var/element = (order > 0 ? min(l) : max(l))

		.[element] = l[element]
		l -= element

#endif

#ifndef FIZZY_COMPRESS_TEXT
#define FIZZY_COMPRESS_TEXT

proc/compress_text(string)
	var/len = length(string)
	var/e,f
	for(var/a = 1, a <= len, a ++)
		if(text2ascii(string,a) != 32)
			if(!e)
				e = a
				a --
			else f = a + 1
	if(!e && !f) return ""
	if(e) return copytext(string,e,f)
	return string

#endif

#ifndef	FIZZY_ESCAPE_SEQUENCE
#define	FIZZY_ESCAPE_SEQUENCE

proc/parse_escape_sequences(string)
	var
		length = length(string)

		previous = 1
		a = 1
	for(a, a <= length, a ++)
		if(text2ascii(string, a) == 92)
			. += copytext(string, previous, a)

			var/suppression
			switch(text2ascii(string, a + 1))
				if(32) continue		// space
				if(34)  . += "\""	// "
				if(60)  . += "\<"	// <
				if(62)  . += "\>"	// >
				if(91)  . += "\["	// [
				if(92)  . += "\\"	// backslash
				if(110) . += "\n"	// n
				if(116) . += "\t"	// t
				if(46)				// newline suppression
					if(text2ascii(string, a + 2) == 46 && text2ascii(string, a + 3) == 46)
						. += "\..."
						suppression = 1

					else CRASH("Unknown escape sequence (\"\\[copytext(string, a + 1, a + 2)]\") found.")
				else CRASH("Unknown escape sequence (\"\\[copytext(string, a + 1, a + 2)]\") found.")

			previous = a + (suppression ? 4 : 2)
			a += suppression ? 3 : 1

	. += copytext(string, previous)

#endif

#ifndef	FIZZY_COPY_OBJECT
#define	FIZZY_COPY_OBJECT

datum/var/list/__NEW__

proc/copy_object(datum/source, location, copy_internal_objects = 1)
	if(istype(source, /list)) return source:Copy()
	if(istype(source, /savefile)) return new/savefile(source:name)

	if(istype(source))
		var/datum/copy
		if(source.__NEW__)
			var/list/arguments = source.__NEW__.Copy()
			arguments.Insert(1, location)
			copy = new source.type(arglist(arguments))
		else copy = new source.type(location)

		for(var/a in source.vars - "vars" - "parent_type" - "type" - "verbs" - "__NEW__")
			if(copy_internal_objects && (istype(source.vars[a], /datum) || istype(source.vars[a], /savefile) || \
			   istype(source.vars[a], /client)))
				copy.vars[a] = .(source.vars[a])

			else copy.vars[a] = source.vars[a]

		return copy

#endif

//These are simple macros that perform basic functions which
//are simply tedious to type.

#define INTERNAL_CRASH(output, src)		world.log << "Map handling error ([src.id]): [output]"; del src
#define SLEEP_ON_LOOP(x)				if(loop_amount && !((x) % loop_amount)) sleep(sleep_time)
#define num2letter(x)					ascii2text(x + 96 - (x > 26 && 58))
#define isobject(x)						(istype(x, /datum) || istype(x, /savefile) || istype(x, /client))

//These are macros that represent numbers for bitflags for
//the /dynamic_map datum.

#define SKIP_NONE						0
#define SKIP_AREA						1
#define SKIP_TURF						2
#define SKIP_STATIC						3
#define SKIP_NONMOVABLE					3
#define SKIP_OBJ						4
#define SKIP_MOB						8
#define SKIP_MOVABLE					12
#define SKIP_CLIENT						16

#define AREA							1
#define TURF							2
#define STATIC							3
#define NONMOVABLE						3
#define OBJ								4
#define MOB								8
#define MOVABLE							12
#define CLIENT							16
#define SKIP_ALL_BUT_(x)				(31 & ~(x))

#define LOAD_ON_READ					0
#define READ_IN_ONLY					64

#define REPLACE_AREA_ON_DELETE			128
#define	RESET_MAX_COORDINATES			256

#define	LOAD_AT_BLOCK					0
#define	APPEND_TO_LOW_EDGE				1
#define	APPEND_TO_HIGH_EDGE				2
#define	APPEND_TO_NEXT_Z				4