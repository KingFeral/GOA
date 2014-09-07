player
	var
		map_editor_client/map_editor

	verb
		Open_Editor()

			if(!map_editor)

				winset(src.client, "mapeditor", "is-visible=true")
				winset(src.client, "main", "can-close=false")
				new/map_editor_client(src, src.loc)
				map_editor_mode = 1

			else if(map_editor)

				winset(src.client, "mapeditor", "is-visible=true")
				winset(src.client, "main", "can-close=false")
				map_editor.loc = loc
				client.mob = map_editor
				map_editor_mode = 1
