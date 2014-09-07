turf
	Title
		icon='pngs/goatitle.png'
		mouse_opacity = 0
	Select
		icon='pngs/goatitle2.png'
		mouse_opacity = 0
	Creation
		icon='pngs/charactercreation.png'
		mouse_opacity = 0
	Skilltreeselection
		icon='pngs/skillmenus.png'
		mouse_opacity = 0
	Tree_Clan
		icon='pngs/Skill-Menu-Clan.png'
		mouse_opacity = 0
	Tree_Non_Clan
		icon='pngs/Skill-Menu-Non.png'
		mouse_opacity = 0
	Tree_Passive
		icon='pngs/Skill-Menu-Passive.png'
		mouse_opacity = 0
	KonohaTraits
		icon='pngs/konohatraits.png'
	MistTraits
		icon='pngs/kiritraits.png'
	SunaTraits
		icon='pngs/sunatraits.png'

	tutorial
		tutorial1
			icon='pngs/tutorial1.png'
		tutorial2
			icon='pngs/tutorial2.png'
		NextPage
			Click()
				if(usr.client)usr.client.eye=locate(85,40,2)
		PrevPage
			Click()
				if(usr.client)usr.client.eye=locate(67,40,2)
		Done
			Click()
				if(usr.client)
					usr.client.eye=usr.client.mob
					usr.client.mob.hidestat=0

	Creation2
		icon='CreationScreen/creation.png'

	memberwarp

	towerdoor



obj
	skilltree
		Back
			mouse_opacity = 2
		Clan_C
			mouse_opacity = 2
		Nonclan_C
			mouse_opacity = 2
		Passive_C
			mouse_opacity = 2
		Skillpoints
			mouse_opacity = 2
			icon='pngs/skillpoints.png'

	Creation2
		Konoha_C
			mouse_opacity = 2
			icon='CreationScreen/leaf.png'
		Suna_C
			mouse_opacity = 2
			icon='CreationScreen/sand.png'
		Mist_C
			mouse_opacity = 2
			icon='CreationScreen/mist.png'
		Nonclan_C
			mouse_opacity = 2
			icon='CreationScreen/non-clan.png'
		Clan_C
			mouse_opacity = 2
			icon='CreationScreen/clan.png'
		Info_C
			mouse_opacity = 2
			icon='CreationScreen/info.png'

	FinishCharCreate
		mouse_opacity = 2

	Done
		mouse_opacity = 2

	cNew
		mouse_opacity = 2
	cLoad
		mouse_opacity = 2
	cDelete
		mouse_opacity = 2
	cgameQuit
		mouse_opacity = 2
	cEnter
		mouse_opacity = 2

	hair_creation
		mouse_opacity = 2
		hair1
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair1"
		hair2
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair2"
		hair3
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair3"
		hair4
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair4"
		hair5
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair5"
		hair6
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair6"
		hair7
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair7"
		hair8
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair8"
		hair9
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair9"
		hair10
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair10"
		hair11
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair11"
		hair12
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair12"
		hair13
			layer = MOB_LAYER
			icon='icons/hairs.dmi'
			icon_state="hair13"
		hair0
			layer = MOB_LAYER
			icon='icons/charcreate.dmi'
			icon_state="none"

	bases
		layer = MOB_LAYER
		mouse_opacity = 2
		base3
			icon='icons/base_m3.dmi'
		base2
			icon='icons/base_m2.dmi'
		base1
			icon='icons/base_m1.dmi'

	haircolor
		layer = MOB_LAYER
		mouse_opacity = 2
		icon='icons/haircolors.dmi'
		haircolor1
			icon_state="0,1"
		haircolor2
			icon_state="1,1"
		haircolor3
			icon_state="2,1"
		haircolor4
			icon_state="3,1"
		haircolor5
			icon_state="4,1"
		haircolor6
			icon_state="5,1"
		haircolor7
			icon_state="6,1"
		haircolor8
			icon_state="7,1"
		haircolor9
			icon_state="8,1"
		haircolor10
			icon_state="9,1"
		haircolor11
			icon_state="0,0"
		haircolor12
			icon_state="1,0"
		haircolor13
			icon_state="2,0"
		haircolor14
			icon_state="3,0"
		haircolor15
			icon_state="4,0"
		haircolor16
			icon_state="5,0"
		haircolor17
			icon_state="6,0"
		haircolor18
			icon_state="7,0"
		haircolor19
			icon_state="8,0"
		haircolor20
			icon_state="9,0"
		haircolor21
			icon_state="10,0"
		haircolor_rgb
			icon='icons/charcreate.dmi'
			icon_state="rgb"

