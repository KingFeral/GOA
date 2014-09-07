obj
	Sunaspawn
	Mistspawn
obj
	Respawn_Pt
		var
			ind=0//0=neutral, 1=konoha, 2=suna, 3=Mist
obj
	cexamspawn
		density=0
turf
	arena
		density=0
obj
	jutsusign
		icon='icons/gui.dmi'
		icon_state="jutsusign"
	clock
		icon='icons/gui.dmi'
		icon_state="clock"
turf
	headbands
		icon='icons/scenic.dmi'
		icon_state="headbands"
	desk2
		icon='icons/scenic.dmi'
		icon_state="desk2"
	denseempty
		density=1
	denseforppl
		density=0
		Enter(o)
			if(istype(o,/mob/human/player))
				return 0
			else
				return 1
turf/water_sides
	icon='icons/water.dmi'
	layer=OBJ_LAYER
	density=0
	var
		sleepdie=100
	wl
		icon_state="left"
	wr
		icon_state="right"
	wd
		icon_state="down"
	wu
		icon_state="up"
	w0l
		icon_state="left"
	w0r
		icon_state="right"
	w0d
		icon_state="down"
	w0u
		icon_state="up"
turf/Hokage_Desk
	icon='interior/hokage-desk.png'
	density=1
	layer=OBJ_LAYER
turf/water

	icon='icons/water.dmi'
	icon_state="still"
	layer=TURF_LAYER+2
	water_sides
		move
			icon_state="move"
		tl
			icon_state="tl"
		tr
			icon_state="tr"
		bl
			icon_state="bl"
		br
			icon_state="br"
	water_fod
		icon='icons/fodturf.dmi'
		icon_state="water"
		tl
			icon_state="water_tl"
		tr
			icon_state="water_tr"
		bl
			icon_state="water_bl"
		br
			icon_state="water_br"
	var
		sleepdie=0

obj
	var
		mob/owner


obj
	MapMaking
		Interior
			icon='icons/house_stuff.dmi'
			Book1
				icon_state="book1"
			Book2
				icon_state="book2"
			Book3
				icon_state="book3"
			Book4
				icon_state="book4"
			Book5
				icon_state="book5"
			Book6
				icon_state="book6"
			Book7
				icon_state="book7"
			Book8
				icon_state="book8"



