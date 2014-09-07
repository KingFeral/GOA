

mob/proc
	removeswords()
		if(src.specialover=="sword")
			src.weapon=new/list
			src.specialover=""
			src.Load_Overlays()
			sleep(1)

	addswords()
		for(var/obj/items/weapons/o in src.contents)
			if(o.equipped)
				o:Use(src)
				sleep(1)
				o:Use(src)
obj
	var

		nottossable=0
obj/items
	Click()
		if(src.deletable)
			var/remove=1
			for(var/obj/items/X in usr.contents)
				if(X.type==src.type)
					remove=0
			if(remove)
				del(src)
		..()
	verb
		Toss()
			set category=null
			if(!src.nottossable)
				for(var/obj/items/X in src.loc)
					if(istype(X,src.type))
						if(X.deletable)
							del(X)
				del(src)
	layer=11
	var
		deletable=0
		posit=0
		worn=0
	proc
		Place(S)
/*			if(src.deletable==0&&!istype(src,/obj/items/usable))
				switch(S)
					if("1")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="2,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==1)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==1)
								del(o)
						X.posit=1
						usr.macro1=src.type
					if("2")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="3,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==2)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==2)
								del(o)
						X.posit=2
						usr.macro2=src.type
					if("3")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="4,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==3)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==3)
								del(o)
						X.posit=3
						usr.macro3=src.type
					if("4")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="5,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==4)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==4)
								del(o)
						X.posit=4
						usr.macro4=src.type
					if("5")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="6,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==5)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==5)
								del(o)
						X.posit=5
						usr.macro5=src.type
					if("6")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="7,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==6)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==6)
								del(o)
						X.posit=6
						usr.macro6=src.type
					if("7")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="8,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==7)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==7)
								del(o)
						X.posit=7
						usr.macro7=src.type
					if("8")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="9,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==8)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==8)
								del(o)
						X.posit=8
						usr.macro8=src.type
					if("9")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="10,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==9)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==9)
								del(o)
						X.posit=9
						usr.macro9=src.type

					if("0")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="11,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==10)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==10)
								del(o)
						X.posit=10
						usr.macro10=src.type*/
	verb
		Remove()
			set category=null
			if(src.deletable==1)
				del(src)
		Set_Custom_Macro()
			set category=null
			var/S=null
			var/C
			if(!S)
				C=input(usr,"Bind Key to Card","Custom Macro") in Bindables
				if(C=="Remove Bind")
					src.cust_macro=null
					src.overlays-=src.macover
					src.macover=null
					return
			else
				C=S
			for(var/obj/O in usr.contents)
				if(O.cust_macro==C)
					O.cust_macro=null
					O.overlays-=O.macover
					O.macover=null

			src.cust_macro=C
			src.macover=image('fonts/Cambriacolor.dmi',icon_state="[C]")
			src.overlays+=src.macover
/*		Place_on_Screen()
			set category=null

			if(src.deletable==0&&!istype(src,/obj/items/usable))
				switch(input2(usr,"Choose a Macro/Screen Location for that ItemCard", "GUI", list ("1","2","3","4","5","6","7","8","9","0","Nevermind")))
					if("1")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="2,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==1)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==1)
								del(o)
						X.posit=1
						usr.macro1=src.type
					if("2")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="3,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==2)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==2)
								del(o)
						X.posit=2
						usr.macro2=src.type
					if("3")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="4,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==3)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==3)
								del(o)
						X.posit=3
						usr.macro3=src.type
					if("4")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="5,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==4)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==4)
								del(o)
						X.posit=4
						usr.macro4=src.type
					if("5")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="6,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==5)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==5)
								del(o)
						X.posit=5
						usr.macro5=src.type
					if("6")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="7,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==6)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==6)
								del(o)
						X.posit=6
						usr.macro6=src.type
					if("7")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="8,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==7)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==7)
								del(o)
						X.posit=7
						usr.macro7=src.type
					if("8")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="9,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==8)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==8)
								del(o)
						X.posit=8
						usr.macro8=src.type
					if("9")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="10,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==9)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==9)
								del(o)
						X.posit=9
						usr.macro9=src.type

					if("0")
						var/obj/items/X = new src.type(usr)
						usr.player_gui+=X
						X.overlays=src.overlays
						X.equipped=src.equipped
						X.install=src.install
						X.screen_loc="11,1"
						usr.client.screen+=X
						X.deletable=1
						for(var/obj/items/o in usr.client.screen)
							if(o.posit==10)
								del(o)
						for(var/obj/gui/o in usr.client.screen)
							if(o.posit==10)
								del(o)
						X.posit=10
						usr.macro10=src.type*/

obj/items
	var
		weapon
		armor


obj/items/usable
	var/oname
	New()
		src.oname=src.name
		src.equipped+=1
		src.name="[src.oname]([equipped])" //equipped is used for the quantity variable
	proc/Refreshcount(mob/human/player/O)
		O.busy=0
		for(var/obj/items/usable/x in O.contents)
			if(istype(x,src.type))
				x.equipped--
				x.name="[src.oname]([equipped])"
				if(x!=src)
					if(x.equipped<=0)
						del(x)
		if(src.equipped<=0)
			del(src)
	proc/Refreshcountdd(mob/human/player/O)
		for(var/obj/items/x in O.contents)
			if(istype(x,src.type))
				if(istext(equipped)) equipped = text2num(equipped)
				x.name="[src.oname]([equipped])"
				if(x!=src)
					if(istext(x.equipped)) x.equipped = text2num(x.equipped)
					if(x.equipped<=0)
						del(x)
		if(src.equipped<=0)
			del(src)
	Caltrop
		icon='icons/gui.dmi'
		icon_state="caltrop"
		code=213
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0&&usr.pk==1)
				usr.busy=1
				usr<<"Dropped Caltrops"
				var/i
				var/obj/o
				for(var/obj/caltrops in oview(0,usr))
					i=1
				if(i!=1)
					o=new/obj/caltrops(usr.loc)
					o.owner = usr

				src.Refreshcount(usr)
				sleep(5)

				spawn(6000)
					if(o)
						del(o)

		Click()
			Use(usr)

	Tripwire
		icon='icons/gui.dmi'
		icon_state="tripwire"
		code=214
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0&&usr.pk==1)
				usr.busy=1
				//usr.stunned=4
				usr.Timed_Stun(40)
				usr<<"Placing Trip Wire"
				var/obj/o=new/obj/trip(usr.loc)
				if(o)o.dir=usr.dir
				sleep(40)
				usr<<"Trap Complete"
				//usr.stunned=0

				src.Refreshcount(usr)
				spawn(6000)
					if(o)
						del(o)

		Click()
			Use(usr)

	Antidote
		icon='icons/gui.dmi'
		icon_state="antidote"
		code=209
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u

		Click()
			Use(usr)

	Bandage
		icon='icons/gui.dmi'
		icon_state="bandage"
		code=210
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0&&usr.stunned==0&&usr.bandaged==0)
				usr.bandaged=1
				usr.busy=1
				//usr.stunned=4
				usr.Timed_Stun(40)
				usr<<"Using Bandages..."
				sleep(40)
				usr<<"20 wounds recovered"
				usr.curwound-=20
				if(usr.curwound<0)
					usr.curwound=0
				spawn(1200)
					usr.bandaged=0
				src.Refreshcount(usr)
				usr.busy=0
			else if(usr.bandaged==1)
				usr<<"Using Bandages again so soon is pointless"
				usr.busy=0

		Click()
			Use(usr)

	Scroll
		Supplyscroll
			icon='icons/gui.dmi'
			icon_state="supplyscroll"
			code=211
			proc/Use(var/mob/u)
				set hidden=1
				set category=null

				usr=u
				if(usr.ko|| usr.stunned||usr.handseal_stun)
					return
				if(usr.busy==0)
					usr.busy=1
					usr.supplies=usr.maxsupplies
					src.Refreshcount(usr)
					usr<<"You used up a supply scroll"
					usr.busy=0

			Click()
				Use(usr)

	SoldierPill
		icon='icons/gui.dmi'
		code=212
		icon_state="soldierpill"
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			usr=u
			if(usr.ko|| usr.stunned||usr.handseal_stun)
				return
			if(usr.busy==0)
				usr.busy=1
				if(usr.soldierpill==0)
					usr.curstamina = min(usr.curstamina+3000, usr.stamina*1.5)
					usr.soldierpill=1
					spawn(2400)
						usr.soldierpill=0
						if(usr.curstamina>usr.stamina)
							usr.curstamina=usr.stamina
					usr<<"You ate a soldier pill"
					src.Refreshcount(usr)
					usr.busy=0
				else
					usr<<"Using another Soldier Pill so soon is pointless"
					usr.busy=0


		Click()
			Use(usr)

