function ModifySpeed(speed) {
    local player_scope = activator.GetScriptScope();

    if (!("max_speed" in player_scope))
        player_scope.max_speed <- NetProps.GetPropFloat(activator, "m_flMaxspeed");

    NetProps.SetPropFloat(activator, "m_flMaxspeed", player_scope.max_speed * speed);
}

function AddSpeed(speed) {
    local current_speed = NetProps.GetPropFloat(activator, "m_flMaxspeed");
    NetProps.SetPropFloat(activator, "m_flMaxspeed", current_speed + speed);
}