StopSound <- function(event = null) {
    local ent = null;
    while (ent = Entities.FindByClassname(ent, "ambient_generic")) {
        EntFireByHandle(ent, "Volume", "0", 0.0, null, null);
    }
}

::Events.Connect("teamplay_restart_round", this, "StopSound");
::Events.Connect("teamplay_round_win", this, "StopSound");
::Events.Connect("teamplay_round_restart_seconds", this, "StopSound");