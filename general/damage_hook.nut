local refs = [];

function OnScriptHook_OnTakeDamage(params)
{
    if (params.attacker.GetClassname() != "player")
        return;

    if (params.const_entity.GetClassname() == "func_button") {
        TryToPressButton(params.attacker, params.const_entity);
        return;
    }

    foreach (ref in refs) {
        if (ref.instance == null)
            continue;

        foreach (hitbox_ent in ref.instance.HitBoxes) {
            if (hitbox_ent == params.const_entity) {
                ref.instance[ref.method](params);
                return;
            }
        }
    }
}

Listen <- function (instance, method) {
    refs.append(RefToMethod(instance, method));
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