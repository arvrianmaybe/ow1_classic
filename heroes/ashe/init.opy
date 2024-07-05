#!mainFile "../../dev_main.opy"

#!include "heroes/ashe/bob.opy"

rule "[ashe/init.opy]: Initialize Ashe":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer._call_init

    setCustomHp(ASHE_HEALTH, 0, 0)
    setUltCost(ASHE_ULT_COST)
    removeSelfHealing()
    
    setBaseDamage(eventPlayer, ASHE_BOB_DAMAGE/OW2_ASHE_BOB_DAMAGE)
    eventPlayer._call_init = false


rule "[ashe/init.opy]: Compensate Ashe global damage reduction":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.ABILITY_1, Button.ABILITY_2]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)