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

can_add_items <- false;
SetupItems <- function() {
    Items <- [];
    EntWatch <- {}; IncludeScript("ze_lib/gamemode/ent_watch", EntWatch);

    ::SlowTimer.Connect(EntWatch, "UpdateText");
    ::FastTimer.Connect(PlayerLogic, "CheckInputsOfItemUsers");

    can_add_items = true;
}

function OnPostSpawn() {
    StageLogic.Start();
    ClientPrint(null, 3, "[MAP] This map uses 'ze_lib'!\nYou can contribute to the development and insult me at  https://github.com/Thetan-ILW/ze_lib ");
}

::Main <- this;

