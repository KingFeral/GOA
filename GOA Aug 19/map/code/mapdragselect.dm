datum/proc/Select( client/c )
datum/proc/deSelect( client/c )
turf
	var/image/selectimg


image/var/isTemp = 0

client/proc/clearScreen()
	for( var/image/i in images )
		if( i.isTemp )
			images-=i

turf/Select( client/c )
	if(	!c.startPoint )
		c.startPoint = src
		c.selected += src
		c.drawTurfs()

turf/deSelect( client/c )
	c.selected -= src

client/var/turf/startPoint
client/var/canSelect = 1
client/var/selected[0]

client/MouseDown( _, turf/t, _, params )
	set waitfor = 0
	. = ..()

	if(!istype(usr, /map_editor_client))
		return

	params = params2list( params )
	if((params["right"]) )return ..()
	else
		for( var/atom/movable/a in selected )
			a.deSelect( src )

		selected = list()

	if( isturf( t ) && canSelect )
		t.Select( src )

client/MouseDrag( _,_,_, turf/t,_,_, params )
	set waitfor = 0
	. = ..()

	if(!istype(usr, /map_editor_client))
		return

	params = params2list( params )
	if((params["right"]) )return ..()
	if(startPoint&&t&&startPoint.z==t.z&&abs(startPoint.x-t.x)<11&&abs(startPoint.y-t.y)<11)
		clearScreen()
		for( var/turf/T in selected )
			T.deSelect( src )
		selected += block( startPoint, t )
		drawTurfs()

client/MouseUp(_,T,_,params)
	set waitfor = 0
	. = ..()

	if(!istype(usr, /map_editor_client))
		return

	clearScreen()
	params = params2list( params )
	if((params["right"]) )return ..()
	//var/z=0
	var/map_editor_client/mc = usr
	if(mc.Map_editor.selected && mc.Map_editor.selected.can_fill)
		var/Ref = mc.Map_editor.selected.ref
		var/x = text2path("[Ref]")
		if(x)
			for( var/turf/t in selected )
				new x(t)
		/*for( var/mob/human/a in t )
			if(a!=src.mob)
				if( !( a in src.mob.targets ) ||!z)
					if(!z)

						src.mob.AddTarget(a, active=1)
						z=1
					else
						src.mob.AddTarget(a, active=0)*/

	startPoint = null

client/proc/drawTurfs()
	for( var/turf/t in selected)
		if(t.selectimg)
			images += t.selectimg
		else
			t.selectimg=image('map/media/extras/select.dmi',t)
			t.selectimg.layer=9
			t.selectimg.isTemp=1
			images+=t.selectimg