local entities = [];

local bullet_damage = 1;
local blast_damage = 7;

local rocket_damage_type = 2359360;
local pipe_damage_type = 262208;
local sticky_damage_type = 2490432;

function OnTakeDamage(params)
{
    local ent = null;

    foreach (entity in entities) {
        if (params.const_entity != entity.self)
            continue;

        ent = entity;
        break;
    }

    if (ent == null)
        return;

    if (params.attacker.GetClassname() != "player")
        return;

    ent.ProcessDamageEvent(params);
}

function ListenToDamage(ent) {
    entities.append(ent);
}

ListenToDamage(this, "OnTakeDamage");