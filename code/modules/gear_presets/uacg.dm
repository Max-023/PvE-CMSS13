/datum/equipment_preset/uacg
	name = "UACG"
	faction = FACTION_UACG
	faction_group = FACTION_LIST_UA
	languages = list(LANGUAGE_ENGLISH, LANGUAGE_SPANISH)
	///Gives the soldiers their radios
	var/headset_type = /obj/item/device/radio/headset/solardevils/uacg
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/load_name(mob/living/carbon/human/new_human, randomise)
	new_human.gender = pick(75;MALE,25;FEMALE)
	var/datum/preferences/A = new
	A.randomize_appearance(new_human)
	var/random_name = capitalize(pick(new_human.gender == MALE ? GLOB.first_names_male : GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
	var/static/list/colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "BROWN" = list(48, 38, 18),"BLUE" = list(29, 51, 65), "GREEN" = list(40, 61, 39), "STEEL" = list(46, 59, 54))
	var/static/list/hair_colors = list("BLACK" = list(15, 15, 10), "BROWN" = list(48, 38, 18), "AUBURN" = list(77, 48, 36), "BLONDE" = list(95, 76, 44))
	var/hair_color = pick(hair_colors)
	new_human.r_hair = hair_colors[hair_color][1]
	new_human.g_hair = hair_colors[hair_color][2]
	new_human.b_hair = hair_colors[hair_color][3]
	new_human.r_facial = hair_colors[hair_color][1]
	new_human.g_facial = hair_colors[hair_color][2]
	new_human.b_facial = hair_colors[hair_color][3]
	var/eye_color = pick(colors)
	new_human.r_eyes = colors[eye_color][1]
	new_human.g_eyes = colors[eye_color][2]
	new_human.b_eyes = colors[eye_color][3]
	if(new_human.gender == MALE)
		new_human.h_style = pick("Undercut", "Partly Shaved", "Side Undercut", "Side Hang Undercut (Reverse)", "Undercut, Top", "Medium Fade", "High Fade", "Coffee House Cut")
		new_human.f_style = pick("Shaved", "Shaved", "Shaved", "Shaved", "Shaved", "Shaved", "3 O'clock Shadow", "3 O'clock Moustache", "5 O'clock Shadow", "5 O'clock Moustache", "7 O'clock Shadow", "7 O'clock Moustache",)
	else
		new_human.h_style = pick("Side Undercut", "Side Hang Undercut (Reverse)", "Undercut, Top", "CIA", "Mulder", "Pvt. Redding", "Pixie Cut Left", "Pixie Cut Right", "Bun")
	new_human.change_real_name(new_human, random_name)
	new_human.age = rand(20,35)

/datum/equipment_preset/uacg/load_status(mob/living/carbon/human/new_human)
	new_human.nutrition = NUTRITION_VERYLOW

//*****************************************************************************************************/

/datum/equipment_preset/uacg/rifle
	name = "US Colonial Guard"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_UACG
	faction_group = FACTION_LIST_UA_COLONY
	assignment = "Colonial Militiaman"
	role_comm_title = "UACG"
	paygrades = list(PAY_SHORT_AE2 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/trooper
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_UACG, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_MARINE_PREP)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/rifle/lance_corporal
	name = parent_type::name + " (E3 Rank)"
	paygrades = list(PAY_SHORT_AE3 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uacg/rifle/private
	name = parent_type::name + " (E1 Rank)"
	paygrades = list(PAY_SHORT_AE1 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uacg/marksman
	name = "US Colonial Guard (Marksman)"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_UACG
	faction_group = FACTION_LIST_UA_COLONY
	assignment = "Colonial Militiaman"
	role_comm_title = "UACG"
	paygrades = list(PAY_SHORT_AE2 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/trooper
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_UACG, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_MARINE_PREP)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/marksman/lance_corporal
	name = parent_type::name + " (E3 Rank)"
	paygrades = list(PAY_SHORT_AE3 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uacg/marksman/private
	name = parent_type::name + " (E1 Rank)"
	paygrades = list(PAY_SHORT_AE1 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uacg/gunner
	name = "US Colonial Guard (Machine Gunner)"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_UACG
	faction_group = FACTION_LIST_UA_COLONY
	assignment = "Colonial Militia Marksman"
	role_comm_title = "UACG"
	paygrades = list(PAY_SHORT_AE2 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/trooper
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_UACG, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_MARINE_PREP)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/gunner/lance_corporal
	name = parent_type::name + " (E3 Rank)"
	paygrades = list(PAY_SHORT_AE3 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uacg/gunner/private
	name = parent_type::name + " (E1 Rank)"
	paygrades = list(PAY_SHORT_AE1 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uacg/tech
	name = "US Colonial Guard Technician"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_UACG
	faction_group = FACTION_LIST_UA_COLONY
	assignment = "Colonial Militiaman Technician"
	role_comm_title = "UACG"
	paygrades = list(PAY_SHORT_AE3 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/mainttech
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_UACG, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_MARINE_PREP)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/pfc/greater_rank
	name = parent_type::name + " (E4 Rank)"
	paygrades = list(PAY_SHORT_AE4 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uacg/tech/lower_rank
	name = parent_type::name + " (E2 Rank)"
	paygrades = list(PAY_SHORT_AE2 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uacg/medic
	name = "US Colonial Guard Medic"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_UACG
	faction_group = FACTION_LIST_UA_COLONY
	assignment = "Colonial Militiaman Medic"
	role_comm_title = "UACG"
	paygrades = list(PAY_SHORT_AE3 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/medic
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_UACG, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_MARINE_PREP)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/medic/greater_rank
	name = parent_type::name + " (E4 Rank)"
	paygrades = list(PAY_SHORT_AE4 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uacg/medic/lesser_rank
	name = parent_type::name + " (E2 Rank)"
	paygrades = list(PAY_SHORT_AE2 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uacg/leader
	name = "US Colonial Guard Unit Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_UACG
	faction_group = FACTION_LIST_UA_COLONY
	assignment = "Colonial Militiaman Unit Leader"
	role_comm_title = "UACG"
	paygrades = list(PAY_SHORT_AE5 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/nco
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_UACG, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_MARINE_PREP)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/leader/lesser_rank
	name = parent_type::name + " (E4 Rank)"
	paygrades = list(PAY_SHORT_AE4 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uacg/senleader
	name = "US Colonial Guard Senior Leader"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_UACG
	faction_group = FACTION_LIST_UA_COLONY
	assignment = "Colonial Militiaman Senior Leader"
	role_comm_title = "UACG"
	paygrades = list(PAY_SHORT_AE7 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/snco
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_UACG, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_MARINE_PREP)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/senleader/privatefirstclass
	name = parent_type::name + " (E6 Rank)"
	paygrades = list(PAY_SHORT_AE6 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uacg/senleader/armorer
	name = "US Colonial Guard Armorer"
	assignment = "Colonial Militiaman Armorer"
	paygrades = list(PAY_SHORT_AE7 = JOB_PLAYTIME_TIER_0)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/senleader/armorer/lesser_rank
	name = parent_type::name + " (E6 Rank)"
	paygrades = list(PAY_SHORT_AE6 = JOB_PLAYTIME_TIER_0)

//*****************************************************************************************************/

/datum/equipment_preset/uacg/officer
	name = "US Colonial Guard Officer"
	flags = EQUIPMENT_PRESET_EXTRA
	faction = FACTION_UACG
	faction_group = FACTION_LIST_UA_COLONY
	assignment = "Colonial Militiaman Officer"
	role_comm_title = "UACG"
	paygrades = list(PAY_SHORT_AO2 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/lt
	access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_UACG, ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_MARINE_PREP)
	idtype = /obj/item/card/id/dogtag

/datum/equipment_preset/uacg/officer/lesser_rank
	name = parent_type::name + " (O1 Rank)"
	paygrades = list(PAY_SHORT_AO1 = JOB_PLAYTIME_TIER_0)

/datum/equipment_preset/uacg/officer/doctor
	name = "US Colonial Guard Doctor"
	assignment = "Colonial Militiaman Doctor"
	paygrades = list(PAY_SHORT_AO1 = JOB_PLAYTIME_TIER_0)
	skills = /datum/skills/doctor
	idtype = /obj/item/card/id/dogtag
