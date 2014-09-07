#define WORLD_ICON_SIZE 32
#define WORLD_HALF_ICON_SIZE 16
#define WORLD_ICON_MULTIPLY 0.03125 //This is  1 / WORLD_ICON_SIZE
#define WORLD_MAX_PX 3232 //This is the size of your map in tiles + 1 times world_icon_size
#define WORLD_MAX_PY 3232 //This is the size of your map in tiles + 1 times world_icon_size

projectile
	parent_type = /obj
	animate_movement = NO_STEPS
	//icon = 'media/obj/extras/projectiles.dmi'

	// Boring variable stuff we need.
	var/tmp/pool_name
	var/tmp/angle = 0
	var/tmp/px = 0 //the true pixel location of the projectile
	var/tmp/py = 0
	var/tmp/last_x = 0 //the last x/y coordinate of the tile we were in
	var/tmp/last_y = 0
	var/tmp/velocity = 12 //speed of the projectile
	var/tmp/character/owner
	var/tmp/distance = 60
	var/tmp/spread_x
	var/tmp/spread_y
	var/tmp/vx = 0 //vector px (movement increment)
	var/tmp/vy = 0 //vector py (movement increment)
	var/tmp/damage = 0
	var/tmp/wounds = 0
	var/tmp/poison = 0
	var/tmp/daze = 0
	var/tmp/knockback = 0
	var/tmp/list/passives = list(BOMBARDMENT)

	proc/set_pos_px(px, py)
		src.x = px * WORLD_ICON_MULTIPLY
		src.y = py * WORLD_ICON_MULTIPLY
		src.pixel_x = px % WORLD_ICON_SIZE - WORLD_HALF_ICON_SIZE
		src.pixel_y = py % WORLD_ICON_SIZE - WORLD_HALF_ICON_SIZE

	proc/check_bounds()
		if((src.px in WORLD_ICON_SIZE to WORLD_MAX_PX) && (src.py in WORLD_ICON_SIZE to WORLD_MAX_PY))
			return 1
		return 0

	proc/update()
		set waitfor = 0

		if(!src.loc) return

		src.px += src.vx + src.spread_x
		src.py += src.vy + src.spread_y

		if(!src.check_bounds())
			global.atom_pool.pool(src, src.pool_name)
			return 0

		src.set_pos_px(src.px, src.py)

		if(src.last_x != src.x || src.last_y != src.y)
			src.last_x = src.x
			src.last_y = src.y

			if(src.loc) src.loc:collide_here(src)

		sleep(TICK_LAG)
		if(src.loc == null)
			return

		if(distance-- > 0)
			src.update()
		else
			global.atom_pool.pool(src, src.pool_name)
			return 0

	proc/can_collide(var/atom/movable/a)
		if(isturf(a))
			if(a.density)
				return 1
		else if(isprojectile(a))
			if(a != src && a:owner != src.owner)
				return 1
		else
			if(a != src && a != src.owner)
				return 1
		return 0

	proc/collide(var/atom/a)
		set waitfor = 0

		if(hascall(a, "on_collide"))
			call(a, "on_collide")(src)

		sleep(get_speed_delay(velocity) - 1)

		global.atom_pool.pool(src, src.pool_name)

	pooled()
		src.icon = null
		src.icon_state = null
		src.dir = null
		src.owner = null
		src.velocity = initial(velocity)
		src.last_x = null
		src.last_y = null
		src.vx = 0
		src.vy = 0
		src.px = 0
		src.py = 0
		src.pixel_x = 0
		src.pixel_y = 0
		src.spread_x = 0
		src.spread_y = 0
		src.distance = initial(distance)
		src.damage = 0
		src.wounds = 0
		src.daze = 0
		src.knockback = 0
		src.poison = 0
		. = ..()

	Cross(atom/movable/a)
		if(src.can_collide(a))
			src.collide(a)
		return ..()

	proc/mod(list/modifications)
		for(var/m in modifications)
			if(m in vars)
				vars[m] = modifications[m]

	proc/initialize(var/location, var/character/user, var/list/mods)
		src.dir = user.dir

		src.mod(mods)

	/*	if(speed) src.velocity = speed
		if(spread_x) src.spread_x = spread_x
		if(spread_y) src.spread_y = spread_y
		if(stamina_dmg) src.damage = stamina_dmg
		if(wound_dmg) src.wounds = wound_dmg
		if(daze) src.daze = daze
		if(poison) src.poison = poison
		if(knockback) src.knockback = knockback
		if(distance) src.distance = distance*/


		src.owner = user
		src.loc = user.loc
		src.px = src.x * WORLD_ICON_SIZE + WORLD_HALF_ICON_SIZE
		src.py = src.y * WORLD_ICON_SIZE + WORLD_HALF_ICON_SIZE

		if(!src.check_bounds())
			global.atom_pool.pool(src, src.pool_name)
			return 0

		var/dx = 0
		var/dy = 0
		var/dr = 0

		var/character/target = user.nearest_target()
		var/atom/look_at = target ? target.loc : get_step(src, src.dir)
		if(!look_at)
			global.atom_pool.pool(src, "projectiles")
			return 0

		dx = (look_at.x * WORLD_ICON_SIZE) + WORLD_HALF_ICON_SIZE - src.px
		dy = (look_at.y * WORLD_ICON_SIZE) + WORLD_HALF_ICON_SIZE - src.py

		dr = sqrt(dx * dx + dy * dy)

		src.vx = dx / dr * src.velocity
		src.vy = dy / dr * src.velocity

		src.dir = get_dir_adv(src, look_at)

		src.update()

turf/DblClick()
	for(var/p in collidables)
		world << p

turf/proc/collide_here(var/projectile/p)
	if(p.can_collide(src))
		p.collide(src)

	if(collidables)
		for(var/atom/a in collidables)
			if(p.can_collide(a))
				p.collide(a)
				return

turf/var/tmp/list/collidables = null
turf/Entered(atom/a)
	if(a.density || isprojectile(a))
		if(!collidables) collidables = list()
		collidables += a
	. = ..()


turf/Exited(atom/a)
	. = ..()
	if(!collidables) return
	collidables -= a
	if(!collidables.len) collidables = null


atom
	proc/on_collide(var/atom/movable/collider)

character/on_collide(var/projectile/collider)
	var/stamina_dmg = collider.damage
	var/wound_dmg = collider.wounds

	if(collider.passives && collider.passives[BOMBARDMENT] && prob(4 * collider.passives[BOMBARDMENT]))
		wound_dmg += rand(1, 4)

	src.take_damage(stamina_dmg, wound_dmg, collider.owner, source = collider.name)

	if(collider.knockback)
		src.knockback(collider.knockback, collider.dir)

	if(collider.poison)
		src.poison += poison

	if(collider.daze)
		if(prob(collider.daze))
			combat_graphic("daze", src)
			src.timed_stun(30)

proc/get_speed_delay(n)
	return (world.icon_size * world.tick_lag) / (!n ? 1 : n)

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