turf/Housewall
	White
		icon='icons/houseturf.dmi'
		density=0
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Right
			icon_state="r"
		Left
			icon_state="l"
		Door
			icon_state="door"
	DWhite
		icon='icons/houseturf.dmi'
		density=1
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Right
			icon_state="r"
		Left
			icon_state="l"
	Yellow
		icon='icons/houseturfyellow.dmi'
		density=0
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Right
			icon_state="r"
		Left
			icon_state="l"
		Door
			icon_state="door"
	DYellow
		icon='icons/houseturfyellow.dmi'
		density=1
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Right
			icon_state="r"
		Left
			icon_state="l"
	Dark
		icon='icons/housedark.dmi'
		density=0
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Rightt
			icon_state="rt"
		Leftt
			icon_state="lt"
		Right
			icon_state="r"
		Left
			icon_state="l"
		Door
			icon_state="door"
		LightBrown
		Roof
			icon='icons/roofinglightbrown.dmi'
			roof
				icon_state="roof"
			edge

				icon_state="edge"
			edgeleft

				icon_state="edge_left"
			edgeright

				icon_state="edge_right"
			edgetop
				icon_state="edge_top"
			roofpeak1

				icon_state="roof_peak1"
			roofpeak2

				icon_state="roof_peak2"
	DDark
		icon='icons/housedark.dmi'
		density=1
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Right
			icon_state="r"
		Left
			icon_state="l"
		Door
			icon_state="door"
			density=0
	Red
		icon='icons/houseturfred.dmi'
		density=0
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Right
			icon_state="r"
		Left
			icon_state="l"
		Door
			icon_state="door"
	DRed
		icon='icons/houseturfred.dmi'
		density=1
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Right
			icon_state="r"
		Left
			icon_state="l"
	Blue
		icon='icons/houseturfblue.dmi'
		density=0
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Right
			icon_state="r"
		Left
			icon_state="l"
		Door
			icon_state="door"
	DBlue
		icon='icons/houseturfblue.dmi'
		density=1
		layer=MOB_LAYER+1
		Main
			icon_state=""
		Right
			icon_state="r"
		Left
			icon_state="l"

turf/hokagebuilding
	layer=MOB_LAYER+1
	icon='pngs/hokage.png'
	density=0

obj/skilltree
	progress
		icon='icons/gui.dmi'
		icon_state="progress"
		layer=9999999999999
	level25
		icon='icons/gui2.dmi'
		icon_state="level25"
	line1
		icon='icons/gui.dmi'
		icon_state="line1"
	line2
		icon='icons/gui.dmi'
		icon_state="line2"
	line3
		icon='icons/gui.dmi'
		icon_state="line3"
	line4
		icon='icons/gui.dmi'
		icon_state="line4"
	line5
		icon='icons/gui.dmi'
		icon_state="line5"
	line6
		icon='icons/gui.dmi'
		icon_state="line6"
	line7
		icon='icons/gui.dmi'
		icon_state="line7"
	line8
		icon='icons/gui.dmi'
		icon_state="line8"
	line9
		icon='icons/gui.dmi'
		icon_state="line9"
	line10
		icon='icons/gui.dmi'
		icon_state="line10"
	line11
		icon='icons/gui.dmi'
		icon_state="line11"
	line12
		icon='icons/gui.dmi'
		icon_state="line12"
	line13
		icon='icons/gui.dmi'
		icon_state="line13"
	line14
		icon='icons/gui.dmi'
		icon_state="line14"
	line15
		icon='icons/gui.dmi'
		icon_state="line15"
	line16
		icon='icons/gui.dmi'
		icon_state="line16"


