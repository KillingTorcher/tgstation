//Use this file to for things related to round start or new spawn initializations.

proc/Initialize_Falaskians_Shit()
	SaveStation()
	new_player_cam = new()

/datum/config_entry/string/discordurl

/client/verb/discord()
	set name = "discord"
	set desc = "Join the discord."
	set hidden = 1
	var/discordurl = CONFIG_GET(string/discordurl)
	if (discordurl)
		if(alert("This will open the discord invitation in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(discordurl)
	else
		src << sound('sound/items/bikehorn.ogg')
		to_chat(src, "<span class='danger'>The discord URL is not set in the server configuration.</span>")

/world/proc/update_status()
	var/theservername = CONFIG_GET(string/servername)
	if (!theservername)
		theservername = "Space Station 13"
	var/dat = "<b>[theservername]</B> "
	var/theforumurl = CONFIG_GET(string/forumurl)
	var/thediscordlink = CONFIG_GET(string/discordurl)
	if(theforumurl || thediscordlink)
		dat += "("
		if(theforumurl)
			dat += "<a href=\"[theforumurl]\">Forums</a>"
		if(theforumurl && thediscordlink)
			dat += "|"
		if(thediscordlink)
			dat += "<a href=\"[thediscordlink]\">Discord</a>"
		dat += ")<br>"
	if(SSticker)
		if(SSticker.current_state < GAME_STATE_PLAYING)
			dat += "New Round Starting."
		else if (SSticker.current_state > GAME_STATE_PLAYING)
			dat += "Round has ended. New round soon."
		else
			dat += "Game Mode: [capitalize(GLOB.master_mode)]<br>"
			dat += "Round Duration: [time2text(world.time-SSticker.round_start_time, "hh:mm")]"
	else
		dat += "Restarting."
	var/thepath = "config/hub_features.txt"
	if(fexists(thepath))
		var/list/hub_features = file2list(thepath)
		if(hub_features && hub_features.len)
			dat += "<br>"
			var/linecount = 1
			for(var/line in hub_features)
				dat += "[line]"
				if(linecount != hub_features.len)
					dat += "<br>"
				linecount ++
	world.status = dat

//modifying a player after hes equipped when spawning in as crew member.
/datum/outfit/proc/update_toolbox_inventory(mob/living/carbon/human/H)
	var/themonth = text2num(time2text(world.timeofday,"MM"))
	var/theday = text2num(time2text(world.timeofday,"DD"))
	//var/theyear = text2num(time2text(world.timeofday,"YYYY"))
	if(!istype(H))
		return
	if(!H.wear_mask && H.ckey == "landrydragon")
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/mime(H),slot_wear_mask)
	//st patricks day
	if(themonth == 3 && theday == 17)
		if(H.w_uniform)
			H.w_uniform.name = "Green [H.w_uniform.name]"
			H.w_uniform.icon_state = "green"
			H.w_uniform.item_state = "g_suit"
			H.w_uniform.item_color = "green"
			H.regenerate_icons()

//switching off human mood because its gay as fuck -falaskian
/datum/config_entry/flag/disable_human_mood
	config_entry_value = 1

/client
	var/list/shared_ips = list()
	var/list/shared_ids = list()