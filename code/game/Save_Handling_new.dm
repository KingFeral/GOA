mob/var
	icon/PREV='icons/underpreview.dmi'

mob
	Write(savefile/F)
		..()
		F["last_x"] << x
		F["last_y"] << y
		F["last_z"] << z

	Read(savefile/F)
		..()
		var/last_x
		var/last_y
		var/last_z
		F["last_x"] >> last_x
		F["last_y"] >> last_y
		F["last_z"] >> last_z
		loc = locate(last_x, last_y, last_z)

client
	proc
		SaveMob()
			world.SaveMob(src.mob,src)

mob
	var/tmp/cansave=1

world
	proc
		SaveMob(mob/x,client/vrc, xkey=x.ckey)
			//set waitfor = 0
			if(RP)
				return
			if(!x)
				return
			if(!x.cansave) return
			if(!x.initialized)
				return
			if(!istype(x,/mob/human/player))
				return
			var/oldname=x.name
			if(x.realname)
				x.name=x.realname
			var/list/S=new/list()
			var/list/inv=new/list()

			var/list/bar=new/list()
			var/list/strg=new/list()
			var/list/nums=new/list()
			var/list/lst=new/list()

			if(x)
				var/kay=x.ckey
				if(!kay)
					kay=vrc.ckey
				if(!kay)
					return

				var/newbounty = x.bounty//round(x.bounty * 0.9)
				var/savex=x.x
				var/savey=x.y

				var/savez=x.z

				if(x.cexam)
					var/obj/Respawn_Pt/Re=null
					for(var/obj/Respawn_Pt/R in world)
						if(x.faction.village=="Missing"&&R.ind==0)
							Re=R
						if(x.faction.village=="Konoha"&&R.ind==1)
							Re=R
						if(x.faction.village=="Suna"&&R.ind==2)
							Re=R
						if(x.faction.village=="Kiri"&&R.ind==3)
							Re=R
					if(Re)
						savex = Re.x
						savey = Re.y
						savez = Re.z
					else
						savex=31
						savey=74
						savez=1
				var/skillcounts=0
				for(var/X in x.skills)
					if(isnum(X))
						skillcounts+=X

				var/itemlist[]=new

				var/puppetsave1[]=new
				var/puppetsave2[]=new
				var/puppetsave3[]=new

				for(var/obj/items/o in x.contents)

					if(!istype(o,/obj/items/weapons/melee/sword/Bone_Sword))
						if(!istype(o,/obj/items/Puppet))
							if(o.deletable==0)
								var/id = type2index(o.type)
								if(id && isnum(id))
									itemlist+=id
									itemlist+=o.equipped
						else

							if(x&&x.Puppets&&x.Puppets.len>=1&&o==x.Puppets[1])

								puppetsave1+=type2index(o.type)
								puppetsave2+=o.name
								puppetsave3+=1
							else if(x&&x.Puppets&&x.Puppets.len>=2&&o==x.Puppets[2])

								puppetsave1+=type2index(o.type)
								puppetsave2+=o.name
								puppetsave3+=2
							else
								puppetsave1+=type2index(o.type)
								puppetsave2+=o.name
								puppetsave3+=(o.equipped) ? (o.equipped) : (0)//0
								//world.log<<"PUPPET WEAPON INSTALL FOR [o.name] IS [(o.install) ? (1) : (0)]"

				var
					skill_info[0]

				/*for(var/list/l in list(puppetsave1,puppetsave2,puppetsave3))
					for(var/z in l)
						world.log<<"SAVED THIS FOR PUPPETS: [z]"*/

				for(var/skill/skill in x.skills)
					skill_info += skill.id
					skill_info += skill.cooldown
					skill_info += skill.uses

				nums.len=41
				nums[1]=x.ezing
				nums[2]=x.MissionCool
				nums[3]=0
				nums[4]=x.votecool
				nums[5]=x.votecool2
				nums[6]=x.factionpoints
				nums[7]=x.overband
				nums[8]=x.Rank_D
				nums[9]=x.Rank_C
				nums[10]=x.Rank_B
				nums[11]=x.Rank_A
				nums[12]=x.Rank_S
				nums[13]=newbounty
				nums[14]=x.hair_type
				nums[15]=x.con
				nums[16]=x.str
				nums[17]=x.int
				nums[18]=x.rfx
				nums[19]=x.skillpoints
				nums[20]=x.levelpoints
				nums[21]=x.money
				nums[22]=max(0,x.stamina)
				nums[23]=max(0,x.curstamina)
				nums[24]=max(0,x.chakra)
				nums[25]=max(0,x.curchakra)
				nums[26]=max(0,x.maxwound)
				nums[27]=max(0,x.curwound)
				nums[28]=x.body
				nums[29]=x.blevel
				nums[30]=x.ko
				nums[31]=x.supplies
				nums[32]=savex
				nums[33]=savey
				nums[34]=savez
				nums[35]=x.kills
				nums[36]=x.deaths
				nums[37] = x.eyecolor_red
				nums[38] = x.eyecolor_green
				nums[39] = x.eyecolor_blue
				nums[40] = x.double_xp_time
				nums[41] = x.triple_xp_time

				lst.len=8
				lst[1]=list2params(x.skillspassive)
				lst[2]=list2params(skill_info)
				lst[3]=list2params(puppetsave1)
				lst[4]=list2params(puppetsave2)
				lst[5]=list2params(puppetsave3)
				lst[6]=list2params(x.macro_set)
				lst[7]=list2params(x.elements)

				strg.len=10
				strg[1]=x.Last_Hosted
				strg[2]=x.lasthostile
				strg[3]=x.rank
				strg[4]=x.icon_name
				strg[5]=x.name
				strg[6]=x.faction.name
				if(x.squad)
					strg[7]=x.squad.name
				else
					strg[7]=null
				strg[8]=x.hair_color
				strg[9]=x.clan
				strg[10]=md5("[nums[28]]["squad_delete"][nums[15]+nums[16]+nums[17]+nums[18]]["faction_info"][nums[29]]["get_chars"][nums[20]]["check_name"][nums[19]]")

				bar.len=10
				bar[1]=x.macro1?(x.macro1.id):0
				bar[2]=x.macro2?(x.macro2.id):0
				bar[3]=x.macro3?(x.macro3.id):0
				bar[4]=x.macro4?(x.macro4.id):0
				bar[5]=x.macro5?(x.macro5.id):0
				bar[6]=x.macro6?(x.macro6.id):0
				bar[7]=x.macro7?(x.macro7.id):0
				bar[8]=x.macro8?(x.macro8.id):0
				bar[9]=x.macro9?(x.macro9.id):0
				bar[10]=x.macro10?(x.macro10.id):0

				inv=itemlist

				x.name=oldname
				S.len=5
				nums[22]=round(nums[22]*100)/100
				nums[23]=round(nums[23]*100)/100
				nums[24]=round(nums[24]*100)/100
				nums[25]=round(nums[25]*100)/100
				S[1]=inv
				S[2]=bar
				S[3]=strg
				S[4]=nums
				S[5]=lst

				//for(var/client/M in SaveListen)
				//	M<<"Saved [x.name] ([xkey])"
				saves.SaveCharacter(xkey, inv, bar, strg, nums, lst)

