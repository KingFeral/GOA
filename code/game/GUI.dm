obj
	decoy
		density=1
		/*New()
			var/tx
			while(src)
				tx=src.x
				walk(src,src.dir)
				sleep(1)
				tx=src.x
				sleep(1)
				if(tx==src.x)
					if(src.dir==EAST)
						src.dir=WEST
					else
						src.dir=EAST*/

obj/kunai_melee
	icon='icons/kunai_melee.dmi'
obj/Kunai_Holster
	icon='icons/Kunai_Holster.dmi'
	layer=FLOAT_LAYER-7
obj/arm_guards
	icon='icons/arm_guards.dmi'
	layer=FLOAT_LAYER-5
obj/sasuke_cloth
	icon='icons/sasuke_cloth.dmi'
	layer=FLOAT_LAYER-2


mob
	proc/increase_con()
		usr = src
		if(usr.levelpoints >= 1)
			var/effective_level = usr.blevel - (round(usr.levelpoints / 6) + 1)
			if(usr.con < ((usr.blevel) * 3 + effective_level + 50))
				var/clan_divider = (src.clan == "Genius") ? (8) : (10)
				//if((++int - 50) % clan_divider == 0) skillspassive[INTELLIGENCE]++
				var/intb = round((con - 50) / clan_divider)
				con++
				levelpoints--
				var/intc = round((con - 50) / clan_divider)
				if(intb != intc) skillspassive[CONTROL]++			/*	var/base_amount = 50
				var/base_multiplier = (usr.clan == "Genius") ? (8) : (10)
				var/rfxb = round(usr.rfx - base_amount / base_multiplier)

				usr.rfx++
				usr.levelpoints--

				var/rfxc = round(usr.rfx - base_amount / base_multiplier)
				if(rfxb != rfxc)
					usr.skillspassive[REFLEX]++*/

				//usr.pint=0
				usr:Level_Up("con")
				return 1
			else
				usr<<"'Control' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
				return 0

	proc/increase_rfx()
		usr = src
		if(usr.levelpoints >= 1)
			var/effective_level = usr.blevel - (round(usr.levelpoints / 6) + 1)
			if(usr.rfx < ((usr.blevel) * 3 + effective_level + 50))
				var/clan_divider = (src.clan == "Genius") ? (8) : (10)
				//if((++int - 50) % clan_divider == 0) skillspassive[INTELLIGENCE]++
				var/intb = round((rfx - 50) / clan_divider)
				rfx++
				levelpoints--
				var/intc = round((rfx - 50) / clan_divider)
				if(intb != intc) skillspassive[REFLEX]++			/*	var/base_amount = 50
				var/base_multiplier = (usr.clan == "Genius") ? (8) : (10)
				var/rfxb = round(usr.rfx - base_amount / base_multiplier)

				usr.rfx++
				usr.levelpoints--

				var/rfxc = round(usr.rfx - base_amount / base_multiplier)
				if(rfxb != rfxc)
					usr.skillspassive[REFLEX]++*/

				//usr.pint=0
				usr:Level_Up("rfx")
				return 1
			else
				usr<<"'Reflex' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
				return 0

	proc/increase_int()
		usr = src
		if(usr.levelpoints >= 1)
			var/effective_level = usr.blevel - (round(usr.levelpoints / 6) + 1)
			if(usr.int < ((usr.blevel) * 3 + effective_level + 50))
				var/clan_divider = (src.clan == "Genius") ? (8) : (10)
				//if((++int - 50) % clan_divider == 0) skillspassive[INTELLIGENCE]++
				var/intb = round((int - 50) / clan_divider)
				int++
				levelpoints--
				var/intc = round((int - 50) / clan_divider)
				if(intb != intc) skillspassive[INTELLIGENCE]++
			/*	var/base_amount =
				var/base_multiplier = (usr.clan == "Genius") ? (8) : (10)
				var/rfxb = round(usr.rfx - base_amount / base_multiplier)

				usr.rfx++
				usr.levelpoints--

				var/rfxc = round(usr.rfx - base_amount / base_multiplier)
				if(rfxb != rfxc)
					usr.skillspassive[REFLEX]++*/

				//usr.pint=0
				usr:Level_Up("int")
				return 1
			else
				usr << "'Intelligence' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
				return 0

	proc/increase_str()
		usr = src
		if(usr.levelpoints >= 1)
			var/effective_level = usr.blevel - (round(usr.levelpoints / 6) + 1)
			if(usr.str < ((usr.blevel) * 3 + effective_level + 50))
				var/clan_divider = (src.clan == "Genius") ? (8) : (10)
				//if((++int - 50) % clan_divider == 0) skillspassive[INTELLIGENCE]++
				var/intb = round((str - 50) / clan_divider)
				str++
				levelpoints--
				var/intc = round((str - 50) / clan_divider)
				if(intb != intc) skillspassive[STRENGTH]++			/*	var/base_amount = 50
				var/base_multiplier = (usr.clan == "Genius") ? (8) : (10)
				var/rfxb = round(usr.rfx - base_amount / base_multiplier)

				usr.rfx++
				usr.levelpoints--

				var/rfxc = round(usr.rfx - base_amount / base_multiplier)
				if(rfxb != rfxc)
					usr.skillspassive[REFLEX]++*/

				//usr.pint=0
				usr:Level_Up("str")
				return 1
			else
				usr<<"'Strength' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
				return 0

