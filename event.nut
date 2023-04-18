class ::Delegate {
    instance = null;
    method = null;

    constructor(instance, method){
        this.instance = instance;
        this.method = method;
    }
}

::Events <- {
    function Connect(event_name, delegate) {
        if (!(event_name in this)) {
            this[event_name] <- {
                delegates = [],
                collected = false,

                ["OnGameEvent_" + event_name] = function(event_data) {
                    foreach (delegate in delegates) {
                        delegate.instance[delegate.method](event_data)
                    }
                }
            }
        }

        local event_table = this[event_name];

        if (!event_table.collected) {
            __CollectGameEventCallbacks(event_table);
            event_table.collected = true;
        }

        event_table.delegates.append(delegate);
    }

    function Disconnect(event_name, delegate) {
        local index_to_remove = -1;

        if (!(event_name in this)) {
            printf("[event.nut | Disconnect] Nothing connected to the event %s, there is nothing to disconnect.\n", event_name);
            return;
        }

        foreach (i, value in this[event_name].delegates) {
            if (delegate.method == value.method && delegate.instance == value.instance) {
                index_to_remove = i;
                break;
            }
        }

        if (index_to_remove == -1) {
            printl("[event.nut | Disconnect] Trying to remove a delegate from the delegate list, this will not work you idiot!");
            return;
        }

        this[event_name].delegates.remove(index_to_remove);
    }
};