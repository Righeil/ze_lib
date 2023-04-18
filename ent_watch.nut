IncludeScript("ze_lib/text");

::EntWatch <- {};

local ent_watch_text = EntWatchText();

::EntWatch.UpdateText <- function() {
    local active_items = [];

    foreach (item in ::Items) {
        if (item.user != null)
            active_items.append(item);
    }

    local str = "";
    local line_count = 0;

    foreach (item in active_items) {
        local time = item.last_use_time + item.cooldown - Time();
        local cooldown = "R";

        if (time > 0)
            cooldown = format("%i", time);

        str += format("%s[%s] %s\n", item.name, cooldown, item.user.GetScriptScope().name);
        line_count += 1;
    }

    ent_watch_text.Update(str);
    ent_watch_text.SetY(0.5 - (line_count * 0.025));

    for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
    {
        local player = PlayerInstanceFromIndex(i);

        if (player == null)
            continue;

        if (player.GetScriptScope().show_entwatch)
            ent_watch_text.Display(player);
    }

}