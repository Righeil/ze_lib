StageRelays <- [];

local root = getroottable();

if (!("stage" in root))
    root.stage <- 1;

function Set(value) {
    if (stage < 1)
        return;

    if (stage > StageRelays.len() + 1)
        return;

    root.stage = value
}

function Start() {
    if (StageRelays.len() == 0)
        return;

    local relay = StageRelays[root.stage - 1];
    EntFireByHandle(relay, "Trigger", null, 0.0, null, null);
}