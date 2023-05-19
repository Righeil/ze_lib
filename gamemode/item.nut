class Item {
    user = null;
    user_scope = null;
    item_ent = null;
    pick_up_ent = null;

    name = null;
    team = null;

    can_be_dropped = false;
    destroy_on_drop = false;
    has_dropped = false;

    cooldown = 0.0;
    last_use_time = 0.0;

    limited_uses = false;
    uses = 0;
    max_num_of_uses = 0;

    constructor(){
        ::Events.Connect("player_death", this, "PlayerDeath");
        last_use_time = Time() - cooldown;
    }

    function SetUser() {
        if (activator.GetTeam() != team)
            return false;

        foreach (item in ::Items) {
            if (item.user == activator)
                return false;
        }

        EntFireByHandle(pick_up_ent, "Disable", null, 0.0, null, null);

        user = activator;
        user_scope = user.GetScriptScope();
        user_scope.item = this;

        item_ent.SetOrigin(user.GetOrigin());
        item_ent.SetAbsAngles(user.GetAbsAngles());

        EntFireByHandle(item_ent, "SetParent", "!activator", 0.0, user, null);

        ClientPrint(user, 4, "Call for medic to use, press M3 (middle button on mouse) to drop.");

        return true;
    }

    function Use() {}

    function AllowedToUse() {
        if (limited_uses)
            if (uses == max_num_of_uses)
                return false;

        if (Time() < last_use_time + cooldown)
            return false;

        last_use_time = Time();
        uses += 1;

        return true;
    }

    function Drop(player_died) {
        if (!can_be_dropped && !player_died)
            return;

        EntFireByHandle(item_ent, "ClearParent", null, 0.0, null, null);

        user_scope.item = null;
        user_scope = null;
        user = null;

        if (destroy_on_drop) {
            ::Events.Disconnect("player_death", this, "PlayerDeath");
            item_ent.Kill();
            OnDrop();
            return;
        }

        EntFireByHandle(pick_up_ent, "Enable", null, 1.5, null, null);
        OnDrop();
    }

    function OnDrop() {}

    function PlayerDeath(event_data) {
        if (user == null)
            return;

        if (event_data.death_flags == 32) // 32 == cheated death
            return;

        if (user_scope.userid == event_data.userid)
            Drop(true);
    }

    function ToEntWatchString() {
        local time = last_use_time + cooldown - Time();
        local cooldown = "R";

        if (time > 0)
            cooldown = format("%i", time);

        return format("%s[%s] %s\n", name, cooldown, user.GetScriptScope().name);
    }
}