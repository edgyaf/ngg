#include <YSI_Coding\y_hooks>

#define VEHICLE_PARAMS_TOG	10030

hook OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys) {

	new vehicleid = GetPlayerVehicleID(playerid);

	szMiscArray[0] = 0;

	if((newkeys & KEY_YES) && vehicleid != INVALID_VEHICLE_ID && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		//if(!AC_KeySpamCheck(playerid)) return 1;
		new engine,lights,alarm,doors,bonnet,boot,objective;
		if(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510 || DynVeh[vehicleid] != -1 && DynVehicleInfo[DynVeh[vehicleid]][gv_iType] == 1 && GetVehicleModel(vehicleid) == 592) return SendClientMessageEx(playerid,COLOR_WHITE,"This command can't be used in this vehicle.");
		if(WheelClamp{vehicleid}) return SendClientMessageEx(playerid,COLOR_WHITE,"(( This vehicle has a wheel camp on its front tire, you will not be able to drive away with it. ))");

		GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
		if(engine == VEHICLE_PARAMS_ON)
		{
			SetVehicleEngine(vehicleid, playerid);
			format(szMiscArray, sizeof(szMiscArray), "%s turns the key in the ignition and the engine stops.", GetPlayerNameEx(playerid));
			SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 15.0, 5000);
			//ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else if((engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET))
		{
			if (GetPVarInt(playerid, "Refueling")) return SendClientMessageEx(playerid, COLOR_WHITE, "You can't do this while refueling.");
			format(szMiscArray, sizeof(szMiscArray), "%s turns the key in the ignition and the engine starts.", GetPlayerNameEx(playerid));
			SetPlayerChatBubble(playerid, szMiscArray, COLOR_PURPLE, 15.0, 5000);
			//ProxDetector(30.0, playerid, szMiscArray, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle engine starting, please wait...");
			SetTimerEx("SetVehicleEngine", 1000, 0, "dd",  vehicleid, playerid);
			RemoveVehicleFromMeter(vehicleid);
		}
		
	}
	if((newkeys & KEY_LOOK_BEHIND) && vehicleid != INVALID_VEHICLE_ID && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		
		if(!IsAPlane(vehicleid)) {
			ShowVehicleMenu(playerid, vehicleid);
		}
		
	}
	return 1;
}

ShowVehicleMenu(playerid, vehicleid) {
	
	szMiscArray[0] = 0;

	new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	format(szMiscArray, sizeof(szMiscArray), "Item\tStatus\n\
		Seatbelt\t%s\n\
		Lights\t%s\n\
		Bonnet\t%s\n\
		Boot\t%s",
		((Seatbelt[playerid] == 0) ? ("Off") : ("On")),
		((lights == VEHICLE_PARAMS_OFF) ? ("Off") : ("On")),
		((bonnet == VEHICLE_PARAMS_OFF) ? ("Closed") : ("Open")),
		((boot == VEHICLE_PARAMS_OFF) ? ("Closed") : ("Open"))
	);

	ShowPlayerDialogEx(playerid, VEHICLE_PARAMS_TOG, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Options", szMiscArray, "Select", "Cancel");
}


hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(arrAntiCheat[playerid][ac_iFlags][AC_DIALOGSPOOFING] > 0) return 1;
	switch(dialogid) {

		case VEHICLE_PARAMS_TOG: {

			if(!response) return 1;

			new vehicleid = GetPlayerVehicleID(playerid);

			switch(listitem) {
				case 0: SetVehicleLights(vehicleid, playerid);// lights
				case 1: SetVehicleHood(vehicleid, playerid);// bonnet
				case 2: SetVehicleTrunk(vehicleid, playerid);// boot
			}	
		}
	}
	return 0;
}