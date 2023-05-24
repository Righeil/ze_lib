class Text {
    entity = null;

    function Update(message) {
        NetProps.SetPropString(entity, "m_iszMessage", message);
    }

    function Display() {
        EntFireByHandle(entity, "Display", null, 0.0, null, null);
    }

    function Kill() {
        entity.Kill();
    }
}

class EntWatchText extends Text {
    constructor() {
        entity = SpawnEntityFromTable("game_text", {
            X = "0.01",
            Y = "0.5",
            Channel = 4,
            Color = Vector(204, 204, 204),
            Effect = "0",
            FadeIn = "0.2",
            FadeOut = "0.2",
            HoldTime = "1",
            spawnflags = 0
        });
    }

    function Display(player) {
        EntFireByHandle(entity, "Display", null, 0.0, player, null);
    }

    function SetY(value) {
        NetProps.SetPropFloat(entity, "m_textParms.y", value);
    }
}

class TopDamageText extends Text {
    constructor() {
        entity = SpawnEntityFromTable("game_text", {
            X = "-1",
            Y = "0.7",
            Channel = 3,
            Color = Vector(171, 249, 255),
            Effect = "0",
            FadeIn = "0.5",
            FadeOut = "0.5",
            HoldTime = "5",
            spawnflags = 1
        });
    }

    function Update(top_damage) {
        local sorted = SortTableByValue(top_damage);

        local str = "==== TOP DAMAGE ====";

        local rows = 4;
        local i = 0;
        foreach (entindex, damage in sorted) {
            if (i == rows) break;
            i += 1;

            local player_name = PlayerInstanceFromIndex(entindex).GetScriptScope().name;
            str += format("\n%s: %i", player_name, damage);
        }

        NetProps.SetPropString(entity, "m_iszMessage", str);
    }

    function SortTableByValue(table) {
        local keys = table.keys();
        local values = table.values();

        for (local i = 0; i < keys.len(); i++) {
            for (local j = i + 1; j < keys.len(); j++) {
                if (values[i] < values[j]) {
                    local _i = values[i];
                    local _j = values[j];
                    values[i] = _j;
                    values[j] = _i;
                    local _i_key = keys[i];
                    local _j_key = keys[j];
                    keys[i] = _i_key;
                    keys[j] = _j_key;
                }
            }
        }

        local sorted_table = {};

        for (local i = 0; i < keys.len(); i++) {
            sorted_table[keys[i]] <- values[i];
        }

        return sorted_table;
    }
}