obj
	gui
		layer=9
	gui/fakecards/arrow
		rfx_uparrow
			Click()
				usr.increase_rfx()
				return
			/*	if(usr.levelpoints>=1)
					var/effective_level = usr.blevel - (round(usr.levelpoints / 6)+1)
					if(usr.rfx < ((usr.blevel)*3 + effective_level + 50))
						var/rfxb=round(usr.rfx/10)

						usr.rfx++
						usr.levelpoints-=1

						var/rfxc=round(usr.rfx/10)
						if(rfxb!=rfxc)
							usr.skillspassive[26]+=1

						//usr.pint=0
						usr:Level_Up("rfx")
					else
						usr<<"'Reflex' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."

*/
		str_uparrow
			Click()
				usr.increase_str()
				return
		/*		if(usr.levelpoints>=1)
					var/effective_level = usr.blevel - (round(usr.levelpoints / 6)+1)
					if(usr.str < ((usr.blevel)*3 + effective_level + 50))
						var/strb=round(usr.str/10)

						usr.str++
						usr.levelpoints-=1

						var/strc=round(usr.str/10)
						if(strb!=strc)
							usr.skillspassive[25]+=1

						//usr.pint=0
						usr:Level_Up("str")

					else
						usr<<"'Strength' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
*/
		int_uparrow
			Click()
				usr.increase_int()
				return
			/*
				if(usr.levelpoints>=1)
					var/effective_level = usr.blevel - (round(usr.levelpoints / 6)+1)
					if(usr.int < ((usr.blevel)*3 + effective_level + 50))
						var/intb=round(usr.int/10)

						usr.int++
						usr.levelpoints-=1

						var/intc=round(usr.int/10)
						if(intb!=intc)
							usr.skillspassive[27]+=1

						//usr.pint=1
						usr:Level_Up("int")

					else
						usr<<"'Intelligence' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
*/
		con_uparrow
			Click()
				usr.increase_con()
				return
			/*
				if(usr.levelpoints>=1)
					var/effective_level = usr.blevel - (round(usr.levelpoints / 6)+1)
					if(usr.con < ((usr.blevel)*3 + effective_level + 50))
						var/conb=round(usr.con/10)

						usr.con++
						usr.levelpoints-=1

						var/conc=round(usr.con/10)
						if(conb!=conc)
							usr.skillspassive[28]+=1

						//usr.pint=0
						usr:Level_Up("con")
					else
						usr<<"'Control' cannot exceed [(usr.blevel)*3+50] (+[effective_level]/[usr.blevel] levelup bonus points) at your current level."
*/
	gui/fakecards
	gui/fakecards/dull
		layer=999
		icon='icons/gui.dmi'
		icon_state="dull"


	gui/fakecards/Buy
		icon='pngs/buy.png'
		Click()


var/Bindables=list("Remove Bind","Q","W","E","R","T","Y","I","O","P","G","H","J","K","L","X","C","V","B","N","M","`","-","=",",",".","/","{","}","\\","Tab","Back")

obj/var/macover
obj