turf
	Danhouse
		density=0
		icon='pngs/danhouse.png'
		layer=MOB_LAYER+1
		Bottoms
			icon='pngs/danhouse_brown.png'
			White
			Brown
				icon='pngs/danhouse_brown.png'
			Orange
				icon='pngs/danhouse_orange.png'
			Tan
				icon='pngs/danhouse_tan.png'

		Roofs
			icon='pngs/blackroof.png'
			Black
			Blue
				icon='pngs/roof_blue.png'
			Cyan
				icon='pngs/roof_cyan.png'
			Green
				icon='pngs/roof_green.png'
			Grey
				icon='pngs/roof_grey.png'
			Orange
				icon='pngs/roof_orange.png'
			Red
				icon='pngs/roof_red.png'
			Yellow
				icon='pngs/roof_yellow.png'
	Konoha_Academy
		icon='pngs/Konoha-Academy.png'
		layer=MOB_LAYER+1
		density=0
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Mist_Academy
		icon='pngs/Mist-Academy.png'
		layer=MOB_LAYER+1
		density=0
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Sand_Academy
		icon='pngs/Sand-Academy.png'
		layer=MOB_LAYER+1
		density=0
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Konoha_Admin
		icon='pngs/adminbuilding.png'
		layer=OBJ_LAYER

		density=0
	Suna_Barber
		density=0
		icon='pngs/sbarber.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Suna_Weapon
		density=0
		icon='pngs/sweapon.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Suna_Dojo
		density=0
		icon='pngs/sdojo.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Suna_Clothing
		density=0
		icon='pngs/sclothing.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	MistHouse1
		density=0
		icon='pngs/misthouse1.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	MistHouse2
		density=0
		icon='pngs/misthouse2.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	MistHouse3
		density=0
		icon='pngs/misthouse3.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	SandHouse1
		density=0
		icon='pngs/sanhouse1.PNG'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	SandHouse2
		density=0
		icon='pngs/sandhouse2.PNG'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	SandHouse3
		density=0
		icon='pngs/sandhouse3.PNG'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Map
		density=1
		icon='map/map.png'

	AkatsukiEnter
		density=1
		icon='pngs/akatsukienter.png'
		layer=MOB_LAYER+1

	SunaAdmin
		density=0
		icon='pngs/sunaadmin.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	KonohaPolice
		density=0
		icon='pngs/konohapolice.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	NarutoBridge
		icon='icons/bridge.dmi'
		EntranceL
			icon='pngs/EntranceL.png'
			layer=MOB_LAYER+1
			density=0
		EntranceR
			icon='pngs/EntranceR.png'
			layer=MOB_LAYER+1
			density=0
		bot
			icon_state="bot"
			density=0
		mid1
			icon_state="mid1"
			density=0
		mid2
			icon_state="mid2"
			density=0
		mid3
			icon_state="mid3"
			density=0
		mid4
			icon_state="mid4"
			density=0
		top
			icon_state="top"
			layer=MOB_LAYER+1
			density=0
		colm
			icon_state="col"
			density=1
			layer=MOB_LAYER
		bot_over
			icon_state="bot-over"
			layer=MOB_LAYER+1
			density=0

	Barber
		density=0
		icon='pngs/Barber1.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Clothing
		density=0
		icon='pngs/Clothing1.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Dojo
		density=0
		icon='pngs/Dojo1.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Weapons_Store
		density=0
		icon='pngs/Weapons1.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	SandArena
		density=0
		icon='pngs/sandarena.png'
		layer=MOB_LAYER+1
	Hospital_Konoha
		density=0
		icon='pngs/konohahospital.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Hospital_Suna
		density=0
		icon='pngs/sunahospital.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Hospital_Mist
		density=0
		icon='pngs/misthospital.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	KonohaHouse1
		density=0
		icon='pngs/konoha-house1.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	KonohaHouse2
		density=0
		icon='pngs/konoha-house2.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	MistAdmin
		density=0
		icon='pngs/mistadmin.png'
		layer=OBJ_LAYER

	Chuunin_Tower
		density=0
		icon='pngs/chuuninbuilding.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Ramen
		density=0
		icon='pngs/ramen.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	KonohaHouse3
		density=0
		icon='pngs/konoha-house3.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	MistHouse_new
		density=0
		icon='pngs/mhouse.png'
		layer=MOB_LAYER+1
		New()
			..()
			var/pos = findtext(src.icon_state,",")
			if(!pos) return // not a coord
			var/gety = text2num(copytext(src.icon_state,pos+1))
			if(gety==0)
				src.density=1
				src.layer=OBJ_LAYER
	Arena
		density=0
		icon='pngs/arena.png'
		layer=MOB_LAYER+1
	Arena_Mist
		density=0
		icon='pngs/mistarena.png'
		layer=MOB_LAYER+1
	GraveStone
		density=0
		icon='pngs/grave.png'
		layer=TURF_LAYER+0.1
turf
	HokageMonument
		density=1
		layer=OBJ_LAYER+2
		icon='pngs/Hokage-Mountain.png'

turf
	UnrealKonohaWalls
		density=0
		icon='pngs/A-Konoha Walls.PNG'
		layer=MOB_LAYER+1
		W1
			density=0
			icon='pngs/W1.png'
		W2

			icon='pngs/W2.png'
		W3

			icon='pngs/W3.png'
		W4

			icon='pngs/W4.png'
		W5

			icon='pngs/W5.png'
		W6

			icon='pngs/W6.png'
		W7

			icon='pngs/W7.png'
		W8

			icon='pngs/W8.png'
		W9

			icon='pngs/W9.png'
		W10

			icon='pngs/W10.png'
		W11

			icon='pngs/W11.png'
		W12
			icon='pngs/W12.png'
		W13
			icon='pngs/W13.png'
		W14
			icon='pngs/W14.png'
		W15
			icon='pngs/W15.png'
		W16
			icon='pngs/W16.png'