client
	proc
		LoadMob(list/S)

			if(!S || S.len<5)
				return

			var/list/inv=S[1]
			var/list/bar=S[2]
			var/list/strg=S[3]
			var/list/nums=S[4]
			var/list/lst=S[5]

			for(var/i = 1; i <= nums.len; ++i)
				if(istext(nums[i]))
					nums[i] = text2num(nums[i])
					if(!nums[i]) nums[i] = 0

			//var/hash=md5("[nums[28]]["squad_delete"][nums[15]+nums[16]+nums[17]+nums[18]]["faction_info"][nums[29]]["get_chars"][nums[20]]["check_name"][nums[19]]")
			//if(strg[10] != hash)
			//	src << "Character verification failed."
			//	del(src)

			var/newx
			var/newy
			var/newz

			newx=nums[32]
			newy=nums[33]
			newz=nums[34]

			var/mob/human/player/x=new/mob/human/player(locate(newx,newy,newz))
			if(x && x.loc && x.loc.loc) x.loc.loc.Entered(x)

			x.name=""

			var/list/itemlist
			var/list/puppetsave1
			var/list/puppetsave2
			var/list/puppetsave3

			x.ezing=nums[1]
			x.MissionCool=nums[2]
			//x.survivalistcool=nums[3]
			x.votecool=nums[4]
			x.votecool2=nums[5]
			x.factionpoints=nums[6]
			x.overband=nums[7]
			x.Rank_D=nums[8]
			x.Rank_C=nums[9]
			x.Rank_B=nums[10]
			x.Rank_A=nums[11]
			x.Rank_S=nums[12]
			x.bounty=nums[13]
			x.hair_type=nums[14]
			x.con=nums[15]
			x.str=nums[16]
			x.int=nums[17]
			x.rfx=nums[18]
			x.skillpoints=nums[19]
			x.levelpoints=nums[20]
			x.money=nums[21]
			x.stamina=nums[22]
			x.curstamina=nums[23]
			x.chakra=nums[24]
			x.curchakra=nums[25]
			x.maxwound=nums[26]
			x.curwound=nums[27]
			x.body=nums[28]
			x.blevel=nums[29]
			x.ko=nums[30]
			x.supplies=nums[31]
			x.kills=nums[35]
			x.deaths=nums[36]
			x.eyecolor_red = nums[37]
			x.eyecolor_green = nums[38]
			x.eyecolor_blue = nums[39]
			x.double_xp_time = nums[40]
			x.triple_xp_time = nums[41]

			x.Last_Hosted=strg[1]
			x.lasthostile=strg[2]
			x.rank=strg[3]
			x.icon_name=strg[4]
			x.name=strg[5]
			x.realname = x.name
			x.hair_color=strg[8]
			x.clan=strg[9]
			var/faction_name = strg[6]
			var/faction/faction_ref = load_faction(faction_name)

			if(!faction_ref)
				del(x)
				src << "Load failed."

			x.faction = faction_ref
			x.mouse_over_pointer = faction_mouse[faction_ref.mouse_icon]
			faction_ref.online_members += x

			x.Refresh_Faction_Verbs()

			if(!x.loc)
				for(var/obj/Respawn_Pt/R in world)
					if((x.faction.village=="Missing"&&R.ind==0)||(x.faction.village=="Konoha"&&R.ind==1)||(x.faction.village=="Suna"&&R.ind==2)||(x.faction.village=="Kiri"&&R.ind==3))
						x.loc = R.loc
						break

			var/squad_name = strg[7]
			if(squad_name)
				var/squad/squad_ref = load_squad(squad_name)
				if(!squad_ref)
					x.squad = null
				else
					x.squad = squad_ref
					squad_ref.online_members += x
			else
				x.squad = null

			x.Refresh_Squad_Verbs()

			if(!x.name)
				x.name = "Nameless"
				del(x)
				src << "Load failed."

			x.skillspassive=dd_text2List(lst[1],"&")
			for(var/i = 1; i <= x.skillspassive.len; ++i)
				x.skillspassive[i] = text2num(x.skillspassive[i])
				if(!x.skillspassive[i]) x.skillspassive[i] = 0

			x.skillspassive.len=50

			var
				skill_info[]

			skill_info=dd_text2List(lst[2],"&")

			for(var/i = 0; i <= (skill_info.len-3);)
				var/id = text2num(skill_info[++i])
				var/cooldown = text2num(skill_info[++i])
				var/uses = text2num(skill_info[++i])
				var/skill/skill = x:AddSkill(id)
				skill.cooldown = cooldown
				skill.uses = uses

			if(!x.HasSkill(KAWARIMI))
				x.AddSkill(KAWARIMI)

			if(!x.HasSkill(WINDMILL_SHURIKEN))
				x.AddSkill(WINDMILL_SHURIKEN)

			if(!x.HasSkill(SHUNSHIN))
				x.AddSkill(SHUNSHIN)

			if(!x.HasSkill(BUNSHIN))
				x.AddSkill(BUNSHIN)

			if(!x.HasSkill(HENGE))
				x.AddSkill(HENGE)

			if(!x.HasSkill(EXPLODING_KUNAI))
				x.AddSkill(EXPLODING_KUNAI)

			if(!x.HasSkill(EXPLODING_NOTE))
				x.AddSkill(EXPLODING_NOTE)

			switch(x.clan)
				if("Sand Control")
					if(!x.HasSkill(SAND_SUMMON))
						x.AddSkill(SAND_SUMMON)
					if(!x.HasSkill(SAND_UNSUMMON))
						x.AddSkill(SAND_UNSUMMON)

			puppetsave1=dd_text2List(lst[3],"&")
			for(var/i = 1; i <= puppetsave1.len; ++i)
				puppetsave1[i] = text2num(puppetsave1[i])
				if(!puppetsave1[i]) puppetsave1[i] = 0

			puppetsave2=dd_text2List(lst[4],"&")

			puppetsave3=dd_text2List(lst[5],"&")
			for(var/i = 1; i <= puppetsave3.len; ++i)
				puppetsave3[i] = text2num(puppetsave3[i])
				if(!puppetsave3[i]) puppetsave3[i] = 0

			itemlist=inv
			for(var/i = 1; i <= itemlist.len; ++i)
				itemlist[i] = text2num(itemlist[i])
				if(!itemlist[i]) itemlist[i] = 0

			for(var/i = 1; i <= 10; ++i)
				var/skill_id = text2num(bar[i])
				if(skill_id)
					for(var/skill/skill in x.skills)
						if(skill.id == skill_id)
							x.vars["macro[i]"] = skill
							var/skillcard/card = new /skillcard(null, skill)
							card.screen_loc = "[i+4]:16,SOUTH"
							x.player_gui += card
							screen += card

			/*for(var/list/l in list(puppetsave1,puppetsave2,puppetsave3))
				for(var/z in l)
					world.log<<"LOADED THIS FOR PUPPETS: [z]"*/

			x.elements=params2list(lst[7])
			for(var/element in x.elements)
				if(!istext(element) || element == "/list")
					x.elements -= element

			//if(x.money>100000000)
			//	x.money=0
		/*	if(x.blevel>150)
				x.blevel=1
			if(x.rfx>((x.blevel-1)*4+50))
				x.rfx=0
			if(x.str>((x.blevel-1)*4+50))
				x.str=0
			if(x.con>((x.blevel-1)*4+50))
				x.con=0
			if(x.int>((x.blevel-1)*4+50))
				x.int=0
			if((x.rfx + x.int + x.con + x.rfx) > (200 + 6*(x.blevel-1)))
				x.rfx = 0
				x.str = 0
				x.con = 0
				x.int = 0*/
			if(x.maxwound>200)
				x.maxwound=100
			if(x.skillpoints > (x.blevel * (165 + 4.5 * x.int)))
				x.skillpoints = 0

			x.Puppets.len=2

			if(puppetsave1)
				var/i2=length(puppetsave1)
				if(i2>100)
					i2=100
				while(i2>0)
					if(!(puppetsave1.len>=i2) ||!(puppetsave2.len>=i2)||!(puppetsave3.len>=i2))
						break
					var/otype = index2type(puppetsave1[i2])
					var/oname = dd_replacetext(puppetsave2[i2], "+", " ")
					var/ostatus= puppetsave3[i2]
					if(otype)
						var/obj/items/o = new otype(x)
						o.name = "[oname]"
						//world.log<<"OSTATUS FOR [oname] IS: [ostatus]"
						if(ostatus == 1)
							o.overlays += 'icons/Equipped1.dmi'
							if(!ispath(otype, /obj/items/Puppet/weapon))
								x.Puppets[1] = o
							else
								o.setup_puppet = 1
						else if(ostatus == 2)
							o.overlays += 'icons/Equipped2.dmi'
							if(!ispath(otype, /obj/items/Puppet/weapon))
								x.Puppets[2] = o
							else
								o.setup_puppet = 2
						/*if(ostatus==1)
							x.Puppets[1]=o
							o.overlays+='icons/Equipped1.dmi'
						if(ostatus==2)
							x.Puppets[2]=o
							o.overlays+='icons/Equipped2.dmi'*/
					i2--

		//ets

				for(var/obj/items/Puppet/weapon/w in x.contents)
					if(w.setup_puppet && x.Puppets[w.setup_puppet])
						w.install = w.setup_puppet//x.Puppets[w.setup_puppet]
						w.equipped = w.setup_puppet
						w.setup_puppet = null

			var/list/L=list(0,0,0,0,0)
			for(var/i = 0; i <= (itemlist.len-2);)
				var/id = itemlist[++i]
				var/equipped = itemlist[++i]
				var/type = index2type(id)

				if(type==/obj/items/weapons/projectile/Kunai_p)
					L[1]=1
				if(type==/obj/items/weapons/projectile/Needles_p)
					L[2]=1
				if(type==/obj/items/weapons/projectile/Shuriken_p)
					L[3]=1
				if(type==/obj/items/weapons/melee/knife/Kunai_Melee)
					L[4]=1
				if(type==/obj/items/equipable/Kunai_Holster)
					L[5]=1
				if(type!=null && ispath(type,/obj/items))
					var/obj/items/o = new type(x)
					if(equipped && !istype(o,/obj/items/usable) && !istype(o,/obj/items/Puppet/weapon))
						o:Use(x)
					else if(istype(o,/obj/items/usable))
						o.equipped=equipped
						if(o) new/Event(10, "refresh_item_count", list(o, x))//o:Refreshcountdd(src.mob)
					else if(istype(o,/obj/items/Puppet/weapon))
						if(equipped)
							o.equipped=equipped
							if(i==1)
								o.overlays+='icons/Equipped1.dmi'
							if(i==2)
								o.overlays+='icons/Equipped2.dmi'
					else
						o.equipped=0

			if(!L[1])
				new/obj/items/weapons/projectile/Kunai_p(x)
			if(!L[2])
				new/obj/items/weapons/projectile/Needles_p(x)
			if(!L[3])
				new/obj/items/weapons/projectile/Shuriken_p(x)
			if(!L[4])
				new/obj/items/weapons/melee/knife/Kunai_Melee(x)
			if(!L[5])
				new/obj/items/equipable/Kunai_Holster(x)

			if(x.rank != "Academy Student" && x.rank != "Genin" && x.faction && x.faction.chuunin_item)
				var/chuunin_type = index2type(x.faction.chuunin_item)
				var/has_chuunin = locate(chuunin_type) in x
				if(!has_chuunin) new chuunin_type(x)

			for(var/skill/skill in x.skills)
				if(skill.cooldown) skill.DoCooldown(x, 1)

			x.macro_set = params2list(lst[6])
			// winset uses params form, so just pass that through to restore macros
			if(x.macro_set.len)
				winset(src, null, lst[6])

			x.initialized = 1
			src.mob=x
			src.mob << "You are flagged and must <a href = ?action=remove-ez-flag>remove</a> it if you want to gain experience."
			src.mob.set_ez_flag()
			x.RefreshSkillList()