/*	gui/skillcards


		New()
			..()
			mouse_drag_pointer=icon('guidrag.dmi',src.icon_state)
	gui/skillcards/Size_Down
		chakracost=5
		icon='icons/gui.dmi'
		icon_state="sizedown"
		sindex=118
		suppliescost=0
		cooldown=5
		code=262
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)
	gui/skillcards/Chidori_Senbon
		chakracost=200
		icon='icons/gui.dmi'
		icon_state="chidorisenbon"
		sindex=117
		suppliescost=0
		cooldown=30
		code=261
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)
	gui/skillcards/Water_Collision_Destruction
		chakracost=450
		icon='icons/gui.dmi'
		icon_state="watercollision"
		sindex=119
		suppliescost=0
		cooldown=70
		code=260
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)
	gui/skillcards/Dragon_Fire_Projectile//watercollision
		chakracost=500
		icon='icons/gui.dmi'
		icon_state="dragonfire"
		sindex=120
		suppliescost=0
		cooldown=70
		code=259
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)
	gui/skillcards/Earth_Flow_River
		chakracost=400
		icon='icons/gui.dmi'
		icon_state="earthflow"
		sindex=121
		suppliescost=0
		cooldown=60
		code=258
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)
	gui/skillcards/Poison_Needles

		icon='icons/gui.dmi'
		icon_state="poison_needles"
		sindex=POISON_NEEDLES
		suppliescost=5
		cooldown=60
		code=27
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Camouflage_Concealment_Technique
		sindex=CAMOFLAGE_CONCEALMENT
		code=4
		icon='icons/gui.dmi'
		icon_state="Camouflage Concealment Technique"
		chakracost=100
		cooldown=60
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Twin_Rising_Dragons
		icon='icons/gui.dmi'
		icon_state="Twin Rising Dragons"
		sindex=TWIN_RISING_DRAGONS
		chakracost=100
		suppliescost=100
		cooldown=120
		code=35
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/chakra_leach
		sindex=CHAKRA_LEECH
		icon='icons/gui.dmi'
		icon_state="chakra_leach"
		code=46
		chakracost=100
		cooldown=60
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Meattank
		sindex=MEAT_TANK
		icon='icons/gui.dmi'
		icon_state="meattank"
		chakracost=300
		code=22
		cooldown=30
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Spinach_Pill
		icon='icons/gui.dmi'
		icon_state="spinach"
		sindex=SPINACH_PILL
		chakracost=0
		cooldown=5
		code=32
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Curry_Pill
		icon='icons/gui.dmi'
		icon_state="curry"
		sindex=CURRY_PILL
		chakracost=0
		cooldown=5
		code=7
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Exploading_Bird
		icon='icons/gui.dmi'
		icon_state="exploading bird"
		sindex=EXPLODING_BIRD
		chakracost=300
		cooldown=5
		code=11
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)
	gui/skillcards/Exploading_Spider
		icon='icons/gui.dmi'
		icon_state="exploading spider"
		sindex=EXPLODING_SPIDER
		chakracost=300
		cooldown=5
		code=13
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/C3
		icon='icons/gui.dmi'
		icon_state="c3"
		code=3
		sindex=C3
		chakracost=800
		cooldown=160

		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Stab_Self
		icon='icons/gui.dmi'
		icon_state="masachism"
		sindex=MASOCHISM
		chakracost=0
		code=33
		cooldown=3
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Blood_Bind
		icon='icons/gui.dmi'
		code=2
		icon_state="blood contract"
		sindex=BLOOD_BIND
		chakracost=450
		cooldown=200
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Wound_Regeneration
		icon='icons/gui.dmi'
		icon_state="wound regeneration"
		sindex=WOUND_REGENERATION
		chakracost=100
		cooldown=5
		code=37
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Immortality
		icon='icons/gui.dmi'
		icon_state="imortality"
		sindex=IMMORTALITY
		chakracost=400
		cooldown=300
		code=18

		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sizeup1
		sindex=SIZEUP1
		chakracost=400
		cooldown=200
		code=96
		icon='icons/gui.dmi'
		icon_state="sizeup1"
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sizeup2
		sindex=SIZEUP2
		chakracost=500
		code=97
		cooldown=200
		icon='icons/gui.dmi'
		icon_state="sizeup2"
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/darkness_genjutsu
		icon='icons/gui.dmi'
		icon_state="darkness"
		sindex=DARKNESS_GENJUTSU
		chakracost=800
		code=49
		cooldown=200
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/chakra_taijutsu_release
		icon='icons/gui.dmi'
		code=47
		icon_state="chakra_taijutsu_release"
		sindex=CHAKRA_TAI_RELEASE
		chakracost=100
		cooldown=10
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Mystical_Palm_cancel
		sindex=MYSTICAL_PALM_CANCEL
		icon='icons/gui.dmi'
		icon_state="mystical_palm_technique_cancel"
		chakracost=0
		cooldown=5
		code=24
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Mystical_Palm
		sindex=MYSTICAL_PALM
		icon='icons/gui.dmi'
		icon_state="mystical_palm_technique"
		chakracost=100
		cooldown=30
		code=23
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Pheonix_rebirth
		sindex=PHOENIX_REBIRTH
		icon='icons/gui.dmi'
		icon_state="pheonix_rebirth"
		chakracost=800
		cooldown=1200
		code=25
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/important_body_ponts_disturbance
		sindex=IMPORTANT_BODY_PTS_DISTURB
		code=67
		icon='icons/gui.dmi'
		icon_state="important_body_ponts_disturbance"
		chakracost=100
		cooldown=180
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Sand_Shuriken
		sindex=SAND_SHURIKEN
		icon='icons/gui.dmi'
		icon_state="sand_shuriken"
		chakracost=300
		cooldown=40
		code=30
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Poison_Mist
		sindex=POISON_MIST
		icon='icons/gui.dmi'
		icon_state="poisonbreath"
		chakracost=420
		cooldown=60
		code=26
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/puppet_henge
		icon='icons/gui.dmi'
		icon_state="puppethenge"
		sindex=PUPPET_HENGE
		chakracost=50
		code=80
		suppliescost=0
		staminacost=0
		cooldown=25
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/puppet_swap
		icon='icons/gui.dmi'
		icon_state="puppetswap"
		sindex=PUPPET_SWAP
		chakracost=100
		suppliescost=0
		staminacost=0
		cooldown=45
		code=81
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/puppet_1
		icon='icons/gui.dmi'
		icon_state="puppet1"
		sindex=PUPPET_SUMMON1
		staminacost=0
		code=78
		suppliescost=0
		chakracost=0
		cooldown=60
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/puppet_2
		icon='icons/gui.dmi'
		icon_state="puppet2"
		sindex=PUPPET_SUMMON2
		staminacost=0
		suppliescost=0
		code=79
		chakracost=0
		cooldown=60
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/lioncombo
		icon='icons/gui.dmi'
		icon_state="lioncombo"
		sindex=LION_COMBO
		code=74
		rng=1
		staminacost=600
		suppliescost=0
		chakracost=0
		cooldown=60
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Manipulate_Advancing_Blades
		sindex=MANIPULATE_ADVANCING_BLADES
		icon='icons/gui.dmi'
		icon_state="Manipulate Advancing Blades"
		chakracost=50
		suppliescost=8
		code=21
		staminacost=0
		cooldown=30
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Shuriken_Kage_Bunshin
		sindex=SHUIRKEN_KAGE_BUNSHIN
		icon='icons/gui.dmi'
		icon_state="Shuriken Kage Bunshin no Jutsu"
		chakracost=300
		suppliescost=1
		staminacost=0
		cooldown=60
		code=31
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Exploading_Kage_Bunshin
		sindex=EXPLODING_KAGE_BUNSHIN
		icon='icons/gui.dmi'
		code=12
		icon_state="exploading bunshin"
		chakracost=400
		suppliescost=0
		staminacost=0
		cooldown=45
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/demonic_ice_mirrors
		sindex=DEMONIC_ICE_MIRRORS
		code=51
		icon='icons/gui.dmi'
		icon_state="demonic_ice_mirrors"
		chakracost=550
		suppliescost=0
		staminacost=0
		cooldown=180
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/ice_needles
		sindex=ICE_NEELDES
		code=66
		icon='icons/gui.dmi'
		icon_state="ice_needles"
		chakracost=200
		suppliescost=0
		staminacost=0
		cooldown=20
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/ice_spike_explosion
		sindex=ICE_SPIKE_EXPLOSION
		code=219
		icon='icons/gui.dmi'
		icon_state="ice_spike_explosion"
		chakracost=350
		suppliescost=0
		staminacost=0
		cooldown=60
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/taijuu_kage_bunshin
		icon='icons/gui.dmi'
		icon_state="taijuu_kage_bunshin"
		sindex=TAJUU_KAGE_BUNSHIN
		chakracost=75
		suppliescost=0
		staminacost=0
		code=100
		cooldown=60
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/bone_spines
		sindex=BONE_SPINES
		icon='icons/gui.dmi'
		code=42
		icon_state="bone_spines"
		chakracost=100
		suppliescost=0
		staminacost=0
		cooldown=35
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sawarabi
		sindex=SAWARIBI
		icon='icons/gui.dmi'
		icon_state="sawarabi"
		chakracost=150
		suppliescost=0
		code=87
		staminacost=0
		cooldown=120
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards
		var
			distance_range=0
			rng=8

	gui/skillcards/sand_control
		sindex=SAND_CONTROL
		icon='icons/gui.dmi'
		icon_state="sand_control"
		chakracost=300
		suppliescost=0
		staminacost=0
		code=84
		cooldown=10
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/desert_funeral
		sindex=DESERT_FUNERAL
		icon='icons/gui.dmi'
		icon_state="desert_funeral"
		code=52
		chakracost=400
		suppliescost=0
		staminacost=0
		cooldown=120
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sand_shield
		sindex=SAND_SHIELD
		icon='icons/gui.dmi'
		icon_state="sand_shield"
		chakracost=100
		suppliescost=0
		staminacost=0
		code=85
		cooldown=20
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sand_armor
		sindex=SAND_ARMOR
		icon='icons/gui.dmi'
		code=83
		icon_state="sand_armor"
		chakracost=200
		suppliescost=0
		staminacost=0
		cooldown=60
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sand_unsummoning
		sindex=SAND_UNSUMMON
		icon='icons/gui.dmi'
		icon_state="sand_unsummon"
		chakracost=20
		suppliescost=0
		staminacost=0
		code=86
		cooldown=3
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/bone_harden
		icon='icons/gui.dmi'
		icon_state="bone_harden"
		sindex=BONE_HARDEN
		chakracost=20
		code=40
		suppliescost=0
		staminacost=0
		cooldown=80
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/bone_harden_cancel
		code=41
		icon='icons/gui.dmi'
		icon_state="bone_harden_cancel"
		sindex=BONE_HARDEN_CANCEL
		chakracost=0
		suppliescost=0
		staminacost=0
		cooldown=3
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/bone_sword
		icon='icons/gui.dmi'
		icon_state="bone_sword"
		sindex=BONE_SWORD
		chakracost=100
		suppliescost=0
		staminacost=0
		code=43
		cooldown=200
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/bone_bullets
		icon='icons/gui.dmi'
		icon_state="bonebullets"
		sindex=BONE_BULLETS
		chakracost=100
		suppliescost=0
		code=218
		staminacost=0
		cooldown=20
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/gate1
		icon='icons/gui.dmi'
		icon_state="gate1"
		sindex=GATE1
		chakracost=300
		suppliescost=0
		code=57
		staminacost=0
		cooldown=400
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/gate2
		icon='icons/gui.dmi'
		icon_state="gate2"
		sindex=GATE2
		code=58
		chakracost=300
		suppliescost=0
		staminacost=0
		cooldown=400
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/gate3
		icon='icons/gui.dmi'
		icon_state="gate3"
		sindex=GATE3
		chakracost=300
		code=59
		suppliescost=0
		staminacost=0
		cooldown=400
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/gate4
		icon='icons/gui.dmi'
		icon_state="gate4"
		sindex=GATE4
		code=60
		chakracost=300
		suppliescost=0
		staminacost=0
		cooldown=400
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/gate5
		icon='icons/gui.dmi'
		icon_state="gate5"
		sindex=GATE5
		chakracost=300
		suppliescost=0
		code=61
		staminacost=0
		cooldown=400
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/gate_cancel
		icon='icons/gui.dmi'
		icon_state="cancelgates"
		sindex=GATE_CANCEL
		chakracost=0
		suppliescost=0
		staminacost=0
		code=62
		cooldown=5
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sharingancopy
		sindex=SHARINGAN_COPY
		icon='icons/gui.dmi'
		icon_state="sharingancopy"
		chakracost=300
		code=94
		suppliescost=0
		staminacost=0
		cooldown=60
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/oodama_rasengan
		icon='icons/gui.dmi'
		icon_state="oodama_rasengan"
		sindex=OODAMA_RASENGAN
		chakracost=500
		suppliescost=0
		staminacost=0
		code=76
		cooldown=140
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/crow_depart_genjutsu
		icon='icons/gui.dmi'
		icon_state="crow_depart"
		sindex=CROW_DEPART_GENJUTSU
		chakracost=100
		suppliescost=0
		code=48
		staminacost=0
		cooldown=180
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/rasengan
		icon='icons/gui.dmi'
		icon_state="rasengan"
		sindex=RASENGAN
		chakracost=300
		suppliescost=0
		code=82
		staminacost=0
		cooldown=90
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/shadow_cancel
		icon='icons/gui.dmi'
		icon_state="cancel_shadow"
		sindex=SHADOW_CANCEL
		chakracost=0
		code=88
		suppliescost=0
		staminacost=0
		cooldown=1
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/shadow_neck_bind
		icon='icons/gui.dmi'
		icon_state="shadow_neck_bind"
		sindex=SHADOW_NECK_BIND
		chakracost=100
		code=90
		suppliescost=0
		staminacost=0
		cooldown=5
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/shadow_sewing_needles
		icon='icons/gui.dmi'
		icon_state="shadow_sewing_needles"
		sindex=SHADOW_SEWING_NEEDLES
		chakracost=200
		code=91
		suppliescost=0
		staminacost=0
		cooldown=80
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/shadow_imitation
		icon='icons/gui.dmi'
		icon_state="shadow_imitation"
		sindex=SHADOW_IMITATION
		chakracost=50
		suppliescost=0
		staminacost=0
		code=89
		cooldown=3
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/doton_split_earth_turn_around_palm
		icon='icons/gui.dmi'
		code=53
		icon_state="doton_split_earth_turn_around_palm"
		sindex=DOTON_CHAMBER_CRUSH
		chakracost=250
		suppliescost=0
		staminacost=0
		cooldown=100
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/katon_tajuu_phoenix_immortal_fire
		sindex=KATON_TAJUU_PHOENIX
		icon='icons/gui.dmi'
		icon_state="katon_super_phoenix_immortal_fire"
		chakracost=200
		suppliescost=0
		code=72
		staminacost=0
		cooldown=40
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Raikiri
		icon='icons/gui.dmi'
		icon_state="Raikiri"
		chakracost=550
		suppliescost=0
		staminacost=0
		code=28
		cooldown=130
		sindex=RAIKIRI
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/fuuton_air_bullet
		icon='icons/gui.dmi'
		icon_state="fuuton_air_bullet"
		sindex=FUUTON_AIR_BULLET
		chakracost=350
		suppliescost=0
		code=56
		cooldown=30
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Suiton_Syrup_Capture_Field
		sindex=SUITON_SYRUP_FIELD
		icon='icons/gui.dmi'
		icon_state="suiton_Syrup_Capture_Field"
		chakracost=280
		suppliescost=0
		cooldown=90
		code=34
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/expl_note
		icon='icons/gui.dmi'
		icon_state="explnote"
		sindex=EXPLODING_NOTE
		chakracost=0
		code=55
		suppliescost=15
		cooldown=10
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/expl_kunai
		icon='icons/gui.dmi'
		code=54
		icon_state="explkunai"
		sindex=EXPLODING_KUNAI
		chakracost=0
		suppliescost=20
		cooldown=10
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/gentle_fist
		icon='icons/gui.dmi'
		icon_state="gentle_fist"
		sindex=GENTLE_FIST
		chakracost=100
		cooldown=30
		code=63
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/hakke_64
		icon='icons/gui.dmi'
		icon_state="64 palms"
		sindex=HAKKE_64
		chakracost=500
		distance_range=3
		cooldown=120
		code=64
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/kaiten
		icon='icons/gui.dmi'
		icon_state="kaiten"
		sindex=KAITEN
		code=70
		chakracost=90
		cooldown=10
		distance_range=3
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/achiever_of_nirvana_fist
		icon='icons/gui.dmi'
		icon_state="achiever_of_nirvana_fist"
		sindex=NIRVANA_FIST
		staminacost=150
		cooldown=10
		code=38
		rng=1
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/leaf_great_whirlwind
		icon='icons/gui.dmi'
		code=73
		icon_state="leaf_great_whirlwind"
		sindex=LEAF_WHIRLWIND
		staminacost=100
		cooldown=20
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/paralyse_genjutsu
		icon='icons/gui.dmi'
		icon_state="paralyse_genjutsu"
		chakracost=100
		code=77
		cooldown=60
		sindex=PARALYZE_GENJUTSU
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sleep_genjutsu
		icon='icons/gui.dmi'
		icon_state="sleep_genjutsu"
		chakracost=250
		cooldown=120
		code=99
		sindex=SLEEP_GENJUTSU
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/kagebunshin
		icon='icons/gui.dmi'
		icon_state="kagebunshin"
		chakracost=150
		code=69
		cooldown=60
		sindex=KAGE_BUNSHIN
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/medical
		icon='icons/gui.dmi'
		icon_state="medical_jutsu"
		chakracost=60
		suppliescost=0
		staminacost=0
		cooldown=5
		code=75
		sindex=MEDIC
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/byakugan
		icon='icons/gui.dmi'
		icon_state="byakugan"
		chakracost=80
		suppliescost=0
		staminacost=0
		code=45
		cooldown=240
		sindex=BYAKUGAN
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Dungeon_Chamber_of_Nothingness
		icon='icons/gui.dmi'
		icon_state="Dungeon Chamber of Nothingness"
		chakracost=100
		suppliescost=0
		staminacost=0
		code=10
		cooldown=40
		sindex=DOTON_CHAMBER
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Futon_Great_Breakthrough
		icon='icons/gui.dmi'
		icon_state="great_breakthrough"
		chakracost=70
		code=15
		suppliescost=0
		staminacost=0
		cooldown=15
		sindex=FUUTON_GREAT_BREAKTHROUGH
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Chidori_Nagashi
		icon='icons/gui.dmi'
		code=6
		icon_state="chidori_nagashi"
		chakracost=100
		suppliescost=0
		staminacost=0
		cooldown=20
		sindex=CHIDORI_CURRENT
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Blade_of_Wind
		icon='icons/gui.dmi'
		code=1
		icon_state="blade_of_wind"
		chakracost=450
		suppliescost=0
		staminacost=0
		cooldown=90
		sindex=FUUTON_WIND_BLADE
		distance_range=1
		rng=1
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Doton_Swamp_of_the_Underworld
		icon='icons/gui.dmi'
		icon_state="doton_swamp_of_the_underworld"
		chakracost=600
		suppliescost=0
		staminacost=0
		code=9
		cooldown=240
		sindex=DOTON_SWAMP
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Katon_Ash_Product_Burning
		icon='icons/gui.dmi'
		icon_state="katon_ash_product_burning"
		chakracost=450
		suppliescost=0
		staminacost=0
		code=19
		cooldown=120
		sindex=KATON_ASH_BURNING
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Katon_Phoenix_Immortal_Fire
		icon='icons/gui.dmi'
		icon_state="katon_phoenix_immortal_fire"
		chakracost=50
		suppliescost=0
		code=20
		staminacost=0
		cooldown=10
		sindex=KATON_PHOENIX_FIRE
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Water_Dragon_Blast
		icon='icons/gui.dmi'
		icon_state="water_dragon_blast"
		chakracost=100
		suppliescost=0
		staminacost=0
		cooldown=90
		code=36
		sindex=SUITON_DRAGON
		needwater=1
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Doton_Iron_Skin
		icon='icons/gui.dmi'
		icon_state="doton_iron_skin"
		chakracost=150
		suppliescost=0
		staminacost=0
		code=8
		cooldown=240
		sindex=DOTON_IRON_SKIN
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Raton_Sword_Form_Assasination_Jutsu
		icon='icons/gui.dmi'
		icon_state="raton_sword_form_assasination_technique"
		chakracost=350
		suppliescost=0
		staminacost=0
		code=29
		cooldown=150
		sindex=CHIDORI_SPEAR
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Futon_Pressure_Damage
		icon='icons/gui.dmi'
		icon_state="futon_pressure_damage"
		chakracost=300
		suppliescost=0
		staminacost=0
		cooldown=120
		code=16
		sindex=FUUTON_PRESSURE_DAMAGE
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Exploading_Water_Shockwave
		icon='icons/gui.dmi'
		code=14
		icon_state="exploading_water_shockwave"
		chakracost=500
		suppliescost=0
		staminacost=0
		code=17
		cooldown=120
		sindex=SUTION_SHOCKWAVE
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Giant_Vortex
		icon='icons/gui.dmi'
		icon_state="giant_vortex"
		chakracost=200
		suppliescost=0
		staminacost=0
		cooldown=60
		sindex=SUITON_VORTEX
		code=220
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/Chidori
		icon='icons/gui.dmi'
		code=5
		icon_state="chidori"
		distance_range=2
		chakracost=400
		suppliescost=0
		staminacost=0
		cooldown=90
		sindex=CHIDORI
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/katon_grand_fireball
		code=71
		name="Katon Grand Fireball no Jutsu"
		icon='icons/gui.dmi'
		icon_state="grand_fireball"
		chakracost=150
		distance_range=5
		suppliescost=0
		staminacost=0
		cooldown=60
		sindex=KATON_FIREBALL
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/henge
		icon='icons/gui.dmi'
		icon_state="henge"
		chakracost=40
		suppliescost=0
		staminacost=0
		code=65
		cooldown=60
		sindex=HENGE
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/karawimi
		icon='icons/gui.dmi'
		icon_state="kawarimi"
		chakracost=50
		suppliescost=0
		staminacost=0
		cooldown=30
		sindex=KAWARIMI
		code=221
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/windmillshuriken
		icon='icons/gui.dmi'
		icon_state="windmill"
		chakracost=0
		suppliescost=30
		code=104
		staminacost=0
		cooldown=30
		sindex=WINDMILL_SHURIKEN
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/shunshin
		icon='icons/gui.dmi'
		icon_state="shunshin"
		chakracost=80
		suppliescost=0
		staminacost=0
		code=95
		cooldown=1
		sindex=SHUNSHIN
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/bunshin
		icon='icons/gui.dmi'
		icon_state="bunshin"
		chakracost=10
		suppliescost=0
		staminacost=0
		cooldown=30
		code=44
		sindex=BUNSHIN
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sharingan_1
		icon='icons/gui.dmi'
		icon_state="sharingan1"
		chakracost=150
		suppliescost=0
		code=92
		staminacost=0
		cooldown=150
		sindex=SHARINGAN1
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)

	gui/skillcards/sharingan_2
		icon='icons/gui.dmi'
		icon_state="sharingan2"
		chakracost=350
		suppliescost=0
		staminacost=0
		cooldown=250
		code=93
		sindex=SHARINGAN2
		Click()
			for(var/obj/gui/skillcards/o in usr.contents)
				o.activated=0
				o.overlays-='selected.dmi'
			src.activated=1
			src.overlays+='selected.dmi'

		verb
			Pick_Up()
				set src in oview(1)
				Move(usr)*/

	gui/skillcards
		layer=10
		var
			exempt=0

		attackcard
			layer=10
			exempt=1
			code=39
			icon='icons/gui.dmi'
			icon_state="attack"
			New(client/C)
				if(!C||!istype(C,/client))return
				if(istype(C,/client))
					screen_loc="12,1"
					C.screen+=src
					..()
				else
					if(istype(C,/mob))
						var/mob/M=C
						if(M.client)
							screen_loc="12,1"
							M.client.screen+=src
			Click()
				if(istype(usr,/mob/human/player))
					if(usr.Primary)
						var/mob/human/Puppet/P =usr.Primary
						if(P)
							P.Melee(usr)
						return
					usr:attackv()

		interactcard
			exempt=1
			code=68
			icon='icons/gui.dmi'
			icon_state="interact0"
			New(client/C)

				if(!C||!istype(C,/client))return
				screen_loc="16,1"
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					usr:interactv()

		usecard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="use"
			code=103
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc="15,1"
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					if(usr.Puppet1 && usr.Puppet1!=usr.Primary && !usr.Primary)
						usr.Primary=usr.Puppet1
						walk(usr.Primary,0)
						usr.client.eye=usr.Puppet1
						return
					else if(usr.Puppet2 && usr.Puppet2!=usr.Primary)
						if(usr.Puppet1 && usr.Puppet1==usr.Primary)
							usr.Primary=usr.Puppet2
							walk(usr.Primary,0)
							usr.client.eye=usr.Puppet2
							return
						else if(!usr.Puppet1)
							usr.Primary=usr.Puppet2
							walk(usr.Primary,0)
							usr.client.eye=usr.Puppet2
							return
					else if(usr.Puppet2 || usr.Puppet1)
						usr.Primary=0
						usr.client.eye=usr.client.mob
						return
					usr:usev()

		skillcard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="skill"
			code=98
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc="13,1"
				C.screen+=src
				..()
