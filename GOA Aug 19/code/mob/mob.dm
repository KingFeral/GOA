mob
	var/clan

	var/tmp/action/action
	var/tmp/action_timestamp
	var/tmp/action/last_action
	var/tmp/last_action_timestamp

	var/tmp/usemove

	// ruthless trait.
	var/tmp/adrenaline

	New()
		. = ..()
		src.initialize_stats()
		src.initialize_attributes()