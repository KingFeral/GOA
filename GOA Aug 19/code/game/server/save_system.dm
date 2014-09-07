save_system
	proc
		CreateFaction(name, leader, village, mouse_icon, chat_icon, chuunin_item, member_limit)
		DeleteFaction(name)
		ChangeFactionLeader(name, new_leader)
		ChangeFactionLimit(name, new_limit)
		ChangeFactionChuuninItem(name, new_chuunin_item)
		ChangeFactionChuuninItemColor(name, new_chuunin_item_color)
		GetFactionMemberCount(name)
		GetFactionInfo(name)
		GetLastLoginDate(ckey)
		SetLastLoginDate(ckey)