#!mainFile "../../dev_main.opy"

#!include "heroes/kiriko/kunai.opy"
#!include "heroes/kiriko/swift_step.opy"
#!include "heroes/kiriko/suzu.opy"

rule "[kiriko/init.opy]: Initialize Kiriko":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer._call_init

    setCustomHp(KIRIKO_HEALTH, 0, 0)
    setUltCost(KIRIKO_ULT_COST)
    removeSelfHealing()

    eventPlayer.setHealingDealt(percent(KIRKIO_OFUDA_HEALING/OW2_KIRIKO_OFUDA_HEALING))
    setBaseDamage(eventPlayer, (KIRIKO_KUNAI_HEADSHOT_DAMAGE/OW2_KIRIKO_KUNAI_HEADSHOT_DAMAGE))

    eventPlayer.setMaxAmmo(0, 6)
    eventPlayer.setAmmo(0, 12)

    eventPlayer._call_init = false

rule "[kiriko/init.opy]: Deal regular damage for any non custom damage":
    @Event playerDealtDamage
    @Hero kiriko
    @Condition eventAbility in [Button.MELEE]
    
    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)