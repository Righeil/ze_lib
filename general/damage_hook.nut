local bosses = [];

function OnScriptHook_OnTakeDamage(params)
{
    if (params.attacker.GetClassname() != "player")
        return;

    if (params.const_entity.GetClassname() == "func_button") {
        TryToPressButton(params.attacker, params.const_entity);
        return;
    }

    foreach (boss in bosses) {
        foreach (hitbox_ent in boss.hitboxes) {
            if (hitbox_ent == params.const_entity) {
                boss.TakeDamage(params);
                return;
            }
        }
    }
}

AddBoss <- function(instance) {
    bosses.append(instance);
}

RemoveBoss <- function(instance) {
    local index_to_remove = -1;

    for (local i = 0; i != bosses.len(); i++) {
        if (bosses[i] != instance)
            continue;

        index_to_remove = i;
        return;
    }
}

function TryToPressButton(player, button) {
    local a = player.GetOrigin();
    local b = button.GetOrigin();

    local difference = Vector(
        a.x - b.x,
        a.y - b.y,
        a.z - b.z
    );

    local distance = sqrt(
        pow(difference.x, 2.0) +
        pow(difference.y, 2.0) +
        pow(difference.z, 2.0)
    );

    if (distance < 160.0)
        EntFireByHandle(button, "PressIn", null, 0.0, null, null);
}

__CollectGameEventCallbacks(this);