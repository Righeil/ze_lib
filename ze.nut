ClearGameEventCallbacks()

IncludeScript("ze_lib/event");
IncludeScript("ze_lib/commands");

enum Team {
    Zombozo = 2,
    Human = 3
}

local admin_steam_id = [
    "[U:1:861070160]"
];

local root = getroottable();

if (!("player_info" in root))
    root.player_info <- {};

function PlayerConnected(event_data) {
    root.player_info[event_data.userid] <- event_data;
}

function PlayerSpawned(event_data) {
    local player = GetPlayerFromUserID(event_data.userid);

    NetProps.SetPropString(player, "m_iName", "");

    player.ValidateScriptScope();
    local player_scope = player.GetScriptScope();

    player_scope.userid <- event_data.userid;
    player_scope.name <- root.player_info[event_data.userid].name;
    player_scope.item <- null;
    player_scope.UseItem <- function () {
        if (item == null)
            return;

        item.Use();
    }

    player_scope.DropItem <- function () {
        if (item == null)
            return;

        item.Drop(false);
    }

    player_scope.is_admin <- false;

    foreach (id in admin_steam_id) {
        if (id == root.player_info[event_data.userid].networkid)
            player_scope.is_admin = true;
    }

    if (!("show_entwatch" in player_scope))
        player_scope.show_entwatch <- true;
}



local ent = null;

while (ent = Entities.FindByClassname(ent, "ambient_generic")) {
    EntFireByHandle(ent, "Volume", "0", 0.0, null, null);
}

::Events.Connect("player_connect", Delegate(this, "PlayerConnected"))
::Events.Connect("player_spawn", Delegate(this, "PlayerSpawned"))