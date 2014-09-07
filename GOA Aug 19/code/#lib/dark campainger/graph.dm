//////////////////////////////////
// GRAPH //
///////////

// A graph is a collection of nodes.
// You shouldn't ever need to create a graph manually
MapPaths/Graph
	parent_type = /datum

	var
		tmp/list/nodes = list()      // Nodes in this graph
		tmp/list/pathers = list()    // Pather mobs on this graph
		subset = 0                   // Which node subset this graph belongs to

		minX;maxX                    // A min-max box that encompasses all nodes
		minY;maxY
		centerX;centerY
		radiusX;radiusY
		z

		tmp/list/stackNodes = list() // Nodes to process later
		tmp/list/stackDirs = list()  // Directions to exit from for stackNodes
		tmp/stackIndex = 0           // Current position in stack
		global/const/maxRange = 127  // Max search range before giving up

	New(MapPaths/Node/node)
		MapPaths.Graphs += src
		if(!node || node.graph || !node.loc || (node.exitDir < 1 && !node.enterDir))
			// If the node is already graphed, or has an unknown exitDir, bail out
			del(src)
		else
			_tracePath(node)

	Del()
		MapPaths.Graphs -= src
		..()

	// Follow the nodes and trace out the graph's connections
	proc/_tracePath(MapPaths/Node/start)
		if(start.graph || !start.loc || (start.exitDir < 1 && !start.enterDir))
			// If the node is already graphed, or has an unknown exitDir, bail out
			return

		var
			MapPaths/Node/node       // Current source node
			turf/turf                // Current tile being searched
			direction                // Current direction of search
			directionInv             // Direction rotated 180 degrees
			limit                    // Counter to limit search range

		// Set graph's subset
		src.subset = start.subset

		// Initialize the z and min-max box to valid values
		src.z = start.z
		minX = start.x
		minY = start.y
		maxX = start.x
		maxY = start.y

		// Seed starting node to be processed
		stackNodes += start
		stackDirs += ((start.exitDir==-1) && turn(start.enterDir, 180)) || start.exitDir || start.enterDir

		// Process the nodes
		while(++stackIndex <= stackNodes.len)

			// Pull next node
			node = stackNodes[stackIndex]
			direction = stackDirs[stackIndex]

			// Associate node with this graph
			_addNode(node)

			turf = node.loc                       // Start the search at the node's location
			limit = maxRange                      // Reset the search limit
			directionInv = turn(direction, 180)   // Calculate the inverse direction

			// Scan forward until we find the next node
			var/found = FALSE
			while(--limit>0 && !found)
				turf = get_step(turf, direction)
				if(!turf) break

				// Register any mobs we find on this path
				for(var/MapPaths/Pather/pather in turf.contents)
					if((!pather.subset || pather.subset==src.subset) && !pather.pathGraph)
						pather.setPathNode(node) // Technically the prev node; we fix it at the end

				// Search for nodes that are aligned with our path
				for(var/MapPaths/Node/N in turf.contents)

					// Check if it's for our graph and if we entered it correctly
					if(N.subset == src.subset && (N.enterDir == direction || N.enterDir == 0))

						// Merge graphs that collide
						if(N.graph && N.graph != src)
							src._merge(N.graph)

						// Determine the direction of movement, based on exitDir:
						//    -1 is reverse, 0 is forward, 1+ is specific
						var/exit = ((N.exitDir==-1) && directionInv) || N.exitDir || direction

						// Check if it's already queued or processed
						var/queued = FALSE
						for(var/i = stackNodes.len to 1 step -1)
							if(stackNodes[i] == N && stackDirs[i] == exit)
								queued = TRUE
								break

						if(!queued)
							// Queue the node to be processed
							stackNodes += N // If two graphs are merged, these aren't transferred -> Double processed?
							stackDirs += exit

						// Link the nodes
						node._addNextNode(N)
						N._addPreviousNode(node)

						found = TRUE

			if(!found)
				// If we couldn't find a next node, throw an error, but continue
				spawn()
					CRASH("\[Map Paths\] Could not find next node for [node.name] ([node.type]) " \
					    + "at <[node.x],[node.y],[node.z]> in direction [_MP_DIR_TO_TEXT(direction)]")

		// Initialize pathers so that they're moving to the next node
		for(var/MapPaths/Pather/pather in pathers)
			pather.setPathNode(pather.currentNode.getNext())

		// Set min-max box center and dimensions
		centerX = 0.5*(minX + maxX)
		centerY = 0.5*(minY + maxY)
		radiusX = centerX - minX
		radiusY = centerY - minY

		// Let all other graphs be built
		sleep(0)
		// Then clear the temporary data (held on to incase of merge)
		stackNodes = null
		stackDirs = null

	proc/_addNode(MapPaths/Node/node)
		node.graph = src
		src.nodes[node] = null // Add, but don't create duplicates

		// Adjust min-max box
		if(node.x < minX) minX = node.x
		if(node.x > maxX) maxX = node.x
		if(node.y < minY) minY = node.y
		if(node.y > maxY) maxY = node.y

	proc/_merge(MapPaths/Graph/graph)
		for(var/MapPaths/Node/node in graph.nodes)
			src._addNode(node)
		for(var/MapPaths/Pather/pather in graph.pathers)
			pather.setPathGraph(src)

		if(graph.stackNodes && graph.stackNodes.len)
			// Copy over temporary stack node data
			src.stackNodes.Insert(1, graph.stackNodes)
			src.stackDirs.Insert(1, graph.stackDirs)
			src.stackIndex += graph.stackNodes.len

		del(graph)

	// Given an atom, return the node in this graph that's closest to it
	proc/getNearestNode(atom/A, maxDistance = null)

		if(A.z != z) return null

		var
			MapPaths/Node/nearest = null                  // Currently closest node
			minDist = maxDistance && maxDistance+0.1 // Current min-distance (starts just above max)

			MapPaths/Node/node
			nodeDist

		// Loop through the nearest graphs and get their nearest nodes
		for(node in nodes)
			nodeDist = max(abs(node.x - A.x), abs(node.y - A.y))

			if(!minDist || nodeDist < minDist)
				nearest = node
				minDist = nodeDist

				if(nodeDist <= 0)
					break // Can't get closer than 0!

		return nearest