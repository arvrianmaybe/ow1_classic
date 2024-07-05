#!mainFile "../../dev_main.opy"

rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer._call_init

    setCustomHp(TRACER_HEALTH, 0, 0)
    setUltCost(TRACER_ULT_COST)
    removeSelfHealing()
    eventPlayer._call_init = false
