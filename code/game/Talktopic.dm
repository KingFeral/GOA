mob/proc
	TalkTopic(mob/NPC,Talkbout)
		switch(Talkbout)
			if("Academy")
				alert(src,"The Ninja Academy is a great place, it teaches shinobi the basic and essential skills that they will make use of throughout their careers")
			if("Dojo")
				alert(src,"The Dojo is a great place to go, you can meet up with fellow shinobi to spar without worrying about being seriously hurt. It's a great way to train.")
			if("The Sannin")
				alert(src,"The Sannin are the pride of Konoha, working as a team those three have really won some amazing victories for Konoha. Orochimaru kind of scares me though, he seems inhuman.")
