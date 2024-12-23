/datum/equipment_preset/uscm
	name = "USCM"
	faction = FACTION_MARINE
	faction_group = FACTION_LIST_MARINE
	languages = list(LANGUAGE_ENGLISH)
	idtype = /obj/item/card/id/dogtag

	utility_under = list(/obj/item/clothing/under/marine)
	utility_hat = list(/obj/item/clothing/head/cmcap)
	utility_gloves = list(/obj/item/clothing/gloves/marine)
	utility_shoes = list(/obj/item/clothing/shoes/marine)
	utility_extra = list(/obj/item/clothing/head/beret/cm, /obj/item/clothing/head/beret/cm/tan)

	service_under = list(/obj/item/clothing/under/marine/officer/bridge)
	service_over = list(/obj/item/clothing/suit/storage/jacket/marine/service, /obj/item/clothing/suit/storage/jacket/marine/service/mp)
	service_hat = list(/obj/item/clothing/head/cmcap)
	service_shoes = list(/obj/item/clothing/shoes/laceup)

	dress_under = list(/obj/item/clothing/under/marine/dress/blues/senior)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues/nco)
	dress_hat = list(/obj/item/clothing/head/marine/dress_cover)
	dress_gloves = list(/obj/item/clothing/gloves/marine/dress)
	dress_shoes = list(/obj/item/clothing/shoes/laceup)
	var/auto_squad_name
	///Allows the squad to be set even if spawned on admin z level
	var/ert_squad = FALSE

/datum/equipment_preset/uscm/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_VERYLOW

/datum/equipment_preset/uscm/load_preset(mob/living/carbon/human/new_human, randomise, count_participant)
	. = ..()
	if(!auto_squad_name || (should_block_game_interaction(new_human) && !ert_squad))
		return
	if(!GLOB.data_core.manifest_modify(new_human.real_name, WEAKREF(new_human), assignment, rank))
		GLOB.data_core.manifest_inject(new_human)

	var/obj/item/card/id/ID = new_human.get_idcard()
	var/datum/money_account/acct = create_account(new_human, rand(30, 50), GLOB.paygrades[ID.paygrade])
	ID.associated_account_number = acct.account_number

	var/datum/squad/auto_squad = get_squad_by_name(auto_squad_name)
	if(auto_squad)
		transfer_marine_to_squad(new_human, auto_squad, new_human.assigned_squad, ID)
	if(!ert_squad && !auto_squad.active)
		auto_squad.engage_squad(FALSE)

	if(!auto_squad)
		transfer_marine_to_squad(new_human, pick(GLOB.RoleAuthority.squads), new_human.assigned_squad, new_human.wear_id)

	new_human.marine_buyable_categories[MARINE_CAN_BUY_EAR] = 0
	new_human.sec_hud_set_ID()
	new_human.hud_set_squad()

	if(new_human.wear_l_ear)
		if(istype(new_human.wear_l_ear, /obj/item/device/radio/headset/almayer/marine))
			var/obj/item/device/radio/headset/almayer/marine/equipped_headset = new_human.wear_l_ear
			equipped_headset.add_hud_tracker(new_human)
	else if(new_human.wear_r_ear)
		if(istype(new_human.wear_r_ear, /obj/item/device/radio/headset/almayer/marine))
			var/obj/item/device/radio/headset/almayer/marine/equipped_headset = new_human.wear_r_ear
			equipped_headset.add_hud_tracker(new_human)

