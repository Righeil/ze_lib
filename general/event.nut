::Events <- {
    function Connect(event_name, instance, method) {
        if (!(event_name in this)) {
            this[event_name] <- {
                references = [],
                collected = false,

                ["OnGameEvent_" + event_name] = function(event_data) {
                    foreach (ref in references) {
                        ref.instance[ref.method](event_data)
                    }
                }
            }
        }

        local event_table = this[event_name];

        if (!event_table.collected) {
            __CollectGameEventCallbacks(event_table);
            event_table.collected = true;
        }

        event_table.references.append(RefToMethod(instance, method));
    }

    function Disconnect(event_name, instance, method) {
        local index_to_remove = -1;

        if (!(event_name in this)) {
            printf("[event.nut | Disconnect] Nothing connected to the event %s, there is nothing to disconnect.\n", event_name);
            return;
        }

        foreach (i, ref in this[event_name].references) {
            if (method == ref.method && instance == ref.instance) {
                index_to_remove = i;
                break;
            }
        }

        if (index_to_remove == -1) {
            printl("[event.nut | Disconnect] Trying to remove a pointer (but it does not exist) from the pointer list, this will not work you idiot!");
            return;
        }

        this[event_name].references.remove(index_to_remove);
    }
};