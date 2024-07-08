#!mainFile "../../dev_main.opy"

#!include "heroes/hanzo/scatter.opy"
#!include "heroes/hanzo/dragon.opy"

rule "[hanzo/init.opy]: Initialize Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer._call_init

    setCustomHp(HANZO_HEALTH, 0, 0)
    setUltCost(HANZO_ULT_COST)
    removeSelfHealing()
    eventPlayer._call_init = false


rule "[hanzo/init.opy]: Deal OW1 primary fire damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1]

    damage(victim, attacker, eventDamage*(HANZO_ARROW_DAMAGE/OW2_HANZO_ARROW_DAMAGE)-eventDamage)
