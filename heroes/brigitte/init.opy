#!mainFile "../../dev_main.opy"

#!include "heroes/brigitte/bash.opy"
#!include "heroes/brigitte/repair.opy"
#!include "heroes/brigitte/rally.opy"
#!include "heroes/brigitte/inspire.opy"

/*
This 2018 Brigitte workshop script is heavily based on
https://workshop.codes/MR5QJ       code: MR5QJ
created by oreoslurpee 
*/

rule "[brigitte/init.opy]: Initialize Brigitte":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer._call_init

    setCustomHp(BRIGITTE_HEALTH, BRIGITTE_ARMOR, 0)
    setUltCost(BRIGITTE_ULT_COST)

    setBaseDamage(eventPlayer, BRIGITTE_FLAIL_DAMAGE/OW2_BRIGITTE_FLAIL_DAMAGE)

    removeSelfHealing()
    eventPlayer._call_init = false

rule "[brigitte/init.opy]: Clean up brigitte":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.BRIGITTE
    
    waitUntil(eventPlayer.getCurrentHero() != Hero.BRIGITTE, Math.INFINITY)
    endRally()


rule "[brigitte/init.opy]: Compensate Brigitte global damage reduction":
    @Event playerDealtDamage
    @Hero brigitte
    @Condition eventAbility in [Button.ABILITY_1]

    damage(victim, attacker, (eventDamage/eventPlayer._base_damage_scalar - eventDamage)/eventPlayer._base_damage_scalar)