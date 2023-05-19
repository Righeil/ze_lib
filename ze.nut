ClearGameEventCallbacks();
SendToServerConsole("mp_waitingforplayers_cancel 1");

IncludeScript("ze_lib/general/ref");
IncludeScript("ze_lib/general/event");
IncludeScript("ze_lib/general/timer");
IncludeScript("ze_lib/general/enums");
IncludeScript("ze_lib/general/hook");
IncludeScript("ze_lib/commands/commands");

enum Team {
    Zombozo = 2,
    Human = 3
}

local admin_steam_id = [
    "[U:1:861070160]",
    "[U:1:125329043]",
];

function PlayerSpawned(event_data) {
    local player = GetPlayerFromUserID(event_data.userid);

    player.ValidateScriptScope();
    local player_scope = player.GetScriptScope();

    player_scope.userid <- event_data.userid;
    player_scope.name <- NetProps.GetPropString(player, "m_szNetname");
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
        if (id == NetProps.GetPropString(player, "m_szNetworkIDString"))
            player_scope.is_admin = true;
    }

    if (!("show_entwatch" in player_scope))
        player_scope.show_entwatch <- true;

    player.SetModelScale(::MapSettings.player_scale, 0.0);
}

function PlayerDisconnect(event) {
    foreach (item in ::Items) {
        if (!item.user)
            continue;

        if (item.user_scope.userid == event.userid)
            item.Drop(true);
    }
}

::StopSound <- function(event = null) {
    local ent = null;
    while (ent = Entities.FindByClassname(ent, "ambient_generic")) {
        EntFireByHandle(ent, "Volume", "0", 0.0, null, null);
    }
}

::Events.Connect("teamplay_restart_round", this, "StopSound");
::Events.Connect("teamplay_round_win", this, "StopSound");
::Events.Connect("teamplay_round_restart_seconds", this, "StopSound");

::Events.Connect("player_spawn", this, "PlayerSpawned");
::Events.Connect("player_disconnect", this, "PlayerDisconnect");

if (::MapSettings.map_has_items)
    ::Items <- {};

local root = getroottable();

if (!("stage" in root))
    root.stage <- 0;

::Timer1S <- Timer(1);