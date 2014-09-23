var
	lastscroll=0
	list/tourneyentries=new
	chuuninreg=0
	chuunincount=0
	list/chuuninwinners=new
	chuuninwatch=0
	FOD = 0
	chuuninactive=0


mob
	Chuunin
		verb
			Leave_Exam()
				set category="Chuunin"
				usr.cexam=0
				for(var/obj/items/Heavenscroll/X in usr.contents)
					del(X)
				for(var/obj/items/Earthscroll/X in usr.contents)
					del(X)
				usr.loc=locate(31,74,1)
				winset(usr, "chuunin_verb_leave", "parent=")
				if(!haschuuninwatch) winset(usr, "chuunin_menu", "parent=")
				usr.verbs-=/mob/Chuunin/verb/Leave_Exam

			Join_Chuunin()
				set category="Chuunin"
				winset(usr, "chuunin_verb_join", "parent=")
				if(!haschuuninwatch) winset(usr, "chuunin_menu", "parent=")
				if(usr.shopping)
					usr.shopping=0
					usr.canmove=1
					usr.see_invisible=0
				usr.Join_Exam()
				usr.verbs-=/mob/Chuunin/verb/Join_Chuunin

			Watch_Fight_Chuunin()
				set category="Chuunin"
				var/list/li=new
				for(var/mob/human/player/x in world)
					if(x.cexam==5)
						li+=x
				var/mob/spec=input3(usr,"Who do you wish to spectate","Spectate", li)
				if(spec)
					if(spec.inarena)
						usr.spectate=1
						usr.client.eye=spec
						usr<<"<font size=+1>Spectating, Hit the Interact Button or Space to return. (Only your vision has changed, your character is still in the same spot.)</font>"




