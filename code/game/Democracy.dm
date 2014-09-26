var
	list/Mute_Elects//=new/list()
mob/proc/RankGrade2()
	switch(src.ninrank)
		if("S")
			return 5
		if("A")
			return 4
		if("B")
			return 3
		if("C")
			return 2
		if("D")
			return 1

mob
	human
		player

	vote
		verb
			Vote_Yes()
				set category= "Vote"
				if(VoteM)
					if(usr.votecool2<=0&& usr.RankGrade()>=1)
						usr.votecool2+=150
						VoteCount++

				usr.verbs-=/mob/vote/verb/Vote_No
				usr.verbs-=/mob/vote/verb/Vote_Yes
				usr.verbs-=/mob/vote/verb/Vote_What
				winset(src, "vote_verb_yes", "parent=")
				winset(src, "vote_verb_no", "parent=")
				winset(src, "vote_verb_what", "parent=")
				winset(src, "vote_menu", "parent=")

			Vote_No()
				set category = "Vote"
				if(VoteM&& usr.RankGrade()>=1)
					if(usr.votecool2<=0)
						VoteCount2++
						usr.votecool2+=150
				usr.verbs-=/mob/vote/verb/Vote_No
				usr.verbs-=/mob/vote/verb/Vote_Yes
				usr.verbs-=/mob/vote/verb/Vote_What
				winset(src, "vote_verb_yes", "parent=")
				winset(src, "vote_verb_no", "parent=")
				winset(src, "vote_verb_what", "parent=")
				winset(src, "vote_menu", "parent=")

			Vote_What()
				set category ="Vote"
				if(VoteM)
					alert(usr,"Mute [VoteM]?")
				else
					usr.verbs-=/mob/vote/verb/Vote_No
					usr.verbs-=/mob/vote/verb/Vote_Yes
					usr.verbs-=/mob/vote/verb/Vote_What
					winset(src, "vote_verb_yes", "parent=")
					winset(src, "vote_verb_no", "parent=")
					winset(src, "vote_verb_what", "parent=")
					winset(src, "vote_menu", "parent=")

world
	proc
		Vote(var/mob/p)
			if(!p) return
			var/pname=p.realname
			var/pid = p.client.computer_id
			sleep(1200)//2mins
			VoteM=0

			var/outof=0
			for(var/mob/human/player/e in world)
				if(e.client && !e.AFK)
					outof++
			if(outof>4)
				world<<"[VoteCount] of active players voted to mute [pname], [VoteCount2] voted against it. (out of [outof] active players)"
				var/no
				var/yes
				no=2*VoteCount2
				yes=VoteCount
				if(yes> no)
					var/time=0
					time=(VoteCount - VoteCount2)*3000
					if(time>36000)
						time=36000
					world<<"Mute Passed! [pname] is muted for [round(time/600)] Minutes"
					if(p)p.mute=3
					world<<"[pname] is muted"
					if(p)mutelist+=pid
					sleep(time)
					mutelist-=pid
					if(p)p.mute=0
					if(p)p<<"You are unmuted."
				else
					world<<"Mutevote Failed. [pname] is off the hook. [VoteCount]/[outof]"
					for(var/mob/human/player/x in world)
						x.votecool2=0
