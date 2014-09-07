mob
	proc/update_grids()
		if(!src.client) return

		var/grid_item = 0

/*		usr << output("Level", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[blevel]", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Level Points", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[body_level]/[Req2Level(blevel)] (Rate:[rate*lp_mult])", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Stamina", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[stamina.value]/[stamina.maximum_value] ([staminaregen>=0?"+[staminaregen]":"[staminaregen]"] regen)", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Chakra", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[chakra.value]/[chakra.maximum_value] ([chakraregen>=0?"+[chakraregen]":"[chakraregen]"] regen)", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Wounds", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[curwound]/[maxwound]", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Strength", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[round(str)] (+[strbuff] -[strneg])", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Control", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[round(con)] (+[conbuff] -[conneg])", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Reflex", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[round(rfx)] (+[rfxbuff] -[rfxneg])", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Intelligence", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[round(int)] (+[intbuff] -[intneg])", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Money", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[ryo]", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Faction Points", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[faction_points]", "detailedstatspane.grid:2,[grid_item]")
		usr << output("Weight", "detailedstatspane.grid:1,[++grid_item]")
		usr << output("[weight]", "detailedstatspane.grid:2,[grid_item]")
		if(!usr.client)return
		winset(usr, "detailedstatspane.grid", "cells=2x[grid_item]")*/