#!mainFile "../../dev_main.opy"

rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer._call_init

    setCustomHp(TRACER_HEALTH, 0, 0)
    setUltCost(TRACER_ULT_COST)
    removeSelfHealing()
    setBaseDamage(eventPlayer, TRACER_PULSE_PISTOL_DAMAGE/OW2_TRACER_PULSE_PISTOL_DAMAGE)
    eventPlayer._call_init = false

rule "[tracer/init.opy]: OW1 Pulse Bomb damage":
    @Event playerDealtDamage
    @Hero tracer
    @Condition eventAbility == Button.ULTIMATE
    
    heal(victim, null, eventDamage - eventDamage*(TRACER_PULSE_BOMB_DAMAGE/OW2_TRACER_PULSE_BOMB_DAMAGE))