/*			Click()
				if(istype(usr,/mob/human/player))
					usr:skillv()*/

		untargetcard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="untarget"
			code=102
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc="17,1"
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					usr.FilterTargets()
					for(var/target in usr.targets)
						usr.RemoveTarget(target)
					usr << "Untargeted"

		treecard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="skilltree"
			code=101
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc="WEST,NORTH"
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					usr:check_skill_tree()

		defendcard
			exempt=1
			icon='icons/gui.dmi'
			icon_state="defend"
			code=50
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc="14,1"
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player))
					if(usr.Puppet1)
						var/mob/human/Puppet/P =usr.Puppet1
						if(P)
							P.Def(usr)
					if(usr.Puppet2)
						var/mob/human/Puppet/P =usr.Puppet2
						if(P)
							P.Def(usr)
					usr.Primary=0
					if(usr.client) usr.client.eye=usr.client.mob
					usr:defendv()

		triggercard
			exempt=1
			icon='icons/new/hud/trigger.dmi'
			icon_state="trigger"
			code=252
			New(client/C)
				if(!C||!istype(C,/client))return
				screen_loc = "WEST,SOUTH"
				C.screen+=src
				..()
			Click()
				if(istype(usr,/mob/human/player) && !usr.ko)
					if(usr.triggers && usr.triggers.len && usr.triggers[usr.triggers.len])
						var/obj/trigger/T = usr.triggers[usr.triggers.len]
						T.Use()