world/proc
	Auto_Chuunin()
		if(chuuninactive) return
		StartChuunin()
		//wait 5 minutes
		chuunincount=0
		chuuninreg=0//no more please
		sleep(100)
		HealChuunin()
		for(var/client/c)
			if(c.mob && c.mob.cexam == 1)
				c<<"The objective of the Forest of Death is simple. You start with either a Heaven or an Earth scroll. When a player is knocked out they will drop a scroll. Clicking scrolls pick them up, collect both scrolls and then enter the tower in the center of the forest. "
		Auto_FOD()

	Auto_FOD()
		StartFOD()
		MultiAnnounce("<span class='chuunin_exam'>{Chuunin - FOD}: Starting Forest of Death!</span>")
		sleep(100)
		var/timer=150
		FOD=1
		Auto_Tournament()
		var/fod_running = 1
		while(fod_running && timer>0)
			timer--
			var/activeH=0
			var/activeE=0
			var/activeP=0
			for(var/client/C)
				var/mob/x = C.mob
				if(x && x.cexam==2)
					++activeP
			for(var/obj/items/I in world)
				if(I.loc && I.loc.z == 5)
					if(istype(I, /obj/items/Heavenscroll))
						++activeH
					else if(istype(I, /obj/items/Earthscroll))
						++activeE
			for(var/client/C)
				if(C && C.mob)
					if(!C.mob.cexam)
						C << "<span class='chuunin_exam'>{Chuunin - FOD}: Players in forest: [activeP], Heaven Scrolls in forest: [activeH], Earth Scrolls in forest: [activeE]</span>"
					if(!(timer % 6))
						C << "<span class='chuunin_exam'>{Chuunin - FOD}: Time remaining: [timer/6] minutes</span>"
			if(activeP<2 || activeH<1 ||activeE<1)
				fod_running=0

			sleep(100)
		MultiAnnounce("<span class='chuunin_exam'>{Chuunin - FOD}: Forest of Death ended.</span>")
		//wait 20 seconds for stragglers
		sleep(200)
		EndFOD()

	Auto_Tournament()
		set waitfor = 0
		if(chuuninwatch)
			world << "{Chuunin - Tournament} Error: Multiple tournaments started"
			return
		var/num_entrants = tourneyentries.len
		while(num_entrants < 4)
			sleep(100)
			num_entrants = tourneyentries.len
		StartArena()
		MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament}: Starting round one!</span>")
		HealChuuninArena()
		var/roundon=0
		var/won_firstround[0]
		var/match_num = 0
		// First round -- run at least until the FOD is over to handle late entries
		while(FOD || tourneyentries.len >= 2)
			// Only run two-person matches while the FOD is running, a three-way shouldn't happen until the end.
			if((FOD && tourneyentries.len > 2) || (tourneyentries.len > 3 || tourneyentries.len == 2))
				var/mob/x1 = pick(tourneyentries)
				tourneyentries -= x1
				while(!x1 && tourneyentries.len)
					x1 = pick(tourneyentries)
					tourneyentries -= x1
				if(!x1) continue
				if(tourneyentries.len < 1)
					tourneyentries += x1
					continue
				var/mob/x2 = pick(tourneyentries)
				tourneyentries -= x2
				while(!x2 && tourneyentries.len)
					x2 = pick(tourneyentries)
					tourneyentries -= x2
				if(!x2)
					tourneyentries += x1
					continue

				Pick_1(x1)
				Pick_2(x2)
				Heal(x1)
				Heal(x2)
				MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 1, Match [++match_num]: [x1] VS [x2]!</span>")
				sleep(70)
				StartFight()
				roundon=1
				while(roundon)
					sleep(50)
					if(!x1 || x1.cexam != 5 || !x2 || x2.cexam != 5)
						roundon = 0

				if(x1 && x1.cexam == 5)
					won_firstround += x1
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 1, Match [match_num]: [x1] wins!</span>")
				if(x2 && x2.cexam == 5)
					won_firstround += x2
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 1, Match [match_num]: [x2] wins!</span>")

				Declare()
				sleep(20)
			else if(tourneyentries.len == 3)
				var/mob/x1 = pick(tourneyentries)
				tourneyentries -= x1
				while(!x1 && tourneyentries.len)
					x1 = pick(tourneyentries)
					tourneyentries -= x1
				if(!x1) continue
				if(tourneyentries.len < 2)
					tourneyentries += x1
					continue
				var/mob/x2 = pick(tourneyentries)
				tourneyentries -= x2
				while(!x2 && tourneyentries.len)
					x2 = pick(tourneyentries)
					tourneyentries -= x2
				if(!x2)
					tourneyentries += x1
					continue
				if(tourneyentries.len < 1)
					tourneyentries += x1
					tourneyentries += x2
					continue
				var/mob/x3 = pick(tourneyentries)
				tourneyentries -= x3
				while(!x3 && tourneyentries.len)
					x3 = pick(tourneyentries)
					tourneyentries -= x3
				if(!x3)
					tourneyentries += x1
					tourneyentries += x2
					continue

				Pick_1(x1)
				Pick_2(x2)
				Pick_3(x3)
				Heal(x1)
				Heal(x2)
				Heal(x3)
				MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 1, Match [++match_num]: [x1] VS [x2] VS [x3]!</span>")
				sleep(70)
				StartFight()
				roundon=1
				while(roundon)
					sleep(50)
					var/fighting = 0
					if(x1 && x1.cexam == 5)
						++fighting
					if(x2 && x2.cexam == 5)
						++fighting
					if(x3 && x3.cexam == 5)
						++fighting
					if(fighting < 2)
						roundon = 0

				if(x1 && x1.cexam == 5)
					won_firstround += x1
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 1, Match [match_num]: [x1] wins!</span>")
				if(x2 && x2.cexam == 5)
					won_firstround += x2
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 1, Match [match_num]: [x2] wins!</span>")
				if(x3 && x3.cexam == 5)
					won_firstround += x3
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 1, Match [match_num]: [x3] wins!</span>")

				Declare()
				sleep(20)
			else
				sleep(100)

		if(tourneyentries.len)
			for(var/mob/M in tourneyentries)
				if(M)
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament}: [M] is advanced to round two!</span>")
					won_firstround += M

		MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament}: Starting round two!</span>")

		match_num = 0

		// Second round -- runs basically like before
		while(won_firstround.len >= 2)
			if(won_firstround.len > 3 || won_firstround.len == 2)
				var/mob/x1 = pick(won_firstround)
				won_firstround -= x1
				while(!x1 && won_firstround.len)
					x1 = pick(won_firstround)
					won_firstround -= x1
				if(!x1) continue
				if(won_firstround.len < 1)
					won_firstround += x1
					continue

				var/mob/x2 = pick(won_firstround)
				won_firstround -= x2
				while(!x2 && won_firstround.len)
					x2 = pick(won_firstround)
					won_firstround -= x2
				if(!x2)
					won_firstround += x1
					continue

				Pick_1(x1)
				Pick_2(x2)
				Heal(x1)
				Heal(x2)
				MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 2, Match [++match_num]: [x1] VS [x2]!</span>")
				sleep(70)
				StartFight()
				roundon=1
				while(roundon)
					sleep(50)
					if(!x1 || x1.cexam != 5 || !x2 || x2.cexam != 5)
						roundon = 0

				if(x1 && x1.cexam == 5)
					MakeChuunin(x1)
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 2, Match [match_num]: [x1] wins!</span>")
				if(x2 && x2.cexam == 5)
					MakeChuunin(x2)
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 2, Match [match_num]: [x2] wins!</span>")

				Declare()
				sleep(20)

			else if(won_firstround.len == 3)
				var/mob/x1 = pick(won_firstround)
				won_firstround -= x1
				while(!x1 && won_firstround.len)
					x1 = pick(won_firstround)
					won_firstround -= x1
				if(!x1) continue
				if(won_firstround.len < 2)
					won_firstround += x1
					continue

				var/mob/x2 = pick(won_firstround)
				won_firstround -= x2
				while(!x2 && won_firstround.len)
					x2 = pick(won_firstround)
					won_firstround -= x2
				if(!x2)
					won_firstround += x1
					continue
				if(won_firstround.len < 1)
					won_firstround += x1
					won_firstround += x2
					continue

				var/mob/x3 = pick(won_firstround)
				won_firstround -= x3
				while(!x3 && won_firstround.len)
					x3 = pick(won_firstround)
					won_firstround -= x3
				if(!x3)
					won_firstround += x1
					won_firstround += x2
					continue

				Pick_1(x1)
				Pick_2(x2)
				Pick_3(x3)
				Heal(x1)
				Heal(x2)
				Heal(x3)
				MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 2, Match [++match_num]: [x1] VS [x2] VS [x3]!</span>")
				sleep(70)
				StartFight()
				roundon=1
				while(roundon)
					sleep(50)
					var/fighting = 0
					if(x1 && x1.cexam == 5)
						++fighting
					if(x2 && x2.cexam == 5)
						++fighting
					if(x3 && x3.cexam == 5)
						++fighting
					if(fighting < 2)
						roundon = 0

				if(x1 && x1.cexam == 5)
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 2, Match [match_num]: [x1] wins!</span>")
					MakeChuunin(x1)
				if(x2 && x2.cexam == 5)
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 2, Match [match_num]: [x2] wins!</span>")
					MakeChuunin(x2)
				if(x3 && x3.cexam == 5)
					MultiAnnounce("<span class='chuunin_exam'>{Chuunin - Tournament} Round 2, Match [match_num]: [x3] wins!</span>")
					MakeChuunin(x3)

				Declare()
				sleep(20)
		if(won_firstround.len)
			for(var/mob/M in won_firstround)
				if(M)
					MakeChuunin(M)
		MultiAnnounce("<span class='chuunin_exam'>Congratulations to the winner(s) of the Chuunin Exam!</span>")
		sleep(20)
		HealChuunin()
		chuunincount=0
		chuuninreg=0
		chuuninwatch=0
		lastscroll=0
		chuuninactive=0
		tourneyentries=new/list()
		for(var/mob/human/player/X in world)
			if(X.cexam)
				X.cexam=0
				X.inarena=0
				X.frozen=0
				var/obj/Re=0
				for(var/obj/Respawn_Pt/R in world)
					if(X.faction.village=="Missing"&&R.ind==0)
						Re=R
					if(X.faction.village=="Konoha"&&R.ind==1)
						Re=R
					if(X.faction.village=="Suna"&&R.ind==2)
						Re=R
					if(X.faction.village=="Kiri"&&R.ind==3)
						Re=R
				if(Re)
					X.loc=Re.loc
				X.pk=0
			sleep(-1)

		for(var/obj/items/Heavenscroll/X in world)
			del(X)
		for(var/obj/items/Earthscroll/X in world)
			del(X)
	Heal(mob/x)
		x.curstamina=x.stamina
		x.curwound=0
		x.curchakra=x.chakra
	HealChuuninArena()
		for(var/client/c)
			if(c.mob && c.mob.cexam == 3)
				c.mob.curstamina=c.mob.stamina
				c.mob.curwound=0
				c.mob.curchakra=c.mob.chakra
	HealChuunin()
		for(var/client/c)
			if(c.mob && c.mob.cexam)
				c.mob.curstamina=c.mob.stamina
				c.mob.curwound=0
				c.mob.curchakra=c.mob.chakra
	StartChuunin()
		if(chuuninactive) return
		chuuninreg=1
		chuunincount=0
		chuuninwinners=new/list()
		chuuninactive=1
		for(var/obj/items/Heavenscroll/X in world)
			del(X)
		for(var/obj/items/Earthscroll/X in world)
			del(X)
			world<<"<span class='chuunin_exam'>The Chuunin Exam has been started. If you want to join you have <em>5 minutes</em> to register! You will be healed automatically when the exam starts!</span>"
		sleep(3000)
		chuuninreg=0
		MultiAnnounce("<span class='chuunin_exam'>Chuunin Exam enlistment has ended.</span>")

	StartFOD()
		for(var/mob/human/player/x in world)
			for(var/obj/items/Heavenscroll/X in usr.contents)
				del(X)
			for(var/obj/items/Earthscroll/X in usr.contents)
				del(X)

		for(var/client/c)
			if(c.mob && c.mob.cexam)
				c.mob << "You only have 25 minutes to pass the forest of death!"
				c.mob.Forest_of_Death()

	EndFOD()
		FOD = 0

		for(var/mob/human/player/X in world)
			if(X.cexam && X.cexam < 3)
				X.cexam=0
				X.inarena=0
				X.frozen=0
				var/obj/Re=0
				for(var/obj/Respawn_Pt/R in world)
					if(X.faction.village=="Missing"&&R.ind==0)
						Re=R
					if(X.faction.village=="Konoha"&&R.ind==1)
						Re=R
					if(X.faction.village=="Suna"&&R.ind==2)
						Re=R
					if(X.faction.village=="Kiri"&&R.ind==3)
						Re=R
				if(Re)
					X.loc=Re.loc
				X.pk=0
			sleep(-1)

		for(var/obj/items/Heavenscroll/X in world)
			del(X)
		for(var/obj/items/Earthscroll/X in world)
			del(X)

	StartArena()
		chuuninwatch=1
		chuunincount=0
		chuuninreg=0

	EndChuunin()
		chuunincount=0
		chuuninreg=0
		chuuninwatch=0
		lastscroll=0
		chuuninactive=0
		tourneyentries=new/list()
		for(var/mob/human/player/X in world)
			if(X.cexam)
				X.cexam=0
				X.inarena=0
				X.frozen=0

				X.loc=locate(31,74,1)
		for(var/obj/items/Heavenscroll/X in world)
			del(X)
		for(var/obj/items/Earthscroll/X in world)
			del(X)
	Pick_1(mob/human/player/x)//in tourneyentries
		chuuninwatch=1
		if(x.client)
			x.pk=1
			var/leng=length(x.name)+1
			if(leng>20)
				leng=20
			var/oname=copytext(x.name,1,leng)
			var/turf/nturf=locate(77,59,4)

			for(var/mob/human/player/X in world)
				if(X.cexam && X.client)
					for(var/image/ex in X.client.images)
						if(ex.icon=='icons/charset.dmi')
							del(ex)

			MapText(world, "[oname]", nturf)
			//world<<"<font color=Blue size= +1>[x.realname] Has entered the Chuunin Arena!</font>"
			x.loc=locate(74,51,4)
			x.frozen=1
			x.inarena=1
			x.cexam=5

	Pick_2(mob/human/player/x)
		chuuninwatch=1
		if(x.client)
			x.pk=1
			var/leng=length(x.name)+1
			if(leng>20)
				leng=20
			var/oname=copytext(x.name,1,leng)
			var/turf/nturf=locate(77,57,4)
			var/turf/xturf=locate(78,58,4)

			MapText(world, "VS", xturf)
			MapText(world, "[oname]", nturf)
			//world<<"<font color=Blue size= +1>[x.realname] Has entered the Chuunin Arena!</font>"
			x.loc=locate(82,51,4)
			x.frozen=1
			x.inarena=1
			x.cexam=5
	Pick_3(mob/human/player/x)
		chuuninwatch=1
		if(x.client)
			x.pk=1
			//world<<"<font color=Blue size= +1>[x.realname] Has entered the Chuunin Arena! (3 way match!)</font>"
			x.loc=locate(79,49,4)
			x.frozen=1
			x.inarena=1
			x.cexam=5

	StartFight()
		set waitfor = 0
		for(var/mob/human/player/x in world)
			if(x.cexam)
				x.chuunin_exam_countdown()
				/*x<<"On Go"
				sleep(10)
				x<<"3"
				sleep(10)
				x<<"2"
				sleep(10)
				x<<"1"
				sleep(10)
				x<<"0, GO!"*/
		sleep(40)
		for(var/mob/human/player/x in world)
			if(x.inarena==1)
				x.pk=1
				x.frozen=0

	Declare()
		for(var/mob/human/player/x in world)
			if(x.cexam==5)
				//world<<"<font color=Blue size= +1>[x.realname] Has won!</font>"
				chuuninwinners+=x
				x.inarena=0
				x.curwound=0
				x.curstamina=x.stamina
				x.curchakra=x.chakra
				x.cexam=6
				x.CArena()
		chuuninwatch=0
	MakeChuunin(mob/human/player/X)
		if(X.rank=="Genin")
			MultiAnnounce("<span class='chuunin_exam'>[X.realname] has been promoted to a Chuunin!</span>")
			AwardMedal("Chuunin", X)
			X.rank="Chuunin"
			if(X.faction.chuunin_item)
				var/chuunin_type = index2type(X.faction.chuunin_item)
				new chuunin_type(X)

