client
	perspective = EDGE_PERSPECTIVE | EYE_PERSPECTIVE

	New()
		..()
		global.clients += src

	Del()
		global.clients -= src
		..()

var/global/list/clients = list()