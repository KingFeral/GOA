//////////////////////////////////
// NODE //
//////////

// A node is one point in the path
MapPaths/Node
	parent_type = /obj
	icon = 'path_node.dmi'
	invisibility = 101

	var
		enterDir = 0 // Direction to enter in, 0 for any
		exitDir = 0 // Direction to exit from, 0 for same as entered from, -1 for reverse as entered from
		subset = 0 // Which path subset to connect to

		tmp/MapPaths/Graph/graph
		tmp/_nextNode // Node (or list of) that follows this one
		tmp/_prevNode // Node (or list of) that precedes this one

	New()
		// Let the rest of the map finish loading
		spawn(0)
			// If it hasn't already been processed
			if(!graph && loc)
				// If the exitDir is based on the enter dir, we can't start with this node
				if(exitDir > 0 || enterDir)
					// Create a new path graph starting at this node
					new/MapPaths/Graph(src)
	proc
		_addNextNode(MapPaths/Node/node)
			if(!_nextNode)
				_nextNode = node
			else if(istype(_nextNode, /list))
				_nextNode += node
			else
				_nextNode = list(_nextNode, node)

		_addPreviousNode(MapPaths/Node/node)
			if(!_prevNode)
				_prevNode = node
			else if(istype(_prevNode, /list))
				_prevNode += node
			else
				_prevNode = list(_prevNode, node)

		_selectNode(node, cycle=0)
			if(!istype(node, /list))
				return node
			else
				var/list/L = node
				if(!L.len) return null
				else if(cycle<=0) return pick(L)
				else return L[((cycle-1) % L.len)+1] // Cycle through the possible paths in sequence

		_countNodes(node)
			if(!node)
				return 0
			if(!istype(node, /list))
				return 1
			else
				var/list/L = node
				return L.len

		_getList(node)
			if(!node)
				return list()
			if(!istype(node, /list))
				return list(node)
			else
				var/list/L = node
				return L.Copy()

		// Returns the number of nodes that could be next
		getNextCount()
			if(!graph || !_nextNode)
				return 0
			return _countNodes(_nextNode)
		getPrevCount()
			if(!graph || !_prevNode)
				return 0
			return _countNodes(_prevNode)

		// Returns a list of the next nodes (always a list, even if empty)
		getNextList()
			return _getList(_nextNode)
		getPrevList()
			return _getList(_prevNode)

		// Returns the next node. Optionally specify which index of the
		//   possible nodes to select (via modulo), otherwise it's picked
		//   at random.
		getNext(cycle=0)
			if(!graph || !_nextNode)
				return null
			return _selectNode(_nextNode, cycle)
		getPrev(cycle=0)
			if(!graph || !_prevNode)
				return null
			return _selectNode(_prevNode, cycle)

		// Using an atom's location, returns whether it is approaching
		//   the node or moving away from the it (based on the pathing order)
		isApproaching(atom/A)

			if(A.loc == loc)
				return FALSE

			var
				closestDir = null // true == approacing, false = leaving
				closestDot = null // dot-product from lowestDir

				px = src.x - A.x  // Vector from node to atom
				py = src.y - A.y
				pLengthInv = 1.0 / sqrt(px*px + py*py)

			// Normalize vector P
			px *= pLengthInv
			py *= pLengthInv

			var
				vx // Vector from node to next/prev node
				vy
				vLengthInv
				dot


			// If the vector to the atom lines up best with the vector to
			//   a next node, it's moving away from this node
			for(var/MapPaths/Node/node in getNextList())
				vx = src.x - node.x
				vy = src.y - node.y
				vLengthInv = 1.0 / sqrt(vx*vx + vy*vy)
				dot = (vx*px + vy*py) * vLengthInv

				// The greater the dot-product, the
				if(closestDot == null || dot > closestDot)
					closestDir = FALSE
					closestDot = dot
					if(dot >= 1 - _MP_FLOAT_TOLERANCE) return closestDir

			// If the vector to the atom lines up best with the vector to
			//   a prev node, it's moving towards this node
			for(var/MapPaths/Node/node in getPrevList())
				vx = src.x - node.x
				vy = src.y - node.y
				vLengthInv = 1.0 / sqrt(vx*vx + vy*vy)
				dot = (vx*px + vy*py) * vLengthInv

				if(closestDot == null || dot > closestDot)
					closestDir = TRUE
					closestDot = dot
					if(dot >= 1 - _MP_FLOAT_TOLERANCE) return closestDir

			return closestDir

		// Update the pather moving towards this node
		execute(MapPaths/Pather/M)
			return M.nodeStep(src)

	// Base path node type that all placable nodes are derived from
	_base

	// Macro to generate direction nodes for all subsets
	_MP_GENERATE_DIRS