obj/items/equipable
	Kunai_Holster
		armor="legarmor"
		icon='icons/Kunai_Holster.dmi'
		icon_state="HUD"
		code=115
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor==src.armor)
					O.overlays=0
					O.overlays+=O.macover
					O.equipped=0

			if(equ)
				usr.legarmor=0
			else
				usr.legarmor=/obj/Kunai_Holster
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Arm_Guards
		armor="armarmor"
		icon='icons/arm_guards.dmi'
		icon_state="gui"
		acmod=10
		code=222
		hind=2
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor==src.armor)
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armarmor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armarmor",/obj/arm_guards)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Sasuke_Clothes
		armor="cloak"
		icon='icons/sasuke_cloth.dmi'
		icon_state="gui"
		code=129
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="cloak")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.cloak=0
			else
				usr.cloak=/obj/sasuke_cloth
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Chuunin_Leaf
		code=224
		armor="armor"
		icon='icons/chuunin-vest.dmi'
		icon_state="HUD"
		acmod=10
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/leaf)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Chuunin_Sand
		armor="armor"
		icon='icons/chuunin-vest_sand.dmi'
		icon_state="HUD"
		code=225
		acmod=10
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/sand)

			usr.Load_Overlays()
		Click()
			Use(usr)

	Chuunin_Mist
		armor="armor"
		icon='icons/chuunin-vest_mist.dmi'
		icon_state="HUD"
		acmod=10
		code=226
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.EQUIP("armor",0)
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.EQUIP("armor",/obj/chuunin/mist)

			usr.Load_Overlays()
		Click()
			Use(usr)

/*
	Hokage_Armor
		armor="armor"
		icon='hokage_armor.dmi'
		icon_state=""
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
			if(equ)
				usr.armor=0
			else
				usr.armor=/obj/Hokage/Hokage_Armor
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Hokage_Armor_Gold
		armor="armor"
		icon='hokage_armor_gold.dmi'
		icon_state=""
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
			if(equ)
				usr.armor=0
			else
				usr.armor=/obj/Hokage/Hokage_Armor_Gold
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Hokage_Armor_Blue
		armor="armor"
		icon='hokage_armor_blue.dmi'
		icon_state=""
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
			if(equ)
				usr.armor=0
			else
				usr.armor=/obj/Hokage/Hokage_Armor_Blue
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Hokage_Armor_Red
		armor="armor"
		icon='hokage_armor_red.dmi'
		icon_state=""
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
			if(equ)
				usr.armor=0
			else
				usr.armor=/obj/Hokage/Hokage_Armor_Red
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Hokage_Armor_Silver
		armor="armor"
		icon='hokage_armor_silver.dmi'
		icon_state=""
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
			if(equ)
				usr.armor=0
			else
				usr.armor=/obj/Hokage/Hokage_Armor_Silver
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)

	Hokage_Armor_Green
		armor="armor"
		icon='hokage_armor_green.dmi'
		icon_state=""
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="armor")
					O.overlays=0
					O.equipped=0
			if(equ)
				usr.armor=0
			else
				usr.armor=/obj/Hokage/Hokage_Armor_Green
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)*/


	trench
		armor="cloak"
		black
			icon='trench/trench.dmi'
			icon_state="HUD"
			code=197
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		dred
			icon='trench/trenchdred.dmi'
			icon_state="HUD"
			code=198
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/dred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dgreen
			icon='trench/trenchdgreen.dmi'
			icon_state="HUD"
			code=199
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/dgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		brown
			icon='trench/trenchbrown.dmi'
			icon_state="HUD"
			code=200
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		blue
			icon='trench/trenchblue.dmi'
			icon_state="HUD"
			code=201
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		grey
			icon='trench/trenchgrey.dmi'
			icon_state="HUD"
			code=202
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		red
			icon='trench/trenchred.dmi'
			icon_state="HUD"
			code=203
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		green
			icon='trench/trenchgreen.dmi'
			icon_state="HUD"
			code=204
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		orange
			icon='trench/trenchorange.dmi'
			icon_state="HUD"
			code=205
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dblue
			icon='trench/trenchdblue.dmi'
			icon_state="HUD"
			code=206
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/dblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		purple
			icon='trench/trenchpurple.dmi'
			icon_state="HUD"
			code=207
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/purple
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		white
			icon='trench/trenchwhite.dmi'
			icon_state="HUD"
			code=208
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/trench/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
	jacket
		armor="armor"
		black
			icon='jacket/jacket.dmi'
			icon_state="HUD"
			code=159
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		dred
			icon='jacket/jacketdred.dmi'
			icon_state="HUD"
			code=160
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/dred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dgreen
			icon='jacket/jacketdgreen.dmi'
			icon_state="HUD"
			code=161
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/dgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		brown
			icon='jacket/jacketbrown.dmi'
			icon_state="HUD"
			code=162
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		grey
			icon='jacket/jacketgrey.dmi'
			icon_state="HUD"
			code=163
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		obito
			icon='jacket/jacketobito.dmi'
			icon_state="HUD"
			code=164
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/obito
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dblue
			icon='jacket/jacketdblue.dmi'
			icon_state="HUD"
			code=165
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="armor")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.armor=0
				else
					usr.armor=/obj/jacket/dblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

	shirt_sleeves
		armor="overshirt"
		black
			icon='icons/shirt_sleeves/shirt_sleeves.dmi'
			icon_state="HUD"
			code=185
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		dred
			icon='icons/shirt_sleeves/shirt_sleevesdred.dmi'
			icon_state="HUD"
			code=186
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/dred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dgreen
			icon='icons/shirt_sleeves/shirt_sleevesdgreen.dmi'
			icon_state="HUD"
			code=187
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/dgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		brown
			icon='icons/shirt_sleeves/shirt_sleevesbrown.dmi'
			icon_state="HUD"
			code=188
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		blue
			icon='icons/shirt_sleeves/shirt_sleevesblue.dmi'
			icon_state="HUD"
			code=189
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		grey
			icon='icons/shirt_sleeves/shirt_sleevesgrey.dmi'
			icon_state="HUD"
			code=190
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		red
			icon='icons/shirt_sleeves/shirt_sleevesred.dmi'
			icon_state="HUD"
			code=191
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		green
			icon='icons/shirt_sleeves/shirt_sleevesgreen.dmi'
			icon_state="HUD"
			code=192
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		orange
			icon='icons/shirt_sleeves/shirt_sleevesorange.dmi'
			icon_state="HUD"
			code=193
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dblue
			icon='icons/shirt_sleeves/shirt_sleevesdblue.dmi'
			icon_state="HUD"
			code=194
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/dblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		purple
			icon='icons/shirt_sleeves/shirt_sleevespurple.dmi'
			icon_state="HUD"
			code=195
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/purple
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		white
			icon='icons/shirt_sleeves/shirt_sleeveswhite.dmi'
			icon_state="HUD"
			code=196
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt_sleeves/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

	cloak
		armor="cloak"
		black
			icon='cloak/cloak.dmi'
			icon_state="gui"
			code=147
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		dred
			icon='cloak/cloakdred.dmi'
			icon_state="gui"
			code=148
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/dred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dgreen
			icon='cloak/cloakdgreen.dmi'
			icon_state="gui"
			code=149
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/dgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		brown
			icon='cloak/cloakbrown.dmi'
			icon_state="gui"
			code=150
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		blue
			icon='cloak/cloakblue.dmi'
			icon_state="gui"
			code=151
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		grey
			icon='cloak/cloakgrey.dmi'
			icon_state="gui"
			code=152
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		red
			icon='cloak/cloakred.dmi'
			icon_state="gui"
			code=153
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		green
			icon='cloak/cloakgreen.dmi'
			icon_state="gui"
			code=154
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		orange
			icon='cloak/cloakorange.dmi'
			icon_state="gui"
			code=155
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		dblue
			icon='cloak/cloakdblue.dmi'
			icon_state="gui"
			code=156
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/dblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		purple
			icon='cloak/cloakpurple.dmi'
			icon_state="gui"
			code=157
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/purple
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		white
			icon='cloak/cloakwhite.dmi'
			icon_state="gui"
			code=158
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="cloak")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.cloak=0
				else
					usr.cloak=/obj/cloak/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
	Pants
		armor="pants"
		Black
			code=118
			icon='icons/pants.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Blue
			code=119
			icon='icons/pantsblue.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Red
			code=120
			icon='icons/pantsred.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		White
			code=121
			icon='icons/pantswhite.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Green
			code=122
			icon='icons/pantsgreen.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Grey
			code=123
			icon='icons/pantsgrey.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Orange
			code=124
			icon='icons/pantsorange.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Brown
			code=125
			icon='icons/pantsbrown.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/brown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightBrown
			code=126
			icon='icons/pantslightbrown.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/lightbrown
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightGrey
			code=127
			icon='icons/pantslightgrey.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/lightgrey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightBlue
			code=128
			icon='icons/pantslightblue.dmi'
			icon_state="gui"
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="pants")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.pants=0
				else
					usr.pants=/obj/pants/lightblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
	Shirt
		armor="overshirt"

		Black
			icon='icons/shirt.dmi'
			icon_state="hud"
			code=130
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Blue
			icon='icons/shirtblue.dmi'
			icon_state="hud"
			code=131
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		DarkBlue
			icon='icons/shirtdarkblue.dmi'
			icon_state="hud"
			code=132
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/darkblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightBlue
			icon='icons/shirtlightblue.dmi'
			icon_state="hud"
			code=133
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/lightblue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Orange
			icon='icons/shirtorange.dmi'
			icon_state="hud"
			code=134
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/orange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		DarkOrange
			icon='icons/shirtdarkorange.dmi'
			icon_state="hud"
			code=135
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/darkorange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightOrange
			icon='icons/shirtlightorange.dmi'
			icon_state="hud"
			code=136
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/lightorange
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Red
			icon='icons/shirtred.dmi'
			icon_state="hud"
			code=137
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		DarkRed
			icon='icons/shirtdarkred.dmi'
			icon_state="hud"
			code=138
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/darkred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightRed
			icon='icons/shirtlightred.dmi'
			icon_state="hud"
			code=139
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/lightred
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		White
			icon='icons/shirtwhite.dmi'
			icon_state="hud"
			code=140
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/white
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Green
			icon='icons/shirtgreen.dmi'
			icon_state="hud"
			code=141
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/green
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

		DarkGreen
			icon='icons/shirtdarkgreen.dmi'
			icon_state="hud"
			code=142
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/darkgreen
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		LightGrey
			icon='icons/shirtlightgrey.dmi'
			icon_state="hud"
			code=143
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/lightgrey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Grey
			icon='icons/shirtgrey.dmi'
			icon_state="hud"
			code=144
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/grey
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Yellow
			icon='icons/shirtyellow.dmi'
			icon_state="hud"
			code=145
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="overshirt")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.overshirt=0
				else
					usr.overshirt=/obj/shirt/yellow
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
	Bandage1
		armor="glasses"
		icon='icons/FaceBandage1.dmi'
		icon_state="gui"
		code=223
		proc/Use(var/mob/u)
			set hidden=1
			set category=null
			var/equ=src.equipped
			usr=u
			for(var/obj/items/O in usr.contents)
				if(O.armor=="glasses")
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				usr.glasses=0
			else
				usr.glasses=/obj/Bandage/B1
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'

			usr.Load_Overlays()
		Click()
			Use(usr)
	Headband
		armor="face"
		verb
			Headband_Preferenes()
				switch(input2(usr,"How would you like to wear your headband?","Headband", list("Above my Hair","Under my Hair","Nevermind")))
					if("Above my Hair")
						usr.overband=0
						spawn()usr.Load_Overlays()
					if("Under my Hair")
						usr.overband=1
						spawn()usr.Load_Overlays()
		Blue
			icon='icons/gui.dmi'
			icon_state="konoha_headband"
			code=112
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="face")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.facearmor=0
				else
					usr.facearmor=/obj/headband/blue
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Red
			icon='icons/gui.dmi'
			icon_state="konoha_headband"
			code=113
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="face")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.facearmor=0
				else
					usr.facearmor=/obj/headband/red
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)
		Black
			icon='icons/gui.dmi'
			icon_state="konoha_headband"
			code=114
			proc/Use(var/mob/u)
				set hidden=1
				set category=null
				var/equ=src.equipped
				usr=u
				for(var/obj/items/O in usr.contents)
					if(O.armor=="face")
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(equ)
					usr.facearmor=0
				else
					usr.facearmor=/obj/headband/black
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'

				usr.Load_Overlays()
			Click()
				Use(usr)