obj
	fence
		density=1
		icon='icons/scenic.dmi'
		ftop
			density=0
			layer=MOB_LAYER+1
			icon_state="fencet"

		ftopl
			density=0
			layer=MOB_LAYER+1
			icon_state="fencetl"
		ftopr
			density=0
			layer=MOB_LAYER+1
			icon_state="fencetr"
		fbot
			icon_state="fenceb"


		fleftb
			icon_state="fencelb"


		frightb
			icon_state="fencerb"

		fleft
			icon_state="fencel"


		fleftp
			icon_state="fencel"
			density=0
			layer=MOB_LAYER+1
		frightp
			icon_state="fencer"
			density=0
			layer=MOB_LAYER+1
		fright
			icon_state="fencer"

		placable
			icon=0
turf
	indoor
		WallWhite
			icon='icons/wallwhite.dmi'
			density=1
			B
				icon_state="b"
			T
				icon_state="t"
			BL
				icon_state="bl"
			BR
				icon_state="br"
			TL
				icon_state="tl"
			TR
				icon_state="tr"
		walls
			density=1
			icon='icons/indoor.dmi'
			sidelwall
				icon_state="sidelwall"
				layer=MOB_LAYER+3
			siderwall
				icon_state="siderwall"
				layer=MOB_LAYER+3
			sideltop
				icon_state="sideltop"
				layer=MOB_LAYER+3
			sidertop
				icon_state="sidertop"
				layer=MOB_LAYER+3
			b1
				icon='icons/wallwhite.dmi'
				icon_state="bl"
			b2
				icon='icons/wallwhite.dmi'
				icon_state="b"
			b3
				icon='icons/wallwhite.dmi'
				icon_state="br"
			t1
				icon='icons/wallwhite.dmi'
				icon_state="tl"
			t2
				icon='icons/wallwhite.dmi'
				icon_state="t"
			t3
				icon='icons/wallwhite.dmi'
				icon_state="tr"
			sideu
				icon_state="sideu"
				layer=MOB_LAYER+3
			sided
				icon_state="sided"
				layer=MOB_LAYER+3
			sider
				icon_state="sider"
				layer=MOB_LAYER+3
			sidel
				icon_state="sidel"
				layer=MOB_LAYER+3
			corner1
				icon_state="corner1"
				layer=MOB_LAYER+3
			corner2
				icon_state="corner2"
				layer=MOB_LAYER+3
			corner3
				icon_state="corner3"
				layer=MOB_LAYER+3
			corner4
				icon_state="corner4"
				layer=MOB_LAYER+3
		floor
			density=0
			icon='icons/indoor.dmi'
			marble
				icon_state="marble"
			wood
				icon='icons/flooring.dmi'
				icon_state="wood"
			dojo
				icon='icons/flooring.dmi'
				icon_state="dojo"


obj
	Signs
		pixel_x=10
		layer=MOB_LAYER+1
		store
			icon='icons/scenic.dmi'
			icon_state="store"
		hospital
			icon='icons/scenic.dmi'
			icon_state="hospital"
		academy
			icon='icons/scenic.dmi'
			icon_state="academy"
		windowu
			icon='icons/konohahouse2.dmi'
			icon_state="window2up"
		windowd
			icon='icons/konohahouse2.dmi'
			icon_state="window2down"
		windowdbottom
			icon='icons/konohahouse2.dmi'
			icon_state="window2down"
			density=1
			layer=TURF_LAYER+0.1
		barber
			density=1
			icon='icons/scenic.dmi'
			icon_state="barber"
		barber2
			icon='icons/scenic.dmi'
			icon_state="barber2"
		apparel
			icon='icons/scenic.dmi'
			icon_state="apparel"
		apparel2
			icon='icons/scenic.dmi'
			icon_state="apparel2"
		dojo
			icon='icons/scenic.dmi'
			icon_state="dojo"
		weapons
			icon='icons/scenic.dmi'
			icon_state="weapons"
		academy2
			icon='icons/scenic.dmi'
			icon_state="academy2"
		hospital2
			icon='icons/scenic.dmi'
			icon_state="hospital2"
obj
	House_Detail
		layer=MOB_LAYER+1
		density=0
		icon='icons/housedetail.dmi'
		window
			icon_state="window"