mob
	proc/chuunin_exam_countdown()
		set waitfor = 0
		src<<"On Go"
		sleep(10)
		src<<"3"
		sleep(10)
		src<<"2"
		sleep(10)
		src<<"1"
		sleep(10)
		src<<"0, GO!"

mob
	Admin
		verb
			AUTO_Chuunin_Start()
				set category="Chuunin"
				if(chuuninactive) return
				world<<"<span class='chuunin_exam'>[usr.realname] has decided to host a chuunin exam.</span>"
				MultiAnnounce("<span class='chuunin_exam'>[usr.realname] has decided to host a chuunin exam. (<a href='[world.url]'>Join server</a>)</span>", 0)
				world.Auto_Chuunin()

			Make_Chuunin(var/mob/human/player/X in world)
				set category="Chuunin"
				if(X.rank=="Genin")
					AwardMedal("Chuunin", X)
					MultiAnnounce("<span class='chuunin_exam'>[X.realname] has been promoted to a Chuunin!</span>")
					X.rank="Chuunin"
					if(X.faction.chuunin_item)
						var/chuunin_type = index2type(faction.chuunin_item)
						new chuunin_type(X)

			Heal_Chuunin()
				set category="Chuunin"
				for(var/mob/human/player/x in world)
					if(x.cexam)
						x.curstamina=x.stamina
						x.curwound=0
						x.curchakra=x.chakra
			Remove_Tourney_Entry(var/x in tourneyentries)
				set category="Chuunin"
				tourneyentries.Remove(x)

			Goto_Chuunin_Arena()
				set category="Chuunin"
				usr.oldx=usr.x
				usr.oldy=usr.y
				usr.oldz=usr.z
				src.cexam=1
				usr.CArena()
			Goto_Forest_of_Death()
				set category="Chuunin"
				usr.oldx=usr.x
				usr.oldy=usr.y
				usr.oldz=usr.z
				src.cexam=1
				usr.Forest_of_Death()
			Goto_Chuunin_Start()
				set category="Chuunin"
				usr.oldx=usr.x
				usr.oldy=usr.y
				usr.oldz=usr.z
				src.cexam=1
				usr.loc=locate(77,7,4)
			Start_Chuunin_Exam()
				set category="Chuunin"
				if(chuuninactive) return
				chuuninreg=1
				chuunincount=0
				chuuninwinners=new/list()
				chuuninactive=1
				for(var/obj/items/Heavenscroll/X in world)
					del(X)
				for(var/obj/items/Earthscroll/X in world)
					del(X)
				world<<"<span class='chuunin_exam'>The Chuunin Exam has been started. If you want to join you have <em>5 minutes</em> to register! You will be healed automatically when the exam starts!</span>"
				MultiAnnounce("<span class='chuunin_exam'>A chuunin exam has started. (<a href='[world.url]'>Join server</a>)</span>", 0)
				sleep(6000)
				chuuninreg=0
				MultiAnnounce("<span class='chuunin_exam'>Chuunin Exam enlistment has ended.</span>")
			Start_Chuunin_Exam_2_FOD()
				set category="Chuunin"
				for(var/mob/human/player/x in world)
					if(x.cexam)
						x.Forest_of_Death()
						sleep(1)
			Start_Chuunin_Exam_3_Arena()
				set category="Chuunin"
				for(var/mob/human/player/x in world)
					for(var/obj/items/Heavenscroll/X in usr.contents)
						del(X)
					for(var/obj/items/Earthscroll/X in usr.contents)
						del(X)
				chuuninwatch=1

			End_Registration()
				set category="Chuunin"
				chuunincount=0
				chuuninreg=0
				MultiAnnounce("<span class='chuunin_exam'>Chuunin Exam enlistment has ended.</span>")
			End_Chuunin_Exam()
				set category="Chuunin"
				chuunincount=0
				chuuninreg=0
				chuuninwatch=0
				lastscroll=0
				chuuninactive=0
				MultiAnnounce("<span class='chuunin_exam'>The Chuunin Exam has ended.</span>")
				tourneyentries=new/list()
				for(var/mob/human/player/X in world)
					if(X.cexam)
						X.cexam=0
						X.inarena=0
						X.frozen=0

						var/obj/Re=0
						for(var/obj/Respawn_Pt/R in world)
							if(X.faction.village=="Missing"&&R.ind==0)
								Re=R
							if(X.faction.village=="Konoha"&&R.ind==1)
								Re=R
							if(X.faction.village=="Suna"&&R.ind==2)
								Re=R
							if(X.faction.village=="Kiri"&&R.ind==3)
								Re=R
						if(Re)
							X.loc=Re.loc
				for(var/obj/items/Heavenscroll/X in world)
					del(X)
				for(var/obj/items/Earthscroll/X in world)
					del(X)
			Clear_Board()
				set category="Chuunin"
				for(var/mob/human/player/X in world)
					if(X.cexam && X.client)
						for(var/image/ex in X.client.images)
							if(ex.icon=='icons/charset.dmi')
								del(ex)

			Pick_Combatant_Chuunin_1(mob/human/player/x in tourneyentries)
				set category="Chuunin"
				chuuninwatch=1
				if(x.client)
					x.pk=1
					var/leng=length(x.name)+1
					if(leng>20)
						leng=20
					var/oname=copytext(x.name,1,leng)
					var/turf/nturf=locate(77,59,4)

					for(var/mob/human/player/X in world)
						if(X.cexam && X.client)
							for(var/image/ex in X.client.images)
								if(ex.icon=='icons/charset.dmi')
									del(ex)

					MapText(world, "[oname]", nturf)
					world<<"<font color=Blue size= +1>[x.realname] Has entered the Chuunin Arena!</font>"
					x.loc=locate(74,51,4)
					x.frozen=1
					x.inarena=1
					x.cexam=5
			Pick_Combatant_Chuunin_2(mob/human/player/x in tourneyentries)
				set category="Chuunin"
				chuuninwatch=1
				if(x.client)
					x.pk=1
					var/leng=length(x.name)+1
					if(leng>20)
						leng=20
					var/oname=copytext(x.name,1,leng)
					var/turf/nturf=locate(77,57,4)
					var/turf/xturf=locate(78,58,4)

					MapText(world, "VS", xturf)
					MapText(world, "[oname]", nturf)
					world<<"<font color=Blue size= +1>[x.realname] Has entered the Chuunin Arena!</font>"
					x.loc=locate(82,51,4)
					x.frozen=1
					x.inarena=1
					x.cexam=5
			Start_Chuunin_Fight()
				set waitfor = 0
				set category="Chuunin"
				for(var/mob/human/player/x in world)
					if(x.cexam)
						x.chuunin_exam_countdown()
				sleep(40)
				for(var/mob/human/player/x in world)
					if(x.inarena==1)
						x.pk=1
						x.frozen=0

			Declare_Winner_Chuunin()
				set category="Chuunin"
				for(var/mob/human/player/x in world)
					if(x.cexam==5)
						world<<"<font color=Blue size= +1>[x.realname] Has won!</font>"
						chuuninwinners+=x
						x.inarena=0
						x.curwound=0
						x.curstamina=x.stamina
						x.curchakra=x.chakra
						x.cexam=6
						x.CArena()
				chuuninwatch=0

