class Text {
    entity = null;

    function Update(message) {
        NetProps.SetPropString(entity, "m_iszMessage", message);
    }

    function Display() {
        EntFireByHandle(entity, "Display", null, 0.0, null, null);
    }
}

class PreGameText extends Text {
    constructor() {
        entity = SpawnEntityFromTable("game_text", {
            X = "-1",
            Y = "0.1",
            Channel = 3,
            message = "Waiting for players. Game starts in 30 seconds."
            Color = Vector(204, 204, 204),
            Effect = "0",
            FadeIn = "0.2",
            FadeOut = "0.2",
            HoldTime = "1",
            spawnflags = 1
        });
    }

    function Update(time_to_end) {
        NetProps.SetPropString(
            entity,
            "m_iszMessage",
            format("Waiting for players. Game starts in %i seconds.", time_to_end)
        );
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