class Timer {
    _entity = null;
    _scope = null;

    constructor(refire_time) {
        _entity = SpawnEntityFromTable("logic_timer", {
            RefireTime = refire_time.tostring(),
            StartDisabled = "0"
        })

        _entity.ValidateScriptScope();
        _scope = _entity.GetScriptScope();
        _scope.references <- [];
        _scope.Tick <- function () {
            foreach (ref in references) {
                ref.instance[ref.method]();
            }
        }

        _entity.ConnectOutput("OnTimer", "Tick");
    }

    function Connect(instance, method) {
        _scope.references.append(RefToMethod(instance, method));
    }
}