obj/log
	icon='icons/log.dmi'
	icon_state=""
	density=1
	New()
		set waitfor = 0
		src.icon_state="kawa"
		sleep(20)
		//del(src)
		loc = null
mob
	var
		BMM=0






obj
	gui
		hudbar
			icon='icons/hudbar.dmi'

			layer=9
			A
				icon_state="0,0"
				New(client/C)
					if(C)
						screen_loc="1,2"
						C.screen+=src
						..()
			B
				icon_state="1,0"
				New(client/C)
					if(C)
						screen_loc="2,2"
						C.screen+=src
						..()
			C
				icon_state="2,0"
				New(client/C)
					if(C)
						screen_loc="3,2"
						C.screen+=src
						..()
			D
				icon_state="3,0"
				New(client/C)
					if(C)
						screen_loc="4,2"
						C.screen+=src
						..()
			E
				icon_state="4,0"
				New(client/C)
					if(C)
						screen_loc="5,2"
						C.screen+=src
						..()
			F
				icon_state="5,0"
				New(client/C)
					if(C)
						screen_loc="6,2"
						C.screen+=src
						..()
			G
				icon_state="6,0"
				New(client/C)
					if(C)
						screen_loc="7,2"
						C.screen+=src
						..()
			H
				icon_state="7,0"
				New(client/C)
					if(C)
						screen_loc="8,2"
						C.screen+=src
						..()
			I
				icon_state="8,0"
				New(client/C)
					if(C)
						screen_loc="9,2"
						C.screen+=src
						..()
			J
				icon_state="9,0"
				New(client/C)
					if(C)
						screen_loc="10,2"
						C.screen+=src
						..()
			K
				icon_state="10,0"
				New(client/C)
					if(C)
						screen_loc="11,2"
						C.screen+=src
						..()
			L
				icon_state="11,0"
				New(client/C)
					if(C)
						screen_loc="12,2"
						C.screen+=src
						..()
			M
				icon_state="12,0"
				New(client/C)
					if(C)
						screen_loc="13,2"
						C.screen+=src
						..()
			N
				icon_state="13,0"
				New(client/C)
					if(C)
						screen_loc="14,2"
						C.screen+=src
						..()
			O
				icon_state="14,0"
				New(client/C)
					if(C)
						screen_loc="15,2"
						C.screen+=src
						..()

			P
				icon_state="15,0"
				New(client/C)
					if(C)
						screen_loc="16,2"
						C.screen+=src
						..()
			Q
				icon_state="16,0"
				New(client/C)
					if(C)
						screen_loc="17,2"
						C.screen+=src
						..()

		placeholder_numbers
			icon = 'icons/new/hud/skillbar_numbers.png'
			screen_loc = "5, 1"
			layer = 25

			New(client/c)
				if(c)
					c.screen += src

		placeholder
			icon='icons/gui.dmi'
			icon_state=""
			layer=9
			mouse_drop_zone=1
			var
				orig=1

			New(client/C)
				if(C)
					var/mob/X=C.mob
					if(orig)
						X.player_gui.Add(new/obj/gui/placeholder/placeholder1(C),
						new/obj/gui/placeholder/placeholder2(C),
						new/obj/gui/placeholder/placeholder3(C),
						new/obj/gui/placeholder/placeholder4(C),
						new/obj/gui/placeholder/placeholder5(C),
						new/obj/gui/placeholder/placeholder6(C),
						new/obj/gui/placeholder/placeholder7(C),
						new/obj/gui/placeholder/placeholder8(C),
						new/obj/gui/placeholder/placeholder9(C),
						new/obj/gui/placeholder/placeholder0(C))
					else
						..()
			placeholder1
				orig=0
				New(client/C)
					overlays += image(icon, "slot1 0,0", layer = 20, pixel_y = -4)
					screen_loc="5:16,1"
					C.screen+=src
					..()
			placeholder2
				orig=0
				New(client/C)
					overlays += image(icon, "slot2 0,0", layer = 20, pixel_y = -4)
					screen_loc="6:16,1"
					C.screen+=src
					..()
			placeholder3
				orig=0
				New(client/C)
					overlays += image(icon, "slot3 0,0", layer = 20, pixel_y = -4)
					screen_loc="7:16,1"
					C.screen+=src
					..()
			placeholder4
				orig=0
				New(client/C)
					overlays += image(icon, "slot4 0,0", layer = 20, pixel_y = -4)
					screen_loc="8:16,1"
					C.screen+=src
					..()
			placeholder5
				orig=0
				New(client/C)
					overlays += image(icon, "slot5 0,0", layer = 20, pixel_y = -4)
					screen_loc="9:16,1"
					C.screen+=src
					..()
			placeholder6
				orig=0
				New(client/C)
					overlays += image(icon, "slot6 0,0", layer = 20, pixel_y = -4)
					screen_loc="10:16,1"
					C.screen+=src
					..()
			placeholder7
				orig=0
				New(client/C)
					overlays += image(icon, "slot7 0,0", layer = 20, pixel_y = -4)
					screen_loc="11:16,1"
					C.screen+=src
					..()
			placeholder8
				orig=0
				New(client/C)
					overlays += image(icon, "slot8 0,0", layer = 20, pixel_y = -4)
					screen_loc="12:16,1"
					C.screen+=src
					..()
			placeholder9
				orig=0
				New(client/C)
					overlays += image(icon, "slot9 0,0", layer = 20, pixel_y = -4)
					screen_loc="13:16,1"
					C.screen+=src
					..()
			placeholder0
				orig=0
				New(client/C)
					overlays += image(icon, "slot10 0,0", layer = 20, pixel_y = -4)
					screen_loc="14:16,1"
					C.screen+=src
					..()


	gui

		//var
			//deletable=0
			//posit=0
			//activated=0
			//cooldown
			//chakracost
			//suppliescost
			//staminacost
			//sindex
			//needwater=0
		skillcards
			mouse_drop_zone=1
			layer=11

