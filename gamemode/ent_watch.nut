IncludeScript("ze_lib/general/text");

local ent_watch_text = EntWatchText();

function UpdateText() {
    local active_items = [];

    foreach (item in ::Items) {
        if (item.user != null)
            active_items.append(item);
    }

    local str = "";
    local line_count = 0;

    foreach (item in active_items) {
        if (!item.ShowInEntWatch)
            continue;

        str += item.GetEntWatchString();
        line_count += 1;
    }

    ent_watch_text.Update(str);
    ent_watch_text.SetY(0.5 - (line_count * 0.0225));

    for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
    {
        local player = PlayerInstanceFromIndex(i);

        if (player == null)
            continue;

        if (player.GetScriptScope().show_entwatch)
            ent_watch_text.Display(player);
    }
}