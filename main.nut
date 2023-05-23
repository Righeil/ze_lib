ClearGameEventCallbacks();

SendToServerConsole("mp_waitingforplayers_cancel 1");

IncludeScript("ze_lib/general/enums");
IncludeScript("ze_lib/general/ref");
IncludeScript("ze_lib/general/event");
IncludeScript("ze_lib/general/timer");

DamageHook <- {}; IncludeScript("ze_lib/general/damage_hook", DamageHook);
Commands <- {}; IncludeScript("ze_lib/commands/commands", Commands);

PlayerLogic <- {}; IncludeScript("ze_lib/logic/player", PlayerLogic);
AudioLogic <- {}; IncludeScript("ze_lib/logic/audio", AudioLogic);
StageLogic <- {}; IncludeScript("ze_lib/logic/stage", StageLogic);

::SlowTimer <- Timer(1);
::FastTimer <- Timer(0.01);

EntWatch <- {};

if (::MapSettings.map_has_items) {
    ::Items <- [];
    IncludeScript("ze_lib/gamemode/ent_watch", EntWatch);

    ::SlowTimer.Connect(EntWatch, "UpdateText");
    ::FastTimer.Connect(PlayerLogic, "CheckInputsOfItemUsers");
}

function OnPostSpawn() {
    StageLogic.Start();
}

::Main <- this;