turf
	konoha
		layer=MOB_LAYER+1
		density=0

		buildings
			door
				density=1
				layer=TURF_LAYER+0.1
				icon='icons/konohahouse.dmi'
				icon_state="enter"
			window
				store
					icon='icons/scenic.dmi'
					icon_state="store"
				hospital
					icon='icons/scenic.dmi'
					icon_state="hospital"
				academy
					icon='icons/scenic.dmi'
					icon_state="academy"
				windowu
					icon='icons/konohahouse2.dmi'
					icon_state="window2up"
				windowd
					icon='icons/konohahouse2.dmi'
					icon_state="window2down"
				windowdbottom
					icon='icons/konohahouse2.dmi'
					icon_state="window2down"
					density=1
					layer=TURF_LAYER+0.1
				barber
					density=1
					icon='icons/scenic.dmi'
					icon_state="barber"
				barber2
					icon='icons/scenic.dmi'
					icon_state="barber2"
				apparel
					icon='icons/scenic.dmi'
					icon_state="apparel"
				apparel2
					icon='icons/scenic.dmi'
					icon_state="apparel2"
				dojo
					icon='icons/scenic.dmi'
					icon_state="dojo"
				weapons
					icon='icons/scenic.dmi'
					icon_state="weapons"
				academy2
					icon='icons/scenic.dmi'
					icon_state="academy2"
				hospital2
					icon='icons/scenic.dmi'
					icon_state="hospital2"
			house1
				icon='icons/house1.dmi'
				t1
					icon_state="t1"
				t2
					icon_state="t2"
				t3
					icon_state="t3"
				t4
					icon_state="t4"
				t5
					icon_state="t5"
				t6
					icon_state="t6"
				t7
					icon_state="t7"
				b1
					icon_state="b1"
				b2
					icon_state="b2"
				b3
					icon_state="b3"
				b35
					icon_state="b35"
				t35
					icon_state="t35"
				b4
					icon_state="b4"
				b5
					icon_state="b5"
				b6
					icon_state="b6"
				b7
					icon_state="b7"
				base
					layer=TURF_LAYER+0.1
					density=1
					b7c
						icon_state="bc7"
					b1c
						icon_state="bc1"
					bb2
						icon_state="b2"
					bb3
						icon_state="b3"
					bb4
						icon_state="b4"
					bb5
						icon_state="b5"
					bb6
						icon_state="b6"
					bb35
						icon_state="b35"
			house2
				icon='icons/house2.dmi'
				t1
					icon_state="t1"
				t2
					icon_state="t2"
				t3
					icon_state="t3"
				t4
					icon_state="t4"
				t5
					icon_state="t5"
				t6
					icon_state="t6"
				t7
					icon_state="t7"
				b1
					icon_state="b1"
				b2
					icon_state="b2"
				b3
					icon_state="b3"
				b35
					icon_state="b35"
				t35
					icon_state="t35"
				b4
					icon_state="b4"
				b5
					icon_state="b5"
				b6
					icon_state="b6"
				b7
					icon_state="b7"
				base
					layer=TURF_LAYER+0.1
					density=1
					b7c
						icon_state="bc7"
					b1c
						icon_state="bc1"
					bb2
						icon_state="b2"
					bb3
						icon_state="b3"
					bb4
						icon_state="b4"
					bb5
						icon_state="b5"
					bb6
						icon_state="b6"
					bb35
						icon_state="b35"
			house3
				icon='icons/house3.dmi'
				t1
					icon_state="t1"
				t2
					icon_state="t2"
				t3
					icon_state="t3"
				t4
					icon_state="t4"
				t5
					icon_state="t5"
				t6
					icon_state="t6"
				t7
					icon_state="t7"
				b1
					icon_state="b1"
				b2
					icon_state="b2"
				b3
					icon_state="b3"
				b35
					icon_state="b35"
				t35
					icon_state="t35"
				b4
					icon_state="b4"
				b5
					icon_state="b5"
				b6
					icon_state="b6"
				b7
					icon_state="b7"
				base
					layer=TURF_LAYER+0.1
					density=1
					b7c
						icon_state="bc7"
					b1c
						icon_state="bc1"
					bb2
						icon_state="b2"
					bb3
						icon_state="b3"
					bb4
						icon_state="b4"
					bb5
						icon_state="b5"
					bb6
						icon_state="b6"
					bb35
						icon_state="b35"

			roof
				layer=MOB_LAYER+1
				density=0
				icon='icons/roof.dmi'
				rlc
					icon_state="rlc"
				rb
					icon_state="rb"
				r1
					icon_state="r1"
				rrc
					icon_state="rrc"
				r2
					icon_state="r2"
				rl
					icon_state="rl"
				ru1
					icon_state="ru1"
				ru2
					icon_state="ru2"
				r3
					icon_state="r3"
				ru3
					icon_state="ru3"
				rr
					icon_state="rr"
				r1b
					icon_state="r1b"
				r2b
					icon_state="r2b"
				r3b
					icon_state="r3b"
				r1bh
					icon_state="r1bh"
				r2bh
					icon_state="r2bh"
				r3bh
					icon_state="r3bh"
	buildings
		icon='icons/buildings.dmi'
		density=0
		test
			layer=MOB_LAYER+1
			roofing
				roof
					icon='icons/konohahouse.dmi'
					icon_state="roof"
				shingles_up
					icon='icons/konohahouse.dmi'
					icon_state="offnorth"
				shingles_down
					icon='icons/konohahouse.dmi'
					icon_state="offsouth"
				shingles_east
					icon='icons/konohahouse.dmi'
					icon_state="offeast"
				shingles_west
					icon='icons/konohahouse.dmi'
					icon_state="offwest"

				roof2
					icon='icons/konohahouse2.dmi'
					icon_state="roof2"
				shingles_up2
					icon='icons/konohahouse2.dmi'
					icon_state="offnorth2"
				shingles_down2
					icon='icons/konohahouse2.dmi'
					icon_state="offsouth2"
				shingles_east2
					icon='icons/konohahouse2.dmi'
					icon_state="offeast2"
				shingles_west2
					icon='icons/konohahouse2.dmi'
					icon_state="offwest2"
				roof3
					icon='icons/konohahouse3.dmi'
					icon_state="roof3"
				roof1half
					icon='icons/konohahouse.dmi'
					icon_state="roof1half"
				roof2half
					icon='icons/konohahouse2.dmi'
					icon_state="roof2half"
				roof3half
					icon='icons/konohahouse3.dmi'
					icon_state="roof3half"
				roof4half
					icon='icons/konohahouse4.dmi'
					icon_state="roof4half"
				shingles_up3
					icon='icons/konohahouse3.dmi'
					icon_state="offnorth3"
				shingles_down3
					icon='icons/konohahouse3.dmi'
					icon_state="offsouth3"
				shingles_east3
					icon='icons/konohahouse3.dmi'
					icon_state="offeast3"
				shingles_west3
					icon='icons/konohahouse3.dmi'
					icon_state="offwest3"

				roof4
					icon='icons/konohahouse4.dmi'
					icon_state="roof4"
				shingles_up4
					icon='icons/konohahouse4.dmi'
					icon_state="offnorth4"
				shingles_down4
					icon='icons/konohahouse4.dmi'
					icon_state="offsouth4"
				shingles_east4
					icon='icons/konohahouse4.dmi'
					icon_state="offeast4"
				shingles_west4
					icon='icons/konohahouse4.dmi'
					icon_state="offwest4"
			walls
				layer=TURF_LAYER+0.1
				density=1
				greybase
					icon='icons/konohahouse2.dmi'
					icon_state="grey"
				peachbase
					icon='icons/konohahouse.dmi'
					icon_state="peach"
				bluebase
					icon='icons/konohahouse3.dmi'
					icon_state="blue"
				grey
					icon='icons/konohahouse2.dmi'
					icon_state="grey"
					density=0
					layer=MOB_LAYER+1
				greyright
					icon='icons/konohahouse2.dmi'
					icon_state="greyright"
				greyleft
					icon='icons/konohahouse2.dmi'
					icon_state="greyleft"
				peach
					icon='icons/konohahouse.dmi'
					icon_state="peach"
					density=0
					layer=MOB_LAYER+1
				peachright
					icon='icons/konohahouse.dmi'
					icon_state="peachright"
				peachleft
					icon='icons/konohahouse.dmi'
					icon_state="peachleft"
				blue
					icon='icons/konohahouse3.dmi'
					icon_state="blue"
					density=0
					layer=MOB_LAYER+1
				blueright
					icon='icons/konohahouse3.dmi'
					icon_state="blueright"
				blueleft
					icon='icons/konohahouse3.dmi'
					icon_state="blueleft"

			details
				layer=MOB_LAYER+1
				density=0
				window
					icon='icons/konohahouse.dmi'
					icon_state="window"
				window2
					icon='icons/konohahouse2.dmi'
					icon_state="window2"
				window2l
					icon='icons/konohahouse2.dmi'
					icon_state="window2l"
				window2r
					icon='icons/konohahouse2.dmi'
					icon_state="window2r"
				window2u
					icon='icons/konohahouse2.dmi'
					icon_state="window2up"
				window2d
					icon='icons/konohahouse2.dmi'
					icon_state="window2down"
				window3
					icon='icons/konohahouse3.dmi'
					icon_state="window3"
				window4
					icon='icons/konohahouse4.dmi'
					icon_state="window4"
				left
					icon='icons/konohahouse.dmi'
					icon_state="left"
				right
					icon='icons/konohahouse.dmi'
					icon_state="right"
				embleft
					icon='icons/konohahouse4.dmi'
					icon_state="embleft"
				embright
					icon='icons/konohahouse4.dmi'
					icon_state="embright"
				top1
					icon='icons/konohahouse4.dmi'
					icon_state="top1"
				top2
					icon='icons/konohahouse4.dmi'
					icon_state="top2"
			enter
				layer=TURF_LAYER+0.1
				icon='icons/konohahouse.dmi'
				icon_state="enter"


		generic
			roof
				icon_state="roof"
				layer=MOB_LAYER+1
			cord
				icon_state="cord"
				layer=MOB_LAYER+1
			cord2
				icon_state="cord2"
				layer=MOB_LAYER+1
			cord3

				icon_state="cord3"
				layer=MOB_LAYER+1
			cord4
				icon_state="cord4"
				layer=MOB_LAYER+1
			shinglesl
				icon_state="shinglesl"
				layer=MOB_LAYER+1
			shingles2l
				icon_state="shingles2l"
				layer=MOB_LAYER+1
			shingles3l
				icon_state="shingles3l"
				layer=MOB_LAYER+1
			shinglesr
				icon_state="shinglesr"
				layer=MOB_LAYER+1
			shingles2r
				icon_state="shingles2r"
				layer=MOB_LAYER+1
			shingles3r
				icon_state="shingles3r"
				layer=MOB_LAYER+1
			shingles
				icon_state="shingles"
				layer=MOB_LAYER+1
			shingles2
				icon_state="shingles2"
				layer=MOB_LAYER+1
			shingles3
				icon_state="shingles3"
				layer=MOB_LAYER+1
			plain
				icon_state="plain"
				layer=MOB_LAYER+1
			plainbase
				density=1
				icon_state="plain"
				layer=TURF_LAYER+0.1
			window
				icon_state="window"
				layer=MOB_LAYER+1
			door
				density=1
				icon_state="door"
				layer=TURF_LAYER+0.1
			edgel
				icon_state="edgel"
				layer=TURF_LAYER+0.1
			sidel
				icon_state="sidel"
				layer=TURF_LAYER+0.1
			edger
				icon_state="edger"
				layer=TURF_LAYER+0.1
			sider
				icon_state="sider"
				layer=TURF_LAYER+0.1


