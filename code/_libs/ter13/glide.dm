#define TILE_WIDTH  																32
#define TILE_HEIGHT 																32
#define TICK_LAG    																0.25 //set to (10 / world.fps) a define is faster, though

mob/human/sandmonster/move_delay = 2

atom/movable
    var
        tmp/move_delay = 1
        tmp/last_move = -1000

    Move(atom/NewLoc,Dir=0,step_x=0,step_y=0)
        //set up glide sizes before the move
        //ensure this is a step, not a jump

        if(src.loc && get_dist(src,NewLoc)==1)
            if(last_move + move_delay > world.time)
                return 0
            . = get_dir(src,NewLoc)
            if(. & . - 1) //if a diagonal move
                src.glide_size = sqrt(TILE_WIDTH**2 + TILE_HEIGHT**2) / move_delay * TICK_LAG
                //glide value must be based on the hypotenuse
            else if(. < 4) //north or south case
                src.glide_size = TILE_HEIGHT / move_delay * TICK_LAG
                //glide value must be based on the adjacent
            else //east or west case
                src.glide_size = TILE_WIDTH / move_delay * TICK_LAG
                //glide value must be based on the opposite
            . = ..(NewLoc,Dir,step_x,step_y)
            if(.)

                last_move = world.time

            return .
        . = ..(NewLoc,Dir,step_x,step_y)