class Item {
    user = null;
    user_scope = null;

    name = null;
    team = null;
    item_ent = null;
    pick_up_ent = null;
    can_be_dropped = false;
    destroy_on_drop = false;

    constructor(){
        ::Events.Connect("player_death", Delegate(this, "PlayerDeath"))
    }

    function SetUser() {
        if (activator.GetTeam() != team)
            return;

        foreach (item in ::Items) {
            if (item.user == activator)
                return;
        }

        EntFireByHandle(pick_up_ent, "Disable", null, 0.0, null, null);

        user = activator;
        user_scope = user.GetScriptScope();
        user_scope.item = this;

        item_ent.SetOrigin(user.GetOrigin());
        item_ent.SetAbsAngles(user.GetAbsAngles());

        EntFireByHandle(item_ent, "SetParent", "!activator", 0.0, user, null);

        ClientPrint(user, 4, "Call for medic to use, press M3 (middle button on mouse) to drop.");

        OnPickUp();
    }

    function Use() {}

    function Drop(player_died) {
        if (!can_be_dropped && !player_died)
            return;

        EntFireByHandle(item_ent, "ClearParent", null, 0.0, null, null);

        user_scope.item = null;
        user_scope = null;
        user = null;

        if (destroy_on_drop) {
            ::Events.Disconnect("player_death", Delegate(this, "PlayerDeath"));
            item_ent.Kill();
            OnDrop();
            return;
        }

        EntFireByHandle(pick_up_ent, "Enable", null, 1.5, null, null);
        OnDrop();
    }

    function OnPickUp() {}
    function OnDrop() {}

    function PlayerDeath(event_data) {
        if (user == null)
            return;

        if (event_data.death_flags == 32) // 32 == cheated death
            return;

        if (user_scope.userid == event_data.userid)
            Drop(true);
    }
}