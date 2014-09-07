/////////////////////////////////
// MACROS //
////////////

#define _MP_NODE_SUBSETS(_path_,_def_,_state_) \
            _MP_NODE_SUBSETS_BUILD(_path_,_def_,_state_,Green);\
            _MP_NODE_SUBSETS_BUILD(_path_,_def_,_state_,Red);\
            _MP_NODE_SUBSETS_BUILD(_path_,_def_,_state_,Blue);\
            _MP_NODE_SUBSETS_BUILD(_path_,_def_,_state_,Yellow);\
            _MP_NODE_SUBSETS_BUILD(_path_,_def_,_state_,Purple);

#define _MP_NODE_SUBSETS_BUILD(_path_,_def_,_state_,_sub_) _sub_/_path_ {_def_;subset=#_sub_;icon_state=#_sub_+"_"+_state_}

#define MP_ADD_SUBSET(_path_,_state_) _MP_NODE_SUBSETS(_path_,parent_type=/MapPaths/Node/_base/_path_,_state_)

#define _MP_DIR_TO_PATH(_enter_,_exit_) _enter_\_\_exit_
#define _MP_DIR_TO_DEF(_enter_,_exit_) enterDir=_enter_;exitDir=_exit_;parent_type=/MapPaths/Node/_base;
#define _MP_DIR_TO_STATE(_enter_,_exit_) #_enter_+"_"+#_exit_
#define _MP_NODE_DIR(_enter_,_exit_) _MP_NODE_SUBSETS(_MP_DIR_TO_PATH(_enter_,_exit_),_MP_DIR_TO_DEF(_enter_,_exit_),_MP_DIR_TO_STATE(_enter_,_exit_))
#define _MP_GENERATE_DIRS _MP_NODE_DIR(NORTH, SOUTH);_MP_NODE_DIR(SOUTH, NORTH);_MP_NODE_DIR(EAST, WEST);_MP_NODE_DIR(WEST, EAST);\
                          _MP_NODE_DIR(SOUTH, WEST);_MP_NODE_DIR(WEST, SOUTH);_MP_NODE_DIR(NORTH, WEST);_MP_NODE_DIR(WEST, NORTH);\
                          _MP_NODE_DIR(EAST, NORTH);_MP_NODE_DIR(NORTH, EAST);_MP_NODE_DIR(EAST, SOUTH);_MP_NODE_DIR(SOUTH, EAST);\
                          _MP_NODE_DIR(SOUTH, SOUTH);_MP_NODE_DIR(NORTH, NORTH);_MP_NODE_DIR(EAST, EAST);_MP_NODE_DIR(WEST, WEST);

#define _MP_DIR_TO_TEXT(_d_) ("[((_d_)&NORTH) ? "NORTH" : ""][((_d_)&SOUTH) ? "SOUTH" : ""][((_d_)&EAST) ? "EAST" : ""][((_d_)&WEST) ? "WEST" : ""]")

#define _MP_FLOAT_TOLERANCE 0.0001


//////////////////////////////////
// UTILITY //
/////////////

// Instance for accessing library procs and vars
var/MapPaths/MapPaths = new()

// Type used as namespace to consolidate library's data
MapPaths

	// List to hold our graphs at runtime
	var/list/Graphs = list()

	proc
		// Given an atom, find and return the nearest node from any graph
		// Returns null if no node was found within the maxDistance
		getNearestGraphNode(atom/A, subset = 0, maxDistance = 32)
			var
				MapPaths/Graph/graph
				list/nearGraphs = list() // List of graphs sorted by distance from pather
				outsideIndex = 1         // Tracks starting index of graphs that pather is outside of

			// Start by creating a list of nearby graphs, sorted by distance
			graph_sort:
				for(graph in Graphs)
					if(graph.z != A.z || (subset && graph.subset != subset)) continue

					var/graphDist = max(abs(graph.centerX - A.x) - graph.radiusX, \
					                    abs(graph.centerY - A.y) - graph.radiusY)

					// Already outside max, no chance an internal node is closer
					if(graphDist > maxDistance)
						continue

					if(graphDist <= 0)
						// Special case to speed things up for graphs pather is inside of
						nearGraphs.Insert(1, graph)
						nearGraphs[graph] = 0
						outsideIndex++
					else
						for(var/index = outsideIndex to nearGraphs.len)
							var/other = nearGraphs[index]
							var/otherDist = nearGraphs[other]
							if(graphDist <= otherDist)
								// Insert before the other graph
								nearGraphs.Insert(index, graph)
								nearGraphs[graph] = graphDist
								// Continue outer loop
								continue graph_sort

						// If we reached this point, place at end
						nearGraphs += graph
						nearGraphs[graph] = graphDist

			if(!nearGraphs.len) return

			var
				MapPaths/Node/nearestNode = null // Currently closest node
				minDist = null // Current min-distance

				MapPaths/Node/node
				nodeDist

			// Loop through the nearest graphs and get their nearest nodes
			for(graph in nearGraphs)

				// If the graph itself is further away than the current nearest, we can stop (because they're sorted)
				if(nearestNode && nearGraphs[graph] >= minDist)
					break

				node = graph.getNearestNode(A, maxDistance)
				nodeDist = max(abs(node.x - A.x), abs(node.y - A.y))

				if(!nearestNode || nodeDist < minDist)
					nearestNode = node
					minDist = nodeDist

					if(nodeDist <= 0)
						break // Can't get closer than 0!

			return nearestNode

		// Given two connected nodes and an atom, returns the turf along the line
		//   between the two nodes that is closest to the atom
		getNearestSegmentPoint(atom/A, MapPaths/Node/nodeA, MapPaths/Node/nodeB)

			if(A.z != nodeA.z || nodeA.z != nodeB.z) return

			// Generalized to support non-collinear nodes
			var
				// The vector between the nodes
				ux = nodeB.x - nodeA.x
				uy = nodeB.y - nodeA.y
				length = sqrt(ux*ux + uy*uy)
				lengthInv = 1.0 / length

			// Normalize the vector
			ux*=lengthInv
			uy*=lengthInv

			var
				// The vector between nodeA and the atom
				px = A.x - nodeA.x
				py = A.y - nodeA.y
				// Length of component in direction of vector (via projection)
				t = (px*ux)+(py*uy)

			if(t <= 0) return nodeA.loc
			else if(t >= length) return nodeB.loc
			else
				return locate(nodeA.x + round(ux * t, 1), nodeA.y + round(uy * t, 1), A.z)