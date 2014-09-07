/*
pif_MapLoader by Popisfizzy
	Current Version: 3.01 BETA
	Release Date: February 25, 2008

This library comes as-is, with absolutely no warranty on the libary, in
part or in whole. Feel free to modify, edit, optimize, destroy, etc.
as you wish. If the library is rendered unworkable due to edits, I give
no guarantee or warrantee on fixing it. There are few comments for the
library, and I will not help you figure out how it works. If you don't
understand it, chances are you shouldn't edit it.

Though it is not required, if this library is used, in part or in
whole, it would be nice for some mention.

-----------------------------------------------------------------------
Index:

o	Description
	A brief description of the library and its uses.

o	Release Notes
	Release notes on the various version. This includes modifications
	to the code, bug fixes, and additions.

o	Notes
	Notes on features or aspects of the code.

o	To Do
	Notes on stuff that has to be added or fixed.

o	Development Procedures
	This is the documentation of the built-in development procedures,
	used by the developer. This includes the name of the procedure,
	what it does, what it returns its arguments, and, occasionally,
	notes on the procedure.

	This section, as well as "Constants/Macros", and possibly
	"Notes" and "Release Notes", should cover the basics . Further
	sections are for those that want to modify the library to do things
	that aren't built-in and standard, or want to work with the core of
	the library.

o	Constants/Macros
	A list of all constants (preprocessor or otherwise) used by the
	library, as well as preprocessor macros. Included is their purpose,
	and other relevant data.

o	/dynamic_map Procedures
	This contains a list of all procedures of the /dynamic_map datum.
	Included are the names of the procedures, what they do, what it
	returns, its arguments, as well as notes on their purpose.

o	/dynamic_map Variables
	This is a list of all variables of the /dynamic_map datum. This
	section describes their purpose, as well as their default value, if
	any.

o	Other Procedures
	This is a list of procedures defined at the global or object level,
	but not on the /dynamic_map datum.

o	Other Variables
	This is a list of variables defined at the global or object level,
	but not on the /dynamic_map datum.

-----------------------------------------------------------------------
Description:

pif_MapLoader is a library that loads in BYOND's .dmm format, quickly
and efficiently. The current version, version 3.0, was written for
BYOND version 411.976 and may not work on loading map files on later
versions. If I become aware of this, I will work to correct the
problem.

At the heart of pif_MapLoader is the /dynamic_map datum. To load a new
map, create a new /dynamic_map object and pass the proper set of
arguments for a given load type (There are three sets of arguments for
different load types, and a fourth set for saving a chunk of the map.
These are all discussed below in the "/dynamic_map Procedures" section).

*	Note: If you find a bug related to opening the map in DM's map
	editor, please include the contents of the map in the <dm>
	tags on the forums (http://members.byond.com/popisfizzy).

-----------------------------------------------------------------------
Release Notes:

o	Version 1.0 released October 25, 2006.


o	Version 2.0 released March 30, 2007
	o	Complete rewrite of all the code.
	o	Procedures to help developers easily use the code have been
		included (Development Procedures.dm).
	o	Included allocation and space-finding functions.

o	Version 2.1 released March 31, 2007
	o	I found a bug that deals with chunk loading, and corrected it.
		It should be working now.

o	Version 2.2 released April 2, 2007
	o	Madjarjarbinks found a bug; it has now been fixed.
	o	Added a procedure called map_contents(). It returns all atoms
		in a given /dynamic_map object's contents.

o	Version 2.3 released April 30, 2007
	o	Added a fix for a security check in referring to a map by an
		id.

o	Version 2.35 released April 30, 2007
	o	A simple bug involving find_space() and its constants has been
		fixed.

o	Version 2.4 released May 6, 2007
	o	Several major bugs involving saving, loading, and deleting have
		been found and resolved, as well as a few minor bugs. Thanks
		goes out to D4RK3 54B3R for finding them and helping me test
		them to see if they were fixed.


o	Version 3.0 released January ##, 2008
	o	The code has been rewritten a second time, with a significant
		increase in speed for the saving code, and several alterations
		in the loading code that allows for previously unnoticed things
		that are in the .dmm-format. All developer procedures will
		still work as they did in 2.0 versions.
	o	What was formerly called the /map datum has been rechristened
		/dynamic_map. All developer procedures still function properly,
		but code may need to be altered if custom functions or
		modifications were made.
	o	To-do:
		o	Add efficient space finding algorithm.

-----------------------------------------------------------------------
Notes:

o	Files will not be deleted by this library, meaning that if a file
	that is being written already exists, the new text will be appended
	to the file, which could potentially (and very likely) cause bugs
	in loading. It is up to the programmer to make sure that the file
	is deleted.

o	The /area atom is the only type that, by default, has skip_delete
	set to one. This is to prevent strange bugs that happen if there
	are no areas in a location If you wish to change this, do so, but
	make sure that there is an area in a location if you delete
	portions of the map. (Version 3.0) in map files

o	ASCII 26 is invalid in DMM files, though pif_MapLoader should still
	be able to load them. The DM map editor will not be able to load
	them though. This is unavoidable, as it seems to be a quirk in DM.

-----------------------------------------------------------------------
To do:

o	Writing a far more efficient space-finding algorithm. The current
	one is simply the version in pif_MapLoader 2.x, but I couldn't
	figure out a better way, nor could I get help in making one.

o	Fix a known bug involving an instance of an object that has a list
	which contains an object to be created. Considering that it's
	likely most people don't even know about the instance editor, I
	can't think that this bug will show up too often.

o	Finish the documentation. The essential documentation is complete,
	but the in-depth documentation still has to be finished.

-----------------------------------------------------------------------
Development Procedures:

o	create_map()
	Creates a new /dynamic_map object and sets its id and saving,
	loading, and deleting preferences.
	o	Arguments
		o	id: The id that the map is to be referred to by.
		o	save_preferences: Th
		e saving preferences for the
			/dynamic_map.
		o	load_preferences: The loading preferences for the
			/dynamic_map.
		o	delete_preferences: The deleting preferences for the
			/dynamic_map.
	o	Return
		o	/dynamic_map: The newly created /dynamic_map object.

o	create_map_on_section()
	Creates a new /dynamic_map object based on a pre-existing map
	area.
	o	Arguments
		o	id: The id that the map is to be referred to by.
		o	atom/low: The low corner of the area to be controlled by
			the /dynamic_map object.
		o	atom/high: The high corner of the areas to be controlled
			by the /dynamic_map object.
		o	save_preferences: The saving preferences for the
			/dynamic_map.
		o	load_preferences: The loading preferences for the
			/dynamic_map.
		o	delete_preferences: The deleting preferences for the
			/dynamic_map.
	o	Returns
		o	/dynamic_map: The newly created /dynamic_map object.

o	delete_all_maps()
	Deletes all currently existing /dynamic_map objects.
	o	Arguments
		o	list/expceptions: Either IDs (referring to a map) or
			/dynamic_map objects that should be skipped over for
			deletion.

o	delete_map()
	Deletes a single /dynamic_map object.
	o	Arguments
		o	id: The id of the /dynamic_map to be deleted.

o	delete_map_chunk()
	Deletes a portion of the world map.
	o	Arguments
		o	atom/low: The low corner of the section map to be deleted.
		o	atom/high: The high corner of the section of the map to be
			deleted.
		o	preferences: The preferences for deletion of the section.

o	find_map()
	Finds a map based on its id.
	o	Arguments
		o	id: The id to search for.
	o	Returns
		o	null: If the map isn't found, it returns null.
		o	/dynamic_map object: If the map is found, the object is
			returned.

o	get_map_at_location()
	Finds the map the corresponds to the location of a given /atom.
	o	Arguments
		o	atom/a: The atom to base the search on.
	o	Returns:
		o	/dynamic_map: Returns a /dynamic_map object if the /atom
			object is located on a map.
		o	null: Returns null if the /atom is not in a /dynamic_map's
			range, or if the object isn't derived from /atom.

o	is_in_use()
	Determines whether a client is on the map.
	o	Arguments
		o	id: The id of the /dynamic_map to refer to.
	o	Returns
		o	1: If there is a client on the map, this returns 1.
		o	0: If no client is on the map, this returns 0.

o	load_chunk()
	Loads a chunk, a section smaller than the whole of a given DMM-
	format file, onto the map.
	o	Arguments
		o	atom/low: The low corner of the map to start loading.
		o	id: The id that the /dynamic_map object is to be referred
			to by.
		o	preferences: The loading preferences for the /dynamic_map
			object.
		o	file: The file to get the chunk from.
		o	lowx, lowy, lowz: The low corner to start getting the chunk
			from.
		o	highx, highy, highz: The high corner to finish getting the
			chunk from.
	o	Returns
		o	/dynamic_map object: The newly created /dynamic_map object.

	load_chunk_into_memory(id, file, lowx, lowy, lowz, highx, highy, highz)

o	load_chunk_into_memory()
	Loads a chunk, a section smaller than the whole  of a give DMM-
	format file, into memory to be used as a template
	o	Arguments
		o	id: The id the the /dynamic_map object is to be referred
			to by.
		o	file: The file to get the chunk from.
		o	lowx, lowy, lowz: The low corner to start getting the chunk
			from.
		o	highx, highy, highz: The high corner to finish getting the
			chunk from.
	o	Returns
		o	/dynamic_map object: The newly created /dynamic_map object
			to be used as a template.

o	load_file_into_memory()
	This loads a DMM-format file to a /dynamic_map object that will be
	used as a template for other maps to be loaded from. This way,
	extra parsing will not have to be done, as all the data has already
	been parsed.
	o	Arguments
		o	id: The id that the template will be referred to by.
		o	file: The file to load into the /dynamic_map object
			template.
	o	Returns
		o	/dynamic_map object: The loading template.

o	load_map()
	This load a DMM-format file onto the map, creating a new
	/dynamic_map object in the process.
	o	Arguments
		o	id: The id that the map will be referred to by.
		o	file: The file to load from.
		o	atom/low: The low corner to place the map at.
	o	Returns
		o	/dynamic_map object: The /dynamic_map that was created to
			load the map.

o	load_map_from_memory()
	Loads a map from a template, a /dynamic_map object that was created
	purely to store data from a map file for later use, multiple times.
	o	Arguments
		o	template: The id of the template to load from.
		o	id: The id that the new /dynamic_map object will be
			referred to by.
		o	atom/low: The location to start loading the map at.
	o	Returns
		o	/dynamic_map object: The new /dynamic_map object.

o	laod_map_on_space()
	Finds space to load a map at. If there is no space, then one of
	several options can be taken.
	o	Arguments
		o	id: The id that the new /dynamic_map object will be
			referred to by.
		o	file: The file to load from.
		o	atom/low: The low corner to search (defaults to locate(1,1,1).
		o	atom/high: The high corner to search (defaults to
			locate(world.maxx, world.maxy, world.maxz).
		o	list/writable: A list of typepaths that are valid to allow the
			map to be written to.
		o	preferences: The preferences on handling the map loading if
			space isn't found to load at.
	o	Returns
		o	/dynamic_map object: The /dynamic_map object that was loaded.

o	map_contents()
	Gets the contents of a given /dynamic_map object.
	o	Arguments
		o	id: The id of the map to get the contents of.
	o	Returns
		o	/list: A list of objects in the /dynamic_map's boundaries.

o	map_corners()
	Gets the high and low corners of a /dynamic_map object.
	o	Arguments
		o	id: The id of the map to get the corners of.
	o	Returns
		o	/list: A list with the first element being the low corner
		of the map, and the second being the high corner.

o	map_high_corner()
	Gets the high corner of a /dynamic_map object.
	o	Arguments
		o	id: The id of the map to get the high corner of.
	o	Returns
		o	/atom: An atom corresponding to the high corner of the
			/dynamic_map object.

o	map_low_corner()
	Gets the low corner of a /dynamic_map object.
	o	Arguments
		o	id: The id of the map to get the low corner of.
	o	Returns
		o	/atom: An atom corresponding to the low corner of the
			/dynamic_map object.

o	save_all_maps()
	Saves all currently loaded maps. By default, the maps are saved
	with the format of "[dynamic_map.id].dmm"
	o	Arguments:
		o	list/exceptions: /dynamic_map ids or objects that shouldn't
			be saved.
		o	list/names: A list of /dynamic_map ids or objects with an
			association that is supposed to be the file name.

o	save_and_delete_all_maps()
	Saves and deletes all currently loaded maps. by defualt, the maps
	will be saved with the format of "[dynamic_map.id].dmm"
	o	Arguments
		o	list/exceptions: /dynamic_map ids or objects that shouldn't
			be saved or deleted.
		o	list/names: A list of /dynamic_map ids or objects with an
			association that is supposed to be the file name.

o	save_and_delete_map()
	Saves and deletes a given /dynamic_map object.
	o	Arguments
		o	id: The id of the map to be saved and deleted.
		o	file: The name of the file to be created or saved to.

o	save_map()
	Saves a /dynamic_map object.
	o	Arguments
		o	id: The id of the map to be saved.
		o	file: The name of the file to be created or saved to.

o	save_map_chunk()
	Saves a portion of the world map.
	o	Arguments
		o	atom/low: The low corner of the section to be saved.
		o	atom/high: The high corner of the section to be saved.
		o	file: The file to be created or saved to.
		o	preferences: The saving preferences for saving the section.

o	set_delete_preferences()
	Sets the delete preferences for a given /dynamic_map object.
	o	Arguments
		o	id: The id of the map to have its preferences set.
		o	preferences: The preferences to be set.

o	set_load_data_handling()
	Sets or toggles the /dynamic_map.clear_load_data variable for a
	given /dynamic_map object.
	o	Arguments
		o	id: The id of the /dynamic_map object to be altered.
		o	handling: The variable that clear_load_data will be set
			equal to. If this value is equal to null, clear_load_data
			will simply be toggled.

o	set_load_preferences()
	Sets the load preferences for a given /dynamic_map object.
	o	Arguments
		o	id: The id of the map to have its preferences set.
		o	preferences: The preferences to be set.

o	set_loop_amount()
	Sets the /dynamic_map.loop_amount variable for a given /dynamic_map
	object.
	o	Arguments
		o	id: The id of the map to have its loop_amount set.
		o	amount: The value loop_amount will be set equal to.

o	set_save_data_handling()
	Sets or toggles the /dynamic_map.clear_save_data variable for a
	given /dynamic_map object.
	o	Arguments
		o	id: The id of the /dynamic_map object to be altered.
		o	handling: The variable that clear_save_data will be set
			equal to. If this value is equal to null, clear_save_data
			will simply be toggled.

o	set_save_preferences()
	Sets the save preferences for a given /dynamic_map object.
	o	Arguments
		o	id: The id of the map to have its preferences set.
		o	preferences: The preferences to be set.

o	set_sleep_time()
	Sets the /dynamic_map.sleep_time variable for a given /dynamic_map
	object.
	o	Arguments
		o	id: The id of the map to have its sleep_time set.
		o	amount: The value sleep_time will be set equal to.

-----------------------------------------------------------------------
Constants/Macros:

This is a list of all the constants and macros used in pif_MapLoader.
This section will be broken up into four sections:
	1)	Catch-alls: Special macros made to make sure certain
		procedures won't be defined twice, causing an error.
	2)	Functions: Simple functions defined as they are tedious to type
		out often.
	3)	Includers: Used to include sections of code will be included.
	4)	Constants

1)	Catch-alls:

o	FIZZY_SECTION
	Used to make sure that the section() function isn't defined
	multiple times.

o	FIZZY_SORT
	Used to make sure that the sort() function isn't defined multiple
	times.

o	FIZZY_COMPRESS_TEXT
	Used to make sure that the compress_text() function isn't defined
	multiples times.

o	FIZZY_ESCAPE_SEQUENCE
	Used to make sure that parse_escape_sequence() isn't defined
	multiples times.

o	FIZZY_COPY_OBJECT
	Used to make sure that the copy_object() function isn't defined
	multiples times.

2)	Functions

o	INTERNAL_CRASH()
	Outputs and error to the log and then deletes the object that
	caused the error.
	o	output: The error to be output.
	o	src: The object to be deleted.

o	SLEEP_ON_LOOP()
	If (x % loop_amount) = 0, then this will sleep the amount stored
	in sleep time.
	o	x: The value to compare to loop_amount.

o	num2letter()
	Converts a number into a letters (1-26 correspond to a-z and 27-
	52 correspond to A-Z).
	o	x: The value to be converted.

o	isobject()
	Determins whether the value passed is an object (/savefile,
	/client, or /datum).
	o	x: The value to be checked.

o	SKIP_ALL_BUT_()
	Gives the bitflags that correspond to skipping everything but
	the values passed.
	o	x: Bitflags that are to be included.

3)	Includers

o	PIF_MAPLOADER_COMPATABILITY_2
	Used to interface 3.0 with 2.x versions of the developer
	procedures. Include this somewhere in your code file to
	interface. See "Backwards Interface.dm" for more details on
	this.

4)	Constants

o	ASCENDING				1
	Used for sort(). This means that the data should be sorted in
	ascending order.

o	DESCENDING				-1
	Used for sort(). This means that the data should be sorted in
	descending order.

o	SKIP_NONE				0
	Means that nothing should be skipped (overwritable).

o	SKIP_AREA				1
	Means that areas should be skipped.

o	SKIP_TURF				2
	Means that turfs should be skipped.

o	SKIP_STATIC				3 (SKIP_TURF|SKIP_AREA)
	Means that turfs and areas should be skipped.

o	SKIP_NONMOVABLE	See SKIP_STATIC

o	SKIP_OBJ				4
	Means that objs should be skipped.

o	SKIP_MOB				8
	Means that mobs should be skipped.

o	SKIP_MOVABLE			12 (SKIP_OBJ|SKIP_MOB)
	Means that objs and mobs should be skipped.

o	SKIP_CLIENT				16
	Means that mobs with an attached client should be skipped.

o	AREA					1
	Used for SKIP_ALL_BUT_(); means that areas shouldn't be
	skipped.

o	TURF					2
	Used for SKIP_ALL_BUT_(); means that turfs shouldn't be
	skip.

o	STATCIC					3
	Used for SKIP_ALL_BUT_(); means that turfs and areas
	shouldn't be skipped.

o	NONMOVABLE		See STATIC

o	OBJ						4
	Used for SKIP_ALL_BUT_(); means that objs shouldn't be
	skipped.

o	MOB						8
	Used for SKIP_ALL_BUT_(); means that mobs shouldn't be
	skipped.

o	NONMOVABLE				12
	Used for SKIP_ALL_BUT_(); means that mobs and objs
	shouldn't be skipped.

o	CLIENT					16
	Used for SKIP_ALL_BUT_(); means that mobs with attached
	clients shouldn't be skipped.

o	LOAD_ON_READ			0
	Denotes that the map should be loaded immediately upon reading
	in the data from the file (overwritable).

o	READ_IN_ONLY			64
	Denotes that the map data should be read in, but that the map
	shouldn't be built.

o	REPLACE_AREA_ON_DELETE	128
	Means that areas should be replaced upon deletion. Not doing
	this can cause peculiar graphical errors.

o	RESET_MAX_COORDINATES	256
	This means that if the map is stretching the size of world.maxx,
	world.maxy, and/or world.maxz, the global map should be compresssed
	down to the previous size.

o	LOAD_AT_BLOCK			0
	Used for space finding. This means that the map will only be loaded
	at the provided block, and if no areas are found, then the map
	should not be loaded.

o	APPEND_TO_LOW_EDGE		1
	Used for space finding. This means the map will be loaded at the
	edge of the low corner of the map if no space is found to load at.

o	APPEND_TO_HIGH_EDGE		2
	Used for space finding. This means the map will be loaded at the
	edge of the high corner of the map if no space is found to load at.

o	APPEND_TO_NEXT_Z
	Used for space finding. This means the map will be loaded at the
	next z level (++ world.maxz) if no space is found to load at.

-----------------------------------------------------------------------
/dynamic_map Procedures:

o	/dynamic_map.Del()
	This deletes the object, clears out any object not covered by
	delete_preferences, resets the world.maxx, world.maxy, and
	world.maxz variables if set to, and removes the map from the
	dynamic_maps list.

o	/dynamic_map.New()
	Creates the map, sets its id, and adds the map to the dynamic_maps
	list.
	o	Arguments
		o	_id: The id that the map will be referred to by. If none is
			passed an arbitrary value will be chosen instead.

o	/dynamic_map.Load()
	Loads the map from a file at a given location.
	o	Arguments
		o	file: The file to load the map from.
		o	atom/location: The location to load the map from.

o	/dynamic_map.Load_From_Template()
	Loads the map data from a previously created template.
	o	Arguments
		o	id: The id of the template to load from.

o	/dynamic_map.Save()
	Saves the map data to a file, or creates a file and saves to it.
	o	Arguments
		o	filename: The name of the file to create or write to.

o	/dynamic_map.are_equal_lists()
	Checks to see if the contents of two lists are the same.
	o	Arguments
		o	list/a: The first list being checked.
		o	list/b: The second list to be checked.
		o	ignore_assocation (0): If true, then the associated
			values will be ignored in comparing.
	o	Returns
		o	1: Returns one if the lists are equal.
		o	0: Returns zero if the lists are not equal.

o	/dynamic_map.build_atom()
	Builds and atom on the map, sets its variables, and loads the
	map on the specified locatoin.
	o	Arguments
		o	type: The typepath to be created.
		o	list/vars: The values that the object will have its
			variables set equal to.
		o	turf/location: The location to create the object at.

o	/dynamic_map.build_file()
	This creates the DMM-format file for saving.
	o	Arguments
		o	filename: The name of the file to be created.

o	/dynamic_map.build_map()
	This adds the /dynamic_map's data to the global map if the
	READ_IN_ONLY flag is set off. Otherwise, it simply builds the
	information for the map's locations.

o	/dynamic_map.clear_initial_objects_list()
	This clears out the initial_objects list, removing the holding
	z-level and all objects contained in it, as well as anything inside
	the list.

o	/dynamic_map.collect_atom_data()
	This collect the information for all the /atoms on the map to be
	saved, and then stores the information into a list so it can be
	written to the file.

o	/dynamic_map.combinations()
	This produces the total number of references strings needed for the
	/atom sets.
	o	Arguments
		o	x: The total number of reference strings needed.

o	/dynamic_map.convert_condition_list()
	Converts the elements of the condition list into a string so they
	can be fed directly into the file.
	o	Returns:
		o	/list: /list of the newly formatted condition list.

o	/dynamic_map.convert_element()
	Converts and element of the condition list into a readable string
	format.
	o	Arguments
		o	list/l: The list of data to be converted.
	o	Returns
		o	/list: /list of newly formatted data.

o	/dynamic_map.convert_position_list()
	Convers the elements of the position list into a string so that
	they can be fed directly into the file.
	o	Returns:
		o	/list: /list of the newly formatted position list.

o	/dyanmic_map.correct_value()
	This converts a raw string into the data format is should be.
	o	Arguments
		o	value: The value that should be formatted.
	o	Returns
		o	number: A number if the raw data is supposed to be a
			numeric value.
		o	string: A string that is correctly escaped, if the raw
			data is supposed to be a string.
		o	file: A file reference is the raw data is supposed to be a
			file.
		o	typeath: A typepath if the raw data is supposed to be a
			typepath.
		o	/list: A /list if the raw data is supposed to be a list.
		o	/datum, /savefile, /client: An non-list object if the data
			is supposed to be a /datum, /savefile, or /client.
		o	null: Null of the data is unknown, or if the raw data reads
			as "null"

o	/dynamic_map.count_list()
	Used in conjuction with /dynamic_map.combination(). This counts the
	base fifty-two number to keep track of the total digits.
	o	Arguments
		o	list/list: The list to be counted and modified.

o	/dynamic_map.determine_holding_area()
	Used to find out the location a given /atom should be stored.
	Movable atoms will always be stored on the /turf corresponding to
	locate(1, 1, world.maxz). Nonmovable atoms (areas and turfs) are
	stored in series on world.maxz. Note that world.maxz is increased
	to store the intial versions of the objects.
	o	Arguments
		o	datum/a: The object to be stored.
	o	Returns
		o	/turf: A turf to store the /atom at.

o	/dynamic_map.evaluate_position()


-----------------------------------------------------------------------

*/