//	Kunai_m
//		icon='projectiles.dmi'
//		icon_state="kunai"
	verb/Get()
		set src in oview(1)
		new src.type(usr)

mob/var/tmp/obj/items/weapons/weapon_ref

obj/items/weapons
	proc/get_stamina_damage()
		. = 0

	weapon=1

	Click()
		Use(usr)

	proc/Use(mob/u)

	verb/Get()
		set src in oview(1)
		Move(usr)

	projectile
		icon='icons/projectiles.dmi'
		itype="projectile2"

		Use(mob/u)
			usr=u
			var/equ=src.equipped
			usr.removeswords()
			usr.weapon_ref=null

			for(var/obj/items/O in usr.contents)
				if(O.weapon)
					O.overlays=0
					O.equipped=0
					O.overlays+=O.macover
			if(equ)
				src.equipped=0
				src.overlays=0
			else
				src.equipped=1
				src.overlays+='icons/Equipped.dmi'
				usr.weapon_ref=src

		Kunai_p
			icon_state="kunai"
			astate="kunai-m"
			accuracymod=50
			supplycost=1
			code=116
			woundmod=300
			nottossable=1

		Shuriken_p
			icon_state="shuriken"
			burst=3
			astate="shuriken-m"
			supplycost=1
			accuracymod=60
			code=146
			woundmod=100
			nottossable=1

		Needles_p
			icon_state="needles"
			astate="needle-m"
			code=117
			accuracymod=65
			burst=5
			woundmod=50
			supplycost=1
			nottossable=1

	melee
		get_stamina_damage(mob/user)
			if(!user)
				return
			. = round((stamina_damage_static + (user.rfx + user.rfxbuff - user.rfxneg)*rfx_stamina_damage_mod)*pick(0.6,0.7,0.8,0.9,1))
			if(user.skillspassive[WEAPON_MASTERY])
				. *= 1 + 0.06 * user.skillspassive[WEAPON_MASTERY]
		knife
			itype="melee2"
			aspecial="knife"

			Kunai_Melee
				name = "Kunai"
				icon='icons/kunai_melee.dmi'
				icon_state="gui"
				code=215
				accuracymod=100
				stamina_damage_static = 200
				rfx_stamina_damage_mod=1
				str_stamina_damage_mod=0
				woundmod=1
				cool=1
				Use(var/mob/u)
					var/equ=src.equipped
					usr=u
					usr.removeswords()
					usr.weapon_ref=null
					for(var/obj/items/O in usr.contents)
						if(O.weapon)
							O.overlays=0
							O.equipped=0
							O.overlays+=O.macover
					if(!equ)
						src.equipped=1
						src.overlays+='icons/Equipped.dmi'
						usr.weapon=new/list

						usr.weapon+=/obj/kunai_melee
						usr.weapon_ref=src

						usr.specialover="sword"
						usr.Load_Overlays()

		sword
			itype="melee"
			aspecial="sword"

			var/weapon_disp_types

			Use(var/mob/u)
				var/equ=src.equipped
				usr=u
				usr.removeswords()
				usr.weapon_ref=null
				for(var/obj/items/O in usr.contents)
					if(O.weapon)
						O.overlays=0
						O.equipped=0
						O.overlays+=O.macover
				if(!equ)
					src.equipped=1
					src.overlays+='icons/Equipped.dmi'
					usr.weapon=weapon_disp_types
					usr.weapon_ref=src

					usr.specialover="sword"
					usr.Load_Overlays()

			Bone_Sword
				name = "Bone Sword"
				icon='icons/gui.dmi'
				icon_state="bone_sword_item"
				accuracymod=40
				woundmod=5
				stamina_damage_static = 400
				rfx_stamina_damage_mod=1.4
				str_stamina_damage_mod=0
				cool=1
				code=251
				weapon_disp_types = list(/obj/sword/b1, /obj/sword/b2, /obj/sword/b3, /obj/sword/b4)

			Sword
				name = "ANBU Sword"
				icon='icons/projectiles.dmi'
				icon_state="sword"
				accuracymod=60
				woundmod=10
				stamina_damage_static = 450
				rfx_stamina_damage_mod=2
				str_stamina_damage_mod=0
				cool=2
				code=216
				weapon_disp_types = list('sword1/swordover.dmi',/obj/sword/s1,/obj/sword/s2,/obj/sword/s3,/obj/sword/s4)

			ZSword
				name = "ZSword"
				icon='icons/projectiles.dmi'
				icon_state="zsword"
				accuracymod=55
				woundmod=25
				stamina_damage_static = 600
				rfx_stamina_damage_mod=2.5
				str_stamina_damage_mod=0
				weapon=1
				code=217
				weight=50
				cool=4
				weapon_disp_types = list(/obj/sword/z1,/obj/sword/z2,/obj/sword/z3,/obj/sword/z4)