turf


	Terrain
		icon='icons/Terrainset.dmi'
		density=0
		Water
			icon_state="5"
			density=1
		GrassFod
			icon='icons/fodturf.dmi'
			icon_state="grass"
		Grass
			icon='icons/mountain.dmi'
			icon_state="grass"
		Desert
			Desert1
				icon_state="1"
			Desert2
				icon_state="2"
			Desert3
				icon_state="3"
			Desert4
				icon_state="4"
			Desert6
				icon_state="6"
			Desert7
				icon_state="7"
			Desert8
				icon_state="8"
			Desert9
				icon_state="9"
			Desert10
				icon_state="10"
			Desert11
				icon_state="11"
			Desert12
				icon_state="12"
			Desert13
				icon_state="13"
			Desert14
				icon_state="14"
				density=1
			Desert15
				icon_state="15"
				density=1
			Desert16
				density=1
				icon_state="16"
			Desert17
				density=1
				icon_state="17"
			Desert18
				density=1
				icon_state="18"
			Desert19
				density=1
				icon_state="19"
			Desert20
				icon_state="20"
			Desert21
				density=1
				icon_state="21"
			Desert22
				density=1
				icon_state="22"
			Desert23
				density=1
				icon_state="23"
			Desert24
				density=1
				icon_state="24"
			Desert25
				icon_state="25"
			Desert26
				icon_state="26"
			Desert27
				icon_state="27"
			Desert28
				icon_state="28"
			Desert29
				icon_state="29"
			Desert30
				icon_state="30"
			Desert31
				icon_state="31"
			Desert32
				icon_state="32"
			Desert33
				icon_state="33"
			Desert34
				icon_state="34"
			Desert35
				icon_state="35"
			Desert36
				icon_state="36"
			Desert37
				icon_state="37"
			Desert38
				icon_state="38"
			Desert39
				icon_state="39"
			Desert40
				icon_state="40"
			Desert41
				icon_state="41"
			Desert42
				density=1
				icon_state="42"
			Desert43
				density=1
				icon_state="43"
			Desert44
				density=1
				icon_state="44"
			Desert45
				density=1
				icon_state="45"
			Desert46
				density=1
				icon_state="46"
			Desert47
				density=1
				icon_state="47"
			Desert48
				density=1
				icon_state="48"
			Desert49
				density=1
				icon_state="49"
			Desert50
				density=1
				icon_state="50"
			Desert51
				density=1
				icon_state="51"
			Desert52
				density=1
				icon_state="52"
			Desert53
				density=1
				icon_state="53"
			Desert54
				density=1
				icon_state="54"
			Desert55
				icon_state="55"

	zinviswall
		density = 1

