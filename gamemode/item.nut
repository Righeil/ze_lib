class Item {
    Name = null;
    Cooldown = 0.0;
    LimitedUses = false;
    MaxNumOfUses = 0;
    ShowInEntWatch = true;

    uses = 0;
    user = null;
    user_scope = null;

    flag_ent = null;
    tie_ent = null;

    team = null;
    last_use_time = 0.0;

    constructor(entity) {
        flag_ent = entity;

        // In hammer, parent any entity to tie_ent that should be parented to item.
        // And also you should parent item_teamflag to tie_ent, we need to get handle of it.
        // Its the only reason we parent it to tie_ent.
        tie_ent = flag_ent.GetMoveParent();

        // We need to do it this way, because if you parent solid object OR trigger to item_teamflag,
        // you can just pick up the intel by touching those objects.
        // So just unparent item_teamflag from tie_ent
        EntFireByHandle(flag_ent, "ClearParent", null, 0.0, null, null);

        last_use_time = Time() - Cooldown;

        NetProps.SetPropBool(flag_ent, "m_bGlowEnabled", false)

        local team_num = NetProps.GetPropInt(flag_ent, "m_iTeamNum");

        switch (team_num) {
            case 2: team = Team.Zombozo; break;
            case 3: team = Team.Human; break;
            default:
                printl("You should set the correct team for the flag entity:" + flag_ent);
                break;
        }
    }

    function SetUser() {
        flag_ent.SetModelScale(0.0, 0.0);

        // m_hPrevOwner always contains the player handle who picked up the item.
        user = NetProps.GetPropEntity(flag_ent, "m_hPrevOwner");
        user_scope = user.GetScriptScope();
        user_scope.item = this;

        // This method is called after the player has picks up the item. Its already attached to the player's spine.
        // Just parent it to the player to get the correct collision and view.
        EntFireByHandle(flag_ent, "SetParent", "!activator", 0.0, user, null);
        flag_ent.SetLocalOrigin(Vector(0, 0, 0));
        flag_ent.SetLocalAngles(QAngle(0, 0, 0));

        // Since each entity is parented to the tie_ent, we need to parent tie_ent to item_teamflag,
        // everything would be broken if we parent it to player, as i recall.
        tie_ent.SetOrigin(user.GetOrigin());
        tie_ent.SetAbsAngles(user.GetAbsAngles());
        EntFireByHandle(tie_ent, "SetParent", "!activator", 0.0, flag_ent, null);

        ClientPrint(user, 4, "Press E to use, press L to drop.");
    }

    function TryToUse() {
        if (LimitedUses) {
            if (Time() < last_use_time + 0.1)
                return;

            if (uses == MaxNumOfUses)
                return;

            uses += 1;
        }

        if (Time() < last_use_time + Cooldown)
            return;

        last_use_time = Time();

        local angle = user.EyeAngles();
        angle.x = 0;
        angle.z = 0;
        flag_ent.SetAbsAngles(angle);

        Use();
    }

    function Use() {}

    function Drop() {
        // This is the only way that works to set the origin of tie_ent to flag_ent.
        EntFireByHandle(tie_ent, "SetParent", "!activator", 0.0, flag_ent, null);
        EntFireByHandle(tie_ent, "ClearParent", null, 0.0, null, null);

        flag_ent.SetModelScale(1.0, 0.25);

        // We are not playing CTF here.
        local icon = Entities.FindByClassname(null, "item_teamflag_return_icon");
        if (icon)
            icon.Kill();

        user_scope.item = null;
        user_scope = null;
        user = null;

        if (team == Team.Zombozo) {
            flag_ent.Kill();
            tie_ent.Kill();
            return;
        }
    }

    function GetEntWatchString() {
        local time = last_use_time + Cooldown - Time();
        local cooldown = "R";

        if (time > 0)
            cooldown = format("%i", time);

        return format("%s[%s] %s\n", Name, cooldown, user_scope.name);
    }
}

instance <- null;

CreateItem <- function(item_instance) {
    instance = item_instance;
    instance.flag_ent.ConnectOutput("OnPickup", "SetUser");
    instance.flag_ent.ConnectOutput("OnDrop", "Drop");
    ::Items.append(instance);
}

SetUser <- @() instance.SetUser();

Drop <- function() {
    if (NetProps.GetPropInt(instance.user, "m_lifeState") != 0)
        return instance.Drop(true);

    instance.Drop(false);
}