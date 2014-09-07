

var/global/atom_pool/atom_pool = new()

atom_pool
	var/tmp/list/atom_pools = list()

	proc/create_pool(var/name, var/path)
		if(!src.get_pool(name))
			src.atom_pools[name] = list()
			src.atom_pools[name] += path

		return src.atom_pools[name]

	proc/pool(var/atom/movable/atom, var/name)
		if(!src.get_pool(name))
			src.create_pool(name, atom.type)

		src.atom_pools[name] += atom

		atom.pooled()

	proc/unpool(var/name, var/path)
		var/list/instances = src.atom_pools[src.get_pool(name)]
		if(!instances)
			if(!path)
				return null

			instances = src.create_pool(name, path)

		if(instances.len == 1)
			var/i = instances[1]
			return new i

		. = instances[2]
		instances -= .
		call(., "unpooled")()

	proc/get_pool(var/name)
		if(name in src.atom_pools)
			return src.atom_pools[name]

	proc/get_instance(var/name, var/path)
		if(!src.get_pool(name))
			src.create_pool(name, path)

		//debug("CREATED INSTANCE poolname=[name];path=[path]")
		return src.unpool(name, path)

atom/movable
	proc/pooled()
		src.loc = null

	proc/unpooled()