turf/warp
	tosecondmap
		Entered(o)
			usr=o
			usr.loc=locate(usr.x,99,5)
			..()
	leavesecondmap
		Entered(o)
			usr=o
			usr.loc=locate(usr.x,2,1)
			..()
	toclothing
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				//usr.stunned+=2
				sleep(10)
				if(usr.dir==NORTH||usr.dir==NORTHEAST||usr.dir==NORTHWEST)
					usr.loc=locate(22,61,3)
			..()
	leaveclothing
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))

				usr.loc=locate(19,63,1)
			..()
	todojo
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				//usr.stunned+=2
				sleep(10)
				if(usr.dir==NORTH||usr.dir==NORTHEAST||usr.dir==NORTHWEST)
					usr.loc=locate(47,4,3)
			..()
	leavedojo
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				usr.loc=locate(8,72,1)
			..()
	tobarber
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				//usr.stunned+=2
				sleep(10)
				if(usr.dir==NORTH||usr.dir==NORTHEAST||usr.dir==NORTHWEST)
					usr.loc=locate(26,73,3)
			..()
	leavebarber
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				usr.loc=locate(40,47,1)
			..()
	toskilltraining
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc) && usr.rank=="Academy Student")
				if(usr.dir==NORTH||usr.dir==NORTHEAST||usr.dir==NORTHWEST)
					usr.loc=locate(21,23,3)
			..()
	leaveskilltraining
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				usr.loc=locate(6,94,3)
			..()
	toweaptraining
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc) && usr.rank=="Academy Student")

				if(usr.dir==NORTH||usr.dir==NORTHEAST||usr.dir==NORTHWEST)
					usr.loc=locate(8,24,3)
			..()
	leaveweaptraining
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc)&& usr.rank=="Academy Student")
				usr.loc=locate(4,94,3)
			..()
	toschool
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				//usr.stunned+=2
				sleep(10)
				if(usr.dir==NORTH||usr.dir==NORTHEAST||usr.dir==NORTHWEST)
					usr.loc=locate(9,6,3)
			..()
	leaveschool
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				usr.loc=locate(16,94,3)
			..()
	tonoob
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				//usr.stunned+=2
				sleep(10)
				if(usr.dir==NORTH||usr.dir==NORTHEAST||usr.dir==NORTHWEST)
					usr.loc=locate(10,88,3)
			..()
	leavenoob
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				if(usr.rank!="Academy Student")
					usr.loc=locate(40,57,1)
				else
					alert(usr,"You cant leave the academy until you become a Genin.")
					return 1
			..()
	totesthouse
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				//usr.stunned+=2
				sleep(10)
				if(usr.dir==NORTH||usr.dir==NORTHEAST||usr.dir==NORTHWEST)
					usr.loc=locate(10,61,3)
			..()
	outtesthouse
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				usr.loc=locate(24,54,1)
			..()
	tohospital
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				//usr.stunned+=2
				sleep(10)
				if(usr.dir==NORTH||usr.dir==NORTHEAST||usr.dir==NORTHWEST)
					usr.loc=locate(91,11,3)
			..()
	outhospital
		Entered(o)
			usr=o
			if(istype(usr,/mob/human/player) && !istype(usr,/mob/human/player/npc))
				usr.loc=locate(45,67,1)
			..()