var
	sword1=list('sword1/swordover.dmi',/obj/sword/s1,/obj/sword/s2,/obj/sword/s3,/obj/sword/s4)

obj/items/var/equipped=0
obj/items/weapons
	var
		itype="projectile"
		astate=""
		woundmod=100
		stamina_damage_static=-1
		rfx_stamina_damage=-1
		str_stamina_damage=-1
		rfx_stamina_damage_mod=-1
		str_stamina_damage_mod=-1
		accuracymod=100
		supplycost=0
		cool=1
		aspecial=""
mob
	proc
		ShadowShuriken(dx,dy,dz)
			usr=src
			var/mob/dork=new/mob(locate(dx,dy,dz))
			dork.density=0
			dork.icon=null
			dork.overlays=null
			spawn(30)
				if(dork)
					del(dork)
			var/pass=1
			if(pass)
				var/ewoundmod=200
				var/eicon='icons/projectiles.dmi'
				var/estate="shuriken-m"

				flick("Throw2",usr)

				var/mob/human/etarget = usr.MainTarget()

				var/angle
				var/speed = 32
				var/spread = 3
				if(etarget)
					angle = get_real_angle(src, etarget)
				else
					angle = dir2angle(dir)

				var/r=round((ewoundmod-100)/75)

				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle-spread*4, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle-spread*3, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle-spread*2, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle-spread, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle+spread, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle+spread*2, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle+spread*3, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)
				spawn() advancedprojectile_angle(eicon, estate, dork, speed, angle+spread*4, distance=10, damage=ewoundmod, wounds=rand(0,1)+r)

		Deque2(pass)
			src.overlays-=image('icons/sandshuriken.dmi',icon_state="sand")
			src.qued2=0
			if(pass)
				var/ewoundmod=400
				var/eicon='icons/sandshuriken.dmi'
				var/estate="shuriken"

				flick("Throw2",src)

				var/mob/human/etarget = MainTarget()

				var/angle
				var/speed = 32
				var/spread = 6
				if(etarget)
					angle = get_real_angle(src, etarget)
				else
					angle = dir2angle(dir)

				var/r=round((ewoundmod-100)/100)

				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread*2, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread*2, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))

		Deque(pass)
			src.overlays-=image('icons/advancing.dmi',icon_state="over")
			src.underlays-=image('icons/advancing.dmi',icon_state="under")
			src.qued=0
			if(pass)
				var/ewoundmod=200
				var/eicon='icons/projectiles.dmi'
				var/estate="kunai-m"

				flick("Throw2",usr)

				var/mob/human/etarget = usr.MainTarget()

				var/angle
				var/speed = 32
				var/spread = 6
				if(etarget)
					angle = get_real_angle(src, etarget)
				else
					angle = dir2angle(dir)

				var/r=round((ewoundmod-100)/100)

				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread*4, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread*3, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread*2, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle-spread, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread*2, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread*3, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))
				spawn() advancedprojectile_angle(eicon, estate, src, speed, angle+spread*4, distance=10, damage=ewoundmod, wounds=prob(50)?(r):(0))