turf
	Powerlines
		icon='icons/Powerlines.dmi'
		layer=MOB_LAYER+1
		density=0

		A1
			density=1
			layer=OBJ_LAYER
			icon_state="1"
		A2
			icon_state="2"
		A3
			icon_state="3"
		A4
			icon_state="4"
		A5
			icon_state="5"
	LightDirtroad
		icon='icons/LightDirtRoad.dmi'
		density=0
		left
			icon_state="left"
		right
			icon_state="right"
		bottom
			icon_state="bottom"
		top
			icon_state="top"
		C1
			icon_state="1"
		C2
			icon_state="2"
		C3
			icon_state="3"
		C4
			icon_state="4"
		C5
			icon_state="5"
		C6
			icon_state="6"
		C7
			icon_state="7"
		C8
			icon_state="8"
	Dirtroad
		icon='icons/DirtRoad.dmi'
		density=0
		left
			icon_state="left"
		right
			icon_state="right"
		bottom
			icon_state="bottom"
		top
			icon_state="top"
		C1
			icon_state="1"
		C2
			icon_state="2"
		C3
			icon_state="3"
		C4
			icon_state="4"
		C5
			icon_state="5"
		C6
			icon_state="6"
		C7
			icon_state="7"
		C8
			icon_state="8"
turf
	sides
		layer=TURF_LAYER+0.1
		L
			icon='icons/LightDirtRoad_o.dmi'
			south
				icon_state="down"
			north
				icon_state="up"
			east
				icon_state="right"
			west
				icon_state="left"
		D
			icon='icons/DirtRoad_o.dmi'
			south
				icon_state="down"
			north
				icon_state="up"
			east
				icon_state="right"
			west
				icon_state="left"
		SandSouth
			icon='icons/mountain.dmi'
			icon_state="ssouth"
		SandNorth
			icon='icons/mountain.dmi'
			icon_state="snorth"
		SandEast
			icon='icons/mountain.dmi'
			icon_state="seast"
		SandWest
			icon='icons/mountain.dmi'
			icon_state="swest"
		ddgsouth
			icon='icons/mountain.dmi'
			icon_state="ddgsouth"
		ddgeast
			icon='icons/mountain.dmi'
			icon_state="ddgeast"
		ddgwest
			icon='icons/mountain.dmi'
			icon_state="ddgwest"
		ddgnorth
			icon='icons/mountain.dmi'
			icon_state="ddgnorth"
		dgsouth
			icon='icons/mountain.dmi'
			icon_state="dgsouth"
		dgeast
			icon='icons/mountain.dmi'
			icon_state="dgeast"
		dgwest
			icon='icons/mountain.dmi'
			icon_state="dgwest"
		dgnorth
			icon='icons/mountain.dmi'
			icon_state="dgnorth"
		gsouth
			icon='icons/mountain.dmi'
			icon_state="gsouth"
		geast
			icon='icons/mountain.dmi'
			icon_state="geast"
		gwest
			icon='icons/mountain.dmi'
			icon_state="gwest"
		gnorth
			icon='icons/mountain.dmi'
			icon_state="gnorth"
		rnorth
			icon='icons/mountain.dmi'
			icon_state="rup"
		rsouth
			icon='icons/mountain.dmi'
			icon_state="rdown"
		rwest
			icon='icons/mountain.dmi'
			icon_state="rleft"
		reast
			icon='icons/mountain.dmi'
			icon_state="rright"

obj
	rock
		icon='icons/GOAturfs.dmi'
		density=1
		Place_Me
			icon_state="BrockBR"


		BR
			icon_state="BrockBR"
			pixel_x=16
		BL
			icon_state="BrockBL"
			pixel_x=-16
		TR
			icon_state="BrockTR"
			pixel_x=16
			density=0
			layer=MOB_LAYER+1
		TL
			icon_state="BrockTL"
			pixel_x=-16
			density=0
			layer=MOB_LAYER+1

	telepole
		icon='icons/GOAturfs.dmi'
		density=0
		layer=MOB_LAYER+1
		top
			icon_state="telepole1"
		mid
			icon_state="telepole2"
		bot
			icon_state="telepole2"
			density=1
			layer=OBJ_LAYER
	lamp
		icon='icons/GOAturfs.dmi'
		density=0
		layer=MOB_LAYER+1
		top
			icon_state="lamptop"
		bot
			icon_state="lampbottom"
			density=1
			layer=OBJ_LAYER
	displaysword
		icon='icons/GOAturfs.dmi'
		icon_state="sword1"
		p1
			icon_state="sword1"
		p2
			icon_state="sword2"
	potflower
		icon='icons/GOAturfs.dmi'
		icon_state="potflower"
		density=0

