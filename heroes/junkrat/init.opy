#!mainFile "../../dev_main.opy"

#!include "heroes/junkrat/mine.opy"

rule "[junkrat/init.opy]: Initialize Junkrat":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer._call_init

    eventPlayer.setMaxHealth(percent((JUNKRAT_HEALTH-JUNKRAT_TIRE_HEALTH)/(OW2_JUNKRAT_HEALTH-OW2_JUNKRAT_TIRE_HEALTH)))
    eventPlayer.addHealthPool(Health.NORMAL, 
                              JUNKRAT_HEALTH - (JUNKRAT_HEALTH-JUNKRAT_TIRE_HEALTH)/(OW2_JUNKRAT_HEALTH-OW2_JUNKRAT_TIRE_HEALTH)*OW2_JUNKRAT_HEALTH, 
                              true, 
                              false)
    setUltCost(JUNKRAT_ULT_COST)
    removeSelfHealing()

    setBaseDamage(eventPlayer, JUNKRAT_FRAG_LAUNCHER_DAMAGE/OW2_JUNKRAT_FRAG_LAUNCHER_DAMAGE)

    eventPlayer._call_init = false


rule "[junkrat/init.opy]: Correct Mine, Tire damage":
    @Event playerDealtDamage
    @Hero junkrat
    @Condition eventAbility in [Button.ABILITY_1, Button.ULTIMATE]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)