/*			MouseDrop(obj/gui/over_object,src_location,over_location)
				if(src==over_object)
					return
				if(istype(over_object,/obj/gui/placeholder) ||istype(over_object,/obj/gui/skillcards)||istype(over_object,/obj/items))
					if(istype(over_object,/obj/gui/skillcards)&&!over_object.deletable)
						return
					else
						var/spot
						switch(over_object.screen_loc)
							if("2,1")
								spot=1
							if("3,1")
								spot=2
							if("4,1")
								spot=3
							if("5,1")
								spot=4
							if("6,1")
								spot=5
							if("7,1")
								spot=6
							if("8,1")
								spot=7
							if("9,1")
								spot=8
							if("10,1")
								spot=9
							if("11,1")
								spot=0

						if(spot!=null)

							src.Place("[spot]")

						if(istype(over_object,/obj/gui/skillcards))over_object.loc=null

			proc
				Place(S)

					if(src.deletable==0)
						switch(S)
							if("1")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="2,1"
								usr.client.screen+=X
								X.deletable=1

								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==1)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==1)
										del(o)
								X.posit=1
								var/xtype=src.type
								usr.macro1=xtype
							if("2")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="3,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==2)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==2)
										del(o)
								X.posit=2
								usr.macro2=src.type
							if("3")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="4,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==3)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==3)
										del(o)
								X.posit=3
								usr.macro3=src.type
							if("4")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="5,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==4)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==4)
										del(o)
								X.posit=4
								usr.macro4=src.type
							if("5")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="6,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==5)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==5)
										del(o)
								X.posit=5
								usr.macro5=src.type
							if("6")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="7,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==6)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==6)
										del(o)
								X.posit=6
								usr.macro6=src.type
							if("7")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="8,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==7)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==7)
										del(o)
								X.posit=7
								usr.macro7=src.type
							if("8")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="9,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==8)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==8)
										del(o)
								X.posit=8
								usr.macro8=src.type
							if("9")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="10,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==9)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==9)
										del(o)
								X.posit=9
								usr.macro9=src.type
							if("0")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="11,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==10)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==10)
										del(o)
								X.posit=10
								usr.macro10=src.type
			verb
				Remove()
					set category=null
					if(src.deletable==1)
						del(src)
				Set_Custom_Macro()
					set category=null
					var/C
					var/S=null
					if(!S)
						C=input(usr,"Bind Key to Card","Custom Macro") in Bindables
						if(C=="Remove Bind")
							src.cust_macro=null
							src.overlays-=src.macover
							src.macover=null
							winset(usr, "custom_macro_[C]", "parent=")
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
					winset(usr, "custom_macro_[C]", "parent=macro;name=\"[C]+REP\";command=\"custom-macro \\\"[C]\\\"\"")
				Place_on_Screen()
					set category=null
					if(src.deletable==0)
						switch(input2(usr,"Choose a Macro/Screen Location for that SkillCard", "GUI", list ("1","2","3","4","5","6","7","8","9","0","Nevermind")))
							if("1")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="2,1"
								usr.client.screen+=X
								X.deletable=1

								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==1)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==1)
										del(o)
								X.posit=1
								var/xtype=src.type
								usr.macro1=xtype
							if("2")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="3,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==2)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==2)
										del(o)
								X.posit=2
								usr.macro2=src.type
							if("3")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="4,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==3)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==3)
										del(o)
								X.posit=3
								usr.macro3=src.type
							if("4")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="5,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==4)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==4)
										del(o)
								X.posit=4
								usr.macro4=src.type
							if("5")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="6,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==5)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==5)
										del(o)
								X.posit=5
								usr.macro5=src.type
							if("6")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="7,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==6)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==6)
										del(o)
								X.posit=6
								usr.macro6=src.type
							if("7")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="8,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==7)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==7)
										del(o)
								X.posit=7
								usr.macro7=src.type
							if("8")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="9,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==8)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==8)
										del(o)
								X.posit=8
								usr.macro8=src.type
							if("9")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="10,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==9)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==9)
										del(o)
								X.posit=9
								usr.macro9=src.type
							if("0")
								var/obj/gui/X = new src.type(usr)
								usr.player_gui+=X
								X.screen_loc="11,1"
								usr.client.screen+=X
								X.deletable=1
								for(var/obj/gui/o in usr.client.screen)
									if(o.posit==10)
										del(o)
								for(var/obj/items/o in usr.client.screen)
									if(o.posit==10)
										del(o)
								X.posit=10
								usr.macro10=src.type*/