turf
	Chuunin_Exam
		icon='icons/chuuninexam.dmi'
		tv
			icon='pngs/tv.png'
			density=1
		hands
			icon='pngs/hands.png'
			density=1
		floor
			icon_state="floor"

		regfloor
			icon_state="floor"
		wall
			icon_state="wall"
			density=1
		wallb
			icon_state="wallb"
			density=1
		railn
			icon_state="railn"

		railw
			icon_state="railw"

		raile
			icon_state="raile"


		railcorner1
			icon_state="railcorner1"

		railcorner2
			icon_state="railcorner2"

	desk
		icon='icons/scenic.dmi'
		icon_state="desk"
		density=1


	blackboard
		icon='icons/scenic.dmi'
		icon_state="blackboard"
	blackleft
		icon='icons/scenic.dmi'
		icon_state="blackleft"
	blackright
		icon='icons/scenic.dmi'
		icon_state="blackright"
	blacktop

		icon='icons/scenic.dmi'
		icon_state="blacktop"
	remove_projectiles

	heads
		icon='pngs/heads.png'
	gen
		icon='icons/gen.dmi'
		density=1
	dense_dark
		icon='icons/black.dmi'
		density=1
		opacity=1

	Terrain
		Pave
			icon='icons/mountain.dmi'
			icon_state="pavement"
			density=0
		DDGrass
			icon='icons/mountain.dmi'
			icon_state ="doubledensegrass"
			density=0

		LightDirt
			icon='icons/LightDirtRoad_o.dmi'
			density=0
		Dirt
			icon='icons/DirtRoad_o.dmi'
			density=0
		rockyground
			icon='icons/mountain.dmi'
			icon_state="rockyground"
			rup
				icon_state="rup"
			rdown
				icon_state="rdown"
			rleft
				icon_state="rleft"
			rright
				icon_state="rright"
		SandSouth
			icon='icons/mountain.dmi'
			icon_state="ssouth"
		SandNorth
			icon='icons/mountain.dmi'
			icon_state="snorth"
		SandEast
			icon='icons/mountain.dmi'
			icon_state="seast"
		SandWest
			icon='icons/mountain.dmi'
			icon_state="swest"
		Grass
			icon='icons/mountain.dmi'
			icon_state ="grass"
			density=0
		DGrass
			icon='icons/mountain.dmi'
			icon_state ="densegrass"
			density=0
		LDGrass
			icon='icons/mountain.dmi'
			icon_state ="ldgrass"
			density=0
		Sand
			icon='icons/mountain.dmi'
			icon_state ="sand"
			density=0
			var/tmp
				show_enter_track
				show_exit_track
				image
					enter_tracks
					enter_runtracks
					exit_tracks
					exit_runtracks

			New()
				enter_tracks=image('icons/sandtracks.dmi',icon_state="enter",layer=OBJ_LAYER)
				enter_runtracks=image('icons/sandtracksrun.dmi',icon_state="enter",layer=OBJ_LAYER)
				exit_tracks=image('icons/sandtracks.dmi',icon_state="exit",layer=OBJ_LAYER)
				exit_runtracks=image('icons/sandtracksrun.dmi',icon_state="exit",layer=OBJ_LAYER)

			Entered(atom/movable/O)
				new/Event(3, "entered_sand_turf", list(O, src))
				return ..()


			Exited(atom/movable/O)
				new/Event(3, "exited_sand_turf", list(O, src))
				return ..()

		cliff
			icon = 'icons/mountain.dmi'
			icon_state = "cliff-drop"
			density = 1
			layer=MOB_LAYER
		Dirtold
			icon = 'icons/mountain.dmi'
			icon_state = "dirt"
			density = 0
		Dirtbottom
			icon = 'icons/mountain.dmi'
			icon_state = "bottom"
			density = 1
		Dirtup
			icon = 'icons/mountain.dmi'
			icon_state = "up"
			density = 1
		Dirtleft
			icon = 'icons/mountain.dmi'
			icon_state = "left"
			density = 1
		Dirtright
			icon = 'icons/mountain.dmi'
			icon_state = "right"
			density = 1
		Dirttl
			icon = 'icons/mountain.dmi'
			icon_state = "tl"
			density = 1
		Dirttr
			icon = 'icons/mountain.dmi'
			icon_state = "tr"
			density = 1

		Grassbottom
			icon = 'icons/mountain.dmi'
			icon_state = "gbottom"
			density = 1
		Grassup
			icon = 'icons/mountain.dmi'
			icon_state = "gtop"
			density = 1
		Grassleft
			icon = 'icons/mountain.dmi'
			icon_state = "gleft"
			density = 1
		Grassright
			icon = 'icons/mountain.dmi'
			icon_state = "gright"
			density = 1
		Grasstl
			icon = 'icons/mountain.dmi'
			icon_state = "gtl"
			density = 1

		Grasstr
			icon = 'icons/mountain.dmi'
			icon_state = "gtr"
			density = 1
		Sandbottom
			icon = 'icons/mountain.dmi'
			icon_state = "sbottom"
			density = 1
		Sandup
			icon = 'icons/mountain.dmi'
			icon_state = "stop"
			density = 1
		Sandleft
			icon = 'icons/mountain.dmi'
			icon_state = "sleft"
			density = 1
		Sandright
			icon = 'icons/mountain.dmi'
			icon_state = "sright"
			density = 1
		Sandtl
			icon = 'icons/mountain.dmi'
			icon_state = "stl"
			density = 1
		Sandtr
			icon = 'icons/mountain.dmi'
			icon_state = "str"
			density = 1

		cliffbl
			icon = 'icons/mountain.dmi'
			icon_state = "bl"
			density = 1
			layer=MOB_LAYER
		cliffbr
			icon = 'icons/mountain.dmi'
			icon_state = "br"
			density = 1
			layer=MOB_LAYER
		Side
			layer=MOB_LAYER
			icon='icons/mountain.dmi'
			icon_state="side"
			density=1