obj
	cEnter
		Click()
			if(istype(usr,/mob/charactermenu))
				if(!EN[10])
					return

				usr:hasspaced = 1

				if(!usr.checkservs)
					usr.CheckServers()
				//usr.loc = locate_tag("maptag_select")
mob
	human
		preview
			var
				addy=0

/*
client
	proc
		LoadMobpreview(char_ckey)
			var/mob/human/preview/x=new/mob/human/preview()
			x.addy=char_ckey
			x.icon='underpreview.dmi'
			if(!EN[3])
				return x
			if(src.SF==1)
				src.SF=new/savefile()
			var/savefile/F = src.SF

			F.cd = "/[ckey]/[char_ckey]/"


			x.name=""
			F["name"]>>x.name

			F["PREV"]>>x.icon
			if(!x.icon)x.icon='underpreview.dmi'

			F=null

			return x
*/

mob/charactermenu
	var
		hasspaced = 0
	Logout()
		del(src)
	Login()
		tag = ckey
		if(RP)
			for(var/mob/human/player/X in world)
				if(X.client && X.client.address && X.client.address==src.client.address)
					src<<"You cannot multikey on a RP Server."
					del(src)
			src<<"Please be advised that this is a Roleplay/Hardcore Server. You cannot train here, your character will NOT SAVE and death is permanent until the server reboots."

		if(!src.client)
			return

		if(src.client) src.client.ClientInitiate()

		name = "[key] (Character Menu)"
		hasspaced = 0
		//client.view = 8
		canmove = 0
		loc = locate_tag("maptag_title")
		..()

