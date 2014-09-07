squad
	var
		leader
		name
		tmp
			mob/human/player/online_members[0]
			pending_invites = 0
			lock = 0

	New(squad_name, mob/human/player/leader_mob, topic_call=0)
		. = ..()
		name = squad_name
		tag = "squad__[squad_name]"
		var/leader_string
		if(ismob(leader_mob))
			online_members += leader_mob
			leader_string = leader_mob.name
			Refresh_Display()
		else
		 leader_string = leader_mob
		leader = leader_string
		if(topic_call && squad_name)
			saves.CreateSquad(squad_name, leader_string)

	proc
		Refresh_Display()
			var/grid_item = 0
			online_members << output(name, "squad_list_grid:[++grid_item]")
			for(var/mob/M in online_members)
				if(!(M in world))
					online_members -= M
					continue
				online_members << output(M, "squad_list_grid:[++grid_item]")
			for(var/mob/M in online_members)
				if(M.client)
					winset(M, "squad_list_grid", "cells=[grid_item]")


proc
	load_squad(squad_name)
		if(!squad_name) return null
		var/squad/squad = locate("squad__[squad_name]")
		if(!squad)
			var/list/squad_info = saves.GetSquadInfo(squad_name)
			if(!squad_info || !squad_info["name"])
				return null
			squad = new /squad(squad_info["name"], squad_info["leader"], 0)
			squad.tag = "squad__[squad.name]"
		return squad

mob
	var
		tmp/squad/squad
	proc
		Refresh_Squad_Verbs()
			var/client/C = client
			if(!C && usr && usr.client)
				C = usr.client
			if(squad)
				if(C)
					winset(C, "squad_menu", "parent=menu;name=\"&Squad\"")
					if(squad.leader == name)
						winset(C, "squad_leader_menu", "parent=squad_menu;name=\"&Leader\"")
					winset(C, "squad_verb_leave", "parent=squad_menu;name=\"L&eave Squad\";command=Leave-Squad")
					winset(C, "squad_verb_create", "parent=")
					winset(C, "squad_members_menu_item", "is-disabled=false")
				verbs -= /mob/human/verb/Create_Squad
				verbs += typesof(/mob/squad_verbs/verb)
				if(squad.leader == name)
					if(C)
						winset(C, "squad_verb_invite", "parent=squad_leader_menu;name=\"&Invite\";command=Invite-to-Squad")
						winset(C, "squad_verb_kick", "parent=squad_leader_menu;name=\"&Kick\";command=Kick-from-Squad")
					verbs += typesof(/mob/squad_verbs/leader/verb)
			else
				if(C)
					winset(C, "squad_menu", "parent=menu;name=\"&Squad\"")
					winset(C, "squad_verb_create", "parent=squad_menu;name=\"&Create Squad\";command=Create-Squad")
					winset(C, "squad_leader_menu", "parent=")
					winset(C, "squad_members_menu_item", "is-disabled=true")
				verbs += /mob/human/verb/Create_Squad
				verbs -= typesof(/mob/squad_verbs/verb)
				verbs -= typesof(/mob/squad_verbs/leader/verb)

mob/human
	verb
		Create_Squad(squad_name as text)
			set desc = "(squad name) Create a new squad."
			squad_name = html_encode(squad_name)
			if(!squad_name || length(squad_name) <= 1)
				usr << "That name is too short."
				return
			if(length(squad_name) >= 50)
				usr << "That name is too long."
				return
			if(!squad)
				var/list/squad_info = saves.GetSquadInfo(squad_name)
				if(!squad_info || !squad_info["name"])
					squad = new(squad_name, src, 1)
					squad.tag = "squad__[squad.name]"
					Refresh_Squad_Verbs()
				else
					usr << "There is already a squad using that name!"
			else
				usr << "You already have a squad!"

mob/squad_verbs
	verb
		Leave_Squad()
			if(squad && !squad.lock && input2(src,"Are you sure you want to leave your squad?","Leave Squad",list("Yes","No")) == "Yes")
				squad.online_members -= src
				if(squad.leader == name)
					var/squad_name = squad.name
					spawn()
						saves.DeleteSquad(squad_name)
					del squad
				if(squad)
					squad.Refresh_Display()
				squad = null
				Refresh_Squad_Verbs()
				src << "You have left your squad."
				winset(src, "right_top_child.left", "left=skills_pane")
	leader
		verb
			Invite_to_Squad(mob/M in ohearers())
				if(squad && !squad.lock && !M.squad && M.faction && faction && M.faction.village == faction.village)
					var/max_squad = 2 + RankGrade()
					if(max_squad == 7) ++max_squad
					if((faction in list(leaf_faction,mist_faction,sand_faction)) && name == faction.leader)
						max_squad = 10
					var/squad_members = saves.GetSquadMemberCount(squad.name)
					squad_members = max(squad_members, squad.online_members.len)
					if((squad_members+squad.pending_invites) < max_squad)
						++squad.pending_invites
						var/accepted = input2(M,"Would you like to join [src]'s squad \"[squad]\"?","Squad Invite",list("Yes","No"))
						if(accepted == "Yes" && squad)
							squad_members = saves.GetSquadMemberCount(squad.name)
							squad_members = max(squad_members, squad.online_members.len)
							if(squad_members < max_squad && squad && !M.squad)
								squad.online_members += M
								M.squad = squad
								M.Refresh_Squad_Verbs()
								M.client.SaveMob()
								squad.Refresh_Display()
						if(squad) --squad.pending_invites
					else
						alert(usr, "You have already invited enough people to fill your squad.")

			Kick_from_Squad(mob/M in (squad.online_members-src))
				if(squad && !squad.lock && input2(src,"Are you sure you would like to kick [M] from your squad?","Squad Kick",list("Yes","No")) == "Yes")
					squad.online_members -= M
					M.squad = null
					M.Refresh_Squad_Verbs()
					squad.Refresh_Display()