obj
	treefod
		covervalue=2
		density=0
		icon='icons/treefod.dmi'
		layer=MOB_LAYER+1
		a
			icon_state="0,0"
		b
			icon_state="0,1"
		c
			icon_state="0,2"
		d
			icon_state="0,3"
		e
			density=1
			layer=TURF_LAYER+0.1
			icon_state="1,0"
		f
			icon_state="1,1"
		g
			icon_state="1,2"
		h
			icon_state="1,3"
		i
			icon_state="2,0"
		j
			icon_state="2,1"
		k
			icon_state="2,2"
		l
			icon_state="2,3"
		growstump
			density=1
			layer=TURF_LAYER+0.1
			icon_state="1,0"
atom
	var
		covervalue=0



turf
	faces
		icon='icons/heads.dmi'
		layer=MOB_LAYER
		f1
			icon_state="1"
		f2
			icon_state="2"
		f3
			icon_state="3"
		f4
			icon_state="4"
		f5
			icon_state="5"
		f6
			icon_state="6"
		f7
			icon_state="7"
		f8
			icon_state="8"
		f9
			icon_state="9"
		f10
			icon_state="10"
		f11
			icon_state="11"
		f12
			icon_state="12"
		f13
			icon_state="13"
		f14
			icon_state="14"
		f15
			icon_state="15"
		f16
			icon_state="16"
		f17
			icon_state="17"
		f18
			icon_state="18"
		f19
			icon_state="19"
		f20
			icon_state="20"
		f21
			icon_state="21"
		f22
			icon_state="22"
		f23
			icon_state="23"
		f24
			icon_state="24"
		f25
			icon_state="25"
		f26
			icon_state="26"
		f27
			icon_state="27"
		f28
			icon_state="28"
		f29
			icon_state="29"


	konoha_tower
		icon='icons/Tower.dmi'
		layer=MOB_LAYER+1
		density=0
		bl
			icon_state="BL"
			layer=TURF_LAYER+0.1
			density=1
		bm
			icon_state="BM"
			layer=TURF_LAYER+0.1
			density=1
		br
			icon_state="BR"
			layer=TURF_LAYER+0.1
			density=1
		ml
			icon_state="ML"
		mm
			icon_state="MM"
		mr
			icon_state="MR"
		divl
			icon_state="DivL"
		divm
			icon_state="DivM"
		divr
			icon_state="DivR"
		extenL
			icon_state="ExtenL"
		extenM
			icon_state="ExtenM"
		extenR
			icon_state="ExtenR"
		RoofBL
			icon_state="RoofBL"
		RoofBM
			icon_state="RoofBM"
		RoofBR
			icon_state="RoofBR"
		RoofTL
			icon_state="RoofTL"
		RoofTM
			icon_state="RoofTM"
		RoofTR
			icon_state="RoofTR"


