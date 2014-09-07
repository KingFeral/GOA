// A few useful procs defined of /world to get X- and Y- components of world.view and world.icon_size

world
	proc
		// Returns horizontal view size (in tiles)
		ViewSizeX()
			if(istext(world.view))
				return text2num(copytext(world.view, 1, findtext(world.view, "x")))
			else
				return world.view * 2 - 1

		// Returns vertical view size (in tiles)
		ViewSizeY()
			if(istext(world.view))
				return text2num(copytext(world.view, findtext(world.view, "x")+1))
			else
				return world.view * 2 -1

#if DM_VERSION>=455
		// Returns horizontal tile size (in pixels)
		IconSizeX()
			if(istext(world.icon_size))
				return text2num(copytext(world.icon_size, 1, findtext(world.icon_size, "x")))
			else
				return world.icon_size

		// Returns vertical tile size (in pixels)
		IconSizeY()
			if(istext(world.icon_size))
				return text2num(copytext(world.icon_size, findtext(world.icon_size, "x")+1))
			else
				return world.icon_size
#else
		// Returns horizontal tile size (in pixels)
		IconSizeX()
			return 32

		// Returns vertical tile size (in pixels)
		IconSizeY()
			return 32
#endif

// /client versions of /world/ViewSize procs
client
	proc
		// Returns horizontal view size (in tiles)
		ViewSizeX()
			if(istext(view))
				return text2num(copytext(view, 1, findtext(view, "x")))
			else
				return view * 2 - 1

		// Returns vertical view size (in tiles)
		ViewSizeY()
			if(istext(view))
				return text2num(copytext(view, findtext(view, "x")+1))
			else
				return view * 2 -1