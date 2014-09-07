proc/SendInterserverMessageTopic(address, action, params)
	params["action"] = action
	params["Password"] = server_password
	return world.Export("[address]?[list2params(params)]")