area
	var
		safe=0

	nopkzone
		safe=1
		Entered(O)
			if(istype(O,/mob))
				O:pk=0
				O:dojo=1
			..()

	pkzone
		safe=0
		Entered(O)
			if(istype(O,/mob))
				O:pk=1
				O:dojo=0
			..()
	pkzone_dojo
		safe=0
		Entered(O)
			if(istype(O,/mob))
				O:pk=1
				O:dojo=1
			..()

area
	pkzone
		Konoha
			Entered(mob/O)
				if(istype(O))
					O.LocationEnter("Konoha")
					O<<"You have Entered Konoha"
				..()

		Suna
			Entered(mob/O)
				if(istype(O))
					O.LocationEnter("Suna")
					O<<"You have Entered Suna"
				..()

		Mist
			Entered(mob/O)
				if(istype(O))
					O.LocationEnter("Kiri")
					O<<"You have Entered Hidden Mist"
				..()

		Kawa
			Entered(mob/O)
				if(istype(O))
					O.LocationEnter("Kawa no Kuni")
					O<<"You have Entered Kawa no Kuni"
				..()

		Cha
			Entered(mob/O)
				if(istype(O))
					O.LocationEnter("Cha no Kuni")
					O<<"You have Entered Cha no Kuni"
				..()

		Ishi
			Entered(mob/O)
				if(istype(O))
					O.LocationEnter("Ishi no Kuni")
					O<<"You have Entered Ishi no Kuni"
				..()

turf
	UnrealHospital
		bottom
			icon='pngs/hospitalbottom.png'
			density=1
			layer=MOB_LAYER+1
		top
			icon='pngs/hospitaltop.png'
			density=0
			layer=MOB_LAYER+1
turf
	stairs
		density=0
		icon='icons/decor.dmi'
		icon_state="stairs"
obj/interactable
	hospitalbed //this turf acts as a spawn point! dont use it
		icon='icons/decor.dmi'
		icon_state="bed"
		density=1
	bed
		icon='icons/decor.dmi'
		icon_state="bed"
		density=1

turf
	konoha/fence
		layer=TURF_LAYER+0.1
		density=1
		icon='icons/scenic.dmi'
		ftop
			density=0
			layer=MOB_LAYER+1
			icon_state="fencet"
		fbot
			icon_state="fenceb"
		fleft
			icon_state="fencel"
		fright
			icon_state="fencer"
obj


	sheet
		layer=MOB_LAYER+2
		icon='icons/decor.dmi'
		icon_state="sheet"
area
	var
		coverparent
		covericon
		covericon_state
		coverremover
		ondense

