/*player
	Move(turf/loc,dirr)
		. = ..()
		//Levelwarp
		if(src.x==100 && (src.dir==EAST||src.dir==NORTHEAST||src.dir==SOUTHEAST))

			var/Map/Minfo = locate("__Map__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/y=src.y
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/Map/NM
				for(var/Map/OP in world)
					if(OP.oX==eX+1 && OP.oY==eY)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(1,y,NM.z)
					src.Get_Global_Coords()


		if(src.x==1 && (src.dir==WEST||src.dir==NORTHWEST||src.dir==SOUTHWEST))
			var/Map/Minfo = locate("__Map__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/y=src.y
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/Map/NM
				for(var/Map/OP in world)
					if(OP.oX==eX-1 && OP.oY==eY)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(100,y,NM.z)
					src.Get_Global_Coords()

		if(src.y==100 && (src.dir==NORTH||src.dir==NORTHEAST||src.dir==NORTHWEST))
			var/Map/Minfo = locate("__Map__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/x=src.x
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/Map/NM
				for(var/Map/OP in world)
					if(OP.oX==eX && OP.oY==eY+1)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(x,1,NM.z)
					src.Get_Global_Coords()

		if(src.y==1 && (src.dir==SOUTH||src.dir==SOUTHWEST||src.dir==SOUTHEAST))
			var/Map/Minfo = locate("__Map__[z]")
			if(Minfo && Minfo.CanLeave(src))
				var/x=src.x
				var/eX=Minfo.oX
				var/eY=Minfo.oY
				var/Map/NM
				for(var/Map/OP in world)
					if(OP.oX==eX && OP.oY==eY-1)
						NM=OP
						break
				if(NM && NM.CanEnter(src))
					Minfo.PlayerLeft(src)
					NM.PlayerEntered(src)
					src.loc=locate(x,100,NM.z)
					src.Get_Global_Coords()*/