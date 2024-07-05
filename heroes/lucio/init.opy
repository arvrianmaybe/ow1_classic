#!mainFile "../../dev_main.opy"

#!include "heroes/lucio/soundwave.opy"
#!include "heroes/lucio/aura.opy"
#!include "heroes/lucio/sound_barrier.opy"

rule "[lucio/init.opy]: Initialize Lucio":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer._call_init

    
    setCustomHp(LUCIO_HEALTH, 0, 0)
    setUltCost(LUCIO_ULT_COST)
    removeSelfHealing()

    lucioAura()

    eventPlayer.setKnockbackDealt(percent(LUCIO_SOUNDWAVE_KNOCKBACK/OW2_LUCIO_SOUNDWAVE_KNOCKBACK))
    eventPlayer._call_init = false


rule "[lucio/init.opy]: OW1 Sonic Amplifier damage":
    @Event playerDealtDamage
    @Hero lucio
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, eventDamage*(LUCIO_SOUND_GUN_DAMAGE/OW2_LUCIO_SOUND_GUN_DAMAGE) - eventDamage)

rule "[lucio/init.opy]: Clean up Lucio":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == Hero.LUCIO

    waitUntil(eventPlayer.getCurrentHero() != Hero.LUCIO, Math.INFINITY)

    cleanUpAura()