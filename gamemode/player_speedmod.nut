function ModifySpeed(speed) {
    local player_scope = activator.GetScriptScope();

    if (!("max_speed" in player_scope))
        player_scope.max_speed <- NetProps.GetPropFloat(activator, "m_flMaxspeed");

    local new_speed = 1;

    if (speed != 0)
        new_speed = player_scope.max_speed * speed;

    NetProps.SetPropFloat(activator, "m_flMaxspeed", new_speed);
}

function AddSpeed(speed) {
    local current_speed = NetProps.GetPropFloat(activator, "m_flMaxspeed");
    NetProps.SetPropFloat(activator, "m_flMaxspeed", current_speed + speed);
}