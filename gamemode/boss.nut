class Boss {
    max_hp = 0.0;
    hp = 0.0;
    scale_value = 0.0;

    hitboxes = [];

    _hp_bar = {};
    _top_damage = {};

    function Start() {
        IncludeScript("ze_lib/gamemode/hp_bar", _hp_bar);
        max_hp = hp;
        _hp_bar.SetPercent(1);
        ::Main.DamageHook.AddBoss(this);
    }

    function Stop() {
        ::Main.DamageHook.RemoveBoss(this);
        _hp_bar.Hide();

        local text = {}; IncludeScript("ze_lib/general/text", text);
        local top_damage_text = text.TopDamageText();

        top_damage_text.Update(_top_damage);
        top_damage_text.Display();
        top_damage_text.Kill();
    }

    function TakeDamage(params) {
        local damage = params.damage / 12.0
        hp -= damage;

        if (hp < 1)
            return Stop();

        local player_index = params.attacker.entindex();

        if (!_top_damage.rawin(player_index))
            _top_damage[player_index] <- 0;

        _top_damage[player_index] += damage;

        _hp_bar.SetPercent(hp / max_hp);
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

instance <- null;

Start <- @() instance.Start();
Stop <- @() instance.Stop();