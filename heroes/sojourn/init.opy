#!mainFile "../../dev_main.opy"

#!include "heroes/sojourn/railgun.opy"

rule "[sojourn/init.opy]: Initialize Sojourn":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer._call_init

    setCustomHp(SOJOURN_HEALTH, 0, 0)
    setUltCost(SOJOURN_ULT_COST)

    removeSelfHealing()
    eventPlayer._call_init = false