obj
	apparel2
		pixel_x=16
		pixel_y=6
		density=0
		layer=MOB_LAYER+2
		icon='icons/scenic.dmi'
		icon_state="apparel2"

turf/memberwarp
	Enter(mob/human/O)
		if(istype(O) && O.client)
			if(O.combat_flagged())
				return 0
			return TRUE
			//if(!O.client.IsByondMember())
			//	O<<"This is for BYOND Members Only!"
			//	return 0
		return ..()
	Entered(mob/human/O)
		if(istype(O) && O.client)
			for(var/turf/memberwarp/M in world)
				if(M!=src)
					if(M.loc)O.loc=locate(M.x,M.y,M.z)

obj/items
	mouse_drop_zone=1
	New()
		..()

		mouse_drag_pointer=new/icon(src.icon,src.icon_state)

/*	MouseDrop(obj/gui/over_object,src_location,over_location)
		if(istype(over_object,/obj/gui/placeholder) ||istype(over_object,/obj/gui/skillcards)||istype(over_object,/obj/items))
			if(!(istype(over_object,/obj/gui/skillcards)&&!over_object.deletable))
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
					if(src==over_object)
						return
					src.Place("[spot]")

				if(istype(over_object,/obj/gui/skillcards))over_object.loc=null*/
	Heavenscroll
		layer=MOB_LAYER+1
		icon='icons/heavenearth.dmi'
		icon_state="heaven"
		Click()
			src.Get(usr)
		verb
			Get()

				set src in oview(1)
				if(!usr.ko)
					Move(usr)
			Drop()
				src.loc=locate(usr.x,usr.y,usr.z)

	Earthscroll
		layer=MOB_LAYER+1
		icon='icons/heavenearth.dmi'
		icon_state="earth"
		Click()
			for(var/mob/x in oview(1,src))
				if(usr==x)
					src.Get(usr)

		verb
			Get()

				set src in oview(1)
				if(!usr.ko)
					Move(usr)
			Drop()
				src.loc=locate(usr.x,usr.y,usr.z)