/datum/equipment_preset/uscm/proc/spawn_marine_fluff_items(mob/living/carbon/human/new_human)
	var/obj/item/helmet_accessory = pick(GLOB.allowed_helmet_items)
	new_human.equip_to_slot_or_del(new helmet_accessory, WEAR_IN_HELMET)
	if(prob(50))
		var/obj/item/helmet_accessory_two = pick(GLOB.allowed_helmet_items)
		new_human.equip_to_slot_or_del(new helmet_accessory_two, WEAR_IN_HELMET)
	var/list/possible_masks = list(/obj/item/clothing/mask/gas) + subtypesof(/obj/item/clothing/mask/rebreather) + subtypesof(/obj/item/clothing/mask/tornscarf)
	if(prob(50))
		var/obj/item/clothing/mask/new_mask = pick(possible_masks)
		new_human.equip_to_slot_or_del(new new_mask, WEAR_FACE)

	var/list/possible_glasses = list(/obj/item/clothing/glasses/regular, /obj/item/clothing/glasses/regular/hipster, /obj/item/clothing/glasses/sunglasses, /obj/item/clothing/glasses/sunglasses/aviator, /obj/item/clothing/glasses/sunglasses/big) + subtypesof(/obj/item/clothing/glasses/mgoggles)
	if(prob(50))
		var/obj/item/clothing/mask/new_glasses = pick(possible_glasses)
		new_human.equip_to_slot_or_del(new new_glasses, WEAR_EYES)

/datum/equipment_preset/uscm/proc/spawn_marine_armor(mob/living/carbon/human/new_human)
	if(prob(66))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/medium, WEAR_JACKET)
	else if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/light, WEAR_JACKET)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/heavy, WEAR_JACKET)

/datum/equipment_preset/uscm/proc/spawn_marine_backpack(mob/living/carbon/human/new_human)
	if(prob(75))
		new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel, WEAR_BACK)
	else
		new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine, WEAR_BACK)

/datum/equipment_preset/uscm/proc/spawn_marine_sidearm(mob/living/carbon/human/new_human)
	return

//*****************************************************************************************************/
/datum/equipment_preset/uscm/pfc
	name = "USCM Squad Rifleman"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrades = list(PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "RFN"
	skills = /datum/skills/pfc

	minimap_icon = "private"
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/pfc/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm/pfc/upp
	name = "UPP Squad Rifleman"
	paygrades = list(PAY_SHORT_UE2 = JOB_PLAYTIME_TIER_0)
	access = list(ACCESS_UPP_GENERAL)
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction_group = list(FACTION_UPP)
	faction = FACTION_UPP

/datum/equipment_preset/uscm/pfc/upp/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "Naval Infantry Telnyashka"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)

/datum/equipment_preset/uscm/pfc/upp/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_UE1 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm/pfc/upp/lesser_rank/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "Naval Infantry Telnyashka"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)

/datum/equipment_preset/uscm/pfc/forecon
	name = "FORECON Squad Rifleman"
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_1)
	skills = /datum/skills/pfc/recon

/datum/equipment_preset/uscm/pfc/forecon/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/sg
	name = "USCM Squad Smartgunner"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = JOB_SQUAD_SMARTGUN
	rank = JOB_SQUAD_SMARTGUN
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

	minimap_icon = "smartgunner"
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/sg/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm/sg/upp
	name = "UPP Squad Machinegunner"
	access = list(ACCESS_UPP_GENERAL, ACCESS_UPP_MACHINEGUN)
	assignment = "Machinegunner"
	paygrades = list(PAY_SHORT_UE4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "MG"
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction_group = list(FACTION_UPP)
	faction = FACTION_UPP

/datum/equipment_preset/uscm/sg/upp/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "Naval Infantry Telnyashka"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)

/datum/equipment_preset/uscm/sg/upp/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm/sg/upp/lesser_rank/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "Naval Infantry Telnyashka"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)

/datum/equipment_preset/uscm/sg/forecon
	name = "FORECON Squad Smartgunner"
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/smartgunner/recon

/datum/equipment_preset/uscm/sg/forecon/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/rto
	name = "USCM Radio Telephone Operator"
	flags = EQUIPMENT_PRESET_START_OF_ROUND|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_RTO
	rank = JOB_SQUAD_RTO
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "RTO"
	skills = /datum/skills/pfc

	minimap_icon = "rto"

/datum/equipment_preset/uscm/rto/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/tank
	name = "USCM Vehicle Crewman (CRMN) (Cryo)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(
		ACCESS_MARINE_PREP,
		ACCESS_MARINE_CREWMAN,
		ACCESS_MARINE_ALPHA,
		ACCESS_MARINE_BRAVO,
		ACCESS_MARINE_CHARLIE,
		ACCESS_MARINE_DELTA,
	)
	assignment = JOB_TANK_CREW
	rank = JOB_TANK_CREW
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "CRMN"
	minimum_age = 30
	skills = /datum/skills/tank_crew

	minimap_icon = "vc"