client/var/list/chars

client/New()
	set waitfor = 0
	..()
	sleep(10)
	while(!leaf_faction || !missing_faction || !mist_faction || !sand_faction) sleep(10)
	src<<"Getting Character List.."
	src.chars=saves.GetCharacterNames(ckey)//params2list(SendInterserverMessage("get_chars", list("key" = ckey)))
	src<<"Retrieved Character List!"

mob
	proc
		ChooseCharacter()
			//for(var/c in client.chars)
			//	world << "MY CHARACTERS: [c]"
			if(src.client&&src.client.chars)
				var/list/characters = src.client.chars

				var/list/menu = new()
				menu += characters
				if(length(menu))
					menu += "Cancel"
					var/pickd=input2(src,"Load a Character","Load",menu)
					if(pickd=="Cancel")
						return
					src<<"Grabbing Character ([pickd]).."
					var/list/Char=saves.GetCharacter(pickd, ckey)
					if(Char)src<<"[pickd] Loaded!"
					if(src.client)src.client.LoadMob(Char)

mob/proc
	Input_or_Fail(list/X,mob/U)
		if(U.client)
			var/res= input2(U.client,"Delete character", "DELETE", X)

			return res
		else
			return 0

mob
	proc
		DeleteCharacter()
			if(src.client)
				alert(src,"WARNING: Your about to select a character to delete.")

				if(src&& src.client && src.client.chars)
					var/list/characters =src.client.chars

					var/CancelCharacterDeletion = "Cancel"
					var/list/menu = new()
					menu += CancelCharacterDeletion
					menu += characters

					var/result
					result=Input_or_Fail(menu,src)

					if(result && result != "Cancel")
						if(src.client)
							var/areyousure = input(src, "Are you sure you would like to delete [result]? By typing this character's name, you will confirm this deletion. This cannot be undone. Note that this is case sensitive. Type anything else to cancel.", "")
							if(areyousure == result)
								if(saves.DeleteCharacter(result, key))
									src.client.chars-=result
									src << "[result] has been deleted"
								else
									src << "Character deletion failed."
							else
								src << "Character deletion has been canceled."
						else
							src << "Character deletion has been canceled."

