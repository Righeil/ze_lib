class Text {
    entity = null;

    function Update();
    function Display() {
        EntFireByHandle(entity, "Display", null, 0.0, null, null);
    }
}

class EntWatchText extends Text {
    constructor() {
        entity = SpawnEntityFromTable("game_text", {
            targetname = "ent_watch_text",
            X = "0.01",
            Y = "0.5",
            Channel = 5,
            Color = Vector(204, 204, 204),
            Effect = "0",
            FadeIn = "0.2",
            FadeOut = "0.2",
            HoldTime = "1",
            spawnflags = 0
        });
    }

    function Update(message) {
        entity.__KeyValueFromString("message",
            message
        );
    }

    function Display(player) {
        EntFireByHandle(entity, "Display", null, 0.0, player, null);
    }

    function SetY(y) {
        entity.__KeyValueFromFloat("y", y);
    }
}