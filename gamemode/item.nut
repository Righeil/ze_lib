class Item {
    name = null;
    team = null;
    cooldown = 0.0;
    limited_uses = false;
    max_num_of_uses = 0;
    show_in_ent_watch = true;

    uses = 0;
    user = null;
    user_scope = null;

    _flag_ent = null;
    _tie_ent = null;
    _last_use_time = 0.0;

    constructor(entity) {
        _flag_ent = entity;

        // In hammer, parent any entity to _tie_ent that should be parented to item.
        // And also you should parent item_teamflag to _tie_ent, we need to get handle of it.
        // Its the only reason we parent it to _tie_ent.
        _tie_ent = _flag_ent.GetMoveParent();

        // We need to do it this way, because if you parent solid object OR trigger to item_teamflag,
        // you can just pick up the intel by touching those objects.
        // So just unparent item_teamflag from _tie_ent
        EntFireByHandle(_flag_ent, "ClearParent", null, 0.0, null, null);

        _last_use_time = Time() - cooldown;

        NetProps.SetPropBool(_flag_ent, "m_bGlowEnabled", false)
        NetProps.SetPropInt(_flag_ent, "m_fEffects", 129);
        NetProps.SetPropInt(_tie_ent, "m_fEffects", 129);

        _flag_ent.ConnectOutput("OnPickup", "SetUser");
        _flag_ent.ConnectOutput("OnDrop", "Drop");

        if (team) return;

        local team_num = NetProps.GetPropInt(_flag_ent, "m_iTeamNum");

        switch (team_num) {
            case 2: team = Team.Zombozo; break;
            case 3: team = Team.Human; break;
            default:
                printl("You should set the correct team for the flag entity:" + _flag_ent);
                break;
        }
    }

    function SetUser() {
        _flag_ent.SetModelScale(0.0, 0.0);

        // m_hPrevOwner always contains the player handle who picked up the item.
        user = NetProps.GetPropEntity(_flag_ent, "m_hPrevOwner");
        user_scope = user.GetScriptScope();
        user_scope.item = this;

        // This method is called after the player has picks up the item. Its already attached to the player's spine.
        // Just parent it to the player to get the correct collision and view.
        EntFireByHandle(_flag_ent, "SetParent", "!activator", 0.0, user, null);
        _flag_ent.SetLocalOrigin(Vector(0, 0, 0));
        _flag_ent.SetLocalAngles(QAngle(0, 0, 0));

        // Since each entity is parented to the _tie_ent, we need to parent _tie_ent to item_teamflag,
        // everything would be broken if we parent it to player, as i recall.
        _tie_ent.SetOrigin(user.GetOrigin());
        _tie_ent.SetAbsAngles(user.GetAbsAngles());
        EntFireByHandle(_tie_ent, "SetParent", "!activator", 0.0, _flag_ent, null);

        ClientPrint(user, 4, "Press E to use, press L to drop.");
    }

    function TryToUse() {
        if (limited_uses) {
            if (Time() < _last_use_time + 0.1)
                return;

            if (uses == max_num_of_uses)
                return;

            uses += 1;
        }

        if (Time() < _last_use_time + cooldown)
            return;

        _last_use_time = Time();

        local angle = user.EyeAngles();
        angle.x = 0;
        angle.z = 0;
        _flag_ent.SetAbsAngles(angle);

        Use();
    }

    function Use() {}

    function Drop() {
        // This is the only way that works to set the origin of _tie_ent to _flag_ent.
        EntFireByHandle(_tie_ent, "SetParent", "!activator", 0.0, _flag_ent, null);
        EntFireByHandle(_tie_ent, "ClearParent", null, 0.0, null, null);

        _flag_ent.SetModelScale(1.0, 0.25);

        // We are not playing CTF here.
        local icon = Entities.FindByClassname(null, "item_teamflag_return_icon");
        if (icon)
            icon.Kill();

        user_scope.item = null;
        user_scope = null;
        user = null;

        if (team == Team.Zombozo) {
            _tie_ent.Kill();
            _flag_ent.Kill();
            return;
        }
    }

    function GetEntWatchString() {
        local time = _last_use_time + cooldown - Time();
        local cooldown = "R";

        if (time > 0)
            cooldown = format("%i", time);

        return format("%s[%s]: %s\n", name, cooldown, user_scope.name);
    }
}

instance <- null;

CreateItem <- function(item_instance) {
    if (!::Main.can_add_items)
        ::Main.SetupItems();

    instance = item_instance;
    ::Main.Items.append(instance);
}

SetUser <- @() instance.SetUser();
Drop <- @() instance.Drop();
