#!mainFile "../../dev_main.opy"

rule "[sojourn/railgun.opy]: OW1 Railgun alt fire headshot damage":
    @Event playerDealtDamage
    @Hero sojourn
    @Condition eventAbility in [Button.SECONDARY_FIRE, Button.ULTIMATE]
    @Condition eventWasCriticalHit

    damage(victim, attacker, ((eventDamage/eventPlayer._base_damage_scalar)*(SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER/OW2_SOJOURN_RAILGUN_ALT_HEADSHOT_MULTIPLIER) - eventDamage)/eventPlayer._base_damage_scalar)
