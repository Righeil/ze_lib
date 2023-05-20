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

    player_scope.CheckInputs <- function () {
        local button = NetProps.GetPropInt(self, "m_nButtons");
        local wanna_use = self.GetTimeSinceCalledForMedic() < 0.15;

        if (wanna_use)
            UseItem();

        if (button & 33554432) // M3
            DropItem();
    }

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

function CheckInputsOfItemUsers() {
    foreach (item in ::Items) {
        if (item.user == null)
            return;

        local user_scope = item.user_scope;
        user_scope.CheckInputs();
    }
}

::Events.Connect("player_spawn", this, "PlayerSpawned");
::Events.Connect("player_disconnect", this, "PlayerDisconnect");