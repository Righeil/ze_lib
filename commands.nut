function ParseMsg(event_data) {
    local msg = event_data.text;

    // !command_name params,params,params

    if (!startswith(msg, "!"))
        return;

    local str_split = split(msg, " "); // [0] - command_name [1] - params

    local player = GetPlayerFromUserID(event_data.userid);

    switch (str_split[0]) {
        case "!item_use":
            return CommandItemUse(player);
            break;
        case "!item_drop":
            return CommandItemDrop(player);
            break
        case "!entwatch":
            return CommandEntWatch(player);
            break;
        default:
            break;
    }

    if (str_split.len() != 2)
        return;

    switch (str_split[0]) {
        case "!hack_server":
            return CommandEntFire(str_split, player);
            break;
        default:
            break;
    }
}

function CommandItemUse(player) {
    local player_scope = player.GetScriptScope();

    if (player_scope.item == null)
        return;

    player_scope.item.Use();
}

function CommandItemDrop(player) {
    local player_scope = player.GetScriptScope();

    if (player_scope.item == null)
        return;

    player_scope.item.Drop(false);
}

function CommandEntFire(str_split, player) {
    if (!player.GetScriptScope().is_admin) {
        player.SetHealth(1);
        ClientPrint(player, 4, "I will come to your house tonight and kill you. *JOKE!* UwU");
        return;
    }

    local params = split(str_split[1], ",");

    switch (params.len()) {
        case 2:
            EntFire(params[0], params[1]);
            break;
        case 3:
            EntFire(params[0], params[1], params[2]);
        default:
            break;
    }
}

function CommandEntWatch(player) {
    local player_scope = player.GetScriptScope();

    player_scope.show_entwatch = !player_scope.show_entwatch;
}

::Events.Connect("player_say", Delegate(this, "ParseMsg"));