obj
	hair_creation
		hair1
			Click()
				usr.hair_type=1
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair2
			Click()
				usr.hair_type=2
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair3
			Click()
				usr.hair_type=3
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair4
			Click()
				usr.hair_type=4
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair5
			Click()
				usr.hair_type=5
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair6
			Click()
				usr.hair_type=6
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair7
			Click()
				usr.hair_type=7
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair8
			Click()
				usr.hair_type=8
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair9
			Click()
				usr.hair_type=9
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair10
			Click()
				usr.hair_type=10
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair11
			Click()
				usr.hair_type=11
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair12
			Click()
				usr.hair_type=12
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair13
			Click()
				usr.hair_type=13
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()
		hair0
			Click()
				usr.hair_type=0
				usr.completeLoad_Overlays()
				if(usr) usr.Refresh_example()

	bases
		base3
			Click()
				if(!usr.initialized)//change later
					usr.icon_name="base_m3"
					usr.Affirm_Icon()
					if(usr) usr.Refresh_example()

				else
					usr<<"You can only modify this at initial character creation."
		base2
			Click()
				if(!usr.initialized)
					usr.icon_name="base_m2"
					usr.Affirm_Icon()
					if(usr) usr.Refresh_example()
				else
					usr<<"You can only modify this at initial character creation."
		base1
			Click()
				if(!usr.initialized)
					usr.icon_name="base_m1"
					usr.Affirm_Icon()
					if(usr) usr.Refresh_example()
				else
					usr<<"You can only modify this at initial character creation."

	haircolor
		var
			r=0
			g=0
			b=0
		haircolor1
			r=0
			g=0
			b=0
		haircolor2
			r=194
			g=194
			b=194
		haircolor3
			r=236
			g=236
			b=236
		haircolor4
			r=61
			g=39
			b=0
		haircolor5
			r=90
			g=57
			b=0
		haircolor6
			r=121
			g=78
			b=3
		haircolor7
			r=171
			g=129
			b=1
		haircolor8
			r=212
			g=161
			b=6
		haircolor9
			r=221
			g=188
			b=8
		haircolor10
			r=239
			g=208
			b=0
		haircolor11
			r=144
			g=71
			b=12
		haircolor12
			r=201
			g=92
			b=4
		haircolor13
			r=201
			g=64
			b=4
		haircolor14
			r=148
			g=49
			b=6
		haircolor15
			r=81
			g=25
			b=1
		haircolor16
			r=248
			g=141
			b=3
		haircolor17
			r=247
			g=228
			b=122
		haircolor18
			r=4
			g=99
			b=153
		haircolor19
			r=180
			g=78
			b=238
		haircolor20
			r=4
			g=204
			b=140
		haircolor21
			r=253
			g=135
			b=179
		Click()
			..()
			var/mod=0.8
			if(usr.hair_type==3)
				mod=0.5
			if(usr.hair_type==4||usr.hair_type==1||usr.hair_type==5||usr.hair_type==6||usr.hair_type==7||usr.hair_type==8||usr.hair_type==9||usr.hair_type==10)
				mod=0.65

			var
				hair_r=limit(0, round(src.r*mod), 255)
				hair_b=limit(0, round(src.b*mod), 255)
				hair_g=limit(0, round(src.g*mod), 255)
			usr.hair_color = rgb(hair_r, hair_g, hair_b)
			usr.completeLoad_Overlays()
			if(usr) usr.Refresh_example()
		haircolor_rgb
			Click()
				var
					hair_color = input(usr, "What color do you want your hair to be?") as color
				if(usr)
					usr.hair_color = hair_color
					usr.completeLoad_Overlays()
					if(usr) usr.Refresh_example()

