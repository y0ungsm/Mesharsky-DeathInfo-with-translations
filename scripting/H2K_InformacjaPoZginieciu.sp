/*	Copyright (C) 2018/2019 Mesharsky
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#pragma semicolon 1

#define PLUGIN_AUTHOR "Mesharsky"
#define PLUGIN_VERSION "0.1"

#include <sourcemod>
#include <sdktools>
#include <multicolors>
#include <cstrike>

#pragma newdecls required

StringMap fullWeaponName;

public Plugin myinfo = 
{
	name = "[CSGO] Informacja po zginięciu", 
	author = PLUGIN_AUTHOR, 
	description = "Informacje po zginięciu", 
	version = PLUGIN_VERSION, 
	url = "https://How2Kill.pl"
};

public void OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath);
	LoadTranslations("deathinfo.phrases.txt");
}

public Action Event_PlayerDeath(Event event, const char[] name, bool bDontBroadcast)
{
	char weapon[64];
	char fullName[16];
	
	int client = GetClientOfUserId(event.GetInt("userid"));
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	int asyster = GetClientOfUserId(event.GetInt("assister"));
	
	event.GetString("weapon", weapon, sizeof(weapon));
	
	if (!attacker)
		return;
	
	if (attacker == client)
		return;
	
	if (!IsValidClient(attacker))
		return;
	
	if (GameRules_GetProp("m_bWarmupPeriod") == 1)
		return;
	
	// Sorry for that ugly ass code.
	fullWeaponName = CreateTrie();
	
	fullWeaponName.SetString("sawedoff", "Obrzyn (Sawed-Off)");
	fullWeaponName.SetString("mag7", "Mag-7");
	fullWeaponName.SetString("nova", "Nova");
	fullWeaponName.SetString("xm1014", "XM1014");
	fullWeaponName.SetString("mp7", "MP7");
	fullWeaponName.SetString("mp9", "MP9");
	fullWeaponName.SetString("ssg08", "SSG 08 (Scout)");
	fullWeaponName.SetString("awp", "AWP");
	fullWeaponName.SetString("famas", "FAMAS");
	fullWeaponName.SetString("ump45", "UMP-45");
	fullWeaponName.SetString("bizon", "PP-Bizon");
	fullWeaponName.SetString("mac10", "Mac-10");
	fullWeaponName.SetString("galilar", "Galil AR");
	fullWeaponName.SetString("p90", "P90");
	fullWeaponName.SetString("ak47", "AK-47");
	fullWeaponName.SetString("m4a1_silencer", "M4A1-S");
	fullWeaponName.SetString("m4a1_silencer_off", "M4A1-S");
	fullWeaponName.SetString("m4a1", "M4A4");
	fullWeaponName.SetString("sg556", "SG 553");
	fullWeaponName.SetString("aug", "AUG");
	fullWeaponName.SetString("m249", "M249");
	fullWeaponName.SetString("negev", "Negev");
	fullWeaponName.SetString("scar20", "Scar-20");
	fullWeaponName.SetString("g3sg1", "G3SG1");
	
	fullWeaponName.SetString("cz75a", "CZ-75");
	fullWeaponName.SetString("usp_silencer", "USP-S");
	fullWeaponName.SetString("usp_silencer_off", "USP-S");
	fullWeaponName.SetString("deagle", "Deagle");
	fullWeaponName.SetString("revolver", "Revolver");
	fullWeaponName.SetString("glock", "Glock");
	fullWeaponName.SetString("p250", "P250");
	fullWeaponName.SetString("hkp2000", "P2000");
	fullWeaponName.SetString("tec9", "TEC-9");
	fullWeaponName.SetString("fiveseven", "FiveSeven");
	fullWeaponName.SetString("elite", "Dwie Berrety");
	
	if (!fullWeaponName.GetString(weapon, fullName, sizeof(fullName)))
	{
		Format(fullName, sizeof(fullName), weapon);
	}
	
	CPrintToChat(client, "%t","DeathInfo_Dead", attacker, fullName);
	CPrintToChat(client, "%t","DeathInfo_Hp", GetClientHealth(attacker));
	if (asyster)
	{
		CPrintToChat(client, "%t","DeathInfo_Assist", asyster);
	}
}

bool IsValidClient(int client)
{
	if (client <= 0 || client > MaxClients) {
		return false;
	}
	
	if (!IsClientInGame(client)) {
		return false;
	}
	
	if (IsFakeClient(client)) {
		return false;
	}
	
	return true;
} 