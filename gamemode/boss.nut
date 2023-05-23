class Boss {
    HitBoxes = [];

    max_hp = 0.0;
    hp = 0.0;
    scale_value = 0.0;

    hp_bar = {};

    function Start() {
        IncludeScript("ze_lib/gamemode/hp_bar", hp_bar);
        max_hp = hp;
        hp_bar.SetPercent(1);
    }

    function Stop() {
        hp_bar.Hide();
        HitBoxes.clear();
    }

    function TakeDamage(params) {
        hp -= event.damage / 12.0;

        if (hp < 1)
            return Stop();

        hp_bar.SetPercent(hp / max_hp);
    }

    function AddHp(value) {
        hp += value;
        UpdateMaxHp()
    }

    function MultiplyHp(value) {
        hp *= value;
        UpdateMaxHp()
    }

    function ScaleHp() {
        hp += scale_value;
        UpdateMaxHp()
    }

    function UpdateMaxHp() {
        if (hp > max_hp)
            max_hp = hp;
    }
}