mob/verb
	usev()
		set name= "Use"
		set hidden=1
		if(usr.camo)
			usr.Affirm_Icon()
			usr.Load_Overlays()
			usr.camo=0
		if(usr.Size||usr.Tank)
			return
		if(usr.stunned||usr.handseal_stun||usr.kstun)
			return
		if(puppetsout)
			if(!Primary)
				if(puppetsout == 1) //usev for Puppet1
					if(Puppet1 in oview(5))
						var/mob/human/ptarget = usr.MainTarget()
						if(ptarget && !ptarget.ko) Puppet1.pwalk_towards(Puppet1,ptarget,2,20)
						Puppet1.Melee(usr)
						return
					else if(Puppet2 in oview(5))
						var/mob/human/ptarget = usr.MainTarget()
						if(ptarget && !ptarget.ko) Puppet2.pwalk_towards(Puppet2,ptarget,2,20)
						Puppet2.Melee(usr)
						return
				else if(puppetsout == 2)
					if(Puppet1 in oview(5))
						var/mob/human/ptarget = usr.MainTarget()
						if(ptarget && !ptarget.ko) Puppet1.pwalk_towards(Puppet1,ptarget,2,20)
						Puppet1.Melee(usr)
						return
			else
				if(Primary) //usev for opposite puppet from Primary, if exists
					if(Primary == Puppet1 && Puppet2)
						if(Puppet2 in oview(5))
							var/mob/human/ptarget = usr.MainTarget()
							if(ptarget && !ptarget.ko) Puppet2.pwalk_towards(Puppet2,ptarget,2,20)
							Puppet2.Melee(usr)
							return
					if(Primary == Puppet2 && Puppet1)
						if(Puppet1 in oview(5))
							var/mob/human/ptarget = usr.MainTarget()
							if(ptarget && !ptarget.ko) Puppet1.pwalk_towards(Puppet1,ptarget,2,20)
							Puppet1.Melee(usr)
							return
		if(usr.qued)
			usr.Deque(1)
			return
		if(usr.qued2)
			usr.Deque2(1)
			return
		if(usr.zetsu)
			usr.invisibility=0
			usr.density=1
			usr.targetable=1
			usr.protected=0
			usr.zetsu=0
		if(usr.incombo)
			return
		if(usr.usedelay>0||usr.stunned||usr.handseal_stun||usr.paralysed)
			return
		if(usr.move_stun)
			++usr.usedelay
		++usr.usedelay
		if(usr.larch)
			return
		if(usr.frozen)
			return
		//world<<"usr=[usr],[usr.pet],[usr.mane],[usr.canattack],[usr.pk],[usr.usedelay],[usr.stunned],[usr.paralysed]"
		if(usr.sleeping)
			return
		if(!usr.canattack)
			return
		if(usr.isguard)
			usr.icon_state=""
			usr.isguard=0
		if(usr.MainTarget()) usr.FaceTowards(usr.MainTarget())

		if(usr.pet)
			var/mob/human/etarget=usr.MainTarget()
			var/mob/human/pp=usr.Get_Sand_Pet()
			if(!pp)
				var/dunsomething=0
				if(etarget)
					for(var/mob/human/player/npc/kage_bunshin/X in orange(10,usr))
						if(X.owner==usr)
							if(etarget)
								if(!X.attack_cd)
									dunsomething=1
									X.attack_cd = 1
									spawn(50) X.attack_cd = 0
									spawn(rand(1,15))
										X.AI_Target(etarget)
										if(prob(50) && !(X.skillusecool || X.rasengan || X.sakpunch2))
											if(!(X.AppearBehind(etarget)))
												X.AI_Attack(etarget)
										else
											X.AI_Attack(etarget)
										/*if(!X.skillusecool)
											if(X.rasengan || X.sakpunch2)
												X.Approach2(etarget)
											else
												pick(X.AppearBehind(etarget),X.Approach2(etarget))*/

				if(!dunsomething)
					goto cont
				else
					usr.combat("[usr]: Attack!!")
					return
			if(pp)
				if(etarget)
					pp:P_Attack(etarget,usr)
				else
					for(var/mob/human/q in get_step(pp,pp.dir))
						pp:P_Attack(q,usr)
				return
		cont
		if(usr.mane ||usr.canattack==0)
			return
		if(usr.pk==0)
			usr<<"this is a no pk zone!"
			return


		var/eicon
		var/estate
		var/etype
		var/ewoundmod
		var/eaccuracymod
		var/mob/etarget
		var/eburst
		var/esupplycost
		var/etypea
		var/estam_static
		var/erfxstam_mod
		var/estrstam_mod
		for(var/obj/items/weapons/O in usr.contents)
			if(O.equipped==1&&O.weapon==1)
				eicon = O.icon
				estate = O.astate
				etype = O.itype
				ewoundmod = O.woundmod
				eaccuracymod = O.accuracymod
				esupplycost = O.supplycost
				usedelay = O.cool
				eburst = O.burst
				etypea = O.type
				estam_static = O.stamina_damage_static
				erfxstam_mod = O.rfx_stamina_damage_mod
				estrstam_mod = O.str_stamina_damage_mod

		if(esupplycost>usr.supplies)
			return
		else
			usr.supplies-=esupplycost
			if(usr.supplies<=0)
				usr.supplies=0

		if(etype=="projectile2")
			flick("Throw1",usr)
			etarget = usr.MainTarget()
			if(!(etarget in oview(10)))
				etarget = null

			var/angle
			var/speed = 48
			var/spread = 9
			if(etarget) angle = get_real_angle(usr, etarget)
			else angle = dir2angle(usr.dir)

			spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle, distance=10, damage=ewoundmod, wounds="passive")
			if(eburst>=3)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread*2, distance=10, damage=ewoundmod, wounds="passive")
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread*2, distance=10, damage=ewoundmod, wounds="passive")
			if(eburst>=5)
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle+spread, distance=10, damage=ewoundmod, wounds="passive")
				spawn() advancedprojectile_angle(eicon, estate, usr, speed, angle-spread, distance=10, damage=ewoundmod, wounds="passive")

			return

		if(etype=="projectile")
			flick("Throw1",usr)
			etarget = usr.MainTarget()
			if(!(etarget in oview(10)))
				etarget = null
			if(etarget)

				var/r=rand(50,200)
				var/result=Roll_Against(usr.rfx+usr.rfxbuff-usr.rfxneg,etarget.rfx+etarget.rfxbuff-etarget.rfxneg,(eaccuracymod*r)/100)
				if(result>=3)
					projectile_to(eicon,estate,usr,etarget)
				else
					projectile_to(eicon,estate,usr,locate(etarget.x,etarget.y,etarget.z))
				if(result==6)

					view(6)<<"[usr] Nailed [etarget] with a projectile"

					etarget.Wound(rand(3,10),0,usr)
					Blood2(etarget)
				if(result==5)
					view(6)<<"[usr] accurately hit [etarget] with a projectile"

					etarget.Wound(rand(1,5),0,usr)
					Blood2(etarget)
				if(result==4)
					view(6)<<"[usr] hit [etarget] dead on with a projectile"
					etarget.Wound(rand(0,1),0,usr)
				if(result==3)
					view(6)<<"[usr] partially hit [etarget] with a projectile"
				if(result>=3)

					etarget.Dec_Stam(ewoundmod/2,0,usr)
					etarget.Hostile(usr)
			else
				spawn()straight_proj(eicon,estate,usr,7,1,65,"a projectile",10,0)
				return
		if(etype=="melee2")//knife

			flick("w-attack",usr)
			var/mob/human/T = usr.NearestTarget()
			if(T)usr.FaceTowards(T)
			if(!(T in oview(1)))
				T = null
			if(!T)
				T=locate() in get_step(usr,usr.dir)
			if(T&&T.ko==0&&T.paralysed==0)
				flick("w-attack",usr)
				if(T.blocked==0)
					var/X = rand(1,(usr.rfx+usr.rfxbuff-usr.rfxneg))*100//attackroll
					var/x=rand(1,(T.rfx+T.rfxbuff-T.rfxneg))*100 //evaderoll


					var/damz=0
					var/woundz=0
					if(!T.icon_state)
						flick("hurt",T)
					damz=round((estam_static + (usr.rfx + usr.rfxbuff - usr.rfxneg)*erfxstam_mod)*pick(0.7,0.8,0.9,1))
					if(usr.skillspassive[WEAPON_MASTERY])
						damz *= 1 + 0.06 * usr.skillspassive[WEAPON_MASTERY]
					T.Dec_Stam(damz,0,usr)
					var/wound2=0
					if(prob(3*skillspassive[OPEN_WOUNDS]))
						wound2=pick(1,2,3,4)
						var/bleed=pick(2,4,6)
						T.bleed(bleed, usr)
						/*spawn(10)
							while(bleed>0)
								bleed--
								sleep(15)
								if(T)
									T.Dec_Stam(100,0,usr)
									Blood2(T,usr)*/

					if(X>x)
						woundz=round(rand(ewoundmod/3,round(ewoundmod/1.5)))

						Blood2(T,usr)
					woundz+=wound2
					if(woundz)T.Wound(woundz,0,usr)

					usr.combat("[usr] hit [T] with a weapon for [damz] stamina damage and inflicting [woundz] wounds!")

					spawn() if(T) T.Hostile(usr)
				else
					var/outcome3=Roll_Against(T.rfx+T.rfxbuff-T.rfxneg,usr.rfx+usr.rfxbuff-usr.rfxneg,100)
					if(outcome3>3)
						//usr.stunned=2
						usr.Timed_Stun(20)
						if(!T.icon_state)
							flick("hurt",usr)
				return
		if(etype=="melee")
			var/stuncut=1
			if(etypea==/obj/items/weapons/melee/sword/Bone_Sword)
				usr.boneuses--
				stuncut=2
			//usr.stunned+=0.5/stuncut
			usr.Timed_Stun(0.5 / stuncut * 10)

			flick("w-attack",usr)
			var/mob/human/T = usr.NearestTarget()
			if(T)usr.FaceTowards(T)
			if(!(T in oview(1)))
				T = null
			if(!T)
				T=locate() in get_step(usr,usr.dir)
			if(T&&T.ko==0&&T.paralysed==0)
				flick("w-attack",usr)
				if(T.blocked==0)
					var/X = rand(1,(usr.rfx+usr.rfxbuff-usr.rfxneg))*eaccuracymod//attackroll
					var/x=rand(1,(T.rfx+T.rfxbuff-T.rfxneg))*100 //evaderoll


					var/damz=0
					var/woundz=0
					if(!T.icon_state)
						flick("hurt",T)

					if(erfxstam_mod)
						damz+=estam_static + (usr.rfx + usr.rfxbuff - usr.rfxneg)*erfxstam_mod
					else if(estrstam_mod)
						damz+=estam_static + (usr.str + usr.strbuff - usr.strneg)*estrstam_mod
					damz = round(damz * pick(0.6,0.7,0.8,0.9,1))
					if(usr.skillspassive[WEAPON_MASTERY])
						damz*=1 + 0.06*usr.skillspassive[WEAPON_MASTERY]
					T.Dec_Stam(damz,0,usr)
					var/wound2=0
					if(prob(3*skillspassive[OPEN_WOUNDS]))
						wound2=pick(1,2,3,4)
						var/bleed=pick(2,4,6)
						T.bleed(bleed, usr)
						/*spawn(10)
							while(bleed>0)
								bleed--
								sleep(15)
								if(T)
									T.Dec_Stam(100,0,usr)
									Blood2(T,usr)*/
					if(X>x)//hit
						woundz=round(0.5*(rand(ewoundmod/3,round(ewoundmod/1.5))))

						Blood2(T,usr)
					woundz+=wound2
					if(woundz)T.Wound(woundz,0,usr)
					usr.combat("[usr] hit [T] with a weapon for [damz] stamina damage and inflicting [woundz] wounds!")

					spawn() if(T && usr) T.Hostile(usr)
				else
					var/outcome3=Roll_Against(T.rfx+T.rfxbuff-T.rfxneg,usr.rfx+usr.rfxbuff-usr.rfxneg,100)
					if(outcome3>3)
						//usr.stunned=2
						usr.Timed_Stun(20)
						if(!T.icon_state)
							flick("hurt",usr)
				return