area/pkzone/Roof
	Black
		coverparent=/area/pkzone/Roof/Black
		covericon='icons/roofingblack.dmi'
		roof

			covericon_state="roof"
		edge
			coverremover=1

			covericon_state="edge"
		edgeleft

			covericon_state="edge_left"
		edgeright

			covericon_state="edge_right"
		edgetop
			ondense=1
			covericon_state="edge_top"
		roofpeak1

			covericon_state="roof_peak1"
		roofpeak2

			covericon_state="roof_peak2"
	Brown
		coverparent=/area/pkzone/Roof/Brown
		covericon='icons/roofingbrown.dmi'
		roof

			covericon_state="roof"
		edge
			coverremover=1

			covericon_state="edge"
		edgeleft

			covericon_state="edge_left"
		edgeright

			covericon_state="edge_right"
		edgetop
			ondense=1
			covericon_state="edge_top"
		roofpeak1

			covericon_state="roof_peak1"
		roofpeak2

			covericon_state="roof_peak2"

	LightBrown
		coverparent=/area/pkzone/Roof/LightBrown
		covericon='icons/roofinglightbrown.dmi'
		roof

			covericon_state="roof"
		edge
			coverremover=1

			covericon_state="edge"
		edgeleft

			covericon_state="edge_left"
		edgeright

			covericon_state="edge_right"
		edgetop
			ondense=1
			covericon_state="edge_top"
		roofpeak1

			covericon_state="roof_peak1"
		roofpeak2

			covericon_state="roof_peak2"
	Blue
		coverparent=/area/pkzone/Roof/Blue
		covericon='icons/roofingblue.dmi'
		roof

			covericon_state="roof"
		edge
			coverremover=1

			covericon_state="edge"
		edgeleft

			covericon_state="edge_left"
		edgeright

			covericon_state="edge_right"
		edgetop
			ondense=1
			covericon_state="edge_top"
		roofpeak1

			covericon_state="roof_peak1"
		roofpeak2

			covericon_state="roof_peak2"
	Red
		coverparent=/area/pkzone/Roof/Red
		roof
			covericon='icons/roofing.dmi'
			covericon_state="roof"
		edge
			coverremover=1
			covericon='icons/roofing.dmi'
			covericon_state="edge"
		edgeleft
			covericon='icons/roofing.dmi'
			covericon_state="edge_left"
		edgeright
			covericon='icons/roofing.dmi'
			covericon_state="edge_right"
		edgetop
			ondense=1
			covericon='icons/roofing.dmi'
			covericon_state="edge_top"
		roofpeak1
			covericon='icons/roofing.dmi'
			covericon_state="roof_peak1"
		roofpeak2
			covericon='icons/roofing.dmi'
			covericon_state="roof_peak2"

turf/dense
	density=1
turf
	Rocks
		Rock1
			icon='pngs/rock1.png'
			density=0
			layer=MOB_LAYER

