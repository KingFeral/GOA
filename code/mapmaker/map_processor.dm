atom
	var
		do_sides = 0
		//list/side_match_types
		side_level = 0
		north_type
		south_type
		east_type
		west_type
	proc
		Process()
			if(do_sides)
				var/adjacent_turfs[0]
				for(var/dx in x-1 to x+1)
					if(dx > 0 && dx <= world.maxx)
						adjacent_turfs += locate(dx, y, z)
				for(var/dy in y-1 to y+1)
					if(dy > 0 && dy <= world.maxy)
						adjacent_turfs += locate(x, dy, z)
				for(var/turf/T in adjacent_turfs)
					var/need_side = 1
					for(var/atom/A in T)
						if(A.side_level >= side_level)
							need_side = 0
							break
					if(T.side_level >= side_level)
						need_side = 0

					if(need_side)
						var/side_type
						switch(get_dir(src, T))
							if(NORTH)
								side_type = north_type
							if(SOUTH)
								side_type = south_type
							if(EAST)
								side_type = east_type
							if(WEST)
								side_type = west_type
						if(side_type) new side_type(T)


obj
	water
		do_sides = 1
		side_level = 8
		north_type = /obj/water_sides/wu
		south_type = /obj/water_sides/wd
		east_type = /obj/water_sides/wr
		west_type = /obj/water_sides/wl

turf
	Terrain
		LightDirt
			do_sides = 1
			side_level = 7
			north_type = /obj/sides/L/north
			south_type = /obj/sides/L/south
			east_type = /obj/sides/L/east
			west_type = /obj/sides/L/west

		Dirt
			do_sides = 1
			side_level = 5
			north_type = /obj/sides/D/north
			south_type = /obj/sides/D/south
			east_type = /obj/sides/D/east
			west_type = /obj/sides/D/west

		rockyground
			do_sides = 1
			side_level = 6
			north_type = /obj/sides/rnorth
			south_type = /obj/sides/rsouth
			east_type = /obj/sides/reast
			west_type = /obj/sides/rwest

		Grass
			do_sides = 1
			side_level = 1
			north_type = /obj/sides/gnorth
			south_type = /obj/sides/gsouth
			east_type = /obj/sides/geast
			west_type = /obj/sides/gwest

		DGrass
			do_sides = 1
			side_level = 2
			north_type = /obj/sides/dgnorth
			south_type = /obj/sides/dgsouth
			east_type = /obj/sides/dgeast
			west_type = /obj/sides/dgwest

		DDGrass
			do_sides = 1
			side_level = 3
			north_type = /obj/sides/ddgnorth
			south_type = /obj/sides/ddgsouth
			east_type = /obj/sides/ddgeast
			west_type = /obj/sides/ddgwest

		Sand
			do_sides = 1
			side_level = 4
			north_type = /obj/sides/SandNorth
			south_type = /obj/sides/SandSouth
			east_type = /obj/sides/SandEast
			west_type = /obj/sides/SandWest