mob
	var/tmp/bleeding = 0

	proc/bleed(time, mob/causer)
		set waitfor = 0
		if(!time || !causer)
			return
		sleep(10)
		bleeding++
		while(time > 0)
			Blood2(src, causer)
			Dec_Stam(100, 0, causer)
			time--
			sleep(15)
		bleeding--

obj/projc
	density=0
	layer=MOB_LAYER+1
	New()
		spawn(100)
			del(src)
obj/needle
	icon='icons/projectiles.dmi'
	icon_state="needle-m"
	density=0
	layer=MOB_LAYER+1
	New()
		spawn(100)
			del(src)
obj/fireball
	icon='icons/fireball.dmi'
	density=0
	layer=MOB_LAYER+1
	New()
		spawn(100)
			del(src)
obj
	var
		xvel=0
		yvel=0
		beenclashed=0
		mot=0
		projdisturber=0
obj/projectile
	landed(atom/movable/O,pow,wnd,daze)
		..()

		if(src.landed)
			return
		src.landed=1
		if(!O)
			if(src.icon=='icons/projectiles.dmi')
				if(src.icon_state=="shuriken-m")src.icon_state=pick("shuriken-m-clashed1","shuriken-m-clashed2","shuriken-m-clashed3") //sets the projectile to its landed in a turf icon state
				if(src.icon_state=="needle-m")src.icon_state=pick("needle-m-clashed1","needle-m-clashed2","needle-m-clashed3")
				if(src.icon_state=="kunai-m")src.icon_state=pick("kunai-m-clashed1","kunai-m-clashed2","kunai-m-clashed3")
				if(src.icon_state=="knife-m")src.icon_state="knife-m-clashed1"
				if(src.icon_state=="windmill-m")src.icon_state="windmill-m-clashed1"
			else
				src.icon=null
				src.overlays=null

			src.landed=2

			sleep(50)
			src.loc=null  //go away invisible
			owner = null
			powner = null
			return
		if(istype(O,/mob/human))
			var/mob/human/Oc = O

			if(Oc.skillspassive[WEAPON_MASTERY] && Oc.isguard && Oc.weapon_ref && istype(Oc.weapon_ref, /obj/items/weapons/melee))
				var/obj/items/weapons/melee/weapon = Oc.weapon_ref
				var/deflection_chance = 0
				switch(weapon.name)
					if("Kunai")
						deflection_chance = 2 * Oc.skillspassive[WEAPON_MASTERY]
					if("Bone Sword", "ANBU Sword")
						deflection_chance = 5 * Oc.skillspassive[WEAPON_MASTERY]
					if("ZSword")
						deflection_chance = 10 * Oc.skillspassive[WEAPON_MASTERY]
				if(prob(deflection_chance))
					flick("w-attack", Oc)
					Oc.Timed_Stun(5)
					Oc.dir = get_dir(Oc, src)
					Oc.combat("You deflected the projectile with your [weapon.name]!")
					src.loc=null  //go away invisible
					owner = null
					powner = null
					return

			if(daze&& prob(daze))
				Oc.icon_state="hurt"
				var/dazed=3
				//Oc.stunned=round(dazed,0.1)
				Oc.Timed_Stun(dazed * 10)

				spawn() Oc.Graphiked('icons/dazed.dmi')

			Oc.Dec_Stam(pow,0,src.powner)  //hurt the player it hits = the power variable
			if(wnd)
				Blood(O.x,O.y,O.z)  //ew blood
				Oc.Wound(wnd,0,src.powner)


			Oc.Hostile(src.powner)
			src.loc=null  //go away invisible
			owner = null
			powner = null
		if(istype(O,/obj/projectile))
			var/obj/projectile/Oc=O
			if(Oc.landed!=2)  //dont clash with projectiles that are sticking in turfs!
				Clash(O,src) //clash O and src together
proc
	advancedprojectile_angle(icon, icon_state, mob/user, speed, angle, distance, damage, wounds=0, daze=0, radius=8, atom/from=user, ignore_list[])
		if(!from || !speed)
			return

		if(wounds=="passive")
			if(user && user.skillspassive[BOMBARDMENT] && prob(3*user.skillspassive[BOMBARDMENT]))
				wounds=pick(1,2,3,4)
			else
				wounds=0

		if(!isnum(wounds))
			wounds = 0

		var/obj/projectile/p = new /obj/projectile(from.loc)
		p.icon = icon
		p.icon_state = icon_state

		p.owner = user
		p.radius = radius

		var/extra_list = list()
		if(wounds)
			extra_list["Wound"] = wounds
		if(daze)
			extra_list["Daze"] = daze
		if(ignore_list)
			extra_list["ignore"] = ignore_list

		M_Projectile_Degree(p, user, damage, (distance*32)/speed, speed, angle, extra_list)

	advancedprojectilen(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,mob/trueowner,radius)
		if(wnd=="passive")
			if(trueowner&& trueowner.skillspassive[BOMBARDMENT]&& prob(4*trueowner.skillspassive[BOMBARDMENT]))
				wnd=pick(1,2,3,4)
			else
				wnd=0
		if(!isnum(wnd))wnd=0
		if(!efrom)
			return
		var/obj/projectile/p = new/obj/projectile(locate(efrom.x,efrom.y,efrom.z))

		p.icon=i
		p.icon_state=estate
		if(radius)p.radius=radius
		else p.radius=8
		if(trueowner)efrom=trueowner
		p.powner=efrom
		var/speed = sqrt(xvel*xvel+yvel*yvel)
		if((!xvel && !yvel )|| speed ==0)
			del(p)
			return
		M_Projectile(p,efrom,damage,xvel,yvel,(distance*32) / speed,list("Wound"=wnd))
		return

	advancedprojectile(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,mob/trueowner,radius)
		var/obj/projectile/p = new/obj/projectile(locate(efrom.x,efrom.y,efrom.z))
		p.icon=i
		p.powner=efrom
		p.icon_state=estate
		if(radius)p.radius=radius
		else p.radius=8
		M_Projectile(p,efrom,damage,xvel,yvel,(distance * 32)/sqrt(xvel*xvel+yvel*yvel),list("Wound"=wnd))
		return

