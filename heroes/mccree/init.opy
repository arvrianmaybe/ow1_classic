#!mainFile "../../dev_main.opy"

#!include "heroes/mccree/fan_hammer.opy"
#!include "heroes/mccree/flashbang.opy"
#!include "heroes/mccree/roll.opy"
#!include "heroes/mccree/deadeye.opy"

rule "[mccree/init.opy]: Initialize Cassidy":
    @Event eachPlayer
    @Hero mccree
    @Condition eventPlayer._call_init

    setCustomHp(MCCREE_HEALTH, 0, 0)
    setUltCost(MCCREE_ULT_COST)
    setUltCost(MCCREE_ULT_COST)

    removeSelfHealing()
    eventPlayer._call_init = false