turf //outdated version of Terrain, dont use this, its being phased out.
	mountain
		rockyground
			icon='icons/mountain.dmi'
			icon_state="rockyground"
			rup
				icon_state="rup"
			rdown
				icon_state="rdown"
			rleft
				icon_state="rleft"
			rright
				icon_state="rright"
		SandSouth
			icon='icons/mountain.dmi'
			icon_state="ssouth"
		SandNorth
			icon='icons/mountain.dmi'
			icon_state="snorth"
		SandEast
			icon='icons/mountain.dmi'
			icon_state="seast"
		SandWest
			icon='icons/mountain.dmi'
			icon_state="swest"
		Grass
			icon='icons/mountain.dmi'
			icon_state ="grass"
			density=0
		DGrass
			icon='icons/mountain.dmi'
			icon_state ="dgrass"
			density=0
		LDGrass
			icon='icons/mountain.dmi'
			icon_state ="ldgrass"
			density=0
		Sand
			icon='icons/mountain.dmi'
			icon_state ="sand"
			density=0
			/*Entered(atom/movable/O)
				spawn(3)
					if(istype(O,/mob/human) && O:client && length(src.overlays)<5)
						if(O:runlevel<4)
							var/image/X=image('icons/sandtracks.dmi',icon_state="enter",layer=OBJ_LAYER,dir=O.dir)
							src.overlays+=X
							spawn(200)
								src.overlays-=X
						else
							var/image/X=image('icons/sandtracksrun.dmi',icon_state="enter",layer=OBJ_LAYER,dir=O.dir)
							src.overlays+=X
							spawn(200)
								src.overlays-=X
				return ..()*/


			/*Exited(atom/movable/O)
				spawn(3)

					if(istype(O,/mob/human) && O:client && length(src.overlays)<5)
						if(O:runlevel<4)
							var/image/X=image('icons/sandtracks.dmi',icon_state="exit",layer=OBJ_LAYER,dir=O.dir)
							src.overlays+=X
							spawn(200)
								src.overlays-=X
						else
							var/image/X=image('icons/sandtracksrun.dmi',icon_state="exit",layer=OBJ_LAYER,dir=O.dir)
							src.overlays+=X
							spawn(200)
								src.overlays-=X
				return ..()*/


		Dirt
			icon = 'icons/mountain.dmi'
			icon_state = "dirt"
			density = 0
		Dirtbottom
			icon = 'icons/mountain.dmi'
			icon_state = "bottom"
			density = 1
		Dirtup
			icon = 'icons/mountain.dmi'
			icon_state = "up"
			density = 1
		Dirtleft
			icon = 'icons/mountain.dmi'
			icon_state = "left"
			density = 1
		Dirtright
			icon = 'icons/mountain.dmi'
			icon_state = "right"
			density = 1
		Dirttl
			icon = 'icons/mountain.dmi'
			icon_state = "tl"
			density = 1
		Dirttr
			icon = 'icons/mountain.dmi'
			icon_state = "tr"
			density = 1

		Grassbottom
			icon = 'icons/mountain.dmi'
			icon_state = "gbottom"
			density = 1
		Grassup
			icon = 'icons/mountain.dmi'
			icon_state = "gtop"
			density = 1
		Grassleft
			icon = 'icons/mountain.dmi'
			icon_state = "gleft"
			density = 1
		Grassright
			icon = 'icons/mountain.dmi'
			icon_state = "gright"
			density = 1
		Grasstl
			icon = 'icons/mountain.dmi'
			icon_state = "gtl"
			density = 1

		Grasstr
			icon = 'icons/mountain.dmi'
			icon_state = "gtr"
			density = 1
		Sandbottom
			icon = 'icons/mountain.dmi'
			icon_state = "sbottom"
			density = 1
		Sandup
			icon = 'icons/mountain.dmi'
			icon_state = "stop"
			density = 1
		Sandleft
			icon = 'icons/mountain.dmi'
			icon_state = "sleft"
			density = 1
		Sandright
			icon = 'icons/mountain.dmi'
			icon_state = "sright"
			density = 1
		Sandtl
			icon = 'icons/mountain.dmi'
			icon_state = "stl"
			density = 1
		Sandtr
			icon = 'icons/mountain.dmi'
			icon_state = "str"
			density = 1

		cliffbl
			icon = 'icons/mountain.dmi'
			icon_state = "bl"
			density = 1
			layer=MOB_LAYER
		cliffbr
			icon = 'icons/mountain.dmi'
			icon_state = "br"
			density = 1
			layer=MOB_LAYER
		Side
			layer=MOB_LAYER
			icon='icons/mountain.dmi'
			icon_state="side"
			density=1
		cliff
			icon = 'icons/mountain.dmi'
			icon_state = "cliff-drop"
			density = 1
			layer=MOB_LAYER
		Hokage_hill_new
			icon = 'icons/hokagemountain.dmi'
			density=1
			m1
				icon_state="m1"
				density=0
			m2
				icon_state="m2"
			m3
				icon_state="m3"
			m4
				icon_state="m4"
			m5
				icon_state="m5"
		Hokage_hill
			icon = 'icons/hokagemountain.dmi'
			cliffbl
				icon = 'icons/hokagemountain.dmi'
				icon_state = "bl"
				density = 1
				layer=MOB_LAYER
			cliffbr
				icon = 'icons/hokagemountain.dmi'
				icon_state = "br"
				density = 1
				layer=MOB_LAYER
			Side
				layer=MOB_LAYER
				icon = 'icons/hokagemountain.dmi'
				icon_state="side"
				density=1
			cliff
				icon = 'icons/hokagemountain.dmi'
				icon_state = "cliff-drop"
				density = 1
				layer=MOB_LAYER
			tleft
				icon_state = "tleft"
			tbottom
				icon_state = "tbottom"
			tright
				icon_state = "tright"
			ttop
				icon_state = "tup"
			left
				icon_state = "left"
				layer=MOB_LAYER+3
			right
				icon_state = "right"
				layer=MOB_LAYER+3