obj
	dirarrows
		icon='icons/charcreate.dmi'
		right
			icon_state="right"
		left
			icon_state="left"
		up
			icon_state="up"
		down
			icon_state="down"

	eyecolor
		pixel_y=16
		icon='icons/eye colors.dmi'
		eyecolor1
			icon_state="0,0"
		eyecolor2
			icon_state="1,0"
		eyecolor3
			icon_state="2,0"
		eyecolor4
			icon_state="3,0"
		eyecolor5
			icon_state="4,0"
		eyecolor6
			icon_state="5,0"
		eyecolor7
			icon_state="6,0"
		eyecolor_rgb
			icon='icons/charcreate.dmi'
			icon_state="rgb"

	Blank_Slot
		icon='CreationScreen/blank.png'
		Slot1
		Slot2
		Slot3
		Slot4
		Slot5
		Slot6

	dojorespawn
		density=0

	arenaspawn
		density=0

	decoy
		icon='icons/gui.dmi'
		icon_state="decoy"
		dir=EAST

	interactable
		paper
			icon='icons/scenic.dmi'
			icon_state="paper"

	gui
		layer=9
		icon='icons/gui.dmi'

		fakecards
			skillpoints
				icon='pngs/skillpoints.png'
			levelups
				icon='pngs/levelups.png'
			upint
				icon='pngs/upint.png'
			upstr
				icon='pngs/upstr.png'
			uprfx
				icon='pngs/uprfx.png'
			upcon
				icon='pngs/upcon.png'
			levelup
				icon='icons/levelup.dmi'
			goldborder
				icon_state="golden"
			arrow
				proc/on_shift_click(mob/user)
				rfx_uparrow
					icon_state="up"
				str_uparrow
					icon_state="up"
				int_uparrow
					icon_state="up"
				con_uparrow
					icon_state="up"

		passives
			icon='icons/gui2.dmi'
			gauge
				str
					icon_state="str"
				rfx
					icon_state="rfx"
				int
					icon_state="int"
				con
					icon_state="con"
			str
				Force
					icon_state="34"
				Built_Solid
					icon_state="9"
				Piercing_Strike
					icon_state="10"
				Endurance
					icon_state="35"
				Brutality
					icon_state="11"
				Flurry
					icon_state="26"
			rfx
				Bombardment
					icon_state="28"
				Evasiveness
					icon_state="31"
				Blindside
					icon_state="16"
				Speed_Demon
					icon_state="4"
				Open_Wounds
					icon_state="17"
				Weapon_Mastery
					icon_state="32"
			int
				Tracking
					icon_state="8"
				Analytical
					icon_state="7"
				Genjutsu_Mastery
					icon_state="19"
				Trap_Mastery
					icon_state="20old"
				Clone_Mastery
					icon_state="1"
				Keen_Eye
					icon_state="36"
			con
				Chakra_Efficiency
					icon_state="5"
				Powerhouse
					icon_state="22"
				Medical_Training
					icon_state="23"
				Pure_Power
					icon_state="24"
				Regeneration
					icon_state="3"
				Seal_Knowledge
					icon_state="6"