mob
	verb
		macchat()
			set name="macchat"
			set hidden = 1
			if(istype(usr,/mob/human/player))
				winset(usr, "default_input", "focus=true")
		macuntarget()
			set name="macuntarget"
			set hidden = 1
			if(istype(usr,/mob/human/player))
				usr.FilterTargets()
				for(var/target in usr.targets)
					usr.RemoveTarget(target)
				usr << "Untargeted"
		macskilltree()
			set name="macskilltree"
			set hidden = 1
			if(istype(usr,/mob/human/player))
				usr:check_skill_tree()
		macskill()
			set name = "macskill"
			set hidden=1
			if(istype(usr,/mob/human/player))
				for(var/obj/gui/skillcards/skillcard/O in usr.client.screen)
					O.Click()
		macattack()
			set name = "macattack"
			set hidden=1
			if(istype(usr,/mob/human/player))
				usr.attackv()
				/*for(var/obj/gui/skillcards/attackcard/O in usr.client.screen)
					O.Click()*/

		macdefend()
			set name = "macdefend"
			set hidden=1
			if(istype(usr,/mob/human/player))
				usr.defendv()
			/*	for(var/obj/gui/skillcards/defendcard/O in usr.client.screen)
					O.Click()*/

		macinteract()
			set name = "macinteract"
			set hidden=1
			if(istype(usr,/mob/human/player))
				usr.interactv()
				/*for(var/obj/gui/skillcards/interactcard/O in usr.client.screen)
					O.Click()*/

			else if(istype(usr,/mob/charactermenu))
				if(!EN[10])
					return

				if(!usr:hasspaced)
					usr:hasspaced = 1

					if(!checkservs)
						usr.CheckServers()
					//usr.loc = locate_tag("maptag_select")

		macuse()
			set name = "macuse"
			set hidden=1
			usr.usev()
			/*if(istype(usr,/mob/human/player))
				for(var/obj/gui/skillcards/usecard/O in usr.client.screen)
					O.Click()*/
		mactrigger()
			set name = "mactrigger"
			set hidden=1
			if(istype(usr,/mob/human/player) && !usr.ko)
				if(usr.triggers && usr.triggers.len && usr.triggers[usr.triggers.len])
					var/obj/trigger/T = usr.triggers[usr.triggers.len]
					T.Use()

		mac1()
			set name = "mac1"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro1)
				usr.macro1.Activate(usr)
		mac2()
			set name = "mac2"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro2)
				usr.macro2.Activate(usr)
		mac3()
			set name = "mac3"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro3)
				usr.macro3.Activate(usr)
		mac4()
			set name = "mac4"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro4)
				usr.macro4.Activate(usr)
		mac5()
			set name = "mac5"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro5)
				usr.macro5.Activate(usr)
		mac6()
			set name = "mac6"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro6)
				usr.macro6.Activate(usr)
		mac7()
			set name = "mac7"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro7)
				usr.macro7.Activate(usr)
		mac8()
			set name = "mac8"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro8)
				usr.macro8.Activate(usr)
		mac9()
			set name = "mac9"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro9)
				usr.macro9.Activate(usr)
		mac0()
			set name = "mac0"
			set hidden=1
			if(istype(usr,/mob/human/player) && usr.macro10)
				usr.macro10.Activate(usr)
		custom_macro(var/S as text)//custommac
			set name ="custom_macro"
			set hidden=1
			if(!istype(usr,/mob/human/player))return
			for(var/obj/O in usr.client.screen)
				if(O.cust_macro==S)
					O.Click()
					return
			for(var/obj/O in usr.contents)
				if(O.cust_macro==S)
					O.Click()
					return

			// remove the coverimage

obj/var/cust_macro=null
//set src in usr.client.screen
/*
client/script={"<STYLE>BODY {font-family: 'Franklin Gothic Medium'; font-size: 10pt; background: #000000; color: #FFFFFF}  IMG.icon{width:32;height:32}</STYLE>
macro
	num1
		set name = "1"
		return "mac1"

	num2
		set name = "2"
		return "mac2"
	num3
		set name = "3"
		return "mac3"
	num4
		set name = "4"
		return "mac4"
	num5
		set name = "5"
		return "mac5"
	num6
		set name = "6"
		return "mac6"
	num7
		set name = "7"
		return "mac7"
	num8
		set name = "8"
		return "mac8"
	num9
		set name = "9"
		return "mac9"
	num0
		set name = "0"
		return "mac0"
	Numpad3 return "mac3"
	Numpad4 return "mac4"
	Numpad5 return "mac5"
	Numpad6 return "mac6"
	Numpad7 return "mac7"
	Numpad8 return "mac8"
	Numpad9 return "mac9"
	Numpad0 return "mac0"
	a return "macattack"
	s return "macskill"
	d return "macdefend"
	space return "macinteract"
	f return "macuse"
	u return "macuntarget"

	"}*/