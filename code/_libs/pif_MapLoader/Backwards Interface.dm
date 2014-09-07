#ifdef	PIF_MAPLOADER_COMPATABILITY_2

/*

This is an interface that allows pif_MapLoader 2.x developer
functions to work correctly using pif_MapLoader 3.0's new functions.
Unfortunately, some changes that have been made aren't reconcilable, so
not everything will work. Anything done directly with 2.x's /map or
/chunk datums will have to be reworked, for example

To interface with 3.0, simply include the following line somewhere in
your code:
#define PIF_MAPLOADER_COMPATABILITY_2


o	Notes
	o	Using this interface, any pif_MapLoader 2.x functions with
		the same name as a pif_MapLoader 3.0 function must be used
		exclusively in the pif_MapLoader 2.x context, or else there will
		be errors.

	o	Only one set of arguments can be used for procedures like
		load_map(). Different uses have now been given different functions
		that will have to be used instead.

*/

#define	map_boundaries(id)													map_corners(id)
#define	load_map(file, id, low)												_load_map(id, file, low)
#define	set_clear_load_lists(id, clear)										set_load_data_handling(id, clear)
#define	set_clear_save_lists(id, clear)										set_save_data_handling(id, clear)
#define save_section(file, low, high, preferences)							save_map_chunk(low, high, file, preferences)
#define load_chunk(file, id, lowx, lowy, lowz, highx, highy, highz, low)	_load_chunk(low, id, null, file, lowx, lowy, lowz, \
																			highx, highy, highz)

proc
	set_reset_max_coordinates(id, reset = null)
		var/dynamic_map/map = find_map(id)
		if(map)
			if(reset == null)
				if(map.delete_preferences & RESET_MAX_COORDINATES) map.delete_preferences &= ~RESET_MAX_COORDINATES
				else map.delete_preferences |= RESET_MAX_COORDINATES

				return

			map.delete_preferences = (map.delete_preferences & ~RESET_MAX_COORDINATES) & (reset && RESET_MAX_COORDINATES)

	save_maps(list/exclusions) save_all_maps(exclusions, args.Copy(2))
	delete_maps() delete_all_maps(args)
	save_and_delete_maps(list/exclusions) save_and_delete_all_maps(exclusions, args.Copy(2))

#endif