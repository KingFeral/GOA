proc/get_dir_adv(atom/ref, atom/target)
	//Written by Lummox JR
	//Returns the direction between two atoms more accurately than get_dir()

    if(target.z > ref.z) return UP
    if(target.z < ref.z) return DOWN

    . = get_dir(ref, target)
    if(. & . - 1)        // diagonal
        var/ax = abs(ref.x - target.x)
        var/ay = abs(ref.y - target.y)
        if(ax >= (ay << 1))      return . & (EAST | WEST)   // keep east/west (4 and 8)
        else if(ay >= (ax << 1)) return . & (NORTH | SOUTH) // keep north/south (1 and 2)