obj
	treefod
		growstump
			Process()
				new/obj/treefod/a(locate(src.x-1,src.y,src.z))
				new/obj/treefod/i(locate(src.x+1,src.y,src.z))
				new/obj/treefod/b(locate(src.x-1,src.y+1,src.z))
				new/obj/treefod/f(locate(src.x,src.y+1,src.z))
				new/obj/treefod/j(locate(src.x+1,src.y+1,src.z))
				new/obj/treefod/c(locate(src.x-1,src.y+2,src.z))
				new/obj/treefod/g(locate(src.x,src.y+2,src.z))
				new/obj/treefod/k(locate(src.x+1,src.y+2,src.z))
				new/obj/treefod/d(locate(src.x-1,src.y+3,src.z))
				new/obj/treefod/h(locate(src.x,src.y+3,src.z))
				new/obj/treefod/l(locate(src.x+1,src.y+3,src.z))

	tree_big
		growstump
			Process()
				new/obj/tree_big/T0_1(locate(src.x-1,src.y,src.z))
				new/obj/tree_big/T0_2(locate(src.x+1,src.y,src.z))

				new/obj/tree_big/T1_1(locate(src.x-2,src.y+1,src.z))
				new/obj/tree_big/T1_2(locate(src.x-1,src.y+1,src.z))
				new/obj/tree_big/T1_3(locate(src.x,src.y+1,src.z))
				new/obj/tree_big/T1_4(locate(src.x+1,src.y+1,src.z))
				new/obj/tree_big/T1_5(locate(src.x+2,src.y+1,src.z))

				new/obj/tree_big/T2_1(locate(src.x-2,src.y+2,src.z))
				new/obj/tree_big/T2_2(locate(src.x-1,src.y+2,src.z))
				new/obj/tree_big/T2_3(locate(src.x,src.y+2,src.z))
				new/obj/tree_big/T2_4(locate(src.x+1,src.y+2,src.z))
				new/obj/tree_big/T2_5(locate(src.x+2,src.y+2,src.z))

				new/obj/tree_big/T3_1(locate(src.x-2,src.y+3,src.z))
				new/obj/tree_big/T3_2(locate(src.x-1,src.y+3,src.z))
				new/obj/tree_big/T3_3(locate(src.x,src.y+3,src.z))
				new/obj/tree_big/T3_4(locate(src.x+1,src.y+3,src.z))
				new/obj/tree_big/T3_5(locate(src.x+2,src.y+3,src.z))

				new/obj/tree_big/T4_1(locate(src.x-2,src.y+4,src.z))
				new/obj/tree_big/T4_2(locate(src.x-1,src.y+4,src.z))
				new/obj/tree_big/T4_3(locate(src.x,src.y+4,src.z))
				new/obj/tree_big/T4_4(locate(src.x+1,src.y+4,src.z))
				new/obj/tree_big/T4_5(locate(src.x+2,src.y+4,src.z))

				new/obj/tree_big/T5_1(locate(src.x-1,src.y+5,src.z))
				new/obj/tree_big/T5_2(locate(src.x,src.y+5,src.z))
				new/obj/tree_big/T5_3(locate(src.x+1,src.y+5,src.z))

	tree
		growstump
			Process()
				new/obj/tree/a(locate(src.x-1,src.y,src.z))
				new/obj/tree/i(locate(src.x+1,src.y,src.z))
				new/obj/tree/b(locate(src.x-1,src.y+1,src.z))
				new/obj/tree/f(locate(src.x,src.y+1,src.z))
				new/obj/tree/j(locate(src.x+1,src.y+1,src.z))
				new/obj/tree/c(locate(src.x-1,src.y+2,src.z))
				new/obj/tree/g(locate(src.x,src.y+2,src.z))
				new/obj/tree/k(locate(src.x+1,src.y+2,src.z))
				new/obj/tree/d(locate(src.x-1,src.y+3,src.z))
				new/obj/tree/h(locate(src.x,src.y+3,src.z))
				new/obj/tree/l(locate(src.x+1,src.y+3,src.z))
				new/obj/tree/e(locate(src.x,src.y,src.z))
				del(src)

	rock
		Place_Me
			Process()
				icon=null
				new/obj/rock/BR(locate(src.x,src.y,src.z))
				new/obj/rock/BL(locate(src.x,src.y,src.z))
				new/obj/rock/TR(locate(src.x,src.y+1,src.z))
				new/obj/rock/TL(locate(src.x,src.y+1,src.z))

	fence
		ftop
			New()
				if(locate(/obj/fence/fright) in locate(src.x+1,src.y,src.z))
					new/obj/fence/fbot(locate(src.x+1,src.y-1,src.z))
				if(locate(/obj/fence/fleft) in locate(src.x-1,src.y,src.z))
					new/obj/fence/fbot(locate(src.x-1,src.y-1,src.z))
		fbot
			New()
				new/obj/fence/ftop(locate(src.x,src.y+1,src.z))
		fleftb
			New()
				new/obj/fence/ftopl(locate(src.x,src.y+1,src.z))
		frightb
			New()
				new/obj/fence/ftopr(locate(src.x,src.y+1,src.z))
		fleft
			New()
				if(!locate(/obj/fence) in locate(src.x,src.y-1,src.z))
					var/turf/X = src.loc
					for(var/obj/fence/K in src.loc)
						K.loc=null
					new/obj/fence/fleftb(X)
					del(src)
				if(!locate(/obj/fence) in locate(src.x,src.y+1,src.z))
					new/obj/fence/fleftp(locate(src.x,src.y+1,src.z))
		fright
			New()
				if(!locate(/obj/fence) in locate(src.x,src.y-1,src.z))
					var/turf/X = src.loc
					for(var/obj/fence/K in src.loc)
						K.loc=null
					new/obj/fence/frightb(X)
					del(src)
				if(!locate(/obj/fence) in locate(src.x,src.y+1,src.z))
					new/obj/fence/frightp(locate(src.x,src.y+1,src.z))
		placable
			icon='icons/scenic.dmi'
			icon_state="fenceb"
			Process()
				if((locate(/obj/fence) in locate(src.x+1,src.y,src.z))&&(locate(/obj/fence) in locate(src.x-1,src.y,src.z)))
					new/obj/fence/fbot(locate(src.x,src.y,src.z))
					del(src)
				else
					spawn(10)
						if((locate(/obj/fence/fbot) in locate(src.x+1,src.y,src.z)) && !(locate(/obj/fence/fbot) in locate(src.x-1,src.y,src.z)))
							new/obj/fence/fright(locate(src.x,src.y,src.z))
							for(var/obj/fence/placable/K in src.loc)
								K.loc=null
							del(src)

						if((locate(/obj/fence/fbot) in locate(src.x-1,src.y,src.z)) && !(locate(/obj/fence/fbot) in locate(src.x+1,src.y,src.z)))
							new/obj/fence/fleft(locate(src.x,src.y,src.z))
							for(var/obj/fence/placable/K in src.loc)
								K.loc=null
							del(src)

						sleep(10)

						var/fence_helper/helper=new
						spawn(60)
							if(!helper.doin)
								var/obj/d = (locate(/obj/fence) in locate(src.x,src.y-1,src.z))
								if(d)
									var/dtype=d.type
									if(dtype==/obj/fence/ftopl||dtype==/obj/fence/fleftb)
										dtype=/obj/fence/fleft
									else if(dtype==/obj/fence/ftopr||dtype==/obj/fence/frightb)
										dtype=/obj/fence/fright
									new dtype(locate(src.x,src.y,src.z))
									for(var/obj/fence/placable/K in src.loc)
										K.loc=null
									del(src)
						spawn(70)
							if(!helper.doin)
								del(src)
						while(!helper.doin&&(locate(/obj/fence/placable) in locate(src.x,src.y+1,src.z)))
							sleep(1)
						helper.doin=1
						var/obj/u = (locate(/obj/fence) in locate(src.x,src.y+1,src.z))

						if(u)
							var/utype=u.type
							if(utype==/obj/fence/ftopl||utype==/obj/fence/fleftb)
								utype=/obj/fence/fleft
							else if(utype==/obj/fence/ftopr||utype==/obj/fence/frightb)
								utype=/obj/fence/fright
							new utype(locate(src.x,src.y,src.z))
							for(var/obj/fence/placable/K in src.loc)
								K.loc=null
							del(src)

fence_helper
	var/doin = 0