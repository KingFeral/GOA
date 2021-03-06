

var/const	// Skill index lists
	// Notes on skill assignments:
	// - Cancel skills are xx99, go down if more are needed
	// - S-rank skills are xx50+

	// Starting skills
	KAWARIMI = 1
	WINDMILL_SHURIKEN = 2
	SHUNSHIN = 3
	BUNSHIN = 4
	HENGE = 5
	EXPLODING_KUNAI = 6
	EXPLODING_NOTE = 7

	// Elemental Skills -- Fire
	KATON_FIREBALL = 100
	KATON_PHOENIX_FIRE = 101
	KATON_ASH_BURNING = 102
	KATON_DRAGON_FIRE = 111

	// Elemental Skills -- Water
	SUITON_DRAGON = 200
	SUITON_VORTEX = 201
	SUITON_SHOCKWAVE = 202
	SUITON_COLLISION_DESTRUCTION = 211

	// Elemental Skills -- Wind
	FUUTON_WIND_BLADE = 300
	FUUTON_GREAT_BREAKTHROUGH = 301
	FUUTON_PRESSURE_DAMAGE = 302
	FUUTON_AIR_BULLET = 311
	FUUTON_RASENSHURIKEN = 350

	// Elemental Skills -- Earth
	DOTON_IRON_SKIN = 400
	DOTON_CHAMBER = 401
	DOTON_EARTH_FLOW = 402
	DOTON_CHAMBER_CRUSH = 411

	// Elemental Skills -- Lightning
	CHIDORI = 500
	CHIDORI_CURRENT = 501
	CHIDORI_SPEAR = 502
	CHIDORI_NEEDLES = 511
	RAIKIRI = 550
	KIRIN = 551

	// General Skills -- Bunshin Variants
	KAGE_BUNSHIN = 1000
	CROW_BUNSHIN = 1001
	TAJUU_KAGE_BUNSHIN = 1010
	SHUIRKEN_KAGE_BUNSHIN = 1011
	EXPLODING_KAGE_BUNSHIN = 1020

	// General Skills -- Rasengan Variants
	RASENGAN = 1100
	OODAMA_RASENGAN = 1110

	// General Skills -- Gates
	GATE1 = 1300
	GATE2 = 1310
	GATE3 = 1320
	GATE4 = 1330
	GATE5 = 1340
	GATE6 = 1350
	PRIMARY_LOTUS = 1351
	HIDDEN_LOTUS = 1352
	MORNING_PEACOCK = 1351
	AFTERNOON_TIGER = 1352
	GATE_CANCEL = 1399

	// General Skills -- Weapons
	MANIPULATE_ADVANCING_BLADES = 1400
	TWIN_RISING_DRAGONS = 1401

	// General Skills -- Genjutsu
	SLEEP_GENJUTSU = 1500
	PARALYZE_GENJUTSU = 1501
	DARKNESS_GENJUTSU = 1511

	// General Skills -- Other
	CAMOUFLAGE_CONCEALMENT = 1600
	CHAKRA_LEECH = 1601
	HIRAISHIN = 1650

	// Medical Skills
	MEDIC = 2000
	CHAKRA_TAI_RELEASE = 2010
	MYSTICAL_PALM = 2011
	POISON_MIST = 2012
	IMPORTANT_BODY_PTS_DISTURB = 2021
	POISON_NEEDLES = 2022
	PHOENIX_REBIRTH = 2030

	// Sage Skills
	SAGE_MODE = 2100

	// CS Skills
	CURSE_SEAL = 2200

	// Clan Skills -- Uchiha
	SHARINGAN1 = 3000
	SHARINGAN2 = 3010
	SHARINGAN_COPY = 3020
	LION_COMBO = 3021

	// Clan Skills -- Hyuuga
	BYAKUGAN = 3100
	KAITEN = 3110
	HAKKE_64 = 3111
	GENTLE_FIST = 3112

	// Clan Skills -- Nara
	SHADOW_IMITATION = 3200
	SHADOW_NECK_BIND = 3210
	SHADOW_SEWING_NEEDLES = 3220

	// Clan Skills -- Akimichi
	MEAT_TANK = 3300
	SPINACH_PILL = 3301
	SIZEUP1 = 3310
	CURRY_PILL = 3311
	SIZEUP2 = 3320

	// Clan Skills -- Haku
	ICE_NEEDLES = 3400
	ICE_SPIKE_EXPLOSION = 3410
	DEMONIC_ICE_MIRRORS = 3420

	// Clan Skills -- Kaguya
	BONE_SWORD = 3500
	BONE_HARDEN = 3501
	BONE_BULLETS = 3502
	BONE_SPINES = 3510
	SAWARIBI = 3520

	// Clan Skills -- Jashin Religion
	MASOCHISM = 3600
	WOUND_REGENERATION = 3601
	IMMORTALITY = 3602
	BLOOD_BIND = 3611

	// Clan Skills -- Sand Control
	SAND_SUMMON = 3700
	SAND_SHIELD = 3710
	DESERT_FUNERAL = 3711
	SAND_SHURIKEN = 3712
	SAND_ARMOR = 3720
	SAND_UNSUMMON = 3799

	// Clan Skills -- Puppeteer
	PUPPET_SUMMON1 = 3800
	PUPPET_SUMMON2 = 3810
	PUPPET_HENGE = 3811
	PUPPET_SWAP = 3812

	// Clan Skills -- Deidara
	EXPLODING_SPIDER = 3900
	EXPLODING_BIRD = 3901
	C3 = 3902
	RIDABLE_BIRD = 3911

	// Taijutsu Stance -- Strong Fist
	STRONG_FIST = 4000
	LEAF_WHIRLWIND = 4001
	LEAF_GREAT_WHIRLWIND = 4002
	LEAF_GALE = 4003
	LEAF_RISING_WIND = 4004
	LEAF_STRONG_WHIRLWIND = 4005
	DANCING_LEAF_SHADOW = 4006

	// Taijutsu Stance -- Arhat Fist
	ARHAT_FIST = 4100
	ROCK_ATTACK = 4101
	THRUSTING_SHOULDER = 4102
	CRUMBLING_PALM = 4103
	RISING_KNEE = 4104
	UPWARDS_PALM = 4105
	PRESSURE_PALM = 4106

	// Taijutsu Stance -- Wrestling
	WRESTLING = 4200
	POWERBOMB = 4201
	DROP_KICK = 4202
	LARIAT = 4203
	KNEE_DROP = 4204
	KIDNEY_PUNCH = 4205
	IRON_CLAW = 4206