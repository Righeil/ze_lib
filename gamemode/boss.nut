class Boss {
    max_hp = 0.0;
    hp = 0.0;
    scale_value = 0.0;

    hitboxes = [];

    hp_bar = {};

    top_damage = {};

    function Start() {
        IncludeScript("ze_lib/gamemode/hp_bar", hp_bar);
        max_hp = hp;
        hp_bar.SetPercent(1);
        ::Main.DamageHook.AddBoss(this);
    }

    function Stop() {
        ::Main.DamageHook.RemoveBoss(this);
        hp_bar.Hide();

        local text = {}; IncludeScript("ze_lib/general/text", text);
        local top_damage_text = text.TopDamageText();

        top_damage_text.Update(top_damage);
        top_damage_text.Display();
        top_damage_text.Kill();
    }

    function TakeDamage(params) {
        local damage = params.damage / 12.0
        hp -= damage;

        if (hp < 1)
            return Stop();

        local player_index = params.attacker.entindex();

        if (!top_damage.rawin(player_index))
            top_damage[player_index] <- 0;

        top_damage[player_index] += damage;

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

instance <- null;

Start <- @() instance.Start();
Stop <- @() instance.Stop();