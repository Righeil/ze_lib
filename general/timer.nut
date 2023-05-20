class Timer {
    entity = null;
    scope = null;

    constructor(refire_time) {
        entity = SpawnEntityFromTable("logic_timer", {
            RefireTime = refire_time.tostring(),
            StartDisabled = "0"
        })

        entity.ValidateScriptScope();
        scope = entity.GetScriptScope();
        scope.references <- [];
        scope.Tick <- function () {
            foreach (ref in references) {
                ref.instance[ref.method]();
            }
        }

        entity.ConnectOutput("OnTimer", "Tick");
    }

    function Connect(instance, method) {
        scope.references.append(RefToMethod(instance, method));
    }
}