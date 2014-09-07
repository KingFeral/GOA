

/*
ini_reader
	Variables
		Mode
			INIREADER_CFG - 0, This switches it to CFG (Default)
			INIREADER_INI - 1, This switches it to INI
		cLastReadLine - This is the last line that was read in the file. It is included for debugging purposes.
		list
			Config - This is the current Configuration File.
	Procedures
		New( F ) - If F is either a file, or a file name, it calls LoadConfiguration( F ). Else, it initializes Config.
		Del() - This sets Config to null.
		Trim( T ) - If T is a non-null text string, it will strip any leading or trailing spaces.
		Replace( T, What, With ) - Replaces What in T with With.
		String( Num, Char ) - Returns Num Chars.
		Escaped( T ) - Replaces \ with \\,  Carriage Return with
		CurrentScanLine() - Returns cLastReadLine
		InputConfiguration( Configuration ) - Removes in Configuration Carriage Returns and Tabs, then fills Config by calling LoadStructure.
		LoadConfiguration( Configuration ) - Loads in Configuration, then removes from the data Carriage Returns and Tabs, then fills Config by calling LoadStructure.
		LoadStructure( Number/N, data, e = 0 ) - Goes through data and sets up a Dictionary to match the configuration file exactly.
		NewConfiguration() - Resets Config and cLastReadLine
		OutputConfiguration( NewLine = CrLf, Whitespace = 1 ) - Returns OutputDictionary.
		OutputDictionary( Dictionary/Dict, Level, NewLine = CrLf, Whitespace = 1 ) - Returns the .ini format of the dictionary.
		ReadSetting( Setting, Default ) - Returns Setting in Config, or Default if it isn't found.
		RemoveSetting( Setting ) - Removes Setting in Config, if it exists.
		Root() - Returns a Deep Copy of Config.
		SaveConfiguration( FileName, NewLine = CrLf, Whitespace = 0 ) - Saves OutputDictionary's return to a file.
		WriteSetting( Setting, Val ) - Writes Val to Setting in Config, or overrides Setting with Val if it exists.
*/


#define Cr ascii2text(13)
#define Lf ascii2text(10)
#define CrLf ascii2text(13) + ascii2text(10)
#define Tab ascii2text(9)
#define islist( L ) istype( L, /list )


var
	const
		BEGINOP_INI = 91		// [
		ENDOP_INI = 93			// ]
		BEGINOP_CFG = 123		// {
		ENDOP_CFG = 125			// }

		LISTBEGIN = 60			// <
		LISTEND = 62			// >
		LISTDELIM = 44			// ,
		ASSIGNOP = 61			// =
		TERMINATEOP = 59		// ;
		STRINGOP = 34			// "
		COMMENT = "//"			//
		COMMENT_ALT = ";"		//
		BEGINCOMMENT = "/*"		//
		ENDCOMMENT = "*/"		//


		WS_SPACE = 32			// space
		WS_LINEFEED = 10		// linefeed
		WS_TAB = 9				//
		WS_RETURN = 13			//

		ESCAPESEQ = 92 			// Double Baskslash
		ES_NEWLINE = 110		// n
		ES_RETURN = 114			// r
		ES_TAB = 116			// t
		ES_QUOTE = 34			// "
		ES_BACKSLASH = 92		// Backslash

		INIREADER_CFG = 1		// Use CFG
		INIREADER_INI = 2		// Use INI

proc
	DeepCopy( list/L )
		. = new/list
		if( istype( L ) && L && L.len )
			for( var/i in L )
				if( islist( i ) )
					var/list/N = new
					N = DeepCopy( L[i] )
					.[i] = N
				else
					.[i] = L[i]
	Pos( list/L, Key = 1)
		. = 0
		if( islist( L ) )
			for( var/i in L )
				.++
				if( i == Key )
					return
		. = 0

slist
	var
		list/Item = null
	New()
		Item = new