obj
	dirarrows
		right
			Click()
				usr.dir=EAST
				usr.Refresh_example()
		left
			Click()
				usr.dir=WEST
				usr.Refresh_example()
		up
			Click()
				usr.dir=NORTH
				usr.Refresh_example()
		down
			Click()
				usr.dir=SOUTH
				usr.Refresh_example()

mob
	var/eyecolor_red = 0
	var/eyecolor_green = 0
	var/eyecolor_blue = 0

obj
	eyecolor
		var
			rx=0
			grx=0
			bx=0
		icon='icons/eye colors.dmi'
		eyecolor1
			rx=0
			grx=0
			bx=0
		eyecolor2
			rx=14
			grx=93
			bx=148
		eyecolor3
			rx=15
			grx=173
			bx=225
		eyecolor4
			rx=8
			grx=212
			bx=109
		eyecolor5
			rx=94
			grx=255
			bx=6
		eyecolor6
			rx=158
			grx=102
			bx=6
		eyecolor7
			rx=193
			grx=145
			bx=0
		eyecolor_rgb
			Click()
				var/r = min(255, input(usr, "How much red do you want in your eyes?") as num)
				var/g = min(255, input(usr, "How much green do you want in your eyes?") as num)
				var/b = min(255, input(usr, "How much blue do you want in your eyes?") as num)
				usr.eyecolor_red=r
				usr.eyecolor_green=g
				usr.eyecolor_blue=b
				usr.Affirm_Icon()
				usr.Load_Overlays()
				usr.Refresh_example()

		Click()
			usr.eyecolor_red = rx
			usr.eyecolor_green = grx
			usr.eyecolor_blue = bx
			usr.Affirm_Icon()
			usr.Load_Overlays()
			usr.Refresh_example()

