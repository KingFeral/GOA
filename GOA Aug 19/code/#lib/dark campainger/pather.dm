

//////////////////////////////////
// PATHER //
////////////

// A pather is a mob that follows paths
MapPaths/Pather
	parent_type = /mob
	var
		subset = 0                     // Which path to connect to, 0 for any
		tmp/MapPaths/Graph/pathGraph   // Path graph currently connected to
		tmp/MapPaths/Node/currentNode  // Node currently moving towards
		tmp/MapPaths/Node/prevNode     // Previous node

	proc

		// Step the mob towards the node. Returns true if mob is at the node's loc
		nodeStep(MapPaths/Node/node)
			step_towards(src, node)

			#ifdef PIXEL_MOVEMENT
			return (bounds_dist(src, node) <= 0)
			#else
			return (src.loc == node.loc)
			#endif

		// Set the pather's current node. Updates the prevNode automatically if not specified
		setPathNode(MapPaths/Node/node, MapPaths/Node/prev)
			if(!prev && currentNode && node && currentNode.graph == node.graph)
				prevNode = currentNode
			else
				prevNode = prev

			currentNode = node
			setPathGraph(node && node.graph)

		// Set's the pather's current graph. Find nearest node if not specified
		setPathGraph(MapPaths/Graph/graph)
			if(graph != src.pathGraph)
				if(src.pathGraph) src.pathGraph.pathers -= src
				pathGraph = graph
				pathGraph.pathers[src] = null
				if(src.currentNode && src.currentNode.graph != graph)
					src.currentNode = null
				if(src.prevNode && src.prevNode.graph != graph)
					src.prevNode = null

		// Gets the node closest to the pather from its CURRENT graph
		getNearestNode(maxDistance = null)
			if(pathGraph)
				return pathGraph.getNearestNode(src, maxDistance)
			else
				return null