/datum/equipment_preset/uscm/tank/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine

	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/vc(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/jacket/marine/service/tanker, WEAR_JACKET)

/datum/equipment_preset/uscm/tank/load_status(mob/living/carbon/human/new_human)
	return

//*****************************************************************************************************/

/datum/equipment_preset/uscm/tank/full
	name = "USCM Vehicle Crewman (CRMN)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	utility_under = list(/obj/item/clothing/under/marine/officer/tanker)

/datum/equipment_preset/uscm/tank/full/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/mcom/vc(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/tanker(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/vp70(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/tanker(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech/tanker(new_human), WEAR_HEAD)

	spawn_weapon(/obj/item/weapon/gun/smg/m39, /obj/item/ammo_magazine/smg/m39/extended, new_human, 0, 3)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/tank/recon
	name = "USCM Reconnaissance Vehicle Operator (CRMN)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	assignment = "Reconnaissance Vehicle Operator"
	role_comm_title = "RVO"
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)

	utility_under = list(/obj/item/clothing/under/marine/officer/tanker)

/datum/equipment_preset/uscm/tank/recon/load_gear(mob/living/carbon/human/new_human)
	var/obj/item/clothing/under/marine/officer/tanker/uniform = new()
	var/obj/item/clothing/accessory/patch/patch_uscm = new()
	var/obj/item/clothing/accessory/patch/forecon/patch_forecon = new()
	uniform.attach_accessory(new_human,patch_uscm)
	uniform.attach_accessory(new_human,patch_forecon)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/sof(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(uniform, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/jungle/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/brown(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m44/gunslinger/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/tanker(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/fancy/cigarettes/lucky_strikes(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldingtool/simple(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt/standard(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/microwavable/packaged_burger(new_human), WEAR_IN_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/wy_chips/pepper(new_human), WEAR_IN_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/snacks/wrapped/chunk(new_human), WEAR_IN_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/cola(new_human), WEAR_IN_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/reagent_container/food/drinks/cans/cola(new_human), WEAR_IN_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack/welder_chestrig(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/weldpack/minitank(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/stack/sandbags_empty/full(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/tools/tank(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/pistol/large(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/marksman(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/marksman(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/marksman(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/marksman(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/marksman(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver/marksman(new_human), WEAR_IN_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/cmcap(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/ucigarette(new_human), WEAR_FACE)

/*****************************************************************************************************/

/datum/equipment_preset/uscm/spec
	name = "USCM (Cryo) Squad Weapons Specialist"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "Spc"
	skills = /datum/skills/specialist

	minimap_icon = "spec"
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/spec/cryo
	name = "USCM Cryo Squad Weapons Specialist"
	auto_squad_name = SQUAD_MARINE_CRYO

/datum/equipment_preset/uscm/spec/cryo/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/spec_kit/cryo, WEAR_R_HAND)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/spec/full_armor
	name = "USCM Weapons Specialist (B18 Armor)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

/datum/equipment_preset/uscm/spec/full_armor/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/specialist(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/specialist(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/gas(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine/specialist(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/explosive/grenade/high_explosive(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/spec/full_armor/load_status(mob/living/carbon/human/new_human)
	return //No cryo munchies

//*****************************************************************************************************/

/datum/equipment_preset/uscm/medic
	name = "USCM Squad Hospital Corpsman"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "HM"
	skills = /datum/skills/combat_medic

	minimap_icon = "medic"

	utility_under = list(/obj/item/clothing/under/marine/medic)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/medic/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm/medic/upp
	name = "UPP Squad Sanitar"
	paygrades = list(PAY_SHORT_UE4 = JOB_PLAYTIME_TIER_0)
	access = list(ACCESS_UPP_GENERAL, ACCESS_UPP_MEDPREP, ACCESS_UPP_MEDICAL)
	assignment = "Sanitar"
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction_group = list(FACTION_UPP)
	faction = FACTION_UPP

/datum/equipment_preset/uscm/medic/upp/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "Naval Infantry Telnyashka"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)

/datum/equipment_preset/uscm/medic/upp/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_UE3 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm/medic/upp/lesser_rank/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "Naval Infantry Telnyashka"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)

/datum/equipment_preset/uscm/medic/forecon
	name = "FORECON Squad Corpsman"
	assignment = "Squad Corpsman"
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/combat_medic/recon

/datum/equipment_preset/uscm/medic/forecon/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/tl
	name = "USCM Squad Sergeant"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_TL_PREP)
	assignment = JOB_SQUAD_TEAM_LEADER
	rank = JOB_SQUAD_TEAM_LEADER
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SqSgt"
	skills = /datum/skills/tl
	minimap_icon = "tl"

/datum/equipment_preset/uscm/tl/upp
	name = "UPP Squad Sergeant"
	paygrades = list(PAY_SHORT_UE5 = JOB_PLAYTIME_TIER_0)
	access = list(ACCESS_UPP_GENERAL, ACCESS_UPP_TLPREP)
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_CHINESE)
	faction_group = list(FACTION_UPP)
	faction = FACTION_UPP

/datum/equipment_preset/uscm/tl/upp/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "Naval Infantry Telnyashka"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)

/datum/equipment_preset/uscm/tl/forecon
	name = "FORECON Assistant Squad Leader"
	assignment = "Assistant Squad Leader"
	paygrades = list(PAY_SHORT_ME6 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "aSL"
	skills = /datum/skills/tl/recon

/*****************************************************************************************************/

/datum/equipment_preset/uscm/engineer
	name = "USCM Squad Combat Technician"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	paygrades = list(PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "ComTech"
	skills = /datum/skills/combat_engineer

	minimap_icon = "engi"

	utility_under = list(/obj/item/clothing/under/marine/engineer)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/engineer/load_gear(mob/living/carbon/human/new_human)
	var/back_item = /obj/item/storage/backpack/marine/satchel/tech
	if (new_human.client && new_human.client.prefs && (new_human.client.prefs.backbag == 1))
		back_item = /obj/item/storage/backpack/marine/tech

	new_human.equip_to_slot_or_del(new back_item(new_human), WEAR_BACK)

/datum/equipment_preset/uscm/engineer/cryo
	name = "USCM Cryo Squad Combat Technician"
	auto_squad_name = SQUAD_MARINE_CRYO

/datum/equipment_preset/uscm/engineer/cryo/load_gear(mob/living/carbon/human/new_human)
	..()
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/engi(new_human), WEAR_L_EAR)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/leader
	name = "USCM Section Sergeant"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE
	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	paygrades = list(PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SctSgt"
	minimum_age = 27
	skills = /datum/skills/SL

	minimap_icon = "leader"

/datum/equipment_preset/uscm/leader/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_ME6 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm/leader/upp
	name = "UPP Platoon Sergeant"
	access = list(ACCESS_UPP_GENERAL, ACCESS_UPP_LEADERSHIP, ACCESS_UPP_FLIGHT)
	paygrades = list(PAY_SHORT_UE7 = JOB_PLAYTIME_TIER_0)
	languages = list(LANGUAGE_RUSSIAN, LANGUAGE_ENGLISH, LANGUAGE_CHINESE)
	faction_group = list(FACTION_UPP)
	faction = FACTION_UPP

/datum/equipment_preset/uscm/leader/upp/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "Naval Infantry Telnyashka"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)

/datum/equipment_preset/uscm/leader/upp/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_UE6 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uscm/leader/upp/lesser_rank/load_gear(mob/living/carbon/human/new_human)
	new_human.undershirt = "Naval Infantry Telnyashka"
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/uppcap/beret/naval, WEAR_HEAD)

/datum/equipment_preset/uscm/leader/forecon
	name = "FORECON Squad Leader"
	assignment = "Squad Leader"
	paygrades = list(PAY_SHORT_ME8 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SL"

/datum/equipment_preset/uscm/leader/forecon/lesser_rank
	name = parent_type::name + " (Lesser Rank)"
	paygrades = list(PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/
// ERT members that spawn with full gear from DEFCON

/datum/equipment_preset/uscm/private_equipped
	name = "USCM Squad Rifleman (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP)
	assignment = JOB_SQUAD_MARINE
	rank = JOB_SQUAD_MARINE
	paygrades = list(PAY_SHORT_ME1 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "RFN"
	skills = /datum/skills/pfc

	minimap_icon = "private"
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/private_equipped/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_NORMAL

/datum/equipment_preset/uscm/private_equipped/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/private_equipped/random
	name = "USCM Squad Rifleman (Equipped Random)"

/datum/equipment_preset/uscm/private_equipped/random/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	spawn_marine_armor(new_human)
	spawn_marine_backpack(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(new_human), WEAR_WAIST)
	spawn_marine_fluff_items(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/leader_equipped
	name = "USCM Section Sergeant (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_DROPSHIP)
	assignment = JOB_SQUAD_LEADER
	rank = JOB_SQUAD_LEADER
	paygrades = list(PAY_SHORT_ME7 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SctSgt"
	minimum_age = 27
	skills = /datum/skills/SL

	minimap_icon = "leader"

/datum/equipment_preset/uscm/leader_equipped/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_NORMAL

/datum/equipment_preset/uscm/leader_equipped/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/leader(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/leader_equipped/random
	name = "USCM Section Sergeant (Equipped Random)"

/datum/equipment_preset/uscm/leader_equipped/random/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	spawn_marine_armor(new_human)
	spawn_marine_backpack(new_human)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/cryo/lead(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(new_human), WEAR_WAIST)
	spawn_marine_fluff_items(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/smartgunner_equipped
	name = "USCM Squad Smartgunner (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SMARTPREP)
	assignment = JOB_SQUAD_SMARTGUN
	rank = JOB_SQUAD_SMARTGUN
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "SG"
	skills = /datum/skills/smartgunner

	minimap_icon = "smartgunner"
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/smartgunner_equipped/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_NORMAL

/datum/equipment_preset/uscm/smartgunner_equipped/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/smartgunner(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/smartgunner/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles/no_nightvision(new_human), WEAR_EYES)


	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)

/datum/equipment_preset/uscm/smartgunner_equipped/random
	name = "USCM Squad Smartgunner (Equipped Random)"

/datum/equipment_preset/uscm/smartgunner_equipped/random/spawn_marine_fluff_items(mob/living/carbon/human/new_human)
	var/obj/item/helmet_accessory = pick(GLOB.allowed_helmet_items)
	new_human.equip_to_slot_or_del(new helmet_accessory, WEAR_IN_HELMET)
	if(prob(50))
		var/obj/item/helmet_accessory_two = pick(GLOB.allowed_helmet_items)
		new_human.equip_to_slot_or_del(new helmet_accessory_two, WEAR_IN_HELMET)
	var/list/possible_masks = list(/obj/item/clothing/mask/gas) + subtypesof(/obj/item/clothing/mask/rebreather) + subtypesof(/obj/item/clothing/mask/tornscarf)
	if(prob(50))
		var/obj/item/clothing/mask/new_mask = pick(possible_masks)
		new_human.equip_to_slot_or_del(new new_mask, WEAR_FACE)

/datum/equipment_preset/uscm/smartgunner_equipped/random/spawn_marine_sidearm(mob/living/carbon/human/new_human)
	var/sidearm = pick("m4a3", "vp70", "m44")
	switch(sidearm)
		if("m4a3")
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/m4a3(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol(new_human), WEAR_IN_ACCESSORY)
		if("vp70")
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/pistol/vp70(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/vp70(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/pistol/vp70(new_human), WEAR_IN_ACCESSORY)
		if("m44")
			new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/revolver/m44(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver(new_human), WEAR_IN_ACCESSORY)
			new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/revolver(new_human), WEAR_IN_ACCESSORY)

/datum/equipment_preset/uscm/smartgunner_equipped/random/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/holster(new_human), WEAR_ACCESSORY)
	spawn_marine_sidearm(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine/smartgunner(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/general_belt(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smartgun(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smartgun(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smartgun(new_human), WEAR_IN_BELT)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles/no_nightvision(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_JACKET)
	spawn_marine_fluff_items(new_human)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/engineer_equipped
	name = "USCM Squad Combat Technician (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_ENGPREP, ACCESS_CIVILIAN_ENGINEERING)
	assignment = JOB_SQUAD_ENGI
	rank = JOB_SQUAD_ENGI
	paygrades = list(PAY_SHORT_ME2 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "ComTech"
	skills = /datum/skills/combat_engineer

	minimap_icon = "engi"

	utility_under = list(/obj/item/clothing/under/marine/engineer)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/engineer_equipped/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_NORMAL

/datum/equipment_preset/uscm/engineer_equipped/load_gear(mob/living/carbon/human/new_human)
	//TODO: add backpacks and satchels
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/device/motiondetector, WEAR_R_HAND)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_BACK)

/datum/equipment_preset/uscm/engineer_equipped/cryo
	name = "USCM Cryo Squad Combat Technician (Equipped)"
	auto_squad_name = SQUAD_MARINE_CRYO

//*****************************************************************************************************/

/datum/equipment_preset/uscm/medic_equipped
	name = "USCM Squad Hospital Corpsman (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_MEDBAY)
	assignment = JOB_SQUAD_MEDIC
	rank = JOB_SQUAD_MEDIC
	paygrades = list(PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "HM"
	skills = /datum/skills/combat_medic

	minimap_icon = "medic"

	utility_under = list(/obj/item/clothing/under/marine/medic)
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/medic_equipped/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_NORMAL

/datum/equipment_preset/uscm/medic_equipped/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
	if(prob(50))
		new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/device/defibrillator(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(new_human), WEAR_WAIST)
	if(new_human.disabilities & NEARSIGHTED)
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health/prescription(new_human), WEAR_EYES)
	else
		new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft(new_human), WEAR_IN_BACK)

/datum/equipment_preset/uscm/medic_equipped/random
	name = "USCM Squad Hospital Corpsman (Equipped Random)"

/datum/equipment_preset/uscm/medic_equipped/random/spawn_marine_fluff_items(mob/living/carbon/human/new_human)
	var/obj/item/helmet_accessory = pick(GLOB.allowed_helmet_items)
	new_human.equip_to_slot_or_del(new helmet_accessory, WEAR_IN_HELMET)
	if(prob(50))
		var/obj/item/helmet_accessory_two = pick(GLOB.allowed_helmet_items)
		new_human.equip_to_slot_or_del(new helmet_accessory_two, WEAR_IN_HELMET)

	if(prob(50))
		var/list/possible_masks = list(/obj/item/clothing/mask/gas) + subtypesof(/obj/item/clothing/mask/rebreather) + subtypesof(/obj/item/clothing/mask/tornscarf)
		if(prob(25))
			var/obj/item/clothing/mask/new_mask = pick(possible_masks)
			new_human.equip_to_slot_or_del(new new_mask, WEAR_FACE)
		else
			new_human.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(new_human), WEAR_FACE)

/datum/equipment_preset/uscm/medic_equipped/random/load_gear(mob/living/carbon/human/new_human)
	spawn_marine_backpack(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine(new_human), WEAR_JACKET)
	spawn_marine_fluff_items(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/medical/lifesaver/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle/m41aMK1(new_human.back), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/surgical_line(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/tool/surgery/synthgraft(new_human), WEAR_IN_BACK)


//*****************************************************************************************************/

/datum/equipment_preset/uscm/specialist_equipped
	name = "USCM Squad Weapons Specialist (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_SPECPREP)
	assignment = JOB_SQUAD_SPECIALIST
	rank = JOB_SQUAD_SPECIALIST
	paygrades = list(PAY_SHORT_ME3 = JOB_PLAYTIME_TIER_0, PAY_SHORT_ME4 = JOB_PLAYTIME_TIER_1, PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_3)
	role_comm_title = "Spc"
	skills = /datum/skills/specialist

	minimap_icon = "spec"
	dress_under = list(/obj/item/clothing/under/marine/dress/blues)
	dress_over = list(/obj/item/clothing/suit/storage/jacket/marine/dress/blues)

/datum/equipment_preset/uscm/specialist_equipped/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_NORMAL

/datum/equipment_preset/uscm/specialist_equipped/load_gear(mob/living/carbon/human/new_human)
	//TODO: add backpacks and satchels
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/attachable/magnetic_harness(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/spec_kit, WEAR_R_HAND)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_BACK)

/datum/equipment_preset/uscm/specialist_equipped/cryo
	name = "USCM Cryo Squad Weapons Specialist (Equipped)"
	auto_squad_name = SQUAD_MARINE_CRYO

//*****************************************************************************************************/

/datum/equipment_preset/uscm/specialist_equipped/sniper
	name = "USCM Sniper Specialist (Equipped)"

/datum/equipment_preset/uscm/specialist_equipped/sniper/load_gear(mob/living/carbon/human/new_human)
	//TODO: add backpacks and satchels
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m42_night_goggles(new_human), WEAR_EYES)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/ghillie(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/ghillie(new_human), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/smock(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/accessory/storage/webbing(new_human), WEAR_ACCESSORY)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/sniper/incendiary(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/sniper/flak(new_human), WEAR_IN_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/ammo_magazine/sniper/flak(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_BACK)

	spawn_weapon(/obj/item/weapon/gun/rifle/sniper/M42A, /obj/item/ammo_magazine/sniper, new_human, 0, 5)

//*****************************************************************************************************/

/datum/equipment_preset/uscm/tl_equipped
	name = "USCM Squad Sergeant (Equipped)"
	flags = EQUIPMENT_PRESET_EXTRA|EQUIPMENT_PRESET_MARINE

	access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_TL_PREP)
	assignment = JOB_SQUAD_TEAM_LEADER
	rank = JOB_SQUAD_TEAM_LEADER
	paygrades = list(PAY_SHORT_ME5 = JOB_PLAYTIME_TIER_0)
	role_comm_title = "SqSgt"
	skills = /datum/skills/tl

	minimap_icon = "tl"

/datum/equipment_preset/uscm/tl_equipped/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_NORMAL

/datum/equipment_preset/uscm/tl_equipped/load_gear(mob/living/carbon/human/new_human)
	//TODO: add backpacks and satchels
	var/obj/item/clothing/under/marine/U = new(new_human)
	var/obj/item/clothing/accessory/storage/webbing/W = new()
	U.attach_accessory(new_human, W)
	new_human.equip_to_slot_or_del(U, WEAR_BODY)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/gun/m4a3/full(new_human), WEAR_WAIST)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/suit/marine(src), WEAR_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(src), WEAR_HANDS)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/rto(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/general/large(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars(new_human), WEAR_L_HAND)

	new_human.back.pickup(new_human)

/datum/equipment_preset/uscm/tl_equipped/random
	name = "USCM Squad Sergeant (Equipped Random)"

/datum/equipment_preset/uscm/tl_equipped/random/load_gear(mob/living/carbon/human/new_human)
	new_human.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/satchel/rto(new_human), WEAR_BACK)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/under/marine(new_human), WEAR_BODY)
	spawn_marine_armor(new_human)
	new_human.equip_to_slot_or_del(new /obj/item/device/binoculars/range(new_human), WEAR_IN_JACKET)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(new_human), WEAR_HEAD)
	new_human.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/solardevils/foxtrot(new_human), WEAR_L_EAR)

	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(new_human), WEAR_R_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(new_human), WEAR_L_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/clothing/gloves/marine(new_human), WEAR_HANDS)

	new_human.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(new_human), WEAR_FEET)
	new_human.equip_to_slot_or_del(new /obj/item/storage/box/MRE(new_human), WEAR_IN_BACK)

	new_human.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(new_human), WEAR_J_STORE)
	new_human.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(new_human), WEAR_WAIST)
	spawn_marine_fluff_items(new_human)