mob
	proc
		GoCust()
			src.client.eye=locate(25,57,2)
			src.Refresh_example()

world/proc
	Name_No_Good(xname)
		var/list/upper=list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O", "P","Q","R","S","T","U","V","W","X","Y","Z")

		if(upper.Find("[copytext("[xname]",1,2)]") && length(xname)<=20 && length(xname)>=1)
			return 0
		else
			return 1

	Name_Correct(xname)
		if(xname)
			var/vname
			vname="[html_encode(xname)]"
			var/replacer="_"
			var/i=findtext(vname," ")
			while(i)
				xname=copytext(xname,1,i)+replacer+copytext(xname,i+length(" "))
				i=findtext(xname," ",i+length(replacer))
			vname=ckeyEx(vname)
			replacer=" "
			i=findtext(vname,"_")
			while(i)
				xname=copytext(xname,1,i)+replacer+copytext(xname,i+length("_"))
				i=findtext(xname,"_",i+length(replacer))
			return vname
		else
			return 0

mob
	proc
		NewCharacter()
			if(!src.client)return
			if((src.client.chars &&src.client.chars.len>3))
				alert(src,"You have more than 3 characters, please delete one before creating a new character.")
				return

			/*if(src.client)
				src.client.view=8
			else
				return*/

			var/mob/newmob = new/mob/human/player(locate_tag("maptag_creation_appearance"))
			newmob.invisibility=100
			newmob.initialized=0

			if(src.client)

				src.client.mob=newmob
				sleep(10)
				newmob.Refresh_example()
			/*
			switch(input(src,"Change Hair", "Hair",text) in list ("Spiked 1","Bald","Nevermind"))
				if("Spiked 1")
					newmob.hair_type=1
					newmob.Get_Hair_RGB()

					newmob.Load_Overlays()
				if("Bald")
					newmob.hair_type=0
					newmob.Load_Overlays()
			newmob.eye_r=input(src,"how much red do you want in your eyes?") as num
			newmob.eye_g=input(src,"how much green do you want in your eyes?") as num
			newmob.eye_b=input(src,"how much blue do you want in your eyes?") as num
			*/

	proc
		Refresh_example()
			for(var/image/o in src.screener)
				//del(o)
				o.loc = null
				screener -= o

			usr.screener+=image(usr.icon,icon_state="",loc=locate_tag("maptag_creation_preview"),layer=MOB_LAYER,dir=usr.dir)
			for(var/o in src.overlays)
				usr.screener+=image(o,loc=locate_tag("maptag_creation_preview"),layer=MOB_LAYER+1,dir=usr.dir)
			for(var/image/p in src.screener)
				usr<<p
				usr.Imgs+=p

