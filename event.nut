class ::Pointer {
    instance = null;
    method = null;

    constructor(instance, method){
        this.instance = instance;
        this.method = method;
    }
}

::Events <- {
    function Connect(event_name, ptr) {
        if (!(event_name in this)) {
            this[event_name] <- {
                pointers = [],
                collected = false,

                ["OnGameEvent_" + event_name] = function(event_data) {
                    foreach (ptr in pointers) {
                        ptr.instance[ptr.method](event_data)
                    }
                }
            }
        }

        local event_table = this[event_name];

        if (!event_table.collected) {
            __CollectGameEventCallbacks(event_table);
            event_table.collected = true;
        }

        event_table.pointers.append(ptr);
    }

    function Disconnect(event_name, ptr) {
        local index_to_remove = -1;

        if (!(event_name in this)) {
            printf("[event.nut | Disconnect] Nothing connected to the event %s, there is nothing to disconnect.\n", event_name);
            return;
        }

        foreach (i, inner_ptr in this[event_name].pointers) {
            if (ptr.method == inner_ptr.method && ptr.instance == inner_ptr.instance) {
                index_to_remove = i;
                break;
            }
        }

        if (index_to_remove == -1) {
            printl("[event.nut | Disconnect] Trying to remove a pointer (but it does not exist) from the pointer list, this will not work you idiot!");
            return;
        }

        this[event_name].pointers.remove(index_to_remove);
    }
};