maptag
	icon = 'map/media/extras/maptag_marker.dmi'
	layer = 100

	parent_type = /obj

	invisibility = 101

proc
	// Find the turf a maptag is on
	locate_tag(tag as text)
		// Find the maptag object
		var/maptag/tag_obj = locate(tag)

		// If the tag isn't there, something is obviously wrong
		// So crash the proc to get debug info
		if(!tag_obj)
			CRASH("Maptag not found: \"[tag]\"")

		// Return the turf the maptag object is on
		return tag_obj.loc