obj
	Done
		Click()
			if(!usr.initialized)
				usr.loc=locate_tag("maptag_creation_clan")
			usr.client.eye=usr.client.mob
			usr.hidestat=0
			usr:Refresh_Stat_Screen()

obj/items/Map
	icon='icons/gui2.dmi'
	icon_state="map"
	Click()
		usr.Look_Map()

obj/items/Guide
	icon='icons/gui2.dmi'
	icon_state="guide"
	Click()
		if(usr.client)usr.client.Help()

mob
	proc
		DoneCreate()
			src.layer=MOB_LAYER
			src.invisibility=0
			//if(client) client.Help()

			loc=locate_tag("maptag_[cVillage]_start")
			if(!loc)
				return 0

			/*if(cVillage=="Leaf")
			else if(cVillage=="Sand")
				loc=locate(41,67,10)
			else if(cVillage=="Kiri")
				loc=locate(9,67,10)
			else
				return 0*/

			invisibility=0
			initialized=1

obj
	cNew
		Click()
			if(istype(usr,/mob/charactermenu))
				usr.NewCharacter()
	cDelete
		Click()
			if(istype(usr,/mob/charactermenu))
				usr.DeleteCharacter()
	cLoad
		Click()
			if(istype(usr,/mob/charactermenu))
				usr.ChooseCharacter()
	cCredits
		Click()
			if(istype(usr,/mob/charactermenu))
				usr.Credits()

	cgameQuit
		Click()
			del(usr)

var/savelead=10

client
	proc
		Saveloop()
			set waitfor = 0
			sleep(savelead*600)
			if(istype(src.mob,/mob/human/player)&&src.mob.initialized)
				SaveMob(src)
			Saveloop()

var
	list/savepriority=new
	savedelay=50