mob
	proc
		Join_Exam()
			usr.oldx=usr.x
			usr.oldy=usr.y
			usr.oldz=usr.z
			src.loc=locate(77,7,4)
			src.cexam=1
			chuunincount++

		CArena()
			sleep(-1)
			for(var/obj/trigger/kawarimi/T in triggers)
				RemoveTrigger(T)
			var/list/Pik=new
			for(var/obj/arenaspawn/ex in world)
				var/turf/L=ex.loc
				Pik+=L
			var/turf/exe
			if(Pik)
				exe=pick(Pik)
			if(exe)
				src.loc=locate(exe.x,exe.y,exe.z)

		Forest_of_Death()
			set waitfor = 0

			sleep(-1)
			if(src.cexam==1)
				src.cexam=2
				var/list/spawnpoints=new
				for(var/obj/cexamspawn/Xx in world)
					var/turf/L=Xx.loc

					spawnpoints+=L
				var/obj/ey=pick(spawnpoints)
				src.loc=locate(ey.x,ey.y,ey.z)
				if(lastscroll==0)
					new/obj/items/Heavenscroll(src)
					lastscroll=1
				else
					new/obj/items/Earthscroll(src)
					lastscroll=0

turf
	towerdoor
		Entered(mob/human/player/O)
			if(istype(O,/mob/human/player/))
				MultiAnnounce("<span class='chuunin_exam'>[O.realname] has passed the Forest of Death.</span>")
				tourneyentries+=O
				O:cexam=3
				//O:stunned=2
				O.Timed_Stun(20)
				O:CArena()

		Enter(O)
			if(istype(O,/mob/human/player/))
				var/h=locate(/obj/items/Heavenscroll) in O
				var/e=locate(/obj/items/Earthscroll) in O

				if(e&&h)
					for(var/obj/items/Heavenscroll/X in O:contents)
						X.loc = null
					for(var/obj/items/Earthscroll/X in O:contents)
						X.loc = null
					return 1
				else
					O << "You need both the Heaven AND the Earth scroll to enter!"
					return 0
			return ..()
