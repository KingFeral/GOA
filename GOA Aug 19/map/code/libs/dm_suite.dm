dmm_suite{
	/*

		dmm_suite version 1.0
			Released January 30th, 2011.

		defines the object /dmm_suite
			- Provides the proc load_map()
				- Loads the specified map file onto the specified z-level.
			- provides the proc write_map()
				- Returns a text string of the map in dmm format
					ready for output to a file.
			- provides the proc save_map()
				- Returns a .dmm file if map is saved
				- Returns FALSE if map fails to save

		The dmm_suite provides saving and loading of map files in BYOND's native DMM map
		format. It approximates the map saving and loading processes of the Dream Maker
		and Dream Seeker programs so as to allow editing, saving, and loading of maps at
		runtime.

		------------------------

		To save a map at runtime, create an instance of /dmm_suite, and then call
		write_map(), which accepts three arguments:
			- A turf representing one corner of a three dimensional grid (Required).
			- Another turf representing the other corner of the same grid (Required).
			- Any, or a combination, of several bit flags (Optional, see documentation).

		The order in which the turfs are supplied does not matter, the /dmm_writer will
		determine the grid containing both, in much the same way as DM's block() function.
		write_map() will then return a string representing the saved map in dmm format;
		this string can then be saved to a file, or used for any other purose.

		------------------------

		To load a map at runtime, create an instance of /dmm_suite, and then call load_map(),
		which accepts two arguments:
			- A .dmm file to load (Required).
			- A number representing the z-level on which to start loading the map (Optional).

		The /dmm_suite will load the map file starting on the specified z-level. If no
		z-level	was specified, world.maxz will be increased so as to fit the map. Note
		that if you wish to load a map onto a z-level that already has objects on it,
		you will have to handle the removal of those objects. Otherwise the new map will
		simply load the new objects on top of the old ones.

		Also note that all type paths specified in the .dmm file must exist in the world's
		code, and that the /dmm_reader trusts that files to be loaded are in fact valid
		.dmm files. Errors in the .dmm format will cause runtime errors.

		*/

	verb/load_map(var/dmm_file as file, var/z_offset as num){
		// dmm_file: A .dmm file to load (Required).
		// z_offset: A number representing the z-level on which to start loading the map (Optional).
		}
	verb/write_map(var/turf/t1 as turf, var/turf/t2 as turf, var/flags as num){
		// t1: A turf representing one corner of a three dimensional grid (Required).
		// t2: Another turf representing the other corner of the same grid (Required).
		// flags: Any, or a combination, of several bit flags (Optional, see documentation).
		}

	// save_map is included as a legacy proc. Use write_map instead.
	verb/save_map(var/turf/t1 as turf, var/turf/t2 as turf, var/map_name as text, var/flags as num){
		// t1: A turf representing one corner of a three dimensional grid (Required).
		// t2: Another turf representing the other corner of the same grid (Required).
		// map_name: A valid name for the map to be saved, such as "castle" (Required).
		// flags: Any, or a combination, of several bit flags (Optional, see documentation).
		}
	}
