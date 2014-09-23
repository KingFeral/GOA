mob
	var/tmp/warp_warn_time = 0

turf/warp
	EpicWarp
		Enter(atom/movable/O)
			. = ..()
			if(. && istype(O,/mob/human/player))
				var/mob/human/player/M = O
				if(M.client)
					if(needgenin)
						if(M.rank == "Academy Student")
							usr<<"You need to pass your Genin exam first!!!"
							return 0
					if(needvillage && needvillage != M.faction.village)
						return 0
					if(M.combat_flagged())
						if(M.warp_warn_time < world.time - 20)
							M << "You may not retreat so soon!"
							M.warp_warn_time = world.time
						return 0

	EpicWarpi
		Enter(atom/movable/O)
			. = ..()
			if(. && ismob(O))
				var/mob/M = O
				if(M.client)
					if(needgenin)
						if(M.rank == "Academy Student")
							usr<<"You need to pass your Genin exam first!!!"
							return 0
					if(needvillage && needvillage != M.faction.village)
						return 0
					if(M.combat_flagged())
						return 0