proc
	advancedprojectile_ramped(i,estate,mob/efrom,xvel,yvel,distance,damage,wnd,vel,pwn,daze,radius)//daze as percent/100
		var/obj/projectile/p = new/obj/projectile(locate(efrom.x,efrom.y,efrom.z))
		p.icon=i
		p.powner=efrom
		p.icon_state=estate
		if(radius)p.radius=radius
		else if(pwn) p.radius=16
		else p.radius=8

		M_Projectile(p,efrom,damage,xvel,yvel,(distance * 32)/sqrt(xvel*xvel+yvel*yvel),list("Wound"=wnd,"Daze"=daze))

	advancedprojectile_returnloc(xtype,mob/efrom,xvel,yvel,distance,vel,dx,dy,dz)
		var/obj/p = new xtype(locate(dx,dy,dz))
		var/horiz=0
		var/vertic=0
		if(abs(xvel)>abs(2*yvel))
			horiz=1
		else if(abs(yvel)>abs(2*xvel))
			vertic=1
		if(!horiz&&!vertic)
			if(xvel>0 && yvel>0)
				p.dir=NORTHEAST
			if(xvel<0 && yvel>0)
				p.dir=NORTHWEST
			if(xvel>0 && yvel<0)
				p.dir=SOUTHEAST
			if(xvel<0 && yvel<0)
				p.dir=SOUTHWEST
		if(horiz)
			if(xvel>0)
				p.dir=EAST
			else
				p.dir=WEST
		if(vertic)
			if(yvel>0)
				p.dir=NORTH
			else
				p.dir=SOUTH
		p.owner=efrom
		p.xvel=xvel*vel/100
		p.yvel=yvel*vel/100
		p.beenclashed=0

		p.mot=distance
		sleep(3)
	//	walk_to(p,eto,0,1)
		while(p.mot>0&&p)
			if(p.mot<=1)
				p.icon=0
				var/xmod=0
				while(p.pixel_x>32)
					p.pixel_x-=32
					xmod++
				while(p.pixel_x<-32)
					p.pixel_x+=32
					xmod--
				var/ymod=0
				while(p.pixel_y>32)
					p.pixel_y-=32
					ymod++
				while(p.pixel_y<-32)
					p.pixel_y+=32
					ymod--
				var/ploc=locate(p.x+xmod,p.y+ymod,p.z)
				del(p)
				return ploc

			if(!p.beenclashed)
				p.pixel_x+=xvel/2
				p.pixel_y+=yvel/2

			if(p.pixel_x>=32)

				var/pass=1
				var/turf/x=locate(p.x+1,p.y,p.z)
				if(!x||x.density==1)
					pass=0
				if(pass)
					p.loc=locate(p.x+1,p.y,p.z)
				//	spawn()if(p)p.pixel_x-=32
				else
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc

			if(p.pixel_x<=-32)

				var/pass=1
				var/turf/x =locate(p.x-1,p.y,p.z)
				if(!x||x.density==1)
					pass=0
				if(pass)
					p.loc=locate(p.x-1,p.y,p.z)
				//	spawn()if(p)p.pixel_x+=32
				else
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc
			if(p.pixel_y>=32)

				var/pass=1
				var/turf/x=locate(p.x,p.y+1,p.z)
				if(!x||x.density==1)
					pass=0
				if(pass)
					p.loc=locate(p.x,p.y+1,p.z)
				//	spawn()if(p)p.pixel_y-=32
				else
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc
			if(p.pixel_y<=-32)
				var/pass=1
				var/turf/x= locate(p.x,p.y-1,p.z)
				if(!x||x.density==1)
					pass=0
				if(pass)
					p.loc=locate(p.x,p.y-1,p.z)
				//	spawn()if(p)p.pixel_y+=32
				else
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc
			for(var/mob/human/m in oview(1,p))
				if(m!=efrom)
					p.icon=0
					if(!m.icon_state)
						flick("hurt",m)
					p.mot=0
					var/ploc=m.loc
					del(p)
					return ploc
			for(var/obj/projc/m in oview(0,p))
				if(m.owner!=p.owner&&m.beenclashed==0&&p.beenclashed==0)

					m.xvel=p.xvel*rand(60,140)/100
					m.yvel=p.xvel*rand(60,140)/100
					m.mot=m.mot/3
					m.beenclashed=1

					var/er=rand(1,3)

					m.icon_state="[m.icon_state]-clashed[er]"
					p.mot=0
					var/ploc=p.loc
					del(p)
					return ploc
					//clang
			sleep(1)
			if(p)
				p.mot--

		sleep(5)
		if(p)
			p.mot=0

proc
	projectile_to(i,estate,mob/efrom,atom/eto)
		if(!(efrom&&eto))return
		var/obj/p
		if(efrom)p = new/obj/proj(locate(efrom.x,efrom.y,efrom.z))
		if(p)
			p.icon=i
			p.icon_state=estate
			sleep(1)
			if(p && eto)walk_to(p,eto,0,1)
			while(p&&eto&&(p.x!=eto.x ||p.y!=eto.y))
				sleep(1)
			if(eto&&istype(eto,/mob/human))
				if(!eto.icon_state)
					flick("hurt",eto)
			sleep(5)
			del(p)
proc
	projectile_to2(type,mob/efrom,atom/eto)
		var/obj/p = new type(locate(efrom.x,efrom.y,efrom.z))

		sleep(1)
		walk_to(p,eto,0,1)
		while(p.x!=eto.x ||p.y!=eto.y)
			sleep(1)
		if(istype(eto,/mob/human))
			if(!eto.icon_state)
				flick("hurt",eto)
		sleep(5)
		del(p)

obj/proj
	density=0
	layer=MOB_LAYER+1
	New()
		spawn(100)
			del(src)


proc
	straight_proj4(eicon,estate,dist,mob/human/u,dx,dy,dz)
		var/obj/proj/M = new/obj/proj(locate(dx,dy,dz))
		M.icon=eicon
		M.icon_state=estate
		sleep(1)
		if(u.dir==NORTH||u.dir==SOUTH||u.dir==EAST||u.dir==WEST)
			M.dir=u.dir
		if(u.dir==NORTHEAST||u.dir==NORTHWEST)
			M.dir=NORTH
		else if(u.dir==SOUTHEAST|u.dir==SOUTHWEST)
			M.dir=SOUTH
		var/stepsleft=dist
		while(stepsleft>0 && M )
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M,M.dir))
					if(istype(O,/mob/human))
						if(O!=u)
							hit=O
				walk(M,M.dir)
				sleep(1)
				walk(M,0)
				stepsleft--
				if(hit)
					sleep(1)
					del(M)
					return hit
			else if(!u)
				del(M)
				return


		sleep(2)
		del(M)
	straight_proj3(type,dist,mob/human/u)

		var/obj/M = new type(locate(u.x,u.y,u.z))
		spawn(20)
			if(M)
				del(M)
		sleep(1)
		if(u.dir==NORTH||u.dir==SOUTH||u.dir==EAST||u.dir==WEST)
			M.dir=u.dir
		if(u.dir==NORTHEAST||u.dir==NORTHWEST)
			M.dir=NORTH
		else if(u.dir==SOUTHEAST|u.dir==SOUTHWEST)
			M.dir=SOUTH
		var/stepsleft=dist
		while(stepsleft>0 && M )
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M,M.dir))
					if(istype(O,/mob/human))
						if(O!=u)
							hit=O
				walk(M,M.dir)
				sleep(1)
				walk(M,0)
				stepsleft--
				if(hit)
					sleep(1)
					del(M)
					return hit
			else if(!u)
				del(M)
				return


		sleep(2)
	straight_proj2(eicon,estate,dist,mob/human/u)
		var/obj/proj/M = new/obj/proj(locate(u.x,u.y,u.z))
		M.icon=eicon
		M.icon_state=estate
		sleep(1)
		if(u.dir==NORTH||u.dir==SOUTH||u.dir==EAST||u.dir==WEST)
			M.dir=u.dir
		if(u.dir==NORTHEAST||u.dir==NORTHWEST)
			M.dir=NORTH
		else if(u.dir==SOUTHEAST|u.dir==SOUTHWEST)
			M.dir=SOUTH
		var/stepsleft=dist
		while(stepsleft>0 && M )
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M,M.dir))
					if(istype(O,/mob/human))
						if(O!=u)
							hit=O
				walk(M,M.dir)
				sleep(1)
				walk(M,0)
				stepsleft--
				if(hit)
					sleep(1)
					del(M)
					return hit
			else if(!u)
				del(M)
				return


		sleep(2)
		del(M)
	straight_proj(eicon,estate,mob/human/u,dist,espeed,epower,ename,maxwound,minwound)
		var/obj/proj/M = new/obj/proj(locate(u.x,u.y,u.z))
		M.icon=eicon
		M.icon_state=estate
		sleep(1)
		if(u.dir==NORTH||u.dir==SOUTH||u.dir==EAST||u.dir==WEST)
			M.dir=u.dir
		if(u.dir==NORTHEAST||u.dir==NORTHWEST)
			M.dir=NORTH
		else if(u.dir==SOUTHEAST|u.dir==SOUTHWEST)
			M.dir=SOUTH
		var/stepsleft=dist
		while(stepsleft>0 && M )
			if(M && u)
				var/mob/hit
				for(var/mob/O in get_step(M,M.dir))
					if(istype(O,/mob/human))
						if(O!=u)
							hit=O
				walk(M,M.dir)
				sleep(1)
				walk(M,0)
				stepsleft--
				if(hit)
					var/r=rand(100,200)
					var/result=Roll_Against(usr.rfx+usr.rfxbuff-usr.rfxneg,hit.rfx+hit.rfxbuff-hit.rfxneg,r)
					if(result==6)

						view(6)<<"[usr] Nailed [hit] with [ename]"

						hit.Wound(rand(minwound+3,maxwound),0,u)
						Blood2(hit)
					if(result==5)
						view(6)<<"[usr] accurately hit [hit] with [ename]"

						hit.Wound(rand(minwound+1,maxwound/2),0,u)
						Blood2(hit)
					if(result==4)
						view(6)<<"[usr] hit [hit] dead on with [ename]"

						hit.Wound(rand(minwound,minwound+1),0,u)

					if(result==3)
						view(6)<<"[usr] partially hit [hit] with [ename]"
					if(result>=3)
						hit.Dec_Stam(epower,0,u)
						if(u)
							spawn()hit.Hostile(u)
					sleep(1)
					del(M)
			else if(!u)
				del(M)
				return
		sleep(2)
		del(M)

