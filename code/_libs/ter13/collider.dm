#define COLLIDE_AREAS 																1
#define COLLIDE_TURFS 																2
#define COLLIDE_OBJS  																4
#define COLLIDE_MOBS  																8
#define COLLIDE_ALL  																15
#define iscollider(x) 																istype((x),/collider)

//Collider objects just hold data for the Entry/Exit/Cross/Uncross testing.
//We shouldn't need to keep many of these around.
collider
    parent_type = /atom/movable
    density = 1
    var/tmp
        atom/movable/proxy
        collision_mask = (COLLIDE_MOBS | COLLIDE_OBJS | COLLIDE_TURFS | COLLIDE_AREAS)
        list/collisions = list()


//override the default behavior just a bit.
atom
    var/tmp
        collision_layer = 0

    Enter(atom/movable/o)
        . = ..(o)
        if(iscollider(o))
            var/collider/c = o
            if(!. && src != c.proxy && c.collision_mask & collision_layer)
                c.collisions += src
            else if(!c.collisions.len)
                . = 1

    Exit(atom/movable/o)
        . = ..(o)
        if(iscollider(o))
            var/collider/c = o
            if(!. && src != c.proxy && c.collision_mask & collision_layer)
                //debug("[c] collided with [src]!")
                c.collisions += src
            else if(!c.collisions.len)
                . = 1

area
    collision_layer = COLLIDE_AREAS

turf
   collision_layer = COLLIDE_TURFS

atom/movable
    Enter(atom/movable/o)
        return 1

    Exit(atom/movable/o)
        return 1

    Cross(atom/movable/o)
        if(iscollider(o))
            var/collider/c = o
            if(c.collision_mask & collision_layer)
                . = ..(o)
                if(!. && src != c.proxy)
                    //debug("[c] collided with [src]!")
                    c.collisions += src
            else
                . = 1
        else
            . = ..(o)

    Uncross(atom/movable/o)
        if(iscollider(o))
            var/collider/c = o
            if(c.collision_mask & collision_layer)
                . = ..(o)
                if(!. && src != c.proxy)
                    c.collisions += src
            else
                . = 1
        else
            . = ..(o)

mob
    collision_layer = COLLIDE_MOBS

obj
    collision_layer = COLLIDE_OBJS



//you should never have to think about this object again.
//we only need one. There will never be any reason to initialize another.

var/collider/__collider = new/collider()

proc
	canMove(atom/movable/ref,turf/fromturf,turf/toturf,layer)
		//__collider.proxy = ref
		__collider.collision_mask = layer
		__collider.loc = fromturf
		. = __collider.Move(toturf)
		__collider.loc = null
		//__collider.proxy = null
		__collider.collisions.Cut(1,0)

	getBlockage(atom/movable/ref,turf/fromturf,turf/toturf,layer)
		//__collider.proxy = ref
		__collider.collision_mask = layer
		__collider.loc = fromturf
		__collider.Move(toturf)
		__collider.loc = null
		//__collider.proxy = null
		. = __collider.collisions
		__collider.collisions = list()

	canStep(atom/movable/ref, /*turf/location, */var/direction, var/collision_layer)
		__collider.proxy = ref
		__collider.collision_mask = collision_layer
		__collider.loc = ref.loc
		. = step(__collider, direction)//__collider.Move(location)
		//world.log << "STEP WAS [.]!"
		__collider.loc = null
		__collider.proxy = null
		//. = __collider.collisions
		__collider.collisions = list()