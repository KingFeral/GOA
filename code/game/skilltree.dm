mob/proc/Get_Skill_Info(index)
	switch(index)
		if(4)
			var/popup = {"SkillPoint Cost: 50, Chakra Cost:10 Cooldown: 30 Seconds <br>
			<br><p><b>Bunshin is a standard ninja skill, using a very slight amount of chakra, the user can create an illusion of themselves to fool enemies.</b>"}// {"<IMG SRC='X.jpg'</IMG>"}
			src<<browse(popup,"window=Announcement,size=300x300,can_close=1,can_resize=1,titlebar=1")

client/Topic(href)
	if(href=="close")
		usr << browse(null,"window=Announcement")
	.=..()

mob/human/proc/refreshskills()
	if(src.client)
		src.Refresh_Skillpoints()
		src.Refresh_Gold()

mob/human/proc/Refresh_Gold()
	if(client)
		for(var/obj/skilltree/skills/X in world)
			if(X.is_dull)
				continue

			client.images -= X.goldimage
			client.images -= X.dullimage

			var/shown_gold = 0
			var/shown_dull = 0

			if(X.sindex > 0 && HasSkill(X.sindex))
				if(!shown_gold)
					src << X.goldimage
					shown_gold = 1

			if(X.element)
				if(X.element in elements)
					if(!shown_gold)
						src << X.goldimage
						shown_gold = 1

			if(X.clan)
				if(clan == X.clan)
					if(!shown_gold)
						src << X.goldimage
						shown_gold = 1
				else
					if(!shown_dull)
						src << X.dullimage
						shown_dull = 1

			if(X.clan_reqs)
				var/has_reqs = 1
				for(var/req_clan in X.clan_reqs)
					if(clan != req_clan)
						has_reqs = 0
						break

				if(!has_reqs)
					if(!shown_dull)
						src << X.dullimage
						shown_dull = 1

			if(X.element_reqs)
				var/has_reqs = 1
				for(var/req_element in X.element_reqs)
					if(!(req_element in elements))
						has_reqs = 0
						break

				if(!has_reqs)
					if(!shown_dull)
						src << X.dullimage
						shown_dull = 1

			if(X.skill_reqs)
				var/has_reqs = 1
				for(var/req_skill in X.skill_reqs)
					if(!HasSkill(req_skill))
						has_reqs = 0
						break

				if(!has_reqs)
					if(!shown_dull)
						src << X.dullimage
						shown_dull = 1

mob/objserver
	New()
		..()
		var/list/m=list()//typesof(/obj/gui/skillcards)
		m+=typesof(/obj/items)
		m -= /obj/items
		m -= /obj/items/equipable
		m -= /obj/items/equipable/newsys
		for(var/x in m)
			new x(src)

mob/npcserver
	New()
		..()
		var/list/m =typesof(/obj/gui/skillcards)
		for(var/x in m)
			if(x!=/obj/gui/skillcards/attackcard&&x!=/obj/gui/skillcards/defendcard&&x!=/obj/gui/skillcards/skillcard &&x!=/obj/gui/skillcards/usecard &&x!=/obj/gui/skillcards/interactcard && x!=/obj/gui/skillcards/untargetcard && x!=/obj/gui/skillcards/treecard)
				new x(src)

obj
	skilltree
		skills
			var
				sindex=0
				cost=0
				list/skill_reqs
				element
				list/element_reqs
				clan
				list/clan_reqs

				tmp
					image
						goldimage
						dullimage
					is_dull = 0


			New()
				. = ..()
				if(icon=='icons/gui.dmi')
					goldimage=image('icons/gui.dmi',src,icon_state="golden")
					dullimage=image('icons/dull.dmi',src)

					//goldimage.pixel_x = pixel_x
					//goldimage.pixel_y = pixel_y
					goldimage.layer = layer + 1

					//dullimage.pixel_x = pixel_x
					//dullimage.pixel_y = pixel_y
					dullimage.layer = layer + 1

				if(!((cost && (sindex > 0)) || element || clan))
					world << dullimage
					is_dull = 1

			Click()
				if(sindex <= 0 && !element)
					return

				var/srccost=src.cost
				if(element)
					switch(usr.elements.len)
						if(0)
							srccost=250
						if(1)
							srccost=450
						if(2)
							srccost=650
						if(3)
							srccost=850
						else // 4
							srccost=1050

				var/description="Ability: [src.name]"
				if(srccost)
					description += ", Skill Point Cost: [srccost]"
				var/options = list(/*"Get Skill Information"*/)

				if(srccost)
					var/has_clan = 1
					if(clan_reqs)
						for(var/req_clan in clan_reqs)
							if(usr.clan != req_clan)
								has_clan = 0
								break

					if(has_clan)
						if(sindex > 0)
							if(!usr:HasSkill(sindex))
								options += "Buy Skill"
						else if(element)
							if(!(element in usr.elements))
								options += "Buy Skill"

				options += "Nevermind"

				switch(input2(usr, "[description]", "Skill", options))
					if("Buy Skill")
						if(!(SkillType(sindex) || element))
							usr << "This skill is not currently availiable."
							return

						if(sindex > 0)
							if(usr:HasSkill(sindex))
								usr<<"You have already learned this skill!"
								return
						else
							if(element in usr.elements)
								usr<<"You have already learned to control this element!"
								return

						var/has_reqs=1
						if(skill_reqs)
							for(var/skill_id in skill_reqs)
								if(skill_id > 0)
									if(!usr:HasSkill(skill_id))
										has_reqs = 0
										break

						if(has_reqs && element_reqs)
							for(var/element in element_reqs)
								if(!(element in usr.elements))
									has_reqs = 0
									break

						if(has_reqs && clan_reqs)
							for(var/clan in clan_reqs)
								if(usr.clan != clan)
									has_reqs = 0
									break

						if(has_reqs)
							if(srccost > 0)
								switch(input2(usr,"Are you sure you want to obtain [src.name] at the cost of [srccost] skillpoints", "Skill",list ("Yes","No")))
									if("Yes")
										var/realcost = src.cost
										if(element)
											switch(usr.elements.len)
												if(0)
													realcost=250
												if(1)
													realcost=450
												if(2)
													realcost=650
												if(3)
													realcost=850
												else // 4
													realcost=1050
										if(usr.skillpoints>=realcost)
											if(sindex > 0)
												usr:AddSkill(sindex)
												if(sindex==SAND_SUMMON)
													usr:AddSkill(SAND_UNSUMMON)
												if(sindex==GATE1)
													usr:AddSkill(GATE_CANCEL)
												usr:RefreshSkillList()
											if(element)
												usr.elements += element
											usr.skillpoints-=realcost
											usr:refreshskills()

							else
								usr<<"This skill is not currently availiable."
								return
						else
							usr << "You are missing the prerequisites to learn this skill!"

			clan
				Akimichi_Clan
					clan = "Akimichi"
				Deidara_Clan
					clan = "Deidara"
				Haku_Clan
					clan = "Haku"
				Hyuuga_Clan
					clan = "Hyuuga"
				Jashin_Religion
					clan = "Jashin"
				Kaguya_Clan
					clan = "Kaguya"
				Nara_Clan
					clan = "Nara"
				Puppeteer
					clan = "Puppeteer"
				// Sand is a skill
				Uchiha_Clan
					clan = "Uchiha"
				akimichi
					clan_reqs = list("Akimichi")
					Size_Multiplication
						sindex = SIZEUP1
						cost = 800
					Super_Size_Multiplication
						sindex = SIZEUP2
						cost = 1500
						skill_reqs = list(SIZEUP1)
					Human_Bullet_Tank
						sindex = MEAT_TANK
						cost = 600
					Spinach_Pill
						sindex = SPINACH_PILL
						cost = 800
					Curry_Pill
						sindex = CURRY_PILL
						cost = 1200
						skill_reqs = list(SPINACH_PILL)
				deidara
					clan_reqs = list("Deidara")
					Exploding_Bird
						sindex = EXPLODING_BIRD
						cost = 800
					Exploding_Spider
						sindex = EXPLODING_SPIDER
						cost = 800
					C3
						sindex = C3
						cost = 3500
						skill_reqs = list(EXPLODING_BIRD, EXPLODING_SPIDER)
				haku
					clan_reqs = list("Haku")
					Sensatsusuisho
						sindex = ICE_NEEDLES
						cost = 800
					Ice_Explosion
						sindex = ICE_SPIKE_EXPLOSION
						cost = 1500
						skill_reqs = list(ICE_NEEDLES)
					Demonic_Ice_Crystal_Mirrors
						sindex = DEMONIC_ICE_MIRRORS
						cost = 2500
						skill_reqs = list(ICE_SPIKE_EXPLOSION)
				hyuuga
					clan_reqs = list("Hyuuga")
					Byakugan
						sindex = BYAKUGAN
						cost = 400
					Turning_the_Tide
						sindex = KAITEN
						cost = 1500
						skill_reqs = list(BYAKUGAN)
					Palms
						sindex = HAKKE_64
						cost = 3000
						skill_reqs = list(BYAKUGAN)
					Gentle_Fist
						sindex = GENTLE_FIST
						cost = 700
						skill_reqs = list(BYAKUGAN)
				jashin
					clan_reqs = list("Jashin")
					Stab_Self
						sindex = MASOCHISM
						cost = 500
						skill_reqs = list(BLOOD_BIND)
					Death_Ruling_Possession_Blood
						sindex = BLOOD_BIND
						cost = 1200
					Wound_Regeneration
						sindex = WOUND_REGENERATION
						cost = 800
						skill_reqs = list(MASOCHISM)
					Immortality
						sindex = IMMORTALITY
						cost = 1500
				kaguya
					clan_reqs = list("Kaguya")
					Piercing_Finger_Bullets
						sindex = BONE_BULLETS
						cost = 1500
					Bone_Harden
						sindex = BONE_HARDEN
						cost = 1000
					Camellia_Dance
						sindex = BONE_SWORD
						cost = 500
					Larch_Dance
						sindex = BONE_SPINES
						cost = 800
						skill_reqs = list(BONE_SWORD)
					Young_Bracken_Dance
						sindex = SAWARIBI
						cost = 2500
						skill_reqs = list(BONE_SPINES, BONE_BULLETS)
				nara
					clan_reqs = list("Nara")
					Shadow_Binding
						sindex = SHADOW_IMITATION
						cost = 1100
					Shadow_Neck_Bind
						sindex = SHADOW_NECK_BIND
						cost = 1500
						skill_reqs = list(SHADOW_IMITATION)
					Shadow_Sewing
						sindex = SHADOW_SEWING_NEEDLES
						cost = 2000
						skill_reqs = list(SHADOW_NECK_BIND)
				puppet
					clan_reqs = list("Puppeteer")
					First_Puppet
						sindex = PUPPET_SUMMON1
						cost = 700
					Second_Puppet
						sindex = PUPPET_SUMMON2
						cost = 2000
						skill_reqs = list(PUPPET_SUMMON1)
					Puppet_Transform
						sindex = PUPPET_HENGE
						cost = 350
						skill_reqs = list(PUPPET_SUMMON1)
					Puppet_Swap
						sindex = PUPPET_SWAP
						cost = 350
						skill_reqs = list(PUPPET_SUMMON1)
				sand
					clan_reqs = list("Sand Control")
					Sand_Control
						sindex = SAND_SUMMON
						cost = 100
					Desert_Funeral
						sindex = DESERT_FUNERAL
						cost = 2000
						skill_reqs = list(SAND_SUMMON)
					Sand_Shield
						sindex = SAND_SHIELD
						cost = 800
						skill_reqs = list(SAND_SUMMON)
					Sand_Armor
						sindex = SAND_ARMOR
						cost = 1500
						skill_reqs = list(SAND_SHIELD)
					Sand_Shuriken
						sindex = SAND_SHURIKEN
						cost = 1750
						skill_reqs = list(SAND_SUMMON)
				uchiha
					clan_reqs = list("Uchiha")
					Sharingan_2
						sindex = SHARINGAN1
						cost = 750
					Sharingan_3
						sindex = SHARINGAN2
						cost = 2000
						skill_reqs = list(SHARINGAN1)
					Sharingan_Copy
						sindex = SHARINGAN_COPY
						cost = 2500
						skill_reqs = list(SHARINGAN2)
			elements
				Earth_Elemental_Control
					element = "Earth"
				Fire_Elemental_Control
					element = "Fire"
				Lightning_Elemental_Control
					element = "Lightning"
				Water_Elemental_Control
					element = "Water"
				Wind_Elemental_Control
					element = "Wind"
				earth
					element_reqs = list("Earth")
					Iron_Skin
						sindex = DOTON_IRON_SKIN
						cost = 1800
					Dungeon_Chamber_of_Nothingness
						sindex = DOTON_CHAMBER
						cost = 800
					Split_Earth_Revolution_Palm
						sindex = DOTON_CHAMBER_CRUSH
						cost = 1500
						skill_reqs = list(DOTON_CHAMBER)
					Earth_Flow_River
						sindex = DOTON_EARTH_FLOW
						cost = 1900
				fire
					element_reqs = list("Fire")
					Grand_Fireball
						sindex = KATON_FIREBALL
						cost = 800
					Hosenka
						sindex = KATON_PHOENIX_FIRE
						cost = 400
					Ash_Accumulation_Burning
						sindex = KATON_ASH_BURNING
						cost = 2500
					Fire_Dragon_Flaming_Projectile
						sindex = KATON_DRAGON_FIRE
						cost = 2200
						skill_reqs = list(KATON_PHOENIX_FIRE)
				lightning
					element_reqs = list("Lightning")
					Chidori
						sindex = CHIDORI
						cost = 1500
					Chidori_Spear
						sindex = CHIDORI_SPEAR
						cost = 2500
					Chidori_Current
						sindex = CHIDORI_CURRENT
						cost = 600
					Chidori_Needles
						sindex = CHIDORI_NEEDLES
						cost = 1500
						skill_reqs = list(CHIDORI)
				water
					element_reqs = list("Water")
					Giant_Vortex
						sindex = SUITON_VORTEX
						cost = 600
					Bursting_Water_Shockwave
						sindex = SUITON_SHOCKWAVE
						cost = 2500
					Water_Dragon_Projectile
						sindex = SUITON_DRAGON
						cost = 1100
					Collision_Destruction
						sindex = SUITON_COLLISION_DESTRUCTION
						cost = 2100
						skill_reqs = list(SUITON_VORTEX)
				wind
					element_reqs = list("Wind")
					Pressure_Damage
						sindex = FUUTON_PRESSURE_DAMAGE
						cost = 2500
					Blade_of_Wind
						sindex = FUUTON_WIND_BLADE
						cost = 1500
					Great_Breakthrough
						sindex = FUUTON_GREAT_BREAKTHROUGH
						cost = 400
					Refined_Air_Bullet
						sindex = FUUTON_AIR_BULLET
						cost = 2000
						skill_reqs = list(FUUTON_GREAT_BREAKTHROUGH)
			general
				clones
					Clone
						sindex = BUNSHIN
						cost = 50
					Shadow_Clone
						sindex = KAGE_BUNSHIN
						cost = 1500
						skill_reqs = list(BUNSHIN)
					Multiple_Shadow_Clone
						sindex = TAJUU_KAGE_BUNSHIN
						cost = 1800
						skill_reqs = list(KAGE_BUNSHIN)
					Exploding_Shadow_Clone
						sindex = EXPLODING_KAGE_BUNSHIN
						cost = 1900
						skill_reqs = list(KAGE_BUNSHIN)
					Crow_Clone
						sindex = CROW_BUNSHIN
						cost = 900
						skill_reqs = list(BUNSHIN)
				gates
					Opening_Gate
						sindex = GATE1
						cost = 1500
					Energy_Gate
						sindex = GATE2
						cost = 1000
						skill_reqs = list(GATE1)
					Life_Gate
						sindex = GATE3
						cost = 1500
						skill_reqs = list(GATE2)
					Pain_Gate
						sindex = GATE4
						cost = 2000
						skill_reqs = list(GATE3)
					Limit_Gate
						sindex = GATE5
						cost = 2000
						skill_reqs = list(GATE4)
				genjutsu
					Darkness
						sindex = DARKNESS_GENJUTSU
						cost = 1700
						skill_reqs = list(PARALYZE_GENJUTSU)
					Fear
						sindex = PARALYZE_GENJUTSU
						cost = 1000
					Temple_of_Nirvana
						sindex = SLEEP_GENJUTSU
						cost = 1300
				taijutsu
					Lion_Combo
						sindex = LION_COMBO
						cost = 1400
					/*Achiever_of_Nirvana_Fist
						cost = 400
						sindex = NIRVANA_FIST*/
					Leaf_Great_Whirlwind
						cost = 800
						sindex = LEAF_WHIRLWIND
				weapons
					Manipulate_Advancing_Blades
						sindex = MANIPULATE_ADVANCING_BLADES
						cost = 1000
					Shuriken_Shadow_Clone
						sindex = SHUIRKEN_KAGE_BUNSHIN
						cost = 1300
						skill_reqs = list(KAGE_BUNSHIN)
					Twin_Rising_Dragons
						sindex = TWIN_RISING_DRAGONS
						cost = 2500
					Windmill_Shuriken
						sindex = WINDMILL_SHURIKEN
						cost = 75
					Exploding_Kunai
						sindex = EXPLODING_KUNAI
						cost = 800
					Exploding_Note
						sindex = EXPLODING_NOTE
						cost = 800
				Body_Flicker
					sindex = SHUNSHIN
					cost = 100
				Body_Replacement
					sindex = KAWARIMI
					cost = 100
				Rasengan
					sindex = RASENGAN
					cost = 1500
				Large_Rasengan
					sindex = OODAMA_RASENGAN
					cost = 2500
					skill_reqs = list(RASENGAN)
				Camouflaged_Hiding
					sindex = CAMOFLAGE_CONCEALMENT
					cost = 1200
				Chakra_Leech
					sindex = CHAKRA_LEECH
					cost = 1700
				Transform
					sindex = HENGE
					cost = 50
			medical
				Healing
					sindex = MEDIC
					cost = 2000
				Poison_Mist
					sindex = POISON_MIST
					cost = 1500
					skill_reqs = list(MEDIC)
				Poisoned_Needles
					sindex = POISON_NEEDLES
					cost = 1500
					skill_reqs = list(POISON_MIST)
				Chakra_Scalpel
					sindex = MYSTICAL_PALM
					cost = 1000
					skill_reqs = list(MEDIC)
				Cherry_Blossom_Impact
					sindex = CHAKRA_TAI_RELEASE
					cost = 1700
					skill_reqs = list(MEDIC)
				Creation_Rebirth
					sindex = PHOENIX_REBIRTH
					cost = 2500
					skill_reqs = list(IMPORTANT_BODY_PTS_DISTURB, CHAKRA_TAI_RELEASE)
				Body_Disruption_Stab
					sindex = IMPORTANT_BODY_PTS_DISTURB
					cost = 1000
					skill_reqs = list(MYSTICAL_PALM)