proc/Gethairicon(i)
	var/h1i
	switch(i)
		if(1)
			h1i='icons/hair1.dmi'

		if(2)
			h1i='icons/hair2.dmi'

		if(3)
			h1i='icons/hair3.dmi'
		if(4)
			h1i='icons/hair4.dmi'
		if(5)
			h1i='icons/hair5.dmi'
		if(6)
			h1i='icons/hair6.dmi'
		if(7)
			h1i='icons/hair7.dmi'
		if(8)
			h1i='icons/hair8.dmi'
		if(9)
			h1i='icons/hair9.dmi'
		if(10)
			h1i='icons/hair10.dmi'
		if(11)
			h1i='icons/hair11.dmi'
		if(12)
			h1i='icons/hair12.dmi'
		if(13)
			h1i='icons/hair13.dmi'
	return h1i
//overlay handling

mob/proc

	Load_Overlays()
		set background = 1
		if(src.Size||src.Tank)
			return
		sleep(-1)
		if(!EN[15])
			return
		src.underlays=0
		var/L[0]
		var/icon/h1i


		switch(src.hair_type)
			if(1)
				h1i=new('icons/hair1.dmi')
			if(2)
				h1i=new('icons/hair2.dmi')
			if(3)
				h1i=new('icons/hair3.dmi')
			if(4)
				h1i=new('icons/hair4.dmi')
			if(5)
				h1i=new('icons/hair5.dmi')
			if(6)
				h1i=new('icons/hair6.dmi')
			if(7)
				h1i=new('icons/hair7.dmi')
			if(8)
				h1i=new('icons/hair8.dmi')
			if(9)
				h1i=new('icons/hair9.dmi')
			if(10)
				h1i=new('icons/hair10.dmi')
			if(11)
				h1i=new('icons/hair11.dmi')
			if(12)
				h1i=new('icons/hair12.dmi')
			if(13)
				h1i=new('icons/hair13.dmi')


		if(h1i)

			if(EN[1])h1i.Blend(src.hair_color)
			var/icon/h2i
			if(src.hair_type==11)
				h2i=new('icons/hair11o.dmi')
				if(EN[1])h2i.Blend(src.hair_color)

			var/image/h1
			var/pixy=0
			if(src.hair_type==11)
				pixy=2
			var/h2
			if(overband)
				h1=image(h1i,layer=FLOAT_LAYER-1,pixel_y=pixy)
				if(h2i)
					h2=image(h2i,layer=FLOAT_LAYER-1)

			else
				h1=image(h1i,layer=FLOAT_LAYER-2,pixel_y=pixy)
				if(h2i)
					h2=image(h2i,layer=FLOAT_LAYER-2)
			L+= h1
			if(h2)
				L+=h2
		if(special)L+=special
		if(undershirt) L+=undershirt
		if(pants) L+=pants
		if(overshirt) L+=overshirt
		if(shoes)L+=shoes
		if(legarmor) L+=legarmor
		if(armor)L+=armor
		if(armarmor)L+=armarmor
		if(armarmor2)L+=armarmor2
		if(glasses)L+=glasses
		if(facearmor)L+=facearmor
		if(cloak)L+=cloak
		if(sholder)L+=sholder
		if(back)L+=back
		if(weapon)L+=weapon
		if(src.gate>=1)
			L+=image('icons/gatepower.dmi',layer=FLOAT_LAYER)
		if(src.pill>=2)
			L+=image('icons/Chakra_Shroud.dmi',layer=FLOAT_LAYER)
		src.hassword=0
		for(var/obj/items/weapons/O in src.contents)
			if(O.equipped==1&&O.weapon==1 && O.itype=="melee")
				src.hassword=1
		src.overlays=L



	completeLoad_Overlays(alph,scale)
		set background = 1
		sleep(-1)
		if(!EN[15])
			return
		usr.underlays=0
		var/L[0]
		var/icon/h1i


		switch(src.hair_type)
			if(1)
				h1i=new('icons/hair1.dmi')
			if(2)
				h1i=new('icons/hair2.dmi')
			if(3)
				h1i=new('icons/hair3.dmi')
			if(4)
				h1i=new('icons/hair4.dmi')
			if(5)
				h1i=new('icons/hair5.dmi')
			if(6)
				h1i=new('icons/hair6.dmi')
			if(7)
				h1i=new('icons/hair7.dmi')
			if(8)
				h1i=new('icons/hair8.dmi')
			if(9)
				h1i=new('icons/hair9.dmi')
			if(10)
				h1i=new('icons/hair10.dmi')
			if(11)
				h1i=new('icons/hair11.dmi')
			if(12)
				h1i=new('icons/hair12.dmi')
			if(13)
				h1i=new('icons/hair13.dmi')


		if(h1i)

			if(EN[1])h1i.Blend(src.hair_color)
			var/icon/h2i
			if(src.hair_type==11)
				h2i=new('icons/hair11o.dmi')
				if(EN[1])h2i.Blend(src.hair_color)

			var/image/h1
			var/pixy=0
			if(src.hair_type==11)
				pixy=2
			var/h2
			if(overband)
				h1=image(h1i,layer=FLOAT_LAYER-1,pixel_y=pixy)
				if(h2i)
					h2=image(h2i,layer=FLOAT_LAYER-1)

			else
				h1=image(h1i,layer=FLOAT_LAYER-2,pixel_y=pixy)
				if(h2i)
					h2=image(h2i,layer=FLOAT_LAYER-2)
			L+= h1
			if(h2)
				L+=h2
		if(special)L+=special
		if(undershirt) L+=undershirt
		if(pants) L+=pants
		if(overshirt) L+=overshirt
		if(shoes)L+=shoes
		if(legarmor) L+=legarmor
		if(armor)L+=armor
		if(armarmor)L+=armarmor
		if(glasses)L+=glasses
		if(facearmor)L+=facearmor
		if(cloak)L+=cloak
		if(back)L+=back
		if(weapon)L+=weapon
		if(src.gate>=1)
			L+=image('icons/gatepower.dmi',layer=FLOAT_LAYER)
		var/Q[0]

		if(alph || scale)
			for(var/X in L)
				if(istype(X,/image))
					var/image/Z=X

					var/icon/E = new(Z.icon)
					if(alph)
						E.MapColors(1,0,0, 0, 0,1,0, 0, 0,0,1, 0, 0, 0, 0, alph, 0, 0, 0, 0)
					if(scale)
						E.Scale(scale,scale)
					Z.icon=E
					Q+=Z
				else

					var/obj/r = new X
					var/icon/E=new(r.icon)
					if(alph)
						E.MapColors(1,0,0, 0, 0,1,0, 0, 0,0,1, 0, 0, 0, 0, alph, 0, 0, 0, 0)
					if(scale)
						E.Scale(scale,scale)
					del(r)
					Q+=E



			src.overlays=Q
		else
			src.overlays=L
obj/var
	burst=1