var/global/list/item_spawners = list(
	"shirt"											= new/item_spawner("shirt", /item/equip/apparel, list(name = "Shirt", icon = 'media/obj/clothing/shirt.dmi', icon_state = "gui", equip_slot = "shirt", user_overlays = list(new/image('media/obj/clothing/shirt.dmi')))),
	"pants"											= new/item_spawner("pants", /item/equip/apparel, list(name = "Pants", icon = 'media/obj/clothing/pants.dmi', icon_state = "gui", equip_slot = "pants", user_overlays = list(new/image('media/obj/clothing/pants.dmi')))),

	"leaf_chuunin_vest"								= new/item_spawner("leaf_chuunin_vest", /item/equip/armor, list(name = "Leaf Chuunin Vest", icon = 'media/faction/vest_icons/leaf_vest.dmi', icon_state = "gui", equip_slot = "chest_armor", armor_value = 50, user_overlays = list(new/image('media/faction/vest_icons/leaf_vest.dmi')))),
	"mist_chuunin_vest"								= new/item_spawner("mist_chuunin_vest", /item/equip/armor, list(name = "Mist Chuunin Vest", icon = 'media/faction/vest_icons/mist_vest.dmi', icon_state = "gui", equip_slot = "chest_armor", armor_value = 50, user_overlays = list(new/image('media/faction/vest_icons/mist_vest.dmi')))),
	"sand_chuunin_vest"								= new/item_spawner("sand_chuunin_vest", /item/equip/armor, list(name = "Sand Chuunin Vest", icon = 'media/faction/vest_icons/sand_vest.dmi', icon_state = "gui", equip_slot = "chest_armor", armor_value = 50, user_overlays = list(new/image('media/faction/vest_icons/sand_vest.dmi')))),

	"kunai_projectile"								= new/item_spawner("kunai_projectile", /item/equip/weapon/projectile, list(name = "Kunai Projectile", icon = 'media/obj/extras/projectiles.dmi', icon_state = "kunai", static_stamina_dmg = 450, projectile_state = "kunai-m", weight = 5)),
	"shuriken_projectile"							= new/item_spawner("shuriken_projectile", /item/equip/weapon/projectile, list(name = "Shuriken Projectile", icon = 'media/obj/extras/projectiles.dmi', icon_state = "shuriken", static_stamina_dmg = 150, projectile_state = "shuriken-m", throw_amount = 3, weight = 5)),
	"senbon_projectile"								= new/item_spawner("senbon_projectile", /item/equip/weapon/projectile, list(name = "Senbon Projectile", icon = 'media/obj/extras/projectiles.dmi', icon_state = "senbons", static_stamina_dmg = 90, projectile_state = "senbon-m", throw_amount = 5, weight = 5)),

	"kunai_knife"									= new/item_spawner("kunai_knife", /item/equip/weapon/melee, list(name = "Kunai", icon = 'media/obj/extras/kunai_knife.dmi', icon_state = "gui", static_stamina_dmg = 100, stat_dmg = list(REFLEX), stat_mult = list(REFLEX = 1), weapon_type = "knife", self_stun = 1, user_overlays = list(new/image('media/obj/extras/kunai_knife.dmi', layer = MOB_LAYER + 0.01)))),
	"executioner"									= new/item_spawner("executioner", /item/equip/weapon/melee, list(name = "Executioner", icon = 'media/obj/extras/projectiles.dmi', icon_state = "executioner", static_stamina_dmg = 450, stat_dmg = list(REFLEX), stat_mult = list(REFLEX = 2), weapon_type = "sword", cooldown = 4, user_overlays = list(new/image('media/obj/extras/Executioner.dmi', pixel_x = -16, pixel_y = -16)))),

	)

item_spawner
	parent_type = /spawner

spawner
	var/id
	var/instance_type
	var/list/properties

	proc/build(atom/a)
		for(var/p in properties)
			if(p in a.vars)
				a.vars[p] = properties[p]

		if(a.modifications)
			for(var/m in a.modifications)
				if(m in a.vars)
					a.vars[m] = a.modifications[m]

			a.modifications = null

	proc/get(atom/location)
		. = new instance_type(location, id)

	New(id, instance_type, list/properties)
		src.id = id
		src.instance_type = instance_type
		src.properties = properties

proc/give_item(item_id, character/m)
	if(item_id)
		var/item_spawner/i = global.item_spawners[item_id]

		if(!i) return

		i.get(m)
	//	m.refresh_inventory()