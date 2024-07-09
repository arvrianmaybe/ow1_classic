#!mainFile "../../dev_main.opy"

#!include "heroes/soldier/sprint.opy"

rule "[soldier/init.opy]: Initialize Soldier: 76":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer._call_init

    setCustomHp(SOLDIER_HEALTH, 0, 0)
    setUltCost(SOLDIER_ULT_COST)
    removeSelfHealing()
    eventPlayer._call_init = false

rule "[soldier/init.opy]: Deal OW1 soldier primary fire damage":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE/OW2_SOLDIER_HEAVY_PULSE_RIFLE_DAMAGE)-eventDamage)