dmm_suite{
	var{
		quote = "\""
		list/letter_digits = list(
			"a","b","c","d","e",
			"f","g","h","i","j",
			"k","l","m","n","o",
			"p","q","r","s","t",
			"u","v","w","x","y",
			"z",
			"A","B","C","D","E",
			"F","G","H","I","J",
			"K","L","M","N","O",
			"P","Q","R","S","T",
			"U","V","W","X","Y",
			"Z"
			)
		}
	save_map(var/turf/t1 as turf, var/turf/t2 as turf, var/map_name as text, var/flags as num){
		//Check for illegal characters in file name... in a cheap way.
		if(!((ckeyEx(map_name)==map_name) && ckeyEx(map_name))){
			CRASH("Invalid text supplied to proc save_map, invalid characters or empty string.")
			}
		//Check for valid turfs.
		if(!isturf(t1) || !isturf(t2)){
			CRASH("Invalid arguments supplied to proc save_map, arguments were not turfs.")
			}
		var/file_text = write_map(t1,t2,flags)
		if(fexists("maps/[map_name].dmm")){
			fdel("maps/[map_name].dmm")
			}
		var/saved_map = file("maps/[map_name].dmm")
		saved_map << file_text
		return saved_map
		}
	write_map(var/turf/t1 as turf, var/turf/t2 as turf, var/flags as num){
		//Check for valid turfs.
		if(!isturf(t1) || !isturf(t2)){
			CRASH("Invalid arguments supplied to proc write_map, arguments were not turfs.")
			}
		var/turf/nw = locate(min(t1.x,t2.x),max(t1.y,t2.y),min(t1.z,t2.z))
		var/turf/se = locate(max(t1.x,t2.x),min(t1.y,t2.y),max(t1.z,t2.z))
		var/list/templates[0]
		var/template_buffer = {""}
		var/dmm_text = {""}
		for(var/pos_z=nw.z;pos_z<=se.z;pos_z++){
			for(var/pos_y=nw.y;pos_y>=se.y;pos_y--){
				for(var/pos_x=nw.x;pos_x<=se.x;pos_x++){
					var/turf/test_turf = locate(pos_x,pos_y,pos_z)
					var/test_template = make_template(test_turf, flags)
					var/template_number = templates.Find(test_template)
					if(!template_number){
						templates.Add(test_template)
						template_number = templates.len
						}
					template_buffer += "[template_number],"
					}
				template_buffer += ";"
				}
			template_buffer += "."
			}
		var/key_length = round/*floor*/(log(letter_digits.len,templates.len-1)+1)
		var/list/keys[templates.len]
		for(var/key_pos=1;key_pos<=templates.len;key_pos++){
			keys[key_pos] = get_model_key(key_pos,key_length)
			dmm_text += {""[keys[key_pos]]" = ([templates[key_pos]])\n"}
			}
		var/z_level = 0
		for(var/z_pos=1;TRUE;z_pos=findtext(template_buffer,".",z_pos)+1){
			if(z_pos>=length(template_buffer)){break}
			if(z_level){dmm_text+={"\n"}}
			dmm_text += {"\n(1,1,[++z_level]) = {"\n"}
			var/z_block = copytext(template_buffer,z_pos,findtext(template_buffer,".",z_pos))
			for(var/y_pos=1;TRUE;y_pos=findtext(z_block,";",y_pos)+1){
				if(y_pos>=length(z_block)){break}
				var/y_block = copytext(z_block,y_pos,findtext(z_block,";",y_pos))
				for(var/x_pos=1;TRUE;x_pos=findtext(y_block,",",x_pos)+1){
					if(x_pos>=length(y_block)){break}
					var/x_block = copytext(y_block,x_pos,findtext(y_block,",",x_pos))
					var/key_number = text2num(x_block)
					var/temp_key = keys[key_number]
					dmm_text += temp_key
					sleep(-1)
					}
				dmm_text += {"\n"}
				sleep(-1)
				}
			dmm_text += {"\"}"}
			sleep(-1)
			}
		return dmm_text
		}
	proc{
		make_template(var/turf/model as turf, var/flags as num){
			var/template = ""
			var/obj_template = ""
			var/mob_template = ""
			var/turf_template = ""
			if(!(flags & DMM_IGNORE_TURFS)){
				turf_template = "[model.type][check_attributes(model)],"
				} else{ turf_template = "[world.turf],"}
			var/area_template = ""
			if(!(flags & DMM_IGNORE_OBJS)){
				for(var/obj/O in model.contents){
					obj_template += "[O.type][check_attributes(O)],"
					}
				}
			for(var/mob/M in model.contents){
				if(M.client){
					if(!(flags & DMM_IGNORE_PLAYERS)){
						mob_template += "[M.type][check_attributes(M)],"
						}
					}
				else{
					if(!(flags & DMM_IGNORE_NPCS)){
						mob_template += "[M.type][check_attributes(M)],"
						}
					}
				}
			if(!(flags & DMM_IGNORE_AREAS)){
				var/area/m_area = model.loc
				area_template = "[m_area.type][check_attributes(m_area)]"
				} else{ area_template = "[world.area]"}
			template = "[obj_template][mob_template][turf_template][area_template]"
			return template
			}
		check_attributes(var/atom/A){
			var/attributes_text = {"{"}
			for(var/V in A.vars){
				sleep(-1)
				if((!issaved(A.vars[V])) || (A.vars[V]==initial(A.vars[V]))){continue}
				if(istext(A.vars[V])){
					attributes_text += {"[V] = "[A.vars[V]]""}
					}
				else if(isnum(A.vars[V])||ispath(A.vars[V])){
					attributes_text += {"[V] = [A.vars[V]]"}
					}
				else if(isicon(A.vars[V])||isfile(A.vars[V])){
					attributes_text += {"[V] = '[A.vars[V]]'"}
					}
				else{
					continue
					}
				if(attributes_text != {"{"}){
					attributes_text+={"; "}
					}
				}
			if(attributes_text=={"{"}){
				return
				}
			if(copytext(attributes_text, length(attributes_text)-1, 0) == {"; "}){
				attributes_text = copytext(attributes_text, 1, length(attributes_text)-1)
				}
			attributes_text += {"}"}
			return attributes_text
			}
		get_model_key(var/which as num, var/key_length as num){
			var/key = ""
			var/working_digit = which-1
			for(var/digit_pos=key_length;digit_pos>=1;digit_pos--){
				var/place_value = round/*floor*/(working_digit/(letter_digits.len**(digit_pos-1)))
				working_digit-=place_value*(letter_digits.len**(digit_pos-1))
				key = "[key][letter_digits[place_value+1]]"
				}
			return key
			}
		}
	}


dmm_suite{
	load_map(var/dmm_file as file, var/z_offset as num){
		if(!z_offset){
			z_offset = world.maxz+1
			}

		var/quote = ascii2text(34)
		var/tfile = file2text(dmm_file)
		var/tfile_len = length(tfile)
		var/list/grid_models[0]
		var/key_len = length(copytext(tfile,2,findtext(tfile,quote,2,0)))

		for(var/lpos=1;lpos<tfile_len;lpos=findtext(tfile,"\n",lpos,0)+1){
			var/tline = copytext(tfile,lpos,findtext(tfile,"\n",lpos,0))
			if(copytext(tline,1,2)!=quote){break}
			var/model_key = copytext(tline,2,findtext(tfile,quote,2,0))
			var/model_contents = copytext(tline,findtext(tfile,"=")+3,length(tline))
			grid_models[model_key] = model_contents
			sleep(-1)
			}

		var/zcrd=-1
		var/ycrd=0
		var/xcrd=0

		for(var/zpos=findtext(tfile,"\n(1,1,");TRUE;zpos=findtext(tfile,"\n(1,1,",zpos+1,0)){
			zcrd++
			world.maxz = max(world.maxz, zcrd+z_offset)
			ycrd=0
			var/zgrid = copytext(tfile,findtext(tfile,quote+"\n",zpos,0)+2,findtext(tfile,"\n"+quote,zpos,0)+1)
			for(var/gpos=1;gpos!=0;gpos=findtext(zgrid,"\n",gpos,0)+1){
				var/grid_line = copytext(zgrid,gpos,findtext(zgrid,"\n",gpos,0)+1)
				var/y_depth = length(zgrid)/(length(grid_line))
				if(world.maxy<y_depth){world.maxy=y_depth}
				grid_line=copytext(grid_line,1,length(grid_line))
				if(!ycrd){
					ycrd = y_depth
					}
				else{ycrd--}
				xcrd=0
				for(var/mpos=1;mpos<=length(grid_line);mpos+=key_len){
					xcrd++
					if(world.maxx<xcrd){world.maxx=xcrd}
					var/model_key = copytext(grid_line,mpos,mpos+key_len)
					parse_grid(grid_models[model_key],xcrd,ycrd,zcrd+z_offset)
					}
				if(gpos+length(grid_line)+1>length(zgrid)){break}
				sleep(-1)
				}
			if(findtext(tfile,quote+"}",zpos,0)+2==tfile_len){break}
			sleep(-1)
			}
		}
	proc{
		parse_grid(var/model as text,var/xcrd as num,var/ycrd as num,var/zcrd as num){
			/*Method parse_grid()
				- Accepts a text string containing a comma separated list of type paths of the
					same construction as those contained in a .dmm file, and instantiates them.
				*/
			var/list/text_strings[0]
			for(var/index=1;findtext(model,quote);index++){
				/*Loop: Stores quoted portions of text in text_strings, and replaces them with an
					index to that list.
					- Each iteration represents one quoted section of text.
					*/
				text_strings.len=index
				text_strings[index] = copytext(model,findtext(model,quote)+1,findtext(model,quote,findtext(model,quote)+1,0))
				model = copytext(model,1,findtext(model,quote))+"~[index]"+copytext(model,findtext(model,quote,findtext(model,quote)+1,0)+1,0)
				sleep(-1)
				}
			var/list/old_turf_underlays[0]
			var/old_turf_density
			var/old_turf_opacity
			/*The old_turf variables store information about turfs instantiated in this location/iteration.
				This is done to approximate the layered turf effect of DM's map editor.
				An image of each turf is stored in old_turf_underlays[], and is later added to the new turf's underlays.
				*/
			for(var/dpos=1;dpos!=0;dpos=findtext(model,",",dpos,0)+1){
				/*Loop: Identifies each object's data, instantiates it, and reconstitues it's fields.
					- Each iteration represents one object's data, including type path and field values.
					*/
				var/full_def = copytext(model,dpos,findtext(model,",",dpos,0))
				var/atom_def = text2path(copytext(full_def,1,findtext(full_def,"{")))
				var/list/attributes[0]
				if(findtext(full_def,"{")){
					full_def = copytext(full_def,1,length(full_def))
					for(var/apos=findtext(full_def,"{")+1;apos!=0;apos=findtext(full_def,";",apos,0)+1){
						//Loop: Identifies each attribute/value pair, and stores it in attributes[].
						attributes.Add(copytext(full_def,apos,findtext(full_def,";",apos,0)))
						if(!findtext(copytext(full_def,apos,0),";")){break}
						sleep(-1)
						}
					}
				//Construct attributes associative list
				var/list/fields = new(0)
				for(var/index=1;index<=attributes.len;index++){
					var/trim_left = trim_text(copytext(attributes[index],1,findtext(attributes[index],"=")))
					var/trim_right = trim_text(copytext(attributes[index],findtext(attributes[index],"=")+1,0))
					//Check for string
					if(findtext(trim_right,"~")){
						var/reference_index = copytext(trim_right,findtext(trim_right,"~")+1,0)
						trim_right=text_strings[text2num(reference_index)]
						}
					//Check for number
					else if(isnum(text2num(trim_right))){
						trim_right = text2num(trim_right)
						}
					//Check for file
					else if(copytext(trim_right,1,2) == "'"){
						trim_right = file(copytext(trim_right,2,length(trim_right)))
						}
					fields[trim_left] = trim_right
					}
					//End construction
				//Begin Instanciation
				var/atom/instance
				var/dmm_suite/preloader/_preloader = new(fields)
				if(ispath(atom_def,/area)){
					instance = locate(atom_def)
					instance.contents.Add(locate(xcrd,ycrd,zcrd))
					}
				else if(ispath(atom_def,/turf)){
					var/turf/old_turf = locate(xcrd,ycrd,zcrd)
					if(old_turf.density){old_turf_density = 1}
					if(old_turf.opacity){old_turf_opacity = 1}
					if(old_turf.icon){
						var/image/old_turf_image = image(old_turf.icon,null,old_turf.icon_state,old_turf.layer,old_turf.dir)
						old_turf_underlays.Add(old_turf_image)
						}
					instance = new atom_def(old_turf, _preloader)
					for(var/inverse_index=old_turf_underlays.len;inverse_index;inverse_index--){
						var/image/image_underlay = old_turf_underlays[inverse_index]
						image_underlay.loc = instance
						instance.underlays.Add(image_underlay)
						}
					if(!instance.density){instance.density = old_turf_density}
					if(!instance.opacity){instance.opacity = old_turf_opacity}
					}
				else{
					instance = new atom_def(locate(xcrd,ycrd,zcrd), _preloader)
					}
				if(_preloader){
					_preloader.load(instance)
					}
					//End Instanciation
				if(!findtext(copytext(model,dpos,0),",")){break}
				sleep(-1)
				}
			}
		trim_text(var/what as text){
			while(length(what) && findtext(what," ",1,2)){
				what=copytext(what,2,0)
				}
			while(length(what) && findtext(what," ",length(what),0)){
				what=copytext(what,1,length(what))
				}
			return what
			}
		}
	}
atom/New(atom/loc, dmm_suite/preloader/_dmm_preloader){
	if(istype(_dmm_preloader, /dmm_suite/preloader)){
		_dmm_preloader.load(src)
		}
	. = ..()
	}
dmm_suite{
	preloader{
		parent_type = /datum
		var{
			list/attributes
			}
		New(list/the_attributes){
			.=..()
			if(!the_attributes.len){ Del()}
			attributes = the_attributes
			}
		proc{
			load(atom/what){
				for(var/attribute in attributes){
					what.vars[attribute] = attributes[attribute]
					}
				Del()
				}
			}
		}
	}