ini_reader
	var
		Mode = INIREADER_CFG
		cLastReadLine = 0
		fspec = 0
		list
			Config = null
	New()
		..()
		NewConfiguration()
	New( F, INIMode )
		..()
		Mode = INIMode
		if( !Mode ) Mode = initial(Mode)
		if( istext( F ) && fexists( F ) )
			F = file(F)
		if( isfile( F ) )
			LoadConfiguration(F)
	Del()
		Config = null
		..()
	proc
		Trim( T )
			if( ckey(T) && istext( T ) )
				. = T
				while( text2ascii(copytext( ., 1, 2 )) <= 32 )
					. = copytext( ., 2 )
				while( text2ascii(copytext( ., length( . ))) <= 32  )
					. = copytext( ., 1, length( . ) )
		Replace( T, What, With )
			. = T
			if( istext( T ) && T && istext( What ) && istext( With )  )
				. = dd_replacetext( T, What, With )
		String( Num, Char )
			. = ""
			if( isnum(Num) && istext(Char) && Num > 0 && length(ckey(Char)))
				for( var/i = 1; i <= Num; i++ )
					. += Char
		Escaped( T )
			if( istext( T ) && ckey( T ) )
				. = Replace( T, "\\", "\\\\" )
				. = Replace( ., Lf, "\\n" )
				. = Replace( ., Cr, "\\r" )
				. = Replace( ., Tab, "\\t" )
				. = Replace( ., "\"", "\\\"" )
		CurrentScanLine()
			. = cLastReadLine
		InputConfiguration( Configuration )
			if( istext( Configuration ) && ckey( Configuration ) )
				Configuration = Replace( Configuration, ascii2text( WS_RETURN ), "" )
				Configuration = Replace( Configuration, ascii2text( WS_TAB ), "" )
				cLastReadLine = 1
				Config = LoadStructure( list(0), Configuration )
		LoadConfiguration( File )
			if( !isfile(File) && fexists( File ) )
				File = file (File)
			if( isfile( File ) )
				var
					Data
				Data = file2text( File )
				Data = Replace( Data, ascii2text( WS_RETURN ), "" )
				Data = Replace( Data, ascii2text( WS_TAB ), "" )
				cLastReadLine = 1
				Config = LoadStructure( list(0), Data )
		ListParse( list/N, data , end )
			var
				p = N[1]
				c
				ca
				sd
				nd
				np
				seq
				newval
				list/L = new
				slist/Return = new
			while( p < length(data) )
				p++
				if( p == end )
					break
				c = copytext( data, p, p + 1 )
				ca = text2ascii(c)
				if( sd )
					if( seq )
						switch( ca )
							if( ES_BACKSLASH )
								newval += "\\"
							if( ES_NEWLINE )
								newval += ascii2text(WS_LINEFEED)
							if( ES_QUOTE )
								newval += "\""
							if( ES_RETURN )
								newval += ascii2text(WS_RETURN)
							if( ES_TAB )
								newval += ascii2text(WS_TAB)
							else
								if( isnum(text2num(c)) )
									np = copytext( data, p, p + 3)
									newval += ascii2text(text2num(np))
									p += 2
								else
									newval += c
						seq = 0
					else
						if( ca == ESCAPESEQ )
							seq = 1
						else if( ca == STRINGOP )
							L += newval
							sd = 0
							newval = ""
						else if( ca == WS_LINEFEED )
							CRASH( "Invalid Assignment. Did you forget to close your list?" )
						else
							newval += c
				else if( nd )
					if( ca == WS_SPACE || ca == LISTDELIM || ca == LISTEND )
						L += text2num(newval)
						nd = 0
						newval = ""
					else
						newval += c
				else
					if( ca == STRINGOP )
						sd = 1
					else if( isnum(text2num(c)) || c == "-" || c == "." || lowertext(c) == "e" || c == "&" )
						nd = 1
						p--
					else if( ca == LISTBEGIN )
						var/list/O = list(p)
						L.len += 1
						L[L.len] = ListParse( O, data, findtext( data, ascii2text(LISTEND) , p ) +1 )
						p = O[1]
			Return.Item = L
			. = Return
			N[1] = p
		LoadStructure( list/N, data, e = 0 )
			if( istype(N) && N && istext( data ) && ckey( data ) )
				var
					p = N[1]
					c
					ca
					np
					sd
					nd
					seq
					assign
					newkey
					newval
					list/Dict = new
				while( p < length( data ) )
					p++
					if( p == e ) break
					c = copytext( data, p, p + 1 )
					ca = text2ascii(c)
					if( nd )
						if( ca == TERMINATEOP )
							Dict[Trim(newkey)] = text2num(newval)
							newkey = ""
							newval = ""
							nd = 0
							assign = 0
						else if( ca == WS_LINEFEED )
							cLastReadLine++
						else
							newval += c
					else if( sd )
						if( seq )
							switch( ca )
								if( ES_BACKSLASH )
									newval += "\\"
								if( ES_NEWLINE )
									newval += ascii2text(WS_LINEFEED)
								if( ES_QUOTE )
									newval += "\""
								if( ES_RETURN )
									newval += ascii2text(WS_RETURN)
								if( ES_TAB )
									newval += ascii2text(WS_TAB)
								else
									if( ca >= 48 && ca <= 57 )
										np = copytext( data, p, p + 3 )
										newval += ascii2text(text2num(np))
										p += 2
									else
										newval += c
							seq = 0
						else
							if( ca == ESCAPESEQ )
								seq = 1
							else if( ca == STRINGOP )
								Dict[ Trim(newkey) ] = newval
								sd = 0
								newkey = ""
								newval = ""
							else if( ca == WS_LINEFEED )
								cLastReadLine++
							else
								newval += c
					else if( assign )
						if( ca == STRINGOP )
							sd = 1
						else if( isnum(text2num(c)) || c == "-" || c == "." || lowertext(c) == "e" || c == "&" )
							nd = 1
							p--
						else if( ca == WS_LINEFEED )
							cLastReadLine++
						else if(ca == TERMINATEOP)
							assign = 0
						else if( ca == LISTBEGIN )
							var/list/O = list(p)
							Dict[Trim(newkey)] = ListParse( O, data, findtext( data, ascii2text(TERMINATEOP), p ) - 1)
							p = O[1]
							newkey = ""
						else if( ca <> WS_SPACE )
							CRASH( "Invalid Assignment. Forget an assignment operator?" )
					else
						switch( ca )
							if( BEGINOP_INI )
								continue
							if( BEGINOP_CFG )
								if( findtext( Trim(newkey), " " ) )
									CRASH( "Spaces are not allowed in key names." )
								else
									var/list/O = list(p)
									Dict[ Trim( newkey ) ] = LoadStructure( O, data )
									p = O[1]
									newkey = ""
							if( ENDOP_INI )
								if( Mode == INIREADER_INI )
									if( findtext( Trim(newkey), " ") )
										CRASH( "Spaces are not allowed in section names." )
									else
										var/list/O = list(p)
										Dict[Trim(newkey)] = LoadStructure( O, data , findtext( data, ascii2text(BEGINOP_INI), p + 1) )
										p = O[1]
										newkey = ""
										if( findtext( data, ascii2text( BEGINOP_INI ), p ) )
											p = findtext( data, ascii2text( BEGINOP_INI ), p )
										else
											break
							if( ENDOP_CFG )
								if( Mode == INIREADER_CFG )
									break
							if( ASSIGNOP )
								if( findtext( Trim( newkey ), " " ) )
									CRASH( "Spaces are not allowed in key names." )
								else
									assign = 1
							if( TERMINATEOP )
								if(newval || newkey)
									Dict[ Trim(newkey) ] = newval
									newkey = ""
									newval = ""
								else if(!newval && !newkey)
									np = findtext( data, ascii2text(WS_LINEFEED), p )
									if( np )
										cLastReadLine++
										p = np
									else
										p = length(data)
										break
							if( WS_LINEFEED )
								cLastReadLine++
								newkey += ascii2text( WS_SPACE )
							if( text2ascii(COMMENT), text2ascii(BEGINCOMMENT) )
								if( copytext( data, p, p + 2 ) == COMMENT )
									np = findtext( data, ascii2text(WS_LINEFEED), p )
									if( np )
										cLastReadLine++
										p = np
									else
										p = length(data)
										break
								else if( copytext( data, p, p + 2 ) == BEGINCOMMENT )
									np = findtext( data, ENDCOMMENT, p )
									if( np )
										var/list/L = dd_text2list( copytext( data, p, p + ( np - p ) ), ascii2text(WS_LINEFEED) )
										cLastReadLine += L.len
										p = np + 1
									else
										p = length(data)
										break
							else
								newkey += c
				. = Dict
				N[1] = p
		NewConfiguration()
			cLastReadLine = 1
			Config = new
		OutputConfiguration( NewLine = Lf, Whitespace = 1 )
			. = OutputDictionary( Config, 0, NewLine, Whitespace )
		OutputDictionary( list/Dict, Level, NewLine = Lf, Whitespace = 1 )
			var
				lt
				sp
				data
			if( istype( Dict ) && Dict )
				if( Dict.len )
					if( Whitespace )
						lt = String( Level, Tab )
						sp = " "
					for( var/i in Dict )
						if( islist(Dict[i]) )
							if( Whitespace )
								data += lt + NewLine
							if( Mode == INIREADER_INI )
								data += ascii2text(BEGINOP_INI)
								data += i
								data += ascii2text(ENDOP_INI) + NewLine
								data += OutputDictionary(Dict[i], Level, NewLine, Whitespace, i)
							else
								data += lt + i + NewLine
								data += lt + ascii2text(BEGINOP_CFG) + NewLine
								data += OutputDictionary(Dict[i], lt + 1, NewLine, Whitespace )
								data += lt + ascii2text(ENDOP_CFG) + NewLine
							if( Whitespace )
								data += NewLine
						else if( isnum(Dict[i]) )
							data += i + sp + ascii2text(ASSIGNOP) + sp + "[Dict[i]]" + ascii2text(TERMINATEOP) + NewLine
						else if( istype( Dict[i], /slist ) )
							var/slist/I = Dict[i]
							data += i + sp + ascii2text(ASSIGNOP) + sp + ascii2text(LISTBEGIN) + List2Text(I.Item) + ascii2text(LISTEND) + ascii2text(TERMINATEOP) + NewLine
						else if(i)
							data += i + sp + ascii2text(ASSIGNOP) + sp + ascii2text(STRINGOP) + Escaped( Dict[i] ) + ascii2text(STRINGOP) + ascii2text(TERMINATEOP) + NewLine
						if( Pos(Dict, i) < Dict.len )
							if( islist(Dict[i]) )
								data += NewLine
			. = data
		List2Text( list/L, Delimiter = "," )
			for( var/i = 1; i <= L.len; i++ )
				if( istype(L[i], /slist) )
					var/slist/I = L[i]
					L[i] = ascii2text(LISTBEGIN) + List2Text(I.Item,Delimiter) + ascii2text(LISTEND)
				else if( isnum( L[i] ) )
					L[i] = num2text(L[i])
				else if( istext( L[i] ) )
					L[i] = ascii2text(STRINGOP) + Escaped(L[i]) + ascii2text(STRINGOP)
			. = dd_list2text(L,Delimiter)
		ReadSetting( Setting, Default )
			if( istext( Setting ) && length( ckey( Setting ) ) && Config )
				if( Setting in Config )
					if( istype( Config[Setting], /slist ) )
						var/slist/I = Config[Setting]
						. = I.Item
					else
						. = Config[Setting]
					return
			. = Default
		RemoveSetting( Setting )
			if( istext( Setting ) && length( ckey( Setting ) ) )
				if( Setting in Config )
					Config -= Setting
		Root()
			. = DeepCopy( Config )
		SaveConfiguration( FileName, NewLine = Lf, Whitespace = 0 )
			var
				Data
			if( Mode == INIREADER_CFG )
				Data = OutputDictionary( Config, 1, NewLine, Whitespace )
			else
				Data = OutputDictionary( Config, 0, NewLine, Whitespace )
			if( fexists( FileName ) )
				fdel(FileName)
			text2file( Data, FileName )
		WriteSetting( Setting, Val )
			if( istext( Setting ) && ckey( Setting ) && !isnull(Val))
				if( Config[ Setting ] )
					if( islist(Val) )
						var/list/Dict = Val
						Config[Setting] = DeepCopy(Dict)
					else
						Config[Setting] = Val
				else
					Config[Setting] = Val
